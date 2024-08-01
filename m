Return-Path: <kvm+bounces-22876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 399C3944279
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 07:04:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9547288282
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 05:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF92A1509A6;
	Thu,  1 Aug 2024 05:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BJexU4ZM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E4115098A
	for <kvm@vger.kernel.org>; Thu,  1 Aug 2024 05:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722488433; cv=none; b=l421l2EtY8fpbDOJpMj7CXAWRzPbyQDJIwlzW4/eUw3uGI6kkzzf+pna3raRtUoU0Z5Hzgv5VPvUl6u2do9PMx+FILSqc78UI1WGfRyKsrZlwyJulfymhHYUvRk0OZnIBEVm87jtPGKzo1SFWkavNLAouxtRgHQHUhbVU7j6raE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722488433; c=relaxed/simple;
	bh=h2BIhzPWqK1WX6sUig0pWm4EWfyb/ZKPY5ztzMGHoIY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XyDbFD50yeVHHI/caSI0v0PDw7bTHThKTmceQ6O1jgG+/ti1qK+g9f1mg+38SDhhct/FzncWr0MUHaqn2XXWiWz5yIOqEzFkmYUHnC+MpD5Qm7/jeWP6YnlrCstw/Irhf6Zc+cpNRyA9HgGpk/JWuquCNf98hT6qq86W+MOHREg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BJexU4ZM; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2cb567fccf4so6417213a91.0
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2024 22:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722488431; x=1723093231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OoGP7Z9uDxmG6CzYVyLj44ANC+cEU7w76pDMHfnQCbo=;
        b=BJexU4ZMaVaNo47MAlItEsi4c4vh+EHaRfRYRvdy9SlXk5cyYM0FIi2elFyRBW8/0u
         mXA3tnqvc+7ExlIgMT04vlXVj+x9jrKgfJVQx2JaP+gXw0iHDK+BaDI6oDPm0gzj16fv
         Jn+aa6cPghv63xh5vT+PsUs6ViFoJBtHuFLJN3unTYag3syNWlj/ZW7yB+UydXFzwFta
         WkEHA3MxEHnbgOLvPrq5Cb8Nb2J7Q3Ml3ot0yx/oo9O0199aCAOXpEF1sMF5N0PaKbHh
         n74K/J/8W+4bbcZTHYOx0LPczExx6bupi8hjpj9kbXcfvpfRE7kfSk4W7lBFEYq0KGUw
         yudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722488431; x=1723093231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OoGP7Z9uDxmG6CzYVyLj44ANC+cEU7w76pDMHfnQCbo=;
        b=s6QIr+9y5i8xAnt4RdhMsAPlugUMCIaWFp7HArHO/fY9RsNaex6Cpa3V4xGgwSIT2N
         NZnPkOzqqoIyELP4lTmKOPpqbxDt9Ib+iNh89JOTP7bzcQankkgfD2+La886uAAXB+Ky
         AEzoIng+NMTTTg74qd3W8voo965hDPokAChxImSuaiY11sg233Et+v2VU7F/EGZOhs+w
         CrtmhJIiiL9ZaQAvSPqdKRfZHoD+V26XwZo1q7ciWJ10+GUnGuX168opaxyGYLfD9fOX
         yCAhzZxE20p1dFmZLYGvy0cfMCRn+F6HI9uYNVxpD5PWJ8/0uOt72T3hW6PdkVI7Caq4
         GhEg==
X-Forwarded-Encrypted: i=1; AJvYcCUN469QbJ9Nx3BEdlWIbPUwJ3f7JkL5O1AeWjg4SfASOBo/tnAajwHcjuRUsRq0+O3gv/dnXu1DDfcDzCEqMhJUTKR+
X-Gm-Message-State: AOJu0YxxYwTvt5dj0Gm+228nKuz5EYVRpxTC5tzn8ZlXcOR5Bx12w80Y
	6X77KfG/D1YX+jetLFu5UNWIWvcIv3d/mR2sfihhlJveMgkdC40olYK6MVEfTxtLNloUhHjqGzx
	vE89O2g==
X-Google-Smtp-Source: AGHT+IE0SUiysq8onpo5FTRQNhm7CnSNYELnvE81ag75kjeNorppDjOFmoYHczpasFS8m6aV5EhpFQVwJMND
X-Received: from mizhang-super.c.googlers.com ([35.247.89.60]) (user=mizhang
 job=sendgmr) by 2002:a17:90b:4f90:b0:2c9:9a89:a2ae with SMTP id
 98e67ed59e1d1-2cfe73470b4mr16443a91.0.1722488431039; Wed, 31 Jul 2024
 22:00:31 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Thu,  1 Aug 2024 04:58:52 +0000
In-Reply-To: <20240801045907.4010984-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240801045907.4010984-1-mizhang@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240801045907.4010984-44-mizhang@google.com>
Subject: [RFC PATCH v3 43/58] KVM: x86/pmu: Introduce PMU operator for setting
 counter overflow
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

Introduce PMU operator for setting counter overflow. When emulating counter
increment, multiple counters could overflow at the same time, i.e., during
the execution of the same instruction. In passthrough PMU, having an PMU
operator provides convenience to update the PMU global status in one shot
with details hidden behind the vendor specific implementation.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h | 1 +
 arch/x86/kvm/pmu.h                     | 1 +
 arch/x86/kvm/vmx/pmu_intel.c           | 5 +++++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 72ca78df8d2b..bd5b118a5ce5 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -28,6 +28,7 @@ KVM_X86_PMU_OP_OPTIONAL(passthrough_pmu_msrs)
 KVM_X86_PMU_OP_OPTIONAL(save_pmu_context)
 KVM_X86_PMU_OP_OPTIONAL(restore_pmu_context)
 KVM_X86_PMU_OP_OPTIONAL(incr_counter)
+KVM_X86_PMU_OP_OPTIONAL(set_overflow)
 
 #undef KVM_X86_PMU_OP
 #undef KVM_X86_PMU_OP_OPTIONAL
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 325f17673a00..78a7f0c5f3ba 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -45,6 +45,7 @@ struct kvm_pmu_ops {
 	void (*save_pmu_context)(struct kvm_vcpu *vcpu);
 	void (*restore_pmu_context)(struct kvm_vcpu *vcpu);
 	bool (*incr_counter)(struct kvm_pmc *pmc);
+	void (*set_overflow)(struct kvm_vcpu *vcpu);
 
 	const u64 EVENTSEL_EVENT;
 	const int MAX_NR_GP_COUNTERS;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 42af2404bdb9..2d46c911f0b7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -881,6 +881,10 @@ static void intel_restore_guest_pmu_context(struct kvm_vcpu *vcpu)
 	wrmsrl(MSR_CORE_PERF_FIXED_CTR_CTRL, pmu->fixed_ctr_ctrl_hw);
 }
 
+static void intel_set_overflow(struct kvm_vcpu *vcpu)
+{
+}
+
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
@@ -897,6 +901,7 @@ struct kvm_pmu_ops intel_pmu_ops __initdata = {
 	.save_pmu_context = intel_save_guest_pmu_context,
 	.restore_pmu_context = intel_restore_guest_pmu_context,
 	.incr_counter = intel_incr_counter,
+	.set_overflow = intel_set_overflow,
 	.EVENTSEL_EVENT = ARCH_PERFMON_EVENTSEL_EVENT,
 	.MAX_NR_GP_COUNTERS = KVM_INTEL_PMC_MAX_GENERIC,
 	.MIN_NR_GP_COUNTERS = 1,
-- 
2.46.0.rc1.232.g9752f9e123-goog


