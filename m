Return-Path: <kvm+bounces-65417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AB054CA9B6D
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:31:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 036C231EA2A6
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:28:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B98C2DF13E;
	Sat,  6 Dec 2025 00:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U6K8xVeK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7A92D8771
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980298; cv=none; b=Lv6hIgqfRnG2fqlqYDEuN1vaR25YpKOzlpROSvXNqiQ6dqxUPs6lT60CkR68cJy/tMStJM8nl+sX3eB9TXfVaRlLEfupoIAuwB0lmVqaaSeDjebytjJ5M0jkEOODA6xv+FOEmcIrteCqHK1x2pdy515KNZDw7+6AndZ4I6zjjY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980298; c=relaxed/simple;
	bh=Pzy06uwQwl662SZzAhKp4ZgGhpYEW/xfdtfXTkdDh0E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BRWgk3kdEkH0nOXtg6cKRz+U1i1/lARPpcd1RVdmBDGQEFFBpgXOOhDBwAiFOVN4WECAffnr95oA5qjWgkVUd8eYJxzSCFsfzP4pmoFbPMFaOWE7zO1e46r+Ttgf37qj5RrG6ZxKxCyknuObwMQr583FV6ThcGfFdbeiA0liQOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U6K8xVeK; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34566e62f16so3090065a91.1
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980295; x=1765585095; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0NKuhyI73DcmRDf6dJr4Yp2dlSnDCvKYnr68Tztb6CI=;
        b=U6K8xVeK3hqhGdDCpbZJH7RkcPnBYjxMzFiJWqxlXRybzO2Oy3k3R7Z5ixbPJgpmri
         hP+ZR/OPaCWEa2eXOzWx4qnLHipFkQphPpHUjCIcecAjYJCMsKH+jRhhjPExSPqWfBoJ
         Tc3XlengNsjyMp3QfQheGRhaZLLb/KSVb9nhf1z97XpuGtN4DRIUvXCII82T8nxlL7gL
         ziCN65iYGbMkV2wGpiaFB7z0fvDhELG06pgA+w/QNSCbdmoIYB3mJAmwsB2utl6q6FlR
         scMTYG6T25xGPRQ9HcGdy59fSfw596mNM1ao6PMALBT+VWw101xfocSgeWz521TluI0O
         kpBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980295; x=1765585095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0NKuhyI73DcmRDf6dJr4Yp2dlSnDCvKYnr68Tztb6CI=;
        b=He8rh4AhvKFFYrOUyclMbnz5t1xeoZYhYVZTC+WU3sxMv2DW41syEwU/w1j9C4K1CB
         o9nBZZueeHAYhQBSoLb+sOxp7WHXCzZDREU3dMtfvCslOE9EUOpoZlXjZn16uI/5Gxj9
         M5r7fL8aq+JXyjh3ELMTJKUgAL9kTUA35sp3BLe+B5x0TZ1EZqyAvBSske5C/JtRSVA6
         p+mtC1aGmNKYzW2QULxPGLsPLgjkZv9PkahAch8P2irEED2mAgdcrvCqJvj3Haewds3t
         VWgeXvFbKHA+tabL21JQe3h9M0Ukiql8wpQRayb4vyOe2HTnTMVzujghvj6B+IbeWJ4i
         /H+g==
X-Forwarded-Encrypted: i=1; AJvYcCWhcnh5FW0tMTVjEnJm6NgF9y+mOuiQ8yLZmXtgyTTMiqvgby9rZUhmLjHYyadawtwJzEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRy/XGfFwFx/7X6HthPNWPQZGPmitE2ybR6XP9DkVp7ekG+Lyg
	htn9zNvsh9DvP/FFb2idLi3YiNJaaWmej747hOix+CGLfCaGLLKeLkDcVIG7VTAM0YEBz24z24T
	klnbNZw==
