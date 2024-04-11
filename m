Return-Path: <kvm+bounces-14307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ABCC8A1E57
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 20:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC8511F25FCA
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 18:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8317F4AEDF;
	Thu, 11 Apr 2024 18:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KMZCcpG8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC07487BC
	for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 18:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712858801; cv=none; b=SzV6CSFCa+XGKva2cEZeLsCmF/OtOD5dMWT5Mryi7XyvF5uZbcrV5b+x4P0fIyXZSUbs8rUeq/iLfEtCfAVHsilVof153a7AGOWydgFKxSgOAot+Olg3zpVAT4P8ysmhoDKHPCTepQIWUsR4mQ2QiUjNXkZ1coAJiPWVVWaXpqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712858801; c=relaxed/simple;
	bh=YOTZKjL3bWzR+U2HGFh3CrQiGRxDH7YCmn8lKN3Z9WE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qw28okB7TogBFuymbZP9MZkWN0dqOKfpXiL0gzOc3xrmOXwmIITA4dIz2uoT17XS7MOajoPNkxIx6rD2sG9j9TO5dYCbsn6B7r22S0KoQdGpoy34DB9evQQ6klN5ZvgQWfBvgfgoG/1pwBHE62pX+3wjp8HrNMK3MClpPbahXcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KMZCcpG8; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5d8dd488e09so99035a12.2
        for <kvm@vger.kernel.org>; Thu, 11 Apr 2024 11:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712858799; x=1713463599; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GGhUQmTooa3lX9A5NM0MmOVLthQr3cREHLR/XHq7cF0=;
        b=KMZCcpG8t4eVXjZNqvoOu1520oK5BzutSG3kHoRp7G2vBZc4M9iZPc41t3kEI4iYCF
         WvOZ2EaBUnsmfWsifUYKdlXDaNS9KOZtdtFjKds+6ZWUX3grpB0yoJnkinafn/E6LuSa
         0tfae9s+zqkfoh2VT4y6368yGToHGtviBe8oJSI+uiigGWnx74lKQD7FbbcfwfJ+bnQc
         A2KL66METhA3X2ox04n6WMW9Rb6fWAGpDhwRJaBAWAgVTyRUFlO/4WnpaWmXnGD+VOar
         4Jg3jj4Sy3dwcXHePeia0jp/RkIuXR4tCsjYvjL+Vnxa0NhsCLJsjuGKvoxqQRDBH10l
         flfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712858799; x=1713463599;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GGhUQmTooa3lX9A5NM0MmOVLthQr3cREHLR/XHq7cF0=;
        b=gFl2PAnMpmKSC1zSZy6RUoYpHjBn3f/fA6GoidM55DpGdVmm1eNyR60RL1RhxBs7on
         On9EFhVQSvabp2Lgg02h8Mi9NTIUrtzgk2c5dGvVpdY0HUfgEKZaCXb8anZm1UP/EXyg
         37vZSUMPJM8nU4ARQX1I0mmbNqye+tyh85m9DF64BDikxRi/xNtpIsXv2VtOCDE2cQV0
         kY0zK/JACBZcDuQ3tkDqy/iUARiA5BKOi/0g5xI1OR5T0Uc3a6u84/PitJ7HXt1xc56b
         Dv8xvP5USRyVEaCCGfaSu3K9aCIdvvowriPvZepBVx3nxkcvpy5PPmAF8yBH5hUCyO68
         LzJg==
X-Forwarded-Encrypted: i=1; AJvYcCXDfMwuYaxyejDUize5ZwuSOgnG7ts0T7I0PtvtCEYfWhgnqxq0UtvLerub+1GJD24/YLGBGFLS3eXCPYiV5PC6U329
X-Gm-Message-State: AOJu0YzIewHeL6bz1srLdXp2DBAcEouynpAx/pZJAje9tXjU0yyxEuZo
	bb7lc6KKHdH8AUtl3LqktbM2tr01taQsw1nlasUDMv9kB55k2UHy8/QjlF1X6wx5rCgiNHH/i4B
	jng==
X-Google-Smtp-Source: AGHT+IGRmhNL+LYtfNLknZs4rkju5jm70OObUUVz9BOFnRyKJalzlRxy3ib78cNNkdoV+Yxe5+yMp480ebU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:f919:0:b0:5db:edca:d171 with SMTP id
 h25-20020a63f919000000b005dbedcad171mr586pgi.6.1712858799398; Thu, 11 Apr
 2024 11:06:39 -0700 (PDT)
Date: Thu, 11 Apr 2024 11:06:37 -0700
In-Reply-To: <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126085444.324918-1-xiong.y.zhang@linux.intel.com> <20240126085444.324918-3-xiong.y.zhang@linux.intel.com>
Message-ID: <ZhgmrczGpccfU-cI@google.com>
Subject: Re: [RFC PATCH 02/41] perf: Support guest enter/exit interfaces
From: Sean Christopherson <seanjc@google.com>
To: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Cc: pbonzini@redhat.com, peterz@infradead.org, mizhang@google.com, 
	kan.liang@intel.com, zhenyuw@linux.intel.com, dapeng1.mi@linux.intel.com, 
	jmattson@google.com, kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, zhiyuan.lv@intel.com, eranian@google.com, 
	irogers@google.com, samantha.alt@intel.com, like.xu.linux@gmail.com, 
	chao.gao@intel.com, Kan Liang <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 26, 2024, Xiong Zhang wrote:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 683dc086ef10..59471eeec7e4 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -3803,6 +3803,8 @@ static inline void group_update_userpage(struct perf_event *group_event)
