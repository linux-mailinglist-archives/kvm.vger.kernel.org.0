Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFCF3701353
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 02:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241786AbjEMAhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 20:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241517AbjEMAgq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 20:36:46 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09DD7A5D8
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:28 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-643a9203dc2so5890936b3a.1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 17:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683938188; x=1686530188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=caCqfAxo3tmXcjzSDBInzE0fjHL4Utao36SGXPLAgDo=;
        b=1SA3m92adALDdF4M2tXh8CcJTLmqMlbEPkHzYlWk50YCEITk5P2uF6rHKRQgOBiv32
         ZT+h+YLliALljJTtaZAvr2hT8E0y373siHAadOsRN9M6ehdkksWXHqGXRpvMrSH8gOZs
         em/7SfUtC0MW3DkkSdI9+CDcNXE5iE4G1yV6Xd4UNMDBMbhyEEJYSO3CoojdzTzX8uQG
         cWH1K+Mgx/lImOT2SQkoHr179+Z5+05bY+K0rCQkliXJaPkVMUF73jVxg/xpPmhM8BEd
         NJ0LlVvKYO0hF0pT15fN9D39cnRhHsN++gywGdN3SvOv4TnOgFHMifRG5XpMekm1RY/+
         RGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683938188; x=1686530188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caCqfAxo3tmXcjzSDBInzE0fjHL4Utao36SGXPLAgDo=;
        b=TUBP8esoMTUS7kKcOvh4ZBFrF2LOygPjkmkywAnr2fiBIlI4HLzocJkQ3j0QACXFDR
         TPDZFACDML+I1tZyWbgaAoXMlUD82s1fp5M60Y9EZI4J6OJ2df9bxJM7Ql3rdpwOrQM6
         4CAG+R54IVtjpc+mREu+gEPl8tQ08ZCmI7P8TErhMcFI0R9KrkcM9rqa4MvTvb8r0EsQ
         Ld/tW7E7PR+jBM6ZSvYKQ6JlKWB2H83eXH9ebr9zq+8vrxBqNBQH2uKHwN6AR8HIaE84
         yy4M8GnrfiKjm0NHSbo1RuyU5FkYryHiuMzNAnffPT/IJdQRn/E1NNwj5tYD+dH32HUj
         ejuA==
X-Gm-Message-State: AC+VfDxZ8BIBbjhyZ9PXEwzZ9LHygKyLHREFcZkV5slSigv8vQJDGHkM
        bGl4m7joFOYuD+MwXqDcyMlmqKO57vM=
X-Google-Smtp-Source: ACHHUZ5ZIoceJVCJgJPVozwhsPt6F90NmTGVT77kQymdEYSNjXuOySK3njg3DHtwar2gg6RBit/1FTDXB0E=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:785:b0:643:a3a6:115f with SMTP id
 g5-20020a056a00078500b00643a3a6115fmr7156203pfu.3.1683938188573; Fri, 12 May
 2023 17:36:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 17:35:44 -0700
In-Reply-To: <20230513003600.818142-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230513003600.818142-13-seanjc@google.com>
Subject: [PATCH v3 12/28] KVM: x86/mmu: Don't rely on page-track mechanism to
 flush on memslot change
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Call kvm_mmu_zap_all_fast() directly when flushing a memslot instead of
bouncing through the page-track mechanism.  KVM (unfortunately) needs to
zap and flush all page tables on memslot DELETE/MOVE irrespective of
whether KVM is shadowing guest page tables.

This will allow changing KVM to register a page-track notifier on the
first shadow root allocation, and will also allow deleting the misguided
kvm_page_track_flush_slot() hook itself once KVM-GT also moves to a
different method for reacting to memslot changes.

No functional change intended.

Cc: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/r/20221110014821.1548347-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2e4476d38377..23a79723031b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6184,13 +6184,6 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
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
@@ -6208,7 +6201,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	}
 
 	node->track_write = kvm_mmu_pte_write;
-	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
@@ -6750,6 +6742,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
+	kvm_mmu_zap_all_fast(kvm);
+
 	kvm_page_track_flush_slot(kvm, slot);
 }
 
-- 
2.40.1.606.ga4b1b128d6-goog