X-Google-Smtp-Source: AGHT+IEu368Ymit6Wf714y2QoU1WaQ4whiXftg8ijTgUsFOrrwNXh1LyvlB+ZwNskFSucsIG3f0JlRtM2cA=
X-Received: from pjoa4.prod.google.com ([2002:a17:90a:8c04:b0:349:6296:2bb7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3bc7:b0:340:d578:f2a2
 with SMTP id 98e67ed59e1d1-349a252b381mr638790a91.6.1764980295195; Fri, 05
 Dec 2025 16:18:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:00 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-25-seanjc@google.com>
Subject: [PATCH v6 24/44] KVM: x86/pmu: Introduce eventsel_hw to prepare for
 pmu event filtering
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Mingwei Zhang <mizhang@google.com>, 
	Xudong Hao <xudong.hao@intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>, Xiong Zhang <xiong.y.zhang@linux.intel.com>, 
	Manali Shukla <manali.shukla@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Mingwei Zhang <mizhang@google.com>

Introduce eventsel_hw and fixed_ctr_ctrl_hw to store the actual HW value in
PMU event selector MSRs. In mediated PMU checks events before allowing the
event values written to the PMU MSRs. However, to match the HW behavior,
when PMU event checks fails, KVM should allow guest to read the value back.

This essentially requires an extra variable to separate the guest requested
value from actual PMU MSR value. Note this only applies to event selectors.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/kvm/pmu.c              | 7 +++++--
 arch/x86/kvm/svm/pmu.c          | 1 +
 arch/x86/kvm/vmx/pmu_intel.c    | 2 ++
 4 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index defd979003be..e72357f64b19 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -529,6 +529,7 @@ struct kvm_pmc {
 	 */
 	u64 emulated_counter;
 	u64 eventsel;
+	u64 eventsel_hw;
 	struct perf_event *perf_event;
 	struct kvm_vcpu *vcpu;
 	/*
@@ -557,6 +558,7 @@ struct kvm_pmu {
 	unsigned nr_arch_fixed_counters;
 	unsigned available_event_types;
 	u64 fixed_ctr_ctrl;
+	u64 fixed_ctr_ctrl_hw;
 	u64 fixed_ctr_ctrl_rsvd;
 	u64 global_ctrl;
 	u64 global_status;
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 621722e8cc7e..36eebc1c7e70 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -902,11 +902,14 @@ static void kvm_pmu_reset(struct kvm_vcpu *vcpu)
 		pmc->counter = 0;
 		pmc->emulated_counter = 0;
 
-		if (pmc_is_gp(pmc))
+		if (pmc_is_gp(pmc)) {
 			pmc->eventsel = 0;
+			pmc->eventsel_hw = 0;
+		}
 	}
 
-	pmu->fixed_ctr_ctrl = pmu->global_ctrl = pmu->global_status = 0;
+	pmu->fixed_ctr_ctrl = pmu->fixed_ctr_ctrl_hw = 0;
+	pmu->global_ctrl = pmu->global_status = 0;
 
 	kvm_pmu_call(reset)(vcpu);
 }
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 16c88b2a2eb8..c1ec1962314e 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -166,6 +166,7 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		data &= ~pmu->reserved_bits;
 		if (data != pmc->eventsel) {
 			pmc->eventsel = data;
+			pmc->eventsel_hw = data;
 			kvm_pmu_request_counter_reprogram(pmc);
 		}
 		return 0;
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820da47454d7..855240678300 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -61,6 +61,7 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 	int i;
 
 	pmu->fixed_ctr_ctrl = data;
+	pmu->fixed_ctr_ctrl_hw = data;
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		u8 new_ctrl = fixed_ctrl_field(data, i);
 		u8 old_ctrl = fixed_ctrl_field(old_fixed_ctr_ctrl, i);
@@ -430,6 +431,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 			if (data != pmc->eventsel) {
 				pmc->eventsel = data;
+				pmc->eventsel_hw = data;
 				kvm_pmu_request_counter_reprogram(pmc);
 			}
 			break;
-- 
2.52.0.223.gf5cc29aaa4-goog


