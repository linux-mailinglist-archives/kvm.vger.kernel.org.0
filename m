Return-Path: <kvm+bounces-6884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A25D383B49C
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 23:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19EDF1F243C7
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 22:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1266135A44;
	Wed, 24 Jan 2024 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OAodkzHy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E233135A42
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 22:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706135089; cv=none; b=Dfjtk3GEL1ZQFlIXP9KZ0DXFvWvIJkIXcEpLrKksHYzCKQw+AMixwWYfxoXzcHdVpc+z53gij1/XbLXH0/0Ps+MTP/yjvEAK4PpM+Xkx7/z/eXXBL/Wt3IgZEks2IeFb1THZyQFBcv9w6sXlN41VuNvnD+FF8iEp71jU9VonOE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706135089; c=relaxed/simple;
	bh=F07WrWrcJc+aqK6y40knhbK14aLSxZVS1jiyy4tF+uM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HRBlSS5qs6rBME8jeMzkBJCcNFYJM9EFDa8PZicY+x7wlEU54/fE8y9pnP565VILBdX9+FQmSwjTA4DPChGGKnPjU7BU10ZNPaqAqq8Imp/K4BLLSwKirxFiFiau8EK8pbzCQ4lvDh0bTMl3G0Roc7B2hOIlrXi5WNk9WKUWBwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OAodkzHy; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6dd80d3d419so1840841b3a.3
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 14:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706135087; x=1706739887; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7s4y9JBqG8sGQYLQqOanboOGz3nHhAEuSqvhsqFQIjU=;
        b=OAodkzHy+vyGlBb6b6u+zO9cj4TS7LitBSH7hQbXAJCckuUKqWljPDc8b0z8eEKGnC
         6RR/xvxYjydIvdrM5sVXBrNRrMsmGaOAbp88jKteqx2C6goKLheITv6FeYRb28hVMCHl
         VLuEGGKDtc6qdzLKSMxfe/y33Y0EJkyFO2Id1tfvgrQbVFWpGivGHoLOSQldCWrurYr0
         mf8HmrnXjuMEfVXvij3eRUYo0p/ogfhsQ2hmPWVUze6hilKHuW3EHE/B+BitQHGI8fLp
         CSm59/mZF69jkSUxXSiptMLg4qnEzsj8Xxot6JvL0ncRJn9jJ6s68mhx4aSps6X8lfdP
         gFrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706135087; x=1706739887;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7s4y9JBqG8sGQYLQqOanboOGz3nHhAEuSqvhsqFQIjU=;
        b=lkL0ASXxeveyOJ/7AxEbPY/QvtvxI+Y+al4svuC54+BXkFrKvUjCsMV2aR69pHrgIN
         Kop5/TSDkl6JcFFHn8xap8mYolMc/iLH9fwBKr3GUvaIsjh2eQfi8qxHMf3yjMCY0kIA
         cGo/J4rMut5fXKuW5vI0A3kD9f3a7AfVFhCB5qNmDDM+gJxjFR223cLLCuBOt5kMKMFN
         M6wvQh5PQ+cJT8KpJJDN00idV3jD3xjRmU9aHzCR2HBZnXL3yhqibhk8k3Mr1X0qeGSP
         t8t0/Qtf0cB8wQ+L0+aWl9krzZGEabfZqJanFtx3qZB91g8AumZZkpmZR6sq7bhGgHY8
         PVNw==
X-Gm-Message-State: AOJu0Yx78KN8IEUwojM1PAxYmGmV2dMoQKVojVv4d67ActQjZ6/Jc56C
	cu/018X03gPKhihqrmwtUIDn3jv+NHw4uRcD2amxe9DUltqV8L085ovzSb7V+A==
X-Google-Smtp-Source: AGHT+IHUR20K1wxsBDC/ddPt9yRSkrVV0P84aEVFp45BZWg3DAqudZXLJ3W7gaFv1/OOWQCCull48w==
X-Received: by 2002:a05:6a20:5491:b0:19c:6cae:508e with SMTP id i17-20020a056a20549100b0019c6cae508emr144215pzk.36.1706135087383;
        Wed, 24 Jan 2024 14:24:47 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id bn21-20020a056a00325500b006d99056c4edsm14409517pfb.187.2024.01.24.14.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 14:24:46 -0800 (PST)
Date: Wed, 24 Jan 2024 22:24:43 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0
 if PDCM is disabled
Message-ID: <ZbGOK9m6UKkQ38bK@google.com>
References: <20240124003858.3954822-1-mizhang@google.com>
 <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com>
 <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbGAXpFUso9JzIjo@google.com>

