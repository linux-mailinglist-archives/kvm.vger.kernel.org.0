Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E57236B041
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbhDZJJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 05:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhDZJJj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 05:09:39 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9861FC061756
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:39 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e9so11614647plj.2
        for <kvm@vger.kernel.org>; Mon, 26 Apr 2021 02:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WigoIf1bDqjv1l/y8T/BSRs1tlh6BcVRQlFS9r21Wyk=;
        b=O37T04+5AWwgCdxukdUFl/2gYu9CiWxGS9LJj2bmIfz11o3AEhBymw8dLTScUiiFfg
         5N9kMbA4aHkAF7PMguRJNstyKo+ems6yhsi677RizCS28zD/GA/otyQrgnFILOAcN2VY
         DHj7SQgr7OuOQwwvme2+lKu2D0KkO9hxui4wM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WigoIf1bDqjv1l/y8T/BSRs1tlh6BcVRQlFS9r21Wyk=;
        b=rfPMo+BHOyxpS6MCZLWQ5b8ZNLv4WUL1/Xj1GwqThLohsyJ8FiqCyg/S2+OCX0Px/g
         39LP+cxiw9X5kYk6mgG3BfPlL2IWu83p4amR8AifiH+RQWHOsATqTPe8FCuU4AmMbiBh
         a3b+9vHdFAPiq4ypQCDd7GIbaWvJ5LV5jd4uIAridbs83VomVLq8fccdr/QgciE+4HWv
         MFPjg4pIK37/Ho1weIVxbPwBdQ3+yyooGweMyGY8WRn/qLxBI07HjgvM+jDrSOGLxomZ
         qJvisza4FTjmUOumKIRdNwQJ5qbTs7xRtTByGNGAJPiELg+rEORmZxWaPH/R5tXaMBfl
         IWxQ==
X-Gm-Message-State: AOAM5333Uc2nJdXOZh0i7eF3UvzMylHLOYFhBuj4wYozSWnPOIfDINUA
        8H2fZqIkzD+CjUpvvHIU/DLwqyEHBhMH9Q==
X-Google-Smtp-Source: ABdhPJxZbgs+YGZOf9JouVrQNr4cdFdLfOz0VCnniBcKCMqWwTJ/+Za99oAbn5f027WdoSCC1NWIhQ==
X-Received: by 2002:a17:90b:224d:: with SMTP id hk13mr20590501pjb.218.1619428118872;
        Mon, 26 Apr 2021 02:08:38 -0700 (PDT)
Received: from localhost (160.131.236.35.bc.googleusercontent.com. [35.236.131.160])
        by smtp.gmail.com with UTF8SMTPSA id d12sm11920666pjj.50.2021.04.26.02.08.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 02:08:38 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     kvm@vger.kernel.org
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [RFC PATCH 4/6] x86/kvm: Add a host side support for virtual suspend time injection
Date:   Mon, 26 Apr 2021 18:06:43 +0900
Message-Id: <20210426090644.2218834-5-hikalium@chromium.org>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
In-Reply-To: <20210426090644.2218834-1-hikalium@chromium.org>
References: <20210426090644.2218834-1-hikalium@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch implements virtual suspend time injection support for kvm
hosts.
If this functionality is enabled and the guest requests it, the host
will stop all the clocks observed by the guest during the host's
suspension and report the duration of suspend to the guest through
struct kvm_host_suspend_time to give a chance to adjust CLOCK_BOOTTIME
to the guest. This mechanism can be used to align the guest's clock
behavior to the hosts' ones.

