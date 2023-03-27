Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503856CACD3
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 20:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjC0SQP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 14:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjC0SQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 14:16:11 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2A0230E2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:16:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id r11so39843489edd.5
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 11:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1679940965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XE1yojV/hoOkVZOn9CEqppzBj+fchtb54t/c0FawRuY=;
        b=u1Jr5RiRE42G8NsiUzQyhJYggtGgkVOXibiv3Z+HqQvJf9s4/OqX/0oGT/UYqMEU1T
         3rgQzBDHNVlj0t2a+HrnMjYUevletNW/z8BF98/OqmIlWdPNvg7EmOpdhBDR8stSJHxR
         +0mRIkyYN87cPAo9axO2MT7/xQpWNtEqHS649hvCU6LC8ID1QZ5B7vugDaAYMI1NY9mL
         a8/Gah9B8pq6tpRRXTecv/Qk6XkWSYwUHDJpmnxuDeS7AtJGAnQimu8xXFvaKG3O6vTv
         Yw00UMDFLzbqHu2TbTx+5wpEpzOORSBD1FjVt3unPfI+wIzlQz0BQrHbGnmhXEIHvL3k
         1IdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679940965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XE1yojV/hoOkVZOn9CEqppzBj+fchtb54t/c0FawRuY=;
        b=g3FK4ogld1DLNgpW9TjYVen6+4lqO1bW+OJIMWG8JRGiwwn1/RsxtIuNZS4Na+RLRK
         Rk9npNfb8Tos+QRLlvrq4oFTYzKhHJomakTGWTIFlcRVaSG/8RSppdZay9eUsq5u4V4b
         2LdX18l7CgA0JG4XYsUo7xA4KT9GUdAfKFlNhAUJ5NOPfpPEqj6uXVsufVBxXqooU6yX
         OPyKkOSuqXKKkGehzAm0QtarDlKxFbBK/DAd8rEFwlRWnb+d7i0OQPKccNFC8zBMc22l
         PgkNJ38DWeqEKJYhzPPBTuNDyDqFzkt+Bi6HQhbfDE9rp++giuaM3OyBJOjXAYJa/ITX
         tFjg==
X-Gm-Message-State: AAQBX9dzAUyvDk2K3y3QRHlBslliel2Bwi2jzahn2+Fk0pjkz5pSJVJC
        voUUj7hLQtqEc8hD/VFPJ12P9eS3oMTdguirBEk=
X-Google-Smtp-Source: AKy350Y+u7M0q20dYPiHHAELdOelMKlBd8+qD+X46E1E0nV8ljJe4fTcqnD8wcnzO9wtbnDWYkRmqA==
X-Received: by 2002:a17:906:bcec:b0:926:8992:4310 with SMTP id op12-20020a170906bcec00b0092689924310mr13865482ejb.38.1679940965251;
        Mon, 27 Mar 2023 11:16:05 -0700 (PDT)
Received: from localhost.localdomain (p4ffe007e.dip0.t-ipconnect.de. [79.254.0.126])
        by smtp.gmail.com with ESMTPSA id 22-20020a170906309600b0092f289b6fdbsm14245396ejv.181.2023.03.27.11.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 11:16:04 -0700 (PDT)
From:   Mathias Krause <minipli@grsecurity.net>
To:     kvm@vger.kernel.org
Cc:     Mathias Krause <minipli@grsecurity.net>
Subject: [kvm-unit-tests PATCH 1/2] x86: Use existing CR0.WP / CR4.SMEP bit definitions
Date:   Mon, 27 Mar 2023 20:19:10 +0200
Message-Id: <20230327181911.51655-2-minipli@grsecurity.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327181911.51655-1-minipli@grsecurity.net>
References: <20230327181911.51655-1-minipli@grsecurity.net>
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

