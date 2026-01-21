Return-Path: <kvm+bounces-68821-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4FLhGKBZcWkNEwAAu9opvQ
	(envelope-from <kvm+bounces-68821-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:56:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AC65F251
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0822A70AE78
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:56:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B34D450900;
	Wed, 21 Jan 2026 22:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W1nuneVu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159CD3ED134
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036115; cv=none; b=YlsyxeDZskqOJ5+P1YhLVGpwkacRPa8bkcbZEmT9pUr4fMR0qfGjeUk6xFs4pWj/tuEdgUF0lJo5Q/+3u6MGocGCvmZKDLDfOKWF05K7Jm9Qh2fIpkOAXkAjB5AgnutYZOrlwWHfr7zOibsUkGau7z8sG0IRJ0qldGPAKX822NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036115; c=relaxed/simple;
	bh=gLJ9pP4KbjVkIZBDUiydWO3ATbRPdgqnRoeV2aYIC0Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GL2p5Ph8HGGJDfvCtHwxQtEq5yxVDGybkNNZ/m8xiQaeAkU0VG2AHKQRHtKET8Z0uc2eTH+GVR8kyTtOu+6zadDbePS0QGcZJm3H6/agUP2qdvyDwZRtfhPzwRNRaTXXWdEyPmEM/q7tOExxu1AFvfyZnCAsxPTnv7R02N6mb/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W1nuneVu; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c704d5d15so633272a91.1
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769036110; x=1769640910; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fYZnEa6Bb/f2/6ej1BUpAz8CiN6p1EtpnBTMXq8YhlA=;
        b=W1nuneVucFkDeLy07WKwR7WvXqdoUrSlkgTfF8EINic3KY514C2zkG8D0jEFK/6Jrm
         qiFDDxyvJOCwC6ohFYKEWtDH8Y96OjD0+anCMjR2eKo/AqWNJv1nPZhHOvJiqn2uznCB
         rRZqi8f+qum+EZjcOqknJvxwQdqs1r6GygCv2bDUw5ZkBCidhXnp+Suzsw1CkdI23YTf
         wAGDF56XT3Tf3GxSVYitWQsvAN9ExIBogDDNlgPUzHbn+ZVs+JFfxMU3WpxLZxmkZrXa
         Yp1nqJ1qfWrqoLQciXroSVCgPbhyXw0abzopwsQySkSFEdtsX84bQmKxBRBhC52xlwqe
         SNvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769036110; x=1769640910;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fYZnEa6Bb/f2/6ej1BUpAz8CiN6p1EtpnBTMXq8YhlA=;
        b=vuWVJbkWUXxqDfFu967tk5D835qABQ/+ti6lnyiEEBweZH5oY8k6PVCS84hfodWL4W
         h5Ib3py13STrhfD4xwIFyTuZa/aicc/oDdvN8HstxVPHDNNTe8I7turicy990M9EHnRG
         3Xx+o4LeHB5340az6toTh7iS175Cc1nZ3tZUXCc709UAWhVma4PWZzk8Z+6nKa87HJ2+
         8sgRWartDyulY5ighlta7sMCw3Pb+H4r3hI1Fco2r9XvQApVHWyIERjUooevNq9Jr/Qj
         2d2ktecXGPBbYliqhsGlxFH+MCFvXK8Aj2SbbJWe8XXjBmtqpcirWCL3vwd/1XXjEhRj
         cKhA==
X-Forwarded-Encrypted: i=1; AJvYcCUi6I7RQnErDvoHV8xQjN08uDvPYoON3W+DRI88eqc93PYoqITDzxERsd/mlhvs7CitJ0M=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywey5c7J4BSO1F+29UDz3DqZGHkLnbld7nbcMI6NL0e4jn7hf1x
	cKy7P2LqX6oZW51vOeNsnn0yYtFhGeWsy5jKgx+fZw1DAvqpBm4Wn8gRq7Wpr6LPwIGkg1UhmER
	nqUbRW9Bap60C8A==
X-Received: from pjbnp3.prod.google.com ([2002:a17:90b:4c43:b0:352:c99c:60b2])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d84:b0:352:e796:bb65 with SMTP id 98e67ed59e1d1-352e796bbbamr4837712a91.31.1769036109597;
 Wed, 21 Jan 2026 14:55:09 -0800 (PST)
Date: Wed, 21 Jan 2026 14:54:02 -0800
In-Reply-To: <20260121225438.3908422-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121225438.3908422-5-jmattson@google.com>
Subject: [PATCH 4/6] KVM: x86/pmu: [De]activate HG_ONLY PMCs at SVME changes
 and nested transitions
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68821-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: C7AC65F251
X-Rspamd-Action: no action

Add a new function, kvm_pmu_set_pmc_eventsel_hw_enable(), to set or clear
the enable bit in eventsel_hw for PMCs identified by a bitmap.

Use this function to update Host-Only and Guest-Only counters at the
following transitions:

  - svm_set_efer(): When SVME changes, enable Guest-Only counters if SVME
    is being cleared (HG_ONLY bits become ignored), or disable them if SVME
    is being set (L1 is active).

  - nested_svm_vmrun(): Disable Host-Only counters and enable Guest-Only
    counters.

  - nested_svm_vmexit(): Disable Guest-Only counters and enable Host-Only
    counters.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 +
 arch/x86/kvm/pmu.c                     |  7 +++++++
 arch/x86/kvm/pmu.h                     |  4 ++++
 arch/x86/kvm/svm/nested.c              | 10 ++++++++++
 arch/x86/kvm/svm/pmu.c                 | 17 +++++++++++++++++
 arch/x86/kvm/svm/svm.c                 |  3 +++
 6 files changed, 42 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index f0aa6996811f..7b32796213a0 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -26,6 +26,7 @@ KVM_X86_PMU_OP_OPTIONAL(cleanup)
 KVM_X86_PMU_OP_OPTIONAL(write_global_ctrl)
 KVM_X86_PMU_OP(mediated_load)
 KVM_X86_PMU_OP(mediated_put)
+KVM_X86_PMU_OP_OPTIONAL(set_pmc_eventsel_hw_enable)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 833ee2ecd43f..1541c201285b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -1142,6 +1142,13 @@ void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_pmu_branch_retired);
 
