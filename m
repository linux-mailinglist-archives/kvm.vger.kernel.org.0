Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC22959E232
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358885AbiHWLzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358745AbiHWLxl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:53:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EB3D59A4;
        Tue, 23 Aug 2022 02:33:04 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso14037527pjj.4;
        Tue, 23 Aug 2022 02:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=jibgJOGd240HxEROEv/c/zVWj7my7wQDRjzZTRSYIhM=;
        b=oMLNqAxfBLjtjE01u/Hw9QLDMdq90VWOYmmQRF1gnUac/j5OCmgsh9gWkju2oE4d7W
         zkQ0W02e7NDzXd0Qg/zgCkdQNr6nRQMh8NgiX7DdZw0TTgF0hedIOCQv7D9ooHbrufz3
         NPsyBjOKaT3b1dE+09xEaoEr+9lP3KbwIM0IN/KsXkUteWjPEyI1gkiENKsxa1TyrqTN
         xn8zEebwUEPz4NjROP+CoX5fvi0ywVw/5oQGTMZheKnLLyl8rnPzmi04y6gSdqJbqfiB
         hSowz0Zf6V+53iOfQScYJSc4F8HnPkwxjQNJFfWFXGa2+a1fgkQ8Yq0hiiHTvdjD6JN6
         K8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=jibgJOGd240HxEROEv/c/zVWj7my7wQDRjzZTRSYIhM=;
        b=myrzvCqK8DlX+Bplt3jNYWggSVJoYkvhJWto+yPNhmIvnCxpjJRd8Ou6j7hr4Oyz4e
         1qF9sEh4V6V3u9FMhlxAUhGam/imUkxiT2TRFBej3KP0lrQ22+UJL5Q7PubO01vyIZ7R
         j0hLqspOF+Tw7bkwJWWJa47UsSywD7VmfgQudnsQ3jyg+jtByf6arU+1Fm8cgX3QKoQq
         bFtWOQazgLF1pOlH/mTZf6N+JX2S2WW4gemXJt/QuTAtZI/YB6GkBkZ3sW7Bs3E+nsGI
         K6wz+IavUHmwb8BocncYT1zAP4NDCiPfH7qvWyxLwknLY9JKfm/QK/SKgVullB+kO+tg
         /hqw==
X-Gm-Message-State: ACgBeo0LVhYPd++fIWzS4Lfo50dWt3Op7WrAFwqeNdsWKgMt2TYk1ybl
        lcdYMAYzTtQYf73ih9ruhV4Ud+N6buA=
X-Google-Smtp-Source: AA6agR6WcaW+eA8Nd539bAAzHgymQCdl9IhadkT//t7peiazcYBH6mG9SgMp90MOYT2aqll2ML81rg==
X-Received: by 2002:a17:902:aa87:b0:172:689f:106b with SMTP id d7-20020a170902aa8700b00172689f106bmr23581514plr.127.1661247177916;
        Tue, 23 Aug 2022 02:32:57 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:57 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 7/8] KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement amd_*_to_pmc()
Date:   Tue, 23 Aug 2022 17:32:20 +0800
Message-Id: <20220823093221.38075-8-likexu@tencent.com>
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

AMD only has gp counters, whose corresponding vPMCs are initialised
and stored in pmu->gp_counter[] in order of idx, so we can access this
array directly based on any valid pmc->idx, without any help from other
interfaces at all. The amd_rdpmc_ecx_to_pmc() can now reuse this part
of the code quite naturally.

Opportunistically apply array_index_nospec() to reduce the attack
surface for speculative execution and remove the dead code.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/svm/pmu.c | 41 +++++------------------------------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index e9c66dd659a6..e57eb0555a04 100644
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
2.37.2

