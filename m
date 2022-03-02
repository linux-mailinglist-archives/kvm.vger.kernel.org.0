Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9B34CA2EF
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 12:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241240AbiCBLOo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 06:14:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241283AbiCBLOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 06:14:41 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB56F60062;
        Wed,  2 Mar 2022 03:13:49 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id d187so1634717pfa.10;
        Wed, 02 Mar 2022 03:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bQfqq7NPJa3dpih8pieKvYThWwyxqyyg9S3gYEPXDpE=;
        b=M5Sp6bR4yQXT4U8AY93+H5kqm8ZrIyK5wMb0dGfznsJwRnGxl9EETQWPO8vLdzaMxj
         5vFoHbaE+QJK60aGCJ2LBC/o52keeXMqD1OaiycfnIrF0rs2IEH37lq+b4MU04XBVhe6
         W5cVN9SHhlJz7+MPLUmYIevUHhkdpYnaWab6eT/GhFE7v2CGhE/G6fhrpz/XkOq3VNSc
         OE8otWyyD2500Bg5bhzzeLBqf2GCbWO3NfeVMos+XHgvhUkn8Jy5Oz0f/V8spB7XKN5T
         q8SyJbd1CVk3uZlryS/Bbculyl6DK4LXV/SfoRBcd9TmlRk/sZL5rHXCezjTUbh1ovR2
         pkGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bQfqq7NPJa3dpih8pieKvYThWwyxqyyg9S3gYEPXDpE=;
        b=nTtMT4CijVO1QgyiNCPMTRZGlLk1k77Wp1tfzYb8S7MobMRuNZHGt0tA+uMSiVzOmy
         mWetMVyEruCCwSp/tYkT9gQafxS2xlZfwzlQdscTBddOTNx6Ip30P147fwxW7S7+0hbo
         xCOvqFej+kCW0L0QN/KXNDs/yig/0wctupcF6/014cVBviBaWftKfUpH6qN8fvo/igny
         z6l2Xc7bo5GlIKHS2h64bpuOg4ydH6gr6+GTW45KKw/QFstNN4JpRUv6AiaWzfXQkyKv
         iB1I37sixw//CdeQ5hmujJSrwU+kLJSFJ8EDYqW1stf+V/3lU9dvJ6UGZeiRHnk9a03/
         dz5A==
X-Gm-Message-State: AOAM530TAghe9xhl4uRMqBhStqvc1UBddourtDzwLGcnKXjnIDwS2q9t
        VqZBgbHICIVORvQZiAOmB3E=
X-Google-Smtp-Source: ABdhPJyWqse28KxG1ouc+wCsVJRaVlyIHqtoSCQJ2VKb3bHKhsxnIfJLMZfEw5khe4Xg1EVq5K5ewQ==
X-Received: by 2002:a05:6a00:ad0:b0:4e1:2d96:2ab0 with SMTP id c16-20020a056a000ad000b004e12d962ab0mr32495037pfl.3.1646219629410;
        Wed, 02 Mar 2022 03:13:49 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id v22-20020a17090ad59600b001b7deb42251sm4681847pju.15.2022.03.02.03.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 03:13:49 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Like Xu <likexu@tencent.com>
Subject: [PATCH v2 02/12] KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
Date:   Wed,  2 Mar 2022 19:13:24 +0800
Message-Id: <20220302111334.12689-3-likexu@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220302111334.12689-1-likexu@tencent.com>
References: <20220302111334.12689-1-likexu@tencent.com>
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
index 3f09af678b2c..fda963161951 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -182,13 +182,43 @@ static int cmp_u64(const void *a, const void *b)
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
@@ -200,17 +230,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
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
@@ -245,23 +265,14 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
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

