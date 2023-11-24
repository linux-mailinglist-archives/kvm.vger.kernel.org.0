Return-Path: <kvm+bounces-2406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C35CC7F6D70
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:59:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4716A1F20EF0
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 07:59:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1DF171B8;
	Fri, 24 Nov 2023 07:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="klU7WTOS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6BB1736;
	Thu, 23 Nov 2023 23:58:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700812724; x=1732348724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+zVTw2NMqAsR3RP45H+LXwxmk3uDyVsGEKOnqyimkHw=;
  b=klU7WTOSIRweKZ851phUD+TOl3Mx3H1VkNZZHgu5suvQXQ68rcypZk7r
   HfDJ9CgX9hKfpZDE+ziRRLRtLFJc3O7XnCjTS9LsY/fpfmMWda/WnuGtl
   pN4hLKYqhF0CZTW6crtil1V4egMpQldSszWJLb8/SazjrcpIXr6KsBRCy
   XG0L3zQnuAaQXmu8/QC6RvXPpwU9CrxCZULvq/rRcPDU5AK8hp5SQ06mj
   npSnF/yt5TrRvtqcaSFDEhtr33cYlK7Wa+C3ssAxzT9JBrdb6O90ug1bH
   +KzZf2fO/iLg2JwTX1OUzzcWD6zEnX+mkk8d/qodiHSiJvBFw03OIR752
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="458872314"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="458872314"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="833629817"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="833629817"
Received: from unknown (HELO embargo.jf.intel.com) ([10.165.9.183])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 23:58:37 -0800
From: Yang Weijiang <weijiang.yang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com
Subject: [PATCH v7 09/26] KVM: x86: Rename kvm_{g,s}et_msr() to menifest emulation operations
Date: Fri, 24 Nov 2023 00:53:13 -0500
Message-Id: <20231124055330.138870-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231124055330.138870-1-weijiang.yang@intel.com>
References: <20231124055330.138870-1-weijiang.yang@intel.com>
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
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/smm.c              |  4 ++--
 arch/x86/kvm/vmx/nested.c       | 13 +++++++------
 arch/x86/kvm/x86.c              | 10 +++++-----
 4 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d7036982332e..5cfa18aaf33f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1967,8 +1967,8 @@ void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
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
index c5ec0ef51ff7..2034337681f9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -927,7 +927,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
-		if (kvm_set_msr(vcpu, e.index, e.value)) {
+		if (kvm_emulate_msr_write(vcpu, e.index, e.value)) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
 				__func__, i, e.index, e.value);
@@ -963,7 +963,7 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (kvm_get_msr(vcpu, msr_index, data)) {
+	if (kvm_emulate_msr_read(vcpu, msr_index, data)) {
 		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
 			msr_index);
 		return false;
@@ -2649,7 +2649,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
-	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+	    WARN_ON_ONCE(kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
 				     vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
@@ -4524,8 +4524,9 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
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
@@ -4700,7 +4701,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 				goto vmabort;
 			}
 
-			if (kvm_set_msr(vcpu, h.index, h.value)) {
+			if (kvm_emulate_msr_write(vcpu, h.index, h.value)) {
 				pr_debug_ratelimited(
 					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
 					__func__, j, h.index, h.value);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..b9c2c0cd4cf5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1973,17 +1973,17 @@ static int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
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
@@ -8329,7 +8329,7 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+	return kvm_emulate_msr_read(emul_to_vcpu(ctxt), msr_index, pdata);
 }
 
 static int emulator_check_pmc(struct x86_emulate_ctxt *ctxt,
-- 
2.27.0


