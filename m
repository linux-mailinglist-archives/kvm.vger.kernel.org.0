Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2201434ACA
	for <lists+kvm@lfdr.de>; Wed, 20 Oct 2021 14:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhJTMHi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Oct 2021 08:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhJTMHf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Oct 2021 08:07:35 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1D5C061769
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:05:19 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q5so22309285pgr.7
        for <kvm@vger.kernel.org>; Wed, 20 Oct 2021 05:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=W0/hAItlN4jumE3bXtgyJTFeomKZFRmDDJAfP2T9OV0=;
        b=LiB0botG46s85lJShFIjIEdGtGJ/XTL2dN4M+c0BCZDWGdKgAAvj5HVDVxjwOga1Ct
         J72JmsM5HiGYoSFvtIKkMbA5u1W/H/ajHQWlVRlzsUdJ9hApUlPml5WIgGNKdDTI38rW
         AKhE/8iLPYbdrFNWW3SWe8NUzdkFajh/e1f/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W0/hAItlN4jumE3bXtgyJTFeomKZFRmDDJAfP2T9OV0=;
        b=krgBdqa3HxUPxR1OFyj2G0tuIAiL1vgO9DTA7D5SC2u5Dg7roGUbEJhmHhttlnjM8p
         TTkf1WP5dmj/bu0HTvit0EwWrnCpTuhc37wckWKDT8+q1hs63h/scOFs4ZM7CjHULNOi
         W9joyLTRoQsSpAFGY0yxk1tpRfyA4cpcHGgDIxKuVs6KBi4Ib/5NdOcUyZWeI4YufH+o
         fSJjSqvzpdKhfi5/tuPPiwG2WV/8u6MZRYCq4rFsIarJuy/wqGU/dAft5ajZWdIuYeP1
         trW0NCx+mruuEFd1wL3dsjElrf7fVpmEtmd2sslSuOtnv0r6Rav17OQlc0pllNAN6VgR
         AN5Q==
X-Gm-Message-State: AOAM533Rt66APFa8Pt+6564pz8AyLwdP6z1LL/lf3u1L8OFVD5f+Ur2e
        BedgEpMYVYO+cJia0P/5Gz1jBQ==
X-Google-Smtp-Source: ABdhPJyehwX66T1GfBbIRkPa96YkjVy5nacylS+1zw5CnZZj/eF0uf6zuqh5HuXXG90EGK3hkTbsiw==
X-Received: by 2002:a62:3102:0:b0:44b:63db:fc88 with SMTP id x2-20020a623102000000b0044b63dbfc88mr6029199pfx.75.1634731519072;
        Wed, 20 Oct 2021 05:05:19 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:e516:d575:e6f:a526])
        by smtp.gmail.com with UTF8SMTPSA id a12sm5693553pjq.16.2021.10.20.05.05.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 05:05:18 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com, linux@roeck-us.net, pbonzini@redhat.com,
        vkuznets@redhat.com, maz@kernel.org, will@kernel.org
Cc:     suleiman@google.com, senozhatsky@google.com,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: [RFC PATCH v3 4/5] kvm/x86: virtual suspend time injection: Implement host side
Date:   Wed, 20 Oct 2021 21:04:29 +0900
Message-Id: <20211020210348.RFC.v3.4.I9c4e7c844507384b546e6d1ea1a5286996eed908@changeid>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211020120431.776494-1-hikalium@chromium.org>
References: <20211020120431.776494-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add main logics that adjust the guest's clocks and notify about the
suspension to the guest.

Adjustment flow:
- Before going into suspend, KVM_REQ_SUSPEND_TIME_ADJ will be
  requested for each vcpus through the PM notifier if the suspend time
  injection is enabled for the kvm.
- Before the first vmenter after the resume, each vcpu will check the
  the request and do two kinds of adjustments.
  - One is kvm-wide adjustment: kvm-clock will be adjusted to the value
    before the suspend.
  - Another is per-vcpu adjustment: tsc will be adjusted to the value
    before the suspend.
  - Those adjustments happen before the vcpu run: so the guest will not
    observe the "rewinding" of the clocks.
- After the adjustment is made, the guest will be notified about the
  adjustment through HYPERVISOR_CALLBACK_VECTOR IRQ.
    - It is guest's responsibility to adjust their CLOCK_BOOTTIME and
      the wall clock to reflect the suspend.
      This will be done in the later patch.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

