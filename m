Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9C44890
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393426AbfFMRIt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:08:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44511 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbfFMRDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id r16so2441950wrl.11;
        Thu, 13 Jun 2019 10:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GxCcO+M7AShhGpFpRgiyxF7HY5zzF8IQeYxesvPCT9E=;
        b=Id+xAM611ZgpDtXt8pKY0xqVi2URqxDVPGbL7dMtYpkHwOznp1Aw9VIhiLsP3PXyRt
         z84O1xhQi62I2mzIzS78AZSyUJaDS03xi/8nq4gaasOdQaA8LfCIACAUZg2uELARB6bB
         MzfBbtYGHCE6R8z8ua2OXDe4RmLksWZKaF6WcRCJ2iRpCm4MBXMDVqUigbU0XtRYawZc
         kjCwIJlxeNXJQgRLElRoAvW1S/n1Y+TuKp22oaEV49qswikOSsSnmUQtDaeM+m3+ir5V
         KghizBjF3k/VLWdym37N+pfwXk0YPhNg+zEAkCeGLXY18gwTpGnnqP+DdhXEds5hcCHR
         bxjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=GxCcO+M7AShhGpFpRgiyxF7HY5zzF8IQeYxesvPCT9E=;
        b=nm0KYf4o+a7xlzzuorpl+CKmsb/jROgxwMeiWUU6h+wPJcKlQtAJdgfCco7sUmhe29
         wpIFBLES10CQfQY3JSe3eSBVejc1clWNV3w788pFZRMUbr/PChV1G5UsEZ7nXcs7jBBH
         Tt37oLnGh4RCoIAeMpY7P8pVd3IMZcDzbh6qFdOtwDCIUp4gqwYys55U0HBYBWzl+lcM
         a8klB0as8cqCnyFA5uuVpgeBEqZ4FZibiMhqSL1D4ZflIH642Vx507D6OO2Sh7bJRv+A
         2la2JyJVdBSD9EZvTPJkw0ue1y4rc0OTxUsJKKQuhSYK1qpPujrKLF9x+NJ4xCN7+tvc
         Bmag==
X-Gm-Message-State: APjAAAUlB4F8UKKsFqsGhagfk7c+EKWx+AlDqu/X+Bx5Lk9gVP3j79oX
        oQPiyiMhoqaCXX1a6ITz/yf7P9Iy
X-Google-Smtp-Source: APXvYqx5tHhNNDsVU3hxOTz8Uc6f/RW98Wv0SV/16fsr7iSFgp521h3qouAeglLU841I8PgtzsZCyw==
X-Received: by 2002:adf:db02:: with SMTP id s2mr24574180wri.326.1560445427925;
        Thu, 13 Jun 2019 10:03:47 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:47 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 13/43] KVM: nVMX: Sync rarely accessed guest fields only when needed
Date:   Thu, 13 Jun 2019 19:02:59 +0200
Message-Id: <1560445409-17363-14-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Many guest fields are rarely read (or written) by VMMs, i.e. likely
aren't accessed between runs of a nested VMCS.  Delay pulling rarely
accessed guest fields from vmcs02 until they are VMREAD or until vmcs12
is dirtied.  The latter case is necessary because nested VM-Entry will
consume all manner of fields when vmcs12 is dirty, e.g. for consistency
checks.

Note, an alternative to synchronizing all guest fields on VMREAD would
be to read *only* the field being accessed, but switching VMCS pointers
is expensive and odds are good if one guest field is being accessed then
others will soon follow, or that vmcs12 will be dirtied due to a VMWRITE
(see above).  And the full synchronization results in slightly cleaner
code.

Note, although GUEST_PDPTRs are relevant only for a 32-bit PAE guest,
they are accessed quite frequently for said guests, and a separate patch
is in flight to optimize away GUEST_PDTPR synchronziation for non-PAE
guests.

Skipping rarely accessed guest fields reduces the latency of a nested
VM-Exit by ~200 cycles.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 140 +++++++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/vmx.h    |   7 +++
 2 files changed, 127 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a6fe6cfe96f6..6f7b572417a4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3376,20 +3376,57 @@ static u32 vmx_get_preemption_timer_value(struct kvm_vcpu *vcpu)
 	return value >> VMX_MISC_EMULATED_PREEMPTION_TIMER_RATE;
 }
 
