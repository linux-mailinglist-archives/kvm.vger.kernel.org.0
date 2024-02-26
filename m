Return-Path: <kvm+bounces-9737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3331C866D91
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:05:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B4A9F1F24F22
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891AC12C555;
	Mon, 26 Feb 2024 08:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uf3z1wew"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (unknown [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF3312B15D;
	Mon, 26 Feb 2024 08:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936151; cv=none; b=Siga6QaZoDpEK8cp+OBGz+6R1W+xQ56Sfg9viNz/RoO/sTV+iiTKJGHYRfoSr0G4YEnozZ/5Wo7RCVFw5uSMX1GGxyXaKuf7Xi8icJ3SqFVZG67VditYJRsDeY4mH17fRrMbVoVpMdwuToAgQxOMSzjRQVMazXrB+aPIN+ThWEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936151; c=relaxed/simple;
	bh=XAPqg9P4ovUdN9yysJhqj4R/8c0qj5T2TQ9C6uUUWv0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GpBmXTl1sn+dZ0Pm0TSA+hBcsXZVBAHHkdzzsCBddNO4btFZ0tzp1+NJTYi0sN/ZuoC+bmlyhpOrIzzSXgacxbFLd7KpHaCWSfxBKKRCLNPfLl5xYN9/tG6BbXJ3+DMs6LeS7qfolfaSHVBZZpFtF4oJqCwfK+rFOFA8ifNjPJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=fail (0-bit key) header.d=intel.com header.i=@intel.com header.b=Uf3z1wew reason="key not found in DNS"; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936149; x=1740472149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XAPqg9P4ovUdN9yysJhqj4R/8c0qj5T2TQ9C6uUUWv0=;
  b=Uf3z1wewYIk9yE0vPZhK5DDDgrNNwmHAXPwQcWmZ+nRYslBBeW+QOOp8
   WH8z2UGFzD36bNMYoHcg5N2XGHDZSs+X/rAn0YKlLsxv3z9nVbMK9BdjS
   IRVpUYMza7FHckszSKLOug9VKQN1JDeLnP/NHlz8+gemlXRucOIVLxIco
   msoB4dhK1N/2nzSlEW27LtHDItCjNRVdvD3enAP2TQT1CElvbL4G9L+kj
   kU9ZJUWKX/Dlv1As0EHBMTQ9v9cXHEPoDw+NASUSlHYVzl2ajnJrOz13H
   uw3Y39Vku1ULmyr3RSbxhy70+KMnnujgBm7zPuxxa/cjfkGdCeOkq9DCh
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751356"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751356"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735084"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:06 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v19 113/130] KVM: TDX: Handle MSR MTRRCap and MTRRDefType access
Date: Mon, 26 Feb 2024 00:26:55 -0800
Message-Id: <81119d66392bc9446340a16f8a532c7e1b2665a2.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle MTRRCap RO MSR to return all features are unsupported and handle
MTRRDefType MSR to accept only E=1,FE=0,type=writeback.
enable MTRR, disable Fixed range MTRRs, default memory type=writeback

TDX virtualizes that cpuid to report MTRR to guest TD and TDX enforces
guest CR0.CD=0. If guest tries to set CR0.CD=1, it results in #GP.  While
updating MTRR requires to set CR0.CD=1 (and other cache flushing
operations).  It means guest TD can't update MTRR.  Virtualize MTRR as
all features disabled and default memory type as writeback.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 99 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 82 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4c635bfcaf7a..2bddaef495d1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -611,18 +611,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
-	/*
-	 * TDX enforces CR0.CD = 0 and KVM MTRR emulation enforces writeback.
-	 * TODO: implement MTRR MSR emulation so that
-	 * MTRRCap: SMRR=0: SMRR interface unsupported
-	 *          WC=0: write combining unsupported
-	 *          FIX=0: Fixed range registers unsupported
-	 *          VCNT=0: number of variable range regitsers = 0
-	 * MTRRDefType: E=1, FE=0, type=writeback only. Don't allow other value.
-	 *              E=1: enable MTRR
-	 *              FE=0: disable fixed range MTRRs
-	 *              type: default memory type=writeback
-	 */
+	/* TDX enforces CR0.CD = 0 and KVM MTRR emulation enforces writeback. */
 	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
 }
 
