Return-Path: <kvm+bounces-49525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F3092AD96A2
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 22:48:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93EAD189FE30
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 20:48:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE5524169B;
	Fri, 13 Jun 2025 20:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AqDvl1P8"
X-Original-To: kvm@vger.kernel.org
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8A92253B0
	for <kvm@vger.kernel.org>; Fri, 13 Jun 2025 20:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749847677; cv=none; b=GYEcymQ8M0vbOyBwHgeoCWmsqlaG4htVHvMmoFUq0wbkiJ1rExMVElcr3AjQ/RVshPD6FG6CBoq3kaMAOV3R8FMd0SyzzC1Z/rii9sZBIwckAH0o+o+jfHteLFqNpvT2+wlslxJjm7f9IJpVRkROgmr5fkwT2BG1VOJV/9UKyhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749847677; c=relaxed/simple;
	bh=3scu/ROOszjXP8l+ZNlZwQryx02bu/GUqC4buj307io=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUcB4fLkBej9FuO1mh1jWd/cxzUQwZ7gyWV21Q6uHnNW/BJvw2c2QtlxBK2hIp2JSuQXYQdxMIjEdUix10QT6cMYV2fp5gIVvWuYRotne7nQKyq3uHkWg2Kjf4Bd/m0hrfdYamdXsdB094B4nkW0RUY9o9c/bU904XdzHFLEUgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AqDvl1P8; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 13 Jun 2025 13:47:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1749847671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g3QpAmNx5DNk1sdY/iNHtbL5cVsrP4TaKvA4vwlUxSU=;
	b=AqDvl1P8NSuH5w8c2k3rrqa4tztuUbtzwZhM8R58zilGZUEQn3cguoYb3i7WeQil7suGSN
	TUl3XKReXwAFZSIE40AuXO/BLTeer3hKffnbZb/Q2xvuMFJgLwLYcVAtx4dcUND5W926Fm
	Nikn5r4AiputfvGWyYEK/a9eli+bP1g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
Message-ID: <aEyOcJJsys9mm_Xs@linux.dev>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-4-seanjc@google.com>
 <86tt4lcgs3.wl-maz@kernel.org>
 <aErlezuoFJ8u0ue-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aErlezuoFJ8u0ue-@google.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Jun 12, 2025 at 07:34:35AM -0700, Sean Christopherson wrote:
> On Thu, Jun 12, 2025, Marc Zyngier wrote:
> > On Wed, 11 Jun 2025 23:45:05 +0100,
> > Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > WARN if unmapping a vLPI in kvm_vgic_v4_unset_forwarding() fails, as
> > > failure means an IRTE has likely been left in a bad state, i.e. IRQs
> > > won't go where they should.
> > 
> > I have no idea what an IRTE is.
> 
> Sorry, x86 IOMMU terminology (Interrupt Remapping Table Entry).  I think the GIC
> terminology would be ITS entry?  Or maybe ITS mapping?

We tend to just call it a 'vLPI mapping', which under the hood implies
a couple other translations have been wired up as well (vPE + Device).

> > But not having an VLPI mapping for an interrupt at the point where we're
> > tearing down the forwarding is pretty benign. IRQs *still* go where they
> > should, and we don't lose anything.

The VM may not actually be getting torn down, though. The series of
fixes [*] we took for 6.16 addressed games that VMMs might be playing on
irqbypass for a live VM.

[*] https://lore.kernel.org/kvmarm/20250523194722.4066715-1-oliver.upton@linux.dev/

> All of those failure scenario seem like warnable offences when KVM thinks it has
> configured the IRQ to be forwarded to a vCPU.

I tend to agree here, especially considering how horribly fragile GICv4
has been in some systems. I know of a couple implementations where ITS
command failures and/or unmapped MSIs are fatal for the entire machine.
Debugging them has been a genuine pain in the ass.

WARN'ing when state tracking for vLPIs is out of whack would've made it
a little easier.

Thanks,
Oliver

