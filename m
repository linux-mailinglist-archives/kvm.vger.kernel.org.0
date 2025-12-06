Return-Path: <kvm+bounces-65424-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E96BDCA9BA0
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:33:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A41DC302D649
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D0C63002A6;
	Sat,  6 Dec 2025 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=google.com header.i=@google.com header.b="mnuXyLYd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65D02F7ACA
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980311; cv=none; b=GiTR/oYS3Y7lRN3q+xKBiyoSzwaPMcDHlQMoPz1fPmhVp1+ReJ0iuBfZy10v1my2eY0DvcUQajaPUbbDDXls3Vu5z3a0tM/frzJTP0DCWtceKYzIce1qPyrpzO2XZn/hfehG8GmWjWu5DXnN4Vy+r/zOKDTskebffBfUjfcRBZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980311; c=relaxed/simple;
	bh=jnmh0698KpE63YRCvIEZAjn7c1Lr7TEaV4sjEsIEpYo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qmaxf1tWcSeSXvShqyVNVKzKAgZrcr/NS2xqEHIqpvfUOd1AoIWX3LBvWoGqgFsVHZ/tTmk3DZzQ8MH90DvEMeA6DwbkLMPvIKrv+q1hTDcbQchiCa65MVFgzmRWaOTcpkLm+8BiMW48DP+epqDI1o1oe4Rn/8qmbk5N05/iGJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mnuXyLYd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34740cc80d5so5031915a91.0
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980308; x=1765585108; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4OfoQfKEgZFjrirIuizJ077/M4GdZrVaenba/hcoG9w=;
        b=mnuXyLYdBe2SGIG4Me7eq8ECbaVCwn7YZGFmEadJqEzHa63nG8JsOYQqCoUXfpeCtJ
         +2goHxl5yet7efQwGGWxpFLbeW6OKD1J9HtcnskPpG/aVrvVIKRDyxbpZL6n8lAZqKTT
         SkMBkkHWWjfWHPJIWtM44x29J0Ei3HUnSL5LWczinPq7rVf1CNIznXS9mo9y3f3rQ7+1
         QDei6BqZdyinngVDEO/rlSjfmHHFovbc8rfn/YF9+PqrkY5X2TDGW+4SKd1BAoBTYAiO
         7btDvyrO3JoejuyKVYpvXqrLVTVE1yWizlOWpXAY2GxGCRyPHn1k+tGKF3Q4wG+/VNGk
         Kp2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980308; x=1765585108;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OfoQfKEgZFjrirIuizJ077/M4GdZrVaenba/hcoG9w=;
        b=kat9/wi3yOtaw0oZvZOCzGHgbCiUU5uDXEA/5PwlmDGE0aJ65LDK+/Y38wb4bN1eir
         IgCBYmDZxGNFbSTnJ0Q8FqIHtWM4mEyfOuKx7SSDspsvVH0NQloIIuM8Ns09+ZuwOVB7
         3xtyh5NRwh7Zw/WQaMPoywCzsFTxoAIChE91iL5WmO4sbIBSTyGAxy3p1/1UqW8XYlHj
         xm0u/eOoJ30duXOSE478sDYk9kysGZy6S3e7Zfcj7hksUbvrEWur7OIO1QJ3VWdS7klI
         Ezq+s0DtWyqPgII30gwFF3X3USLrba6TXHEDuHrwTXJjzigKs91vFSk0MJHcV6l3TRhB
         /KGw==
X-Forwarded-Encrypted: i=1; AJvYcCUv6SrYRiaoczA4zQKlPIMNqnROsRayE9UuRT40S/eiXVRbX4DxWi4LaBNhaP+wONoZQIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzqRcELW+zJkGGnKMe7aOHSo3TXiCsayXE9wxPyqibUG+8qGSrr
	yNcDGWRg67lVo0wnyLTWBVNPii57ITaXJpLyAgmnDes5/qkCSekXbd3iiTh3V43qN2jDMDJPhSa
	qjrDsFg==
X-Google-Smtp-Source: AGHT+IHbD7B9YeGH7Tmr7JOXchgVNBxwJK8eblPXJXnk4Y9Y/l53ndcM8z2+XQN6T6Xmq93leyEKMn8mhtA=
X-Received: from pjbcc9.prod.google.com ([2002:a17:90a:f109:b0:340:3e18:b5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec7:b0:32e:528c:60ee
 with SMTP id 98e67ed59e1d1-349a25b9531mr659960a91.24.1764980308336; Fri, 05
 Dec 2025 16:18:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:17:07 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-32-seanjc@google.com>
Subject: [PATCH v6 31/44] KVM: nVMX: Disable PMU MSR interception as
 appropriate while running L2
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

Merge KVM's PMU MSR interception bitmaps with those of L1, i.e. merge the
bitmaps of vmcs01 and vmcs12, e.g. so that KVM doesn't interpose on MSR
accesses unnecessarily if L1 exposes a mediated PMU (or equivalent) to L2.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: rewrite changelog and comment, omit MSRs that are always intercepted]
Tested-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b56ed2b1ac67..729cc1f05ac8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -630,6 +630,34 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
 #define nested_vmx_merge_msr_bitmaps_rw(msr) \
 	nested_vmx_merge_msr_bitmaps(msr, MSR_TYPE_RW)
 
+static void nested_vmx_merge_pmu_msr_bitmaps(struct kvm_vcpu *vcpu,
+					     unsigned long *msr_bitmap_l1,
+					     unsigned long *msr_bitmap_l0)
+{
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int i;
+
+	/*
+	 * Skip the merges if the vCPU doesn't have a mediated PMU MSR, i.e. if
+	 * none of the MSRs can possibly be passed through to L1.
+	 */
+	if (!kvm_vcpu_has_mediated_pmu(vcpu))
+		return;
+
+	for (i = 0; i < pmu->nr_arch_gp_counters; i++) {
+		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PERFCTR0 + i);
+		nested_vmx_merge_msr_bitmaps_rw(MSR_IA32_PMC0 + i);
+	}
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_FIXED_CTR0 + i);
+
+	nested_vmx_merge_msr_bitmaps_rw(MSR_CORE_PERF_GLOBAL_CTRL);
+	nested_vmx_merge_msr_bitmaps_read(MSR_CORE_PERF_GLOBAL_STATUS);
+	nested_vmx_merge_msr_bitmaps_write(MSR_CORE_PERF_GLOBAL_OVF_CTRL);
+}
+
 /*
  * Merge L0's and L1's MSR bitmap, return false to indicate that
  * we do not use the hardware.
@@ -745,6 +773,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
 
+	nested_vmx_merge_pmu_msr_bitmaps(vcpu, msr_bitmap_l1, msr_bitmap_l0);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
-- 
2.52.0.223.gf5cc29aaa4-goog