Changes in v3:
- Used PM notifier instead of modifying timekeeping_resume()
  - This avoids holding kvm_lock under interrupt disabled context.
- Used KVM_REQ_* to make a request for vcpus.
- Reused HYPERVISOR_CALLBACK_VECTOR IRQ instead of adding a new one.
- Extracted arch-independent parts.

 arch/x86/include/asm/kvm_host.h |   2 +
 arch/x86/kvm/Kconfig            |  13 ++++
 arch/x86/kvm/cpuid.c            |   4 ++
 arch/x86/kvm/x86.c              | 109 ++++++++++++++++++++++++++++++++
 include/linux/kvm_host.h        |  48 ++++++++++++++
 virt/kvm/kvm_main.c             |  88 ++++++++++++++++++++++++++
 6 files changed, 264 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f8f48a7ec577..bdff8f777632 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1085,6 +1085,8 @@ struct kvm_arch {
 	bool pause_in_guest;
 	bool cstate_in_guest;
 
+	u64 msr_suspend_time;
+
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
 	raw_spinlock_t tsc_write_lock;
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ac69894eab88..6d68a4d6be87 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -129,4 +129,17 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_VIRT_SUSPEND_TIMING
+	bool "Host support for virtual suspend time injection"
+	depends on KVM=y && HAVE_KVM_PM_NOTIFIER
+	default n
+	help
+	 This option makes the host's suspension reflected on the guest's clocks.
+	 In other words, guest's CLOCK_MONOTONIC will stop and
+	 CLOCK_BOOTTIME keeps running during the host's suspension.
+	 This feature will only be effective when both guest and host support
+	 this feature. For the guest side, see KVM_VIRT_SUSPEND_TIMING_GUEST.
+
+	 If unsure, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 751aa85a3001..34a2fe147503 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -886,6 +886,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+		entry->eax |= (1 << KVM_FEATURE_HOST_SUSPEND_TIME);
+#endif
+
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index aabd3a2ec1bc..b6d0d7f73196 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1367,6 +1367,7 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
+	MSR_KVM_HOST_SUSPEND_TIME,
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSC_DEADLINE,
@@ -3467,6 +3468,19 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+	case MSR_KVM_HOST_SUSPEND_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HOST_SUSPEND_TIME))
+			return 1;
+
+		if (!(data & KVM_MSR_ENABLED))
+			break;
+
+		if (kvm_init_suspend_time_ghc(vcpu->kvm, data & ~1ULL))
+			return 1;
+
+		vcpu->kvm->arch.msr_suspend_time = data;
+		break;
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3785,6 +3799,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+	case MSR_KVM_HOST_SUSPEND_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HOST_SUSPEND_TIME))
+			return 1;
+
+		msr_info->data = vcpu->kvm->arch.msr_suspend_time;
+		break;
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -9392,6 +9412,93 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(__kvm_request_immediate_exit);
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+bool virt_suspend_time_enabled(struct kvm *kvm)
+{
+	return kvm->arch.msr_suspend_time & KVM_MSR_ENABLED;
+}
+
+/*
+ * Do per-vcpu suspend time adjustment (tsc) and
+ * make an interrupt to notify it.
+ */
+static void vcpu_do_suspend_time_adjustment(struct kvm_vcpu *vcpu,
+					    u64 total_ns)
+{
+	struct kvm_lapic_irq irq = {
+		.delivery_mode = APIC_DM_FIXED,
+		.vector = HYPERVISOR_CALLBACK_VECTOR
+	};
+	u64 last_suspend_duration = 0;
+	s64 adj;
+
+	spin_lock(&vcpu->suspend_time_ns_lock);
+	if (total_ns > vcpu->suspend_time_ns) {
+		last_suspend_duration = total_ns - vcpu->suspend_time_ns;
+		vcpu->suspend_time_ns = total_ns;
+	}
+	spin_unlock(&vcpu->suspend_time_ns_lock);
+
+	if (!last_suspend_duration) {
+		/* It looks like the suspend is not happened yet. Retry. */
+		kvm_make_request(KVM_REQ_SUSPEND_TIME_ADJ, vcpu);
+		return;
+	}
+
+	adj = __this_cpu_read(cpu_tsc_khz) *
+		(last_suspend_duration / 1000000);
+	adjust_tsc_offset_host(vcpu, -adj);
+	/*
+	 * This request should be processed before
+	 * the first vmenter after resume to avoid
+	 * an unadjusted TSC value is observed.
+	 */
+	kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
+	kvm_write_suspend_time(vcpu->kvm);
+	if (!kvm_apic_set_irq(vcpu, &irq, NULL))
+		pr_err("kvm: failed to set suspend time irq\n");
+}
+
+/*
+ * Do kvm-wide suspend time adjustment (kvm-clock).
+ */
+static void kvm_do_suspend_time_adjustment(struct kvm *kvm, u64 total_ns)
+{
+	spin_lock(&kvm->suspend_time_ns_lock);
+	if (total_ns > kvm->suspend_time_ns) {
+		u64 last_suspend_duration = total_ns - kvm->suspend_time_ns;
+		/*
+		 * Move the offset of kvm_clock here as if it is stopped
+		 * during the suspension.
+		 */
+		kvm->arch.kvmclock_offset -= last_suspend_duration;
+
+		/* suspend_time is accumulated per VM. */
+		kvm->suspend_time_ns += last_suspend_duration;
+		/*
+		 * This adjustment will be reflected to the struct provided
+		 * from the guest via MSR_KVM_HOST_SUSPEND_TIME before
+		 * the notification interrupt is injected.
+		 */
+		kvm_make_all_cpus_request(kvm, KVM_REQ_CLOCK_UPDATE);
+	}
+	spin_unlock(&kvm->suspend_time_ns_lock);
+}
+
+static void kvm_adjust_suspend_time(struct kvm_vcpu *vcpu)
+{
+	u64 total_ns = kvm_total_suspend_time(vcpu->kvm);
+	/* Do kvm-wide adjustment (kvm-clock) */
+	kvm_do_suspend_time_adjustment(vcpu->kvm, total_ns);
+	/* Do per-vcpu adjustment (tsc) */
+	vcpu_do_suspend_time_adjustment(vcpu, total_ns);
+}
+#else
+static void kvm_adjust_suspend_time(struct kvm_vcpu *vcpu)
+{
+}
+#endif
+
 /*
  * Returns 1 to let vcpu_run() continue the guest execution loop without
  * exiting to the userspace.  Otherwise, the value will be returned to the
@@ -9421,6 +9528,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			r = -EIO;
 			goto out;
 		}
+		if (kvm_check_request(KVM_REQ_SUSPEND_TIME_ADJ, vcpu))
+			kvm_adjust_suspend_time(vcpu);
 		if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
 			if (unlikely(!kvm_x86_ops.nested_ops->get_nested_state_pages(vcpu))) {
 				r = 0;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..ef93c067ceba 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -151,6 +151,7 @@ static inline bool is_error_page(struct page *page)
 #define KVM_REQ_UNBLOCK           2
 #define KVM_REQ_UNHALT            3
 #define KVM_REQ_VM_BUGGED         (4 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_SUSPEND_TIME_ADJ  5
 #define KVM_REQUEST_ARCH_BASE     8
 
 #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
@@ -336,6 +337,11 @@ struct kvm_vcpu {
 	} async_pf;
 #endif
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	u64 suspend_time_ns;
+	spinlock_t suspend_time_ns_lock;
+#endif
+
 #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
 	/*
 	 * Cpu relax intercept or pause loop exit optimization
@@ -623,6 +629,12 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	u64 suspend_time_ns;
+	spinlock_t suspend_time_ns_lock;
+	u64 base_offs_boot_ns;
+	struct gfn_to_hva_cache suspend_time_ghc;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
@@ -1829,6 +1841,42 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 }
 #endif /* CONFIG_KVM_XFER_TO_GUEST_WORK */
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+bool virt_suspend_time_enabled(struct kvm *kvm);
+void kvm_write_suspend_time(struct kvm *kvm);
+int kvm_init_suspend_time_ghc(struct kvm *kvm, gpa_t gpa);
+static inline u64 kvm_total_suspend_time(struct kvm *kvm)
+{
+	return ktime_get_offs_boot_ns() - kvm->base_offs_boot_ns;
+}
+
+static inline u64 vcpu_suspend_time_injected(struct kvm_vcpu *vcpu)
+{
+	return vcpu->suspend_time_ns;
+}
+#else
+static inline bool virt_suspend_time_enabled(struct kvm *kvm)
+{
+	return 0;
+}
+static inline void kvm_write_suspend_time(struct kvm *kvm)
+{
+}
+static inline int kvm_init_suspend_time_ghc(struct kvm *kvm, gpa_t gpa)
+{
+	return 1;
+}
+static inline u64 kvm_total_suspend_time(struct kvm *kvm)
+{
+	return 0;
+}
+
+static inline u64 vcpu_suspend_time_injected(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+#endif /* CONFIG_KVM_VIRT_SUSPEND_TIMING */
+
 /*
  * This defines how many reserved entries we want to keep before we
  * kick the vcpu to the userspace to avoid dirty ring full.  This
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7851f3a1b5f7..a4fedd2455d4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -425,6 +425,11 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 	vcpu->ready = false;
 	preempt_notifier_init(&vcpu->preempt_notifier, &kvm_preempt_ops);
 	vcpu->last_used_slot = 0;
+
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	vcpu->suspend_time_ns = kvm->suspend_time_ns;
+	spin_lock_init(&vcpu->suspend_time_ns_lock);
+#endif
 }
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
@@ -812,12 +817,70 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
+static int kvm_suspend_notifier(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	if (!virt_suspend_time_enabled(kvm))
+		return NOTIFY_DONE;
+
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvm_make_request(KVM_REQ_SUSPEND_TIME_ADJ, vcpu);
+	mutex_unlock(&kvm->lock);
+
+	return NOTIFY_DONE;
+}
+
+static int kvm_resume_notifier(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	if (!virt_suspend_time_enabled(kvm))
+		return NOTIFY_DONE;
+
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/*
+		 * Clear KVM_REQ_SUSPEND_TIME_ADJ if the suspend injection is
+		 * not needed (e.g. suspend failure)
+		 * The following condition is also true when the adjustment is
+		 * already done and it is safe to clear the request again here.
+		 */
+		if (kvm_total_suspend_time(kvm) ==
+		    vcpu_suspend_time_injected(vcpu))
+			kvm_clear_request(KVM_REQ_SUSPEND_TIME_ADJ, vcpu);
+	}
+	mutex_unlock(&kvm->lock);
+
+	return NOTIFY_DONE;
+}
+
+static int kvm_pm_notifier(struct kvm *kvm, unsigned long state)
+{
+	switch (state) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		return kvm_suspend_notifier(kvm);
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+		return kvm_resume_notifier(kvm);
+	}
+
+	return NOTIFY_DONE;
+}
+
 static int kvm_pm_notifier_call(struct notifier_block *bl,
 				unsigned long state,
 				void *unused)
 {
 	struct kvm *kvm = container_of(bl, struct kvm, pm_notifier);
 
+	if (kvm_pm_notifier(kvm, state) != NOTIFY_DONE)
+		return NOTIFY_BAD;
+
 	return kvm_arch_pm_notifier(kvm, state);
 }
 
