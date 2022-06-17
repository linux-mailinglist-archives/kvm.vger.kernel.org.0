Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4543754FBD3
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 19:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbiFQRBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 13:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231786AbiFQRBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 13:01:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F69F30F6B
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 10:01:35 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 31so4514608pgv.11
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 10:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SRO7S+VtYQQ7CuT0HxqPXVXaFoJKc9kcpBIC9Ny2GXE=;
        b=H/yPj2x7BlxCCt81iCpTE5EkFP3Dty/VK1bZV1z25KE/LjGyN7SXeTJT2hDinGXVsP
         yKnWD+bSnMg17PHjkfrn+c3NqZSIABspHotC46x9KpdL1XIujrP880h5/dYfIzpJqffP
         r/IGHr8StQdM9Pv4HgEjUqpIBy/hAmMbDAuwsEalh68jgIXoLI4hMSbBS9C8QKV77NWi
         1wOP8X1/Imj52YER3j06T7ncEH788Qvydm5p/zpwISDRL1jsOMw1jIGPJnqg/bFRCKJz
         J43GPBCSUETfo7/1PtSdE4Pi9GCX0J2+XuZVUwLzY3a44bo+0aQMg7lgiSVpVcOKhTf5
         hOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SRO7S+VtYQQ7CuT0HxqPXVXaFoJKc9kcpBIC9Ny2GXE=;
        b=lbh9bUTDDWm9/elG8CtpCvFAmmqLWEFlwkdLy4L38lpo//eJLlQJGneoEgRuP42tmQ
         Or7EYSAnnAMirnA/XcF5WNBDbST0gFhv2VPMlxuSd413TZfJZvLVy0BCXTQNj88i9uJa
         iNqE5pgHYO0aeooYIVN2cqjDRkPL4jE0FKAseO8Lq6azdeM/2vmoAETzmYWEXDDf1Wy7
         bvZGRK9AOrlD/0MGiq91fHn6tJYSiK4zOKmIduQAxZA+wLb5qg4l1ttw9xzt6U/UOsXI
         VtXKZciCyvY4rarILTZ7UGygJygGXlHkAUCx/3JSJ507x3Xe91mBRvG+S5S3Y5X3ZJEc
         eAZA==
X-Gm-Message-State: AJIora/6WmFM3tpjNPfOA+kPRKD8D9Qq37/txHNvAuqRJ/tPJgLCayov
        tWLa+qDKmbW0CIMDZsY9JH18+w==
X-Google-Smtp-Source: AGRyM1sFPXEURTOwpo2fql5+Md+sSZz0Ko9Lq4pBbmT0ckr/KaLsXrnXfTdc/59+n072/62ew2vEbw==
X-Received: by 2002:a63:5a13:0:b0:3c6:3d28:87e5 with SMTP id o19-20020a635a13000000b003c63d2887e5mr10117659pgb.452.1655485294325;
        Fri, 17 Jun 2022 10:01:34 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id a29-20020aa7971d000000b0051bc1865ca5sm4007529pfg.122.2022.06.17.10.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 10:01:33 -0700 (PDT)
Date:   Fri, 17 Jun 2022 17:01:30 +0000
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
Subject: Re: [PATCH v6 19/22] KVM: x86/mmu: Zap collapsible SPTEs in shadow
 MMU at all possible levels
Message-ID: <Yqyzavjp9eS9p4+m@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-20-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516232138.1783324-20-dmatlack@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022, David Matlack wrote:
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU. This
> is fine for now since KVM never creates intermediate huge pages during
> dirty logging. In other words, KVM always replaces 1GiB pages directly
> with 4KiB pages, so there is no reason to look for collapsible 2MiB
> pages.
> 
> However, this will stop being true once the shadow MMU participates in
> eager page splitting. During eager page splitting, each 1GiB is first
> split into 2MiB pages and then those are split into 4KiB pages. The
> intermediate 2MiB pages may be left behind if an error condition causes
> eager page splitting to bail early.
> 
> No functional change intended.
> 
> Reviewed-by: Peter Xu <peterx@redhat.com>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index f83de72feeac..a5d96d452f42 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6177,18 +6177,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
>  	return need_tlb_flush;
>  }
>  
> +static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
> +					   const struct kvm_memory_slot *slot)
> +{
> +	/*
> +	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1 since there's no need to zap
> +	 * pages that are already mapped at the maximum possible level.
> +	 */
> +	if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
> +			      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1,
> +			      true))

No need to wrap, "true" fits easily on the previous line.  That said, I don't see
any point in adding a helper.  It's highly unlike there will be another caller,
and IMO it's not any more readable since I have to go look at another function
when reading kvm_mmu_zap_collapsible_sptes().

With some gentle massaging, the comment can squeeze onto two lines even with the
extra level of indentation.

		/*
	 	 * Note, use KVM_MAX_HUGEPAGE_LEVEL - 1, there's no need to zap
		 * pages that are already mapped at the maximum hugepage level.
		 */
		if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
				      PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true)
			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);

> +		kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +}
> +
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>  				   const struct kvm_memory_slot *slot)
>  {
>  	if (kvm_memslots_have_rmaps(kvm)) {
>  		write_lock(&kvm->mmu_lock);
> -		/*
> -		 * Zap only 4k SPTEs since the legacy MMU only supports dirty
> -		 * logging at a 4k granularity and never creates collapsible
> -		 * 2m SPTEs during dirty logging.
> -		 */
> -		if (slot_handle_level_4k(kvm, slot, kvm_mmu_zap_collapsible_spte, true))
> -			kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +		kvm_rmap_zap_collapsible_sptes(kvm, slot);
>  		write_unlock(&kvm->mmu_lock);
>  	}
>  
> -- 
> 2.36.0.550.gb090851708-goog
> 
