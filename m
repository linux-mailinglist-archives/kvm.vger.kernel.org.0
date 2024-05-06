Return-Path: <kvm+bounces-16625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6659C8BC6D7
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9364B1C210E1
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DACE61411ED;
	Mon,  6 May 2024 05:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n5iWb21h"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD651411D5
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973453; cv=none; b=Dhoy6kMJY+MkSnV0/YiB4SD+dBr0Sg86MOmd6/cJxyTFPQXbLjXqhph2U6q2ZmRRcKBzSJSYrDZOElgbtXHufMpN2NaUL4QmbKs14Y8MltocPWU0yFp5lC1tG624pxUHQRUXkH7zcBZSp4pRqjs2l7JNwGFHS9Rs2hTwViHWOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973453; c=relaxed/simple;
	bh=lMvvALjEQ5cdBw6uwXuouBz5p/7iVli76bSE1Bhj3sY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lD1Xcpd/JDxFrAl5yLmC9HFh7t6L/qao77jqBFCssURSsVRSFnfIBkBfePp1H75iy20Y1YsgWz/TDkbXZaWl38nYb/OdQigO/6ktej4UVU9xZBwkUDfQxFmxKIROyqN/H1Q8DEn5P18KE+oj+qPv3iMo2TcZvHwQDo/fyvpfrZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n5iWb21h; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6f452eb2066so518246b3a.0
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973451; x=1715578251; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4mK1POZoBW5cL5CzM+xtc0aCZ930EREANUx6x7aY3Ps=;
        b=n5iWb21hgNu0u+qdt9Wb9Cyq9zE+TAXqPj90y8zse09eWj0UOLgk+A4MDUAKy87spy
         i4k5n2xfnx7aKVpR5st2xhs6cbsW/7qxBwWi7jXSxT+eyXI/4YaKjdHwBCGBWu4u2PEU
         LgAtZ12HF+CFUkazprBtX8zW45qv86cnSopLctfyhYG3hfDowYR8ArFH+FzNNr/DOgSx
         /QsDNyfUzTytS0rma+/VbovriE5xz1E1nMy4a13Qkao+2G0Jebnvh2QeulNzmMFE8xS2
         HgDJLpZMj+DXynDFnm0wvy0QlEa1716wjUvV5B2oPb8O6LO1wOje3sBBi1z3LXxTZH1C
         Eudw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973451; x=1715578251;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4mK1POZoBW5cL5CzM+xtc0aCZ930EREANUx6x7aY3Ps=;
        b=IYtfauxSLUmfOh9fzjjijSc8xkzuOkmTIRMnAh33m1W5aB2v1Gfjt/fCpJgaPDHkfj
         Y6T2/y+Fg3hkFzl/qU4YUgSEj3h6LHyFs98XZBnrA8IAD/r3z3yhErbT8mq5y9dHe4Gq
         noIzZP7Yd3KqW0OuA8NfBOKM7muh7zBt4zUGDuR6cLe6ABGQyk7F+yULXfwn+tlmyhWq
         3y+nU2g4T9jPZeTj7k9Nkt3YtnJZOv76EGX7S5ulFhS/O2BFjqXw4XPIlVaZURPBtNU7
         dwMIHnELpG+5A9XG/OUokpO0UFLb0Yn19fsgKKvDWf8jSlKpP/RGwlOZSfhnpYN1mDJw
         1DOQ==
X-Forwarded-Encrypted: i=1; AJvYcCWawkpcImVgtcVrpqyGraPIM1Jh6yJ7yaQ/HRHyCmvc3jILd9xvtdoIKqyzN0gb1jsWx7Gbh4VT1WFr0osGPMgrnIfp
X-Gm-Message-State: AOJu0Yze2xBNartzXfpd9/3yBfOCgccv0922P1L4O68QMGsJqZiUKQ76
	V/tPLqZu2Iy8JihiL4rIkCYfqvCWRTFYuuuzk1CXwziNpEJ7Q2/843Qip3SN2hoU8lNeixzAfjI
	+9Y6DIg==
X-Google-Smtp-Source: AGHT+IEiekBYZm5VwfOaaayp1+mzErwV1Jme1w3J5ojOYUoJKlxroyRSkBXxKxbfPugQSHcRHFmHVAFd9p+G
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6a00:3901:b0:6f3:eeda:a844 with SMTP id
 fh1-20020a056a00390100b006f3eedaa844mr242648pfb.1.1714973451259; Sun, 05 May
 2024 22:30:51 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:38 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-14-mizhang@google.com>
