Return-Path: <kvm+bounces-22843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC663944257
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6E0B11F22C4F
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17F71142625;
	Thu,  1 Aug 2024 04:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HYswRxFf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C348C146D7D
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488372; cv=none; b=PE/5U/NhK4ovJotA7Bw9qfNLzINXqJx4H0XdFBv7c6IVEZvDVH8AK1tEcnesLPG9DnI7U90b8D3ONkOjQxMgqmyH5lHfKQjGUea6CpkHChVOj4LzbawYIKZN6ukF+5LPstuuy4GvbEZTiyB1dPnaUEWWHRDEmFS5dG22e1dxg/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488372; c=relaxed/simple;
	bh=o5hEtqrZtZQ+GSVgDLW9bBqacTp65v2v47VvU5C1Xzg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=anLncitwog6g53Q30ltfqNJKJyj0UhaNRkjUE4A9NbgOQyr0ZpjRPkYYZxDlz0ARur4LESqhZr/o4u+hbJkle4/rRbek/SXDV6T4PtA+sAK1HstV9G0fhFHRUVUlx+t885XtiahlCQt7HWFO5PbEEyKhw4dadk6dKy2dOMmme20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HYswRxFf; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66619cb2d3eso139767557b3.2
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488369; x=1723093169; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jpGgyT7HBtCD2+qsQsy2UlEb4EuF6pmeTb/cXO1/UxM=;
        b=HYswRxFfZ0Ik8888e6av6S8JJAfNfBZxXAWZTCjcal+m/a+uItyyodUMx9mDlk2tQq
         UR0Rqy+YR+B/uHpXPbPXx+ax74G+1ouhI0bf7UPH8ZrlVCt3NXD8htz7v5IWXNm38yNv
         EavhIVPox2hUekDMO/GIFA1GfH+/S/HU1/MmIZlaRTnPSHlooYPVg/mxynV2iNa+D0oK
         RO8akl8GVnWz+rlwSPgKWSg86QH2HRZSjbCzAmAIWD/+Y5vxXrtBUauFiJrYh8oqYG46
         8mw0tqH0Q8eS1q0rMpmUJ7aQSTTIwz1jSUecJgfhWjQNCBL50nzRlWLCgXDynnCGIW27
         DP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488369; x=1723093169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jpGgyT7HBtCD2+qsQsy2UlEb4EuF6pmeTb/cXO1/UxM=;
        b=QU7vifVNxEsgUttslWFMoKW6J0e0eqIWeedyDN5Gn23MTZnCG2sSQupfCRctOaNRGA
         TTusPrZIEcJ97LaHX7dMbmTc7SonPaTIzQCmfkWrhF5enxvrcP2/ZWCq4jo2fsjF2aka
         Spj9P5A9hLJVhm1cU/aejmk1IpX9GcQ9tfMRI+Ml8DfCxFGtiHYMB/eHyIBnPXPzsPYn
         hEMEMandFiSYzXEzyJOpZwP/HyJHFEQtXQQod/90qV4MR5S7JTeBJX4PKhOI/YEIG6Pw
         AsOtY8FEysc6NqnASdcaC7lCKxtams5nIeo2DzHHhhX1tZGX1pYeQz5+k3gckIkAiJCE
         6Ruw==
X-Forwarded-Encrypted: i=1; AJvYcCXN6enFY64cFJS/awxGOUtXNbpq6uGlWc06hFqjKR4s401cXmiBwJ4CevU+12t2419wJhbYysIlwhISe9mK8NLDli4B
X-Gm-Message-State: AOJu0YyTRD4p07Tz5ICNjWLy+VXTiRqy8WZYBuAaS5MxAXBJ/ID7dAL1
	kmswHX3I2k7xbMfwDfPnmcHTQO8rnseyHTBvNUVIh7tfQDvu5oEcA0Q1J59mNP6/OIOCyf9wA5J
	SxEAiyw==
X-Google-Smtp-Source: AGHT+IE36C0k9NJpJpbVp5XW9qqNl7CG6TduA9fccCY/71DaZJCFFGgQWLIivQyA9lnhS41mowX8N3sFiVCM
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:18c5:b0:e05:faf5:a19e with SMTP id
 3f1490d57ef6-e0bcd2553f4mr2378276.6.1722488369672; Wed, 31 Jul 2024 21:59:29
 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:19 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-11-mizhang@google.com>
Subject: [RFC PATCH v3 10/58] perf: Add generic exclude_guest support
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

Only KVM knows the exact time when a guest is entering/exiting. Expose
two interfaces to KVM to switch the ownership of the PMU resources.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 include/linux/perf_event.h |  4 +++
 kernel/events/core.c       | 54 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 81a5f8399cb8..75773f9890cc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1738,6 +1738,8 @@ extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
 int perf_get_mediated_pmu(void);
 void perf_put_mediated_pmu(void);
+void perf_guest_enter(void);
+void perf_guest_exit(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1831,6 +1833,8 @@ static inline int perf_get_mediated_pmu(void)
 }
 
 static inline void perf_put_mediated_pmu(void)			{ }
+static inline void perf_guest_enter(void)			{ }
+static inline void perf_guest_exit(void)			{ }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 57648736e43e..57ff737b922b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5941,6 +5941,60 @@ void perf_put_mediated_pmu(void)
 }
 EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
 
+/* When entering a guest, schedule out all exclude_guest events. */
+void perf_guest_enter(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(__this_cpu_read(perf_in_guest)))
+		goto unlock;
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	ctx_sched_out(&cpuctx->ctx, EVENT_GUEST);
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx) {
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+		task_ctx_sched_out(cpuctx->task_ctx, EVENT_GUEST);
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+	}
+
+	__this_cpu_write(perf_in_guest, true);
+
+unlock:
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+}
+EXPORT_SYMBOL_GPL(perf_guest_enter);
+
+void perf_guest_exit(void)
+{
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
+
+	lockdep_assert_irqs_disabled();
+
+	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+
+	if (WARN_ON_ONCE(!__this_cpu_read(perf_in_guest)))
+		goto unlock;
+
+	perf_ctx_disable(&cpuctx->ctx, EVENT_GUEST);
+	ctx_sched_in(&cpuctx->ctx, EVENT_GUEST);
+	perf_ctx_enable(&cpuctx->ctx, EVENT_GUEST);
+	if (cpuctx->task_ctx) {
+		perf_ctx_disable(cpuctx->task_ctx, EVENT_GUEST);
+		ctx_sched_in(cpuctx->task_ctx, EVENT_GUEST);
+		perf_ctx_enable(cpuctx->task_ctx, EVENT_GUEST);
+	}
+
+	__this_cpu_write(perf_in_guest, false);
+unlock:
+	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
+}
+EXPORT_SYMBOL_GPL(perf_guest_exit);
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
-- 
2.46.0.rc1.232.g9752f9e123-goog


