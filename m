Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B70521478
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 13:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbiEJMBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 08:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241393AbiEJMBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 08:01:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB2553B64;
        Tue, 10 May 2022 04:57:26 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cq17-20020a17090af99100b001dc0386cd8fso1934709pjb.5;
        Tue, 10 May 2022 04:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+ri3ZfuN8FuVbSM//0lu8Toi01vpQqcUZp67pKtVbk=;
        b=LNtmuy58omRFRozovkqcW+xsZL6/z3+iz9w5LCVdNDQ51/haSM+16lwhxmP6rykSFE
         KzcuAXy7KOUCxC29OU5+kHT2q6Y8vHpPgZTAo6zT5bQha4nAxfBNRxcgVWxIJq69oZ4e
         qrXr83+xBI6KXhRF5z86ysmJrUVlfxoIp4kV3ATqjyg7wFwfEcMAy1RDCfIcqI9PrPef
         8sFhEYmZjFZVD2NBjz01h8PGpeA5mP1zjmhdB/PiN/rbEJkFqOZFYNrGoR4m+C22E5HS
         HzFajf/lI8AswYT5jZiekylbky4v0ajGl2WpH3gbiALlzvwe6DcF9x5qsY3DjlcdJJzn
         MWzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+ri3ZfuN8FuVbSM//0lu8Toi01vpQqcUZp67pKtVbk=;
        b=BnHQyW57CXcCM4kukHu/BkI2IpsIuJlTQl4NQYL0kHFFxmYEbWeUUQRGnVgxZ7Q48C
         IfGzW2aPkSUWm6715cDnzc4J5JKMUWMBuEldSA36UTmHOXu9tDdMnld6MztXzSMNYRPA
         lvfmVUW4Bn/ex2QJMPhp4+lG2yEfAbs5UwuxwdqTis0Jpyk8kkrxg6OBwSlozzx1EvPw
         nJmF3gvmmtfF28AIWUGUeHXxrDhZN0vtEDiytjQiZKdZ0cKiskVZgQgIAPvY/U9m6qI9
         fvYrZdKO6y2ygHEsj6r1igeY8M5XFAEQL8iU41JhZZ057+LekNmBkxJu57aewcJiFWDZ
         hawA==
X-Gm-Message-State: AOAM5304AwfoRjbbVzhhekT5/zeh3XQrrg6aHSbny9wepL7WDcJhMGqn
        hE0Z45xj7N9BaT4E3tCorGA=
X-Google-Smtp-Source: ABdhPJyIeP8oTcjQ3VMSFESdLsCog0TR/cq6n8yCgtgSImIplBUC0qVSZiWewGA3g4HwfQnLyFi06w==
X-Received: by 2002:a17:90a:de87:b0:1d9:8264:baef with SMTP id n7-20020a17090ade8700b001d98264baefmr31351167pjv.227.1652183846333;
        Tue, 10 May 2022 04:57:26 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.81])
        by smtp.gmail.com with ESMTPSA id m21-20020a62a215000000b0050dc7628194sm10460463pff.110.2022.05.10.04.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 04:57:26 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, sandipan.das@amd.com,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement amd_*_to_pmc()
Date:   Tue, 10 May 2022 19:57:17 +0800
Message-Id: <20220510115718.93335-2-likexu@tencent.com>
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

AMD only has gp counters, whose corresponding vPMCs are initialised
and stored in pmu->gp_counter[] in order of idx, so we can access this
array directly based on any valid pmc->idx, without any help from other
interfaces at all. The amd_rdpmc_ecx_to_pmc() can now reuse this part
of the code quite naturally.

Opportunistically apply array_index_nospec() to reduce the attack
surface for speculative execution.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 36 +++++++++++-------------------------
 1 file changed, 11 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 68b9e22c84d2..4668baf762d2 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -45,6 +45,16 @@ static struct kvm_event_hw_type_mapping amd_event_mapping[] = {
 	[7] = { 0xd1, 0x00, PERF_COUNT_HW_STALLED_CYCLES_BACKEND },
 };
 
+static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
+{
+	unsigned int num_counters = pmu->nr_arch_gp_counters;
+
+	if (pmc_idx >= num_counters)
+		return NULL;
+
+	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
+}
+
 static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
 {
 	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
@@ -164,22 +174,6 @@ static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
 	return true;
 }
 
-static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
-{
-	unsigned int base = get_msr_base(pmu, PMU_TYPE_COUNTER);
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
-
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
-		/*
-		 * The idx is contiguous. The MSRs are not. The counter MSRs
-		 * are interleaved with the event select MSRs.
-		 */
-		pmc_idx *= 2;
-	}
-
-	return get_gp_pmc_amd(pmu, base + pmc_idx, PMU_TYPE_COUNTER);
-}
-
 static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -193,15 +187,7 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
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
2.36.1

