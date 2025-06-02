Return-Path: <kvm+bounces-48235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A90FACBDCC
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 01:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E48E93A2D19
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 23:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A590C1FF1A6;
	Mon,  2 Jun 2025 23:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gu4VPl1F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4334F13C8EA
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 23:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748908286; cv=none; b=UgdyZ+nS27WMw3PChJk4PUglzMIy02vIWlhsODt+hxcnGGwF5wSCMNXXw2ugm0fNzf2vl9lddG9Xk1Kbu+W264G/5yoXRDL7Pc6SdtsQ2CYe3tdF1CWDTtaJYOFp1DfboqQ/ZNRAV8o5kjFfh6AuwYnNZqxEc4CQ4rVwzfyfV9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748908286; c=relaxed/simple;
	bh=Gp8rOEMBvQyfyOkGkFjC5cb4A1mmOp6V4W/IbKcxMGw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Q9arrncVOD939V9RWPLkW763dKkmToxZWcf6I9uECMEfK4H7/xv5ZeyGlO4n1gtQ0de1xKhYia6urQBYIzvPE9Cw/7cCRJTp6JJUDaaF6VIKWHfnH+pnh/SPT65Q24y+SELU769SfmbcVgcj8iIX4pwXQxeiphtCeGjxjv3ezac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gu4VPl1F; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-310efe825ccso4891520a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 16:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748908284; x=1749513084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dk4+owqQNHxfLdSzehkTZZ2/llGFNFZWt1ateStP9t8=;
        b=Gu4VPl1FxDZ/ntQUE0/rDNqyIAj4nvkqZCV6HX04XR6VWrww5RrnGb+a44sgh8s/KF
         md49APeU6XpkbzgNLYQsy8Ir19N3vE4T6O5CcJNZDQ8l3AoAv2SCHo0lZ1QkMnS3CAeA
         mKfo2AYzw4bD3wE1pWFiZgSpAe23savIoscXTNED8cR44GZmqhBOESOSIDWaSi3cfx9M
         9DjI14NfxUeBaDy9z3uVIaMHW04W/vSsbJsrKdPaFeG16wGhVwChbmoF8SK53xhTY9yN
         xjz9T7MFnZfrSS2v0LwLz8O3HlONk9uw5bI9COZh1HsXx5krZY+rTuhJ5HNlkOdtM/1T
         7LBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748908284; x=1749513084;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dk4+owqQNHxfLdSzehkTZZ2/llGFNFZWt1ateStP9t8=;
        b=IPtBXgIaHMBWZXeVI83mlN4lKWELYKIfkqgnNVXCS6i6yjABHxzFcSj11b9k8CMcL6
         Wom1Y0Kqc3fEmgAU8a3bL/gxRogYky67xWdaNjAb3veRTOLzloGEibyhBIUSP4mdsJr0
         S2iRRRwfxs9E8RfnywRspjPHlTP9MH9LCI62AqiyTXKyW2aRmG008EcAAf9PDCtVEa4C
         NTkpkm6xuCmENsg5LO7h63bkC8976x6oWOPCM22zwTz3TgItyKEraopiSHA79v927R7F
         WGjoqKlW117U4iuIzVE5ryJnsDfJpvf14DjX4QiD6UccRPciFkXxAdp5Vcw2KZXovmup
         PhXw==
X-Forwarded-Encrypted: i=1; AJvYcCWMDOPbe34oJ6lTug6rqWuqAQCW6S4R09BqddYCpmgpgk9k/leQzyS7giz02LVg+TMU9F8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw50ZoYr4MJr+10QdTf1elyfnaz8z2tzDL0W8wuL4oj9GPorCg8
	6vrlaqI707Cgz6J1ybD68PtKW3PKUtpblSpVwyA2K2fBH4YSl0nNaJITD+JNiYuZ0NDl4/8FGb+
	k8EDDdA==
