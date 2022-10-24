Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9549B609D8F
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJXJNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiJXJNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:04 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3EC95A2D4
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:03 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id p3so6994422pld.10
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qaw17Upa3BItxpXUKeacE4Corj+Zh28fyNt32bUya00=;
        b=CvVoUAs2g3YUKmJrQSp2QE/nT4MqwM607FU6g9LxDjGhRsicgIQKG4laE6BXVERyti
         rGUXd0Bkz3URTmHDgnZzAeBZh38CbYaykEHHRGe2xTzqVnA62scInXSUXUDru16c1GbT
         wEOlYu9VaL2Ipr+uDnbtdtGX4d+YdxK6QWverez3x7M5XO86ibrwGk00jhWAkHIM/VaG
         sy3ByBwirrDCSSdKu5ONFICg6zG3a5DUGiGeR2/xWna9Mj/hSW5kumtmWCqAypr0mqbE
         MSDCcrqBA8jIVATYVAgFxQi/MY0Bp/WgSkpUmDQxvJvDwrr80gdARJAI7W2xBSTdCMlx
         J0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qaw17Upa3BItxpXUKeacE4Corj+Zh28fyNt32bUya00=;
        b=kiBFBVsQnd/7+duFEmmfv3suiFiPa7EbT4aPZfb17jXEsJRDCt4dRHoZoiyY2Af/Zw
         KsFZSab/INcEQbinMjDG0+BxC2FJ6lS/iwaOX0RfA13fko+acTzdVjmt9/ahbzlyknIu
         y64KomZ3MA9v69stnGlcm0UsXDbZsqTDYSS/jAy/SG+zt5A4zeTKRGwMPhLXcXpCKSWe
         AywYJYykbAvd7PKkadEXQgYOwV/uGKfcqhVpCHDK185VT3o8QikqVGTGd9qpo3Q9ynmG
         xMyk9irs2Cowldqcf5J6rXqk2WHbfyXCLVJ3bUaUhToMpiP9TzUEhfxgBa0OvD9fwQFu
         OQdA==
X-Gm-Message-State: ACrzQf2tvhnHW627kh7cJ4C9YOg2B8dYX6FfOCWQsuC0LQtRe1QUmfNq
        I9iJ87jyAsrXRuDV5A2Slk/ib6E77Nzh/5Dz
X-Google-Smtp-Source: AMsMyM6YKoU01t9nj32FikvbclDC7QSZp8l08j006aIovvClNr6ebCee4oHb/xxyyxl7rwgf9zTK/A==
X-Received: by 2002:a17:90b:1e08:b0:212:ee11:7b09 with SMTP id pg8-20020a17090b1e0800b00212ee117b09mr10545426pjb.60.1666602783315;
        Mon, 24 Oct 2022 02:13:03 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:03 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 01/24] x86/pmu: Add PDCM check before accessing PERF_CAP register
Date:   Mon, 24 Oct 2022 17:12:00 +0800
Message-Id: <20221024091223.42631-2-likexu@tencent.com>
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

On virtual platforms without PDCM support (e.g. AMD), #GP
failure on MSR_IA32_PERF_CAPABILITIES is completely avoidable.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/processor.h | 8 ++++++++
 x86/pmu.c           | 2 +-
 x86/pmu_lbr.c       | 2 +-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 0324220..f85abe3 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -847,4 +847,12 @@ static inline bool pmu_gp_counter_is_available(int i)
 	return !(cpuid(10).b & BIT(i));
 }
 
+static inline u64 this_cpu_perf_capabilities(void)
+{
+	if (!this_cpu_has(X86_FEATURE_PDCM))
+		return 0;
+
+	return rdmsr(MSR_IA32_PERF_CAPABILITIES);
+}
+
 #endif
diff --git a/x86/pmu.c b/x86/pmu.c
index d59baf1..d278bb5 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -660,7 +660,7 @@ int main(int ac, char **av)
 
 	check_counters();
 
-	if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
+	if (this_cpu_perf_capabilities() & PMU_CAP_FW_WRITES) {
 		gp_counter_base = MSR_IA32_PMC0;
 		report_prefix_push("full-width writes");
 		check_counters();
diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index 8dad1f1..c040b14 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -72,7 +72,7 @@ int main(int ac, char **av)
 		return report_summary();
 	}
 
-	perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
+	perf_cap = this_cpu_perf_capabilities();
 
 	if (!(perf_cap & PMU_CAP_LBR_FMT)) {
 		report_skip("(Architectural) LBR is not supported.");
-- 
2.38.1

