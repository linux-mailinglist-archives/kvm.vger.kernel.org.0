Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C48F132DED7
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhCEBLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbhCEBLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:16 -0500
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE4BC06175F
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:16 -0800 (PST)
Received: by mail-qv1-xf49.google.com with SMTP id d26so196640qve.7
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=LYxFT4pOeVnoMsQ+X9owyhaLmk95i91RCUFmHpd8o00=;
        b=n6UwsGRzwiYvaiDCD6Ln97IoBdaqzvGyTfW0APuURuBqjKPmL3be8RpTz8s6rXOf4c
         X5DCrfuT+xc7S5gYPV5OCzUiy90Cwq5nRsX0kJj0F1aZ/tvfc9PLictCy2Xat1JlFT8d
         43qCHwBDJNwnKUq//RdZD9havfLszBxlJVuA1M8T3vLgWSmJlnid0YN+bZpYxcxj8fQA
         j1QICHQhB8j0Osahhrv93vhcLF3X5CVJmPVVgYKbsDYKYPuJ40fuHRSlhH8p45Zvmm5+
         VHxYHzOyRlZDzdu8XLLnrn/u4+jfkvdiNng13OI5mxMHv7ekCdKoCTt3VTVF2B/XJfpc
         n1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=LYxFT4pOeVnoMsQ+X9owyhaLmk95i91RCUFmHpd8o00=;
        b=rfh/WVFzjVI8TITXo/5urt3ggd84cWsU5/Fql1so7MGb4wzOxXP5FCvmOCOqfHED/+
         8O/rvFPjJLoyuuySEJ1qiePVAzp4+hmspNHs5joNO52vF6S3W8bSW80DCAtm0vOAisT9
         sg7OMmhtaTiqrcKZVObxYtPubi6Q1/q4OfDBl83mW/iI2u6MjmW6dVumoi1pXBUlAKnv
         1KPuAEHmR61UnD2kELuiYByo1xK6TNfZ4oT3ruy5xjr5gHNrM25ARPRf/WLsm/Q7lDCX
         Va8qu6b3GVWz9ATFQIM/H/URNggBKvkUAfC/N5xPsoa3XIfzTTy2xKb4Nk03RUjPvVEi
         DubQ==
X-Gm-Message-State: AOAM532K8zGR+PSefG+9UKVnsigHBQzyot4LZKWwNSBpCpbFslK3J2ST
        moJNHoGy3JmNmWQ5XxxuldtXDqEmnwQ=
X-Google-Smtp-Source: ABdhPJz58uN5rXMxKfkQdJ4mdsacSBHXSYWCi+lQBymZY0ezQ16RmqurQtF/8Qe6WV8yluVuP8NY88pH7pE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a05:6214:20af:: with SMTP id
 15mr6858313qvd.42.1614906675307; Thu, 04 Mar 2021 17:11:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:48 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 04/17] KVM: x86/mmu: Allocate the lm_root before allocating
 PAE roots
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allocate lm_root before the PAE roots so that the PAE roots aren't
leaked if the memory allocation for the lm_root happens to fail.

Note, KVM can still leak PAE roots if mmu_check_root() fails on a guest's
PDPTR, or if mmu_alloc_root() fails due to MMU pages not being available.
Those issues will be fixed in future commits.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 64 ++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c4f8e59f596c..7cb5fb5d2d4d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3308,21 +3308,38 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK;
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
+	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
-		/*
-		 * Allocate the page for the PDPTEs when shadowing 32-bit NPT
-		 * with 64-bit only when needed.  Unlike 32-bit NPT, it doesn't
-		 * need to be in low mem.  See also lm_root below.
-		 */
-		if (!mmu->pae_root) {
-			WARN_ON_ONCE(!tdp_enabled);
+	/*
+	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
+	 * tables are allocated and initialized at root creation as there is no
+	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
+	 * on demand, as running a 32-bit L1 VMM is very rare.  Unlike 32-bit
+	 * NPT, the PDP table doesn't need to be in low mem.  Preallocate the
+	 * pages so that the PAE roots aren't leaked on failure.
+	 */
+	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL &&
+	    (!mmu->pae_root || !mmu->lm_root)) {
+		u64 *lm_root, *pae_root;
 
-			mmu->pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-			if (!mmu->pae_root)
-				return -ENOMEM;
+		if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->lm_root))
+			return -EIO;
+
+		pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		if (!pae_root)
+			return -ENOMEM;
+
+		lm_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+		if (!lm_root) {
+			free_page((unsigned long)pae_root);
+			return -ENOMEM;
 		}
+
+		mmu->pae_root = pae_root;
+		mmu->lm_root = lm_root;
+
+		lm_root[0] = __pa(mmu->pae_root) | pm_mask;
 	}
 
 	for (i = 0; i < 4; ++i) {
@@ -3344,30 +3361,11 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 			return -ENOSPC;
 		mmu->pae_root[i] = root | pm_mask;
 	}
-	mmu->root_hpa = __pa(mmu->pae_root);
-
-	/*
-	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
-	 * tables are allocated and initialized at MMU creation as there is no
-	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
-	 * on demand, as running a 32-bit L1 VMM is very rare.  The PDP is
-	 * handled above (to share logic with PAE), deal with the PML4 here.
-	 */
-	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
-		if (mmu->lm_root == NULL) {
-			u64 *lm_root;
-
-			lm_root = (void*)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-			if (!lm_root)
-				return -ENOMEM;
-
-			lm_root[0] = __pa(mmu->pae_root) | pm_mask;
-
-			mmu->lm_root = lm_root;
-		}
 
+	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
 		mmu->root_hpa = __pa(mmu->lm_root);
-	}
+	else
+		mmu->root_hpa = __pa(mmu->pae_root);
 
 set_root_pgd:
 	mmu->root_pgd = root_pgd;
-- 
2.30.1.766.gb4fecdf3b7-goog