X-Google-Smtp-Source: AGHT+IHU/6drj+dM1whBytUXQqdCww913o5IkJnaZED8ISZFjpU9lFbKAws8DQaneO3FH5a0aB4NgkaLd68=
X-Received: from pjbcz16.prod.google.com ([2002:a17:90a:d450:b0:311:c20d:676d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4cce:b0:311:b0ec:135f
 with SMTP id 98e67ed59e1d1-31250474eb6mr21467217a91.30.1748908284437; Mon, 02
 Jun 2025 16:51:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon,  2 Jun 2025 16:51:21 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602235121.55424-1-seanjc@google.com>
Subject: [PATCH] perf/x86: KVM: Have perf define a dedicated struct for
 getting guest PEBS data
From: Sean Christopherson <seanjc@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Have perf define a struct for getting guest PEBS data from KVM instead of
poking into the kvm_pmu structure.  Passing in an entire "struct kvm_pmu"
_as an opaque pointer_ to get at four fields is silly, especially since
one of the fields exists purely to convey information to perf, i.e. isn't
used by KVM.

Perf should also own its APIs, i.e. define what fields/data it needs, not
rely on KVM to throw fields into data structures that effectively hold
KVM-internal state.

Opportunistically rephrase the comment about cross-mapped counters to
explain *why* PEBS needs to be disabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/core.c            |  5 +++--
 arch/x86/events/intel/core.c      | 20 ++++++++++----------
 arch/x86/events/perf_event.h      |  3 ++-
 arch/x86/include/asm/kvm_host.h   |  9 ---------
 arch/x86/include/asm/perf_event.h | 13 +++++++++++--
 arch/x86/kvm/vmx/pmu_intel.c      | 18 +++++++++++++++---
 arch/x86/kvm/vmx/vmx.c            | 11 +++++++----
 arch/x86/kvm/vmx/vmx.h            |  2 +-
 8 files changed, 49 insertions(+), 32 deletions(-)

diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index 139ad80d1df3..6080c3e6e191 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -703,9 +703,10 @@ void x86_pmu_disable_all(void)
 	}
 }
 
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data)
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr,
+						  struct x86_guest_pebs *guest_pebs)
 {
-	return static_call(x86_pmu_guest_get_msrs)(nr, data);
+	return static_call(x86_pmu_guest_get_msrs)(nr, guest_pebs);
 }
 EXPORT_SYMBOL_GPL(perf_guest_get_msrs);
 
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index c5f385413392..364bba216cf4 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/nmi.h>
-#include <linux/kvm_host.h>
 
 #include <asm/cpufeature.h>
 #include <asm/debugreg.h>
@@ -4332,11 +4331,11 @@ static int intel_pmu_hw_config(struct perf_event *event)
  * when it uses {RD,WR}MSR, which should be handled by the KVM context,
  * specifically in the intel_pmu_{get,set}_msr().
  */
-static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
+static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr,
+							  struct x86_guest_pebs *guest_pebs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
-	struct kvm_pmu *kvm_pmu = (struct kvm_pmu *)data;
 	u64 intel_ctrl = hybrid(cpuc->pmu, intel_ctrl);
 	u64 pebs_mask = cpuc->pebs_enabled & x86_pmu.pebs_capable;
 	int global_ctrl, pebs_enable;
@@ -4374,20 +4373,20 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		return arr;
 	}
 
-	if (!kvm_pmu || !x86_pmu.pebs_ept)
+	if (!guest_pebs || !x86_pmu.pebs_ept)
 		return arr;
 
 	arr[(*nr)++] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_DS_AREA,
 		.host = (unsigned long)cpuc->ds,
-		.guest = kvm_pmu->ds_area,
+		.guest = guest_pebs->ds_area,
 	};
 
 	if (x86_pmu.intel_cap.pebs_baseline) {
 		arr[(*nr)++] = (struct perf_guest_switch_msr){
 			.msr = MSR_PEBS_DATA_CFG,
 			.host = cpuc->active_pebs_data_cfg,
-			.guest = kvm_pmu->pebs_data_cfg,
+			.guest = guest_pebs->data_cfg,
 		};
 	}
 
@@ -4395,7 +4394,7 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	arr[pebs_enable] = (struct perf_guest_switch_msr){
 		.msr = MSR_IA32_PEBS_ENABLE,
 		.host = cpuc->pebs_enabled & ~cpuc->intel_ctrl_guest_mask,
-		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask & kvm_pmu->pebs_enable,
+		.guest = pebs_mask & ~cpuc->intel_ctrl_host_mask & guest_pebs->enable,
 	};
 
 	if (arr[pebs_enable].host) {
@@ -4403,8 +4402,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 		arr[pebs_enable].guest = 0;
 	} else {
 		/* Disable guest PEBS thoroughly for cross-mapped PEBS counters. */
-		arr[pebs_enable].guest &= ~kvm_pmu->host_cross_mapped_mask;
-		arr[global_ctrl].guest &= ~kvm_pmu->host_cross_mapped_mask;
+		arr[pebs_enable].guest &= ~guest_pebs->cross_mapped_mask;
+		arr[global_ctrl].guest &= ~guest_pebs->cross_mapped_mask;
 		/* Set hw GLOBAL_CTRL bits for PEBS counter when it runs for guest */
 		arr[global_ctrl].guest |= arr[pebs_enable].guest;
 	}
@@ -4412,7 +4411,8 @@ static struct perf_guest_switch_msr *intel_guest_get_msrs(int *nr, void *data)
 	return arr;
 }
 
