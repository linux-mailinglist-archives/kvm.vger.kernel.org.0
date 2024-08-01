Return-Path: <kvm+bounces-22839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C98B944253
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:00:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C45ACB22F1B
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:00:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6FD1145326;
	Thu,  1 Aug 2024 04:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vPMQ6GLC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA50143884
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 04:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488364; cv=none; b=kpFhWJORRwXsHmZ9SSwWZiQoNdglEgbpvVxyiQ+Q/y4kn7uIhmXGY2rIZnPeII7ELvnQkjO58qxdF1gj7mghvcTSTqIYUVJ/2K2Y9yz6NHV8THl6Y8OmYm8jN6ooSNc7Ii3xSExS9TfRmiOsVc1RwVvG8Pef2TxGG3tYV9Nh+Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488364; c=relaxed/simple;
	bh=Y2oKdGQFixKYysep5mtMEZPG1HOavWPGM4mOQh9bSTc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nQfqga0i3abuVAx3XEfUcuHU5vyAJX+rjrayfeXB6BAZ4b/UEXYsmC6XCrRH1AewEdVNTWA/4u6Kn7nNJc0vdkZXCFncrYmClT5WzMUlaVkwLpRAddT+CleJMuB5hqmVn6f5dtb30GK/U35ha41BhTqwXAJ5jI6Uf6f+CJp0o9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vPMQ6GLC; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7a2787eb33dso6444640a12.1
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 21:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488363; x=1723093163; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=U/v+CJ5mcJsRXRRG9Vhu8lil7+MVwtmAo65IN57uonU=;
        b=vPMQ6GLCd1neXWHU0IT+7ySlnMVtA9RH0b2m4kc+dCBBrUGyqv1emNHWZSL0pzP7wq
         Sr9IyQ6Mu3eOJasflyC1ouOMTtIeOy3zodafkZ5lhJCYD1NXijrn7R1iMdX/AVVsnyHl
         OszrWKVLq9UTZNRIfabhQ9qs8fH49lSI84FKl5Q9msCrgag9Jfjof4N5jqB6xv38o+aH
         k46hpQq1XmVgEb76jJOkTHblTrOBHYRNlFwPd1U9OSnB8xJK/RsNdzDIq7egG2c3ie6c
         DN5CBpboebQDetw3PRWKEvasy/Sc8CLFVHkQ5tag7qGhp2ZWsy/zXuSyi2sH0nD54IUN
         qfZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488363; x=1723093163;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U/v+CJ5mcJsRXRRG9Vhu8lil7+MVwtmAo65IN57uonU=;
        b=L4i/PR190Lo9w8ojlsycMyak4ihhJ8I9WPmgdEB/C2ZS9qVogiqFESrRw9p6PKcTOU
         HQffckcpUdfyPk7Kt5eOCU6wueyVFil1UfWOpxoF7O6+XiEZWSb9AHF0mh5vmrsRzdko
         PhjDXUzVC+yWgEfHiq1uADRH4SST3kcYX0GTPLjsZerRqBqKkO+ukjB+h4JlH6eTHIAI
         IzWs17t65qSarzKvf0g0t2SCcOcKt/5g9xEZq48a7GyOaHl3VBQuN1OAgxMa/YWrnNn7
         +54ayNIvu4Gn81IB1u5LzSPHqRNqqZqT/9vWjs8QLEVBDHjQqjw7LJDHyruUBmkBD+rJ
         RZpQ==
X-Forwarded-Encrypted: i=1; AJvYcCXt5T2Kz5dF3LPGPqFvrJbGu/deY/KYzdphrg9u1SpvlMA1JdHv6eCXTGwl4Wd/keAdqP12vsyNHjvZclfyqm9js6cC
X-Gm-Message-State: AOJu0YzOP/KpXwvF3HW/Z0pBci5P/tdPJVbDbG4ZunWVYaPuqa8n4/k2
	t2xteGgfqAGemITyyu95mFFVxL6iJmM6IKiyfFL6VxJXUQP83H1cfyCsuFkDpfid3Bo3gjxn4K5
	mKK2B7g==
X-Google-Smtp-Source: AGHT+IH78Dq08etLHi4ZMudq84xi8KT5KSIOZU8bUwbPZ9A/Ozize3/rl6h0gHrRn30YS/d2rLGkH7RHU5zr
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a17:902:f688:b0:1fa:acf0:72d6 with SMTP id
 d9443c01a7336-1ff4ced872cmr1004635ad.3.1722488362716; Wed, 31 Jul 2024
 21:59:22 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:15 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-7-mizhang@google.com>
Subject: [RFC PATCH v3 06/58] perf: Support get/put passthrough PMU interfaces
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

