Return-Path: <kvm+bounces-61437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B18C1DA25
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 00:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 996AB4013CE
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 23:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D12C2E7F08;
	Wed, 29 Oct 2025 23:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JboSAFnd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DFF1E521A
	for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 23:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761778828; cv=none; b=RhGjynMUiaReGFHPH6fRQacqys1edovIGmwn4QS3Blb2DB6o7TomB3ihQCWreZTBoFwbQjDmu+Jec+U80hDuMitqho9lLImhvnUmEtgd4SykJbY1kjKrIXdW1mVRr40FOhHQSM/5IzJzj8Th1YFHv8sD/FOAQ28YorCz3U1CkEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761778828; c=relaxed/simple;
	bh=CiI5Nn3m3g4rYOkdtlhfN/EsnGcr6LlTcetEUgKPJfY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pNnsvvuR9f8SsOlA2TUDi9Lir1/bKD02ZhO07RdPMToAdzaEpe5tH/Dsr6BE6ISyAoIDQMIxnfV1t8x51TN/IacirkMQyPq0dezerVDEXSntUBkexw+fhJU0V3c0Ult6q748PkH+P9blcjuyXZ6NkOhOQv+AuaMU2RSOsTHwfcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JboSAFnd; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb7796d4so354783a91.0
        for <kvm@vger.kernel.org>; Wed, 29 Oct 2025 16:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761778826; x=1762383626; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=z9ixBsj91glcxroJP2Rf1HQlKO0xZv2gSTaOETVHtQw=;
        b=JboSAFnd9dktDVxOOlBulPwwWbc6pgvFObSP9+N3D/onGHMkn+3xE/Q49KrYFchhbv
         Gt9+idwC6givZSZg9CiCxCJOxxupZ8YHktX48P8LDldLR4LXo66xl/GWlPI2AE0SgT3e
         AXCFPLKrk6GSuwAwX08cXy3xqBIKe3u6OTnu6LMYZeyCsLiG1LCRdiNdx6azujzWRTjU
         KmqTXsin7X0HBdgqhCxiTjGDm20oCAVweP+XYqW/4K2w6h4L1ZiASKrDU0NLPD8RKWvN
         Gie5rahbDn7LS5kOTi6e0+t1vRovdUcMDGngFZJKDNnmn+m63SCullFdniBzffLjHcQM
         fR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761778826; x=1762383626;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=z9ixBsj91glcxroJP2Rf1HQlKO0xZv2gSTaOETVHtQw=;
        b=SRYeNMMx/6U1gzth8fuKYvXxi3/AhRofI2KQqdjkbhxNz3iA/CHZDjBh12hk5mVwE3
         K+6K7ssO/2U45rLkUYlLCXjEGqTwImfkQau4Dtw4vswFAAedYQhKL0U5O9dXxH7/CRqa
         N8nIyxgTtJDPy+nejtm8qtVsYQOBwRg8Fs3c/8gAwee+3rbwMEauRe33IJANj/E5xD2m
         zo7MjPNEGgao3VmmbOgqeAhbQs6OmtKSJ3crbr54qsgjRfhGpmRIEWFoWjNBBZfi0w1x
         OBcTRCN2P9VMxQT4CjgSZ9cZo+U1vDSw3RgYk6O56NiOsKuYKvKtkWUsd+Ux6NWZZ8Zm
         dagg==
X-Forwarded-Encrypted: i=1; AJvYcCUsAKL+rGbz6dnzMx6OmRK/yOHmn2bWSwI92OhpUmsrGo5eDcKhx6z+GBwDYQ/PCRnhy2k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww0rmcre8jszNT03Xs1isH+3p1r0FWnv73V7NtAJI1t1hPYH99
	WBSK4FSgKiwTWLT7YFbliFMYFEDeLugGpNAwaKS7xPbnYklNdDoKiux17lK9omfuBPfO5giDivF
	VQwEddQ==
X-Google-Smtp-Source: AGHT+IFs6NM2xgQel/cu5JnoaHPVb6EDk919Fxynofiz29lgkoJxWfP5QqyKPuANosTJ1r3A01CgINrEjRQ=
X-Received: from pjvn22.prod.google.com ([2002:a17:90a:de96:b0:33b:a0ae:940])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:56c7:b0:32e:a10b:ce33
 with SMTP id 98e67ed59e1d1-3403a299e57mr5756186a91.21.1761778826096; Wed, 29
 Oct 2025 16:00:26 -0700 (PDT)
Date: Wed, 29 Oct 2025 16:00:24 -0700
In-Reply-To: <2e0e538e-99f0-4828-bdd3-fda7ad3794c3@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
 <20251029194831.6819B2E7@davehans-spike.ostc.intel.com> <6bfe570e35364bd121b648fe8475f705666183d6.camel@intel.com>
 <2e0e538e-99f0-4828-bdd3-fda7ad3794c3@intel.com>
Message-ID: <aQKciMQG9y-szKUm@google.com>
Subject: Re: [PATCH 1/2] x86/virt/tdx: Remove __user annotation from kernel pointer
From: Sean Christopherson <seanjc@google.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Oct 29, 2025, Dave Hansen wrote:
> On 10/29/25 14:06, Edgecombe, Rick P wrote:
> > For the KVM side of tdx, the commits are getting prefixed with "KVM: TDX: ", and
> > "x86/virt/tdx" is being used arch/x86/virt/vmx/tdx/tdx.c. It's probably not too
> > late to adopt the one true naming scheme. I don't have a strong preference
> > except some consistency and that the maintainers agree :)
> 
> Yeah, I just picked one. I honestly don't care what we do in the end.

I do.  Being able to quickly determine if something touches KVM is valuable.  TDX
blurs the line since much of the code is split across KVM and x86/virt, but I
still find value in differentiating when possible.

> I was also probably just going to send these in the tip/x86/tdx branch unless
> anyone screams, so I did it the tip-ish way.

But this doesn't have anything to do with what tree the patches get routed through.
Scopes are always about what files/content is changing.

I also don't undertand why you would take these through tip.  They only touch
KVM (which is annoying hard to see since there's no shortlog in the cover letter).
Sure, they're minor changes and _probably_ won't conflict with anything, but again
I don't see how that matters.  These are clearly KVM patches.

