Return-Path: <kvm+bounces-28924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB48899F346
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 18:51:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71302289510
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2024 16:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149011F76CD;
	Tue, 15 Oct 2024 16:50:56 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899771B21B3;
	Tue, 15 Oct 2024 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729011055; cv=none; b=koplhkfyH/giBxePRAlQg0OjGl+u7etfWjhTc6G7BVfOwa9OQkhIWo5jncjHkD2f6yXwpg4gt3EF5nD5A8iMMom2lx+14FzNIO5jVS9UWWz3377Pj5sreiccP4QpXuFVabM4KAAZBIxd4P0zdsMqqN11rLrRLWEJQtPk4uh8QFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729011055; c=relaxed/simple;
	bh=FUAdEiyh+50MpdGLnlQiguenZ/RFSOSwUrW8eHHQOT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T0m5GafyW1UJfavD6ifZuKLEuqBU7EMeNmqXKA+4LYGiPJPreUSuAsS/U8spg4yXlZWE6RpGOL7giIiVgffOf+z1SV2NdLuyWNdEA0js3sADgivk9NEOwMczfhYHkpXIUTJuNTGAh8kzEPPbRS37fHtmk6k9R4yozmA90GYJoA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD95C4CEC6;
	Tue, 15 Oct 2024 16:50:50 +0000 (UTC)
Date: Tue, 15 Oct 2024 17:50:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, will@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
	wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
	daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
	lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
	mtosatti@redhat.com, sudeep.holla@arm.com,
	misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <Zw6dZ7HxvcHJaDgm@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <086081ed-e2a8-508d-863c-21f2ff7c5490@gentwo.org>

On Tue, Oct 15, 2024 at 09:42:56AM -0700, Christoph Lameter (Ampere) wrote:
> On Tue, 15 Oct 2024, Catalin Marinas wrote:
> > > +			unsigned int loop_count = 0;
> > >  			if (local_clock_noinstr() - time_start > limit) {
> > >  				dev->poll_time_limit = true;
> > >  				break;
> > >  			}
> > > +
> > > +			smp_cond_load_relaxed(&current_thread_info()->flags,
> > > +					      VAL & _TIF_NEED_RESCHED ||
> > > +					      loop_count++ >= POLL_IDLE_RELAX_COUNT);
> >
> > The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
> > never set. With the event stream enabled on arm64, the WFE will
> > eventually be woken up, loop_count incremented and the condition would
> > become true. However, the smp_cond_load_relaxed() semantics require that
> > a different agent updates the variable being waited on, not the waiting
> > CPU updating it itself. Also note that the event stream can be disabled
> > on arm64 on the kernel command line.
> 
> Setting of need_resched() from another processor involves sending an IPI
> after that was set. I dont think we need to smp_cond_load_relaxed since
> the IPI will cause an event. For ARM a WFE would be sufficient.

I'm not worried about the need_resched() case, even without an IPI it
would still work.

The loop_count++ side of the condition is supposed to timeout in the
absence of a need_resched() event. You can't do an smp_cond_load_*() on
a variable that's only updated by the waiting CPU. Nothing guarantees to
wake it up to update the variable (the event stream on arm64, yes, but
that's generic code).

-- 
Catalin

