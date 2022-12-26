Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79DD6560F9
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 08:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231781AbiLZHyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 02:54:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbiLZHyf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 02:54:35 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A956A13E
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 23:54:33 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id w26so6847590pfj.6
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 23:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nCsShkqzAQC2vblsPgRikGqyp95YkRxeETotFwCvMC0=;
        b=mPVhEiGzrcEEi6VIuF5ym1dQX1c0unvvrJJB9uVKrJNyhhMTPcUSyAwQsqD9wEfOjg
         JMedzt7Z2ccZqW1aYFhtF55iP8JekRPTdcmt+3ZuN24HaW/0dtBkin979v0g/S+E3Lzo
         vUdXyfForO3AiPh1bbQcDfV7+POEvQJ37exYn5B2Dd7Kkm+Vy8kPs1zDt1j0YvaewR/F
         iS0QrXDdW24giAl0a/vB1cA9rT/6QxoNvyKY8zdi1mT+nWeK6L7iBFwfxoxknNvaO6y0
         JE26WUVrqx+uyi6BvRF7WSiUFpITyEFsEzmfUFcw5vcndPhyXbdAGjwkKXltWBM4eZfY
         Nefg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nCsShkqzAQC2vblsPgRikGqyp95YkRxeETotFwCvMC0=;
        b=HVjEGd6AI7cP0MFHL1qHH6zbnep4wJR5lk3XTppLMQuOfsiD3MWU7d0BZ3QO2ZMuVt
         bO9hMjiGrThbnJ3wtDsHuO62IZCQDIjIlO3dWD0VmmFxaNJNBj7ww18GohCsWBa6C4SI
         A0HKCpb5mCS0vsrtHwVXCzjyFPRqzYzE92GK1wzzShm4mCXeB5Q2tNvMH4OKlCrEeKvw
         862Zzjvm86oymRijGYYKwuxDN1Y6WHLS86xCG6a0Z1Jaiv1PXPmDLYlbCqfmXHqyARoC
         hGwJL4J+3kwKoaQ9r2f3afuJoXylIcvJmDBSX7pBI/1fDbzyrsv8dr7YXvD8TAdorujx
         s5XA==
X-Gm-Message-State: AFqh2krBm9xM0q3kiD4hWDI61fsgvaIigOgP1TWplY2v3kWih+1O3TxJ
        sUohIJZ5Ajy5o3busiRcWTc=
X-Google-Smtp-Source: AMrXdXscLfnh3fZcHvIWNsJt/5VQj3PkKdThREXoY9ZKNESR+/Xnld2HH7poTzOsJqF4q4rVAccfbg==
X-Received: by 2002:a62:84c9:0:b0:581:1f4b:d1e5 with SMTP id k192-20020a6284c9000000b005811f4bd1e5mr3408041pfd.12.1672041273161;
        Sun, 25 Dec 2022 23:54:33 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a125-20020a621a83000000b00575467891besm6289271pfa.136.2022.12.25.23.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Dec 2022 23:54:32 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH V2 1/2] x86/pmu: Add Intel Guest Transactional (commited) cycles testcase
Date:   Mon, 26 Dec 2022 15:54:11 +0800
Message-Id: <20221226075412.61167-2-likexu@tencent.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221226075412.61167-1-likexu@tencent.com>
References: <20221226075412.61167-1-likexu@tencent.com>
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

On Intel platforms with TSX feature, pmu users in guest can collect
the commited or total transactional cycles for a tsx-enabled workload,
adding new test cases to cover them, as they are not strictly the same
as normal hardware events from the KVM implementation point of view.

Signed-off-by: Like Xu <likexu@tencent.com>
---
V1: https://lore.kernel.org/kvm/20221207071506.15733-1-likexu@tencent.com/
V1 -> V2 Changelog:
- Drop HLE check; (Weijiang)
- Print out the data here for each GP counter; (Weijiang)
- Use "unsigned int" for EAX; (Sean)
- Use mnemonic for XBEGIN; (Sean)
- Drop use of _xend(); (Sean)
- Use xbegin inline instead of processor.h to avoid conflicts with vmx_tests;

 x86/pmu.c | 42 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 72c2c9c..356d589 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -20,7 +20,7 @@
 
 typedef struct {
 	uint32_t ctr;
-	uint32_t config;
+	uint64_t config;
 	uint64_t count;
 	int idx;
 } pmu_counter_t;
@@ -547,6 +547,45 @@ static void check_emulated_instr(void)
 	report_prefix_pop();
 }
 
+#define XBEGIN_STARTED (~0u)
+static void check_tsx_cycles(void)
+{
+	pmu_counter_t cnt;
+	unsigned int i, ret = 0;
+
+	if (!this_cpu_has(X86_FEATURE_RTM))
+		return;
+
+	report_prefix_push("TSX cycles");
+
+	for (i = 0; i < pmu.nr_gp_counters; i++) {
+		cnt.ctr = MSR_GP_COUNTERx(i);
+
+		if (i == 2)
+			/* Transactional cycles commited only on gp counter 2 */
+			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x30000003c;
+		else
+			/* Transactional cycles */
+			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x10000003c;
+
+		start_event(&cnt);
+
+		asm volatile("xbegin 1f\n\t"
+				"1:\n\t"
+				: "+a" (ret) :: "memory");
+
+		/* Generate a non-canonical #GP to trigger ABORT. */
+		if (ret == XBEGIN_STARTED)
+			*(int *)NONCANONICAL = 0;
+
+		stop_event(&cnt);
+
+		report(cnt.count > 0, "gp cntr-%d with a value of %" PRId64 "", i, cnt.count);
+	}
+
+	report_prefix_pop();
+}
+
 static void check_counters(void)
 {
 	if (is_fep_available())
@@ -559,6 +598,7 @@ static void check_counters(void)
 	check_counter_overflow();
 	check_gp_counter_cmask();
 	check_running_counter_wrmsr();
+	check_tsx_cycles();
 }
 
 static void do_unsupported_width_counter_write(void *index)
-- 
2.39.0

