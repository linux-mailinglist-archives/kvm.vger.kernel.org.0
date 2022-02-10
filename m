Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379F74B0A82
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 11:26:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbiBJK0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 05:26:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238573AbiBJK0M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 05:26:12 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7FEB92;
        Thu, 10 Feb 2022 02:26:14 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id 9so6529788pfx.12;
        Thu, 10 Feb 2022 02:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S3brhBb+bSmy7kWwrAStLjrdT1gd/LIODsFcqQLD4DQ=;
        b=ThVMKztpRfKTy8XRFBBwfFFDavDQ1+6xwPwMrm1vPQRijO2IjB9rpgJn//wqkf1mjS
         /JxYjQtcEbVGSfB/6vJlq4LhNEoTx6P32HyiCg0FaGyRSWdc48KPQewzRcGu2IUxdVZy
         lShqP7Z7wY/ZYVOi4nMq7WTWJhMR26QoXBigUhKjIV0epqTjwnu6xkLWwuSDa/She12S
         EDqTrUMpVykaH0vLzwOcqF0URLSFAW5WhqpC/uFo1bxO5xoAm2ZTz2RKFrMSmnCiRSVl
         RBWfkvSMP2c8NmOdSsliBI4e4kylMZMnMbv9pcjLwm61KuonJNNYHdlnTXV+GobvYt9q
         2pXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S3brhBb+bSmy7kWwrAStLjrdT1gd/LIODsFcqQLD4DQ=;
        b=jjCEjPZEZSNzeLJdyYYMW9na5XtjfAASYsDj9skkBDroyJPNo0SkTgddhHpi4B5nTK
         c0sZiwU2i8rHcUfQXpAo4K4gVmTCiSOcJCSLlAFfjUo3rRpK5b497y4zKOtVYGM7TVHB
         hrV3StLs3JwJXSd5gZ0c1NyPwn3mmpeSNkbYw89a17AxXwRGnSdqRjsrzHziIcWp8yHd
         1OVf/2vsCvrXSG9npzcDofmVQcVV5MV+1OWXsKSEq3Z7ccwQaop4RphFR8yq8sdv575r
         /3/ai0zD8wBX6WPf4xy+LgbN115Bd0Z+91U02AyneTSU/ILm3Bm1NgAWNInv6qN0q5/P
         lpsw==
X-Gm-Message-State: AOAM5324RNV1YrbWAvqVfeb/zMbOu3QGmQOCf4oLqY4By5vGEGbhJ70l
        AsO4xask2THBj9Squ/tfr6Rw8qmXB4jkkGTOlKg=
X-Google-Smtp-Source: ABdhPJwuxHSAEKlJLK7gS3sI6+I73ZHYogHHWMo136AeW6Lyw4akalgxs0AUePN0kRApMjNCmONxPA==
X-Received: by 2002:a63:982:: with SMTP id 124mr5724006pgj.438.1644488773695;
        Thu, 10 Feb 2022 02:26:13 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w2sm6916757pfb.139.2022.02.10.02.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 02:26:13 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/pmu: Distinguish EVENTSEL bitmasks for uniform event creation and filtering
Date:   Thu, 10 Feb 2022 18:26:03 +0800
Message-Id: <20220210102603.42764-1-likexu@tencent.com>
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

The current usage of EVENTSEL_* macro is a mess in the KVM context. Partly
because we have a conceptual ambiguity when choosing to create a RAW or
HARDWARE event: when bits other than HARDWARE_EVENT_MASK are set,
the pmc_reprogram_counter() will use the RAW type.

By introducing the new macro AMD64_EXTRA_EVENTSEL_EVENT to simplify,
the following three issues can be addressed in one go:

- the 12 selection bits are used as comparison keys for allow or deny;
- NON_HARDWARE_EVENT_MASK is only used to determine if a HARDWARE
  event is programmed or not, a 12-bit selected event will be a RAW event;
  (jmattson helped report this issue)
- by reusing AMD64_RAW_EVENT_MASK, the extra 4 selection bits (if set) are
  passed to the perf correctly and not filtered out by X86_RAW_EVENT_MASK;.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/include/asm/perf_event.h |  3 ++-
 arch/x86/kvm/pmu.c                | 11 ++++-------
 arch/x86/kvm/pmu.h                |  6 ++++++
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..bd068fd19043 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -43,8 +43,9 @@
 #define AMD64_EVENTSEL_INT_CORE_SEL_MASK		\
 	(0xFULL << AMD64_EVENTSEL_INT_CORE_SEL_SHIFT)
 
+#define AMD64_EXTRA_EVENTSEL_EVENT				(0x0FULL << 32)
 #define AMD64_EVENTSEL_EVENT	\
-	(ARCH_PERFMON_EVENTSEL_EVENT | (0x0FULL << 32))
+	(ARCH_PERFMON_EVENTSEL_EVENT | AMD64_EXTRA_EVENTSEL_EVENT)
 #define INTEL_ARCH_EVENT_MASK	\
 	(ARCH_PERFMON_EVENTSEL_UMASK | ARCH_PERFMON_EVENTSEL_EVENT)
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 2c98f3ee8df4..99426a8d7f18 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -198,7 +198,8 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 
 	filter = srcu_dereference(kvm->arch.pmu_event_filter, &kvm->srcu);
 	if (filter) {
-		__u64 key = eventsel & AMD64_RAW_EVENT_MASK_NB;
+		__u64 key = eventsel & (INTEL_ARCH_EVENT_MASK |
+					AMD64_EXTRA_EVENTSEL_EVENT);
 
 		if (bsearch(&key, filter->events, filter->nevents,
 			    sizeof(__u64), cmp_u64))
@@ -209,18 +210,14 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	if (!allow_event)
 		return;
 
-	if (!(eventsel & (ARCH_PERFMON_EVENTSEL_EDGE |
-			  ARCH_PERFMON_EVENTSEL_INV |
-			  ARCH_PERFMON_EVENTSEL_CMASK |
-			  HSW_IN_TX |
-			  HSW_IN_TX_CHECKPOINTED))) {
+	if (!(eventsel & NON_HARDWARE_EVENT_MASK)) {
 		config = kvm_x86_ops.pmu_ops->pmc_perf_hw_id(pmc);
 		if (config != PERF_COUNT_HW_MAX)
 			type = PERF_TYPE_HARDWARE;
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & X86_RAW_EVENT_MASK;
+		config = eventsel & AMD64_RAW_EVENT_MASK;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7a7b8d5b775e..48d867e250bc 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -17,6 +17,12 @@
 
 #define MAX_FIXED_COUNTERS	3
 
+#define KVM_ARCH_PERFMON_EVENTSEL_IGNORE \
+	(ARCH_PERFMON_EVENTSEL_ANY | ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
+
+#define NON_HARDWARE_EVENT_MASK	(AMD64_EXTRA_EVENTSEL_EVENT | \
+	 (X86_ALL_EVENT_FLAGS & ~KVM_ARCH_PERFMON_EVENTSEL_IGNORE))
+
 struct kvm_event_hw_type_mapping {
 	u8 eventsel;
 	u8 unit_mask;
-- 
2.35.0

