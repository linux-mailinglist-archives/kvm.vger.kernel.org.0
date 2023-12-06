Return-Path: <kvm+bounces-3711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EA96C807492
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 17:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 944261F21228
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 16:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1798546532;
	Wed,  6 Dec 2023 16:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJ6tfIPH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6C0DC
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 08:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701879106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+QIrSHc0OS1gT3GJGWQJ2lAnVJcygVUhXHGYVV067ts=;
	b=NJ6tfIPH4SkwYW2ik8UXkrS8gfhUg7Y8eV4idd4K+E4DZG37dE0CDbDbAfnesmOlV3SzKE
	dum2PkoOfKvvDqDr/orH+RXhOC8t1rvddYhFJKDly1/sf4cRc37YVmnAigah7/dMyv5Ojm
	1V1eTeo1A16aYUO6EobZJiwpROwna6s=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-37-5uYYzse1NlGRnT9bOhdviw-1; Wed, 06 Dec 2023 11:11:43 -0500
X-MC-Unique: 5uYYzse1NlGRnT9bOhdviw-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3334e7d1951so877946f8f.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 08:11:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701879102; x=1702483902;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+QIrSHc0OS1gT3GJGWQJ2lAnVJcygVUhXHGYVV067ts=;
        b=M+5syrWCXLHfCcUlKQ7blezXIZkD/UglhU6IWjtdCizCo/09LIluWomL49pf7aoL3g
         m7TM8IKt599DNU8y42JL4R7zPa/l3fHOw8dimP9QsZJv+DKYrdmIm+yI+TbCCcHUWdCn
         aHQNsisBsvo7eosvxqWIlC/b6IlLNJe0UGjR+NhrznVbl/uNmGisJj1eS8oZsOHZdFFD
         0ojaWhgZsMQkIosKKDNCw0Dv/e1iDs5jqP3oY4LaSSMhCA99URH7EHE5AtH+85qrWeKt
         dK3C+aD76F/JoTZAo8QsRSrBfIna+okRzH/2lpL0CCHhvVjqnVjHUiVJVtaJi2l5817k
         K0sg==
X-Gm-Message-State: AOJu0YxZyUYid77uBQlVIe3buaHZjuvkfRgZvmnqYAxHKa5R/N/76XEg
	kUJgH/mjE0yUz6i0qPf9ciUlQzl7FP5mF2YidQUrxN2SCwO7CfScslRdg41m8QU9y9IYwLdkusz
	5Oo/OEyczQubB
X-Received: by 2002:a05:6000:194f:b0:333:40e8:7697 with SMTP id e15-20020a056000194f00b0033340e87697mr423441wry.135.1701879102264;
        Wed, 06 Dec 2023 08:11:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQLBgfunVDvE5rWJp3G7NjNdXU8eyubgsURu9UsjnJkHVDnpjucEROHimsPOJSnt0b4/P9Yg==
X-Received: by 2002:a05:6000:194f:b0:333:40e8:7697 with SMTP id e15-20020a056000194f00b0033340e87697mr423428wry.135.1701879101858;
        Wed, 06 Dec 2023 08:11:41 -0800 (PST)
Received: from starship ([89.237.98.20])
        by smtp.gmail.com with ESMTPSA id r4-20020a5d52c4000000b0033363342041sm47968wrv.23.2023.12.06.08.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 08:11:41 -0800 (PST)
Message-ID: <8e7b64f06fe2a8132a8f9f76d673ac663ecfd854.camel@redhat.com>
Subject: Re: [PATCH v7 04/26] x86/fpu/xstate: Introduce
 XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
From: Maxim Levitsky <mlevitsk@redhat.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 dave.hansen@intel.com,  pbonzini@redhat.com, seanjc@google.com,
 peterz@infradead.org, chao.gao@intel.com,  rick.p.edgecombe@intel.com,
 john.allen@amd.com
Date: Wed, 06 Dec 2023 18:11:39 +0200
In-Reply-To: <888fc0db-a8de-4d42-bcd5-84479c3a8f5e@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
	 <20231124055330.138870-5-weijiang.yang@intel.com>
	 <3c16bb90532fbd2ec95b5a3d42a93bbbf77c4d37.camel@redhat.com>
	 <9a7052ca-9c67-45b5-ba23-dbd23e69722c@intel.com>
	 <5a8c870875acc5c7e72eb3e885c12d6362f45243.camel@redhat.com>
	 <888fc0db-a8de-4d42-bcd5-84479c3a8f5e@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2023-12-06 at 11:00 +0800, Yang, Weijiang wrote:
