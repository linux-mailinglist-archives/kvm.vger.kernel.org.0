Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9761355A480
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 00:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbiFXWxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 18:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXWxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 18:53:31 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5968E43EC8
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 15:53:30 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so7017814pjl.5
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 15:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tVvmPFlVYh1eywyk8X/ZOhSRyJAUFIuskvR1LEIJ1vQ=;
        b=s8He2MsJOXCaycrGX1mG1fxPyK0GY+qid/53Ua4JIpGXeMfcDd0DpeNADBbGJb0dxX
         bZiMS/Li4XNAF466IkSip2+IKEZTgaafJ+UhHRLp9YCj3k4Z0YIhNKjTOvtbFoHbC67d
         1KaAr6lnZjWTHOIswYWgxW4Ibmcarfa9HMDP8CMW76N6YEQ1Kd0EEaTAmM4o2iYvoWN6
         YiE1gTDSV6xkD8QitprAPGpVCBl4M09SZw/7BBlD/Pvzih4JcxGNFxOH6/CCA8GJ/Dvt
         Xsi8/LCcIKXN6IXFT4qthznVMO5+ArrnlP8cojvRXovuos9l7X0++8XfeJXVZqr0+vG8
         tLiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tVvmPFlVYh1eywyk8X/ZOhSRyJAUFIuskvR1LEIJ1vQ=;
        b=e8F9nOCipc6MkqceDln/+/IBu6t2rdxrXydafm6GMhhYspmtoQH5jlvG9/MfgpZalY
         YjGtTjwUI/rEfbFNNeYswnx8u3c++R4wg25Lp2M+zAZx0F3ng2ldiApZEK6wOb0OlYfg
         ZIn7T48DkfsOkgYWqUUBPeGPXe05B7MaUWq7+YHg7PCKpG3mV3oxoTqfJhH/gobdfO7X
         bYFNXAlces455LqyiPsaJauzCLcFtg7ZzjpiC5g1At2nnL5iMWhm0rqHKzRb55UWD2Pa
         gdZTpDtxli6CxoOt3kcLKgBqKliILR81VVTKWYsySs/md+XQOVYC8QC7xvgr6eL2Cw4J
         6bnw==
X-Gm-Message-State: AJIora9xuVFqKk4+lZuOkWkVkGFdMMHK0rNfLEIaanzOE+/9I3xs6zn2
        c743Iexp+QH4sNR1cz8SyweWUhAqbUE0fg==
X-Google-Smtp-Source: AGRyM1sikow0gG68DKTKWU8HtFkMlDC51Zl4CzpPGehlxEKYiexl56kpexQ5GM+J4tWOjs6aJ5EmFg==
X-Received: by 2002:a17:902:6b8c:b0:168:fee5:884 with SMTP id p12-20020a1709026b8c00b00168fee50884mr1348279plk.105.1656111209721;
        Fri, 24 Jun 2022 15:53:29 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id bj23-20020a056a00319700b0052584b69a50sm218842pfb.66.2022.06.24.15.53.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 15:53:29 -0700 (PDT)
Date:   Fri, 24 Jun 2022 22:53:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: x86/mmu: Fix wrong gfn range of tlb flushing in
 kvm_set_pte_rmapp()
Message-ID: <YrZAZXHJTsUp8yuP@google.com>
References: <cover.1656039275.git.houwenlong.hwl@antgroup.com>
 <a92b4b56116f0f71ffceab2b4ff3c03f47fd468f.1656039275.git.houwenlong.hwl@antgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a92b4b56116f0f71ffceab2b4ff3c03f47fd468f.1656039275.git.houwenlong.hwl@antgroup.com>
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

On Fri, Jun 24, 2022, Hou Wenlong wrote:
> When the spte of hupe page is dropped in kvm_set_pte_rmapp(),
> the whole gfn range covered by the spte should be flushed.
> However, rmap_walk_init_level() doesn't align down the gfn
> for new level like tdp iterator does, then the gfn used in
> kvm_set_pte_rmapp() is not the base gfn of huge page. And
> the size of gfn range is wrong too for huge page. Since
> the base gfn of huge page is more meaningful during the
> rmap walking, so align down the gfn for new level and use
> the correct size of huge page for tlb flushing in
> kvm_set_pte_rmapp().

It's also worth noting that kvm_set_pte_rmapp() is the other user of the rmap
iterators that consumes @gfn, i.e. modifying iterator->gfn is safe-ish.

> Fixes: c3134ce240eed ("KVM: Replace old tlb flush function with new one to flush a specified range.")
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
> ---
>  arch/x86/kvm/mmu/mmu.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b8a1f5b46b9d..37bfc88ea212 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -1427,7 +1427,7 @@ static bool kvm_set_pte_rmapp(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
>  	}
>  
>  	if (need_flush && kvm_available_flush_tlb_with_range()) {
> -		kvm_flush_remote_tlbs_with_address(kvm, gfn, 1);
> +		kvm_flush_remote_tlbs_with_address(kvm, gfn, KVM_PAGES_PER_HPAGE(level));
>  		return false;
>  	}
>  
> @@ -1455,7 +1455,7 @@ static void
>  rmap_walk_init_level(struct slot_rmap_walk_iterator *iterator, int level)
>  {
>  	iterator->level = level;
> -	iterator->gfn = iterator->start_gfn;
> +	iterator->gfn = iterator->start_gfn & -KVM_PAGES_PER_HPAGE(level);

Hrm, arguably this be done on start_gfn in slot_rmap_walk_init().  Having iter->gfn
be less than iter->start_gfn will be odd.

>  	iterator->rmap = gfn_to_rmap(iterator->gfn, level, iterator->slot);
>  	iterator->end_rmap = gfn_to_rmap(iterator->end_gfn, level, iterator->slot);
>  }
> -- 
> 2.31.1
> 
