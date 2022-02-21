Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF224BE6D1
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 19:02:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356869AbiBULwo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 06:52:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356864AbiBULwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 06:52:41 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46692BCA;
        Mon, 21 Feb 2022 03:52:18 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id w37so7694594pga.7;
        Mon, 21 Feb 2022 03:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zSEA5ShgmjgGbVmEyqJV29NO0XQwdAjkBZxc1SaUiQQ=;
        b=Sgspyi7sOpqLNdyg+nIZP72GED425zCInXpRNj/6hUQdLNCwfuCRk6QBffDoZx6uZ1
         AI1EQ1WmTH8TAWLCb7HHfVOy9W2glGukahamjorERk+7buyr/qw7kBDL9yhBy4Fxsvte
         NmRdv5S4+XipvoGyGrQurTXRHFDs0CKOnintD6Hk16BUwlcgKlEdIEzn263cc89Of3t8
         hmm3kCvHJ9KbXE6ekwIO8Lg3rnk1q05D79mzCbvBlmMKoItoPLBMWda01xXX4Y25mA12
         MqlQuL1Ua0OH/7al2tacO10CzFAQMIcokKKx6ZjA1jUbFifAXv9ZjkIS64oTRzYG/Pie
         EPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zSEA5ShgmjgGbVmEyqJV29NO0XQwdAjkBZxc1SaUiQQ=;
        b=wNv/oK0XSTmYr/aC5AIkMbxJveooxy5VvSFRAbI1PIUI32ido/6MPgiPDG+YgUAZNe
         5QTz3mZx2GSKGL3Fk+MHQG40FH74dTS9BOiuXGBZjs3ZBrYqnAPfENZvdggSq/vqs/ov
         Lvuf8XX6p+2mIos68EN3DRf1TPtDHFjHS2KJI+RS4Gip1dxJ15ky6TiQo9TMA+C/oUdV
         aP6WmrWoyXz/Vbjn9DARYCoqF9cpq1DU3UcQU+FPIbi+acN7BL4PnQrgKx62dlsrWI3X
         nANdHASpjF7Z1b7SnM8N5Vb1Xytoqp+E+e+J4sxSKeucP+jq1UdaPjo+zy+dYDdeUg03
         c3+A==
X-Gm-Message-State: AOAM531f3nfOkH9dorH7N+HDJWLRDcYi9kpfMtm2XCVz/7n69ZZQ8ou0
        S/MIhL7BC2KAtN8UXslTY68=
X-Google-Smtp-Source: ABdhPJzG6WWKh7gw6qQ/L7I8BzazjMEQUt6kzMEEQJfxMhxCxBK3fXsoANLtNNKYEg1C4QVO3frbAg==
X-Received: by 2002:a63:8bc9:0:b0:372:c564:621b with SMTP id j192-20020a638bc9000000b00372c564621bmr16100579pge.601.1645444338316;
        Mon, 21 Feb 2022 03:52:18 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id z14sm13055011pfe.30.2022.02.21.03.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 03:52:18 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <likexu@tencent.com>
Subject: [PATCH 02/11] KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
Date:   Mon, 21 Feb 2022 19:51:52 +0800
Message-Id: <20220221115201.22208-3-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20220221115201.22208-1-likexu@tencent.com>
References: <20220221115201.22208-1-likexu@tencent.com>
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
 arch/x86/kvm/pmu.c | 61 +++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c4692f0ff87e..78527b118f72 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -180,13 +180,43 @@ static int cmp_u64(const void *a, const void *b)
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
-	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
@@ -198,17 +228,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
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
@@ -243,23 +263,14 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
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
2.35.0

