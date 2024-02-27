Return-Path: <kvm+bounces-10090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E1E0B869899
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 15:41:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 78C241F21B97
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 14:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC91713B798;
	Tue, 27 Feb 2024 14:41:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6892F16423
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 14:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044886; cv=none; b=HYWpz9w3tVzhcvBglPv/RQtVzyCxkg5rvGb2ELc0GNGvC1OaOff1AP3OdeVMn9EdFQ2JyDfMzJpM2+KXOg5oqitF8B1LJ/9uvBgIWRhBE8GUMITejsiWLonRldMTDI68F3EjTlJ5jHrqEvpyj6eAY5kCBfHJotzxIxZ6Mq7NX9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044886; c=relaxed/simple;
	bh=MYsw92l+jB195Q/VNlcZ62mYs47pxQnaKyTW6lSbLic=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BW2S26hQx3bN89M+1vVBR7TWs/57kW0kE4emRskMAinQx8su++DxtHvRDKpaa1z4EAQyEhVfkMMHoZrrr/oYBXGfpBuM504KsGkUcPtvP79S6BvZIOrD8FZUwqdaxjT4JnEJzoz2PVpbQRIYgBlNXEJwswfWP4wc4fB3Sz3D4yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590BCC433C7;
	Tue, 27 Feb 2024 14:41:24 +0000 (UTC)
Date: Tue, 27 Feb 2024 09:43:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, Paul
 Durrant <paul@xen.org>, Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj
 <mhal@rbox.co>, Paul Durrant <pdurrant@amazon.com>, David Woodhouse
 <dwmw@amazon.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Peter Zijlstra
 <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, "H.
 Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v2 7/8] KVM: x86/xen: avoid blocking in hardirq context
 in kvm_xen_set_evtchn_fast()
Message-ID: <20240227094326.04fd2b09@gandalf.local.home>
In-Reply-To: <20240227115648.3104-8-dwmw2@infradead.org>
References: <20240227115648.3104-1-dwmw2@infradead.org>
	<20240227115648.3104-8-dwmw2@infradead.org>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Feb 2024 11:49:21 +0000
David Woodhouse <dwmw2@infradead.org> wrote:

> diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
> index c16b6d394d55..d8b5326ecebc 100644
> --- a/arch/x86/kvm/xen.c
> +++ b/arch/x86/kvm/xen.c
> @@ -1736,9 +1736,23 @@ static int set_shinfo_evtchn_pending(struct kvm_vcpu *vcpu, u32 port)
>  	unsigned long flags;
>  	int rc = -EWOULDBLOCK;
>  
> -	read_lock_irqsave(&gpc->lock, flags);
> +	local_irq_save(flags);
> +	if (!read_trylock(&gpc->lock)) {

Note, directly disabling interrupts in PREEMPT_RT is just as bad as doing
so in non RT and the taking a mutex.

Worse yet, in PREEMPT_RT read_unlock_irqrestore() isn't going to re-enable
interrupts.

Not really sure what the best solution is here.

-- Steve


> +		/*
> +		 * When PREEMPT_RT turns locks into mutexes, rwlocks are
> +		 * turned into mutexes and most interrupts are threaded.
> +		 * But timer events may be delivered in hardirq mode due
> +		 * to using HRTIMER_MODE_ABS_HARD. So bail to the slow
> +		 * path if the trylock fails in interrupt context.
> +		 */
> +		if (in_interrupt())
> +			goto out;
> +
> +		read_lock(&gpc->lock);
> +	}
> +
>  	if (!kvm_gpc_check(gpc, PAGE_SIZE))
> -		goto out;
> +		goto out_unlock;
>  
>  	if (IS_ENABLED(CONFIG_64BIT) && kvm->arch.xen.long_mode) {
>  		struct shared_info *shinfo = gpc->khva;

