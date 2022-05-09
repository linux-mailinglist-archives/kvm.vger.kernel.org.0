Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9231F520239
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbiEIQ0Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 12:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238956AbiEIQ0V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 12:26:21 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F3214FCAF
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 09:22:27 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 7so12445226pga.12
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 09:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=h0BduPSlx+0DYGpcl48qYpS5kqKKQ08NtMh3QxSXYwI=;
        b=JanI5ZQydg1tdBAykjwdsFPI3CK1CwVbAt0KrqXY795qNT/V7Etv6rVxC+dyGPbEAV
         GziUvX8FGVtebKTogqpzyPQGeofN2Rg3T6iNHK6ejGDGzEpBWh3lXl+CCYPYssN94MbQ
         n3gY/+D8E8veN5qQIYAWPYX/1M0UC64rHNYGLvDhsHDZ80Cm9e5UYglbWcc/Cj5LvB1X
         gtHtYXMrhZ7rfTUhYpnNKNzSHb6kl6Uj3zo/cBe4Li6W9PLV2pGV3VFmo0dlz3aCFt1l
         Ep4A1epZ6BRdW5zx9ySp2yBXF7AFLl7bH9j9X7esz8gWCqvktjQqWznULIJpSLql5L+V
         DHjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=h0BduPSlx+0DYGpcl48qYpS5kqKKQ08NtMh3QxSXYwI=;
        b=fPsHro32HfkJbKwbMXoO5Kf1plhYD2sCGaS8d01r1cHWJU9zjLx/uPmHD88J1hV9r3
         Lpe6sTDFfa110n++cssl/pSvjHuMDiuytYomT066mPfnovw33YIX9I8ZWKAVCnjv+ivJ
         bII59UrnrFgMYpqT3bcZya71HBh1JRaVW7f7PDVM2gZ0L1/YwaZQaxgzcatTf0vp2PBR
         7ZKcjx3ARbrPYztFtJSlp0AIY3W1LsbcfYPqm3fYEy9EDzdaHs9129t4znrFJhFoUYpg
         00ibGazL9obXdHZkf6qWBJfdCq2UfCNkr9g2Ioi1qOQF9umpcPEaPrf2UMn9/8vOJYdR
         7dvQ==
X-Gm-Message-State: AOAM530ai9eNkZv6iE/2kxe5DQHNCcSzPGX4dYErNv3PwUqa3NCmtKVg
        hj5H7/M6Lzw/YRRBECShgGZt/w==
X-Google-Smtp-Source: ABdhPJwS/aqF9inY824wgySOHIECTDMrAtVZPxpl4nEz+ZeRKEi2y7w0amGxzMFqw/dLeDMc+xApRA==
X-Received: by 2002:a63:2c8a:0:b0:3c5:f760:2e36 with SMTP id s132-20020a632c8a000000b003c5f7602e36mr13796842pgs.372.1652113346392;
        Mon, 09 May 2022 09:22:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s40-20020a056a0017a800b0050dc7628146sm9006481pfg.32.2022.05.09.09.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 09:22:25 -0700 (PDT)
Date:   Mon, 9 May 2022 16:22:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>
Subject: Re: [PATCH v4 16/20] KVM: x86/mmu: Extend
 make_huge_page_split_spte() for the shadow MMU
Message-ID: <Ynk/vnHQsXnZkMGT@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-17-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-17-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022, David Matlack wrote:
> Currently make_huge_page_split_spte() assumes execute permissions can be
> granted to any 4K SPTE when splitting huge pages. This is true for the
> TDP MMU but is not necessarily true for the shadow MMU, since KVM may be
> shadowing a non-executable huge page.
> 
> To fix this, pass in the child shadow page where the huge page will be
> split and derive the execution permission from the shadow page's role.
> This is correct because huge pages are always split with direct shadow
> page and thus the shadow page role contains the correct access
> permissions.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/spte.c    | 13 +++++++------
>  arch/x86/kvm/mmu/spte.h    |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
>  3 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 4739b53c9734..9db98fbeee61 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -215,10 +215,11 @@ static u64 make_spte_executable(u64 spte)
>   * This is used during huge page splitting to build the SPTEs that make up the
>   * new page table.
>   */
> -u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
> +u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)

Rather than pass in @sp, what about passing in @role?  Then the need for
exec_allowed and child_level goes away (for whatever reason I reacted to the
"allowed" part of exec_allowed).

E.g.

---
 arch/x86/kvm/mmu/spte.c    | 11 +++++------
 arch/x86/kvm/mmu/spte.h    |  3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 9db98fbeee61..1b766e381727 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -215,10 +215,9 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
+			      int index)
 {
-	bool exec_allowed = sp->role.access & ACC_EXEC_MASK;
-	int child_level = sp->role.level;
 	u64 child_spte;

 	if (WARN_ON_ONCE(!is_shadow_present_pte(huge_spte)))
@@ -234,9 +233,9 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
 	 * split. So we just have to OR in the offset to the page at the next
 	 * lower level for the given index.
 	 */
-	child_spte |= (index * KVM_PAGES_PER_HPAGE(child_level)) << PAGE_SHIFT;
+	child_spte |= (index * KVM_PAGES_PER_HPAGE(role.level)) << PAGE_SHIFT;

-	if (child_level == PG_LEVEL_4K) {
+	if (role.level == PG_LEVEL_4K) {
 		child_spte &= ~PT_PAGE_SIZE_MASK;

 		/*
@@ -244,7 +243,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index)
 		 * the page executable as the NX hugepage mitigation no longer
 		 * applies.
 		 */
-		if (exec_allowed && is_nx_huge_page_enabled())
+		if ((role.access & ACC_EXEC_MASK) && is_nx_huge_page_enabled())
 			child_spte = make_spte_executable(child_spte);
 	}

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 921ea77f1b5e..80d36d0d9def 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, struct kvm_mmu_page *sp, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, union kvm_mmu_page_role role,
+			      int index);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 110a34ca41c2..c4c4bad69f38 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1469,7 +1469,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, sp->role, i);

 	/*
 	 * Replace the huge spte with a pointer to the populated lower level

base-commit: 721828e2397ab854b536de3ea10a9bc7962091a9
--
