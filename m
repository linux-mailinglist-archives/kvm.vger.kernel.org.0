Return-Path: <kvm+bounces-48924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F004CAD46A1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 01:22:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39C4C189DFEE
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 23:22:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B222BD029;
	Tue, 10 Jun 2025 23:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="npC1CXB5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4836529B799
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 23:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749597626; cv=none; b=N1H9yXPEmojYOD11VQu9cNavo20vBfA9Zbqoc1HMk9+PqqfuPdeW/ZJHtDhqmBloslNS4KOvYODreqQKGbrn6tFnxCZFFoIvs5KqEjitqX6E7kL6BQYO+FZ3t3xreZ5cjS3dZ45DrokYO4SMdbWg+zFC3lVhHGTNSS84j4v3VoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749597626; c=relaxed/simple;
	bh=GNOyxW1SytwEj4+h3gEIfqwnB6VMjLWxhbQovCAzrec=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cSkjFTWm4EmqZcZe9z1T39IZg3CRITdbhHCh5bSGWXUNDlU9v0kITlKUVZsqFSPDFWws30d+Osr+KF8LCHj2LdENoL2MoCEDs6j9AeBjzEeBzWfzKEipEJ1Z92qYBLl8qavKgg+yYSivLHXwK/AQ7IKqVY0MceS/X0zB0vHm5N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=npC1CXB5; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c38df7ed2so4297231a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 16:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749597625; x=1750202425; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=KQ/8WZhuTg5FjxxTRupMp19TYSftGyyuU4wfKee6pEQ=;
        b=npC1CXB5hwFC3VJxC1RWTSmnivB/w7Zrl5TZdHDeJbV+O4xzL+UrI5rqqKdWucW/q2
         KzHSXVothtVml6ynpxmrx/hK0T9F38UNd+qNfbvAziTz/HrZCq3tpSDwnHfGrCnawpZU
         R8fyr9M6GDl+taICbcYpCovkRvAFTAqSoEiukUlvkk4GWUc6LkGsv/pOcga2FcJ3mzsQ
         0IHjvH80iMKk/OzW7HIG7aNLaz61TPe3GxxClvRu3jI7wNJQgPVF9GWSTz+/5ClmxpxY
         GIFg+FLPALDnvc7o3oJ+G6Of/GNnEkUzOLiUBQ6lVYY/blDW7aVIzpE6TAd3a6HB0pVe
         Worg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749597625; x=1750202425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KQ/8WZhuTg5FjxxTRupMp19TYSftGyyuU4wfKee6pEQ=;
        b=talBzRbDKk89ho3dpIeJzRxSJOt2pruENw3CxdjyHOvwS9Ad/pw8zW+9yf72ph6vUZ
         48djEfDanv6Q/wlm8gIYiNp8kz4dw4g06q3pEKtz6QaL4bla0dsf1/KrrYWXaGsyp83N
         IE0LIK5bl408yhcdBRMa56l1DviWAKkofNw8QK2D2Di3mdU2zh/Gk85HRSQ1zyeXjojv
         hAJ1WyIQ04L1FyisNNZDIEUPk/D/YpO11i0Vyr67veHli/mfhAohsu8K8DqUyWItdFHn
         PwmeflrJ1OsOViQvABhN4UknlgAzwC1Vq36LNxufuvg2+PpnSHs53U08uyA8rF+JlJcU
         X9Pg==
X-Gm-Message-State: AOJu0Yw5qVCWt2DE3aCJtTt5fqX7VFgBXFI3gpNi+mOm5hVQ+2sV8Eo9
	H0GABo40Mf0fX0JK6O/vbE+qlZldZGTXY01LFFwXg9ScAr6fHGFRiI6gvSjLBg6Zkrym4jcS7N1
	7z7xmFw==
