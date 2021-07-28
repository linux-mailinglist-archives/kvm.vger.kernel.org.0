Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 888E33D88F3
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 09:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbhG1HiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 03:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234989AbhG1HiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 03:38:10 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1B3C061765
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 00:38:08 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 16-20020a250b100000b029055791ebe1e6so1832454ybl.20
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 00:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ItxvmoLzr9xs5I3liCyTAjxxyvxuLujT+yI95nIWpZY=;
        b=DkPi2Ql28sQkGvARBAJvXqfU1qpWOQYKc4ib5YPERVuQiTJUcT2g0VvAJFGcO4bVKj
         NbHwenzOGa+HscRVRylED4keNy1wA5ONDxPHhZpCs8KH6YPs+HcWi+sXkZ4TZyUGvowR
         YwtM6jpAnmi+nGAtT21qI68cz9g+aP7SlEFffJUNqqUGrcGg2TdZN/5p1Ps3UVmOBjsc
         ibRqPqqDT8lRNvW7+ZKz87mx5cXRN6fBDLZiRapsM/uoXsgpBxUNtbYc9YtsyNG1fTlf
         dDEaam7VDlNynO7QT4aVxmYpiwU7BBRnQ/cxXeHTN5IdK6d6lacVUNNnWqa0j6HlpCey
         TJkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ItxvmoLzr9xs5I3liCyTAjxxyvxuLujT+yI95nIWpZY=;
        b=lfy9xyPRjJy/0H//5KoVhw/uqY6J3Kaj90ibDImPVtz/Tfos5CJlngQWlAH93MzTjF
         kBeFtqXQIWH6iW3Ij0HBT+2h03oDq4o83bK9/yTosBitEYHdXE90hTmqx+ca6Q+mLccK
         fA+vZTOJ4bU/r8y1as0oAA26RnQNf7pz1zGPSVVBA7rTlFD+rwYIh4YHatmGMLJIcFNe
         Xdm+qa4clxjbe9Xf8vRTA+b/6/nhhMZ4zQfPxpHzeBGAXRrumghTWPf+3PVf5eNZFXhZ
         13uKFZRTTM5e9+u8PBKdpO0LxhjYXMMCs9XK7GBJwRkLYylDM8HW/5dE0Q2BG/tdBHh0
         PiIA==
X-Gm-Message-State: AOAM530WCNdYEp9jOM1oKxoy4iwanv+R/90wa81yOPYE4QY/Vh5ZCcKa
        exlCEAJumQidHQeSuyNLc2aOsvjrCJDDZQ==
X-Google-Smtp-Source: ABdhPJz4akmaSv8b4mgk8pewn6kzM1YlgZ1n9KlBmowZhLkQCZcPEguLjpYHXYDn3hNQiXFMkO+TuC0dmIC12w==
X-Received: from suleiman1.tok.corp.google.com ([2401:fa00:8f:203:44f4:48a1:aec5:6e5b])
 (user=suleiman job=sendgmr) by 2002:a25:d312:: with SMTP id
 e18mr20220036ybf.14.1627457888130; Wed, 28 Jul 2021 00:38:08 -0700 (PDT)
Date:   Wed, 28 Jul 2021 16:36:59 +0900
In-Reply-To: <20210728073700.120449-1-suleiman@google.com>
Message-Id: <20210728073700.120449-2-suleiman@google.com>
Mime-Version: 1.0
References: <20210728073700.120449-1-suleiman@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [RFC PATCH 1/2] kvm,x86: Support heterogeneous RT VCPU configurations.
From:   Suleiman Souhlal <suleiman@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Cc:     ssouhlal@FreeBSD.org, joelaf@google.com, senozhatsky@chromium.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When CONFIG_KVM_HETEROGENEOUS_RT is enabled, it is possible to use a
RT VCPU without getting hundreds of milliseconds of latency spikes
when the RT VCPU preempts another VCPU that's holding a lock.
The guest needs to have preempt_count reporting enabled.

We achieve this by preventing non-RT VCPUs from getting preempted if
they are in a critical section, which we define as having non-zero
preempt_count or interrupts disabled. This avoids the priority inversion
of a RT VCPU preempting another VCPU that is holding a lock that it
wants.

