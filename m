Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A372490490
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 10:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233632AbiAQJD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 04:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbiAQJDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 04:03:55 -0500
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:8234::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52360C061574;
        Mon, 17 Jan 2022 01:03:55 -0800 (PST)
Received: from ip4d173d02.dynamic.kabel-deutschland.de ([77.23.61.2] helo=[192.168.66.200]); authenticated
        by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        id 1n9Nvc-0005vo-I4; Mon, 17 Jan 2022 10:03:52 +0100
Message-ID: <acd2fd5e-d622-948c-82ef-629a8030c9d8@leemhuis.info>
Date:   Mon, 17 Jan 2022 10:03:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-BS
To:     "James D. Turner" <linuxkernel.foss@dmarc-none.turner.link>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, regressions@lists.linux.dev,
        linux-kernel@vger.kernel.org
References: <87ee57c8fu.fsf@turner.link>
From:   Thorsten Leemhuis <regressions@leemhuis.info>
Subject: Re: [REGRESSION] Too-low frequency limit for AMD GPU
 PCI-passed-through to Windows VM
In-Reply-To: <87ee57c8fu.fsf@turner.link>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1642410235;881c5ab1;
X-HE-SMSGID: 1n9Nvc-0005vo-I4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[TLDR: I'm adding this regression to regzbot, the Linux kernel
regression tracking bot; most text you find below is compiled from a few
templates paragraphs some of you might have seen already.]

Hi, this is your Linux kernel regression tracker speaking.


On 17.01.22 03:12, James D. Turner wrote:
> 
> With newer kernels, starting with the v5.14 series, when using a MS
> Windows 10 guest VM with PCI passthrough of an AMD Radeon Pro WX 3200
> discrete GPU, the passed-through GPU will not run above 501 MHz, even
> when it is under 100% load and well below the temperature limit. As a
> result, GPU-intensive software (such as video games) runs unusably
> slowly in the VM.

Thanks for the report. Greg already asked for a bisection, which would
help a lot here.

To be sure this issue doesn't fall through the cracks unnoticed, I'm
adding it to regzbot, my Linux kernel regression tracking bot:

#regzbot ^introduced v5.13..v5.14-rc1
#regzbot ignore-activity

Reminder: when fixing the issue, please add a 'Link:' tag with the URL
to the report (the parent of this mail) using the kernel.org redirector,
as explained in 'Documentation/process/submitting-patches.rst'. Regzbot
then will automatically mark the regression as resolved once the fix
lands in the appropriate tree. For more details about regzbot see footer.

Sending this to everyone that got the initial report, to make all aware
of the tracking. I also hope that messages like this motivate people to
directly get at least the regression mailing list and ideally even
regzbot involved when dealing with regressions, as messages like this
wouldn't be needed then.

Don't worry, I'll send further messages wrt to this regression just to
the lists (with a tag in the subject so people can filter them away), as
long as they are intended just for regzbot. With a bit of luck no such
messages will be needed anyway.

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
> 
> 
---
Additional information about regzbot:

If you want to know more about regzbot, check out its web-interface, the
getting start guide, and/or the references documentation:

https://linux-regtracking.leemhuis.info/regzbot/
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/getting_started.md
https://gitlab.com/knurd42/regzbot/-/blob/main/docs/reference.md

The last two documents will explain how you can interact with regzbot
yourself if your want to.

Hint for reporters: when reporting a regression it's in your interest to
tell #regzbot about it in the report, as that will ensure the regression
gets on the radar of regzbot and the regression tracker. That's in your
interest, as they will make sure the report won't fall through the
cracks unnoticed.

Hint for developers: you normally don't need to care about regzbot once
it's involved. Fix the issue as you normally would, just remember to
include a 'Link:' tag to the report in the commit message, as explained
in Documentation/process/submitting-patches.rst
That aspect was recently was made more explicit in commit 1f57bd42b77c:
https://git.kernel.org/linus/1f57bd42b77c
