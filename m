Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B89263C964
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 21:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236290AbiK2Ud4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 15:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236695AbiK2UdZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 15:33:25 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DC86A743
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:23 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so12127498pfw.4
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 12:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tKuv2pQJ/ktBo11UCHJDyWQA4yglWCsAVtNBjefb2w4=;
        b=ZPxuozPd70kms6z51G5uswnIPlKLBHlN4iPC9WVrnPfbI9ud9n+Z5Bo+LqXBp/Uz3r
         KehZirDmspyUIwMyjI8uf6Jxrxbq9CtJwrUg6JC1VjogTQlUHNEh7xE3p4H9gbDpZaNY
         RljUex/tcM32ET8pzL+MirPtqfFispOzwFVWAjmTsIKK5VbVsYHlWpiBCn8/2eWkuVkR
         Ewo9gF5+MW/9um9fUHs2k4e5t3oxLa6h+YxYdVXG+/96Polk/Bqfsxjye6bcou7bafmT
         LthlT27S7eL5Pt55uF8UmU7avGXbTWID5lKogYyC+PXSuhzPNVlAyxlHl11n1c5D4tfS
         Gy/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tKuv2pQJ/ktBo11UCHJDyWQA4yglWCsAVtNBjefb2w4=;
        b=YRTTeUKenyKxrwxhj02wLXkYDKwjlCUxvuoe9BiGUm38NwSjTLx69OjyKRYma4/dFd
         qMObvKo5q0ilkGYylxf+3wV0BOQdRK7vUWDHXNc20yFEnYT/qA6Ief33uZc4mDkp1oQP
         HXpPPGyh2SdTQ/baFWRq72sU22Ju33vb0LdlFdiSn6QlEHmsXZmv9o6Tl63txyRFx3zJ
         LDlHJ9VtwpKmT0e+SRrU5bmnCyvK/IF8xbBN0VJqyu28OsqMXiQtoRykD4tsBsraJA6y
         sJ7PQF0fmUuta+AyFM9a43+l2p5GclgXJriYMa7Yk7nM8cMziAL1UYbZrx5cD/Qgfqg+
         nDdQ==
X-Gm-Message-State: ANoB5pmr0r5fnwHPnZhbUTzmo4+C3scrwNrBvxhRapPhqa15mTvgl3ua
        NGo580sGXvOKQ3oLJCsyTEEMZf1EJALoHg8Xue15Ci4vRSnpvaz/wxy7zlRKQTDab6rPWxLq9Pt
        ZlboFVyijrAIh6fPKc7+Nmwm1hX+DBdGfbKYT3uKVQ5QJ6XsqN+aZFfJ/z8XNYDkg5f6K
X-Google-Smtp-Source: AA0mqf54xfzH0ssMzpqUd5Mqilf5zPH3/iptfkMsAEmsMV62zoJcW2bpWlfTuJm+zAz7fjfI93c1b/hMTbSmOz4s
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:32cd:b0:178:32b9:6f4f with SMTP
 id i13-20020a17090332cd00b0017832b96f4fmr38934026plr.94.1669754003211; Tue,
 29 Nov 2022 12:33:23 -0800 (PST)
Date:   Tue, 29 Nov 2022 20:32:41 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129203240.1815829-1-aaronlewis@google.com>
Subject: [kvm-unit-tests PATCH] x86: Fix test failures as a result of using clang-18
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jsperbeck@google.com, jmattson@google.com,
        seanjc@google.com, Aaron Lewis <aaronlewis@google.com>
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

When building 'debug' test on clang-18 the compiler more aggressively
inlines helper functions.  This results in test failures because some
of the helpers are not intended to be inlined.  Fix this by marking
those functions with 'noinline'.

Reported-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/debug.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/x86/debug.c b/x86/debug.c
index b66bf04..65784c5 100644
--- a/x86/debug.c
+++ b/x86/debug.c
@@ -128,7 +128,7 @@ static void report_singlestep_basic(unsigned long start, const char *usermode)
 	       "%sSingle-step #DB basic test", usermode);
 }
 
-static unsigned long singlestep_basic(void)
+static noinline unsigned long singlestep_basic(void)
 {
 	unsigned long start;
 
@@ -165,7 +165,7 @@ static void report_singlestep_emulated_instructions(unsigned long start,
 	       "%sSingle-step #DB on emulated instructions", usermode);
 }
 
-static unsigned long singlestep_emulated_instructions(void)
+static noinline unsigned long singlestep_emulated_instructions(void)
 {
 	unsigned long start;
 
@@ -204,7 +204,7 @@ static void report_singlestep_with_sti_blocking(unsigned long start,
 }
 
 
-static unsigned long singlestep_with_sti_blocking(void)
+static noinline unsigned long singlestep_with_sti_blocking(void)
 {
 	unsigned long start_rip;
 
@@ -239,7 +239,7 @@ static void report_singlestep_with_movss_blocking(unsigned long start,
 	       "%sSingle-step #DB w/ MOVSS blocking", usermode);
 }
 
-static unsigned long singlestep_with_movss_blocking(void)
+static noinline unsigned long singlestep_with_movss_blocking(void)
 {
 	unsigned long start_rip;
 
@@ -277,7 +277,7 @@ static void report_singlestep_with_movss_blocking_and_icebp(unsigned long start,
 	       "%sSingle-Step + ICEBP #DB w/ MOVSS blocking", usermode);
 }
 
-static unsigned long singlestep_with_movss_blocking_and_icebp(void)
+static noinline unsigned long singlestep_with_movss_blocking_and_icebp(void)
 {
 	unsigned long start;
 
@@ -320,7 +320,7 @@ static void report_singlestep_with_movss_blocking_and_dr7_gd(unsigned long start
 	       "Single-step #DB w/ MOVSS blocking and DR7.GD=1");
 }
 
-static unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
+static noinline unsigned long singlestep_with_movss_blocking_and_dr7_gd(void)
 {
 	unsigned long start_rip;
 
-- 
2.38.1.584.g0f3c55d4c2-goog

