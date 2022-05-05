Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0020F51CC5B
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 00:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiEEWz1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 18:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiEEWzY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 18:55:24 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE26527FD
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 15:51:43 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c14so4799961pfn.2
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 15:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=s96H1umg/qV43/22C5Nl7ZCpsFN6ZXGIf/o3otHdHt8=;
        b=jsm2XbMzlpriHcwfe/0kOKXVy11FyfFWR1rwiMswYuBj3MK90WLoqIxsUysaUenNru
         w+Qo0MpA74zT+u8UowzpWq2pwRjUbrRRbWdeKjjmpIqM1Sb0wbIovDKg6c3RAvc6Uoad
         oLzc+INoLRj+x0uDEvn8irK06jUP/vzPL2dEwZONHsm67S/FWHN/Pewp+GP4G9rOAoyq
         2yZaiyLj+utfBZD03HEG1IEGoY4LLpKt4St/1RNK4vCDUnseQnfpDh+a+ZulwZbZIuW3
         Jjv6ico/YqIGh536YOT3DHDDnVn5iYlV6G+OI7YOTUQH7SI6As6F/lAfW1SAzJsVhC7Q
         I+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=s96H1umg/qV43/22C5Nl7ZCpsFN6ZXGIf/o3otHdHt8=;
        b=MHqrPMDIWI0ijK1vhlaOoaKUMakO6V8HOH9lWVtBNcQ3iJH4MPBCmGefMejW0fjaC1
         XkJWQ4GV3t4yiceHaEZVm35Yob6uJz73HYLmevbEF9fwJSJNbcLttEPauWylsncpJRs3
         WbPi6uo83aayxVglbC8F5IQ7MNBhP58zvHztJQqfZtkw0GxlSkP82XOh3nwDUqEeaca8
         30vP1Op2LiWSo0KYAWjdscsLdiEtAr0vMeFfcFSMZajsePmLl/HZblmmTgFbwxbJSf9b
         /3ewMWXdg2QzjKwivqhUFFtKK7Vl4oRC7PWzaR3mavBmL0uKsiaEs9Zjg5ry1KPjMSgc
         A4ew==
X-Gm-Message-State: AOAM532enFwWcAdWGTX63WxfCEdIzMneMgEMi7DJrEiabqSksqErSLim
        3K1uqUBZVlg8BVgS4axLuDn8RQ==
X-Google-Smtp-Source: ABdhPJyCAW6StWjxRVvfp7RlyOBP2jZqbrBA7pmE/nSSvQ5s4y9qix3e0nUwHDNmFnbiUshcoMsJuQ==
X-Received: by 2002:a63:1d6:0:b0:3c1:732a:3855 with SMTP id 205-20020a6301d6000000b003c1732a3855mr270000pgb.571.1651791103104;
        Thu, 05 May 2022 15:51:43 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id cq21-20020a056a00331500b0050dc76281e0sm1848870pfb.186.2022.05.05.15.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 15:51:42 -0700 (PDT)
Date:   Thu, 5 May 2022 22:51:39 +0000
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
Subject: Re: [PATCH v4 07/20] KVM: x86/mmu: Move guest PT write-protection to
 account_shadowed()
Message-ID: <YnRU+zN9T8Zf91Ei@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-8-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-8-dmatlack@google.com>
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
> Move the code that write-protects newly-shadowed guest page tables into
> account_shadowed(). This avoids a extra gfn-to-memslot lookup and is a
> more logical place for this code to live. But most importantly, this
> reduces kvm_mmu_alloc_shadow_page()'s reliance on having a struct
> kvm_vcpu pointer, which will be necessary when creating new shadow pages
> during VM ioctls for eager page splitting.
> 
> Note, it is safe to drop the role.level == PG_LEVEL_4K check since
> account_shadowed() returns early if role.level > PG_LEVEL_4K.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

>  arch/x86/kvm/mmu/mmu.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index fa7846760887..4f894db88bbf 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -807,6 +807,9 @@ static void account_shadowed(struct kvm *kvm, struct kvm_mmu_page *sp)
>  						    KVM_PAGE_TRACK_WRITE);
>  
>  	kvm_mmu_gfn_disallow_lpage(slot, gfn);
> +
> +	if (kvm_mmu_slot_gfn_write_protect(kvm, slot, gfn, PG_LEVEL_4K))
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
>  }
>  
>  void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> @@ -2100,11 +2103,9 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm_vcpu *vcpu,
>  	sp->gfn = gfn;
>  	sp->role = role;
>  	hlist_add_head(&sp->hash_link, sp_list);
> -	if (!role.direct) {
> +
> +	if (!role.direct)
>  		account_shadowed(vcpu->kvm, sp);
> -		if (role.level == PG_LEVEL_4K && kvm_vcpu_write_protect_gfn(vcpu, gfn))

Huh.  Two thoughts.

1. Can you add a patch to drop kvm_vcpu_write_protect_gfn() entirely, i.e. convert
   mmu_sync_children() to use kvm_mmu_slot_gfn_write_protect?  It's largely a moot
   point, but only because mmu_sync_children() only operates on shadow pages that
   are relevant to the current non-SMM/SMM role.  And _that_ holds true only because
   KVM does kvm_mmu_reset_context() and drops roots for the vCPU on SMM transitions.

   That'd be a good oppurtunity to move this pair into a helper:

   	slots = kvm_memslots_for_spte_role(kvm, sp->role);
	slot = __gfn_to_memslot(slots, gfn);

2. This got me thinking...  Write-protecting for shadow paging should NOT be
   associated with the vCPU or even the role.  The SMM memslots conceptually
   operate on the same guest physical memory, SMM is just given access to memory
   that is not present in the non-SMM memslots.

   If KVM creates SPTEs for non-SMM, then it needs to write-protect _all_ memslots
   that contain the relevant gfn, e.g. if the guest takes an SMI and modifies the
   non-SMM page tables, then KVM needs trap and emulate (or unsync) those writes.

   The mess "works" because no sane SMM handler (kind of a contradiction in terms)
   will modify non-SMM page tables, and vice versa.

   The entire duplicate memslots approach is flawed.  Better would have been to
   make SMM a flag and hide SMM-only memslots, not duplicated everything...

> -			kvm_flush_remote_tlbs_with_address(vcpu->kvm, gfn, 1);
> -	}
>  
>  	return sp;
>  }
> -- 
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
