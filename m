Return-Path: <kvm+bounces-69642-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0NXiIVPte2kMJgIAu9opvQ
	(envelope-from <kvm+bounces-69642-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:29:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CB43DB5AF8
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 00:29:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9F35D300B2B6
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 23:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2187335554;
	Thu, 29 Jan 2026 23:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iPcGbahZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A3F37757D
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 23:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769729347; cv=none; b=B41++0avEYnlkQfcpN4a3LRSuqUgsiy4JeLZoQdctnH/hqbYyz/kmk0VlGx3Nk12S9va7WXN2Jg6sSc0iK3pmzy6h4OX7DE4nUa68lKulyOPOvgikhBQdZGhmx3sVLCntOcHIPl5tERe2rlWpmFNuWeUwu+XW//cT+toSXj36Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769729347; c=relaxed/simple;
	bh=FT7tqsXR7z8CLijk8zuS07pg9saPtM/Y6JJH09YC9j8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=odN2NNcboIAr9ujWRz5pomPTUbQTqj+fp7iynWEHqtTzm37jtkjzFufcjedDZGTQJZh2RJ7x93mOnXmbn7SzrT7hv/wYHHMK3FQWxbAaNXwSb0la/Lo+Tzvn9dVx91zMnx7BQ1FKXkzYhw7N8SRYo9pWM1w+hWHfj/DzQ7+Zr8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iPcGbahZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c5d6193daso3470646a91.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769729345; x=1770334145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Srv37W6IxsjnZSGJ2r5eoka37P7txkKUnZCQigLVbTg=;
        b=iPcGbahZN2rkYw9FBb32VCwEX+fmwxGAEUTZhSc2rmsa7HL93PFbgog8Z8uvwCFNV3
         jbMV9GHG80Fk60ImHlewQEb+thXE5JfG1b7bE4aWkdTyBAar2Ke0Y6Xeb+Cj8sVKugEt
         8uYBYmsz8PfTYSMICl+z6kt1yOJgve/GzmEOZQxcxsJM07iz2K6GwsO3IM7UCTjA22Sd
         QiuA+U0PZBwqXqYbr6zFoJouMj/tj8m882X8Sa8x0NQb2W5xu2qmyfdJ1hDPwwAjxiwR
         neomTKbV2lkUxb9mA3DxyxCunFJIVp/nK3ZzQvpe7aF61KdruxF03UQbFnmnFfLvB2Cv
         yKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769729345; x=1770334145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Srv37W6IxsjnZSGJ2r5eoka37P7txkKUnZCQigLVbTg=;
        b=P5pvhGwzIt7G+9z4gp0w4/l3XBqo4dksJrf0cr/vdz0CwNOHlcltiP8V+9XhGaYoiu
         X1g1E6mePis/F/KVeYqd2jOiGtc0LYlJcuIRoUyn6DsPBZNreMExEucKN1smZloljuIM
         1mSctLWwQoX0eqOSz1yKravVRaA7hPu2fAjph015Q7NWsG6zEcrSaZn36srulJwDSHRC
         T0HuRe7gfC3K36dRJ9SsQpQaJqVgtyhzQN20PEimRaRcVSMfANfhbwc9ED1iKXGHshOB
         ECYe20kTFovBYSkBXt6Gs11cJs9Uo3pXYtIAVNpMG0cHfdmULHWtyySQtyOf/xWsbNQs
         d7vw==
X-Forwarded-Encrypted: i=1; AJvYcCUzdM8Qo8/VgSwt6UFderpciqdHkqLfWHZJKa0oQCbbow3Mluu22XJLouJI3USDPVUsDXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHqu4xF981r8dlMuUcJdy4iv1Smexur3dz8rGteh8yV/XBsx0J
	ZJ7lD8X34nfIMgjlInGbrQ8/UVjfd/xoMsRRmgdfnl/Nizt+asQ37AxjTMNuqlIkhqAjKzPAGwj
	ymre1x6TOf5KbJQ==
X-Received: from pjbga13.prod.google.com ([2002:a17:90b:38d:b0:349:3867:ccc1])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2883:b0:341:8ac7:39b7 with SMTP id 98e67ed59e1d1-3543b3aa986mr976448a91.25.1769729344811;
 Thu, 29 Jan 2026 15:29:04 -0800 (PST)
Date: Thu, 29 Jan 2026 15:28:08 -0800
In-Reply-To: <20260129232835.3710773-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129232835.3710773-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129232835.3710773-4-jmattson@google.com>
Subject: [PATCH v2 3/5] KVM: x86/pmu: Refresh Host-Only/Guest-Only eventsel at
 nested transitions
From: Jim Mattson <jmattson@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: mizhang@google.com, yosryahmed@google.com, sandipan.das@amd.com, 
	Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69642-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[26];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CB43DB5AF8
X-Rspamd-Action: no action

Add amd_pmu_refresh_host_guest_eventsel_hw() to recalculate eventsel_hw for
all PMCs based on the current vCPU state. This is needed because Host-Only
and Guest-Only counters must be enabled/disabled at:

  - SVME changes: When EFER.SVME is modified, counters with Guest-Only bits
    need their hardware enable state updated.

  - Nested transitions: When entering or leaving guest mode, Host-Only
    counters should be disabled/enabled and Guest-Only counters should be
    enabled/disabled accordingly.

Introduce svm_enter_guest_mode() and svm_leave_guest_mode() wrappers that
call enter_guest_mode()/leave_guest_mode() followed by the PMU refresh,
ensuring the PMU state stays synchronized with guest mode transitions.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/svm/nested.c |  6 +++---
 arch/x86/kvm/svm/pmu.c    | 12 ++++++++++++
 arch/x86/kvm/svm/svm.c    |  2 ++
 arch/x86/kvm/svm/svm.h    | 17 +++++++++++++++++
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index de90b104a0dd..a7d1901f256b 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -757,7 +757,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	nested_svm_transition_tlb_flush(vcpu);
 
 	/* Enter Guest-Mode */
-	enter_guest_mode(vcpu);
+	svm_enter_guest_mode(vcpu);
 
 	/*
 	 * Filled at exit: exit_code, exit_info_1, exit_info_2, exit_int_info,
@@ -1136,7 +1136,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12 = map.hva;
 
 	/* Exit Guest-Mode */
-	leave_guest_mode(vcpu);
+	svm_leave_guest_mode(vcpu);
 	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
@@ -1402,7 +1402,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 		svm->nested.nested_run_pending = 0;
 		svm->nested.vmcb12_gpa = INVALID_GPA;
 
-		leave_guest_mode(vcpu);
+		svm_leave_guest_mode(vcpu);
 
 		svm_switch_vmcb(svm, &svm->vmcb01);
 
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 8d451110a94d..e2a849fc7daa 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -171,6 +171,18 @@ static void amd_pmu_set_eventsel_hw(struct kvm_pmc *pmc)
 	pmc->eventsel_hw &= ~ARCH_PERFMON_EVENTSEL_ENABLE;
 }
 
