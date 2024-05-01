Return-Path: <kvm+bounces-16366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E3458B8F53
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D2025283E65
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 18:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279791474BA;
	Wed,  1 May 2024 18:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OKthm/ur"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572FF146D60
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714586503; cv=none; b=Ukhe40PFPbA5rILZLauQ/lXB3Q3AFUHRzx7ILGHe6gc+ePGh1HRKdHC2lxDZaLzB+FS/0GXby0RtAMaPRR+TZJQ5ai7fkU67gd0t4UaVyFpOCq8R/jM1xOD0xuXAphRgxEpds9lVBlJYecVhNygUs9f35yFtomyJ2z6RpPMb2vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714586503; c=relaxed/simple;
	bh=zjpxgyAK4GAbrd3HGC5s/4QO74a8GhDO3MiVtLjfZEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVu3hMXiE2N2y3+1GWTk1o2FKgMnYFxN/1W/g4fPNpj5puIY8147MbUXhYRv0waxNVjs/rgPjwF75FzvUYWdaBqVH1E8FdtjDCx5BOIWOor10zySA5XWjv/gfCDkAlL7XRxazOXt26/Fz8rkqODpFhEW4ACnq33tler7kN7Mohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OKthm/ur; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 1 May 2024 18:01:31 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1714586499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=69cqu9i0hgyzyuHYDqr+vrRYe6XfjRaXapX+zs6xjnE=;
	b=OKthm/ur+byGKYcHm2DPTNC5z/URFbkOGPadzI7eiZzZ5mezBuOrZl7iO90ODYz9fRbgEy
	6ouYU5nahmPlBewz9DVswxKYUkCE/I5p4/wec5b9+XAdcs6XajZ/4HudNHe28xxU0lQwpd
	WHY0DzOGslb59/2viaOe877XKsJlqEk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Anup Patel <anup@brainfault.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: Fold kvm_arch_sched_in() into
 kvm_arch_vcpu_load()
Message-ID: <ZjKDe6SlVWGj0ugA@linux.dev>
References: <20240430193157.419425-1-seanjc@google.com>
 <ZjGMn5tlq8edKZYv@linux.dev>
 <ZjJRhQhX_12eBvY-@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZjJRhQhX_12eBvY-@google.com>
X-Migadu-Flow: FLOW_OUT

On Wed, May 01, 2024 at 07:28:21AM -0700, Sean Christopherson wrote:
> On Wed, May 01, 2024, Oliver Upton wrote:
> > On Tue, Apr 30, 2024 at 12:31:53PM -0700, Sean Christopherson wrote:
> > > Drop kvm_arch_sched_in() and instead pass a @sched_in boolean to
> > > kvm_arch_vcpu_load().
> > > 
> > > While fiddling with an idea for optimizing state management on AMD CPUs,
> > > I wanted to skip re-saving certain host state when a vCPU is scheduled back
> > > in, as the state (theoretically) shouldn't change for the task while it's
> > > scheduled out.  Actually doing that was annoying and unnecessarily brittle
> > > due to having a separate API for the kvm_sched_in() case (the state save
> > > needed to be in kvm_arch_vcpu_load() for the common path).
> > > 
> > > E.g. I could have set a "temporary"-ish flag somewhere in kvm_vcpu, but (a)
> > > that's gross and (b) it would rely on the arbitrary ordering between
> > > sched_in() and vcpu_load() staying the same.
> > 
> > Another option would be to change the rules around kvm_arch_sched_in()
> > where the callee is expected to load the vCPU context.
> > 
> > The default implementation could just call kvm_arch_vcpu_load() directly
> > and the x86 implementation can order things the way it wants before
> > kvm_arch_vcpu_load().
> > 
> > I say this because ...
> > 
> > > The only real downside I see is that arm64 and riscv end up having to pass
> > > "false" for their direct usage of kvm_arch_vcpu_load(), and passing boolean
> > > literals isn't ideal.  But that can be solved by adding an inner helper that
> > > omits the @sched_in param (I almost added a patch to do that, but I couldn't
> > > convince myself it was necessary).
> > 
> > Needing to pass @sched_in for other usage of kvm_arch_vcpu_load() hurts
> > readability, especially when no other architecture besides x86 cares
> > about it.
> 
> Yeah, that bothers me too.
> 
> I tried your suggestion of having x86's kvm_arch_sched_in() do kvm_arch_vcpu_load(),
> and even with an added kvm_arch_sched_out() to provide symmetry, the x86 code is
> kludgy, and even the common code is a bit confusing as it's not super obvious
> that kvm_sched_{in,out}() is really just kvm_arch_vcpu_{load,put}().
> 
> Staring a bit more at the vCPU flags we have, adding a "bool scheduled_out" isn't
> terribly gross if it's done in common code and persists across load() and put(),
> i.e. isn't so blatantly a temporary field.  And because it's easy, it could be
> set with WRITE_ONCE() so that if it can be read cross-task if there's ever a
> reason to do so.
> 
> The x86 code ends up being less ugly, and adding future arch/vendor code for
> sched_in() *or* sched_out() requires minimal churn, e.g. arch code doesn't need
> to override kvm_arch_sched_in().
> 
> The only weird part is that vcpu->preempted and vcpu->ready have slightly
> different behavior, as they are cleared before kvm_arch_vcpu_load().  But the
> weirdness is really with those flags no having symmetry, not with scheduled_out
> itself.
> 
> Thoughts?

Yeah, this seems reasonable. Perhaps scheduled_out could be a nice hint
for guardrails / sanity checks in the future.

-- 
Thanks,
Oliver

