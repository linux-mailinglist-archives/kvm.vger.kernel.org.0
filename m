Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0174736F1E5
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 23:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237531AbhD2VT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 17:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbhD2VTz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Apr 2021 17:19:55 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6945FC06138D
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:19:07 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g29-20020a25b11d0000b02904f44adeb480so1067593ybj.13
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 14:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XVYnt8AGloz+IDwnCKZeO9D6UQw7DJweCpNStTZ2cAE=;
        b=Yoms/P21MbDMDoiBPrEogKqYS5Sb7aE+YqkWkyLuFIxSRheV6OeZOhbVarBcmxP8+L
         I6v8tWDNzyQ0z2FDbwyUXzBoCix0u9PM2JD0kgz70rKytm9obtsTu5nhSSjDgMlVWkwv
         4ZW5VcRGq0wAzd5aTfaUIRHpFpy8lHWaovtP5hhUbc/n9ukF1S9FRquLbP5ANIMG/crj
         0h4cGJeua+OWjKtSTfQSxRk27YKKnhwVO0j8FMJoMsU3jPQqiLcNQo/GOZYACiSXCOkk
         FrkIqDRzlkxEGeMMbSv2fxZmby3u8F/KtGNPcbZLvMsOFDZ/e2XssSjOTm58fQb9TUdd
         lGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XVYnt8AGloz+IDwnCKZeO9D6UQw7DJweCpNStTZ2cAE=;
        b=lNM6XKRzcSGMZPYG9HUKJYdo1OAHE5auev4tQFAw+oV7XOvmbKkNFp+8XZHJBo/46v
         CECK6PWoAmPSkW8FehtHFXbjtFd6s/LtM21IsDXgdF+cL+FEamrgK/2ucRokZDcdgQtM
         BDtFmyeiesDv2DhaLnROk2DapXiOyyoxgbm7ojBMRjMoYz48+zGm3ey+DRlGQKEUwDde
         CcS+pKNESAaWbzw6ldKkJX/j+ZWzYG1U+08WZ6woRulcZ/+Y5RtoBG+Cr//TfGXCe2ys
         VE9ULZSDQR+4+hr38Xv84eLIR6N9UDeKHcz6vVLJmUQeVTpneqRsjb+QOIOYe8var+cp
         6hTw==
X-Gm-Message-State: AOAM532vKYrHX1IXIl4UHgO63Cs0B9N9cVXiMGEPmb6VuJ1dnO7AJD8Y
        rijHBEEg9TvD77mgI4v6FX2oqJst36Vk
X-Google-Smtp-Source: ABdhPJwYDd2Kf5SXfPvdgeurHUBQKR0XZ8wIuevF5+PyOg8FgCJ5XUQKCZjH3vOch21gd0bVVopXKhLOd2lK
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:1a18:9719:a02:56fb])
 (user=bgardon job=sendgmr) by 2002:a25:3b0e:: with SMTP id
 i14mr2379500yba.12.1619731146539; Thu, 29 Apr 2021 14:19:06 -0700 (PDT)
Date:   Thu, 29 Apr 2021 14:18:33 -0700
In-Reply-To: <20210429211833.3361994-1-bgardon@google.com>
Message-Id: <20210429211833.3361994-8-bgardon@google.com>
Mime-Version: 1.0
References: <20210429211833.3361994-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2 7/7] KVM: x86/mmu: Lazily allocate memslot rmaps
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
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
 arch/x86/include/asm/kvm_host.h | 11 +++++++
 arch/x86/kvm/mmu/mmu.c          | 21 +++++++++++--
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/x86.c              | 54 ++++++++++++++++++++++++++++++---
 4 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3900dcf2439e..b8633ed00a6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1124,6 +1124,15 @@ struct kvm_arch {
 #endif /* CONFIG_X86_64 */
 
 	bool shadow_mmu_active;
+
+	/*
+	 * If set, the rmap should be allocated for any newly created or
+	 * modified memslots. If allocating rmaps lazily, this may be set
+	 * before the rmaps are allocated for existing memslots, but
+	 * shadow_mmu_active will not be set until after the rmaps are fully
+	 * allocated.
+	 */
+	bool alloc_memslot_rmaps;
 };
 
 struct kvm_vm_stat {
@@ -1855,4 +1864,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int kvm_cpu_dirty_log_size(void);
 
+int alloc_all_memslots_rmaps(struct kvm *kvm);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e252af46f205..b2a6585bd978 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3125,9 +3125,17 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return ret;
 }
 
