Return-Path: <kvm+bounces-4422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CABD81257B
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 03:48:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9878283173
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 02:48:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C011F6FB1;
	Thu, 14 Dec 2023 02:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="TLk6wGLM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8B8189
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:44 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id d75a77b69052e-42594f0ca09so38131671cf.0
        for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 18:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1702522063; x=1703126863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAar5i9/lcWjhhQPz6VKvLzxomcjdsaa1gOTUvqg6u0=;
        b=TLk6wGLM6TvHmadZf7aJXG+U6KiAZWelER7w7r8xDWhLZsfrtEb3uXe21PZA4x/ocy
         98YNchMd2lCMK+NTAa9zamqfOZSMBPRy36+UAjNUth+qyeq+s9NCFczgriXUohb68uee
         GIL/zo9W6j+qMCREL0hwvfMRydTBrA8QHGdH/qaWcv2JzHWbRjpXrTNhq5nWt6OYta93
         HhX25H+zgKGIuxCQywm29nH+pJLn2k0ED2Vz7ct/5wMU8AMOEJxxvMfkCoxeFrvu0/d6
         lh9VnWC5HjNyDddN7mrfGBLHC0g25yRhrsy0tF+gWte0nqV8/+3kmvDEDxwlAzGJ7IlW
         XpQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702522063; x=1703126863;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAar5i9/lcWjhhQPz6VKvLzxomcjdsaa1gOTUvqg6u0=;
        b=LUtHyP1O60gEyWH5oLS8YWRSQZFcxEcPmiK6Sr0VFv/X2pGApDW4LlIwV9aRuc93eM
         dJvvP+yLXk58kFMH609x+qqCkM6SNqcGbArYouyRF0YwIJxKPaRsv9SSz7Ih9DrYp9xZ
         7LT3tSxPQOL+x4ddWnCAbzDiz5bzauF0dZb0EEzpjm4kt/vG5EGj9TFBCfzOWHDkt8Um
         M7KLzNq4tcA3KidcAa+t8/AFB8h6jvlWHd7CeRt/Hh2wZjwCgQv/VBpYmNvOutYsppbO
         BdDqjSnTaPN61Ni+1VCPlraA2Sq5demIa7NEldJBy/oBwnSk4aOBmhwSQIiSHPiDQcnk
         7BCQ==
X-Gm-Message-State: AOJu0Yx9+HoSL9HsgKl2mw0R3eAP4G/r64dZa93hySBT+FveglSLfdN1
	7wSeTgzhR0yFd9Hyt9/C8f4Dfw==
X-Google-Smtp-Source: AGHT+IFGgq1THcmm+bd9GOJsDlZSeGvBOLxsyJq1Ep1X2Gc7vAduDsMkJsEoVLK7RPMLAoAHN2gtmw==
X-Received: by 2002:a05:622a:1308:b0:417:f85b:5a5a with SMTP id v8-20020a05622a130800b00417f85b5a5amr8227335qtk.5.1702522063178;
        Wed, 13 Dec 2023 18:47:43 -0800 (PST)
Received: from vinp3lin.lan (c-73-143-21-186.hsd1.vt.comcast.net. [73.143.21.186])
        by smtp.gmail.com with ESMTPSA id fh3-20020a05622a588300b00425b356b919sm4240208qtb.55.2023.12.13.18.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Dec 2023 18:47:42 -0800 (PST)
From: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>
To: Ben Segall <bsegall@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Daniel Bristot de Oliveira <bristot@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Wanpeng Li <wanpengli@tencent.com>
Cc: "Vineeth Pillai (Google)" <vineeth@bitbyteword.org>,
	Suleiman Souhlal <suleiman@google.com>,
	Masami Hiramatsu <mhiramat@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Joel Fernandes <joel@joelfernandes.org>
Subject: [RFC PATCH 7/8] sched/core: boost/unboost in guest scheduler
Date: Wed, 13 Dec 2023 21:47:24 -0500
Message-ID: <20231214024727.3503870-8-vineeth@bitbyteword.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231214024727.3503870-1-vineeth@bitbyteword.org>
References: <20231214024727.3503870-1-vineeth@bitbyteword.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RT or higher priority tasks in guest is considered a critical workload
and guest scheduler can request boost/unboost on a task switch and/or a
task wakeup. Also share the preempt status of guest vcpu with the host
so that host can take decision on boot/unboost.

CONFIG_TRACE_PREEMPT_TOGGLE is enabled for using the function
equivalent of preempt_count_{add,sub} to update the shared memory.
Another option is to update the preempt_count_{add,sub} macros, but
it will be more code churn and complex.

Boost request is lazy, but unboost request is synchronous.

Detect the feature in guest from cpuid flags and use the MSR to pass the
GPA of memory location for sharing scheduling information.

