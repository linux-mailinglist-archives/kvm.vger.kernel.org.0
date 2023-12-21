Return-Path: <kvm+bounces-4990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9D881B1CA
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 10:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CEA6EB268AB
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 09:12:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B074E4E1D5;
	Thu, 21 Dec 2023 09:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LTJzGaNi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E41F4CDF9;
	Thu, 21 Dec 2023 09:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703149428; x=1734685428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mnzEVlzgWkMulqUCa41he1GtyrHqz8Magus+6evCOOA=;
  b=LTJzGaNizoqYbxkx2pqnJ0yXqtm8ANr0PCM7x2J0G+kbQE7erB9Egb3+
   rrMb0nbCWI82+AQg/2Mlm/gf/SucAFsP27wHndt9niAydOqAoseNJPLHt
   SqQp5IOUVnvqqiAFkNlclWFBBpxfb+8tQSJ+xhUmHkk7H9HCig+ZnsV/X
   TbGNmiLvOp9fDhYWKllWTcX7l7xzGD3OJT77wa5c6DOKK1dp+3aCuCou7
   HT/bIp6aVlHbFwDJQGcsGURX5CTpItDuARISmk6F2ODrD6B66eBZKmtbE
   8uTkgaZZ5zLUtUMaAgBtnsJNmiw9JgD1zKGdbm87vJ1ZeJmJSf4soZxtn
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="398729624"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="398729624"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="900028587"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="900028587"
Received: from 984fee00a5ca.jf.intel.com (HELO embargo.jf.intel.com) ([10.165.9.183])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2023 01:03:10 -0800
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
Subject: [PATCH v8 09/26] KVM: x86: Rename kvm_{g,s}et_msr() to menifest emulation operations
Date: Thu, 21 Dec 2023 09:02:22 -0500
Message-Id: <20231221140239.4349-10-weijiang.yang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20231221140239.4349-1-weijiang.yang@intel.com>
References: <20231221140239.4349-1-weijiang.yang@intel.com>
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