-void activate_shadow_mmu(struct kvm *kvm)
+int activate_shadow_mmu(struct kvm *kvm)
 {
+	int r;
+
+	r = alloc_all_memslots_rmaps(kvm);
+	if (r)
+		return r;
+
 	kvm->arch.shadow_mmu_active = true;
+
+	return 0;
 }
 
 static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
@@ -3300,7 +3308,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		}
 	}
 
-	activate_shadow_mmu(vcpu->kvm);
+	r = activate_shadow_mmu(vcpu->kvm);
+	if (r)
+		return r;
 
 	write_lock(&vcpu->kvm->mmu_lock);
 	r = make_mmu_pages_available(vcpu);
@@ -5491,7 +5501,12 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
 
 	if (!kvm_mmu_init_tdp_mmu(kvm))
-		activate_shadow_mmu(kvm);
+		/*
+		 * No memslots can have been allocated at this point.
+		 * activate_shadow_mmu won't actually need to allocate
+		 * rmaps, so it cannot fail.
+		 */
+		WARN_ON(activate_shadow_mmu(kvm));
 
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 297a911c018c..c6b21a916452 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -165,6 +165,6 @@ void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
-void activate_shadow_mmu(struct kvm *kvm);
+int activate_shadow_mmu(struct kvm *kvm);
 
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc32a7dbe4c4..c72b35cbaef7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10842,11 +10842,24 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
-static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
+static int alloc_memslot_rmap(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      unsigned long npages)
 {
 	int i;
 
+	if (!kvm->arch.alloc_memslot_rmaps)
+		return 0;
+
+	/*
+	 * All rmaps for a memslot should be allocated either before
+	 * the memslot is installed (in which case no other threads
+	 * should have a pointer to it), or under the
+	 * slots_arch_lock. Avoid overwriting already allocated
+	 * rmaps.
+	 */
+	if (slot->arch.rmap[0])
+		return 0;
+
 	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
 		int lpages;
 		int level = i + 1;
@@ -10868,7 +10881,40 @@ static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
 	return -ENOMEM;
 }
 
-static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
+int alloc_memslots_rmaps(struct kvm *kvm, struct kvm_memslots *slots)
+{
+	struct kvm_memory_slot *slot;
+	int r = 0;
+
+	kvm_for_each_memslot(slot, slots) {
+		r = alloc_memslot_rmap(kvm, slot, slot->npages);
+		if (r)
+			break;
+	}
+	return r;
+}
+
+int alloc_all_memslots_rmaps(struct kvm *kvm)
+{
+	struct kvm_memslots *slots;
+	int r = 0;
+	int i;
+
+	mutex_lock(&kvm->slots_arch_lock);
+	kvm->arch.alloc_memslot_rmaps = true;
+
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		slots = __kvm_memslots(kvm, i);
+		r = alloc_memslots_rmaps(kvm, slots);
+		if (r)
+			break;
+	}
+	mutex_unlock(&kvm->slots_arch_lock);
+	return r;
+}
+
+static int kvm_alloc_memslot_metadata(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
@@ -10881,7 +10927,7 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	r = alloc_memslot_rmap(slot, npages);
+	r = alloc_memslot_rmap(kvm, slot, npages);
 	if (r)
 		return r;
 
@@ -10954,7 +11000,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(memslot,
+		return kvm_alloc_memslot_metadata(kvm, memslot,
 						  mem->memory_size >> PAGE_SHIFT);
 	return 0;
 }
-- 
2.31.1.527.g47e6f16901-goog

