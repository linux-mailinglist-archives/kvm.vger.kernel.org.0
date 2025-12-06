Return-Path: <kvm+bounces-65397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CE9D6CA9B16
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9C8B231BC254
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA6E21B185;
	Sat,  6 Dec 2025 00:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3iIpNMqJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64088223DE7
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980257; cv=none; b=BGTpFrYozhYDEKSFu+zb9b4p+uyogEvP5T43csCvhzMeXlyi8eJ7XxvB95pVt1cWJNgmeJyZL8OnvMf2HFCG10Zpx8VZIH56C2+E/12U4r2KQBRKbrWQUFocsqQnQpYQTZecbMF7w0f2QGhJa/5F6QNGlnxdQcpXoe65x/TrkBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980257; c=relaxed/simple;
	bh=QLQZjWHCBv07/qr5bOJVEcqFcY4sq2RI3wzauvN7A34=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sFJHrJlnumv4xW8NRFarF/flA4Vt3x+64LxeCIHgG3q2eQsEnWmhNH5m9Ez0a4Ejc9qzOe1cu6r7CeDcjbwkUbgO05a15rpC74lyUuJVUbGNLaBy4x70wCQAABHuC1NJx19mO9vMrD5RXfQTiyD4EFrfwCdCiY8zy0a5u2ODsyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3iIpNMqJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-343e262230eso3273844a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980255; x=1765585055; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wmQUDTBRI6uAYPiZERIyuwnHpmVucKzvhAShzUV1wg8=;
        b=3iIpNMqJ366fJfO+YSSAcxqYolblWh8q6TqpHIXfTTjRH18GMFBh0j7NRm6lhCvncr
         8mKnNULVd/yFqZ3kpvgUN614kQE+e4k0c/KCJDGaVL+c/qjI3zXi7c/y0cIFYnL8ZXSa
         FGs1LM4FxwVEtTeVn3+NDgQ287PjXp5MYMCi8ikdcYCHYbqD4V99Ki8Vo37IYqHjEcaq
         HBnJRANlrqVdKOzPdPcFqM74GYIOCzXIbYr1egbshlLtJtfdfM+juovlm/LVqm3z+yEG
         rtJ0awWnijUPKEMMkVA2sKiWJ06ru9xw6ECobAb4dGLaLS7AklPYawWg4pGjU5a97R3x
         FeOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980255; x=1765585055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wmQUDTBRI6uAYPiZERIyuwnHpmVucKzvhAShzUV1wg8=;
        b=KZJTF+a8LFI2HVrrUiprwFXCrrzgfxytqTlJpPJJZNDo5elBwmovUfp4uUEFK3/PNb
         an/q7uZ/oxatMnCXG5IqSTm7eIfGqBfF9fii8x290LCghJsYJwmc5PNWVuMWhbUqvvqV
         w1GjN+bNARtafpBFIaokisz2YGZmLkVqNNkzTPv7WOWV9oIikb0meZTKMwklasrw5+Yb
         UrQMmbBTontywog8zfiCtujX1oVbBkXm5IrKdrv3YKblSh9M7ZIQxXN+GXNw7oA51d9F
         iJjsRSldZN53cQ8uNjEsmFnsw8WQrwPk4yZAvJjN9jEc8rXkGI+o237WtekNQ2J094nG
         mgYQ==
X-Forwarded-Encrypted: i=1; AJvYcCW6/rLTIzBlqorDD1MSjaboVi1G5N264AXxuF1Bs3OYg1TmFoZTjraa2SMnOAq1SbHjlGo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yygoo0TEWfxPUTp6udVC1WUuIBld2alPQKlwoqxqgYT+tbQjf1x
	MheLMve23RSkPv97oJzRhtvXlDMB2Xoz3KJOePwUpBOR1aSlgYZhoCoQmuYfK6VV16sZK1OFyN+
	gfoQShA==
