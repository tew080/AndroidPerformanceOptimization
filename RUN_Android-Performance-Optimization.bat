::
::Github: tew080
::Version V1
::
@echo off
setlocal enabledelayedexpansion
echo.
echo ========================================
echo +++ Android Performance Optimization Funtion +++
echo.
echo              * Q = Exit or Back *
echo         * Reboot to Uninstall PropSet *
echo ========================================
echo 1.Set Max refresh rate           2.Set device RAM size
echo 3.Set Use Skia render Engine     4.Idle maintenance
echo 5.Storage TRIM                   6.Background Dex Optimization
echo 7.(AOT) Compilation All App      8.(AOT) ReCompilation All App
echo 9.Disabling V-Sync               10.Optimizing Touch Response
echo 11.Disabling Anti-Aliasing       12.GPU and Hardware Acceleration
echo 13.Auto Default Optimization     14.Refresh Rate Optimization
echo 15.Fix Bug Render Engine in App  16.Bloatware [Uninstall,Disable,Reinstall]
echo.

:menu

REM
set "aot_re_compile=P"
set "aot_compile_mode=P"
set "refresh_rate=120"
set "ram=8"
set "Device=N"
set "vulkan=N"
set "menu=Q"
set "touch_timer_ms=250"
set "skia_renderer=2"
set "soc=N"
set "Tuning=N"
set "Bloatware=Q"
set "Packare_Name=Q"

set /p menu="Enter Num: "

if "%menu%"=="1" (
    :EnterRefresh
    set /p refresh_rate="Enter desired refresh rate (60, 90, 120, 144, 165): "
    if /i "!refresh_rate!"=="Q" (
        goto menu
    )
    if not "!refresh_rate!"=="60" if not "!refresh_rate!"=="90" if not "!refresh_rate!"=="120" if not "!refresh_rate!"=="144" if not "!refresh_rate!"=="165"  (
        echo [Error] Allowed values: 60, 90, 120, 144, 165
        goto EnterRefresh
    )
    :Devices
    set /p Device="Device Vivo/Iqoo [Y/N]: "
    if /i "!Device!"=="Y"  (
        adb shell settings put global vivo_screen_refresh_rate_mode !refresh_rate!
    ) else if /i "!Device!"=="N" (
        echo off
    ) else if /i "!Device!"=="Q" (
        goto menu
    ) else (
        echo [Error] Enter Y or N Only!
        goto Devices
    )
    ::from rog phone 6d
    if "!refresh_rate!"=="60" (
        adb shell setprop debug.sf.late.sf.duration 15600000
        adb shell setprop debug.sf.late.app.duration 16600000
        adb shell setprop debug.sf.early.sf.duration 15600000
        adb shell setprop debug.sf.early.app.duration 16600000
        adb shell setprop debug.sf.earlyGl.sf.duration 15600000
        adb shell setprop debug.sf.earlyGl.app.duration 16600000
    ) else if "!refresh_rate!"=="90" (
        adb shell setprop debug.sf.late.sf.duration 13100000
        adb shell setprop debug.sf.late.app.duration 19200000
        adb shell setprop debug.sf.early.sf.duration 13100000
        adb shell setprop debug.sf.early.app.duration 19200000
        adb shell setprop debug.sf.earlyGl.sf.duration 13100000
        adb shell setprop debug.sf.earlyGl.app.duration 19200000
    ) else if "!refresh_rate!"=="120" (
        adb shell setprop debug.sf.late.sf.duration 8333333
        adb shell setprop debug.sf.late.app.duration 8333333
        adb shell setprop debug.sf.early.sf.duration 8333333
        adb shell setprop debug.sf.early.app.duration 8333333
        adb shell setprop debug.sf.earlyGl.sf.duration 8333333
        adb shell setprop debug.sf.earlyGl.app.duration 8333333
    ) else if "!refresh_rate!"=="144" (
        adb shell setprop debug.sf.late.sf.duration 6944443
        adb shell setprop debug.sf.late.app.duration 6944443
        adb shell setprop debug.sf.early.sf.duration 6944443
        adb shell setprop debug.sf.early.app.duration 6944443
        adb shell setprop debug.sf.earlyGl.sf.duration 6944443
        adb shell setprop debug.sf.earlyGl.app.duration 6944443
    ) else if "!refresh_rate!"=="165" (
        adb shell setprop debug.sf.late.sf.duration 6060606
        adb shell setprop debug.sf.late.app.duration 6060606
        adb shell setprop debug.sf.early.sf.duration 6060606
        adb shell setprop debug.sf.early.app.duration 6060606
        adb shell setprop debug.sf.earlyGl.sf.duration 6060606
        adb shell setprop debug.sf.earlyGl.app.duration 6060606
    )
    :: end from rog phone 6d
    adb shell settings put global peak_refresh_rate !refresh_rate!.0
    adb shell settings put global min_refresh_rate !refresh_rate!.0
    adb shell settings put global user_refresh_rate !refresh_rate!.0
    adb shell settings put system peak_refresh_rate !refresh_rate!.0
    adb shell settings put system min_refresh_rate !refresh_rate!.0
    adb shell settings put system user_refresh_rate !refresh_rate!.0
    adb shell setprop debug.sf.frame_rate_multiple_threshold !refresh_rate!
    adb shell setprop debug.sf_frame_rate_multiple_fences !refresh_rate!
    adb shell setprop debug.sf.game_default_frame_rate_override !refresh_rate!
    echo Set Max refresh rate to !refresh_rate! Hz [OK]
)

