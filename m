Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5DC24FB79C
	for <lists+kvm@lfdr.de>; Mon, 11 Apr 2022 11:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344447AbiDKJiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Apr 2022 05:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344444AbiDKJiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Apr 2022 05:38:03 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A707917040;
        Mon, 11 Apr 2022 02:35:49 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id p25so7372479pfn.13;
        Mon, 11 Apr 2022 02:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S3CmUzSdA0RYNyNJRXH3lJpoghz9EL53OwgRkYTpCfM=;
        b=jqBNyi1p17ZlXd5wyyexOmujQLCHTJvKkaQqHtJTC5RVtgwZeRfUzpX1kFumK1BFdy
         ixmMlRx4zaRoUpc/adZL/ePE9bAd4ol2VCjLSTwZJjP/d7PeQlJmQqeQUBSqnOn9IFUH
         l1O+TzhEAwPkZPsKfSzNm1m2NSquByTJtk2EY4JY1gFEV9UnPoJd6+Wi9rkeX+0gZDTC
         DvJdclySrPCGCiypCeHa85ZjBNcAAn0yrxVT0TGgnuJ9th/0VJrwU2rkc1myXsU4fxZ9
         GPRUwgXbEqf+oTOQTDGQw+T1Rtqo/h0ahLIZ/NPZ6TXBFv89lDO4UUzMBFrbpmlEMyEL
         eV+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S3CmUzSdA0RYNyNJRXH3lJpoghz9EL53OwgRkYTpCfM=;
        b=3y+TPk/k6mAobTKj/pljG2++JTSpuVI9GLsSavyjRMmnGowLgcjxXcIDi1B71u0eHJ
         Ai62ISh2ZnD0mj4ZVdLVPM9xRBTcIjO/0gYGJpmKPfcYUllZNy4StWQG56UBmev/arN2
         0ERdMa+TOVOOaOV9eKpeWPT//p2CC31TNJFoVRLS3V6Q99KO3pi9qc6XVFzIfTblq8rW
         b4pV4gZZhFBqS127sw8hRrJi3IJJH07qY+DAYnl4j+qf3u1Jn8tQlWicMuqtHLc3XUzx
         5d7RTCEgl/STMgVBs8spFynhvvTPbMsE4hx2kYH0NVAlDfLAAZyCuTkBwH26iMOUQvqp
         TlaA==
X-Gm-Message-State: AOAM531nMHPKz5KyAVAfyqnhRIFzx8NQlx6+v0ENPenJB5jWDW4vWekY
        Jx/NrUBv5qsdjFeotu7vaWM=
X-Google-Smtp-Source: ABdhPJwp1WjZtcT1MItnPzEdlgZElWGWjyIsTX3fHj+49OqaXJFlkZ5+6NHUsF+zhnoQqeZpsJshMg==
X-Received: by 2002:a63:fc18:0:b0:39c:f431:8310 with SMTP id j24-20020a63fc18000000b0039cf4318310mr13281487pgi.433.1649669749223;
        Mon, 11 Apr 2022 02:35:49 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id k10-20020a056a00168a00b004f7e2a550ccsm34034426pfc.78.2022.04.11.02.35.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 02:35:49 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH v3 02/11] KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
Date:   Mon, 11 Apr 2022 17:35:28 +0800
Message-Id: <20220411093537.11558-3-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411093537.11558-1-likexu@tencent.com>
References: <20220411093537.11558-1-likexu@tencent.com>
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

Checking the kvm->arch.pmu_event_filter policy in both gp and fixed
code paths was somewhat redundant, so common parts can be extracted,
which reduces code footprint and improves readability.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/pmu.c | 63 +++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b52676f86562..00436933d13c 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -205,14 +205,44 @@ static int cmp_u64(const void *a, const void *b)
 	return *(__u64 *)a - *(__u64 *)b;
 }
 
+static bool check_pmu_event_filter(struct kvm_pmc *pmc)
+{
+	struct kvm_pmu_event_filter *filter;
+	struct kvm *kvm = pmc->vcpu->kvm;
+	bool allow_event = true;
+	__u64 key;
+	int idx;
+
+	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
+	if (!filter)
+		goto out;
+
+	if (pmc_is_gp(pmc)) {
+		key = pmc->eventsel & AMD64_RAW_EVENT_MASK_NB;
+		if (bsearch(&key, filter->events, filter->nevents,
+			    sizeof(__u64), cmp_u64))
+			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
+		else
+			allow_event = filter->action == KVM_PMU_EVENT_DENY;
+	} else {
+		idx = pmc->idx - INTEL_PMC_IDX_FIXED;
+		if (filter->action == KVM_PMU_EVENT_DENY &&
+		    test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
+			allow_event = false;
+		if (filter->action == KVM_PMU_EVENT_ALLOW &&
+		    !test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
+			allow_event = false;
+	}
+
+out:
+	return allow_event;
+}
+
 void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 {
 	u64 config;
 	u32 type = PERF_TYPE_RAW;
-	struct kvm *kvm = pmc->vcpu->kvm;
-	struct kvm_pmu_event_filter *filter;
-	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
-	bool allow_event = true;
+	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
@@ -224,17 +254,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!(eventsel & ARCH_PERFMON_EVENTSEL_ENABLE) || !pmc_is_enabled(pmc))
 		return;
 
-	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
-	if (filter) {
-		__u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
-
-		if (bsearch(&key, filter->events, filter->nevents,
-			    sizeof(__u64), cmp_u64))
-			allow_event = filter->action == KVM_PMU_EVENT_ALLOW;
-		else
-			allow_event = filter->action == KVM_PMU_EVENT_DENY;
-	}
-	if (!allow_event)
+	if (!check_pmu_event_filter(pmc))
 		return;
 
 	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
@@ -267,23 +287,14 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 {
 	unsigned en_field = ctrl & 0x3;
 	bool pmi = ctrl & 0x8;
-	struct kvm_pmu_event_filter *filter;
-	struct kvm *kvm = pmc->vcpu->kvm;
 
 	pmc_pause_counter(pmc);
 
 	if (!en_field || !pmc_is_enabled(pmc))
 		return;
 
-	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
-	if (filter) {
-		if (filter->action == KVM_PMU_EVENT_DENY &&
-		    test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			return;
-		if (filter->action == KVM_PMU_EVENT_ALLOW &&
-		    !test_bit(idx, (ulong *)&filter->fixed_counter_bitmap))
-			return;
-	}
+	if (!check_pmu_event_filter(pmc))
+		return;
 
 	if (pmc->current_config == (u64)ctrl && pmc_resume_counter(pmc))
 		return;
-- 
2.35.1

