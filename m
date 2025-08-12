Return-Path: <kvm+bounces-54473-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69465B21B00
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 04:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D04B6284F5
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 02:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874D82E2F17;
	Tue, 12 Aug 2025 02:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kxcTuiT7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54EE13D8A4;
	Tue, 12 Aug 2025 02:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754967389; cv=none; b=otabR51NYlpp+zNby2G/qSGa7brN5NikuC3/4XZQpD4nSGIqXVpJLoWc8rRN5HttREyiyti+unrDAjy1yQtx9JuwZQtNOe/a2cXewpyScfATMmbnJYLcf3XIBBf29lZDsKjJXdk/oIoy4Mp2ej2Ptg56eF3sXJMdm8Nvd9AFSBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754967389; c=relaxed/simple;
	bh=59Lddcpsx0ltVEXxI4JbBZLMy6Ums8t0Jrpm7HGtKn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujdgFOTVslHKFr9dfNhHVmnGuRZKAOOQx2u2C8EJEFau63A4WG/Vgzpg1DidGngEo3gp4lR7BAUyTIgIM/1nViaqCKXyc/qdyrIiLeXX9F5c50LqKp5MHnfXUY6OO3TzfSHw3SFeZghK6sYCzz9y3PoIElnkLw09wyEMV4m1vls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kxcTuiT7; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754967388; x=1786503388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=59Lddcpsx0ltVEXxI4JbBZLMy6Ums8t0Jrpm7HGtKn4=;
  b=kxcTuiT7oWQSy1DwjWRfD1Yg7eZwv9AL41GDnEJPwaFPFrlk30+FkjJc
   ASHHrKpnSk83MJhd8ixSj5KhDkiGFmvR5yWtkB4J9uDOUzTbGACL5vUrd
   HZKBDrdN54w9BYB2Gr+VzFotC0GoT3osPA8MQUGBQRoUWipmYLYu/ZVbx
   6BZ71DMqvteJs2wndxATMba4XsDXykcVUCDSU0JNYl1O3iAo6ixDHlpVJ
   yEb/MOmap9XMNt4Pbti5A9sAFHDeDZj560hEEDy0OnAeEx0fLp2VJPJBn
   7NTTxIu87tCOIRLpSp1SKHch9ryqGwh8febwj1tEfyTxTk++PDwQnniHC
   Q==;
X-CSE-ConnectionGUID: uSDb3QFySuS0zKwuerezbg==
X-CSE-MsgGUID: 1G7TgS+rSDaVCawxWa/hkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57100429"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="57100429"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:23 -0700
X-CSE-ConnectionGUID: ZlS2m3n+TtaREeseP9aRng==
X-CSE-MsgGUID: aZ+matr2R/qcLazvMLmoSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="171321218"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 19:56:23 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mlevitsk@redhat.com,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	xin@zytor.com,
	Sean Christopherson <seanjc@google.com>,
	Chao Gao <chao.gao@intel.com>,
	Mathias Krause <minipli@grsecurity.net>,
	John Allen <john.allen@amd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v12 01/24] KVM: x86: Rename kvm_{g,s}et_msr()* to show that they emulate guest accesses
Date: Mon, 11 Aug 2025 19:55:09 -0700
Message-ID: <20250812025606.74625-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250812025606.74625-1-chao.gao@intel.com>
References: <20250812025606.74625-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yang Weijiang <weijiang.yang@intel.com>

Rename
	kvm_{g,s}et_msr_with_filter()
	kvm_{g,s}et_msr()
to
	kvm_emulate_msr_{read,write}
	__kvm_emulate_msr_{read,write}

to make it more obvious that KVM uses these helpers to emulate guest
behaviors, i.e., host_initiated == false in these helpers.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v12: use less verbose function names -- Sean/Xin
---
 arch/x86/include/asm/kvm_host.h |  8 ++++----
 arch/x86/kvm/smm.c              |  4 ++--
 arch/x86/kvm/vmx/nested.c       | 14 +++++++-------
 arch/x86/kvm/x86.c              | 26 +++++++++++++-------------
 4 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..86e4d0b8469b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2149,11 +2149,11 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
-int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data);
-int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data);
+int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data, bool host_initiated);
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data);
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data);
+int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data);
+int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data);
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu);
 int kvm_emulate_as_nop(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index 9864c057187d..5dd8a1646800 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -529,7 +529,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt,
 
 	vcpu->arch.smbase =         smstate->smbase;
 
-	if (kvm_set_msr(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
+	if (__kvm_emulate_msr_write(vcpu, MSR_EFER, smstate->efer & ~EFER_LMA))
 		return X86EMUL_UNHANDLEABLE;
 
 	rsm_load_seg_64(vcpu, &smstate->tr, VCPU_SREG_TR);
@@ -620,7 +620,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 
 		/* And finally go back to 32-bit mode.  */
 		efer = 0;
-		kvm_set_msr(vcpu, MSR_EFER, efer);
+		__kvm_emulate_msr_write(vcpu, MSR_EFER, efer);
 	}
 #endif
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b8ea1969113d..7dc2e1c09ea6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -997,7 +997,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
 				__func__, i, e.index, e.reserved);
 			goto fail;
 		}
