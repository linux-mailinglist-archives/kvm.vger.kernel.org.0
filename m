Return-Path: <kvm+bounces-57071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2807B4A86F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:43:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 72E4D4466FF
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:41:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2117C2D781E;
	Tue,  9 Sep 2025 09:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XU4AwdMJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0022D2496;
	Tue,  9 Sep 2025 09:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410802; cv=none; b=suVGBXqcW500p7wjDFPiyKUne7i1vq92PMhdIOhQfSwX/U7swt3P9OPeL3+CeUifNuHgkn/T/kQonKW7483WXECtLtX7c3dPLVJQnlxQhDw2i9L7rCz8OAfMzf7kzk9hhs7T9kOY/FicagrDZ07mm8bpvlTlj26XDlYNF7UuhWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410802; c=relaxed/simple;
	bh=8pLjPioMN6KH/wXQkjjfphL22gwbwTJnC2YBCe5LjCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7jiP0guPZC+B8jCLAKOZKsFZpUSPEKrgaNOkk+LiL6zplm6jUbqeypAwx9nTkK85LWq9eU2K4wosuNtMNOiVZOBe+UWkd/M1rh91JNzfNThkxycftDWKxHLRG+umSs+lixGb1L57pbYzuU6MLOZrAqht7dljwZnLSXGO/sv+TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XU4AwdMJ; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410800; x=1788946800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8pLjPioMN6KH/wXQkjjfphL22gwbwTJnC2YBCe5LjCA=;
  b=XU4AwdMJPIxZwAZnKnqKzsc8siKsMWDlXCMYGhA+GyQy1s8XjqMrUKM8
   P0vZ6EStHiz4I+nzlGI/XfaFWCm07VCbHxrqAlqS8woq8FQ1u1ZFyiXwB
   XqqsRzW3t/rB5y0YJlorA4b3h5Ep613e+H2YVgp8tFYdtQBjjpxsXEZZQ
   muuKqnmtT0W1Ovd1fQiaiv0BsfEmv3yxgJilHFbXmMWasw7Fz0VDuvaAw
   svDFDDXoXIHusv+n+Bvg72ZX5IkAMaV4Rck3FuQDTuOLS2lEQxsE3dJZB
   8n5vIBedQ5wLY7SmsyDHmldC66toa0zCX2yh4mmuXZft+MUQ71OkhGMVM
   A==;
X-CSE-ConnectionGUID: HKxDQvOeRBefTB0dn8005Q==
X-CSE-MsgGUID: I8nZ+cm1R7mRFwmDioh+tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307222"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307222"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:55 -0700
X-CSE-ConnectionGUID: K+2Gp9GeS6O+KqzF+emYIw==
X-CSE-MsgGUID: Aius937KS9ujdgZ7LuAdFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207403"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:55 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 06/22] KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
Date: Tue,  9 Sep 2025 02:39:37 -0700
Message-ID: <20250909093953.202028-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Load the guest's FPU state if userspace is accessing MSRs whose values
are managed by XSAVES. Introduce two helpers, kvm_{get,set}_xstate_msr(),
to facilitate access to such kind of MSRs.

If MSRs supported in kvm_caps.supported_xss are passed through to guest,
the guest MSRs are swapped with host's before vCPU exits to userspace and
after it reenters kernel before next VM-entry.

Because the modified code is also used for the KVM_GET_MSRS device ioctl(),
explicitly check @vcpu is non-null before attempting to load guest state.
The XSAVE-managed MSRs cannot be retrieved via the device ioctl() without
loading guest FPU state (which doesn't exist).

Note that guest_cpuid_has() is not queried as host userspace is allowed to
access MSRs that have not been exposed to the guest, e.g. it might do
KVM_SET_MSRS prior to KVM_SET_CPUID2.

The two helpers are put here in order to manifest accessing xsave-managed
MSRs requires special check and handling to guarantee the correctness of
read/write to the MSRs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Co-developed-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
v14:
- s/rdmsrl/rdmsrq, s/wrmsrl/wrmsrq (Xin)
- return true in is_xstate_managed_msr() for MSR_IA32_S_CET
---
 arch/x86/kvm/x86.c | 36 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h | 24 ++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c15e8c00dc7d..7c0a07be6b64 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -136,6 +136,9 @@ static int __set_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2);
 
 static DEFINE_MUTEX(vendor_module_lock);
+static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu);
+static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 
 #define KVM_X86_OP(func)					     \
@@ -4566,6 +4569,22 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+/*
+ *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
+ *  switched with the rest of guest FPU state.
+ */
+static bool is_xstate_managed_msr(u32 index)
+{
+	switch (index) {
+	case MSR_IA32_S_CET:
+	case MSR_IA32_U_CET:
+	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*
  * Read or write a bunch of msrs. All parameters are kernel addresses.
  *
@@ -4576,11 +4595,26 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
 		    int (*do_msr)(struct kvm_vcpu *vcpu,
 				  unsigned index, u64 *data))
 {
+	bool fpu_loaded = false;
 	int i;
 
-	for (i = 0; i < msrs->nmsrs; ++i)
+	for (i = 0; i < msrs->nmsrs; ++i) {
+		/*
+		 * If userspace is accessing one or more XSTATE-managed MSRs,
+		 * temporarily load the guest's FPU state so that the guest's
+		 * MSR value(s) is resident in hardware, i.e. so that KVM can
+		 * get/set the MSR via RDMSR/WRMSR.
+		 */
+		if (vcpu && !fpu_loaded && kvm_caps.supported_xss &&
+		    is_xstate_managed_msr(entries[i].index)) {
+			kvm_load_guest_fpu(vcpu);
+			fpu_loaded = true;
+		}
 		if (do_msr(vcpu, entries[i].index, &entries[i].data))
 			break;
+	}
+	if (fpu_loaded)
+		kvm_put_guest_fpu(vcpu);
 
 	return i;
 }
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index eb3088684e8a..34afe43579bb 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -701,4 +701,28 @@ int ____kvm_emulate_hypercall(struct kvm_vcpu *vcpu, int cpl,
 
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
+/*
+ * Lock and/or reload guest FPU and access xstate MSRs. For accesses initiated
+ * by host, guest FPU is loaded in __msr_io(). For accesses initiated by guest,
+ * guest FPU should have been loaded already.
+ */
+
+static inline void kvm_get_xstate_msr(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr_info)
+{
+	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
+	kvm_fpu_get();
+	rdmsrq(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr_info)
+{
+	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
+	kvm_fpu_get();
+	wrmsrq(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
 #endif
-- 
2.47.3


