Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C3F5A7981
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 10:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbiHaIyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 04:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiHaIx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 04:53:59 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C286FC9259;
        Wed, 31 Aug 2022 01:53:57 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id t129so13782937pfb.6;
        Wed, 31 Aug 2022 01:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=M85TwFsU78GuR/7MUBP0eSGrfptr74I6oc9jGB2T7VM=;
        b=Cspwi3zn09b/MwMNZiK7l/lGBbAB3fZcqxlrwsFDv6GySpcp6MdOyp2OOXPePLXbF0
         ZVhbHKtmCeHaQzmvcdRJdh1pUSO0W9FmeYZD/sB3w0SkVXeanrI6KkBQsEOAgheXn6zX
         obc8K3RxE0CAzrV1bZ3cH1LhrkuW2xhiN/pmuVL47DppXbaM/SOSynhHtElEDyAZhlLl
         TN/EAk9WtPcvpycd50kVr2NydPGqhrUjdAWOSeGCewYknzh3bYqs2eupKDBLGc9H3AqL
         LjTXBw8ju23ESUuxwgOxgGg3ErHsHHYGqzxLiZNbvoKRNAYoHj+DgBwBwGvRi0wdM9r9
         GnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=M85TwFsU78GuR/7MUBP0eSGrfptr74I6oc9jGB2T7VM=;
        b=EK/fGvvUz1NUFq7Oa1zBCYVdj9eDB8kFbiZSVm3Y1AT/0XTcRLNe1QTJQXhQc24Zcp
         iXxvU39i+87b+QxRimTln5aPbH3KDSsLy2hcXzZ2l86MrUTFXwthMMb91hqw1uRbvVJI
         RsDh5n3NRqRXS4gVKzaEwfqW4quKVyVatCQsFk2WV3rcLRAD6edRF+BN3tjqRHYSNqvN
         Ll+TPYW0z334h2XE74/d49Q9SHtPqoqTMjm4FwjtXl3BimuzYTdp97DTHAX4Tj/km3wv
         nktN5T/caKlIbLYm1Fpp4KqpwoWag4D9t5IhuUFT3UkpTZwZkcve7+eOzEx5mRcdzm+L
         PlHA==
X-Gm-Message-State: ACgBeo2+6wsVDv+ce9R2D81dScM3qTgshbVbWRc/Ht4xSZtvRKfC0tZC
        TQwBzrEX9FF3SnrWjRDD/Op7eSpLBubIKBUd
X-Google-Smtp-Source: AA6agR7ojae63TXUxDxAsKxmg8yiWyE1+VTYv1EZ/jpbXf4zDDovjgrt1V0AWhgI1vSaKTaUOzvtsQ==
X-Received: by 2002:a63:ce17:0:b0:42a:bfb6:f218 with SMTP id y23-20020a63ce17000000b0042abfb6f218mr20727351pgf.484.1661936037089;
        Wed, 31 Aug 2022 01:53:57 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 26-20020a17090a1a1a00b001fab208523esm868772pjk.3.2022.08.31.01.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 01:53:56 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 6/7] KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement amd_*_to_pmc()
Date:   Wed, 31 Aug 2022 16:53:27 +0800
Message-Id: <20220831085328.45489-7-likexu@tencent.com>
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

Access PMU counters on AMD by directly indexing the array of general
purpose counters instead of translating the PMC index to an MSR index.
AMD only supports gp counters, there's no need to translate a PMC index
to an MSR index and back to a PMC index.

Opportunistically apply array_index_nospec() to reduce the attack
surface for speculative execution and remove the dead code.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 0166f3bc6447..c736757c29d2 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -33,23 +33,6 @@ enum index {
 	INDEX_ERROR,
 };
 
-static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
-{
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
-
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
-		if (type == PMU_TYPE_COUNTER)
-			return MSR_F15H_PERF_CTR;
-		else
-			return MSR_F15H_PERF_CTL;
-	} else {
-		if (type == PMU_TYPE_COUNTER)
-			return MSR_K7_PERFCTR0;
-		else
-			return MSR_K7_EVNTSEL0;
-	}
-}
-
 static enum index msr_to_index(u32 msr)
 {
 	switch (msr) {
@@ -141,18 +124,12 @@ static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
 
 static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 {
-	unsigned int base = get_msr_base(pmu, PMU_TYPE_COUNTER);
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+	unsigned int num_counters = pmu->nr_arch_gp_counters;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
-		/*
-		 * The idx is contiguous. The MSRs are not. The counter MSRs
-		 * are interleaved with the event select MSRs.
-		 */
-		pmc_idx *= 2;
-	}
+	if (pmc_idx >= num_counters)
+		return NULL;
 
-	return get_gp_pmc_amd(pmu, base + pmc_idx, PMU_TYPE_COUNTER);
+	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
 }
 
 static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
@@ -168,15 +145,7 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 static struct kvm_pmc *amd_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 	unsigned int idx, u64 *mask)
 {
-	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
-	struct kvm_pmc *counters;
-
-	idx &= ~(3u << 30);
-	if (idx >= pmu->nr_arch_gp_counters)
-		return NULL;
-	counters = pmu->gp_counters;
-
-	return &counters[idx];
+	return amd_pmc_idx_to_pmc(vcpu_to_pmu(vcpu), idx & ~(3u << 30));
 }
 
 static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
-- 
2.37.3

