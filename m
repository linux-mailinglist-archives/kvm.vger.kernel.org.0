Return-Path: <kvm+bounces-54183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DA43B1CD1D
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:10:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3464A3B0938
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:10:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9D6A2E267E;
	Wed,  6 Aug 2025 19:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DdMX0++t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22A42E11A8
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510326; cv=none; b=gVaFzwOY4NDuif+E6XjNBpBRMbTLHNiHbyGKPDeyZMj9o21cSncBCqSQc7ZoTw5X37iBV4nY79Oh68rZBpqD76mbvdhVc9VgALd3jZiXCzEx1EBPj7v1gk7DIu82A545B7phR9RLp+/fRnkqIWfuqp2l47MNxxiCmZi01RaM4gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510326; c=relaxed/simple;
	bh=xxEMYMafoH1hCuYfyuUxc0eXfBZ4HMKS++5sGsaBrpM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rJgpU5t+5p8Emrlvf20LL0ci7OOeMypJnC1zDD9E+AAw6x79pwSjVHKp9dQFMg5mXptpGDsRi36h5GKG9qWc6axvbPxSXIt7fs3k9mBBn4Jg30EhL6DZ87ZOoJSNmVFCVGGTE6e3y/dWZcUTvyvlNtkYE5rWpaoDfXLj7wtcd/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DdMX0++t; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3928ad6176so130429a12.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510323; x=1755115123; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AqSoz/ys0/nDwriVLA2HvcSasFXIo2nt11bZwmhw7W4=;
        b=DdMX0++t8TEps43r4L+BtI7kaHxLQ23a6EcGQADh64fVkngAr1srAI1De2hl8ngyEe
         3JFAGghDRRDhlOAcvP9QpeZp3jcHVJbnVRuqa+ZNKHu5SWTgBI6TeEbI9Mx4vJqKE+qj
         lNKy41AZYlLdc7rC+TdxoxcLxexH+rTAvSdcLSshVJd+brdol6zZpIB9FkD3douITXXU
         dfBmyHBMkBvqtcLwXMPwU8dOixdNW81FvNoRfNABw4tecv3qPuj3ko3EoybKTrIdQdqs
         QzD2e5nYosvcuOZCWJ/SUPk8M9KqkXlTqkiaNBB3Z4CS+Y0jS/0Z3PhIWzugklE7aT/u
         Ar1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510323; x=1755115123;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AqSoz/ys0/nDwriVLA2HvcSasFXIo2nt11bZwmhw7W4=;
        b=Z7LSm1t49sEmxx48ezDxMTjWyGSix5dOgMYCvTAFJCIXOVO0XXVBTAVb86pd36hYS/
         pNhRzllVLGw0/nE5fKM644d3jKbUDl2I7bLDVPM3t9uhGxkLnpYvb2Vvt5a7qb70k3nb
         mVUCc/mxOSmXFk7OhN7zOJrZB4u5nyMA9l0NPEi0PzlSxhCsLqOa6QJnjBeWzkhgk8wI
         Q2mwORsFB1DdEVtPIJkp0fyuWFU34kvPNA+YUSw56IQK8qTLjrs60pdwlmIAFQmoX2Dq
         DLOjNonjRyCtT7gHEg0/GFbhZGnJA4Sgo5/MaXDoc8MuRng5RiXcuW380xsUuNQElq5y
         TjeA==
X-Forwarded-Encrypted: i=1; AJvYcCXciLT32+cIjtpOjg3yv0kAllozTbFrT+NaZedJJNetQH8PW4hPShQYx0ni4pC9wwsX/iA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7VU7RGyGUzOuB0QByv0MC9d2zqNYl0TFMLIyD1sNOXs6JUeDp
	Y/zQOdZslbVT+PwxZNNkizYYjksuZdqeE4ej3z8kHimKFhEfb1DE94LJbefIGvYhFAQG3F1mD7X
	Th6pGFA==
X-Google-Smtp-Source: AGHT+IFhegW1gGR7UHrSJevPOd3ITDk2k4F1jYjU8AgzTqj6JmCrtpCZa2eEdv34H9OVmz6MG3yGyWC8HfY=
X-Received: from pjbsx14.prod.google.com ([2002:a17:90b:2cce:b0:311:c197:70a4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c09:b0:31e:3bbc:e9e6
 with SMTP id 98e67ed59e1d1-3217638fd88mr438488a91.19.1754510322909; Wed, 06
 Aug 2025 12:58:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:57:03 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-42-seanjc@google.com>
Subject: [PATCH v5 41/44] KVM: nVMX: Disable PMU MSR interception as
 appropriate while running L2
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Kan Liang <kan.liang@linux.intel.com>, 
	Yongwei Ma <yongwei.ma@intel.com>, Mingwei Zhang <mizhang@google.com>, 
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Sandipan Das <sandipan.das@amd.com>, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

From: Mingwei Zhang <mizhang@google.com>

Merge KVM's PMU MSR interception bitmaps with those of L1, i.e. merge the
bitmaps of vmcs01 and vmcs12, e.g. so that KVM doesn't interpose on MSR
accesses unnecessarily if L1 exposes a mediated PMU (or equivalent) to L2.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
[sean: rewrite changelog and comment, omit MSRs that are always intercepted]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 47f1f0c7d3a7..b986a6fb684c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -627,6 +627,34 @@ static inline void nested_vmx_set_intercept_for_msr(struct vcpu_vmx *vmx,
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
@@ -724,6 +752,8 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
 					 MSR_IA32_MPERF, MSR_TYPE_R);
 
+	nested_vmx_merge_pmu_msr_bitmaps(vcpu, msr_bitmap_l1, msr_bitmap_l0);
+
 	kvm_vcpu_unmap(vcpu, &map);
 
 	vmx->nested.force_msr_bitmap_recalc = false;
-- 
2.50.1.565.gc32cd1483b-goog


