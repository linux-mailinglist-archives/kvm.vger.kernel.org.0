Return-Path: <kvm+bounces-54707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EF49B2736B
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:14:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 845C55E8586
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:14:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9011C2335;
	Fri, 15 Aug 2025 00:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BUZT9xXj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDBA1922FA
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755216744; cv=none; b=e000lpyGS0vF2xR3xAVsufPNTA1zbPg54p6eCSWGi9DOTaPik++I8R8TZddP6tJfVnwzwmwtwv40Hje8bHd0B0J7e6DLHSuAjdnvJHb2ZR5cxNoRcpXTStP7KqMGUXCN1JDOfOmnwATp+/xIwygjrzioj6QOYe3gjHFmN/w2zuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755216744; c=relaxed/simple;
	bh=O2LmGYHZhZkLGwfBk2Yp1f3Rs3CptBnqxMLK4Ir6eIg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RdEsmJGIE8l7iS5Cm5CcuJVgdQ6aJJtiTg1vTzfLGO5dcJMEHOREpr6n1Jfr1Gx1yyH/Jj8xKk3Trjzaf7lPX6PvLj86WEA4tdFX6ffpzz/lf+kDyYN2Ur3HdeYz/270uj8TtsnSe9Fev0yxQS7uh/VsS4HLy3TaCoKHpHMmR84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BUZT9xXj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-24457f4f3ecso15734965ad.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755216742; x=1755821542; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pXQWA5FLczzcFgAGgva/tQ0VYzpmUU3vq4Bm8GhyjFA=;
        b=BUZT9xXjxbtNoMsY1W1el/OZHt/eLhsCx+Bmkg9/s71XRz3jI0McbmKGSxgQevDhe7
         v31d4LoDYWYiWdOvsO4QIuUN7fZXAmp9Sa80BOB1qUzzDca2w34MVVBFGd3LXDAVrqsY
         BHDg2hDAPQCjZ2+Eg0n98WpzcR7EBEkHLPYke8itjCU9g9RNtmcIy4gUdb3bWIHHL3xH
         jWflMO5QbkqFTvc00plobFmeJVENrVckBs2t8x4rKxy1jJhY7iUd0ovu8WSrPvdzy5ql
         tql2fDiz9CMgWyEHwYz+1Z1XntgqnvVDIefXqe8hqEsswy4Pt8Hs5rT2tCTzyH4CyLHf
         pOCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755216742; x=1755821542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pXQWA5FLczzcFgAGgva/tQ0VYzpmUU3vq4Bm8GhyjFA=;
        b=L5/bXw3KaDg4vf+8Ltdki8h82fyExmBLmFVacJxUm9qk0Xt8OLc1llKZan99Eq5Ebn
         5Cd9LhQ5cSPjTEwc+N1VjYugCa4KOWlKy0UAvI5mfzU2LVXcyEHJrKTb4RATtqZqMYUe
         yOyrcD03A9yFQrT5e6Wcld2pi7tOLi19d/QYoR9/KAAYkJF58dTk0Mm0ZVQ1F2YqQq0y
         7PAbqfxbfPCiMN7K7hqhOxQCeJA5J98VVcvThpurAfzvK9kyyAStoYb4VrMBhNr2uP2J
         4T9El/KNK1jU5uBRyTFXI7x9Q6BFRzgDOiQ4c4MDxHlxMMnCR66e9qpuZvclsbjXKrcg
         mcxg==
X-Gm-Message-State: AOJu0YxQohtITriSbbD2UmnY4BMdUcWaWUKpdGEhBaHZAbz2lY2b5qYm
	5CxUWSW6xDDTyXogkQdDnb+PgcnW+CFsdELzQFemWoEk2CPxcccYpciU2NOXbhTEZAyCvBRea5g
	+ecf1EQ==
X-Google-Smtp-Source: AGHT+IEpd6403VG8BvXCtL5Wm0bfYaHW/IiE3Ya7RRt9tZra7RgrQ/Ti92XyDRtdQNwdGxQoM3swrEunIu8=
X-Received: from pjuj12.prod.google.com ([2002:a17:90a:d00c:b0:314:29b4:453])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac1:b0:240:3db8:9adc
 with SMTP id d9443c01a7336-2446d5ac887mr1825575ad.4.1755216742609; Thu, 14
 Aug 2025 17:12:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:11:50 -0700
In-Reply-To: <20250815001205.2370711-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815001205.2370711-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815001205.2370711-7-seanjc@google.com>
Subject: [PATCH 6.1.y 06/21] KVM: x86: Snapshot the host's DEBUGCTL in common x86
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

[ Upstream commit fb71c795935652fa20eaf9517ca9547f5af99a76 ]

Move KVM's snapshot of DEBUGCTL to kvm_vcpu_arch and take the snapshot in
common x86, so that SVM can also use the snapshot.

Opportunistically change the field to a u64.  While bits 63:32 are reserved
on AMD, not mentioned at all in Intel's SDM, and managed as an "unsigned
long" by the kernel, DEBUGCTL is an MSR and therefore a 64-bit value.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: stable@vger.kernel.org
Reviewed-and-tested-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250227222411.3490595-4-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: resolve minor syntatic conflict in vmx_vcpu_load()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 8 ++------
 arch/x86/kvm/vmx/vmx.h          | 2 --
 arch/x86/kvm/x86.c              | 1 +
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6db42ee82032..555c7bf35e28 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -677,6 +677,7 @@ struct kvm_vcpu_arch {
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
+	u64 host_debugctl;
 	u64 apic_base;
 	struct kvm_lapic *apic;    /* kernel irqchip context */
 	bool load_eoi_exitmap_pending;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7b87fbc69b21..c24da2cff208 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1418,13 +1418,9 @@ void vmx_vcpu_load_vmcs(struct kvm_vcpu *vcpu, int cpu,
  */
 static void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
-
 	vmx_vcpu_load_vmcs(vcpu, cpu, NULL);
 
 	vmx_vcpu_pi_load(vcpu, cpu);
-
-	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
 static void vmx_vcpu_put(struct kvm_vcpu *vcpu)
@@ -7275,8 +7271,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	}
 
 	/* MSR_IA32_DEBUGCTLMSR is zeroed on vmexit. Restore it if needed */
-	if (vmx->host_debugctlmsr)
-		update_debugctlmsr(vmx->host_debugctlmsr);
+	if (vcpu->arch.host_debugctl)
+		update_debugctlmsr(vcpu->arch.host_debugctl);
 
 #ifndef CONFIG_X86_64
 	/*
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 8b4b149bd9c1..357819872d80 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -352,8 +352,6 @@ struct vcpu_vmx {
 	/* apic deadline value in host tsc */
 	u64 hv_deadline_tsc;
 
-	unsigned long host_debugctlmsr;
-
 	/*
 	 * Only bits masked by msr_ia32_feature_control_valid_bits can be set in
 	 * msr_ia32_feature_control. FEAT_CTL_LOCKED is always included
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 08c4ad276ccb..2178f6bb8e90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4742,6 +4742,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	/* Save host pkru register if supported */
 	vcpu->arch.host_pkru = read_pkru();
+	vcpu->arch.host_debugctl = get_debugctlmsr();
 
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
-- 
2.51.0.rc1.163.g2494970778-goog


