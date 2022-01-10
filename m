Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E83B48A160
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 22:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343753AbiAJVFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jan 2022 16:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239741AbiAJVFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jan 2022 16:05:03 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AA6C06173F
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:05:02 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id a4-20020a17090a70c400b001b21d9c8bc8so362506pjm.7
        for <kvm@vger.kernel.org>; Mon, 10 Jan 2022 13:05:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tvWQrk5m+auOAW75En/9PBKMdEwVtYbyEoey6RrsQGY=;
        b=e5wvyEvF+6FHTqteWzNNKatxYnJ4VRlsfWm24dqvR6gh/YchZ8gn84JRPhHUb4l2TC
         a/zNUCJkZ4csmy+GqoZjvNoUj4m4oA3lpGHhSsmc9hXQt/1ZLfi4sS8GkEcGugkuWjcL
         Jwddo2N9Pam5r0DUjpQfgFV8cqesubSvju8AQut6DA5nPGQEZNSdYPqhtxbIsYY6tYJa
         TEG26xC6/S+/MM2dQQfBXHJD2GiW3MDF4b7xHvPOlZhFc3v1Mw3m8rXCRcxtvLH0hFFp
         LCSBqQhBbFIKfU9BOWZWcQu/L/lzZUjOw6+P0uiv4rGAd1JpNJ5JOBpHXFaTllRe9sN4
         AyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tvWQrk5m+auOAW75En/9PBKMdEwVtYbyEoey6RrsQGY=;
        b=2ckBpf/EzO6elE01JffoqQCvsNB5X9np1VoMAtncFngcyrAXlagREKQqZWgLPh2YGg
         nIvUMh2IDTkuRoHbeBPKyQQoq9Ho7K31c4Xi/n7D+B12u3USiYkWzIuTUoxq5yjkdFUJ
         TX75PdGOBUzFAIWYgd7yIHX1JCCQDZlEDnD7JAECZFEULeWPvA+AHn0tKiZKGYkM0YMd
         WiZfYclNSB9Se6FjwpuQKkkZSsTEv8JyKsE2N9wHICsXWEELNXp0jc6wjnbc8eIPtuNe
         E5t1CQlc3MzIHds/3buKkQYndndaZBba+2HRSvgNblAgNlEjYuqR850GfpZwELfS1wbr
         6+1w==
X-Gm-Message-State: AOAM532m0ebkfB9slEkqg/7cICdCQYcHzaKbUZbEY5Hw38R3iYW81DdR
        zI4ceAYq+/cyGUqBFv3AuvqmEmJ+63AtWtSj+uwOHn7ZYsHrZxk56dOIhLsUo3p0Ch/QFd3MfVm
        4C8/OqVHVmBTcbLBBoxwPISwq0BLhJyXnLeRQwXoQR7RaVeCQh8RcfyhcIE+1zLGEJSW5UbQ=
X-Google-Smtp-Source: ABdhPJzKNuD1sJM5lGJUPo9JWpQ9TX/uS6nn/vrAZPHCas8+Luj+bHqUKHRmoSvs4znM+7FiR3Lwl9FKVzdJYJZqtw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a63:a706:: with SMTP id
 d6mr1340856pgf.390.1641848702323; Mon, 10 Jan 2022 13:05:02 -0800 (PST)
Date:   Mon, 10 Jan 2022 21:04:39 +0000
In-Reply-To: <20220110210441.2074798-1-jingzhangos@google.com>
Message-Id: <20220110210441.2074798-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220110210441.2074798-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [RFC PATCH 1/3] KVM: arm64: Use read/write spin lock for MMU protection
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To reduce the contentions caused by MMU lock, some MMU operations can
be performed under read lock.
One improvement is to add a fast path for permission relaxation during
dirty logging under the read lock.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/mmu.c              | 36 +++++++++++++++----------------
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 3b44ea17af88..6c99c0335bae 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -50,6 +50,8 @@
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
 
+#define KVM_HAVE_MMU_RWLOCK
+
 /*
  * Mode of operation configurable with kvm-arm.mode early param.
  * See Documentation/admin-guide/kernel-parameters.txt for more information.
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index bc2aba953299..cafd5813c949 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -58,7 +58,7 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
 			break;
 
 		if (resched && next != end)
-			cond_resched_lock(&kvm->mmu_lock);
+			cond_resched_rwlock_write(&kvm->mmu_lock);
 	} while (addr = next, addr != end);
 
 	return ret;
@@ -179,7 +179,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	phys_addr_t end = start + size;
 
-	assert_spin_locked(&kvm->mmu_lock);
+	lockdep_assert_held_write(&kvm->mmu_lock);
 	WARN_ON(size & ~PAGE_MASK);
 	WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
 				   may_block));
@@ -213,13 +213,13 @@ static void stage2_flush_vm(struct kvm *kvm)
 	int idx, bkt;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_flush_memslot(kvm, memslot);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -720,13 +720,13 @@ void stage2_unmap_vm(struct kvm *kvm)
 
 	idx = srcu_read_lock(&kvm->srcu);
 	mmap_read_lock(current->mm);
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 
 	slots = kvm_memslots(kvm);
 	kvm_for_each_memslot(memslot, bkt, slots)
 		stage2_unmap_memslot(kvm, memslot);
 
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	mmap_read_unlock(current->mm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
@@ -736,14 +736,14 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
 	if (pgt) {
 		mmu->pgd_phys = 0;
 		mmu->pgt = NULL;
 		free_percpu(mmu->last_vcpu_ran);
 	}
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
 		kvm_pgtable_stage2_destroy(pgt);
@@ -783,10 +783,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 		if (ret)
 			break;
 
-		spin_lock(&kvm->mmu_lock);
+		write_lock(&kvm->mmu_lock);
 		ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
 					     &cache);
-		spin_unlock(&kvm->mmu_lock);
+		write_unlock(&kvm->mmu_lock);
 		if (ret)
 			break;
 
@@ -834,9 +834,9 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
 	start = memslot->base_gfn << PAGE_SHIFT;
 	end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	stage2_wp_range(&kvm->arch.mmu, start, end);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	kvm_flush_remote_tlbs(kvm);
 }
 
@@ -1212,7 +1212,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && device)
 		return -ENOEXEC;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	pgt = vcpu->arch.hw_mmu->pgt;
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1271,7 +1271,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 out_unlock:
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 	kvm_set_pfn_accessed(pfn);
 	kvm_release_pfn_clean(pfn);
 	return ret != -EAGAIN ? ret : 0;
@@ -1286,10 +1286,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
 
 	trace_kvm_access_fault(fault_ipa);
 
-	spin_lock(&vcpu->kvm->mmu_lock);
+	write_lock(&vcpu->kvm->mmu_lock);
 	mmu = vcpu->arch.hw_mmu;
 	kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
-	spin_unlock(&vcpu->kvm->mmu_lock);
+	write_unlock(&vcpu->kvm->mmu_lock);
 
 	pte = __pte(kpte);
 	if (pte_valid(pte))
@@ -1692,9 +1692,9 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 	gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
 	phys_addr_t size = slot->npages << PAGE_SHIFT;
 
-	spin_lock(&kvm->mmu_lock);
+	write_lock(&kvm->mmu_lock);
 	unmap_stage2_range(&kvm->arch.mmu, gpa, size);
-	spin_unlock(&kvm->mmu_lock);
+	write_unlock(&kvm->mmu_lock);
 }
 
 /*
-- 
2.34.1.575.g55b058a8bb-goog

