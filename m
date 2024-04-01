Return-Path: <kvm+bounces-13298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ABB9894753
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 00:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA5822829E1
	for <lists+kvm@lfdr.de>; Mon,  1 Apr 2024 22:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F3F05674A;
	Mon,  1 Apr 2024 22:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eyJbGAh0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F6254780
	for <kvm@vger.kernel.org>; Mon,  1 Apr 2024 22:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712010582; cv=none; b=BMh8KTcFCzeZUZNwDerWt2SeBdZCnbmOXRK+MnTzfZHLjcRjFLT8IIxAInjty5f4aakXEnQ/7uIhfxlXMUy1ahqqcUQDvXM3TMe/yatP+1xPkd4hVexUWW0AaowFgtx1hIktZJFJYqbNg6vzHco+Ofxo4o0+HLYYNus0FzSWtXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712010582; c=relaxed/simple;
	bh=uRf1QBahqZS8Z955x72vM5aZgORLckJbANqvbX6mN9A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ALU4QvlkyFG8XiYqqY1DP/N7Kf7P0efhJ/czcIr3GR6khcfEMaVte/tTb5qoRoETDiVW8SIVYeqdNHY87kw5dcQ5JBOW1KksrFEXZOhsys1bpgxcdmZxJdlV92gH/fdKLaOQVBmDAuDf6kYXIEy5f4rd5RjLYRVExX0u+I9xQGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eyJbGAh0; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-60cbba6fa0bso80049317b3.3
        for <kvm@vger.kernel.org>; Mon, 01 Apr 2024 15:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712010580; x=1712615380; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dxbv2zR344az1ZpGGMLXWBIEjEGxYRekW2mxLE4Y23k=;
        b=eyJbGAh0iBdRTIwMI4OtvSBqKQoDFg8NJ0Ep0pbIoQM4UVBLdB+08muoCbmzO0irzt
         vMLd2qxkSYhzgMbqjXOPsYAfCv6KsjCPt50iAmogxnZ55hxu+sWNoRxuKrQz7qk5KXbY
         xd8ehcUj5hymmgHqFksAHhoYb8JyrVuMxfIxLyif2Kw9rIoNnkGStYSc/41R1Nmlz3P6
         xCGGqBbjPdRaKiYL3zLyYPsh/lvAlGUB+iq1/nabr0gicxOJMQJ2YcGfAOYfO6Xs9C83
         YLnx80yRuicS13u4vTP4/LV6Yb9ni169DPe/1YHhZM9Z7TvZ+iU22QWmVMRezUa+OBr4
         eIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712010580; x=1712615380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dxbv2zR344az1ZpGGMLXWBIEjEGxYRekW2mxLE4Y23k=;
        b=gVK8peTQ8YlDOdFd0okVyy8qtlA+CpkMakMh/zFdE0lGtYbbcL4/dVMsE0o3xT0aMO
         LsBAvEnWoUt+QQ4Km0k6KRYTK/EaRmR2Nn66v+3ta/nMflb58UCZzihc2hRjB8w4REQJ
         0ITEnBfNY3jV8Ny9PDLLiDqB4AOOhkUK+aRtGPeyerp9UxY9eaneacvDQ36QG6+DzzIL
         pHCIfg8RIiNYYfKdROY5Fp2AqfFqJkMCsMXVyl5JOOqakPFNRN+1Opah2J0IezURJsv9
         1WDSBpOXY6bx4Vb9cYIk0sg3v92LAJYihlh4E+bnInE8TRZe48bCiEEKuEsrAN25/9zA
         xkWw==
X-Forwarded-Encrypted: i=1; AJvYcCVd0Mr6hjCLgRbdlwMb+W3+z5h6/8+vVKuIMC0Tq2fjr/wRa54ra9VLZA4S8inSCfN1GgCvQobqffWIypxH8vAyL2zc
X-Gm-Message-State: AOJu0YzOmKRnznV/RW2iOSAN5cW3ybYM93xUUbo3wGW1bO3MYqkNqWpW
	ZbqG+ui3hp7Ad1oxEYx6drNUfHwhGvIiRLVs9K7xRSkeNXEhpOUVaHf4+2/WBqWJeLJDXv5JWC8
	FJw==
X-Google-Smtp-Source: AGHT+IHEvNGnR/FEXAGvVteLDZwjTiunaD1N2L6JusyGM6kOld5osvQPso1tIa1rejLfUzGR7x2twBKIPo4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:e202:0:b0:615:1579:8660 with SMTP id
 l2-20020a0de202000000b0061515798660mr246209ywe.7.1712010580188; Mon, 01 Apr
 2024 15:29:40 -0700 (PDT)
Date: Mon, 1 Apr 2024 15:29:38 -0700
In-Reply-To: <ZgDyxpaf+HgQzYDp@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240309010929.1403984-1-seanjc@google.com> <20240309010929.1403984-6-seanjc@google.com>
 <ZgDyxpaf+HgQzYDp@chao-email>
Message-ID: <Zgs1Ul2rZjyUvMEx@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support self-snoop
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>, kvm@vger.kernel.org, 
	rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Tian <kevin.tian@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Yiwei Zhang <zzyiwei@google.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Mar 25, 2024, Chao Gao wrote:
> On Fri, Mar 08, 2024 at 05:09:29PM -0800, Sean Christopherson wrote:
> >Unconditionally honor guest PAT on CPUs that support self-snoop, as
> >Intel has confirmed that CPUs that support self-snoop always snoop caches
> >and store buffers.  I.e. CPUs with self-snoop maintain cache coherency
> >even in the presence of aliased memtypes, thus there is no need to trust
> >the guest behaves and only honor PAT as a last resort, as KVM does today.
> >
> >Honoring guest PAT is desirable for use cases where the guest has access
> >to non-coherent DMA _without_ bouncing through VFIO, e.g. when a virtual
> >(mediated, for all intents and purposes) GPU is exposed to the guest, along
> >with buffers that are consumed directly by the physical GPU, i.e. which
> >can't be proxied by the host to ensure writes from the guest are performed
> >with the correct memory type for the GPU.

...

> > int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> >diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> >index 17a8e4fdf9c4..5dc4c24ae203 100644
> >--- a/arch/x86/kvm/vmx/vmx.c
> >+++ b/arch/x86/kvm/vmx/vmx.c
> >@@ -7605,11 +7605,13 @@ static u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
> > 
> > 	/*
> > 	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> >-	 * device attached.  Letting the guest control memory types on Intel
> >-	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> >-	 * the guest to behave only as a last resort.
> >+	 * device attached and the CPU doesn't support self-snoop.  Letting the
> >+	 * guest control memory types on Intel CPUs without self-snoop may
> >+	 * result in unexpected behavior, and so KVM's (historical) ABI is to
> >+	 * trust the guest to behave only as a last resort.
> > 	 */
> >-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> >+	if (!static_cpu_has(X86_FEATURE_SELFSNOOP) &&
> >+	    !kvm_arch_has_noncoherent_dma(vcpu->kvm))
> > 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> 
> W/ this change, guests w/o pass-thru devices can also access UC memory. Locking
> UC memory leads to bus lock. So, guests w/o pass-thru devices can potentially
> launch DOS attacks on other CPUs on host. isn't it a problem?

Guests can already trigger bus locks with atomic accesses that split cache lines.
And SPR adds bus lock detection.  So practically speaking, I'm pretty sure ICX is
the only CPU where anything close to a novel attack is possible.  And FWIW, such
an attack is already possible on AMD.

