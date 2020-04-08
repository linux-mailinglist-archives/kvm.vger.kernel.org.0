Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E05DA1A1B3C
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 07:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgDHFFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 01:05:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38234 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbgDHFFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 01:05:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852xa5179539;
        Wed, 8 Apr 2020 05:05:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=7Qqvi8ilezudja6Xt6TMpZeT8QAYzWIZNCTpskFpIKg=;
 b=PlrYMSP2h6k1ZitVeuybm/+AYAE+sB8vRMB0+kQOvow5oszNXceJgjEAAvFiIlmk8dfT
 43T9eS07CTuXT5UodAkvV/QFJS1fQXtS2c29x/cctBkqEX6jmAfoJcWHJC0DTzKAUQWR
 iUbfgYI6KmSYNMk70LnKGdaOG/+UOyrjPqDPs2t9xMboURdOeol/NYZGkwptOCiG14T0
 sbJWNxq07XmOG8CdPD29AbXQVHyC/cFAqZVn9RBzyVvGYcPANFGGd78XxPiAgZ4dOBxM
 VvAY06D+9EnXtAWkr8uALBZMh621nLJ+hx8OYkjVKw5z/RXOjk5BS3CqcxHaLinqXVoO jQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 3091mnh158-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03852gSb148301;
        Wed, 8 Apr 2020 05:05:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3091kgj7qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Apr 2020 05:05:35 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03855Xes022191;
        Wed, 8 Apr 2020 05:05:33 GMT
Received: from monad.ca.oracle.com (/10.156.75.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Apr 2020 22:05:33 -0700
From:   Ankur Arora <ankur.a.arora@oracle.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     peterz@infradead.org, hpa@zytor.com, jpoimboe@redhat.com,
        namit@vmware.com, mhiramat@kernel.org, jgross@suse.com,
        bp@alien8.de, vkuznets@redhat.com, pbonzini@redhat.com,
        boris.ostrovsky@oracle.com, mihai.carabas@oracle.com,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        virtualization@lists.linux-foundation.org,
        Ankur Arora <ankur.a.arora@oracle.com>
Subject: [RFC PATCH 25/26] x86/kvm: Guest support for dynamic hints
Date:   Tue,  7 Apr 2020 22:03:22 -0700
Message-Id: <20200408050323.4237-26-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200408050323.4237-1-ankur.a.arora@oracle.com>
References: <20200408050323.4237-1-ankur.a.arora@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9584 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 priorityscore=1501 bulkscore=0 adultscore=0
 impostorscore=0 phishscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004080037
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the hypervisor supports KVM_FEATURE_DYNAMIC_HINTS, then register a
callback vector (currently chosen to be HYPERVISOR_CALLBACK_VECTOR.)
The callback triggers on a change in the active hints which are
are exported via KVM CPUID in %ecx.

Trigger re-evaluation of KVM_HINTS based on change in their active
status.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig                |  1 +
 arch/x86/entry/entry_64.S       |  5 +++
 arch/x86/include/asm/kvm_para.h |  7 ++++
 arch/x86/kernel/kvm.c           | 58 ++++++++++++++++++++++++++++++---
 include/asm-generic/kvm_para.h  |  4 +++
 include/linux/kvm_para.h        |  5 +++
 6 files changed, 76 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e0629558b6b5..23b239d184fc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -810,6 +810,7 @@ config KVM_GUEST
 	select PARAVIRT_CLOCK
 	select ARCH_CPUIDLE_HALTPOLL
 	select PARAVIRT_RUNTIME
+	select X86_HV_CALLBACK_VECTOR
 	default y
 	---help---
 	  This option enables various optimizations for running under the KVM
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 0e9504fabe52..96b2a243c54f 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1190,6 +1190,11 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 	acrn_hv_callback_vector acrn_hv_vector_handler
 #endif
 
+#if IS_ENABLED(CONFIG_KVM_GUEST)
+apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
+	kvm_callback_vector kvm_do_callback
+#endif
+
 idtentry debug			do_debug		has_error_code=0	paranoid=1 shift_ist=IST_INDEX_DB ist_offset=DB_STACK_OFFSET
 idtentry int3			do_int3			has_error_code=0	create_gap=1
 idtentry stack_segment		do_stack_segment	has_error_code=1
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 9b4df6eaa11a..5a7ca5639c2e 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -88,11 +88,13 @@ static inline long kvm_hypercall4(unsigned int nr, unsigned long p1,
 bool kvm_para_available(void);
 unsigned int kvm_arch_para_features(void);
 unsigned int kvm_arch_para_hints(void);
+unsigned int kvm_arch_para_active_hints(void);
 void kvm_async_pf_task_wait(u32 token, int interrupt_kernel);
 void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
 void do_async_page_fault(struct pt_regs *regs, unsigned long error_code, unsigned long address);
+void kvm_callback_vector(struct pt_regs *regs);
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
@@ -121,6 +123,11 @@ static inline unsigned int kvm_arch_para_hints(void)
 	return 0;
 }
 
+static inline unsigned int kvm_arch_para_active_hints(void)
+{
+	return 0;
+}
+
 static inline u32 kvm_read_and_reset_pf_reason(void)
 {
 	return 0;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 1cb7eab805a6..163b7a7ec5f9 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -25,6 +25,8 @@
 #include <linux/nmi.h>
 #include <linux/swait.h>
 #include <linux/memory.h>
+#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <asm/timer.h>
 #include <asm/cpu.h>
 #include <asm/traps.h>
@@ -438,7 +440,7 @@ static void __init sev_map_percpu_data(void)
 static bool pv_tlb_flush_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
-		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
+		!kvm_para_has_active_hint(KVM_HINTS_REALTIME) &&
 		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
 }
 
@@ -463,7 +465,7 @@ static bool pv_ipi_supported(void)
 static bool pv_sched_yield_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
-		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
+		!kvm_para_has_active_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
 }
 
