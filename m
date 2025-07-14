Return-Path: <kvm+bounces-52395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 090D4B04B82
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 01:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6087A7B1C25
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 23:04:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC752BE639;
	Mon, 14 Jul 2025 22:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P5TL3jlq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020BD299950
	for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 22:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533997; cv=none; b=prVRNw6CazduvbWDSzbycJHWLg7Fcr68MQZKvhfEhckSVGS5eUYPeoZvvGuV199h4a2WZC5qdPXB/aC27fO9P4qPb6ig343Nnvner2kSlEaIWA/0Mb0YUZ7Yfiav7ePxfL3gvfcLmARCuIHs9Z7BhAsJ9p7U7hsiYU6vqhOa5VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533997; c=relaxed/simple;
	bh=+QrD5N262WMEkEIDCLEn9xsl1UHsD+B3fLJKnajCte4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NUHm18XYPwD7MVahpdTR20irk1SWuhVgMKPi+CIGA6O7bA/Ja0Ccg12yXHBwj7HrUls4C5kyaIXTWBSpbf+6iaH+P9lp6KKZ47CGF8150IsvE8mwq1Trr2l5loHVGIr9z21PVX/TU9aaYLfMlwcztP6SGfXU5JbV74kOPuV3xcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P5TL3jlq; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-876afa8b530so534981039f.0
        for <kvm@vger.kernel.org>; Mon, 14 Jul 2025 15:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533992; x=1753138792; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ssu6XVTznYXQ2t7039xq5/RphL9Rc3QnEHfinMHeLm8=;
        b=P5TL3jlqGj71fzMw7fn1NREEzoRpkXw7o8eVnT9N88XuYYt5cTTTf4d4JfGl2CKsyl
         ZZ48pS84iy0plGNbXkB8lxHjK4OM+lmPzIgMQJxYameO4UfO+2iB3Wop7QFHXqDGKGu+
         cogEOuwIoBJmDgXH6DkeD4feaPUXAqToKvnPsrhFHwDdFpT8C6YT+mnb3eUQoz6QK45f
         sohA7wLJrEugUCad9EviUR7oeY0JS9a2iVsXX/gJ30SLD3Yf4FeJOijgT9/21W0d15bi
         BkNP6qYErUn4Dsk6BmU2kjSyBHU+bJWUkEF7LXXTJqpdqhO/ujJhJ5GyeKcUlO6/Oq5H
         6j/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533992; x=1753138792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ssu6XVTznYXQ2t7039xq5/RphL9Rc3QnEHfinMHeLm8=;
        b=RbDtovIL2fgjss2VbA24BiQGsg4/10z+QxHaqOGI6r8hVkLrWahP+edvPouc/qcVkf
         1xCoCLJ8G9hHMGYGEiOw0608O6OtDUZC8Lz7HiOmmOB0aWh3IdC5GWono2OccTbTLzt1
         KPsX2TdN4O/8FYsV/oANcM6rWiZ81j4rTpDHTfkjR61uy/gzFcejnYl8PR2/giiVHAvM
         izyIVncHCg0bJPgngnvczTgL47KN8jQ+Lckus15RpdyJN35q1Q30HyqhwvB3EfZZEHy0
         jgydf6XAozgcQnSCnb0N87Av84vKf6xMzsFeLlqL2aZaLk67kv+jioSV4DUzXpqoNipL
         mGSA==
X-Gm-Message-State: AOJu0YyOeuny5RQUD0Isw+A+JkHKXyzzXX8vV/cr4Mt41P7dSiWfKP1H
	2kECPb0hy4TLnrVNbgSNBi6QHLwFUBqyzuj5iVxHWsXlVg1zffUqaUyc3z9UA/ektO42d/bCTZW
	sVR/i4rEaTBfyUExjGm/wP2QoV7XK2cct2sSokUu7WXSXNeOCATGpwO9XVC4N62ybJUtYFn0ieo
	58jg2XRAy2OH7WsiceQNjSILignb/fap8vsx2qjoIEXqYXFBz3NOAP9XNXqWY=
X-Google-Smtp-Source: AGHT+IGDw6Aiqn+peGv14I4uiw/UfAz/LnaAwVzpsB+zhVreBKr6TdqJGcvfwIs5Vp6INunAGafxrdf30hBME2OE7w==
X-Received: from iobbk15.prod.google.com ([2002:a05:6602:400f:b0:879:8855:695f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:4019:b0:876:7876:a587 with SMTP id ca18e2360f4ac-87977e98946mr1665405839f.0.1752533992118;
 Mon, 14 Jul 2025 15:59:52 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:15 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-22-coltonlewis@google.com>
Subject: [PATCH v4 21/23] KVM: arm64: Inject recorded guest interrupts
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

When we re-enter the VM after handling a PMU interrupt, calculate
whether it was any of the guest counters that overflowed and inject an
interrupt into the guest if so.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h |  2 ++
 arch/arm64/kvm/pmu-direct.c      | 22 +++++++++++++++++++++-
 arch/arm64/kvm/pmu-emul.c        |  4 ++--
 arch/arm64/kvm/pmu.c             |  6 +++++-
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 6149eb051ff9..908e43416b50 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -87,6 +87,8 @@ bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu);
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 3f9e0d4a74e1..80a3eb89fca1 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -280,7 +280,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	write_pmcr(val);
 
 	/*
-	 * Loading these registers is tricky because of
+	 * Loading these registers is more intricate because of
 	 * 1. Applying only the bits for guest counters (indicated by mask)
 	 * 2. Setting and clearing are different registers
 	 */
@@ -356,3 +356,23 @@ void kvm_pmu_handle_guest_irq(u64 govf)
 
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
 }
+
+/**
+ * kvm_pmu_part_overflow_status() - Determine if any guest counters have overflowed
+ * @vcpu: Ponter to struct kvm_vcpu
+ *
+ * Determine if any guest counters have overflowed and therefore an
+ * IRQ needs to be injected into the guest.
+ *
+ * Return: True if there was an overflow, false otherwise
+ */
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 mask = kvm_pmu_guest_counter_mask(pmu);
+	u64 pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	u64 pmint = read_pmintenset();
+	u64 pmcr = read_pmcr();
+
+	return (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
+}
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index bcaa9f7a8ca2..6f41fc3e3f74 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -268,7 +268,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
  * counter where the values of the global enable control, PMOVSSET_EL0[n], and
  * PMINTENSET_EL1[n] are all 1.
  */
-bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
@@ -405,7 +405,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 		kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
 					  ARMV8_PMUV3_PERFCTR_CHAIN);
 
-	if (kvm_pmu_overflow_status(vcpu)) {
+	if (kvm_pmu_emul_overflow_status(vcpu)) {
 		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 
 		if (!in_nmi())
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index db11a3e9c4b7..d837cb8fef68 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -407,7 +407,11 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	bool overflow;
 
-	overflow = kvm_pmu_overflow_status(vcpu);
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		overflow = kvm_pmu_part_overflow_status(vcpu);
+	else
+		overflow = kvm_pmu_emul_overflow_status(vcpu);
+
 	if (pmu->irq_level == overflow)
 		return;
 
-- 
2.50.0.727.gbf7dc18ff4-goog


