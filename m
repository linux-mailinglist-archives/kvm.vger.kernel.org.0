Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16FC701355
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbjEMAhO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241673AbjEMAgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:53 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B555FCD
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:30 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba6386e6f7aso7863093276.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938187; x=1686530187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FkA1kDYxtUVHRHibS4MjAh7jt6yYy8zgAEbTcCm3Aro=;
        b=QcrHglgjQKdCLUAUPMt9T3ZETFuoebB3X4ZrPMqqN1eLxNZeHHFYM5Li0G7IRgqzrT
         fUVNXQwICEpsoThiTF/27ls8NtDVXRlUSaPuMKvwmyD/7uceYhmBrCPiy7GX0eueEu59
         sh9w4SiwmEFDhqqSLuUpF5qaASCXXyd5jyTm4pEA0+CY3bY1yazJ05Y5xvWzMU1c15df
         VoedXBsbFUxFrWiOjMFEcmY03nk0s1gkww2AJXLxZ81nvGUkTvoFTXrUmacMm6kuMB8i
         fh7hFM+tD29QS8LZlww8KRhvNvJE3Ob9njWh3aSLQLuqJGYvHbr4R0FjA8ENS9UaHnm/
         M1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938187; x=1686530187;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FkA1kDYxtUVHRHibS4MjAh7jt6yYy8zgAEbTcCm3Aro=;
        b=NX+r55HBjoGUzf4VqtCOhwNc4MswMBt0JCq9yIzUW0V0IiOjTBa7PiV4g2MdKARL6S
         /CrIu+2i9nnzLk6sRvpU76AT7pQURJ5J1cgJKSfLRjIWN8PpMlCoKfKx4ErvOQb3Glds
         SQTW3Zrulo10YPi+XGF8i1JWJWGiwYGDjlELprTjWfU+kNypKu5NJDw8AChD/E5nuj5R
         o3UPGgyJipJk20JskZryZFNaajyJytVz2gcfZA6+/x7+XO6pWEHBYjO0sDZGAZgiNmco
         2RstEyGOEBFDhk9jGEiTvqoWB+6bb+KZSHdVo8sDfZ5r5GsG29LFarYIi4dzV/chWF0H
         4kqg==
X-Gm-Message-State: AC+VfDyL22utYiK85C6q3MDLcbNwCcW+1x0ThLgbRKTYvkSfwqU6w4n2
        thNrHDs9exlottP3YXL+WjAN99MQtBY=
X-Google-Smtp-Source: ACHHUZ7+gIUnmBGvUuumWyI5g0GRGJ88QYrLdJ3wdv8MgxZd8U0nKSB4DYEio0yahHNKQwNut26HYiPeL6I=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9d84:0:b0:b9d:c27c:3442 with SMTP id
 v4-20020a259d84000000b00b9dc27c3442mr11524411ybp.9.1683938186917; Fri, 12 May
 2023 17:36:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:43 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-12-seanjc@google.com>
Subject: [PATCH v3 11/28] KVM: x86/mmu: Move kvm_arch_flush_shadow_{all,memslot}()
 to mmu.c
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
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
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/mmu/mmu.c          | 13 ++++++++++++-
 arch/x86/kvm/x86.c              | 11 -----------
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index fb9d1f2d6136..564a29153cee 100644
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
index c8961f45e3b1..2e4476d38377 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6717,7 +6717,7 @@ void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
 	 */
 }
 
-void kvm_mmu_zap_all(struct kvm *kvm)
+static void kvm_mmu_zap_all(struct kvm *kvm)
 {
 	struct kvm_mmu_page *sp, *node;
 	LIST_HEAD(invalid_list);
@@ -6742,6 +6742,17 @@ void kvm_mmu_zap_all(struct kvm *kvm)
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
index 523c39a03c00..b2d9c5979df7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12758,17 +12758,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
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
2.40.1.606.ga4b1b128d6-goog

