Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2625588C95
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbiHCNBt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiHCNBr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:01:47 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81081B7E7;
        Wed,  3 Aug 2022 06:01:46 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q7-20020a17090a7a8700b001f300db8677so1964516pjf.5;
        Wed, 03 Aug 2022 06:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkm/gMyaSfsgZa6BAvqiI+XJ+6EHE76B0lrGvtObm68=;
        b=L/SijQ11QQB4tA2T/w89ghqjitftl7G35W0WKZ3y6fMlQ+KHVOLgBzPuVBWsUIrOLi
         MUU4xW5lisRPxH/PtGgzP3/1X26bFTOGlnkAZ63bO8HPmTHj+x6Pf0OzweHmJkxAzK7O
         Jlwa6Gpgb2bJNknRoSnrobta3oK8MpK2mto6zEBDSpLAoLfUCKeeaX6guUFZwmM4DkuB
         FSn2t0DmmiPigBX2GauHNx94MZ+bvSsA3UXwFXAPhGWGaL0lGxITIjUclUqGB47RK9sE
         amybsoxbepanZyPD0YbKqS8PjDQoO58Q0cVnGI3UBXgwfcDyHoDSos+7T/wQUxXlg5O9
         X1xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kkm/gMyaSfsgZa6BAvqiI+XJ+6EHE76B0lrGvtObm68=;
        b=CW5mW9qrhBLcUb0QNs9JnkGgtYhAKjSXxiEAxIR5JCcT8FwIk7cagZ884T+DdGo7P4
         1pLDZBYKda6uE6Knm1FrUrfk9aOpaT3qwKkyOnuZEKgg6hsv7wc09ZKzCFJIoFLo+Lai
         zduXAuKFqzqJnJIgRBNH1hMelsiXrT0+pDhtjj78pmQfN45GX3F5N0s7v/3QhUUr4nVD
         FNgLx3cGe5V0dQHRFOgpN7Jd+K7D4Ag5s1eCBmUrHj21Jr57fWiMs54RQg5KbHyEpQwe
         AbQvlAFGisRH93ptEeVUyirirAWT++7/VnyAO5Ag9POSBm8W7og6YdC/mXtTU72twMrq
         7Sog==
X-Gm-Message-State: ACgBeo2ya1iDNvsH9NS6XQDiPamhp0/f8qvArrRNV6fxRKKktDSUTL7y
        CCeV/BRAFoRGX1QTwbTnlGM=
X-Google-Smtp-Source: AA6agR5oniDmiwWiAAG3wuydieVGKh0x6Lwc+40CC2AWxzv1cu6xbRlS/gV7Dc6Jy85GJGXJ55zUnA==
X-Received: by 2002:a17:90b:ec7:b0:1f2:fa08:44cd with SMTP id gz7-20020a17090b0ec700b001f2fa0844cdmr4767178pjb.183.1659531705888;
        Wed, 03 Aug 2022 06:01:45 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id k3-20020a170902c40300b0016f1ef2cd44sm198058plk.154.2022.08.03.06.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 06:01:45 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: x86/svm/pmu: Rewrite get_gp_pmc_amd() for more counters scalability
Date:   Wed,  3 Aug 2022 21:01:24 +0800
Message-Id: <20220803130124.72340-2-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220803130124.72340-1-likexu@tencent.com>
References: <20220803130124.72340-1-likexu@tencent.com>
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
v1: https://lore.kernel.org/kvm/20220510115718.93335-3-likexu@tencent.com/
v1 -> v2 Changelog:
- Move amd_pmc_idx_to_pmc() to the front for reuse;
- Apply msr_base and ratio semantics to the switch statement;

 arch/x86/kvm/svm/pmu.c | 85 +++++++++---------------------------------
 1 file changed, 17 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index d1c3b766841e..d90af8cdd405 100644
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
2.37.1

