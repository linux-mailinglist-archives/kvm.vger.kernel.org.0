Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C56EC59DFCF
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358422AbiHWLyU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358700AbiHWLw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:58 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3960D59A7;
        Tue, 23 Aug 2022 02:33:04 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p9so11852422pfq.13;
        Tue, 23 Aug 2022 02:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=/IKVzfhBQXEpapBjo70h6YuHbpTsL9mny3LHoRffMJs=;
        b=FZnyOdE08/dlPRvpgom/0NDmrRE8eCsvTigdBVJpLqkOFIqIHAGsbM/UkMSiJJVvA0
         6+2jt2IzlwbPGX8z2DAZEE+20fnE+yqR3312eUjFDr4uGrHNaWFPTFGf+NaAmdFgZtkw
         Gci9cc7sjc21GJeE/WgBnjrnvwDl16b9Q/CtmbdlAvHgk/HOLuR3pOUIQQurh+2CzE8q
         0IISZ1+L+8tbGh0VKWDtGkOSTGex7OsQ7CtM/FwoW6rej0aVaspiO7XVnN1CvD1znr9l
         eMidWn/4QPuB8RkvVlwNv5HNqKLpko64lhOC2PxSiuvJi1pwi9CSf4qqA2i3oSBc1Lqc
         yXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=/IKVzfhBQXEpapBjo70h6YuHbpTsL9mny3LHoRffMJs=;
        b=WVFfMKdMKYGoKVKkKOKeJNSC+ysephMgSE7zQbZFSQ9U2k4cIWDNOL0P8hPvmykfUI
         5TahmKW5Tqka+qIuBD/lfEbLRAR1sSGwJJlu3fZo2gTBlil30yBkUHAWe2CV8IGzKYlX
         yAdsdI7P2Pyy9qVOWKDfYhooJJuvKTJOXlJ49w9bjYPDyj24s/aqC6G5nqJWPqiJAgwr
         XUuCel4hXeynpwoIOJJQ8rxWn9zVWDSDCqzB4GqwGh2tf4wJij+Ek+4KqbcNMA/kIhG6
         IeOG9vHdN9mqs0a8irDj9CBVWtPxoza7vMMse6meFzViL03V8RUmDqT/d4PMA76rQxOx
         eSOA==
X-Gm-Message-State: ACgBeo3bAPwQp8krqcKcEDsN7aT1CvVzzeTTFwBCUqPXUZkJMiaaksGh
        tHvYWeyWRTi/5DnlM2NcmG0=
X-Google-Smtp-Source: AA6agR7vZf0um13O/sGVqgfT8zI+7tCAywQiXHqFbDS2ImQPFFukABtRQjPXXgbogJ+X5X3lzen2tw==
X-Received: by 2002:a05:6a00:1a44:b0:52a:ecd5:bbef with SMTP id h4-20020a056a001a4400b0052aecd5bbefmr24021554pfv.28.1661247180774;
        Tue, 23 Aug 2022 02:33:00 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:33:00 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 8/8] KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters scalability
Date:   Tue, 23 Aug 2022 17:32:21 +0800
Message-Id: <20220823093221.38075-9-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823093221.38075-1-likexu@tencent.com>
References: <20220823093221.38075-1-likexu@tencent.com>
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
 arch/x86/kvm/svm/pmu.c | 85 +++++++++---------------------------------
 1 file changed, 17 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index e57eb0555a04..c7ff6a910679 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -23,90 +23,49 @@ enum pmu_type {
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
+		idx = (unsigned int)((msr - MSR_F15H_PERF_CTL0) / 2);
+		if ((msr == (MSR_F15H_PERF_CTL0 + 2 * idx)) !=
+		    (type == PMU_TYPE_EVNTSEL))
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
@@ -122,16 +81,6 @@ static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
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
2.37.2

