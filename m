Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D628C767B28
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbjG2BhV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237600AbjG2BhI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:37:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7653C49F2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:36:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-563fc38db94so1629803a12.0
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594568; x=1691199368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LElPg6EV64u55H7Mf5AyrdjNlx5IOWlBkIPEppU8Jnw=;
        b=jfCkSXMvNm0a4r+jhBUQwEXZDOxflF3V10465oegx122JX3cMjyBQ9B6yH6wk+0Jzp
         UVY6dLZfCVQ0+FBwRm/X8oVmEgDEuMdMqkJVU/heWBSTLawPW9MjAzRT+N1Ynxg/SZNT
         KNqx0RkGgbjKNuutmmNxcjNPUVwHvZRAkFFuiWse/LAAXFpfuTolirdvvmrpgdLdTv4u
         Z4LbCo1VWeYHuIu/i1dW/gchrcve2Xo01BA20So28O333O53tZVGRyVXESvsCZFJCXwh
         1d9D4TzpmXEjyMHr15owgr2TNH+L6sDCDTgxWySgb2terfpz4qAARImLY+CUy17C8wlM
         P1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594568; x=1691199368;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LElPg6EV64u55H7Mf5AyrdjNlx5IOWlBkIPEppU8Jnw=;
        b=MP2KPqaT85WOq5c7zKjKY8W1Rvl/LVe8UEGqHJ+hiyIWXOHcrS081A/146CzqPtPKi
         1djsYsRkhVSRgUuZAl7Q6mBeoESLztBcmybMztN/FsfIIM65YoQFWseet/V5osAR2paN
         1/slmDIbuCD7Ji26PkvPqP+Kl/aaIQMi3vE+Fhq4U9vt+dvFe27XORypUNnFnz0RCom1
         pqD9gKuTqXcKvVLhaGUrhpSgNlKuOvekOmeIIo02N1tPduM2Ii6n+D3Uv5Df6w3ith/8
         hdXmek/7xKlm1GdZBMuyqik3GkzDnDWgVKHh6FrFZVv31yK2irHONw+4hbNu7YuACpqH
         P+7g==
X-Gm-Message-State: ABy/qLaK9BMnU0y1HL/TV1yKxgdGcimY7vMkf6TtFt7SnNM8rG4/TSWN
        jjBiqWj3k0oiv8lsShJoyUgyKuywYvc=
X-Google-Smtp-Source: APBJJlFvu/5rgdRg5jWuo0EZYVBoATZTGEN5oN8JxS8hlpYglyUmwtlAU4FlgtZH1W7tOI6Tno2qFTm78ZM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c406:b0:1b8:3c5e:2289 with SMTP id
 k6-20020a170902c40600b001b83c5e2289mr12198plk.2.1690594568714; Fri, 28 Jul
 2023 18:36:08 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:19 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-14-seanjc@google.com>
Subject: [PATCH v4 13/29] KVM: x86/mmu: Don't rely on page-track mechanism to
 flush on memslot change
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
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6dee659d592..79ea57396d97 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6199,13 +6199,6 @@ static bool kvm_has_zapped_obsolete_pages(struct kvm *kvm)
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
@@ -6223,7 +6216,6 @@ int kvm_mmu_init_vm(struct kvm *kvm)
 	}
 
 	node->track_write = kvm_mmu_pte_write;
-	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
 
 	kvm->arch.split_page_header_cache.kmem_cache = mmu_page_header_cache;
@@ -6765,6 +6757,8 @@ void kvm_arch_flush_shadow_all(struct kvm *kvm)
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 				   struct kvm_memory_slot *slot)
 {
+	kvm_mmu_zap_all_fast(kvm);
+
 	kvm_page_track_flush_slot(kvm, slot);
 }
 
-- 
2.41.0.487.g6d72f3e995-goog

