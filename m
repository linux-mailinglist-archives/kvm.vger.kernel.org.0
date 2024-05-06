Return-Path: <kvm+bounces-16652-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 119E98BC6F4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBAD3280B40
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:35:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31B3143C52;
	Mon,  6 May 2024 05:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ayVimRto"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8152C143C48
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973505; cv=none; b=ZvgMB15dlM/JhIibp8dzWjKnDc1Im/PYWXFVAAogkBYFLAI2q8RSYlFwQzNugYtEBzmONlX4x+CuGxgoXvl/t1FHO9gBRzVhLvSC1A1hfdSw+/o+ZkNIeutJ4TmiLs4OGt29PH6R7ya9Z2/mV4SMCxyGDVK1aRGSAIaYl1aD90o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973505; c=relaxed/simple;
	bh=IaG3WshtNgeTnyTB/oLA4MQoJ01it8Gujk8G4J4nCbw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VT077SnZIoidBJp2r+k9ocZqyKYPw37Y+tsaiHrpUQSDLweFd7hj35YicXpM/AtoCic2Hr2QITUDpPcfM3NxkVHgmLEJXcFIKdx3C4sVRjelfeJXVM/59kACFLs8O5Ha0iVw7k6RC75QbY/wyYZM8UfjH9yrFIlq85IQm/2XFUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ayVimRto; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc64f63d768so3125125276.2
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973503; x=1715578303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=v82sTxnncFb8g7f7pUYj4aCyHiFFjGX3JeQTtvNNAl0=;
        b=ayVimRtoitAOsIe0+3LgIFPyxf/t+Wum88EIG3WHPA5fYNMsEcr7IgzxD6gw8uciZh
         5jbODL1uRcvS/QEyUEzSlGMcWTR4ySh/ZbI0RQvGDDascTtc7bGxFmPf5mSvtmps2zHj
         4wF4h4Qi0W11lTcdyQryQVO4awyrJe6QmnrKq3JVkGLHvY0p8I4u4t5uQxeQ1WQv6V4H
         futpXZ6/XXdKiw0jwxk9ElU0O1+9VGqS0tjOWjYMx4h5SeTCPM8e5XrKg7eTkmfhnLwB
         +Mt8hnY4tIywNF+IEi4tK08f0Vdpoy+qEUnawdJ6Gnm7Dg/AJfyeDK4DgjzFh088h8pP
         PrTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973503; x=1715578303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v82sTxnncFb8g7f7pUYj4aCyHiFFjGX3JeQTtvNNAl0=;
        b=oS1HJXNWE5nkO7/2TNSwX1Nsyk2D+NguwvpihxsZRECCnmNztawbBvu9cV/Nj5nz5t
         9QheCA2KYwCl+DMQIF1C44FOG0BmMGZzRsv4icvjIGeR+byHWeaFBX4HA1PXKGCHbE6u
         pFaP6oprqB9p7GHQDNkOjhjUqo3yAiQUwLPlApN/TTTZPIjM8bMoEVmM+EDQYfP6EUHe
         LohzU3jWQu+sc9WeGaV6K/wL1qinQcjfV7tf9JPiz2DAj3O8+lTvjEiYTurwo1EhwycV
         qyTdr2bRkRabH1omIux0EmnHF4X+yO5jYLAGgLfuQOMRMhpcggwD2aU0w+lxfLJ9PuVG
         pvTg==
X-Forwarded-Encrypted: i=1; AJvYcCVm1bBjVCpc03rm+r31ab648GXOS4OiciH63nPoNcTS7hL+sacBwXVGlFNpKSdXOgQUj8zBlLAAi5PTyNQVAm/nLxLd
X-Gm-Message-State: AOJu0YwO4BLN2mtaOzkyS42HFUsNzZ/SytMTeWFQ7ANbaa7hKv45ozRD
	Ejp/O3+DvuTVEgf7eWIaqfwKqW8My3rDMcrqtM+fm+411WHAzuXKt7e2ozo3dTnOR7k8mflZMl9
	caUwZ4Q==
X-Google-Smtp-Source: AGHT+IEW4RzhFKt80YyR6YW1SeSH/HMbIyDtdOi+jV8EvuYRDlsFQmiRPYaYPOkisNK0JdhXPHyjGdR40kpH
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a05:6902:1082:b0:de4:5ce2:7d2 with SMTP id
 v2-20020a056902108200b00de45ce207d2mr3128058ybu.4.1714973503230; Sun, 05 May
 2024 22:31:43 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:05 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-41-mizhang@google.com>
Subject: [PATCH v2 40/54] KVM: x86/pmu: Introduce PMU operator to increment counter
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

Introduce PMU operator to increment counter because in passthrough PMU
there is no common backend implementation like host perf API. Having a PMU
operator for counter increment and overflow checking will help hiding
architectural differences.

So Introduce the operator function to make it convenient for passthrough
PMU to synthesize a PMI.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 +
 arch/x86/kvm/pmu.h                     |  1 +
 arch/x86/kvm/vmx/pmu_intel.c           | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 1a848ba6a7a7..72ca78df8d2b 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -27,6 +27,7 @@ KVM_X86_PMU_OP_OPTIONAL(cleanup)
 KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
 KVM_X86_PMU_OP_OPTIONAL(save_pmu_context)
 KVM_X86_PMU_OP_OPTIONAL(restore_pmu_context)
+KVM_X86_PMU_OP_OPTIONAL(incr_counter)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 9cde62f3988e..325f17673a00 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -44,6 +44,7 @@ struct kvm_pmu_ops {
 	void (*passthrough_pmu_msrs)(struct kvm_vcpu *vcpu);
 	void (*save_pmu_context)(struct kvm_vcpu *vcpu);
 	void (*restore_pmu_context)(struct kvm_vcpu *vcpu);
+	bool (*incr_counter)(struct kvm_pmc *pmc);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6db759147896..485bbccf503a 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -74,6 +74,17 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	}
 }
 
+static bool intel_incr_counter(struct kvm_pmc *pmc)
+{
+	pmc->counter += 1;
+	pmc->counter &= pmc_bitmask(pmc);
+
+	if (!pmc->counter)
+		return true;
+
+	return false;
+}
+
 static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 					    unsigned int idx, u64 *mask)
 {
@@ -885,6 +896,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.passthrough_pmu_msrs = intel_passthrough_pmu_msrs,
 	.save_pmu_context = intel_save_guest_pmu_context,
 	.restore_pmu_context = intel_restore_guest_pmu_context,
+	.incr_counter = intel_incr_counter,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = 1,
-- 
2.45.0.rc1.225.g2a3ae87e7f-goog