-static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr, void *data)
+static struct perf_guest_switch_msr *core_guest_get_msrs(int *nr,
+							 struct x86_guest_pebs *guest_pebs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
 	struct perf_guest_switch_msr *arr = cpuc->guest_switch_msrs;
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 46d120597bab..29ae9e442f2e 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -963,7 +963,8 @@ struct x86_pmu {
 	/*
 	 * Intel host/guest support (KVM)
 	 */
-	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr, void *data);
+	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr,
+							struct x86_guest_pebs *guest_pebs);
 
 	/*
 	 * Check period value for PERF_EVENT_IOC_PERIOD ioctl.
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7bc174a1f1cb..2fe0d2520f14 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -583,15 +583,6 @@ struct kvm_pmu {
 	u64 pebs_data_cfg;
 	u64 pebs_data_cfg_rsvd;
 
-	/*
-	 * If a guest counter is cross-mapped to host counter with different
-	 * index, its PEBS capability will be temporarily disabled.
-	 *
-	 * The user should make sure that this mask is updated
-	 * after disabling interrupts and before perf_guest_get_msrs();
-	 */
-	u64 host_cross_mapped_mask;
-
 	/*
 	 * The gate to release perf_events not marked in
 	 * pmc_in_use only once in a vcpu time slice.
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 812dac3f79f0..0edfc3e34813 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -646,11 +646,20 @@ static inline void perf_events_lapic_init(void)	{ }
 static inline void perf_check_microcode(void) { }
 #endif
 
+struct x86_guest_pebs {
+	u64	enable;
+	u64	ds_area;
+	u64	data_cfg;
+	u64	cross_mapped_mask;
+};
+
 #if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
-extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
+extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr,
+							 struct x86_guest_pebs *guest_pebs);
 extern void x86_perf_get_lbr(struct x86_pmu_lbr *lbr);
 #else
-struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr, void *data);
+struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr,
+						  struct x86_guest_pebs *guest_pebs);
 static inline void x86_perf_get_lbr(struct x86_pmu_lbr *lbr)
 {
 	memset(lbr, 0, sizeof(*lbr));
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 77012b2eca0e..e6ff02b97677 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -705,11 +705,22 @@ static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
-void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
+u64 intel_pmu_get_cross_mapped_mask(struct kvm_pmu *pmu)
 {
-	struct kvm_pmc *pmc = NULL;
+	u64 host_cross_mapped_mask;
+	struct kvm_pmc *pmc;
 	int bit, hw_idx;
 
+	if (!(pmu->pebs_enable & pmu->global_ctrl))
+		return 0;
+
+	/*
+	 * If a guest counter is cross-mapped to a host counter with a different
+	 * index, flag it for perf, as PEBS needs to be disabled for that
+	 * counter to avoid enabling PEBS on the wrong perf event.
+	 */
+	host_cross_mapped_mask = 0;
+
 	kvm_for_each_pmc(pmu, pmc, bit, (unsigned long *)&pmu->global_ctrl) {
 		if (!pmc_speculative_in_use(pmc) ||
 		    !pmc_is_globally_enabled(pmc) || !pmc->perf_event)
@@ -721,8 +732,9 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 		 */
 		hw_idx = pmc->perf_event->hw.idx;
 		if (hw_idx != pmc->idx && hw_idx > -1)
-			pmu->host_cross_mapped_mask |= BIT_ULL(hw_idx);
+			host_cross_mapped_mask |= BIT_ULL(hw_idx);
 	}
+	return host_cross_mapped_mask;
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5c5766467a61..2a496fd64edc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7247,12 +7247,15 @@ static void atomic_switch_perf_msrs(struct vcpu_vmx *vmx)
 	struct perf_guest_switch_msr *msrs;
 	struct kvm_pmu *pmu = vcpu_to_pmu(&vmx->vcpu);
 
-	pmu->host_cross_mapped_mask = 0;
-	if (pmu->pebs_enable & pmu->global_ctrl)
-		intel_pmu_cross_mapped_check(pmu);
+	struct x86_guest_pebs guest_pebs = {
+		.enable = pmu->pebs_enable,
+		.ds_area = pmu->ds_area,
+		.data_cfg = pmu->pebs_data_cfg,
+		.cross_mapped_mask = intel_pmu_get_cross_mapped_mask(pmu),
+	};
 
 	/* Note, nr_msrs may be garbage if perf_guest_get_msrs() returns NULL. */
-	msrs = perf_guest_get_msrs(&nr_msrs, (void *)pmu);
+	msrs = perf_guest_get_msrs(&nr_msrs, &guest_pebs);
 	if (!msrs)
 		return;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 951e44dc9d0e..bfcce24919d5 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -677,7 +677,7 @@ static inline bool intel_pmu_lbr_is_enabled(struct kvm_vcpu *vcpu)
 	return !!vcpu_to_lbr_records(vcpu)->nr;
 }
 
-void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu);
+u64 intel_pmu_get_cross_mapped_mask(struct kvm_pmu *pmu);
 int intel_pmu_create_guest_lbr_event(struct kvm_vcpu *vcpu);
 void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu);
 

base-commit: 0ff41df1cb268fc69e703a08a57ee14ae967d0ca
-- 
2.49.0.1204.g71687c7c1d-goog


