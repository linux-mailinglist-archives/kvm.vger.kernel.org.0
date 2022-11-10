Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 330A7623927
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 02:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiKJBs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 20:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbiKJBs1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 20:48:27 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7731179
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 17:48:26 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id t3-20020a170902e84300b00186ab03043dso304275plg.20
        for <kvm@vger.kernel.org>; Wed, 09 Nov 2022 17:48:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=daDWJEg62ng3VYHUROoCBAV65+QlkqFHNrop2NyZODI=;
        b=np3hHMwFmg3zyf+XIJlCgqYHS/rYTVi1+gp/E7D0SV7NRd3OEG0uJFYn+JGp7+NA2x
         8wLSk9lG8xLFuHh0sUwa4rGkXLwT4Ppez7wxW3la/WPVK1Gpy/iHDkWwn9yCQZlafh6+
         YYmrQDLM4cjdzPTjVqiwBNbWaZJBcA0FD3CiTp8EnEgtcbw7FkeKGynIFl2ukCaEVZ/5
         uatpTZF3YJMFldetRARaUekEgmzA9MF+sWAXpOm0pHAiOxPzoR7e3BczA5kjSzDl6ARv
         3IQL5Ug7l+byTMc5JOMQrIT9s/7PtYKD88z/864Ww9XFdJQgg2ZHlRTGixc8osKu/vpZ
         suow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=daDWJEg62ng3VYHUROoCBAV65+QlkqFHNrop2NyZODI=;
        b=3vhfm1L7RnG1yqQALYUx3lmLO4gx4MTDWuS0CsQBO3O7VsfFnmr3Bu5R4Xy6k2py50
         nf+wiq747WLaT3qg69T7chTt9rtCoUMezcT8GhVLdYJxSwIoOxQmj9q/92bbB2KXKjIA
         v9f/C8+rTarmer0inHu5x6dnmEYjbh2c/9pkgz73Af979GkvzFKRsuRkBDeoS/t8QYr7
         6EnOZOJVj2Y6keBTU2LeJ/IREN7YSoUAjsgN/w05iSyu0PHN4DQBse2gDHCoupwQXP6x
         64kwW8kmZKRzp2+s8d0mm98bECYTa6AUXScxZhHqv38Jtu6x6PcCsp6m97PaOn7oOBEd
         W3TQ==
X-Gm-Message-State: ACrzQf04gr2wVDLDl0d4xogOH+ZM/QOb8xCMBQmguAnsMnSbFhXDMjR3
        cUHAZeKRh95cvaSr9tF32nW0M44JsnA=
X-Google-Smtp-Source: AMsMyM5Y7LYgwhXwuVsTa6jt22FphDA9I+k6xqd3AbEw2IfLP+IwbzaWBEA8n/qVf3S5Yg+kc/IAJa/fhDM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7249:b0:188:5391:cec2 with SMTP id
 c9-20020a170902724900b001885391cec2mr1098435pll.78.1668044905785; Wed, 09 Nov
 2022 17:48:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 10 Nov 2022 01:48:20 +0000
In-Reply-To: <20221110014821.1548347-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221110014821.1548347-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110014821.1548347-2-seanjc@google.com>
Subject: [PATCH 1/2] KVM: x86/mmu: Don't rely on page-track mechanism to flush
 on memslot change
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call kvm_mmu_zap_all_fast() directly when flushing a memslot instead of
bounding through the page-track mechanism.  KVM (unfortunately) needs to
zap and flush all page tables on memslot DELETE/MOVE irrespective of
whether KVM is shadowing guest page tables.

This will allow changing KVM to register a page-track notifier on the
first shadow root allocation, and will also allow deleting the misguided
kvm_page_track_flush_slot() hook itself once KVM-GT also moves to a
different method for reacting to memslot changes.

No functional change intended.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/mmu/mmu.c          | 10 +---------
 arch/x86/kvm/x86.c              |  2 ++
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 81114a376c4e..382cfffb7e6c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1765,6 +1765,7 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_zap_all(struct kvm *kvm);
+void kvm_mmu_zap_all_fast(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 93c389eaf471..0a5ae07a190e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5943,7 +5943,7 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
  * not use any resource of the being-deleted slot or all slots
  * after calling the function.
  */
-static void kvm_mmu_zap_all_fast(struct kvm *kvm)
+void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
 	lockdep_assert_held(&kvm->slots_lock);
 
@@ -5999,13 +5999,6 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
 	return unlikely(!list_empty_careful(&kvm->arch.zapped_obsolete_pages));
 }
 
-static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
-			struct kvm_memory_slot *slot,
-			struct kvm_page_track_notifier_node *node)
-{
-	kvm_mmu_zap_all_fast(kvm);
-}
-
 int kvm_mmu_init_vm(struct kvm *kvm)
 {
 	struct kvm_page_track_notifier_node *node = &kvm->arch.mmu_sp_tracker;
@@ -6021,7 +6014,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 		return r;
 
 	node->track_write = kvm_mmu_pte_write;
-	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e46e458c5b08..5da86fe3c113 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12550,6 +12550,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
+	kvm_mmu_zap_all_fast(kvm);
+
 	kvm_page_track_flush_slot(kvm, slot);
 }
 
-- 
2.38.1.431.g37b22c650d-goog

