Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E870E520279
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 18:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239004AbiEIQfr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 12:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238152AbiEIQfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 12:35:46 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633811053D7
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 09:31:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id fv2so13623036pjb.4
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 09:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5m6MbZqTR/K0ls/JbmsnhfS4t8Ut8ls1IozELXnIajI=;
        b=s13iOT82pVhN2fLD51n/NkSFDJD8cuLjhPlrxBexcLZ+iCv7bxql+RQW5WZNA6fFA4
         z5l+nLKe3RnRjm9mBUN+Nff6o7y8D4q/xHGhe2K9N4IqAqRDugEr/Md2q9u3/c5F/JeM
         WrKAlaJvdQA05qhUztwbpvAVjRR+Klf10Dx7bfv4TjyzmvrwjiDZ7xthVIuwaa3gbA1g
         H+JuabtImAJ4cKsXDDOmsdE/LAdlpMI8Yb6Dy91JJ0dh+3ELSh7wwaaHAoS+aTacs9DY
         zdriLZJSyn2UsZueEqG5RS1L3NnSWos5SqYxdNX5gf2T6ZYpeD3PGG4H1BBc0gN5wHud
         HzOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5m6MbZqTR/K0ls/JbmsnhfS4t8Ut8ls1IozELXnIajI=;
        b=X7lWZVFccDDWaPK4OsiWydxaunosPKP0PkOAhccvttkjejS2+7HVvE/tAN0JLLFZ2g
         KTjBGknqyQGpbPj1WsYVLIi4tnm60MWIKptiej7QmdKkdpdJSCvG0qs7ODE2cVG+Bo1F
         QgL4e4wcEzTkyRPYlLWaXgL9uSyp8nmXJm+7bWjNVuH3UQoPGcKvgALvGIG8vQbjtqOz
         WyopXfvcFRrHM896QtLpeI9MYzB5G5SO3xRbgdDRqBbw3FofkweSvtgrdYBJf8ae2wLB
         NWUgoMP4+scE3pjRExOv+k5CppF24Nb2uSNJsx4RD+4C7D8wPbZ2KlsRgVCXuAeSIOGA
         ejFA==
X-Gm-Message-State: AOAM531Sq7VNkpXoKvFg9iPW+ifkbnIUES2ARtQcvn72me52U0PVQwur
        B3uoXBFRzJFKvkuhIogLSU21fw==
X-Google-Smtp-Source: ABdhPJzGs1IwQJk/45XzTRSExCEERaP5PYcy1LzTQKkXOwouwsurcXkKRerTln5UGHN/bEbuxUUpMw==
X-Received: by 2002:a17:902:cf05:b0:156:8445:ce0f with SMTP id i5-20020a170902cf0500b001568445ce0fmr16888729plg.99.1652113910711;
        Mon, 09 May 2022 09:31:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u21-20020a17090abb1500b001d95cdb62d4sm12797700pjr.33.2022.05.09.09.31.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 09:31:50 -0700 (PDT)
Date:   Mon, 9 May 2022 16:31:46 +0000
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
Subject: Re: [PATCH v4 17/20] KVM: x86/mmu: Zap collapsible SPTEs at all
 levels in the shadow MMU
Message-ID: <YnlB8n8UMCuaCj1G@google.com>
References: <20220422210546.458943-1-dmatlack@google.com>
 <20220422210546.458943-18-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210546.458943-18-dmatlack@google.com>
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

Maybe a slight tweak to the shortlog?  "Zap collapsible SPTEs at all levels in
the shadow MMU" left me wondering "when is KVM zapping at all levels?"

  KVM: x86/mmu: Zap all possible levels in shadow MMU when collapsing SPTEs

On Fri, Apr 22, 2022, David Matlack wrote:
> Currently KVM only zaps collapsible 4KiB SPTEs in the shadow MMU (i.e.
> in the rmap). This is fine for now KVM never creates intermediate huge
> pages during dirty logging, i.e. a 1GiB page is never partially split to
> a 2MiB page.

"partially" is really confusing.  I think what you mean is that KVM can split a
1gb to a 2mb page, and not split all the way down to 4kb.  But "partially" makes
it sound like KVM ends up with a huge SPTE that is half split or something.  I
think you can just avoid that altogether and be more explicit:

  i.e. a 1GiB pager is never split to just 2MiB, dirty logging always splits
  down to 4KiB pages.

> However, this will stop being true once the shadow MMU participates in
> eager page splitting, which can in fact leave behind partially split

"partially" again.  Maybe

  which can in fact leave behind 2MiB pages after splitting 1GiB huge pages.

> huge pages. In preparation for that change, change the shadow MMU to
> iterate over all necessary levels when zapping collapsible SPTEs.
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
> index ed65899d15a2..479c581e8a96 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6098,18 +6098,25 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
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
> 2.36.0.rc2.479.g8af0fa9b8e-goog
> 
