Return-Path: <kvm+bounces-20388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 092BF9147DF
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 12:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7DE8284AFD
	for <lists+kvm@lfdr.de>; Mon, 24 Jun 2024 10:55:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E47C137772;
	Mon, 24 Jun 2024 10:55:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B98B2F24;
	Mon, 24 Jun 2024 10:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719226509; cv=none; b=SyQGnMk5gBHqY7wqtbL3tQ5WnPahwMAXUiGmxE/0A4BXOfUha/Rp9XMynI6G2AIEFyW0RSROUgrngf2NyR98fHYy5k786QdAwCxS6wueHT08zNWW0cohrKYPL+XQZCAgshwf5teWgu+qdv0uv6cC65VK01rOUvX5PfKCojqP8QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719226509; c=relaxed/simple;
	bh=Azy9ITJyQFSFf7+tiTgAYOzxp7NONG+jBcbI9NfETxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ipVX7PkyUgC7d8mdCE2nSbQhVg2aW1H4stZJdsZOsWf9GFRO8zCidLeDVZIbtq9mA24EhhFFo5gdoa1qOyzeDKSOj9i2o3qG/nTAxJGka1DLI0kaExMpJ93nuPaljyKn15AYrLrW9OTOsrIcLvTpOYGh7a5gL4UqCWwbBgSFrwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DA84DA7;
	Mon, 24 Jun 2024 03:55:31 -0700 (PDT)
Received: from bogus (e103737-lin.cambridge.arm.com [10.1.197.49])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34B993F73B;
	Mon, 24 Jun 2024 03:55:02 -0700 (PDT)
Date: Mon, 24 Jun 2024 11:54:59 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	Sudeep Holla <sudeep.holla@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	harisokn@amazon.com, joao.m.martins@oracle.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH 8/9] arm64: support cpuidle-haltpoll
Message-ID: <ZnlQg9kcAWG443re@bogus>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
 <20240430183730.561960-9-ankur.a.arora@oracle.com>
 <20240619121711.jid3enfzak7vykyn@bogus>
 <871q4pc0f9.fsf@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871q4pc0f9.fsf@oracle.com>

On Fri, Jun 21, 2024 at 04:59:22PM -0700, Ankur Arora wrote:
> 
> Sudeep Holla <sudeep.holla@arm.com> writes:
> 
> > On Tue, Apr 30, 2024 at 11:37:29AM -0700, Ankur Arora wrote:
> >> Add architectural support for the cpuidle-haltpoll driver by defining
> >> arch_haltpoll_*(). Also select ARCH_HAS_OPTIMIZED_POLL since we have
> >> an optimized polling mechanism via smp_cond_load*().
> >>
> >> Add the configuration option, ARCH_CPUIDLE_HALTPOLL to allow
> >> cpuidle-haltpoll to be selected.
> >>
> >> Note that we limit cpuidle-haltpoll support to when the event-stream is
> >> available. This is necessary because polling via smp_cond_load_relaxed()
> >> uses WFE to wait for a store which might not happen for an prolonged
> >> period of time. So, ensure the event-stream is around to provide a
> >> terminating condition.
> >>
> >
> > Currently the event stream is configured 10kHz(1 signal per 100uS IIRC).
> > But the information in the cpuidle states for exit latency and residency
> > is set to 0(as per drivers/cpuidle/poll_state.c). Will this not cause any
> > performance issues ?
> 
> No I don't think there's any performance issue.
>

Thanks for the confirmation, that was my assumption as well.

> When the core is waiting in WFE for &thread_info->flags to
> change, and set_nr_if_polling() happens, the CPU will come out
> of the wait quickly.
> So, the exit latency, residency can be reasonably set to 0.
>

Sure

> If, however, there is no store to &thread_info->flags, then the event
> stream is what would cause us to come out of the WFE and check if
> the poll timeout has been exceeded.
> In that case, there was no work to be done, so there was nothing
> to wake up from.
>

This is exactly what I was referring when I asked about performance, but
it looks like it is not a concern for the reason specified about.

> So, in either circumstance there's no performance loss.
>
> However, when we are polling under the haltpoll governor, this might
> mean that we spend more time polling than determined based on the
> guest_halt_poll_ns. But, that would only happen in the last polling
> iteration.
>
> So, I'd say, at worst no performance loss. But, we would sometimes
> poll for longer than necessary before exiting to the host.
>

Does it make sense to add some comment that implies briefly what we
have discussed here ? Mainly why 0 exit and target residency values
are fine and how worst case WFE wakeup doesn't impact the performance.

--
Regards,
Sudeep

