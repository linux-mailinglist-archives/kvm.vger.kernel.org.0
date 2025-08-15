Return-Path: <kvm+bounces-54751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CDB6B2745E
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:59:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 613B25E0D04
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9EDC1E5718;
	Fri, 15 Aug 2025 00:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xMEr3CQH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE6D156237
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755219460; cv=none; b=IRk7sCiMYo3Rcuj+4+/KNzq7jUQjDDbzrEXa0qBtrl2totZHCCQMYUK/+TSpmMioPQb+fMCXFcDm3H0fdZ4r4Kg9ba4K4UPkyRpD+cW3A5BJSbd6x2CHJkv7RORojJ2RjjZAs/j1H3UtUuf4mYGS3s7c8AhhxEQ/rd1JVMUxN2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755219460; c=relaxed/simple;
	bh=dBlHTlIAJfX5eawiwMNpv72twz60gql05QR73AbznkU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kARDHU9aqqqZXs57ise7pR049jl7kqexJ1uzSB6jylGfe68RYk47P8elldyUaGc0nSjCWstnMAuOQ0smMhtRYA/pzpo7uCwcULrNDqS25htElyvNeVilNYDWXuxUcv+Z9suosaf81wXxPiJPxGoNEb8OP4giJNNeAiYLj97fW+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xMEr3CQH; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2445806b18aso15135125ad.1
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755219457; x=1755824257; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=pt6AG6fFgzvWmcsWMwVWOAjsGddZcqy4y6FZVOShyzA=;
        b=xMEr3CQH5gQ9g8PaQSvmxP3zxXU2pFay6t6n+kcEfRZFODhZ8YnUC3swz2KAYNawbR
         IcXvFz7dESmLYx6SykDfZItbY6g5jOYjf0ltcO4gNk5HYcOn6BvPs9teqTF34CsoDzwN
         /npa57kohy5XzuW9pBwGG1/8sGjePI2ZQDu3ViSz7b2mcB2MrEKToH9DXurbYQpnPUAI
         dxVnTweIUXTnpbEqLn6jZLpV/gfItIiManYDyrVNDBOL9FnZiTsh61goIi7kOpGoTs8O
         P9VWvRohyWRiFD9YhgPfQP9cwOuwBInSAVItHR9sXxyWcDXpY6egmM4JDLT4wGEaj2Uv
         PGNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755219457; x=1755824257;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pt6AG6fFgzvWmcsWMwVWOAjsGddZcqy4y6FZVOShyzA=;
        b=hfSQ1aCrKI1oCpVCyYVJ4H3IV9ekBiBw2FfIIlLW2yh93/WndAy5D0nDh6of6QADTS
         3BsgI+N0pm72DNL9IP4Bc26BXojWKH7rX8a4aTomUfKjzfKa2gbrRZ7Vs7ah95T/1K3D
         G/OgJbPVxgEFgGxv6+NatQHhgAK/1+EKMtVsaCbNwNWLJrySPvOzLdpG2LDOrGgpuyfj
         A2X/BFz/rL1keOzEqcmILUZ0MFwuNIVwSGb7UEknJv+cMZ8PeIeDMDJHnlpzXBksfFDy
         YNJI3HtAOr77ujSdIoWqxg8F0XhzHEw5BLFRV8QlXY7qz1PUywKunzgoezPfgEfMLuA4
         ruuw==
X-Gm-Message-State: AOJu0YzvQLQgsxGN3ueu+Ddy0RJqi/MMEAi62YnNY68LkBIdKyjzNjy8
	SWr20mZRnGhSPebwY5vgIsAmahaEjGoBI7nSGZQwou3Scs4X0vpNpQcOuYzQDfpC8B6WvZlekMM
	cfAvhMw==
