Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE824943A4
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357821AbiASXJW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344386AbiASXIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:10 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05FCC061763
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:09 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x15-20020a17090a46cf00b001b35ee9643fso4813434pjg.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=X1xFe3lwJlWFwZpWylh7a3VDSNBVAiA26u7lyQbChJo=;
        b=jvbMEkwSZeTEeOuV8CErttwAOXO/5jJ+6kmeUkwv5T6uXogwK+f8N3gzw/Y39GDvvx
         25xcS4aE47u831G5Wj/4As4ThZm8Bxo621Tauxy3YIb/SyDahoyiOSLuCYeoyvEi33re
         D4d0gk0FWofQIf3gvYpzcfKvUTzkmPpuRHkVJdRFle2JZFrA6e1ZfTYDKZ5aXk+DSkSW
         9bEX11C1mEFVxhfm3b4D9LawSWjOtuzLoIdoMpkhv+5ezNnMua8zyHITVfg+Li77yPv+
         oOp9YBREo31SHznl2kb9mqapq1wrMqDPX9H29+DMt1UN5uHzrIIyNNuTOL+yYSxOgwrl
         iLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=X1xFe3lwJlWFwZpWylh7a3VDSNBVAiA26u7lyQbChJo=;
        b=Uak00pNRf7aqOMSloeo9w0VzEXFd0QHQN/qh2cwUdMVvpgBiUZ1tj4qQCmWfj2wcXg
         DEKZG+4I/I/qxBd+dHI6MVAdaB/xoNTM/VgaGJanzLLTmAy2is53r7C19/nEAVtngrwz
         aX7l0jeWSeniVvG8L00LdoFIr1kv57SDn18USM6OAji6tLlU9SUMrwK5Gf/7daohSTqz
         YsW9MD7zoWInBicRKAq0COFomYqEWhKRA7x2Jvzo272JJVBW4IdQZs4dbSWTEQ4py9g2
         FBTyKiEsjKTH8P/1YviR+/inHjPxFfejgg6EuVWyMpZ1bbcgTr59KiDkjWZVxrsiPou0
         H9yQ==
X-Gm-Message-State: AOAM531vIspx33yAtd1mzMPT6b56jICc1RTKyQnSQxjQUSLAs4HEXeh6
        T3GYDSD4rYJOznqiUhGjNVXBY3ddJULYrg==
X-Google-Smtp-Source: ABdhPJyX6n0W7sUsc+jwt5qL6W/yPKs9MZ4mL8ia3N/Lf9fTpfrmzHuUPi404CV+PVsVThypgnx+/6fleGODbQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8b95:: with SMTP id
 z21mr7060563pjn.29.1642633689344; Wed, 19 Jan 2022 15:08:09 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:34 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-14-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 13/18] KVM: x86/mmu: Derive page role for TDP MMU shadow
 pages from parent
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
that changes is the level. This is in preparation for splitting huge
pages during VM-ioctls which do not have access to the vCPU MMU context.

No functional change intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 90b6fbec83cc..5c1f1777e3d3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -157,19 +157,8 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
-						   int level)
-{
-	union kvm_mmu_page_role role;
-
-	role = vcpu->arch.mmu->mmu_role.base;
-	role.level = level;
-
-	return role;
-}
-
 static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     int level)
+					     union kvm_mmu_page_role role)
 {
 	struct kvm_mmu_page *sp;
 
@@ -177,7 +166,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp->role.word = page_role_for_level(vcpu, level).word;
+	sp->role = role;
 	sp->gfn = gfn;
 	sp->tdp_mmu_page = true;
 
@@ -186,16 +175,28 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return sp;
 }
 
-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+static struct kvm_mmu_page *tdp_mmu_alloc_child_sp(struct kvm_vcpu *vcpu,
+						   struct tdp_iter *iter)
 {
+	struct kvm_mmu_page *parent_sp;
 	union kvm_mmu_page_role role;
+
+	parent_sp = sptep_to_sp(rcu_dereference(iter->sptep));
+
+	role = parent_sp->role;
+	role.level--;
+
+	return tdp_mmu_alloc_sp(vcpu, iter->gfn, role);
+}
+
+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
+{
+	union kvm_mmu_page_role role = vcpu->arch.mmu->mmu_role.base;
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
-
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
@@ -203,7 +204,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = tdp_mmu_alloc_sp(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
+	root = tdp_mmu_alloc_sp(vcpu, 0, role);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1021,7 +1022,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = tdp_mmu_alloc_sp(vcpu, iter.gfn, iter.level - 1);
+			sp = tdp_mmu_alloc_child_sp(vcpu, &iter);
 			if (tdp_mmu_link_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
 				tdp_mmu_free_sp(sp);
 				break;
-- 
2.35.0.rc0.227.g00780c9af4-goog

