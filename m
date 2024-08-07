Return-Path: <kvm+bounces-23460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E052C949C98
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 02:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A17B1C216BB
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 00:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E76291C27;
	Wed,  7 Aug 2024 00:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b="QlS52S3B"
X-Original-To: kvm@vger.kernel.org
Received: from mx2.freebsd.org (mx2.freebsd.org [96.47.72.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1FB163;
	Wed,  7 Aug 2024 00:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=96.47.72.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722989296; cv=pass; b=L3JnPMFrQ3DNSTz71eCEJKUSZd8U4TPKSLfrZ9S0qLsSacS33K6oVrX4u21YmjCvjnZ7pcIA2GOmSKlMBqsDDee5hl/D9QI3NMeaVzdnlOydkc8SsZYSFlMyr2QlUgJTmx5WdKgNM2AA5xMaYSr7jyDw9D3eQo9ceCcXdDzhW7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722989296; c=relaxed/simple;
	bh=KdgT8VefBeru5DFw/5nMoPdJMjL5wZeP202EITVIimo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+1gnk7rKKV9IzsH3CgaX7Zmh+2+kmN7fx8fWMrc3PTMI/rI6mmbORMwbYh70dvJvzqZhLK2ivZ3HSQkqO0G6XnfQJog+aBzIsLh4wM01n9YJ3WIKemnnJO8CH+4JUYBPkv//XYA8B7o0PlWIEnCnB2DjCHGBRzsT6H66CgH4zs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org; spf=pass smtp.mailfrom=freebsd.org; dkim=pass (2048-bit key) header.d=freebsd.org header.i=@freebsd.org header.b=QlS52S3B; arc=pass smtp.client-ip=96.47.72.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=freebsd.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=freebsd.org
Received: from mx1.freebsd.org (mx1.freebsd.org [IPv6:2610:1c1:1:606c::19:1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits)
	 client-signature RSA-PSS (4096 bits))
	(Client CN "mx1.freebsd.org", Issuer "R10" (verified OK))
	by mx2.freebsd.org (Postfix) with ESMTPS id 4Wdr9L66Wlz4SP8;
	Wed,  7 Aug 2024 00:08:06 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
Received: from freefall.freebsd.org (freefall.freebsd.org [IPv6:2610:1c1:1:6074::16:84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
	 client-signature RSA-PSS (4096 bits) client-digest SHA256)
	(Client CN "freefall.freebsd.org", Issuer "R11" (verified OK))
	by mx1.freebsd.org (Postfix) with ESMTPS id 4Wdr9L5FlSz4s8c;
	Wed,  7 Aug 2024 00:08:06 +0000 (UTC)
	(envelope-from ssouhlal@freebsd.org)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org; s=dkim;
	t=1722989286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N9AGE1mp7ocKprsfehWNf01gy5gs2eXOafGL7Ty3aBc=;
	b=QlS52S3BB4/aErLfOazVkIbWgS6QpoiIkNPYyak5hFDz0/ryPJIZ2cf0ytdOyeqD3Nfv6k
	qjECSxYFZh5hs2A5fQ9YL8V9JmLN4rLBYpfc+FIaKloMZo15oY2Bjp6Kgmhfxoh9vnCoKS
	kGaWHWjVFxleb2gbNHWzONz14bmTn+8rRzt6xU/suFGaBiernC4fSxh1i7qzvMS16+EUU8
	jOLcdiltIFS2L58bczy2Lgo0+NBIBJBd1nTPZJYC4Tr1iJvrSDV1KgdlqqW9xkHmjXYy+I
	+0Zq9+8Yj0FoUtVIuomB35w2kt0c2NTa9Taj78j2rtrP2NqlX7Syj8CLcZS5lA==
ARC-Seal: i=1; s=dkim; d=freebsd.org; t=1722989286; a=rsa-sha256; cv=none;
	b=t038ymMtqZPaaYj8t3pKymAZTFslTDuipIVzvvUfZUtf0xQCYYW7J3N0Oys0s5UQB0n1mq
	dCm/p6fnv7nVVbAznno603CoW/53ypvqsb7GTS8A7b14JR965t9z2VsUlZK/SuKqC7HWZ0
	VDBS9+M4MeImyAG5UUKqDLDGg/TkrEr/2+OjnSUOZoWDSM5FIEz61AYfqsegMo1sCt+QjX
	uEaN6Ll9QRcQ/ylbGoxNCpWHhdAJSmnwFt678xL0HHEqVQqtHU4hGjpO+eSw9PouuW540F
	i/5tIHD8ovI8OR+PuNlkiu6nb65CV1FSq/eHjkGDaPxMY7ugSG1dneFDC3h6/w==
ARC-Authentication-Results: i=1;
	mx1.freebsd.org;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=freebsd.org;
	s=dkim; t=1722989286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N9AGE1mp7ocKprsfehWNf01gy5gs2eXOafGL7Ty3aBc=;
	b=HTh/KI8W5dp/cS/ev/JNyvgzdkc5rXXdfhew7A8hGfd25vFBoYfmF9GmTjWG0/fdV2nTzL
	3IpgyW3hWU5Q5KTJG/AARaWl5QV29KNhM1pP/fIxYjY1pXVWP0VNsTvzyDm71137Ak5KtG
	UdvaPTYBDNKMPZD3anbCxxHJTH0Kc7WiYsDts7g5ctAoVaGmQxyxM7XprWS0UKVTTujn+j
	1DV+HBuul1t0bg59EPy/BvXNsK07vkoEkTEgcwnYRjlw1gAzkVBV/0J6hq4gZ0RzIfGO8j
	GDTU0xUgE4pCnhiH6BPp7g9OjwHycFlSZmnl2sMUtzRqsL07sZ0+JSoH+0UNNQ==
Received: by freefall.freebsd.org (Postfix, from userid 1026)
	id 9E6BB3FD7; Wed, 07 Aug 2024 00:08:06 +0000 (UTC)
Date: Wed, 7 Aug 2024 00:08:06 +0000
From: Suleiman Souhlal <ssouhlal@freebsd.org>
To: Joel Fernandes <joelaf@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, vineethrp@google.com,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] sched: Don't try to catch up excess steal time.
Message-ID: <ZrK65hAa-yDoG6F7@freefall.freebsd.org>
References: <20240806111157.1336532-1-suleiman@google.com>
 <CAJWu+oqp9sUDOvKB23p+_C1cTvFj8sQptfz30UwrWJyKhf1ckg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJWu+oqp9sUDOvKB23p+_C1cTvFj8sQptfz30UwrWJyKhf1ckg@mail.gmail.com>

On Tue, Aug 06, 2024 at 06:51:36PM -0400, Joel Fernandes wrote:
> On Tue, Aug 6, 2024 at 7:13 AM Suleiman Souhlal <suleiman@google.com> wrote:
> >
> > When steal time exceeds the measured delta when updating clock_task, we
> > currently try to catch up the excess in future updates.
> > However, this results in inaccurate run times for the future clock_task
> > measurements, as they end up getting additional steal time that did not
> > actually happen, from the previous excess steal time being paid back.
> >
> > For example, suppose a task in a VM runs for 10ms and had 15ms of steal
> > time reported while it ran. clock_task rightly doesn't advance. Then, a
> > different task runs on the same rq for 10ms without any time stolen.
> > Because of the current catch up mechanism, clock_sched inaccurately ends
> > up advancing by only 5ms instead of 10ms even though there wasn't any
> > actual time stolen. The second task is getting charged for less time
> > than it ran, even though it didn't deserve it.
> > In other words, tasks can end up getting more run time than they should
> > actually get.
> >
> > So, we instead don't make future updates pay back past excess stolen time.
> >
> > Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > ---
> >  kernel/sched/core.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index bcf2c4cc0522..42b37da2bda6 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -728,13 +728,15 @@ static void update_rq_clock_task(struct rq *rq, s64 delta)
> >  #endif
> >  #ifdef CONFIG_PARAVIRT_TIME_ACCOUNTING
> >         if (static_key_false((&paravirt_steal_rq_enabled))) {
> > -               steal = paravirt_steal_clock(cpu_of(rq));
> > +               u64 prev_steal;
> > +
> > +               steal = prev_steal = paravirt_steal_clock(cpu_of(rq));
> >                 steal -= rq->prev_steal_time_rq;
> >
> >                 if (unlikely(steal > delta))
> >                         steal = delta;
> >
> > -               rq->prev_steal_time_rq += steal;
> > +               rq->prev_steal_time_rq = prev_steal;
> >                 delta -= steal;
> 
> Makes sense, but wouldn't this patch also do the following: If vCPU
> task is the only one running and has a large steal time, then
> sched_tick() will only freeze the clock for a shorter period, and not
> give future credits to the vCPU task itself?  Maybe it does not matter
> (and I probably don't understand the code enough) but thought I would
> mention.

The patch should still be doing the right thing in that situation:
The clock will be frozen for the whole duration that it ran, and delta
will be 0.
The current excess amount is not relevant to the future, as far as I can
tell.
The pre-patch code is giving the rq extra time that it hadn't measured.
I don't really see why it should be getting that extra time.

> 
> I am also not sure if the purpose of stealtime is to credit individual
> tasks, or rather all tasks on the runqueue because the "whole
> runqueue" had time stolen.. No where in this function is it dealing
> with individual tasks but rather the rq itself.

This function is used to update clock_task, which *is* relevant to
individual tasks. It is used to calculate how long tasks ran for (and
for load averages).

-- Suleiman

