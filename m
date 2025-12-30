Return-Path: <kvm+bounces-66855-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98423CEAA3F
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 22:00:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A8A5830245F8
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 20:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228452FBE00;
	Tue, 30 Dec 2025 20:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="McvBej4V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B331F5847
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 20:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767128393; cv=none; b=O0VjHfd4ljSgP97qiUnNyJAiP6fj+FJZCNm6h++CYuSmeOV9Hpd46V1B0yak4Qn29UJuomLr/yckJQwMHW4kV3Jvfid1n15mgXI5IStm48nylfk234s4HrRJMr1Nq2u89oYqh/aRXe3FEBBpO9Eke/8mKqgQXvKILNPFSV0EjlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767128393; c=relaxed/simple;
	bh=Yf8c47fOuuNkzfnpHdoKVTxRaTYauBW8yFATb/V1hEw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sQ2RR7KoIipyNgrw7Olycyth/D9vdUIQ1RhfF2zo2BfCPdF3FANNhcsLIiRNOWKOkEpODKvcOOMCOBM1hfoR9rqRX/pyj9MOLnNHN6OFSNf4pvXFB360VaxKQimY0nq+4IZsiTDB/GhwrxM5yXqJhSW9HLiodoSmFbTPXAPIBLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=McvBej4V; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7a9fb6fcc78so8384795b3a.3
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 12:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767128391; x=1767733191; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5nk5TvmPe83Os2b9bwchwqySErdfgrBx32d2v4ifhjQ=;
        b=McvBej4VUUB9Yb8J/modRXXzWV8LmbcxQSKiQuodrDUnkfifP/LgLthbW7Dv06Ciji
         7reSgGEshmmQ0SP+0DBgOd9bhppRe8Y0xwEAiYf59l6di9asiZk2ctMScohyKNivL+ZH
         nt8o7MhgjFx4KUSgRvy8UWVAvJ3f5KvVvrHYeV+HMKnDFuvhHy04v2azdLPzRWzZy5UV
         w8uFNe5SDagiweQcax4EBdl33jXgrX6DopMy1fO3c7SAmoE7wsfV1nDH03qvCtYxmHEX
         07MEUlnY1eg02vaycZjsMcFxkd8Dol1+TgpR9vONNvVU9ILQbJ0qyFQFDeGkEPGhPRqI
         hNzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767128391; x=1767733191;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5nk5TvmPe83Os2b9bwchwqySErdfgrBx32d2v4ifhjQ=;
        b=H7o9qf5vQJH123f1VCr7aPhJyYKneq64+v5Mwaf3w3NLwmEJnjf+DzpOtmcfw8NUif
         5Ds7AGvrdJnolhHirmwRswacRMWrusgFvAXRbDvXPZpampe9/hrNbik851XV0mcPmLYI
         ilErmxOki9+MIBm0vCVW7rUyl5rm71Eo6Yi1QacXFhiVZjZagd18M1OPWosHu98/wT9C
         Pvby/D3HsEA3d63bOSSpy94MAOtagyvIJYacq+irebAvi3s7VBQgwZcj8w19mRage8VD
         g98G0eexgOVsyJm7dut5RsoJqh/nrYmcKHejWP9xH5r57BQGucocyO7DY6DoePhft3F6
         zacg==
X-Gm-Message-State: AOJu0YzS0zzE9Fil5xk7XgdgVmKH1ll/GaZRZMDA8Ru+X5a6TnOiCNgF
	pKWQ5e9AndQyEjj9u1kSgSigKIQJEMPYyQtcO5G0dhT5SFmuadEZb3xlYtIz4hUjj16o6lOIK9x
	HtZK6fg==
X-Google-Smtp-Source: AGHT+IGAuzn+m4gMdXThPs7O1JzbOAo+Q8is8e2w2bdDiH2qejYHd3LZNgFF858yE21dPAksD4Kjte1A2Ck=
X-Received: from pfbfb38.prod.google.com ([2002:a05:6a00:2da6:b0:7c2:629c:5908])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:aa7:9a85:0:b0:7f7:398c:a855
 with SMTP id d2e1a72fcca58-7ff65f789e1mr28943109b3a.39.1767128390969; Tue, 30
 Dec 2025 12:59:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 12:59:48 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230205948.4094097-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Return "unsupported" instead of "invalid" on access
 to unsupported PV MSR
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Return KVM_MSR_RET_UNSUPPORTED instead of '1' (which for all intents and
purposes means "invalid") when rejecting accesses to KVM PV MSRs to adhere
to KVM's ABI of allowing host reads and writes of '0' to MSRs that are
advertised to userspace via KVM_GET_MSR_INDEX_LIST, even if the vCPU model
doesn't support the MSR.

E.g. running a QEMU VM with

  -cpu host,-kvmclock,kvm-pv-enforce-cpuid

yields:

  qemu: error: failed to set MSR 0x12 to 0x0
  qemu: target/i386/kvm/kvm.c:3301: kvm_buf_set_msrs:
        Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.

Fixes: 66570e966dd9 ("kvm: x86: only provide PV features if enabled in guest's CPUID")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff8812f3a129..dd0b5be1514d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4096,47 +4096,47 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data, 0);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		kvm_write_system_time(vcpu, data, false, msr_info->host_initiated);
 		break;
 	case MSR_KVM_SYSTEM_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		kvm_write_system_time(vcpu, data, true,  msr_info->host_initiated);
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (kvm_pv_enable_async_pf(vcpu, data))
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (kvm_pv_enable_async_pf_int(vcpu, data))
 			return 1;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 		if (data & 0x1) {
 			/*
 			 * Pairs with the smp_mb__after_atomic() in
@@ -4149,7 +4149,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_STEAL_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (unlikely(!sched_info_on()))
 			return 1;
@@ -4167,7 +4167,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_PV_EOI_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		if (kvm_lapic_set_pv_eoi(vcpu, data, sizeof(u8)))
 			return 1;
@@ -4175,7 +4175,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		/* only enable bit supported */
 		if (data & (-1ULL << 1))
@@ -4476,61 +4476,61 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->kvm->arch.wall_clock;
 		break;
 	case MSR_KVM_SYSTEM_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_CLOCKSOURCE2))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.time;
 		break;
 	case MSR_KVM_ASYNC_PF_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.apf.msr_en_val;
 		break;
 	case MSR_KVM_ASYNC_PF_INT:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.apf.msr_int_val;
 		break;
 	case MSR_KVM_ASYNC_PF_ACK:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_ASYNC_PF_INT))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = 0;
 		break;
 	case MSR_KVM_STEAL_TIME:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_STEAL_TIME))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.st.msr_val;
 		break;
 	case MSR_KVM_PV_EOI_EN:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.pv_eoi.msr_val;
 		break;
 	case MSR_KVM_POLL_CONTROL:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_POLL_CONTROL))
-			return 1;
+			return KVM_MSR_RET_UNSUPPORTED;
 
 		msr_info->data = vcpu->arch.msr_kvm_poll_control;
 		break;

base-commit: 9448598b22c50c8a5bb77a9103e2d49f134c9578
-- 
2.52.0.351.gbe84eed79e-goog


