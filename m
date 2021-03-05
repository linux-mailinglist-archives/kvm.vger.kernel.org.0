Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783AE32DEDC
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCEBL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhCEBLW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:22 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C87C061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:21 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id n10so660602ybb.12
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CmO0jBjVu/c7x8l80OPFh/BbeYFo14Dpvu6vuN/tNRs=;
        b=qnGtoCB+XFmno9EBMk9jcVVvFzLo328MkUD0yjac4wxhw46zCLfzmRFzZ/4ua7M4w8
         MfsXNVlcHndKhGNbOrfmJN3RND0Rwuc/xiLph6AhP3vTvQpLRnGRobmTkUIRzI6K0h0S
         1yH3qovPQLrZJwXjy3yK1+TLxTAj3aFhAWWSTqyIKhdyagk6/Rod8TmUixRpYAk3vUtb
         KORGqEBXyU8XnB3UZVDCNaOPoXm9jKDdx20WbRwxr2cHfH0JxVtwqLvtcFhEsReBq9/5
         vM0NgC1BfLictuoIJBR+U/2G0NViOKpvqmxoLSra+k4QoWdiD2KvwUKXdoMXRfhUKlV6
         C9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CmO0jBjVu/c7x8l80OPFh/BbeYFo14Dpvu6vuN/tNRs=;
        b=drx955hzX0Ek978X3jhwvZDLDIHiODl2xM/JHAGPrco8Wgqy5RqnRPbbkefWkRqmJU
         V9L8mtrphVqT7z7Co4o+zxnIs62mn1lJ9gMFrLPluJE6QIwwiiZfse1Lc0DcDF7Z/bVP
         aR//dxt64XOhpqCBlAfQjmWneESdbE60yu9Q1ncwZIViLijlt3NVt9wnOFFyOh5ju4ib
         72WmBhVs2Uu6ahx5Gh4pi4bK4UzaKvbFhFNVsMg95hfXiqBtMhBfoe5p2rJESR8IhnoX
         Zo3ebukAZGpHncIrSflWApSEFlUD0LCtwEs4uts3WmiRB4o6dHQ3jadodlHv9eu6upnp
         bwkg==
X-Gm-Message-State: AOAM530UGP/DPPytmeE7dyIDnXQt1h2EqBHxix/4ohmEGz4xzdrC+KRz
        oKWHWLPrkJ3B1fX3ygKt2Rju/D492qo=
X-Google-Smtp-Source: ABdhPJwOvNDvvbRu3skaLol+f303QwH6Y9y6nF46U0Wmf6//Sjp7k3BgHEWmglXG6NUwb6NjW24TmW8ziqE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:d6d5:: with SMTP id n204mr10134841ybg.22.1614906680251;
 Thu, 04 Mar 2021 17:11:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:50 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 06/17] KVM: x86/mmu: Ensure MMU pages are available when
 allocating roots
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

Hold the mmu_lock for write for the entire duration of allocating and
initializing an MMU's roots.  This ensures there are MMU pages available
and thus prevents root allocations from failing.  That in turn fixes a
bug where KVM would fail to free valid PAE roots if a one of the later
roots failed to allocate.

Add a comment to make_mmu_pages_available() to call out that the limit
is a soft limit, e.g. KVM will temporarily exceed the threshold if a
page fault allocates multiple shadow pages and there was only one page
"available".

Note, KVM _still_ leaks the PAE roots if the guest PDPTR checks fail.
This will be addressed in a future commit.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 50 +++++++++++++++-----------------------
 arch/x86/kvm/mmu/tdp_mmu.c | 23 ++++--------------
 2 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dd9d5cc13a46..7ebfbc77b050 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2403,6 +2403,15 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 
 	kvm_mmu_zap_oldest_mmu_pages(vcpu->kvm, KVM_REFILL_PAGES - avail);
 