if "%menu%"=="2" (
    :EnterRAM
    set /p ram="Enter device RAM size (2/3/4/6/8/12/16/24): "
    if /i "!ram!"=="Q" (
        goto menu
    )
    if not "!ram!"=="2" if not "!ram!"=="3" if not "!ram!"=="4" if not "!ram!"=="6" if not "!ram!"=="8" if not "!ram!"=="12" if not "!ram!"=="16" if not "!ram!"=="24" (
        echo [Error] Allowed values: 2, 3, 4, 6, 8, 12, 16
        goto EnterRAM
    )
    if "!ram!"=="2" (
        adb shell setprop debug.hwui.text_small_cache_width 512
        adb shell setprop debug.hwui.text_small_cache_height 512
        adb shell setprop debug.hwui.text_large_cache_width 1024
        adb shell setprop debug.hwui.text_large_cache_height 512
        adb shell setprop debug.hwui.layer_cache_size 24
        adb shell setprop debug.hwui.path_cache_size 16
        adb shell setprop debug.hwui.texture_cache_size 32
        adb shell setprop debug.hwui.r_buffer_cache_size 4
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 2
        adb shell setprop debug.hwui.texture_cache_flushrate 0.3
    ) else if "!ram!"=="3" (
        adb shell setprop debug.hwui.text_small_cache_width 512
        adb shell setprop debug.hwui.text_small_cache_height 512
        adb shell setprop debug.hwui.text_large_cache_width 1024
        adb shell setprop debug.hwui.text_large_cache_height 512
        adb shell setprop debug.hwui.layer_cache_size 32
        adb shell setprop debug.hwui.path_cache_size 16
        adb shell setprop debug.hwui.texture_cache_size 48
        adb shell setprop debug.hwui.r_buffer_cache_size 4
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 3
        adb shell setprop debug.hwui.texture_cache_flushrate 0.35
    ) else if "!ram!"=="4" (
        adb shell setprop debug.hwui.text_small_cache_width 1024
        adb shell setprop debug.hwui.text_small_cache_height 512
        adb shell setprop debug.hwui.text_large_cache_width 1024
        adb shell setprop debug.hwui.text_large_cache_height 1024
        adb shell setprop debug.hwui.layer_cache_size 48
        adb shell setprop debug.hwui.path_cache_size 24
        adb shell setprop debug.hwui.texture_cache_size 64
        adb shell setprop debug.hwui.r_buffer_cache_size 6
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 4
        adb shell setprop debug.hwui.texture_cache_flushrate 0.4
    ) else if "!ram!"=="6" (
        adb shell setprop debug.hwui.text_small_cache_width 1024
        adb shell setprop debug.hwui.text_small_cache_height 512
        adb shell setprop debug.hwui.text_large_cache_width 2048
        adb shell setprop debug.hwui.text_large_cache_height 1024
        adb shell setprop debug.hwui.layer_cache_size 64
        adb shell setprop debug.hwui.path_cache_size 32
        adb shell setprop debug.hwui.texture_cache_size 72
        adb shell setprop debug.hwui.r_buffer_cache_size 6
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 5
        adb shell setprop debug.hwui.texture_cache_flushrate 0.4
    ) else if "!ram!"=="8" (
        adb shell setprop debug.hwui.text_small_cache_width 1024
        adb shell setprop debug.hwui.text_small_cache_height 1024
        adb shell setprop debug.hwui.text_large_cache_width 2048
        adb shell setprop debug.hwui.text_large_cache_height 1024
        adb shell setprop debug.hwui.layer_cache_size 96
        adb shell setprop debug.hwui.path_cache_size 48
        adb shell setprop debug.hwui.texture_cache_size 96
        adb shell setprop debug.hwui.r_buffer_cache_size 8
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 6
        adb shell setprop debug.hwui.texture_cache_flushrate 0.45
    ) else if "!ram!"=="12" (
        adb shell setprop debug.hwui.text_small_cache_width 1024
        adb shell setprop debug.hwui.text_small_cache_height 1024
        adb shell setprop debug.hwui.text_large_cache_width 2048
        adb shell setprop debug.hwui.text_large_cache_height 1024
        adb shell setprop debug.hwui.layer_cache_size 128
        adb shell setprop debug.hwui.path_cache_size 64
        adb shell setprop debug.hwui.texture_cache_size 128
        adb shell setprop debug.hwui.r_buffer_cache_size 8
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 8
        adb shell setprop debug.hwui.texture_cache_flushrate 0.5
    ) else if "!ram!"=="16" (
        adb shell setprop debug.hwui.text_small_cache_width 2048
        adb shell setprop debug.hwui.text_small_cache_height 1024
        adb shell setprop debug.hwui.text_large_cache_width 2048
        adb shell setprop debug.hwui.text_large_cache_height 2048
        adb shell setprop debug.hwui.layer_cache_size 160
        adb shell setprop debug.hwui.path_cache_size 96
        adb shell setprop debug.hwui.texture_cache_size 160
        adb shell setprop debug.hwui.r_buffer_cache_size 8
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 10
        adb shell setprop debug.hwui.texture_cache_flushrate 0.5
    ) else if "!ram!"=="24" (
        adb shell setprop debug.hwui.text_small_cache_width 2048
        adb shell setprop debug.hwui.text_small_cache_height 1024
        adb shell setprop debug.hwui.text_large_cache_width 2048
        adb shell setprop debug.hwui.text_large_cache_height 2048
        adb shell setprop debug.hwui.layer_cache_size 192
        adb shell setprop debug.hwui.path_cache_size 128
        adb shell setprop debug.hwui.texture_cache_size 192
        adb shell setprop debug.hwui.r_buffer_cache_size 8
        adb shell setprop debug.hwui.gradient_cache_size 1
        adb shell setprop debug.hwui.drop_shadow_cache_size 12
        adb shell setprop debug.hwui.texture_cache_flushrate 0.5
    )
    echo Optimizing HWUI Cache for !ram! GB RAM [OK]
)

