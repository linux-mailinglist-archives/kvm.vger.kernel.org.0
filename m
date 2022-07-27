Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07C1583596
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 01:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231886AbiG0XVS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 19:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbiG0XVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 19:21:15 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53DD52FF7;
        Wed, 27 Jul 2022 16:21:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id v16-20020a17090abb9000b001f25244c65dso3679847pjr.2;
        Wed, 27 Jul 2022 16:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JhcMOFcvohu/f0TZ60L28EIOBtRBD87TsfU13owPfgc=;
        b=l7oWtsf85rVev9HsUgSXdOqte7Ky6Cn0ph4O7cC8vwprVWVWuRu4A3f0uVKYC/VMmA
         6DTUaRmNEBUkr+yCL17dMx0cVUxZqAiuej77JiVbzyA+xdvDKR1l48VwsYPUnIFtZ/bA
         QLOCrIkjuWPd6fih/xg70D8WrI7BsqPZE670Gx8BxLIUWvU725UXwO2nmtz4LyXgGYe6
         8S2EfRz7sEw7rEtRZ6nIAkoN+yqxjyslJ5TiQNlr0EhleuvZKmU4vt1tm/flknsLXFBD
         tzreuaFkhDj0GWoI76yxGZEzKExsGNuj4is752+GeMM8w4WTzh90Pq/kBhWSdt98/9CZ
         NQ4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JhcMOFcvohu/f0TZ60L28EIOBtRBD87TsfU13owPfgc=;
        b=6IGLkaCJGdc85PRYpcgJfeq/FJbD0X0RyNOyAFLsANJQgmuWmbrKfn1EDt7dgt5hn/
         AqoZDOIEq6hqIKMLL8scxMe3+k4d1a9eVB1pfOiBfWSzezGQ267ecgPEvBAGLyWeKpaU
         16g1mb5flWa1/A1ixPInKaH31XAKJs18LxFcqiQHWyfRxXl/MqmR9picIiYBsPhsCQ18
         x1R+G7kDJz/UY0pZTFl0Tgkj3KM0ZeEniI63HfNVeq6fhBh2CEoQHPNU0uj57HAcdTsC
         hGpvZRecKuTwQq06ldDqoVT7/pMama9e8Ym/Zt1FMclndB4vxKQVsF3UnQzCI/jJQfCK
         8Z4w==
X-Gm-Message-State: AJIora/oADPu7S1SiUFwA3swl8qRB28Z89N8AEB5MZXMD8u4HY+lo0Zc
        Af3geu8cOFzjI6awHIdTYQSQNjQZ7WCE3g==
X-Google-Smtp-Source: AGRyM1u27Jb0ZQFYhKZydIkM3CNw51tDaJeO9IuCjjTvSOFftwWcmvBWnWQncKI9GhF/JPHZPiThzw==
X-Received: by 2002:a17:902:7c04:b0:16c:2e00:395a with SMTP id x4-20020a1709027c0400b0016c2e00395amr23587517pll.123.1658964060959;
        Wed, 27 Jul 2022 16:21:00 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id 24-20020a630f58000000b00419b66846fcsm12502760pgp.91.2022.07.27.16.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 16:21:00 -0700 (PDT)
Date:   Wed, 27 Jul 2022 16:20:58 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v7 037/102] KVM: x86/mmu: Track shadow MMIO value/mask on
 a per-VM basis
Message-ID: <20220727232058.GB3669189@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <242df8a7164b593d3702b9ba94889acd11f43cbb.1656366338.git.isaku.yamahata@intel.com>
 <20220719084737.GU1379820@ls.amr.corp.intel.com>
 <c9d7f7e0665358f7352e95a7028a8779fd0531c6.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c9d7f7e0665358f7352e95a7028a8779fd0531c6.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 03:45:59PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> > @@ -337,9 +335,8 @@ u64 mark_spte_for_access_track(u64 spte)
> >  	return spte;
> >  }
> >  
> > -void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> > +void kvm_mmu_set_mmio_spte_mask(struct kvm *kvm, u64 mmio_value, u64 mmio_mask)
> >  {
> > -	BUG_ON((u64)(unsigned)access_mask != access_mask);
> >  	WARN_ON(mmio_value & shadow_nonpresent_or_rsvd_lower_gfn_mask);
> >  
> >  	if (!enable_mmio_caching)
> > @@ -366,12 +363,9 @@ void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask)
> >  	    WARN_ON(mmio_value && (__REMOVED_SPTE & mmio_mask) == mmio_value))
> >  		mmio_value = 0;
> >  
> > -	if (!mmio_value)
> > -		enable_mmio_caching = false;
> > -
> > -	shadow_mmio_value = mmio_value;
> > -	shadow_mmio_mask  = mmio_mask;
> > -	shadow_mmio_access_mask = access_mask;
> > +	kvm->arch.enable_mmio_caching = !!mmio_value;
> 
> KVM has a global enable_mmio_caching boolean, and I think we should honor it
> here (in this patch) by doing below first:
> 
> 	if (enabling_mmio_caching)
> 		mmio_value = 0;

This function already includes "if (!enable_mmio_caching) mmio_value = 0;" in
the beginning. (But not in this hunk, though).  So this patch honors the kernel
module parameter.


> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index f5fd22f6bf5f..99bce92b596e 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -5,8 +5,6 @@
> >  
> >  #include "mmu_internal.h"
> >  
> > -extern bool __read_mostly enable_mmio_caching;
> > -
> 
> Here you removed the ability to control enable_mmio_caching globally.  It's not
> something you stated to do in the changelog.  Perhaps we should still keep it,
> and enforce it in kvm_mmu_set_mmio_spte_mask() as commented above.
> 
> And in upstream KVM, it is a module parameter.  What happens to it?

Ditto.  the upstredam kvm_mmu_set_mmio_spte_mask() has
"if (!enable_mmio_caching) mmio_value = 0;" and this patch keeps it.


> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 36d2127cb7b7..52fb54880f9b 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -7,6 +7,7 @@
> >  #include "x86_ops.h"
> >  #include "tdx.h"
> >  #include "x86.h"
> > +#include "mmu.h"
> >  
> >  #undef pr_fmt
> >  #define pr_fmt(fmt) "tdx: " fmt
> > @@ -276,6 +277,9 @@ int tdx_vm_init(struct kvm *kvm)
> >  	int ret, i;
> >  	u64 err;
> >  
> > +	kvm_mmu_set_mmio_spte_mask(kvm, vmx_shadow_mmio_mask,
> > +				   vmx_shadow_mmio_mask);
> > +
> 
> I prefer to split this chunk out to another patch so this patch can be purely
> infrastructural.   In this way you can even move this patch around easily in
> this series.

Ok. I'll move it to a patch that touches TDX.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
