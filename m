Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804E94579D0
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbhKTABw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbhKTABY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:24 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C07C06174A
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:22 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id x18-20020a170902ec9200b00143c6409dbcso5371500plg.5
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=THyCGcJlJDIteh93mmk5MXegs42Ad6o+RQjSwoy4UKE=;
        b=HzfOzdGrIvRs5CF2OA0gibAVw6lsOEdz4I9Y3lvNVhRphfkOGsmN2IdLnrQOgDe7Wd
         gUAcFcFlNnBVY9rG1gXm9D0WUfqtNbo2+vhixc3srxN+Sw81tuSyHPFqSmsB+i8tscLn
         SbOrfwigCEi+pCyreDY377FZMcYVvZl1RD88P2bv9p8JWHBXs2j43mlJIjVDFfLX6Qi/
         1IxX7BsjaFXchGBtICPLuxxPFB9xDf6KBMSyk+sEyidXAsW+O7IIMw/Er4vbM1Ek6h2r
         1UR2R80rT0W1hmP3Urp+8M1HRoNKPg6X6VbqSjSgmMYkfEcW8HSC8riD9Szou81VLxuX
         xMuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=THyCGcJlJDIteh93mmk5MXegs42Ad6o+RQjSwoy4UKE=;
        b=pCtUPkkcccQJ6rf6cxabO6iU5aEl3k9yw96ykCEiV5Yqfc+QV06iEjiBNt9R0Uubmw
         gZGjO51J1ZjLL2Y245QXx+DaFonXzrqsPn+XQprgZBUWCGRQh5D20T9MThjnToHRjM3V
         feQ/LU6qunnOrkb3CNJBYN8fXl+oRtjoP/ijbSNv2e1+ItXNiEnBoaSKjYL+DrpdfYtE
         lNoXpzPo3mI/GrUnkESivY0RIVCE8SCc3uBbbTDpGKcy/eaULvRS0LcJFZQMhsYO7dTB
         fqcnGcd1m47fj9GSCUNxZB0qktROEYMF+8P5YOasc/uMA36VzlVi2+EmAClVqeXAALeg
         KAcA==
X-Gm-Message-State: AOAM5311/SQRv/tZAuJJWoByVK4VtLCHwQZhJjZb0tsRubsx9MWcENtH
        P+UFB1hA6yLkF19xLk1kEwHMxKRSd2BwOg==
X-Google-Smtp-Source: ABdhPJxt7MI51GZajwUnfC3GYlRa9MHQ8weuL4DIzGepaXz2g9XCcaSYQOuxMHK8ExOZQp1keUHWHsbpgXa43w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:f68e:b0:142:c60:475 with SMTP id
 l14-20020a170902f68e00b001420c600475mr83161881plg.8.1637366301600; Fri, 19
 Nov 2021 15:58:21 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:51 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-8-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 07/15] KVM: x86/mmu: Pass in vcpu->arch.mmu_caches instead
 of vcpu
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

Pass in vcpu->arch.mmu_caches to alloc_{,_child}_tdp_mmu_page() instead
of the vcpu. This is in preparation for eagerly splitting large pages
during VM-ioctls which does not have access to the vCPU mmu_caches.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1a409992a57f..ff4d83ad7580 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -157,14 +157,11 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
-					       union kvm_mmu_page_role role)
+static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_mmu_memory_caches *mmu_caches,
+					       gfn_t gfn, union kvm_mmu_page_role role)
 {
-	struct kvm_mmu_memory_caches *mmu_caches;
 	struct kvm_mmu_page *sp;
 
-	mmu_caches = &vcpu->arch.mmu_caches;
-
 	sp = kvm_mmu_memory_cache_alloc(&mmu_caches->page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&mmu_caches->shadow_page_cache);
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
@@ -178,7 +175,8 @@ static struct kvm_mmu_page *alloc_tdp_mmu_page(struct kvm_vcpu *vcpu, gfn_t gfn,
 	return sp;
 }
 
-static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, struct tdp_iter *iter)
+static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_mmu_memory_caches *mmu_caches,
+						     struct tdp_iter *iter)
 {
 	struct kvm_mmu_page *parent_sp;
 	union kvm_mmu_page_role role;
@@ -188,7 +186,7 @@ static struct kvm_mmu_page *alloc_child_tdp_mmu_page(struct kvm_vcpu *vcpu, stru
 	role = parent_sp->role;
 	role.level--;
 
-	return alloc_tdp_mmu_page(vcpu, iter->gfn, role);
+	return alloc_tdp_mmu_page(mmu_caches, iter->gfn, role);
 }
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
@@ -213,7 +211,7 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = alloc_tdp_mmu_page(vcpu, 0, role);
+	root = alloc_tdp_mmu_page(&vcpu->arch.mmu_caches, 0, role);
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1031,7 +1029,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = alloc_child_tdp_mmu_page(vcpu, &iter);
+			sp = alloc_child_tdp_mmu_page(&vcpu->arch.mmu_caches, &iter);
 			if (!tdp_mmu_install_sp_atomic(vcpu->kvm, &iter, sp, account_nx))
 				break;
 		}
-- 
2.34.0.rc2.393.gf8c9666880-goog