+	/*
+	 * Note, this check is intentionally soft, it only guarantees that one
+	 * page is available, while the caller may end up allocating as many as
+	 * four pages, e.g. for PAE roots or for 5-level paging.  Temporarily
+	 * exceeding the (arbitrary by default) limit will not harm the host,
+	 * being too agressive may unnecessarily kill the guest, and getting an
+	 * exact count is far more trouble than it's worth, especially in the
+	 * page fault paths.
+	 */
 	if (!kvm_mmu_available_pages(vcpu->kvm))
 		return -ENOSPC;
 	return 0;
@@ -3220,16 +3229,9 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 {
 	struct kvm_mmu_page *sp;
 
-	write_lock(&vcpu->kvm->mmu_lock);
-
-	if (make_mmu_pages_available(vcpu)) {
-		write_unlock(&vcpu->kvm->mmu_lock);
-		return INVALID_PAGE;
-	}
 	sp = kvm_mmu_get_page(vcpu, gfn, gva, level, direct, ACC_ALL);
 	++sp->root_count;
 
-	write_unlock(&vcpu->kvm->mmu_lock);
 	return __pa(sp->spt);
 }
 
@@ -3242,16 +3244,9 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 	if (is_tdp_mmu_enabled(vcpu->kvm)) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
-
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
 		mmu->root_hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
-		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
-				      true);
-
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
+		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level, true);
 		mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
@@ -3259,8 +3254,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
-			if (!VALID_PAGE(root))
-				return -ENOSPC;
 			mmu->pae_root[i] = root | PT_PRESENT_MASK;
 		}
 		mmu->root_hpa = __pa(mmu->pae_root);
@@ -3296,8 +3289,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
 				      mmu->shadow_root_level, false);
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
 		mmu->root_hpa = root;
 		goto set_root_pgd;
 	}
@@ -3316,6 +3307,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < 4; ++i) {
 		MMU_WARN_ON(VALID_PAGE(mmu->pae_root[i]));
+
 		if (mmu->root_level == PT32E_ROOT_LEVEL) {
 			pdptr = mmu->get_pdptr(vcpu, i);
 			if (!(pdptr & PT_PRESENT_MASK)) {
@@ -3329,8 +3321,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, false);
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
 		mmu->pae_root[i] = root | pm_mask;
 	}
 
@@ -3394,14 +3384,6 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-static int mmu_alloc_roots(struct kvm_vcpu *vcpu)
-{
-	if (vcpu->arch.mmu->direct_map)
-		return mmu_alloc_direct_roots(vcpu);
-	else
-		return mmu_alloc_shadow_roots(vcpu);
-}
-
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -4846,7 +4828,15 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
-	r = mmu_alloc_roots(vcpu);
+	write_lock(&vcpu->kvm->mmu_lock);
+	if (make_mmu_pages_available(vcpu))
+		r = -ENOSPC;
+	else if (vcpu->arch.mmu->direct_map)
+		r = mmu_alloc_direct_roots(vcpu);
+	else
+		r = mmu_alloc_shadow_roots(vcpu);
+	write_unlock(&vcpu->kvm->mmu_lock);
+
 	kvm_mmu_sync_roots(vcpu);
 	if (r)
 		goto out;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 70226e0875fe..50ef757c5586 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -137,22 +137,21 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return sp;
 }
 
-static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 {
 	union kvm_mmu_page_role role;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
 
-	write_lock(&kvm->mmu_lock);
-
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root) {
 		if (root->role.word == role.word) {
 			kvm_mmu_get_root(kvm, root);
-			write_unlock(&kvm->mmu_lock);
-			return root;
+			goto out;
 		}
 	}
 
@@ -161,19 +160,7 @@ static struct kvm_mmu_page *get_tdp_mmu_vcpu_root(struct kvm_vcpu *vcpu)
 
 	list_add(&root->link, &kvm->arch.tdp_mmu_roots);
 
-	write_unlock(&kvm->mmu_lock);
-
-	return root;
-}
-
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu_page *root;
-
-	root = get_tdp_mmu_vcpu_root(vcpu);
-	if (!root)
-		return INVALID_PAGE;
-
+out:
 	return __pa(root->spt);
 }
 
-- 
2.30.1.766.gb4fecdf3b7-goog