if "%menu%"=="9" (
    adb shell setprop debug.egl.swapinterval 0
    adb shell setprop debug.gr.swapinterval 0
    adb shell setprop debug.gpurend.vsync false
    adb shell setprop debug.hwui.disable_vsync true
    echo Disabling V-Sync for maximum FPS [OK]
)

if "%menu%"=="10" (
    set /p touch_timer_ms="Custom Timer Boost ms (Default = 250ms): "
    if /i "!touch_timer_ms!"=="Q" (
        goto menu
    )
    adb shell setprop debug.sf.touch_latency_opt 1
    adb shell setprop debug.sf.set_touch_timer_ms !touch_timer_ms!
    echo Optimizing Touch Response *-Touch Timer !touch_timer_ms! Ms-* [OK]
)

if "%menu%"=="11" (
    adb shell setprop debug.egl.force_ssaa false
    adb shell setprop debug.egl.force_smaa false
    adb shell setprop debug.egl.force_taa false
    adb shell setprop debug.egl.force_msaa false
    adb shell setprop debug.egl.force_fxaa false
    echo Disabling Anti-Aliasing for FPS [OK]
)

if "%menu%"=="12" (
    :soc
    set /p soc="SOC Snapdragon [Y/N]: "
    if /i "!soc!"=="Y"  (
        adb shell setprop debug.gralloc.enable_fb_ubwc 1
    ) else if /i "!soc!"=="N" (
        echo off
    ) else if /i "!soc!"=="Q" (
        goto menu
    ) else (
        echo [Error] Enter Y or N Only!
        goto soc
    )
    :Tuning
    set /p Tuning="Enable Performance Tuning [Y/N]: "
    if /i "!Tuning!"=="Y"  (
        adb shell setprop debug.performance.tuning 1
    ) else if /i "!Tuning!"=="N" (
        echo off
    ) else if /i "!Tuning!"=="Q" (
        goto menu
    ) else (
        echo [Error] Enter Y or N Only!
        goto Tuning
    )
    adb shell setprop debug.sf.hw 1
    adb shell setprop debug.video.accelerate.hw 1
    echo GPU and Hardware Acceleration [OK]
)

