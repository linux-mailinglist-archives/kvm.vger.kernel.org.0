Return-Path: <kvm+bounces-22847-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E0094425B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 066241F224F8
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:01:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E608413E023;
	Thu,  1 Aug 2024 04:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IQtzQXmN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5811494A7
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488379; cv=none; b=QMhbyS6qp/xsAgpPCtzufQgn5Uhai3I1GRC1b5dhmT5yGyuO+p8nWId/nTIYUl4BfccTEoF7GsmXUIHjddwwRar0X4YJ16DnSLjku2Z2KBDMDGHxEPblkLBTudAV9xF6MEw+6jS8DHqqQ9v4N5rMP1MF73gNWPfpFph+BOlGy70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488379; c=relaxed/simple;
	bh=02tnM7/qpDAUsw/+gR8ObHrOBPgLqDoOs5Lh1ph0QeQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=YL4fGOBky7Ya0a1yIu62QIpqe66h8pgfe7nYY801jpB+YhiC+bl3hfmRaWNdtlrAlMFN8T8Ww/6czbnhCRVSqeirLC8XSKSNDLYXpN8GRFT2OMh9VUQwqb3svUQlW90RmAcsonAdpQRX/DG67iXZ4IJWHosB7bwDxqQWc44wCuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IQtzQXmN; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fc658a161bso39734355ad.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488377; x=1723093177; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=km+p8LX37fq6mHG8tieZJX2dAdQpJDVGZUlT9VV4F9Q=;
        b=IQtzQXmNhsMfy2ccIXk9V375xJqS5qKR8k8yIFl1XYgGmlF5JEJKY2UNcP/2nQPCQ2
         JYNIz7qG4KSolnxFnC/sXvvc929JqPBJPocXQ0Z3sPHGv06WpRPL6UpHNwPAwM6UbgbQ
         WTVJcQJRrH1cVO29BGvFMrb5xhEsVjYzCsnVhVvFJaVLzaoG7WPKiAno5PnsyUTTt9O4
         osJoE4u/J+ox3QrXPUr95cYCTp8dD2VBZTwJ9ZhgqXh4zSYHa/FOxf9iL4Y4c8oQyl2i
         GrdiyKCuXFr2HQd20qb21auh4c5JrkJI9JDAPMDm9prijj6KU75Pe7baeVcSAoPFuqmn
         C9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488377; x=1723093177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=km+p8LX37fq6mHG8tieZJX2dAdQpJDVGZUlT9VV4F9Q=;
        b=bywxnIn6e8CS+oN8MTd597/l7NJaVbVvIPOXAPT9Yaz2dEzf+kulkOByP5QdRdPptU
         ixwD4ZnpTgGlx+FLYT2KdXSKu2ReJG+2SAYbc7Vju7fQW2MVLbNHuZPkjKF2OOf7yuQ5
         W8HWJIaELA4s1UKZmUnhcbAhSGIwIVu6padSAQxqW96QAB8FC4g3hQoRl0nzkHKttXgq
         i8tsgFyWOhQ8++M1q0i7x+68ngCNa+/mC8W31W+YdAd9eu9UaZx6KJHrkiT0jSr3Amgn
         lN25CnF30jgoEueAsmemRcNZGbJWaWNco18ZSRN/vrlrHHYUV2uFKBZqLimnd8vKiwf4
         sfjg==
X-Forwarded-Encrypted: i=1; AJvYcCVEOm9RnGTRl4D+psYgGBX0mxnMnl9U5gvbakVltvl49R5niQEB37HWDQZ7FkeCWNSwZXt7ppCjT8BkrvW1rq5iTKLz
X-Gm-Message-State: AOJu0YyTEP8dztnMKWi/IqN//gVxITdWoHvNz1vVe9ZdegkUlhwGu54g
	T1If7Wruqw8CPGqPUuxtIClYFkBQ9lH5jypnuSL5mVmXw9beyzrv9pQlhfSe/tIAELpRiPnTePS
	b7CYZyQ==
X-Google-Smtp-Source: AGHT+IECPDnBABss0TIx0jpPEV7X5AaKhV9r393eoJgc9v2aXrrjfacIDevTaKo6bcPtGTm/IU/yklRpVTQ7
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:ce11:b0:1fb:82f5:6631 with SMTP id
 d9443c01a7336-1ff4d1ffdbbmr915595ad.9.1722488376993; Wed, 31 Jul 2024
 21:59:36 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:23 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-15-mizhang@google.com>
Subject: [RFC PATCH v3 14/58] perf: Add switch_interrupt() interface
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

