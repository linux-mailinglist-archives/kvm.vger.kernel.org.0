Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9666932B599
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381339AbhCCHSn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581642AbhCBTBX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 14:01:23 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5930FC0611C3
        for <kvm@vger.kernel.org>; Tue,  2 Mar 2021 10:46:05 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id lk3so2525990pjb.9
        for <kvm@vger.kernel.org>; Tue, 02 Mar 2021 10:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=o1VKZ6+LkEpFaDICD3QOjbJ8GdnaSlQdzWdXunTpsjE=;
        b=TtChc1k0rg4FV+bsfKDIAX1dpUzBoncazX8loWSo0PhZXBnzWTuyMTMJaVmepKzUAa
         RRE/xBkcYaoezCgX6Jj4z+UHGz4VTuRK4mQGfVp3SPNBG2O0WNXE2SpCxrU7cRYoL9Zu
         ZUv1hbr/rYZV61H8137hCE/WStVtAdVWrNKtyvnDLSgZYwz5VqT8X0JlAbdQhFQpSGTG
         e57MM0CNGFjTsuG/6oZPDcUuU7yKeAYJxO7XkcfgTAIWnELSeTq+T7QNsKQLaH5PbVKJ
         tqtje1+XSMVxZe4bNCXdRrn5s6eiL54g25w21h3PTGbr24L8+38PL7ujvb+DsZE5sJ6F
         hocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=o1VKZ6+LkEpFaDICD3QOjbJ8GdnaSlQdzWdXunTpsjE=;
        b=bHwRWnix2XbJt92roetkkLpYq8L+7u1L+h0eKhdQGqA9qJvfHljrOdeQIDjaTGB8EL
         P2vSfPYjTtVrmG6l5KlRNlYmOv6hfBnNmu2RYjwlRVRwmaa1TD/ayaoFNpXYYYfe2Bxc
         5VKqJVKRoCym/DBLXDSmSHxfMuUnEBWQixPWOlDyMZnCQJ+nA5Gsu9Bz0ab+rmId2b1R
         Ks8VkI3AVVKczSNnhp92owr3rW12ulr0UWFOPV/D/b+89GdokqZbZUAMq1cv431AKKsi
         SIAgD00jpDIqQ7buYjQTiB+o+/9EheI225V30dGS+CHbOU6dI3g+k94jKy242WO/de4z
         Fniw==
X-Gm-Message-State: AOAM532B0VPbOmpDp/6FQftxTTn/0C9SaYk0b2HkCHByFjZ7zaz7yLdG
        PvM68CedWjx9JBg8+7UHoDvb//vpMkg=
X-Google-Smtp-Source: ABdhPJx+UnXRWkcfqxPFPEu0Ip6uAE9yR6VcRfIEH3w0TM1YNbrpPpQpU/4GnGH7WZ0/NuKdc0GV0yqEetU=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:805d:6324:3372:6183])
 (user=seanjc job=sendgmr) by 2002:a0c:bdaf:: with SMTP id n47mr4819595qvg.48.1614710753763;
 Tue, 02 Mar 2021 10:45:53 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  2 Mar 2021 10:45:28 -0800
In-Reply-To: <20210302184540.2829328-1-seanjc@google.com>
Message-Id: <20210302184540.2829328-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210302184540.2829328-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 03/15] KVM: x86/mmu: Ensure MMU pages are available when
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

Note, KVM still leaks the PAE roots if the lm_root allocation fails.
This will be addressed in a future commit.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 41 ++++++++++++--------------------------
 arch/x86/kvm/mmu/tdp_mmu.c | 23 +++++----------------
 2 files changed, 18 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ed3fac1244e..1f129001a30c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2398,6 +2398,9 @@ static int make_mmu_pages_available(struct kvm_vcpu *vcpu)
 {
 	unsigned long avail = kvm_mmu_available_pages(vcpu->kvm);
 
+	/* Ensure all four PAE roots can be allocated in a single pass. */
+	BUILD_BUG_ON(KVM_MIN_FREE_MMU_PAGES < 4);
+
 	if (likely(avail >= KVM_MIN_FREE_MMU_PAGES))
 		return 0;
 
@@ -3220,16 +3223,9 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
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
 
@@ -3241,16 +3237,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 	if (is_tdp_mmu_enabled(vcpu->kvm)) {
 		root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
-
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
 				      true);
-
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
@@ -3258,8 +3248,6 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
-			if (!VALID_PAGE(root))
-				return -ENOSPC;
 			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;
 		}
 		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
@@ -3294,8 +3282,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
 				      vcpu->arch.mmu->shadow_root_level, false);
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
 		vcpu->arch.mmu->root_hpa = root;
 		goto set_root_pgd;
 	}
@@ -3325,6 +3311,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < 4; ++i) {
 		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
+
 		if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL) {
 			pdptr = vcpu->arch.mmu->get_pdptr(vcpu, i);
 			if (!(pdptr & PT_PRESENT_MASK)) {
@@ -3338,8 +3325,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 
 		root = mmu_alloc_root(vcpu, root_gfn, i << 30,
 				      PT32_ROOT_LEVEL, false);
-		if (!VALID_PAGE(root))
-			return -ENOSPC;
 		vcpu->arch.mmu->pae_root[i] = root | pm_mask;
 	}
 	vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
@@ -3373,14 +3358,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -4822,7 +4799,15 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->direct_map);
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