if "%menu%"=="14" (
    adb shell setprop debug.graphics.game_default_frame_rate.disabled 1
    adb shell setprop debug.hwui.fps_divisor -1
    adb shell setprop debug.hwui.skia_atrace_enabled false
    adb shell setprop debug.hwui.skia_tracing_enabled false
    adb shell setprop debug.hwui.disable_draw_defer true
    adb shell setprop debug.hwui.disable_draw_reorder false
    adb shell setprop debug.hwui.render_ahead 2
    adb shell setprop debug.hwui.use_hint_manager true
    adb shell setprop debug.hwui.use_gpu_pixel_buffers true
    adb shell setprop debug.hwui.skip_empty_damage true
    adb shell setprop debug.hwui.use_buffer_age true
    adb shell setprop debug.hwui.use_partial_updates false
    adb shell setprop debug.hwui.render_dirty_regions false
    adb shell setprop debug.hwui.early_z 1
    adb shell setprop debug.hwui.render_thread_priority 1
    adb shell setprop debug.hwui.skip_eglmanager_telemetry true
    adb shell setprop debug.hwc.asyncdisp 1
    adb shell setprop debug.hwui.trace_gpu_resources false
    adb shell setprop debug.gr.numframebuffers 3
    adb shell setprop debug.sf.vsp_trace false
    adb shell setprop debug.sf.latch_unsignaled 1
    adb shell setprop debug.sf.disable_backpressure 1
    adb shell setprop debug.sf.max_frame_buffer_acquired_buffers 4
    echo Refresh Rate Optimization [OK]
)

if "%menu%"=="3" (
    adb shell cmd device_config put systemui enable_hw_accelerated_canvas true
    adb shell settings put global render_shadows_in_compositor 1
    :skia_renderer
    set /p skia_renderer="Skiavk[1] or Skiagl[2] [1/2]: "
    if /i "!skia_renderer!"=="Q" (
        goto menu
    )
    if not "!skia_renderer!"=="1" if not "!skia_renderer!"=="2" (
        echo [Error] Allowed values: 1 or 2
        goto skia_renderer
    )
    if "!skia_renderer!"=="1" (
        adb shell setprop debug.hwui.renderer skiavk
        adb shell setprop debug.hwui.default_renderer skiavk
        adb shell setprop debug.renderengine.backend skiavkthreaded
        adb shell setprop debug.hwui.renderengine.backend skiavkthreaded
        adb shell setprop debug.hwui.use_vulkan true
        adb shell setprop debug.hwui.force_vulkan true
        adb shell setprop debug.hwui.disable_opengl true
        adb shell setprop debug.skia.vulkan_as_default true
        adb shell setprop debug.sf.enable_hwc_vulkan true
        adb shell setprop debug.renderthread.skia.reduceopstasksplitting true
        adb shell setprop debug.renderengine.capture_skia_ms 0
        adb shell setprop debug.renderengine.skia_atrace_enabled false
        adb shell setprop debug.hwui.skia_use_perfetto_track_events false
        adb shell setprop debug.hwui.skia_tracing_enabled false
        echo Setting SkiaVulkan Renderer [OK]
    ) else if "!skia_renderer!"=="2" (
        adb shell setprop debug.hwui.renderer skiagl
        adb shell setprop debug.hwui.default_renderer skiagl
        adb shell setprop debug.renderengine.backend skiaglthreaded
        adb shell setprop debug.hwui.renderengine.backend skiaglthreaded
        adb shell setprop debug.hwui.use_vulkan false
        adb shell setprop debug.hwui.force_vulkan false
        adb shell setprop debug.hwui.disable_opengl false
        adb shell setprop debug.skia.vulkan_as_default false
        adb shell setprop debug.sf.enable_hwc_vulkan false
        adb shell setprop debug.renderthread.skia.reduceopstasksplitting true
        adb shell setprop debug.renderengine.capture_skia_ms 0
        adb shell setprop debug.renderengine.skia_atrace_enabled false
        adb shell setprop debug.hwui.skia_use_perfetto_track_events false
        adb shell setprop debug.hwui.skia_tracing_enabled false
        echo Setting SkiaGL Renderer [OK]
    )
    echo.
    echo Reloading apps to use Renderer Option [!skia_renderer!]...
    for /f "tokens=2 delims=:" %%a in ('adb shell pm list packages ^| findstr /v ia.mo') do (
        adb shell am force-stop %%a
    )
    timeout /t 1 >nul
    echo Forcing crash: System UI
    adb shell am crash com.android.systemui
    echo [OK] Reloading apps to use Renderer Option [!skia_renderer!] Done
)

