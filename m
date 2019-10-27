Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF90E6200
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2019 11:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbfJ0KRM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Oct 2019 06:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726682AbfJ0KRM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Oct 2019 06:17:12 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8C7A4368FF
        for <kvm@vger.kernel.org>; Sun, 27 Oct 2019 10:17:11 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id o13so1426640qkm.15
        for <kvm@vger.kernel.org>; Sun, 27 Oct 2019 03:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uONJXjgvNvjYSUNW0PvTpmvXbc4zToxXmvIIlm6FhZA=;
        b=G+h7PqHqqlT3YoniMxPwVY2pELaaqHScq+gUaSXctyYlY1Bfv6ALmbZ4z2juuCyQ9j
         FX4zY6mR7sfGRfnI0QMVG9qpHWRonqdnMWryCOb/BoN7DvMN5fQq7AjdJmHytlFCDuut
         LEfYInZPy4xCZ1J2A+J2rY/JWvKdCZZAik8zyWqPN4ZwZnvwKrfQ3kLhKpOcIVzF/eMB
         zPBdqC+WeMPfHXQ7o/P1KrWpWSos0X08faH4/Qz613284r4P+Ehn1wZV61lFQyb2zymJ
         XuQxrfUatgyOYvOfSo95i1gH5X2KC2A1EmWGULWcpJKK9jRbr9WWKbi0FrutW9kCmt63
         6pLQ==
X-Gm-Message-State: APjAAAX82wcIxpO9xNW0oWA5KrAjiwZAoUv66+Qe9u/55EjFrGvZt3kf
        0gifcp1bHYa/yYRlaYk7XIEr4MPrWXkOtAnElEe21upscF0cuVw/HX5XH/1osxhdvmOWUWHRM5O
        N6eB9SGM12ifF
X-Received: by 2002:ac8:2a5d:: with SMTP id l29mr12584611qtl.36.1572171429070;
        Sun, 27 Oct 2019 03:17:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyP4mdDOy1Vzl+MhHUFbMCJjv1WqxmWRCIXA6x4xWDkLURlGFc/uEKPgcnnlq7ZD97dvDPzUw==
X-Received: by 2002:ac8:2a5d:: with SMTP id l29mr12584581qtl.36.1572171428665;
        Sun, 27 Oct 2019 03:17:08 -0700 (PDT)
Received: from redhat.com (bzq-79-176-10-77.red.bezeqint.net. [79.176.10.77])
        by smtp.gmail.com with ESMTPSA id g8sm5319138qta.67.2019.10.27.03.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 03:17:07 -0700 (PDT)
Date:   Sun, 27 Oct 2019 06:17:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xiang Zheng <zhengxiang9@huawei.com>
Cc:     pbonzini@redhat.com, imammedo@redhat.com, shannon.zhaosl@gmail.com,
        peter.maydell@linaro.org, lersek@redhat.com, james.morse@arm.com,
        gengdongjiu@huawei.com, mtosatti@redhat.com, rth@twiddle.net,
        ehabkost@redhat.com, jonathan.cameron@huawei.com,
        xuwei5@huawei.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org, linuxarm@huawei.com,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH v20 0/5] Add ARMv8 RAS virtualization support in QEMU
Message-ID: <20191027061450-mutt-send-email-mst@kernel.org>
References: <20191026032447.20088-1-zhengxiang9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026032447.20088-1-zhengxiang9@huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 26, 2019 at 11:24:42AM +0800, Xiang Zheng wrote:
> In the ARMv8 platform, the CPU error types are synchronous external abort(SEA)
> and SError Interrupt (SEI). If exception happens in guest, sometimes it's better
> for guest to perform the recovery, because host does not know the detailed
> information of guest. For example, if an exception happens in a user-space
> application within guest, host does not know which application encounters
> errors.
> 
> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify userspace.
> After user space gets the notification, it will record the CPER into guest GHES
> buffer and inject an exception or IRQ into guest.
> 
> In the current implementation, if the type of SIGBUS is BUS_MCEERR_AR, we will
> treat it as a synchronous exception, and notify guest with ARMv8 SEA
> notification type after recording CPER into guest.
> 
> This series of patches are based on Qemu 4.1, which include two parts:
> 1. Generate APEI/GHES table.
> 2. Handle the SIGBUS signal, record the CPER in runtime and fill it into guest
>    memory, then notify guest according to the type of SIGBUS.
> 
> The whole solution was suggested by James(james.morse@arm.com); The solution of
> APEI section was suggested by Laszlo(lersek@redhat.com).
> Show some discussions in [1].
> 
> This series of patches have already been tested on ARM64 platform with RAS
> feature enabled:
> Show the APEI part verification result in [2].
> Show the BUS_MCEERR_AR SIGBUS handling verification result in [3].


