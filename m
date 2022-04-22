Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5208150C3BC
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 01:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232055AbiDVWQl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 18:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiDVWPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 18:15:39 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322D023E810
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:15 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y2-20020a62ce02000000b0050ac8d73c8dso6099414pfg.8
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 14:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=z0XSCH07in75tEpUNZM8MYk8qU4dimko+wjHO05t1Es=;
        b=KD9t5eTkK3NVK3tDD7GdIoPNOwREuKL7cqyJGO4kzNMZf+MFH4XlV7cjFoRKeyOu3q
         5ur3N4mfWODth+B68D1ssXTcuD3FaXVeCfIhZBY4/hMELOEAi0eyi67gBcSp+eLONfic
         XRBRAXmfx/nh6QZq1tcHVjVKsSA7JXALFLvBZp8tdkPvM3oWGpiqUyHD2Fh6PND0M+Zn
         Q9JPiPAUXvqMoSaGIAIwG1T91QRoM3EXmRYeWhrDpoSKOmQUj3iz6JDkrvXC86woQ/iy
         J25MV0v5eMnTye2IhMVWXJLmCNAEMASYimVPnIDSdbMhxV0zClWVvkMmI2OeD4YSudGA
         8RXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=z0XSCH07in75tEpUNZM8MYk8qU4dimko+wjHO05t1Es=;
        b=ptHd1aI75w1spoUVEuzHyPE476X3KU7fDCoaJ+QJnS5M4Mus68KmjPUCz3RcWqPp5g
         SZNZ97IEVccv20x+0pao8sceecYsM676AAb9Adzwo3rqi6CCU0M3hJnwNZq+FPekrfI/
         Il5wxfKejpHJk3nHPWoomHeSZP7Tw3VTdlEF48R4UVlTJmQQ5KaS7kPrXiWXGD3nBUnE
         g63I76jM4cNh1BXljzbWxPCYubziAjeFAKpmBC6FBkrvxp3HHmcVqdpkjwfr/u61rcVB
         VpLPxKotbV0EDEN2WKVy8n/NlIppmzRQRzZS7FaXXMWVpwcBwn72Q/cyGwAZ8BeXiF3G
         lmcg==
X-Gm-Message-State: AOAM532R+1kxcPRHT+4SIRfbzl/+7+hDcl86FRZtQUTtaDtwfpotFc/O
        sNyx7njIKUSgXbw/VeLGsUgh/Hc7e5u9xA==
X-Google-Smtp-Source: ABdhPJxZKsBJ5rApfD6PzIxQyIWIsTbPHIisq+LTRCOt+rp7dIyugbvbwuSo/cZL8dyJFY11MYP1ozI/a3x51Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:21c8:b0:4fd:f89f:ec0e with SMTP
 id t8-20020a056a0021c800b004fdf89fec0emr6710829pfj.83.1650661574708; Fri, 22
 Apr 2022 14:06:14 -0700 (PDT)
Date:   Fri, 22 Apr 2022 21:05:42 +0000
In-Reply-To: <20220422210546.458943-1-dmatlack@google.com>
Message-Id: <20220422210546.458943-17-dmatlack@google.com>
Mime-Version: 1.0
References: <20220422210546.458943-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v4 16/20] KVM: x86/mmu: Extend make_huge_page_split_spte() for
 the shadow MMU
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
shadowing a non-executable huge page.

To fix this, pass in the child shadow page where the huge page will be
split and derive the execution permission from the shadow page's role.
This is correct because huge pages are always split with direct shadow
page and thus the shadow page role contains the correct access
permissions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c    | 13 +++++++------
 arch/x86/kvm/mmu/spte.h    |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..9db98fbeee61 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -215,10 +215,11 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
 {
+	bool exec_allowed = sp->role.access & ACC_EXEC_MASK;
+	int child_level = sp->role.level;
 	u64 child_spte;
-	int child_level;
 
 	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
 		return 0;
@@ -227,7 +228,6 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		return 0;
 
 	child_spte = huge_spte;
-	child_level = huge_level - 1;
 
 	/*
 	 * The child_spte already has the base address of the huge page being
@@ -240,10 +240,11 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		child_spte &= ~PT_PAGE_SIZE_MASK;
 
 		/*
-		 * When splitting to a 4K page, mark the page executable as the
-		 * NX hugepage mitigation no longer applies.
+		 * When splitting to a 4K page where execution is allowed, mark
+		 * the page executable as the NX hugepage mitigation no longer
+		 * applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (exec_allowed && is_nx_huge_page_enabled())
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..921ea77f1b5e 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 566548a3efa7..110a34ca41c2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1469,7 +1469,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

