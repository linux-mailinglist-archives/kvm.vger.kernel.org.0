Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600FA6AE22A
	for <lists+kvm@lfdr.de>; Tue,  7 Mar 2023 15:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCGOXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Mar 2023 09:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbjCGOWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Mar 2023 09:22:51 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C557A92F
        for <kvm@vger.kernel.org>; Tue,  7 Mar 2023 06:18:11 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z19-20020a056a001d9300b005d8fe305d8bso7363857pfw.22
        for <kvm@vger.kernel.org>; Tue, 07 Mar 2023 06:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678198631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BzCMQ571F2WO9LWAD1EwN+lMykAg6bUWw3+SVP+kARo=;
        b=RksqaONSskexR2Fats+78uKEPYfTYGvXHhU7LGBcg1VmQncP1V5D1HOpcKs8/Ra3g3
         Crwl31Y5VBUktxWoO0DwaVkfgHYFRlFYiRjMS6P3XgyhZwoJe26fzMlVizwjYpEwm5f1
         16K2V1gI9cad9Rn/FlwxqY46+t1Y0fhPKUf1ozsEx58MMe7Zir/HEbn90xe0yuan5QkF
         urJgmjQc+aE0lS8Es3ShVM9l2R/TyCXA0NUA3Pqghgs1Q96CLPuljz4NgUCoTbdCYq8U
         Ue9FzXjPrTQwasanb07sqeM1GzHUiQGjO3RYR3PUhEDhgd2Vs6/gpaN6E9/uVugZLOHc
         2U9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678198631;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BzCMQ571F2WO9LWAD1EwN+lMykAg6bUWw3+SVP+kARo=;
        b=Rpf+vJowB7z5UeXBQY4NR7PbCvhulOC2k94aC1ASBBKmWg6B8Uet5KhlG8azWuMUeS
         KNpMqj99oYh3jD3nfhGggMUxp7j9Oe8BXpWxYwh0O+QWTddIEUC6eBOce4057J78WQSo
         RdFoSW8PL/dZkGZLImYe1MkbECEuRBgWjyT8H4+1PtSB8YVX6RxR+q4gmzJ0TFNp0dP1
         ESnzWvmvThUVwze8vVxclCESvkV0SCIsgzckclMzmnQLJMqqvv1CEvPhaGYM6P81+IFi
         dqjoQNONGmLjGQx2RhhoRisHmTDn4QXcQXPp3uINgUp3eJ5N5YCTQ75Ge1ShKBVDcWB1
         1uCQ==
X-Gm-Message-State: AO0yUKV4ZinTjB63cXNJraD9f5BrgvnYVApbx7y0pKoNpRH7anOvBnvF
        VaI5lyXwDalMLYBJPjB2bMcD/GYkEcAQEy6KOvItDBLZ93nK3gkh8YjIeK1xoJk6BFwkWhKzX3N
        GXa2Y/ZNgd231pQxs6zLlFa3vtdr6U8YGFm6vQePyJ+g3h2mJW/ydjMh/rCLM3cxZMWVf
X-Google-Smtp-Source: AK7set+3eqEflYq0/MmG8HxeV3v7IeNtORt/dO4+Ech++4ak6QUElumeJhtNEzUDNl1HYb5/WdClLKkUvWeia8vE
X-Received: from aaronlewis-2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:519c])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:328e:b0:19b:456:6400 with SMTP
 id jh14-20020a170903328e00b0019b04566400mr5980295plb.7.1678198630974; Tue, 07
 Mar 2023 06:17:10 -0800 (PST)
Date:   Tue,  7 Mar 2023 14:13:56 +0000
In-Reply-To: <20230307141400.1486314-1-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230307141400.1486314-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307141400.1486314-2-aaronlewis@google.com>
Subject: [PATCH v3 1/5] KVM: x86/pmu: Prevent the PMU from counting disallowed events
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        like.xu.linux@gmail.com, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When counting "Instructions Retired" (0xc0) in a guest, KVM will
occasionally increment the PMU counter regardless of if that event is
being filtered. This is because some PMU events are incremented via
kvm_pmu_trigger_event(), which doesn't know about the event filter. Add
the event filter to kvm_pmu_trigger_event(), so events that are
disallowed do not increment their counters.

Fixes: 9cd803d496e7 ("KVM: x86: Update vPMCs when retiring instructions")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 arch/x86/kvm/pmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 612e6c70ce2e..9914a9027c60 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -400,6 +400,12 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 	return is_fixed_event_allowed(filter, pmc->idx);
 }
 
+static bool event_is_allowed(struct kvm_pmc *pmc)
+{
+	return pmc_is_enabled(pmc) && pmc_speculative_in_use(pmc) &&
+	       check_pmu_event_filter(pmc);
+}
+
 static void reprogram_counter(struct kvm_pmc *pmc)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
@@ -409,10 +415,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 	pmc_pause_counter(pmc);
 
-	if (!pmc_speculative_in_use(pmc) || !pmc_is_enabled(pmc))
-		goto reprogram_complete;
-
-	if (!check_pmu_event_filter(pmc))
+	if (!event_is_allowed(pmc))
 		goto reprogram_complete;
 
 	if (pmc->counter < pmc->prev_counter)
@@ -684,7 +687,7 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 	for_each_set_bit(i, pmu->all_valid_pmc_idx, X86_PMC_IDX_MAX) {
 		pmc = static_call(kvm_x86_pmu_pmc_idx_to_pmc)(pmu, i);
 
-		if (!pmc || !pmc_is_enabled(pmc) || !pmc_speculative_in_use(pmc))
+		if (!pmc || !event_is_allowed(pmc))
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

