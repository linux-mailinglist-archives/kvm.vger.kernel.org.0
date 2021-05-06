Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A375375A5B
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236453AbhEFSom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbhEFSoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:44:23 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4E5C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:43:23 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id b1-20020a0c9b010000b02901c4bcfbaa53so4836656qve.19
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K/x5z5bZjszhScOsSUvYig/rlmtrsL2ZrnZOND+61kE=;
        b=LUC4WOb6mauhV5uFzsrXpaReIKKRZrn4AoIkNHikJ5LaaU4mVWIpGlAa95eSlp313V
         CYiLL2JHFDEQxNcWb5LxNu/RM++wYeQhCOos4qUwt2JCcKeV131gknJ+qCBabvIWM/ek
         SbgOsdvEotdJ/Rmea6GljXnmeAbG1J07HZo/SzHspNM2b9iBx8K2ffenZNFWSBaGFFl3
         jph7tFMnI06LokeGXCTzelOpyYp1gbTzfuPQ5igkRagT2cOs7lgniCnFFSsShcaM5LwL
         /WvzreBptU9Nx17RYv9DpApkg0JwOprezc4WN1Y2z6nh0Mcv7SLrwJhSWi8LbgnbfKk3
         uLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K/x5z5bZjszhScOsSUvYig/rlmtrsL2ZrnZOND+61kE=;
        b=DD044KcHKNJjleWNpRaeztf8oQQ/VE7aWtMtprZ0atl5+qxOVTN/S9QpFVJQaa6noR
         4y8S12qqRMvqn9tD0PNnx/+0OmCiOvA3ktBS4PStpKko7MSrIwpI02PpyfOJ6J0b7izz
         12x8tLoUmAU7VfkeNtOqTCDpqxNuvatBU8TAQkxqI8dCz0EExiKsOx/FqAZOSGB+j0iN
         TSLra/4ZiiCW13KxGeKCgSNeajfP5KiCZoEGVqXa+H5XDeOqVTd4yzUaXKWekTeu9Mz2
         N3jc9TEqdD8VB6hcu97TSO0+xRBgpJDIwZ5MAsIpNoMxHZr08bG/SlckrqPLYsYBgHGz
         2DNg==
X-Gm-Message-State: AOAM530IVqV9Jposr7QyTCbBWZ0GCpVQQ/nQBouLkggrRSb2qFiM8yFT
        jIG+bXEOAa6RPtlQ7NSeJr6bxwKvBdHX
X-Google-Smtp-Source: ABdhPJy/HwoTP0gK5bHmoUE0N8nTQYyJkQguHvxLj+bAE0kbE8QnN/AET23D4SxE+skS2wnCdCb688CvgShr
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9258:9474:54ca:4500])
 (user=bgardon job=sendgmr) by 2002:ad4:4634:: with SMTP id
 x20mr6230195qvv.49.1620326602821; Thu, 06 May 2021 11:43:22 -0700 (PDT)
Date:   Thu,  6 May 2021 11:42:41 -0700
In-Reply-To: <20210506184241.618958-1-bgardon@google.com>
Message-Id: <20210506184241.618958-9-bgardon@google.com>
Mime-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 8/8] KVM: x86/mmu: Lazily allocate memslot rmaps
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the TDP MMU is in use, wait to allocate the rmaps until the shadow
MMU is actually used. (i.e. a nested VM is launched.) This saves memory
equal to 0.2% of guest memory in cases where the TDP MMU is used and
there are no nested guests involved.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 14 ++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 ++++--
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 ++--
 arch/x86/kvm/x86.c              | 37 ++++++++++++++++++++++++++++++++-
 5 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 00065f9bbc5e..7b8e1532fb55 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1860,5 +1860,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 int kvm_cpu_dirty_log_size(void);
 
 inline bool kvm_memslots_have_rmaps(struct kvm *kvm);
+int alloc_all_memslots_rmaps(struct kvm *kvm);
 
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 48067c572c02..e3a3b65829c5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3306,6 +3306,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	r = alloc_all_memslots_rmaps(vcpu->kvm);
+	if (r)
+		return r;
+
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
 	if (r < 0)
@@ -5494,9 +5498,13 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
-	kvm_mmu_init_tdp_mmu(kvm);
-
-	kvm->arch.memslots_have_rmaps = true;
+	if (!kvm_mmu_init_tdp_mmu(kvm))
+		/*
+		 * No smp_load/store wrappers needed here as we are in
+		 * VM init and there cannot be any memslots / other threads
+		 * accessing this struct kvm yet.
+		 */
+		kvm->arch.memslots_have_rmaps = true;
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 83cbdbe5de5a..5342aca2c8e0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -14,10 +14,10 @@ static bool __read_mostly tdp_mmu_enabled = false;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
 
 /* Initializes the TDP MMU for the VM, if enabled. */
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
+bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
-		return;
+		return false;
 
 	/* This should not be changed for the lifetime of the VM. */
 	kvm->arch.tdp_mmu_enabled = true;
@@ -25,6 +25,8 @@ void kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
+
+	return true;
 }
 
 static __always_inline void kvm_lockdep_assert_mmu_lock_held(struct kvm *kvm,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5fdf63090451..b046ab5137a1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -80,12 +80,12 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level);
 
 #ifdef CONFIG_X86_64
-void kvm_mmu_init_tdp_mmu(struct kvm *kvm);
+bool kvm_mmu_init_tdp_mmu(struct kvm *kvm);
 void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm);
 static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return kvm->arch.tdp_mmu_enabled; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return sp->tdp_mmu_page; }
 #else
-static inline void kvm_mmu_init_tdp_mmu(struct kvm *kvm) {}
+static inline bool kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return false; }
 static inline void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm) {}
 static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1098ab73a704..95e74fb9fc20 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10868,9 +10868,44 @@ static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
 	return -ENOMEM;
 }
 
+int alloc_all_memslots_rmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	int r = 0;
+	int i;
+
+	if (kvm_memslots_have_rmaps(kvm))
+		return 0;
+
+	mutex_lock(&kvm->slots_arch_lock);
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			r = alloc_memslot_rmap(slot, slot->npages);
+			if (r) {
+				mutex_unlock(&kvm->slots_arch_lock);
+				return r;
+			}
+		}
+	}
+
+	/*
+	 * memslots_have_rmaps is set and read in different lock contexts,
+	 * so protect it with smp_load/store.
+	 */
+	smp_store_release(&kvm->arch.memslots_have_rmaps, true);
+	mutex_unlock(&kvm->slots_arch_lock);
+	return 0;
+}
+
 bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
-	return kvm->arch.memslots_have_rmaps;
+	/*
+	 * memslots_have_rmaps is set and read in different lock contexts,
+	 * so protect it with smp_load/store.
+	 */
+	return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
 }
 
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,
-- 
2.31.1.607.g51e8a6a459-goog

