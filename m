Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56D4959DC
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 07:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348827AbiAUGWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 01:22:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343580AbiAUGWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 01:22:43 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE500C061574;
        Thu, 20 Jan 2022 22:22:42 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1nAnJm-00011t-WB; Fri, 21 Jan 2022 07:22:39 +0100
Message-ID: <fc2b7593-db8f-091c-67a0-ae5ffce71700@leemhuis.info>
Date:   Fri, 21 Jan 2022 07:22:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
Content-Language: en-BS
To:     James Turner <linuxkernel.foss@dmarc-none.turner.link>,
        Alex Deucher <alexander.deucher@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>
References: <87ee57c8fu.fsf@turner.link>
 <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
 <87a6ftk9qy.fsf@dmarc-none.turner.link> <87zgnp96a4.fsf@turner.link>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
In-Reply-To: <87zgnp96a4.fsf@turner.link>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1642746162;9796f0df;
X-HE-SMSGID: 1nAnJm-00011t-WB
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, this is your Linux kernel regression tracker speaking.

On 21.01.22 03:13, James Turner wrote:
> 
> I finished the bisection (log below). The issue was introduced in
> f9b7f3703ff9 ("drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)").

FWIW, that was:

> drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)
> They are global ACPI methods, so maybe the structures
> global in the driver. This simplified a number of things
> in the handling of these methods.
> 
> v2: reset the handle if verify interface fails (Lijo)
> v3: fix compilation when ACPI is not defined.
> 
> Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

In that case we need to get those two and the maintainers for the driver
involved by addressing them with this mail. And to make it easy for them
here is a link and a quote from the original report:

https://lore.kernel.org/all/87ee57c8fu.fsf@turner.link/

