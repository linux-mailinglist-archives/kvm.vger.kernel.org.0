Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABBD4D56A7
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 01:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345214AbiCKA1K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 19:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345196AbiCKA1F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 19:27:05 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE5181A2722
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:00 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id t10-20020a17090a5d8a00b001bed9556134so6765481pji.5
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 16:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cgeEs8BEwlCwQg4uwdq2WGFHwIysPh6phqJCR0F6k5E=;
        b=rYx7Jqj6Gy3597TptoRhJdrqs/Hp8iKZ54PUtCCP1XWegMJL6/XfhmdhJT9uBJQiWH
         ZE5h7nYGSmoHWR3jekHywiWqVqzYnIn3iMjZLs1yTffpVYvhuqxw7VtoRdHcmknboDZV
         JaGspNzGf5/qUKHlZtXWJwiljrvD4FR+upssqyDkEZueUr53Bv3WvwOj/zzr8mYfrJiq
         k7f2lf8q256HKL3Wuv3+j022awWEg8sSZdUIR/trB9Yyd6Z8krtbJm0h2i+oQ8aXL1QH
         3OLc2hD77uQGQ4LMYuHeQex2C+6qz2UP8W2rChJhSKxk3mMJLVkbpnGVBmgnfN6VoZen
         sB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cgeEs8BEwlCwQg4uwdq2WGFHwIysPh6phqJCR0F6k5E=;
        b=FJaubvKAPrXJt6cZ7jOo6B/FpTy/q3I5WZH/GFj3iOMMuMmrodkCjmoai3lZD1JcEk
         BCK13UPXoZxvCoAtL8o4Yfem093LsHAThxANls95Gj3o0RHRz+AnxphH21ewGXip5XtZ
         PCxcvvgL5aloc8nZ1qMYVUEX0AjdPLtp+l9LZQG1NndeBstmBb07wjDy/NYDjdmkV4su
         2a8Z/gb+3/s2RjZu2g/tj5r8i8tHSGQgPTwHEuhdH1cjo0WGWyhVrJmw3Lphosb2yEDp
         D6VlYwqwhIWR880C8BFh5GjgcXySrvIzfB6uCQZxrp1PdlcGzMzerAuqk63akq95xwJE
         65QA==
X-Gm-Message-State: AOAM531gsihPZ242PIxUc/lcLkaeOJxOfK08XPD1w2/ennK85jPad5YW
        ymKRWhRTCd7oevTsAy1aqGcedK9a73lpaA==
X-Google-Smtp-Source: ABdhPJy4jPXZbommb1140O0m7nX/f+s6PPe4tO5XvxEJ5QF7X5XtVfhvTF/UqH4vCyBIyTH3kSFZezPw37Zl0Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:1e10:b0:1bf:6c78:54a9 with SMTP
 id pg16-20020a17090b1e1000b001bf6c7854a9mr321715pjb.1.1646958359778; Thu, 10
 Mar 2022 16:25:59 -0800 (PST)
Date:   Fri, 11 Mar 2022 00:25:19 +0000
In-Reply-To: <20220311002528.2230172-1-dmatlack@google.com>
Message-Id: <20220311002528.2230172-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220311002528.2230172-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v2 17/26] KVM: x86/mmu: Pass access information to make_huge_page_split_spte()
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU. Huge pages
mapped by the shadow MMU may be shadowing huge pages that the guest has
disallowed execute permissions.

No functional change intended.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c    | 5 +++--
 arch/x86/kvm/mmu/spte.h    | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d10189d9c877..7294f95464a7 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -216,7 +216,8 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
+			      unsigned int access)
 {
 	u64 child_spte;
 	int child_level;
@@ -244,7 +245,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		 * When splitting to a 4K page, mark the page executable as the
 		 * NX hugepage mitigation no longer applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (is_nx_huge_page_enabled() && (access & ACC_EXEC_MASK))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..c7ccdd5c440d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
+			      unsigned int access);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 85b7bc333302..541b145b2df2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1430,7 +1430,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.35.1.723.g4982287a31-goog

