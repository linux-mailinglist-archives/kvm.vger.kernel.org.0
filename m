Return-Path: <kvm+bounces-65612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E058BCB12AB
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 22:19:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E0AD3167C73
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 21:17:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E6FE3128A1;
	Tue,  9 Dec 2025 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UJW7uWDB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D028730DEA0
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313578; cv=none; b=spZEB5UHvF2esrChh2ZwoYryb/x+VWFr9dj4dIdQ2Rdeq6gG5mU3WqO7CnT67kb1DB+f3EAYpUhxCdH/fblnXStc/9wmNk/5tsVxzyYciMTwwPfG7DuUQobaaoVFUKdQI9Bp+72B0mPVeCmqE8VungMHYH+6O4iztPvQnD40amQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313578; c=relaxed/simple;
	bh=vXep3cSR5+RW3ZaGAs8EaICvp+PDXlXKTrV3Sz3Arf0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gzOi5j+YShh+zVAXXgqbKbRsnIVM/LLH4CchzA/vRoxUduzgQ1mLVRqd9SJm00SGPib2dX/Ywp1fRsDBiPucQLB7mecNLT0Mc6l1s/kHpYp8OukeovVUNXbMTDahOZdYTBnWWj19d1eC9zCmOis5ogPHpgAHVYfG1nCZ/vJ0igc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UJW7uWDB; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7c7593b5c93so10335371a34.3
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313566; x=1765918366; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z3C+EgXBZrnvYKUsePQFPeWA6+JM50EPdZ7QjJ5U3nk=;
        b=UJW7uWDB/q+u1O0dzb6pn1hiAyGvferoZeQawIWhWDMW7xnVcTDcqzs4sXHB/KDSny
         04wVi/yvZm3AhjvruaQWt6V+Nfbui+xggqXNGvZWEZzOQCnUyGCgbTdbFw9mWBQ2cn7m
         wshbekOLEClxTYGi9KsbubntcVjaAV27sVJWhXeshugfDQ1htG5gBp3BYWf+9F1AmYNH
         HAqU9Xy50KLMWHWds3uoGdxWmTP9O7GeKAeRsdcN2w7iCL4UD3gnWi5p9bNVl8QapSmE
         j00xIyoaiqmlT2XtSPlEyqjBXls1vcFsnHw9BSd2X5SEuYSTl1R/B9aq+gy4LXIC3Ij1
         Bm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313566; x=1765918366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z3C+EgXBZrnvYKUsePQFPeWA6+JM50EPdZ7QjJ5U3nk=;
        b=FhmbsGlGfFf8u57KVFpvwUwQqUYl+iXONlaCBSAMDPbUj0UjnHApSVRgOrUOaYF+zZ
         xxgkC5yUJD8iBH5HDn0M2H4OWsaGuNDgJrLHMVkWpPP/f9uplD+cSzwAxrbbUC6jrqCd
         TSOSfXzREYSlhCQ1mgslqQrMm9GFbpvaK08iroFBP4CxBpzsxZ/CsEti6ETRyqBHZRy+
         VcQBfcgEl6lM4JujORpAVjen736GSlEh2S8ad4/4HkaPatPsHvU+N3M1ZXO5SFkeWVa7
         OjyTDBONO4S8U0ZRNm6KguSd6t1BxPkNlGQ+MB1AVc4qZ+ApWWAFMJQSC1DVrzFYQvac
         SqMA==
X-Gm-Message-State: AOJu0YzI2lVS2NJKK7crUH3TufDqqU4X2eW16FIrSU7sGlU2TC5UEJ/O
	/N0LHGs+wR0S802Fcu8zKW6mcr9eYSREQBjogVlOK+QAdKEEucb4HhgBQk01n0DSqlPHJJdw1Ih
	eFerC4up7Nf2xFeLTre+HX4uAr+r+Ryc3ltFwpBSWW52qRTQ/VoEHq+s/5ZVGsta27RpZatUNns
	6s4ARpdR4jquD6bsUwPbI9gu0QHLTUCxObqiRrCZF4epP5e0wH6IR/BS75u50=
