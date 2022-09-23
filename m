Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBBA5E708F
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 02:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbiIWAOU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 20:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiIWAOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 20:14:09 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547B2105D62
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:08 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m188-20020a633fc5000000b00434dccacd4aso6140649pga.10
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 17:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=f2xmpMmtFzdLGsMsB8kYkuwB1JyVMmF0btvwH040Ee4=;
        b=rnJaFLPPbtEl6p8La4UuvJhCknH1LynXt8bS7KvIUGS3P7eeW30h7WaODIpwswxgzj
         roFq6ACeln5B5O+fl50fFlFJ7wQ2rGsO9epEhfT30UKCFX3s+0S3uO+Ie1y7k3+dPGFZ
         fyGMfm4BRK4zUGtWjhOJ/CavPC++zvEDZnnAVaTWrrif8FAUXzvKISy9FfG2v3I9Zbav
         zQsIBzbyyX14LwXYLZXehp/DXX9KNEkupPok80ZJM7cCSiW54V0uE0EMolLe1MCyIQSz
         JCCn0G2pjR+/pzm4ZLNsb6wHq2/B01AWyE6cHihCndklGqAAnV3u9Z5WquEizknAePSt
         FccA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=f2xmpMmtFzdLGsMsB8kYkuwB1JyVMmF0btvwH040Ee4=;
        b=Gmae4GZliVaGMbntdnDz5VApIuauZUK7QHNQnXlZTJ7RrEJUDdqbdoTebCrkPD20aT
         vaw7RWtUPOX3MRhkV3ml2T5h4IeKpXCmzG+mqJ5DFJ2Otp83ZA/Hir1nNK0pwUgYVulO
         tgS4cb0HvzCort4nUTXo7ajIrgFEsUDudUyZZRtoE+jXPy0NH69wYcbjHk2LIn45R771
         YHwkf8uh/EJq/BYj/uxCsTancaedGpnIWLv78Z7v0J0b4i2hYusidxVxAGVU+nm/BmsF
         Rx8LWfziKokTgoFyqXEmjfwQVm5iyDXHVDkhZcQNZH+UyY9I/J6v6C7qCXXLGIbI3Uel
         09Ng==
X-Gm-Message-State: ACrzQf2OnNQ/QLKtpt7Pu+4w9kygboMqnogp6NT+dvd1UDg2bM32/EPX
        O/bn+Pcc0hn9OVz/kMMRDLQhgGMib8Q=
X-Google-Smtp-Source: AMsMyM6w+VH96XwQOSnc5r8zfbqw1kG64xzRQX/6SN96JqNtwiRpf7Q+Oh9TqgLurWU6/4eTY93vgQmAHfs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a22:b0:54e:6a90:fbef with SMTP id
 p34-20020a056a000a2200b0054e6a90fbefmr6068807pfh.53.1663892047901; Thu, 22
 Sep 2022 17:14:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Sep 2022 00:13:53 +0000
In-Reply-To: <20220923001355.3741194-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220923001355.3741194-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220923001355.3741194-3-seanjc@google.com>
Subject: [PATCH 2/4] KVM: x86/pmu: Clear "reprogram" bit if counter is
 disabled or disallowed
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Like Xu <likexu@tencent.com>,
        Wanpeng Li <wanpengli@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When reprogramming a counter, clear the counter's "reprogram pending" bit
if the counter is disabled (by the guest) or is disallowed (by the
userspace filter).  In both cases, there's no need to re-attempt
programming on the next coincident KVM_REQ_PMU as enabling the counter by
either method will trigger reprogramming.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4504987cbbe2..4cd99320019b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -150,9 +150,9 @@ static void kvm_perf_overflow(struct perf_event *perf_event,
 	__kvm_perf_overflow(pmc, true);
 }
 
-static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
-				  u64 config, bool exclude_user,
-				  bool exclude_kernel, bool intr)
+static int pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type, u64 config,
+				 bool exclude_user, bool exclude_kernel,
+				 bool intr)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
 	struct perf_event *event;
@@ -204,14 +204,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 	if (IS_ERR(event)) {
 		pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
 			    PTR_ERR(event), pmc->idx);
-		return;
+		return PTR_ERR(event);
 	}
 
 	pmc->perf_event = event;
 	pmc_to_pmu(pmc)->event_count++;
-	clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
 	pmc->is_paused = false;
 	pmc->intr = intr || pebs;
+	return 0;
 }
 
 static void pmc_pause_counter(struct kvm_pmc *pmc)
@@ -245,7 +245,6 @@ static bool pmc_resume_counter(struct kvm_pmc *pmc)
 	perf_event_enable(pmc->perf_event);
 	pmc->is_paused = false;
 
-	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
 	return true;
 }
 
@@ -303,10 +302,10 @@ void reprogram_counter(struct kvm_pmc *pmc)
 	pmc_pause_counter(pmc);
 
 	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
-		return;
+		goto reprogram_complete;
 
 	if (!check_pmu_event_filter(pmc))
-		return;
+		goto reprogram_complete;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
 		printk_once("kvm pmu: pin control bit is ignored\n");
@@ -324,16 +323,27 @@ void reprogram_counter(struct kvm_pmc *pmc)
 	}
 
 	if (pmc->current_config == new_config && pmc_resume_counter(pmc))
-		return;
+		goto reprogram_complete;
 
 	pmc_release_perf_event(pmc);
 
 	pmc->current_config = new_config;
-	pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
-			      (eventsel & pmu->raw_event_mask),
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
-			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
+
+	/*
+	 * If reprogramming fails, e.g. due to contention, leave the counter's
+	 * regprogram bit set, i.e. opportunistically try again on the next PMU
+	 * refresh.  Don't make a new request as doing so can stall the guest
+	 * if reprogramming repeatedly fails.
+	 */
+	if (pmc_reprogram_counter(pmc, PERF_TYPE_RAW,
+				  (eventsel & pmu->raw_event_mask),
+				  !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
+				  !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
+				  eventsel & ARCH_PERFMON_EVENTSEL_INT))
+		return;
+
+reprogram_complete:
+	clear_bit(pmc->idx, (unsigned long *)&pmc_to_pmu(pmc)->reprogram_pmi);
 }
 EXPORT_SYMBOL_GPL(reprogram_counter);
 
-- 
2.37.3.998.g577e59143f-goog

