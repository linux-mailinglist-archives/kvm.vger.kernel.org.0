Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C40D6D21DA
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 15:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232509AbjCaN5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Mar 2023 09:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbjCaN5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Mar 2023 09:57:31 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF677C669
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:26 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id x3so89860643edb.10
        for <kvm@vger.kernel.org>; Fri, 31 Mar 2023 06:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680271045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XE1yojV/hoOkVZOn9CEqppzBj+fchtb54t/c0FawRuY=;
        b=PqyLujmpdRa8jFLDJ6RXmtdY96zL9V9h7GKJAPWwiJgYI9hUR5lyFW3tIT/Q+83R+F
         iKgoQjY2WbVBJavwKfh/VEW64PP2JsyKLUrMQjzHT539LdvOP3tBf2EqaJsvwKks/jpO
         7ULVuN77HsvvcAdhdk6uXrAwXiz3y2PzywsD0VzO53uXw1+HPtw1nUqXOEDCKh26L4Bv
         A7muV7XRrki6yTC0Pl7iezDhFcf5z0sd4P56OXxKLNq16+7ngFo4vqKufncHKk6Ewale
         U9Qam1jLJKsZw7pNlCx66UlvQES22p73/M2mj783F+3nfE86kGha/4GXK7Rlx05vdppo
         ikjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680271045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XE1yojV/hoOkVZOn9CEqppzBj+fchtb54t/c0FawRuY=;
        b=kdz5D31qelbxno4F9S8TJ9WJF14sX0ywwtrVFozYqlgN8AbgJi/f9ErBFqt8QAuJpd
         MH6+da28O1bP9iXhMGQpmzvwdSBlQQ0gmHXZXvz19KVHdyB6PcfpMDuBLxKHX7r6IOoK
         O2NIW7pSgVFUugsXkKHCnUVbThENL/1t6+xMCPos/KTYET3APY/6AqkAM7jVZRYHGrNU
         2GjiQHg/6lf4Nu0uY7jRnwfpKxt9bYT5jZl5sXz7Kenw3Ys1SESlyjyb0uTGHaLlXdsf
         VfGR1m8jORpg0MtRfLpSrnMGUJMBqlxA7ZyUfuX47eyJ9OCON1XGVBl2h9rnr+XPMlLX
         Wk+A==
X-Gm-Message-State: AAQBX9eQvq7Dvom4TgkWxd+JuFJX7RN+s6CMp1utD5tXM565HLgC5Uip
        bX6WshnzeuHVDuH3gtOmZUK+huClEh/aXonTYL19kA==
X-Google-Smtp-Source: AKy350a3szEhvmYZeCnhK2KUegckCTBDTnbEA5dOwzcIyIDIEbmsMFuFNGN6L/4suwykEUbZ0vSZcA==
X-Received: by 2002:a17:906:ac1:b0:92d:9767:8e0a with SMTP id z1-20020a1709060ac100b0092d97678e0amr24377466ejf.13.1680271044523;
        Fri, 31 Mar 2023 06:57:24 -0700 (PDT)
Received: from nuc.fritz.box (p200300f6af1a510052e55a748e5a73cd.dip0.t-ipconnect.de. [2003:f6:af1a:5100:52e5:5a74:8e5a:73cd])
        by smtp.gmail.com with ESMTPSA id ay20-20020a170906d29400b00928de86245fsm996888ejb.135.2023.03.31.06.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 06:57:24 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH v2 1/4] x86: Use existing CR0.WP / CR4.SMEP bit definitions
Date:   Fri, 31 Mar 2023 15:57:06 +0200
Message-Id: <20230331135709.132713-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230331135709.132713-1-minipli@grsecurity.net>
References: <20230331135709.132713-1-minipli@grsecurity.net>
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
defining our own.

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

