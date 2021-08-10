Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DB03E862A
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 00:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhHJWqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 18:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235169AbhHJWqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 18:46:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01D3C061765
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:46:00 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id v130-20020a25c5880000b0290593c8c353ffso434182ybe.7
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 15:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=c+Hc+xUCIMHUyz3THenyNaBQHUNW/1M+dybXqnv58Y8=;
        b=PVHTmWAf+7jISewEtfkTYuAFOFWvoZ1b3kPifjFnv8jVSOnXNG5MLaGZB4gwKW99Db
         EQfz3mDB0CrcJUT/uje15uMWouY9Drb3iuGDJKuOr3wtSOG89jc+FLZS2/3lkExYkDbI
         BApAAGKUe3CLt7mLoaoFWFpIPQ9kV3WnomIFS9woRgKtgTk9ocwapRHLy72cpwEGwYM2
         cbQr5coko72PadfijBMJZ4Q87muKBIH5mhhPozs73FxmfQEIrGhJKAsnwYSkFLqow4Z6
         gnEqsp57PSA+s4SQ9gg3xe+Y20UOyEy5kiDMu+TGXFDhZ032DjsrsQMAoONwadLXs6Va
         IThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=c+Hc+xUCIMHUyz3THenyNaBQHUNW/1M+dybXqnv58Y8=;
        b=V1qW3S0XkL/lITrBOTpWtvo/QaPGyCZovsEx5wA2ErZHocn17HZgBp2VVmnxtPZGpc
         RjQ7ujAWmrWuhBOEZ/z+4IZ6c0JiSQHuCHrJ6E0CF+9+DLu+L4uTTCvsEOSOBYL1kodR
         qeAZhq8EWEe+9EkwSOi2UDug4RkyMwq46yAxW6kJJEDAslwRWhXd1Emc5lWpOBvlNa/9
         SYRaOqpofmS+dTbLNcOwdt7WAJk6291juvFQqOEdWGSk4YGpd77PZOIHqnfejHTqpa9x
         THNzm70Jhm1U/neZQMXz/iDJ+1s9xjD7OYyaGyhGhJuwIBebsLlm9t3q6Ww/Ig+oMM51
         NjIQ==
X-Gm-Message-State: AOAM530pkCaQVY2sXLm2rYgxry8rS5fsxf/0iUJ0ovBdG9aVXCQXlld7
        XSdkh4A1IwCJ/WvmO7sICt2pcSBFM9w=
X-Google-Smtp-Source: ABdhPJwlN/X01xB6oeWRpFaqK1Yeamz+9U1e4jnM8PsKIwF2I2fWTQcQWXagKhBNC7ezXBWijHbWrB0Tjao=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:1c47:622e:7a2a:372d])
 (user=seanjc job=sendgmr) by 2002:a25:4006:: with SMTP id n6mr40750899yba.472.1628635560090;
 Tue, 10 Aug 2021 15:46:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 10 Aug 2021 15:45:53 -0700
In-Reply-To: <20210810224554.2978735-1-seanjc@google.com>
Message-Id: <20210810224554.2978735-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210810224554.2978735-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Protect marking SPs unsync when using TDP
 MMU with spinlock
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add yet another spinlock for the TDP MMU and take it when marking indirect
shadow pages unsync.  When using the TDP MMU and L1 is running L2(s) with
nested TDP, KVM may encounter shadow pages for the TDP entries managed by
L1 (controlling L2) when handling a TDP MMU page fault.  The unsync logic
is not thread safe, e.g. the kvm_mmu_page fields are not atomic, and
misbehaves when a shadow page is marked unsync via a TDP MMU page fault,
which runs with mmu_lock held for read, not write.

Lack of a critical section manifests most visibly as an underflow of
unsync_children in clear_unsync_child_bit() due to unsync_children being
corrupted when multiple CPUs write it without a critical section and
without atomic operations.  But underflow is the best case scenario.  The
worst case scenario is that unsync_children prematurely hits '0' and
leads to guest memory corruption due to KVM neglecting to properly sync
shadow pages.

