Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1713752147A
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 13:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241448AbiEJMBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 08:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241395AbiEJMBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 08:01:42 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E1C25D11E;
        Tue, 10 May 2022 04:57:29 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id a191so14465227pge.2;
        Tue, 10 May 2022 04:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4EHijMXYqaJmiEN7Jfvz24yA9KqjDPzEn/FC/pqCNrE=;
        b=CHPMB23IKZeBKNMKntaVYEyo+fNtb5WgyWyN7HUWd7xTGfAewWqy+eWLErvLk94M9i
         v/b+nybOg+6EerGru4YaYEasrNCCh+NZO9Gz5/xvW/2axlLe5+ZalTaSEdioZ5k/uFqm
         8j4RBdfYRJtYW/+gmCf/aQFCAHWjP1TEuisQcuT6p4z+otStzLH9mRqnGmAoPnYg9wi7
         Wqhhjneji3X9wk2C1WqI+iofLYRGvbMXMDyq/OPDOFoVaNxu9YTq5uce0aR5yWkaxbeR
         VRQc9x5kmxeTa0OCGNoYkeR4cIFfEAmHBra3EEGcCMZ3ZO5inDMRLr56hbRJv04Tjbdl
         Ql7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4EHijMXYqaJmiEN7Jfvz24yA9KqjDPzEn/FC/pqCNrE=;
        b=q5l25yCzcI/RdytDVnihg/vzcWhnT967qwQ7YrDWkXifnGq83pg6ToX8pQ3rbDOR2r
         1xoDqCij8+RiniS5yVGzT3VqTCx++eojrYDd9THnFuvpoLVynvmRMH5ULAz0nvKQyL3Q
         zgO0m4WDqM714gux5a4WC6nnJxyMXbf+2h/zPQSMOwMBL4euyfFRMRcEGblNY/Qir733
         esQHKuhD0NOGGKi8xCLGVSWHdW1suDjQpqKGxJLTX7Fx61EIHeXybhR//5KuJMt3FPej
         wd71A3lVxfxv2VLT360k1oX9Qc0fZDoYoOIAFIblBgoUzvzvaTpvnHjuw9jZ8vDVYHaw
         nrBA==
X-Gm-Message-State: AOAM532N+CxgkGbZ+zY6VVT8OPQtBuik7F3fon43jgBwv4ztNY4YQ5P3
        XCHx0TrGqpfhFwEVP625mxA=
X-Google-Smtp-Source: ABdhPJzWAZACAmlCttWC+a2MV8NJYLAhdL0z2+nnXOh2Diskk4x3djZN6Qwx6JyQ6TDCfzznDfXTgw==
X-Received: by 2002:a63:846:0:b0:39d:9a9d:1178 with SMTP id 67-20020a630846000000b0039d9a9d1178mr16867813pgi.225.1652183848841;
        Tue, 10 May 2022 04:57:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.81])
        by smtp.gmail.com with ESMTPSA id m21-20020a62a215000000b0050dc7628194sm10460463pff.110.2022.05.10.04.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 04:57:28 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, sandipan.das@amd.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] KVM: x86/svm/pmu: Drop 'enum index' for more counters scalability
Date:   Tue, 10 May 2022 19:57:18 +0800
Message-Id: <20220510115718.93335-3-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510115718.93335-1-likexu@tencent.com>
References: <20220510115718.93335-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

If the number of AMD gp counters continues to grow, the code will
be very clumsy and the switch-case design of inline get_gp_pmc_amd()
will also bloat the kernel text size.

The target code is taught to manage two groups of MSRs, each
representing a different version of the AMD PMU counter MSRs.
The MSR addresses of each group are contiguous, with no holes,
and there is no intersection between two sets of addresses,
but they are discrete in functionality by design like this:

[Group A : All counter MSRs are tightly bound to all event select MSRs ]

  MSR_K7_EVNTSEL0			0xc0010000
  MSR_K7_EVNTSELi			0xc0010000 + i
  ...
  MSR_K7_EVNTSEL3			0xc0010003
  MSR_K7_PERFCTR0			0xc0010004
  MSR_K7_PERFCTRi			0xc0010004 + i
  ...
  MSR_K7_PERFCTR3			0xc0010007

[Group B : The counter MSRs are interleaved with the event select MSRs ]

  MSR_F15H_PERF_CTL0		0xc0010200
  MSR_F15H_PERF_CTR0		(0xc0010200 + 1)
  ...
  MSR_F15H_PERF_CTLi		(0xc0010200 + 2 * i)
  MSR_F15H_PERF_CTRi		(0xc0010200 + 2 * i + 1)
  ...
  MSR_F15H_PERF_CTL5		(0xc0010200 + 2 * 5)
  MSR_F15H_PERF_CTR5		(0xc0010200 + 2 * 5 + 1)

