Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274DB35AE77
	for <lists+kvm@lfdr.de>; Sat, 10 Apr 2021 16:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhDJOmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Apr 2021 10:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbhDJOmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Apr 2021 10:42:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA92C06138B
        for <kvm@vger.kernel.org>; Sat, 10 Apr 2021 07:42:38 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id r22so9799826edq.9
        for <kvm@vger.kernel.org>; Sat, 10 Apr 2021 07:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kTawFiL6YC0ek5PHB26XWuvo8LaNhKMkeOr4Du3g3zA=;
        b=JCcCeg0rQfZpHF7PhaQNGA3miaa7tggjS+utX6p12DI0sTb0ihsmqMgvvGsbxtDHCr
         KgoxghxA7da6cqteVtbnfdO5V/Pc97pVB/ZvZVnWPHB9wxtQxiJw8CRBdl+mbjT7FQEX
         1jxnAnJoT8pgL6emKLIsCAiabuxq45xMybI397PO1WX6fCN20mDAnGeLbOuRj+tslGID
         k7fLuauKxt18AHgRiTMJx3N8l/0z2pwcZE+4CWsQsuLtFzIlqjgCUuUwbYZ9wsAgg0Bi
         pfD0Ze0K6Y8gsSkfdsODcr1rRuva1eS7YeXt+og1VSY4EygWHqVoZ/J05B/xXUjB8aRB
         eatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=kTawFiL6YC0ek5PHB26XWuvo8LaNhKMkeOr4Du3g3zA=;
        b=ODW/6dgrNSirnjUoQvNVPf04C17s+8NiXgzp/YP9RYxkA77gmTn8TbRDUX2mc/kaai
         QjRcHaDrWH8/UGmt844repkdds5d3BNrco6fqsV/z5KpjHrYhbIRKpTErmFz1XEeT9E/
         53yYzMZCSHTJK1mqzFuX+B2dYKuH1AlT3ycdyZjxUIx2lmueSbEKUyqFPx1rG0YJYL5e
         eRJQjVFb9naKcb2m7O0NmjABw3esj92bMyfSZFG3ATASXGpCOU19ieRjD/3j89KIbqkx
         P9q7Pim+RdC9mDTpUpwS9bh3zdiXbQGQqGtuJMPO0qvMod9Unb9M5sy6tGNklgcexK7y
         q1Yw==
X-Gm-Message-State: AOAM530wFd2LsRzW8ljt7IMZrK5LG44WIbzRcwlgBTDo2UvXpC3DaPu6
        ewGJWuzAs+8CuFnpqwsRVD6sOAqy1DM=
X-Google-Smtp-Source: ABdhPJw76ssbtXK8h1CD4DJy4g5SmIyJB4j8fKnOjZbRV/ewnbsLEO1fsF1/x1o4JGKvUz5HJrCEUA==
X-Received: by 2002:a05:6402:34d5:: with SMTP id w21mr21863459edc.14.1618065756922;
        Sat, 10 Apr 2021 07:42:36 -0700 (PDT)
Received: from avogadro.redhat.com ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id q18sm3171357edr.26.2021.04.10.07.42.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 07:42:36 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH kvm-unit-tests] access: change CR0/CR4/EFER before TLB flushes
Date:   Sat, 10 Apr 2021 16:42:34 +0200
Message-Id: <20210410144234.32124-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After CR0/CR4/EFER changes a stale TLB entry can be observed, because MOV
to CR4 only invalidates TLB entries if CR4.SMEP is changed from 0 to 1.

The TLB is already flushed in ac_set_expected_status,
but if kvm-unit-tests is migrated to another CPU and CR4 is
changed after the flush, a stale entry can be used.

Reported-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/access.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 66bd466..e5d5c00 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -448,8 +448,6 @@ fault:
 
 static void ac_set_expected_status(ac_test_t *at)
 {
-    invlpg(at->virt);
-
     if (at->ptep)
 	at->expected_pte = *at->ptep;
     at->expected_pde = *at->pdep;
@@ -561,6 +559,18 @@ static void __ac_setup_specific_pages(ac_test_t *at, ac_pool_t *pool,
 	root = vroot[index];
     }
     ac_set_expected_status(at);
+
+    set_cr0_wp(F(AC_CPU_CR0_WP));
+    set_efer_nx(F(AC_CPU_EFER_NX));
+    set_cr4_pke(F(AC_CPU_CR4_PKE));
+    if (F(AC_CPU_CR4_PKE)) {
+        /* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
+        write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
+                   (F(AC_PKU_AD) ? 4 : 0));
+    }
+
+    set_cr4_smep(F(AC_CPU_CR4_SMEP));
+    invlpg(at->virt);
 }
 
 static void ac_test_setup_pte(ac_test_t *at, ac_pool_t *pool)
@@ -644,17 +654,6 @@ static int ac_test_do_access(ac_test_t *at)
     *((unsigned char *)at->phys) = 0xc3; /* ret */
 
     unsigned r = unique;
-    set_cr0_wp(F(AC_CPU_CR0_WP));
-    set_efer_nx(F(AC_CPU_EFER_NX));
-    set_cr4_pke(F(AC_CPU_CR4_PKE));
-    if (F(AC_CPU_CR4_PKE)) {
-        /* WD2=AD2=1, WD1=F(AC_PKU_WD), AD1=F(AC_PKU_AD) */
-        write_pkru(0x30 | (F(AC_PKU_WD) ? 8 : 0) |
-                   (F(AC_PKU_AD) ? 4 : 0));
-    }
-
-    set_cr4_smep(F(AC_CPU_CR4_SMEP));
-
     if (F(AC_ACCESS_TWICE)) {
 	asm volatile (
 	    "mov $fixed2, %%rsi \n\t"
-- 
2.30.1

