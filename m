Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A96A609DA2
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiJXJOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:14:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiJXJNm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:42 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B655AA36
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:37 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id io19so2986936plb.8
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X01d27bImszq5JJeDGG8+c38fFyhTDHSDxshjcb4ihQ=;
        b=QDssjgFV/CduyXGykFBw8agaHCNPslVwhFaonbpfD7POcvDENv/X95dS0v+C4ebA6S
         SwQiRbCpJDkrjiCPUysOfflUyaMYtQHPcyFr5qdl+5kZ7RAS+eDgqVq9lUTnPnC65cO4
         qXf1Ylo4/XM054nfK1V8jpqr+nXiBygER7EJU2YAqXvShrpxQhqbpVL1LCbQxhL2Qck5
         C0V5RTiNArlUWEfkq1sIvr1SdlrBNBRz1dWw2dL9O0Z3zcXe7DCUZ9RZ6kivDzBvQjrg
         BS4Tzm+ybQQEGus4gi+WBCij93CIxxE1iOO+GpR4YioBx/y7I0UDNLImubuzl6UqGuBh
         IzIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X01d27bImszq5JJeDGG8+c38fFyhTDHSDxshjcb4ihQ=;
        b=IaFAfGujLpXEwxOdCSbETLgiPNv6oHD8TW6fj0qN7NNI5Pj9zYKnOLtFtmbV3ZInyk
         47b5xR/JBP0PIz60GEBoiwyssOz2wuF9B4wxHxpmcVFtYq5ILxh5D10lZq9MRJ2ZMbEV
         Adkz5adcChgTAdUH4O8VIzH7zYVpYKI9izie42gl4lv8rqYnqtxz3iYI1S5TKrl02Vss
         RuQG+3i5LioiCJGV0msI2gjDIwHqlTUq4WX9ScHqUe8ItBIh181HI9K/JyT8T9tpse0B
         iK/LAlmWrXZgn2FB428OL6MeHamZUVDEJ4d/5UDZfBY8p6xFM/a4Wgymrl0gvq/AhGWw
         mQ7g==
X-Gm-Message-State: ACrzQf0SexyaWk0R3VoCzFiJsW747DuMpZDMSFkaSy0NpEpNnkv8P8xO
        cn5KOBZR1EM08hFk+xCJcmA=
X-Google-Smtp-Source: AMsMyM4fZmAyowCIhKQGwQyMPqqnU1Lt0p9YbsEpgnQve25UYFSRSleYoraf8D/Rvvj8KbzaETl4uQ==
X-Received: by 2002:a17:902:d512:b0:181:f1f4:fcb4 with SMTP id b18-20020a170902d51200b00181f1f4fcb4mr32938538plg.102.1666602815972;
        Mon, 24 Oct 2022 02:13:35 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:35 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 21/24] x86/pmu: Add gp_events pointer to route different event tables
Date:   Mon, 24 Oct 2022 17:12:20 +0800
Message-Id: <20221024091223.42631-22-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
---
 x86/pmu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index daeb7a2..24d015e 100644
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
@@ -212,7 +215,7 @@ static void check_gp_counters(void)
 {
 	int i;
 
-	for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
+	for (i = 0; i < gp_events_size; i++)
 		if (pmu_gp_counter_is_available(i))
 			check_gp_counter(&gp_events[i]);
 		else
@@ -248,7 +251,7 @@ static void check_counters_many(void)
 
 		cnt[n].ctr = gp_counter_msr(n);
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
-			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
+			gp_events[i % gp_events_size].unit_sel;
 		n++;
 	}
 	for (i = 0; i < nr_fixed_counters; i++) {
@@ -603,7 +606,7 @@ static void set_ref_cycle_expectations(void)
 {
 	pmu_counter_t cnt = {
 		.ctr = MSR_IA32_PERFCTR0,
-		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[2].unit_sel,
+		.config = EVNTSEL_OS | EVNTSEL_USR | intel_gp_events[2].unit_sel,
 	};
 	uint64_t tsc_delta;
 	uint64_t t0, t1, t2, t3;
@@ -639,8 +642,8 @@ static void set_ref_cycle_expectations(void)
 	if (!tsc_delta)
 		return;
 
-	gp_events[2].min = (gp_events[2].min * cnt.count) / tsc_delta;
-	gp_events[2].max = (gp_events[2].max * cnt.count) / tsc_delta;
+	intel_gp_events[2].min = (intel_gp_events[2].min * cnt.count) / tsc_delta;
+	intel_gp_events[2].max = (intel_gp_events[2].max * cnt.count) / tsc_delta;
 }
 
 static void check_invalid_rdpmc_gp(void)
@@ -664,6 +667,8 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
+	gp_events = (struct pmu_event *)intel_gp_events;
+	gp_events_size = sizeof(intel_gp_events)/sizeof(intel_gp_events[0]);
 	set_ref_cycle_expectations();
 
 	printf("PMU version:         %d\n", pmu_version());
-- 
2.38.1

