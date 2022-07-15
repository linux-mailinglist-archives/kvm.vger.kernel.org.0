Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC746576A12
	for <lists+kvm@lfdr.de>; Sat, 16 Jul 2022 00:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiGOWnF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 18:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiGOWmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 18:42:46 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E9C33E0F
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:41 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f7-20020a170902ce8700b0016cb1f2298fso2744026plg.18
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 15:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=nKZwU46tdd0WaDHu+Sg6LY1gpa1IBSzjRW6H5zeHce8=;
        b=bSXNdd3WOjzzjC176GBV0psJgli8IOnDsDSF2Ez847DKaoyUXd85e8lrBf4zqRtV6z
         67psHhfOruNhY60EkxhLGSh7tX/CNDye7qz+c3c9n742Jb4XS+KiT+yZv2SjvASRtBm7
         iGBoLHF+lJuT8pVwcfLh1VVAkQhGIvC2hOJTXFaSGLLpOJxvEHzCWb11apE7DnEj2hrc
         fODXS9LcfjYHUM/m6+dDAfueMRO2RA7VJSBQPmIrRHJAwkACw7gONdYFVdry9N82OkSX
         q+oBObB0R5w9WX4WsAGFkr8cSFa2jQTK2g+EbwP5dGo02RATkZK6eOXrHB2/SkmAclkz
         gPSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=nKZwU46tdd0WaDHu+Sg6LY1gpa1IBSzjRW6H5zeHce8=;
        b=YuOsjnhN3RUh+F7Gp2CaI0kw/LHAKillD+DF0D8l9qspw/mFSfMNG+pk+M69ZjILKX
         3FVxyNSobvthfA8NNe8f7wP2/xFuwLMHjiRW9oO7Mq3wbq5wcB0EdVw3mD3N4Wugz8bW
         HeOgNSUkt8jThydBXrsdCJEirGZrXJxIqYjpDUCSDJlgaJqXjqcH8B6fMabg+f+EpsLN
         GHLkHaNQQBnBU0TFZdg0TWG/067Giqb8/Ix7pV5BayOvsLB/xWbB1mDdMe221gkmo09G
         ZRDahv3mxswt0vC1FpE7fKFnMO+qnSF/YL6KEqRJAZ+6KUH6qhQsrxRe+IpIoA5krVid
         8qGg==
X-Gm-Message-State: AJIora+LP/LD+EUEgrIUIMMPcWu48hlKWHrSfU83dVL9p2LDU9B7olMM
        C15oLeKr3cXWdXlXkH+NIpyqZsuBP5A=
X-Google-Smtp-Source: AGRyM1ujBRNucPizZy2wMsMB7RSXuyXOVOMKIo4vbG8VnH3PpfY+Ru5iTJWa89ooGQKngLh4mbMUKXpoB90=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:b00b:b0:1f1:6023:dacd with SMTP id
 x11-20020a17090ab00b00b001f16023dacdmr2731540pjq.184.1657924960839; Fri, 15
 Jul 2022 15:42:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 22:42:24 +0000
In-Reply-To: <20220715224226.3749507-1-seanjc@google.com>
Message-Id: <20220715224226.3749507-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220715224226.3749507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 5/7] KVM: x86/mmu: Rename rmap zap helpers to eliminate
 "unmap" wrapper
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
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

Rename kvm_unmap_rmap() and kvm_zap_rmap() to kvm_zap_rmap() and
__kvm_zap_rmap() respectively to show that what was the "unmap" helper is
just a wrapper for the "zap" helper, i.e. that they do the exact same
thing, one just exists to deal with its caller passing in more params.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 61c32d8d1f6d..00be88e0a5f7 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1383,17 +1383,17 @@ static bool kvm_vcpu_write_protect_gfn(struct kvm_vcpu *vcpu, u64 gfn)
 	return kvm_mmu_slot_gfn_write_protect(vcpu->kvm, slot, gfn, PG_LEVEL_4K);
 }
 
-static bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			 const struct kvm_memory_slot *slot)
+static bool __kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			   const struct kvm_memory_slot *slot)
 {
 	return pte_list_destroy(kvm, rmap_head);
 }
 
-static bool kvm_unmap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
-			   struct kvm_memory_slot *slot, gfn_t gfn, int level,
-			   pte_t unused)
+static bool kvm_zap_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
+			 struct kvm_memory_slot *slot, gfn_t gfn, int level,
+			 pte_t unused)
 {
-	return kvm_zap_rmap(kvm, rmap_head, slot);
+	return __kvm_zap_rmap(kvm, rmap_head, slot);
 }
 
 static bool kvm_set_pte_rmap(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
@@ -1529,7 +1529,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	bool flush = false;
 
 	if (kvm_memslots_have_rmaps(kvm))
-		flush = kvm_handle_gfn_range(kvm, range, kvm_unmap_rmap);
+		flush = kvm_handle_gfn_range(kvm, range, kvm_zap_rmap);
 
 	if (is_tdp_mmu_enabled(kvm))
 		flush = kvm_tdp_mmu_unmap_gfn_range(kvm, range, flush);
@@ -6004,7 +6004,7 @@ static bool kvm_rmap_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_e
 			if (WARN_ON_ONCE(start >= end))
 				continue;
 
-			flush = slot_handle_level_range(kvm, memslot, kvm_zap_rmap,
+			flush = slot_handle_level_range(kvm, memslot, __kvm_zap_rmap,
 							PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL,
 							start, end - 1, true, flush);
 		}
-- 
2.37.0.170.g444d1eabd0-goog