X-Google-Smtp-Source: AGHT+IE+Q1bxOP7O2hdAR+5uvGwSUyrHQRsNxJJcZ41BmbQLJOhfNhTF9IlZ3TTqoSNqarccK80mXi5fG/4ler8rFA==
X-Received: from otbaz24.prod.google.com ([2002:a05:6830:4598:b0:7c7:307:1f8c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:7198:b0:7c9:59a5:dd04 with SMTP id 46e09a7af769-7cacec5716bmr83284a34.37.1765313566430;
 Tue, 09 Dec 2025 12:52:46 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:17 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-21-coltonlewis@google.com>
Subject: [PATCH v5 20/24] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Because ARM hardware is not yet capable of direct interrupt injection
into guests, guest counters will still trigger interrupts that need to
be handled by the host PMU interrupt handler. Clear the overflow flags
in hardware to handle the interrupt as normal, but record which guest
overflow flags were set in the virtual overflow register for later
injecting the interrupt into the guest.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h |  6 ++++++
 arch/arm64/include/asm/kvm_pmu.h |  2 ++
 arch/arm64/kvm/pmu-direct.c      | 17 +++++++++++++++++
 drivers/perf/arm_pmuv3.c         |  9 +++++++++
 4 files changed, 34 insertions(+)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 3ea5741d213d8..485d2f08ac113 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -180,6 +180,11 @@ static inline void write_pmintenset(u32 val)
 	write_sysreg(val, PMINTENSET);
 }
 
+static inline u32 read_pmintenset(void)
+{
+	return read_sysreg(PMINTENSET);
+}
+
 static inline void write_pmintenclr(u32 val)
 {
 	write_sysreg(val, PMINTENCLR);
@@ -249,6 +254,7 @@ static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
 	return ~0;
 }
 
+static inline void kvm_pmu_handle_guest_irq(u64 govf) {}
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 43aa334dce517..e4cbab0fd09cf 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -101,6 +101,7 @@ u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
 u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
+void kvm_pmu_handle_guest_irq(u64 govf);
 
 u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
 u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
@@ -322,6 +323,7 @@ static inline u64 kvm_pmu_guest_counter_mask(void *pmu)
 
 static inline void kvm_pmu_host_counters_enable(void) {}
 static inline void kvm_pmu_host_counters_disable(void) {}
+static inline void kvm_pmu_handle_guest_irq(u64 govf) {}
 
 #endif
 
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index c5767e2ebc651..76d8ed24c8646 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -396,3 +396,20 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	val = read_pmintenset();
 	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
 }
+
+/**
+ * kvm_pmu_handle_guest_irq() - Record IRQs in guest counters
+ * @govf: Bitmask of guest overflowed counters
+ *
+ * Record IRQs from overflows in guest-reserved counters in the VCPU
+ * register for the guest to clear later.
+ */
+void kvm_pmu_handle_guest_irq(u64 govf)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu)
+		return;
+
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 2bed99ba992d7..3c1a69f88b284 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -783,6 +783,8 @@ static u64 armv8pmu_getreset_flags(void)
 
 	/* Write to clear flags */
 	value &= ARMV8_PMU_CNT_MASK_ALL;
+	/* Only reset interrupt enabled counters. */
+	value &= read_pmintenset();
 	write_pmovsclr(value);
 
 	return value;
@@ -904,6 +906,7 @@ static void read_branch_records(struct pmu_hw_events *cpuc,
 static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 {
 	u64 pmovsr;
+	u64 govf;
 	struct perf_sample_data data;
 	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
 	struct pt_regs *regs;
@@ -961,6 +964,12 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 		 */
 		perf_event_overflow(event, &data, regs);
 	}
+
+	govf = pmovsr & kvm_pmu_guest_counter_mask(cpu_pmu);
+
+	if (kvm_pmu_is_partitioned(cpu_pmu) && govf)
+		kvm_pmu_handle_guest_irq(govf);
+
 	armv8pmu_start(cpu_pmu);
 
 	return IRQ_HANDLED;
-- 
2.52.0.239.gd5f0c6e74e-goog


