Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 670CC5A7988
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiHaIyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiHaIyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:54:01 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3135CAC70;
        Wed, 31 Aug 2022 01:53:59 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso20421267pjh.5;
        Wed, 31 Aug 2022 01:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=Ra1XTrPkeUnQjVN7gF2ynGZOQwRo6+U5v64sosBSSNE=;
        b=TbkoULMu/PebQrH/fNWCuJwq4vyr3xHDPitg7hlRD1vc4gSv9QKl0ZxV0dLIu5wSfY
         Qe0LjMtqW1/fuWy/GqCmLiFU5lVfbNQulN8Cbh/qoQaKBVGrk2NHcKtA2rlscb3Xv6gJ
         4DbJhemF9peqdmNc7QyHLaDzKEb/+1lhsfyZh/r1BQ1c5Uxi4PSJRFdmeow8BaLxCmy9
         a/x8WJHBdyeHBMs5Ez8GT8TFP7+DpnFCpMJpqiafqz6r29tKiBEAmXqBMZl3isqxqEX4
         bXMkhhS+UliHQl4joPAfy8DdqskL2gsOC/T9RIjciSypsP1FmUQnHdG4V/UFSRKUi9aM
         Eu9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=Ra1XTrPkeUnQjVN7gF2ynGZOQwRo6+U5v64sosBSSNE=;
        b=wz7UvHKwgo0+PRoerdba/NMpwID7UccR3AvINftUktb5r/2nQwYFH/UgRgHIaBn9oA
         f+rUWOr++HTYzJeD4qC0LINASYKzJHnO2BDCB2C7nfk7H50o0J+faaPon17QniRsEW6x
         XCLmx0oIxlcfcVwbH+tKnj+Szb1HdWZHIDtizJVq6+4u+VQ4AogkVtEoDp6coY6uQ+jc
         hDaoDnhkcGiGIWU9ujCu0hAd9lYAJ6J59D37/s90O92pHqNDS8q5aD/if47xAeZ46tC8
         Dfld3mpZARKFl1muE0MNEU2VTG+thrYECSiEbQeXaorLKV7995oBiDYdCV69v477c5Ec
         RtLw==
X-Gm-Message-State: ACgBeo03TQnkZgxaaIL/mr9HBHYiE1yOe3tL2x4MJ/QTinN060GVCu/8
        70R+HTeO2MR1ZF/lZNbtva4YbOCM2kpZ8kWd
X-Google-Smtp-Source: AA6agR6h1miFrjqk/OZbSh0MJNoFTggNs1WBgnb5Ln0YDv29L5LbRf8d9O1+628O8BPVterl6Gg6JQ==
X-Received: by 2002:a17:90a:c782:b0:1fb:307f:7cbd with SMTP id gn2-20020a17090ac78200b001fb307f7cbdmr2202279pjb.14.1661936038736;
        Wed, 31 Aug 2022 01:53:58 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:58 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/7] KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters scalability
Date:   Wed, 31 Aug 2022 16:53:28 +0800
Message-Id: <20220831085328.45489-8-likexu@tencent.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220831085328.45489-1-likexu@tencent.com>
References: <20220831085328.45489-1-likexu@tencent.com>
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
registers is accessed, then determine if it matches its requested type,
applying different scaling ratios respectively, and finally get pmc_idx
to pass into amd_pmc_idx_to_pmc().

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 88 ++++++++++--------------------------------
 1 file changed, 20 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index c736757c29d2..2ec420b85d6a 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -23,90 +23,52 @@ enum pmu_type {
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
-static enum index msr_to_index(u32 msr)
+static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 {
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
+	unsigned int num_counters = pmu->nr_arch_gp_counters;
+
+	if (pmc_idx >= num_counters)
+		return NULL;
+
+	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
 }
 
 static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 					     enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+	unsigned int idx;
 
 	if (!vcpu->kvm->arch.enable_pmu)
 		return NULL;
 
 	switch (msr) {
-	case MSR_F15H_PERF_CTL0:
-	case MSR_F15H_PERF_CTL1:
-	case MSR_F15H_PERF_CTL2:
-	case MSR_F15H_PERF_CTL3:
-	case MSR_F15H_PERF_CTL4:
-	case MSR_F15H_PERF_CTL5:
+	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
 		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
 			return NULL;
-		fallthrough;
+		/*
+		 * Each PMU counter has a pair of CTL and CTR MSRs. CTLn
+		 * MSRs (accessed via EVNTSEL) are even, CTRn MSRs are odd.
+		 */
+		idx = (unsigned int)((msr - MSR_F15H_PERF_CTL0) / 2);
+		if (!(msr & 0x1) != (type == PMU_TYPE_EVNTSEL))
+			return NULL;
+		break;
 	case MSR_K7_EVNTSEL0 ... MSR_K7_EVNTSEL3:
 		if (type != PMU_TYPE_EVNTSEL)
 			return NULL;
+		idx = msr - MSR_K7_EVNTSEL0;
 		break;
-	case MSR_F15H_PERF_CTR0:
-	case MSR_F15H_PERF_CTR1:
-	case MSR_F15H_PERF_CTR2:
-	case MSR_F15H_PERF_CTR3:
-	case MSR_F15H_PERF_CTR4:
-	case MSR_F15H_PERF_CTR5:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
-			return NULL;
-		fallthrough;
 	case MSR_K7_PERFCTR0 ... MSR_K7_PERFCTR3:
 		if (type != PMU_TYPE_COUNTER)
 			return NULL;
+		idx = msr - MSR_K7_PERFCTR0;
 		break;
 	default:
 		return NULL;
 	}
 
-	return &pmu->gp_counters[msr_to_index(msr)];
+	return amd_pmc_idx_to_pmc(pmu, idx);
 }
 
 static bool amd_hw_event_available(struct kvm_pmc *pmc)
@@ -122,16 +84,6 @@ static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
 	return true;
 }
 
-static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
-{
-	unsigned int num_counters = pmu->nr_arch_gp_counters;
-
-	if (pmc_idx >= num_counters)
-		return NULL;
-
-	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
-}
-
 static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-- 
2.37.3

