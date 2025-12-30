Return-Path: <kvm+bounces-66870-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 68523CEACF7
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 23:59:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 692B8300673F
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8171299AB4;
	Tue, 30 Dec 2025 22:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CZPpEYXt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0899248F6F
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767135594; cv=none; b=KuZ/Fn1Q4gZig7Rwj8taaTfzG3oAS0ZbmaGdkY9+1eJMWLLaZxu8Wvpbr0OOvaMTWWK5ZKlhBUb729bv9Y1qHlkcHOceLcnPmvtNU04QigvpNPqMlClBCNXfM50o2xYowO9GYO6vguW5oWnISsvX9RbPzGAnG0EgIsWK5QyWf1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767135594; c=relaxed/simple;
	bh=yojfISBOIFSpXcr5+NNlskwwpGIiPkNElaXPFYmcfyY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mu49PU12+k+gPooKHGb33gpSoZasdN3lkCO/ll46zK1kLinOwaBp+lU6oLbmY9EqzAPCMX9wwLJmYkFTuXxmx54uJA5GsDz+nmtdTtx5G+htzvRnqrl6Y+3s2yspKA+76pGmbJAlHd4t+Fli6G3zih51KvNdpOAf+is6XIuUR7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CZPpEYXt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0e9e0fd49so114536235ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 14:59:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767135592; x=1767740392; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fBDadXmXw1V+5U8Oi2GEcCZPNX2euffTMHG2vLf3Jyo=;
        b=CZPpEYXtsSAbVkqKnkI93Vesh904zYR8pN4Z6Yg3Hz5vj+1j7Ucva+kg803cnpnwIr
         AiJRoW04GLOZaGIHFFsK1eqSskJlkYR3730eXEYOv/fOUd/nHHpS8Xi2XAgCgs6zlrj0
         PKt/5iqTVG3HzoBd7ylf4Q6lyuLJwRrNKHovF4VAFUgrBNhi6cKOuxP9zsMv0KBrWC4n
         PPsjihUzTlBQNrj6iOpMbeG3cRp178f09hAzRpyEaLJ2sqjP3gfmfhGEjy/n3KkWW/dr
         IJKkO9+WNSk4QmMSjavgqDK1cHbG7Vh6ASIQestF4rGf0euS3DMNqeqjO/7HfE4n1AmF
         wnZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767135592; x=1767740392;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fBDadXmXw1V+5U8Oi2GEcCZPNX2euffTMHG2vLf3Jyo=;
        b=Zi8WcPGV24nD2rDp7r0TMqMDVq0Hm2DFx5g3Qxh/HXMoG4f/uqk5Jk/yAJxcaQNiPV
         7i/ySQt7qO88I1ITFmojcjv7DzULf+oop9+x6WF7/ML0EIlJ0YFI9POJfI8jL7CJRqS9
         6VKYDRpFPWfSTPmRV5KX/t3NPzpIWN48eCqOFSrRdehdwiQhSKaKS2OC1K4qkPoOaMaL
         qYDuTFNEB66p6RyBAEsb57/3XT9R1hXGdGlqLcZ9SojdR800UTejBatEaED/eI7QQYDM
         lDx6OaLTXrTbCIzMkh1VXDKQ2JYYdNhQFXRIxxIxiCbnuFaKMJ/2XxYIF/po7ht1j55t
         mP5g==
X-Forwarded-Encrypted: i=1; AJvYcCVZoSc+xPfs72SvP1crp2oSRXPWirs4eTTjXMstEXVXe6KkgtcFLyB7nzuEVxZBihmoRdc=@vger.kernel.org
X-Gm-Message-State: AOJu0YytnJ+MbKkLOisrtBV/vWPiFJT3gvyRNp2R+fYsuw/wmf2GFhRO
	m8k2hnjD0iJYbj1D358rxDg5mnoxjUB5N/6J/0ZJBHgcTXbwELCk6NO675PQduJmvNy+UYaoHNb
	quQQ0Nw==