X-Google-Smtp-Source: AGHT+IH/WMVYo8K4atT6PPBxzG/jMa+y6G7NdNEfFkox+VvMIEdJw99ziDIIvUfceGqDxBL2DRsVeW69wlk=
X-Received: from plhy2.prod.google.com ([2002:a17:902:d642:b0:240:770f:72cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:cec3:b0:23f:dc56:66e2
 with SMTP id d9443c01a7336-2446d8d25b3mr3852235ad.38.1755219457431; Thu, 14
 Aug 2025 17:57:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:57:23 -0700
In-Reply-To: <20250815005725.2386187-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815005725.2386187-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815005725.2386187-6-seanjc@google.com>
Subject: [PATCH 6.12.y 5/7] KVM: nVMX: Check vmcs12->guest_ia32_debugctl on
 nested VM-Enter
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

[ Upstream commit 095686e6fcb4150f0a55b1a25987fad3d8af58d6 ]

Add a consistency check for L2's guest_ia32_debugctl, as KVM only supports
a subset of hardware functionality, i.e. KVM can't rely on hardware to
detect illegal/unsupported values.  Failure to check the vmcs12 value
would allow the guest to load any harware-supported value while running L2.

Take care to exempt BTF and LBR from the validity check in order to match
KVM's behavior for writes via WRMSR, but without clobbering vmcs12.  Even
if VM_EXIT_SAVE_DEBUG_CONTROLS is set in vmcs12, L1 can reasonably expect
that vmcs12->guest_ia32_debugctl will not be modified if writes to the MSR
are being intercepted.

Arguably, KVM _should_ update vmcs12 if VM_EXIT_SAVE_DEBUG_CONTROLS is set
*and* writes to MSR_IA32_DEBUGCTLMSR are not being intercepted by L1, but
that would incur non-trivial complexity and wouldn't change the fact that
KVM's handling of DEBUGCTL is blatantly broken.  I.e. the extra complexity
is not worth carrying.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250610232010.162191-7-seanjc@google.com
Stable-dep-of: 7d0cce6cbe71 ("KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with getter/setter APIs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 12 ++++++++++--
 arch/x86/kvm/vmx/vmx.c    |  5 ++---
 arch/x86/kvm/vmx/vmx.h    |  3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 903e874041ac..1e0b9f92ff18 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2653,7 +2653,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
+		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl &
+						  vmx_get_supported_debugctl(vcpu, false));
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
@@ -3135,7 +3136,8 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS) &&
-	    CC(!kvm_dr7_valid(vmcs12->guest_dr7)))
+	    (CC(!kvm_dr7_valid(vmcs12->guest_dr7)) ||
+	     CC(!vmx_is_valid_debugctl(vcpu, vmcs12->guest_ia32_debugctl, false))))
 		return -EINVAL;
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT) &&
@@ -4576,6 +4578,12 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		(vmcs12->vm_entry_controls & ~VM_ENTRY_IA32E_MODE) |
 		(vm_entry_controls_get(to_vmx(vcpu)) & VM_ENTRY_IA32E_MODE);
 
+	/*
+	 * Note!  Save DR7, but intentionally don't grab DEBUGCTL from vmcs02.
+	 * Writes to DEBUGCTL that aren't intercepted by L1 are immediately
+	 * propagated to vmcs12 (see vmx_set_msr()), as the value loaded into
+	 * vmcs02 doesn't strictly track vmcs12.
+	 */
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_DEBUG_CONTROLS)
 		vmcs12->guest_dr7 = vcpu->arch.dr7;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ff61093e9af7..50d45c18fce9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2173,7 +2173,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 	return (unsigned long)data;
 }
 
-static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated)
 {
 	u64 debugctl = 0;
 
@@ -2192,8 +2192,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	return debugctl;
 }
 
-static bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data,
-				  bool host_initiated)
+bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
 {
 	u64 invalid;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index cf57fbf12104..ee330d14089d 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -435,6 +435,9 @@ static inline void vmx_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr,
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 
+u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
+bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated);
+
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
  * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
-- 
2.51.0.rc1.163.g2494970778-goog