+void amd_pmu_refresh_host_guest_eventsel_hw(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	int i;
+
+	if (pmu->reserved_bits & AMD64_EVENTSEL_HOST_GUEST_MASK)
+		return;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++)
+		amd_pmu_set_eventsel_hw(&pmu->gp_counters[i]);
+}
+
 static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5f0136dbdde6..498e098a3df0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -244,6 +244,8 @@ int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
 			if (svm_gp_erratum_intercept && !sev_guest(vcpu->kvm))
 				set_exception_intercept(svm, GP_VECTOR);
 		}
+
+		amd_pmu_refresh_host_guest_eventsel_hw(vcpu);
 	}
 
 	svm->vmcb->save.efer = efer | EFER_SVME;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ebd7b36b1ceb..86d4d37bfb08 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -864,6 +864,23 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct vcpu_svm *svm, struct sev_es_save_area *hostsa);
 void sev_es_unmap_ghcb(struct vcpu_svm *svm);
 
+
+/* pmu.c */
+void amd_pmu_refresh_host_guest_eventsel_hw(struct kvm_vcpu *vcpu);
+
+
+static inline void svm_enter_guest_mode(struct kvm_vcpu *vcpu)
+{
+	enter_guest_mode(vcpu);
+	amd_pmu_refresh_host_guest_eventsel_hw(vcpu);
+}
+
+static inline void svm_leave_guest_mode(struct kvm_vcpu *vcpu)
+{
+	leave_guest_mode(vcpu);
+	amd_pmu_refresh_host_guest_eventsel_hw(vcpu);
+}
+
 #ifdef CONFIG_KVM_AMD_SEV
 int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp);
 int sev_mem_enc_register_region(struct kvm *kvm,
-- 
2.53.0.rc1.225.gd81095ad13-goog


