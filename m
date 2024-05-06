Return-Path: <kvm+bounces-16640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D79418BC6E7
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:34:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 05F2B1C2112E
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:34:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCD2142914;
	Mon,  6 May 2024 05:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Toh9dh/9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2840214290E
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973483; cv=none; b=fq3uEv/snH+hvCLeW8VA35mGCCeHFUgZ077vxfZZFPe1IJ3wMJIvqs9ZuEMpTUFSNmA84cUypSdL+XFZziR/knxKRAnSfJnfHec9DeMkQHkxBxIyI7X0n9ubsTfQuCQgxnbtg5a4LZwsCg6udNOy5WYmHBo8Il5giTMrQy0yzFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973483; c=relaxed/simple;
	bh=88xK6/BPJJ+qwqrdgbzMXC9g6Pw8McmBuWqQS6vOTwU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ckTBmgeEPuNOwDJJJ/99+3sM4kney65r5VLjn5qikJ5lQvoAIDIsUw0C6Anlpv3i6dW6mOSR0zt4yefzF3Zd2VXQt298deYU91sYD699OiJWVsoGcIpVlLBtHa/6EP2s+EDQO2NCMnnfZWYrbnmHcvoYESnMjRTmsyAidcSLRgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Toh9dh/9; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de8b6847956so5602897276.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973480; x=1715578280; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OkpzniOmql2hhfCmXuFweeEuaPvaB5DKyTSnoADA8Gs=;
        b=Toh9dh/9TqlHE1t6noU6jkZLdVfcf/JcUGFLhsHw6IIVbAd+meQYZ9txScgmhuW/4s
         cftEgF+SYAU70ol+OfNLz6By2F7rDvON6w0T3EfjcxiNnFmIBoB0vr4a7rrTln+Vwog7
         aDVSgY0yzgIOwl0DolCKixVzg4Yva/a9+6mLRdqO4/B83Rp3kFXsTF6Lsc39d9p5cx9x
         0tOV5bGxk2ZksR2Sn4sQuYmcZdnhFiDFXm2eeqnZrFGRpRZIhWL2nAP/1AtmG9IvFlWj
         0dLlnhr3+hhe6PAD0rqX9leKy66jMv3VkTVR8+zVKnqhPN6K5ZwMEv+43pKEMrlY+8cZ
         MA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973480; x=1715578280;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OkpzniOmql2hhfCmXuFweeEuaPvaB5DKyTSnoADA8Gs=;
        b=gZt5bhGQU1gVq8ngm3UF1HNTAV5ngFtktvn7oOXVVkgTeg5lRjeL9oIKC99Ce/xV/K
         fcGKbrkYbyw7QLpYW8r5nJPwc9884vMg2qdjBWOPithW2k/5OV984/wPRZgsufx2R5Wu
         0DoCQC6uh1229oJ6vlwF/yDr5EPYLC1NWn00U8dkIC3COp4VzQTdw394P17JmCFbpeyi
         3ulmyOZdHEWEW1XpZYDv5y2mooKE9VZ3dyORHa5FX2XPyFi737gtg2tzuFQarVyknA90
         HrxtKA6KMCipfN9FylzfpsJYvr+Iuz182JD1XRbSYl+X0ly24i2VYChNqGIxRmFucKtx
         pC5g==
X-Forwarded-Encrypted: i=1; AJvYcCU1VeqEXIBVdnNbU9q0SHO76JGlRhdWzDy+9wpTTMU4xIrWx+UPIuuRbLTIGgjFJZozltFKR7T9bDGSU6XwAuaOQJUi
X-Gm-Message-State: AOJu0YzyoAzpikuyy8Yw4lfBxAIhf88PZUTbnfN2o2Pvojf6csx+uCIn
	HPd4m66ARRo9srV8T/Dqs6uS7uFA22U3Ewy7rM6Kw9szkYTxfvukNdxrKlz080viGEGI0OvRIly
	C2s/Hxw==
X-Google-Smtp-Source: AGHT+IEQigA+N6bi8857q6EtFVr7KpnrtnHKM9GHLCDJKJfbJ2IRz1kMP2ixe60uRxek8PlnolS78L/nue/W
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:2b0f:b0:dbe:d0a9:2be3 with SMTP id
 fi15-20020a0569022b0f00b00dbed0a92be3mr3565587ybb.3.1714973480270; Sun, 05
 May 2024 22:31:20 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:29:53 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-29-mizhang@google.com>
Subject: [PATCH v2 28/54] KVM: x86/pmu: Add counter MSR and selector MSR index
 into struct kvm_pmc
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

Add the MSR indices for both selector and counter in each kvm_pmc. Giving
convenience to mediated passthrough vPMU in scenarios of querying MSR from
a given pmc. Note that legacy vPMU does not need this because it never
directly accesses PMU MSRs, instead each kvm_pmc is bound to a perf_event.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/svm/pmu.c          | 13 +++++++++++++
 arch/x86/kvm/vmx/pmu_intel.c    | 13 +++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 19b924c3bd85..8b4ea9bdcc74 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -519,6 +519,8 @@ struct kvm_pmc {
 	 */
 	u64 emulated_counter;
 	u64 eventsel;
+	u64 msr_counter;
+	u64 msr_eventsel;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 6b471b1ec9b8..447657513729 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -177,6 +177,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 	union cpuid_0x80000022_ebx ebx;
+	int i;
 
 	pmu->version = 1;
 	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
@@ -210,6 +211,18 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->nr_arch_fixed_counters = 0;
 	bitmap_set(pmu->all_valid_pmc_idx, 0, pmu->nr_arch_gp_counters);
+
+	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
+		for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+			pmu->gp_counters[i].msr_eventsel = MSR_F15H_PERF_CTL0 + 2*i;
+			pmu->gp_counters[i].msr_counter = MSR_F15H_PERF_CTR0 + 2*i;
+		}
+	} else {
+		for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+			pmu->gp_counters[i].msr_eventsel = MSR_K7_EVNTSEL0 + i;
+			pmu->gp_counters[i].msr_counter = MSR_K7_PERFCTR0 + i;
+		}
+	}
 }
 
 static void amd_pmu_init(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8e8d1f2aa5e5..7852ba25a240 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -562,6 +562,19 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 				~((1ull << pmu->nr_arch_gp_counters) - 1);
 		}
 	}
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		pmu->gp_counters[i].msr_eventsel = MSR_P6_EVNTSEL0 + i;
+		if (fw_writes_is_enabled(vcpu))
+			pmu->gp_counters[i].msr_counter = MSR_IA32_PMC0 + i;
+		else
+			pmu->gp_counters[i].msr_counter = MSR_IA32_PERFCTR0 + i;
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
+		pmu->fixed_counters[i].msr_eventsel = MSR_CORE_PERF_FIXED_CTR_CTRL;
+		pmu->fixed_counters[i].msr_counter = MSR_CORE_PERF_FIXED_CTR0 + i;
+	}
 }
 
 static void intel_pmu_init(struct kvm_vcpu *vcpu)
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


