Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85A2B4EF959
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 19:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350727AbiDAR6W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 13:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350736AbiDAR6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 13:58:19 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C128328F81E
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 10:56:28 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 77-20020a621450000000b004fa8868a49eso2020151pfu.3
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 10:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N+Yt2vLgKrZHcuNVUsOj9eJGBLy1X2SsKXkQhye+WRI=;
        b=Qr6kriferOcm7AIY4k/KBQ72DaTvRRltjRQh/5ECnhmB7SaEkrHaUEXakckg6PNkRI
         UqnATSklWc+8zALzY6JKcjXGFe1SfBq6T8EoKDzLpY6jLE2QLs0t53yQ/skVLxXtxGPc
         SbCNotOgDY1raopFMdahKZ5R9WaFB1/m5rObgP9wTILsP2yEOkos0mtBOC4YzivxawyR
         A6HVPHEPfUothLkegc9HrO+kBmoz4HMGCFgxA1bBAmyGBat3PADxzlV+wjdNE3FggTSW
         FImW+j6GQKwF5ZJexZpan7VjGim/N71Uhn5jXmS5VsRXU7NBV1T63G8bmnjgkl+Uvk8D
         elaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N+Yt2vLgKrZHcuNVUsOj9eJGBLy1X2SsKXkQhye+WRI=;
        b=B3iba0YDiT3m1QTBEGkhDXbizuoMdcW5xmYCJxZMOxohs1joAmpwPzN+8trFdnhu9H
         HwVmlcyK9y3B7VgmRDH76I1ViPi0sIW22FjHgoto4NaD0/LTaFdknqnJGM68Gt52bBJC
         VKfT5zz2I9gCmFwPs8r0apL2lsFRN+veMl7Y36HpVzhniVFuv1cHzAbLwVNFjN1332Ru
         Y8ucFgJAeqVhlH+kPR67Fsodo+IbHLBM6KdnW6Wy8xIFSi57VUPT7IKxA8ziXJUV8uMx
         rY+XBrwj/DL67IDWUj90l+GIDADmGXBaem1OhOhvspY1YibIArVXcU6xbVaDt7HO+jK3
         E/Xw==
X-Gm-Message-State: AOAM532s3kbdy1UqEPP04YI/oEQ1B0RmjAODV7TKKkBgRDq/pl9oNpZZ
        O5GnxcQjQfUp+dNEHtjD4R44ByXj12r4zA==
X-Google-Smtp-Source: ABdhPJwplQwfsWEVcDA4UHiGwuSL/A4oELiqXDjC0LjFD0RE2g1bBGBlZDUBl9Lc3mLD3IwFfsHZo9b9soqNMw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:3e44:b0:1c9:8365:5753 with SMTP
 id t4-20020a17090a3e4400b001c983655753mr13236316pjm.60.1648835788080; Fri, 01
 Apr 2022 10:56:28 -0700 (PDT)
Date:   Fri,  1 Apr 2022 17:55:48 +0000
In-Reply-To: <20220401175554.1931568-1-dmatlack@google.com>
Message-Id: <20220401175554.1931568-18-dmatlack@google.com>
Mime-Version: 1.0
References: <20220401175554.1931568-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 17/23] KVM: x86/mmu: Extend make_huge_page_split_spte() for
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU, since we may be
splitting a huge page that shadows a non-executable guest huge page.

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
index d10189d9c877..ef6537c6f5ef 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -216,10 +216,11 @@ static u64 make_spte_executable(u64 spte)
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
@@ -228,7 +229,6 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		return 0;
 
 	child_spte = huge_spte;
-	child_level = huge_level - 1;
 
 	/*
 	 * The child_spte already has the base address of the huge page being
@@ -241,10 +241,11 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
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
index a04262bc34e2..36d241405ecc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1455,7 +1455,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.35.1.1094.g7c7d902a7c-goog

