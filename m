Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83210135204
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 04:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgAIDiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 22:38:18 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:34020 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726913AbgAIDiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 22:38:17 -0500
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 76138863EC7918525871;
        Thu,  9 Jan 2020 11:38:15 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Thu, 9 Jan 2020
 11:38:08 +0800
Subject: Re: [PATCH v22 0/9] Add ARMv8 RAS virtualization support in QEMU
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <fam@euphon.net>, <rth@twiddle.net>, <ehabkost@redhat.com>,
        <mtosatti@redhat.com>, <xuwei5@huawei.com>,
        <jonathan.cameron@huawei.com>, <james.morse@arm.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>
CC:     <zhengxiang9@huawei.com>, <linuxarm@huawei.com>
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <f56cd9fd-5e40-fbad-a6e6-1233262ed1ca@huawei.com>
Date:   Thu, 9 Jan 2020 11:38:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

1. How to enable this feature:
(a) In KVM mode: ./qemu-system-aarch64 --enable-kvm -cpu host --bios QEMU_EFI.fd_new  -machine virt,gic-version=3,ras,kernel-irqchip=on  -smp 4 -nographic -kernel Image  -append "rdinit=/init console=ttyAMA0 mem=512M root=/dev/ram0" -initrd guestfs_new.cpio.gz
(b）In TCG mode: ./qemu-system-aarch64 -cpu cortex-a57 -bios QEMU_EFI.fd_new  -machine virt,gic-version=3,ras  -smp 4 -nographic -kernel Image  -append "rdinit=/init console=ttyAMA0 mem=512M root=/dev/ram0 earlycon=pl011,0x9000000 rw" -initrd guestfs_new.cpio.gz

2. How to quickly test this series patches:
（a）hack some code as shown in [1].
 (b) build and run the qemu: ./qemu-system-aarch64 -cpu cortex-a57 -bios QEMU_EFI.fd_new  -machine virt,gic-version=3,ras  -smp 4 -nographic -kernel Image  -append "rdinit=/init console=ttyAMA0 mem=512M root=/dev/ram0 earlycon=pl011,0x9000000 rw" -initrd guestfs_new.cpio.gz
 (c) find the process id(PID) of "qemu-system-aarch64": $ ps -aux | grep "qemu
 (d) then send SIGBUS to qemu process: kill -s SIGBUS PID


[1]:
diff --git a/cpus.c b/cpus.c
index b472378b70..a0b67f5947 100644
--- a/cpus.c
+++ b/cpus.c
@@ -1087,6 +1087,8 @@ static void sigbus_reraise(void)

 static void sigbus_handler(int n, siginfo_t *siginfo, void *ctx)
 {
+    siginfo->si_code = BUS_MCEERR_AO;
+
     if (siginfo->si_code != BUS_MCEERR_AO && siginfo->si_code != BUS_MCEERR_AR) {
         sigbus_reraise();
     }
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index f3b05c1977..03e8e20f4a 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -1323,17 +1323,23 @@ int kvm_arch_get_registers(CPUState *cs)

 void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
 {
+#if 0
     ram_addr_t ram_addr;
     hwaddr paddr;

     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
-
-    if (acpi_enabled && addr &&
+#else
+    hwaddr paddr = 0x400a1000;
+    code = BUS_MCEERR_AR;
+#endif
+    if (acpi_enabled && paddr &&
             object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
+#if 0
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
             kvm_hwpoison_page_add(ram_addr);
+#endif
             /*
              * Asynchronous signal will be masked by main thread, so
              * only handle synchronous signal.
@@ -1348,11 +1354,13 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
                 }
             }
             return;
+#if 0
         }
         if (code == BUS_MCEERR_AO) {
             error_report("Hardware memory error at addr %p for memory used by "
                 "QEMU itself instead of guest system!", addr);
         }
+#endif
     }

     if (code == BUS_MCEERR_AR) {



On 2020/1/8 19:32, Dongjiu Geng wrote:
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
> This series of patches are based on Qemu 4.2, which include two parts:
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
> 
> ---
> Change since v21:
> 1. Make the user-facing 'ras' option description more clearly to address Peter's comments.
> 2. Update the doc description in "docs/specs/acpi_hest_ghes.rst"
> 3. Split HEST/GHES patches to more patches to make the review easily
> 4. Using source_id to index the location to save the CPER.
> 5. Optimize and simplify the logic to build HEST/GHES table to address Igor/Michael/Beata comments.
> 6. make ghes_addr_le a part of GED device.
> 
> Change since v20:
> 1. Move some implementation details from acpi_ghes.h to acpi_ghes.c
> 2. Add the reviewers for the ACPI/APEI/GHES part
> 
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
> Dongjiu Geng (9):
>   hw/arm/virt: Introduce a RAS machine option
>   docs: APEI GHES generation and CPER record description
>   ACPI: Build related register address fields via hardware error fw_cfg
>     blob
>   ACPI: Build Hardware Error Source Table
>   ACPI: Record the Generic Error Status Block address
>   KVM: Move hwpoison page related functions into kvm-all.c
>   ACPI: Record Generic Error Status Block(GESB) table
>   target-arm: kvm64: handle SIGBUS signal from kernel or KVM
>   MAINTAINERS: Add ACPI/HEST/GHES entries
> 
>  MAINTAINERS                            |   9 +
>  accel/kvm/kvm-all.c                    |  36 +++
>  default-configs/arm-softmmu.mak        |   1 +
>  docs/specs/acpi_hest_ghes.rst          | 110 ++++++++
>  docs/specs/index.rst                   |   1 +
>  hw/acpi/Kconfig                        |   4 +
>  hw/acpi/Makefile.objs                  |   1 +
>  hw/acpi/aml-build.c                    |   2 +
>  hw/acpi/generic_event_device.c         |  15 +-
>  hw/acpi/ghes.c                         | 446 +++++++++++++++++++++++++++++++++
>  hw/arm/virt-acpi-build.c               |  19 ++
>  hw/arm/virt.c                          |  23 ++
>  include/hw/acpi/aml-build.h            |   1 +
>  include/hw/acpi/generic_event_device.h |   2 +
>  include/hw/acpi/ghes.h                 |  75 ++++++
>  include/hw/arm/virt.h                  |   1 +
>  include/qemu/uuid.h                    |   5 +
>  include/sysemu/kvm.h                   |   3 +-
>  include/sysemu/kvm_int.h               |  12 +
>  target/arm/cpu.h                       |   4 +
>  target/arm/helper.c                    |   2 +-
>  target/arm/internals.h                 |   5 +-
>  target/arm/kvm64.c                     |  66 +++++
>  target/arm/tlb_helper.c                |   2 +-
>  target/i386/cpu.h                      |   2 +
>  target/i386/kvm.c                      |  36 ---
>  26 files changed, 840 insertions(+), 43 deletions(-)
>  create mode 100644 docs/specs/acpi_hest_ghes.rst
>  create mode 100644 hw/acpi/ghes.c
>  create mode 100644 include/hw/acpi/ghes.h
> 

