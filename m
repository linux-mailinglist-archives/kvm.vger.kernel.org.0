Return-Path: <kvm+bounces-50707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F15AE885B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:38:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9D834A2D94
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F5828D8FB;
	Wed, 25 Jun 2025 15:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dv2z/It3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6EA81E1C3F;
	Wed, 25 Jun 2025 15:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750865896; cv=none; b=b/Wg/IN/mn4/+de3F+T3m0Et3x60NCw2uUY+xwQgdHhKXmCD0Gwy+f5c5n38bFizbGe9hfJlkHalyzjRfDhYlYRX9UDi7Wa8ipJzSp7WKgXUhecoBgDS2RH4ykXPlZ3nY/HSEvlaE2YKY8PqXIpr22PomH0wmYDBlOUpflPl5as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750865896; c=relaxed/simple;
	bh=DdxS8fK+k+4jJXT/e+VE5Z7hLWA+bNaknSmckFwX8wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MtGExylV9Ra2BlnH4Ne3hHHkyGaZyGmZedANE6flFXYg40Mxa7NkPoTFreAVgcJq2OTyFLlJjBZP9H2pDgDAyghdVjJP4rs4iOMc4Y7JkR5ukfRX+DRI5gf0t49aRkbC/TfhV8+9lLpvmYO2nJX6CH51eavpH5bxX3jdpofxU8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dv2z/It3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CC2C4CEEA;
	Wed, 25 Jun 2025 15:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750865895;
	bh=DdxS8fK+k+4jJXT/e+VE5Z7hLWA+bNaknSmckFwX8wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dv2z/It31S17vagV0qD/YG5Cs2xuaGCisG/MbnWq93zzaUaUrXfiITmuJmPyJHwj2
	 nuYNJ9rGhpx/rmwcVlVvK8JVPDARGPgUOiSjlIwptVSwOUXYz20nLXVgoGzjl4GnvY
	 LPtfY5IWEoNiJ/TJy+BqTqea3mtmXtFONVvBzy5/xqT4jDN2G40iQOremK7E9wCqTi
	 DBbEfJsTzL8nVPUCssNUtOU8I2AXv63MDwg9llG0CBQd5uCbM7k5iAmGPdjPLhACi3
	 r9Pk4sC1SWmvJqzefP6200Jp81E1uqxJnpuzPsYH+VL/KdRMihIBWKc8gyvuQ25wFq
	 alh8oPqaYSR9w==
Date: Wed, 25 Jun 2025 20:58:16 +0530
From: Naveen N Rao <naveen@kernel.org>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>, 
	Vasant Hegde <vasant.hegde@amd.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Joao Martins <joao.m.martins@oracle.com>, Francesco Lavra <francescolavra.fl@gmail.com>, 
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 20/62] KVM: SVM: Add a comment to explain why
 avic_vcpu_blocking() ignores IRQ blocking
Message-ID: <ha3rq3ybk4c63bov2ix6yyajggep6zdulsd2e44vqw4ctufeiq@env4pl5m3wz6>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-22-seanjc@google.com>
 <pxtvegopzsyhn7lelksclxiiee7tumppu76553rax7octqpy7i@giclgo667htf>
 <aFl-ZYyf9guxSkHE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFl-ZYyf9guxSkHE@google.com>

On Mon, Jun 23, 2025 at 09:18:45AM -0700, Sean Christopherson wrote:
> On Mon, Jun 23, 2025, Naveen N Rao wrote:
> > On Wed, Jun 11, 2025 at 03:45:23PM -0700, Sean Christopherson wrote:
> > > Add a comment to explain why KVM clears IsRunning when putting a vCPU,
> > > even though leaving IsRunning=1 would be ok from a functional perspective.
> > > Per Maxim's experiments, a misbehaving VM could spam the AVIC doorbell so
> > > fast as to induce a 50%+ loss in performance.
> > > 
> > > Link: https://lore.kernel.org/all/8d7e0d0391df4efc7cb28557297eb2ec9904f1e5.camel@redhat.com
> > > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/svm/avic.c | 31 ++++++++++++++++++-------------
> > >  1 file changed, 18 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index bf8b59556373..3cf929ac117f 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -1121,19 +1121,24 @@ void avic_vcpu_blocking(struct kvm_vcpu *vcpu)
> > >  	if (!kvm_vcpu_apicv_active(vcpu))
> > >  		return;
> > >  
> > > -       /*
> > > -        * Unload the AVIC when the vCPU is about to block, _before_
> > > -        * the vCPU actually blocks.
> > > -        *
> > > -        * Any IRQs that arrive before IsRunning=0 will not cause an
> > > -        * incomplete IPI vmexit on the source, therefore vIRR will also
> > > -        * be checked by kvm_vcpu_check_block() before blocking.  The
> > > -        * memory barrier implicit in set_current_state orders writing
> > > -        * IsRunning=0 before reading the vIRR.  The processor needs a
> > > -        * matching memory barrier on interrupt delivery between writing
> > > -        * IRR and reading IsRunning; the lack of this barrier might be
> > > -        * the cause of errata #1235).
> > > -        */
> > > +	/*
> > > +	 * Unload the AVIC when the vCPU is about to block, _before_ the vCPU
> > > +	 * actually blocks.
> > > +	 *
> > > +	 * Note, any IRQs that arrive before IsRunning=0 will not cause an
> > > +	 * incomplete IPI vmexit on the source; kvm_vcpu_check_block() handles
> > > +	 * this by checking vIRR one last time before blocking.  The memory
> > > +	 * barrier implicit in set_current_state orders writing IsRunning=0
> > > +	 * before reading the vIRR.  The processor needs a matching memory
> > > +	 * barrier on interrupt delivery between writing IRR and reading
> > > +	 * IsRunning; the lack of this barrier might be the cause of errata #1235).
> > > +	 *
> > > +	 * Clear IsRunning=0 even if guest IRQs are disabled, i.e. even if KVM
> > > +	 * doesn't need to detect events for scheduling purposes.  The doorbell
> > 
> > Nit: just IsRunning (you can drop the =0 part).
> 
> Hmm, not really.  It could be:
> 
> 	/* Note, any IRQs that arrive while IsRunning is set will not cause an
> 
> or
> 
> 	/* Note, any IRQs that arrive while IsRunning=1 will not cause an
> 
> but that's just regurgitating the spec.  The slightly more interesting scenario
> that's being described here is what will happen if an IRQ arrives _just_ before
> the below code toggle IsRunning from 1 => 0.

Oh, you're right. I was referring to the last paragraph starting with 
"Clear IsRunning=0 even if", which to me feels like a double negation. 
It reads better if it is "Clear IsRunning even if ..."

> 
> > Trying to understand the significance of IRQs being disabled here. Is 
> > that a path KVM tries to optimize?
> 
> Yep.  KVM doesn't need a notification for the undelivered (virtual) IRQ, because
> it won't be handled by the vCPU until the vCPU enables IRQs, and thus it's not a
> valid wake event for the vCPU.
> 
> So, *if* spurious doorbells didn't affect performance or functionality, then
> ideally KVM would leave IsRunning=1, e.g. so that the IOMMU doesn't need to
> generate GA log events, and so that other vCPUs aren't forced to VM-Exit when
> sending an IPI.  Unfortunately, spurious doorbells are quite intrusive, and so
> KVM "needs" to clear IsRunning.

Ok, got that. kvm_arch_vcpu_blocking() looks like it exists precisely 
for this reason.

Thanks,
Naveen


