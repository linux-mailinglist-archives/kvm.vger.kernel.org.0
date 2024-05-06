Return-Path: <kvm+bounces-16660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B6658BC6FC
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:37:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF4951F235CB
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D5E1448DD;
	Mon,  6 May 2024 05:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wu2bu1kg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBD21448D2
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973521; cv=none; b=pjQvcqPwA8um7ZTTI+uGgTIFf16pGBOp1xcnkZI282sJcGHLT//3QzSgpeeeyP8Nn05Cs9F8DKcUlWjkymywiI4tgOLJzen6BwwSCZGhEmY4/9/q6TcKl3W9zinr6+ByGnWU27hqr8KxavMRb0YoVMlAaemfB7PzRAJdiJZDaZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973521; c=relaxed/simple;
	bh=PUWdFm9NkUxPRSLxWUtMIgLlhIdfLkOQDnSCTHerqRI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TKZNK8PBz6iC7NopqbtQrd3P5MEyogToDirNAos7adgComTWNQJ3+J5sc4dNUbD6RYF7Ob40rRjWh270mYBpHKJOSAUmQAKs2d6A7oxOewLk0yoclxzqcvX0QNQp6ksfVw9Ph7NLNpDz2OsuHaOI9ej8397zh40Zp7b6kKOiAKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Wu2bu1kg; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61c9e36888bso30639527b3.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973517; x=1715578317; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=2beKaClMZ6uoVFCYUavhgl0DmCZK5D16MDURExXJUS4=;
        b=Wu2bu1kgveVB3o1BKGZi0uhWjyR/E+3UfdpQkHk8CHgcXKr1u6WNNL+ftgNjm9sFlY
         yukIDkcy9rETWgCP2g3FWm50vtiVk09SM80WHP3fzNcdvvJ/zuwrLKU5cdPo9KuNy89B
         dWtbYpwhC81O2616/qPzzCbyRoNtHC1iv/K8wcWOjEJyiJPNU/u44nngT9/rwkhPnkcL
         +fQLkmaQgY7B6Zu/mbtFTv7610ZSmceThWsMmkPw10QJuuCpvbuQlRomZR6km0yygNkM
         LG/h1vLsXnwLMOmzSMdUAuOfHLO72mY9lCQvMDhovDGDyrUXN6/hu2jnwKp09SsylwiD
         A52Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973517; x=1715578317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2beKaClMZ6uoVFCYUavhgl0DmCZK5D16MDURExXJUS4=;
        b=Mn19psFx7OWY3KBzW3AcgNC/TeJFQoj0XyByU0WtZOJ/dl7zSvnKOjUcF0q8EYBQNG
         snkt/Zo9Uavi+2c2sEShy6lYhxRWdap+9FuRXxg7g4GCq1AfNja7jaeyDLfMYBzjFof2
         XbwIDuyJE3BNzjzrrLIseCM7Gwyh6idM0zswQVuZlIMfqeKWANX3PEneaksAx2Mh6FH/
         2dz+ITdkKC4P+bzzOFSSqE6JUlhs8E04Rtqt3iKpgMtqmBfZuJgo2AlhEUVvaJ9G5IcX
         3Pc8BSi2MDbZo7f/zu3nUaL3JvqnIwNHmYVvKm6P7eARGUmqjVFhdm2QbWWI9VBmqGjl
         yEGA==
X-Forwarded-Encrypted: i=1; AJvYcCUBw8mpNKy+VkeVt7u1qlNCjxpvlHUDfDcf3sl/tjY896EEALwMZ7iSFC3CTt8bfcj/nwiZ1y44VacBIObNhtIDJzpt
X-Gm-Message-State: AOJu0YzhD5srdk1WfA//2nfIrrjORCm1YEdPF0NAoF8Qu8CcEBuZrMSa
	3wMr1cjb84/0cv3+73+sKTl31dVK+tqiaqoLA6IjF9Rroo0F1uPcfGAwEIYxZdmscf1p0qhdYTG
	q54Gdew==
X-Google-Smtp-Source: AGHT+IG7nnFU+Iqsv5LSBlLKbPf95eWbySpGorv0PgavHad/I1gnkSdJIZpHYqklITnQ72haOlDjyyo4+koN
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a81:8394:0:b0:61a:b2d4:a3fb with SMTP id
 t142-20020a818394000000b0061ab2d4a3fbmr2144006ywf.8.1714973517609; Sun, 05
 May 2024 22:31:57 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:13 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-49-mizhang@google.com>
Subject: [PATCH v2 48/54] KVM: x86/pmu/svm: Set enable_passthrough_pmu module parameter
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

From: Sandipan Das <sandipan.das@amd.com>

Since passthrough PMU can be also used on some AMD platforms, set the
"enable_passthrough_pmu" KVM kernel module parameter to true when the
following conditions are met.
 - parameter is set to true when module loaded
 - enable_pmu is true
 - is running on and AMD CPU
 - CPU supports PerfMonV2
 - host PMU supports passthrough mode

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
---
 arch/x86/kvm/pmu.h     | 20 ++++++++++++--------
 arch/x86/kvm/svm/svm.c |  2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 10553bc1ae1d..02ea90431033 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -196,6 +196,7 @@ extern struct kvm_pmu_emulated_event_selectors kvm_pmu_eventsel;
 static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
+	bool is_amd = boot_cpu_data.x86_vendor == X86_VENDOR_AMD;
 	int min_nr_gp_ctrs = pmu_ops->MIN_NR_GP_COUNTERS;
 
 	/*
@@ -223,18 +224,21 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 			enable_pmu = false;
 	}
 
-	/* Pass-through vPMU is only supported in Intel CPUs. */
-	if (!is_intel)
+	/* Pass-through vPMU is only supported in Intel and AMD CPUs. */
+	if (!is_intel && !is_amd)
 		enable_passthrough_pmu = false;
 
 	/*
-	 * Pass-through vPMU requires at least PerfMon version 4 because the
-	 * implementation requires the usage of MSR_CORE_PERF_GLOBAL_STATUS_SET
-	 * for counter emulation as well as PMU context switch.  In addition, it
-	 * requires host PMU support on passthrough mode. Disable pass-through
-	 * vPMU if any condition fails.
+	 * On Intel platforms, pass-through vPMU requires at least PerfMon
+	 * version 4 because the implementation requires the usage of
+	 * MSR_CORE_PERF_GLOBAL_STATUS_SET for counter emulation as well as
+	 * PMU context switch.  In addition, it requires host PMU support on
+	 * passthrough mode. Disable pass-through vPMU if any condition fails.
+	 *
+	 * On AMD platforms, pass-through vPMU requires at least PerfMonV2
+	 * because MSR_PERF_CNTR_GLOBAL_STATUS_SET is required.
 	 */
-	if (!enable_pmu || kvm_pmu_cap.version < 4 || !kvm_pmu_cap.passthrough)
+	if (!enable_pmu || !kvm_pmu_cap.passthrough || (is_intel && kvm_pmu_cap.version < 4) || (is_amd && kvm_pmu_cap.version < 2))
 		enable_passthrough_pmu = false;
 
 	if (!enable_pmu) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d1a9f9951635..88648b3a9cdd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -238,6 +238,8 @@ module_param(intercept_smi, bool, 0444);
 bool vnmi = true;
 module_param(vnmi, bool, 0444);
 
+module_param(enable_passthrough_pmu, bool, 0444);
+
 static bool svm_gp_erratum_intercept = true;
 
 static u8 rsm_ins_bytes[] = "\x0f\xaa";
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


