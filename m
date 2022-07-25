Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAD50580828
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 01:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbiGYX0f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 19:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbiGYX0c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 19:26:32 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD00326550
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:26:31 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id ep13so843793pjb.0
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 16:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dSqaBP+fclUhK0lffZegZwrqN3mAgO796z9Jt3A4amA=;
        b=UML49fMurvLZyFwBtjiXOBGIzQHULHk7BL7jC/DGaax1tEVlXGoA9lTzcxW0QrgNB0
         +B/HK/eUOOh6ae1e+P22iX70AK0QYytPeGEERjPMzSFpcWyo8/rvkuOTfvVdsRGVM/Iw
         dwrkcuJ/fpuhl3vcMY1LIzfGB2DRGppKGLWDRlXafWiezdY/TI8rLhLl+CPGP6Wl/KSk
         yyRm4wzcFMit98kQzqSQw1Nx28nVGxIkx/MOBOtgHI5as7/W0a5676KCMBZwnNM/C6Gk
         jdQbQPsZRiaj7ayVHV5WLTRK4JxRKISh62+727XGQF05gTOtROwqTVfkYhwm0SXKP/aF
         Px6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dSqaBP+fclUhK0lffZegZwrqN3mAgO796z9Jt3A4amA=;
        b=jlEk33gpp8fLxIN/LZ89XElyhR70kQJOXhfr8A6m2bMiL8H8hDSMgEY1sW8Fxb+zq+
         u9ZV3d7Kbdg48GM5DN4rjyDlMt9jMtq6AMTJtKb0EtjONNEpwVbPrlNYseeguMTAkkLS
         970zTWZj/wu99OFccz2nc1dRr+AEFooCtraDQUIunf+qITmIV7qMfb6V21uIAbz0Z1z4
         L+kyue1eTYh44JsQv7wgxjbmCRR/xacF4apQ8/uCt6FknxxS4Xtg/f2C4Xzeq9oyvHzm
         opZ13D9mwDk11YlpLy0B1lFll5f1i8n5Rq+GfleB52ADXcNsapZRW+DSbMnp2zlb9KtQ
         w0wg==
X-Gm-Message-State: AJIora86eXtZB35sgGzZvr4qg/JOwK3t86xOqlFmxH1lvyHOmZUttoER
        5qBcQfvvToYXchMRKsSbeA4hRQ==
X-Google-Smtp-Source: AGRyM1vLrk8MsQ4ZosHzREZZYjOcrKyvGKPlR9D8veTKACocZUMp8d9g5ib8q+/YMmcvSTvn8W3+LQ==
X-Received: by 2002:a17:902:d151:b0:16d:9f18:8fb0 with SMTP id t17-20020a170902d15100b0016d9f188fb0mr37038plt.164.1658791591055;
        Mon, 25 Jul 2022 16:26:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id i1-20020a626d01000000b005254d376beasm10079146pfc.6.2022.07.25.16.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 16:26:30 -0700 (PDT)
Date:   Mon, 25 Jul 2022 23:26:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH v2 1/6] KVM: x86/mmu: Tag disallowed NX huge pages even
 if they're not tracked
Message-ID: <Yt8mo6XbT/60UcpS@google.com>
References: <20220723012325.1715714-1-seanjc@google.com>
 <20220723012325.1715714-2-seanjc@google.com>
 <Yt8eC2OyolG9QE3g@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt8eC2OyolG9QE3g@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022, David Matlack wrote:
> On Sat, Jul 23, 2022 at 01:23:20AM +0000, Sean Christopherson wrote:
> > Tag shadow pages that cannot be replaced with an NX huge page even if
> > zapping the page would not allow KVM to create a huge page, e.g. because
> > something else prevents creating a huge page.
> 
> This sentence looks messed up :). Should it read:
> 
>   Tag shadow pages that cannot be replaced with an NX huge page, e.g.
>   because something else prevents creating a huge page.
> 
> ?

Hmm, not quite.  Does this read better?

  Tag shadow pages that cannot be replaced with an NX huge page regardless
  of whether or not zapping the page would allow KVM to immediately create
  a huge page, e.g. because something else prevents creating a huge page.

What I'm trying to call out is that, today, KVM tracks pages that were disallowed
from being huge due to the NX workaround if and only if the page could otherwise
be huge.  After this patch, KVM will track pages that were disallowed regardless
of whether or they could have been huge at the time of fault.

> > +void account_nx_huge_page(struct kvm *kvm, struct kvm_mmu_page *sp,
> > +			  bool nx_huge_page_possible)
> > +{
> > +	sp->nx_huge_page_disallowed = true;
> > +
> > +	if (!nx_huge_page_possible)
> > +		untrack_possible_nx_huge_page(kvm, sp);
> 
> What would be a scenario where calling untrack_possible_nx_huge_page()
> is actually necessary here?

The only scenario that jumps to mind is the non-coherent DMA with funky MTRRs
case.  There might be others, but it's been a while since I wrote this...

The MTRRs are per-vCPU (KVM really should just track them as per-VM, but whatever),
so it's possible that KVM could encounter a fault with a lower fault->req_level
than a previous fault that set nx_huge_page_disallowed=true (and added the page
to the possible_nx_huge_pages list because it had a higher req_level).

> > @@ -5970,7 +5993,7 @@ int kvm_mmu_init_vm(struct kvm *kvm)
> >  
> >  	INIT_LIST_HEAD(&kvm->arch.active_mmu_pages);
> >  	INIT_LIST_HEAD(&kvm->arch.zapped_obsolete_pages);
> > -	INIT_LIST_HEAD(&kvm->arch.lpage_disallowed_mmu_pages);
> > +	INIT_LIST_HEAD(&kvm->arch.possible_nx_huge_pages);
> >  	spin_lock_init(&kvm->arch.mmu_unsync_pages_lock);
> >  
> >  	r = kvm_mmu_init_tdp_mmu(kvm);
> > @@ -6845,23 +6868,25 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
> 
> Can you rename this to kvm_recover_nx_huge_pages() while you're here?

Will do.

> > @@ -1134,7 +1136,7 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
> >  	spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> >  	list_add(&sp->link, &kvm->arch.tdp_mmu_pages);
> >  	if (account_nx)
> > -		account_huge_nx_page(kvm, sp);
> > +		account_nx_huge_page(kvm, sp, true);
> 
> 
> account_nx is fault->huge_page_disallowed && fault->req_level >=
> iter.level. So this is equivalent to:
> 
>   if (fault->huge_page_disallowed && fault->req_level >= iter.level)
>           account_nx_huge_page(kvm, sp, true);
> 
> Whereas __direct_map() uses:
> 
>   if (fault->is_tdp && fault->huge_page_disallowed)
>         account_nx_huge_page(vcpu->kvm, sp, fault->req_level >= it.level);
> 
> Aside from is_tdp (which you cover in another patch), why is there a
> discrepancy in the NX Huge Page accounting?

That wart gets fixed in patch 3.  Fixing the TDP MMU requires more work due to
mmu_lock being held for read and so I wanted to separate it out.  And as a minor
detail, the Fixes: from this patch predates the TDP MMU, so in a way it's kinda
sorta a different bug.

> >  	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> >  
> >  	return 0;
> > -- 
> > 2.37.1.359.gd136c6c3e2-goog
> > 
