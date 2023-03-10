Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E746B3CE8
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 11:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCJKzB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 05:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCJKy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 05:54:28 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544B0FD296;
        Fri, 10 Mar 2023 02:54:14 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id fr5-20020a17090ae2c500b0023af8a036d2so8573009pjb.5;
        Fri, 10 Mar 2023 02:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678445653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0wyg7PPl9oMWqL20HC/bqjAELVsUWzLxhdgpFsSisLM=;
        b=jn/kMMaNqkIr84Aixb+tjQPhwsKirnz68cRcL6mMk6z4QEsympIhltdDzMLwDLHVVq
         kxTkoDJhXDTEmf535WmCayGqs/8Thx7O3sQOy1o/yJBnAHgglZwcs1WXUYN+DsYgXkcs
         ejq+jkeUHbYcSMyT0mszwWswdR285M2ZqTv7KrT4ZuYy0CMKl+qANvx/Q14edHFwE5Bg
         S2HrNTTczkV67JDXkRilR62VEyeDGXAEVpSzB0/Xgfva3+9UT5sMtFKM5uAJ7u+XUKI8
         O3wCBoLIHSRg9lSqryE37F+9x5KLyeBAiuqv6GomAUQqT6xyjs4w8Iw/002Qz6u7AzLw
         ZheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678445653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0wyg7PPl9oMWqL20HC/bqjAELVsUWzLxhdgpFsSisLM=;
        b=5ARlXlUdLxRfJl9BfV/nawx7B3HGKSCETZxmUUKv6M2QenCPU0Ex4IOvKH5NxIznzQ
         JPz7zPMTxElh5iIL1Ic5MaG2iTc8eMO8uLMRTvepF0Ny9eyF5fdG5aWQgSNqon9DpQ6T
         Jg72pZtYh1g4x5vUW4efYB9P540lYywCrPMCqHrH5S/jbCPMmif60lamW8uSwXCQ+SsL
         NLjiXJAj0cHMKHGZmt8y7V/ccMBXcOVOkoVHBtf+DiP/F5DaISG3ikJ66RVVkpAXLVoD
         iprFpkczs4MFjcSzmDSzBNVqRVPcuKoL0wAKRfzkbS6KwjuwY9Umj/eyzCAQozh5JNQq
         ikdw==
X-Gm-Message-State: AO0yUKXKLNTvsSnY5eicC95s8mwJ8lEYhbJimgIOVTeDSbBxhQRletoP
        jwIXsjCFfblOGduVu4fq+v8=
X-Google-Smtp-Source: AK7set9GOgc8d03h5OC2+CJxAfSKCw8Cqdq3FEXvdxgQP0Hm/oxTD3H85ka7WEmbgH72V1/W8e1cAw==
X-Received: by 2002:a17:902:e844:b0:19c:d97f:5d28 with SMTP id t4-20020a170902e84400b0019cd97f5d28mr31349746plg.32.1678445653644;
        Fri, 10 Mar 2023 02:54:13 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id ks3-20020a170903084300b0019cbabf127dsm1174167plb.182.2023.03.10.02.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 02:54:13 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] KVM: x86/pmu: Hide guest counter updates from the VMRUN instruction
Date:   Fri, 10 Mar 2023 18:53:46 +0800
Message-Id: <20230310105346.12302-6-likexu@tencent.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310105346.12302-1-likexu@tencent.com>
References: <20230310105346.12302-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

When AMD guest is counting (branch) instructions event, its vPMU should
first subtract one for any relevant (branch)-instructions enabled counter
(when it precedes VMRUN and cannot be preempted) to offset the inevitable
plus-one effect of the VMRUN instruction immediately follows.

Based on a number of micro observations (also the reason why x86_64/
pmu_event_filter_test fails on AMD Zen platforms), each VMRUN will
increment all hw-(branch)-instructions counters by 1, even if they are
only enabled for guest code. This issue seriously affects the performance
understanding of guest developers based on (branch) instruction events.

If the current physical register value on the hardware is ~0x0, it triggers
an overflow in the guest world right after running VMRUN. Although this
cannot be avoided on mainstream released hardware, the resulting PMI
(if configured) will not be incorrectly injected into the guest by vPMU,
since the delayed injection mechanism for a normal counter overflow
depends only on the change of pmc->counter values.

The pmu_hide_vmrun() is called before each VMRUN and its overhead
depends on the number of counters enabled by the guest and is negligible
when none of the counters are used.

Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++++
 arch/x86/kvm/pmu.c              | 18 ++++++++++++++++++
 arch/x86/kvm/pmu.h              | 24 +++++++++++++++++++++++-
 arch/x86/kvm/svm/pmu.c          |  1 +
 arch/x86/kvm/svm/svm.c          | 28 ++++++++++++++++++++++++++++
 5 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index adb92fc4d7c9..d6fcbf233cb3 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -561,6 +561,10 @@ struct kvm_pmu {
 	 */
 	u64 host_cross_mapped_mask;
 
+	/* Flags to track any HW quirks that need to be fixed by vPMU. */
+	u64 quirk_flags;
+	DECLARE_BITMAP(hide_vmrun_pmc_idx, X86_PMC_IDX_MAX);
+
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2a0504732966..315dca021d57 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -254,6 +254,7 @@ static void pmc_pause_counter(struct kvm_pmc *pmc)
 	counter += perf_event_pause(pmc->perf_event, true);
 	pmc->counter = counter & pmc_bitmask(pmc);
 	pmc->is_paused = true;
+	kvm_mark_pmc_is_quirky(pmc);
 }
 
 static bool pmc_resume_counter(struct kvm_pmc *pmc)
