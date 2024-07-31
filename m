Return-Path: <kvm+bounces-22766-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BE29431DF
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 16:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5A21B1F262AC
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 14:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0DED1B150A;
	Wed, 31 Jul 2024 14:19:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF051AC458
	for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722435584; cv=none; b=n7L4l0GW+vRtDzWS1lDw7JQ6AJYNQZGDq0gBHSAMIZpUzj9ebsA+EZsca/GQvk+m3wIIjxzfTEacJY2nz8diWjI5HMe0bOZOvwUB12cYv1uM5kjAXaKxSWqo8YGn/T5j5v2o8lzKOUmUYDmicGPu8ICa1ZizlRqMNXESW1N7mlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722435584; c=relaxed/simple;
	bh=UamIZEcb4exf/uLWgnIZsIph0oJXU5Hr/jLfBWXF30Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RzY+IVzUYYBvzCgmLkl1gcdfG9TL6AkHrsKEZjE2PWQwZPv8XOaF3YqgOM6NfPt1xCG7u2Tj5dJtKPG+TuxeR1uN4HRyWdFOKqBcP+cmSpl1CD8vZEE+9ZYt/kKBc0s5EoY+E6bgFekJT3PSuzc8RWFjYwKQvIHYgJKQr7+bQww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A9371007;
	Wed, 31 Jul 2024 07:20:07 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4068B3F5A1;
	Wed, 31 Jul 2024 07:19:40 -0700 (PDT)
Date: Wed, 31 Jul 2024 15:19:37 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>
Subject: Re: [PATCH 00/12] KVM: arm64: nv: Add support for address
 translation instructions
Message-ID: <ZqpH-f5LbrMApVjB@raptor>
References: <20240625133508.259829-1-maz@kernel.org>
 <ZqoMUb_Q6n8J_pYq@raptor>
 <86sevp25a7.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86sevp25a7.wl-maz@kernel.org>

Hi Marc,

On Wed, Jul 31, 2024 at 12:02:24PM +0100, Marc Zyngier wrote:
> On Wed, 31 Jul 2024 11:05:05 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi Marc,
> > 
> > On Tue, Jun 25, 2024 at 02:34:59PM +0100, Marc Zyngier wrote:
> > > Another task that a hypervisor supporting NV on arm64 has to deal with
> > > is to emulate the AT instruction, because we multiplex all the S1
> > > translations on a single set of registers, and the guest S2 is never
> > > truly resident on the CPU.
> > 
> > I'm unfamiliar with the state of NV support in KVM, but I thought I would have a
> > look at when AT trapping is enabled. As far as I can tell, it's only enabled in
> > vhe/switch.c::__activate_traps() -> compute_hcr() if is_hyp_ctct(vcpu). Found
> > this by grep'ing for HCR_AT.
> > 
> > Assuming the above is correct, I am curious about the following:
> > 
> > - The above paragraph mentions guest's stage 2 (and the code takes that into
> >   consideration), yet when is_hyp_ctxt() is true it is likely that the guest
> >   stage 2 is not enabled. Are you planning to enable the AT trap based on
> >   virtual HCR_EL2.VM being set in a later series?
> 
> I don't understand what you are referring to. AT traps and the guest's
> HCR_EL2.VM are totally orthogonal, and are (or at least should be)
> treated independently.

I was referring to what happens when a guest is running at EL1 with virtual
stage 2 enabled and that guest performs an AT instruction. If the stage 1
translation tables are not mapped at virtual stage 2, then KVM should inject a
data abort in the guest hypervisor.

But after thinking about it some more, I guess that's not something that needs
AT trapping: if the stage 1 tables are not mapped in the physical stage 2
(because the level 1 hypervisor unmapped them from the virtual stage 2), then
KVM will get a data abort, and then inject that back into the guest hypervisor.

And as far as I can tell, KVM tracks IPAs becoming unmapped from virtual stage 2
by trapping TLBIs.

So everything looks correct to me, sorry for the noise.

> 
> But more importantly, there are a bunch of cases where you have no
> other choice but trap, and that what I allude to when I say "because
> we multiplex all the S1 translations on a single set of register".
> 
> If I'm running the EL2 part of the guest, and that guest executes an
> AT S1E1R while HCR_EL2.{E2H,TGE}={1,0}, it refers to the guest's EL1&0
> translation regime. I can't let the guest execute it, because it would
> walk its view of the EL2&0 regime. So we need to trap, evaluate what
> the guest is trying to do, and do the walk in the correct context (by
> using the instructions or the SW walk).

Yes, that looks correct to me.

> 
> > 
> > - A guest might also set the HCR_EL2.AT bit in the virtual HCR_EL2 register. I
> >   suppose I have the same question, injecting the exception back into the guest
> >   is going to be handled in another series?
> 
> This is already handled. The guest's HCR_EL2 is always folded into the
> runtime configuration, and the resulting trap handled through the
> existing trap routing infrastructure (see d0fc0a2519a6d, which added
> the triaging of most traps resulting from HCR_EL2).

That explains it then, thanks for digging out the commit id!

Alex

