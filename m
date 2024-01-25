Return-Path: <kvm+bounces-6887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED42483B5ED
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 01:15:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A5C65288C49
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 00:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E5F87F8;
	Thu, 25 Jan 2024 00:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EhVaID8U"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5717F
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 00:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706141688; cv=none; b=gGSBefgfbwVxu/MKUngz2VFgT4XhKLKMT5ycVHNLf0iLDiwOAgc3TJetry1/v1axYDdf2Wz/idC/qclpmoooUWxO70DYxP67VxgILrVTCskKq/hnEt6C7qdxFfsLlklcNDt7z9xtfbQG0kLckYWakG4cZLr55eoqFhTOzhSHn90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706141688; c=relaxed/simple;
	bh=YOAcjvoGiuZ6mQwS+jVJ9CpTyuzi9sgrbhGFuSRZiwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZ5bupzAWxXJ8lBjatbHBAZXzzJqZdKIkfiWhUENDMmbfyd2nZqJpIjkCDqv+AQX5KAYMEBWCCYsYndqhWtwMqETJ3KUmIoqYfUS+tY6NMM6KOIhIx4TKK62ShPr6RWZMGvWI++11sGNs/iaw2e3l8v0uT2Dlw0nexNCQ6UF3PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EhVaID8U; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2901ceb0d33so154558a91.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 16:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706141686; x=1706746486; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Td59QsnOnNAIxqMoEJwJRDHKQ4MnG7nuO2f/+7fni28=;
        b=EhVaID8UEHVHk0M1jQu/LpF3WTuj4AgIymLbl49IMh0OTMIyoh9PuF7D2V/oUmII9v
         glsYzdx36Abuq8uucK0sfl8giZiQJf8IkQ8fkzndRq+YQYtjvI2lXBilxCPwSZFoLF0L
         jlandM7ZEKGveNdc9MwkGASDQ6dXkUUefDBw+x1ZJSmLdMQM+TqhTJ+gt7c/7OAFWx7H
         edLlEdimgF0eTstTb025+JKJF4AzNGy+zKyTN1FGxyVh4YrjN3BbzM2wqApMFBTTRrOL
         VGQrPIcjoboccb32ya0klA3mknMrHraFKH9qWL5JpDhZ27Pwznn0j3f7QAkQ63L/bj+5
         bg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706141686; x=1706746486;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Td59QsnOnNAIxqMoEJwJRDHKQ4MnG7nuO2f/+7fni28=;
        b=hMiR8lnXi9pkzer7b4V0LRiKfsq5CVh+P6y3mVDIzYiKro+GbNsDubhCNM0hSUZ/c7
         7GR9FD4UQLb8xLYSISPvdMi+HxK5WKpr7OhTS2a0kb9LCmXlHbP5thfK0ztj8Ne/k1aS
         jfAI3KoyiJWgpc7RvELEHh8JMBvfgH81sTRa+8K+sfJxK3XYlVTQgkAWzmpM9BaC595y
         A74FCdXCpdW6BfokHZHK+1Vn6Z24/pqnz5o56Umas16Sm/9M382sO7YC2aojRT5j+6JR
         RgkBPK8AHWPuDYNiy5HZpJU7BWGzfYsxn5I3udgTUVtyu4ec0zuW3IOZ3LhR9AVfu6d9
         mhaw==
X-Gm-Message-State: AOJu0YwB/uN/g+3iLGdY8ypMe8xvqIHmJCCbPgMe3dArudb9gNRWset3
	i+gX9Nlmgie0JPcx+NjdQeGzI2S8QlZqKRjyfG0wXZ8+rfLDYBbV6kpk6wIm7A==
X-Google-Smtp-Source: AGHT+IFU6JU4bcA5/KdglQYspt4pidHTMZ8C8W6q5WioAyFYjb48ONDTgEG2UYxD2263DCxCG99DtQ==
X-Received: by 2002:a17:90a:4093:b0:290:98a7:20d with SMTP id l19-20020a17090a409300b0029098a7020dmr139522pjg.28.1706141686292;
        Wed, 24 Jan 2024 16:14:46 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id v13-20020a170903238d00b001d5e03543dcsm11041859plh.38.2024.01.24.16.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jan 2024 16:14:45 -0800 (PST)
Date: Thu, 25 Jan 2024 00:14:42 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Aaron Lewis <aaronlewis@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: x86/pmu: Reset perf_capabilities in vcpu to 0
 if PDCM is disabled
Message-ID: <ZbGn8lAj4XxiecFn@google.com>
References: <20240124003858.3954822-1-mizhang@google.com>
 <20240124003858.3954822-2-mizhang@google.com>
 <ZbExcMMl-IAzJrfx@google.com>
 <CAAAPnDFAvJBuETUsBScX6WqSbf_j=5h_CpWwrPHwXdBxDg_LFQ@mail.gmail.com>
 <ZbGAXpFUso9JzIjo@google.com>
 <ZbGOK9m6UKkQ38bK@google.com>
 <ZbGUfmn-ZAe4lkiN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZbGUfmn-ZAe4lkiN@google.com>

