Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F3D4579CF
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhKTABu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236232AbhKTABW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:22 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5D6C061748
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:20 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id n13-20020a170902d2cd00b0014228ffc40dso5361561plc.4
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wkh89fBmd980/DQWmtPUYCadBdan6p83cu7YV29qV8k=;
        b=ldY/d0mXvBJvYMeDK9yCu4ktNBNtCrtdEfhdwO9kKn2UaQOwPlTeNKIPzENhdWDDaV
         XJMXzeLRc3dO+wT7e5bXMZmayNYt23r/Ogdip4meQ9vPQQNcW/VNp07LGN7VUJJwyR8g
         ofWeE4b3IIp451A6W10yKqZ4rDxjfJGVSloYlu/prw86q7L/tlDBN5+VR+8owR5VkEWB
         BpC9QOPuNqIWz79X7ztv0Z28B9aeSN02nr8YoQoQRjRqI/VPw5a5gmaH87wSuisUZn5m
         hVw2Lrqf9O0UYuIwkdIEVaOnOOsQ9vjt4m3mFfogdpP2iUC3V4LUjYFz+SGdq20QUj5x
         QeVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wkh89fBmd980/DQWmtPUYCadBdan6p83cu7YV29qV8k=;
        b=nKlFhoxzPl7Xt6m/PkowL+4QyCa+ocQ0ZNa9urYrSfI2QLveXJnyWHd3iYPm9lV4dD
         RJggaNiBSwvJHLPt7MVkJYnyM720YoHRw8sM1J93Xyw/CBFLUCmIZbAgXyFDqXqloLuv
         tr9lpG/0jauyJQANjNV6BAe8oCffGLQ3a2imRBfyMZBsDdyTzppMS4LvA8p7OhxIuLEI
         aq7wY26BHLdI0EHeJ4+BC4ahHvX1AQv2kMiTRYyVNWRRD32TAkOT9RxalKhJcdNLwyOV
         fGt5aFTpuD9LbYCujnU2cBiAMzx6Sn/0pmC9WE8EaAGll6OX9abUuY5UylIz0cbLmCgD
         JaHg==
X-Gm-Message-State: AOAM531PiTqhmezc87D1mBsPZDIaX7fFt0lkExCPEZg4El6LmTWeDC2J
        9yRQKcFtZ+n2RE+n00Ycp7CfWB/Fh9Ic9w==
X-Google-Smtp-Source: ABdhPJxAiDhSmMRQvNP4bwzJil10537qF0v5lVx1zfQp6exZ6z/iBFJmLyKBgLkVV9W6GLU1kmcYWRkSF8Jxrw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:aa7:8b14:0:b0:4a3:a714:30ed with SMTP id
 f20-20020aa78b14000000b004a3a71430edmr10453181pfd.2.1637366299898; Fri, 19
 Nov 2021 15:58:19 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:50 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-7-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 06/15] KVM: x86/mmu: Derive page role from parent
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
index b70707a7fe87..1a409992a57f 100644
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
-	role.gpte_is_8_bytes = true;
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
 	struct kvm_mmu_memory_caches *mmu_caches;
 	struct kvm_mmu_page *sp;
@@ -184,7 +169,7 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
-	sp->role.word = page_role_for_level(vcpu, level).word;
+	sp->role = role;
 	sp->gfn = gfn;
 	sp->tdp_mmu_page = true;
 
@@ -193,6 +178,19 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
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
@@ -201,7 +199,12 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
-	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
+	role = vcpu->arch.mmu->mmu_role.base;
+	role.level = vcpu->arch.mmu->shadow_root_level;
+	role.direct = true;
+	role.gpte_is_8_bytes = true;
+	role.access = ACC_ALL;
+	role.ad_disabled = !shadow_accessed_mask;
 
 	/* Check for an existing root before allocating a new one. */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
@@ -210,7 +213,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = alloc_tdp_mmu_page(vcpu, 0, vcpu->arch.mmu->shadow_root_level);
+	root = alloc_tdp_mmu_page(vcpu, 0, role);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1028,7 +1031,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = alloc_tdp_mmu_page(vcpu, iter.gfn, iter.level - 1);
+			sp = alloc_child_tdp_mmu_page(vcpu, &iter);
 			if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
 				break;
 		}
-- 
2.34.0.rc2.393.gf8c9666880-goog

