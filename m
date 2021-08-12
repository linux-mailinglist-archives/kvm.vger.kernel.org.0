Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B3E3E9DC3
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 07:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhHLFHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 01:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbhHLFHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 01:07:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81249C0613D3
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:07:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i32-20020a25b2200000b02904ed415d9d84so5076083ybj.0
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 22:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/utoSJ8QS0HxPHF3S+Rl2+2UNA9UrrVUfB5I0fsn+To=;
        b=JdSsSfM2cADHbOfN/Pm5VsjX9Vb8jKGjCmFFhQNiWx8i+g/TghjaSOCKUhV5gLBCWH
         LSrFjmoDK4bXiQIzx2VNMXV7VQgiWBVPm9Rcrm48PvaTh5x41x1wVyI3sAPz5YY6/S9U
         +ULmLO6inK/jjWV31szVvzrpNU9jRGiyMu17tr1zWouBA4tXax2/K+UkyG8yh63TxD7/
         dS3JpN32cf8PrW9J3G+/DJ8ARRu7mtkYHwDmtxhhbhc4p7jrA8KMfGkTrGEFVIqvXHbl
         RbxkIG9bFAWYagHvyAVibMImq+g2kUonZxXN7Dhtt1r+cOuxpzO/oK/UCuckBeLY/N9H
         gKtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/utoSJ8QS0HxPHF3S+Rl2+2UNA9UrrVUfB5I0fsn+To=;
        b=gcOdJojeutuU+UHUFhpBOMdVH2eZyWdUvBoRCGQvlk/z3v8L58Q0I+1DQvhlVJdGjS
         ZI5BiUj8s9adp6I2NuNfBCzkCQBrqYitw9cH9lhLKuv46vzvH6hJFnc7TSyzgaTLBKPt
         3Yj0YX+xyexHPP5pMP8qUMzx/0hySIC8iInu8nlZMngUxUr/s41ZtXfEmOBV3YV9ALFj
         Ig2qaTw7ndRDJqkfYNYztSfxCL0xeRiLyeKQJJRJXnWYO+4IO5vCGMLWMzr3yNDIJe33
         2euJpwyM/kxNTk2bZ4von7DK4KXw8ovWyHshTgoyY4Poc/vHBpP1Y58UYKBVaI4ul25X
         sImA==
X-Gm-Message-State: AOAM533j9r0pg+k0br+UjOdNxhc6+Hj8iwhi9S48ZOdvJJ+TA2MDxjtB
        G98Twhs+v1gvM5KPw+7dgsW2BfH1BlU=
X-Google-Smtp-Source: ABdhPJzAOAt+AafU0bLR1uL7lMuA/404q6kIftnmi4qYhwX6Bms4heg5W3wpL59hC8ewvhl98gbAFrAIY0g=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f150:c3bd:5e7f:59bf])
 (user=seanjc job=sendgmr) by 2002:a25:af81:: with SMTP id g1mr2126973ybh.172.1628744842739;
 Wed, 11 Aug 2021 22:07:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 11 Aug 2021 22:07:16 -0700
In-Reply-To: <20210812050717.3176478-1-seanjc@google.com>
Message-Id: <20210812050717.3176478-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210812050717.3176478-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH 1/2] KVM: x86/mmu: Don't skip non-leaf SPTEs when zapping all SPTEs
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

Use a magic number for the end gfn to signal "zap all" for the TDP MMU
and really zap all SPTEs in this case.  As is, zap_gfn_range() skips
non-leaf SPTEs whose range exceeds the range to be zapped.  If
shadow_phys_bits is not aligned to the range size of top-level SPTEs,
e.g. 512gb with 4-level paging, the "zap all" flows will skip top-level
SPTEs whose range extends beyond shadow_phys_bits and leak their SPs
when the VM is destroyed.

Use a magic number and the current upper bound (based on host.MAXPHYADDR)
instead of the max theoretical gfn, 1 << (52 - 12), even though the latter
would be functionally ok, too.  Bounding based on host.MAXPHYADDR allows
the TDP iterator to terminate its walk when the gfn of the iterator is
out of bounds.

