Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A840F609D9A
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiJXJNg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbiJXJNZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:25 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2116169BC4
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:15 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id f23so7939374plr.6
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NL81jaqKKFzrMCxOCGcpdgaauWXeDH5p8SvcsPbwmls=;
        b=RblnWhL5S8XjnpDFO9vdvkfdHtr+kXptXKV+qEG1pJ3MPyTF2aAvcWVIqkObwc/Kp+
         jsM1sqKFoNcACrE+6etqyxkThy2B0CUxLOkx4HjFXrqpHJpBfC6ewesewTqWTe39Site
         ZDi2epwlIsEhlsVvBACmk3A7TIlkblfGAqKx4kKn1u2jRVw76kbQwpp/z+S2modJfS36
         mMAVAkHxkd8po+jZQ9Z2+Desnoo1703c8M72WuAYYuQPgxA1dgWCEDQdjR2c0KXjiF2P
         Wrj0ycd9acVmJv08KhVWGmnZSJw84iXsIg2O06xNsy5mEUc+ct7m/fZjG91/QKOAmuut
         PX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NL81jaqKKFzrMCxOCGcpdgaauWXeDH5p8SvcsPbwmls=;
        b=LAIhBEjo9kx6s/9Y7tdOrMjaw6GBkxvvRZGA6j0JDdOlBET3IXCwiFMmaUWa5z+m/M
         oRYNyN3XIYJ9eR6bzIwGqrELTvpaNkxQiyM7P33EkWkjfymxwXLkL9NiuXBCc87vsGYB
         UKyJCWIyg0bRLlVnw5DwEj/X0DBo1ZU2KrbRfS9hmBncGA1BJHJUWIm6YtD7Lwsf8k5p
         ehLzCnSo8P0XGoMDWuPtv6wxSn1IiNFYQnYGZI1MKkZ/NTONYDECyTfrAGOpEFDC3Q7U
         nyaq3LABtRAYHAvqfsEyPbfdiGXmHuNXGyRmsV66SmaROG6JTHRTz5NniDXJrsg3t+Be
         qrKQ==
X-Gm-Message-State: ACrzQf2COwsQD8l0VoDkJLHc//Hc7fxVD/bN2j44YY+RUfd6BU/K4Jre
        y9VF/VBCXgWq+H2NLF7vk34FmtaNf6uOj5Dv
X-Google-Smtp-Source: AMsMyM7jD64a2Q/5mfcmtlUYXwqw6ceR8lwszBGyJAGNyE/YCLTRy4MCLvXeKYm1qvFZPQSqWZ24LQ==
X-Received: by 2002:a17:902:8d93:b0:17f:852e:f84e with SMTP id v19-20020a1709028d9300b0017f852ef84emr31818346plo.20.1666602794744;
        Mon, 24 Oct 2022 02:13:14 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:14 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 08/24] x86/pmu: Reset the expected count of the fixed counter 0 when i386
Date:   Mon, 24 Oct 2022 17:12:07 +0800
Message-Id: <20221024091223.42631-9-likexu@tencent.com>
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
---
 x86/pmu.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 3b1ed16..bb6e97e 100644
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
2.38.1

