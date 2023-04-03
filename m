Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35F36D42B0
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjDCK4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjDCK4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:56:37 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ECED61A3
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 03:56:35 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id j24so28921391wrd.0
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 03:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680519393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tvq2Ku7+r2hCsvAVWbqSUv9fohN3osKERwU7gfauayA=;
        b=DXg87Kr1aQLpt/NeklDhnizO8Fm/hhU1/lNnX3vxY8y3EHgHFXHvcnC43pjQNaGUDP
         CJ6ds0K0ijiSLy8T+5e29E0IKkKVhpsk1KIKOxmcMTUxVr5tBMt4xBA/0t1Fg7kEiKkM
         IfbwJbJVoFFuq9MolSk2uNDk6KGl0nN57w3YKLfLNM8B5jEdqFu8bKI4nTgeOQwXVbdP
         xe9jCTTDumO/6FV4Zcm5zUeQhff674yA1zXdngud7DRQycPScGGL9Tl8+tm0v9MTxKir
         EbNZKsPdoJ1/TNOaksw6iZy2o2R/hbb2GZBV5IFyyJ5Y29J3kBaUz6KsA+WUcRH5OVZ2
         Iavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680519393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tvq2Ku7+r2hCsvAVWbqSUv9fohN3osKERwU7gfauayA=;
        b=HoY2vMZjz5i8845PimgJJaG2kcQ6EA9BStT4GgE9QIvVl5l/Glz/anyzEIxXxyDLEm
         gOXCWFyjH9hIfk/KfZcz9tHvhJzXWweqcZcfd2LE74fVZolQGwPTvF8xx9R5+MT5ejdf
         i72BkRF3BXk+QjOMmLaIx7JZaP/acBRPcCHVS2JZXDPnp/iqOLWTQ/sC5m7yKdSwPZ5K
         z7Xfyf6+yaNvaL+RP8fgveOCxuq1l7yzILwGJiRZz37NPvwbj5TOm+NZfXryMSzNeJdj
         idZEa3we7oexp6t6F52usSuHVk48DwhTm99SR8LXp+KNaFfWu4iqPyBamJyIeDPlS6Ml
         kRRg==
X-Gm-Message-State: AAQBX9daKRHlR9MgHiwwLvgPloEL/Y7k3XS9US2HVLBAwQFrS8PwRB0S
        aRzF3+viKNyJQiabNjPLhnDBkEOd0SR/mI5LurPoyA==
X-Google-Smtp-Source: AKy350agVdPjU1Lm8smDa0L24zDRnl14626ymLKEG6qoTsTUhdeGSJBsG+/0WTFnJ1fEYxZX8CmCWQ==
X-Received: by 2002:a05:6000:7:b0:2cf:f314:774d with SMTP id h7-20020a056000000700b002cff314774dmr26607311wrx.44.1680519393228;
        Mon, 03 Apr 2023 03:56:33 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af22160069a3c79c8928b176.dip0.t-ipconnect.de. [2003:f6:af22:1600:69a3:c79c:8928:b176])
        by smtp.gmail.com with ESMTPSA id x6-20020a5d60c6000000b002dfca33ba36sm9483671wrt.8.2023.04.03.03.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 03:56:32 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v3 1/4] x86: Use existing CR0.WP / CR4.SMEP bit definitions
Date:   Mon,  3 Apr 2023 12:56:15 +0200
Message-Id: <20230403105618.41118-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230403105618.41118-1-minipli@grsecurity.net>
References: <20230403105618.41118-1-minipli@grsecurity.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the existing bit definitions from x86/processor.h instead of
defining one-off versions in individual tests.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
---
 x86/access.c | 11 ++++-------
 x86/pks.c    |  5 ++---
 x86/pku.c    |  5 ++---
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 4dfec23073f7..203353a3f74f 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -20,9 +20,6 @@ static int invalid_mask;
 #define PT_BASE_ADDR_MASK ((pt_element_t)((((pt_element_t)1 << 36) - 1) & PAGE_MASK))
 #define PT_PSE_BASE_ADDR_MASK (PT_BASE_ADDR_MASK & ~(1ull << 21))
 
-#define CR0_WP_MASK (1UL << 16)
-#define CR4_SMEP_MASK (1UL << 20)
-
 #define PFERR_PRESENT_MASK (1U << 0)
 #define PFERR_WRITE_MASK (1U << 1)
 #define PFERR_USER_MASK (1U << 2)
@@ -239,9 +236,9 @@ static void set_cr0_wp(int wp)
 {
 	unsigned long cr0 = shadow_cr0;
 
-	cr0 &= ~CR0_WP_MASK;
+	cr0 &= ~X86_CR0_WP;
 	if (wp)
-		cr0 |= CR0_WP_MASK;
+		cr0 |= X86_CR0_WP;
 	if (cr0 != shadow_cr0) {
 		write_cr0(cr0);
 		shadow_cr0 = cr0;
@@ -272,9 +269,9 @@ static unsigned set_cr4_smep(ac_test_t *at, int smep)
 	unsigned long cr4 = shadow_cr4;
 	unsigned r;
 
-	cr4 &= ~CR4_SMEP_MASK;
+	cr4 &= ~X86_CR4_SMEP;
 	if (smep)
-		cr4 |= CR4_SMEP_MASK;
+		cr4 |= X86_CR4_SMEP;
 	if (cr4 == shadow_cr4)
 		return 0;
 
diff --git a/x86/pks.c b/x86/pks.c
index ef95fb96c597..bda15efc546d 100644
--- a/x86/pks.c
+++ b/x86/pks.c
@@ -5,7 +5,6 @@
 #include "x86/vm.h"
 #include "x86/msr.h"
 
-#define CR0_WP_MASK      (1UL << 16)
 #define PTE_PKEY_BIT     59
 #define SUPER_BASE        (1 << 23)
 #define SUPER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) + SUPER_BASE)))
@@ -18,9 +17,9 @@ static void set_cr0_wp(int wp)
 {
     unsigned long cr0 = read_cr0();
 
-    cr0 &= ~CR0_WP_MASK;
+    cr0 &= ~X86_CR0_WP;
     if (wp)
-        cr0 |= CR0_WP_MASK;
+        cr0 |= X86_CR0_WP;
     write_cr0(cr0);
 }
 
diff --git a/x86/pku.c b/x86/pku.c
index 51ff412cef82..6c0d72cc6f81 100644
--- a/x86/pku.c
+++ b/x86/pku.c
@@ -5,7 +5,6 @@
 #include "x86/vm.h"
 #include "x86/msr.h"
 
-#define CR0_WP_MASK      (1UL << 16)
 #define PTE_PKEY_BIT     59
 #define USER_BASE        (1 << 23)
 #define USER_VAR(v)      (*((__typeof__(&(v))) (((unsigned long)&v) + USER_BASE)))
@@ -18,9 +17,9 @@ static void set_cr0_wp(int wp)
 {
     unsigned long cr0 = read_cr0();
 
-    cr0 &= ~CR0_WP_MASK;
+    cr0 &= ~X86_CR0_WP;
     if (wp)
-        cr0 |= CR0_WP_MASK;
+        cr0 |= X86_CR0_WP;
     write_cr0(cr0);
 }
 
-- 
2.39.2