@@ -822,6 +823,19 @@ int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+static inline bool event_is_branch_instruction(struct kvm_pmc *pmc)
+{
+	return eventsel_match_perf_hw_id(pmc, PERF_COUNT_HW_INSTRUCTIONS) ||
+		eventsel_match_perf_hw_id(pmc,
+					  PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
+}
+
+static inline bool quirky_pmc_will_count_vmrun(struct kvm_pmc *pmc)
+{
+	return event_is_branch_instruction(pmc) && event_is_allowed(pmc) &&
+		!static_call(kvm_x86_get_cpl)(pmc->vcpu);
+}
+
 void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -837,6 +851,10 @@ void kvm_pmu_handle_event(struct kvm_vcpu *vcpu)
 
 		reprogram_counter(pmc);
 		kvm_pmu_handle_pmc_overflow(pmc);
+
+		if (vcpu_has_pmu_quirks(vcpu) &&
+		    quirky_pmc_will_count_vmrun(pmc))
+			set_bit(pmc->idx, pmu->hide_vmrun_pmc_idx);
 	}
 
 	/*
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index a47b579667c6..30f6f58f4c38 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -18,6 +18,9 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+#define X86_PMU_COUNT_VMRUN	BIT_ULL(0)
+#define X86_PMU_QUIRKS_MASK	X86_PMU_COUNT_VMRUN
+
 struct kvm_pmu_ops {
 	bool (*hw_event_available)(struct kvm_pmc *pmc);
 	bool (*pmc_is_enabled)(struct kvm_pmc *pmc);
@@ -54,14 +57,33 @@ static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
 	kvm_make_request(KVM_REQ_PMU, pmc->vcpu);
 }
 
+static inline bool vcpu_has_pmu_quirks(struct kvm_vcpu *vcpu)
+{
+	return vcpu_to_pmu(vcpu)->quirk_flags & X86_PMU_QUIRKS_MASK;
+}
+
+/*
+ * The time to mark pmc is when the accumulation value returned
+ * by perf API based on a HW counter has just taken effect.
+ */
+static inline void kvm_mark_pmc_is_quirky(struct kvm_pmc *pmc)
+{
+	if (!vcpu_has_pmu_quirks(pmc->vcpu))
+		return;
+
+	kvm_pmu_request_counter_reprogram(pmc);
+}
+
 static inline u64 pmc_read_counter(struct kvm_pmc *pmc)
 {
 	u64 counter, enabled, running;
 
 	counter = pmc->counter;
-	if (pmc->perf_event && !pmc->is_paused)
+	if (pmc->perf_event && !pmc->is_paused) {
 		counter += perf_event_read_value(pmc->perf_event,
 						 &enabled, &running);
+		kvm_mark_pmc_is_quirky(pmc);
+	}
 	/* FIXME: Scaling needed? */
 	return counter & pmc_bitmask(pmc);
 }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 5fa939e411d8..130991a97f22 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -187,6 +187,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->nr_arch_fixed_counters = 0;
 	pmu->global_status = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+	pmu->quirk_flags |= X86_PMU_COUNT_VMRUN;
 }
 
 static void amd_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f41d96e638ef..f6b33d172481 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3919,6 +3919,31 @@ static fastpath_t svm_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 	return EXIT_FASTPATH_NONE;
 }
 
+static void pmu_hide_vmrun(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	unsigned int i;
+
+	for_each_set_bit(i, pmu->hide_vmrun_pmc_idx, X86_PMC_IDX_MAX) {
+		clear_bit(i, pmu->hide_vmrun_pmc_idx);
+
+		/* AMD doesn't have fixed counters at now. */
+		if (i >= pmu->nr_arch_gp_counters)
+			continue;
+
+		/*
+		 * The prerequisite for fixing HW quirks is that there is indeed
+		 * HW working and perf has no chance to retrieve the counter.
+		 */
+		pmc = &pmu->gp_counters[i];
+		if (!pmc->perf_event || pmc->perf_event->hw.idx < 0)
+			continue;
+
+		pmc->counter--;
+	}
+}
+
 static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_intercepted)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -3986,6 +4011,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_wait_lapic_expire(vcpu);
 
+	if (vcpu->kvm->arch.enable_pmu && vcpu_has_pmu_quirks(vcpu))
+		pmu_hide_vmrun(vcpu);
+
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
 	 * it's non-zero. Since vmentry is serialising on affected CPUs, there
-- 
2.39.2