>  		event_update_userpage(event);
>  }
>  
> +static DEFINE_PER_CPU(bool, __perf_force_exclude_guest);
> +
>  static int merge_sched_in(struct perf_event *event, void *data)
>  {
>  	struct perf_event_context *ctx = event->ctx;
> @@ -3814,6 +3816,14 @@ static int merge_sched_in(struct perf_event *event, void *data)
>  	if (!event_filter_match(event))
>  		return 0;
>  
> +	/*
> +	 * The __perf_force_exclude_guest indicates entering the guest.
> +	 * No events of the passthrough PMU should be scheduled.
> +	 */
> +	if (__this_cpu_read(__perf_force_exclude_guest) &&
> +	    has_vpmu_passthrough_cap(event->pmu))

As mentioned in the previous reply, I think perf should WARN and reject any attempt
to trigger a "passthrough" context switch if such a switch isn't supported by
perf, not silently let it go through and then skip things later.

> +		return 0;
> +
>  	if (group_can_go_on(event, *can_add_hw)) {
>  		if (!group_sched_in(event, ctx))
>  			list_add_tail(&event->active_list, get_event_list(event));

...

> +/*
> + * When a guest enters, force all active events of the PMU, which supports
> + * the VPMU_PASSTHROUGH feature, to be scheduled out. The events of other
> + * PMUs, such as uncore PMU, should not be impacted. The guest can
> + * temporarily own all counters of the PMU.
> + * During the period, all the creation of the new event of the PMU with
> + * !exclude_guest are error out.
> + */
> +void perf_guest_enter(void)
> +{
> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	if (__this_cpu_read(__perf_force_exclude_guest))

This should be a WARN_ON_ONCE, no?

> +		return;
> +
> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +	perf_force_exclude_guest_enter(&cpuctx->ctx);
> +	if (cpuctx->task_ctx)
> +		perf_force_exclude_guest_enter(cpuctx->task_ctx);
> +
> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +
> +	__this_cpu_write(__perf_force_exclude_guest, true);
> +}
> +EXPORT_SYMBOL_GPL(perf_guest_enter);
> +
> +static void perf_force_exclude_guest_exit(struct perf_event_context *ctx)
> +{
> +	struct perf_event_pmu_context *pmu_ctx;
> +	struct pmu *pmu;
> +
> +	update_context_time(ctx);
> +	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
> +		pmu = pmu_ctx->pmu;
> +		if (!has_vpmu_passthrough_cap(pmu))
> +			continue;

I don't see how we can sanely support a CPU that doesn't support writable
PERF_GLOBAL_STATUS across all PMUs.

> +
> +		perf_pmu_disable(pmu);
> +		pmu_groups_sched_in(ctx, &ctx->pinned_groups, pmu);
> +		pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
> +		perf_pmu_enable(pmu);
> +	}
> +}
> +
> +void perf_guest_exit(void)
> +{
> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	if (!__this_cpu_read(__perf_force_exclude_guest))

WARN_ON_ONCE here too?

> +		return;
> +
> +	__this_cpu_write(__perf_force_exclude_guest, false);
> +
> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +	perf_force_exclude_guest_exit(&cpuctx->ctx);
> +	if (cpuctx->task_ctx)
> +		perf_force_exclude_guest_exit(cpuctx->task_ctx);
> +
> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +}
> +EXPORT_SYMBOL_GPL(perf_guest_exit);
> +
> +static inline int perf_force_exclude_guest_check(struct perf_event *event,
> +						 int cpu, struct task_struct *task)
> +{
> +	bool *force_exclude_guest = NULL;
> +
> +	if (!has_vpmu_passthrough_cap(event->pmu))
> +		return 0;
> +
> +	if (event->attr.exclude_guest)
> +		return 0;
> +
> +	if (cpu != -1) {
> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, cpu);
> +	} else if (task && (task->flags & PF_VCPU)) {
> +		/*
> +		 * Just need to check the running CPU in the event creation. If the
> +		 * task is moved to another CPU which supports the force_exclude_guest.
> +		 * The event will filtered out and be moved to the error stage. See
> +		 * merge_sched_in().
> +		 */
> +		force_exclude_guest = per_cpu_ptr(&__perf_force_exclude_guest, task_cpu(task));
> +	}

These checks are extremely racy, I don't see how this can possibly do the
right thing.  PF_VCPU isn't a "this is a vCPU task", it's a "this task is about
to do VM-Enter, or just took a VM-Exit" (the "I'm a virtual CPU" comment in
include/linux/sched.h is wildly misleading, as it's _only_ valid when accounting
time slices).

Digging deeper, I think __perf_force_exclude_guest has similar problems, e.g.
perf_event_create_kernel_counter() calls perf_event_alloc() before acquiring the
per-CPU context mutex.

> +	if (force_exclude_guest && *force_exclude_guest)
> +		return -EBUSY;
> +	return 0;
> +}
> +
>  /*
>   * Holding the top-level event's child_mutex means that any
>   * descendant process that has inherited this event will block
> @@ -11973,6 +12142,11 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
>  		goto err_ns;
>  	}
>  
> +	if (perf_force_exclude_guest_check(event, cpu, task)) {

This should be:

	err = perf_force_exclude_guest_check(event, cpu, task);
	if (err)
		goto err_pmu;

i.e. shouldn't effectively ignore/override the return result.

> +		err = -EBUSY;
> +		goto err_pmu;
> +	}
> +
>  	/*
>  	 * Disallow uncore-task events. Similarly, disallow uncore-cgroup
>  	 * events (they don't make sense as the cgroup will be different
> -- 
> 2.34.1
> 

