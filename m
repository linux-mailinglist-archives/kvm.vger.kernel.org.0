Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88D0E55A37A
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiFXVbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 17:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiFXVa5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 17:30:57 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F0C8053D
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:56 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id n21-20020a056a000d5500b005251893308cso1638806pfv.6
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 14:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=+jnXhzHCPLlyWGuqZQ0mGasvqcBiUClEYUi7f6uXGnA=;
        b=oMU1MlW+3HAUB8TWEcHWIqU6v3ZgrNxHm+Tp3iBDMZrqPmr/WGzoH7HQuTSZdLaO52
         Gb1sdyM9iEwOq8CHr2baCpaLbkv06tIYZyXwdAyxq3b+9mOXSiCveMZcDoIhpN7XNFoP
         AZz1KEI2BDu64hW6HRfrsp4y039H0MhY5iqm2PIwz8x4excaZ6az3/sRqSm3mhfSVDbO
         ZRVccTtvLbqt+A1utFOFQShRJA2OcrbxF2gm0h390trx4zGXGf4iEvd5XVXiTV+mycc4
         g5TfbT4xRTTs7G7PskXxxsTv1ArM8+7fgiD2df4FrniuyouldzbJ9a4LkzRRa+YWbE7o
         JHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=+jnXhzHCPLlyWGuqZQ0mGasvqcBiUClEYUi7f6uXGnA=;
        b=4qFbDpZkpuJf+Sk4P/mqpCgWEDMsM/RXjCo79cvXVLZYAVLDd/Rs/uBtq8C2tTLK03
         yyof/iZ6gkKzIf2OxtPHi+Zo708xGkBuAh7hn9lGtUIWIFUEr9GLRXrZSLmcQgzBlBZb
         yfiSlW4lmohuH4phT1dCVfiTFRub2RJ8/h06a8n9V6sd7PHakS0G5XbMAZIb+HEKKkO1
         G1htDM2K5awGKGNO5Y1pNlxFuFFhPp39tmRBGC5Kc8H2QYcFgHUDrCW8oGaQMPyLW9Dn
         I24IF8KTiwglbkJT9gZE+XeRk/QQQKSHubWOSdhYNQaBfhwJIUSfPhrAegzvA7huXI13
         5kHw==
X-Gm-Message-State: AJIora+qObwoQmRjFPKqw23+1YCi81lincBw5tOKJfv3yU2I4r04Bmtv
        /wlua6wMMVugelOhQhp8Nlq0KmQnoiA=
X-Google-Smtp-Source: AGRyM1tzdjiNisYNqq4YKLQi4OaXM7gDixiQ7ghRnaWpvtULrzdW//5VP9BJ3ETreJf22QjtlykemyEnLqM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4a97:b0:1ea:fa24:467c with SMTP id
 f23-20020a17090a4a9700b001eafa24467cmr389269pjh.1.1656106255902; Fri, 24 Jun
 2022 14:30:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 21:30:38 +0000
In-Reply-To: <20220624213039.2872507-1-seanjc@google.com>
Message-Id: <20220624213039.2872507-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220624213039.2872507-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH v2 3/4] KVM: x86/mmu: Use "unsigned int", not "u32", for
 SPTEs' @access info
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
Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 83ca71361acd..eae5c801e442 100644
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

