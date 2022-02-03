Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C34F4A7D1C
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiBCBBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348654AbiBCBBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:12 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A725C06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:12 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id p29-20020a634f5d000000b003624b087f05so575170pgl.7
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=6KmMfMviXjhh47073t9JRPIjwz/2bj2JAaTlcyJJ9So=;
        b=OHS/4Tryvc4rLrAkA7SgL54tIZSl/+WdXyA5qOzSGcqgECQsX0xmmvmuwVxFJBB8n0
         UxeBMdL7I9fFd7nbiosXRu5snlxQhwcQu232GJKVojDQ4bF29WgAOZCVvb3F+nr2WQRY
         gM7uepdJSDU80azqpYqBQneApdRtqYMg0TPciUyHlFawXNndLEisiGpoWIhKGCXCz4Oh
         kovlkcVv1NfeEuOZmoiSngPnJ+Ab+p5WGyeMAsHN/Hc+vd52K/pLdWwDlHJRyF55bouE
         r9DACAtMSFlH+XSMYe4oAOTsOm6oaNP+UB5RDXxRkoirKa2v7yZN7ZRL30wL0tcYET7G
         K/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=6KmMfMviXjhh47073t9JRPIjwz/2bj2JAaTlcyJJ9So=;
        b=tfuPcxElJJ8+iyPZmWg4su2w2nb0Caz85sDtuhT9lXscBX4JAcJ8OdhdVyJNe5Wmg6
         m5zM2WGp5aTkPQCuyMx9xIu15C9bbRpXFYIgLM74ZEBo48YhBZlr6yBB9P5+J6MGz+f7
         1nvvUbrvXUcwvIvgrGeV0AE88FtahtTmBWVvG2qwM8fnUqPpxT+2+PqihnFD1BFEVVBk
         2LD8ilkQDPv+A53yUKTHPvSHfCI69V8Usn2pp9ypAKCBUh+/zySGDEkQ4NuI+spWvNR7
         uHGGU6lc8Zu5Os6d5eRp2Ap6ELTKyX4kZOirJaBu8q2hj+4RXkVj+6L02zlVtc0+JDfj
         VSEA==
X-Gm-Message-State: AOAM532g5gCUS69UHN3onfYvb316O5x35WB+MWBSLxAXM7TMyJKjvyQy
        jQ9UvS0hFXB8TeIftXIHvf0XDTphOXdT/A==
X-Google-Smtp-Source: ABdhPJzBvRJYYNGhqcwrxLrYThKR4uZHb9SZRU/KWAXLiv724Ph1LTf5kTkD0+Q2PplUV5xPxnlMESNZNwHrCA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a62:2982:: with SMTP id
 p124mr32182607pfp.53.1643850071923; Wed, 02 Feb 2022 17:01:11 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:35 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 07/23] KVM: x86/mmu: Move huge page split sp allocation code
 to mmu.c
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the code that allocates a new shadow page for splitting huge pages
into mmu.c. Currently this code is only used by the TDP MMU but it will
be reused in subsequent commits to also split huge pages mapped by the
shadow MMU.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/mmu/mmu_internal.h |  2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 23 ++---------------------
 3 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d4f90a10b652..3acdf372fa9a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1730,6 +1730,32 @@ static struct kvm_mmu_page *kvm_mmu_alloc_sp(struct kvm_vcpu *vcpu, bool direct)
 	return sp;
 }
 
+/*
+ * Allocate a new shadow page using the provided GFP flags to split a huge page.
+ *
+ * Huge page splitting always uses direct shadow pages since the huge page is
+ * being mapped directly with a lower level page table. Thus there's no need to
+ * allocate the gfns array.
+ */
+struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(gfp_t gfp)
+{
+	struct kvm_mmu_page *sp;
+
+	gfp |= __GFP_ZERO;
+
+	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
+	if (!sp)
+		return NULL;
+
+	sp->spt = (void *)__get_free_page(gfp);
+	if (!sp->spt) {
+		kmem_cache_free(mmu_page_header_cache, sp);
+		return NULL;
+	}
+
+	return sp;
+}
+
 static void mark_unsync(u64 *spte);
 static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index da6166b5c377..2c80028695ca 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -160,4 +160,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
+struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(gfp_t gfp);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8def8f810cb0..0d58c3d15894 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1263,25 +1263,6 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
-{
-	struct kvm_mmu_page *sp;
-
-	gfp |= __GFP_ZERO;
-
-	sp = kmem_cache_alloc(mmu_page_header_cache, gfp);
-	if (!sp)
-		return NULL;
-
-	sp->spt = (void *)__get_free_page(gfp);
-	if (!sp->spt) {
-		kmem_cache_free(mmu_page_header_cache, sp);
-		return NULL;
-	}
-
-	return sp;
-}
-
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       struct tdp_iter *iter,
 						       bool shared)
@@ -1297,7 +1278,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = kvm_mmu_alloc_direct_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
 	if (sp)
 		return sp;
 
@@ -1309,7 +1290,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = kvm_mmu_alloc_direct_sp_for_split(GFP_KERNEL_ACCOUNT);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
-- 
2.35.0.rc2.247.g8bbb082509-goog

