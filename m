Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E9E3EAA01
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 20:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhHLSOt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 14:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237587AbhHLSOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 14:14:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FD3C0617A8
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:14:21 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e16-20020a5b0cd00000b0290593fc399a4fso3701268ybr.15
        for <kvm@vger.kernel.org>; Thu, 12 Aug 2021 11:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+cJ5Eo/7stSEoQmpKvGeL2VAiRr7HR5gJQMVrTeKcGA=;
        b=S7/oJLtkN1d+GhNnH3wmvdTroTuqo9qJJ7vMrwDYr+cjiY46jdonihhTpLEfg8fBAn
         pmcZDVDAPMK2vaKWGFbNRWXWpBCTJOx6RHDBxqzcbAV70u5ySiB5IILP0IRRNxKuMkQX
         9AgJFfhf2kgSybCC6uDdZp4ILKj7mNhjoWC8B3f80E16M4hxdpgvWnxlQLqUrShgWO+u
         +EtzLOlmKTf7lyproJN939d4ZZWQUrPOPzG2zI+BfRxIpirpdw8QYwHn+ZTA+wuL7552
         pZsvPB7tW92fhpT900HIVxY7kURyO9wtu+ixefttz2Wqn7kdHjw0xZJgq42HdOcdi3tl
         KEDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+cJ5Eo/7stSEoQmpKvGeL2VAiRr7HR5gJQMVrTeKcGA=;
        b=NtKd5zxubzYxsaYzcWwTn2r+Yq9tYPsjBBIOpg9HeDKtAPcZ4XEYHsRNvXZWN6G1pi
         z0BfwLG7OfO+JiMmkfz7een0rNKbvXbETa+7JHZGlc1gCUkvDFCHmjgCVdmGm3fGTokF
         UkAftvR79aGFPpi5vO/LIpsHy1Y8EH2tDTr7iU24zTVDW0RXuA1O2jJ50vB1YDIyvWS9
         I/2+K33pgmQoAOOuKvaxu+0YXghtcP2kIWQqHBfd1Bi9w4RG00aAfXHi/2VjguxRufER
         zA8DD5VK+FWxXSsGDjLEEDI8QZxPjJBp9iVKeCO1mZXmDD0NhEVE7jjmb9M5dv19Qewc
         uytw==
X-Gm-Message-State: AOAM533GAsNSVHtZqtJUsuwbgCnzfKQ3xDHPYhS+1T3QvjCuYHeMw6oa
        khfKaNwCm0NI3bHruB4oxJDsdr9xSxc=
X-Google-Smtp-Source: ABdhPJz6pmWSGGBm1wSrsGou+jluQl6wDiZZTrxx9iEEKnbegwtos8/9wXQmh61LjeqJ2U9le1Qr32aYrmw=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:f150:c3bd:5e7f:59bf])
 (user=seanjc job=sendgmr) by 2002:a5b:c52:: with SMTP id d18mr6097835ybr.248.1628792061210;
 Thu, 12 Aug 2021 11:14:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 Aug 2021 11:14:13 -0700
In-Reply-To: <20210812181414.3376143-1-seanjc@google.com>
Message-Id: <20210812181414.3376143-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210812181414.3376143-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v2 1/2] KVM: x86/mmu: Don't leak non-leaf SPTEs when zapping
 all SPTEs
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

Pass "all ones" as the end GFN to signal "zap all" for the TDP MMU and
really zap all SPTEs in this case.  As is, zap_gfn_range() skips non-leaf
SPTEs whose range exceeds the range to be zapped.  If shadow_phys_bits is
not aligned to the range size of top-level SPTEs, e.g. 512gb with 4-level
paging, the "zap all" flows will skip top-level SPTEs whose range extends
beyond shadow_phys_bits and leak their SPs when the VM is destroyed.

Use the current upper bound (based on host.MAXPHYADDR) to detect that the
caller wants to zap all SPTEs, e.g. instead of using the max theoretical
gfn, 1 << (52 - 12).  The more precise upper bound allows the TDP iterator
to terminate its walk earlier when running on hosts with MAXPHYADDR < 52.

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
 arch/x86/kvm/mmu/tdp_mmu.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 47ec9f968406..4a9d52283ec5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -43,6 +43,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 	if (!kvm->arch.tdp_mmu_enabled)
 		return;
 
+	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_pages));
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
 	/*
@@ -81,8 +82,6 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
-
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
@@ -94,7 +93,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	list_del_rcu(&root->link);
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 
-	zap_gfn_range(kvm, root, 0, max_gfn, false, false, shared);
+	zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
@@ -739,8 +738,17 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush,
 			  bool shared)
 {
+	gfn_t max_gfn_host = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
+	bool zap_all = (start == 0 && end >= max_gfn_host);
 	struct tdp_iter iter;
 
+	/*
+	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
+	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
+	 * and so KVM will never install a SPTE for such addresses.
+	 */
+	end = min(end, max_gfn_host);
+
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 
 	rcu_read_lock();
@@ -759,9 +767,10 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -803,12 +812,11 @@ bool __kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, int as_id, gfn_t start,
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool flush = false;
 	int i;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
-		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, max_gfn, flush);
+		flush = kvm_tdp_mmu_zap_gfn_range(kvm, i, 0, -1ull, flush);
 
 	if (flush)
 		kvm_flush_remote_tlbs(kvm);
@@ -846,7 +854,6 @@ static struct kvm_mmu_page *next_invalidated_root(struct kvm *kvm,
  */
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	struct kvm_mmu_page *next_root;
 	struct kvm_mmu_page *root;
 	bool flush = false;
@@ -862,8 +869,7 @@ void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm)
 
 		rcu_read_unlock();
 
-		flush = zap_gfn_range(kvm, root, 0, max_gfn, true, flush,
-				      true);
+		flush = zap_gfn_range(kvm, root, 0, -1ull, true, flush, true);
 
 		/*
 		 * Put the reference acquired in
-- 
2.33.0.rc1.237.g0d66db33f3-goog

