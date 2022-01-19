Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28124943A2
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344623AbiASXJU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344392AbiASXIL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:11 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3793DC061765
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:11 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id x1-20020a17090ab00100b001b380b8ed35so2733332pjq.7
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tWmcJzsgGR4GDuJlLqa8FcjNIzENtjsOvf5WT6cMtRs=;
        b=M/YtWqls5toIttXKec13oXAajJC3r+/s/9kvwFpjiwejO0bejmPMSRTi8yVoO0YtQb
         zzB7FN0BmHTgU6A/vfuE1740vudZVhmHY2KZN6u1a4QA4lJ4AK/2I7a8YUNjiqrbigKS
         K5tPJ9y4jVHCCzFG0dTdtC/Q61zQXeHvOfz2ZzvqyjW8xZY+5psdUseJV0vUsT1VMvDf
         xURIraF3gu2lrWLpBVEt26u79YCELHDNvqeGTJ+GEEMW2QxNsgzcBEPjrnYmXjexsuKw
         Yy1MfiNS8aTeKHV7jdB+7iuToWil0OYgT2mUWS/ffxMFbqFutbL58NjSTgcSMsm5/wPr
         0lrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tWmcJzsgGR4GDuJlLqa8FcjNIzENtjsOvf5WT6cMtRs=;
        b=badso3RQ8sm3ypZDGGI/NRkLBKZNTBJlbDqLHhkHCeOsg4SeLdAxDvxkCSCq8eKb73
         YVt6f2QUgDMQBL1liYvrw8QvbJPFyGFljhrjuwClgPZDh+988DbVYkxIDLD2hgY46bEa
         7ceFSaBqVGAdKIfGu1/4dfln2vnQktRclG4DZKmgmePLc5xOYv42Va46xBUdxIICCxO+
         /tsA9uEZAHXtYQbxeakUhk19XgvOUJMg8CUChBMg/BVgEtYFihLzYpll7BpCrWZshxBD
         IXKmC2jAd8NhzYsXyOuIWjP0PmJvV8e7RRE1HB8l32WQ6/dsk9G2GPglj/XvX+qX2r29
         +O0w==
X-Gm-Message-State: AOAM531q+ZYqS9ozi7MNvmmcKhhoGzvbvsWidfanpCHqEHPHi2++pg+Y
        sEf1Ansa3Kqq2g+XwkfoP/+dVc+YYsHQsg==
X-Google-Smtp-Source: ABdhPJwuryg9HLFTmojVb0lCgI5CQkHshRZipEPIKE0750i/cOILuTWKCWQd5aAt4KHZg67Aoxc2DEQ8ebinHQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:df15:: with SMTP id
 gp21mr7048329pjb.108.1642633690701; Wed, 19 Jan 2022 15:08:10 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:35 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-15-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 14/18] KVM: x86/mmu: Separate TDP MMU shadow page
 allocation and initialization
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

Separate the allocation of shadow pages from their initialization.  This
is in preparation for splitting huge pages outside of the vCPU fault
context, which requires a different allocation mechanism.

No functional changed intended.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5c1f1777e3d3..b526a1873f30 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -157,13 +157,19 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		if (kvm_mmu_page_as_id(_root) != _as_id) {		\
 		} else
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
-					     union kvm_mmu_page_role role)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu_page *sp;
 
 	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
 	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+
+	return sp;
+}
+
+static void tdp_mmu_init_sp(struct kvm_mmu_page *sp, gfn_t gfn,
+			      union kvm_mmu_page_role role)
+{
 	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
 
 	sp->role = role;
@@ -171,12 +177,10 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp(struct kvm_vcpu *vcpu, gfn_t gfn,
 	sp->tdp_mmu_page = true;
 
 	trace_kvm_mmu_get_page(sp, true);
-
-	return sp;
 }
 
-static struct kvm_mmu_page *tdp_mmu_alloc_child_sp(struct kvm_vcpu *vcpu,
-						   struct tdp_iter *iter)
+static void tdp_mmu_init_child_sp(struct kvm_mmu_page *child_sp,
+				  struct tdp_iter *iter)
 {
 	struct kvm_mmu_page *parent_sp;
 	union kvm_mmu_page_role role;
@@ -186,7 +190,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_child_sp(struct kvm_vcpu *vcpu,
 	role = parent_sp->role;
 	role.level--;
 
-	return tdp_mmu_alloc_sp(vcpu, iter->gfn, role);
+	tdp_mmu_init_sp(child_sp, iter->gfn, role);
 }
 
 hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
@@ -204,7 +208,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 			goto out;
 	}
 
-	root = tdp_mmu_alloc_sp(vcpu, 0, role);
+	root = tdp_mmu_alloc_sp(vcpu);
+	tdp_mmu_init_sp(root, 0, role);
+
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
@@ -1022,7 +1028,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			if (is_removed_spte(iter.old_spte))
 				break;
 
-			sp = tdp_mmu_alloc_child_sp(vcpu, &iter);
+			sp = tdp_mmu_alloc_sp(vcpu);
+			tdp_mmu_init_child_sp(sp, &iter);
+
 			if (tdp_mmu_link_sp_atomic(vcpu->kvm, &iter, sp, account_nx)) {
 				tdp_mmu_free_sp(sp);
 				break;
-- 
2.35.0.rc0.227.g00780c9af4-goog

