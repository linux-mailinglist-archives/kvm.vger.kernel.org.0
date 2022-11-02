Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A50A66170E6
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiKBWvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbiKBWvb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:31 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9173ED2D7
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-370624ca2e8so75517b3.16
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MwZEGp4gIAnfWn9O/1bfNB8hTEFhkrFg2YS5MeqkyKI=;
        b=YXVsPLzDgBkgwTttQKgO+vfgXZIpnnXAwpwjdwQrGb065QUosihJqzXlY/ZO5uYevN
         Eul8pDyeqgQAk08kaNPK58jF89y+qMdxCrcm4jndAq2PawgwqJC89wfhUKVzBSaBuUNd
         mtKOQiQqOhVcm1NyxRfLdKaOhGCXxrE3pVqkJ6Q0sHMf/IPvhA00g0yEUP299RW/3ZGX
         5VcgOGBlgNEeCSM4e4Errdie3rW5fBdOY2aYL6cqhWIzSQkojvSqRpysow5RHCaYqwFO
         UwN1CwrA9/TTWvZjM3Mb1LFoJVGt4uo7XN+Pzgk5WorjewVfVlmLs+8RqjijARV1HEOg
         oaxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MwZEGp4gIAnfWn9O/1bfNB8hTEFhkrFg2YS5MeqkyKI=;
        b=PSNwN5rFMlcry1fluK4ds4+a5KSvOOOi+UVkHo46VisAHVUTGOS7REe5ZNPLdJ/45K
         wCAsjbP2bLsRa+qA/xGMLXaYN2QVw7KikI7iNyHBuSNmMHU8SccukfTeCtt7theVIGJC
         7utNT8WFzsrfDbTwDYLrt+DQfcyZwPSb3Bgy23NDoYZi/JWNRVuQh6o102UVbCH416FO
         Q+Fi0fPiplvUKWuaSULrlqzPszuZy5U3M7N/xs3gKteDN3S9T7Vj5Cy0xwduFH4+uSLP
         vz2vhkGiVbYvQ0mfsZ7fxSmfKsxchURc9ACFGSNtnhDC8wnlqnxOJsJQN8QTjeuRRFNj
         p3+w==
X-Gm-Message-State: ACrzQf1O4CKJ28lBZKHG6yTHo1RPyeaS37N/RF6lO/TCx11mfHyEYf97
        bHpQ82pkNKOWlL1D4jp+jUOyydFOrT8=
X-Google-Smtp-Source: AMsMyM7b4e1elwS2ZgPTx1No+88g2GiEoxzJHJjk2QTABPkiZlj6e0qNM3YWXBLUo5KZRWqERbHYdfNIldk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c2:b0:6ca:c6e4:e48 with SMTP id
 w2-20020a05690210c200b006cac6e40e48mr25659972ybu.404.1667429488326; Wed, 02
 Nov 2022 15:51:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:51 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-9-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 08/27] x86/pmu: Reset the expected count of
 the fixed counter 0 when i386
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Like Xu <likexu@tencent.com>,
        Sandipan Das <sandipan.das@amd.com>
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

From: Like Xu <likexu@tencent.com>

The pmu test check_counter_overflow() always fails with 32-bit binaries.
The cnt.count obtained from the latter run of measure() (based on fixed
counter 0) is not equal to the expected value (based on gp counter 0) and
there is a positive error with a value of 2.

The two extra instructions come from inline wrmsr() and inline rdmsr()
inside the global_disable() binary code block. Specifically, for each msr
access, the i386 code will have two assembly mov instructions before
rdmsr/wrmsr (mark it for fixed counter 0, bit 32), but only one assembly
mov is needed for x86_64 and gp counter 0 on i386.

The sequence of instructions to count events using the #GP and #Fixed
counters is different. Thus the fix is quite high level, to use the same
counter (w/ same instruction sequences) to set initial value for the same
counter. Fix the expected init cnt.count for fixed counter 0 overflow
based on the same fixed counter 0, not always using gp counter 0.

The difference of 1 for this count enables the interrupt to be generated
immediately after the selected event count has been reached, instead of
waiting for the overflow to be propagation through the counter.

Adding a helper to measure/compute the overflow preset value. It
provides a convenient location to document the weird behavior
that's necessary to ensure immediate event delivery.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 0546eb13..ddbc0cf9 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -288,17 +288,30 @@ static void check_counters_many(void)
 	report(i == n, "all counters");
 }
 
+static uint64_t measure_for_overflow(pmu_counter_t *cnt)
+{
+	__measure(cnt, 0);
+	/*
+	 * To generate overflow, i.e. roll over to '0', the initial count just
+	 * needs to be preset to the negative expected count.  However, as per
+	 * Intel's SDM, the preset count needs to be incremented by 1 to ensure
+	 * the overflow interrupt is generated immediately instead of possibly
+	 * waiting for the overflow to propagate through the counter.
+	 */
+	assert(cnt->count > 1);
+	return 1 - cnt->count;
+}
+
 static void check_counter_overflow(void)
 {
 	int nr_gp_counters = pmu_nr_gp_counters();
-	uint64_t count;
+	uint64_t overflow_preset;
 	int i;
 	pmu_counter_t cnt = {
 		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
-	__measure(&cnt, 0);
-	count = cnt.count;
+	overflow_preset = measure_for_overflow(&cnt);
 
 	/* clear status before test */
 	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
@@ -309,12 +322,13 @@ static void check_counter_overflow(void)
 		uint64_t status;
 		int idx;
 
-		cnt.count = 1 - count;
+		cnt.count = overflow_preset;
 		if (gp_counter_base == MSR_IA32_PMC0)
 			cnt.count &= (1ull << pmu_gp_counter_width()) - 1;
 
 		if (i == nr_gp_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
+			cnt.count = measure_for_overflow(&cnt);
 			cnt.count &= (1ull << pmu_fixed_counter_width()) - 1;
 		}
 
-- 
2.38.1.431.g37b22c650d-goog

