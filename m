Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE69B440515
	for <lists+kvm@lfdr.de>; Fri, 29 Oct 2021 23:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhJ2Vvk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 17:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhJ2Vvk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 17:51:40 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6DBC061570
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 14:49:11 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id x13-20020a17090a1f8d00b001a285b9f2cbso5922071pja.6
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 14:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=CdLKGufbpTM2CKlDAAYXXeBIc9n+GXT/7Jiwz+kLUg4=;
        b=jRT8Iues0/p2ytTSy4OOkLxB0hxqGwZhVWj81sTeylPVmV/sM/2AKB09PvSdt6opn6
         wUMzEW5UQWGmpKjCyhR3pYZ9w+eJA3wSTNR96fMeoDyukF75MfGC2n/AxBAkyxCPHpF9
         ozq22hAWuPGGSDUjClSh61cKrurXQQohkvBK78Bj7Dm5geL9sTcYkKzUgiF5+0xAGzgf
         9LgbBUJwx9jqZ8rnmISs20rqM7Tja5f/wFAdRJSiPREnfwpPgDXxDyzmvltPQvE5E5P+
         xdqFzxudXC2BNTy2Pn6X6F/6v7KFAam6T58cgg7wYAo7rDvOoo7WOJr6L9MOK0bVKGDy
         fsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=CdLKGufbpTM2CKlDAAYXXeBIc9n+GXT/7Jiwz+kLUg4=;
        b=ak4lqE3BeOYoInuxxGZNOAdL+iBVS1FfYHXjVHYVCRWD2beA6Lk8H9IZ+R7vm7mw0D
         cEobJ3xc8eBfX4ruV9E9zlbai4VEZzYOmwhOO/1+9Ma3Ho31JLXPYlGcn4QJgwOp2gF3
         wlbfMwC7KmxPy75bVSsw+2kH7qvWmppYCRL1JOGpDMVRoBttljKbkifSEh2Ic57OFxvJ
         fUxpLs5k3jUz7dAatjNKrDyvnGR4sNgBbvRZEdLC+YZ98GUBqeCFYdQA9O439F+Kr/9A
         L3zWmD9I3PU8AnRPMXUlfdzoLYgEk1hv+hAILXR1qOt35QxVbORj8rHGvDELQST9pN3+
         W7yg==
X-Gm-Message-State: AOAM532ZbjJSbXgOrg862qzuoxFyMHddGrBqiorOjZm/C+YCQ/G72mKw
        AZNJE6+tuqCF0dMzMUOsRXUtg/wd/uOFSwbKEToLQ0utG48BAXfFES6dvSBQRUM/CGtNN3D9/yV
        rGKRaT5MJsXRIg5dZBOaJG/ued95MDqhttiGY4559heUIioi9z5X+/NIGS5IJTW8QRLGv
X-Google-Smtp-Source: ABdhPJyHhXA4ZfdFr+7jqP817J9DTCPaDCzTKCQKjdIq2C8G7HaA+vFLbJ25sDxsFGBIoiDHdbXvwwn26XhXNGnK
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:3b85:: with SMTP id
 pc5mr14223241pjb.74.1635544150485; Fri, 29 Oct 2021 14:49:10 -0700 (PDT)
Date:   Fri, 29 Oct 2021 21:48:00 +0000
Message-Id: <20211029214759.1541992-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [kvm-unit-tests PATCH] x86: Look up the PTE rather than assuming it
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rather than assuming which PTE the SMEP test is running on, look it up
to ensure we have the correct entry.  If this test were to run on a
different page table (ie: run in an L2 test) the wrong PTE would be set.
Switch to looking up the PTE to avoid this from happening.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/access.c   | 9 ++++++---
 x86/cstart64.S | 1 -
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 4725bbd..a4d72d9 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -204,7 +204,7 @@ static void set_cr0_wp(int wp)
 static unsigned set_cr4_smep(int smep)
 {
     unsigned long cr4 = shadow_cr4;
-    extern u64 ptl2[];
+    pteval_t *pte;
     unsigned r;
 
     cr4 &= ~CR4_SMEP_MASK;
@@ -213,11 +213,14 @@ static unsigned set_cr4_smep(int smep)
     if (cr4 == shadow_cr4)
         return 0;
 
+    pte = get_pte(phys_to_virt(read_cr3()), set_cr4_smep);
+    assert(pte);
+
     if (smep)
-        ptl2[2] &= ~PT_USER_MASK;
+        *pte &= ~PT_USER_MASK;
     r = write_cr4_checking(cr4);
     if (r || !smep) {
-        ptl2[2] |= PT_USER_MASK;
+        *pte |= PT_USER_MASK;
 
 	/* Flush to avoid spurious #PF */
 	invlpg((void *)(2 << 21));
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38..4ba9943 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -26,7 +26,6 @@ ring0stacktop:
 .data
 
 .align 4096
-.globl ptl2
 ptl2:
 i = 0
 	.rept 512 * 4
-- 
2.33.1.1089.g2158813163f-goog

