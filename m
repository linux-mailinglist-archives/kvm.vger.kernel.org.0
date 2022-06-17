Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A84954FBA6
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 18:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382922AbiFQQyW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 12:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383510AbiFQQyM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 12:54:12 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905D3A5
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:53:45 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d5so4337569plo.12
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 09:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ucCcfaYZvgorEkpHgVzhpc1Ph044LMnDSukLkvTyniw=;
        b=nihcaiHJDM3r9i2nXXSzrVufURwzvCMcvOCZH9yd+h/3rrHRfSJCcFoNS0DWDhS7/Q
         AsL7bb5sDhBfKwEze2AgqPjjAYUtMiNQn7D6pILMd68KzKKcuVFC2k1QBdAxwNB/36TQ
         X+3vM9ZcFq2aPUxht0DBdI+qtYF1H5vk1evMM1rDOwD4akbHwhelJ0LJreLIQ8gIHF58
         WMCbYq16tP3QIsyHHASfefRYIPtH/qtSdeIsvfg6XzMWzASkrx+hxHCc+dkTZZCbkzVu
         OMUyQaKqpPoQ3wBmfM9PnQKFIVrpeT3aask/QqzXBvgGR7yAAZ7GqkaTsUx94KYbZvR3
         nIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ucCcfaYZvgorEkpHgVzhpc1Ph044LMnDSukLkvTyniw=;
        b=fmc4X0bX7YWZMAm6ckoOBL+PJP8FNVL+w1JHBWnVipC7l2Ng19lMlBJz8yj1DOi5/4
         yNkpUhPt80G7MzO9j6KE/QMeF+twrOT2Wt8Wgl5hnsZlUBGuyzKBYrqOMgckb+LpAFzu
         Q+JnrDdkWEaBY7z4OqBHeWDk9aeoXlP/6LjA7d16liWXjBHccpQITBucmnWR1X2mhpVu
         9LyAp6vj0shsfeRvMTn3qmzzS0Ws0s4wPirb5fVn2NzbaZcqrX+sJcFo7lmEuu2CwPOk
         yArxb1wvFk17HiPaPOPkrxNrjF6Q8OEiV1EJTnTt9qfbQ6UBnpye8pOMHtzbWhiwilvZ
         ZcTA==
X-Gm-Message-State: AJIora+r48Ry1Z2BfotIf6aSLQuw9HlOlpKE9et7voBfSgYdxdnM1cSy
        imksP3hPma3rf+TWdqFnS9CTdA==
X-Google-Smtp-Source: AGRyM1uuSAAGC1HIcizmZrKGASWfVFm+sC7JEwZ74K9omkmMAXmeXsd2AuzE3MZ21fKHkl/c9hiRZg==
X-Received: by 2002:a17:902:aa43:b0:168:ef35:5bd9 with SMTP id c3-20020a170902aa4300b00168ef355bd9mr10260027plr.137.1655484823310;
        Fri, 17 Jun 2022 09:53:43 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p51-20020a056a0026f300b00522cdb95d1bsm3926032pfw.31.2022.06.17.09.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 09:53:42 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:53:39 +0000
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
        <kvm-riscv@lists.infradead.org>, Peter Feiner <pfeiner@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Subject: Re: [PATCH v6 17/22] KVM: x86/mmu: Cache the access bits of shadowed
 translations
Message-ID: <Yqyxk59MwjM6wzZU@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-18-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-18-dmatlack@google.com>
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

On Mon, May 16, 2022, David Matlack wrote:

Please lead with what the patch actually does, e.g. move paragraphs three and four
ito the top and reword paragraph three to be a command.  I already know what this
patch does and still had a hard time finding that information in the changelog.