Co-developed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Vineeth Pillai (Google) <vineeth@bitbyteword.org>
---
 arch/x86/Kconfig                | 13 +++++
 arch/x86/include/asm/kvm_para.h |  7 +++
 arch/x86/kernel/kvm.c           | 16 ++++++
 include/linux/sched.h           | 21 ++++++++
 kernel/entry/common.c           |  9 ++++
 kernel/sched/core.c             | 93 ++++++++++++++++++++++++++++++++-
 6 files changed, 158 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 68ce4f786dcd..556ae2698633 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -827,6 +827,19 @@ config KVM_GUEST
 	  underlying device model, the host provides the guest with
 	  timing infrastructure such as time of day, and system time
 
+config PARAVIRT_SCHED
+	bool "Enable paravirt scheduling capability for guests"
+	depends on KVM_GUEST
+	select TRACE_PREEMPT_TOGGLE
+	help
+	  Paravirtualized scheduling facilitates the exchange of scheduling
+	  related information between the host and guest through shared memory,
+	  enhancing the efficiency of vCPU thread scheduling by the hypervisor.
+	  An illustrative use case involves dynamically boosting the priority of
+	  a vCPU thread when the guest is executing a latency-sensitive workload
+	  on that specific vCPU.
+	  This config enables paravirt scheduling in guest(VM).
+
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
 	prompt "Disable host haltpoll when loading haltpoll driver"
diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index 57bc74e112f2..3473dd2915b5 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -176,4 +176,11 @@ static __always_inline bool kvm_handle_async_pf(struct pt_regs *regs, u32 token)
 }
 #endif
 
+#ifdef CONFIG_PARAVIRT_SCHED
+static inline void kvm_pv_sched_notify_host(void)
+{
+	wrmsrl(MSR_KVM_PV_SCHED, ULLONG_MAX);
+}
+#endif
+
 #endif /* _ASM_X86_KVM_PARA_H */
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 526d4da3dcd4..5f96b228bdd5 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -377,6 +377,14 @@ static void kvm_guest_cpu_init(void)
 		wrmsrl(MSR_KVM_PV_EOI_EN, pa);
 	}
 
+#ifdef CONFIG_PARAVIRT_SCHED
+	if (pv_sched_enabled()) {
+		unsigned long pa = pv_sched_pa() | KVM_MSR_ENABLED;
+
+		wrmsrl(MSR_KVM_PV_SCHED, pa);
+	}
+#endif
+
 	if (has_steal_clock)
 		kvm_register_steal_time();
 }
@@ -832,6 +840,14 @@ static void __init kvm_guest_init(void)
 		alloc_intr_gate(HYPERVISOR_CALLBACK_VECTOR, asm_sysvec_kvm_asyncpf_interrupt);
 	}
 
