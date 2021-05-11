Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFA137ACE7
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:16:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232032AbhEKRRv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:17:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhEKRRj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:17:39 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1782BC061344
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:29 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id h17-20020a0cb4d10000b02901c51890529dso16062001qvf.18
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Ngmzrc1OFlZl8Ai9tz2syHudz9d0nSq8e5MZecARPTE=;
        b=n3Guhyxdq4cgqPfyN+sJwX7soNr8JrbxP9j8x1tRS6JFnDlxPGztO9hSVvPZ311zv0
         fbABmRwsqx5XDc232fireb8CPH1YXrzIeq5mEih2hx4UR2uKq9PkkESo89MWnCa5tMPg
         eBVqvWL94S89OCWn5/valg14OzblkbA/R0cDIwALpDEqpC3IjWIXeIfIQz6WDcVHYtUQ
         5rFn3a5PZy2j1G6Vk508PaYzWZ9PFs8uCJsU+V5iaFnckYJncg1govjNlTTmUJcrz5jQ
         Ix1N2hHwZ2ZyrvSMB52w42tCGoIwcAVNRu4r2reo+ItBsB3jqv/sxC4W4EdoZYRRbT+y
         aspA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ngmzrc1OFlZl8Ai9tz2syHudz9d0nSq8e5MZecARPTE=;
        b=E5OLjusvQu6fu6SFi7d2p3WZqqgIVbIJ6FMv0F/lso5/j2ky32c3/yNCg3qbWpxKli
         7aRWqXPrCOBO3fJ27calzq+W1wtqH1O/9junJeuIQWDjbGNOhiDWhVP0WQYM2alYNmT0
         PsdfMnIE0dwY2Xvdsj57mwa4yVXb57ZO2IzKsJc5GLhON1d58nHAJd8FEfq+9PXwpr2g
         DWOuQPI7S1sZB8GiiU602l1Aw/DsYyDYA+Hy2sbSEX6lQFL/Ep7sRbeg0zpVxIlhLPOU
         U5vgvSNcCc7Cvtn2ElqJv74MPqu8lU7tpB0H4KZa7u6szgTfLO1shRbRKlddFjJw+tNN
         Cimg==
X-Gm-Message-State: AOAM532PTtnmTFKb5kzAKY+GAUD2wXvYfXoZKpZ0DXbIhogSV/475E0G
        FAERwjXe893eDQEJkNa3ECxSqVrgsF1p
X-Google-Smtp-Source: ABdhPJyL7t6bz9R6TfR54Z+J13Kc0BJROZ9Nq49s5ztgCQoyEKQJRFo/KOliSW/XupevQqqvx+vytcKauEvR
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e050:3342:9ea6:6859])
 (user=bgardon job=sendgmr) by 2002:ad4:5490:: with SMTP id
 q16mr14227216qvy.40.1620753388262; Tue, 11 May 2021 10:16:28 -0700 (PDT)
Date:   Tue, 11 May 2021 10:16:08 -0700
In-Reply-To: <20210511171610.170160-1-bgardon@google.com>
Message-Id: <20210511171610.170160-6-bgardon@google.com>
Mime-Version: 1.0
References: <20210511171610.170160-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v4 5/7] KVM: x86/mmu: Add a field to control memslot rmap allocation
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

Add a field to control whether new memslots should have rmaps allocated
for them. As of this change, it's not safe to skip allocating rmaps, so
the field is always set to allocate rmaps. Future changes will make it
safe to operate without rmaps, using the TDP MMU. Then further changes
will allow the rmaps to be allocated lazily when needed for nested
oprtation.

No functional change expected.

Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  6 ++++++
 arch/x86/kvm/mmu/mmu.c          |  2 ++
 arch/x86/kvm/x86.c              | 13 ++++++++-----
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 55efbacfc244..fc75ed49bfee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1124,6 +1124,12 @@ struct kvm_arch {
 	 */
 	spinlock_t tdp_mmu_pages_lock;
 #endif /* CONFIG_X86_64 */
+
+	/*
+	 * If set, rmaps have been allocated for all memslots and should be
+	 * allocated for any newly created or modified memslots.
+	 */
+	bool memslots_have_rmaps;
 };
 
 struct kvm_vm_stat {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..f059f2e8c6fe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5469,6 +5469,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm_mmu_init_tdp_mmu(kvm);
 
+	kvm->arch.memslots_have_rmaps = true;
+
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cc0440b5b35d..03b6bcff2a53 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10935,7 +10935,8 @@ static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
 	return 0;
 }
 
-static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
+static int kvm_alloc_memslot_metadata(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
@@ -10948,9 +10949,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	r = memslot_rmap_alloc(slot, npages);
-	if (r)
-		return r;
+	if (kvm->arch.memslots_have_rmaps) {
+		r = memslot_rmap_alloc(slot, npages);
+		if (r)
+			return r;
+	}
 
 	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		struct kvm_lpage_info *linfo;
@@ -11021,7 +11024,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(memslot,
+		return kvm_alloc_memslot_metadata(kvm, memslot,
 						  mem->memory_size >> PAGE_SHIFT);
 	return 0;
 }
-- 
2.31.1.607.g51e8a6a459-goog

