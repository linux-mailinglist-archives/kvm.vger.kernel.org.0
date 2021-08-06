Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF85E3E2818
	for <lists+kvm@lfdr.de>; Fri,  6 Aug 2021 12:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244892AbhHFKIX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 06:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244875AbhHFKIW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 06:08:22 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E765C061799
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 03:08:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so16856315pjh.3
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 03:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Gt3RNpwNEDuBzuurGwRUsOSXgvllck+aPukicqTV5aI=;
        b=io739bQscygkFggdyL8JEXBPvlyNPc82ikGqkJcWmuH79I+94LTEysBOl5E2qq+Oi6
         FybT4KA5csz8WwnnB57mFx085+tkYtOyQCf3Lo6JkqoCPvbujWj2SHphbd1Hz2m82WTA
         fuWyLQUItHFmsShpif9qiL9B5ydIzy993BJP8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gt3RNpwNEDuBzuurGwRUsOSXgvllck+aPukicqTV5aI=;
        b=BOWpbeyD2Tox5ISfgCDnV8ilUNiFfmuwKqiQFTRBgbiJf6mbYzx5nChbRgDPBUGyak
         fFzV7c1OM1X5A76aPuRdgD1Rk53JYjscSwK6V2IYbIqNI96cWilsKjMeycSrDK4KSwP9
         WClmw382uTLlbZl5rxGuYJ/aN0bKSFBs60L1PQneSXRyl3amVfJU7/HpG+lz31oLzTTH
         uk+f+PXkh38XMDU1W4t0Q6463JVL4DA/2+fvdbIdjEy52MCio/XSr+YFXF96DBKr7ZeP
         13z2ZPTtHt7Z6HRZhbHAIt/Ip/MDtgYImaMEGxl52Aylq7xXf4lcSPc3qiNwpc+xlU6I
         WJDw==
X-Gm-Message-State: AOAM532EvuhyCgo8yt3Y2nN4qGmSMYET/tS6en1HIKZWrlXSwli/O7NB
        mAhSpcAwm1cspzDRp9Dq3ljlL4ln7wcU0w==
X-Google-Smtp-Source: ABdhPJx7x+UAB9e+NRpCozXJTiYPOYGCGby32okU5xutY7gFgO9r9xfpnxu9UXOW8HegCiq6RUlINQ==
X-Received: by 2002:a62:b414:0:b029:317:52d:7fd5 with SMTP id h20-20020a62b4140000b0290317052d7fd5mr10008201pfn.30.1628244485985;
        Fri, 06 Aug 2021 03:08:05 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:b731:9e91:71e2:65e7])
        by smtp.gmail.com with UTF8SMTPSA id u17sm9768689pfh.184.2021.08.06.03.08.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Aug 2021 03:08:05 -0700 (PDT)
From:   Hikaru Nishida <hikalium@chromium.org>
To:     linux-kernel@vger.kernel.org, dme@dme.org, tglx@linutronix.de,
        mlevitsk@redhat.com
