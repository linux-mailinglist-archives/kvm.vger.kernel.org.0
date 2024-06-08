Return-Path: <kvm+bounces-19111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FEE0900EB9
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 02:09:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE5571F229E4
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDF81522A;
	Sat,  8 Jun 2024 00:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oXSv2eFN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A14367
	for <kvm@vger.kernel.org>; Sat,  8 Jun 2024 00:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717805304; cv=none; b=CgjkK0typ8vacn3GTtnqv9YToyyJZQRzXwDluiR15AzTUHotKdFY/TVzrRX8yIgi+RSkjZTf0e6Fk6wJeeJFSNwTZvs2UedIWn84HkkNQxM810yWScc3itjDgwzIRK2vaVEDK72L+7uanYKzttnt3l7PpnelqqwXAlx4owzYBPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717805304; c=relaxed/simple;
	bh=ZKVxFlWCoRksUkxWWrwGa7iVo7XPZ+TLSlr9yB8cyQ4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=VLbucqMDHmd576D87fH5hwwNxXmQ66Be0+dXdG36oxaxDHVJwFWfaAmRbP5zJR0LQb36u4p+OjInHDUA4AsVKW9M0w4tFPHsHKecbf2Hv8e4R5ha7BJ5UKosR02vrslebuDUOpmQLbBhhkJq5WzKbXjerkeKQnBsfw20bW2vtbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oXSv2eFN; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-629f8a92145so42419217b3.0
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2024 17:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717805302; x=1718410102; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p9BtvksvI6bGDUh23pevo8BBa49pDsRz+KvlfS/FYmQ=;
        b=oXSv2eFNYDprzKPXZKNENLYvX20bbN3aKjNzKoB1YUKGfN0OPncTiP2gnhJgQHRp+Y
         5M+Co7LjGU2naf/+L+aFGMu4pimGIuIfeuwmeTLHY+2JR1gT9ggUpHpa5PW8dm0CKTwr
         zbcEl+JpN26VbgDxOcUKuT0KWnymju0kJ0pi/uqLhsmoPWzsPfjsXAAbWVISkd4Ae+4w
         OJavmvbL6mU3TRiNi/HSGrFvoFXLqIqlL82XTmnDi+0vBevTQw1LwH5KPzGjly24T2FT
         On5zLVocbpqHE/mICyJfhfodNCiefzG+67RG6GhFES+9A5d2s7PYKsDZzfEzIIIISdBO
         VMyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717805302; x=1718410102;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p9BtvksvI6bGDUh23pevo8BBa49pDsRz+KvlfS/FYmQ=;
        b=fNMVHQtb0/ZuYVi+tjikYxDS5z5Fy53nM1yjMnvlZxVRGeCvqDEORusSP435zyNkme
         JxeANQARjauAtJi4tr7J06aAvFMdSH4HvKuSrbK1gUCT+eHxfrxq1L0yDAc3ppA/UCYP
         HRg1Uc1odbMdXhFuIzrhxjuVqQ/xJU3JTsvMNX2NW4zhfDhjwxe8XqAOErY8LHEDNXST
         SqJOpiUujD1turgzaaCRuRJCOr1TjlJsgFShgjumIwmpOPuVIgqkY126CLLvo10kNDwo
         OF+ZcLZpZ7cYwEcCSVy/okTOlteBiM9rpTjhg274zeoSH5Bx20XKptEKFIE6B+zjqlAJ
         Goaw==
X-Gm-Message-State: AOJu0YxUk56RCi4LrZecm/efu9n4GpAuswdW0Zu7krBaVprdRXDQr+np
	osdeFvvip7SOIweiJ7iaJuX7AS9slg8H0laIFBVL8da07N2pi3uQnyMyQf5doy9v0b7fDIL1EGM
	gMQ==
X-Google-Smtp-Source: AGHT+IGsPBWA9cFMabTPuN0FW8ziyUTGmFt2hhUp8cBCUnYGq78VyaVXvNf1Zu/Hv+lUv2lIpK7EL0+W7ao=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:f81:b0:627:d7e6:383f with SMTP id
 00721157ae682-62cd5667ca0mr10320587b3.7.1717805301747; Fri, 07 Jun 2024
 17:08:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  7 Jun 2024 17:08:19 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <20240608000819.3296176-1-seanjc@google.com>
Subject: [PATCH] KVM: x86/pmu: Add a helper to enable bits in FIXED_CTR_CTRL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper, intel_pmu_enable_fixed_counter_bits(), to dedup code that
enables fixed counter bits, i.e. when KVM clears bits in the reserved mask
used to detect invalid MSR_CORE_PERF_FIXED_CTR_CTRL values.

No functional change intended.

Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index e01c87981927..fb5cbd6cbeff 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -448,6 +448,14 @@ static __always_inline u64 intel_get_fixed_pmc_eventsel(unsigned int index)
 	return eventsel;
 }
 
+static void intel_pmu_enable_fixed_counter_bits(struct kvm_pmu *pmu, u64 bits)
+{
+	int i;
+
+	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
+		pmu->fixed_ctr_ctrl_rsvd &= ~intel_fixed_bits_by_idx(i, bits);
+}
+
 static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -457,7 +465,6 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	union cpuid10_edx edx;
 	u64 perf_capabilities;
 	u64 counter_rsvd;
-	int i;
 
 	memset(&lbr_desc->records, 0, sizeof(lbr_desc->records));
 
@@ -501,12 +508,9 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			((u64)1 << edx.split.bit_width_fixed) - 1;
 	}
 
-	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
-		pmu->fixed_ctr_ctrl_rsvd &=
-			 ~intel_fixed_bits_by_idx(i,
-						  INTEL_FIXED_0_KERNEL |
-						  INTEL_FIXED_0_USER |
-						  INTEL_FIXED_0_ENABLE_PMI);
+	intel_pmu_enable_fixed_counter_bits(pmu, INTEL_FIXED_0_KERNEL |
+						 INTEL_FIXED_0_USER |
+						 INTEL_FIXED_0_ENABLE_PMI);
 
 	counter_rsvd = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
 		(((1ull << pmu->nr_arch_fixed_counters) - 1) << KVM_FIXED_PMC_BASE_IDX));
@@ -551,10 +555,8 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 		if (perf_capabilities & PERF_CAP_PEBS_BASELINE) {
 			pmu->pebs_enable_rsvd = counter_rsvd;
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
-			for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
-				pmu->fixed_ctr_ctrl_rsvd &=
-					~intel_fixed_bits_by_idx(i, ICL_FIXED_0_ADAPTIVE);
 			pmu->pebs_data_cfg_rsvd = ~0xff00000full;
+			intel_pmu_enable_fixed_counter_bits(pmu, ICL_FIXED_0_ADAPTIVE);
 		} else {
 			pmu->pebs_enable_rsvd =
 				~((1ull << pmu->nr_arch_gp_counters) - 1);

base-commit: b9adc10edd4e14e66db4f7289a88fdbfa45ae7a8
-- 
2.45.2.505.gda0bf45e8d-goog


