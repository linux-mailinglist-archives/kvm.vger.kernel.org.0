Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9E86170E5
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiKBWvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiKBWv3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:29 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FCFDE80
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:27 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3691846091fso292517b3.9
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+W//lE9W8lJzpaGkv5iCS58X6yjVUczDe/HcDPMXKL4=;
        b=ACSuiE2JjTztXwavvbHCKiSxk89Gve0uuXQYSrk22GGK480M1lrcJ1GbJQxbvqmfgO
         17oKWix+b+YXFyMjjpd2iCyKvY6c2deWSfpOiMbAs3vOVSV+oB0Iz3a0H569KkI6sAZS
         klV/AnqeinLmh58MyYfDToF/ZmM/fQzXSfuSmcHQvOZN6PwZxgfdOCuBWYmTSsgULajw
         mmtw7HkLiWVksmffnk+Mtr6IgVBgiJKYOE9hMgskX/UnHc/BF2V7MFMmk4aTqpdOysi+
         zjCCLOEL4x1Tt2nll3x+mMLvvMyUbPXGGcgBANTNQcZC9dlje8zaFBTVpttabfVjk5no
         QyzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+W//lE9W8lJzpaGkv5iCS58X6yjVUczDe/HcDPMXKL4=;
        b=oBJ1uamvcTyee/1O+Wv0XCINC5Fpc2hheOXE53cgi7IG+Dxl11GtX6QMOXE0fyjN+f
         4iLbPhIt92wE8nLHPBxTvO6e92Nl1+5mcU1BtFEPCrHzKPcOgzZkZvBqeBDcnIQuzcUB
         mkoT1bAeWhWDJ3XkR/6+SCLtge5V1adcqPkp9tonLz66Ad/bN0F0EDyue7qWzaQZIDEO
         FWY/0KB6LqY/MRX6X/oSqh7NwhEJD0A65u+Q4tkRykaXd/TxM0QtmO62yfO4qe1SOSmi
         ml5m3c1iWw3glNzTziSet7aBtNjyDVNAklses9GzWpxZi4qcdRgQCORCg8LU/fai6s/0
         dgWg==
X-Gm-Message-State: ACrzQf3znQz8dTADvfirbRU24mozUvysZLKSwevmykHCfvwv8f6f386M
        I8qowAPmmFQPm0zqvYBFdKL9Nd5INM0=
X-Google-Smtp-Source: AMsMyM7eqi+DDu/o0KPQk39/bSFzlJNPolnyidwpaecS5EKUrfsk4AtvNKgV7cRM9kfrWToIEUGi3/8y9W0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d1c9:0:b0:6cb:4010:eac1 with SMTP id
 i192-20020a25d1c9000000b006cb4010eac1mr27648630ybg.337.1667429486734; Wed, 02
 Nov 2022 15:51:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:50 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 07/27] x86/pmu: Introduce multiple_{one,
 many}() to improve readability
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

The current measure_one() forces the common case to pass in unnecessary
information in order to give flexibility to a single use case. It's just
syntatic sugar, but it really does help readers as it's not obvious that
the "1" specifies the number of events, whereas multiple_many() and
measure_one() are relatively self-explanatory.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 77e59c5c..0546eb13 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -181,7 +181,7 @@ static void stop_event(pmu_counter_t *evt)
 	evt->count = rdmsr(evt->ctr);
 }
 
-static noinline void measure(pmu_counter_t *evt, int count)
+static noinline void measure_many(pmu_counter_t *evt, int count)
 {
 	int i;
 	for (i = 0; i < count; i++)
@@ -191,6 +191,11 @@ static noinline void measure(pmu_counter_t *evt, int count)
 		stop_event(&evt[i]);
 }
 
+static void measure_one(pmu_counter_t *evt)
+{
+	measure_many(evt, 1);
+}
+
 static noinline void __measure(pmu_counter_t *evt, uint64_t count)
 {
 	__start_event(evt, count);
@@ -220,7 +225,7 @@ static void check_gp_counter(struct pmu_event *evt)
 	int i;
 
 	for (i = 0; i < nr_gp_counters; i++, cnt.ctr++) {
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
 	}
 }
@@ -247,7 +252,7 @@ static void check_fixed_counters(void)
 
 	for (i = 0; i < nr_fixed_counters; i++) {
 		cnt.ctr = fixed_events[i].unit_sel;
-		measure(&cnt, 1);
+		measure_one(&cnt);
 		report(verify_event(cnt.count, &fixed_events[i]), "fixed-%d", i);
 	}
 }
@@ -274,7 +279,7 @@ static void check_counters_many(void)
 		n++;
 	}
 
-	measure(cnt, n);
+	measure_many(cnt, n);
 
 	for (i = 0; i < n; i++)
 		if (!verify_counter(&cnt[i]))
@@ -338,7 +343,7 @@ static void check_gp_counter_cmask(void)
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
 	};
 	cnt.config |= (0x2 << EVNTSEL_CMASK_SHIFT);
-	measure(&cnt, 1);
+	measure_one(&cnt);
 	report(cnt.count < gp_events[1].min, "cmask");
 }
 
-- 
2.38.1.431.g37b22c650d-goog

