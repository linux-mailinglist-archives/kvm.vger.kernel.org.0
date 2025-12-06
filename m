Return-Path: <kvm+bounces-65412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DD839CA9BF7
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 01:39:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 76F2231983F9
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 00:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30E7B2C235B;
	Sat,  6 Dec 2025 00:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r85hU2PS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B8324E4A8
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 00:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764980287; cv=none; b=opj9D5TngfWx3EsLBe4P6wLcX3G5UBrb8bm6ZCxwKgXiWSMUajGK8pCa39LRnt8v18sZg662/EQ3ZuqX1ziMPn2htI4MQUK1wpiVwF5L+CIZ6yXoSR1HDyIwUJaXoz/0+/GdWI+c3khNfRbnXBz9cjSrTWYtElRJ9VmG7EupPUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764980287; c=relaxed/simple;
	bh=+5rvOQQEmWi8zXJY9jqrXtHF9NbwN3EkEXKXWn4uwVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nJ/7AdP4IK0cS8J0uPgD9D8FTr7a9J4Gs18QmqO9v3HouNR0UClH87DtruXjQoBMWeVD2nzFJBvqf7VaQ8rpeeHFi99wS48lpPBg7cKSQTaH8GZqdKPLTPRr7qj1xpkOvfEy6MXlBNiZ7DEkaIWkncetd240fg4rF7Z+gox0jOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r85hU2PS; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7b8ed43cd00so3148822b3a.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 16:18:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764980284; x=1765585084; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Updb/Jfn2dAHBrhkdzkPSsR6YWK/TllPUiDQA+O1aSA=;
        b=r85hU2PSGYrGRH+SzXBDxfmq2Jp5ipUFbFSdQYvpDt8wsRm2XHTtVJVfWhtQnAzTEb
         vwAW0emhK/5y48p4DdsrdG/yEuS/EqAheVtfA86TIAXNrqvrCsVNh4nowh2yJ6MxEMUf
         TTYMJtGQ7QGJjxjAkbMAioPY4ZyBqHVl7zyziXTgx0i3rKudjIgpdLxjWST5I9WGov4v
         OJQd/Ii7SwuahL7qwPY34fiT5zTwCU1OFUrFqlJ283fbdJ1RpBgYDLweVPKJfUxiZloq
         ZiTX5pXOV79cmM16S/Wy6d+mWm1+CyEObotQyessdvUKNGV0sWgiCjATrxA1r0mlMkUy
         wyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764980284; x=1765585084;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Updb/Jfn2dAHBrhkdzkPSsR6YWK/TllPUiDQA+O1aSA=;
        b=DGKu2aZ2Hefo4q1J4Ru0KpiTLczzVbIK1ybtw2qixrU3QnM81eATY/Qavc0rA/DOX4
         lIGEmCoQritgvLJGbWt732Vy/WaljBOIQvToiPyjeEEift8vZYkssDdc/ZQ8VQF/KQ13
         J5lHK4WEFBDqfxBdtDDTbmGi+W9SQNwja+oNsUlFB6nLXSIfHnh9KJ0NtTeDiVopk4oY
         OgUJvWBz01qyVmq3zLlL3ji7vIuebsLFE5Gu++s4BwEOt8RVvkwNvZLAn/zJiDWEYil2
         y2LwGwjj5TAntpYOGRCRcYvq0OoSq357sLI0N+s9RmnkmLe6jqBGaSzayl/QMWdKTakv
         dMXg==
X-Forwarded-Encrypted: i=1; AJvYcCW3KZSNq1QXORt/RovhYtlqsT7AfV1NXCE3YkcJBeyzYM9IyZ5SYp51SJs40b9cDxXV770=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmmJPmUEGD13udeGUxUuZMNPEHVr/2Sp+FfUUdqqe7aa4sUVPu
	2w/KNpOutuaLNAGjjGpRIH7WhVy62nYcZaNN60o9Uf26nR4MbLTx1WbKMWjFIDU0EF5Q+hcZAUd
	rAAw7tQ==
X-Google-Smtp-Source: AGHT+IGmx8a/eJZmORgvkEWVhn/uP5dbhmnIbP0XRDK0XcrnLs6A3LdHJHErdqkr+RZXqUaApvjJvO7ayAk=
X-Received: from pgbdp3.prod.google.com ([2002:a05:6a02:f03:b0:bc8:5648:d6bf])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:8187:b0:366:1a2c:6f91
 with SMTP id adf61e73a8af0-3661a2c7805mr309067637.4.1764980284548; Fri, 05
 Dec 2025 16:18:04 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 16:16:55 -0800
In-Reply-To: <20251206001720.468579-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206001720.468579-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206001720.468579-20-seanjc@google.com>
Subject: [PATCH v6 19/44] KVM: x86/pmu: Register PMI handler for mediated vPMU
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
Tested-by: Xudong Hao <xudong.hao@intel.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 10 ++++++++++
 arch/x86/kvm/pmu.h |  2 ++
 arch/x86/kvm/x86.c |  3 ++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 0de0af5c6e4f..b3dde9a836ea 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -159,6 +159,16 @@ void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
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
index a5c7c026b919..9849c2bb720d 100644
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
index fb3a5e861553..1623afddff3b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10111,7 +10111,8 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		set_hv_tscchange_cb(kvm_hyperv_tsc_notifier);
 #endif
 
-	__kvm_register_perf_callbacks(ops->handle_intel_pt_intr, NULL);
+	__kvm_register_perf_callbacks(ops->handle_intel_pt_intr,
+				      enable_mediated_pmu ? kvm_handle_guest_mediated_pmi : NULL);
 
 	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) && tdp_mmu_enabled)
 		kvm_caps.supported_vm_types |= BIT(KVM_X86_SW_PROTECTED_VM);
-- 
2.52.0.223.gf5cc29aaa4-goog


