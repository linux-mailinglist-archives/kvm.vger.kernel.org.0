Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3DA32C6C9
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1451105AbhCDA37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1835188AbhCCSCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 13:02:33 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69A10C061756
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 10:01:51 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id c16so4998272ply.0
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fN9kN40P4Zb0ukn4Ugrf+KcpYX4t7X0lCi/CEaratbo=;
        b=HR9HE4CMDqeLv5C4sWclwl7s5hfMoIrfjNf3jN8ZfWfTFiDoND8rTi8dzYei7fRnnG
         8CEI8u1jdw+BLbKMKrzcydeZ8f3J+72cdzt8W1IMx1C14U5S4QoCBC0kf894CuFZQ/cW
         e8ajp6S0OR4owY2zjwEKJvEMcq5VIWPKu6lwc3O1ewxsbct508b2NSMNjdofJQfRa/At
         FignDJwRpKNgc8QOw/06M9O7ZSRUo1ou6O6ktmu4veCYeAgpJxEaKMID+hmPbDst8M32
         h2iy5nEEA6V/T0ZY+PwDEBsW39qZkrIQwka+beRRpY34dEvprsIPGrg685z+N60f1Q1U
         tIWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fN9kN40P4Zb0ukn4Ugrf+KcpYX4t7X0lCi/CEaratbo=;
        b=OGLIUrUAgcKuvS7al5PRCPAIRgueQTiIjGffnuQhtmj2NQ/SFD4nq+g4M2Ztruf/LP
         /U9Gqlp1Uc3d1b0+9gupTvBmGOE3L/8IcuSmJmiZNUR7N4FkRO9APV2YfvnxRnqoE+6a
         RFiRvydBJTUl+02PYiGGzneoCyHg0XVJnQQ1lCWOQ+4Q6HiJXLw0kXLnxifDudidX03v
         /DNkXTQ/8yZv2a1iyJGxI2FfZXTN5CgOte236sZVE2ptFYEAzalYyvR8UxXx4RU8mSnL
         jPNmr8ky+m5tz64KE7vBUHjxVnVicF06a97anguwlivBWlsFc+G4Wx8gj1QP1wUs8JkZ
         qicQ==
X-Gm-Message-State: AOAM532H9bEnN+14kuSfD/A5FhlO43rSnEi38JkGFbhGyhenaBhuNlXQ
        ezM3C1of1VFl7ECEMVHBtvPJQw==
X-Google-Smtp-Source: ABdhPJxNGP2ojm9WBMUOuIrgKMhdSc9v7P8W4g6NZqjn4VtIHtI3ni07XFYu+J2/K28y5xiMoKZ5rw==
X-Received: by 2002:a17:903:22cb:b029:e5:b8b0:b935 with SMTP id y11-20020a17090322cbb02900e5b8b0b935mr211991plg.66.1614794510591;
        Wed, 03 Mar 2021 10:01:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id r15sm25659314pfh.97.2021.03.03.10.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:01:50 -0800 (PST)
Date:   Wed, 3 Mar 2021 10:01:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>, wei.w.wang@intel.com,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] KVM: x86: Expose Architectural LBR CPUID leaf
Message-ID: <YD/PB18qLqS7noKH@google.com>
References: <20210303135756.1546253-1-like.xu@linux.intel.com>
 <20210303135756.1546253-9-like.xu@linux.intel.com>
 <YD/IeTdqbK9kEDNp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YD/IeTdqbK9kEDNp@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 03, 2021, Sean Christopherson wrote:
> On Wed, Mar 03, 2021, Like Xu wrote:
> > If CPUID.(EAX=07H, ECX=0):EDX[19] is set to 1, then KVM supports Arch
> > LBRs and CPUID leaf 01CH indicates details of the Arch LBRs capabilities.
> > Currently, KVM only supports the current host LBR depth for guests,
> > which is also the maximum supported depth on the host.
> > 
> > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c   | 25 ++++++++++++++++++++++++-
> >  arch/x86/kvm/vmx/vmx.c |  2 ++
> >  2 files changed, 26 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index b4247f821277..4473324fe7be 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -450,7 +450,7 @@ void kvm_set_cpu_caps(void)
> >  		F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
> >  		F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) | F(INTEL_STIBP) |
> >  		F(MD_CLEAR) | F(AVX512_VP2INTERSECT) | F(FSRM) |
> > -		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16)
> > +		F(SERIALIZE) | F(TSXLDTRK) | F(AVX512_FP16) | F(ARCH_LBR)
> >  	);
> >  
> >  	/* TSC_ADJUST and ARCH_CAPABILITIES are emulated in software. */
> 
> ...
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 2f307689a14b..034708a3df20 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7258,6 +7258,8 @@ static __init void vmx_set_cpu_caps(void)
> >  		kvm_cpu_cap_clear(X86_FEATURE_INVPCID);
> >  	if (vmx_pt_mode_is_host_guest())
> >  		kvm_cpu_cap_check_and_set(X86_FEATURE_INTEL_PT);
> > +	if (cpu_has_vmx_arch_lbr())
> > +		kvm_cpu_cap_check_and_set(X86_FEATURE_ARCH_LBR);
> 
> Using kvm_cpu_cap_check_and_set(), which queries boot_cpu_has(), is only
> necessary if a feature is not exposed by default in kvm_set_cpu_caps().  That's
> why INTEL_PT uses it.  ARCH_LBR on the other hand is set in the "enable by
> default" mask.
> 
> That being said, it's probably a bad idea to advertise ARCH_LBR by default.  In
> the unlikely case that AMD adds support for ARCH_LBR, enable-by-default means
> guest will be able to use ARCH_LBR on old KVMs that presumably would lack support
> for ARCH_LBR on SVM.
> 
> TL;DR: omit F(ARCH_LBR) or replace it with "0 /* ARCH_LBR */".

Actually, I take that back.  It'll require changing SVM, but due to the XSS
interaction it's probably cleaner to leaf F(ARCH_LBR) as is, and do:

	if (!cpu_has_vmx_arch_lbr())
		kvm_cpu_cap_clear(X86_FEATURE_ARCH_LBR);

and then unconditionally clear the cap for SVM.  In a way, that's arguably
better documentation as it explicitly shows that SVM lacks supports.

More thoughts in the next patch...