> Splitting huge pages requires allocating/finding shadow pages to replace
> the huge page. Shadow pages are keyed, in part, off the guest access
> permissions they are shadowing. For fully direct MMUs, there is no
> shadowing so the access bits in the shadow page role are always ACC_ALL.
> But during shadow paging, the guest can enforce whatever access
> permissions it wants.
> 
> When KVM is resolving a fault, it walks the guest pages tables to
> determine the guest access permissions. But that is difficult to plumb
> when splitting huge pages outside of a fault context, e.g. for eager
> page splitting.
> 
> To enable eager page splitting, KVM can cache the shadowed (guest)
> access permissions whenever it updates the shadow page tables (e.g.
> during fault, or FNAME(sync_page)). In fact KVM already does this to
> cache the shadowed GFN using the gfns array in the shadow page.
> The access bits only take up 3 bits, which leaves 61 bits left over for
> gfns, which is more than enough. So this change does not require any
> additional memory.
> 
> Now that the gfns array caches more information than just GFNs, rename
> it to shadowed_translation.
> 
> While here, preemptively fix up the WARN_ON() that detects gfn
> mismatches in direct SPs. The WARN_ON() was paired with a
> pr_err_ratelimited(), which means that users could sometimes see the
> WARN without the accompanying error message. Fix this by outputting the
> error message as part of the WARN splat.

If you're going do this cleanup, I vote to make them WARN_ONCE().  If these fire,
then they are all but guaranteed to fire _a lot_ and will bring down the kernel.
Spamming the log is unlikely to help debug problems, i.e. a single splat should
be sufficient to alert a downstream debugger that a VM crash was more than likely
due to a KVM MMU bug.

> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

...

> +static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index, gfn_t gfn, u32 access)

"unsigned int access", and I would prefer that we are a bit more agressive in
wrapping, i.e. run past 80 chars only when it's silly to wrap or when not wrapping
is inarguably easier to read.

E.g. I completely agree that letting this

	sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);

is better than

	sp->shadowed_translation =
		kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);

but I'd prefer we don't end up with function prototypes that have multiple parameters
ending after 80 chars.


diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09135fcfbfcf..36176af6e4c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -743,7 +743,8 @@ static u32 kvm_mmu_page_get_access(struct kvm_mmu_page *sp, int index)
        return sp->role.access;
 }

-static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index, gfn_t gfn, u32 access)
+static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index,
+                                        gfn_t gfn, unsigned int access)
 {
        if (sp_has_gptes(sp)) {
                sp->shadowed_translation[index] = (gfn << PAGE_SHIFT) | access;
@@ -761,7 +762,8 @@ static void kvm_mmu_page_set_translation(struct kvm_mmu_page *sp, int index, gfn
             sp->gfn, kvm_mmu_page_get_gfn(sp, index), gfn);
 }

-static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index, u32 access)
+static void kvm_mmu_page_set_access(struct kvm_mmu_page *sp, int index,
+                                   unsigned int access)
 {
        gfn_t gfn = kvm_mmu_page_get_gfn(sp, index);

@@ -2201,7 +2203,8 @@ static struct kvm_mmu_page *kvm_mmu_get_shadow_page(struct kvm_vcpu *vcpu,
        return __kvm_mmu_get_shadow_page(vcpu->kvm, vcpu, &caches, gfn, role);
 }

-static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct, u32 access)
+static union kvm_mmu_page_role kvm_mmu_child_role(u64 *sptep, bool direct,
+                                                 unsigned int access)
 {
        struct kvm_mmu_page *parent_sp = sptep_to_sp(sptep);
        union kvm_mmu_page_role role;


> @@ -1054,12 +1055,15 @@ static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
>  		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
>  			continue;
>  
> -		if (gfn != sp->gfns[i]) {
> +		if (gfn != kvm_mmu_page_get_gfn(sp, i)) {

This will conflict with kvm/queue, resolution is straightforward:

		if ((!pte_access && !shadow_present_mask) ||
		    gfn != kvm_mmu_page_get_gfn(sp, i)) {

>  			drop_spte(vcpu->kvm, &sp->spt[i]);
>  			flush = true;
>  			continue;
>  		}
>  
> +		/* Update the shadowed access bits in case they changed. */
> +		kvm_mmu_page_set_access(sp, i, pte_access);
> +
>  		sptep = &sp->spt[i];
>  		spte = *sptep;
>  		host_writable = spte & shadow_host_writable_mask;
> -- 
> 2.36.0.550.gb090851708-goog
> 