-		if (kvm_set_msr_with_filter(vcpu, e.index, e.value)) {
+		if (kvm_emulate_msr_write(vcpu, e.index, e.value)) {
 			pr_debug_ratelimited(
 				"%s cannot write MSR (%u, 0x%x, 0x%llx)\n",
 				__func__, i, e.index, e.value);
@@ -1033,7 +1033,7 @@ static bool nested_vmx_get_vmexit_msr_value(struct kvm_vcpu *vcpu,
 		}
 	}
 
-	if (kvm_get_msr_with_filter(vcpu, msr_index, data)) {
+	if (kvm_emulate_msr_read(vcpu, msr_index, data)) {
 		pr_debug_ratelimited("%s cannot read MSR (0x%x)\n", __func__,
 			msr_index);
 		return false;
@@ -2770,8 +2770,8 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 
 	if ((vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)) &&
-	    WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-				     vmcs12->guest_ia32_perf_global_ctrl))) {
+	    WARN_ON_ONCE(__kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+						 vmcs12->guest_ia32_perf_global_ctrl))) {
 		*entry_failure_code = ENTRY_FAIL_DEFAULT;
 		return -EINVAL;
 	}
@@ -4758,8 +4758,8 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	}
 	if ((vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL) &&
 	    kvm_pmu_has_perf_global_ctrl(vcpu_to_pmu(vcpu)))
-		WARN_ON_ONCE(kvm_set_msr(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
-					 vmcs12->host_ia32_perf_global_ctrl));
+		WARN_ON_ONCE(__kvm_emulate_msr_write(vcpu, MSR_CORE_PERF_GLOBAL_CTRL,
+						     vmcs12->host_ia32_perf_global_ctrl));
 
 	/* Set L1 segment info according to Intel SDM
 	    27.5.2 Loading Host Segment and Descriptor-Table Registers */
@@ -4937,7 +4937,7 @@ static void nested_vmx_restore_host_state(struct kvm_vcpu *vcpu)
 				goto vmabort;
 			}
 
-			if (kvm_set_msr_with_filter(vcpu, h.index, h.value)) {
+			if (kvm_emulate_msr_write(vcpu, h.index, h.value)) {
 				pr_debug_ratelimited(
 					"%s WRMSR failed (%u, 0x%x, 0x%llx)\n",
 					__func__, j, h.index, h.value);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a1c49bc681c4..09b106a5afdf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1932,33 +1932,33 @@ static int kvm_get_msr_ignored_check(struct kvm_vcpu *vcpu,
 				 __kvm_get_msr);
 }
 
-int kvm_get_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+int kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_READ))
 		return KVM_MSR_RET_FILTERED;
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr_with_filter);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_read);
 
-int kvm_set_msr_with_filter(struct kvm_vcpu *vcpu, u32 index, u64 data)
+int kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	if (!kvm_msr_allowed(vcpu, index, KVM_MSR_FILTER_WRITE))
 		return KVM_MSR_RET_FILTERED;
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr_with_filter);
+EXPORT_SYMBOL_GPL(kvm_emulate_msr_write);
 
-int kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data)
+int __kvm_emulate_msr_read(struct kvm_vcpu *vcpu, u32 index, u64 *data)
 {
 	return kvm_get_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_get_msr);
+EXPORT_SYMBOL_GPL(__kvm_emulate_msr_read);
 
-int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
+int __kvm_emulate_msr_write(struct kvm_vcpu *vcpu, u32 index, u64 data)
 {
 	return kvm_set_msr_ignored_check(vcpu, index, data, false);
 }
-EXPORT_SYMBOL_GPL(kvm_set_msr);
+EXPORT_SYMBOL_GPL(__kvm_emulate_msr_write);
 
 static void complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
 {
@@ -2030,7 +2030,7 @@ int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 	u64 data;
 	int r;
 
-	r = kvm_get_msr_with_filter(vcpu, ecx, &data);
+	r = kvm_emulate_msr_read(vcpu, ecx, &data);
 
 	if (!r) {
 		trace_kvm_msr_read(ecx, data);
@@ -2055,7 +2055,7 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	u64 data = kvm_read_edx_eax(vcpu);
 	int r;
 
-	r = kvm_set_msr_with_filter(vcpu, ecx, data);
+	r = kvm_emulate_msr_write(vcpu, ecx, data);
 
 	if (!r) {
 		trace_kvm_msr_write(ecx, data);
@@ -8353,7 +8353,7 @@ static int emulator_get_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
-	r = kvm_get_msr_with_filter(vcpu, msr_index, pdata);
+	r = kvm_emulate_msr_read(vcpu, msr_index, pdata);
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
 
@@ -8376,7 +8376,7 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
 	int r;
 
-	r = kvm_set_msr_with_filter(vcpu, msr_index, data);
+	r = kvm_emulate_msr_write(vcpu, msr_index, data);
 	if (r < 0)
 		return X86EMUL_UNHANDLEABLE;
 
@@ -8396,7 +8396,7 @@ static int emulator_set_msr_with_filter(struct x86_emulate_ctxt *ctxt,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+	return __kvm_emulate_msr_read(emul_to_vcpu(ctxt), msr_index, pdata);
 }
 
 static int emulator_check_rdpmc_early(struct x86_emulate_ctxt *ctxt, u32 pmc)
-- 
2.47.1


