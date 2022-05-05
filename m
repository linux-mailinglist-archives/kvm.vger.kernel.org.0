Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968F351CBEC
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 00:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386206AbiEEWOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 18:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386210AbiEEWOP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 18:14:15 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676085E144
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 15:10:32 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s14so5658090plk.8
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 15:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4yANqmx2Ha2H5KKnZT4vayRpvNWYePsYuao7lny+AJM=;
        b=WbQtNTmD+Ll3JRwpNhBd4c/qZ7ZhI3rJDChU04IDGWARrptUSht8lO2pyXKueUKszR
         zxvkcbj4UNrrDCndk2TZ02kD+oFXEXd+YMm58AuZR/yxlohmpGUhM+5UKtK2plTMf4JP
         2ud5uPhWODIRQy52Jy606FlgPkZii5ykeoLbqhaIQhU7zzlfVD9xFz19uBldHEUWxpPJ
         Jr/VL/9fvFPsuu15nPzSXepo62Xn5V1fBuW2gof7fs1K332ekNk6WtgjH6NgWGkweqrS
         HXl6ELl8SE6ge/fgDMMwYR1lwCldudc4HKLmkJtBeEDLEtgkViKqaNWxT/SZqtIa5TZS
         aoww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4yANqmx2Ha2H5KKnZT4vayRpvNWYePsYuao7lny+AJM=;
        b=gq5caEYTwgk6/8WquAiK1GtxRHFbuJSF43NiXekJuAmjaWYxQuNr+Eq/vducDrRN0x
         azxEX5gxgzh4uCuw2twOQOXkm0dPrDNfyUT9+al3AaCixeGtDmBmmDWd816lF0NptVMD
         asl0ntdg9vphr8Vb5ixSODg+LI6qRz3M+Y7w5TbhvTjOLXQGWJeW5UrhN5HTa3czLLXy
         IcJTk/46XLSWHzqISgWANs7AmjusfeIBN1AHipylXvcYMibpgFdgbtUwdbPTnDQU0NTm
         66u77vUoUS8NRL5kBY2UmL8V/amm7EgRPKPXowGduE3DNvPuPqv3YST8Q/+FrUfDPqOT
         dC0Q==
X-Gm-Message-State: AOAM532bkq6QVdTV0NIKveojGdqxDN55sudw1FFH0oZ8K9pTgVs2wlEC
        1HFqtOB36UzuFMHSRI7E2xYidg==
X-Google-Smtp-Source: ABdhPJzheC8ozkQRQlg0u//bWzdNAJ7gKjw8V68pwITeoxj4Y3vaCAJqiTmLvoMgLTNgmx9kjJjymw==
X-Received: by 2002:a17:90b:4c8a:b0:1dc:6ff1:e2e1 with SMTP id my10-20020a17090b4c8a00b001dc6ff1e2e1mr436607pjb.217.1651788632009;
        Thu, 05 May 2022 15:10:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902d50c00b0015e8d4eb21csm124933plg.102.2022.05.05.15.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 15:10:31 -0700 (PDT)
Date:   Thu, 5 May 2022 22:10:28 +0000
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
Subject: Re: [PATCH v4 05/20] KVM: x86/mmu: Consolidate shadow page
 allocation and initialization
Message-ID: <YnRLVB+t0bLBeu+/@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-6-dmatlack@google.com>
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
> Consolidate kvm_mmu_alloc_page() and kvm_mmu_alloc_shadow_page() under
> the latter so that all shadow page allocation and initialization happens
> in one place.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 39 +++++++++++++++++----------------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 5582badf4947..7d03320f6e08 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1703,27 +1703,6 @@ static void drop_parent_pte(struct kvm_mmu_page *sp,
>  	mmu_spte_clear_no_track(parent_pte);
>  }
>  
> -static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, bool direct)
> -{
> -	struct kvm_mmu_page *sp;
> -
> -	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> -	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> -	if (!direct)
> -		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> -	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> -
> -	/*
> -	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> -	 * depends on valid pages being added to the head of the list.  See
> -	 * comments in kvm_zap_obsolete_pages().
> -	 */
> -	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> -	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> -	kvm_mod_used_mmu_pages(vcpu->kvm, +1);
> -	return sp;
> -}
> -
>  static void mark_unsync(u64 *spte);
>  static void kvm_mmu_mark_parents_unsync(struct kvm_mmu_page *sp)
>  {
> @@ -2100,7 +2079,23 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
>  						      struct hlist_head *sp_list,
>  						      union kvm_mmu_page_role role)
>  {
> -	struct kvm_mmu_page *sp = kvm_mmu_alloc_page(vcpu, role.direct);
> +	struct kvm_mmu_page *sp;
> +
> +	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
> +	sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
> +	if (!role.direct)
> +		sp->gfns = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_gfn_array_cache);
> +
> +	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
> +
> +	/*
> +	 * active_mmu_pages must be a FIFO list, as kvm_zap_obsolete_pages()
> +	 * depends on valid pages being added to the head of the list.  See
> +	 * comments in kvm_zap_obsolete_pages().
> +	 */
> +	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
> +	list_add(&sp->link, &vcpu->kvm->arch.active_mmu_pages);
> +	kvm_mod_used_mmu_pages(vcpu->kvm, +1);

To reduce churn later on, what about opportunistically grabbing vcpu->kvm in a
local variable in this patch?

Actually, at that point, it's a super trivial change, so you can probably just drop 

	KVM: x86/mmu: Replace vcpu with kvm in kvm_mmu_alloc_shadow_page()

and do the vcpu/kvm swap as part of

	KVM: x86/mmu: Pass memory caches to allocate SPs separately

>  	sp->gfn = gfn;
>  	sp->role = role;
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