On Wed, Jan 24, 2024, Sean Christopherson wrote:
> On Wed, Jan 24, 2024, Aaron Lewis wrote:
> > On Wed, Jan 24, 2024 at 7:49 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > > > Reset vcpu->arch.perf_capabilities to 0 if PDCM is disabled in guest cpuid.
> > > > Without this, there is an issue in live migration. In particular, to
> > > > migrate a VM with no PDCM enabled, VMM on the source is able to retrieve a
> > > > non-zero value by reading the MSR_IA32_PERF_CAPABILITIES. However, VMM on
> > > > the target is unable to set the value. This creates confusions on the user
> > > > side.
> > > >
> > > > Fundamentally, it is because vcpu->arch.perf_capabilities as the cached
> > > > value of MSR_IA32_PERF_CAPABILITIES is incorrect, and there is nothing
> > > > wrong on the kvm_get_msr_common() which just reads
> > > > vcpu->arch.perf_capabilities.
> > > >
> > > > Fix the issue by adding the reset code in kvm_vcpu_after_set_cpuid(), i.e.
> > > > early in VM setup time.
> > > >
> > > > Cc: Aaron Lewis <aaronlewis@google.com>
> > > > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > > > ---
> > > >  arch/x86/kvm/cpuid.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > > index adba49afb5fe..416bee03c42a 100644
> > > > --- a/arch/x86/kvm/cpuid.c
> > > > +++ b/arch/x86/kvm/cpuid.c
> > > > @@ -369,6 +369,9 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> > > >       vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> > > >       vcpu->arch.reserved_gpa_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu);
> > > >
> > > > +     /* Reset MSR_IA32_PERF_CAPABILITIES guest value to 0 if PDCM is off. */
> > > > +     if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> > > > +             vcpu->arch.perf_capabilities = 0;
> > >
> > > No, this is just papering over the underlying bug.  KVM shouldn't be stuffing
> > > vcpu->arch.perf_capabilities without explicit writes from host userspace.  E.g
> > > KVM_SET_CPUID{,2} is allowed multiple times, at which point KVM could clobber a
> > > host userspace write to MSR_IA32_PERF_CAPABILITIES.  It's unlikely any userspace
> > > actually does something like that, but KVM overwriting guest state is almost
> > > never a good thing.
> > >
> > > I've been meaning to send a patch for a long time (IIRC, Aaron also ran into this?).
> > > KVM needs to simply not stuff vcpu->arch.perf_capabilities.  I believe we are
> > > already fudging around this in our internal kernels, so I don't think there's a
> > > need to carry a hack-a-fix for the destination kernel.
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 27e23714e960..fdef9d706d61 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -12116,7 +12116,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > >
> > >         kvm_async_pf_hash_reset(vcpu);
> > >
> > > -       vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
> > 
> > Yeah, that will fix the issue we are seeing.  The only thing that's
> > not clear to me is if userspace should expect KVM to set this or if
> > KVM should expect userspace to set this.  How is that generally
> > decided?
> 
> By "this", you mean the effective RESET value for vcpu->arch.perf_capabilities?
> To be consistent with KVM's CPUID module at vCPU creation, which is completely
> empty (vCPU has no PMU and no PDCM support) KVM *must* zero
> vcpu->arch.perf_capabilities.
> 
> If userspace wants a non-zero value, then userspace needs to set CPUID to enable
> PDCM and set MSR_IA32_PERF_CAPABILITIES.
> 
> MSR_IA32_ARCH_CAPABILITIES is in the same boat, e.g. a vCPU without
> X86_FEATURE_ARCH_CAPABILITIES can end up seeing a non-zero MSR value.  That too
> should be excised.
> 
hmm, does that mean KVM just allows an invalid vcpu state exist from
host point of view? I think this makes a lot of confusions on migration
where VMM on the source believes that a non-zero value from KVM_GET_MSRS
is valid and the VMM on the target will find it not true.

If we follow the suggestion by removing the initial value at vCPU
creation time, then I think it breaks the existing VMM code, since that
requires VMM to explicitly set the MSR, which I am not sure we do today.

The following code below is different. The key difference is that the
following code preserves a valid value, but this case is to not preserve
an invalid value. 

Thanks.
-Mingwei

> In a perfect world, KVM would also zero-initialize vcpu->arch.msr_platform_info,
> but that one is less obviously broken and also less obviously safe to remove.
> 
>   commit e53d88af63ab4104e1226b8f9959f1e9903da10b
>   Author:     Jim Mattson <jmattson@google.com>
>   AuthorDate: Tue Oct 30 12:20:21 2018 -0700
>   Commit:     Paolo Bonzini <pbonzini@redhat.com>
>   CommitDate: Fri Dec 14 18:00:01 2018 +0100
> 
>       kvm: x86: Don't modify MSR_PLATFORM_INFO on vCPU reset
>     
>       If userspace has provided a different value for this MSR (e.g with the
>       turbo bits set), the userspace-provided value should survive a vCPU
>       reset. For backwards compatibility, MSR_PLATFORM_INFO is initialized
>       in kvm_arch_vcpu_setup.
>     
>       Signed-off-by: Jim Mattson <jmattson@google.com>
>       Reviewed-by: Drew Schmitt <dasch@google.com>
>       Cc: Abhiroop Dabral <adabral@paloaltonetworks.com>
>       Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> In other words, KVM shouldn't define the vCPU model beyond the absolute bare
> minimum that is required by the x86 architecture (as of P6 CPUs, which is more
> or less the oldest CPU KVM can reasonably virtualize without carrying useless code).