+void kvm_pmu_set_pmc_eventsel_hw_enable(struct kvm_vcpu *vcpu,
+				       unsigned long *bitmap, bool enable)
+{
+	kvm_pmu_call(set_pmc_eventsel_hw_enable)(vcpu, bitmap, enable);
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_pmu_set_pmc_eventsel_hw_enable);
+
 static bool is_masked_filter_valid(const struct kvm_x86_pmu_event_filter *filter)
 {
 	u64 mask = kvm_pmu_ops.EVENTSEL_EVENT |
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 0925246731cb..b8be8b6e40d8 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -41,6 +41,8 @@ struct kvm_pmu_ops {
 	void (*mediated_load)(struct kvm_vcpu *vcpu);
 	void (*mediated_put)(struct kvm_vcpu *vcpu);
 	void (*write_global_ctrl)(u64 global_ctrl);
+	void (*set_pmc_eventsel_hw_enable)(struct kvm_vcpu *vcpu,
+					   unsigned long *bitmap, bool enable);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
@@ -258,6 +260,8 @@ void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
 void kvm_pmu_instruction_retired(struct kvm_vcpu *vcpu);
 void kvm_pmu_branch_retired(struct kvm_vcpu *vcpu);
+void kvm_pmu_set_pmc_eventsel_hw_enable(struct kvm_vcpu *vcpu,
+				       unsigned long *bitmap, bool enable);
 void kvm_mediated_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_mediated_pmu_put(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..edaa76e38417 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -28,6 +28,7 @@
 #include "smm.h"
 #include "cpuid.h"
 #include "lapic.h"
+#include "pmu.h"
 #include "svm.h"
 #include "hyperv.h"
 
@@ -1054,6 +1055,11 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
+	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
+		vcpu_to_pmu(vcpu)->pmc_hostonly, false);
+	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
+		vcpu_to_pmu(vcpu)->pmc_guestonly, true);
+
 	if (nested_svm_merge_msrpm(vcpu))
 		goto out;
 
@@ -1137,6 +1143,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);
+	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
+		vcpu_to_pmu(vcpu)->pmc_hostonly, true);
+	kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
+		vcpu_to_pmu(vcpu)->pmc_guestonly, false);
 	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index c06013e2b4b1..85155d65fa38 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -316,6 +316,22 @@ static void amd_mediated_pmu_put(struct kvm_vcpu *vcpu)
 		wrmsrq(MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR, pmu->global_status);
 }
 
+static void amd_pmu_set_pmc_eventsel_hw_enable(struct kvm_vcpu *vcpu,
+					       unsigned long *bitmap,
+					       bool enable)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct kvm_pmc *pmc;
+	int i;
+
+	kvm_for_each_pmc(pmu, pmc, i, bitmap) {
+		if (enable)
+			pmc->eventsel_hw |= ARCH_PERFMON_EVENTSEL_ENABLE;
+		else
+			pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
+	}
+}
+
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
@@ -329,6 +345,7 @@ struct kvm_pmu_ops amd_pmu_ops __initdata = {
 	.is_mediated_pmu_supported = amd_pmu_is_mediated_pmu_supported,
 	.mediated_load = amd_mediated_pmu_load,
 	.mediated_put = amd_mediated_pmu_put,
+	.set_pmc_eventsel_hw_enable = amd_pmu_set_pmc_eventsel_hw_enable,
 
 	.EVENTSEL_EVENT = AMD64_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_MAX_NR_AMD_GP_COUNTERS,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7803d2781144..953089b38921 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -244,6 +244,9 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
+
+		kvm_pmu_set_pmc_eventsel_hw_enable(vcpu,
+			vcpu_to_pmu(vcpu)->pmc_guestonly, !(efer & EFER_SVME));
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
-- 
2.52.0.457.g6b5491de43-goog


