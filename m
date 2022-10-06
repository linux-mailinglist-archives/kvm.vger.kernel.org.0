Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184935F5DF9
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 02:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiJFApj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 20:45:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJFApa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 20:45:30 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9D9356D8
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 17:45:23 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id e13-20020a17090ab38d00b0020b06ff019aso342827pjr.0
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 17:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2gTzGEunAM1B955sLCeuUAkDsPrX87UOdJQ1JROK9rE=;
        b=YA8S8UOP8UUGVeyHGx1YXwDsNszah+0N9SWv21cgP22PMBFZ4ucyey1wdoawxzL+0t
         f1Wgy8rfuHx/U2vPCGO5/DVYREAAvfGkc9RQv4nwm6pocSdVwzpn6aO2FyGedfqSYkiD
         dRubk7lHPLcHJ4/m7u/sPIdaDQ/wSu446H30Z33li9eeYA16RvANegZGqeRByZGkupUH
         4nHyOsxXWBHMmETSatEQHrO1hXXpc2JBAUXHiw6eQMnMFOP+ZFNoFO2WwbRMhhejVoqa
         707y5irEjcaIzaZ3sw8qA9tvrKy4BIdGmwLjEI8wNp7K3PndyRJnSBa2gZOqFA+tD1xS
         6KGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2gTzGEunAM1B955sLCeuUAkDsPrX87UOdJQ1JROK9rE=;
        b=uUXIEhsoNdHs5Mz0nhBThuNDcwhz6oTgR1ea48qDxhroyY5juQzoIW5HbcHfb5cpGY
         8fWCajju5f5cS7jqYqWOOfszsYWIJE8u49EuCOADGLApQjIpKTztjwNrisFc6/z7EHj8
         GoFUjEw8W7HBKRX0PzubVXwNO82KTAr3q5i3A9OmJeSDA1l/6svcH/A7AQ69WPLo08Yj
         GReQqnbGsTmr3f+sIneiPnUSMuSoL3ZqgtqzyIEZ8JdpmFq4gq0bBgn92Zz6EdRYkmqa
         4fhl9pqNFVBT+CDIezmBWkxD5k+XErmWJJu+DP+VrxwLws/w7Ps6hlzcVmRSNCqma2tD
         ZtKQ==
X-Gm-Message-State: ACrzQf1TXdAErkIbU9kjUNEKPyrTWyAllxEtqV3J5L5YfQjligOUZo7I
        3fOzEPNQRpdIGjSOA5fC5p8RR5IZ8NE=
X-Google-Smtp-Source: AMsMyM5ax33IlzTRJtjPshSr3tiLeqkuoCzogKQ/PsI/5InfbtHqhHmzCgaNDZQVOp2DDfKb2ct8IbHOnWA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:24d4:b0:541:11bd:dd24 with SMTP id
 d20-20020a056a0024d400b0054111bddd24mr2473311pfv.66.1665017122580; Wed, 05
 Oct 2022 17:45:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  6 Oct 2022 00:45:09 +0000
In-Reply-To: <20221006004512.666529-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221006004512.666529-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006004512.666529-5-seanjc@google.com>
Subject: [PATCH 4/7] KVM: selftests: Verify parent PTE is PRESENT when getting
 child PTE
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
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

Verify the parent PTE is PRESENT when getting a child via virt_get_pte()
so that the helper can be used for getting PTEs/GPAs without losing
sanity checks that the walker isn't wandering into the weeds.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/lib/x86_64/processor.c      | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 324bf24564a1..c9649f19aca1 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -131,23 +131,28 @@ void virt_arch_pgd_alloc(struct kvm_vm *vm)
 	}
 }
 
-static void *virt_get_pte(struct kvm_vm *vm, uint64_t pt_gpa, uint64_t vaddr,
-			  int level)
+static void *virt_get_pte(struct kvm_vm *vm, uint64_t *parent_pte,
+			  uint64_t vaddr, int level)
 {
+	uint64_t pt_gpa = PTE_GET_PA(*parent_pte);
 	uint64_t *page_table = addr_gpa2hva(vm, pt_gpa);
 	int index = (vaddr >> PG_LEVEL_SHIFT(level)) & 0x1ffu;
 
+	TEST_ASSERT((*parent_pte & PTE_PRESENT_MASK) || parent_pte == &vm->pgd,
+		    "Parent PTE (level %d) not PRESENT for gva: 0x%08lx",
+		    level + 1, vaddr);
+
 	return &page_table[index];
 }
 
 static uint64_t *virt_create_upper_pte(struct kvm_vm *vm,
-				       uint64_t pt_gpa,
+				       uint64_t *parent_pte,
 				       uint64_t vaddr,
 				       uint64_t paddr,
 				       int current_level,
 				       int target_level)
 {
-	uint64_t *pte = virt_get_pte(vm, pt_gpa, vaddr, current_level);
+	uint64_t *pte = virt_get_pte(vm, parent_pte, vaddr, current_level);
 
 	if (!(*pte & PTE_PRESENT_MASK)) {
 		*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK;
@@ -197,20 +202,20 @@ void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level)
 	 * Allocate upper level page tables, if not already present.  Return
 	 * early if a hugepage was created.
 	 */
-	pml4e = virt_create_upper_pte(vm, vm->pgd, vaddr, paddr, PG_LEVEL_512G, level);
+	pml4e = virt_create_upper_pte(vm, &vm->pgd, vaddr, paddr, PG_LEVEL_512G, level);
 	if (*pml4e & PTE_LARGE_MASK)
 		return;
 
-	pdpe = virt_create_upper_pte(vm, PTE_GET_PA(*pml4e), vaddr, paddr, PG_LEVEL_1G, level);
+	pdpe = virt_create_upper_pte(vm, pml4e, vaddr, paddr, PG_LEVEL_1G, level);
 	if (*pdpe & PTE_LARGE_MASK)
 		return;
 
-	pde = virt_create_upper_pte(vm, PTE_GET_PA(*pdpe), vaddr, paddr, PG_LEVEL_2M, level);
+	pde = virt_create_upper_pte(vm, pdpe, vaddr, paddr, PG_LEVEL_2M, level);
 	if (*pde & PTE_LARGE_MASK)
 		return;
 
 	/* Fill in page table entry. */
-	pte = virt_get_pte(vm, PTE_GET_PA(*pde), vaddr, PG_LEVEL_4K);
+	pte = virt_get_pte(vm, pde, vaddr, PG_LEVEL_4K);
 	TEST_ASSERT(!(*pte & PTE_PRESENT_MASK),
 		    "PTE already present for 4k page at vaddr: 0x%lx\n", vaddr);
 	*pte = PTE_PRESENT_MASK | PTE_WRITABLE_MASK | (paddr & PHYSICAL_PAGE_MASK);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

