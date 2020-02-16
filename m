Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1AD16036A
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2020 11:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgBPKWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Feb 2020 05:22:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:59250 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727860AbgBPKWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Feb 2020 05:22:13 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A709C2882CC04DBA6154;
        Sun, 16 Feb 2020 18:22:07 +0800 (CST)
Received: from huawei.com (10.151.151.243) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Sun, 16 Feb 2020
 18:21:53 +0800
From:   Dongjiu Geng <gengdongjiu@huawei.com>
To:     <mst@redhat.com>, <imammedo@redhat.com>,
        <xiaoguangrong.eric@gmail.com>, <shannon.zhaosl@gmail.com>,
        <peter.maydell@linaro.org>, <fam@euphon.net>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <mtosatti@redhat.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <pbonzini@redhat.com>,
        <james.morse@arm.com>, <lersek@redhat.com>,
        <jonathan.cameron@huawei.com>,
        <shameerali.kolothum.thodi@huawei.com>
CC:     <gengdongjiu@huawei.com>, <zhengxiang9@huawei.com>
Subject: [PATCH v23 8/9] target-arm: kvm64: handle SIGBUS signal from kernel or KVM
Date:   Sun, 16 Feb 2020 18:24:07 +0800
Message-ID: <20200216102408.22987-10-gengdongjiu@huawei.com>
X-Mailer: git-send-email 2.18.0.huawei.25
In-Reply-To: <20200216102408.22987-1-gengdongjiu@huawei.com>
References: <20200216102408.22987-1-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.151.151.243]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a SIGBUS signal handler. In this handler, it checks the SIGBUS type,
translates the host VA delivered by host to guest PA, then fills this PA
to guest APEI GHES memory, then notifies guest according to the SIGBUS
type.

When guest accesses the poisoned memory, it will generate a Synchronous
External Abort(SEA). Then host kernel gets an APEI notification and calls
memory_failure() to unmapped the affected page in stage 2, finally
returns to guest.

Guest continues to access the PG_hwpoison page, it will trap to KVM as
stage2 fault, then a SIGBUS_MCEERR_AR synchronous signal is delivered to
Qemu, Qemu records this error address into guest APEI GHES memory and
notifes guest using Synchronous-External-Abort(SEA).

In order to inject a vSEA, we introduce the kvm_inject_arm_sea() function
in which we can setup the type of exception and the syndrome information.
When switching to guest, the target vcpu will jump to the synchronous
external abort vector table entry.

The ESR_ELx.DFSC is set to synchronous external abort(0x10), and the
ESR_ELx.FnV is set to not valid(0x1), which will tell guest that FAR is
not valid and hold an UNKNOWN value. These values will be set to KVM
register structures through KVM_SET_ONE_REG IOCTL.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 include/sysemu/kvm.h    |  3 +-
 target/arm/cpu.h        |  4 +++
 target/arm/helper.c     |  2 +-
 target/arm/internals.h  |  5 ++--
 target/arm/kvm64.c      | 73 +++++++++++++++++++++++++++++++++++++++++++++++++
 target/arm/tlb_helper.c |  2 +-
 target/i386/cpu.h       |  2 ++
 7 files changed, 85 insertions(+), 6 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 141342d..3b22504 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -379,8 +379,7 @@ bool kvm_vcpu_id_is_valid(int vcpu_id);
 /* Returns VCPU ID to be used on KVM_CREATE_VCPU ioctl() */
 unsigned long kvm_arch_vcpu_id(CPUState *cpu);
 
-#ifdef TARGET_I386
-#define KVM_HAVE_MCE_INJECTION 1
+#ifdef KVM_HAVE_MCE_INJECTION
 void kvm_arch_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 #endif
 
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index 0b3036c..a8b7fb0 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -28,6 +28,10 @@
 /* ARM processors have a weak memory model */
 #define TCG_GUEST_DEFAULT_MO      (0)
 
+#ifdef TARGET_AARCH64
+#define KVM_HAVE_MCE_INJECTION 1
+#endif
+
 #define EXCP_UDEF            1   /* undefined instruction */
 #define EXCP_SWI             2   /* software interrupt */
 #define EXCP_PREFETCH_ABORT  3
