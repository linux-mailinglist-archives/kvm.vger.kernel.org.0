Return-Path: <kvm+bounces-54163-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0007B1CCF0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:04:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A757A18C58B0
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:04:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708D02D8396;
	Wed,  6 Aug 2025 19:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BGx0X2k/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2192BE044
	for <kvm@vger.kernel.org>; Wed,  6 Aug 2025 19:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754510291; cv=none; b=NfHYnzESJEff5G7I4hCtxwqHe8e5KV7b2kocUxhyLtxwhZmfTPI765q7/HdYIJKx9zNPgDriL98qX8FwlSIAZDzRPELlD29dd0qazDMWvZp6shiQRV9U81lbGFW3LB8fxYpJd6BOHXYl9xMOqXd5YzYKqaaWeSSwveHYe12xbd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754510291; c=relaxed/simple;
	bh=C53ygBWjsMP+UcUorpUgoXrWlq5dJSRuSmIlt0jKd/U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OIm1TKFWPSDlzPhnY0T3q7alg8owyEsRKkbTXYfyTJfG7b2IZIi26qa51A2e6jihQHJeqhOnmWmvkSXOh2tvKz60XlMEK04cz0us6WgowyhUQkErP7OaArJiGJD+q+qXIO8PBix3NDeqzOzVDHkOiPVMYw8WUM91NhXkMz7F+LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BGx0X2k/; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31eac278794so251727a91.3
        for <kvm@vger.kernel.org>; Wed, 06 Aug 2025 12:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754510288; x=1755115088; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=x5qdlfMt7f/v/zSfpvn0pZJb5j/BJcw1RvQoZStHDYU=;
        b=BGx0X2k/F+R1x1yZosxwA7KSbUSa40GEAi1KWMmNGvwh8PHnwr3d4JNvHe3UdiH2nU
         dM9gT99CwSIMm7skf/4bX6VZMfvV2FKF/htnbu6/g0lbS2ppNryTGUgq8m6WDppUBMfm
         YIeezq2Jl2X/6iJHxMPxYpeB1UImS4ZeDYs+PRLIQ9YfhI7mt5EsXHfhHpOWF6LF3xts
         MoYVgo/46US2PizxKvwDrpE42zPapC2JVtGe0PylRPivgvy4Tn4xLfjY1IurVkKa6mh9
         8xy0WGAwdgO+jB/dK5sLkVFBi9peZqSmZEbD0TUQCZKpOh+T3IK0j+3bDSqOvlwDlaX4
         94CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754510288; x=1755115088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x5qdlfMt7f/v/zSfpvn0pZJb5j/BJcw1RvQoZStHDYU=;
        b=sH06XH6viZP4BYzajphn6Frd3Kd6m7GewOW4cxT4zoT4B7A3C8gPBSl0XQBS+jPI40
         q5u/sSw/5E6zC/bTOd26fOqrOxNXtGZBaf4ACGzJg8ZaesIwxrC3TaKPGRiQmJN/kU0s
         fWqISTAae6DLdYS8zy8EretQrx9BNcD/9Bp+GPiIk7DSuubgJgLuE62Qe1LyfW0phhSo
         kwTj+BUxw1uZ+ZWIk+JR0YLm6rgdJdFofLb7o98lJ14A19PXbgKJYg/L7Z5WLiXIszhA
         of0Dw+DDfJCVaRGxpCwTOrvlV7T4/V6r5ASeGpfQnidQJRHyMbVoj+RShqRfqsyIXNdM
         l+rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuhlnVTab6RQESuEMQhluW8glNGH6o2W2pg+lYjpPRo/3CN4ULceFCJsfbmw/8urNwl1w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5IjC+/7YMmAIYagobEpzVJ8YfU4kZ5VT7RAqnEWasbB/QrmJd
	ZeIcZhvVcOXzSFdcKjfBt8pV6LFpbLD93HeO0hx6z3wPs/WjiPQfjzSzHSl5e3iFlccjChMYA/C
	7Nfvgbw==
X-Google-Smtp-Source: AGHT+IFfF+d9RBweWfYhERWBY7pftrU4yG2unJrGI6enSH3CQtm8m01r3mZaRpes0DVZoNbRLzozGADRUKg=
X-Received: from pjbeu16.prod.google.com ([2002:a17:90a:f950:b0:31e:dd67:e98])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac1:b0:31e:f193:1822
 with SMTP id 98e67ed59e1d1-32166ccac82mr5178351a91.28.1754510287763; Wed, 06
 Aug 2025 12:58:07 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  6 Aug 2025 12:56:43 -0700
In-Reply-To: <20250806195706.1650976-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250806195706.1650976-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250806195706.1650976-22-seanjc@google.com>
Subject: [PATCH v5 21/44] KVM: x86/pmu: Register PMI handler for mediated vPMU
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

From: Xiong Zhang <xiong.y.zhang@linux.intel.com>

Register a dedicated PMI handler with perf's callback when mediated PMU
support is enabled.  Perf routes PMIs that arrive while guest context is
loaded to the provided callback, by modifying the CPU's LVTPC to point at
a dedicated mediated PMI IRQ vector.

WARN upon receipt of a mediated PMI if there is no active vCPU, or if the
vCPU doesn't have a mediated PMU.  Even if a PMI manages to skid past
VM-Exit, it should never be delayed all the way beyond unloading the vCPU.
And while running vCPUs without a mediated PMU, the LVTPC should never be
wired up to the mediated PMI IRQ vector, i.e. should always be routed
through perf's NMI handler.

Signed-off-by: Xiong Zhang <xiong.y.zhang@linux.intel.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 10 ++++++++++
 arch/x86/kvm/pmu.h |  2 ++
 arch/x86/kvm/x86.c |  3 ++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 4d4bb9b17412..680523e9d11e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -155,6 +155,16 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 		perf_get_hw_event_config(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 }
 
+void kvm_handle_guest_mediated_pmi(void)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (WARN_ON_ONCE(!vcpu || !kvm_vcpu_has_mediated_pmu(vcpu)))
+		return;
+
+	kvm_make_request(KVM_REQ_PMI, vcpu);
+}
+
 static inline void __kvm_perf_overflow(struct kvm_pmc *pmc, bool in_pmi)
 {
 	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index f5b6181b772c..e038bce76b9e 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -46,6 +46,8 @@ struct kvm_pmu_ops {
 
 void kvm_pmu_ops_update(const struct kvm_pmu_ops *pmu_ops);
 
+void kvm_handle_guest_mediated_pmi(void);
+
 static inline bool kvm_pmu_has_perf_global_ctrl(struct kvm_pmu *pmu)
 {
 	/*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 396d1aa81732..2c34dd3f0222 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9693,7 +9693,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		set_hv_tscchange_cb(kvm_hyperv_tsc_notifier);
 #endif
 
-	__kvm_register_perf_callbacks(ops->handle_intel_pt_intr, NULL);
+	__kvm_register_perf_callbacks(ops->handle_intel_pt_intr,
+				      enable_mediated_pmu ? kvm_handle_guest_mediated_pmi : NULL);
 
 	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled)
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SW_PROTECTED_VM);
-- 
2.50.1.565.gc32cd1483b-goog


