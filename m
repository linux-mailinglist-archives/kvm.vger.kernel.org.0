Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDAD859E26B
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 14:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358706AbiHWLxG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 07:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358488AbiHWLwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 07:52:22 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FE9D51FE;
        Tue, 23 Aug 2022 02:32:53 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 73so11763411pgb.9;
        Tue, 23 Aug 2022 02:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=kmsJThxMpL4fKPHkENmuVnZ9XORtMvlqpgm9TJ9ODsE=;
        b=A78yrInV0cuSgnOfsAcBxJ2wwQwZnjaetvznU7KHMasPcl5tGc/vCy5XkFeeJsp9Dg
         yj7JFhMbZY2O50EgTz/ZJEBG3Ilx1Y6cCptOo7dzs9v2egnU491pA0hWHWKtHRqxAS3i
         xFdZLebCQQzIu3Ax9ombfuzz9pHrzcWPITLttqnTPWiIm3sKBvvfcSwbdwBWRh1C67Zn
         rk33b/2gc77Ft5eZFZEJj0ftfSMZ2CXPb+erGDUENXe2u82Pv2Np84UUWq3KC362LRrD
         0UicxLweea7YS3m/WitDmisYaCZm0p++jTcRIBNgUINoybOZ8fuo3ne5MkcNheOgb1Jt
         GYyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=kmsJThxMpL4fKPHkENmuVnZ9XORtMvlqpgm9TJ9ODsE=;
        b=x2FJAym2m0Aa4nLNMJZHIdcF9RzTwY9RKM8IyWUALHdw+DSYz7ds0+PJVUF63xKcrk
         XxNI4zFl+R43VSUm31WMHj0kdpViPT2oiOYSUXCYFF9Yq11g7wG4gJPb75N/RBLeQMUr
         sripSH8VyWbNCd75gn/WyR7UbhAgTX6ueixPdkAGk1phcilpgJ+YASsx6JcPaNainChg
         BBVKFH/1W9iLDpJOHoJ3yiRkOhNL9O6DBsgUiCNUv+hjk++I7pKP0aQI52b+rn5WK41u
         ZREqtPIk7Fzz+cHyN8TLxb6KdVm66T+XI/2BESs+KBViYWUF5zJTiXkUFk/7WykoMsqA
         9gWA==
X-Gm-Message-State: ACgBeo1pY1Ukfo3Xt9B9tRSNSTp8A3c1/4uxD9KnmTQPWLSrth3Dmbfx
        LVOEpNkDJpt8I5kTHfSNU9U=
X-Google-Smtp-Source: AA6agR7SWSvgMJUf1OLU12wjPib4Z+Of0SWDD5+MxpFkkxBSgGnm77bzrRK3Lgrjff+7U4dumFRNVQ==
X-Received: by 2002:a65:49c8:0:b0:415:e89d:ea1a with SMTP id t8-20020a6549c8000000b00415e89dea1amr19965937pgs.266.1661247171182;
        Tue, 23 Aug 2022 02:32:51 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm10057212plg.265.2022.08.23.02.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 02:32:50 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v2 4/8] KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
Date:   Tue, 23 Aug 2022 17:32:17 +0800
Message-Id: <20220823093221.38075-5-likexu@tencent.com>
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

The check logic in the pmc_resume_counter() to determine whether
a perf_event is reusable is partial and flawed, especially when it
comes to a pseudocode sequence (not correct but clearly valid) like:

  - enabling a counter and its PEBS bit
  - enable global_ctrl
  - run workload
  - disable only the PEBS bit, leaving the global_ctrl bit enabled

In this corner case, a perf_event created for PEBS can be reused by
a normal counter before it has been released and recreated, and when this
normal counter overflows, it triggers a PEBS interrupt (precise_ip != 0).

To address this issue, the reuse check has been revamped and KVM will
go back to do reprogram_counter() when any bit of guest PEBS_ENABLE
msr has changed, which is similar to what global_ctrl_changed() does.

Fixes: 79f3e3b58386 ("KVM: x86/pmu: Reprogram PEBS event to emulate guest PEBS counter")
Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/pmu.c           |  4 ++--
 arch/x86/kvm/vmx/pmu_intel.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 390d697efde1..d9b9a0f0db17 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -237,8 +237,8 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 			      get_sample_period(pmc, pmc->counter)))
 		return false;
 
-	if (!test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) &&
-	    pmc->perf_event->attr.precise_ip)
+	if (test_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->pebs_enable) !=
+	    (!!pmc->perf_event->attr.precise_ip))
 		return false;
 
 	/* reuse perf_event to serve as pmc_reprogram_counter() does*/
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index d595ff33d32d..6242b0b81116 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -68,15 +68,11 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-/* function is called when global control register has been updated. */
-static void global_ctrl_changed(struct kvm_pmu *pmu, u64 data)
+static void reprogram_counters(struct kvm_pmu *pmu, u64 diff)
 {
 	int bit;
-	u64 diff = pmu->global_ctrl ^ data;
 	struct kvm_pmc *pmc;
 
-	pmu->global_ctrl = data;
-
 	for_each_set_bit(bit, (unsigned long *)&diff, X86_PMC_IDX_MAX) {
 		pmc = intel_pmc_idx_to_pmc(pmu, bit);
 		if (pmc)
@@ -397,7 +393,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
-	u64 reserved_bits;
+	u64 reserved_bits, diff;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -418,7 +414,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->global_ctrl == data)
 			return 0;
 		if (kvm_valid_perf_global_ctrl(pmu, data)) {
-			global_ctrl_changed(pmu, data);
+			diff = pmu->global_ctrl ^ data;
+			pmu->global_ctrl = data;
+			reprogram_counters(pmu, diff);
 			return 0;
 		}
 		break;
@@ -433,7 +431,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (pmu->pebs_enable == data)
 			return 0;
 		if (!(data & pmu->pebs_enable_mask)) {
+			diff = pmu->pebs_enable ^ data;
 			pmu->pebs_enable = data;
+			reprogram_counters(pmu, diff);
 			return 0;
 		}
 		break;
-- 
2.37.2

