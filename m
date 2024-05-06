Return-Path: <kvm+bounces-16618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3983A8BC6CE
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:31:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2CABDB2157F
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:31:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9091474432;
	Mon,  6 May 2024 05:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RsBTSxYM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406E44F218
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973440; cv=none; b=M92rjh0st+1sjaPjWGUgap/zH8tGzYBau+wNphv1KHk993fmvo3fFdeMZmi4kIE0oGK+jOlbFgOg7SB3aCZgB8bW0J4fFEXjBwDL9UuZuwbL773SZqysQmI1Ro+k8trQrwKaEMxSmlBYsvCQG0dI3xKSvaj9hq1U2iRqBaqY5Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973440; c=relaxed/simple;
	bh=+QWFJPHlThvofTPhQBRsdtYamAoR5AAbuvRVkJ+vK48=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PFBJdtIKyj8HQlZITUO39ZQUd6GrczEC1GOMri+UYLARATPo1osXigpqXBBz8603Zs5upNKCyZsFu8Z+WbPfngce7G5oY6iZLaX4CrUaDC1U60dwEQR4lSZQm9IcIwun8l8vtymcoV9+wr6GQruAIE2m83Oios/BZuMxXM6sPqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RsBTSxYM; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61be4b79115so35276357b3.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973438; x=1715578238; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=C0uXV2FpCJf1eTCcSGikTf9qijHz34JmD7mqnQQVcBI=;
        b=RsBTSxYMv6wbv2lnGSqN5nflM4web8fmvb3bXgJnYoN3PNfxRvHUuF90kHENKPTiJq
         vpMMqVNF+ANjiQgW3uW+wNNhcOASw+UbmOh50cJKt4NtvbhVOXmA/ZArO8QaxmKRba1S
         8zZG6+jfdx+BwuRoaXwzPyyu2DNQ12rhqYt4OzABWoZmcui6GTzXGBxfI2SoUiGhh17p
         q3IGSdqEWqlTCUZVVode5vRp49MjKaexIM6Iwv5SbBq1HOTrB2VxhNUJg9YCPDaxG9gY
         KexiqBFCUAmrLDfWurvo0rJaPpaXxg+riyWIfsLWr8q/87RDJ7xuF8Zrzfv4ADiKcuuJ
         KCrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973438; x=1715578238;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C0uXV2FpCJf1eTCcSGikTf9qijHz34JmD7mqnQQVcBI=;
        b=tf5mZC9pFZtIhyI+OL/f4gJxROuQwD36Vm/be/pm0Mbp6iP5Vxzxg94yJyypXKAnuZ
         zJsj/AjCIfIm2tG4/n0ilZZhZMp0QnHmd367AylrgImuyrqVRjs8yClg8V3EzTyKjjtH
         Trv+ogJy2KnMePg+pm7Ngi6y0Ee3BhbvLi1SKNpgJXIvJsl/hWfAR2jytkGTKwXgYmhH
         5EnKmwC9GyXqvwYynkSHC/KIhV3sHEAmYTO0tQDtw1VFNV2n8SdG5pKHktU54+dT93yP
         FApZ+ji2aqMIJCxuGwWc24aGU9pyD3f5u/X4oE//V8neEGuSBmwDGEc+/x4yZiPTIsmI
         OnOg==
X-Forwarded-Encrypted: i=1; AJvYcCWd5XllP9he8mdGhApkIr73sf8FZr2tnn0EqoLfi0PLDPfmsaujHDEWXxbfdK+9HApniwpTEbo2FGr0fwt3OClFA0/h
X-Gm-Message-State: AOJu0YwhtVHzYV7y+1CQGkEJEUHB/ae/EeYUUgLkjRpmW5FAUn0gVhTr
	E/CnMECrxbShqIokchWn97M6CWwKej1qjUME4D1q6uP1vPODRMsDWBdlAMtgdVWsmrdm4AXo0q6
	AqZZwEA==
X-Google-Smtp-Source: AGHT+IEqxRWED0t+Eaa9O87y3nmyUh43vM3hBkvg/CfwpaD8/jGGSpOk4SfzcoJ20nbLWXCNgvBLieKhQYg4
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a81:a18a:0:b0:61b:e6a7:e697 with SMTP id
 y132-20020a81a18a000000b0061be6a7e697mr2533383ywg.9.1714973438319; Sun, 05
 May 2024 22:30:38 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:31 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-7-mizhang@google.com>
Subject: [PATCH v2 06/54] perf: Support get/put passthrough PMU interfaces
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

Currently, the guest and host share the PMU resources when a guest is
running. KVM has to create an extra virtual event to simulate the
guest's event, which brings several issues, e.g., high overhead, not
accuracy and etc.

A new passthrough PMU method is proposed to address the issue. It requires
that the PMU resources can be fully occupied by the guest while it's
running. Two new interfaces are implemented to fulfill the requirement.
The hypervisor should invoke the interface while creating a guest which
wants the passthrough PMU capability.

The PMU resources should only be temporarily occupied as a whole when a
guest is running. When the guest is out, the PMU resources are still
shared among different users.

