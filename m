Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1800952BC9F
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbiERNZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 09:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237798AbiERNZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 09:25:25 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7091B5FAB;
        Wed, 18 May 2022 06:25:23 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id c22so2150814pgu.2;
        Wed, 18 May 2022 06:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nbyBZvHwvfXuHRDLwuJO4YuwoVjeLxru2xz7bgaHsoA=;
        b=XFRMHZ4EFhN96DF5t8nI3KHeq8wCB3dypEwnw4WFM+ULafJ3ctRgHm6hlAIXMxlQGE
         D/pYTTzeCCqjbNamm4WFlDaXAw0W2nxivuFxScPT/vUJSoZyROV/Ckn9HI04WvdPjjxf
         MVX/tPNfpLPLVYkT3CJpd7t6wzqI3kFMik4kyMLRjgdt3AGwadrrO/PcIMlYOX8YB1Bc
         mnxidux5qToY5IERPu90jjgShrvKrLlmpKUP/K83SQyfuOhFWmRnICulvSCIv07XwhPY
         sC+xk2pr1mb3KvwzBFQ5FT1U82Bqg8sdp1m5NYLguwTeE+a/K8h0JWRAkwtJe/Cbom4i
         m3/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nbyBZvHwvfXuHRDLwuJO4YuwoVjeLxru2xz7bgaHsoA=;
        b=b7hgKVzb5thtDDH+w64Ig49FKNHrLd0IfhQALAsDYvut9DFZs807EJAs3Zk5ofBpSZ
         OatqSYoqQJzhSpEcwJjnTPBIzUFTp0NHfL9eQPMo+Af71u4pugdTE9OzVdEcK7Al6Vxu
         14TTktnCtuMjlk4sC06G6X+AgOSIGyDTwwZwl/an9I5CfzZH0ejm/GA8Fz6innHPSuxF
         l8M4oy08Hp9z0hEKhEDZxkMKA3gXwQ/5CyZrp3ZPzwU3ZxuQHyfYPF3DSD4ITECATdcc
         0Fkxo6r+Q9nhwcScV0ZcWeX5LbvSTvezMCH4Vg5xBR8hVrrYkWFnfvtmGkLBFkgJXA8D
         /D5Q==
X-Gm-Message-State: AOAM530RuFqCMnpKJaUj7ixsbp3imKgSUcVaMufg8xtO9BzzssGHK8p9
        83FKa1kBjpUgZMxYL4aMWoc=
X-Google-Smtp-Source: ABdhPJwt2saGt5mtepV0elRXunnYmCUxL5aedI7Xr/D+wwgnmqo5KfWVDrYi+qCJG5JPB7oPSRcqDA==
X-Received: by 2002:aa7:88d2:0:b0:50a:cf7d:6ff1 with SMTP id k18-20020aa788d2000000b0050acf7d6ff1mr28259176pff.67.1652880323228;
        Wed, 18 May 2022 06:25:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.gmail.com with ESMTPSA id s13-20020a17090302cd00b0015e8d4eb244sm1625549plk.142.2022.05.18.06.25.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 06:25:23 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH RESEND v3 02/11] KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
Date:   Wed, 18 May 2022 21:25:03 +0800
Message-Id: <20220518132512.37864-3-likexu@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220518132512.37864-1-likexu@tencent.com>
References: <20220518132512.37864-1-likexu@tencent.com>
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
index 3e200b9610f9..f189512207db 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -240,14 +240,44 @@ static int cmp_u64(const void *a, const void *b)
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
@@ -259,17 +289,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
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
@@ -302,23 +322,14 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
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
2.36.1

