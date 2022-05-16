Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8186752953A
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350536AbiEPXWn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347287AbiEPXWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:22:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07B5473B1
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:18 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id g63-20020a636b42000000b003db2a3daf30so7905816pgc.22
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q0LsgOUH6fh/EMGEgMPSdRPwXrsuMMeqwhsgKGGJKHM=;
        b=sYxBRUC4xCN0gxlNhyXh4ufIMQqfDpQw9fg0VVL0zI2FMLrgq4nlCYyXlslYTTGplN
         VQrupVuKsqXc2SNFb2+VhZQRxQOvM2YnH3q3YSFqPcm692rXWSh+NUl7k+d70kZa9eBB
         wxXdK/rsf+VNmJTQrWXEeM16bukVzOiurMq+cIDEC3jlVkM7E7l/hPAPO4kMJltEVJ2+
         EQc+TESlu4v97mzryGnMTnAze7LS9b7TvaoA/H18t856AtOc1lpnM5DyaPUiUz3DwjzB
         LNs3hvGx1VHDzpqotysdCyaQw0PxsX3Spv268K6bsyFhPR8sgZ8yP/+B5u+LOfsPTGIJ
         mzfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q0LsgOUH6fh/EMGEgMPSdRPwXrsuMMeqwhsgKGGJKHM=;
        b=k/6MUtmTL0T3kuowc074lH2NdSF7k+YDpLArKdSqolaTZunnaS2Sg6xLsk70p4qplJ
         mV4OeHB3i1/9j9MtCYiChhlrP7Ky59E1nCrAmcdxGAhEObvP5bNoK1Gw0Fqv2aoGBgGq
         xWOy3Rl8sxe8g8Werm+ZIUfHicQbGHA1Ejj0/icsO51679NnlpXCxjc3Dd9pF4e+Iz1m
         4UEA+mgPsFftRd8FtJNRqewfQVFtW7p/UkcmkWmLa5n3xdqsWF28VA5tJjnfmIMBmdqL
         4CVi71U1YfZedWhh0oq0PRHW/0vwUC6rxEo2wIBRwmcv4hocTAiTjEx91/meKHAkt3da
         BGUA==
X-Gm-Message-State: AOAM531w3aL3sgJBj9HF98mLS+g41Os1egFLfWu9uLNXc2/31d/xdy+9
        EcaQ/MtlLuX2l5CYdexy0lOvhx19GQkkkg==
X-Google-Smtp-Source: ABdhPJxxVc2X+E/BqhlrQUzowWpF74AF8VV0DkGvXIAS9U+w0AyQGB7MWZQd1uKFsOcBrtNhibS7p0Bf0PvO6g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:22d2:b0:15e:a3a4:918c with SMTP
 id y18-20020a17090322d200b0015ea3a4918cmr19126527plg.36.1652743330438; Mon,
 16 May 2022 16:22:10 -0700 (PDT)
Date:   Mon, 16 May 2022 23:21:34 +0000
In-Reply-To: <20220516232138.1783324-1-dmatlack@google.com>
Message-Id: <20220516232138.1783324-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v6 18/22] KVM: x86/mmu: Extend make_huge_page_split_spte() for
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

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
shadowing a non-executable huge page.

To fix this, pass in the role of the child shadow page where the huge
page will be split and derive the execution permission from that.  This
is correct because huge pages are always split with direct shadow page
and thus the shadow page role contains the correct access permissions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c    | 16 ++++++++--------
 arch/x86/kvm/mmu/spte.h    |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b5960bbde7f7..237e8dc12993 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -244,10 +244,10 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
+			      int index)
 {
 	u64 child_spte;
-	int child_level;
 
 	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
 		return 0;
@@ -256,23 +256,23 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		return 0;
 
 	child_spte = huge_spte;
-	child_level = huge_level - 1;
 
 	/*
 	 * The child_spte already has the base address of the huge page being
 	 * split. So we just have to OR in the offset to the page at the next
 	 * lower level for the given index.
 	 */
-	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
+	child_spte |= (index * KVM_PAGES_PER_HPAGE(role.level)) << PAGE_SHIFT;
 
-	if (child_level == PG_LEVEL_4K) {
+	if (role.level == PG_LEVEL_4K) {
 		child_spte &= ~PT_PAGE_SIZE_MASK;
 
 		/*
-		 * When splitting to a 4K page, mark the page executable as the
-		 * NX hugepage mitigation no longer applies.
+		 * When splitting to a 4K page where execution is allowed, mark
+		 * the page executable as the NX hugepage mitigation no longer
+		 * applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled())
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 0127bb6e3c7d..3dada44cc066 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -425,7 +425,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role, int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 841feaa48be5..a5472ee56080 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1488,7 +1488,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp->role, i);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.36.0.550.gb090851708-goog