```
> Hi,
> 
> With newer kernels, starting with the v5.14 series, when using a MS
> Windows 10 guest VM with PCI passthrough of an AMD Radeon Pro WX 3200
> discrete GPU, the passed-through GPU will not run above 501 MHz, even
> when it is under 100% load and well below the temperature limit. As a
> result, GPU-intensive software (such as video games) runs unusably
> slowly in the VM.
> 
> In contrast, with older kernels, the passed-through GPU runs at up to
> 1295 MHz (the correct hardware limit), so GPU-intensive software runs at
> a reasonable speed in the VM.
> 
> I've confirmed that the issue exists with the following kernel versions:
> 
> - v5.16
> - v5.14
> - v5.14-rc1
> 
> The issue does not exist with the following kernels:
> 
> - v5.13
> - various packaged (non-vanilla) 5.10.* Arch Linux `linux-lts` kernels
> 
> So, the issue was introduced between v5.13 and v5.14-rc1. I'm willing to
> bisect the commit history to narrow it down further, if that would be
> helpful.
> 
> The configuration details and test results are provided below. In
> summary, for the kernels with this issue, the GPU core stays at a
> constant 0.8 V, the GPU core clock ranges from 214 MHz to 501 MHz, and
> the GPU memory stays at a constant 625 MHz, in the VM. For the correctly
> working kernels, the GPU core ranges from 0.85 V to 1.0 V, the GPU core
> clock ranges from 214 MHz to 1295 MHz, and the GPU memory stays at 1500
> MHz, in the VM.
> 
> Please let me know if additional information would be helpful.
> 
> Regards,
> James Turner
> 
> # Configuration Details
> 
> Hardware:
> 
> - Dell Precision 7540 laptop
> - CPU: Intel Core i7-9750H (x86-64)
> - Discrete GPU: AMD Radeon Pro WX 3200
> - The internal display is connected to the integrated GPU, and external
>   displays are connected to the discrete GPU.
> 
> Software:
> 
> - KVM host: Arch Linux
>   - self-built vanilla kernel (built using Arch Linux `PKGBUILD`
>     modified to use vanilla kernel sources from git.kernel.org)
>   - libvirt 1:7.10.0-2
>   - qemu 6.2.0-2
> 
> - KVM guest: Windows 10
>   - GPU driver: Radeon Pro Software Version 21.Q3 (Note that I also
>     experienced this issue with the 20.Q4 driver, using packaged
>     (non-vanilla) Arch Linux kernels on the host, before updating to the
>     21.Q3 driver.)
> 
> Kernel config:
> 
> - For v5.13, v5.14-rc1, and v5.14, I used
>   https://github.com/archlinux/svntogit-packages/blob/89c24952adbfa645d9e1a6f12c572929f7e4e3c7/trunk/config
>   (The build script ran `make olddefconfig` on that config file.)
> 
> - For v5.16, I used
>   https://github.com/archlinux/svntogit-packages/blob/94f84e1ad8a530e54aa34cadbaa76e8dcc439d10/trunk/config
>   (The build script ran `make olddefconfig` on that config file.)
> 
> I set up the VM with PCI passthrough according to the instructions at
> https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF
> 
> I'm passing through the following PCI devices to the VM, as listed by
> `lspci -D -nn`:
> 
>   0000:01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Lexa XT [Radeon PRO WX 3200] [1002:6981]
>   0000:01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Baffin HDMI/DP Audio [Radeon RX 550 640SP / RX 560/560X] [1002:aae0]
> 
> The host kernel command line includes the following relevant options:
> 
>   intel_iommu=on vfio-pci.ids=1002:6981,1002:aae0
> 
> to enable IOMMU and bind the `vfio-pci` driver to the PCI devices.
> 
> My `/etc/mkinitcpio.conf` includes the following line:
> 
>   MODULES=(vfio_pci vfio vfio_iommu_type1 vfio_virqfd i915 amdgpu)
> 
> to load `vfio-pci` before the graphics drivers. (Note that removing
> `i915 amdgpu` has no effect on this issue.)
> 
> I'm using libvirt to manage the VM. The relevant portions of the XML
> file are:
> 
>   <hostdev mode="subsystem" type="pci" managed="yes">
>     <source>
>       <address domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
>     </source>
>     <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
>   </hostdev>
>   <hostdev mode="subsystem" type="pci" managed="yes">
>     <source>
>       <address domain="0x0000" bus="0x01" slot="0x00" function="0x1"/>
>     </source>
>     <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
>   </hostdev>
> 
> # Test Results
> 
> For testing, I used the following procedure:
> 
> 1. Boot the host machine and log in.
> 
> 2. Run the following commands to gather information. For all the tests,
>    the output was identical.
> 
>    - `cat /proc/sys/kernel/tainted` printed:
> 
>      0
> 
>    - `hostnamectl | grep "Operating System"` printed:
> 
>      Operating System: Arch Linux
> 
>    - `lspci -nnk -d 1002:6981` printed
> 
>      01:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Lexa XT [Radeon PRO WX 3200] [1002:6981]
>      	Subsystem: Dell Device [1028:0926]
>      	Kernel driver in use: vfio-pci
>      	Kernel modules: amdgpu
> 
>    - `lspci -nnk -d 1002:aae0` printed
> 
>      01:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Baffin HDMI/DP Audio [Radeon RX 550 640SP / RX 560/560X] [1002:aae0]
>      	Subsystem: Dell Device [1028:0926]
>      	Kernel driver in use: vfio-pci
>      	Kernel modules: snd_hda_intel
> 
>    - `sudo dmesg | grep -i vfio` printed the kernel command line and the
>      following messages:
> 
>      VFIO - User Level meta-driver version: 0.3
>      vfio-pci 0000:01:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none
>      vfio_pci: add [1002:6981[ffffffff:ffffffff]] class 0x000000/00000000
>      vfio_pci: add [1002:aae0[ffffffff:ffffffff]] class 0x000000/00000000
>      vfio-pci 0000:01:00.0: vgaarb: changed VGA decodes: olddecodes=io+mem,decodes=io+mem:owns=none
> 
> 3. Start the Windows VM using libvirt and log in. Record sensor
>    information.
> 
> 4. Run a graphically-intensive video game to put the GPU under load.
>    Record sensor information.
> 
> 5. Stop the game. Record sensor information.
> 
> 6. Shut down the VM. Save the output of `sudo dmesg`.
> 
> I compared the `sudo dmesg` output for v5.13 and v5.14-rc1 and didn't
> see any relevant differences.
> 
> Note that the issue occurs only within the guest VM. When I'm not using
> a VM (after removing `vfio-pci.ids=1002:6981,1002:aae0` from the kernel
> command line so that the PCI devices are bound to their normal `amdgpu`
> and `snd_hda_intel` drivers instead of the `vfio-pci` driver), the GPU
> operates correctly on the host.
> 
> ## Linux v5.16 (issue present)
> 
> $ cat /proc/version
> Linux version 5.16.0-1 (linux@archlinux) (gcc (GCC) 11.1.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Sun, 16 Jan 2022 01:51:08 +0000
> 
> Before running the game:
> 
> - GPU core: 214.0 MHz, 0.800 V, 0.0% load, 53.0 degC
> - GPU memory: 625.0 MHz
> 
> While running the game:
> 
> - GPU core: 501.0 MHz, 0.800 V, 100.0% load, 54.0 degC
> - GPU memory: 625.0 MHz
> 
> After stopping the game:
> 
> - GPU core: 214.0 MHz, 0.800 V, 0.0% load, 51.0 degC
> - GPU memory: 625.0 MHz
> 
> ## Linux v5.14 (issue present)
> 
> $ cat /proc/version
> Linux version 5.14.0-1 (linux@archlinux) (gcc (GCC) 11.1.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Sun, 16 Jan 2022 03:19:35 +0000
> 
> Before running the game:
> 
> - GPU core: 214.0 MHz, 0.800 V, 0.0% load, 50.0 degC
> - GPU memory: 625.0 MHz
> 
> While running the game:
> 
> - GPU core: 501.0 MHz, 0.800 V, 100.0% load, 54.0 degC
> - GPU memory: 625.0 MHz
> 
> After stopping the game:
> 
> - GPU core: 214.0 MHz, 0.800 V, 0.0% load, 49.0 degC
> - GPU memory: 625.0 MHz
> 
> ## Linux v5.14-rc1 (issue present)
> 
> $ cat /proc/version
> Linux version 5.14.0-rc1-1 (linux@archlinux) (gcc (GCC) 11.1.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Sun, 16 Jan 2022 18:31:35 +0000
> 
> Before running the game:
> 
> - GPU core: 214.0 MHz, 0.800 V, 0.0% load, 50.0 degC
> - GPU memory: 625.0 MHz
> 
> While running the game:
> 
> - GPU core: 501.0 MHz, 0.800 V, 100.0% load, 54.0 degC
> - GPU memory: 625.0 MHz
> 
> After stopping the game:
> 
> - GPU core: 214.0 MHz, 0.800 V, 0.0% load, 49.0 degC
> - GPU memory: 625.0 MHz
> 
> ## Linux v5.13 (works correctly, issue not present)
> 
> $ cat /proc/version
> Linux version 5.13.0-1 (linux@archlinux) (gcc (GCC) 11.1.0, GNU ld (GNU Binutils) 2.36.1) #1 SMP PREEMPT Sun, 16 Jan 2022 02:39:18 +0000
> 
> Before running the game:
> 
> - GPU core: 214.0 MHz, 0.850 V, 0.0% load, 55.0 degC
> - GPU memory: 1500.0 MHz
> 
> While running the game:
> 
> - GPU core: 1295.0 MHz, 1.000 V, 100.0% load, 67.0 degC
> - GPU memory: 1500.0 MHz
> 
> After stopping the game:
> 
> - GPU core: 214.0 MHz, 0.850 V, 0.0% load, 52.0 degC
> - GPU memory: 1500.0 MHz

```

