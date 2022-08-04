Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFFCA58A3DE
	for <lists+kvm@lfdr.de>; Fri,  5 Aug 2022 01:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbiHDXXu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 19:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbiHDXXs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 19:23:48 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3703E52DE1
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 16:23:47 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id z187so799050pfb.12
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 16:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1h56T+GF0bC064cXeA855D8CjIl/Gq1Kdu3reSRrqBI=;
        b=qEzRAGXdmEDfDJ+CfwhA/pwWYgR2fu9PYCiNa2nJkNLppvE4A/aGqwYoR6OKi++roG
         HIfMywN7bxEaWj5ps1VHfYbwEOkb1cbA1wmawhm2scdWlyXZUkCZ9i+uZ49/FLH2OVHU
         1UpruqnLv1jFOQoLvtAFTmlFhuZKxMWzCCu5tgUJUJ+EJ1VOuT6rSP8QEnyi1g6vL50y
         steY61/RoY+kPuu9bWf02aS5XwspwD4RSmRmO+9YxzDM+2lEYOQMNzNyTAC13Hc10pVZ
         Pa7R4hIrJ6RcXipbbk/aqTI+t/b0tZVRR2mx4RfdOQ0TIJu3lDRCpWVBbh1HI2tjks1c
         PruA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1h56T+GF0bC064cXeA855D8CjIl/Gq1Kdu3reSRrqBI=;
        b=fLRp00UBT4Yk+sV9r2E33CQAvmL6vUgOdJiaIviDvzq7VZB4WpaKAWFY0gK8paZnya
         RkZ1oq56MdObpTsWHGLeCsoD39KcBZnHcIAB0WBfD8nc2p7NpUyHuxYyAswDBZssXRsL
         xkjPyA5pMA4sePqH2v1dzjnqF69LCYmJl5R5fHAAnV5DQPBNXkMAP83SB5QZfi0nWZYI
         Z+/C04qltNP/hkkJcVp76VJVhll9kuY3G2oxXBt4dkPdDmuHcPD3u/Z3eNd3KGXa6LIX
         ckKKADmUuLpGKn56+6o05ZP2dums5P/zCoQ9ZoLmS9nbHejn7eb/YEvtH65NIl1iKClY
         Mwqg==
X-Gm-Message-State: ACgBeo3MZyoADW2b0GJ2qjckrUP/sq8yvNvdkQofpitGUkfycqMv/AbQ
        lv81iuMTbeyaP+JxIyUV0/8XvA==
X-Google-Smtp-Source: AA6agR4IWgC9IuMM9zJP8m4skrduVubby7ccpw1GNk0NMJYpp/lX6AmSa1azZp/z/oEIV7K4IuyymQ==
X-Received: by 2002:a05:6a00:2181:b0:51b:560b:dd30 with SMTP id h1-20020a056a00218100b0051b560bdd30mr3937001pfi.44.1659655426435;
        Thu, 04 Aug 2022 16:23:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id g64-20020a625243000000b0052d6ad246a4sm1550629pfb.144.2022.08.04.16.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 16:23:45 -0700 (PDT)
Date:   Thu, 4 Aug 2022 23:23:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 037/104] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE
Message-ID: <YuxU/VXlSwVip7ys@google.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <bfa4f7415a1d059bd3a4c6d14105f2baf2d03ba6.1651774250.git.isaku.yamahata@intel.com>
 <YuxOHPpkhKnnstqw@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuxOHPpkhKnnstqw@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, David Matlack wrote:
> On Thu, May 05, 2022 at 11:14:31AM -0700, isaku.yamahata@intel.com wrote:
> > +static inline void kvm_init_shadow_page(void *page)
> > +{
> > +#ifdef CONFIG_X86_64
> > +	int ign;
> > +
> > +	WARN_ON_ONCE(shadow_nonpresent_value != SHADOW_NONPRESENT_VALUE);
> > +	asm volatile (
> > +		"rep stosq\n\t"
> > +		: "=c"(ign), "=D"(page)
> > +		: "a"(SHADOW_NONPRESENT_VALUE), "c"(4096/8), "D"(page)
> > +		: "memory"
> > +	);
> 
> Use memset64()?

Huh.  The optimized x86-64 versions were added in 2017 (4c51248533ad ("x86: implement
memset16, memset32 & memset64"), so I can't even claim I wrote this before there
was a perfect fit.

> > @@ -5643,7 +5687,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
> >  	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
> >  	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
> >  
> > -	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> > +	if (!(is_tdp_mmu_enabled(vcpu->kvm) && shadow_nonpresent_value))
> > +		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
> 
> Is there any reason to prefer using __GFP_ZERO? I suspect the code would
> be simpler if KVM unconditionally initialized shadow pages.

Hmm, we'd have to implement kvm_init_shadow_page() for 32-bit builds, and I don't
love having "gfp_zero" but not using it when we need zeros, but if the end result
is simpler, I'm definitely ok with omitting __GFP_ZERO and always flowing through
kvm_init_shadow_page().

> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index fbbab180395e..3319ca7f8f48 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -140,6 +140,19 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
> >  
> >  #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
> >  
> > +/*
> > + * non-present SPTE value for both VMX and SVM for TDP MMU.
> > + * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
> > + * For VMX EPT, bit 63 is ignored if #VE is disabled.
> > + *              bit 63 is #VE suppress if #VE is enabled.
> > + */
> > +#ifdef CONFIG_X86_64
> > +#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
> > +static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
> > +#else
> > +#define SHADOW_NONPRESENT_VALUE	0ULL
> > +#endif
> 
> The terminology "shadow_nonpresent" implies it would be the opposite of
> e.g.  is_shadow_present_pte(), when in fact they are completely
> different concepts.

You can fight Paolo over that one :-)  I agree it looks a bit odd when juxtaposed
with is_shadow_present_pte(), but at the same time I agree with Paolo that
SHADOW_INIT_VALUE is also funky.

https://lore.kernel.org/all/9dfc44d6-6b20-e864-8d4f-09ab7d489b97@redhat.com

> Also, this is a good opportunity to follow the same naming terminology
> as REMOVED_SPTE in the TDP MMU.
> 
> How about EMPTY_SPTE?

No, because "empty" implies there's nothing there, and it very much matters that
the SUPPRESS_VE bit is set for TDX.
