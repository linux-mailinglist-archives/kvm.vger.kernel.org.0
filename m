Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67529373FCF
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 18:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233998AbhEEQae (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 12:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbhEEQa3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 12:30:29 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D484C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 09:29:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id md17so1097206pjb.0
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 09:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PtDxfO21/LGxTPF9vukAcaQEKePn1czqbdVKjYC9ITI=;
        b=H1igZrphUfbsfmID/ur6C8M2xOh7l7Gt3G92KlnhVLfro5pIgDeJDgdWkeQmAPSpSg
         UnwNLZdBD0LLhI+NbN/5ZKsjCq7Rju9cNmWtIxGnqLVWXZ7ZGhcRR1UCZFx19lc5cdFU
         LHXmUFwDsl26NyYQq3zb7lz/LuKROWiQE10Bbyxt1aCBSRiuCcagrIZRUPabc5x5G6tF
         Gt4QX0eaniZJKAgKPPiqdlMrkc16GRuZFTuPrXUX1C2aLUoUFMc8gbHTQdtuI4EJ7LLN
         C0PeDVC10IJu17BfKn8AKY6uZFmnCHpItTRfjfCc7QDtJ7y6LwM6X1HMyE444BsNWzn7
         SocQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PtDxfO21/LGxTPF9vukAcaQEKePn1czqbdVKjYC9ITI=;
        b=IOsvduloC41kSr0KmKp+IB2zz9VRIgJqiyjo/a76cv9Vb1uC0UCMDZL7u/7QT9/+JF
         +QEre3lTfynjEFkJV3+f71T2hnBVhbgYORSXlmNZUYAOU0pVyHF2IMtqxY5ybpaHJ58r
         cWD7bsc/61Q3ZUNrKzPiRt2gXs8OsRxRT8LtQQvJt/PUePN1ljP0Bsvv7pbfSvkkv9hR
         t9lZ3XIjRgGcylXUAy/GH5VxfB1aXEqsMfa9ZkcRF73rSMdc2nuNZRnpDVzriNSb2us6
         I7slvo2tPxRVztE/zRwBh4b0Whwzhr98nNQqP1w77Xm9UbUORyzC8rWctNvjK2am9M+D
         dc2g==
X-Gm-Message-State: AOAM531bbUSNG1AHZVmBgd2Me7WxafBN++hqPKNSSacCakc/wX5xR8EO
        1sHFEn6YHcO+H4HnXQrw9xCBlvDenb93NA==
X-Google-Smtp-Source: ABdhPJw4Nf1+IhU1datEMsFKpfCZ4mYj242oIgI/CWIZ3H8NUbIQkSDHOQGBHqSOclCruEkja7fKnw==
X-Received: by 2002:a17:903:4091:b029:ec:fbd2:3192 with SMTP id z17-20020a1709034091b02900ecfbd23192mr31821336plc.21.1620232164837;
        Wed, 05 May 2021 09:29:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g6sm10486268pfr.213.2021.05.05.09.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 09:29:24 -0700 (PDT)
Date:   Wed, 5 May 2021 16:29:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: Re: [PATCH 2/3] KVM: x86/mmu: Fix pf_fixed count in
 tdp_mmu_map_handle_target_level()
Message-ID: <YJLH4Iyz4imfY0c2@google.com>
References: <cover.1620200410.git.kai.huang@intel.com>
 <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23b565dd3b3dfa20aea1c13bce01163f9427a237.1620200410.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 05, 2021, Kai Huang wrote:
> Currently pf_fixed is increased even when page fault requires emulation,
> or fault is spurious.  Fix by only increasing it when return value is
> RET_PF_FIXED.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 1cad4c9f7c34..debe8c3ec844 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -942,7 +942,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
>  				       rcu_dereference(iter->sptep));
>  	}
>  
> -	if (!prefault)
> +	if (!prefault && ret == RET_PF_FIXED)
>  		vcpu->stat.pf_fixed++;

Both this patch and the existing code are wrong to check prefault, and they both
deviate from the legacy MMU (both TDP and shadow) for RET_PF_EMULATE.

For prefault==true, KVM should indeed bump pf_fixed since "prefault" really means
"async page fault completed".  In that case, the original page fault from the
guest was morphed into an async page fault and stat.pf_fixed was _not_ incremented
because KVM hasn't actually fixed the fault.  The "prefault" flag is there
purely so that KVM doesn't injected a #PF into the guest in the case where the
guest unmapped the gpa while the async page fault was being handled.

For RET_PF_EMULATE, I could go either way.  On one hand, KVM is installing a
translation that accelerates future emulated MMIO, so it's kinda sorta fixing
the page fault.  On the other handle, future emulated MMIO still page faults, it
just gets handled without going through the full page fault handler.

If we do decide to omit RET_PF_EMULATE, it should be a separate patch and should
be done for all flavors of MMU.  For this patch, the correct code is:

	if (ret != RET_PF_SPURIOUS)
		vcpu->stat.pf_fixed++;

which works because "ret" cannot be RET_PF_RETRY.

Looking through the other code, KVM also fails to bump stat.pf_fixed in the fast
page fault case.  So, if we decide to fix/adjust RET_PF_EMULATE, I think it would
make sense to handle stat.pf_fixed in a common location.

The legacy MMU also prefetches on RET_PF_EMULATE, which isn't technically wrong,
but it's pretty much guaranteed to be a waste of time since prefetching only
installs SPTEs if there is a backing memslot and PFN.

Kai, if it's ok with you, I'll fold the above "ret != RET_PF_SPURIOUS" change
into a separate mini-series to address the other issues I pointed out.  I was
hoping I could paste patches for them inline and let you carry them, but moving
stat.pf_fixed handling to a common location requires additional code shuffling
because of async page faults :-/

Thanks!

>  	return ret;
> -- 
> 2.31.1
> 