On a machine with 2 CPU threads, creating a VM with 3 VCPUs and making
VCPU 2 RT in the host (and preventing most tasks from running on it by
using "isolcpus"), the max latency shown by
"/data/local/tmp/cyclictest -l100000 -m -Sp90 -i1000 -q -n" in the guest
for VCPU2 never exceeds 4ms (and is often < 1ms) in my tests, even when
the host CPUs are overloaded by running something like
"for i in `seq 8`; do yes > /dev/null & done".
Without these changes, the max latency would often get in the hundreds
of milliseconds.

Signed-off-by: Suleiman Souhlal <suleiman@google.com>
---
 arch/x86/include/asm/kvm_host.h      |  7 +++
 arch/x86/include/uapi/asm/kvm_para.h |  2 +
 arch/x86/kvm/Kconfig                 | 13 ++++++
 arch/x86/kvm/cpuid.c                 |  3 ++
 arch/x86/kvm/vmx/vmx.c               | 15 ++++++
 arch/x86/kvm/x86.c                   | 70 +++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h                   |  2 +
 include/linux/kvm_host.h             |  4 ++
 include/linux/preempt.h              |  7 +++
 kernel/sched/core.c                  | 30 ++++++++++++
 virt/kvm/Kconfig                     |  3 ++
 virt/kvm/kvm_main.c                  | 13 ++++++
 12 files changed, 168 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 974cbfb1eefe..a8a2ceb870d2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -836,6 +836,13 @@ struct kvm_vcpu_arch {
 
 	u64 msr_kvm_poll_control;
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	bool preempt_count_enabled;
+	bool may_boost;
+	int boost;
+	struct gfn_to_hva_cache preempt_count_g2h;
+#endif
+
 	/*
 	 * Indicates the guest is trying to write a gfn that contains one or
 	 * more of the PTEs used to translate the write itself, i.e. the access
diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
index 5146bbab84d4..4534dcb05229 100644
--- a/arch/x86/include/uapi/asm/kvm_para.h
+++ b/arch/x86/include/uapi/asm/kvm_para.h
@@ -35,6 +35,7 @@
 #define KVM_FEATURE_MSI_EXT_DEST_ID	15
 #define KVM_FEATURE_HC_MAP_GPA_RANGE	16
 #define KVM_FEATURE_MIGRATION_CONTROL	17
+#define KVM_FEATURE_PREEMPT_COUNT	18
 
 #define KVM_HINTS_REALTIME      0
 
@@ -57,6 +58,7 @@
 #define MSR_KVM_ASYNC_PF_INT	0x4b564d06
 #define MSR_KVM_ASYNC_PF_ACK	0x4b564d07
 #define MSR_KVM_MIGRATION_CONTROL	0x4b564d08
+#define MSR_KVM_PREEMPT_COUNT	0x4b564d09
 
 struct kvm_steal_time {
 	__u64 steal;
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ac69894eab88..20716814376e 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -129,4 +129,17 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+
+config KVM_HETEROGENEOUS_RT
+	bool "Support for heterogeneous real-time VCPU configurations"
+	depends on KVM
+	select HAVE_KVM_MAY_PREEMPT
+	help
+	 Allows some VCPUs to be real-time. Without this option, if some
+	 VCPUs are real-time while others are not, extremely long latencies
+	 might be experienced. Needs guest with CONFIG_PREEMPT_COUNT_REPORTING
+	 enabled.
+
+	 If in doubt, say "N".
+
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 739be5da3bca..ea78faad8adc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -910,6 +910,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+			     (1 << KVM_FEATURE_PREEMPT_COUNT) |
+#endif
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
 		if (sched_info_on())
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..b2eedcd4d16e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6750,6 +6750,21 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	trace_kvm_exit(vmx->exit_reason.full, vcpu, KVM_ISA_VMX);
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	vcpu->arch.may_boost = 0;
+	if (vmx->exit_reason.basic == EXIT_REASON_EXTERNAL_INTERRUPT ||
+	    vmx->exit_reason.basic == EXIT_REASON_PREEMPTION_TIMER ||
+	    vmx->exit_reason.basic == EXIT_REASON_MSR_WRITE) {
+		/*
+		 * Boost when MSR write when sending IPI for function call,
+		 * otherwise the sending cpu might not be able to release lock
+		 * and the destination cpu will not be able to progress.
+		 */
+		if (kvm_vcpu_dont_preempt(vcpu))
+			vcpu->arch.may_boost = 1;
+	}
+#endif
+
 	if (unlikely(vmx->exit_reason.failed_vmentry))
 		return EXIT_FASTPATH_NONE;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a4fd10604f72..c18ea8d136a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1355,6 +1355,9 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	MSR_KVM_PREEMPT_COUNT,
