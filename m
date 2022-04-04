Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C78B4F2059
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 01:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230500AbiDDXou (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 19:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiDDXor (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 19:44:47 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D462E6949E
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 16:42:42 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id ob7-20020a17090b390700b001c692ec6de4so431908pjb.7
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 16:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=iUBYYnkU7CJchuxR3lOvqoVPphRBCh0qszifS0z2hb0=;
        b=Th3RchuViiwMrL8xEdUyolWaFP9EHSqtrabMVLsluz6Av0uhtq0l+VPtlLLz3wm8/F
         R/FvuzzEQBfvNteCCxMg5ChL99EycnrtbVDuzFwhO/N9ywIXjaALM7iS2czWfkUwCQPc
         VnSh+Ou3eJmBmHVIzcBbbSNO4q/sDfJ4m9f4yCJ78hDQMANblW8yG3ZzlUKxk1zngy7x
         OC6JlSI/+wrVKGsU7vn/X0JFA+RTNtP5XZ03RyrkX9CHOI93tk/ukhW1dEv1u958SGoZ
         XIVNqQqYPyZNWupqD5UFI2OeMGaSCgod0Eh41gbF6IOaN5+iePHefJrADl+kn4qXBzlZ
         SCzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=iUBYYnkU7CJchuxR3lOvqoVPphRBCh0qszifS0z2hb0=;
        b=erweVwDt0d3CGYTr/SJvh4or3lNFkrQOpOCSmtJUs3dk6OixF8XFTF59IluXHflWxb
         Wx0bPTIPn1TXvkxAUgYuQ/2LvCZzKwG8lMJIgQgd1poRj81ZHeHwKAYG3zEYcuy5AG4N
         Y3Vc57ZGd3BHuxEPAIFCIZ60pEIh0hAEsp5h0PKydXkCttiIr4/25cQu9GWpqg0leES0
         itHrZyoeXWowXd3KnDcsJGVg2avmNull9D0nUMz+mgkFgkLTkwK5HIWQJ3lUhwDRpz53
         7bHbdX5T2fVoYg5t4BEbgliZM38VjyEA6uNSRCjRlgigSMcvxH4oS3hMYOLvWQUmd6C7
         Qriw==
X-Gm-Message-State: AOAM530ZWeuxbMjZG0TzSQgDeZJjFX4fJvyRhtSGXw9Cb21LIWlObFrN
        McFdO1B14berN32WOdnsENMtPrNX23Iyoq8r
X-Google-Smtp-Source: ABdhPJymGpqpZQotLwNvi6g82KDcXAiQqYHQzWEZeJFKQrAz7QzxfdlcOk5WyldaIY67+U8rZh3KFnCR84iDU0dQ
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:db48:b0:1ca:ab67:d75 with SMTP
 id u8-20020a17090adb4800b001caab670d75mr73985pjx.1.1649115729756; Mon, 04 Apr
 2022 16:42:09 -0700 (PDT)
Date:   Mon,  4 Apr 2022 23:41:53 +0000
In-Reply-To: <20220404234154.1251388-1-yosryahmed@google.com>
Message-Id: <20220404234154.1251388-5-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220404234154.1251388-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v2 4/5] KVM: riscv: mm: count KVM page table pages in
 pagetable stats
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     mizhang@google.com, David Matlack <dmatlack@google.com>,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-mips@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yosry Ahmed <yosryahmed@google.com>
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

Count the pages used by KVM in riscv for page tables in pagetable stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/riscv/kvm/mmu.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index f80a34fbf102..fcfb75713750 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -152,6 +152,7 @@ static int stage2_set_pte(struct kvm *kvm, u32 level,
 			next_ptep = kvm_mmu_memory_cache_alloc(pcache);
 			if (!next_ptep)
 				return -ENOMEM;
+			kvm_account_pgtable_pages((void *)next_ptep, +1);
 			*ptep = pfn_pte(PFN_DOWN(__pa(next_ptep)),
 					__pgprot(_PAGE_TABLE));
 		} else {
@@ -229,6 +230,7 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 	pte_t *next_ptep;
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
+	struct page *p;
 
 	ret = stage2_level_to_page_size(ptep_level, &page_size);
 	if (ret)
@@ -252,8 +254,13 @@ static void stage2_op_pte(struct kvm *kvm, gpa_t addr,
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			stage2_op_pte(kvm, addr + i * next_page_size,
 					&next_ptep[i], next_ptep_level, op);
-		if (op == STAGE2_OP_CLEAR)
-			put_page(virt_to_page(next_ptep));
+		if (op == STAGE2_OP_CLEAR) {
+			p = virt_to_page(next_ptep);
+			if (page_count(p) == 1)
+				kvm_account_pgtable_pages((void *)next_ptep,
+							  -1);
+			put_page(p);
+		}
 	} else {
 		if (op == STAGE2_OP_CLEAR)
 			set_pte(ptep, __pte(0));
@@ -700,25 +707,27 @@ int kvm_riscv_stage2_map(struct kvm_vcpu *vcpu,
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
 {
 	struct page *pgd_page;
+	int order;
 
 	if (kvm->arch.pgd != NULL) {
 		kvm_err("kvm_arch already initialized?\n");
 		return -EINVAL;
 	}
 
-	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
-				get_order(stage2_pgd_size));
+	order = get_order(stage2_pgd_size);
+	pgd_page = alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
 	if (!pgd_page)
 		return -ENOMEM;
 	kvm->arch.pgd = page_to_virt(pgd_page);
 	kvm->arch.pgd_phys = page_to_phys(pgd_page);
-
+	kvm_account_pgtable_pages((void *)kvm->arch.pgd, +(1UL << order));
 	return 0;
 }
 
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 {
 	void *pgd = NULL;
+	int order;
 
 	spin_lock(&kvm->mmu_lock);
 	if (kvm->arch.pgd) {
@@ -729,8 +738,11 @@ void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
 	}
 	spin_unlock(&kvm->mmu_lock);
 
-	if (pgd)
-		free_pages((unsigned long)pgd, get_order(stage2_pgd_size));
+	if (pgd) {
+		order = get_order(stage2_pgd_size);
+		kvm_account_pgtable_pages((void *)pgd, -(1UL << order));
+		free_pages((unsigned long)pgd, order);
+	}
 }
 
 void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
-- 
2.35.1.1094.g7c7d902a7c-goog

