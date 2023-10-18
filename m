Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249137CE048
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 16:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbjJROlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 10:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345105AbjJROlP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 10:41:15 -0400
Received: from smtp-fw-9105.amazon.com (smtp-fw-9105.amazon.com [207.171.188.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB34F12C
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 07:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697640073; x=1729176073;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IDGAueLIWMQ+6a3zkfx1ItLqoZd2Rt17kkdLzjudLzE=;
  b=sZrnL5jrbDoiLvPCQmRpddDP74J2lkjcPC1MMf3t8c2OWB7tXejPnW+9
   TDYCUl7d+MoXm4Qfjat4WHGpvYflN2LFBrmjTr6Y8ZqLoTZCLvINGOlta
   LHYPoo7GqcKGBWN1LNTjAhfAyiTZdkt2VKMvSwlAq5F4fcZyWKOLbKT1Y
   k=;
X-IronPort-AV: E=Sophos;i="6.03,235,1694736000"; 
   d="scan'208";a="679172963"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9105.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2023 14:40:56 +0000
Received: from smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev (iad7-ws-svc-p70-lb3-vlan3.iad.amazon.com [10.32.235.38])
        by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 06C08341355;
        Wed, 18 Oct 2023 14:40:53 +0000 (UTC)
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:28318]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.217:2525] with esmtp (Farcaster)
 id fc275e5c-d35e-48f6-882f-fafc7f9bbc39; Wed, 18 Oct 2023 14:40:53 +0000 (UTC)
X-Farcaster-Flow-ID: fc275e5c-d35e-48f6-882f-fafc7f9bbc39
Received: from EX19D047EUB002.ant.amazon.com (10.252.61.57) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Wed, 18 Oct 2023 14:40:52 +0000
Received: from dev-dsk-mancio-1b-75107ff4.eu-west-1.amazon.com (172.19.77.28)
 by EX19D047EUB002.ant.amazon.com (10.252.61.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Wed, 18 Oct 2023 14:40:49 +0000
From:   Riccardo Mancini <mancio@amazon.com>
To:     <vkuznets@redhat.com>, <pbonzini@redhat.com>
CC:     <graf@amazon.de>, <kvm@vger.kernel.org>,
        Riccardo Mancini <mancio@amazon.com>,
        Eugene Batalov <bataloe@amazon.com>,
        Greg Farrell <gffarre@amazon.com>
Subject: [RFC PATCH 4.14 v2] KVM: x86: Backport support for interrupt-based APF page-ready delivery in guest
Date:   Wed, 18 Oct 2023 14:40:16 +0000
Message-ID: <20231018144016.5635-1-mancio@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <87mswh7390.fsf@redhat.com>
References: <87mswh7390.fsf@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.77.28]
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D047EUB002.ant.amazon.com (10.252.61.57)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Vitaly, Paolo,

thank you both for the comments!
For visibility, here is the complete v2 patch with the additional safety 
check to avoid handling page ready notifications from #PF if async-pf-int 
is enabled.

Thanks,
Riccardo

Commit follows:

