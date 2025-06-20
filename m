Return-Path: <kvm+bounces-50192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84347AE256A
	for <lists+kvm@lfdr.de>; Sat, 21 Jun 2025 00:25:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 021B43ADD77
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 22:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9DE025CC63;
	Fri, 20 Jun 2025 22:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4L05MAEd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177E123F41F
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 22:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457942; cv=none; b=ncdDuvJxpEUSuo/FSrlcAbWQ36/EwqjipmuvXEzSWXBQZI2XeMMTn2Pe0tu5wDJoSaL0wNpbOxQ7VxIC9OJ2GtSJtYC6qIMrRLfZLmu8UUdSTpoJQ2qGgFH0PQb4j4Uw+fvw5aKHPbgPUqUuULMTc+ipVW/fO3xjaDAQcsz0riM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457942; c=relaxed/simple;
	bh=yMGaPG1CZQkU3Bq8XdwQsHNu1kFzSYzZgl5dA+p/rKk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sqM5uFjhS7bM9Nq9DK6sQqi+tFPceymrEwhy/sU/3Uq8P2aX+osOLJMkW3RONA2K8TqWfU7epTeRbnA6OoCgBHuVgrfWFsRyJHp0GTTSUNzP2vhH7nwzZb3OMUal6s4xxdsc621ajqQyXP701xXXqQfvwKwsFH/kUtXQPT/wYUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4L05MAEd; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddd045bb28so21159205ab.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 15:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457937; x=1751062737; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=evXfKUBhSeG+2oly7f+qnRnfAE1yqFxCmvksu6Guakw=;
        b=4L05MAEd9mBEL8yU95i3IBx5kciKhcXWgeqgGyv2qKblvATzu89jWtccYMwybuTNrP
         0Y7cMvGjd84bgA7H5wLSrdeiKjLIFiwDCC76vAZnTdewMhsMtq2nYkpbxlit3rO0q7z0
         ixy8Vras9MBVijExVSrgLBCrQwZUetK1jdLA+97kzLfvH/m0HaK55r/aeNmfKwDqE3M3
         WzZq5KNsqEWlDSlCetxInka78F/jj2l48XZhH7cE2dcczPgHWXQTQ3Jtpohk4ceNA/z2
         NNw9Jdu3q+UybwkiwEcdEEvy9FCpEndbxye4hnfInlBmncJwTdvhpDXLUWQaJ0m1ecVp
         DAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457937; x=1751062737;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=evXfKUBhSeG+2oly7f+qnRnfAE1yqFxCmvksu6Guakw=;
        b=qnr/5tJ4b5yK2FGCOUacfIxwwfUjOA+rJK7ZLQNRbwDwQY9nxA4ig1nlhWtUJlOkS1
         Q7A19hA/d2b5DDNiiF7DS8tSMgEmve4LFCEDNFq6CiXLWi8yR0F/7NuFk+fasW4LC5pi
         pI76WXddvqAgdDfpawnnILHRBJFxt4TaDGl9kGiuXIXzS/iz8G2QCaGiw+hE1+E06DFS
         0NH9JyrXjnzCyVf32CotHGVzi/YZZNVTLj7kRLvBRcyGnSbvDczmDFK1lBWjK80bSpNh
         KI75ok58/p00IVVBBtXnYy3dl4SmusBW6nS/Yk56YvYwbyyyj+Vl/ukf0Lpba42kDBIC
         SJNg==
X-Gm-Message-State: AOJu0Yw4bSiSLP+Okx74IBs/xfhdz2ZVuS3q0RewIPM/FBBWUAi8W/7R
	h1Z5sYUoHOA8SS+zDp0b5A8kkTqQ/gJZ80XzAU/46NVEmH1Ry41D1ExA5M+NbodjNJrnbRtub2q
	zhwb+hpF/mQWx5kWK4ZJv68EQeAY1BeuFEW9RV08ENNvzq8dH5/F28qvg+7/oPT5C6motJQEy6l
	6RTqgzQgjbNCSXO5trs8+JIFS30JDO1xOeY/DmOfIhBd0EHCa+HFWQZXmYwuM=
X-Google-Smtp-Source: AGHT+IFQNwOuHEkKN7g4qywdhJQMH3Ei639Gg+Rq7B3OB/2GxQkU/gqG6/aq0ZsCLexdUvss75SIoe73NPnJzqeZ9A==
X-Received: from ilue6.prod.google.com ([2002:a05:6e02:b26:b0:3dd:b662:5c3b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1a4f:b0:3dd:bb7e:f1af with SMTP id e9e14a558f8ab-3de38cdcc11mr49042745ab.20.1750457937447;
 Fri, 20 Jun 2025 15:18:57 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:20 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-21-coltonlewis@google.com>
Subject: [PATCH v2 19/23] KVM: arm64: Enforce PMU event filter at vcpu_load()
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

The KVM API for event filtering says that counters do not count when
blocked by the event filter. To enforce that, the event filter must be
rechecked on every load. If the event is filtered, exclude counting at
all exception levels before writing the hardware.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-part.c | 43 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 19bd6e0da222..fd19a1dd7901 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -177,6 +177,47 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 	return hpmn;
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
+	u64 evtyper_set = kvm_pmu_evtyper_mask(vcpu->kvm)
+		& ~kvm_pmu_event_mask(vcpu->kvm)
+		& ~ARMV8_PMU_INCLUDE_EL2;
+	u64 evtyper_clr = ARMV8_PMU_INCLUDE_EL2;
+	u8 i;
+	u64 val;
+
+	for (i = 0; i < pmu->hpmn_max; i++) {
+		val = __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + i);
+
+		if (vcpu->kvm->arch.pmu_filter &&
+		    !test_bit(val, vcpu->kvm->arch.pmu_filter)) {
+			val |= evtyper_set;
+			val &= ~evtyper_clr;
+		}
+
+		write_pmevtypern(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMCCFILTR_EL0);
+
+	if (vcpu->kvm->arch.pmu_filter &&
+	    !test_bit(ARMV8_PMUV3_PERFCTR_CPU_CYCLES, vcpu->kvm->arch.pmu_filter)) {
+		val |= evtyper_set;
+		val &= ~evtyper_clr;
+	}
+
+	write_pmccfiltr(val);
+}
+
 /**
  * kvm_pmu_load() - Load untrapped PMU registers
  * @vcpu: Pointer to struct kvm_vcpu
@@ -199,6 +240,8 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	if (!kvm_pmu_is_partitioned(pmu) || (vcpu->arch.mdcr_el2 & MDCR_EL2_TPM))
 		return;
 
+	kvm_pmu_apply_event_filter(vcpu);
+
 	for (i = 0; i < pmu->hpmn_max; i++) {
 		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
 		write_pmevcntrn(i, val);
-- 
2.50.0.714.g196bf9f422-goog