+#ifdef CONFIG_PARAVIRT_SCHED
+	if (kvm_para_has_feature(KVM_FEATURE_PV_SCHED)) {
+		pr_info("KVM host has PV_SCHED!\n");
+		pv_sched_enable();
+	} else
+		pr_info("KVM host does not support PV_SCHED!\n");
+#endif
+
 #ifdef CONFIG_SMP
 	if (pv_tlb_flush_supported()) {
 		pv_ops.mmu.flush_tlb_multi = kvm_flush_tlb_multi;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index de7382f149cf..e740b1e8abe3 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2442,4 +2442,25 @@ static inline void sched_core_fork(struct task_struct *p) { }
 
 extern void sched_set_stop_task(int cpu, struct task_struct *stop);
 
+#ifdef CONFIG_PARAVIRT_SCHED
+DECLARE_STATIC_KEY_FALSE(__pv_sched_enabled);
+
+extern unsigned long pv_sched_pa(void);
+
+static inline bool pv_sched_enabled(void)
+{
+	return static_branch_unlikely(&__pv_sched_enabled);
+}
+
+static inline void pv_sched_enable(void)
+{
+	static_branch_enable(&__pv_sched_enabled);
+}
+
+extern bool pv_sched_vcpu_boosted(void);
+extern void pv_sched_boost_vcpu(void);
+extern void pv_sched_unboost_vcpu(void);
+extern void pv_sched_boost_vcpu_lazy(void);
+extern void pv_sched_unboost_vcpu_lazy(void);
+#endif
 #endif
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index be61332c66b5..fae56faac0b0 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -210,6 +210,15 @@ static void exit_to_user_mode_prepare(struct pt_regs *regs)
 	kmap_assert_nomap();
 	lockdep_assert_irqs_disabled();
 	lockdep_sys_exit();
+#ifdef CONFIG_PARAVIRT_SCHED
+	/*
+	 * Guest requests a boost when preemption is disabled but does not request
+	 * an immediate unboost when preemption is enabled back. There is a chance
+	 * that we are boosted here. Unboost if needed.
+	 */
+	if (pv_sched_enabled() && !task_is_realtime(current))
+		pv_sched_unboost_vcpu();
+#endif
 }
 
 /*
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b47f72b6595f..57f211f1b3d7 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -151,6 +151,71 @@ const_debug unsigned int sysctl_sched_nr_migrate = SCHED_NR_MIGRATE_BREAK;
 
 __read_mostly int scheduler_running;
 
+#ifdef CONFIG_PARAVIRT_SCHED
+#include <linux/kvm_para.h>
+
+DEFINE_STATIC_KEY_FALSE(__pv_sched_enabled);
+
+DEFINE_PER_CPU_DECRYPTED(struct pv_sched_data, pv_sched) __aligned(64);
+
+unsigned long pv_sched_pa(void)
+{
+	return slow_virt_to_phys(this_cpu_ptr(&pv_sched));
+}
+
+bool pv_sched_vcpu_boosted(void)
+{
+	return (this_cpu_read(pv_sched.boost_status) == VCPU_BOOST_BOOSTED);
+}
+
+void pv_sched_boost_vcpu_lazy(void)
+{
+	this_cpu_write(pv_sched.schedinfo.boost_req, VCPU_REQ_BOOST);
+}
+
+void pv_sched_unboost_vcpu_lazy(void)
+{
+	this_cpu_write(pv_sched.schedinfo.boost_req, VCPU_REQ_UNBOOST);
+}
+
+void pv_sched_boost_vcpu(void)
+{
+	pv_sched_boost_vcpu_lazy();
+	/*
+	 * XXX: there could be a race between the boost_status check
+	 *      and hypercall.
+	 */
+	if (this_cpu_read(pv_sched.boost_status) == VCPU_BOOST_NORMAL)
+		kvm_pv_sched_notify_host();
+}
+
+void pv_sched_unboost_vcpu(void)
+{
+	pv_sched_unboost_vcpu_lazy();
+	/*
+	 * XXX: there could be a race between the boost_status check
+	 *      and hypercall.
+	 */
+	if (this_cpu_read(pv_sched.boost_status) == VCPU_BOOST_BOOSTED &&
+			!preempt_count())
+		kvm_pv_sched_notify_host();
+}
+
+/*
+ * Share the preemption enabled/disabled status with host. This will not incur a
+ * VMEXIT and acts as a lazy boost/unboost mechanism - host will check this on
+ * the next VMEXIT for boost/unboost decisions.
+ * XXX: Lazy unboosting may allow cfs tasks to run on RT vcpu till next VMEXIT.
+ */
+static inline void pv_sched_update_preempt_status(bool preempt_disabled)
+{
+	if (pv_sched_enabled())
+		this_cpu_write(pv_sched.schedinfo.preempt_disabled, preempt_disabled);
+}
+#else
+static inline void pv_sched_update_preempt_status(bool preempt_disabled) {}
+#endif
+
 #ifdef CONFIG_SCHED_CORE
 
 DEFINE_STATIC_KEY_FALSE(__sched_core_enabled);
@@ -2070,6 +2135,19 @@ unsigned long get_wchan(struct task_struct *p)
 
 static inline void enqueue_task(struct rq *rq, struct task_struct *p, int flags)
 {
+#ifdef CONFIG_PARAVIRT_SCHED
+	/*
+	 * TODO: currently request for boosting remote vcpus is not implemented. So
+	 * we boost only if this enqueue happens for this cpu.
+	 * This is not a big problem though, target cpu gets an IPI and then gets
+	 * boosted by the host. Posted interrupts is an exception where target vcpu
+	 * will not get boosted immediately, but on the next schedule().
+	 */
+	if (pv_sched_enabled() && this_rq() == rq &&
+			sched_class_above(p->sched_class, &fair_sched_class))
+		pv_sched_boost_vcpu_lazy();
+#endif
+
 	if (!(flags & ENQUEUE_NOCLOCK))
 		update_rq_clock(rq);
 
@@ -5835,6 +5913,8 @@ static inline void preempt_latency_start(int val)
 #ifdef CONFIG_DEBUG_PREEMPT
 		current->preempt_disable_ip = ip;
 #endif
+		pv_sched_update_preempt_status(true);
+
 		trace_preempt_off(CALLER_ADDR0, ip);
 	}
 }
@@ -5867,8 +5947,10 @@ NOKPROBE_SYMBOL(preempt_count_add);
  */
 static inline void preempt_latency_stop(int val)
 {
-	if (preempt_count() == val)
+	if (preempt_count() == val) {
+		pv_sched_update_preempt_status(false);
 		trace_preempt_on(CALLER_ADDR0, get_lock_parent_ip());
+	}
 }
 
 void preempt_count_sub(int val)
@@ -6678,6 +6760,15 @@ static void __sched notrace __schedule(unsigned int sched_mode)
 	rq->last_seen_need_resched_ns = 0;
 #endif
 
+#ifdef CONFIG_PARAVIRT_SCHED
+	if (pv_sched_enabled()) {
+		if (sched_class_above(next->sched_class, &fair_sched_class))
+			pv_sched_boost_vcpu_lazy();
+		else if (next->sched_class == &fair_sched_class)
+			pv_sched_unboost_vcpu();
+	}
+#endif
+
 	if (likely(prev != next)) {
 		rq->nr_switches++;
 		/*
-- 
2.43.0


