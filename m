Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B432132B577
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356211AbhCCHRY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:17:24 -0500
Received: from foss.arm.com ([217.140.110.172]:57360 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235463AbhCBSX7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:23:59 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E946F31B;
        Tue,  2 Mar 2021 09:56:46 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9E923F766;
        Tue,  2 Mar 2021 09:56:45 -0800 (PST)
Subject: Re: [PATCH kvmtool v2 00/22] Unify I/O port and MMIO trap handling
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <fabb6032-6ac2-f418-c5e6-12cd7b4cbdc5@arm.com>
Date:   Tue, 2 Mar 2021 17:57:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

I've started to review this iteration and I've come across this error when trying
to apply the patches:

$ git am --reject
patches/unify-ioport-and-mmio/v2/Unify-I-O-port-and-MMIO-trap-handling.patch
Applying: ioport: Remove ioport__setup_arch()
Checking patch arm/ioport.c...
Checking patch include/kvm/ioport.h...
Checking patch ioport.c...
Checking patch mips/kvm.c...
Checking patch powerpc/ioport.c...
Checking patch x86/ioport.c...
Applied patch arm/ioport.c cleanly.
Applied patch include/kvm/ioport.h cleanly.
Applied patch ioport.c cleanly.
Applied patch mips/kvm.c cleanly.
Applied patch powerpc/ioport.c cleanly.
Applied patch x86/ioport.c cleanly.
Applying: hw/serial: Use device abstraction for FDT generator function
Checking patch hw/serial.c...
Checking patch include/kvm/kvm.h...
Applied patch hw/serial.c cleanly.
Applied patch include/kvm/kvm.h cleanly.
Applying: ioport: Retire .generate_fdt_node functionality
Checking patch include/kvm/ioport.h...
Checking patch ioport.c...
Applied patch include/kvm/ioport.h cleanly.
Applied patch ioport.c cleanly.
Applying: mmio: Extend handling to include ioport emulation
Checking patch include/kvm/kvm.h...
Checking patch ioport.c...
Checking patch mmio.c...
Applied patch include/kvm/kvm.h cleanly.
Applied patch ioport.c cleanly.
Applied patch mmio.c cleanly.
Applying: hw/i8042: Clean up data types
Checking patch hw/i8042.c...
Applied patch hw/i8042.c cleanly.
Applying: hw/i8042: Refactor trap handler
Checking patch hw/i8042.c...
Applied patch hw/i8042.c cleanly.
Applying: hw/i8042: Switch to new trap handlers
Checking patch hw/i8042.c...
error: while searching for:
        ioport__write8(data, value);
}

/*
 * Called when the OS has written to one of the keyboard's ports (0x60 or 0x64)
 */
static bool kbd_in(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void
*data, int size)
{
    kbd_io(vcpu, port, data, size, false, NULL);

    return true;
}

static bool kbd_out(struct ioport *ioport, struct kvm_cpu *vcpu, u16 port, void
*data, int size)
{
    kbd_io(vcpu, port, data, size, true, NULL);

    return true;
}

static struct ioport_operations kbd_ops = {
    .io_in        = kbd_in,
    .io_out        = kbd_out,
};

