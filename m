Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE346207D
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 16:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731764AbfGHOaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 10:30:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54858 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbfGHOaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jul 2019 10:30:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KZ+JyrNmsYozld9a4FapspL694KYxTiXMOBra+KG6/g=; b=ANjX9kGQaVVgnRye6huS/jIYR
        Dc3UVfWIMQnfRv8II0PKtpKwVHWwyaHL1jQvcjynhtDBFqf7zFqFlTswwC/nD+OZnscyEOSOgd3W8
        nnkc1aJGJzESAD2ELQRCTBUazn/b0zEcshB0uGl64XB28oFDi36inaIXBeL6z5oy9ERcsoDwkZegs
        J61hbMmYOFHYJbWa/r+Rf8UcTstvmJwH3K9QkvH3U+OKfNdTL/CGQKZHrq5D3JAbJvnGYz9Xg/xac
        ONL8h+tTggeNKhkcXJwBxHxIAxx1ycDlICAQI2csSVVpkew1DuqFc5oa/ZGdzjD/Xs5lTw7iwrVwZ
        Amdhg2oHQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkUeL-0007gC-0R; Mon, 08 Jul 2019 14:29:49 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B9A5320B31C22; Mon,  8 Jul 2019 16:29:47 +0200 (CEST)
Date:   Mon, 8 Jul 2019 16:29:47 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, ak@linux.intel.com, kan.liang@intel.com,
        mingo@redhat.com, rkrcmar@redhat.com, like.xu@intel.com,
        jannh@google.com, arei.gonglei@huawei.com, jmattson@google.com
Subject: Re: [PATCH v7 07/12] perf/x86: no counter allocation support
Message-ID: <20190708142947.GM3402@hirez.programming.kicks-ass.net>
References: <1562548999-37095-1-git-send-email-wei.w.wang@intel.com>
 <1562548999-37095-8-git-send-email-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562548999-37095-8-git-send-email-wei.w.wang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 08, 2019 at 09:23:14AM +0800, Wei Wang wrote:
> In some cases, an event may be created without needing a counter
> allocation. For example, an lbr event may be created by the host
> only to help save/restore the lbr stack on the vCPU context switching.
> 
> This patch adds a new interface to allow users to create a perf event
> without the need of counter assignment.
> 
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> ---

I _really_ hate this one.

>  arch/x86/events/core.c     | 12 ++++++++++++
>  include/linux/perf_event.h | 13 +++++++++++++
>  kernel/events/core.c       | 37 +++++++++++++++++++++++++------------
>  3 files changed, 50 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
> index f315425..eebbd65 100644
> --- a/arch/x86/events/core.c
> +++ b/arch/x86/events/core.c
> @@ -410,6 +410,9 @@ int x86_setup_perfctr(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	u64 config;
>  
> +	if (is_no_counter_event(event))
> +		return 0;
> +
>  	if (!is_sampling_event(event)) {
>  		hwc->sample_period = x86_pmu.max_period;
>  		hwc->last_period = hwc->sample_period;
> @@ -1248,6 +1251,12 @@ static int x86_pmu_add(struct perf_event *event, int flags)
>  	hwc = &event->hw;
>  
>  	n0 = cpuc->n_events;
> +
> +	if (is_no_counter_event(event)) {
> +		n = n0;
> +		goto done_collect;
> +	}
> +
>  	ret = n = collect_events(cpuc, event, false);
>  	if (ret < 0)
>  		goto out;
> @@ -1422,6 +1431,9 @@ static void x86_pmu_del(struct perf_event *event, int flags)
>  	if (cpuc->txn_flags & PERF_PMU_TXN_ADD)
>  		goto do_del;
>  
> +	if (is_no_counter_event(event))
> +		goto do_del;
> +
>  	/*
>  	 * Not a TXN, therefore cleanup properly.
>  	 */

That's truely an abomination.

> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 0ab99c7..19e6593 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -528,6 +528,7 @@ typedef void (*perf_overflow_handler_t)(struct perf_event *,
>   */
>  #define PERF_EV_CAP_SOFTWARE		BIT(0)
>  #define PERF_EV_CAP_READ_ACTIVE_PKG	BIT(1)
> +#define PERF_EV_CAP_NO_COUNTER		BIT(2)
>  
>  #define SWEVENT_HLIST_BITS		8
>  #define SWEVENT_HLIST_SIZE		(1 << SWEVENT_HLIST_BITS)
> @@ -895,6 +896,13 @@ extern int perf_event_refresh(struct perf_event *event, int refresh);
>  extern void perf_event_update_userpage(struct perf_event *event);
>  extern int perf_event_release_kernel(struct perf_event *event);
>  extern struct perf_event *
> +perf_event_create(struct perf_event_attr *attr,
> +		  int cpu,
> +		  struct task_struct *task,
> +		  perf_overflow_handler_t overflow_handler,
> +		  void *context,
> +		  bool counter_assignment);
> +extern struct perf_event *
>  perf_event_create_kernel_counter(struct perf_event_attr *attr,
>  				int cpu,
>  				struct task_struct *task,

Why the heck are you creating this wrapper nonsense?