@@ -568,7 +570,7 @@ static void kvm_smp_send_call_func_ipi(const struct cpumask *mask)
 static void __init kvm_smp_prepare_cpus(unsigned int max_cpus)
 {
 	native_smp_prepare_cpus(max_cpus);
-	if (kvm_para_has_hint(KVM_HINTS_REALTIME))
+	if (kvm_para_has_active_hint(KVM_HINTS_REALTIME))
 		static_branch_disable(&virt_spin_lock_key);
 }
 
@@ -654,6 +656,13 @@ static bool kvm_pv_tlb(void)
 	return cond;
 }
 
+#ifdef CONFIG_PARAVIRT_RUNTIME
+static bool has_dynamic_hint;
+static void __init kvm_register_callback_vector(void);
+#else
+#define has_dynamic_hint false
+#endif /* CONFIG_PARAVIRT_RUNTIME */
+
 static void __init kvm_guest_init(void)
 {
 	int i;
@@ -674,6 +683,12 @@ static void __init kvm_guest_init(void)
 	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI))
 		apic_set_eoi_write(kvm_guest_apic_eoi_write);
 
+	if (IS_ENABLED(CONFIG_PARAVIRT_RUNTIME) &&
+	    kvm_para_has_feature(KVM_FEATURE_DYNAMIC_HINTS)) {
+		kvm_register_callback_vector();
+		has_dynamic_hint = true;
+	}
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_cpus = kvm_smp_prepare_cpus;
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
@@ -729,12 +744,27 @@ unsigned int kvm_arch_para_features(void)
 	return cpuid_eax(kvm_cpuid_base() | KVM_CPUID_FEATURES);
 }
 
+/*
+ * Universe of hints that's ever been given to this guest.
+ */
 unsigned int kvm_arch_para_hints(void)
 {
 	return cpuid_edx(kvm_cpuid_base() | KVM_CPUID_FEATURES);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_para_hints);
 
+/*
+ * Currently active set of hints. Reading can race with modifications.
+ */
+unsigned int kvm_arch_para_active_hints(void)
+{
+	if (has_dynamic_hint)
+		return cpuid_ecx(kvm_cpuid_base() | KVM_CPUID_FEATURES);
+	else
+		return kvm_arch_para_hints();
+}
+EXPORT_SYMBOL_GPL(kvm_arch_para_active_hints);
+
 static uint32_t __init kvm_detect(void)
 {
 	return kvm_cpuid_base();
@@ -878,7 +908,7 @@ static inline bool kvm_para_lock_ops(void)
 {
 	/* Does host kernel support KVM_FEATURE_PV_UNHALT? */
 	return kvm_para_has_feature(KVM_FEATURE_PV_UNHALT) &&
-		!kvm_para_has_hint(KVM_HINTS_REALTIME);
+		!kvm_para_has_active_hint(KVM_HINTS_REALTIME);
 }
 
 static bool kvm_pv_spinlock(void)
@@ -975,4 +1005,24 @@ void kvm_trigger_reprobe_cpuid(struct work_struct *work)
 
 	mutex_unlock(&text_mutex);
 }
+
+static DECLARE_WORK(trigger_reprobe, kvm_trigger_reprobe_cpuid);
+
+void __irq_entry kvm_do_callback(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+
+	irq_enter();
+	inc_irq_stat(irq_hv_callback_count);
+
+	schedule_work(&trigger_reprobe);
+	irq_exit();
+	set_irq_regs(old_regs);
+}
+
+static void __init kvm_register_callback_vector(void)
+{
+	alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, kvm_callback_vector);
+	wrmsrl(MSR_KVM_HINT_VECTOR, HYPERVISOR_CALLBACK_VECTOR);
+}
 #endif /* CONFIG_PARAVIRT_RUNTIME */
diff --git a/include/asm-generic/kvm_para.h b/include/asm-generic/kvm_para.h
index 728e5c5706c4..4a575299ad62 100644
--- a/include/asm-generic/kvm_para.h
+++ b/include/asm-generic/kvm_para.h
@@ -24,6 +24,10 @@ static inline unsigned int kvm_arch_para_hints(void)
 	return 0;
 }
 
+static inline unsigned int kvm_arch_para_active_hints(void)
+{
+	return 0;
+}
 static inline bool kvm_para_available(void)
 {
 	return false;
diff --git a/include/linux/kvm_para.h b/include/linux/kvm_para.h
index f23b90b02898..c98d3944d25a 100644
--- a/include/linux/kvm_para.h
+++ b/include/linux/kvm_para.h
@@ -14,4 +14,9 @@ static inline bool kvm_para_has_hint(unsigned int feature)
 {
 	return !!(kvm_arch_para_hints() & (1UL << feature));
 }
+
+static inline bool kvm_para_has_active_hint(unsigned int feature)
+{
+	return !!(kvm_arch_para_active_hints() & BIT(feature));
+}
 #endif /* __LINUX_KVM_PARA_H */
-- 
2.20.1

