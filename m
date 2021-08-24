Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 723D83F6327
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 18:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233659AbhHXQtd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 12:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbhHXQtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 12:49:22 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324BAC0617A8
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 09:48:38 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id n18so20328536pgm.12
        for <kvm@vger.kernel.org>; Tue, 24 Aug 2021 09:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m9zx9wPkQsVwuuFwnbs+K5JFN1HzrSIu6c5FttUeBTs=;
        b=Yx207EI3mkGQZ1fi5+Tt2VgC0a/NIK7O33psWgm2LM+oVVyiYo/RYMBuqq24/BXGH1
         F9kZf2AsUo7b2yBXdXL8ISdPfp/0o8RNci9/l/7AX9wfDxYaaYdH9ILTM9RSL8t+BfMO
         YiWwKctmpntJM3QYMp5Kx24m1ym+pxzBQ2LQVghWAPcBhgh76uoBeGT9zTscqpEpsO9V
         VDX9g1XqvjfODfLlgp21dCGdICSt0nj1La2tprevpKyyU2ZfMsqAzHqjq9GFHjT2z1f+
         5LX1z0YveYphXc+fmYfhsYfWoA+UvMMx2xebPfWOgdCBV9efprgd766j9AaIlp7ysnF1
         V72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m9zx9wPkQsVwuuFwnbs+K5JFN1HzrSIu6c5FttUeBTs=;
        b=I1jsuAhXLSP3TEqnUHerLFg+hUULPoFQmyhLCPLXusvJzOQ8AFGlFB4uJuwnoGunv1
         QcN6dB82t07bNi4tlh0qUrBuqBVE4w3uw3mYPiUXR+2iQHo4y4tuIH9hSgfidHcwDAON
         xBrSmISdnKeRFJKtoAOpzPCLg4qWQG1T+x7hCB6h/vMmCMFua9D2tURg0vMzIDsjT9Oi
         i2QJTrmLcIK1z++uKIaxwLTs/9tMGTmrYYFsjllboXNLiXSc7iU9U5qTsUhXFlffPFnC
         BBb7fuqEx+x9QmiCFqzGAztK0CXFlFnDX/f93FfZOomgES9qABWG+XNw3f5PG/LlCGjl
         wkJg==
X-Gm-Message-State: AOAM530JqhHzQcqlLjDD8/tjY/NXpti2gJhaZ738M9dNZaFIOnkplxRg
        sfAL2lvC2n6jEuydkBk2ILaw7g==
X-Google-Smtp-Source: ABdhPJycSIiwd3j+2gWwhiF5A2vaSNO1KlHn04eDxrgllpC2n1y44TKvs9d77r4ajcqQ3u53q9H3XA==
X-Received: by 2002:a63:ef12:: with SMTP id u18mr37413412pgh.331.1629823717428;
        Tue, 24 Aug 2021 09:48:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z131sm20601519pfc.159.2021.08.24.09.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 09:48:36 -0700 (PDT)
Date:   Tue, 24 Aug 2021 16:48:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] KVM: VMX: Disallow PT MSRs accessing if PT is not
 exposed to guest
Message-ID: <YSUi3/qLiOkKxjRC@google.com>
References: <20210824110743.531127-1-xiaoyao.li@intel.com>
 <20210824110743.531127-5-xiaoyao.li@intel.com>
 <YSUALsBF8rKNPiaS@google.com>
 <8b53fc19-c3cc-d11f-37e3-70fc0639878d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b53fc19-c3cc-d11f-37e3-70fc0639878d@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021, Xiaoyao Li wrote:
> On 8/24/2021 10:20 PM, Sean Christopherson wrote:
> > On Tue, Aug 24, 2021, Xiaoyao Li wrote:
> > > Per SDM, it triggers #GP for all the accessing of PT MSRs, if
> > > X86_FEATURE_INTEL_PT is not available.
> > > 
> > > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > > ---
> > >   arch/x86/kvm/vmx/vmx.c | 20 ++++++++++++++------
> > >   1 file changed, 14 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 4a70a6d2f442..1bbc4d84c623 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -1010,9 +1010,16 @@ static unsigned long segment_base(u16 selector)
> > >   static inline bool pt_can_write_msr(struct vcpu_vmx *vmx)
> > >   {
> > >   	return vmx_pt_mode_is_host_guest() &&
> > > +	       guest_cpuid_has(&vmx->vcpu, X86_FEATURE_INTEL_PT) &&
> > >   	       !(vmx->pt_desc.guest.ctl & RTIT_CTL_TRACEEN);
> > >   }
> > > +static inline bool pt_can_read_msr(struct kvm_vcpu *vcpu)
> > > +{
> > > +	return vmx_pt_mode_is_host_guest() &&
> > > +	       guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT);
> > > +}
> > > +
> > >   static inline bool pt_output_base_valid(struct kvm_vcpu *vcpu, u64 base)
> > >   {
> > >   	/* The base must be 128-byte aligned and a legal physical address. */
> > > @@ -1849,24 +1856,24 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >   							&msr_info->data);
> > >   		break;
> > >   	case MSR_IA32_RTIT_CTL:
> > > -		if (!vmx_pt_mode_is_host_guest())
> > > +		if (!pt_can_read_msr(vcpu))
> > 
> > These all need to provide exemptions for accesses from the host.  KVM allows
> > access to MSRs that are not exposed to the guest so long as all the other checks
> > pass.
> 
> Not all the MSRs are allowed to be accessed from host regardless of whether
> it's exposed to guest. e.g., MSR_IA32_TSC_ADJUST, it checks guest CPUID
> first.
> 
> For me, for those PT MSRs, I cannot think of any reason that host/userspace
> would access them without PT being exposed to guest.

Order of operations.  Userspace is allowed to do KVM_GET/SET_MSR before
KVM_SET_CPUID2.

> On the other hand, since this patch indeed breaks the existing userspace VMM
> who accesses those MSRs without checking guest CPUID.
> 
> So I will follow your advice to allow the host_initiated case in next
> version.
> 
> > Same for the next patch.
> 
> Sorry, I don't know how it matters next patch.

Me either.  Ignore that comment. :-)