There will be a dedicated interrupt vector for guests on some platforms,
e.g., Intel. Add an interface to switch the interrupt vector while
entering/exiting a guest.

When PMI switch into a new guest vector, guest_lvtpc value need to be
reflected onto HW, e,g., guest clear PMI mask bit, the HW PMI mask
bit should be cleared also, then PMI can be generated continuously
for guest. So guest_lvtpc parameter is added into perf_guest_enter()
and switch_interrupt().

At switch_interrupt(), the target pmu with PASSTHROUGH cap should
be found. Since only one passthrough pmu is supported, we keep the
implementation simply by tracking the pmu as a global variable.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>

[Simplify the commit with removal of srcu lock/unlock since only one pmu is
supported.]

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 include/linux/perf_event.h |  9 +++++++--
 kernel/events/core.c       | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 41 insertions(+), 4 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 75773f9890cc..aeb08f78f539 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -541,6 +541,11 @@ struct pmu {
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
 	 */
 	int (*check_period)		(struct perf_event *event, u64 value); /* optional */
+
+	/*
+	 * Switch the interrupt vectors, e.g., guest enter/exit.
+	 */
+	void (*switch_interrupt)	(bool enter, u32 guest_lvtpc); /* optional */
 };
 
 enum perf_addr_filter_action_t {
@@ -1738,7 +1743,7 @@ extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
 int perf_get_mediated_pmu(void);
 void perf_put_mediated_pmu(void);
-void perf_guest_enter(void);
+void perf_guest_enter(u32 guest_lvtpc);
 void perf_guest_exit(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
@@ -1833,7 +1838,7 @@ static inline int perf_get_mediated_pmu(void)
 }
 
 static inline void perf_put_mediated_pmu(void)			{ }
-static inline void perf_guest_enter(void)			{ }
+static inline void perf_guest_enter(u32 guest_lvtpc)		{ }
 static inline void perf_guest_exit(void)			{ }
 #endif
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 57ff737b922b..047ca5748ee2 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -422,6 +422,7 @@ static inline bool is_include_guest_event(struct perf_event *event)
 
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
+static struct pmu *passthru_pmu;
 static struct srcu_struct pmus_srcu;
 static cpumask_var_t perf_online_mask;
 static struct kmem_cache *perf_event_cache;
@@ -5941,8 +5942,21 @@ void perf_put_mediated_pmu(void)
 }
 EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
 
+static void perf_switch_interrupt(bool enter, u32 guest_lvtpc)
+{
+	/* Mediated passthrough PMU should have PASSTHROUGH_VPMU cap. */
+	if (!passthru_pmu)
+		return;
+
+	if (passthru_pmu->switch_interrupt &&
+	    try_module_get(passthru_pmu->module)) {
+		passthru_pmu->switch_interrupt(enter, guest_lvtpc);
+		module_put(passthru_pmu->module);
+	}
+}
+
 /* When entering a guest, schedule out all exclude_guest events. */
-void perf_guest_enter(void)
+void perf_guest_enter(u32 guest_lvtpc)
 {
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
 
@@ -5962,6 +5976,8 @@ void perf_guest_enter(void)
 		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
 	}
 
+	perf_switch_interrupt(true, guest_lvtpc);
+
 	__this_cpu_write(perf_in_guest, true);
 
 unlock:
@@ -5980,6 +5996,8 @@ void perf_guest_exit(void)
 	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
 		goto unlock;
 
+	perf_switch_interrupt(false, 0);
+
 	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
 	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
 	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
@@ -11842,7 +11860,21 @@ int perf_pmu_register(struct pmu *pmu, const char *name, int type)
 	if (!pmu->event_idx)
 		pmu->event_idx = perf_event_idx_default;
 
-	list_add_rcu(&pmu->entry, &pmus);
+	/*
+	 * Initialize passthru_pmu with the core pmu that has
+	 * PERF_PMU_CAP_PASSTHROUGH_VPMU capability.
+	 */
+	if (pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) {
+		if (!passthru_pmu)
+			passthru_pmu = pmu;
+
+		if (WARN_ONCE(passthru_pmu != pmu, "Only one passthrough PMU is supported\n")) {
+			ret = -EINVAL;
+			goto free_dev;
+		}
+	}
+
+	list_add_tail_rcu(&pmu->entry, &pmus);
 	atomic_set(&pmu->exclusive_cnt, 0);
 	ret = 0;
 unlock:
-- 
2.46.0.rc1.232.g9752f9e123-goog


