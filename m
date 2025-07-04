Return-Path: <kvm+bounces-51585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A709AF8CFE
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 10:58:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05FF0764E19
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 919CF2F50BC;
	Fri,  4 Jul 2025 08:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iDgI+A72"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63A72F3C1D;
	Fri,  4 Jul 2025 08:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619052; cv=none; b=MEjtHe29RFoAqgSmGjIAbJouUvmR4TQRXdpDOGwx7hBwdneSA/guSUjnNeGiXErhokcuI7ejtzukJ2zFAnB/+gV29aEU2zVtiypPNrUl/RXjYq7dziMIVJAnwv9w/lnU4+Zt80e0zwcLCp2pTh3K/QNQVfHI8UxQh9dRpy5ZqVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619052; c=relaxed/simple;
	bh=nv2RAE0OageOtvQQzhopp7CbMfGiLnkE692bRmNksbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXrHBFXCYMmQf7+xyPdkdbxacZ5s0Gc5Z3KPOXMP3WU5WfEXSZdDfqdU8kzKX0Hkk14owKMH86c+9PHa4sZbgCT3OsmcGppVlu7rTs9jVN+YA9cGDXPO12dGdLDEy3EYfRKbMlfulj3+iqiB4FSC0zLrA2Nl9GpYGwh32RRptek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iDgI+A72; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619050; x=1783155050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nv2RAE0OageOtvQQzhopp7CbMfGiLnkE692bRmNksbA=;
  b=iDgI+A724xY4IcE7wyxgmIhko/vt9yCPU5MZnO9NXB/jqp56LAH+2IjZ
   zxU23hiN3mSPNrHlSkHm/LOf3uOsU0sPZbuPVEp3Cc1ThzJnvrYqz8bHN
   axKJVLh1zcNNhsnH4283FMUaKq8X6chdgvpgyKK68oEYSXD0s3NsYHQAl
   i3D+EufBO/58FoKNS0nzn6EUTjOiEaOd/eIykSsl2Mz6FRQG4SVVc0bjD
   o5w5rPbyy3F3VXyYte6XBE5lnhQ1kIryF7OGM2K7ldF3aqrciw+kc7Arc
   ly8nXpbbAeOQI5XzKzp1+1m1atj0MatnFXpsq6IzwJl4dw0k/CnwTyXyF
   w==;
X-CSE-ConnectionGUID: 1ZNPVmtATeamVDVeXXCJcA==
X-CSE-MsgGUID: vjhRO+sXSCGvhcNM7BQn9Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391732"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391732"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:43 -0700
X-CSE-ConnectionGUID: Jg4iLQEkSR2+OWHIIHOqfg==
X-CSE-MsgGUID: ANF+CFmIToaTkF0K815jnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154722005"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:43 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 17/23] KVM: VMX: Set host constant supervisor states to VMCS fields
Date: Fri,  4 Jul 2025 01:49:48 -0700
Message-ID: <20250704085027.182163-18-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
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
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/capabilities.h |  4 ++++
 arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 arch/x86/kvm/x86.h              |  1 +
 4 files changed, 32 insertions(+)

diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
index cb6588238f46..0f0e1717dc80 100644
--- a/arch/x86/kvm/vmx/capabilities.h
+++ b/arch/x86/kvm/vmx/capabilities.h
@@ -104,6 +104,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
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
index ba46c1dcdb9d..3d6da3836e6b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4300,6 +4300,21 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
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
index 9ff7996d7534..b17a8bf84db3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9975,6 +9975,18 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 		return -EIO;
 	}
 
+	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
+		rdmsrl(MSR_IA32_S_CET, kvm_host.s_cet);
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
index 1b5a96329c64..8d2049a1f41b 100644
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
2.47.1


