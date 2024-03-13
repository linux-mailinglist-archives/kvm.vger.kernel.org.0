Return-Path: <kvm+bounces-11755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF9D387AFFE
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 19:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2CE91C25ED4
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 18:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2248D84A5C;
	Wed, 13 Mar 2024 17:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yb8Nnsa8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B01634FF
	for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710351035; cv=none; b=WdEMqERl4DMAIn8g4Y4P7OnqNPYAHu/5mKr2ovHtEnrpI+vklaNbXpntKxQa534r/tW3m90DoXDBUZs2ihJjDSR280oJM98IopsCaUL4zjEPJ17EdKIoSlm695zNv1JH/48rutwqcAjKfJCkc4iKAUoDJ+mVCJv1ZWrbnSZL/Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710351035; c=relaxed/simple;
	bh=mQK451AsPUWoNGu5tQADsqz6lNGCGwlzWicoSCxfOds=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nIqzCX4oiRTRLyPtEzL3axlZYLWLvjv1XczwZx6Lix81bfeXzOHOXjmMEeW8j65aUsJ/YU75U8bc1pD//3Hs6m6tXm5Kw+s46/sNrGv+EklAQjfPgoa0cnMsO/bbOv6JmrcDHf0STjGrdwyK8n/uC1hxoVsHXz2zQu/K4Ueie0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yb8Nnsa8; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1ddbad556a8so350155ad.3
        for <kvm@vger.kernel.org>; Wed, 13 Mar 2024 10:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710351033; x=1710955833; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FlLkhEe/0D5rW6ngXULURvSkbqIjDZBghD0r9MHVOtc=;
        b=Yb8Nnsa8fdv8TEJkT3ptAc9ZMHslYnkF3FGqaVxsmxQ/WzfBajk++fZaUa2sVh8PlF
         YTdAXY5VFgOGCYcNJwa833cpgOkjXDPtaGvZlqkFiEK0U1Yck3otiVr1YCiv5jcMxlRl
         zHk1eF8sHSgqf0lkqKLTTbuXn9ACKMPE0AtiB5AvZMXrOnaqrqdjM0wo7mJKVjQQAkdt
         KL5MHHW+EYAk6drRXcFganZfFLFx7RVb1VwUdfr8D17juqyPP9cXZ2uHwAtVqLOWJEuI
         CXigYqvhTSqkPIOMpWZHwPWEAKiTUYYyh/Fj7bFoKf3OG+fZccsF39Ndcm6PzCcnZq4r
         Kijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710351033; x=1710955833;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FlLkhEe/0D5rW6ngXULURvSkbqIjDZBghD0r9MHVOtc=;
        b=eSH8brA7LVmaoJSTPSA0oDXOLiKJv+ZPrghWwN/wpYfNOL/bSFRutUer8mS5WgKx7T
         dYZe9MI4aAmxMdzH46VGKpRHqIjmVBMAWQzWyLJApcC3Bu3z43ifU1xfIftYF8LIksGl
         roGBlTqz6Y5vtXgOoSkPdZbDP591MfMh6q3Y9avF2jCszn9XwVk78L6vwveKdWn0hukk
         TBVfEW8W7stGpH/9a0tN5XCOqd38KUZIncx+S43jXXTWBotmpuHww2jEpLWqh2q2dAK4
         1eeQhZbQNxURUUtrgdLBDzFwqUVn2Qaov/0GUnM94pB59/zQdyAESf8dxStitoU7Me46
         gHAQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1lbH3QSNAEWgZDlMEWaNJzYmV9OuPkyfOYSEzyUeK1VjtZtjhl7HhmiIXK4Fyt5osQRC/PcaNsKLSZIcfu0YS6C/G
X-Gm-Message-State: AOJu0YwifADR1kDxUXbREYtIYaLKDlxE8wSopeAeIM4b1iR0f2Lw90Gt
	4B61E3N0e5H6USm11IwVqs+kDbfxJV9foOej807weM5kuU+cmX4VEaW04Px7eg==
