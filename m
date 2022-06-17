Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C12454FA22
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 17:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347292AbiFQPUg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 11:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380506AbiFQPUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 11:20:34 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCBD4BB82
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 08:20:33 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q140so4316199pgq.6
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 08:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9lvtLfhK9FmnJCkjV3dLNO0hqHNedTj51KG69lT+G7U=;
        b=Cnrh4J+Enfnr9AuDAiARSUS8mUaZcnFEgSEcsP/3UOmGi7ZFakP7Lj2GtJ7HnTrwqv
         L6J6/wfxFldCidlYCZQIhOrF+sUiIK0rRRCP214gYUgZJ7L4yKYTZzRG5CmXdrBWMffR
         Akc5WcXega+OF3hbiRscqL4Ns4GZedxPJe8j/HkcuYxvxtsoVn3LwCnGxR0OABmr+NlW
         6oAEDJX+HWJuIx8+sea4NUDWVHS6om0EdHTwqcCX0PIBPigOMV+zn/JxKPP+iN+2cwzb
         Iv3dASZw4C+i3tz5KuZPaPlN6oKgslXa73WjAlmBCS9XMjU+en4eJH9i1oScyrizdAUs
         H41g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9lvtLfhK9FmnJCkjV3dLNO0hqHNedTj51KG69lT+G7U=;
        b=QNIFRB2xKSARr0wDGuqQQz3S3ZHctAgJvECohEd0wNc4mF7e7O6SlJYG2ZfeVCK7kI
         ajw2tgVtEDtF3JiQxVRSMUQzDW9/1NwewaguzICqmM3M+s0dBQfH5xkhI7czpjOg+yeA
         bhBjgXAYt8txs4F3slHlaBvyWGDrT+/oOEJgoco5aqWYL42ZROxFi1lWm4CRh0wlDY6y
         6uLIDFEfokKu94iKlDtcbY1iHZTij39S/is+LHamq8eQsDfwnhabpM7/gWgpLWVSIZdq
         YNjyngYErel2kEUKlnjouZoH/lrno9Lp2dFVDIrOENeATwmDvXuAwAuj8T0BaGIMmdA3
         y6fw==
X-Gm-Message-State: AJIora8w2CsAGYFymSLoAFT2MLJSctL/rpVxbX8CMmmNwXXv5GTW6sbU
        RfnlCi7kedLd4dwqxEZ3NTAp/A==
X-Google-Smtp-Source: AGRyM1tE4W44jfGPjBoEvzrK2Cg/RlLC/1RDwKrs0fwTi62j7Xg865cr/MrV4kkvr1ussDo8Q6fhrQ==
X-Received: by 2002:a63:8b4b:0:b0:3fc:ee1a:9574 with SMTP id j72-20020a638b4b000000b003fcee1a9574mr9555543pge.431.1655479233124;
        Fri, 17 Jun 2022 08:20:33 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b00161ac982b9esm3691318pll.185.2022.06.17.08.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 08:20:32 -0700 (PDT)
Date:   Fri, 17 Jun 2022 15:20:28 +0000
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
Subject: Re: [PATCH v6 05/22] KVM: x86/mmu: Always pass 0 for @quadrant when
 gptes are 8 bytes
Message-ID: <YqybvAdDr6JY6Cu0@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-6-dmatlack@google.com>
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
> The quadrant is only used when gptes are 4 bytes, but
> mmu_alloc_{direct,shadow}_roots() pass in a non-zero quadrant for PAE
> page directories regardless. Make this less confusing by only passing in
> a non-zero quadrant when it is actually necessary.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

One nit, otherwise

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/mmu/mmu.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 515e0b33144a..8508c4bfddb5 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3406,9 +3406,10 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, int quadrant,
>  	struct kvm_mmu_page *sp;
>  
>  	role.level = level;
> +	role.quadrant = quadrant;
>  
> -	if (role.has_4_byte_gpte)
> -		role.quadrant = quadrant;
> +	WARN_ON_ONCE(quadrant && !role.has_4_byte_gpte);
> +	WARN_ON_ONCE(role.direct && role.has_4_byte_gpte);
>  
>  	sp = kvm_mmu_get_page(vcpu, gfn, role);
>  	++sp->root_count;
> @@ -3444,7 +3445,7 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
>  		for (i = 0; i < 4; ++i) {
>  			WARN_ON_ONCE(IS_VALID_PAE_ROOT(mmu->pae_root[i]));
>  
> -			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), i,
> +			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT), 0,
>  					      PT32_ROOT_LEVEL);
>  			mmu->pae_root[i] = root | PT_PRESENT_MASK |
>  					   shadow_me_mask;
> @@ -3529,6 +3530,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  	struct kvm_mmu *mmu = vcpu->arch.mmu;
>  	u64 pdptrs[4], pm_mask;
>  	gfn_t root_gfn, root_pgd;
> +	unsigned int quadrant;
>  	hpa_t root;
>  	unsigned i;

Not really your fault, but this manages to use three different type declarations
for quadrant.  i is a bare "unsigned", quadrant an "unsigned int" here, and then
@quadrant in mmu_alloc_root() is an "int".

I suspect the "unsigned i" is originated with the "i << (30 - PAGE_SHIFT)" in
mmu_alloc_direct_roots(), though even that can't create a negative value.

Given that quadrant is tiny and "int i" is a de facto standard for iterator values,
my preference would be to opportunisticaly consolidate this to

	int quadrant, i, r;

>  	int r;
> @@ -3614,7 +3616,15 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
>  			root_gfn = pdptrs[i] >> PAGE_SHIFT;
>  		}
>  
> -		root = mmu_alloc_root(vcpu, root_gfn, i, PT32_ROOT_LEVEL);
> +		/*
> +		 * If shadowing 32-bit non-PAE page tables, each PAE page
> +		 * directory maps one quarter of the guest's non-PAE page
> +		 * directory. Othwerise each PAE page direct shadows one guest
> +		 * PAE page directory so that quadrant should be 0.
> +		 */
> +		quadrant = (mmu->cpu_role.base.level == PT32_ROOT_LEVEL) ? i : 0;
> +
> +		root = mmu_alloc_root(vcpu, root_gfn, quadrant, PT32_ROOT_LEVEL);
>  		mmu->pae_root[i] = root | pm_mask;
>  	}
>  
> -- 
> 2.36.0.550.gb090851708-goog
> 