Rewrite get_gp_pmc_amd() in this way: first determine which group of
registers is accessed by the pass-in 'msr' address, then determine
which msr 'base' is referenced by 'type', applying different address
scaling ratios separately, and finally get the pmc_idx.

If the 'base' does not match its 'type', it continues to remain invalid.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 96 ++++++++----------------------------------
 1 file changed, 18 insertions(+), 78 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 4668baf762d2..b1ae249b4779 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -23,16 +23,6 @@ enum pmu_type {
 	PMU_TYPE_EVNTSEL,
 };
 
-enum index {
-	INDEX_ZERO = 0,
-	INDEX_ONE,
-	INDEX_TWO,
-	INDEX_THREE,
-	INDEX_FOUR,
-	INDEX_FIVE,
-	INDEX_ERROR,
-};
-
 /* duplicated from amd_perfmon_event_map, K7 and above should work. */
 static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
 	[0] = { 0x76, 0x00, PERF_COUNT_HW_CPU_CYCLES },
@@ -55,11 +45,9 @@ static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
 }
 
-static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
+static u32 get_msr_base(bool core_ctr, enum pmu_type type)
 {
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
-
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
+	if (core_ctr) {
 		if (type == PMU_TYPE_COUNTER)
 			return MSR_F15H_PERF_CTR;
 		else
@@ -72,77 +60,29 @@ static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 	}
 }
 
-static enum index msr_to_index(u32 msr)
-{
-	switch (msr) {
-	case MSR_F15H_PERF_CTL0:
-	case MSR_F15H_PERF_CTR0:
-	case MSR_K7_EVNTSEL0:
-	case MSR_K7_PERFCTR0:
-		return INDEX_ZERO;
-	case MSR_F15H_PERF_CTL1:
-	case MSR_F15H_PERF_CTR1:
-	case MSR_K7_EVNTSEL1:
-	case MSR_K7_PERFCTR1:
-		return INDEX_ONE;
-	case MSR_F15H_PERF_CTL2:
-	case MSR_F15H_PERF_CTR2:
-	case MSR_K7_EVNTSEL2:
-	case MSR_K7_PERFCTR2:
-		return INDEX_TWO;
-	case MSR_F15H_PERF_CTL3:
-	case MSR_F15H_PERF_CTR3:
-	case MSR_K7_EVNTSEL3:
-	case MSR_K7_PERFCTR3:
-		return INDEX_THREE;
-	case MSR_F15H_PERF_CTL4:
-	case MSR_F15H_PERF_CTR4:
-		return INDEX_FOUR;
-	case MSR_F15H_PERF_CTL5:
-	case MSR_F15H_PERF_CTR5:
-		return INDEX_FIVE;
-	default:
-		return INDEX_ERROR;
-	}
-}
-
 static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 					     enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+	unsigned int ratio = 0;
+	unsigned int pmc_idx;
+	u32 base;
 
-	switch (msr) {
-	case MSR_F15H_PERF_CTL0:
-	case MSR_F15H_PERF_CTL1:
-	case MSR_F15H_PERF_CTL2:
-	case MSR_F15H_PERF_CTL3:
-	case MSR_F15H_PERF_CTL4:
-	case MSR_F15H_PERF_CTL5:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
-			return NULL;
-		fallthrough;
-	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
-		if (type != PMU_TYPE_EVNTSEL)
-			return NULL;
-		break;
-	case MSR_F15H_PERF_CTR0:
-	case MSR_F15H_PERF_CTR1:
-	case MSR_F15H_PERF_CTR2:
-	case MSR_F15H_PERF_CTR3:
-	case MSR_F15H_PERF_CTR4:
-	case MSR_F15H_PERF_CTR5:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
-			return NULL;
-		fallthrough;
-	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
-		if (type != PMU_TYPE_COUNTER)
-			return NULL;
-		break;
-	default:
-		return NULL;
+	/* MSR_K7_* MSRs are still visible to PERFCTR_CORE guest. */
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE) &&
+	    msr >= MSR_F15H_PERF_CTL0 && msr <= MSR_F15H_PERF_CTR5) {
+		base = get_msr_base(true, type);
+		ratio = 2;
+	} else if (msr >= MSR_K7_EVNTSEL0 && msr <= MSR_K7_PERFCTR3) {
+		base = get_msr_base(false, type);
+		ratio = 1;
 	}
 
-	return &pmu->gp_counters[msr_to_index(msr)];
+	if (!ratio || msr < base)
+		return NULL;
+
+	pmc_idx = (unsigned int)((msr - base) / ratio);
+	return amd_pmc_idx_to_pmc(pmu, pmc_idx);
 }
 
 static unsigned int amd_pmc_perf_hw_id(struct kvm_pmc *pmc)
-- 
2.36.1

