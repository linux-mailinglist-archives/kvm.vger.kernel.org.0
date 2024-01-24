Return-Path: <kvm+bounces-6853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D268C83B046
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 18:44:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 88A811F2220E
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 17:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F054785C66;
	Wed, 24 Jan 2024 17:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ucR4+2gD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DD07F7CE
	for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 17:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706118242; cv=none; b=ImM4W0RKpQljz4YdJ3VKTzp+/iY559Iaba5b+zl+fEeYSMhQfcPSojAlS05fDQykulTP2MZZwocsQMhJvMT+2TllObi/uMQ5Ud1+dZibzHZt/A3NfVmEKRf6UcIQX8ulZQL6Qqhy0+Q5CIfF6wKS8CgCHvqFZTvrk0TDcu2yVLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706118242; c=relaxed/simple;
	bh=MZHuAtNiL03oEoJHa6bf7Od5Fg8D8o9NBf7iVEHZ9ag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UMJfBKOLYAJO/F5ipTAcxhzWacmHf5qBY30iIH6r1msWvb8juFQ6CMOEnBgaR1pVxBG/vCEBsZ1cb98ZSHRpSlmfx0pPr+DNaXXKCpENJDTfrSCyGX1Am5Rev7jhmaarhMvpBIjKiCw2uKHGeMFoo2Yczup6hM17WAV+NYQVimA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ucR4+2gD; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cfda2f4716so1607626a12.3
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 09:44:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706118240; x=1706723040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=phLGUzO1dl3tbnC30bhE9/nw1oePNjTydqU1ZrBpVgU=;
        b=ucR4+2gDmiF/NDBhyFKzVAnIRpM6+RRFEjKVocLTvKqe+S3ZNF3WKjQHdcr8Tsln5w
         bwJ6d2E9h1LPkW4JGqW7aOcfI3yBXFoIjH7sZY+ui+S6roMemn00rIaIyBYogcW+z67X
         r5Ya3XFPCIx6/ynmJhG/PuXNcx8ev3vU96oIHU/7f0Gg65fi1dQdRRkmRvWBM1pWh4m5
         4ZnT/YUZg0SWL1OgkHfXt53o4D3ybfuhnC5pkdokeRTqNYN0PaHE8i3TulN3WUl0D11T
         1SyPH9wLB+sz6AVWUi1XcXqgaR8jOmwSbKEE8QYcI45i4XAQ+5S0AqF0txU3SSv5QOsD
         lhQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706118240; x=1706723040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=phLGUzO1dl3tbnC30bhE9/nw1oePNjTydqU1ZrBpVgU=;
        b=IsxNbMbsv7nTQ0wmkMevmYBF8A0IyHAqjQSjXT/zXN8XMe5ygbkVPnCG1FkhmRpA5s
         1ObsiXGWomc5C9SIgKv1qDC7jddHl1Z3JIQi74+jqg2utlKXDXAVOhFzdO0VrWUbkmF7
         yJypSBuGoZODhD2ZImY71/hjJJTIWVvdaYrWECzLiaS6oLMqK6FmrVDHnvEqi3HMPi6p
         Y1UCUYSMDpaz51KS4CDjwbCnavfFhFUo5XZSn1s9cdQPh/NDBWGE2z2M48HFduhlPEji
         7/6AqTqFDOxEnV0GPxsgtuaTjdvRtMnxuHl46hI0h6mj6UL7PbBbnEaQA9EWKlm25Le7
         wW3Q==
X-Gm-Message-State: AOJu0YyIdur24fu7VgthFIAhXX9gMinYZDhR72kRxT5IkEf90iQTdweP
	abAoHeWOuW+RBeeGPEaeqFZ2mNqiU+Juw+m8a++zhz8jgoSLXw3p8mNJ37RAFLhRRVynOv9Qn56
	tHA==
X-Google-Smtp-Source: AGHT+IH50wrWLE+dOd9vXG84ZvByuwmloXUXoNDIkK2WvQj7QWsB8hpAZLXMXP/PyBpBzNHdQEpsB43YjN8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:5652:0:b0:5ca:31a3:c70c with SMTP id
 g18-20020a635652000000b005ca31a3c70cmr42150pgm.3.1706118239933; Wed, 24 Jan
 2024 09:43:59 -0800 (PST)
Date: Wed, 24 Jan 2024 09:43:58 -0800
In-Reply-To: <20240124170243.93-1-moehanabichan@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <ZbE7kd9W8csPRjvU@google.com> <20240124170243.93-1-moehanabichan@outlook.com>
Message-ID: <ZbFMXtGmtIMavZKW@google.com>
Subject: Re: Re: [PATCH] KVM: x86: Check irqchip mode before create PIT
From: Sean Christopherson <seanjc@google.com>
To: moehanabi <moehanabichan@gmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com, 
	pbonzini@redhat.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 25, 2024, moehanabi wrote:
> > On Thu, Jan 25, 2024, Brilliant Hanabi wrote:
> > > As the kvm api(https://docs.kernel.org/virt/kvm/api.html) reads,
> > > KVM_CREATE_PIT2 call is only valid after enabling in-kernel irqchip
> > > support via KVM_CREATE_IRQCHIP.
> > > 
> > > Without this check, I can create PIT first and enable irqchip-split
> > > then, which may cause the PIT invalid because of lacking of in-kernel
> > > PIC to inject the interrupt.
> > 
> > Does this cause actual problems beyond the PIT not working for the guest?  E.g.
> > does it put the host kernel at risk?  If the only problem is that the PIT doesn't
> > work as expected, I'm tempted to tweak the docs to say that KVM's PIT emulation
> > won't work without an in-kernel I/O APIC.  Rejecting the ioctl could theoertically
> > break misconfigured setups that happen to work, e.g. because the guest never uses
> > the PIT.
> 
> I don't think it will put the host kernel at risk. But that's exactly what
> kvmtool does: it creates in-kernel PIT first and set KVM_CREATE_IRQCHIP then.

Right.  My concern, which could be unfounded paranoia, is that rejecting an ioctl()
that used to succeed could break existing setups.  E.g. if a userspace VMM creates
a PIT and checks the ioctl() result, but its guest(s) never actually use the PIT
and so don't care that the PIT is busted.

> I found this problem because I was working on implementing a userspace PIC
> and PIT in kvmtool. As I planned, I'm going to commit a related patch to 
> kvmtool if this patch will be applied.
> 
> > > Signed-off-by: Brilliant Hanabi <moehanabichan@gmail.com>
> > > ---
> > >  arch/x86/kvm/x86.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 27e23714e960..3edc8478310f 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -7016,6 +7016,8 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
> > >  		r = -EEXIST;
> > >  		if (kvm->arch.vpit)
> > >  			goto create_pit_unlock;
> > > +		if (!pic_in_kernel(kvm))
> > > +			goto create_pit_unlock;
> > 
> > -EEXIST is not an appropriate errno.
> 
> Which errno do you think is better?

Maybe ENOENT?