if "%menu%"=="15" (
        set /p Packare_Name="Packare Name [Ex: com.instagram.android]: "
        if /i "!Packare_Name!"=="Q" (
            goto menu
        )
        adb shell setprop debug.hwui.renderer skiagl
        adb shell setprop debug.hwui.default_renderer skiagl
        adb shell setprop debug.renderengine.backend skiaglthreaded
        adb shell setprop debug.hwui.renderengine.backend skiaglthreaded
        adb shell setprop debug.hwui.use_vulkan false
        adb shell setprop debug.hwui.force_vulkan false
        adb shell setprop debug.hwui.disable_opengl false
        adb shell setprop debug.skia.vulkan_as_default false
        adb shell setprop debug.sf.enable_hwc_vulkan false
        adb shell am force-stop !Packare_Name!
        echo Fix Bug Render Engine in [!Packare_Name!] [OK]
)

if /i "%menu%"=="4" (
    echo Idle maintenance....
    adb shell sm idle-maint run
    echo [OK] Idle maintenance
)

if /i "%menu%"=="5" (
    echo Storage TRIM....
    adb shell sm fstrim
    echo [OK] Storage TRIM
)

if "%menu%"=="6" (
    adb shell cmd device_config put package_native_code optimizable_apps true
    echo Background Dex Optimization....
    adb shell cmd package bg-dexopt-job
    echo [OK] Background Dex Optimization
)

if "%menu%"=="7" (
    adb shell cmd device_config put package_native_code optimizable_apps true
    :aot_compile_mode
    set /p aot_compile_mode="AOT FULL Or AOT Profile (Default = AOT Profile) [F/P]: "
    if /i "!aot_compile_mode!"=="Q" (
        goto menu
    )
    if /i "!aot_compile_mode!"=="F" (
        echo AOT FULL Compilation All App....
        adb shell cmd package compile -m speed -a
        adb shell cmd package compile -m speed -a --secondary-dex
	adb shell pm trim-caches 999999999999
        echo [OK] AOT FULL Compilation All App
    ) else if /i "!aot_compile_mode!"=="P" (
        echo AOT Profile Compilation All App....
        adb shell cmd package compile -m speed-profile -a
        adb shell cmd package compile -m speed-profile -a --secondary-dex
	adb shell pm trim-caches 999999999999
        echo [OK] AOT Profile Compilation All App
    ) else (
        echo [Error] Enter F or P Only!
        goto aot_compile_mode
    )
)

if "%menu%"=="16" (
    :Debloat
    set /p Bloatware="Uninstall = U ,Disable = D ,Reinstall = R : "
    if /i "!Bloatware!"=="Q" (
            goto menu
    )
    if /i "!Bloatware!"=="U" (
        :uninstall
        set /p Packare_Name="Packare Name [Ex: com.instagram.android]: "
        adb shell pm uninstall -k --user 0 !Packare_Name!
        echo Uninstall [!Packare_Name!] [OK]
        if /i "!Packare_Name!"=="Q" (
            goto Debloat
        )
        goto uninstall
    ) else if /i "!Bloatware!"=="D" (
        :disable
        set /p Packare_Name="Packare Name [Ex: com.instagram.android]: "
        adb shell pm disable-user --user 0 !Packare_Name!
        echo Disable [!Packare_Name!] [OK]
        if /i "!Packare_Name!"=="Q" (
            goto debloat
        )
        goto disable
    ) else if /i "!Bloatware!"=="R" (
        :reinstall
        set /p Packare_Name="Packare Name [Ex: com.instagram.android]: "
        adb shell pm install-existing !Packare_Name!
        echo Reinstall [!Packare_Name!] [OK]
        if /i "!Packare_Name!"=="Q" (
            goto debloat
        )
        goto reinstall
    ) else (
        goto Debloat
    )
)