X-Google-Smtp-Source: AGHT+IFeD+h6n1YidrAbsE5HiAota6bVKAwW35UPDKlcY0mTqb6cSWAiLyOFKPv8tt+wNUg2L4+hFSIa5lY=
X-Received: from pjzz4.prod.google.com ([2002:a17:90b:58e4:b0:34a:b8aa:69d8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d48e:b0:29e:fc06:b8a5
 with SMTP id d9443c01a7336-2a2cab16368mr405899135ad.18.1767135591960; Tue, 30
 Dec 2025 14:59:51 -0800 (PST)
Date: Tue, 30 Dec 2025 14:59:50 -0800
In-Reply-To: <aUvJWmZP5wLpvhnw@yilunxu-OptiPlex-7050>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com> <20251206011054.494190-3-seanjc@google.com>
 <69352b2239a33_1b2e100d2@dwillia2-mobl4.notmuch> <aTiAKG4TlKcZnJnn@google.com>
 <6939242dcfff1_20cb5100c3@dwillia2-mobl4.notmuch> <aTmBobJJo_sFbre9@google.com>
 <aUvJWmZP5wLpvhnw@yilunxu-OptiPlex-7050>
Message-ID: <aVRZZkAgmdLfudJc@google.com>
Subject: Re: [PATCH v2 2/7] KVM: x86: Extract VMXON and EFER.SVME enablement
 to kernel
From: Sean Christopherson <seanjc@google.com>
To: Xu Yilun <yilun.xu@linux.intel.com>
Cc: dan.j.williams@intel.com, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Dec 24, 2025, Xu Yilun wrote:
> On Wed, Dec 10, 2025 at 06:20:17AM -0800, Sean Christopherson wrote:
> > On Wed, Dec 10, 2025, dan.j.williams@intel.com wrote:
> > > Sean Christopherson wrote:
> > > > On Sat, Dec 06, 2025, dan.j.williams@intel.com wrote:
> > > > I don't think we need anything at this time.  INTEL_TDX_HOST depends on KVM_INTEL,
> > > > and so without a user that needs VMXON without KVM_INTEL, I think we're good as-is.
> > > > 
> > > >  config INTEL_TDX_HOST
> > > > 	bool "Intel Trust Domain Extensions (TDX) host support"
> > > > 	depends on CPU_SUP_INTEL
> > > > 	depends on X86_64
> > > > 	depends on KVM_INTEL
> > > 
> > > ...but INTEL_TDX_HOST, it turns out, does not have any functional
> > > dependencies on KVM_INTEL. At least, not since I last checked. Yes, it
> > > would be silly and result in dead code today to do a build with:
> > > 
> > > CONFIG_INTEL_TDX_HOST=y
> > > CONFIG_KVM_INTEL=n
> > > 
> > > However, when the TDX Connect support arrives you could have:
> > > 
> > > CONFIG_INTEL_TDX_HOST=y
> > > CONFIG_KVM_INTEL=n
> > > CONFIG_TDX_HOST_SERVICES=y
> > > 
> > > Where "TDX Host Services" is a driver for PCIe Link Encryption and TDX
> > > Module update. Whether such configuration freedom has any practical
> > > value is a separate question.
> > > 
> > > I am ok if the answer is, "wait until someone shows up who really wants
> > > PCIe Link Encryption without KVM".
> > 
> > Ya, that's my answer.  At the very least, wait until TDX_HOST_SERVICES comes
> > along.
> 
> I've tested the PCIe Link Encryption without KVM, with the kernel
> config:
> 
>   CONFIG_INTEL_TDX_HOST=y
>   CONFIG_KVM_INTEL=n
>   CONFIG_TDX_HOST_SERVICES=y
> 
> and
> 
> --- /dev/null
> +++ b/drivers/virt/coco/tdx-host/Kconfig
> @@ -0,0 +1,10 @@
> +config TDX_HOST_SERVICES
> +       tristate "TDX Host Services Driver"
> +       depends on INTEL_TDX_HOST
> +       default m
> 
> Finally I enabled the combination successfully with a patch below, do we
> need the change when TDX_HOST_SERVICES comes?

Ya, we'll need something along those lines.  What exactly we want the Kconfig
soup to look like is TBD though, e.g. it may or may not make sense to have a
common config that says "I want virtualization!"?