X-Google-Smtp-Source: AGHT+IEZRxY3LZNDar88VXHAyUm8Uc785TqYbcnbZTCQlLOLUTZJss/bvouzXSbB0o11yHRRJXuvDvjgcck=
X-Received: from pjbhl15.prod.google.com ([2002:a17:90b:134f:b0:340:9a37:91a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:520f:b0:340:2a18:1536
 with SMTP id 98e67ed59e1d1-349a25e044emr617645a91.25.1764980254710; Fri, 05
 Dec 2025 16:17:34 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:40 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-5-seanjc@google.com>
Subject: [PATCH v6 04/44] perf: Add APIs to create/release mediated guest vPMUs
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Kan Liang <kan.liang@linux.intel.com>

Currently, exposing PMU capabilities to a KVM guest is done by emulating
guest PMCs via host perf events, i.e. by having KVM be "just" another user
of perf.  As a result, the guest and host are effectively competing for
resources, and emulating guest accesses to vPMU resources requires
expensive actions (expensive relative to the native instruction).  The
overhead and resource competition results in degraded guest performance
and ultimately very poor vPMU accuracy.

To address the issues with the perf-emulated vPMU, introduce a "mediated
vPMU", where the data plane (PMCs and enable/disable knobs) is exposed
directly to the guest, but the control plane (event selectors and access
to fixed counters) is managed by KVM (via MSR interceptions).  To allow
host perf usage of the PMU to (partially) co-exist with KVM/guest usage
of the PMU, KVM and perf will coordinate to a world switch between host
perf context and guest vPMU context near VM-Enter/VM-Exit.

Add two exported APIs, perf_{create,release}_mediated_pmu(), to allow KVM
to create and release a mediated PMU instance (per VM).  Because host perf
context will be deactivated while the guest is running, mediated PMU usage
will be mutually exclusive with perf analysis of the guest, i.e. perf
events that do NOT exclude the guest will not behave as expected.

To avoid silent failure of !exclude_guest perf events, disallow creating a
mediated PMU if there are active !exclude_guest events, and on the perf
side, disallowing creating new !exclude_guest perf events while there is
at least one active mediated PMU.

Exempt PMU resources that do not support mediated PMU usage, i.e. that are
outside the scope/view of KVM's vPMU and will not be swapped out while the
guest is running.

Guard mediated PMU with a new kconfig to help readers identify code paths
that are unique to mediated PMU support, and to allow for adding arch-
specific hooks without stubs.  KVM x86 is expected to be the only KVM
architecture to support a mediated PMU in the near future (e.g. arm64 is
trending toward a partitioned PMU implementation), and KVM x86 will select
PERF_GUEST_MEDIATED_PMU unconditionally, i.e. won't need stubs.

Immediately select PERF_GUEST_MEDIATED_PMU when KVM x86 is enabled so that
all paths are compile tested.  Full KVM support is on its way...

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: add kconfig and WARNing, rewrite changelog, swizzle patch ordering]
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig       |  1 +
 include/linux/perf_event.h |  6 +++
 init/Kconfig               |  4 ++
 kernel/events/core.c       | 82 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 278f08194ec8..d916bd766c94 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -37,6 +37,7 @@ config KVM_X86
 	select SCHED_INFO
 	select PERF_EVENTS
 	select GUEST_PERF_EVENTS
+	select PERF_GUEST_MEDIATED_PMU
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select HAVE_KVM_NO_POLL
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fd1d91017b99..94f679634ef6 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -305,6 +305,7 @@ struct perf_event_pmu_context;
 #define PERF_PMU_CAP_EXTENDED_HW_TYPE	0x0100
 #define PERF_PMU_CAP_AUX_PAUSE		0x0200
 #define PERF_PMU_CAP_AUX_PREFER_LARGE	0x0400
+#define PERF_PMU_CAP_MEDIATED_VPMU	0x0800
 
 /**
  * pmu::scope
@@ -1914,6 +1915,11 @@ extern int perf_event_account_interrupt(struct perf_event *event);
 extern int perf_event_period(struct perf_event *event, u64 value);
 extern u64 perf_event_pause(struct perf_event *event, bool reset);
 
+#ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
+int perf_create_mediated_pmu(void);
+void perf_release_mediated_pmu(void);
+#endif
+
 #else /* !CONFIG_PERF_EVENTS: */
 
 static inline void *
diff --git a/init/Kconfig b/init/Kconfig
index cab3ad28ca49..45b9ac626829 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2010,6 +2010,10 @@ config GUEST_PERF_EVENTS
 	bool
 	depends on HAVE_PERF_EVENTS
 
+config PERF_GUEST_MEDIATED_PMU
+	bool
+	depends on GUEST_PERF_EVENTS
+
 config PERF_USE_VMALLOC
 	bool
 	help
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e34112df8b31..cfeea7d330f9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5657,6 +5657,8 @@ static void __free_event(struct perf_event *event)
 	call_rcu(&event->rcu_head, free_event_rcu);
 }
 
