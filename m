Return-Path: <kvm+bounces-51827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D214AFDB8D
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 01:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9BA4D7AC6E7
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 23:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E361522F774;
	Tue,  8 Jul 2025 23:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BsVbATAW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E7320A5F3
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 23:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752016092; cv=none; b=BI8jzhv2QM54AZSIG7YmPkXhz2UKr5uubDy0v3NM9MQA/pc8mINLImPh+h+BRrnB1SlraXUVqRBCLeOMUgRTmWN+MDbmFSsSTME84cGebUcXLN5w/X8EuvKdXyFWvBQcI5lgpQQ4DqVMJIrs8bwJKcjhzwX1c4IfkcicHicKjXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752016092; c=relaxed/simple;
	bh=gZNJmaLpVr+OtS/Nqo6vxmob7whUqwd5zJSDbbgT0AE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ux6OU8GUfn6DIjxqQqlKvG9VSaa7DSSBByKzoKmhcMq3Fnoioh+CfT8v8LNfY7dWkqKi53+kkoAfj+SYHm6DsGjzT9RP4E+xhCiVgvJyXqs64/ram75mEbfTMPufyvvEFqxDVWCMgsMreFIqCWhqyFeQMGdXjoy6kZDQ6gFdgG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BsVbATAW; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-311ef4fb5fdso4861606a91.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 16:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752016090; x=1752620890; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MFSd0209c41kn4eCGXw/D3eQSEzKypHqo5tejralxxo=;
        b=BsVbATAWGm7MWVl1gkngFmIWNn3e/wJArTi8WJCkmAmfsbiv5ZdhbTX2ScOdaDzCIl
         sbgm3LEWr9KBH8Ulb3ZoRpLAdbbUt3jEGIzBV0YtL706AR3kpVOtIPeLy8ZD2qLP/nff
         7hbAIKkSOTecp5z85Tdj+UzQPoYG6kGtS+F7jmttekaaBDZBiHc8wzNHVKRdNaV4RTLR
         mYEgktyJoiyAfdV5O0RZyepumJkT9Y0HTm2xmAbKsX6UDbdrGrK7+sKtuG3xPOxHoa7g
         bZDfJPLzMwnjFkkuVrSw/ZX6ag53vNmYMS/NFUV4uwVmRRZqSjkJdBPbIuU1sPgFB7KR
         sL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752016090; x=1752620890;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MFSd0209c41kn4eCGXw/D3eQSEzKypHqo5tejralxxo=;
        b=Q/K0yjqIwXAxBPAzg4z+7x+nLnZLuUCgp/8byAEY+9kycygFR+tEf1kHcszeFsMID+
         MUJ7y2gZxzzGxAZrH0UQXoY/W1Mqzt/s53h4AfpljgupBhtstRB06DFaj2eLFmBc4gxA
         EdKj2ADxBIB/ON8fg1Fd+pkAN2jZPvKp55vJcYJqXyx+/6UgOFrYP9+yrTc9FdqeBA84
         SLAHt9K04uKNqid5MP2+EdangsEmuRPcpx1sCqi+8hUe+e4mcWRgj+d/auEkW7F5Zi1Y
         0wnUH7c0LTSETRlpAAAGtXmHJtzF8Pv4a9Ulgh69Q1E9Y759hI9TrSAX8dNBui60X2bv
         77+g==
X-Forwarded-Encrypted: i=1; AJvYcCW/eQrjrNnG9u43vR0n7+Xr87r327rvr2ZoRnGi3nOtZYQEm8JKtEfOCo+6782nc+4TYcc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8yxV6quQM5XxsxB9UhBovXXwAxwtm1ogj3dN3SKEJtH/dIONt
	n/2wEcR57K4d/c+0AGxux+F5b6O4STMsbj6GYb9bTaflPihBuIeKwxcPtwe/AdnRK//Mgt38s3F
	abWSy5A==