This patch backports support for interrupt-based delivery of Async Page
Fault notifications in KVM guests from commit b1d405751cd5 ("KVM: x86:
Switch KVM guest to using interrupts for page ready APF delivery") [1].

Differently from the patchet upstream, this patch does not remove
support for the legacy #PF-based delivery, and removes unnecessary
refactoring to limit changes to KVM guest code.

v2: add kvm_apf_int_enabled flag to prevent handling of PAGE_READY

[1] https://lore.kernel.org/kvm/20200525144125.143875-1-vkuznets@redhat.com/

Reviewed-by: Eugene Batalov <bataloe@amazon.com>
Reviewed-by: Greg Farrell <gffarre@amazon.com>
Signed-off-by: Riccardo Mancini <mancio@amazon.com>
---
 arch/x86/entry/entry_32.S            |  5 +++
 arch/x86/entry/entry_64.S            |  5 +++
 arch/x86/include/asm/hardirq.h       |  2 +-
 arch/x86/include/asm/kvm_para.h      |  7 ++++
 arch/x86/include/uapi/asm/kvm_para.h | 16 +++++++++-
 arch/x86/kernel/irq.c                |  2 +-
 arch/x86/kernel/kvm.c                | 48 ++++++++++++++++++++++++----
 7 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
index 1fdedb2eaef3..460eb7a9981e 100644
--- a/arch/x86/entry/entry_32.S
+++ b/arch/x86/entry/entry_32.S
@@ -896,6 +896,11 @@ BUILD_INTERRUPT3(hyperv_callback_vector, HYPERVISOR_CALLBACK_VECTOR,
 
 #endif /* CONFIG_HYPERV */
 
+#ifdef CONFIG_KVM_GUEST
+BUILD_INTERRUPT3(kvm_async_pf_vector, HYPERVISOR_CALLBACK_VECTOR,
+		 kvm_async_pf_intr)
+#endif
+
 ENTRY(page_fault)
 	ASM_CLAC
 	pushl	$do_page_fault
diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 1804ccf52d9b..545d911a2c9e 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1113,6 +1113,11 @@ apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
 	hyperv_callback_vector hyperv_vector_handler
 #endif /* CONFIG_HYPERV */
 
+#ifdef CONFIG_KVM_GUEST
+apicinterrupt3 HYPERVISOR_CALLBACK_VECTOR \
+	kvm_async_pf_vector kvm_async_pf_intr
+#endif
+
 idtentry debug			do_debug		has_error_code=0	paranoid=1 shift_ist=DEBUG_STACK
 idtentry int3			do_int3			has_error_code=0	create_gap=1
 idtentry stack_segment		do_stack_segment	has_error_code=1
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index 486c843273c4..75e51b7c9f50 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -37,7 +37,7 @@ typedef struct {
 #ifdef CONFIG_X86_MCE_AMD
 	unsigned int irq_deferred_error_count;
 #endif
-#if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
+#if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN) || defined(CONFIG_KVM_GUEST)
 	unsigned int irq_hv_callback_count;
 #endif
 } ____cacheline_aligned irq_cpustat_t;
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index c373e44049b1..f4806dd3c38d 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -4,6 +4,7 @@
 
 #include <asm/processor.h>
 #include <asm/alternative.h>
+#include <linux/interrupt.h>
 #include <uapi/asm/kvm_para.h>
 
 extern void kvmclock_init(void);
@@ -94,6 +95,12 @@ void kvm_async_pf_task_wake(u32 token);
 u32 kvm_read_and_reset_pf_reason(void);
 extern void kvm_disable_steal_time(void);
 
+extern __visible void kvm_async_pf_vector(void);
+#ifdef CONFIG_TRACING
+#define trace_kvm_async_pf_vector kvm_async_pf_vector
+#endif
+__visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs);
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init kvm_spinlock_init(void);
 #else /* !CONFIG_PARAVIRT_SPINLOCKS */
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 341db0462b85..29b86e9adc9a 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -26,6 +26,8 @@
 #define KVM_FEATURE_PV_EOI		6
 #define KVM_FEATURE_PV_UNHALT		7
 #define KVM_FEATURE_ASYNC_PF_VMEXIT	10
+#define KVM_FEATURE_ASYNC_PF_INT	14
+#define KVM_FEATURE_MSI_EXT_DEST_ID	15
 
 /* The last 8 bits are used to indicate how to interpret the flags field
  * in pvclock structure. If no bits are set, all flags are ignored.
@@ -42,6 +44,8 @@
 #define MSR_KVM_ASYNC_PF_EN 0x4b564d02
 #define MSR_KVM_STEAL_TIME  0x4b564d03
 #define MSR_KVM_PV_EOI_EN      0x4b564d04
+#define MSR_KVM_ASYNC_PF_INT	0x4b564d06
+#define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 
 struct kvm_steal_time {
 	__u64 steal;
@@ -70,6 +74,11 @@ struct kvm_clock_pairing {
 #define KVM_ASYNC_PF_ENABLED			(1 << 0)
 #define KVM_ASYNC_PF_SEND_ALWAYS		(1 << 1)
 #define KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT	(1 << 2)
+#define KVM_ASYNC_PF_DELIVERY_AS_INT		(1 << 3)
+
+/* MSR_KVM_ASYNC_PF_INT */
+#define KVM_ASYNC_PF_VEC_MASK			GENMASK(7, 0)
+
 
 /* Operations for KVM_HC_MMU_OP */
 #define KVM_MMU_OP_WRITE_PTE            1
@@ -101,8 +110,13 @@ struct kvm_mmu_op_release_pt {
 #define KVM_PV_REASON_PAGE_READY 2
 
 struct kvm_vcpu_pv_apf_data {
+	/* Used for 'page not present' events delivered via #PF */
 	__u32 reason;
-	__u8 pad[60];
+
+	/* Used for 'page ready' events delivered via interrupt notification */
+	__u32 token;
+
+	__u8 pad[56];
 	__u32 enabled;
 };
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index fbcc303fb1f9..d1def86b66bd 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -134,7 +134,7 @@ int arch_show_interrupts(struct seq_file *p, int prec)
 		seq_printf(p, "%10u ", per_cpu(mce_poll_count, j));
 	seq_puts(p, "  Machine check polls\n");
 #endif
-#if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN)
+#if IS_ENABLED(CONFIG_HYPERV) || defined(CONFIG_XEN) || defined(CONFIG_KVM_GUEST)
 	if (test_bit(HYPERVISOR_CALLBACK_VECTOR, used_vectors)) {
 		seq_printf(p, "%*s: ", prec, "HYP");
 		for_each_online_cpu(j)
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 5853eb50138e..12e5fddb6da1 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -79,6 +79,8 @@ static DEFINE_PER_CPU(struct kvm_vcpu_pv_apf_data, apf_reason) __aligned(64);
 static DEFINE_PER_CPU(struct kvm_steal_time, steal_time) __aligned(64);
 static int has_steal_clock = 0;
 
+static DEFINE_PER_CPU(u32, kvm_apf_int_enabled);
+
 /*
  * No need for any "IO delay" on KVM
  */
@@ -267,26 +269,48 @@ dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	u32 reason = kvm_read_and_reset_pf_reason();
+	u32 handle_page_ready = !__this_cpu_read(kvm_apf_int_enabled);
 
-	switch (kvm_read_and_reset_pf_reason()) {
-	default:
+	if (!reason) {
+		/* This is a normal page fault */
 		do_page_fault(regs, error_code);
-		break;
-	case KVM_PV_REASON_PAGE_NOT_PRESENT:
+	} else if (reason & KVM_PV_REASON_PAGE_NOT_PRESENT) {
 		/* page is swapped out by the host. */
 		prev_state = exception_enter();
 		kvm_async_pf_task_wait((u32)read_cr2(), !user_mode(regs));
 		exception_exit(prev_state);
-		break;
-	case KVM_PV_REASON_PAGE_READY:
+	} else if (handle_page_ready && (reason & KVM_PV_REASON_PAGE_READY)) {
+		/* possible only if interrupt-based mechanism is disabled */
 		rcu_irq_enter();
 		kvm_async_pf_task_wake((u32)read_cr2());
 		rcu_irq_exit();
-		break;
+	} else {
+		WARN_ONCE(1, "Unexpected async PF flags: %x\n", reason);
 	}
 }
 NOKPROBE_SYMBOL(do_async_page_fault);
 
+__visible void __irq_entry kvm_async_pf_intr(struct pt_regs *regs)
+{
+	u32 token;
+
+	entering_ack_irq();
+
+	inc_irq_stat(irq_hv_callback_count);
+
+	if (__this_cpu_read(apf_reason.enabled)) {
+		token = __this_cpu_read(apf_reason.token);
+		rcu_irq_enter();
+		kvm_async_pf_task_wake(token);
+		rcu_irq_exit();
+		__this_cpu_write(apf_reason.token, 0);
+		wrmsrl(MSR_KVM_ASYNC_PF_ACK, 1);
+	}
+
+	exiting_irq();
+}
+
 static void __init paravirt_ops_setup(void)
 {
 	pv_info.name = "KVM";
@@ -344,6 +368,12 @@ static void kvm_guest_cpu_init(void)
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
 			pa |= KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
+		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT)) {
+			pa |= KVM_ASYNC_PF_DELIVERY_AS_INT;
+			wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
+			__this_cpu_write(kvm_apf_int_enabled, 1);
+		}
+
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
 		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
@@ -371,6 +401,7 @@ static void kvm_pv_disable_apf(void)
 
 	wrmsrl(MSR_KVM_ASYNC_PF_EN, 0);
 	__this_cpu_write(apf_reason.enabled, 0);
+	__this_cpu_write(kvm_apf_int_enabled, 0);
 
 	printk(KERN_INFO"Unregister pv shared memory for cpu %d\n",
 	       smp_processor_id());
@@ -490,6 +521,9 @@ void __init kvm_guest_init(void)
 	if (kvmclock_vsyscall)
 		kvm_setup_vsyscall_timeinfo();
 
+	if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT) && kvmapf)
+		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, kvm_async_pf_vector);
+
 #ifdef CONFIG_SMP
 	smp_ops.smp_prepare_boot_cpu = kvm_smp_prepare_boot_cpu;
 	if (cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN, "x86/kvm:online",
-- 
2.40.1