diff --git a/target/arm/helper.c b/target/arm/helper.c
index 7d15d5c..12a95b6 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -3310,7 +3310,7 @@ static uint64_t do_ats_write(CPUARMState *env, uint64_t value,
              * Report exception with ESR indicating a fault due to a
              * translation table walk for a cache maintenance instruction.
              */
-            syn = syn_data_abort_no_iss(current_el == target_el,
+            syn = syn_data_abort_no_iss(current_el == target_el, 0,
                                         fi.ea, 1, fi.s1ptw, 1, fsc);
             env->exception.vaddress = value;
             env->exception.fsr = fsr;
diff --git a/target/arm/internals.h b/target/arm/internals.h
index 6d4a942..31b7b96 100644
--- a/target/arm/internals.h
+++ b/target/arm/internals.h
@@ -451,13 +451,14 @@ static inline uint32_t syn_insn_abort(int same_el, int ea, int s1ptw, int fsc)
         | ARM_EL_IL | (ea << 9) | (s1ptw << 7) | fsc;
 }
 
-static inline uint32_t syn_data_abort_no_iss(int same_el,
+static inline uint32_t syn_data_abort_no_iss(int same_el, int fnv,
                                              int ea, int cm, int s1ptw,
                                              int wnr, int fsc)
 {
     return (EC_DATAABORT << ARM_EL_EC_SHIFT) | (same_el << ARM_EL_EC_SHIFT)
            | ARM_EL_IL
-           | (ea << 9) | (cm << 8) | (s1ptw << 7) | (wnr << 6) | fsc;
+           | (fnv << 10) | (ea << 9) | (cm << 8) | (s1ptw << 7)
+           | (wnr << 6) | fsc;
 }
 
 static inline uint32_t syn_data_abort_with_iss(int same_el,
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index fb21ab9..f91b611 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -28,6 +28,8 @@
 #include "sysemu/kvm_int.h"
 #include "kvm_arm.h"
 #include "internals.h"
+#include "hw/acpi/acpi.h"
+#include "hw/acpi/ghes.h"
 
 static bool have_guest_debug;
 
@@ -846,6 +848,30 @@ int kvm_arm_cpreg_level(uint64_t regidx)
     return KVM_PUT_RUNTIME_STATE;
 }
 
+/* Callers must hold the iothread mutex lock */
+static void kvm_inject_arm_sea(CPUState *c)
+{
+    ARMCPU *cpu = ARM_CPU(c);
+    CPUARMState *env = &cpu->env;
+    CPUClass *cc = CPU_GET_CLASS(c);
+    uint32_t esr;
+    bool same_el;
+
+    c->exception_index = EXCP_DATA_ABORT;
+    env->exception.target_el = 1;
+
+    /*
+     * Set the DFSC to synchronous external abort and set FnV to not valid,
+     * this will tell guest the FAR_ELx is UNKNOWN for this abort.
+     */
+    same_el = arm_current_el(env) == env->exception.target_el;
+    esr = syn_data_abort_no_iss(same_el, 1, 0, 0, 0, 0, 0x10);
+
+    env->exception.syndrome = esr;
+
+    cc->do_interrupt(c);
+}
+
 #define AARCH64_CORE_REG(x)   (KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
                  KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(x))
 
@@ -1274,6 +1300,53 @@ int kvm_arch_get_registers(CPUState *cs)
     return ret;
 }
 
+void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
+{
+    ram_addr_t ram_addr;
+    hwaddr paddr;
+
+    assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
+
+    if (acpi_enabled && addr &&
+            object_property_get_bool(qdev_get_machine(), "ras", NULL)) {
+        ram_addr = qemu_ram_addr_from_host(addr);
+        if (ram_addr != RAM_ADDR_INVALID &&
+            kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            kvm_hwpoison_page_add(ram_addr);
+            /*
+             * If this is a BUS_MCEERR_AR, we know we have been called
+             * synchronously from the vCPU thread, so we can easily
+             * synchronize the state and inject an error.
+             *
+             * TODO: we currently don't tell the guest at all about
+             * BUS_MCEERR_AO. In that case we might either be being
+             * called synchronously from the vCPU thread, or a bit
+             * later from the main thread, so doing the injection of
+             * the error would be more complicated.
+             */
+            if (code == BUS_MCEERR_AR) {
+                kvm_cpu_synchronize_state(c);
+                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
+                    kvm_inject_arm_sea(c);
+                } else {
+                    error_report("failed to record the error");
+                    abort();
+                }
+            }
+            return;
+        }
+        if (code == BUS_MCEERR_AO) {
+            error_report("Hardware memory error at addr %p for memory used by "
+                "QEMU itself instead of guest system!", addr);
+        }
+    }
+
+    if (code == BUS_MCEERR_AR) {
+        error_report("Hardware memory error!");
+        exit(1);
+    }
+}
+
 /* C6.6.29 BRK instruction */
 static const uint32_t brk_insn = 0xd4200000;
 
diff --git a/target/arm/tlb_helper.c b/target/arm/tlb_helper.c
index e63f8bd..7388494 100644
--- a/target/arm/tlb_helper.c
+++ b/target/arm/tlb_helper.c
@@ -33,7 +33,7 @@ static inline uint32_t merge_syn_data_abort(uint32_t template_syn,
      * ISV field.
      */
     if (!(template_syn & ARM_EL_ISV) || target_el != 2 || s1ptw) {
-        syn = syn_data_abort_no_iss(same_el,
+        syn = syn_data_abort_no_iss(same_el, 0,
                                     ea, 0, s1ptw, is_write, fsc);
     } else {
         /*
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 576f309..69a2bb7 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -29,6 +29,8 @@
 /* The x86 has a strong memory model with some store-after-load re-ordering */
 #define TCG_GUEST_DEFAULT_MO      (TCG_MO_ALL & ~TCG_MO_ST_LD)
 
+#define KVM_HAVE_MCE_INJECTION 1
+
 /* Maximum instruction code size */
 #define TARGET_MAX_INSN_SIZE 16
 
-- 
1.8.3.1

