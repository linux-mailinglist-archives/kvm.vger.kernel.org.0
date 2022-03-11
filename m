Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142A24D56AE
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238759AbiCKA10 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345238AbiCKA1Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:27:25 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BAE1A271D
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:14 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id lp2-20020a17090b4a8200b001bc449ecbceso6758130pjb.8
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=//m+/4Erm4fn+rEULp2+N5ovNu4tAor1JU0kGbOkSFg=;
        b=DMOErCjEnqpcFOKygIlsSFTfCmw0C9Pj2tK0NYpYCgAcTI1iGWeaL6FRV1b2ZlfKX8
         fHYQBmv/QbDdZc+efkMwruYG+KF4wDiQDaVEfR1WJ8mcUSF76wTcN32p8eRd3os+gbwe
         HmiPcVbSsqLkKI3pTJ0GlBqlqq9PA36fDqQPPRemYGpGS2VlQfbNt1iRDlvaB0K2kTnc
         XnxAxv59lS8YUiLJmKwZc6thsP7Jo1gj39W7PaGOaRSlJdD4vh92yg8lUDbEdT2KiQZ8
         tIhYCc+gAjCABk9ZJUASFdr26iqSp1JW7do4XHUHG5vHE4zhj5bN+IYHo6EeO/tLY3TV
         7glw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=//m+/4Erm4fn+rEULp2+N5ovNu4tAor1JU0kGbOkSFg=;
        b=ZkRnsLOT+aXaYtJkdLC71u2YulaQagGEqrlaFftlJtEinxuOjRf51D/0CQmCdKU99t
         2xvjWH8U2vBGInL2HlJP2279Aws7jG10AeMKpDc1I9n36cNcsjiQak+d/NF2LsXHEAK4
         jJ1KMmNCHnWpluq6vWTx41q+YIi/e0aEv/H0xG0r3XNKivM/nY4UO7RIS5AxSa+qG12Y
         UA0RuSy2OsG0TdKflkAXDub+4p8N+/v4jPv8k4k28X5sZ9XcNbj5KGa6XLpJQqWHqSQI
         qUPNLY3mgOfmVIw45ElxO14BQMbKvz2Jujc81t5FE5AW/zrJwSIDIF9U/Eky0Oeew1jM
         fCUw==
X-Gm-Message-State: AOAM533BhSJ350iyy0R2Xbzdq6PsDpbs7/ZR+YunMapJGOgajgNenCoY
        SeC1eyzng2BxUEnpX06e7/+oUDkYGb/58g==
X-Google-Smtp-Source: ABdhPJzhIkawyFt0f4OEQ5xaTKMM8Gn4o1vOGnaEYzvNSaPlKUnsrfCuFW5EPlURrJUZ7m52xqfE2I313J0YiA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:a510:b0:1bc:5887:d957 with SMTP
 id a16-20020a17090aa51000b001bc5887d957mr18553716pjq.38.1646958373723; Thu,
 10 Mar 2022 16:26:13 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:27 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-26-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 25/26] KVM: x86/mmu: Drop NULL pte_list_desc_cache fallback
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
        David Matlack <dmatlack@google.com>
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

Now that the eager page splitting code no longer passes in NULL cache
pointers we can get rid of the debug WARN_ON() and allocation fallback.
While here, also drop the helper function mmu_alloc_pte_list_desc() as
it no longer serves any purpose.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 68785b422a08..d2ffebb659e0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -725,16 +725,6 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
-static struct pte_list_desc *mmu_alloc_pte_list_desc(struct kvm_mmu_memory_cache *cache)
-{
-	static const gfp_t gfp_nocache = GFP_ATOMIC | __GFP_ACCOUNT | __GFP_ZERO;
-
-	if (WARN_ON_ONCE(!cache))
-		return kmem_cache_alloc(pte_list_desc_cache, gfp_nocache);
-
-	return kvm_mmu_memory_cache_alloc(cache);
-}
-
 static void mmu_free_pte_list_desc(struct pte_list_desc *pte_list_desc)
 {
 	kmem_cache_free(pte_list_desc_cache, pte_list_desc);
@@ -914,7 +904,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		rmap_head->val = (unsigned long)spte;
 	} else if (!(rmap_head->val & 1)) {
 		rmap_printk("%p %llx 1->many\n", spte, *spte);
-		desc = mmu_alloc_pte_list_desc(cache);
+		desc = kvm_mmu_memory_cache_alloc(cache);
 		desc->sptes[0] = (u64 *)rmap_head->val;
 		desc->sptes[1] = spte;
 		desc->spte_count = 2;
@@ -926,7 +916,7 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 		while (desc->spte_count == PTE_LIST_EXT) {
 			count += PTE_LIST_EXT;
 			if (!desc->more) {
-				desc->more = mmu_alloc_pte_list_desc(cache);
+				desc->more = kvm_mmu_memory_cache_alloc(cache);
 				desc = desc->more;
 				desc->spte_count = 0;
 				break;
-- 
2.35.1.723.g4982287a31-goog

