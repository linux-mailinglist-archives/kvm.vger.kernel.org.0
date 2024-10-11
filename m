Return-Path: <kvm+bounces-28615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFAFF99A2D7
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 13:39:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 19E7B1C22440
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 11:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E17216450;
	Fri, 11 Oct 2024 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CYiJfI02"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA02D1CDFD6;
	Fri, 11 Oct 2024 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728646765; cv=none; b=djjldfd/0OMjSmlDPWPrx3nuZnCq9bUbj3aWR/6AVd4g9641FPQQKyUpP+ncDVo38w8Nh0RrssfjV+82KMoC69YFZNIVXPMZTUe0gXnM4QssFR4mJaq50OfkaaAL27Xduik+Tb61tGQfv6EtCxwuemuzkk9YR8KxSQxoC0YLq5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728646765; c=relaxed/simple;
	bh=JNjGPn9gPR2lUgCxgeNHs2fKHZ+30o2AONf+AhTXmYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oaHvBPbBm74GUaMi1MFUqPzLiBcrSPyYhwKEuYEzKvLGy464CS6X9xaWrOo/KteuAj/gIgHgAOj42VfIolQvWv20cwB6BzS42miEtq+5vLs7b5e5vJ9LNOM/y78+l1LzQrN0Ne4+iHe9Lv2DgLW9prt0LLjxNccyn7XDMywUEIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=CYiJfI02; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8dbtc+aUqoQxAIijImc2mtsRXf2ai+3VZEj++WdzSOY=; b=CYiJfI02xpx5GXxoIb3/879jr6
	/z0u1jOdfZT/gsoLLePDRhKx6yc8AXd77MhLC0vZ19L+HFdt2PaNojs21d2LCT7QjjtdsoDKw5yo3
	3SC6HrvTH/WrxacxikiSUO5x4eTh7dywwYTLhlGatTZK83cMV+w27SevuW9Ur7Ck58O/VY06Pp/fI
	Z3Qk2tAFQAg/6FevDvOOwRH7JR73hzn1GtKibVQ0m/qirxIlVTy//1OSLcSq+GzAP7UpgfjDGIfTB
	iEQHTiBpdrJfwKR1z8jE9hrs+X/cA9K3pJa36OAkzaoJMfRVamo8lCkGU/z8oHtzXkPgyHg9MmBB7
	3zApwPQg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1szDzH-00000005sHY-413Q;
	Fri, 11 Oct 2024 11:39:16 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 67C4B300642; Fri, 11 Oct 2024 13:39:15 +0200 (CEST)
Date: Fri, 11 Oct 2024 13:39:15 +0200
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
	Like Xu <like.xu.linux@gmail.com>,
	Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [RFC PATCH v3 08/58] perf: Clean up perf ctx time
Message-ID: <20241011113915.GN14587@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-9-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801045907.4010984-9-mizhang@google.com>

On Thu, Aug 01, 2024 at 04:58:17AM +0000, Mingwei Zhang wrote:
> From: Kan Liang <kan.liang@linux.intel.com>
> 
> The current perf tracks two timestamps for the normal ctx and cgroup.
> The same type of variables and similar codes are used to track the
> timestamps. In the following patch, the third timestamp to track the
> guest time will be introduced.
> To avoid the code duplication, add a new struct perf_time_ctx and factor
> out a generic function update_perf_time_ctx().
> 
> No functional change.
> 
> Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>


--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -801,11 +801,22 @@ static inline u64 perf_cgroup_event_time
 	return now;
 }
 
-static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv);
-
-static inline void __update_cgrp_time(struct perf_cgroup_info *info, u64 now, bool adv)
+static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
 {
-	update_perf_time_ctx(&info->time, now, adv);
+	if (adv)
+		time->time += now - time->stamp;
+	time->stamp = now;
+
+	/*
+	 * The above: time' = time + (now - timestamp), can be re-arranged
+	 * into: time` = now + (time - timestamp), which gives a single value
+	 * offset to compute future time without locks on.
+	 *
+	 * See perf_event_time_now(), which can be used from NMI context where
+	 * it's (obviously) not possible to acquire ctx->lock in order to read
+	 * both the above values in a consistent manner.
+	 */
+	WRITE_ONCE(time->offset, time->time - time->stamp);
 }
 
 static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
@@ -821,7 +832,7 @@ static inline void update_cgrp_time_from
 			cgrp = container_of(css, struct perf_cgroup, css);
 			info = this_cpu_ptr(cgrp->info);
 
-			__update_cgrp_time(info, now, true);
+			update_perf_time_ctx(&info->time, now, true);
 			if (final)
 				__store_release(&info->active, 0);
 		}
@@ -844,7 +855,7 @@ static inline void update_cgrp_time_from
 	 * Do not update time when cgroup is not active
 	 */
 	if (info->active)
-		__update_cgrp_time(info, perf_clock(), true);
+		update_perf_time_ctx(&info->time, perf_clock(), true);
 }
 
 static inline void
@@ -868,7 +879,7 @@ perf_cgroup_set_timestamp(struct perf_cp
 	for (css = &cgrp->css; css; css = css->parent) {
 		cgrp = container_of(css, struct perf_cgroup, css);
 		info = this_cpu_ptr(cgrp->info);
-		__update_cgrp_time(info, ctx->time.stamp, false);
+		update_perf_time_ctx(&info->time, ctx->time.stamp, false);
 		__store_release(&info->active, 1);
 	}
 }
@@ -1478,24 +1489,6 @@ static void perf_unpin_context(struct pe
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
 }
 
-static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
-{
-	if (adv)
-		time->time += now - time->stamp;
-	time->stamp = now;
-
-	/*
-	 * The above: time' = time + (now - timestamp), can be re-arranged
-	 * into: time` = now + (time - timestamp), which gives a single value
-	 * offset to compute future time without locks on.
-	 *
-	 * See perf_event_time_now(), which can be used from NMI context where
-	 * it's (obviously) not possible to acquire ctx->lock in order to read
-	 * both the above values in a consistent manner.
-	 */
-	WRITE_ONCE(time->offset, time->time - time->stamp);
-}
-
 /*
  * Update the record of the current time in a context.
  */