Ciao, Thorsten (wearing his 'Linux kernel regression tracker' hat)

P.S.: As a Linux kernel regression tracker I'm getting a lot of reports
on my table. I can only look briefly into most of them. Unfortunately
therefore I sometimes will get things wrong or miss something important.
I hope that's not the case here; if you think it is, don't hesitate to
tell me about it in a public reply, that's in everyone's interest.

BTW, I have no personal interest in this issue, which is tracked using
regzbot, my Linux kernel regression tracking bot
(https://linux-regtracking.leemhuis.info/regzbot/). I'm only posting
this mail to get things rolling again and hence don't need to be CC on
all further activities wrt to this regression.

#regzbot introduced f9b7f3703ff9
#regzbot title drm: amdgpu: Too-low frequency limit for AMD GPU
PCI-passed-through to Windows VM


> Would any additional information be helpful?
> 
> git bisect start
> # bad: [e73f0f0ee7541171d89f2e2491130c7771ba58d3] Linux 5.14-rc1
> git bisect bad e73f0f0ee7541171d89f2e2491130c7771ba58d3
> # good: [62fb9874f5da54fdb243003b386128037319b219] Linux 5.13
> git bisect good 62fb9874f5da54fdb243003b386128037319b219
> # bad: [e058a84bfddc42ba356a2316f2cf1141974625c9] Merge tag 'drm-next-2021-07-01' of git://anongit.freedesktop.org/drm/drm
> git bisect bad e058a84bfddc42ba356a2316f2cf1141974625c9
> # good: [a6eaf3850cb171c328a8b0db6d3c79286a1eba9d] Merge tag 'sched-urgent-2021-06-30' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good a6eaf3850cb171c328a8b0db6d3c79286a1eba9d
> # good: [007b312c6f294770de01fbc0643610145012d244] Merge tag 'mac80211-next-for-net-next-2021-06-25' of git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next
> git bisect good 007b312c6f294770de01fbc0643610145012d244
> # bad: [18703923a66aecf6f7ded0e16d22eb412ddae72f] drm/amdgpu: Fix incorrect register offsets for Sienna Cichlid
> git bisect bad 18703923a66aecf6f7ded0e16d22eb412ddae72f
> # good: [c99c4d0ca57c978dcc2a2f41ab8449684ea154cc] Merge tag 'amd-drm-next-5.14-2021-05-19' of https://gitlab.freedesktop.org/agd5f/linux into drm-next
> git bisect good c99c4d0ca57c978dcc2a2f41ab8449684ea154cc
> # good: [43ed3c6c786d996a264fcde68dbb36df6f03b965] Merge tag 'drm-misc-next-2021-06-01' of git://anongit.freedesktop.org/drm/drm-misc into drm-next
> git bisect good 43ed3c6c786d996a264fcde68dbb36df6f03b965
> # bad: [050cd3d616d96c3a04f4877842a391c0a4fdcc7a] drm/amd/display: Add support for SURFACE_PIXEL_FORMAT_GRPH_ABGR16161616.
> git bisect bad 050cd3d616d96c3a04f4877842a391c0a4fdcc7a
> # good: [f43ae2d1806c2b8a0934cb4acddd3cf3750d10f8] drm/amdgpu: Fix inconsistent indenting
> git bisect good f43ae2d1806c2b8a0934cb4acddd3cf3750d10f8
> # good: [6566cae7aef30da8833f1fa0eb854baf33b96676] drm/amd/display: fix odm scaling
> git bisect good 6566cae7aef30da8833f1fa0eb854baf33b96676
> # good: [5ac1dd89df549648b67f4d5e3a01b2d653914c55] drm/amd/display/dc/dce/dmub_outbox: Convert over to kernel-doc
> git bisect good 5ac1dd89df549648b67f4d5e3a01b2d653914c55
> # good: [a76eb7d30f700e5bdecc72d88d2226d137b11f74] drm/amd/display/dc/dce110/dce110_hw_sequencer: Include header containing our prototypes
> git bisect good a76eb7d30f700e5bdecc72d88d2226d137b11f74
> # good: [dd1d82c04e111b5a864638ede8965db2fe6d8653] drm/amdgpu/swsmu/aldebaran: fix check in is_dpm_running
> git bisect good dd1d82c04e111b5a864638ede8965db2fe6d8653
> # bad: [f9b7f3703ff97768a8dfabd42bdb107681f1da22] drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)
> git bisect bad f9b7f3703ff97768a8dfabd42bdb107681f1da22
> # good: [f1688bd69ec4b07eda1657ff953daebce7cfabf6] drm/amd/amdgpu:save psp ring wptr to avoid attack
> git bisect good f1688bd69ec4b07eda1657ff953daebce7cfabf6
> # first bad commit: [f9b7f3703ff97768a8dfabd42bdb107681f1da22] drm/amdgpu/acpi: make ATPX/ATCS structures global (v2)
> 
> James
> 
