Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C372B767B24
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237654AbjG2BhP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237622AbjG2Bg5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:36:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2EE5598
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:36:25 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c6dd0e46a52so2500571276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594567; x=1691199367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mQ+ZuzEFbl5O8mlpWOHgtbjc+Hc/5HoNzhozE45JaLU=;
        b=WZConVgDmS5EmLUtUW3mWU7S8RxEZOVUVAu20Avyg+dOT8q99nTIpuz55xULKWjISw
         iCAurxgWrZk5icw5zY5sztJnmPPEWtvRbD0q5iScqHoLph8A+Trwc9DE/7E+yCbSArRH
         096LUklzL9PKq5+7HD3ZdjHqQKTNSLFEp4UUvOIah0va5NhjfqhpczKpIhbbpdSoqBDd
         /cGZ3dGKnFyE7j7LlLeysb6brynTp1h/cN3eXU8/k167F4MM7x8Jz4AMq8txNwYoq7kz
         AT8lnb9euANf7Knv+9SQX9b42mS+B949wl6d6R8Hqd1o33mEljeyuwvXAaZrbwAZKY5H
         xm0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594567; x=1691199367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mQ+ZuzEFbl5O8mlpWOHgtbjc+Hc/5HoNzhozE45JaLU=;
        b=Xm1LMY8oiJjF0+K8Ul4eTD4G929KXLzdFn+9PLMGNFfxrNTib0DZUDnUCrFcbjTGZv
         FZn195Zp2Aiy5ZdEt8wMxBFHfFWlVyYGvkijZ5JLnir2DdnRowzjjZqkgJd+QjqM85ov
         LAPD7in6TNRqu7VTKirzBt2ODu82z0X8fHdqzQIG/9NZDLks8EmGqsI3JjZbWfEdMikP
         +DCEKYolr8DD8gIAUaviwsE5nTNBKUcMbjzbpJWqi7rF5Lf2peaE/M4pP5EGAjd6rs3P
         CTx2yEVGferUEZu+cfm2wOqAkWzhAhJZLW/lKjRMJ1MAoUrHObjRqeBLT3gFGICMb9qz
         3asQ==
X-Gm-Message-State: ABy/qLZUBb429wnLKbTV4kYcao6GuKx186XchOs0bLXY5iSAnq0h7Yw6
        qYox8CuF/Y/JV5+UTDUi2C2/vYxkjJA=
X-Google-Smtp-Source: APBJJlFQ3hhnV1P7ciVR0dYoESD3XPJ++F/enrXhmW6nGDeuy1gJ4hjm9TqahxJ6bBSca1yu04RHJYuqicA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2057:0:b0:c41:4696:e879 with SMTP id
 g84-20020a252057000000b00c414696e879mr17328ybg.7.1690594566810; Fri, 28 Jul
 2023 18:36:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:18 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-13-seanjc@google.com>
Subject: [PATCH v4 12/29] KVM: x86/mmu: Move kvm_arch_flush_shadow_{all,memslot}()
 to mmu.c
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move x86's implementation of kvm_arch_flush_shadow_{all,memslot}() into
mmu.c, and make kvm_mmu_zap_all() static as it was globally visible only
for kvm_arch_flush_shadow_all().  This will allow refactoring
kvm_arch_flush_shadow_memslot() to call kvm_mmu_zap_all() directly without
having to expose kvm_mmu_zap_all_fast() outside of mmu.c.  Keeping
everything in mmu.c will also likely simplify supporting TDX, which
intends to do zap only relevant SPTEs on memslot updates.

No functional change intended.

Suggested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 13 ++++++++++++-
 arch/x86/kvm/x86.c              | 11 -----------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 28bd38303d70..856ec22aceb6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1832,7 +1832,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
 void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 				   const struct kvm_memory_slot *memslot);
-void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ec169f5c7dce..c6dee659d592 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6732,7 +6732,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	 */
 }
 
-void kvm_mmu_zap_all(struct kvm *kvm)
+static void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -6757,6 +6757,17 @@ void kvm_mmu_zap_all(struct kvm *kvm)
 	write_unlock(&kvm->mmu_lock);
 }
 
+void kvm_arch_flush_shadow_all(struct kvm *kvm)
+{
+	kvm_mmu_zap_all(kvm);
+}
+
+void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
+{
+	kvm_page_track_flush_slot(kvm, slot);
+}
+
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen)
 {
 	WARN_ON(gen & KVM_MEMSLOT_GEN_UPDATE_IN_PROGRESS);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a6b9bea62fb8..059571d5abed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12776,17 +12776,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 		kvm_arch_free_memslot(kvm, old);
 }
 
-void kvm_arch_flush_shadow_all(struct kvm *kvm)
-{
-	kvm_mmu_zap_all(kvm);
-}
-
-void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-				   struct kvm_memory_slot *slot)
-{
-	kvm_page_track_flush_slot(kvm, slot);
-}
-
 static inline bool kvm_guest_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
 	return (is_guest_mode(vcpu) &&
-- 
2.41.0.487.g6d72f3e995-goog