+#endif
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSC_DEADLINE,
@@ -3439,7 +3442,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (kvm_lapic_enable_pv_eoi(vcpu, data, sizeof(u8)))
 			return 1;
 		break;
-
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	case MSR_KVM_PREEMPT_COUNT:
+		vcpu->arch.preempt_count_enabled = 0;
+		if (!(data & KVM_MSR_ENABLED))
+			break;
+		if (!kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		    &vcpu->arch.preempt_count_g2h, data & ~KVM_MSR_ENABLED,
+		    sizeof(int)))
+			vcpu->arch.preempt_count_enabled = 1;
+		break;
+#endif
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
 			return 1;
@@ -9684,6 +9697,17 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_enable();
 	preempt_enable();
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	/*
+	 * Boosted VCPU is no longer in critical section, so we can yield
+	 * back the cpu.
+	 */
+	if (vcpu->arch.boost && !vcpu->arch.may_boost) {
+		vcpu->arch.boost = 0;
+		schedule();
+	}
+#endif
+
 	vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 
 	/*
@@ -9757,6 +9781,26 @@ static inline bool kvm_vcpu_running(struct kvm_vcpu *vcpu)
 		!vcpu->arch.apf.halted);
 }
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+int
+kvm_vcpu_dont_preempt(struct kvm_vcpu *vcpu)
+{
+	int count, ret;
+
+	if (!vcpu->arch.preempt_count_enabled)
+		return 0;
+
+	pagefault_disable();
+	ret = kvm_read_guest_cached(vcpu->kvm, &vcpu->arch.preempt_count_g2h,
+	    &count, sizeof(int));
+	pagefault_enable();
+	if (likely(!ret))
+		return count & ~PREEMPT_NEED_RESCHED || !(kvm_get_rflags(vcpu) &
+		    X86_EFLAGS_IF);
+	return 0;
+}
+#endif /* CONFIG_KVM_HETEROGENEOUS_RT */
+
 static int vcpu_run(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -10705,6 +10749,11 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	vcpu->arch.boost = 0;
+	vcpu->arch.may_boost = 0;
+#endif
+
 	r = static_call(kvm_x86_vcpu_create)(vcpu);
 	if (r)
 		goto free_guest_fpu;
@@ -11066,6 +11115,10 @@ void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
 		kvm_make_request(KVM_REQ_PMU, vcpu);
 	}
 	static_call(kvm_x86_sched_in)(vcpu, cpu);
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	vcpu->arch.boost = 0;
+	vcpu->arch.may_boost = 0;
+#endif
 }
 
 void kvm_arch_free_vm(struct kvm *kvm)
