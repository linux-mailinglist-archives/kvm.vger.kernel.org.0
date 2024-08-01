Return-Path: <kvm+bounces-22841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E8129944255
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:00:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16C591C22535
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C248A146D7A;
	Thu,  1 Aug 2024 04:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W1znYxYD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3665B1448E5
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488370; cv=none; b=aYNSk08TnzEU4TYW4rmEztAYgzIUBplUjBLmJJCi4gmsjEMHezHd9ajeMVqaVg/lL58JWxLxepi3rSyQu0pjrnIl5v5jBNdxtOFciW8H7RMdwe9JCpwGTHZRztKAgkAMcjlYNYcr48ZZO+8/9/NXJTZAZatKKaN+kJiFiLIj1u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488370; c=relaxed/simple;
	bh=tpzCQzHMZFX7c1AT5cMEt40rEO2f6HsB/bvU99X/K/0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Qnvgf1G27+RoQydG780MTFAtKROp8wa/n+1DE9vjWkuwg9BeNDmDqtkEmWBUttZQ/tqd7PiEqXNhVEmNyA5Kw04eV+jPgh929QcZ3pnERQ+88fgXAcE3dGOiXytSAmzKlr7iJ/8DaHMDvOSIvqwyJzI44fE+1pBVqlo2VGtE1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W1znYxYD; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e03b3f48c65so9617082276.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488366; x=1723093166; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=PXHETXmeoMyzkRFbIwNld5EMsoT/IC0GxFRJGsoikdg=;
        b=W1znYxYDNIkT5ESLvQEVZAcVXsPQvOfMnihoSnQvE6oNtYxN+RFVSAP+CEUWUB4qsb
         4/z16SSeDtYHzoTFjCjVVP+Gejc7Trffs/o5PBIGnBHU6r3OOaovaLg6msH6ooFMBV6d
         cxrobBnER8CsSQpVSGcjYwhWEzYty+8bJbmKyL+EwrfefAcFZwPI9RTkGy8KSnXPbvaU
         +GoE13q5jjclRCXp3HyPF2RsDAN+6M705PENmctOFxJeMX0bX5J6kJUAO+sRo0THKpDT
         p5D7Wp7hDhQt3nbxgP42q46N6U/slLpgu4iTJ4xb5GVh7VPTjn828TamQAoYlM57BsLm
         4ZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488366; x=1723093166;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PXHETXmeoMyzkRFbIwNld5EMsoT/IC0GxFRJGsoikdg=;
        b=bA/d406EusCRpUIoSK5vkIJGoh5MqdzR9qeA2z79DRNnh4HqVIdI422OALkfFG22Qs
         +1GcBKBGJA4qY+5r85xwauOReKhIJpgZoROp3wN1kZmt1kVmbIxdt6A1xdYn+La+2UEj
         vFTB2IDykdv32ymQeydBLuzWGEVZ9fpF1YeUBG6NBo/TUYjrsRrw7hlx5yuhn+Umeziw
         FxWuN1MsKzMDVMHRpD45dNeeVsLZUXM7Y7GRyTfLy8YqDVmVcLNVAEB+83E5xzfu7ZfS
         XTGBxtZQz0ruVQ2ETfiSYm2CRQQ4xgPI5lqX5UwGBDO3SF6AcXVrZDW2Atv4joLAoEoR
         iNJw==
X-Forwarded-Encrypted: i=1; AJvYcCWObMlGKvTFKkNIDO9FBD/Bdy2W78wf4UB8JmTIYs2SxJaxti7pdfZiaOnOal2iiSa4BsEIe9phhHtFaRO8c9TL5Wq/
X-Gm-Message-State: AOJu0YwHXEdOGFKIJo0KPBeA+1M+kAZlJkdnUEvfdpghMATTb3cyfvu9
	fo1cncqv98PUdIk9MHzDDNvKSLg+v9g87Kgn64rOSU3Nski2z3FDJRVC8xiUX3eRu/l+5s6o4cH
	cO0/mYg==
X-Google-Smtp-Source: AGHT+IEHQusDUcT+dsbbixAwzBJb2jo69k9Y9gegBibYfPM2SYsP1xjAxKCxFo07IkBWHLNsgRYNtIIxRUIb
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:1501:b0:e0b:edb:143c with SMTP id
 3f1490d57ef6-e0bccf8a219mr6379276.0.1722488366177; Wed, 31 Jul 2024 21:59:26
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:17 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-9-mizhang@google.com>
Subject: [RFC PATCH v3 08/58] perf: Clean up perf ctx time
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, Like Xu <like.xu.linux@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Raghavendra Rao Ananta <rananta@google.com>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

The current perf tracks two timestamps for the normal ctx and cgroup.
The same type of variables and similar codes are used to track the
timestamps. In the following patch, the third timestamp to track the
guest time will be introduced.
To avoid the code duplication, add a new struct perf_time_ctx and factor
out a generic function update_perf_time_ctx().

No functional change.

Suggested-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 include/linux/perf_event.h | 13 +++++----
 kernel/events/core.c       | 59 +++++++++++++++++++-------------------
 2 files changed, 37 insertions(+), 35 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 45d1ea82aa21..e22cdb6486e6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -906,6 +906,11 @@ struct perf_event_groups {
 	u64		index;
 };
 
+struct perf_time_ctx {
+	u64		time;
+	u64		stamp;
+	u64		offset;
+};
 
 /**
  * struct perf_event_context - event context structure
@@ -945,9 +950,7 @@ struct perf_event_context {
 	/*
 	 * Context clock, runs when context enabled.
 	 */