-/*
- * Update the guest state fields of vmcs12 to reflect changes that
- * occurred while L2 was running. (The "IA-32e mode guest" bit of the
- * VM-entry controls is also updated, since this is really a guest
- * state bit.)
- */
-static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+static bool is_vmcs12_ext_field(unsigned long field)
 {
-	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
-	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
+	switch (field) {
+	case GUEST_ES_SELECTOR:
+	case GUEST_CS_SELECTOR:
+	case GUEST_SS_SELECTOR:
+	case GUEST_DS_SELECTOR:
+	case GUEST_FS_SELECTOR:
+	case GUEST_GS_SELECTOR:
+	case GUEST_LDTR_SELECTOR:
+	case GUEST_TR_SELECTOR:
+	case GUEST_ES_LIMIT:
+	case GUEST_CS_LIMIT:
+	case GUEST_SS_LIMIT:
+	case GUEST_DS_LIMIT:
+	case GUEST_FS_LIMIT:
+	case GUEST_GS_LIMIT:
+	case GUEST_LDTR_LIMIT:
+	case GUEST_TR_LIMIT:
+	case GUEST_GDTR_LIMIT:
+	case GUEST_IDTR_LIMIT:
+	case GUEST_ES_AR_BYTES:
+	case GUEST_DS_AR_BYTES:
+	case GUEST_FS_AR_BYTES:
+	case GUEST_GS_AR_BYTES:
+	case GUEST_LDTR_AR_BYTES:
+	case GUEST_TR_AR_BYTES:
+	case GUEST_ES_BASE:
+	case GUEST_CS_BASE:
+	case GUEST_SS_BASE:
+	case GUEST_DS_BASE:
+	case GUEST_FS_BASE:
+	case GUEST_GS_BASE:
+	case GUEST_LDTR_BASE:
+	case GUEST_TR_BASE:
+	case GUEST_GDTR_BASE:
+	case GUEST_IDTR_BASE:
+	case GUEST_PENDING_DBG_EXCEPTIONS:
+	case GUEST_BNDCFGS:
+		return true;
+	default:
+		break;
+	}
 
-	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
-	vmcs12->guest_rip = kvm_rip_read(vcpu);
-	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
+	return false;
+}
+
+static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
+				       struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	vmcs12->guest_es_selector = vmcs_read16(GUEST_ES_SELECTOR);
 	vmcs12->guest_cs_selector = vmcs_read16(GUEST_CS_SELECTOR);
@@ -3410,8 +3447,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_gdtr_limit = vmcs_read32(GUEST_GDTR_LIMIT);
 	vmcs12->guest_idtr_limit = vmcs_read32(GUEST_IDTR_LIMIT);
 	vmcs12->guest_es_ar_bytes = vmcs_read32(GUEST_ES_AR_BYTES);
-	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
-	vmcs12->guest_ss_ar_bytes = vmcs_read32(GUEST_SS_AR_BYTES);
 	vmcs12->guest_ds_ar_bytes = vmcs_read32(GUEST_DS_AR_BYTES);
 	vmcs12->guest_fs_ar_bytes = vmcs_read32(GUEST_FS_AR_BYTES);
 	vmcs12->guest_gs_ar_bytes = vmcs_read32(GUEST_GS_AR_BYTES);
@@ -3427,11 +3462,65 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_tr_base = vmcs_readl(GUEST_TR_BASE);
 	vmcs12->guest_gdtr_base = vmcs_readl(GUEST_GDTR_BASE);
 	vmcs12->guest_idtr_base = vmcs_readl(GUEST_IDTR_BASE);