On Wed, Jan 24, 2024, Sean Christopherson wrote:
> On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > On Wed, Jan 24, 2024, Sean Christopherson wrote:
> > > On Wed, Jan 24, 2024, Aaron Lewis wrote:
> > > > On Wed, Jan 24, 2024 at 7:49 AM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Wed, Jan 24, 2024, Mingwei Zhang wrote:
> > > > > No, this is just papering over the underlying bug.  KVM shouldn't be stuffing
> > > > > vcpu->arch.perf_capabilities without explicit writes from host userspace.  E.g
> > > > > KVM_SET_CPUID{,2} is allowed multiple times, at which point KVM could clobber a
> > > > > host userspace write to MSR_IA32_PERF_CAPABILITIES.  It's unlikely any userspace
> > > > > actually does something like that, but KVM overwriting guest state is almost
> > > > > never a good thing.
> > > > >
> > > > > I've been meaning to send a patch for a long time (IIRC, Aaron also ran into this?).
> > > > > KVM needs to simply not stuff vcpu->arch.perf_capabilities.  I believe we are
> > > > > already fudging around this in our internal kernels, so I don't think there's a
> > > > > need to carry a hack-a-fix for the destination kernel.
> > > > >
> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index 27e23714e960..fdef9d706d61 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -12116,7 +12116,6 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > > > >
> > > > >         kvm_async_pf_hash_reset(vcpu);
> > > > >
> > > > > -       vcpu->arch.perf_capabilities = kvm_caps.supported_perf_cap;
> > > > 
> > > > Yeah, that will fix the issue we are seeing.  The only thing that's
> > > > not clear to me is if userspace should expect KVM to set this or if
> > > > KVM should expect userspace to set this.  How is that generally
> > > > decided?
> > > 
> > > By "this", you mean the effective RESET value for vcpu->arch.perf_capabilities?
> > > To be consistent with KVM's CPUID module at vCPU creation, which is completely
> > > empty (vCPU has no PMU and no PDCM support) KVM *must* zero
> > > vcpu->arch.perf_capabilities.
> > > 
> > > If userspace wants a non-zero value, then userspace needs to set CPUID to enable
> > > PDCM and set MSR_IA32_PERF_CAPABILITIES.
> > > 
> > > MSR_IA32_ARCH_CAPABILITIES is in the same boat, e.g. a vCPU without
> > > X86_FEATURE_ARCH_CAPABILITIES can end up seeing a non-zero MSR value.  That too
> > > should be excised.
> > > 
> > hmm, does that mean KVM just allows an invalid vcpu state exist from
> > host point of view?
> 
> Yes.
> 
> https://lore.kernel.org/all/ZC4qF90l77m3X1Ir@google.com
> 
> > I think this makes a lot of confusions on migration where VMM on the source
> > believes that a non-zero value from KVM_GET_MSRS is valid and the VMM on the
> > target will find it not true.
> 
> Yes, but seeing a non-zero value is a KVM bug that should be fixed.
> 
How about adding an entry in vmx_get_msr() for
MSR_IA32_PERF_CAPABILITIES and check pmu_version? This basically pairs
with the implementation in vmx_set_msr() for MSR_IA32_PERF_CAPABILITIES.

Doing so allows KVM_GET_MSRS return 0 for the MSR instead of returning
the initial permitted value.

The benefit is that it is not enforcing the VMM to explicitly set the
value. In fact, there are several platform MSRs which has initial value
that VMM may rely on instead of explicitly setting.
MSR_IA32_PERF_CAPABILITIES is only one of them.


> > If we follow the suggestion by removing the initial value at vCPU
> > creation time, then I think it breaks the existing VMM code, since that
> > requires VMM to explicitly set the MSR, which I am not sure we do today.
> 
> Yeah, I'm hoping we can squeak by without breaking existing setups.
> 
> I'm 99% certain QEMU is ok, as QEMU has explicitly set MSR_IA32_PERF_CAPABILITIES
> since support for PDCM/PERF_CAPABILITIES was added by commit ea39f9b643
> ("target/i386: define a new MSR based feature word - FEAT_PERF_CAPABILITIES").
> 
> Frankly, if our VMM doesn't do the same, then it's wildly busted.  Relying on
> KVM to define the vCPU is irresponsible, to put it nicely.
> 
> > The following code below is different. The key difference is that the
> > following code preserves a valid value, but this case is to not preserve
> > an invalid value. 
> 
> But it's a completely different fix.  I referenced that commit to call out that
> the need for the commit and changelog suggests that someone (*cough* us) is relying
> on KVM to initialize MSR_PLATFORM_INFO, and has been doing so for a very long time.
> That doesn't mean it's the correct KVM behavior, just that it's much riskier to
> change.

