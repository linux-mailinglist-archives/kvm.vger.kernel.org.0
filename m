Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 070447C8BA2
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 18:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjJMQhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 12:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjJMQht (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 12:37:49 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A56BB
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 09:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1697215067; x=1728751067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lITbt8wLcF8MLZ70qObK0qVfyiYBGVzBj3ZnH/tQlvM=;
  b=jbH4ydodCHhsTjp49H88BPxCHmG0O6Y/jbOPbRn8FsfGAqKkTMss78zW
   JUVHQa2919xCmkvHdkAQYIZw0lczPBu0QaA5T+AF4stq01bB/J4sX2tGQ
   2oingWBPoFQtCQgB4jYEcCwTkKCAE0RDXm011j/dUM/2cdFu+noWOsgpu
   g=;
X-IronPort-AV: E=Sophos;i="6.03,222,1694736000"; 
   d="scan'208";a="361784857"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2023 16:37:43 +0000
Received: from EX19D014EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-1box-2bm6-32cf6363.us-west-2.amazon.com (Postfix) with ESMTPS id 657FA80F98;
        Fri, 13 Oct 2023 16:37:42 +0000 (UTC)
Received: from EX19D047EUB002.ant.amazon.com (10.252.61.57) by
 EX19D014EUA003.ant.amazon.com (10.252.50.119) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Fri, 13 Oct 2023 16:37:41 +0000
Received: from dev-dsk-mancio-1b-75107ff4.eu-west-1.amazon.com (172.19.77.28)
 by EX19D047EUB002.ant.amazon.com (10.252.61.57) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.37; Fri, 13 Oct 2023 16:37:38 +0000
From:   Riccardo Mancini <mancio@amazon.com>
To:     <vkuznets@redhat.com>
CC:     <bataloe@amazon.com>, <graf@amazon.de>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>, Riccardo Mancini <mancio@amazon.com>,
        Greg Farrell <gffarre@amazon.com>
Subject: [RFC PATCH 4.14] KVM: x86: Backport support for interrupt-based APF page-ready delivery in guest
Date:   Fri, 13 Oct 2023 16:36:40 +0000
Message-ID: <20231013163640.14162-1-mancio@amazon.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <877co1cc5d.fsf@redhat.com>
References: <877co1cc5d.fsf@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.77.28]
X-ClientProxiedBy: EX19D035UWB002.ant.amazon.com (10.13.138.97) To
 EX19D047EUB002.ant.amazon.com (10.252.61.57)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hey Vitaly,

thanks for your suggestion!
I've backported the guest-side of the patchset to 4.14.326, could you help
us and take a look at the backport?
I only backported the original patchset, I'm not sure if there's any
other patch (bug fix) that needs to be included in the backpotrt.
We've tested it in our environment and it gets rid of the performance
regression when running on 5.10 host, with no detected functional issue,
either on 4.14 or on 5.10.
I don't think the 4.14 stable tree accepts any patch that adds a feature
like this one, but we're looking into downstreaming it.
This patch might also be useful to somebody else hitting our same issue.

Thanks,
Riccardo

Commit follows:

This patch backports support for interrupt-based delivery of Async Page
Fault notifications in KVM guests from commit b1d405751cd5 ("KVM: x86:
Switch KVM guest to using interrupts for page ready APF delivery") [1].

Differently from the patchet upstream, this patch does not remove
support for the legacy #PF-based delivery, and removes unnecessary
refactoring to limit changes to KVM guest code.

[1] https://lore.kernel.org/kvm/20200525144125.143875-1-vkuznets@redhat.com/

Reviewed-by: Eugene Batalov <bataloe@amazon.com>
Reviewed-by: Greg Farrell <gffarre@amazon.com>
Signed-off-by: Riccardo Mancini <mancio@amazon.com>

---
 arch/x86/entry/entry_32.S            |  5 ++++
 arch/x86/entry/entry_64.S            |  5 ++++
 arch/x86/include/asm/hardirq.h       |  2 +-
 arch/x86/include/asm/kvm_para.h      |  7 +++++
 arch/x86/include/uapi/asm/kvm_para.h | 16 ++++++++++-
 arch/x86/kernel/irq.c                |  2 +-
 arch/x86/kernel/kvm.c                | 42 +++++++++++++++++++++++-----
 7 files changed, 69 insertions(+), 10 deletions(-)

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
index 5853eb50138e..50390628342d 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -267,26 +267,46 @@ dotraplinkage void
 do_async_page_fault(struct pt_regs *regs, unsigned long error_code)
 {
 	enum ctx_state prev_state;
+	u32 reason = kvm_read_and_reset_pf_reason();
 
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
+	} else if (reason & KVM_PV_REASON_PAGE_READY) {
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
@@ -344,6 +364,11 @@ static void kvm_guest_cpu_init(void)
 		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_VMEXIT))
 			pa |= KVM_ASYNC_PF_DELIVERY_AS_PF_VMEXIT;
 
+		if (kvm_para_has_feature(KVM_FEATURE_ASYNC_PF_INT)) {
+			pa |= KVM_ASYNC_PF_DELIVERY_AS_INT;
+			wrmsrl(MSR_KVM_ASYNC_PF_INT, HYPERVISOR_CALLBACK_VECTOR);
+		}
+
 		wrmsrl(MSR_KVM_ASYNC_PF_EN, pa);
 		__this_cpu_write(apf_reason.enabled, 1);
 		printk(KERN_INFO"KVM setup async PF for cpu %d\n",
@@ -490,6 +515,9 @@ void __init kvm_guest_init(void)
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

