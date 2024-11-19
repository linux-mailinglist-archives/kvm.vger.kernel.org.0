Return-Path: <kvm+bounces-32036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 978819D1C2D
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 01:17:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E7FBB22868
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 00:17:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 695A61AAC4;
	Tue, 19 Nov 2024 00:17:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBC81798C;
	Tue, 19 Nov 2024 00:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731975463; cv=none; b=KyX13I5H7KRIZbxFlqQBfNGYlt0z4lLnG7o6LbvDpQ2yLkze85U+ZY0O9Ai5/3jf6ac4VMnidlqTC/g1FWE23MAMYoRyAf35qZ8xRWeb756RTP63EyUvOznNc3+IE2ddqs7JTY5Y0WHLt/FewvWELtD6h0Bdk6cw9eboMAC+8Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731975463; c=relaxed/simple;
	bh=6HTj8ySQcTLZ6Mfq0r9+KjeFhw4vyi/iOb/axvI0vVI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rzDy0uwRP1bfhUCr2zc6cS8hET28+wyL0ZvsxM/iOIMdHfMkuvRZheefaBwbvZfZVMrIBvc5L3XrD5BMrzm/zXPhThmCv836Cf12xah2h2sd+kJaFIommExGqB3K9GiN3sdrAEcfQxowU/3+0DfARHjWrh9ktNTg/94XL+v1zXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8E0C4CECF;
	Tue, 19 Nov 2024 00:17:41 +0000 (UTC)
Date: Mon, 18 Nov 2024 19:18:13 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Joel Fernandes <joelaf@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, Mel Gorman
 <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Paolo Bonzini
 <pbonzini@redhat.com>, seanjc@google.com, Srikar Dronamraju
 <srikar@linux.ibm.com>, David Woodhouse <dwmw2@infradead.org>,
 vineethrp@google.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 ssouhlal@freebsd.org
Subject: Re: [PATCH v3] sched: Don't try to catch up excess steal time.
Message-ID: <20241118191813.145031fc@gandalf.local.home>
In-Reply-To: <CAJWu+oqR=SMKHd1EqvRm3nvz7e1r4e7Rj76hJ8jhDQQkNVo0ig@mail.gmail.com>
References: <20241118043745.1857272-1-suleiman@google.com>
	<20241118143311.3ca94405@gandalf.local.home>
	<CAJWu+oqR=SMKHd1EqvRm3nvz7e1r4e7Rj76hJ8jhDQQkNVo0ig@mail.gmail.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 19 Nov 2024 09:10:41 +0900
Joel Fernandes <joelaf@google.com> wrote:

> > > +++ b/kernel/sched/core.c
> > > @@ -766,13 +766,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
> > >  #endif
> > >  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> > >       if (static_key_false((&paravirt_steal_rq_enabled))) {
> > > -             steal = paravirt_steal_clock(cpu_of(rq));
> > > +             u64 prev_steal;
> > > +
> > > +             steal = prev_steal = paravirt_steal_clock(cpu_of(rq));
> > >               steal -= rq->prev_steal_time_rq;
> > >
> > >               if (unlikely(steal > delta))
> > >                       steal = delta;  
> >
> > So is the problem just the above if statement? That is, delta is already
> > calculated, but if we get interrupted by the host before steal is
> > calculated and the time then becomes greater than delta, the time
> > difference between delta and steal gets pushed off to the next task, right?  
> 
> Pretty much.. the steal being capped to delta means the rest of the
> steal is pushed off to the future. Instead he discards the remaining
> steal after this patch.

Thanks for confirming. I just wanted to make sure I understand as the
initial change log went into a lot of detail where I sorta got lost ;-)

-- Steve

