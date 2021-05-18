Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71528387E80
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 19:35:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351210AbhERRfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 13:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351202AbhERRfu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 13:35:50 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB17C06175F
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:31 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 140-20020a3704920000b02903a568b50545so2015143qke.7
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 10:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=QJBRdiNT50y6CWenT8iHGZ+jatWGFL5n8aWtdmK//io=;
        b=lq+642t/uIN+3l8/YXQdQ9VpERXKH/FAKZ1CnqHdfk7zw8dw3Om/dUBR3SYDjfA0mT
         QJCesbCHigRxleDQ6xFaX0f8i1b88osHnoE1mlgc2s0w52TJvgPWBKYI+8e4jTI6Y2qX
         +wtP+1qhfBMSNytwthMAph2umI4nVKkGrXdc68MF9/VO65PbcK6MNKkny34eWznp26UT
         QTCYBsEtNaHnjwN1WqqFqvd02QRAfoWgi4+mloYhH034hSwVVD/41SpDz82HfkxZUsTj
         LorhErhgAW9deu8ZqCeGImJ9Dfj7fz38r0u21ma5t80GpijY5/F6aHCochR+iWrr/g9D
         Ahjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=QJBRdiNT50y6CWenT8iHGZ+jatWGFL5n8aWtdmK//io=;
        b=jCWLGa17DoFULkViHTWtPiYy0WSLSO9X70xK1mU57qqoh3Jdy2b8jajtqcC/CPIN/8
         YqeHQU/r5JrHIOPXv5G61Mz70pIn/W4yv71IlsD5TcEaR5oH5nd1DJqMuERguWqUqWlS
         J4F44cK1z+SEIrgVjgIby+mcg915r9fpDWrLPRi4XtHgHIDkzePHY1K1dyfqnYtEBg2n
         CLDjDV5DPkwX2uLPm171/bZUTmTcZWXWcEYMmbJ1sC4PElJ4S4EnvRug982/0W3hZzEg
         Ss1G/TzPUniq9PO0MrOYODezQaUBmOX1QBArXgk81MrgJoNlAuphmP2IstRJRZmofKA+
         75SQ==
X-Gm-Message-State: AOAM530MrdNMmZ2c/aAHUhMdSRWS30z11rXTbTdyuO6ckh+9NnCYoW2A
        m/wLITy0MX+70CN72eJTaa+9+TG1GDBo
X-Google-Smtp-Source: ABdhPJxlZBvsJ7tEWJAysMi9ycSI3V6Lv90wDn44kMX/vfhOOjh0C8HqUirDFz7+ImKy1PFaGMwoGIO3Zt5C
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:2715:2de:868e:9db7])
 (user=bgardon job=sendgmr) by 2002:a0c:8e49:: with SMTP id
 w9mr6721541qvb.35.1621359271150; Tue, 18 May 2021 10:34:31 -0700 (PDT)
Date:   Tue, 18 May 2021 10:34:14 -0700
In-Reply-To: <20210518173414.450044-1-bgardon@google.com>
Message-Id: <20210518173414.450044-8-bgardon@google.com>
Mime-Version: 1.0
References: <20210518173414.450044-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH v5 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
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
        David Hildenbrand <david@redhat.com>,
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
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/mmu.h              |  7 ++++-
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++---
 arch/x86/kvm/mmu/tdp_mmu.c      |  6 +++--
 arch/x86/kvm/mmu/tdp_mmu.h      |  4 +--
 arch/x86/kvm/x86.c              | 46 +++++++++++++++++++++++++++++++++
 6 files changed, 71 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fc75ed49bfee..7b65f82ade1c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1868,4 +1868,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int kvm_cpu_dirty_log_size(void);
 
+int alloc_all_memslots_rmaps(struct kvm *kvm);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index af09c47b1aa2..e987c9af82b6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -234,7 +234,12 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
-	return kvm->arch.memslots_have_rmaps;
+	/*
+	 * Ensure that threads reading memslots_have_rmaps in various
+	 * lock contexts see the value before trying to dereference
+	 * the memslot rmap pointers.
+	 */
+	return smp_load_acquire(&kvm->arch.memslots_have_rmaps);
 }
 
 #endif
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e0daabc83ca..2ac7bec515a1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3294,6 +3294,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	r = alloc_all_memslots_rmaps(vcpu->kvm);
+	if (r)
+		return r;
+
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
 	if (r < 0)
@@ -5481,9 +5485,13 @@ void kvm_mmu_init_vm(struct kvm *kvm)
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
index 95eeb5ac6a8a..ea00c9502ba1 100644
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
index 7cbaa92687f7..28dc8bdd0c8a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10931,6 +10931,8 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 		int lpages = gfn_to_index(slot->base_gfn + npages - 1,
 					  slot->base_gfn, level) + 1;
 
+		WARN_ON(slot->arch.rmap[i]);
+
 		slot->arch.rmap[i] = kvcalloc(lpages, sz, GFP_KERNEL_ACCOUNT);
 		if (!slot->arch.rmap[i]) {
 			memslot_rmap_free(slot);
@@ -10941,6 +10943,50 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 	return 0;
 }
 
+int alloc_all_memslots_rmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	struct kvm_memory_slot *slot;
+	int r, i;
+
+	/*
+	 * Check if memslots alreday have rmaps early before acquiring
+	 * the slots_arch_lock below.
+	 */
+	if (kvm_memslots_have_rmaps(kvm))
+		return 0;
+
+	mutex_lock(&kvm->slots_arch_lock);
+
+	/*
+	 * Read memslots_have_rmaps again, under the slots arch lock,
+	 * before allocating the rmaps
+	 */
+	if (kvm_memslots_have_rmaps(kvm)) {
+		mutex_unlock(&kvm->slots_arch_lock);
+		return 0;
+	}
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot(slot, slots) {
+			r = memslot_rmap_alloc(slot, slot->npages);
+			if (r) {
+				mutex_unlock(&kvm->slots_arch_lock);
+				return r;
+			}
+		}
+	}
+
+	/*
+	 * Ensure that memslots_have_rmaps becomes true strictly after
+	 * all the rmap pointers are set.
+	 */
+	smp_store_release(&kvm->arch.memslots_have_rmaps, true);
+	mutex_unlock(&kvm->slots_arch_lock);
+	return 0;
+}
+
 static int kvm_alloc_memslot_metadata(struct kvm *kvm,
 				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
-- 
2.31.1.751.gd2f1c929bd-goog