-	u64				time;
-	u64				timestamp;
-	u64				timeoffset;
+	struct perf_time_ctx		time;
 
 	/*
 	 * These fields let us detect when two contexts have both
@@ -1040,9 +1043,7 @@ struct bpf_perf_event_data_kern {
  * This is a per-cpu dynamically allocated data structure.
  */
 struct perf_cgroup_info {
-	u64				time;
-	u64				timestamp;
-	u64				timeoffset;
+	struct perf_time_ctx		time;
 	int				active;
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7cb51dbf897a..c25e2bf27001 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -775,7 +775,7 @@ static inline u64 perf_cgroup_event_time(struct perf_event *event)
 	struct perf_cgroup_info *t;
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
-	return t->time;
+	return t->time.time;
 }
 
 static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
@@ -784,20 +784,16 @@ static inline u64 perf_cgroup_event_time_now(struct perf_event *event, u64 now)
 
 	t = per_cpu_ptr(event->cgrp->info, event->cpu);
 	if (!__load_acquire(&t->active))
-		return t->time;
-	now += READ_ONCE(t->timeoffset);
+		return t->time.time;
+	now += READ_ONCE(t->time.offset);
 	return now;
 }
 
+static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv);
+
 static inline void __update_cgrp_time(struct perf_cgroup_info *info, u64 now, bool adv)
 {
-	if (adv)
-		info->time += now - info->timestamp;
-	info->timestamp = now;
-	/*
-	 * see update_context_time()
-	 */
-	WRITE_ONCE(info->timeoffset, info->time - info->timestamp);
+	update_perf_time_ctx(&info->time, now, adv);
 }
 
 static inline void update_cgrp_time_from_cpuctx(struct perf_cpu_context *cpuctx, bool final)
@@ -860,7 +856,7 @@ perf_cgroup_set_timestamp(struct perf_cpu_context *cpuctx)
 	for (css = &cgrp->css; css; css = css->parent) {
 		cgrp = container_of(css, struct perf_cgroup, css);
 		info = this_cpu_ptr(cgrp->info);
-		__update_cgrp_time(info, ctx->timestamp, false);
+		__update_cgrp_time(info, ctx->time.stamp, false);
 		__store_release(&info->active, 1);
 	}
 }
@@ -1469,18 +1465,11 @@ static void perf_unpin_context(struct perf_event_context *ctx)
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
 }
 
-/*
- * Update the record of the current time in a context.
- */
-static void __update_context_time(struct perf_event_context *ctx, bool adv)
+static inline void update_perf_time_ctx(struct perf_time_ctx *time, u64 now, bool adv)
 {
-	u64 now = perf_clock();
-
-	lockdep_assert_held(&ctx->lock);
-
 	if (adv)
-		ctx->time += now - ctx->timestamp;
-	ctx->timestamp = now;
+		time->time += now - time->stamp;
+	time->stamp = now;
 
 	/*
 	 * The above: time' = time + (now - timestamp), can be re-arranged
@@ -1491,7 +1480,19 @@ static void __update_context_time(struct perf_event_context *ctx, bool adv)
 	 * it's (obviously) not possible to acquire ctx->lock in order to read
 	 * both the above values in a consistent manner.
 	 */
-	WRITE_ONCE(ctx->timeoffset, ctx->time - ctx->timestamp);
+	WRITE_ONCE(time->offset, time->time - time->stamp);
+}
+
+/*
+ * Update the record of the current time in a context.
+ */
+static void __update_context_time(struct perf_event_context *ctx, bool adv)
+{
+	u64 now = perf_clock();
+
+	lockdep_assert_held(&ctx->lock);
+
+	update_perf_time_ctx(&ctx->time, now, adv);
 }
 
 static void update_context_time(struct perf_event_context *ctx)
@@ -1509,7 +1510,7 @@ static u64 perf_event_time(struct perf_event *event)
 	if (is_cgroup_event(event))
 		return perf_cgroup_event_time(event);
 
-	return ctx->time;
+	return ctx->time.time;
 }
 
 static u64 perf_event_time_now(struct perf_event *event, u64 now)
@@ -1523,9 +1524,9 @@ static u64 perf_event_time_now(struct perf_event *event, u64 now)
 		return perf_cgroup_event_time_now(event, now);
 
 	if (!(__load_acquire(&ctx->is_active) & EVENT_TIME))
-		return ctx->time;
+		return ctx->time.time;
 
-	now += READ_ONCE(ctx->timeoffset);
+	now += READ_ONCE(ctx->time.offset);
 	return now;
 }
 
@@ -11302,14 +11303,14 @@ static void task_clock_event_update(struct perf_event *event, u64 now)
 
 static void task_clock_event_start(struct perf_event *event, int flags)
 {
-	local64_set(&event->hw.prev_count, event->ctx->time);
+	local64_set(&event->hw.prev_count, event->ctx->time.time);
 	perf_swevent_start_hrtimer(event);
 }
 
 static void task_clock_event_stop(struct perf_event *event, int flags)
 {
 	perf_swevent_cancel_hrtimer(event);
-	task_clock_event_update(event, event->ctx->time);
+	task_clock_event_update(event, event->ctx->time.time);
 }
 
 static int task_clock_event_add(struct perf_event *event, int flags)
@@ -11329,8 +11330,8 @@ static void task_clock_event_del(struct perf_event *event, int flags)
 static void task_clock_event_read(struct perf_event *event)
 {
 	u64 now = perf_clock();
-	u64 delta = now - event->ctx->timestamp;
-	u64 time = event->ctx->time + delta;
+	u64 delta = now - event->ctx->time.stamp;
+	u64 time = event->ctx->time.time + delta;
 
 	task_clock_event_update(event, time);
 }
-- 
2.46.0.rc1.232.g9752f9e123-goog


