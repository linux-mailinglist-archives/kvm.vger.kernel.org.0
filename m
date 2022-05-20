Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6852EE62
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346535AbiETOpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244390AbiETOpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:45:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF1F170F22;
        Fri, 20 May 2022 07:45:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fw21-20020a17090b129500b001df9f62edd6so6557834pjb.0;
        Fri, 20 May 2022 07:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bV1fOV8EkPPKwTjdd+pCTFwZ+Tvzp6iCg5Gu+jWNb7o=;
        b=jYSUm9nn4IZq15zBrPNJHS6DY7JGyShjxIH5jVqHz3lgZUe4TFRyDUIi6Ny2znOkyg
         i/mFcUTWJ1kSTywrvoYWpYustfL3dCTrXzUbLEqBrvafbSxYS7F1quVM1ZXumO6oU0sC
         WXlC4XUm438GrqA+ZKNsk9bPfwleiJZofZgP38x3cTvVYOXvICUE/JW0cEUXtHPVeHLA
         nMV3LVccHDDYLtQm4CQhR0bx75KczIbJXobfeMI2U+G+1wolu6Z5ST819jqOhX80H3tZ
         fS4T1I+V3DSH7sHywI+tZOaIxcOeTqs/hFUq1VSOedpJ2kigBc96Vp3+2mREwXQKOBxv
         nFYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bV1fOV8EkPPKwTjdd+pCTFwZ+Tvzp6iCg5Gu+jWNb7o=;
        b=wkhEMgqUVcxFGn25E9zVuDju5fOrJHXqNf4SjSFwMw98hnjZla1NBak/ywGp/8+UfY
         2AEW/LjBxFwp5rlOiuef5vbcIupi9V8uFt5TmLiCH0pSirV7baQcmdSrcuV5U36A+b+E
         q/71pPcao8sjTnXIbM0U6Q1oX6nF/F6nBFPRXQy9EQ7G+AHgAzzbe8A3TQ1jarxbEp27
         a9WliSPRQkCxj4WSrCMJ3uvxF1Y8SY4+6nScC4IMVOQT+wYpWSY+5TaHaSkCJBSyLfA6
         MTERmnw7lMVg5nhOutnY6EzH3XN+7T9IzbIK9ttcJDC1tY0WnmSIBeXASXd2ONFSl+40
         Gi9Q==
X-Gm-Message-State: AOAM532tKw/WAsE1A380DHLzxIMzbGRLOD3IP0KXMssAIdMLIG4KEZMx
        Qa2Px/LV5yxsffh2WkxwVlg=
X-Google-Smtp-Source: ABdhPJyGaT7E+U0fr95zdMFKOzoFCFHlE57Co3IqQ8mOUYHRFFWs0oGNzpnjz814PubMJ4j+W7U6Wg==
X-Received: by 2002:a17:902:9a42:b0:158:bf91:ecec with SMTP id x2-20020a1709029a4200b00158bf91ececmr10227542plv.115.1653057918534;
        Fri, 20 May 2022 07:45:18 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.25])
        by smtp.gmail.com with ESMTPSA id a13-20020aa7864d000000b0051829b1595dsm1932698pfo.130.2022.05.20.07.45.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 07:45:18 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     pbonzini@redhat.com
Cc:     jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, sandipan.das@amd.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com
Subject: [PATCH v2 2/3] KVM: x86/svm/pmu: Direct access pmu->gp_counter[] to implement amd_*_to_pmc()
Date:   Fri, 20 May 2022 22:45:12 +0800
Message-Id: <20220520144512.88454-1-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510115718.93335-2-likexu@tencent.com>
References: <20220510115718.93335-2-likexu@tencent.com>
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
v1 -> v2 Changelog:
- Remove unused helper get_msr_base();

 arch/x86/kvm/svm/pmu.c | 45 +++++++-----------------------------------
 1 file changed, 7 insertions(+), 38 deletions(-)

diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index a3b78342a221..6cd8d3c2000c 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -61,21 +61,14 @@ static struct kvm_event_hw_type_mapping amd_f17h_event_mapping[] = {
 static_assert(ARRAY_SIZE(amd_event_mapping) ==
 	     ARRAY_SIZE(amd_f17h_event_mapping));
 
-static unsigned int get_msr_base(struct kvm_pmu *pmu, enum pmu_type type)
+static struct kvm_pmc *amd_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 {
-	struct kvm_vcpu *vcpu = pmu_to_vcpu(pmu);
+	unsigned int num_counters = pmu->nr_arch_gp_counters;
 
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
+	if (pmc_idx >= num_counters)
+		return NULL;
+
+	return &pmu->gp_counters[array_index_nospec(pmc_idx, num_counters)];
 }
 
 static enum index msr_to_index(u32 msr)
@@ -186,22 +179,6 @@ static bool amd_pmc_is_enabled(struct kvm_pmc *pmc)
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
@@ -215,15 +192,7 @@ static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
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