Signed-off-by: Hikaru Nishida <hikalium@chromium.org>
---

 arch/x86/include/asm/kvm_host.h |  5 ++
 arch/x86/kvm/cpuid.c            |  4 ++
 arch/x86/kvm/x86.c              | 89 ++++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h        |  7 +++
 kernel/time/timekeeping.c       |  3 ++
 5 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3768819693e5..6584adaab3bf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -994,6 +994,11 @@ struct kvm_arch {
 
 	gpa_t wall_clock;
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	struct gfn_to_hva_cache suspend_time;
+	bool suspend_time_injection_enabled;
+#endif /* KVM_VIRT_SUSPEND_TIMING */
+
 	bool mwait_in_guest;
 	bool hlt_in_guest;
 	bool pause_in_guest;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6bd2f8b830e4..62224b7bd7f9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -814,6 +814,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+		entry->eax |= (1 << KVM_FEATURE_HOST_SUSPEND_TIME);
+#endif
+
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eca63625aee4..d919f771ce31 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1285,6 +1285,9 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	MSR_KVM_HOST_SUSPEND_TIME,
+#endif
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSCDEADLINE,
@@ -2020,6 +2023,20 @@ static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 	return;
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+static void kvm_write_suspend_time(struct kvm *kvm, bool updated)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_host_suspend_time st;
+
+	if (!ka->suspend_time_injection_enabled)
+		return;
+
+	st.suspend_time_ns = kvm->suspend_time_ns;
+	kvm_write_guest_cached(kvm, &ka->suspend_time, &st, sizeof(st));
+}
+#endif
+
 static uint32_t div_frac(uint32_t dividend, uint32_t divisor)
 {
 	do_shl32_div32(dividend, divisor);
@@ -2653,6 +2670,9 @@ static void kvm_setup_pvclock_page(struct kvm_vcpu *v,
 
 	if (vcpu->pvclock_set_guest_stopped_request) {
 		vcpu->hv_clock.flags |= PVCLOCK_GUEST_STOPPED;
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+		kvm_write_suspend_time(v->kvm, true);
+#endif
 		vcpu->pvclock_set_guest_stopped_request = false;
 	}
 
@@ -3229,7 +3249,23 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
-
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	case MSR_KVM_HOST_SUSPEND_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HOST_SUSPEND_TIME))
+			return 1;
+		if (!(data & KVM_MSR_ENABLED)) {
+			vcpu->kvm->arch.suspend_time_injection_enabled = false;
+			break;
+		}
+		if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+		     &vcpu->kvm->arch.suspend_time, data & ~KVM_MSR_ENABLED,
+		     sizeof(struct kvm_host_suspend_time))) {
+			return 1;
+		}
+		vcpu->kvm->arch.suspend_time_injection_enabled = true;
+		kvm_write_suspend_time(vcpu->kvm, false);
+		break;
+#endif
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3535,6 +3571,15 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	case MSR_KVM_HOST_SUSPEND_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HOST_SUSPEND_TIME))
+			return 1;
+		msr_info->data = vcpu->kvm->arch.suspend_time.gpa;
+		if (vcpu->kvm->arch.suspend_time_injection_enabled)
+			msr_info->data |= KVM_MSR_ENABLED;
+		break;
+#endif
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -11723,6 +11768,48 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+void kvm_arch_timekeeping_inject_sleeptime(const struct timespec64 *delta)
+{
+	struct kvm_vcpu *vcpu;
+	u64 suspend_time_ns;
+	struct kvm *kvm;
+	s64 adj;
+	int i;
+
+	suspend_time_ns = timespec64_to_ns(delta);
+	adj = tsc_khz * (suspend_time_ns / 1000000);
+	/*
+	 * Adjust TSCs on all vcpus as if they are stopped during a suspend.
+	 * doing a similar thing in kvm_arch_hardware_enable().
+	 */
+	mutex_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		if (!kvm->arch.suspend_time_injection_enabled)
+			continue;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			/*
+			 * Adjustment here is always smaller than the gap
+			 * observed by the guest, so subtracting the value
+			 * here never rewinds the observed TSC in guests.
+			 * This adjustment will be applied on the next
+			 * kvm_arch_vcpu_load().
+			 */
+			vcpu->arch.tsc_offset_adjustment -= adj;
+		}
+		/*
+		 * Move the offset of kvm_clock here as if it is stopped
+		 * during the suspension.
+		 */
+		kvm->arch.kvmclock_offset -= suspend_time_ns;
+		/* suspend_time is accumulated per VM. */
+		kvm->suspend_time_ns += suspend_time_ns;
+	}
+	mutex_unlock(&kvm_lock);
+}
+#endif
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1b65e7204344..e077b9a960fc 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -520,6 +520,9 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	u64 suspend_time_ns;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
@@ -1522,4 +1525,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+void kvm_arch_timekeeping_inject_sleeptime(const struct timespec64 *delta);
+#endif /* CONFIG_KVM_VIRT_SUSPEND_TIMING */
+
 #endif
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index ff0304de7de9..342a032ad552 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1786,6 +1786,9 @@ void timekeeping_resume(void)
 	if (inject_sleeptime) {
 		suspend_timing_needed = false;
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+		kvm_arch_timekeeping_inject_sleeptime(&ts_delta);
+#endif
 	}
 
 	/* Re-base the last cycle value */
-- 
2.31.1.498.g6c1eba8ee3d-goog

