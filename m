Return-Path: <kvm+bounces-51775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 05ADEAFCE0D
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:45:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18D401676B8
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E21FE2E0B73;
	Tue,  8 Jul 2025 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rxo1oo3i"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A9B2E172F
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985749; cv=none; b=B7k+DJxLiE5PR5uoTWBnikFMqxV04DCjlfN6FAFwXaXUB8XiZrH3MYKOE6rJSO5ySTjknhy+de/VBn0HSqheuamWsv5A5MNLYsV0D2navmcyt0W3iWX+pwnFVh8QZTZuax9/dmP3zDBO/O+z3E9eNh7+N0IuupjTU3KqTpAxRpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985749; c=relaxed/simple;
	bh=LXboLWDCXGg9nqpypiFt02b3q749NkL+RNHC1Pt1xG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WklV46430W16zRzpI4n3UTHSpsLEjgg76JD1N5XoaE9Pg3ndrBtwFcNkWQld0cybRYTu2OtWxULwDUOrby/7MvFzNhWieQD8gixYQG4CQTuBDvt/x3jHYk7wwrenUrwO0Tpe/RzxBWA7reVebZHODCxLZedb4EYynDTqwq+rYT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rxo1oo3i; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7494999de28so5831995b3a.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751985747; x=1752590547; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ehETrpJERh/ReGe7TAM7Xc0bnOoYtpFGCnGNiHhtzZg=;
        b=rxo1oo3iZuo80SdmCIipXJMxR61N+XXCv+xfHHzKJyngEJSyOeqfq2O4Qfl8rq61QA
         0XZUO20fZZl/t+HitnUz+MfpaJWrTYNmRrsO0tnIwMyTxO8cyzoQBtjIfaI5SGKu/8WX
         AHXXfalTduYgZnEFmlye9T4d6bSoVj9zsb5VGWE6+ctdNdr0LpH48Ffy0F2MeKNQqaRG
         J1BHusZFZsrLjvr50ZXkz4jZOARnihj0i0hk8Wd976ZIr7+Jf13VSZSiWkHYg33Clm8i
         dy0O0IovNq1FT5EoIW7slPAI7iUu2C0hD+kn17ZSWdBsvGVyUR+qdSyB+saRptqehBNQ
         K2qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751985747; x=1752590547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ehETrpJERh/ReGe7TAM7Xc0bnOoYtpFGCnGNiHhtzZg=;
        b=s4i1wWkvXIj2C0RU3cULLjG3HQdcVKlxK1CVoKkN7VkLFiOHgzqU0WONRLI1KxUMLw
         EQOECTFs/CQO22tTi4lpiJnc6pHs5A5o//54lrSTUkypQX47QJVZL35h0UHjbLcQ2HKx
         X+ACItDb1iv4cQ9zRUfUNKjXUKAfMMsOJfKlU//XZaDNUEWHlL0o1ydKnQjk+Mt7GG1q
         EFCI9lJM2wp27xH0apA8QKDTlPQicQeqZ9nkoTqn0kHGeVRBY2CWVO1rBuZvxX+iT+pp
         PSEUeUWPEn8/L6XobVTyFO2WHNfhQQMWpOblb2LzdqaZfzFobEhhflaIQBkAS3xihzFO
         VzRw==
X-Forwarded-Encrypted: i=1; AJvYcCWpc0+sPvPV2br9IAwthapmhu4wwHnXq2EXLz1Y4R/afSrkRMJ1L+R9Xy9iBHdVCJRzSBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwntuVHu5hWbrtxrXSPJZBz4mngcRoia0TbXExJS+71QlclXp37
	3nfUS/MZFp4poZl0mgfYyUlvNrF2VYw9XbRCQ1czxaKR+q2giw3dMiSHZVvtii1Lprpt8QRyQIp
	9Cw/FnA==
X-Google-Smtp-Source: AGHT+IFsGV3b/2LSNvAdnf3sO/VCpL8OZ7iKXhfjVOd4gFa1OFN1Hi7Ce8Bbd2uv6YncDuuzObVpo0p6kso=
X-Received: from pfbkq21.prod.google.com ([2002:a05:6a00:4b15:b0:746:3244:f1e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:22d2:b0:742:a91d:b2f5
 with SMTP id d2e1a72fcca58-74d2497dfe9mr4044568b3a.13.1751985746902; Tue, 08
 Jul 2025 07:42:26 -0700 (PDT)
Date: Tue, 8 Jul 2025 07:42:25 -0700
In-Reply-To: <d8a30e490c50956a358887a3d018a9b86df91fd0.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250707101029.927906-1-nikunj@amd.com> <20250707101029.927906-3-nikunj@amd.com>
 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
 <cf03633c-63ba-40b7-abd1-8cbeb4daadd9@intel.com> <d8a30e490c50956a358887a3d018a9b86df91fd0.camel@intel.com>
Message-ID: <aG0uUdY6QPnit6my@google.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nikunj@amd.com" <nikunj@amd.com>, 
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, 
	"vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>, "bp@alien8.de" <bp@alien8.de>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, 
	"santosh.shukla@amd.com" <santosh.shukla@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 08, 2025, Kai Huang wrote:
> 
> > > > -		svm->vcpu.arch.guest_state_protected = true;
> > > > +		vcpu->arch.guest_state_protected = true;
> > > > +		vcpu->arch.guest_tsc_protected = snp_secure_tsc_enabled(kvm);
> > > > +
> > > 
> > > + Xiaoyao.
> > > 
> > > The KVM_SET_TSC_KHZ can also be a vCPU ioctl (in fact, the support of VM
> > > ioctl of it was added later).  I am wondering whether we should reject
> > > this vCPU ioctl for TSC protected guests, like:

Yes, we definitely should.  And if it's not too ugly, KVM should also reject the
VM-scoped KVM_SET_TSC_KHZ if vCPUs have been created with guest_tsc_protected=true.
(or maybe we could get greedy and try to disallow KVM_SET_TSC_KHZ if vCPUs have
been created for any VM shape?)

> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 2806f7104295..699ca5e74bba 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -6186,6 +6186,10 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> > >                  u32 user_tsc_khz;
> > >   
> > >                  r = -EINVAL;
> > > +
> > > +               if (vcpu->arch.guest_tsc_protected)
> > > +                       goto out;
> > > +
> > >                  user_tsc_khz = (u32)arg;
> > >   
> > >                  if (kvm_caps.has_tsc_control &&
> > 
> > It seems to need to be opt-in since it changes the ABI somehow. E.g., it 
> > at least works before when the VMM calls KVM_SET_TSC_KHZ at vcpu with 
> > the same value passed to KVM_SET_TSC_KHZ at vm. But with the above 
> > change, it would fail.
> > 
> > Well, in reality, it's OK for QEMU since QEMU explicitly doesn't call 
> > KVM_SET_TSC_KHZ at vcpu for TDX VMs. But I'm not sure about the impact 
> > on other VMMs. Considering KVM TDX support just gets in from v6.16-rc1, 
> > maybe it doesn't have real impact for other VMMs as well?

6.16 hasn't officially release yet, so any impact to userspace is irrelevant,
i.e. there is no established ABI at this time.

Can someone send a proper patch?

