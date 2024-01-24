Return-Path: <kvm+bounces-6757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3B4B839F64
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 03:45:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9438F2888EF
	for <lists+kvm@lfdr.de>; Wed, 24 Jan 2024 02:45:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFE817573;
	Wed, 24 Jan 2024 02:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i9OJaSVb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD768FBF6;
	Wed, 24 Jan 2024 02:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064160; cv=none; b=ZulyoLAK6r8j7KWeHG156gU3/9c+Yc6jTR2opmQZr4L1wnU4ehEBDSsLCnLFILTpc5UqKNbq5zceQppU4jXgEeNQD/uRNbeTPmBwgDZcvABO8AsBsf3VlpPflu1AcOWhHoloiPx4TC3lfReIzZr5oXz7ItVFfqaWy3ThVTBoC1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064160; c=relaxed/simple;
	bh=mnzEVlzgWkMulqUCa41he1GtyrHqz8Magus+6evCOOA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nK/KNQvFX2GcYkTE/UpZdp0unPrZcxz1KtwvXQwq9mqaVS+0qRNJoVxHDI40ZaE/BVSJoOEul9SPsHA1aptacpZg8lh/uIT1n83qKTnoRtOeYlmXO8i1sffxwyxbGNvKxUAmiXMSSCSBqRlqoHwRoeFslNt3X7BovuuSJ+Mka1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i9OJaSVb; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706064158; x=1737600158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mnzEVlzgWkMulqUCa41he1GtyrHqz8Magus+6evCOOA=;
  b=i9OJaSVbTEex5kpuog4ExnbY6MFevjv9eZl40a7FB+OAhgcPJtk/Hakq
   enrNaPJgHN5G4Q3SRVa5RybEzhyMz3CKX2dkvRtrr5yzAa7n8YygzE8Pz
   NcS1B3O4x0/EU1uCg0b2xIRGv6bqmY2FVs5syyDJkG8rFgvi3vYOLCTfP
   RE7+3jfjXqL/iCDjhzKnkJIwG1WfnrZKGN1M5WmoaPe2Cj9HCxSRGxPIX
   1f79sfq9ZA9CJTpAhR/3gD+A4/OlzefuoL85AzVDuto0X7pLCfc3sOyAz
   UsV3VOhwxxGZU5p+pV+3Kp97cFPriCNmwgJGjcdI3VSdUUA3c88Lo9QSj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="400586471"
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="400586471"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,215,1701158400"; 
   d="scan'208";a="1825852"
Received: from 984fee00a5ca.jf.intel.com ([10.165.9.183])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2024 18:42:35 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	yuan.yao@linux.intel.com
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v9 09/27] KVM: x86: Rename kvm_{g,s}et_msr() to menifest emulation operations
Date: Tue, 23 Jan 2024 18:41:42 -0800
Message-Id: <20240124024200.102792-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20240124024200.102792-1-weijiang.yang@intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename kvm_{g,s}et_msr() to kvm_emulate_msr_{read,write}() to make it
more obvious that KVM uses these helpers to emulate guest behaviors,
i.e., host_initiated == false in these helpers.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/smm.c              |  4 ++--
 arch/x86/kvm/vmx/nested.c       | 13 +++++++------
 arch/x86/kvm/x86.c              | 10 +++++-----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7bc1daf68741..5c665165024c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2013,8 +2013,8 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
 int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
+int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index dc3d95fdca7d..45c855389ea7 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -535,7 +535,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 
 	vcpu->arch.smbase =         smstate->smbase;
 
-	if (kvm_set_msr(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
+	if (kvm_emulate_msr_write(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
 		return X86EMUL_UNHANDLEABLE;
 
 	rsm_load_seg_64(vcpu, &smstate->tr, VCPU_SREG_TR);
@@ -626,7 +626,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 
 		/* And finally go back to 32-bit mode.  */
 		efer = 0;
-		kvm_set_msr(vcpu, MSR_EFER, efer);
+		kvm_emulate_msr_write(vcpu, MSR_EFER, efer);
 	}
 #endif
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index db0ad1e6ec4b..b2e9853584b8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -958,7 +958,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
-		if (kvm_set_msr(vcpu, e.index, e.value)) {
+		if (kvm_emulate_msr_write(vcpu, e.index, e.value)) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
 				__func__, i, e.index, e.value);
@@ -994,7 +994,7 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (kvm_get_msr(vcpu, msr_index, data)) {
+	if (kvm_emulate_msr_read(vcpu, msr_index, data)) {
 		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
 			msr_index);
 		return false;
@@ -2686,7 +2686,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
-	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+	    WARN_ON_ONCE(kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
@@ -4568,8 +4568,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	}
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
-		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-					 vmcs12->host_ia32_perf_global_ctrl));
+		WARN_ON_ONCE(kvm_emulate_msr_write(vcpu,
+					MSR_CORE_PERF_GLOBAL_CTRL,
+					vmcs12->host_ia32_perf_global_ctrl));
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
@@ -4744,7 +4745,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 				goto vmabort;
 			}
 
-			if (kvm_set_msr(vcpu, h.index, h.value)) {
+			if (kvm_emulate_msr_write(vcpu, h.index, h.value)) {
 				pr_debug_ratelimited(
 					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
 					__func__, j, h.index, h.value);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..0e7dc3398293 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1976,17 +1976,17 @@ static int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
 
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_read);
 
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
+int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_write);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {
@@ -8386,7 +8386,7 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+	return kvm_emulate_msr_read(emul_to_vcpu(ctxt), msr_index, pdata);
 }
 
 static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
-- 
2.39.3


