Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D426C6170F0
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 23:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiKBWwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 18:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiKBWv7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 18:51:59 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F63BC3E
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 15:51:52 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id p5-20020a170902e74500b001884ba979f8so165726plf.17
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 15:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hDMWTQWwPwfep3nB0/domu8CGgaz+q/6W7S8QdoXBnM=;
        b=jym3Y7Y/+n22EFT4UfFGZx6u0ca1sLtcB3LAt6l72xa73ra0Z+V3OfU22FQJUfPRJN
         MjmIpGb9VFqZPAcoV0xX5kiRZ9OQhBssQ5nVvUp4X3uUmQy0DJDVgAbTsTiONclHSuwT
         eh7HuGK0hmT6Xg8DwVA4hE8GW65WDvChNLDVcesInxrS+kahgaJl5nYTtOHr45wQuB9q
         /O0cb7em13L1+OcMMu5I4L2ranV89SLj2GrQWqlmGGtGxtkvsPYZkGKYvvJ1Vl18/qvl
         V9Mw5mzjd5oqnsS+/DbcAraUNcaw0e1wK7aDps6L8GMYy2Ezo87p+menmOxOk3WDuhBb
         D+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hDMWTQWwPwfep3nB0/domu8CGgaz+q/6W7S8QdoXBnM=;
        b=3Lbf8DBNoG1s4Xk7Bf44SGvVzkCE6yCSjG3uayV4EqPpam/pnYLrS1jKZAkdfPBe7Y
         IpdV9K9w38QrmtuejDUZc/ZiJ/KwT1CZiOWDs/vom4khpnZk4vow31YRlfy7e5Z5DcqL
         0qZneROstKsTT1kwx/6RtNvB22BUQENAhytyNrFIqzdy0MWhtrBOLLs3HxUWGvXKGfHx
         djRHQC2PiPcbd9fwFM8zt+M5fTh5ifzclIWRPDB4kJr7Dw5Ta6NoIyD1z/QkINOa65sn
         9brJ3iluWa1JtIibrk1uENNkSdo4WQZMg/3KSUCvJZEcvsM150YkiV8clOSJq9iFbIgu
         W0Pw==
X-Gm-Message-State: ACrzQf2XnlJy7WPn7I0kzBLQoY6iyQ1MH9Llijj5irl+qcqiTXKI4Xto
        XDcLCS8RsfpgPN4HBjJ/OChzzmEJwTE=
X-Google-Smtp-Source: AMsMyM5RCVOuLllwMfA8bt4/+wkPQweEsb7m/NT4Dzoc0YWahOdzTBpekVNrB60N+kWpUlYbh6THhNNn1VE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:32cf:b0:186:e114:be9c with SMTP id
 i15-20020a17090332cf00b00186e114be9cmr27776554plr.136.1667429502074; Wed, 02
 Nov 2022 15:51:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  2 Nov 2022 22:50:59 +0000
In-Reply-To: <20221102225110.3023543-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221102225110.3023543-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221102225110.3023543-17-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v5 16/27] x86/pmu: Snapshot CPUID.0xA PMU
 capabilities during BSP initialization
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

Snapshot PMU info from CPUID.0xA into "struct pmu_caps pmu" during
pmu_init() instead of reading CPUID.0xA every time a test wants to query
PMU capabilities.  Using pmu_caps to track various properties will also
make it easier to hide the differences between AMD and Intel PMUs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/pmu.c | 16 ++++++++++++++++
 lib/x86/pmu.h | 32 ++++++++++++++------------------
 2 files changed, 30 insertions(+), 18 deletions(-)

diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
index bb272ab7..9c1034aa 100644
--- a/lib/x86/pmu.c
+++ b/lib/x86/pmu.c
@@ -4,6 +4,22 @@ struct pmu_caps pmu;
 
 void pmu_init(void)
 {
+	struct cpuid cpuid_10 = cpuid(10);
+
+	pmu.version = cpuid_10.a & 0xff;
+
+	if (pmu.version > 1) {
+		pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
+		pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
+	}
+
+	pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
+	pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
+	pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
+
+	/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
+	pmu.gp_counter_available = ~cpuid_10.b;
+
 	if (this_cpu_has(X86_FEATURE_PDCM))
 		pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
 }
diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
index 4780237c..c7e9d3ae 100644
--- a/lib/x86/pmu.h
+++ b/lib/x86/pmu.h
@@ -34,6 +34,13 @@
 #define EVNTSEL_INV	(1 << EVNTSEL_INV_SHIF)
 
 struct pmu_caps {
+	u8 version;
+	u8 nr_fixed_counters;
+	u8 fixed_counter_width;
+	u8 nr_gp_counters;
+	u8 gp_counter_width;
+	u8 gp_counter_mask_length;
+	u32 gp_counter_available;
 	u64 perf_cap;
 };
 
@@ -43,7 +50,7 @@ void pmu_init(void);
 
 static inline u8 pmu_version(void)
 {
-	return cpuid(10).a & 0xff;
+	return pmu.version;
 }
 
 static inline bool this_cpu_has_pmu(void)
@@ -58,43 +65,32 @@ static inline bool this_cpu_has_perf_global_ctrl(void)
 
 static inline u8 pmu_nr_gp_counters(void)
 {
-	return (cpuid(10).a >> 8) & 0xff;
+	return pmu.nr_gp_counters;
 }
 
 static inline u8 pmu_gp_counter_width(void)
 {
-	return (cpuid(10).a >> 16) & 0xff;
+	return pmu.gp_counter_width;
 }
 
 static inline u8 pmu_gp_counter_mask_length(void)
 {
-	return (cpuid(10).a >> 24) & 0xff;
+	return pmu.gp_counter_mask_length;
 }
 
 static inline u8 pmu_nr_fixed_counters(void)
 {
-	struct cpuid id = cpuid(10);
-
-	if ((id.a & 0xff) > 1)
-		return id.d & 0x1f;
-	else
-		return 0;
+	return pmu.nr_fixed_counters;
 }
 
 static inline u8 pmu_fixed_counter_width(void)
 {
-	struct cpuid id = cpuid(10);
-
-	if ((id.a & 0xff) > 1)
-		return (id.d >> 5) & 0xff;
-	else
-		return 0;
+	return pmu.fixed_counter_width;
 }
 
 static inline bool pmu_gp_counter_is_available(int i)
 {
-	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
-	return !(cpuid(10).b & BIT(i));
+	return pmu.gp_counter_available & BIT(i);
 }
 
 static inline u64 this_cpu_perf_capabilities(void)
-- 
2.38.1.431.g37b22c650d-goog