X-Google-Smtp-Source: AGHT+IFVyHBcjaoHp5u3gjWValua5wG3aHh6kxQ2DzTMvQHWnOQyAZbWjWCIBkbZD3QkB6MBrYydLQ==
X-Received: by 2002:a17:902:cec7:b0:1dd:9090:a36b with SMTP id d7-20020a170902cec700b001dd9090a36bmr11723705plg.4.1710351032699;
        Wed, 13 Mar 2024 10:30:32 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id ko16-20020a17090307d000b001d9d4375149sm8970398plb.215.2024.03.13.10.30.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Mar 2024 10:30:31 -0700 (PDT)
Date: Wed, 13 Mar 2024 17:30:27 +0000
From: Mingwei Zhang <mizhang@google.com>
To: "Wang, Wei W" <wei.w.wang@intel.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Aaron Lewis <aaronlewis@google.com>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86/pmu: Return correct value of
 IA32_PERF_CAPABILITIES for userspace after vCPU has run
Message-ID: <ZfHis9Omgy2k3qTK@google.com>
References: <20240313003739.3365845-1-mizhang@google.com>
 <DS0PR11MB63731F54EA26D14CF7D6A3FDDC2A2@DS0PR11MB6373.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR11MB63731F54EA26D14CF7D6A3FDDC2A2@DS0PR11MB6373.namprd11.prod.outlook.com>

On Wed, Mar 13, 2024, Wang, Wei W wrote:
> On Wednesday, March 13, 2024 8:38 AM, Mingwei Zhang wrote:
> > Return correct value of IA32_PERF_CAPABILITIES when userspace tries to read
> > it after vCPU has already run. Previously, KVM will always return the guest
> > cached value on get_msr() even if guest CPUID lacks X86_FEATURE_PDCM. The
> > guest cached value on default is kvm_caps.supported_perf_cap. However,
> > when userspace sets the value during live migration, the call fails because of
> > the check on X86_FEATURE_PDCM.
> 
> Could you point where in the set_msr path that could fail?
> (I don’t find there is a check of X86_FEATURE_PDCM in vmx_set_msr and
> kvm_set_msr_common)
> 
My memory cheated me... The check was on pmu->version, which not
X86_FEATURE_PDCM. Note pmu->version is basically backed by another bits
guest CPUID.

> > 
> > Initially, it sounds like a pure userspace issue. It is not. After vCPU has run,
> > KVM should faithfully return correct value to satisify legitimate requests from
> > userspace such as VM suspend/resume and live migrartion. In this case, KVM
> > should return 0 when guest cpuid lacks X86_FEATURE_PDCM. 
> Some typos above (satisfy, migration, CPUID)
> 
> Seems the description here isn’t aligned to your code below?
> The code below prevents userspace from reading the MSR value (not return 0 as the
> read value) in that case.
> 
> >So fix the
> > problem by adding an additional check in vmx_set_msr().
> > 
> > Note that IA32_PERF_CAPABILITIES is emulated on AMD side, which is fine
> > because it set_msr() is guarded by kvm_caps.supported_perf_cap which is
> > always 0.
> > 
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Cc: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Mingwei Zhang <mizhang@google.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > 40e3780d73ae..6d8667b56091 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2049,6 +2049,17 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu,
> > struct msr_data *msr_info)
> >  		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
> >  			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
> >  		break;
> > +	case MSR_IA32_PERF_CAPABILITIES:
> > +		/*
> > +		 * Host VMM should not get potentially invalid MSR value if
> > vCPU
> > +		 * has already run but guest cpuid lacks the support for the
> > +		 * MSR.
> > +		 */
> > +		if (msr_info->host_initiated &&
> > +		    kvm_vcpu_has_run(vcpu) &&
> > +		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
> > +			return 1;
> > +		break;
> >  	case KVM_FIRST_EMULATED_VMX_MSR ...
> > KVM_LAST_EMULATED_VMX_MSR:
> >  		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
> >  			return 1;
> > 
> > base-commit: fd89499a5151d197ba30f7b801f6d8f4646cf446
> > --
> > 2.44.0.291.gc1ea87d7ee-goog
> > 
> 

