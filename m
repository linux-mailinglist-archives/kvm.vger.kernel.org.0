Return-Path: <kvm+bounces-29079-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF8E9A2470
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 16:02:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CCB321F23BF5
	for <lists+kvm@lfdr.de>; Thu, 17 Oct 2024 14:02:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6D41DE3AF;
	Thu, 17 Oct 2024 14:01:55 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA96439FE5;
	Thu, 17 Oct 2024 14:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729173714; cv=none; b=APEKMNaaSkJY3ZrMv3CbYP+hKWbPFu+GX1do4KpEVf7gCvGOAtaML8Hrlgz/Em/cN2rIAj6CMiphy7Ym7pntI0ZkhaZA5KcBf62lSmqH9Gj+K6mfQqRBYNmOHI0hGu+o9bWVrZ2B9nmZs7rVI6yoDiKnq9m6Li+Nexqt8pZBVY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729173714; c=relaxed/simple;
	bh=YIGa7aKF3zPBjTfPQwEODkjyQxe13e+PbHCs5IPylfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqX/Fj4v7D1CHtaOjLwSkdrdSEzQDusF8li+I4TgINOkYbB2dPK4f6QiTh3xAEMmXQ44wdtSLYRJZ6sveV+caz+VO81BxnJkHIZmZtt7UqjQqFiVYNfOeCf5rqBQRTGPX4TM8jIKGisReT/FYoKlQ2PFTEeTMcYqWASv9Q2bN7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D0FC4CEC3;
	Thu, 17 Oct 2024 14:01:49 +0000 (UTC)
Date: Thu, 17 Oct 2024 15:01:47 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "ankur.a.arora@oracle.com" <ankur.a.arora@oracle.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"sudeep.holla@arm.com" <sudeep.holla@arm.com>,
	"joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
	"wanpengli@tencent.com" <wanpengli@tencent.com>,
	"cl@gentwo.org" <cl@gentwo.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"misono.tomohiro@fujitsu.com" <misono.tomohiro@fujitsu.com>,
	"daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
	"arnd@arndb.de" <arnd@arndb.de>,
	"lenb@kernel.org" <lenb@kernel.org>,
	"will@kernel.org" <will@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>,
	"mtosatti@redhat.com" <mtosatti@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"mark.rutland@arm.com" <mark.rutland@arm.com>
Subject: Re: [PATCH v8 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed()
Message-ID: <ZxEYy9baciwdLnqh@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20240925232425.2763385-2-ankur.a.arora@oracle.com>
 <Zw5aPAuVi5sxdN5-@arm.com>
 <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f7ffdcdb79eee0e8a545f544120495477832cd5.camel@amazon.com>

On Wed, Oct 16, 2024 at 03:13:33PM +0000, Okanovic, Haris wrote:
> On Tue, 2024-10-15 at 13:04 +0100, Catalin Marinas wrote:
> > On Wed, Sep 25, 2024 at 04:24:15PM -0700, Ankur Arora wrote:
> > > diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> > > index 9b6d90a72601..fc1204426158 100644
> > > --- a/drivers/cpuidle/poll_state.c
> > > +++ b/drivers/cpuidle/poll_state.c
> > > @@ -21,21 +21,20 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
> > > 
> > >       raw_local_irq_enable();
> > >       if (!current_set_polling_and_test()) {
> > > -             unsigned int loop_count = 0;
> > >               u64 limit;
> > > 
> > >               limit = cpuidle_poll_time(drv, dev);
> > > 
> > >               while (!need_resched()) {
> > > -                     cpu_relax();
> > > -                     if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> > > -                             continue;
> > > -
> > > -                     loop_count = 0;
> > > +                     unsigned int loop_count = 0;
> > >                       if (local_clock_noinstr() - time_start > limit) {
> > >                               dev->poll_time_limit = true;
> > >                               break;
> > >                       }
> > > +
> > > +                     smp_cond_load_relaxed(&current_thread_info()->flags,
> > > +                                           VAL & _TIF_NEED_RESCHED ||
> > > +                                           loop_count++ >= POLL_IDLE_RELAX_COUNT);
> > 
> > The above is not guaranteed to make progress if _TIF_NEED_RESCHED is
> > never set. With the event stream enabled on arm64, the WFE will
> > eventually be woken up, loop_count incremented and the condition would
> > become true. However, the smp_cond_load_relaxed() semantics require that
> > a different agent updates the variable being waited on, not the waiting
> > CPU updating it itself. Also note that the event stream can be disabled
> > on arm64 on the kernel command line.
> 
> Alternately could we condition arch_haltpoll_want() on
> arch_timer_evtstrm_available(), like v7?

No. The problem is about the smp_cond_load_relaxed() semantics - it
can't wait on a variable that's only updated in its exit condition. We
need a new API for this, especially since we are changing generic code
here (even it was arm64 code only, I'd still object to such
smp_cond_load_*() constructs).

-- 
Catalin

