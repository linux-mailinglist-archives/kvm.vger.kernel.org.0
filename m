Return-Path: <kvm+bounces-16619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5FF58BC6CF
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A5DA281774
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:31:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40EF12BF2B;
	Mon,  6 May 2024 05:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MCsvrl7E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF90C6A008
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973442; cv=none; b=q+uvQ9uxfFhWh6OflTNHk0hEXfcVDv/Gz3sWPw2I0BNSgcHU07JUk3fBENj8i2kpOBKBTOcU+WsFMlyDxRyABmhm3Xqc06I/O6goBBl/ZbDShTXBCA2Y1MwW6MBg73jbzZqo/rFLxELSUrQA+9QEzm5eRRlGUxSzxxyHyCBUIws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973442; c=relaxed/simple;
	bh=J71VjJ5Nkkpbaj0gjw8oPf7WOPc3B55n16+J37qG1h8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EIqm5Oxjspjsr4BRdSY98V68H+D0anhbhgueUjcE+4R5qtJQmC7gdaAZfIFRjxYI8vUdbM5vPe9pZ+IOsnSkQO7UtZpujXLj+T9trIOBsS2OPxMCqS3h2pVGFw3fJGhgNldFA2qGgKcRPkG+bqnqiz1ZwA0SLdhrgrtNUroIS/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MCsvrl7E; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f449ea6804so2151550b3a.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973440; x=1715578240; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2JGTkNqizi9Vg1BZR7juTMryMl6SxngNGt1WQcBSzhE=;
        b=MCsvrl7Ezw0XeSLSMLiXzCiDZafWA1m7eBU+RUxauyvbYgqT3EbhANB92VSuyCJ26i
         Gt0fOhMuDvqHwgKurXiVdrBC4K2EOhRwaMJpEGAoiLiqKUYsVHu3ErxJ9DrAMwC/EBBS
         4E3YsC1CQRUmqSIT38iDRGmcmtOXYMObyX2ugH4G7oIU8iCpHmffhplIXW7PGkEQXtp8
         jlOY836/B1qUybojC635gTkqG0wY2+LSo1mbhX6ZlvNOUKGTbe76ZdcVAM6ccFJIYR2o
         KPZ6UG5KfsOdq3CVrSiCwQXXQm7Cub69sY/wNclIM5dcRs4c6nljP4NDbMoQwo4sbdpK
         TcDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973440; x=1715578240;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2JGTkNqizi9Vg1BZR7juTMryMl6SxngNGt1WQcBSzhE=;
        b=eq+AKGk+cCV6hNInRVD9CIFnby8/DQPyt2tlZv9l5zwy4HeIMx70Mu5KdwwfJPhH7q
         s9/PA+puCG+B4fh5mckpeN2BlWm/sR+jIyPDQeYIxMMCJncrOxQoernT1QAAD73VkBbe
         B0j1VrfiGc8Hk6fgczrIYkwx5Ladc+5NyYRE/Xad1MKcyhnknizQXkhRSEcbcIruMXz1
         BMEQtS4R98Okk0PaU5xCvSh7XIXE/pb/N9B++JAZ2Fm0IpXPWz3uqtTcE/22XbzG6Al1
         11knmPedpqwuo1VTC4bLxLvo5UX5CfuAM97GC9rNvg2rf35zb4UHR0kIGL3lZ0Zwtdf+
         8phQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMleLMKjbSOfMsIxjnKvMMO1//jL8TxUeaFeY7jNqCc7NxMrinveTub0TKEr6yzSlOpsAmVJcCNHpywe4CrlqgN2ax
X-Gm-Message-State: AOJu0YzDeYBIXnFWhS1tK6oD8zKg3x8CjIqXvA5uSjYm1qt1bByEwVhZ
	FNl1pf0lmB11rWHj8F+ObPcqYb4EE3uRYFBWkg4CN6aUNtxMgZp+QI4pjB0LBMcqpO13szkv9cK
	wgIm5Yg==
X-Google-Smtp-Source: AGHT+IGuFOm1jHHHZYze2f1GD5mh74ABhkOkHxNWYBnbZD7Y6g4eDyhDjnqH2Uh8t2wKfeoVU4DR+qm4Smi5
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:13a0:b0:6f0:b67e:dd0c with SMTP id
 t32-20020a056a0013a000b006f0b67edd0cmr365541pfg.5.1714973440068; Sun, 05 May
 2024 22:30:40 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:32 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-8-mizhang@google.com>
Subject: [PATCH v2 07/54] perf: Add generic exclude_guest support
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Xiong Zhang <xiong.y.zhang@intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Kan Liang <kan.liang@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Sandipan Das <sandipan.das@amd.com>
Cc: Jim Mattson <jmattson@google.com>, Stephane Eranian <eranian@google.com>, 
	Ian Rogers <irogers@google.com>, Namhyung Kim <namhyung@kernel.org>, 
	Mingwei Zhang <mizhang@google.com>, gce-passthrou-pmu-dev@google.com, 
	Samantha Alt <samantha.alt@intel.com>, Zhiyuan Lv <zhiyuan.lv@intel.com>, 
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