@@ -11074,6 +11127,21 @@ void kvm_arch_free_vm(struct kvm *kvm)
 	vfree(kvm);
 }
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+#define	MAX_BOOSTS 5
+
+bool
+kvm_arch_may_preempt(struct kvm_vcpu *vcpu, struct task_struct *prev)
+{
+	/*
+	 * Limit the maximum number of times we can get boosted to prevent
+	 * livelock.
+	 */
+	if (vcpu->arch.may_boost && vcpu->arch.boost++ < MAX_BOOSTS)
+		return false;
+	return true;
+}
+#endif
 
 int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 {
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 44ae10312740..2954340ed258 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -486,4 +486,6 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+int kvm_vcpu_dont_preempt(struct kvm_vcpu *vcpu);
+
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ae7735b490b4..4d40152a6692 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1695,4 +1695,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
+bool kvm_arch_may_preempt(struct kvm_vcpu *vcpu, struct task_struct *prev);
+#endif /* CONFIG_HAVE_KVM_MAY_PREEMPT */
+
 #endif
diff --git a/include/linux/preempt.h b/include/linux/preempt.h
index 9881eac0698f..12fcfdd6b825 100644
--- a/include/linux/preempt.h
+++ b/include/linux/preempt.h
@@ -290,6 +290,9 @@ struct preempt_notifier;
  * @sched_out: we've just been preempted
  *    notifier: struct preempt_notifier for the task being preempted
  *    next: the task that's kicking us out
+ * @may_preempt: is it ok to preempt us?
+ *    notifier: struct preempt_notifier for the task being scheduled
+ *    prev: our task
  *
  * Please note that sched_in and out are called under different
  * contexts.  sched_out is called with rq lock held and irq disabled
@@ -300,6 +303,10 @@ struct preempt_ops {
 	void (*sched_in)(struct preempt_notifier *notifier, int cpu);
 	void (*sched_out)(struct preempt_notifier *notifier,
 			  struct task_struct *next);
+#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
+	bool (*may_preempt)(struct preempt_notifier *notifier,
+	    struct task_struct *prev);
+#endif
 };
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2d9ff40f4661..337265e208a5 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4293,6 +4293,21 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 		__fire_sched_out_preempt_notifiers(curr, next);
 }
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+static bool
+fire_may_preempt_notifiers(struct task_struct *prev)
+{
+	struct preempt_notifier *notifier;
+
+	if (static_branch_unlikely(&preempt_notifier_key))
+		hlist_for_each_entry(notifier, &prev->preempt_notifiers, link)
+			if (notifier->ops->may_preempt &&
+			    !notifier->ops->may_preempt(notifier, prev))
+				return false;
+	return true;
+}
+#endif
+
 #else /* !CONFIG_PREEMPT_NOTIFIERS */
 
 static inline void fire_sched_in_preempt_notifiers(struct task_struct *curr)
@@ -4305,6 +4320,12 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 {
 }
 
+static inline bool
+fire_may_preempt_notifiers(struct task_struct *curr)
+{
+	return true;
+}
+
 #endif /* CONFIG_PREEMPT_NOTIFIERS */
 
 static inline void prepare_task(struct task_struct *next)
@@ -5833,6 +5854,15 @@ static void __sched notrace __schedule(bool preempt)
 	if (sched_feat(HRTICK) || sched_feat(HRTICK_DL))
 		hrtick_clear(rq);
 
+#ifdef CONFIG_KVM_HETEROGENEOUS_RT
+	if (prev->__state == TASK_RUNNING && prev->sched_class !=
+	    &rt_sched_class && !fire_may_preempt_notifiers(prev)) {
+		clear_tsk_need_resched(prev);
+		clear_preempt_need_resched();
+		return;
+	}
+#endif
+
 	local_irq_disable();
 	rcu_note_context_switch(preempt);
 
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index 62b39149b8c8..e4a5ee7a231c 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -66,3 +66,6 @@ config KVM_XFER_TO_GUEST_WORK
 
 config HAVE_KVM_PM_NOTIFIER
        bool
+
+config HAVE_KVM_MAY_PREEMPT
+	bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 986959833d70..d609a7b41497 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5313,6 +5313,16 @@ static void check_processor_compat(void *data)
 	*c->ret = kvm_arch_check_processor_compat(c->opaque);
 }
 
+#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
+static bool
+kvm_may_preempt(struct preempt_notifier *pn, struct task_struct *prev)
+{
+	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);
+
+	return kvm_arch_may_preempt(vcpu, prev);
+}
+#endif
+
 int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 		  struct module *module)
 {
@@ -5391,6 +5401,9 @@ int kvm_init(void *opaque, unsigned vcpu_size, unsigned vcpu_align,
 
 	kvm_preempt_ops.sched_in = kvm_sched_in;
 	kvm_preempt_ops.sched_out = kvm_sched_out;
+#ifdef CONFIG_HAVE_KVM_MAY_PREEMPT
+	kvm_preempt_ops.may_preempt = kvm_may_preempt;
+#endif
 
 	kvm_init_debug();
 
-- 
2.32.0.432.gabb21c7263-goog

