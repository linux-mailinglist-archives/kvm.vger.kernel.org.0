Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C305B57C918
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 12:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232488AbiGUKgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 06:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbiGUKgJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 06:36:09 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4936A9D3;
        Thu, 21 Jul 2022 03:36:07 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s206so1294050pgs.3;
        Thu, 21 Jul 2022 03:36:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rk4YQEFZ9q3XkvsAPJzCLl3rTK6rSHOeH4GBUtkHDEc=;
        b=mj4kSgA8HGlu9Nw+Ii1qbzC6c5a71cbDpWq+8HbTfKQMJt6q53h7dzGfExghUxqZ0L
         VNjYxMAhM8QpDjpLuGA0Sjjio/1ip231Ov2k9hJMOsV59GtiWlvwna5GMLwR1Dl5hc0Z
         srdJJTXsyMe3EofYXsCSMS4lLKxNNg1SBlpvSL5V5jyknYGxa9M/HpExC4Ai0FMTqor8
         vom/aUynFWpt0ZUGeIK0yIf8BAy+6tZjWHWTsTIBomiCkIzMqPub8ePIcomAySKwED66
         VD/3yZ7un4bl5ZnDjmRbzYTAioo5Rf/uw66GHpNN4a1JtFsZ2DylxTwZwWqQDbXOajCp
         mclA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rk4YQEFZ9q3XkvsAPJzCLl3rTK6rSHOeH4GBUtkHDEc=;
        b=WjTJTNjLnp7LRjWeunY4WnxR34qsvz1x/9mjilr4m5/ElF/X0OZeya/IrlpPjwBFiD
         griIcUQ3eqEzIMm7T1yHyiESZrNhlEXPuV6JDFWUfJ/EzGC5U1FnAi2FX0bD5ez5mAj+
         sytRlY+3/EHxp6U/7Mf7RbxJSfSAxL2POlhV3dDPTyCPAbvd8kw4ACAWQj1l33V+qE5c
         7ZlWharKQrylOHwQWKCs46CHIx0doHHmM4EflQDU3RnLCAtlsuYaUydZIWvQ7gxEc/03
         eRz8gqHDa3ym5PrqMGWnLZOYeynSKAKThAS4iP/jerNvTj4sp9wE+0bVwMm7yl/4LA1M
         osrg==
X-Gm-Message-State: AJIora9pLmgHBnBE5t6d0B+ppbDdLO7yJ7KcN5C161GBXJBHyjQg0aqm
        dskgeuRLdt77WMwKHUUAN6s=
X-Google-Smtp-Source: AGRyM1txJN0FEip0oGXy99I4KACumLEOC/+1s1HhOdVlBU3UjbAWgK+YkWGXz4gokpajNc1K6s7Ipw==
X-Received: by 2002:a62:4e04:0:b0:52b:30f5:59b8 with SMTP id c4-20020a624e04000000b0052b30f559b8mr34941989pfb.37.1658399767349;
        Thu, 21 Jul 2022 03:36:07 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id q12-20020a65494c000000b00419aa0d9a2esm1161887pgs.28.2022.07.21.03.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 03:36:07 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 5/7] KVM: x86/pmu: Avoid using PEBS perf_events for normal counters
Date:   Thu, 21 Jul 2022 18:35:46 +0800
Message-Id: <20220721103549.49543-6-likexu@tencent.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220721103549.49543-1-likexu@tencent.com>
References: <20220721103549.49543-1-likexu@tencent.com>
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
index 22793348aa14..97236b6cbe04 100644
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
@@ -404,7 +400,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
-	u64 reserved_bits;
+	u64 reserved_bits, diff;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -425,7 +421,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -440,7 +438,9 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.37.1

