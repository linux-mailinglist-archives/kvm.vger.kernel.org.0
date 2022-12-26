Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAFA6560FA
	for <lists+kvm@lfdr.de>; Mon, 26 Dec 2022 08:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiLZHyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Dec 2022 02:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiLZHyh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Dec 2022 02:54:37 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1E0132
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 23:54:36 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id b12so6806008pgj.6
        for <kvm@vger.kernel.org>; Sun, 25 Dec 2022 23:54:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IDZYs/MEWificaqkh6FAhYITezAJQayTh3RxZA+C/28=;
        b=RNWrgtwBhoAJXm3UKDk5hBFuo/iirBlK2G2UTe7SRLKUuZ/nb2BME3RuFO1MZe+uJn
         jDCe8jbT+9+7mENo0OrcYD89GL39sjV1wjLmYr372/qp2VzMcH9s4VEcMaq4VOmAG0o4
         pQ3a/Xkp6mGFqhAhA5/Xx2kVG5mYYoELcpCFQDZGafxMbnBdDuYXXiJylbxbUo3rlSvw
         wk5xVbPkLPOBF3zHYZUfP1xWXNl8o0tVJGfwIX2AXI0AN5IOw5AYTbtOgHaM0QiFORYI
         oJnhM1CufdgO42WKkhTGdGkEH1Z/TgRYFQZBZqw+GdJ6Hqu3hfot713JyYZ7Cdyyq320
         hzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IDZYs/MEWificaqkh6FAhYITezAJQayTh3RxZA+C/28=;
        b=LK2UzLPIEU5my2GYCtDpYQZ2rVmqn4AaXjgZ60TBcsoEYGNkg3atdxny8f6WHV78kk
         tkXpZL//d/ll4ZlAv+Di+bGznp5Ej8ZUC4oSInevM9IwxHhfnOLKKgpUgiUo7pkE93c2
         G2R+ZFx9+0UUhK86CtbSRR2PYn/D2aF+pXG6VA8AGk4XMkXWrc2lGHMJxanDuaKFokEy
         4R916PzfrVQOkQnpeBTiRSKGMplY2co1rOvcFxjIfCoNQ5uUzHvoQEfGVRLNq1H59dgi
         anjJH2bHAY5PGdZTqORVRJYgTg+/hPRxRV1jmCz9wvhkKmjMtfsvv20w/mv0hDP3VsCv
         OHlg==
X-Gm-Message-State: AFqh2kpRcYkP7EnYe8TnC45c4RM9XjemL1X6aOucW7mHjLq+cjn6uEuP
        1RElZORvt/RGeaw9i/9rqgLMGifHNG1gqgUD
X-Google-Smtp-Source: AMrXdXuh+eDg8oMYq3nzKWiojs56PNEZ9O5fIFll5Is0eAtgpdoeamkFmWJ5/DykG89Z4PVsr8m4Lw==
X-Received: by 2002:a05:6a00:1da2:b0:580:f804:d704 with SMTP id z34-20020a056a001da200b00580f804d704mr5857903pfw.28.1672041275954;
        Sun, 25 Dec 2022 23:54:35 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id a125-20020a621a83000000b00575467891besm6289271pfa.136.2022.12.25.23.54.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Dec 2022 23:54:35 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH RESEND 2/2] x86/pmu: Wrap the written counter value with gp_counter_width
Date:   Mon, 26 Dec 2022 15:54:12 +0800
Message-Id: <20221226075412.61167-3-likexu@tencent.com>
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

The check_emulated_instr() testcase fails when the KVM module parameter
"force_emulation_prefix" is 1. The root cause is that the value written by
the counter exceeds the maximum bit width of the GP counter.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 x86/pmu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/x86/pmu.c b/x86/pmu.c
index 356d589..4dbbe71 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -477,6 +477,7 @@ static void check_running_counter_wrmsr(void)
 static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
+	uint64_t gp_counter_width = (1ull << pmu.gp_counter_width) - 1;
 	unsigned int branch_idx = pmu.is_intel ? 5 : 2;
 	pmu_counter_t brnch_cnt = {
 		.ctr = MSR_GP_COUNTERx(0),
@@ -498,8 +499,8 @@ static void check_emulated_instr(void)
 
 	brnch_start = -EXPECTED_BRNCH;
 	instr_start = -EXPECTED_INSTR;
-	wrmsr(MSR_GP_COUNTERx(0), brnch_start);
-	wrmsr(MSR_GP_COUNTERx(1), instr_start);
+	wrmsr(MSR_GP_COUNTERx(0), brnch_start & gp_counter_width);
+	wrmsr(MSR_GP_COUNTERx(1), instr_start & gp_counter_width);
 	// KVM_FEP is a magic prefix that forces emulation so
 	// 'KVM_FEP "jne label\n"' just counts as a single instruction.
 	asm volatile(
-- 
2.39.0

