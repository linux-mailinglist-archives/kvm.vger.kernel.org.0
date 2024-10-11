Return-Path: <kvm+bounces-28646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2745899AB24
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 20:43:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56E3A1C2191F
	for <lists+kvm@lfdr.de>; Fri, 11 Oct 2024 18:43:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE101CB317;
	Fri, 11 Oct 2024 18:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aE8/GKZM"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CD81C5796;
	Fri, 11 Oct 2024 18:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728672172; cv=none; b=IC3x/kBCQlwqG9JJUJyVCta0LfGjnN9drjLdkw3qCd7ZFWPrfpgQJTEDX7tvY0ATPM+MALvL/urcvf+smvGV/PAEiIrl7gKTvWzmju3fQltBlKcDYHbJGR0peR+TnL/xyDwHtgOJeESsvrXdCTElYkl+YPzYUjf+/C4ku/8f1/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728672172; c=relaxed/simple;
	bh=Jjfo4K2iIDHp/psPQdMiHq33DkPwCSvs1wshiMqXN3U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l09tQbJk6EfQEngzAifIAKNHszsIuo/7Hf88MtyG5L4at0uYWDlMZK3gp0vpDGPtP4Apn90E6v8LD3aFKCAzmSqGSFP4oRKQ50fiMxyrjzm7+KQedD5Or5z82ZX4ZnC8s7342HXbOATsh+jCcbD4c0xpCW9sWoi+N8p6MlY1Yds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=aE8/GKZM; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1EUwMSDRYhUSzl5iQdDKKDN1jiIu4L3m+r5PDqdzHw4=; b=aE8/GKZMmUicongI8lZiENJoVW
	W30aNP2A+TBOZEk3V9cqCL9sXbbdxrRAjh8xXSQnoDasz89bQ/qL834Je2/wnTlRIzJGHeduFnL/D
	Xa2ys6wTfAIFyWPFOXedOYTgxUCci9vsXwA/k/K7kEoXViUN0CoH025GYWb+fi0SBPPhncIF06bh5
	0Hi8EftVrqF29Qyx+ufaAIpnCqkQ2B/okUxtsYZA6Bef9N5UdMBK2RM2tS4t4hIL7QknkVnQ6c18u
	nP9TABsn8B3+FM70D19Ci2+qXApGyoHMvRXWmi67UOISqAc1TIhwI40qcUwnjCK7kIo4f2utQ7/L8
	UmEbVNtA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1szKaz-0000000BZXN-0Sy1;
	Fri, 11 Oct 2024 18:42:37 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 31C0F3001D4; Fri, 11 Oct 2024 20:42:37 +0200 (CEST)
Date: Fri, 11 Oct 2024 20:42:37 +0200
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
Subject: Re: [RFC PATCH v3 09/58] perf: Add a EVENT_GUEST flag
Message-ID: <20241011184237.GQ17263@noisy.programming.kicks-ass.net>
References: <20240801045907.4010984-1-mizhang@google.com>
 <20240801045907.4010984-10-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801045907.4010984-10-mizhang@google.com>


Can you rework this one along these lines?

---
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -975,6 +975,7 @@ struct perf_event_context {
 	 * Context clock, runs when context enabled.
 	 */
 	struct perf_time_ctx		time;
+	struct perf_time_ctx		timeguest;
 
 	/*
 	 * These fields let us detect when two contexts have both
@@ -1066,6 +1067,7 @@ struct bpf_perf_event_data_kern {
  */
 struct perf_cgroup_info {
 	struct perf_time_ctx		time;
+	struct perf_time_ctx		timeguest;
 	int				active;
 };
 
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -782,12 +782,44 @@ static inline int is_cgroup_event(struct
 	return event->cgrp != NULL;
 }
 
+static_assert(offsetof(struct perf_event, timeguest) -
+	      offsetof(struct perf_event, time) == 
+	      sizeof(struct perf_time_ctx));
+
+static_assert(offsetof(struct perf_cgroup_info, timeguest) -
+	      offsetof(struct perf_cgroup_info, time) ==
+	      sizeof(struct perf_time_ctx));
+
+static inline u64 __perf_event_time_ctx(struct perf_event *event,
+					struct perf_time_ctx *times)
+{
+	u64 time = times[0].time;
+	if (event->attr.exclude_guest)
+		time -= times[1].time;
+	return time;
+}
+
+static inline u64 __perf_event_time_ctx_now(struct perf_event *event,
+					    struct perf_time_ctx *times,
+					    u64 now)
+{
+	if (event->attr.exclude_guest) {
+		/*
+		 * (now + times[0].offset) - (now + times[1].offset) :=
+		 * times[0].offset - times[1].offset
+		 */
+		return READ_ONCE(times[0].offset) - READ_ONCE(times[1].offset);
+	}
+
+	return now + READ_ONCE(times[0].offset);
+}
+
 static inline u64 perf_cgroup_event_time(struct perf_event *event)
 {
 	struct perf_cgroup_info *t;
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	return t->time.time;
+	return __perf_event_time_ctx(event, &t->time);
 }
 
 static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
@@ -796,12 +828,12 @@ static inline u64 perf_cgroup_event_time
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
 	if (!__load_acquire(&t->active))
-		return t->time.time;
+		return __perf_event_time_ctx(event, &t->time);
 	now += READ_ONCE(t->time.offset);
-	return now;
+	return __perf_event_time_ctx_now(event, &t->time, now);
 }
 
-static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
+static inline void __update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
 {
 	if (adv)
 		time->time += now - time->stamp;
@@ -819,6 +851,13 @@ static inline void update_perf_time_ctx(
 	WRITE_ONCE(time->offset, time->time - time->stamp);
 }
 
+static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
+{
+	__update_perf_time_ctx(time + 0, now, adv);
+	if (__this_cpu_read(perf_in_guest))
+		__update_perf_time_ctx(time + 1, now, adv)
+}
+
 static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
 {
 	struct perf_cgroup *cgrp = cpuctx->cgrp;