This looks mostly OK to me.  I sent some minor style comments but they
can be addressed by follow up patches.

Maybe it's a good idea to merge this before soft freeze to make sure it
gets some testing.  I'll leave this decision to the ARM maintainer.  For
ACPI parts:

Reviewed-by: Michael S. Tsirkin <mst@redhat.com>


> ---
> Change since v19:
> 1. Fix clang compile error
> 2. Fix sphinx build error
> 
> Change since v18:
> 1. Fix some code-style and typo/grammar problems.
> 2. Remove no_ras in the VirtMachineClass struct.
> 3. Convert documentation to rst format.
> 4. Simplize the code and add comments for some magic value.
> 5. Move kvm_inject_arm_sea() function into the patch where it's used.
> 6. Register the reset handler(kvm_unpoison_all()) in the kvm_init() function.
> 
> Change since v17:
> 1. Improve some commit messages and comments.
> 2. Fix some code-style problems.
> 3. Add a *ras* machine option.
> 4. Move HEST/GHES related structures and macros into "hw/acpi/acpi_ghes.*".
> 5. Move HWPoison page functions into "include/sysemu/kvm_int.h".
> 6. Fix some bugs.
> 7. Improve the design document.
> 
> Change since v16:
> 1. check whether ACPI table is enabled when handling the memory error in the SIGBUS handler.
> 
> Change since v15:
> 1. Add a doc-comment in the proper format for 'include/exec/ram_addr.h'
> 2. Remove write_part_cpustate_to_list() because there is another bug fix patch
>    has been merged "arm: Allow system registers for KVM guests to be changed by QEMU code"
> 3. Add some comments for kvm_inject_arm_sea() in 'target/arm/kvm64.c'
> 4. Compare the arm_current_el() return value to 0,1,2,3, not to PSTATE_MODE_* constants.
> 5. Change the RAS support wasn't introduced before 4.1 QEMU version.
> 6. Move the no_ras flag  patch to begin in this series
> 
> Change since v14:
> 1. Remove the BUS_MCEERR_AO handling logic because this asynchronous signal was masked by main thread
> 2. Address some Igor Mammedov's comments(ACPI part)
>    1) change the comments for the enum AcpiHestNotifyType definition and remove ditto in patch 1
>    2) change some patch commit messages and separate "APEI GHES table generation" patch to more patches.
> 3. Address some peter's comments(arm64 Synchronous External Abort injection)
>    1) change some code notes
>    2) using arm_current_el() for current EL
>    2) use the helper functions for those (syn_data_abort_*).
> 
> Change since v13:
> 1. Move the patches that set guest ESR and inject virtual SError out of this series
> 2. Clean and optimize the APEI part patches
> 3. Update the commit messages and add some comments for the code
> 
> Change since v12:
> 1. Address Paolo's comments to move HWPoisonPage definition to accel/kvm/kvm-all.c
> 2. Only call kvm_cpu_synchronize_state() when get the BUS_MCEERR_AR signal
> 3. Only add and enable GPIO-Signal and ARMv8 SEA two hardware error sources
> 4. Address Michael's comments to not sync SPDX from Linux kernel header file
> 
> Change since v11:
> Address James's comments(james.morse@arm.com)
> 1. Check whether KVM has the capability to to set ESR instead of detecting host CPU RAS capability
> 2. For SIGBUS_MCEERR_AR SIGBUS, use Synchronous-External-Abort(SEA) notification type
>    for SIGBUS_MCEERR_AO SIGBUS, use GPIO-Signal notification
> 
> 
> Address Shannon's comments(for ACPI part):
> 1. Unify hest_ghes.c and hest_ghes.h license declaration
> 2. Remove unnecessary including "qmp-commands.h" in hest_ghes.c
> 3. Unconditionally add guest APEI table based on James's comments(james.morse@arm.com)
> 4. Add a option to virt machine for migration compatibility. On new virt machine it's on
>    by default while off for old ones, we enabled it since 2.12
> 5. Refer to the ACPI spec version which introduces Hardware Error Notification first time
> 6. Add ACPI_HEST_NOTIFY_RESERVED notification type
> 
> Address Igor's comments(for ACPI part):
> 1. Add doc patch first which will describe how it's supposed to work between QEMU/firmware/guest
>    OS with expected flows.
> 2. Move APEI diagrams into doc/spec patch
> 3. Remove redundant g_malloc in ghes_record_cper()
> 4. Use build_append_int_noprefix() API to compose whole error status block and whole APEI table,
>    and try to get rid of most structures in patch 1, as they will be left unused after that
> 5. Reuse something like https://github.com/imammedo/qemu/commit/3d2fd6d13a3ea298d2ee814835495ce6241d085c
>    to build GAS
> 6. Remove much offsetof() in the function
> 7. Build independent tables first and only then build dependent tables passing to it pointers
>    to previously build table if necessary.
> 8. Redefine macro GHES_ACPI_HEST_NOTIFY_RESERVED to ACPI_HEST_ERROR_SOURCE_COUNT to avoid confusion
> 
> 
> Address Peter Maydell's comments
> 1. linux-headers is done as a patch of their own created using scripts/update-linux-headers.sh run against a
>    mainline kernel tree
> 2. Tested whether this patchset builds OK on aarch32
> 3. Abstract Hwpoison page adding code  out properly into a cpu-independent source file from target/i386/kvm.c,
>    such as kvm-all.c
> 4. Add doc-comment formatted documentation comment for new globally-visible function prototype in a header
> 
> ---
> [1]:
> https://lkml.org/lkml/2017/2/27/246
> https://patchwork.kernel.org/patch/9633105/
> https://patchwork.kernel.org/patch/9925227/
> 
> [2]:
> Note: the UEFI(QEMU_EFI.fd) is needed if guest want to use ACPI table.
> 
> After guest boot up, dump the APEI table, then can see the initialized table
> (1) # iasl -p ./HEST -d /sys/firmware/acpi/tables/HEST
> (2) # cat HEST.dsl
>     /*
>      * Intel ACPI Component Architecture
>      * AML/ASL+ Disassembler version 20170728 (64-bit version)
>      * Copyright (c) 2000 - 2017 Intel Corporation
>      *
>      * Disassembly of /sys/firmware/acpi/tables/HEST, Mon Sep  5 07:59:17 2016
>      *
>      * ACPI Data Table [HEST]
>      *
>      * Format: [HexOffset DecimalOffset ByteLength]  FieldName : FieldValue
>      */
> 
>     ..................................................................................
>     [308h 0776   2]                Subtable Type : 000A [Generic Hardware Error Source V2]
>     [30Ah 0778   2]                    Source Id : 0001
>     [30Ch 0780   2]            Related Source Id : FFFF
>     [30Eh 0782   1]                     Reserved : 00
>     [30Fh 0783   1]                      Enabled : 01
>     [310h 0784   4]       Records To Preallocate : 00000001
>     [314h 0788   4]      Max Sections Per Record : 00000001
>     [318h 0792   4]          Max Raw Data Length : 00001000
> 
>     [31Ch 0796  12]         Error Status Address : [Generic Address Structure]
>     [31Ch 0796   1]                     Space ID : 00 [SystemMemory]
>     [31Dh 0797   1]                    Bit Width : 40
>     [31Eh 0798   1]                   Bit Offset : 00
>     [31Fh 0799   1]         Encoded Access Width : 04 [QWord Access:64]
>     [320h 0800   8]                      Address : 00000000785D0040
> 
>     [328h 0808  28]                       Notify : [Hardware Error Notification Structure]
>     [328h 0808   1]                  Notify Type : 08 [SEA]
>     [329h 0809   1]                Notify Length : 1C
>     [32Ah 0810   2]   Configuration Write Enable : 0000
>     [32Ch 0812   4]                 PollInterval : 00000000
>     [330h 0816   4]                       Vector : 00000000
>     [334h 0820   4]      Polling Threshold Value : 00000000
>     [338h 0824   4]     Polling Threshold Window : 00000000
>     [33Ch 0828   4]        Error Threshold Value : 00000000
>     [340h 0832   4]       Error Threshold Window : 00000000
> 
>     [344h 0836   4]    Error Status Block Length : 00001000
>     [348h 0840  12]            Read Ack Register : [Generic Address Structure]
>     [348h 0840   1]                     Space ID : 00 [SystemMemory]
>     [349h 0841   1]                    Bit Width : 40
>     [34Ah 0842   1]                   Bit Offset : 00
>     [34Bh 0843   1]         Encoded Access Width : 04 [QWord Access:64]
>     [34Ch 0844   8]                      Address : 00000000785D0098
> 
>     [354h 0852   8]            Read Ack Preserve : 00000000FFFFFFFE
>     [35Ch 0860   8]               Read Ack Write : 0000000000000001
> 
>     .....................................................................................
> 
> (3) After a synchronous external abort(SEA) happen, Qemu receive a SIGBUS and 
>     filled the CPER into guest GHES memory.  For example, according to above table,
>     the address that contains the physical address of a block of memory that holds
>     the error status data for this abort is 0x00000000785D0040
> (4) the address for SEA notification error source is 0x785d80b0
>     (qemu) xp /1 0x00000000785D0040
>     00000000785d0040: 0x785d80b0
> 
> (5) check the content of generic error status block and generic error data entry
>     (qemu) xp /100x 0x785d80b0
>     00000000785d80b0: 0x00000001 0x00000000 0x00000000 0x00000098
>     00000000785d80c0: 0x00000000 0xa5bc1114 0x4ede6f64 0x833e63b8
>     00000000785d80d0: 0xb1837ced 0x00000000 0x00000300 0x00000050
>     00000000785d80e0: 0x00000000 0x00000000 0x00000000 0x00000000
>     00000000785d80f0: 0x00000000 0x00000000 0x00000000 0x00000000
>     00000000785d8100: 0x00000000 0x00000000 0x00000000 0x00004002
> (6) check the OSPM's ACK value(for example SEA)
>     /* Before OSPM acknowledges the error, check the ACK value */
>     (qemu) xp /1 0x00000000785D0098
>     00000000785d00f0: 0x00000000
> 
>     /* After OSPM acknowledges the error, check the ACK value, it change to 1 from 0 */
>     (qemu) xp /1 0x00000000785D0098
>     00000000785d00f0: 0x00000001
> 
> [3]: KVM deliver "BUS_MCEERR_AR" to Qemu, Qemu record the guest CPER and inject
>     synchronous external abort to notify guest, then guest do the recovery.
> 
> [ 1552.516170] Synchronous External Abort: synchronous external abort (0x92000410) at 0x000000003751c6b4
> [ 1553.074073] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 8
> [ 1553.081654] {1}[Hardware Error]: event severity: recoverable
> [ 1554.034191] {1}[Hardware Error]:  Error 0, type: recoverable
> [ 1554.037934] {1}[Hardware Error]:   section_type: memory error
> [ 1554.513261] {1}[Hardware Error]:   physical_address: 0x0000000040fa6000
> [ 1554.513944] {1}[Hardware Error]:   error_type: 0, unknown
> [ 1555.041451] Memory failure: 0x40fa6: Killing mca-recover:1296 due to hardware memory corruption
> [ 1555.373116] Memory failure: 0x40fa6: recovery action for dirty LRU page: Recovered
> 
> Dongjiu Geng (5):
>   hw/arm/virt: Introduce a RAS machine option
>   docs: APEI GHES generation and CPER record description
>   ACPI: Add APEI GHES table generation support
>   KVM: Move hwpoison page related functions into kvm-all.c
>   target-arm: kvm64: handle SIGBUS signal from kernel or KVM
> 
>  accel/kvm/kvm-all.c             |  36 +++
>  default-configs/arm-softmmu.mak |   1 +
>  docs/specs/acpi_hest_ghes.rst   |  95 +++++++
>  docs/specs/index.rst            |   1 +
>  hw/acpi/Kconfig                 |   4 +
>  hw/acpi/Makefile.objs           |   1 +
>  hw/acpi/acpi_ghes.c             | 476 ++++++++++++++++++++++++++++++++
>  hw/acpi/aml-build.c             |   2 +
>  hw/arm/virt-acpi-build.c        |  12 +
>  hw/arm/virt.c                   |  23 ++
>  include/hw/acpi/acpi_ghes.h     | 148 ++++++++++
>  include/hw/acpi/aml-build.h     |   1 +
>  include/hw/arm/virt.h           |   1 +
>  include/sysemu/kvm.h            |   3 +-
>  include/sysemu/kvm_int.h        |  12 +
>  target/arm/cpu.h                |   4 +
>  target/arm/helper.c             |   2 +-
>  target/arm/internals.h          |   5 +-
>  target/arm/kvm64.c              |  64 +++++
>  target/arm/tlb_helper.c         |   2 +-
>  target/i386/cpu.h               |   2 +
>  target/i386/kvm.c               |  36 ---
>  22 files changed, 889 insertions(+), 42 deletions(-)
>  create mode 100644 docs/specs/acpi_hest_ghes.rst
>  create mode 100644 hw/acpi/acpi_ghes.c
>  create mode 100644 include/hw/acpi/acpi_ghes.h
> 
> -- 
> 2.19.1
> 