X-Google-Smtp-Source: AGHT+IFFo3+5yVC4fM9VcTfzy+mC6FiUGixXTYItaJMUckQvSvaHxwrzG7P2NqBFObzwlPIHddMIOtiGvfE=
X-Received: from pjbsv3.prod.google.com ([2002:a17:90b:5383:b0:314:626:7b97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b84:b0:311:f99e:7f4e
 with SMTP id 98e67ed59e1d1-31c2fdc3ed8mr589249a91.16.1752016089722; Tue, 08
 Jul 2025 16:08:09 -0700 (PDT)
Date: Tue, 8 Jul 2025 16:08:08 -0700
In-Reply-To: <13feda96f84da526b14c4ff48d41626b827140fb.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707101029.927906-1-nikunj@amd.com> <20250707101029.927906-3-nikunj@amd.com>
 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
 <cf03633c-63ba-40b7-abd1-8cbeb4daadd9@intel.com> <d8a30e490c50956a358887a3d018a9b86df91fd0.camel@intel.com>
 <aG0uUdY6QPnit6my@google.com> <13feda96f84da526b14c4ff48d41626b827140fb.camel@intel.com>
Message-ID: <aG2k2BFBJHL-szZc@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "bp@alien8.de" <bp@alien8.de>, "vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, "nikunj@amd.com" <nikunj@amd.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "santosh.shukla@amd.com" <santosh.shukla@amd.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 08, 2025, Kai Huang wrote:
> On Tue, 2025-07-08 at 07:42 -0700, Sean Christopherson wrote:
> > On Tue, Jul 08, 2025, Kai Huang wrote:
> > > 
> > > > > > -		svm->vcpu.arch.guest_state_protected = true;
> > > > > > +		vcpu->arch.guest_state_protected = true;
> > > > > > +		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
> > > > > > +
> > > > > 
> > > > > + Xiaoyao.
> > > > > 
> > > > > The KVM_SET_TSC_KHZ can also be a vCPU ioctl (in fact, the support of VM
> > > > > ioctl of it was added later).  I am wondering whether we should reject
> > > > > this vCPU ioctl for TSC protected guests, like:
> > 
> > Yes, we definitely should.  And if it's not too ugly, KVM should also reject the
> > VM-scoped KVM_SET_TSC_KHZ if vCPUs have been created with guest_tsc_protected=true.
> > (or maybe we could get greedy and try to disallow KVM_SET_TSC_KHZ if vCPUs have
> > been created for any VM shape?)
> 
> Technically, if we want to do, I think we should do the simple way (the
> latter).  But I think this will have a real potential impact on the ABI?
> 
> I would prefer the simple way.  How do you think?

I like the simple way too, but as you note, it'll most definitely be an ABI
change.  Which is what I was alluding to by "getting greedy" :-)

> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index 2806f7104295..699ca5e74bba 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> > > > >                  u32 user_tsc_khz;
> > > > >   
> > > > >                  r = -EINVAL;
> > > > > +
> > > > > +               if (vcpu->arch.guest_tsc_protected)
> > > > > +                       goto out;
> > > > > +
> > > > >                  user_tsc_khz = (u32)arg;
> > > > >   
> > > > >                  if (kvm_caps.has_tsc_control &&
> > > > 
> > > > It seems to need to be opt-in since it changes the ABI somehow. E.g., it 
> > > > at least works before when the VMM calls KVM_SET_TSC_KHZ at vcpu with 
> > > > the same value passed to KVM_SET_TSC_KHZ at vm. But with the above 
> > > > change, it would fail.
> > > > 
> > > > Well, in reality, it's OK for QEMU since QEMU explicitly doesn't call 
> > > > KVM_SET_TSC_KHZ at vcpu for TDX VMs. But I'm not sure about the impact 
> > > > on other VMMs. Considering KVM TDX support just gets in from v6.16-rc1, 
> > > > maybe it doesn't have real impact for other VMMs as well?
> > 
> > 6.16 hasn't officially release yet, so any impact to userspace is irrelevant,
> > i.e. there is no established ABI at this time.
> > 
> > Can someone send a proper patch?
> 
> I will try to do today.

Thanks!

> But if you also want to reject KVM_SET_TSC_KHZ VM ioctl in either way,
> then it could be in a separate patch, which means we should have 2
> separate patches to handle?

Ya, probably two separate patches given that the VM-scoped change could break
userspace.

