Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41B052952E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350353AbiEPXWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350380AbiEPXWG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:22:06 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FEC45534
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:59 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y14-20020a17090a784e00b001df7b1f8b74so373480pjl.5
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3LhrUUJfnPbZnXXceqMM0IPZa+RwfuesldMIFcGLHNI=;
        b=ViTD7LnMDy5dnyUjNjzjAzqyb5r7Ia8iZfJbijiy5JlVtsN5M4FlGlZn/DhNRVcEct
         Wn2i6z/nvuNrHO0Hg71L+gNAVVe1s2LYdlUwWI1Lg1uPplXHab665aGapujzXCIdpUpp
         cSv2dJXa3KQznE9gBnDTzYbsCcxKtqf3smx/54to4bYnEolSEr2ebh9KROgR4ay55x7K
         fYqjJbEqHuuZeUCO56iDPe2XU9E4ql3qFeP6Yu8RPzKwAe2FdGIfuiKdH0uGLUpyKcbz
         otzC4k8XerJIPHClmHOqBkXXfWrGweo4h77tsTOqAtfWxOzrRAbTXAitnEtHO8ncI8c7
         6HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3LhrUUJfnPbZnXXceqMM0IPZa+RwfuesldMIFcGLHNI=;
        b=Rnf3MVHl9X25v1ekTIa3fhwTUKA9Jsr57zZomGju78BxvlrywDheRl4N7y00XzzSei
         vVkkzOnjggCKt53GYwBXCGRTiTlaRW2fK6ZuINfzk30gvrj38/w5nbqeKTUhQ8+p08cH
         x8Zk/uFHP2FJRH0F0DBRtx5XaeSXeawbEZG+0y+gjHHLkmO4OQI1a/qOyIVzlHWycjVJ
         UlXd3fJZ245wVGTgjuzoxg+RcCEZVFov9EyUajZUXiNSP37C7Dw6hsJKT4A14GOhaUBa
         +50hy4ClxEARwtcrojdU3BxjL3D+47te8rBuD7Hu+SES8F83FMLoILqTPENueJ60o3kb
         Bl8g==
X-Gm-Message-State: AOAM533mRvrEYJIBwM3JXznnmpzKNyZWoSFxIVCZd6PqdqONUgORRAC6
        9OnZqn5p0r1xugA9nZGrppXIP8ZXMTtugA==
X-Google-Smtp-Source: ABdhPJws0x4xZT8MEY8uaMsjDnhKVFClVcDUeHFaRwxuLoikzMxk54YWO7hpW8lqLUiOk0lnC4lFMP7mYrmHTQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4c06:b0:1dc:861c:1cfb with SMTP
 id na6-20020a17090b4c0600b001dc861c1cfbmr32974410pjb.85.1652743319050; Mon,
 16 May 2022 16:21:59 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:27 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 11/22] KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        maciej.szmigiero@oracle.com,
        "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <linux-mips@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR MIPS (KVM/mips)" 
        <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        David Matlack <dmatlack@google.com>
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

The vcpu pointer in kvm_mmu_alloc_shadow_page() is only used to get the
kvm pointer. So drop the vcpu pointer and just pass in the kvm pointer.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index bad4dd5aa051..8031b799ca77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2082,7 +2082,7 @@ struct shadow_page_caches {
 	struct kvm_mmu_memory_cache *gfn_array_cache;
 };
 
-static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
+static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
 						      struct shadow_page_caches *caches,
 						      gfn_t gfn,
 						      struct hlist_head *sp_list,
@@ -2102,15 +2102,15 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
 	 * depends on valid pages being added to the head of the list.  See
 	 * comments in kvm_zap_obsolete_pages().
 	 */
-	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
-	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
-	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
+	sp->mmu_valid_gen = kvm->arch.mmu_valid_gen;
+	list_add(&sp->link, &kvm->arch.active_mmu_pages);
+	kvm_mod_used_mmu_pages(kvm, +1);
 
 	sp->gfn = gfn;
 	sp->role = role;
 	hlist_add_head(&sp->hash_link, sp_list);
 	if (sp_has_gptes(sp))
-		account_shadowed(vcpu->kvm, sp);
+		account_shadowed(kvm, sp);
 
 	return sp;
 }
@@ -2129,7 +2129,7 @@ static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
 	sp = kvm_mmu_find_shadow_page(vcpu, gfn, sp_list, role);
 	if (!sp) {
 		created = true;
-		sp = kvm_mmu_alloc_shadow_page(vcpu, caches, gfn, sp_list, role);
+		sp = kvm_mmu_alloc_shadow_page(vcpu->kvm, caches, gfn, sp_list, role);
 	}
 
 	trace_kvm_mmu_get_page(sp, created);
-- 
2.36.0.550.gb090851708-goog