+	vmcs12->guest_pending_dbg_exceptions =
+		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
+	if (kvm_mpx_supported())
+		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
+
+	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = false;
+}
+
+static void copy_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
+				       struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	int cpu;
+
+	if (!vmx->nested.need_sync_vmcs02_to_vmcs12_rare)
+		return;
+
+
+	WARN_ON_ONCE(vmx->loaded_vmcs != &vmx->vmcs01);
+
+	cpu = get_cpu();
+	vmx->loaded_vmcs = &vmx->nested.vmcs02;
+	vmx_vcpu_load(&vmx->vcpu, cpu);
+
+	sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+
+	vmx->loaded_vmcs = &vmx->vmcs01;
+	vmx_vcpu_load(&vmx->vcpu, cpu);
+	put_cpu();
+}
+
+/*
+ * Update the guest state fields of vmcs12 to reflect changes that
+ * occurred while L2 was running. (The "IA-32e mode guest" bit of the
+ * VM-entry controls is also updated, since this is really a guest
+ * state bit.)
+ */
+static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (vmx->nested.hv_evmcs)
+		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+
+	vmx->nested.need_sync_vmcs02_to_vmcs12_rare = !vmx->nested.hv_evmcs;
+
+	vmcs12->guest_cr0 = vmcs12_guest_cr0(vcpu, vmcs12);
+	vmcs12->guest_cr4 = vmcs12_guest_cr4(vcpu, vmcs12);
+
+	vmcs12->guest_rsp = kvm_rsp_read(vcpu);
+	vmcs12->guest_rip = kvm_rip_read(vcpu);
+	vmcs12->guest_rflags = vmcs_readl(GUEST_RFLAGS);
+
+	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
+	vmcs12->guest_ss_ar_bytes = vmcs_read32(GUEST_SS_AR_BYTES);
 
 	vmcs12->guest_interruptibility_info =
 		vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
-	vmcs12->guest_pending_dbg_exceptions =
-		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
+
 	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED)
 		vmcs12->guest_activity_state = GUEST_ACTIVITY_HLT;
 	else
@@ -3481,8 +3570,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
 	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
 	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
-	if (kvm_mpx_supported())
-		vmcs12->guest_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 }
 
 /*
@@ -4280,6 +4367,8 @@ static inline void nested_release_vmcs12(struct kvm_vcpu *vcpu)
 	if (vmx->nested.current_vmptr == -1ull)
 		return;
 
+	copy_vmcs02_to_vmcs12_rare(vcpu, get_vmcs12(vcpu));
+
 	if (enable_shadow_vmcs) {
 		/* copy to memory all shadowed fields in case
 		   they were modified */
@@ -4397,6 +4486,9 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_UNSUPPORTED_VMCS_COMPONENT);
 
+	if (!is_guest_mode(vcpu) && is_vmcs12_ext_field(field))
+		copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+
 	/* Read the field, zero-extended to a u64 field_value */
 	field_value = vmcs12_read_any(vmcs12, field, offset);
 
@@ -4495,9 +4587,16 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 		return nested_vmx_failValid(vcpu,
 			VMXERR_VMWRITE_READ_ONLY_VMCS_COMPONENT);
 
-	if (!is_guest_mode(vcpu))
+	if (!is_guest_mode(vcpu)) {
 		vmcs12 = get_vmcs12(vcpu);
-	else {
+
+		/*
+		 * Ensure vmcs12 is up-to-date before any VMWRITE that dirties
+		 * vmcs12, else we may crush a field or consume a stale value.
+		 */
+		if (!is_shadow_field_rw(field))
+			copy_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
+	} else {
 		/*
 		 * When vmcs->vmcs_link_pointer is -1ull, any VMWRITE
 		 * to shadowed-field sets the ALU flags for VMfailInvalid.
@@ -5317,6 +5416,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	 */
 	if (is_guest_mode(vcpu)) {
 		sync_vmcs02_to_vmcs12(vcpu, vmcs12);
+		sync_vmcs02_to_vmcs12_rare(vcpu, vmcs12);
 	} else if (!vmx->nested.need_vmcs12_to_shadow_sync) {
 		if (vmx->nested.hv_evmcs)
 			copy_enlightened_to_vmcs12(vmx);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index f4448292df0f..ed65999b07a8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -109,6 +109,7 @@ struct nested_vmx {
 	 * to guest memory during VM exit.
 	 */
 	struct vmcs12 *cached_shadow_vmcs12;
+
 	/*
 	 * Indicates if the shadow vmcs or enlightened vmcs must be updated
 	 * with the data held by struct vmcs12.
@@ -117,6 +118,12 @@ struct nested_vmx {
 	bool dirty_vmcs12;
 
 	/*
+	 * Indicates lazily loaded guest state has not yet been decached from
+	 * vmcs02.
+	 */
+	bool need_sync_vmcs02_to_vmcs12_rare;
+
+	/*
 	 * vmcs02 has been initialized, i.e. state that is constant for
 	 * vmcs02 has been written to the backing VMCS.  Initialization
 	 * is delayed until L1 actually attempts to run a nested VM.
-- 
1.8.3.1