Subject: [PATCH v2 13/54] perf: core/x86: Forbid PMI handler when guest own PMU
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

If a guest PMI is delivered after VM-exit, the KVM maskable interrupt will
be held pending until EFLAGS.IF is set. In the meantime, if the logical
processor receives an NMI for any reason at all, perf_event_nmi_handler()
will be invoked. If there is any active perf event anywhere on the system,
x86_pmu_handle_irq() will be invoked, and it will clear
IA32_PERF_GLOBAL_STATUS. By the time KVM's PMI handler is invoked, it will
be a mystery which counter(s) overflowed.

When LVTPC is using KVM PMI vecotr, PMU is owned by guest, Host NMI let
x86_pmu_handle_irq() run, x86_pmu_handle_irq() restore PMU vector to NMI
and clear IA32_PERF_GLOBAL_STATUS, this breaks guest vPMU passthrough
environment.

So modify perf_event_nmi_handler() to check perf_guest_context_loaded,
and if so, to simply return without calling x86_pmu_handle_irq().

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/events/core.c     | 19 ++++++++++++++++++-
 include/linux/perf_event.h |  5 +++++
 kernel/events/core.c       |  5 +++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 8167f2230d3a..c0f6e294fcad 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -726,7 +726,7 @@ EXPORT_SYMBOL_GPL(x86_perf_guest_exit);
  * It will not be re-enabled in the NMI handler again, because enabled=0. After
  * handling the NMI, disable_all will be called, which will not change the
  * state either. If PMI hits after disable_all, the PMU is already disabled
- * before entering NMI handler. The NMI handler will not change the state
+ * before entering NMI handler. The NMI handler will no	change the state
  * either.
  *
  * So either situation is harmless.
@@ -1749,6 +1749,23 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 	u64 finish_clock;
 	int ret;
 
+	/*
+	 * When guest pmu context is loaded this handler should be forbidden from
+	 * running, the reasons are:
+	 * 1. After x86_perf_guest_enter() is called, and before cpu enter into
+	 *    non-root mode, NMI could happen, but x86_pmu_handle_irq() restore PMU
+	 *    to use NMI vector, which destroy KVM PMI vector setting.
+	 * 2. When VM is running, host NMI other than PMI causes VM exit, KVM will
+	 *    call host NMI handler (vmx_vcpu_enter_exit()) first before KVM save
+	 *    guest PMU context (kvm_pmu_save_pmu_context()), as x86_pmu_handle_irq()
+	 *    clear global_status MSR which has guest status now, then this destroy
+	 *    guest PMU status.
+	 * 3. After VM exit, but before KVM save guest PMU context, host NMI other
+	 *    than PMI could happen, x86_pmu_handle_irq() clear global_status MSR
+	 *    which has guest status now, then this destroy guest PMU status.
+	 */
+	if (perf_is_guest_context_loaded())
+		return 0;
 	/*
 	 * All PMUs/events that share this PMI handler should make sure to
 	 * increment active_events for their events.
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index acf16676401a..5da7de42954e 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1736,6 +1736,7 @@ extern int perf_get_mediated_pmu(void);
 extern void perf_put_mediated_pmu(void);
 void perf_guest_enter(void);
 void perf_guest_exit(void);
+bool perf_is_guest_context_loaded(void);
 #else /* !CONFIG_PERF_EVENTS: */
 static inline void *
 perf_aux_output_begin(struct perf_output_handle *handle,
@@ -1830,6 +1831,10 @@ static inline int perf_get_mediated_pmu(void)
 static inline void perf_put_mediated_pmu(void)			{ }
 static inline void perf_guest_enter(void)			{ }
 static inline void perf_guest_exit(void)			{ }
+static inline bool perf_is_guest_context_loaded(void)
+{
+	return false;
+}
 #endif
 
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4c6daf5cc923..184d06c23391 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5895,6 +5895,11 @@ void perf_guest_exit(void)
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
+bool perf_is_guest_context_loaded(void)
+{
+	return __this_cpu_read(perf_in_guest);
+}
+
 /*
  * Holding the top-level event's child_mutex means that any
  * descendant process that has inherited this event will block
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


