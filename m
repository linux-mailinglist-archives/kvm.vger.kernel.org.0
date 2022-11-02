Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A8A6170F6
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiKBWw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231661AbiKBWwG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:52:06 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FF9DF34
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:57 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id l63-20020a639142000000b0046f5bbb7372so41296pge.23
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xDvNqDKYm25iAo/FVzxm8LbMNeFXW/5fxLAmd4sS7IQ=;
        b=gnhf2kfc3cb2WRrJmjgeLzIJhzQPJGUxtqm/5QF5FVsmC+mXj0iigWKguQwPhb54xF
         g1xw6yCJB0jBMynZLOk+fSBQr/8OTLuQkZMll1QwLxMzN1Zzy+RWk+OIlwWJJUh0FM+2
         cKwlqk6bKS6ZovFbXdlp4e0LH6aasAByYEN0pdY4vI+AfIhQ6bF823xVTI5NjA2Er/Ug
         rDHhi0Qjm036ylSdHZoexGvLeSXE5mNJuWNXGXyhr6Et77XxDMathyKq/ZvAdhg/qlQk
         KZyWe1rdGyqlJjUWNmLT+6oYXhJHTDrLET+/usNoHBoL28q5bnPRDYMjAbroLVCzMD9z
         sILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xDvNqDKYm25iAo/FVzxm8LbMNeFXW/5fxLAmd4sS7IQ=;
        b=CcTlzUjrGFTYfuGL/ygPLxxsYeC1TuVL7ru6n6WrUBgewa2sVTMQtEYNvFQewRPbcV
         wt3HhuPT8/MR2TayBcFVzGjBqG9HejweSf3C9/v6Oe9u29p/w0GIhKhyk/cvk/zGKg3V
         1UHtBj5JR+TGxLzNf36B7u84bMFldWfTMBD3xbrFUxNoI3Dy3rcC6BWGhLtQ3DdSmZOO
         Slu5QyviETm1boMMAgDTiCZul6K4b51MEzFkG35Ie5CPEBCUc6BgW4M54XRlWl6BCoYK
         z2aEbBGJVfJESAs8UJOe0cry2H020afwN6zVYcoIaT5xy4OdPpf1SRzmrM+z8/2KoyaK
         l/rg==
X-Gm-Message-State: ACrzQf0qf+gePbSXtB5jbn4/yeoNJfyY9tyz6pN4Dytilw9q9iaAweUE
        V2eyJC5Ve5qIPqsiADxXiIpiIYU0I/w=
X-Google-Smtp-Source: AMsMyM6rnsPaepV9JCYvC97L/PHj8LHVdqry7XXTJo20kpcBej/MGou3rR5bRhkJUfY00sQO94Ea63AFdfs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:f414:b0:212:cacf:42c3 with SMTP id
 ch20-20020a17090af41400b00212cacf42c3mr45271349pjb.198.1667429514522; Wed, 02
 Nov 2022 15:51:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:51:07 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-25-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 24/27] x86/pmu: Add gp_events pointer to
 route different event tables
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

AMD and Intel do not share the same set of coding rules for performance
events, and code to test the same performance event can be reused by
pointing to a different coding table, noting that the table size also
needs to be updated.

Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 7f200658..c40e2a96 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -30,7 +30,7 @@ struct pmu_event {
 	uint32_t unit_sel;
 	int min;
 	int max;
-} gp_events[] = {
+} intel_gp_events[] = {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
@@ -46,6 +46,9 @@ struct pmu_event {
 
 char *buf;
 
+static struct pmu_event *gp_events;
+static unsigned int gp_events_size;
+
 static inline void loop(void)
 {
 	unsigned long tmp, tmp2, tmp3;
@@ -91,7 +94,7 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 	if (is_gp(cnt)) {
 		int i;
 
-		for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
+		for (i = 0; i < gp_events_size; i++)
 			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
 				return &gp_events[i];
 	} else
@@ -213,7 +216,7 @@ static void check_gp_counters(void)
 {
 	int i;
 
-	for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
+	for (i = 0; i < gp_events_size; i++)
 		if (pmu_gp_counter_is_available(i))
 			check_gp_counter(&gp_events[i]);
 		else
@@ -246,7 +249,7 @@ static void check_counters_many(void)
 
 		cnt[n].ctr = MSR_GP_COUNTERx(n);
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
-			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
+			gp_events[i % gp_events_size].unit_sel;
 		n++;
 	}
 	for (i = 0; i < pmu.nr_fixed_counters; i++) {
@@ -595,7 +598,7 @@ static void set_ref_cycle_expectations(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[2].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[2].unit_sel,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
@@ -631,8 +634,8 @@ static void set_ref_cycle_expectations(void)
 	if (!tsc_delta)
 		return;
 
-	gp_events[2].min = (gp_events[2].min * cnt.count) / tsc_delta;
-	gp_events[2].max = (gp_events[2].max * cnt.count) / tsc_delta;
+	intel_gp_events[2].min = (intel_gp_events[2].min * cnt.count) / tsc_delta;
+	intel_gp_events[2].max = (intel_gp_events[2].max * cnt.count) / tsc_delta;
 }
 
 static void check_invalid_rdpmc_gp(void)
@@ -656,6 +659,8 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
+	gp_events = (struct pmu_event *)intel_gp_events;
+	gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 	set_ref_cycle_expectations();
 
 	printf("PMU version:         %d\n", pmu.version);
-- 
2.38.1.431.g37b22c650d-goog