@@ -1932,7 +1921,9 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_ARCH_CAPABILITIES:
 	case MSR_IA32_POWER_CTL:
+	case MSR_MTRRcap:
 	case MSR_IA32_CR_PAT:
+	case MSR_MTRRdefType:
 	case MSR_IA32_TSC_DEADLINE:
 	case MSR_IA32_MISC_ENABLE:
 	case MSR_PLATFORM_INFO:
@@ -1974,16 +1965,47 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (tdx_has_emulated_msr(msr->index, false))
-		return kvm_get_msr_common(vcpu, msr);
-	return 1;
+	switch (msr->index) {
+	case MSR_MTRRcap:
+		/*
+		 * Override kvm_mtrr_get_msr() which hardcodes the value.
+		 * Report SMRR = 0, WC = 0, FIX = 0 VCNT = 0 to disable MTRR
+		 * effectively.
+		 */
+		msr->data = 0;
+		return 0;
+	default:
+		if (tdx_has_emulated_msr(msr->index, false))
+			return kvm_get_msr_common(vcpu, msr);
+		return 1;
+	}
 }
 
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (tdx_has_emulated_msr(msr->index, true))
+	switch (msr->index) {
+	case MSR_MTRRdefType:
+		/*
+		 * Allow writeback only for all memory.
+		 * Because it's reported that fixed range MTRR isn't supported
+		 * and VCNT=0, enforce MTRRDefType.FE = 0 and don't care
+		 * variable range MTRRs. Only default memory type matters.
+		 *
+		 * bit 11 E: MTRR enable/disable
+		 * bit 12 FE: Fixed-range MTRRs enable/disable
+		 * (E, FE) = (1, 1): enable MTRR and Fixed range MTRR
+		 * (E, FE) = (1, 0): enable MTRR, disable Fixed range MTRR
+		 * (E, FE) = (0, *): disable all MTRRs.  all physical memory
+		 *                   is UC
+		 */
+		if (msr->data != ((1 << 11) | MTRR_TYPE_WRBACK))
+			return 1;
 		return kvm_set_msr_common(vcpu, msr);
-	return 1;
+	default:
+		if (tdx_has_emulated_msr(msr->index, true))
+			return kvm_set_msr_common(vcpu, msr);
+		return 1;
+	}
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
@@ -2704,6 +2726,45 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	return ret;
 }
 
+static int tdx_vcpu_init_mtrr(struct kvm_vcpu *vcpu)
+{
+	struct msr_data msr;
+	int ret;
+	int i;
+
+	/*
+	 * To avoid confusion with reporting VNCT = 0, explicitly disable
+	 * vaiale-range reisters.
+	 */
+	for (i = 0; i < KVM_NR_VAR_MTRR; i++) {
+		/* phymask */
+		msr = (struct msr_data) {
+			.host_initiated = true,
+			.index = 0x200 + 2 * i + 1,
+			.data = 0,	/* valid = 0 to disable. */
+		};
+		ret = kvm_set_msr_common(vcpu, &msr);
+		if (ret)
+			return -EINVAL;
+	}
+
+	/* Set MTRR to use writeback on reset. */
+	msr = (struct msr_data) {
+		.host_initiated = true,
+		.index = MSR_MTRRdefType,
+		/*
+		 * Set E(enable MTRR)=1, FE(enable fixed range MTRR)=0, default
+		 * type=writeback on reset to avoid UC.  Note E=0 means all
+		 * memory is UC.
+		 */
+		.data = (1 << 11) | MTRR_TYPE_WRBACK,
+	};
+	ret = kvm_set_msr_common(vcpu, &msr);
+	if (ret)
+		return -EINVAL;
+	return 0;
+}
+
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 {
 	struct msr_data apic_base_msr;
@@ -2741,6 +2802,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	if (kvm_set_apic_base(vcpu, &apic_base_msr))
 		return -EINVAL;
 
+	ret = tdx_vcpu_init_mtrr(vcpu);
+	if (ret)
+		return ret;
+
 	ret = tdx_td_vcpu_init(vcpu, (u64)cmd.data);
 	if (ret)
 		return ret;
-- 
2.25.1