Cc:     suleiman@google.com, Hikaru Nishida <hikalium@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        John Stultz <john.stultz@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        x86@kernel.org
Subject: [v2 PATCH 3/4] x86/kvm: Add host side support for virtual suspend time injection
Date:   Fri,  6 Aug 2021 19:07:09 +0900
Message-Id: <20210806190607.v2.3.Ib0cb8ecae99f0ccd0e2814b310adba00b9e81d94@changeid>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
In-Reply-To: <20210806100710.2425336-1-hikalium@chromium.org>
References: <20210806100710.2425336-1-hikalium@chromium.org>
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

 arch/x86/include/asm/kvm_host.h |   5 ++
 arch/x86/kvm/Kconfig            |  13 ++++
 arch/x86/kvm/cpuid.c            |   4 ++
 arch/x86/kvm/x86.c              | 109 +++++++++++++++++++++++++++++++-
 include/linux/kvm_host.h        |   8 +++
 kernel/time/timekeeping.c       |   3 +
 6 files changed, 141 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0ac920f6adcb..39d7540f35c4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1064,6 +1064,11 @@ struct kvm_arch {
 	bool pause_in_guest;
 	bool cstate_in_guest;
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	u64 msr_suspend_time;
+	struct gfn_to_hva_cache suspend_time;
+#endif /* KVM_VIRT_SUSPEND_TIMING */
+
 	unsigned long irq_sources_bitmap;
 	s64 kvmclock_offset;
 	raw_spinlock_t tsc_write_lock;
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ac69894eab88..4a2d020d3b60 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -129,4 +129,17 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_VIRT_SUSPEND_TIMING
+	bool "Virtual suspend time injection"
+	depends on KVM=y
+	default n
+	help
+	 This option makes the host's suspension reflected on the guest's clocks.
+	 In other words, guest's CLOCK_MONOTONIC will stop and
+	 CLOCK_BOOTTIME keeps running during the host's suspension.
+	 This feature will only be effective when both guest and host enable
+	 this option.
+
+	 If unsure, say N.
+
 endif # VIRTUALIZATION
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c42613cfb5ba..d71ced5c5a78 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -911,6 +911,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+		entry->eax |= (1 << KVM_FEATURE_HOST_SUSPEND_TIME);
+#endif
+
 		if (sched_info_on())
 			entry->eax |= (1 << KVM_FEATURE_STEAL_TIME);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 20777b49c56a..59897b95cda4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1355,6 +1355,9 @@ static const u32 emulated_msrs_all[] = {
 
 	MSR_KVM_ASYNC_PF_EN, MSR_KVM_STEAL_TIME,
 	MSR_KVM_PV_EOI_EN, MSR_KVM_ASYNC_PF_INT, MSR_KVM_ASYNC_PF_ACK,
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	MSR_KVM_HOST_SUSPEND_TIME,
+#endif
 
 	MSR_IA32_TSC_ADJUST,
 	MSR_IA32_TSC_DEADLINE,
@@ -2132,6 +2135,24 @@ void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs)
 	kvm_write_guest(kvm, wall_clock, &version, sizeof(version));
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
+				    struct kvm_interrupt *irq);
+static void kvm_write_suspend_time(struct kvm *kvm)
+{
+	struct kvm_arch *ka = &kvm->arch;
+	struct kvm_suspend_time st;
+
+	st.suspend_time_ns = kvm->suspend_time_ns;
+	kvm_write_guest_cached(kvm, &ka->suspend_time, &st, sizeof(st));
+}
+
+static void kvm_make_suspend_time_interrupt(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_interrupt(vcpu, VIRT_SUSPEND_TIMING_VECTOR, false);
+	kvm_make_request(KVM_REQ_EVENT, vcpu);
+}
+#endif
 static void kvm_write_system_time(struct kvm_vcpu *vcpu, gpa_t system_time,
 				  bool old_msr, bool host_initiated)
 {
@@ -3237,6 +3258,25 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	kvm_unmap_gfn(vcpu, &map, &vcpu->arch.st.cache, true, false);
 }
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+static int set_suspend_time_struct(struct kvm_vcpu *vcpu, u64 data)
+{
+	if (!(data & KVM_MSR_ENABLED)) {
+		vcpu->kvm->arch.msr_suspend_time = data;
+		return 0;
+	}
+
+	if (kvm_gfn_to_hva_cache_init(vcpu->kvm,
+				&vcpu->kvm->arch.suspend_time, data & ~1ULL,
+				sizeof(struct kvm_suspend_time)))
+		return 1;
+
+	kvm_write_suspend_time(vcpu->kvm);
+	vcpu->kvm->arch.msr_suspend_time = data;
+	return 0;
+}
+#endif
+
 int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	bool pr = false;