The exclude_guest event modifier is used to guarantee the exclusive
occupation of the PMU resources. When creating a guest, the hypervisor
should check whether there are !exclude_guest events in the system.
If yes, the creation should fail. Because some PMU resources have been
occupied by other users.
If no, the PMU resources can be safely accessed by the guest directly.
Perf guarantees that no new !exclude_guest events are created when a
guest is running.

Only the passthrough PMU is affected, but not for other PMU e.g., uncore
and SW PMU. The behavior of those PMUs are not changed. The guest
enter/exit interfaces should only impact the supported PMUs.
Add a new PERF_PMU_CAP_PASSTHROUGH_VPMU flag to indicate the PMUs that
support the feature.

Add nr_include_guest_events to track the !exclude_guest system-wide
event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
---
 include/linux/perf_event.h |  9 +++++
 kernel/events/core.c       | 67 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d2a15c0c6f8a..dd4920bf3d1b 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -291,6 +291,7 @@ struct perf_event_pmu_context;
 #define PERF_PMU_CAP_NO_EXCLUDE			0x0040
 #define PERF_PMU_CAP_AUX_OUTPUT			0x0080
 #define PERF_PMU_CAP_EXTENDED_HW_TYPE		0x0100
+#define PERF_PMU_CAP_PASSTHROUGH_VPMU		0x0200
 
 struct perf_output_handle;
 
@@ -1731,6 +1732,8 @@ extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
+extern int perf_get_mediated_pmu(void);
+extern void perf_put_mediated_pmu(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1817,6 +1820,12 @@ static inline u64 perf_event_pause(struct perf_event *event, bool reset)
 {
 	return 0;
 }
+static inline int perf_get_mediated_pmu(void)
+{
+	return 0;
+}
+
+static inline void perf_put_mediated_pmu(void)			{ }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 724e6d7e128f..701b622c670e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -402,6 +402,21 @@ static atomic_t nr_bpf_events __read_mostly;
 static atomic_t nr_cgroup_events __read_mostly;
 static atomic_t nr_text_poke_events __read_mostly;
 static atomic_t nr_build_id_events __read_mostly;
+static atomic_t nr_include_guest_events __read_mostly;
+
+static refcount_t nr_mediated_pmu_vms = REFCOUNT_INIT(0);
+static DEFINE_MUTEX(perf_mediated_pmu_mutex);
+
+/* !exclude_guest system wide event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
+static inline bool is_include_guest_event(struct perf_event *event)
+{
+	if ((event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) &&
+	    !event->attr.exclude_guest &&
+	    !event->attr.task)
+		return true;
+
+	return false;
+}
 
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
@@ -5193,6 +5208,9 @@ static void _free_event(struct perf_event *event)
 
 	unaccount_event(event);
 
+	if (is_include_guest_event(event))
+		atomic_dec(&nr_include_guest_events);
+
 	security_perf_event_free(event);
 
 	if (event->rb) {
@@ -5737,6 +5755,42 @@ u64 perf_event_pause(struct perf_event *event, bool reset)
 }
 EXPORT_SYMBOL_GPL(perf_event_pause);
 
+/*
+ * Currently invoked at VM creation to
+ * - Check whether there are existing !exclude_guest system wide events
+ *   of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU
+ * - Set nr_mediated_pmu_vms to prevent !exclude_guest event creation on
+ *   PMUs with PERF_PMU_CAP_PASSTHROUGH_VPMU
+ *
+ * No impact for the PMU without PERF_PMU_CAP_PASSTHROUGH_VPMU. The perf
+ * still owns all the PMU resources.
+ */
+int perf_get_mediated_pmu(void)
+{
+	int ret = 0;
+
+	mutex_lock(&perf_mediated_pmu_mutex);
+	if (refcount_inc_not_zero(&nr_mediated_pmu_vms))
+		goto end;
+
+	if (atomic_read(&nr_include_guest_events)) {
+		ret = -EBUSY;
+		goto end;
+	}
+	refcount_set(&nr_mediated_pmu_vms, 1);
+end:
+	mutex_unlock(&perf_mediated_pmu_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);
+
+void perf_put_mediated_pmu(void)
+{
+	if (!refcount_dec_not_one(&nr_mediated_pmu_vms))
+		refcount_set(&nr_mediated_pmu_vms, 0);
+}
+EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
@@ -12086,11 +12140,24 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (err)
 		goto err_callchain_buffer;
 
+	if (is_include_guest_event(event)) {
+		mutex_lock(&perf_mediated_pmu_mutex);
+		if (refcount_read(&nr_mediated_pmu_vms)) {
+			mutex_unlock(&perf_mediated_pmu_mutex);
+			err = -EACCES;
+			goto err_security_alloc;
+		}
+		atomic_inc(&nr_include_guest_events);
+		mutex_unlock(&perf_mediated_pmu_mutex);
+	}
+
 	/* symmetric to unaccount_event() in _free_event() */
 	account_event(event);
 
 	return event;
 
+err_security_alloc:
+	security_perf_event_free(event);
 err_callchain_buffer:
 	if (!event->parent) {
 		if (event->attr.sample_type & PERF_SAMPLE_CALLCHAIN)
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


