Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F41559F75
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiFXRS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbiFXRSQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:16 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769232A26E
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z189-20020a6265c6000000b005254eb899c1so1489647pfb.22
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=K46f4K9UaV60sAHFJWU6i+EIQhUTy/NN+lEPT0vprpQ=;
        b=hBbjl9EkDKZpN8W6SeE8NvLEAl7ZXREUS9DHSbr7wSvuP5JZMVLXsaOXmJARVpYblF
         T19DjoRsgKIuV60zNxDu98CAYYICpYWs1FVcKVy2TEiH54yRVC8Rtx9GhG389ueFL5Rw
         2HTDDuV6URANEwgqpqMjCm77Z7MSjtb7p+Kn6k1UVHzwbL0qEPi0+nV9YIJwF1bncvZ1
         wWXBDeoFh6a3seZrN7UG0gI2v3lXGBKBmhSXtBvf/j/dLn2dkaye6MRERWdePVBTwdo5
         5EbDEmMQ9l3zSXORttaHmip5kG4pQzLQ8oXT77FdJHi6dmicYhHJIpuaXu5xQw5t25hV
         8l5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=K46f4K9UaV60sAHFJWU6i+EIQhUTy/NN+lEPT0vprpQ=;
        b=aNjy+UVvrTqT0s/n7hewzbDAp0tWPgR0pY1IKQv0KQqnXCjmSKxgy5pW5FJXwrRfTJ
         ImW0Qkozjl91aB7VDyCvCIisTv5qPHcA/GYOmtqEnayI38q8I2dj3XpfGRF1DnKJRKOw
         oJkxmd3XuPflEmUIsVyoSDgagiHKE8kTAYgPxRBtHo36o1VAHL8XvNFU6LlzaidPkLCQ
         itjVj9uD/OM0WXsyextFeLGjqZsvFv0jjUm6SOh7GYd/YRG5Dp5b2zkY8SqEcraN+TBi
         hRQGiUAHIJrEPeMOPuUdwIz6Af2bLR/ZBEGh8l2apsXqDPjIHXH2UAzbqo/Iq/C360Ue
         orGA==
X-Gm-Message-State: AJIora/VQ8KYFKuuPywJu8P79QdOjm67qfzK+D+qQ1LiDUWqDExQkLUu
        dwwdjG8BiC4/TJJy69+gIhuHnLo2Py4=
X-Google-Smtp-Source: AGRyM1vfiSzQ8mSTP/tOcOMbj7UtFYATxe8z92dHt/p/s2mrtuhQGnQakG5Hz09P3lw/NM/m+xqssy0k62o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e5cb:b0:16a:7321:c3a1 with SMTP id
 u11-20020a170902e5cb00b0016a7321c3a1mr123987plf.62.1656091094078; Fri, 24 Jun
 2022 10:18:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 17:18:07 +0000
In-Reply-To: <20220624171808.2845941-1-seanjc@google.com>
Message-Id: <20220624171808.2845941-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220624171808.2845941-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 2/3] KVM: x86/mmu: Use "unsigned int", not "u32", for SPTEs'
 @access info
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>
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

Use an "unsigned int" for @access parameters instead of a "u32", mostly
to be consistent throughout KVM, but also because "u32" is misleading.
@access can actually squeeze into a u8, i.e. doesn't need 32 bits, but is
as an "unsigned int" because sp->role.access is an unsigned int.

No functional change intended.

Link: https://lore.kernel.org/all/YqyZxEfxXLsHGoZ%2F@google.com
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 07dfed427d5b..e2213eeadebc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -717,7 +717,8 @@ static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
 	return sp->role.access;
 }
 
-static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index, gfn_t gfn, u32 access)
+static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
+					 gfn_t gfn, unsigned int access)
 {
 	if (sp_has_gptes(sp)) {
 		sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
@@ -735,7 +736,8 @@ static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index, gfn
 	          sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
 }
 
-static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index, u32 access)
+static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
+				    unsigned int access)
 {
 	gfn_t gfn = kvm_mmu_page_get_gfn(sp, index);
 
@@ -1580,7 +1582,7 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
 static void __rmap_add(struct kvm *kvm,
 		       struct kvm_mmu_memory_cache *cache,
 		       const struct kvm_memory_slot *slot,
-		       u64 *spte, gfn_t gfn, u32 access)
+		       u64 *spte, gfn_t gfn, unsigned int access)
 {
 	struct kvm_mmu_page *sp;
 	struct kvm_rmap_head *rmap_head;
@@ -1601,7 +1603,7 @@ static void __rmap_add(struct kvm *kvm,
 }
 
 static void rmap_add(struct kvm_vcpu *vcpu, const struct kvm_memory_slot *slot,
-		     u64 *spte, gfn_t gfn, u32 access)
+		     u64 *spte, gfn_t gfn, unsigned int access)
 {
 	struct kvm_mmu_memory_cache *cache = &vcpu->arch.mmu_pte_list_desc_cache;
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

