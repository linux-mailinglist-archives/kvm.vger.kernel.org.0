Return-Path: <kvm+bounces-32287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9798D9D52E5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 19:56:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 590362822D5
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2024 18:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D35B41D79BE;
	Thu, 21 Nov 2024 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="epBHLhlg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417A31D79A6
	for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732215201; cv=none; b=N6hm5Pc1A54/ogKreDkoFu/9YOx2nlQ7i3Scq0cJ0/E5lJy8lcxfWuNn6DsL2fdeW8fCQXBg9D/BgH84kxbV7zI9B7NA0Wbl3ymKFFyPU7acQkAbq+eennWa/x5ZVJXFj7cwMIuAILSCoMP9Huf3ovZQmW9gMEpCqGx11savwpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732215201; c=relaxed/simple;
	bh=eGhYnE5emXo94Pyg5quiuPFdiSkETv0T4xLbIt+gbbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tmiwxqi00o7uU8sf8hH2WY+Qr/wHWbqKej68ARHc/7+7IAEeeCODXRX9f6ok0tjslicFCxYpLy1TdC//n2bmQJ3ZqqmA67MtJPaSpmtuN+xz1eEMyO8Fg44rIA866pTfkn7RBseqCazW7uJicuCgX9Wt9+EhmHcF1ZVeImasNNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=epBHLhlg; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6eeb2b305efso30331267b3.0
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2024 10:53:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732215199; x=1732819999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T+9Madf5AUgYPaX6aUUL9JHycbWIRkK+aZqhIzgnbrs=;
        b=epBHLhlgmfnklftRQidJ2GmzQ+NWXPZW4UK+9IvFWJMBEz545B6BzS5+fs/HgOlrnx
         doncHJ6bH3mEZomG9hhOSpCDC+ZE+C3Mc/+aN+F+YxDoy56mOWkBuePVzTJzJM5Ze4H5
         +6Qlc8xxQq9s4SlVnaaZZvNG1g3T5ZP7k8taUUxiWkBMEC/JdmAeMU6qyir8OpILwAQ9
         TsYABene16OKHGimxZX0pZsTEPOdJScw+vldYYnQJ08ZAp3Lf0TvloFI6D7bEPIQLpbH
         EvppUyxtL6gq8rgZWbESl63tfumL8ia9OBvjtEVJCcM37Pqnj8w0BbokVSYVXEdXneHP
         2y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732215199; x=1732819999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T+9Madf5AUgYPaX6aUUL9JHycbWIRkK+aZqhIzgnbrs=;
        b=IYQB4rQ36/Zgv6s6yLvowBT9+d/4PATnw6od7LHLitSTF/lSxlGn+1X4W1ak0JxvMz
         UtTwcMa9WdDMl2qYEirMjZAYhjFlc9IvuQ08fD0S3eiGutHZWS+CyJoDPfvHDx0/Lmsj
         gg72BdsPZKgQCvPiXTCDuvwBEUiFyIuCwQuGycFW5Z529sAEWaNqj4SwV4m6t/QPsKdg
         6D3CgUMsLEXLvLcR75oTGludNeWnXykxr/VJx0YxCT3F46rUhQRIwAWdJHeY48e89m4E
         v6uf+eC50Hfn6ZXZD8A817c7OAmrNg1zrGmcrL/6NegnaS/8sCMt3oT/TV4e/CqK1vgT
         n92Q==
X-Forwarded-Encrypted: i=1; AJvYcCWUVWd1qExFsk0C8nns584t4UTPPDLhwgchAfipoF64qYaPQa+q7fCu2Ugmbw1EuHaMG+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwB4VEzEPUg4G2TCQqudkS3gwjGz5CZAlRMF08OppqR1X0QXe5x
	bor67uXyYHhAeZd9ed7noFq49KtuS4KiyNyyrIndCss143VsR//zDhOrpUrXgM4xKGlsOWwW0M3
	5x181oA==
X-Google-Smtp-Source: AGHT+IFW1c+yo5NB9i6gITZMQ/WYNQr1/fXSlza8bauLrwlg/McJYGaXVTMf7a6D63EaXjw6XMTTYqlKnd3N
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a25:ab92:0:b0:e30:d5cf:775a with SMTP id
 3f1490d57ef6-e38f74af44emr892276.6.1732215199276; Thu, 21 Nov 2024 10:53:19
 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu, 21 Nov 2024 18:52:53 +0000
In-Reply-To: <20241121185315.3416855-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121185315.3416855-1-mizhang@google.com>
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121185315.3416855-2-mizhang@google.com>
Subject: [RFC PATCH 01/22] x86/aperfmperf: Introduce get_host_[am]perf()
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Huang Rui <ray.huang@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>, 
	Mario Limonciello <mario.limonciello@amd.com>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>, Len Brown <lenb@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Perry Yuan <perry.yuan@amd.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	Jim Mattson <jmattson@google.com>, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jim Mattson <jmattson@google.com>