@@ -3451,6 +3491,14 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		vcpu->arch.msr_kvm_poll_control = data;
 		break;
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	case MSR_KVM_HOST_SUSPEND_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HOST_SUSPEND_TIME))
+			return 1;
+
+		return set_suspend_time_struct(vcpu, data);
+#endif
+
 	case MSR_IA32_MCG_CTL:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
@@ -3769,6 +3817,14 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	case MSR_KVM_HOST_SUSPEND_TIME:
+		if (!guest_pv_has(vcpu, KVM_FEATURE_HOST_SUSPEND_TIME))
+			return 1;
+
+		msr_info->data = vcpu->kvm->arch.msr_suspend_time;
+		break;
+#endif
 	case MSR_IA32_P5_MC_ADDR:
 	case MSR_IA32_P5_MC_TYPE:
 	case MSR_IA32_MCG_CAP:
@@ -9778,7 +9834,14 @@ static int vcpu_run(struct kvm_vcpu *vcpu)
 		kvm_clear_request(KVM_REQ_UNBLOCK, vcpu);
 		if (kvm_cpu_has_pending_timer(vcpu))
 			kvm_inject_pending_timer_irqs(vcpu);
-
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+		if (kvm->suspend_injection_requested &&
+			kvm_vcpu_ready_for_interrupt_injection(vcpu)) {
+			kvm_write_suspend_time(kvm);
+			kvm_make_suspend_time_interrupt(vcpu);
+			kvm->suspend_injection_requested = false;
+		}
+#endif
 		if (dm_request_for_irq_injection(vcpu) &&
 			kvm_vcpu_ready_for_interrupt_injection(vcpu)) {
 			r = 0;
@@ -12338,6 +12401,50 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
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
+	 * Adjust TSCs on all vcpus and kvmclock as if they are stopped
+	 * during host's suspension.
+	 * Also, cummulative suspend time is recorded in kvm structure and
+	 * the update will be notified via an interrupt for each vcpu.
+	 */
+	mutex_lock(&kvm_lock);
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		if (!(kvm->arch.msr_suspend_time & KVM_MSR_ENABLED))
+			continue;
+
+		kvm_for_each_vcpu(i, vcpu, kvm)
+			vcpu->arch.tsc_offset_adjustment -= adj;
+
+		/*
+		 * Move the offset of kvm_clock here as if it is stopped
+		 * during the suspension.
+		 */
+		kvm->arch.kvmclock_offset -= suspend_time_ns;
+
+		/* suspend_time is accumulated per VM. */
+		kvm->suspend_time_ns += suspend_time_ns;
+		kvm->suspend_injection_requested = true;
+		/*
+		 * This adjustment will be reflected to the struct provided
+		 * from the guest via MSR_KVM_HOST_SUSPEND_TIME before
+		 * the notification interrupt is injected.
+		 */
+	}
+	mutex_unlock(&kvm_lock);
+}
+#endif
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d44ff1367ef3..bb9c582a70d0 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -601,6 +601,10 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+	u64 suspend_time_ns;
+	bool suspend_injection_requested;
+#endif
 };
 
 #define kvm_err(fmt, ...) \
@@ -1715,4 +1719,8 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 /* Max number of entries allowed for each kvm dirty ring */
 #define  KVM_DIRTY_RING_MAX_ENTRIES  65536
 
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+void kvm_arch_timekeeping_inject_sleeptime(const struct timespec64 *delta);
+#endif /* CONFIG_KVM_VIRT_SUSPEND_TIMING */
+
 #endif
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 233ceb6cce1f..3ac3fb479981 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1797,6 +1797,9 @@ void timekeeping_resume(void)
 	if (inject_sleeptime) {
 		suspend_timing_needed = false;
 		__timekeeping_inject_sleeptime(tk, &ts_delta);
+#ifdef CONFIG_KVM_VIRT_SUSPEND_TIMING
+		kvm_arch_timekeeping_inject_sleeptime(&ts_delta);
+#endif
 	}
 
 	/* Re-base the last cycle value */
-- 
2.32.0.605.g8dce9f2422-goog