X-Google-Smtp-Source: AGHT+IGbj0+cctzd4GKSNL5dVe1ppyWvyLHGggIYnZ8TsVYDtCUXRFBhMN0AlDspipvVcnIAana36HT7Yxg=
X-Received: from pjbsk1.prod.google.com ([2002:a17:90b:2dc1:b0:308:6685:55e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1c8d:b0:312:dbcd:b931
 with SMTP id 98e67ed59e1d1-313af21ce8emr1953802a91.18.1749597624800; Tue, 10
 Jun 2025 16:20:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 10 Jun 2025 16:20:09 -0700
In-Reply-To: <20250610232010.162191-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250610232010.162191-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <20250610232010.162191-8-seanjc@google.com>
Subject: [PATCH v6 7/8] KVM: VMX: Wrap all accesses to IA32_DEBUGCTL with
 getter/setter APIs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Adrian Hunter <adrian.hunter@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

From: Maxim Levitsky <mlevitsk@redhat.com>

Introduce vmx_guest_debugctl_{read,write}() to handle all accesses to
vmcs.GUEST_IA32_DEBUGCTL. This will allow stuffing FREEZE_IN_SMM into
GUEST_IA32_DEBUGCTL based on the host setting without bleeding the state
into the guest, and without needing to copy+paste the FREEZE_IN_SMM
logic into every patch that accesses GUEST_IA32_DEBUGCTL.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
[sean: massage changelog, make inline, use in all prepare_vmcs02() cases]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c    | 10 +++++-----
 arch/x86/kvm/vmx/pmu_intel.c |  8 ++++----
 arch/x86/kvm/vmx/vmx.c       |  8 +++++---
 arch/x86/kvm/vmx/vmx.h       | 10 ++++++++++
 4 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5a6c636954eb..9edce9f411a3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2662,11 +2662,11 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	if (vmx->nested.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl &
-						  vmx_get_supported_debugctl(vcpu, false));
+		vmx_guest_debugctl_write(vcpu, vmcs12->guest_ia32_debugctl &
+					       vmx_get_supported_debugctl(vcpu, false));
 	} else {
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
+		vmx_guest_debugctl_write(vcpu, vmx->nested.pre_vmenter_debugctl);
 	}
 	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
@@ -3531,7 +3531,7 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 
 	if (!vmx->nested.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
-		vmx->nested.pre_vmenter_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		vmx->nested.pre_vmenter_debugctl = vmx_guest_debugctl_read();
 	if (kvm_mpx_supported() &&
 	    (!vmx->nested.nested_run_pending ||
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
@@ -4805,7 +4805,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	__vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
 
 	kvm_set_dr(vcpu, 7, 0x400);
-	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+	vmx_guest_debugctl_write(vcpu, 0);
 
 	if (nested_vmx_load_msr(vcpu, vmcs12->vm_exit_msr_load_addr,
 				vmcs12->vm_exit_msr_load_count))
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8a94b52c5731..578b4ef58260 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -652,11 +652,11 @@ static void intel_pmu_reset(struct kvm_vcpu *vcpu)
  */
 static void intel_pmu_legacy_freezing_lbrs_on_pmi(struct kvm_vcpu *vcpu)
 {
-	u64 data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+	u64 data = vmx_guest_debugctl_read();
 
 	if (data & DEBUGCTLMSR_FREEZE_LBRS_ON_PMI) {
 		data &= ~DEBUGCTLMSR_LBR;
-		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		vmx_guest_debugctl_write(vcpu, data);
 	}
 }
 
@@ -729,7 +729,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 	if (!lbr_desc->event) {
 		vmx_disable_lbr_msrs_passthrough(vcpu);
-		if (vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR)
+		if (vmx_guest_debugctl_read() & DEBUGCTLMSR_LBR)
 			goto warn;
 		if (test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use))
 			goto warn;
@@ -751,7 +751,7 @@ void vmx_passthrough_lbr_msrs(struct kvm_vcpu *vcpu)
 
 static void intel_pmu_cleanup(struct kvm_vcpu *vcpu)
 {
-	if (!(vmcs_read64(GUEST_IA32_DEBUGCTL) & DEBUGCTLMSR_LBR))
+	if (!(vmx_guest_debugctl_read() & DEBUGCTLMSR_LBR))
 		intel_pmu_release_guest_lbr_event(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b685e43de4e9..196f33d934d3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2147,7 +2147,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			msr_info->data = vmx->pt_desc.guest.addr_a[index / 2];
 		break;
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = vmcs_read64(GUEST_IA32_DEBUGCTL);
+		msr_info->data = vmx_guest_debugctl_read();
 		break;
 	default:
 	find_uret_msr:
@@ -2281,7 +2281,8 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 						VM_EXIT_SAVE_DEBUG_CONTROLS)
 			get_vmcs12(vcpu)->guest_ia32_debugctl = data;
 
-		vmcs_write64(GUEST_IA32_DEBUGCTL, data);
+		vmx_guest_debugctl_write(vcpu, data);
+
 		if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
 		    (data & DEBUGCTLMSR_LBR))
 			intel_pmu_create_guest_lbr_event(vcpu);
@@ -4796,7 +4797,8 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 	vmcs_write32(GUEST_SYSENTER_CS, 0);
 	vmcs_writel(GUEST_SYSENTER_ESP, 0);
 	vmcs_writel(GUEST_SYSENTER_EIP, 0);
-	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+
+	vmx_guest_debugctl_write(&vmx->vcpu, 0);
 
 	if (cpu_has_vmx_tpr_shadow()) {
 		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 392e66c7e5fe..c20a4185d10a 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -417,6 +417,16 @@ void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
 u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated);
 bool vmx_is_valid_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated);
 
+static inline void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val)
+{
+	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
+}
+
+static inline u64 vmx_guest_debugctl_read(void)
+{
+	return vmcs_read64(GUEST_IA32_DEBUGCTL);
+}
+
 /*
  * Note, early Intel manuals have the write-low and read-high bitmap offsets
  * the wrong way round.  The bitmaps control MSRs 0x00000000-0x00001fff and
-- 
2.50.0.rc0.642.g800a2b2222-goog


