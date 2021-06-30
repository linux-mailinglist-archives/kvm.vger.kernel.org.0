Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4F43B8A34
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 23:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232511AbhF3Vuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 17:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbhF3Vux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 17:50:53 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727C7C0617A8
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:24 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id q9-20020a17090a0649b029016ffc6b9665so4644584pje.1
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=c7z8kdWFSIxQNMBObfdt2Re6PF35LU4DZgXWH2TIoqU=;
        b=iKiSbqHdGezXssdhrW4FVZ14QDpjn5Yt8UO5CX57jCLusCGMLMN9K0tQVjw4YoJ6AN
         1z32q0ZEFCLAWG1AQ2rWbj5mwzULKUbDtyyN1kSNWcO7Zx2hvGsWcnEbaec7tatEg+pA
         71mID9BVOFsA/8ag24Qbgbpv1iF+6lvsxAY/60u8iNSZZCD2qWKtwbyrXhsF7NEICqn9
         jai1cUYNwChfhHXTaY+DozTKe4M+M740W8MzLjx4GfJwCEYjq09eZjKpBrvJT8PFteZg
         clSzHZmD2p8ryNTLuAOmQgoavsl3Hq4zQl1gkkXQHrat5YeI9OUhj6e7TmgYciC5Riql
         NFVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=c7z8kdWFSIxQNMBObfdt2Re6PF35LU4DZgXWH2TIoqU=;
        b=HOfsGpCJExrHqGEsmh8WFsjRJr276u6ha9X0QE/lRhNHwprHGm9shCqBq3YcMiBAWy
         eMutKFaHxzFRyf9IZD09acOlylygkFi1Tv8X3+mFs/5XKHbfwB4eAlKrZs6ariCV1fbz
         6cpU8Ccq2RYUoY4+pPOjpbTiLj4sTV68ntbKz3hEnnc2CVccTnTQUErmItQtnEuBjh0s
         f4pYNliTmB+wiScLSteiQK5ZifPNnNk+zWkfyaUxE94xPZpF2V1G/1V6mWZ7j6RXDDjL
         /Cw6li62UcUa5L6p5dAvKZ0yLJZI3gOq2YLADDFC03wVo6wCs7dSNehtBO+IjBQb8T95
         HrqA==
X-Gm-Message-State: AOAM531vnipJkpWL20kIqFiGznPDr+d3RApq6TFhImM0Jp1tIgdSajCF
        TbMAuuqzr56Y2W4nXeczwdlCPIavgGNnom8Z2/9YEWFk+SKIl5DxnfeAMBSU/JMCfQnX+Lo2b8/
        9duz2b+9WjmcwssaU62Gw1MUFZ4RXpqVePUVcWF7pOlXJ4nHrp7TuFV80wj2SKCA=
X-Google-Smtp-Source: ABdhPJxgiUu0EL/PBbIT39F4ybj8K110+gsAkbpv2UB2yUYgBxb4BY3NTf5wamQkgYzedjTfQ+y/aKoz5ts7AA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:18e:b029:127:a5ba:7243 with SMTP
 id z14-20020a170903018eb0290127a5ba7243mr29683618plg.4.1625089703843; Wed, 30
 Jun 2021 14:48:23 -0700 (PDT)
Date:   Wed, 30 Jun 2021 21:47:59 +0000
In-Reply-To: <20210630214802.1902448-1-dmatlack@google.com>
Message-Id: <20210630214802.1902448-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 3/6] KVM: x86/mmu: Make walk_shadow_page_lockless_{begin,end}
 interoperate with the TDP MMU
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Acquire the RCU read lock in walk_shadow_page_lockless_begin and release
it in walk_shadow_page_lockless_end when the TDP MMU is enabled.  This
should not introduce any functional changes but is used in the following
commit to make fast_page_fault interoperate with the TDP MMU.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 24 ++++++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.c | 20 ++++++++++++++------
 arch/x86/kvm/mmu/tdp_mmu.h |  6 ++++--
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 45274436d3c0..88c71a8a55f1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -686,6 +686,11 @@ static bool mmu_spte_age(u64 *sptep)
 
 static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 {
+	if (is_tdp_mmu(vcpu->arch.mmu)) {
+		kvm_tdp_mmu_walk_lockless_begin();
+		return;
+	}
+
 	/*
 	 * Prevent page table teardown by making any free-er wait during
 	 * kvm_flush_remote_tlbs() IPI to all active vcpus.
@@ -701,6 +706,11 @@ static void walk_shadow_page_lockless_begin(struct kvm_vcpu *vcpu)
 
 static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 {
+	if (is_tdp_mmu(vcpu->arch.mmu)) {
+		kvm_tdp_mmu_walk_lockless_end();
+		return;
+	}
+
 	/*
 	 * Make sure the write to vcpu->mode is not reordered in front of
 	 * reads to sptes.  If it does, kvm_mmu_commit_zap_page() can see us
@@ -3621,6 +3631,12 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 
 	walk_shadow_page_lockless_begin(vcpu);
 
+	if (is_tdp_mmu(vcpu->arch.mmu)) {
+		leaf = kvm_tdp_mmu_get_walk_lockless(vcpu, addr, sptes,
+						     root_level);
+		goto out;
+	}
+
 	for (shadow_walk_init(&iterator, vcpu, addr),
 	     *root_level = iterator.level;
 	     shadow_walk_okay(&iterator);
@@ -3634,8 +3650,8 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 			break;
 	}
 
+out:
 	walk_shadow_page_lockless_end(vcpu);
-
 	return leaf;
 }
 
@@ -3647,11 +3663,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	int root, leaf, level;
 	bool reserved = false;
 
-	if (is_tdp_mmu(vcpu->arch.mmu))
-		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
-	else
-		leaf = get_walk(vcpu, addr, sptes, &root);
-
+	leaf = get_walk(vcpu, addr, sptes, &root);
 	if (unlikely(leaf < 0)) {
 		*sptep = 0ull;
 		return reserved;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index caac4ddb46df..c6fa8d00bf9f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1513,12 +1513,24 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	return spte_set;
 }
 
+void kvm_tdp_mmu_walk_lockless_begin(void)
+{
+	rcu_read_lock();
+}
+
+void kvm_tdp_mmu_walk_lockless_end(void)
+{
+	rcu_read_unlock();
+}
+
 /*
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
+ *
+ * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
+int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+				  int *root_level)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
@@ -1527,14 +1539,10 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	*root_level = vcpu->arch.mmu->shadow_root_level;
 
-	rcu_read_lock();
-
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
 
-	rcu_read_unlock();
-
 	return leaf;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 1cae4485b3bc..e9dde5f9c0ef 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -77,8 +77,10 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   int min_level);
 
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level);
+void kvm_tdp_mmu_walk_lockless_begin(void);
+void kvm_tdp_mmu_walk_lockless_end(void);
+int kvm_tdp_mmu_get_walk_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+				  int *root_level);
 
 #ifdef CONFIG_X86_64
 bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
-- 
2.32.0.93.g670b81a890-goog

