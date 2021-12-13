Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDEB2473834
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 23:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244105AbhLMW7g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 17:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244093AbhLMW7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 17:59:34 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB124C06173F
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:33 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id s22-20020a056a00179600b004b31f2cdb19so2181281pfg.7
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 14:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=qbJieaZuu87kEMt04U4TNMVcgVWYL2WjrOpD1ljrWDc=;
        b=lEG+wIsncHNBbz6yrYgLYNCMI/UhW6vi7GQ6gSpVK4Q2P3Lwq4xs1/bZMF7j+wkvXx
         hXuTA08YuuuCtw/PuJKYf30Een5c+N6++PFcuG7jVrMppaCwjb0i0Fm8Sfpfcf6lxwoL
         hTzSHm+xe89MpzLv/+cq0iwxqt3vbXgngFEs0CW3Q35YD0QNOZs+QD+4Gzj4umrNXmRf
         DucFfTSp63r5LINLWuqpdvvefCf0D3rOhC1mWI652SFivBLBtMpS/TXmu8ug7+kt1geW
         vsfAOdmbZLONbDU8sRjzwu4VOUKaI7kESXMz6qenPjpBpTWoXnrzcwwBoKXz5weVQNgz
         j/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=qbJieaZuu87kEMt04U4TNMVcgVWYL2WjrOpD1ljrWDc=;
        b=we3cN+nGZ3/zwwbY/3WffGdmDTiW7hELiZbowfumGJMJkPTgrcjvGNPYdT7Qn7necs
         cLU6rCivylPk7XFpVB5jADqIQJM4fEQNEv3MCAQIYEiEH2VEvya2Ril8MKApw75JcQ+V
         nrlUbWpzv6qnqkahOQAKcN80y3QYwmT+R54aTYh4zDSvrD7vbWcQtHALb8PdcoVKhvAW
         74cnejN2rxcHN+R00c74cFtDCGa0ITdY2sTABVLGW1qtrmuETJCIVS98E7S0rwAFdR1C
         fJu4u8yzPvLP+CLZu0t0q9oKtQ+TTbOK6/kPO6IAPecDDJlQb+YzY67RouoE6j4gogat
         fKPw==
X-Gm-Message-State: AOAM530z2kMrtnBml5TcNDc70PHL/Y4/+UFXdhI4XjrTGnSq3UXB2OAf
        DaL4xO0Efz0om5DcuN826CK37kG2DW/HbA==
X-Google-Smtp-Source: ABdhPJz43pp1XwQ5G6OTwEPPV5fRJP87AnvL1NLsovbaGTAhycIMv81QOzG1WYQk7qhqi+zV6uWVXsQ6ZJiLwA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1a92:: with SMTP id
 ng18mr1076877pjb.19.1639436373299; Mon, 13 Dec 2021 14:59:33 -0800 (PST)
Date:   Mon, 13 Dec 2021 22:59:12 +0000
In-Reply-To: <20211213225918.672507-1-dmatlack@google.com>
Message-Id: <20211213225918.672507-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20211213225918.672507-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.1.173.g76aa8bc2d0-goog
Subject: [PATCH v1 07/13] KVM: x86/mmu: Derive page role from parent
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Derive the page role from the parent shadow page, since the only thing
that changes is the level. This is in preparation for eagerly splitting
large pages during VM-ioctls which does not have access to the vCPU
MMU context.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 43 ++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2fb2d7677fbf..582d9a798899 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -157,23 +157,8 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
-						   int level)
-{
-	union kvm_mmu_page_role role;
-
-	role = vcpu->arch.mmu->mmu_role.base;
-	role.level = level;
-	role.direct = true;
-	role.has_4_byte_gpte = false;
-	role.access = ACC_ALL;
-	role.ad_disabled = !shadow_accessed_mask;
-
-	return role;
-}
-
 static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					       int level)
+					       union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
@@ -181,7 +166,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp->role.word = page_role_for_level(vcpu, level).word;
+	sp->role = role;
 	sp->gfn = gfn;
 	sp->tdp_mmu_page = true;
 
@@ -190,6 +175,19 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return sp;
 }
 
+static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
+{
+	struct kvm_mmu_page *parent_sp;
+	union kvm_mmu_page_role role;
+
+	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
+
+	role = parent_sp->role;
+	role.level--;
+
+	return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
+}
+
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 {
 	union kvm_mmu_page_role role;
@@ -198,7 +196,12 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = vcpu->arch.mmu->shadow_root_level;
+	role.direct = true;
+	role.has_4_byte_gpte = false;
+	role.access = ACC_ALL;
+	role.ad_disabled = !shadow_accessed_mask;
 
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
@@ -207,7 +210,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
+	root = alloc_tdp_mmu_page(vcpu, 0, role);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1033,7 +1036,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
+			sp = alloc_child_tdp_mmu_page(vcpu, &iter);
 			if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
 				tdp_mmu_free_sp(sp);
 				break;
-- 
2.34.1.173.g76aa8bc2d0-goog

