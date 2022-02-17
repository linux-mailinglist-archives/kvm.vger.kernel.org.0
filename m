Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0FD4B9B3C
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 09:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237804AbiBQIg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 03:36:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237579AbiBQIg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 03:36:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C3129A568;
        Thu, 17 Feb 2022 00:36:13 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so4758271pjm.2;
        Thu, 17 Feb 2022 00:36:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/TBhBCbqgGLkrSfwe557uNk0DpF24Rc/4Efq4hPMXTs=;
        b=SX7/In6dvYlBY75BkEpSCRzuwxjuoEiSFQQT8C4Ag8Sujft9j19gNJFIiziNmrUsMP
         /SA8S7Gt43bJHJ7JgfDNN0lVbpdL9wW1L5ebYB00q/p55MF+UBfSnWQzFIz5ciy/RVfe
         Ao6qXWj4fXmbLyqhwVrw7I+uoSMsfN3eWqMlritELeoDzdhvd4rD1OAw7FTg8z1bQP30
         r2n7K4QLRqfo7aeoy7IbFzyjvYRBRpLWtunXvfENdqq8VqU7gIpLWeBLzV/QX+t/QnqR
         JFcACH1iuB77U+O/Ue74N8Nah/pLfoRloWSa1nRQrdcnJdxyIvqHb9M3xsfS2Oa7+c59
         wUNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/TBhBCbqgGLkrSfwe557uNk0DpF24Rc/4Efq4hPMXTs=;
        b=KaVgQLxzDxPP9C4RI6bW3IbVlycQn/NRbKdIASH7pxKWLtbqCqqJYuytoUyk8rJLUb
         PlAgw9K3ozc9lHpBcxxKiLwxRhxnTW49HXW8dHj0339nHKREWDOmEBj+3hNr/ZZjw5Ff
         YClMDoKygscqc5aZQ9Z/Ckq++RYT4JBGq6ZzKgTK7tyVeg2QDOcsj0YJKuYEIPUzi4W0
         /I7Cr11f/SYbLaUxErPD4Q4C8IqvUNs951ydB0y/1U116WPbDj+MVkuenpCj880WB6pN
         agIXJte+Lc5Q/222G99rtUYFbSBTSEpWVY3ptt1Rm1P1PZHaEo/Sh7hYUpSqeE51wpvX
         NBzg==
X-Gm-Message-State: AOAM532QQF5cwLDeDs8dG1Gg9llF6RxfU7JqyBb4yAlFaGvWuzv1mQU5
        7aEN55dIOZrsRcCSvyFh2aI=
X-Google-Smtp-Source: ABdhPJyA5XjxTU0tUv/e7TSo1fklrCpnDGB5vldR0gyDm3r+eJ1HR39sf+UhsZo6lmobfUcRm16Eww==
X-Received: by 2002:a17:902:da82:b0:14e:bbe8:35e6 with SMTP id j2-20020a170902da8200b0014ebbe835e6mr1805773plx.13.1645086972790;
        Thu, 17 Feb 2022 00:36:12 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a17sm5475843pfv.23.2022.02.17.00.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 00:36:12 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Eric Hankland <ehankland@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: x86/pmu: Extract check_pmu_event_filter() from the same semantics
Date:   Thu, 17 Feb 2022 16:36:00 +0800
Message-Id: <20220217083601.24829-1-likexu@tencent.com>
X-Mailer: git-send-email 2.35.0
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
which reduces code footprint, improves readability and facilitates
the maintenance of SRCU logic for pmu_event_filter in a one place.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/pmu.c | 61 +++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 25 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f614f95acc6b..af2a3dd22dd9 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -179,12 +179,42 @@ static int cmp_u64(const void *a, const void *b)
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
 	unsigned config, type = PERF_TYPE_RAW;
-	struct kvm *kvm = pmc->vcpu->kvm;
-	struct kvm_pmu_event_filter *filter;
-	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
@@ -196,17 +226,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
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
@@ -241,23 +261,14 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
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

