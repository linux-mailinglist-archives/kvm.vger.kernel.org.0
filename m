Return-Path: <kvm+bounces-55290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F756B2FACC
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:42:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 600F6601805
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2408353356;
	Thu, 21 Aug 2025 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mN65ToEf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F22034DCE6;
	Thu, 21 Aug 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783131; cv=none; b=iYlswC/x3OcNDUCX/VL2HvZ82K/qyDg6Z4EG3isOn4PJLoR/vrOROSKIaMyKCBo6VW+btXu/02dXi3tqoWSCscB2VQpYt2XAPrpukIqMQ7Ep6Yp+9w718EeCox+RCYeEtdQPZgn1vX9uaECiHWM+2hyUp4k4HErQ3sAZl1D2ZpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783131; c=relaxed/simple;
	bh=CH8oFLP6cF5J3EtZ+6/4WW4Qp3XIvM5HDKP9wMniKXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i+ddOeD39p7oP+OwTHVl91kxO0j9mSm7VR1TBYChr4/sCP3TXk4W3jqGOC2miHxpUGH2+7LXXX6unILnju2S3w3VjmGcehWssfPlqE2ZiJISbnUoU5szpbtcpAh+zpcTJ2NTYn4nHlwiPQP1CngcZPBbnBX7tpIzOPRj3Tiwvbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mN65ToEf; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783129; x=1787319129;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CH8oFLP6cF5J3EtZ+6/4WW4Qp3XIvM5HDKP9wMniKXc=;
  b=mN65ToEfZ0zlzGWxwpaBw8JlR53GXzvJRxz2SCiZ8DTfrrqU4sinvcw6
   lO7GAVWeVSvHGh1XSdA9/cSEKfLxk5OYM/zqlGftsUy+AOfEJ0vjjUn+U
   VWZRHVGxepMUqhmVI4amr3QBd72hilNbJt+IiOhsp++H6Y6rXDD73EiO9
   92wDRurFX70bIqMG4fWEplQm2hRuLeq95eF3egV5y/T6QncdWYFiO7slW
   ThVsu9z/jueCb43U3YzNsyElCyFS+U9k+L8XyhVPAAStMlU0syMnG9QwP
   +3dtNMUbRaZoc7KHTeDSew8a2R8rEqOd3l5OMsBjTPq1LXLD961fuy6z4
   w==;
X-CSE-ConnectionGUID: 9PZ7f3+1TC+giXKRN8ognA==
X-CSE-MsgGUID: LAcU5jQcReGVsFPd5H+rLw==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446188"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446188"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: l3J0X3IoQCuHF7SQ+JgyKw==
X-CSE-MsgGUID: UtJLGRmmS3mfloYfCn+Hdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285422"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:50 -0700
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
Subject: [PATCH v13 13/21] KVM: VMX: Set host constant supervisor states to VMCS fields
Date: Thu, 21 Aug 2025 06:30:47 -0700
Message-ID: <20250821133132.72322-14-chao.gao@intel.com>
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

From: Yang Weijiang <weijiang.yang@intel.com>

Save constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} field explicitly.
Kernel IBT is supported and the setting in MSR_IA32_S_CET is static after
post-boot(The exception is BIOS call case but vCPU thread never across it)
and KVM doesn't need to refresh HOST_S_CET field before every VM-Enter/
VM-Exit sequence.

Host supervisor shadow stack is not enabled now and SSP is not accessible
to kernel mode, thus it's safe to set host IA32_INT_SSP_TAB/SSP VMCS field
to 0s. When shadow stack is enabled for CPL3, SSP is reloaded from PL3_SSP
before it exits to userspace. Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/
SYSRET/SYSENTER SYSEXIT/RDSSP/CALL etc.

Prevent KVM module loading if host supervisor shadow stack SHSTK_EN is set
in MSR_IA32_S_CET as KVM cannot co-exit with it correctly.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 32 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index 5316c27f6099..7d290b2cb0f4 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -103,6 +103,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
 }
 
+static inline bool cpu_has_load_cet_ctrl(void)
+{
+	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
+}
 static inline bool cpu_has_vmx_mpx(void)
 {
 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_BNDCFGS;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index adf5af30e537..e8155635cb42 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4320,6 +4320,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 	if (cpu_has_load_ia32_efer())
 		vmcs_write64(HOST_IA32_EFER, kvm_host.efer);
+
+	/*
+	 * Supervisor shadow stack is not enabled on host side, i.e.,
+	 * host IA32_S_CET.SHSTK_EN bit is guaranteed to 0 now, per SDM
+	 * description(RDSSP instruction), SSP is not readable in CPL0,
+	 * so resetting the two registers to 0s at VM-Exit does no harm
+	 * to kernel execution. When execution flow exits to userspace,
+	 * SSP is reloaded from IA32_PL3_SSP. Check SDM Vol.2A/B Chapter
+	 * 3 and 4 for details.
+	 */
+	if (cpu_has_load_cet_ctrl()) {
+		vmcs_writel(HOST_S_CET, kvm_host.s_cet);
+		vmcs_writel(HOST_SSP, 0);
+		vmcs_writel(HOST_INTR_SSP_TABLE, 0);
+	}
 }
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dfd94146846e..34e4b2c4b892 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9893,6 +9893,18 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -EIO;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
+		rdmsrq(MSR_IA32_S_CET, kvm_host.s_cet);
+		/*
+		 * Linux doesn't yet support supervisor shadow stacks (SSS), so
+		 * KVM doesn't save/restore the associated MSRs, i.e. KVM may
+		 * clobber the host values.  Yell and refuse to load if SSS is
+		 * unexpectedly enabled, e.g. to avoid crashing the host.
+		 */
+		if (WARN_ON_ONCE(kvm_host.s_cet & CET_SHSTK_EN))
+			return -EIO;
+	}
+
 	memset(&kvm_caps, 0, sizeof(kvm_caps));
 
 	x86_emulator_cache = kvm_alloc_emulator_cache();
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 256e59aa9359..27fec4ed4c4e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -50,6 +50,7 @@ struct kvm_host_values {
 	u64 efer;
 	u64 xcr0;
 	u64 xss;
+	u64 s_cet;
 	u64 arch_capabilities;
 };
 
-- 
2.47.3


