Return-Path: <kvm+bounces-28618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1323299A2E5
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA7E0283A18
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E761F216A04;
	Fri, 11 Oct 2024 11:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LgQctK44"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3231F9415;
	Fri, 11 Oct 2024 11:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728646921; cv=none; b=dB9Ddk/COU5+cloecJLvbnuLpw/gbroD6DCx0zR29FufurVHWAVKvIn005nNohKA6vBUrhJ8/HL3d0Wk8+0SEB7DXwTncyaikdMXy5E1VoSZVphXG4SRDNBFJfl1jQW7FM/fMhykqkAnX2vOf2jVhRVwGgOhVqRGI2rCSHUhCCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728646921; c=relaxed/simple;
	bh=f5/gKUV+onCFlwc+BTuEU324blfwu0E0ySgrxtQzrnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EVook4D5It4jRNJ+WL2Dq1XanPVssBtVoc/MYPNbNtJfqzACWsI7DBJqpZ/tHeUue0q4GP5jpAtK/jVLQxH0KpUmm+XRkb0rH84Tb1yg2TvFNg9/WtiLSi6pfst8plwmnp+/cSAHeCGcpHyjiRTwkpmt25GcP9z/4k3rBUKfKiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LgQctK44; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=s0nie3up7O9BX6Pp/Xow1TsRav7XmKEP6A0jErw7/ro=; b=LgQctK44yeUsn1zwiKssE5kD4s
	BiS8Pou2pBtwWhwceWltYXJGedWypGE7EtQ6TI0AW4TzE0pYQWvLXqIFwqErYV3Eg7GSwv+Y0Ne9W
	5NsIaBmIYobZsDiZMf2jKuLCB4Ziwa4wOGsmQklh1Vc1HvKIzKqrLNM/1VQmC+tBNJYQvtGTSj+RH
	cWPgst7qqmfARCSoHteMY1z7QyYSExQ/8YimlX7v8fo9EO4oDzPPZP8vRsccrRvIhOjJqFdHNuHDt
	DMxUMaEcSM65lpUqQRLFV9ripUN8Ui2nmjcFmjEvjp1HeOhJIlQG7qf3aIZHeF/p7mVaYvX65t6Ip
	QGTcaolQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1szE1m-0000000Ae0b-3VxG;
	Fri, 11 Oct 2024 11:41:51 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CC2B2300642; Fri, 11 Oct 2024 13:41:50 +0200 (CEST)
Date: Fri, 11 Oct 2024 13:41:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: Mingwei Zhang <mizhang@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Kan Liang <kan.liang@intel.com>,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	Manali Shukla <manali.shukla@amd.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Jim Mattson <jmattson@google.com>,
	Stephane Eranian <eranian@google.com>,
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>,
	gce-passthrou-pmu-dev@google.com,
	Samantha Alt <samantha.alt@intel.com>,
	Zhiyuan Lv <zhiyuan.lv@intel.com>, Yanfei Xu <yanfei.xu@intel.com>,
	Like Xu <like.xu.linux@gmail.com>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
Message-ID: <20241011114150.GO14587@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
 <095522b1-faad-4544-9282-4dda8be03695@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <095522b1-faad-4544-9282-4dda8be03695@linux.intel.com>

On Wed, Aug 21, 2024 at 01:27:17PM +0800, Mi, Dapeng wrote:
> On 8/1/2024 12:58 PM, Mingwei Zhang wrote:

> > +static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
> > +					    struct perf_time_ctx *time,
> > +					    struct perf_time_ctx *timeguest,
> > +					    u64 now)
> > +{
> > +	/*
> > +	 * The exclude_guest event time should be calculated from
> > +	 * the ctx time -  the guest time.
> > +	 * The ctx time is now + READ_ONCE(time->offset).
> > +	 * The guest time is now + READ_ONCE(timeguest->offset).
> > +	 * So the exclude_guest time is
> > +	 * READ_ONCE(time->offset) - READ_ONCE(timeguest->offset).
> > +	 */
> > +	if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest))
> 
> Hi Kan,
> 
> we see the following the warning when run perf record command after
> enabling "CONFIG_DEBUG_PREEMPT" config item.
> 
> [  166.779208] BUG: using __this_cpu_read() in preemptible [00000000] code:
> perf/9494
> [  166.779234] caller is __this_cpu_preempt_check+0x13/0x20
> [  166.779241] CPU: 56 UID: 0 PID: 9494 Comm: perf Not tainted
> 6.11.0-rc4-perf-next-mediated-vpmu-v3+ #80
> [  166.779245] Hardware name: Quanta Cloud Technology Inc. QuantaGrid
> D54Q-2U/S6Q-MB-MPS, BIOS 3A11.uh 12/02/2022
> [  166.779248] Call Trace:
> [  166.779250]  <TASK>
> [  166.779252]  dump_stack_lvl+0x76/0xa0
> [  166.779260]  dump_stack+0x10/0x20
> [  166.779267]  check_preemption_disabled+0xd7/0xf0
> [  166.779273]  __this_cpu_preempt_check+0x13/0x20
> [  166.779279]  calc_timer_values+0x193/0x200
> [  166.779287]  perf_event_update_userpage+0x4b/0x170
> [  166.779294]  ? ring_buffer_attach+0x14c/0x200
> [  166.779301]  perf_mmap+0x533/0x5d0
> [  166.779309]  mmap_region+0x243/0xaa0
> [  166.779322]  do_mmap+0x35b/0x640
> [  166.779333]  vm_mmap_pgoff+0xf0/0x1c0
> [  166.779345]  ksys_mmap_pgoff+0x17a/0x250
> [  166.779354]  __x64_sys_mmap+0x33/0x70
> [  166.779362]  x64_sys_call+0x1fa4/0x25f0
> [  166.779369]  do_syscall_64+0x70/0x130
> 
> The season that kernel complains this is __perf_event_time_ctx_now() calls
> __this_cpu_read() in preemption enabled context.
> 
> To eliminate the warning, we may need to use this_cpu_read() to replace
> __this_cpu_read().
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index ccd61fd06e8d..1eb628f8b3a0 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -1581,7 +1581,7 @@ static inline u64 __perf_event_time_ctx_now(struct
> perf_event *event,
>          * So the exclude_guest time is
>          * READ_ONCE(time->offset) - READ_ONCE(timeguest->offset).
>          */
> -       if (event->attr.exclude_guest && __this_cpu_read(perf_in_guest))
> +       if (event->attr.exclude_guest && this_cpu_read(perf_in_guest))
>                 return READ_ONCE(time->offset) - READ_ONCE(timeguest->offset);
>         else
>                 return now + READ_ONCE(time->offset);

The saner fix is moving the preempt_disable() in
perf_event_update_userpage() up a few lines, no?