Use an entirely new spinlock even though piggybacking tdp_mmu_pages_lock
would functionally be ok.  Usurping the lock could degrade performance when
building upper level page tables on different vCPUs, especially since the
unsync flow could hold the lock for a comparatively long time depending on
the number of indirect shadow pages and the depth of the paging tree.

Note, even though L2 could theoretically be given access to its own EPT
entries, a nested MMU must hold mmu_lock for write and thus cannot race
against a TDP MMU page fault.  I.e. the additional spinlock only needs to
be taken by the TDP MMU, as opposed to being taken by any MMU for a VM
that is running with the TDP MMU enabled.  Holding mmu_lock for read also
prevents the indirect shadow page from being freed.

Alternative #1, the TDP MMU could simply pass "false" for can_unsync and
effectively disable unsync behavior for nested TDP.  Write protecting leaf
shadow pages is unlikely to noticeably impact traditional L1 VMMs, as such
VMMs typically don't modify TDP entries, but the same may not hold true for
non-standard use cases and/or VMMs that are migrating physical pages (from
L1's perspective).

Alternative #2, the unsync logic could be made thread safe.  In theory,
simply converting all relevant kvm_mmu_page fields to atomics and using
atomic bitops for the bitmap would suffice.  However, (a) an in-depth audit
would be required, (b) the code churn would be substantial, and (c) legacy
shadow paging would incur additional atomic operations in performance
sensitive paths for no benefit (to legacy shadow paging).

Fixes: a2855afc7ee8 ("KVM: x86/mmu: Allow parallel page faults for the TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/locking.rst |  8 +++----
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/mmu/mmu.c             | 36 ++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/mmu_internal.h    |  3 ++-
 arch/x86/kvm/mmu/spte.c            |  4 ++--
 arch/x86/kvm/mmu/spte.h            |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         |  3 ++-
 7 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 8138201efb09..b6bb56325138 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -31,10 +31,10 @@ On x86:
 
 - vcpu->mutex is taken outside kvm->arch.hyperv.hv_lock
 
-- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock is
-  taken inside kvm->arch.mmu_lock, and cannot be taken without already
-  holding kvm->arch.mmu_lock (typically with ``read_lock``, otherwise
-  there's no need to take kvm->arch.tdp_mmu_pages_lock at all).
+- kvm->arch.mmu_lock is an rwlock.  kvm->arch.tdp_mmu_pages_lock and
+  kvm->arch.tdp_mmu_unsync_pages_lock are taken inside kvm->arch.mmu_lock, and
+  cannot be taken without already holding kvm->arch.mmu_lock (typically with
+  ``read_lock``, thus the need for additional spinlocks).
 
 Everything else is a leaf: no other lock is taken inside the critical
 sections.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4c567b05edad..0df970dc5f45 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1176,6 +1176,9 @@ struct kvm_arch {
 	 * the thread holds the MMU lock in write mode.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
+
+	/* Protects marking pages unsync during TDP MMU page faults. */
+	spinlock_t tdp_mmu_unsync_pages_lock;
 #endif /* CONFIG_X86_64 */
 
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d574c68cbc5c..bcc5dedd531a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1887,6 +1887,8 @@ static int mmu_unsync_walk(struct kvm_mmu_page *sp,
 
 static void kvm_unlink_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
 	WARN_ON(!sp->unsync);
 	trace_kvm_mmu_sync_page(sp);
 	sp->unsync = 0;
@@ -2592,10 +2594,17 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
  * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
  * be write-protected.
  */
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
+			    spinlock_t *unsync_lock)
 {
+	bool locked_write = !unsync_lock;
 	struct kvm_mmu_page *sp;
 
+	if (locked_write)
+		lockdep_assert_held_write(&vcpu->kvm->mmu_lock);
+	else
+		lockdep_assert_held_read(&vcpu->kvm->mmu_lock);
+
 	/*
 	 * Force write-protection if the page is being tracked.  Note, the page
 	 * track machinery is used to write-protect upper-level shadow pages,
@@ -2617,9 +2626,32 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync)
 		if (sp->unsync)
 			continue;
 
+		/*
+		 * TDP MMU page faults require an additional spinlock as they
+		 * run with mmu_lock held for read, not write, and the unsync
+		 * logic is not thread safe.
+		 */
+		if (!locked_write) {
+			locked_write = true;
+			spin_lock(unsync_lock);
+
+			/*
+			 * Recheck after taking the spinlock, a different vCPU
+			 * may have since marked the page unsync.  A false
+			 * positive on the unprotected check above is not
+			 * possible as clearing sp->unsync _must_ hold mmu_lock
+			 * for write, i.e. unsync cannot transition from 0->1
+			 * while this CPU holds mmu_lock for read.
+			 */
+			if (READ_ONCE(sp->unsync))
+				continue;
+		}
+
 		WARN_ON(sp->role.level != PG_LEVEL_4K);
 		kvm_unsync_page(vcpu, sp);
 	}
+	if (unsync_lock && locked_write)
+		spin_unlock(unsync_lock);
 
 	/*
 	 * We need to ensure that the marking of unsync pages is visible
@@ -2675,7 +2707,7 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	sp = sptep_to_sp(sptep);
 
 	ret = make_spte(vcpu, pte_access, level, gfn, pfn, *sptep, speculative,
-			can_unsync, host_writable, sp_ad_disabled(sp), &spte);
+			can_unsync, host_writable, sp_ad_disabled(sp), &spte, NULL);
 
 	if (spte & PT_WRITABLE_MASK)
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 62bb8f758b3f..45179ae4a265 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -122,7 +122,8 @@ static inline bool is_nx_huge_page_enabled(void)
 	return READ_ONCE(nx_huge_pages);
 }
 
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync);
+int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, gfn_t gfn, bool can_unsync,
+			    spinlock_t *unsync_lock);
 
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_gfn_allow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 3e97cdb13eb7..4a053d2022de 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -92,7 +92,7 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
 		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte)
+		     u64 *new_spte, spinlock_t *unsync_lock)
 {
 	u64 spte = SPTE_MMU_PRESENT_MASK;
 	int ret = 0;
@@ -159,7 +159,7 @@ int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync)) {
+		if (mmu_try_to_unsync_pages(vcpu, gfn, can_unsync, unsync_lock)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			ret |= SET_SPTE_WRITE_PROTECTED_PT;
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index eb7b227fc6cf..be159c5caadb 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -342,7 +342,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 int make_spte(struct kvm_vcpu *vcpu, unsigned int pte_access, int level,
 		     gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool speculative,
 		     bool can_unsync, bool host_writable, bool ad_disabled,
-		     u64 *new_spte);
+		     u64 *new_spte, spinlock_t *unsync_lock);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dab6cb46cdb2..d99e064d366f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -25,6 +25,7 @@ bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_roots);
 	spin_lock_init(&kvm->arch.tdp_mmu_pages_lock);
 	INIT_LIST_HEAD(&kvm->arch.tdp_mmu_pages);
+	spin_lock_init(&kvm->arch.tdp_mmu_unsync_pages_lock);
 
 	return true;
 }
@@ -952,7 +953,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 		make_spte_ret = make_spte(vcpu, ACC_ALL, iter->level, iter->gfn,
 					 pfn, iter->old_spte, prefault, true,
 					 map_writable, !shadow_accessed_mask,
-					 &new_spte);
+					 &new_spte, &vcpu->kvm->arch.tdp_mmu_unsync_pages_lock);
 
 	if (new_spte == iter->old_spte)
 		ret = RET_PF_SPURIOUS;
-- 
2.32.0.605.g8dce9f2422-goog