+static void mediated_pmu_unaccount_event(struct perf_event *event);
+
 DEFINE_FREE(__free_event, struct perf_event *, if (_T) __free_event(_T))
 
 /* vs perf_event_alloc() success */
@@ -5666,6 +5668,7 @@ static void _free_event(struct perf_event *event)
 	irq_work_sync(&event->pending_disable_irq);
 
 	unaccount_event(event);
+	mediated_pmu_unaccount_event(event);
 
 	if (event->rb) {
 		/*
@@ -6188,6 +6191,81 @@ u64 perf_event_pause(struct perf_event *event, bool reset)
 }
 EXPORT_SYMBOL_GPL(perf_event_pause);
 
+#ifdef CONFIG_PERF_GUEST_MEDIATED_PMU
+static atomic_t nr_include_guest_events __read_mostly;
+
+static atomic_t nr_mediated_pmu_vms __read_mostly;
+static DEFINE_MUTEX(perf_mediated_pmu_mutex);
+
+/* !exclude_guest event of PMU with PERF_PMU_CAP_MEDIATED_VPMU */
+static inline bool is_include_guest_event(struct perf_event *event)
+{
+	if ((event->pmu->capabilities & PERF_PMU_CAP_MEDIATED_VPMU) &&
+	    !event->attr.exclude_guest)
+		return true;
+
+	return false;
+}
+
+static int mediated_pmu_account_event(struct perf_event *event)
+{
+	if (!is_include_guest_event(event))
+		return 0;
+
+	guard(mutex)(&perf_mediated_pmu_mutex);
+
+	if (atomic_read(&nr_mediated_pmu_vms))
+		return -EOPNOTSUPP;
+
+	atomic_inc(&nr_include_guest_events);
+	return 0;
+}
+
+static void mediated_pmu_unaccount_event(struct perf_event *event)
+{
+	if (!is_include_guest_event(event))
+		return;
+
+	atomic_dec(&nr_include_guest_events);
+}
+
+/*
+ * Currently invoked at VM creation to
+ * - Check whether there are existing !exclude_guest events of PMU with
+ *   PERF_PMU_CAP_MEDIATED_VPMU
+ * - Set nr_mediated_pmu_vms to prevent !exclude_guest event creation on
+ *   PMUs with PERF_PMU_CAP_MEDIATED_VPMU
+ *
+ * No impact for the PMU without PERF_PMU_CAP_MEDIATED_VPMU. The perf
+ * still owns all the PMU resources.
+ */
+int perf_create_mediated_pmu(void)
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
+EXPORT_SYMBOL_GPL(perf_create_mediated_pmu);
+
+void perf_release_mediated_pmu(void)
+{
+	if (WARN_ON_ONCE(!atomic_read(&nr_mediated_pmu_vms)))
+		return;
+
+	atomic_dec(&nr_mediated_pmu_vms);
+}
+EXPORT_SYMBOL_GPL(perf_release_mediated_pmu);
+#else
+static int mediated_pmu_account_event(struct perf_event *event) { return 0; }
+static void mediated_pmu_unaccount_event(struct perf_event *event) {}
+#endif
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
@@ -13078,6 +13156,10 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 	if (err)
 		return ERR_PTR(err);
 
+	err = mediated_pmu_account_event(event);
+	if (err)
+		return ERR_PTR(err);
+
 	/* symmetric to unaccount_event() in _free_event() */
 	account_event(event);
 
-- 
2.52.0.223.gf5cc29aaa4-goog


