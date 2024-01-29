Return-Path: <kvm+bounces-7383-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 805558411E3
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9BAD1F25C35
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 18:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A67626F08C;
	Mon, 29 Jan 2024 18:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pPW3f9Sj"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52BF3F9FC;
	Mon, 29 Jan 2024 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706552156; cv=none; b=C8Y/dBnbLQZWJjvqbdCMo7tnIX1Y2YxRngXsNE+16Vr5UXFgjiZwdwc/p5zrnt8ZQFDFutJr6s5j5dqyPuqF2UF/BuUXhtakXVtOvVg3cHveU1yU9PC1SnL4aLpUDnGlVFPJis/5hvYxrSM84y91F9BoqCtMQ/JabHqijGZ8ys4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706552156; c=relaxed/simple;
	bh=HtWWFC71BCavDoQvTNSF5iID0oN+lBFa3TU2UQoctyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E8AFEhOnkF67a/wpCQHKKde5gWxqYTx+xDqcdg9xAG/T56xjCRxaYDeUOs0Ovm973YFQNBZ5CVYw6bkVK8G4IbgwWvpyxaeTa2Amt+wver0u4Rs0me3J34Bq61A4FEOt7CNAk0jUI0PUjbo6xHW6XB4jLoajOk2hAplh90odN+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pPW3f9Sj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A849C433C7;
	Mon, 29 Jan 2024 18:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706552156;
	bh=HtWWFC71BCavDoQvTNSF5iID0oN+lBFa3TU2UQoctyw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pPW3f9SjldNx036oVfr2mb7rF/1uWtZ+8laYPTJFddNQu22KfZ9+JSUv3x0Zuw9Bs
	 Zg59bttwt3Mq13HLeF7PE+CdppqGpDgui6gYfX2F0YP/bMAsrPRvM5xTKFMs/xgxq0
	 AKs03jubjF5XETb+5vpA4ubGccF/LgcfoHaiv9vPYmZcxEq+QxwuBLK+1qOOKyz2hB
	 bDObKuNdlKVq94bl6KJx3hVJOl9w6th4nhM+Xg7uZ9cxQowb+FA6/48N6cVWwyJpPH
	 Cya7zQern418k52+XIWRSXC9HRRO//yRjqbXG8Ogd0pMHsMRLRIJNPE8O4O6X4juuj
	 UDdExsudUOJfg==
Date: Mon, 29 Jan 2024 18:15:47 +0000
From: Will Deacon <will@kernel.org>
To: Mihai Carabas <mihai.carabas@oracle.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
	wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
	daniel.lezcano@linaro.org, akpm@linux-foundation.org,
	pmladek@suse.com, peterz@infradead.org, dianders@chromium.org,
	npiggin@gmail.com, rick.p.edgecombe@intel.com,
	joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
	mic@digikod.net, arnd@arndb.de, ankur.a.arora@oracle.com
Subject: Re: [PATCH 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Message-ID: <20240129181547.GA12305@willie-the-truck>
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
 <1700488898-12431-8-git-send-email-mihai.carabas@oracle.com>
 <20231211114642.GB24899@willie-the-truck>
 <1b3650c5-822e-4789-81d2-0304573cabd9@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b3650c5-822e-4789-81d2-0304573cabd9@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sun, Jan 28, 2024 at 11:22:50PM +0200, Mihai Carabas wrote:
> La 11.12.2023 13:46, Will Deacon a scris:
> > On Mon, Nov 20, 2023 at 04:01:38PM +0200, Mihai Carabas wrote:
> > > cpu_relax on ARM64 does a simple "yield". Thus we replace it with
> > > smp_cond_load_relaxed which basically does a "wfe".
> > > 
> > > Suggested-by: Peter Zijlstra <peterz@infradead.org>
> > > Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
> > > ---
> > >   drivers/cpuidle/poll_state.c | 14 +++++++++-----
> > >   1 file changed, 9 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> > > index 9b6d90a72601..440cd713e39a 100644
> > > --- a/drivers/cpuidle/poll_state.c
> > > +++ b/drivers/cpuidle/poll_state.c
> > > @@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
> > >   		limit = cpuidle_poll_time(drv, dev);
> > > -		while (!need_resched()) {
> > > -			cpu_relax();
> > > -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> > > -				continue;
> > > -
> > > +		for (;;) {
> > >   			loop_count = 0;
> > > +
> > > +			smp_cond_load_relaxed(&current_thread_info()->flags,
> > > +					      (VAL & _TIF_NEED_RESCHED) ||
> > > +					      (loop_count++ >= POLL_IDLE_RELAX_COUNT));
> > > +
> > > +			if (loop_count < POLL_IDLE_RELAX_COUNT)
> > > +				break;
> > > +
> > >   			if (local_clock_noinstr() - time_start > limit) {
> > >   				dev->poll_time_limit = true;
> > >   				break;
> > Doesn't this make ARCH_HAS_CPU_RELAX a complete misnomer?
> 
> This controls the build of poll_state.c and the generic definition of
> smp_cond_load_relaxed (used by x86) is using cpu_relax(). Do you propose
> other approach here?

Give it a better name? Having ARCH_HAS_CPU_RELAX control a piece of code
that doesn't use cpu_relax() doesn't make sense to me.

Will