@@ -843,6 +906,26 @@ static void kvm_destroy_pm_notifier(struct kvm *kvm)
 }
 #endif /* CONFIG_HAVE_KVM_PM_NOTIFIER */
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+void kvm_write_suspend_time(struct kvm *kvm)
+{
+	struct kvm_suspend_time st;
+
+	st.suspend_time_ns = kvm->suspend_time_ns;
+	kvm_write_guest_cached(kvm, &kvm->suspend_time_ghc, &st, sizeof(st));
+}
+
+int kvm_init_suspend_time_ghc(struct kvm *kvm, gpa_t gpa)
+{
+	if (kvm_gfn_to_hva_cache_init(kvm, &kvm->suspend_time_ghc, gpa,
+				      sizeof(struct kvm_suspend_time)))
+		return 1;
+
+	kvm_write_suspend_time(kvm);
+	return 0;
+}
+#endif
+
 static struct kvm_memslots *kvm_alloc_memslots(void)
 {
 	int i;
@@ -1080,6 +1163,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	if (r)
 		goto out_err_no_disable;
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	spin_lock_init(&kvm->suspend_time_ns_lock);
+	kvm->base_offs_boot_ns = ktime_get_offs_boot_ns();
+#endif
+
 #ifdef CONFIG_HAVE_KVM_IRQFD
 	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
 #endif
-- 
2.33.0.1079.g6e70778dc9-goog