In preparation for KVM pass-through of IA32_APERF and IA32_MPERF,
introduce wrappers that read these MSRs. Going forward, all kernel
code that needs host APERF/MPERF values should use these wrappers
instead of rdmsrl().

While these functions currently just read the MSRs directly, future
patches will enhance them to handle cases where the MSRs contain guest
values. Moving all host APERF/MPERF reads to use these functions now
will make it easier to add this functionality later.

No functional change intended.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/topology.h  |  3 +++
 arch/x86/kernel/cpu/aperfmperf.c | 22 ++++++++++++++++++----
 drivers/cpufreq/amd-pstate.c     |  4 ++--
 drivers/cpufreq/intel_pstate.c   |  5 +++--
 4 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 92f3664dd933b..2ef9903cf85d7 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -302,6 +302,9 @@ static inline void arch_set_max_freq_ratio(bool turbo_disabled) { }
 static inline void freq_invariance_set_perf_ratio(u64 ratio, bool turbo_disabled) { }
 #endif
 
+extern u64 get_host_aperf(void);
+extern u64 get_host_mperf(void);
+
 extern void arch_scale_freq_tick(void);
 #define arch_scale_freq_tick arch_scale_freq_tick
 
diff --git a/arch/x86/kernel/cpu/aperfmperf.c b/arch/x86/kernel/cpu/aperfmperf.c
index f642de2ebdac8..3be5070ba3361 100644
--- a/arch/x86/kernel/cpu/aperfmperf.c
+++ b/arch/x86/kernel/cpu/aperfmperf.c
@@ -40,8 +40,8 @@ static void init_counter_refs(void)
 {
 	u64 aperf, mperf;
 
-	rdmsrl(MSR_IA32_APERF, aperf);
-	rdmsrl(MSR_IA32_MPERF, mperf);
+	aperf = get_host_aperf();
+	mperf = get_host_mperf();
 
 	this_cpu_write(cpu_samples.aperf, aperf);
 	this_cpu_write(cpu_samples.mperf, mperf);
@@ -94,6 +94,20 @@ void arch_set_max_freq_ratio(bool turbo_disabled)
 }
 EXPORT_SYMBOL_GPL(arch_set_max_freq_ratio);
 
+u64 get_host_aperf(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+	return native_read_msr(MSR_IA32_APERF);
+}
+EXPORT_SYMBOL_GPL(get_host_aperf);
+
+u64 get_host_mperf(void)
+{
+	WARN_ON_ONCE(!irqs_disabled());
+	return native_read_msr(MSR_IA32_MPERF);
+}
+EXPORT_SYMBOL_GPL(get_host_mperf);
+
 static bool __init turbo_disabled(void)
 {
 	u64 misc_en;
@@ -474,8 +488,8 @@ void arch_scale_freq_tick(void)
 	if (!cpu_feature_enabled(X86_FEATURE_APERFMPERF))
 		return;
 
-	rdmsrl(MSR_IA32_APERF, aperf);
-	rdmsrl(MSR_IA32_MPERF, mperf);
+	aperf = get_host_aperf();
+	mperf = get_host_mperf();
 	acnt = aperf - s->aperf;
 	mcnt = mperf - s->mperf;
 
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index b63863f77c677..c26092284be56 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -446,8 +446,8 @@ static inline bool amd_pstate_sample(struct amd_cpudata *cpudata)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	rdmsrl(MSR_IA32_APERF, aperf);
-	rdmsrl(MSR_IA32_MPERF, mperf);
+	aperf = get_host_aperf();
+	mperf = get_host_mperf();
 	tsc = rdtsc();
 
 	if (cpudata->prev.mperf == mperf || cpudata->prev.tsc == tsc) {
diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 400337f3b572d..993a66095547f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/pm_qos.h>
 #include <linux/bitfield.h>
+#include <linux/topology.h>
 #include <trace/events/power.h>
 
 #include <asm/cpu.h>
@@ -2423,8 +2424,8 @@ static inline bool intel_pstate_sample(struct cpudata *cpu, u64 time)
 	u64 tsc;
 
 	local_irq_save(flags);
-	rdmsrl(MSR_IA32_APERF, aperf);
-	rdmsrl(MSR_IA32_MPERF, mperf);
+	aperf = get_host_aperf();
+	mperf = get_host_mperf();
 	tsc = rdtsc();
 	if (cpu->prev_mperf == mperf || cpu->prev_tsc == tsc) {
 		local_irq_restore(flags);
-- 
2.47.0.371.ga323438b13-goog


