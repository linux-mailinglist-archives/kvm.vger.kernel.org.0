Return-Path: <kvm+bounces-65615-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 70CA5CB119F
	for <lists+kvm@lfdr.de>; Tue, 09 Dec 2025 22:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B9BEC30678C5
	for <lists+kvm@lfdr.de>; Tue,  9 Dec 2025 21:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 087C73126D2;
	Tue,  9 Dec 2025 20:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p8yCYit0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9594C307486
	for <kvm@vger.kernel.org>; Tue,  9 Dec 2025 20:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313579; cv=none; b=UCosvhAP7f+HOPgk1fmOB6AO6gWpwekkm5xilJ1Q9tz/dyIQuINn+vx5Ix25x7j6TVmq/Aeb1TYHIdMnmLOAjEVgJLHFy4XTNjzKGeHcrcac+bGB9KuPJY3GXfFbxJTx+NC2HdzQGcOCNH8HkSfNBYRfqhTyN4+cSDhNL3rCSJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313579; c=relaxed/simple;
	bh=0i/XVALUfLVfonlnN8cOfbbK0RivHhuamyQe6SmIzEY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lw10B1UvlEDSLh03E6lerE48WdWNvlzxtu7ArE65bV6qG+EnYYgMQAKRh1AwTxHCgE+ip4nDOd5j2aeeXd3Wr2W/thuQqOzh7raBD8Fz5Y6ahBAxQfF6PAiPR4hii8Makk9xvUY5ZVikR2XSugt6JP7oJL+LoZ334CvVz8gsSh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p8yCYit0; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-3ec7ae153faso3972233fac.0
        for <kvm@vger.kernel.org>; Tue, 09 Dec 2025 12:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313564; x=1765918364; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ihXpQp4YbEFBpuWRcFtm84jVRjsgBgDbq/Ms0l8x8e0=;
        b=p8yCYit0q0/NYoK/RSE56lgArZmffC2RUnjc3avCDel7JbfOtadDw14NvTscZZyOxe
         ElaBo+2k29JW8SwmTsrWtEWCaMI5oTakgbZ4eCf3kQ7HfFHVUPi+P3C5gBBlSgkEL741
         kd/0QRfdSSNoxuaNx/fLwq5XKfWTldNF9J+OwA5Anu++BhkdJLXeLa+dIPQKlNTi/Gki
         Bl95OY8Y4HyZPu3hK4F6ROZEkYvbXs5t+yTsv/EQ5rSgXpRtAVLXqIA7Gr8tS0mxIaka
         xUEeaMQB6vVguFgc3BXI4Bl5jwBDaNOzOdSdKiZzeKmJ7vRc6ijKt7mjJapPxXkpbnzy
         nW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313564; x=1765918364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ihXpQp4YbEFBpuWRcFtm84jVRjsgBgDbq/Ms0l8x8e0=;
        b=Ntv1BVSsU+ti8dskDUdAb0FkmzRu50T4PrFFfHA7Pl8/WM5hgzn80Y1zrMJmHBrapw
         H13rSHYlS7QlR/uebHCXYNV2ZvenaZH1SKmw8H26sEf5NP0LG1fFpLHV9f9da015jMAH
         DmQK+pILY1JRsuui7TJID3tQBgg0JisyNsxnRIEZFGsxnzBzMbt3aQnEbLwHNyyP+VNx
         lk6vzi6MB/zY2ZfAeGkcaAOPW5GvG9eLZrVqdA1FU3mI3CXlQ+jD4DoJi4jHgDNbVfsk
         ad3ITrj2We9klfw75Px8R4XArtOTGZJjWP0IfgRHoWT/72DuL4QW0CI/88QjCGlzszw1
         ofsA==
X-Gm-Message-State: AOJu0YyQf6EOM5oe3HsDPQ2vHqPlWL+5Z7WhqA6ksxkVg0cf4FTXryuy
	nGUCVRASHBVQ7Xg2jdVsu5qBJO8O2eXguXnNq5R6jBGjPOR5lHTQVMXeiOqSnhiZMY/NQJM+gOq
	6OwhkDg3lbcaG0ie1pDGAnXnQ7Rl88U62XPRXIf0D6W0RcVzDNNc9vI3MNvd+OVH3W9izCL1gAD
	4QWD8nN+NWWilrVAOayVmjf3WrSN+IduJf26zHF6G36aEWFfWXbl+g6TprwaQ=
X-Google-Smtp-Source: AGHT+IHxM7HDFMt11Fktl9vAFCiqioFJsGX2hMXvHLM0Q/bfIgLNdr5sCpLbQ+drd5Dfesj8Rx6njSPwYNcP8RB94g==
X-Received: from ilbck7.prod.google.com ([2002:a05:6e02:3707:b0:430:c858:3dd3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:20e:b0:657:64ce:b40f with SMTP id 006d021491bc7-65b2ac06416mr132080eaf.4.1765313564200;
 Tue, 09 Dec 2025 12:52:44 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:15 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-19-coltonlewis@google.com>
Subject: [PATCH v5 18/24] KVM: arm64: Enforce PMU event filter at vcpu_load()
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

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load since it might have changed since the last
time the guest wrote a value. If the event is filtered, exclude
counting at all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 44 +++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 71977d24f489a..8d0d6d1a0d851 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -221,6 +221,49 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 	return nr_host_cnt_max;
 }
 
+/**
+ * kvm_pmu_apply_event_filter()
+ * @vcpu: Pointer to vcpu struct
+ *
+ * To uphold the guarantee of the KVM PMU event filter, we must ensure
+ * no counter counts if the event is filtered. Accomplish this by
+ * filtering all exception levels if the event is filtered.
+ */
+static void kvm_pmu_apply_event_filter(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 evtyper_set = ARMV8_PMU_EXCLUDE_EL0 |
+		ARMV8_PMU_EXCLUDE_EL1;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	u8 i;
+	u64 val;
+	u64 evsel;
+
+	if (!pmu)
+		return;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+		evsel = val & kvm_pmu_event_mask(vcpu->kvm);
+
+		if (vcpu->kvm->arch.pmu_filter &&
+		    !test_bit(evsel, vcpu->kvm->arch.pmu_filter))
+			val |= evtyper_set;
+
+		val &= ~evtyper_clr;
+		write_pmevtypern(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, vcpu->kvm->arch.pmu_filter))
+		val |= evtyper_set;
+
+	val &= ~evtyper_clr;
+	write_pmccfiltr(val);
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -244,6 +287,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 		return;
 
 	pmu = vcpu->kvm->arch.arm_pmu;
+	kvm_pmu_apply_event_filter(vcpu);
 
 	for (i = 0; i < pmu->hpmn_max; i++) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
-- 
2.52.0.239.gd5f0c6e74e-goog


