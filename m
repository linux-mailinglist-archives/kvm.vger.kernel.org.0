Return-Path: <kvm+bounces-16653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF208BC6F5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 07:36:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41F981C20E03
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 05:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD7A12BF2B;
	Mon,  6 May 2024 05:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="McMoFHuZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D674112BF15
	for <kvm@vger.kernel.org>; Mon,  6 May 2024 05:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714973507; cv=none; b=joEa6ibri+iLETr/G8t9cYytjy/PEyC3pR7fknAipaaLrwq9CR1Q6IysGOeFlYooBqQtHmzS6UPOlMA8NRAhv699gqq4hulQ/J2BTTTYqkKiTo/DE+dqMRNxf9AONkKcMB+BjhI3yqQO3yJUpY31SihrEL3dBWzbLWdusINqWsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714973507; c=relaxed/simple;
	bh=DgJ4EN+xMRdFH/4/6PHsC4fBVL3Naex6D2R86q5BLnQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RoJmskpRhUFrGgPDx/ZQjRJmq1xdV1sM11IDi0bR3LaqRkMAgJ/gRVqjK5216QzjaEi5lMiEsr2UjMXvpfs3yg7LZv1ddT2Y4cQzQZhzEb+zldxNWl0Y8qTS6mqFUz6wjzkCOqelrV7DcGu6jB93aE+JVDF4V1Px4VpOspwworA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=McMoFHuZ; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--mizhang.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbf216080f5so3367097276.1
        for <kvm@vger.kernel.org>; Sun, 05 May 2024 22:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714973505; x=1715578305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=n6H04ZJ0rZ+UiGVgsYG099h9bSA0uf9CXiCVKmASq/Y=;
        b=McMoFHuZmJrlfiZxjF/baSADfp9jgEPIRHrZKR5joq21vGxe+U9Wl9eh/nOky46dT5
         1YL3RbXZ+etvPEKH8kHMe5ee5f5m+HauLzLzRPOKKyhJL3Wr3Ppy7ABySNpv9aZQ/38f
         ovKfW7tiFK16nidWL+LI/tEMtD8EeOlmuXewx4+k+Yp7v1LKQAasCkuRAYOx8R4p13Eu
         iA5HZiXFAEmpzvhK7Meb0+YFmzzgyDTjTec9i9uJEq3tj106EGQzWJfzkei1/jFYda9b
         aicnHpsmSr9pd8Ar+bZjVoZBP7aynbnnvzaOaENl6yvReVnecSkqYMaHRWTPjCXymqD+
         9Kmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714973505; x=1715578305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n6H04ZJ0rZ+UiGVgsYG099h9bSA0uf9CXiCVKmASq/Y=;
        b=xQqM5Qbu3t7DH5eiT1td3HRLhRSv2VAoy+6BiHeb96Yf+igSbOGBYnugaJi8DLdMJK
         EIfzxl+jrHfICaJ2PD4oqtOJi4/RtpHGTpvso5kCfzcpxntJP4Is8eoWkGqMvUDrmaVX
         xMWcT7yuSvtLyQbEwAx/lcOBbgQyiDLKXA0SxduUL/S4OfiomJo4Leu/Nie2s+mQoIP9
         ErlrQMcGWyL+T3Epus2J+1T/5kCtN5dkNplGqr8FUB8x0t+YwNS7sgmtpvSdcpcucsWq
         3gu2Y8UR/XsVS/wLDa4X26EUSLhKkKKhZncf0gVQyM78r/SgzojsTMclY2lDaFDOpgqS
         L3/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXxLWcThKFOoApfiEazX3r4gYjnQK5sjUy/mR8XJe1tYScD/S/Fe+FTc1tVpqULJcKluggURsZnleqMdHLnWL//IxxQ
X-Gm-Message-State: AOJu0YwnYyHoKQ4PfBTqAzGC33jLxhRISzhou/azTHooamMWGXIw0oTF
	fgo3tsoHY5X+juEIgJxjGf5Il3Vw0T6xy8zzOXit1OgVpXYHzfVpkXy+C3N2lLl1OIlxz9O84Sd
	Ng+SvSg==
X-Google-Smtp-Source: AGHT+IEmLxPOoCJPiggLCMbYGTg3TFX0hbToInK1+lAcbfmdqB2YXkGuGmvR0MnJ99c7k9V04Ni2T4a/e+Gz
X-Received: from mizhang-super.c.googlers.com ([34.105.13.176]) (user=mizhang
 job=sendgmr) by 2002:a25:aa73:0:b0:de5:53a9:384a with SMTP id
 s106-20020a25aa73000000b00de553a9384amr2838673ybi.13.1714973504994; Sun, 05
 May 2024 22:31:44 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date: Mon,  6 May 2024 05:30:06 +0000
In-Reply-To: <20240506053020.3911940-1-mizhang@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240506053020.3911940-1-mizhang@google.com>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
Message-ID: <20240506053020.3911940-42-mizhang@google.com>
Subject: [PATCH v2 41/54] KVM: x86/pmu: Introduce PMU operator for setting
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
	Yanfei Xu <yanfei.xu@intel.com>, maobibo <maobibo@loongson.cn>, 
	Like Xu <like.xu.linux@gmail.com>, Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org, 
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
index 485bbccf503a..aac09eb9af0e 100644
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
2.45.0.rc1.225.g2a3ae87e7f-goog