> On 12/5/2023 5:55 PM, Maxim Levitsky wrote:
> > On Fri, 2023-12-01 at 15:49 +0800, Yang, Weijiang wrote:
> > > On 12/1/2023 1:33 AM, Maxim Levitsky wrote:
> > > > On Fri, 2023-11-24 at 00:53 -0500, Yang Weijiang wrote:
> > > > > Define new XFEATURE_MASK_KERNEL_DYNAMIC set including the features can be
> > > > I am not sure though that this name is correct, but I don't know if I can
> > > > suggest a better name.
> > > It's a symmetry of XFEATURE_MASK_USER_DYNAMIC ;-)
> > > > > optionally enabled by kernel components, i.e., the features are required by
> > > > > specific kernel components. Currently it's used by KVM to configure guest
> > > > > dedicated fpstate for calculating the xfeature and fpstate storage size etc.
> > > > > 
> > > > > The kernel dynamic xfeatures now only contain XFEATURE_CET_KERNEL, which is
> > > > > supported by host as they're enabled in xsaves/xrstors operating xfeature set
> > > > > (XCR0 | XSS), but the relevant CPU feature, i.e., supervisor shadow stack, is
> > > > > not enabled in host kernel so it can be omitted for normal fpstate by default.
> > > > > 
> > > > > Remove the kernel dynamic feature from fpu_kernel_cfg.default_features so that
> > > > > the bits in xstate_bv and xcomp_bv are cleared and xsaves/xrstors can be
> > > > > optimized by HW for normal fpstate.
> > > > > 
> > > > > Suggested-by: Dave Hansen <dave.hansen@intel.com>
> > > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > > ---
> > > > >    arch/x86/include/asm/fpu/xstate.h | 5 ++++-
> > > > >    arch/x86/kernel/fpu/xstate.c      | 1 +
> > > > >    2 files changed, 5 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/arch/x86/include/asm/fpu/xstate.h b/arch/x86/include/asm/fpu/xstate.h
> > > > > index 3b4a038d3c57..a212d3851429 100644
> > > > > --- a/arch/x86/include/asm/fpu/xstate.h
> > > > > +++ b/arch/x86/include/asm/fpu/xstate.h
> > > > > @@ -46,9 +46,12 @@
> > > > >    #define XFEATURE_MASK_USER_RESTORE	\
> > > > >    	(XFEATURE_MASK_USER_SUPPORTED & ~XFEATURE_MASK_PKRU)
> > > > >    
> > > > > -/* Features which are dynamically enabled for a process on request */
> > > > > +/* Features which are dynamically enabled per userspace request */
> > > > >    #define XFEATURE_MASK_USER_DYNAMIC	XFEATURE_MASK_XTILE_DATA
> > > > >    
> > > > > +/* Features which are dynamically enabled per kernel side request */
> > > > I suggest to explain this a bit better. How about something like that:
> > > > 
> > > > "Kernel features that are not enabled by default for all processes, but can
> > > > be still used by some processes, for example to support guest virtualization"
> > > It looks good to me, will apply it in next version, thanks!
> > > 
> > > > But feel free to keep it as is or propose something else. IMHO this will
> > > > be confusing this way or another.
> > > > 
> > > > 
> > > > Another question: kernel already has a notion of 'independent features'
> > > > which are currently kernel features that are enabled in IA32_XSS but not present in 'fpu_kernel_cfg.max_features'
> > > > 
> > > > Currently only 'XFEATURE_LBR' is in this set. These features are saved/restored manually
> > > > from independent buffer (in case of LBRs, perf code cares for this).
> > > > 
> > > > Does it make sense to add CET_S to there as well instead of having XFEATURE_MASK_KERNEL_DYNAMIC,
> > > CET_S here refers to PL{0,1,2}_SSP, right?
> > > 
> > > IMHO, perf relies on dedicated code to switch LBR MSRs for various reason, e.g., overhead, the feature
> > > owns dozens of MSRs, remove xfeature bit will offload the burden of common FPU/xsave framework.
> > This is true, but the question that begs to be asked, is what is the true purpose of the 'independent features' is
> > from the POV of the kernel FPU framework. IMHO these are features that the framework is not aware of, except
> > that it enables it in IA32_XSS (and in XCR0 in the future).
> 
> This is the origin intention for introducing independent features(firstly called dynamic feature, renamed later), from the
> changelog the major concern is overhead:

Yes, and to some extent the reason why we want to have CET supervisor state not saved on normal thread's FPU state is also overhead,
because in theory if the kernel did save it, the MSRs will be in INIT state and thus XSAVES shouldn't have any functional impact,
even if it saves/restores them for nothing.

In other words, as I said, independent features = features that FPU state doesn't manage, and are just optionally enabled,
so that a custom code can do a custom xsave(s)/xrstor(s), likely from/to a custom area to save/load these features.

It might make sense to rename independent features again to something like 'unmanaged features' or 'manual features' or something
like that.


Another interesting question that arises here, is once KVM supports arch LBRs, it will likely need to expose the XFEATURE_LBR
to the guest and will need to context switch it similar to CET_S state, which strengthens the argument that CET_S should
be in the same group as the 'independent features'.

Depending on the performance impact, XFEATURE_LBR might even need to be dynamically allocated.


For the reference this is the patch series that introduced the arch LBRs to KVM:
https://www.spinics.net/lists/kvm/msg296507.html


Best regards,
	Maxim Levitsky

> 
> commit f0dccc9da4c0fda049e99326f85db8c242fd781f
> Author: Kan Liang <kan.liang@linux.intel.com>
> Date:   Fri Jul 3 05:49:26 2020 -0700
> 
>      x86/fpu/xstate: Support dynamic supervisor feature for LBR
> 
> "However, the kernel should not save/restore the LBR state component at
> each context switch, like other state components, because of the
> following unique features of LBR:
> - The LBR state component only contains valuable information when LBR
>    is enabled in the perf subsystem, but for most of the time, LBR is
>    disabled.
> - The size of the LBR state component is huge. For the current
>    platform, it's 808 bytes.
> If the kernel saves/restores the LBR state at each context switch, for
> most of the time, it is just a waste of space and cycles."
> 
> > For the guest only features, like CET_S, it is also kind of the same thing (xsave but to guest state area only).
> > I don't insist that we add CET_S to independent features, but I just gave an idea that maybe that is better
> > from complexity point of view to add CET there. It's up to you to decide.
> > 
> > Sean what do you think?
> > 
> > Best regards,
> > 	Maxim Levitsky
> > 
> > 
> > > But CET only has 3 supervisor MSRs and they need to be managed together with user mode MSRs.
> > > Enabling it in common FPU framework would make the switch/swap much easier without additional
> > > support code.
> > > 
> > > >    and maybe rename the
> > > > 'XFEATURE_MASK_INDEPENDENT' to something like 'XFEATURES_THE_KERNEL_DOESNT_CARE_ABOUT'
> > > > (terrible name, but you might think of a better name)
> > > > 
> > > > 
> > > > > +#define XFEATURE_MASK_KERNEL_DYNAMIC	XFEATURE_MASK_CET_KERNEL
> > > > > +
> > > > >    /* All currently supported supervisor features */
> > > > >    #define XFEATURE_MASK_SUPERVISOR_SUPPORTED (XFEATURE_MASK_PASID | \
> > > > >    					    XFEATURE_MASK_CET_USER | \
> > > > > diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
> > > > > index b57d909facca..ba4172172afd 100644
> > > > > --- a/arch/x86/kernel/fpu/xstate.c
> > > > > +++ b/arch/x86/kernel/fpu/xstate.c
> > > > > @@ -824,6 +824,7 @@ void __init fpu__init_system_xstate(unsigned int legacy_size)
> > > > >    	/* Clean out dynamic features from default */
> > > > >    	fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
> > > > >    	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> > > > > +	fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_KERNEL_DYNAMIC;
> > > > >    
> > > > >    	fpu_user_cfg.default_features = fpu_user_cfg.max_features;
> > > > >    	fpu_user_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;
> > > > Best regards,
> > > > 	Maxim Levitsky
> > > > 
> > > > 
> > > > 
> > > > 
> > 
> > 



