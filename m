Return-Path: <kvm+bounces-11495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E70F877A7C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 05:57:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ABE7C1F221A4
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 04:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64BD479F6;
	Mon, 11 Mar 2024 04:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UGqSue40"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CC0748F
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 04:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710133063; cv=none; b=tfB5gz+vUsqt+dcV40OBD9zXA64YM3pQGldvkS/K5XnlWfOP0bq4g/mT/XNA69fVPbjO8CF1Wn2gLZeXBEr/GPMqWAz5jrp9s1nPXh29U3NK8kgMFkJPxXykkQjZ5sHgbbzJHaseRMkHHfcD3b0s06li7s5of2B2Y2Ft5q3ZZFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710133063; c=relaxed/simple;
	bh=xjQzlJl9OraInuNo/twNVtJ2VMOlG7ZoZONnXTUCgoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QdJuLh7Y9TPO7aBdckZXR7xQ7Fxe7A4xSiJKge0DGjC6raNJtU+01tlqg7xOAnWNkBi4uoungyLxhIlgAHOcOCkO78cePhYAIkY1TUsLVktFGXQlv3y+fCBqeIW5/BMA4e9CaTqK0VdHe34nexjLMPGaCUn0lT9lAAaJ29ZKyIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UGqSue40; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Sun, 10 Mar 2024 21:57:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1710133058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z8//AGzztt4+rMVOK6OmLLzYmbCGtHTn6bRJ5+iBV8U=;
	b=UGqSue40cB4RjIDDEcEFeUbFzFKCggFcnLT5+OLC/YIEGbEiJQ6HbgJu5db+qay05sVOiX
	KqwTa3NW0ZXPRl+Z1ZxIWs2k9pJdxcpWLCE2toy0OpFe5HWEqOeddHGjQXdQ/FtcE7XirM
	Zz+INmRszTZKQgiUiWHcvqMFnM5R0C4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v4 2/3] KVM: arm64: selftests: Guarantee interrupts are
 handled
Message-ID: <Ze6PMRMfIK8z0q4F@thinky-boi>
References: <20240307183907.1184775-1-coltonlewis@google.com>
 <20240307183907.1184775-3-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307183907.1184775-3-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

nitpick: Shortlog should read

  KVM: selftests: Ensure pending interrupts are handled in arch_timer test

The fact that we're dealing with pending interrupts is critical here;
the ISB has no interaction with the GIC in terms of interrupt timing as
it gets to the PE.

On Thu, Mar 07, 2024 at 06:39:06PM +0000, Colton Lewis wrote:
> Break up the asm instructions poking daifclr and daifset to handle
> interrupts. R_RBZYL specifies pending interrupts will be handle after
> context synchronization events such as an ISB.
> 
> Introduce a function wrapper for the WFI instruction.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
>  tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
>  tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index d3bf584d2cc1..85f182704d79 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
>  	KVM_INJECT_MULTI(cmd, first_intid, num);
>  
>  	while (irq_handled < num) {
> -		asm volatile("wfi\n"
> -			     "msr daifclr, #2\n"
> -			     /* handle IRQ */
> -			     "msr daifset, #2\n"
> -			     : : : "memory");
> +		gic_wfi();
> +		local_irq_enable();
> +		isb();
> +		/* handle IRQ */
> +		local_irq_disable();

Sorry, this *still* annoys me. Please move the comment above the ISB,
you're documenting a behavior that is implied by the instruction, not
anything else.

>  	}
> -	asm volatile("msr daifclr, #2" : : : "memory");
> +	local_irq_enable();
>  
>  	GUEST_ASSERT_EQ(irq_handled, num);
>  	for (i = first_intid; i < num + first_intid; i++)
> diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
> index 9043eaef1076..f474714e4cb2 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/gic.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
> @@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
>  bool gic_irq_get_pending(unsigned int intid);
>  void gic_irq_set_config(unsigned int intid, bool is_edge);
>  
> +/* Execute a Wait For Interrupt instruction. */
> +void gic_wfi(void);
> +
>  #endif /* SELFTEST_KVM_GIC_H */
> diff --git a/tools/testing/selftests/kvm/lib/aarch64/gic.c b/tools/testing/selftests/kvm/lib/aarch64/gic.c
> index 9d15598d4e34..392e3f581ae0 100644
> --- a/tools/testing/selftests/kvm/lib/aarch64/gic.c
> +++ b/tools/testing/selftests/kvm/lib/aarch64/gic.c
> @@ -164,3 +164,8 @@ void gic_irq_set_config(unsigned int intid, bool is_edge)
>  	GUEST_ASSERT(gic_common_ops);
>  	gic_common_ops->gic_irq_set_config(intid, is_edge);
>  }
> +
> +void gic_wfi(void)
> +{
> +	asm volatile("wfi");
> +}

Ok, I left a comment about this last time...

WFI instructions are only relevant in the context of a PE, so it would
be natural to add such a helper to aarch64/processor.h. There are
definitely implementations out there that do not use a GIC and still
have WFI instructions.

-- 
Thanks,
Oliver

