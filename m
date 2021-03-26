Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14BF0349F77
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhCZCUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbhCZCUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:16 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF080C061761
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:15 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id f75so8101232yba.8
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8Eo/ejufJftePnvgXQFd5kbV9TMjCK+DUzEIWSLNHic=;
        b=J4NBszqz0qYCjVKsOP65Ukhsxf/vaS7LS6yFdbgFAh2sUgBQG0ogA/cQxk794uXzjP
         RY9KWD9YNpzjGBLdWOTPyshz2TFnTG+tnYPlCC99vnayJJ8x/1vz0RyuxQBRKNswIoqx
         u7caOX3ZY3ljHIlIuV5UDQD7orO9CacchKaW4wZWVQ1KulpoGRsgS3HncjI2rDTBW85e
         0LzSSCSzQyzj0qFJEDJj1/5vO/M+e6fGvrqJcu73hE+6xaV3PGahPlecwL8l+6KqIgxm
         +0hE0fM1McrNq/V5ahNrq1hMd2o01ghMEWLbLn93kMCLrtd6e1hGFJmudhcDtPpnJwkT
         0OzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8Eo/ejufJftePnvgXQFd5kbV9TMjCK+DUzEIWSLNHic=;
        b=oJkDRGY0k3wI7j2ZstWnXO2+6nIC2Q26a4nku4tnHcAaSlq4LFVAx5p+YA257UpdDI
         pHzrNdE1fIDhdV12ereXE6b7hsT7D2eZybrmr8ELYIRw9xYWIm4VsCO0IHsa0zQ2DG9e
         7yvBm0EAlpcDXJeYX7TdAqL3GzwbYpK4o7yAzuzR4a99quK00wyoGb59dkBi0AqGvMHd
         LFtFdv2N/JCOh1cvSz7nLu0Of2dBDolZKJe/jRNln/9WN/Y6XxfkEj2r5m6ylorb2/nC
         +68YGBDVmTAee+75/4s8fs51LpEUU7BGtne+KKz37ZA6FnDMpJ9phlWSo1b1NHyoqfIl
         leIw==
X-Gm-Message-State: AOAM532FJk5PgiMrerdrKzayy46D/8R5zS0HpXfSqiQ4PEv4U0qAF0Zj
        bARqEC0WJOsvrwxMfomcZziuahatLMM=
X-Google-Smtp-Source: ABdhPJwV8LHyLDP6hqXuH/hYE4HksnD0YFc19NvHc8Jf2O8EQ8BbTBUtjDn7cvQ5x0SPUFyfrReRDGiHTIk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:9982:: with SMTP id p2mr17272898ybo.457.1616725215166;
 Thu, 25 Mar 2021 19:20:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:41 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 02/18] KVM: x86/mmu: Move flushing for "slot" handlers to
 caller for legacy MMU
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Place the onus on the caller of slot_handle_*() to flush the TLB, rather
than handling the flush in the helper, and rename parameters accordingly.
This will allow future patches to coalesce flushes between address spaces
and between the legacy and TDP MMUs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7a99e59c8c1c..d5c9fb34971a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5227,7 +5227,7 @@ typedef bool (*slot_level_handler) (struct kvm *kvm, struct kvm_rmap_head *rmap_
 static __always_inline bool
 slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			slot_level_handler fn, int start_level, int end_level,
-			gfn_t start_gfn, gfn_t end_gfn, bool lock_flush_tlb)
+			gfn_t start_gfn, gfn_t end_gfn, bool flush_on_yield)
 {
 	struct slot_rmap_walk_iterator iterator;
 	bool flush = false;
@@ -5238,7 +5238,7 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			flush |= fn(kvm, iterator.rmap, memslot);
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-			if (flush && lock_flush_tlb) {
+			if (flush && flush_on_yield) {
 				kvm_flush_remote_tlbs_with_address(kvm,
 						start_gfn,
 						iterator.gfn - start_gfn + 1);
@@ -5248,32 +5248,26 @@ slot_handle_level_range(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		}
 	}
 
-	if (flush && lock_flush_tlb) {
-		kvm_flush_remote_tlbs_with_address(kvm, start_gfn,
-						   end_gfn - start_gfn + 1);
-		flush = false;
-	}
-
 	return flush;
 }
 
 static __always_inline bool
 slot_handle_level(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		  slot_level_handler fn, int start_level, int end_level,
-		  bool lock_flush_tlb)
+		  bool flush_on_yield)
 {
 	return slot_handle_level_range(kvm, memslot, fn, start_level,
 			end_level, memslot->base_gfn,
 			memslot->base_gfn + memslot->npages - 1,
-			lock_flush_tlb);
+			flush_on_yield);
 }
 
 static __always_inline bool
 slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
-		 slot_level_handler fn, bool lock_flush_tlb)
+		 slot_level_handler fn, bool flush_on_yield)
 {
 	return slot_handle_level(kvm, memslot, fn, PG_LEVEL_4K,
-				 PG_LEVEL_4K, lock_flush_tlb);
+				 PG_LEVEL_4K, flush_on_yield);
 }
 
 static void free_mmu_pages(struct kvm_mmu *mmu)
@@ -5509,10 +5503,14 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 			if (start >= end)
 				continue;
 
-			slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
-						PG_LEVEL_4K,
-						KVM_MAX_HUGEPAGE_LEVEL,
-						start, end - 1, true);
+			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmapp,
+							PG_LEVEL_4K,
+							KVM_MAX_HUGEPAGE_LEVEL,
+							start, end - 1, true);
+
+			if (flush)
+				kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
+								   gfn_end);
 		}
 	}
 
@@ -5605,9 +5603,12 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 {
 	/* FIXME: const-ify all uses of struct kvm_memory_slot.  */
 	struct kvm_memory_slot *slot = (struct kvm_memory_slot *)memslot;
+	bool flush;
 
 	write_lock(&kvm->mmu_lock);
-	slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+	flush = slot_handle_leaf(kvm, slot, kvm_mmu_zap_collapsible_spte, true);
+	if (flush)
+		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
 
 	if (is_tdp_mmu_enabled(kvm))
 		kvm_tdp_mmu_zap_collapsible_sptes(kvm, slot);
@@ -5619,7 +5620,7 @@ void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
 {
 	/*
 	 * All current use cases for flushing the TLBs for a specific memslot
-	 * are related to dirty logging, and do the TLB flush out of mmu_lock.
+	 * related to dirty logging, and many do the TLB flush out of mmu_lock.
 	 * The interaction between the various operations on memslot must be
 	 * serialized by slots_locks to ensure the TLB flush from one operation
 	 * is observed by any other operation on the same memslot.
-- 
2.31.0.291.g576ba9dcdaf-goog