Add nr_include_guest_events to track the !exclude_guest events of PMU
with PERF_PMU_CAP_PASSTHROUGH_VPMU.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 include/linux/perf_event.h | 10 ++++++
 kernel/events/core.c       | 66 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index a5304ae8c654..45d1ea82aa21 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -291,6 +291,7 @@ struct perf_event_pmu_context;
 #define PERF_PMU_CAP_NO_EXCLUDE			0x0040
 #define PERF_PMU_CAP_AUX_OUTPUT			0x0080
 #define PERF_PMU_CAP_EXTENDED_HW_TYPE		0x0100
+#define PERF_PMU_CAP_PASSTHROUGH_VPMU		0x0200
 
 struct perf_output_handle;
 
@@ -1728,6 +1729,8 @@ extern void perf_event_task_tick(void);
 extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
+int perf_get_mediated_pmu(void);
+void perf_put_mediated_pmu(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1814,6 +1817,13 @@ static inline u64 perf_event_pause(struct perf_event *event, bool reset)
 {
 	return 0;
 }
+
+static inline int perf_get_mediated_pmu(void)
+{
+	return 0;
+}
+
+static inline void perf_put_mediated_pmu(void)			{ }
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8f908f077935..45868d276cde 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -402,6 +402,20 @@ static atomic_t nr_bpf_events __read_mostly;
 static atomic_t nr_cgroup_events __read_mostly;
 static atomic_t nr_text_poke_events __read_mostly;
 static atomic_t nr_build_id_events __read_mostly;
+static atomic_t nr_include_guest_events __read_mostly;
+
+static atomic_t nr_mediated_pmu_vms;
+static DEFINE_MUTEX(perf_mediated_pmu_mutex);
+
+/* !exclude_guest event of PMU with PERF_PMU_CAP_PASSTHROUGH_VPMU */
+static inline bool is_include_guest_event(struct perf_event *event)
+{
+	if ((event->pmu->capabilities & PERF_PMU_CAP_PASSTHROUGH_VPMU) &&
+	    !event->attr.exclude_guest)
+		return true;
+
+	return false;
+}
 
 static LIST_HEAD(pmus);
 static DEFINE_MUTEX(pmus_lock);
@@ -5212,6 +5226,9 @@ static void _free_event(struct perf_event *event)
 
 	unaccount_event(event);
 
+	if (is_include_guest_event(event))
+		atomic_dec(&nr_include_guest_events);
+
 	security_perf_event_free(event);
 
 	if (event->rb) {
@@ -5769,6 +5786,36 @@ u64 perf_event_pause(struct perf_event *event, bool reset)
 }
 EXPORT_SYMBOL_GPL(perf_event_pause);
 
+/*
+ * Currently invoked at VM creation to
+ * - Check whether there are existing !exclude_guest events of PMU with
+ *   PERF_PMU_CAP_PASSTHROUGH_VPMU
+ * - Set nr_mediated_pmu_vms to prevent !exclude_guest event creation on
+ *   PMUs with PERF_PMU_CAP_PASSTHROUGH_VPMU
+ *
+ * No impact for the PMU without PERF_PMU_CAP_PASSTHROUGH_VPMU. The perf
+ * still owns all the PMU resources.
+ */
+int perf_get_mediated_pmu(void)
+{
+	guard(mutex)(&perf_mediated_pmu_mutex);
+	if (atomic_inc_not_zero(&nr_mediated_pmu_vms))
+		return 0;
+
+	if (atomic_read(&nr_include_guest_events))
+		return -EBUSY;
+
+	atomic_inc(&nr_mediated_pmu_vms);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(perf_get_mediated_pmu);
+
+void perf_put_mediated_pmu(void)
+{
+	atomic_dec(&nr_mediated_pmu_vms);
+}
+EXPORT_SYMBOL_GPL(perf_put_mediated_pmu);
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
@@ -11907,6 +11954,17 @@ static void account_event(struct perf_event *event)
 	account_pmu_sb_event(event);
 }
 
+static int perf_account_include_guest_event(void)
+{
+	guard(mutex)(&perf_mediated_pmu_mutex);
+
+	if (atomic_read(&nr_mediated_pmu_vms))
+		return -EACCES;
+
+	atomic_inc(&nr_include_guest_events);
+	return 0;
+}
+
 /*
  * Allocate and initialize an event structure
  */
@@ -12114,11 +12172,19 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (err)
 		goto err_callchain_buffer;
 
+	if (is_include_guest_event(event)) {
+		err = perf_account_include_guest_event();
+		if (err)
+			goto err_security_alloc;
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
2.46.0.rc1.232.g9752f9e123-goog


