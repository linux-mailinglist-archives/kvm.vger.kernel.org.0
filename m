Return-Path: <kvm+bounces-16809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC9E8BDD95
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 10:58:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4A9061F24D87
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949F814D43E;
	Tue,  7 May 2024 08:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bylM8dMV"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0A014D435;
	Tue,  7 May 2024 08:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715072298; cv=none; b=D/zRPLtxg733m3G6WfR9mEvne/+HaCH4Uy1i6Db1B5i/50IKPBM7+IWVdstd2mVZvSvJxiCmg8rV3j+bo9r7igj9oaIU0DgTUXqthU8MTwb+NG2P4/Xs+PHXaAErKjcS2Qty8SHoVfYe6ywPlzuVcQe8qp8/w/bClSWW7FlhASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715072298; c=relaxed/simple;
	bh=E7Vhyallr/nX7BoTjU3TnBsTTfCzCvsx4+RbXuejgjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2nzr9iLxvSUV/OD/p7vToeY143XKp7dOIvbER+a0avDx3PgV2WG6yIlRnSsUlE3WxOtrjIfMZA/IcxMjrit7xWWF7Z/E34m8te7Cs9hc/3jBp32mm4UG+rM+HSqFo2H4tfIz3oOjENamzPNSWH0juwDaDVAkFw50SQPpMkIcok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=bylM8dMV; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FbVHuQdp52sXEYW2SDNlui0R/3F7Zh9lqymf82Zw1XU=; b=bylM8dMVCkSiCedP8H2hI3Np16
	ms5tLvx43SPcw5FmjH1ydjitx+wpUCt+7chu3AOETyoHIw09I6rIqAubpLF35dDO3vS71bfatVnhQ
	5DD05Xv2Ngo27TVR5HU6OAjNQaAPQkGTlfxm3EusiXjIc0MUXbAImino/Xy85C8jKh52pL7Ou3WS3
	j++qLsnnra9atRSGLkaop3cn6yFeH1/KlU4QlKk6dD8sho1XOQe2t96jCIKJZ1jhhVKhWuB2S3u2U
	sASeuA66wG0620fzpAOGNRhB24iO9Do9AbEaedFF2zzuY9BiZW13sV+Kaugz8XGZTIZWYnynm4+/J
	4yFXMj8w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4GeG-0000000CsA2-1MPT;
	Tue, 07 May 2024 08:58:08 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 03886300362; Tue,  7 May 2024 10:58:08 +0200 (CEST)
Date: Tue, 7 May 2024 10:58:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Xiong Zhang <xiong.y.zhang@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
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
	maobibo <maobibo@loongson.cn>, Like Xu <like.xu.linux@gmail.com>,
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH v2 07/54] perf: Add generic exclude_guest support
Message-ID: <20240507085807.GS40213@noisy.programming.kicks-ass.net>
References: <20240506053020.3911940-1-mizhang@google.com>
 <20240506053020.3911940-8-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240506053020.3911940-8-mizhang@google.com>

On Mon, May 06, 2024 at 05:29:32AM +0000, Mingwei Zhang wrote:

> @@ -5791,6 +5801,100 @@ void perf_put_mediated_pmu(void)
>  }
>  EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
>  
> +static void perf_sched_out_exclude_guest(struct perf_event_context *ctx)
> +{
> +	struct perf_event_pmu_context *pmu_ctx;
> +
> +	update_context_time(ctx);
> +	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
> +		struct perf_event *event, *tmp;
> +		struct pmu *pmu = pmu_ctx->pmu;
> +
> +		if (!(pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
> +			continue;
> +
> +		perf_pmu_disable(pmu);
> +
> +		/*
> +		 * All active events must be exclude_guest events.
> +		 * See perf_get_mediated_pmu().
> +		 * Unconditionally remove all active events.
> +		 */
> +		list_for_each_entry_safe(event, tmp, &pmu_ctx->pinned_active, active_list)
> +			group_sched_out(event, pmu_ctx->ctx);
> +
> +		list_for_each_entry_safe(event, tmp, &pmu_ctx->flexible_active, active_list)
> +			group_sched_out(event, pmu_ctx->ctx);
> +
> +		pmu_ctx->rotate_necessary = 0;
> +
> +		perf_pmu_enable(pmu);
> +	}
> +}
> +
> +/* When entering a guest, schedule out all exclude_guest events. */
> +void perf_guest_enter(void)
> +{
> +	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
> +
> +	lockdep_assert_irqs_disabled();
> +
> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +	if (WARN_ON_ONCE(__this_cpu_read(perf_in_guest))) {
> +		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +		return;
> +	}
> +
> +	perf_sched_out_exclude_guest(&cpuctx->ctx);
> +	if (cpuctx->task_ctx)
> +		perf_sched_out_exclude_guest(cpuctx->task_ctx);
> +
> +	__this_cpu_write(perf_in_guest, true);
> +
> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +}
> +
> +static void perf_sched_in_exclude_guest(struct perf_event_context *ctx)
> +{
> +	struct perf_event_pmu_context *pmu_ctx;
> +
> +	update_context_time(ctx);
> +	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
> +		struct pmu *pmu = pmu_ctx->pmu;
> +
> +		if (!(pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
> +			continue;
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
> +	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
> +
> +	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest))) {
> +		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +		return;
> +	}
> +
> +	__this_cpu_write(perf_in_guest, false);
> +
> +	perf_sched_in_exclude_guest(&cpuctx->ctx);
> +	if (cpuctx->task_ctx)
> +		perf_sched_in_exclude_guest(cpuctx->task_ctx);
> +
> +	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
> +}

Bah, this is a ton of copy-paste from the normal scheduling code with
random changes. Why ?

Why can't this use ctx_sched_{in,out}() ? Surely the whole
CAP_PASSTHROUGHT thing is but a flag away.

