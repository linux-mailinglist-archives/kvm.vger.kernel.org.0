Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC7E456038
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 17:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhKRQPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 11:15:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhKRQPV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 11:15:21 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4C2C061574
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:12:20 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id iq11so5502504pjb.3
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 08:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JtUbgJF6NuH5ekchLkHHx7uhAr5eiEYDxaa/1ZDxQZM=;
        b=iRBhWG5YmMZ8saHTlZ/Xuz0EDAF+36mnUXW9sw4XNE40qtsP9abacRjGj7c8sYEJEN
         RXbIuWjqZsO2VHrGVChvijshzPkxkBds4BrFHqRB1S3+hBj0sTAveaI1hlcsqSNT9Smq
         jC28mFTpF5iFgIIvodg94YTOjPtG4lfvEgBH8ybTeo2YZ6JL4FivN48XTr4SQiXqNRIr
         pow/xaD/Fm5PaS4WLDjH63Mi6bOt+4itX5B3TAY3F0tzBgnwAVlDU3C4MfbPRRpcloXH
         8BFnHBhpgmg0VTW2Hj8w6dRDFUcL/0usr/iVid4soYx1bKkPTGP51kRAQO7tHc5YCgqw
         JyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JtUbgJF6NuH5ekchLkHHx7uhAr5eiEYDxaa/1ZDxQZM=;
        b=Z/7p44nfRVhj5YXl2ojgcqZKzhG9ca6ASfWY0htHQJ3p4NhC3NANH3ArmlfdkR98gH
         Y/d+pn7Ssgc3L2psdrgyEtxrOyxErPZo0fNsCKs7lmri5Q2GImLAtV0swxrb+SSnKQ9v
         96IxAkjJ/eMCel5x+nZw0v72f+ycoArbGTYFvM61Nokrpeo0EQHcMDLaCofJYABQgWvQ
         SlBpfWgOtHOJsjOJCdwDw9CdhrpjcIxavT0fjTNOTqzjYdi7+mSWHCyJHOxxMDEtcO63
         DPrW373uLAWvFF4cTg8wGCdxFrnGwyr/SDnNW1weC97TTAVxyLnLBPT4vkO8PiCV/ij+
         3VbA==
X-Gm-Message-State: AOAM533Dk2c4rsQpF5oJUwQJK7B1ptq2KQC75Q18CxTUUIriytpz8cWc
        LF6I0yoFkP+QY4Fbz3zLShL02A==
X-Google-Smtp-Source: ABdhPJz/oQk2Mm80u4EHRmjaQ3+PKJloRdFqaSBeITGTV+Ei76TrbAUwoZVcNLOQ3yPldyZqefDXDQ==
X-Received: by 2002:a17:90a:49c2:: with SMTP id l2mr12111506pjm.23.1637251939046;
        Thu, 18 Nov 2021 08:12:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f29sm121048pgf.34.2021.11.18.08.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 08:12:18 -0800 (PST)
Date:   Thu, 18 Nov 2021 16:12:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3 3/4] x86/kvm: add max number of vcpus for hyperv
 emulation
Message-ID: <YZZ7Xxg5LEoCb+oK@google.com>
References: <20211116141054.17800-1-jgross@suse.com>
 <20211116141054.17800-4-jgross@suse.com>
 <YZVrDpjW0aZjFxo1@google.com>
 <bfe38122-0ddd-d9bc-4927-942b051a39c4@suse.com>
 <YZZn/iWsi2H845w6@google.com>
 <c3823bf6-dca3-515f-4657-14aac51679b3@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3823bf6-dca3-515f-4657-14aac51679b3@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, Juergen Gross wrote:
> On 18.11.21 15:49, Sean Christopherson wrote:
> > On Thu, Nov 18, 2021, Juergen Gross wrote:
> > > On 17.11.21 21:50, Sean Christopherson wrote:
> > > > > @@ -166,7 +166,7 @@ static struct kvm_vcpu *get_vcpu_by_vpidx(struct kvm *kvm, u32 vpidx)
> > > > >    	struct kvm_vcpu *vcpu = NULL;
> > > > >    	int i;
> > > > > -	if (vpidx >= KVM_MAX_VCPUS)
> > > > > +	if (vpidx >= min(KVM_MAX_VCPUS, KVM_MAX_HYPERV_VCPUS))
> > > > 
> > > > IMO, this is conceptually wrong.  KVM should refuse to allow Hyper-V to be enabled
> > > > if the max number of vCPUs exceeds what can be supported, or should refuse to create
> > > 
> > > TBH, I wasn't sure where to put this test. Is there a guaranteed
> > > sequence of ioctl()s regarding vcpu creation (or setting the max
> > > number of vcpus) and the Hyper-V enabling?
> > 
> > For better or worse (mostly worse), like all other things CPUID, Hyper-V is a per-vCPU
> > knob.  If KVM can't detect the impossible condition at compile time, kvm_check_cpuid()
> > is probably the right place to prevent enabling Hyper-V on an unreachable vCPU.
> 
> With HYPERV_CPUID_IMPLEMENT_LIMITS already returning the
> supported number of vcpus for the Hyper-V case I'm not sure
> there is really more needed.

Yep, that'll do nicely.

> The problem I'm seeing is that the only thing I can do is to
> let kvm_get_hv_cpuid() not adding the Hyper-V cpuid leaves for
> vcpus > 64. I can't return a failure, because that would
> probably let vcpu creation fail. And this is something we don't
> want, as kvm_get_hv_cpuid() is called even in the case the guest
> doesn't plan to use Hyper-V extensions.

Argh, that thing is annoying.

My vote is still to reject KVM_SET_CPUID{2} if userspace attempts to enable Hyper-V
for a vCPU when the max number of vCPUs exceeds HYPERV_CPUID_IMPLEMENT_LIMITS.  If
userspace parrots back KVM_GET_SUPPORTED_CPUID, it will specify KVM as the hypervisor,
i.e. enabling Hyper-V requires deliberate action from userspace.

The non-vCPU version of KVM_GET_SUPPORTED_HV_CPUID is not an issue, e.g. the generic
KVM_GET_SUPPORTED_CPUID also reports features that become unsupported if dependent
CPUID features are not enabled by userspace.

The discrepancy with the per-vCPU variant of kvm_get_hv_cpuid() would be unfortunate,
but IMO that ship sailed when the per-vCPU variant was added by commit 2bc39970e932
("x86/kvm/hyper-v: Introduce KVM_GET_SUPPORTED_HV_CPUID").  We can't retroactively
yank that code out, but I don't think we should be overly concerned with keeping it
100% accurate.  IMO it's perfectly fine for KVM to define the output of
KVM_GET_SUPPORTED_HV_CPUID as being garbage if the vCPU cannot possibly support
Hyper-V enlightments.  That situation isn't possible today, so there's no backwards
compatibility to worry about.
