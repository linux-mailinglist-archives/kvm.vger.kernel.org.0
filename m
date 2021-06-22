Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4773B0F22
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhFVVDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhFVVDa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:30 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB78C061756
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:14 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o14-20020a05620a0d4eb02903a5eee61155so1375296qkl.9
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ogeXtkj2c8Izcn67ls62PAxamc9dXkTYzjrZvENMaR0=;
        b=UtTzOY0YvHYKtJxtzIMDVTX7kd2UkBs1wIPT06m89yGKJjL+sVD2CY+76fcWDqW14R
         aLRGntimUGOevIlGfbZvejeNkVF93xv0obeI9lw3xqEyEKFtkdhKcHpRRsnTW4qYNwHw
         /FWLh21Y8zZRaMcOSDJFW9fzqv+R+QIITE8DVc1cQfy8X3Mjy9boD3wtlG+JMJKmEZHt
         9FeyGl70CSrFCph4LfG7M3QWpHl9jnYR7ajPbU/TCtHUCWeO5SGGzx4QMXfiS0hvwiTP
         z7kjNsd04l4P/1FPWTlNDUG9PX57Xdi2a5hji0pkHhBavzj2Xxn/AD+OVL5yKf9/YfAT
         /MVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ogeXtkj2c8Izcn67ls62PAxamc9dXkTYzjrZvENMaR0=;
        b=BW5FZPeAJodliiYBPXvi46gaKwDcBC4TRtF7M8fWwts52NPUanBZ3S98UnZKdpARIy
         N3XAvUn4IeS2Qnpwz4TFtvjZWIqlCieev5MyUonpElslaZM0/sBpBNsV0q3wFBiQGjya
         rm0DW5wfUcSTD/4byAk5c7vbwW0Qb+GHU6+dDfa9Mg9CfxKmG57qKpb8WIWBN4weP1WR
         9uMXRTSuRE0vhhOxRQQ6gDj+z9iDWKpu2XZSrJC+0o5y3gWbS9aMzQpUQ/hPTUV7biyA
         JjJ0Copqp1HZ4jyorBXE7Bn3k0XdX+Qk9agnwouPUarzSJ+R2tNKU5GPyGHWWpdzUfMf
         RTJQ==
X-Gm-Message-State: AOAM532R3qYtuxDJAy+RQvZUifeICEowHoLTpcA1qvU9CbS5rgBF5klk
        al5QvnUb0/ATUF8IjeFCJciLDrSsanU=
X-Google-Smtp-Source: ABdhPJyOt0RI/DQSmCteDKDwduuAWJBod5bgmda4GKKDU6XMDp5KSAxSOIghBuJ9RxVHZjEO1AZFxkr8nLI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a5b:601:: with SMTP id d1mr6880048ybq.189.1624395673199;
 Tue, 22 Jun 2021 14:01:13 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:45 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 10/12] x86: Let tests omit PT_USER_MASK when
 configuring virtual memory
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let tests opt out of setting PT_USER_MASK so that they can set CR4.SMEP
and/or CR4.SMAP without having to manually modify all PTEs, which is
beyond painful.  Keep user pages the default to avoid having to update
existing tests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/vm.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 221d427..5cd2ee4 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -4,6 +4,8 @@
 #include "alloc_page.h"
 #include "smp.h"
 
+static pteval_t pte_opt_mask;
+
 pteval_t *install_pte(pgd_t *cr3,
 		      int pte_level,
 		      void *virt,
@@ -23,7 +25,7 @@ pteval_t *install_pte(pgd_t *cr3,
             else
                 pt_page = 0;
 	    memset(new_pt, 0, PAGE_SIZE);
-	    pt[offset] = virt_to_phys(new_pt) | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
+	    pt[offset] = virt_to_phys(new_pt) | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask;
 	}
 	pt = phys_to_virt(pt[offset] & PT_ADDR_MASK);
     }
@@ -93,12 +95,12 @@ pteval_t *get_pte_level(pgd_t *cr3, void *virt, int pte_level)
 pteval_t *install_large_page(pgd_t *cr3, phys_addr_t phys, void *virt)
 {
     return install_pte(cr3, 2, virt,
-		       phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK | PT_PAGE_SIZE_MASK, 0);
+		       phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask | PT_PAGE_SIZE_MASK, 0);
 }
 
 pteval_t *install_page(pgd_t *cr3, phys_addr_t phys, void *virt)
 {
-    return install_pte(cr3, 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | PT_USER_MASK, 0);
+    return install_pte(cr3, 1, virt, phys | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask, 0);
 }
 
 void install_pages(pgd_t *cr3, phys_addr_t phys, size_t len, void *virt)
@@ -147,12 +149,17 @@ static void set_additional_vcpu_vmregs(struct vm_vcpu_info *info)
 	write_cr0(info->cr0);
 }
 
-void *setup_mmu(phys_addr_t end_of_memory, void *unused)
+void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
 {
     pgd_t *cr3 = alloc_page();
     struct vm_vcpu_info info;
     int i;
 
+    if (opt_mask)
+	pte_opt_mask = *(pteval_t *)opt_mask;
+    else
+	pte_opt_mask = PT_USER_MASK;
+
     memset(cr3, 0, PAGE_SIZE);
 
 #ifdef __x86_64__
-- 
2.32.0.288.g62a8d224e6-goog

