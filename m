Return-Path: <kvm+bounces-55280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F55CB2FABE
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:41:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2D25CAE40DC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:34:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CDBA341640;
	Thu, 21 Aug 2025 13:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CjzDwIqn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FBD338F53;
	Thu, 21 Aug 2025 13:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783124; cv=none; b=GHWsVdrgrqCWdPjaaNhGKiEuazWPM01MAynBAR/d6mnwqGttluhbmhop6vJ4SAaGj2SlWACTysdrP+P5sXZyH1LutDDAfFOE5zdwDn8N4clH8TAhncKlBZgx8MY6v9IPX1WLMhfrR1JADXpjxI3mu0+a+XXq8AdlgXrsZ096o9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783124; c=relaxed/simple;
	bh=a5VtupWJ1oGM8gpq46Igy6WhBl1c+IHc69V77OtVq9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDv7i+Ebm9gqK/7lVuOieenJspjYMqXG4/V6wNmSfB2PBidFxD6vKHjMiQLytIkn+74WQWDhnNoDIq2p0tt7RO3EHQaaUzDSx9e6qq21XrrcT/4tAgMahaMTMgcu/aMF0RAZgYwfJ/4XG6K+tLJHtXS++0h1ea3hyCWqzXiUkfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CjzDwIqn; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783122; x=1787319122;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a5VtupWJ1oGM8gpq46Igy6WhBl1c+IHc69V77OtVq9Q=;
  b=CjzDwIqnPXvIYcaHSN6LvbQ2oVXZcawU8JICqDJAHZwf8up3kcL6z+Sh
   PPb7Q+Cd/r7fwvCvg/B8EmXkUA85v7/spxk5uleJcBY+cHzH+Y3ejYQsh
   wRCn/CGj/HKZrSiind0JI8LkipxoAeyVx6zyuWLA2uoOB7JTFWAVJthHZ
   ClnnrK3iEh0gQjgscMjCB7Jq1YlgkwAveaJeqdABdLi7ZabkR5dhFZtCb
   kAqBOGS7m9dYWy4ISqENQ0DRJnXxYGao8nlLmw7j4ZlMb7y1FPvdWI+EI
   oL4b2H7ktmdzFYQ+aj7ijjca5B3rhEwcSW4xRp609id6XuJuli6VWjdih
   Q==;
X-CSE-ConnectionGUID: ZAe9+OfJRJ2SvuLDD1Rk6A==
X-CSE-MsgGUID: pIDUO16CTxu8s+CUcvtUQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446083"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446083"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:00 -0700
X-CSE-ConnectionGUID: E5IxRR0DT0ykNtaXn5+4+Q==
X-CSE-MsgGUID: mjW6vHxfRQ21xL+dUYpJOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285396"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:42 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 05/21] KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
Date: Thu, 21 Aug 2025 06:30:39 -0700
Message-ID: <20250821133132.72322-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
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
 arch/x86/kvm/x86.c | 35 ++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.h | 24 ++++++++++++++++++++++++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6b01c6e9330e..799ac76679c9 100644
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
@@ -4566,6 +4569,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 }
 EXPORT_SYMBOL_GPL(kvm_get_msr_common);
 
+/*
+ *  Returns true if the MSR in question is managed via XSTATE, i.e. is context
+ *  switched with the rest of guest FPU state.
+ */
+static bool is_xstate_managed_msr(u32 index)
+{
+	switch (index) {
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
@@ -4576,11 +4594,26 @@ static int __msr_io(struct kvm_vcpu *vcpu, struct kvm_msrs *msrs,
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
index eb3088684e8a..d90f1009ac10 100644
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
+	rdmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
+static inline void kvm_set_xstate_msr(struct kvm_vcpu *vcpu,
+				      struct msr_data *msr_info)
+{
+	KVM_BUG_ON(!vcpu->arch.guest_fpu.fpstate->in_use, vcpu->kvm);
+	kvm_fpu_get();
+	wrmsrl(msr_info->index, msr_info->data);
+	kvm_fpu_put();
+}
+
 #endif
-- 
2.47.3