Add a WARN on kmv->arch.tdp_mmu_pages when the TDP MMU is destroyed to
help future debuggers should KVM decide to leak SPTEs again.

The bug is most easily reproduced by running (and unloading!) KVM in a
VM whose host.MAXPHYADDR < 39, as the SPTE for gfn=0 will be skipped.

  =============================================================================
  BUG kvm_mmu_page_header (Not tainted): Objects remaining in kvm_mmu_page_header on __kmem_cache_shutdown()
  -----------------------------------------------------------------------------
  Slab 0x000000004d8f7af1 objects=22 used=2 fp=0x00000000624d29ac flags=0x4000000000000200(slab|zone=1)
  CPU: 0 PID: 1582 Comm: rmmod Not tainted 5.14.0-rc2+ #420
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  Call Trace:
   dump_stack_lvl+0x45/0x59
   slab_err+0x95/0xc9
   __kmem_cache_shutdown.cold+0x3c/0x158
   kmem_cache_destroy+0x3d/0xf0
   kvm_mmu_module_exit+0xa/0x30 [kvm]
   kvm_arch_exit+0x5d/0x90 [kvm]
   kvm_exit+0x78/0x90 [kvm]
   vmx_exit+0x1a/0x50 [kvm_intel]
   __x64_sys_delete_module+0x13f/0x220
   do_syscall_64+0x3b/0xc0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 47ec9f968406..6566f70a31c1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -13,6 +13,17 @@
 static bool __read_mostly tdp_mmu_enabled = true;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0644);
 
+/*
+ * Magic numbers for 'start' and 'end' used when zapping all SPTEs.  The values
+ * are not completely arbitrary; start must be 0, and end must be greater than
+ * the max theoretical GFN that KVM can fault into the TDP MMU.
+ */
+#define ZAP_ALL_START	0
+#define ZAP_ALL_END	-1ull
+
+/* start+end pair for zapping SPTEs for all possible GFNs. */
+#define ZAP_ALL ZAP_ALL_START, ZAP_ALL_END
+
 /* Initializes the TDP MMU for the VM, if enabled. */
 bool kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
@@ -43,6 +54,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	if (!kvm->arch.tdp_mmu_enabled)
 		return;
 
+	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -81,8 +93,6 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
@@ -94,7 +104,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false, false, shared);
+	zap_gfn_range(kvm, root, ZAP_ALL, false, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -739,8 +749,16 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush,
 			  bool shared)
 {
+	bool zap_all = (end == ZAP_ALL_END);
 	struct tdp_iter iter;
 
+	/*
+	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
+	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
+	 * and so KVM will never install a SPTE for such addresses.
+	 */
+	end = min(end, 1ULL << (shadow_phys_bits - PAGE_SHIFT));
+
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	rcu_read_lock();
@@ -759,9 +777,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		/*
 		 * If this is a non-last-level SPTE that covers a larger range
 		 * than should be zapped, continue, and zap the mappings at a
-		 * lower level.
+		 * lower level, except when zapping all SPTEs.
 		 */
-		if ((iter.gfn < start ||
+		if (!zap_all &&
+		    (iter.gfn < start ||
 		     iter.gfn + KVM_PAGES_PER_HPAGE(iter.level) > end) &&
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
@@ -803,12 +822,11 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool flush = false;
 	int i;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, ZAP_ALL, flush);
 
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
@@ -846,7 +864,6 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
 	bool flush = false;
@@ -862,8 +879,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 		rcu_read_unlock();
 
-		flush = zap_gfn_range(kvm, root, 0, max_gfn, true, flush,
-				      true);
+		flush = zap_gfn_range(kvm, root, ZAP_ALL, true, flush, true);
 
 		/*
 		 * Put the reference acquired in
-- 
2.33.0.rc1.237.g0d66db33f3-goog