if "%menu%"=="8" (
    adb shell cmd device_config put package_native_code optimizable_apps true
    :aot_re_compile_mode
    set /p aot_re_compile_mode="AOT *Re* Compilation FULL Or AOT Profile (Default = AOT Profile) [F/P]: "
    if /i "!aot_re_compile_mode!"=="Q" (
        goto menu
    )
    if /i "!aot_re_compile_mode!"=="F" (
        echo AOT FULL Compilation All App....
        adb shell cmd package compile -m speed -f -a
        adb shell cmd package compile -m speed -f -a --secondary-dex
	adb shell pm trim-caches 999999999999
        echo [OK] AOT FULL Compilation All App
    ) else if /i "!aot_re_compile_mode!"=="P" (
        echo AOT Profile Compilation All App....
        adb shell cmd package compile -m speed-profile -f -a
        adb shell cmd package compile -m speed-profile -f -a --secondary-dex
	adb shell pm trim-caches 999999999999
        echo [OK] AOT Profile Compilation All App
    ) else (
        echo [Error] Enter F or P Only!
        goto aot_re_compile_mode
    )
)

if "%menu%"=="13" (
    adb shell setprop debug.graphics.game_default_frame_rate.disabled 1
    adb shell setprop debug.hwui.fps_divisor -1
    adb shell setprop debug.hwui.skia_atrace_enabled false
    adb shell setprop debug.hwui.skia_tracing_enabled false
    adb shell setprop debug.hwui.disable_draw_defer true
    adb shell setprop debug.hwui.disable_draw_reorder false
    adb shell setprop debug.hwui.render_ahead 2
    adb shell setprop debug.hwui.use_hint_manager true
    adb shell setprop debug.hwui.use_gpu_pixel_buffers true
    adb shell setprop debug.hwui.skip_empty_damage true
    adb shell setprop debug.hwui.use_buffer_age true
    adb shell setprop debug.hwui.use_partial_updates false
    adb shell setprop debug.hwui.render_dirty_regions false
    adb shell setprop debug.hwui.early_z 1
    adb shell setprop debug.hwui.render_thread_priority 1
    adb shell setprop debug.hwui.skip_eglmanager_telemetry true
    adb shell setprop debug.hwc.asyncdisp 1
    adb shell setprop debug.hwui.trace_gpu_resources false
    adb shell setprop debug.gr.numframebuffers 3
    adb shell setprop debug.sf.vsp_trace false
    echo Refresh Rate Optimization [OK]
    timeout /t 1 >nul
    adb shell setprop debug.egl.swapinterval 0
    adb shell setprop debug.gr.swapinterval 0
    adb shell setprop debug.gpurend.vsync false
    adb shell setprop debug.hwui.disable_vsync true
    echo Disabling V-Sync for maximum FPS [OK]
    timeout /t 1 >nul
    adb shell setprop debug.sf.touch_latency_opt 1
    adb shell setprop debug.sf.set_touch_timer_ms !touch_timer_ms!
    adb shell setprop debug.sf.latch_unsignaled 1
    adb shell setprop debug.sf.disable_backpressure 1
    adb shell setprop debug.sf.max_frame_buffer_acquired_buffers 4
    echo Optimizing Touch Response *-Touch Timer !touch_timer_ms! Ms-* [OK]
    timeout /t 1 >nul
    adb shell setprop debug.egl.force_ssaa false
    adb shell setprop debug.egl.force_smaa false
    adb shell setprop debug.egl.force_taa false
    adb shell setprop debug.egl.force_msaa false
    adb shell setprop debug.egl.force_fxaa false
    echo Disabling Anti-Aliasing for FPS [OK]
    timeout /t 1 >nul
    adb shell setprop debug.sf.hw 1
    adb shell setprop debug.video.accelerate.hw 1
    adb shell setprop debug.gralloc.enable_fb_ubwc 1
    echo GPU and Hardware Acceleration [OK]
    echo.
    adb shell cmd device_config put package_native_code optimizable_apps true
    timeout /t 1 >nul
    echo Idle maintenance....
    adb shell sm idle-maint run
    echo [OK] Idle maintenance
    timeout /t 1 >nul
    echo Storage TRIM....
    adb shell sm fstrim
    echo [OK] Storage TRIM
    timeout /t 1 >nul
    echo Background Dex Optimization....
    adb shell cmd package bg-dexopt-job
    echo [OK] Background Dex Optimization
    timeout /t 1 >nul
    echo AOT Profile Compilation All App....
    adb shell cmd package compile -m speed-profile -f -a
    adb shell cmd package compile -m speed-profile -f -a --secondary-dex
    adb shell pm trim-caches 999999999999
    echo [OK] AOT Profile Compilation All App
    echo.
    echo ========================================
    echo +++ Optimization Done +++
    echo ========================================
)

if /i "%menu%"=="Q" (
    exit
)

goto menu
