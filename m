Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3696D6985
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbjDDQyQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbjDDQyB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:01 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBAE46BF
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id e8-20020a17090a118800b0023d35ae431eso10449357pja.8
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rKns3Wiwoan3kRwpsSohFC3AUUF9+LBqJOS4omq70dk=;
        b=M+b3ZrCixJJtyAgR8EjjUthEY2U6c2hV6ICHgrGDs0WvrIICatLiG9+wGyF3V7fLPH
         EwpwczOVRMd+eO2v71R7X1B2nd6y2hc8+ugpx6RndBiYRu73enqmN3kBQd3Xvow0Hfcz
         LPztSLrfopxnvMujETGjqFViwzaj4KfdY/OuoRhN7RUDlWlJ34jYKTVfwwkd+6DN7hk/
         qxIrvy1Vb8sa+rET4iy8TOjFHo+1YIVqjaFhZc4hCWZ009Y+XK8Rvh+yHop8etzr5pEY
         gBYFcTAcawTrnzIA39BxYDvRHE61thhMrXnEPp88ti1NDmEv1w3oC4QNeJ+bl/Fi8AE3
         W6NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rKns3Wiwoan3kRwpsSohFC3AUUF9+LBqJOS4omq70dk=;
        b=oBJ3pGONSxniXpOblSGYD2pJ+it0WY9zpF44ym1Pk+Wu5y8pl0pIkThUekMMaPIWnu
         3TZZ14s0TrRVlC2OwfHFr6boF6C3tHOe3I72gsKY6MeOWFRHtUt2XChqonHbli+g2MZ3
         6ICX3IrLuczPSFFIVMqjCGaeOm0liEPWJs03jmqxYfnW7qr7HPOnaJAa29tO3d6+W8Ls
         klS1JhhbBOnrylGn1K5tL0iV4lpfWtRzAnYe2qsqrrPQrWhhHdh+ZvxW0nNfCAzaZRCU
         BYujEtPN6AmrV2dvs+UtZqKAxhRJJ+l7YmbJRV/juytgr6TABjE+XzQuGncb4P8qmsGt
         qz9Q==
X-Gm-Message-State: AAQBX9cTQWA2YCbFLDKKtw32yB8NavtslX3wm8bnfqScyfcKrBibteIr
        OEK8WWIkG0FgEYjlzmeV1amtNyGx5e4=
X-Google-Smtp-Source: AKy350agzdTgXMGqj+CRU+QR67w/XWUAOKaWhV1akReLdRidQeQaigUxbsBuIBFFuwesW7pmVNKgIJP6lE8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1051:b0:23f:d120:4413 with SMTP id
 gq17-20020a17090b105100b0023fd1204413mr1210974pjb.1.1680627226027; Tue, 04
 Apr 2023 09:53:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:32 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-2-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 1/9] x86: Use existing CR0.WP / CR4.SMEP bit definitions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mathias Krause <minipli@grsecurity.net>

Use the existing bit definitions from x86/processor.h instead of
defining one-off versions in individual tests.

Signed-off-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 11 ++++-------
 x86/pks.c    |  5 ++---
 x86/pku.c    |  5 ++---
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 4dfec230..203353a3 100644
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
index ef95fb96..bda15efc 100644
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
index 51ff412c..6c0d72cc 100644
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
2.40.0.348.gf938b09366-goog