int kbd__init(struct kvm *kvm)
{
    int r;

    kbd_reset();
    state.kvm = kvm;
    r = ioport__register(kvm, I8042_DATA_REG, &kbd_ops, 2, NULL);
    if (r < 0)
        return r;
    r = ioport__register(kvm, I8042_COMMAND_REG, &kbd_ops, 2, NULL);
    if (r < 0) {
        ioport__unregister(kvm, I8042_DATA_REG);
        return r;
    }


error: patch failed: hw/i8042.c:325
Checking patch include/kvm/i8042.h...
Applying patch hw/i8042.c with 1 reject...
Rejected hunk #1.
Applied patch include/kvm/i8042.h cleanly.
Patch failed at 0007 hw/i8042: Switch to new trap handlers
hint: Use 'git am --show-current-patch=diff' to see the failed patch
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".

where the patch file is from patchwork.kernel.org [1], created when clicking on
the "series" button on the top right. I'm not sure what is causing the error,
everything looks the same to me.

Regardless, I've applied the reject manually and everything looks ok.

[1]
https://patchwork.kernel.org/project/kvm/patch/20210225005915.26423-2-andre.przywara@arm.com/

Thanks,

Alex

On 2/25/21 12:58 AM, Andre Przywara wrote:
> Compared to v1 this has a few fixes, as suggested by Alex.
> There is a new patch 20/22, which cleans up the ARM memory map
> definition and adds some chart to make it more obvious what is going on.
> For a changelog, see below.
>
> ==============
>
> At the moment we use two separate code paths to handle exits for
> KVM_EXIT_IO (ioport.c) and KVM_EXIT_MMIO (mmio.c), even though they
> are semantically very similar. Because the trap handler callback routine
> is different, devices need to decide on one conduit or need to provide
> different handler functions for both of them.
>
> This is not only unnecessary code duplication, but makes switching
> devices from I/O port to MMIO a tedious task, even though there is no
> real difference between the two, especially on ARM and PowerPC.
>
> For ARM we aim at providing a flexible memory layout, and also have
> trouble with the UART and RTC device overlapping with the PCI I/O area,
> so it seems indicated to tackle this once and for all.
>
> The first three patches do some cleanup, to simplify things later.
>
> Patch 04/22 lays the groundwork, by extending mmio.c to be able to also
> register I/O port trap handlers, using the same callback prototype as
> we use for MMIO.
>
> The next 14 patches then convert devices that use the I/O port
> interface over to the new joint interface. This requires to rework
> the trap handler routine to adhere to the same prototype as the existing
> MMIO handlers. For most devices this is done in two steps: a first to
> introduce the reworked handler routine, and a second to switch to the new
> joint registration routine. For some devices the first step is trivial,
> so it's done in one patch.
>
> Patch 19/22 then retires the old I/O port interface, by removing ioport.c
> and friends.
> Patch 20/22 uses the opportunity to clean up the memory map description,
> also declares a new region (from 16MB on), where the final two patches
> switch the UART and the RTC device to. They are now registered
> on the MMIO "bus", when running on ARM or arm64. This moves them away
> from the first 64KB, so they are not in the PCI I/O area anymore.
>
> Please have a look and comment!
>
> Cheers,
> Andre
>
> Changelog v1 .. v2:
> - rework memory map definition
> - add explicit debug output for debug I/O port
> - add explicit check for MMIO coalescing on I/O ports
> - drop usage of ioport__{read,write}8() from serial
> - drop explicit I/O port cleanup routine (to mimic MMIO operation)
> - add comment for IOTRAP_BUS_MASK
> - minor cleanups / formatting changes
>
> Andre Przywara (22):
>   ioport: Remove ioport__setup_arch()
>   hw/serial: Use device abstraction for FDT generator function
>   ioport: Retire .generate_fdt_node functionality
>   mmio: Extend handling to include ioport emulation
>   hw/i8042: Clean up data types
>   hw/i8042: Refactor trap handler
>   hw/i8042: Switch to new trap handlers
>   x86/ioport: Refactor trap handlers
>   x86/ioport: Switch to new trap handlers
>   hw/rtc: Refactor trap handlers
>   hw/rtc: Switch to new trap handler
>   hw/vesa: Switch trap handling to use MMIO handler
>   hw/serial: Refactor trap handler
>   hw/serial: Switch to new trap handlers
>   vfio: Refactor ioport trap handler
>   vfio: Switch to new ioport trap handlers
>   virtio: Switch trap handling to use MMIO handler
>   pci: Switch trap handling to use MMIO handler
>   Remove ioport specific routines
>   arm: Reorganise and document memory map
>   hw/serial: ARM/arm64: Use MMIO at higher addresses
>   hw/rtc: ARM/arm64: Use MMIO at higher addresses
>
>  Makefile                          |   1 -
>  arm/include/arm-common/kvm-arch.h |  47 ++++--
>  arm/ioport.c                      |   5 -
>  hw/i8042.c                        |  94 +++++-------
>  hw/rtc.c                          |  91 ++++++------
>  hw/serial.c                       | 160 ++++++++++++--------
>  hw/vesa.c                         |  19 +--
>  include/kvm/i8042.h               |   1 -
>  include/kvm/ioport.h              |  32 ----
>  include/kvm/kvm.h                 |  49 ++++++-
>  ioport.c                          | 235 ------------------------------
>  mips/kvm.c                        |   5 -
>  mmio.c                            |  65 +++++++--
>  pci.c                             |  82 +++--------
>  powerpc/ioport.c                  |   6 -
>  vfio/core.c                       |  50 ++++---
>  virtio/pci.c                      |  46 ++----
>  x86/ioport.c                      | 107 +++++++-------
>  18 files changed, 433 insertions(+), 662 deletions(-)
>  delete mode 100644 ioport.c
>
