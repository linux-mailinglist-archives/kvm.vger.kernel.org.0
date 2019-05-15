Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 615181EB21
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 11:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbfEOJkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 05:40:14 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8198 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725871AbfEOJkO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 May 2019 05:40:14 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 09E4FFE2A56C8E7F6DB3;
        Wed, 15 May 2019 17:40:12 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 15 May 2019
 17:40:05 +0800
Subject: Re: [PATCH v17 00/10] Add ARMv8 RAS virtualization support in QEMU
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <468f900f-ce80-8d5b-a64d-67c0b3bee1ed@huawei.com>
Date:   Wed, 15 May 2019 17:40:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,
 for this series patch, we can use below simple method to test:

1). Apply below hard code change after applying this series patch:
diff --git a/cpus.c b/cpus.c
index e58e7ab..7149f54 100644
--- a/cpus.c
+++ b/cpus.c
@@ -1131,6 +1131,8 @@ static void sigbus_reraise(void)

 static void sigbus_handler(int n, siginfo_t *siginfo, void *ctx)
 {
+    siginfo->si_code = BUS_MCEERR_AO;
+
     if (siginfo->si_code != BUS_MCEERR_AO && siginfo->si_code != BUS_MCEERR_AR) {
         sigbus_reraise();
     }
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index d2eac28..6c9956e 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -1035,20 +1035,23 @@ int kvm_arch_get_registers(CPUState *cs)

 void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
 {
+#if 0
     ram_addr_t ram_addr;
-    hwaddr paddr;
-
+#endif
+    hwaddr paddr = 0x400a1000;
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);

+#if 0
     if (acpi_enabled && addr) {
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
             kvm_hwpoison_page_add(ram_addr);
+#endif
             /* Asynchronous signal will be masked by main thread, so
              * only handle synchronous signal.
              */
-            if (code == BUS_MCEERR_AR) {
+            if (code == BUS_MCEERR_AR || BUS_MCEERR_AO == code) {
                 kvm_cpu_synchronize_state(c);
                 if (GHES_CPER_FAIL != ghes_record_errors(ACPI_HEST_NOTIFY_SEA, paddr)) {
                     kvm_inject_arm_sea(c);
@@ -1057,11 +1060,13 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
                 }
             }
             return;
+#if 0
         }
         fprintf(stderr, "Hardware memory error for memory used by "
                 "QEMU itself instead of guest system!\n");
     }

+#endif
     if (code == BUS_MCEERR_AR) {
         fprintf(stderr, "Hardware memory error!\n");
         exit(1);

2) In Arm64 machine run below command to run a virtual machine with kvm disabled, and enable bios:
./qemu-system-aarch64 -cpu cortex-a57 -machine virt,gic-version=3  -smp 4 -nographic -kernel Image -bios QEMU_EFI.fd -append "rdinit=/init console=ttyAMA0 mem=512M root=/dev/ram0 earlycon=pl011,0x9000000 rw" -initrd guestfs_new.cpio.gz

3) Deliver SGIBUS signal to QEMU:
   kill -s SIGBUS 11522

4) then you can see QEMU record the error memory address to APEI table, and inject a SEA to guest, for example:

[   75.514270] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 1
[   75.531858] {1}[Hardware Error]: event severity: recoverable
[   75.535095] {1}[Hardware Error]:  Error 0, type: recoverable
[   75.539223] {1}[Hardware Error]:   section_type: memory error
[   75.543878] {1}[Hardware Error]:   physical_address: 0x00000000400a1000
[   75.548696] {1}[Hardware Error]:   error_type: 0, unknown
[   75.577156] Internal error: synchronous external abort: 96000410 [#1] PREEMPT SMP

On 2019/5/14 19:18, Dongjiu Geng wrote:
> In the ARMv8 platform, the CPU error type are synchronous external
> abort(SEA) and SError Interrupt (SEI). If exception happens to guest,
> sometimes guest itself do the recovery is better, because host 
> does not know guest's detailed information. For example, if a guest
> user-space application happen exception, host does not which application
> encounter errors.
> 
> For the ARMv8 SEA/SEI, KVM or host kernel delivers SIGBUS to notify user
> space. After user space gets  the notification, it will record the CPER
> to guest GHES buffer for guest and inject a exception or IRQ to guest.
> 
> In the current implement, if the SIGBUS is BUS_MCEERR_AR, we will
> treat it as synchronous exception, and use ARMv8 SEA notification type
> to notify guest after recording CPER for guest;
> 
> This series patches are based on Qemu 4.0, which have two parts:
> 1. Generate APEI/GHES table.
> 2. Handle the SIGBUS signal, record the CPER in runtime and fill into guest memory,
>    then according to SIGBUS type to notify guest.
> 
> Whole solution was suggested by James(james.morse@arm.com); APEI part solution is suggested by
> Laszlo(lersek@redhat.com). Shown some discussion in [1].
> 
> 
> This series patches have already tested on ARM64 platform with RAS feature enabled:
> Show the APEI part verification result in [2]
> Show the BUS_MCEERR_AR SIGBUS handling verification result in [3]
> 
> ---
> change since v16:
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
> 
> 
> Dongjiu Geng (10):
>   hw/arm/virt: Add RAS platform version for migration
>   ACPI: add some GHES structures and macros definition
>   acpi: add build_append_ghes_notify() helper for Hardware Error
>     Notification
>   acpi: add build_append_ghes_generic_data() helper for Generic Error
>     Data Entry
>   acpi: add build_append_ghes_generic_status() helper for Generic Error
>     Status Block
>   docs: APEI GHES generation and CPER record description
>   ACPI: Add APEI GHES table generation support
>   KVM: Move related hwpoison page functions to accel/kvm/ folder
>   target-arm: kvm64: inject synchronous External Abort
>   target-arm: kvm64: handle SIGBUS signal from kernel or KVM
> 
>  accel/kvm/kvm-all.c             |  33 ++++
>  default-configs/arm-softmmu.mak |   1 +
>  docs/specs/acpi_hest_ghes.txt   |  97 +++++++++++
>  hw/acpi/Kconfig                 |   4 +
>  hw/acpi/Makefile.objs           |   1 +
>  hw/acpi/acpi_ghes.c             | 348 ++++++++++++++++++++++++++++++++++++++++
>  hw/acpi/aml-build.c             |  70 ++++++++
>  hw/arm/virt-acpi-build.c        |  12 ++
>  hw/arm/virt.c                   |   6 +
>  include/exec/ram_addr.h         |  24 +++
>  include/hw/acpi/acpi-defs.h     |  52 ++++++
>  include/hw/acpi/acpi_ghes.h     |  83 ++++++++++
>  include/hw/acpi/aml-build.h     |  21 +++
>  include/hw/arm/virt.h           |   1 +
>  include/sysemu/kvm.h            |   2 +-
>  target/arm/internals.h          |   5 +-
>  target/arm/kvm.c                |   3 +
>  target/arm/kvm64.c              |  73 +++++++++
>  target/arm/op_helper.c          |   2 +-
>  target/i386/kvm.c               |  34 +---
>  20 files changed, 835 insertions(+), 37 deletions(-)
>  create mode 100644 docs/specs/acpi_hest_ghes.txt
>  create mode 100644 hw/acpi/acpi_ghes.c
>  create mode 100644 include/hw/acpi/acpi_ghes.h
> 