Current perf doesn't explicitly schedule out all exclude_guest events
while the guest is running. There is no problem for the current emulated
vPMU. Because perf owns all the PMU counters. It can mask the counter
which is assigned to a exclude_guest event when a guest is running
(Intel way), or set the correspoinding HOSTONLY bit in evsentsel (AMD
way). The counter doesn't count when a guest is running.

However, either way doesn't work with the passthrough vPMU introduced.
A guest owns all the PMU counters when it's running. Host should not
mask any counters. The counter may be used by the guest. The evsentsel
may be overwrite.

Perf should explicitly schedule out all exclude_guest events to release
the PMU resources when entering a guest, and resume the counting when
exiting the guest.

Expose two interfaces to KVM. The KVM should notify the perf when
entering/exiting a guest.

It's possible that a exclude_guest event is created when a guest is
running. The new event should not be scheduled in as well.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 include/linux/perf_event.h |   4 ++
 kernel/events/core.c       | 104 +++++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index dd4920bf3d1b..acf16676401a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1734,6 +1734,8 @@ extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
 extern int perf_get_mediated_pmu(void);
 extern void perf_put_mediated_pmu(void);
+void perf_guest_enter(void);
+void perf_guest_exit(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1826,6 +1828,8 @@ static inline int perf_get_mediated_pmu(void)
 }
 
 static inline void perf_put_mediated_pmu(void)			{ }
+static inline void perf_guest_enter(void)			{ }
+static inline void perf_guest_exit(void)			{ }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 701b622c670e..4c6daf5cc923 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -406,6 +406,7 @@ static atomic_t nr_include_guest_events __read_mostly;
 
 static refcount_t nr_mediated_pmu_vms = REFCOUNT_INIT(0);
 static DEFINE_MUTEX(perf_mediated_pmu_mutex);
+static DEFINE_PER_CPU(bool, perf_in_guest);
 
 /* !exclude_guest system wide event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
 static inline bool is_include_guest_event(struct perf_event *event)
@@ -3854,6 +3855,15 @@ static int merge_sched_in(struct perf_event *event, void *data)
 	if (!event_filter_match(event))
 		return 0;
 
+	/*
+	 * Don't schedule in any exclude_guest events of PMU with
+	 * PERF_PMU_CAP_PASSTHROUGH_VPMU, while a guest is running.
+	 */
+	if (__this_cpu_read(perf_in_guest) &&
+	    event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU &&
+	    event->attr.exclude_guest)
+		return 0;
+
 	if (group_can_go_on(event, *can_add_hw)) {
 		if (!group_sched_in(event, ctx))
 			list_add_tail(&event->active_list, get_event_list(event));
@@ -5791,6 +5801,100 @@ void perf_put_mediated_pmu(void)
 }
 EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
 
+static void perf_sched_out_exclude_guest(struct perf_event_context *ctx)
+{
+	struct perf_event_pmu_context *pmu_ctx;
+
+	update_context_time(ctx);
+	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
+		struct perf_event *event, *tmp;
+		struct pmu *pmu = pmu_ctx->pmu;
+
+		if (!(pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
+			continue;
+
+		perf_pmu_disable(pmu);
+
+		/*
+		 * All active events must be exclude_guest events.
+		 * See perf_get_mediated_pmu().
+		 * Unconditionally remove all active events.
+		 */
+		list_for_each_entry_safe(event, tmp, &pmu_ctx->pinned_active, active_list)
+			group_sched_out(event, pmu_ctx->ctx);
+
+		list_for_each_entry_safe(event, tmp, &pmu_ctx->flexible_active, active_list)
+			group_sched_out(event, pmu_ctx->ctx);
+
+		pmu_ctx->rotate_necessary = 0;
+
+		perf_pmu_enable(pmu);
+	}
+}
+
+/* When entering a guest, schedule out all exclude_guest events. */
+void perf_guest_enter(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(__this_cpu_read(perf_in_guest))) {
+		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+		return;
+	}
+
+	perf_sched_out_exclude_guest(&cpuctx->ctx);
+	if (cpuctx->task_ctx)
+		perf_sched_out_exclude_guest(cpuctx->task_ctx);
+
+	__this_cpu_write(perf_in_guest, true);
+
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+}
+
+static void perf_sched_in_exclude_guest(struct perf_event_context *ctx)
+{
+	struct perf_event_pmu_context *pmu_ctx;
+
+	update_context_time(ctx);
+	list_for_each_entry(pmu_ctx, &ctx->pmu_ctx_list, pmu_ctx_entry) {
+		struct pmu *pmu = pmu_ctx->pmu;
+
+		if (!(pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU))
+			continue;
+
+		perf_pmu_disable(pmu);
+		pmu_groups_sched_in(ctx, &ctx->pinned_groups, pmu);
+		pmu_groups_sched_in(ctx, &ctx->flexible_groups, pmu);
+		perf_pmu_enable(pmu);
+	}
+}
+
+void perf_guest_exit(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest))) {
+		perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+		return;
+	}
+
+	__this_cpu_write(perf_in_guest, false);
+
+	perf_sched_in_exclude_guest(&cpuctx->ctx);
+	if (cpuctx->task_ctx)
+		perf_sched_in_exclude_guest(cpuctx->task_ctx);
+
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+}
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


