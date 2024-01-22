Return-Path: <kvm+bounces-6675-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE59837861
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FB25287281
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 145617C088;
	Mon, 22 Jan 2024 23:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WapUgLww"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B205745F2;
	Mon, 22 Jan 2024 23:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967766; cv=none; b=c9vXsFYO8n3qGSFzGLdNlLZG/NclvshefwAdrp5pgi1xXl6tZ8vlUdm1m7Am5FyhSBx5M2TvTuhSDLJQFgiszqnFEnq0QeTD/43uttZmE7+DeuAAD+X1PxMcXk+e8T8czm5z01KrfNBmKxkS5omdPs/dilbUiaAz57y4Bmr2RV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967766; c=relaxed/simple;
	bh=dAsWrCRW+6naU7sRd9tkmyVlajZ/Ifufs1qXYRHczYI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a75q1tUXffteeFuuKK46mWSX/FStIldk0Njzxc/UY+Q3oUwiW/BT8w/hH71kZsSxbO3JqdEUt2kp6UyR/WTtI3iRJleyUlGdjVeqOfDpPY7drzAVnMK7sHOxqS1AhtC0xlrf68LlGVEDQg5sM+UU6S6vvlqt2Pb/22a30yEPVNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WapUgLww; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967764; x=1737503764;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dAsWrCRW+6naU7sRd9tkmyVlajZ/Ifufs1qXYRHczYI=;
  b=WapUgLwwSf1V3vY/C5ypLdigkpHpvE3GEqexQNn8wsMR92VRTRm4Ckvq
   pora2SIFjvK6cJFtZEpqasxQ5sNPb3TEBD4v9ldb9cfXweKvS+3JnvUp3
   BdHzQbEHs8abU4vygwkEaeRLmwklY/LFJqFQSG1iTO2ejAYoRQstCfeLD
   YbpBh4iv4yAXBuIy8TLfz4DT+X+HlmgUm7rnMflNzN5QA91nD7cpADPYZ
   6ULDsYvxslagm3CzwymHQQqDQQdf0APXl/TMR98NPWFyQ6va7F1S5UuNo
   jvrFcICniV2Aik5l+IZgwY851p1JdVMVb/nIt/9fMBKknLHwxFK0d4R7b
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217881"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217881"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817993"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:52 -0800
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
Subject: [PATCH v18 102/121] KVM: TDX: Handle MSR MTRRCap and MTRRDefType access
Date: Mon, 22 Jan 2024 15:54:18 -0800
Message-Id: <f60333abec4547676b77e882c983d5e3548b2927.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index 66d575cfd884..a75275f6f161 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -656,18 +656,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
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
 
@@ -1978,7 +1967,9 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_ARCH_CAPABILITIES:
 	case MSR_IA32_POWER_CTL:
+	case MSR_MTRRcap:
 	case MSR_IA32_CR_PAT:
+	case MSR_MTRRdefType:
 	case MSR_IA32_TSC_DEADLINE:
 	case MSR_IA32_MISC_ENABLE:
 	case MSR_PLATFORM_INFO:
@@ -2020,16 +2011,47 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 
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
@@ -2778,6 +2800,45 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
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
@@ -2815,6 +2876,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
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


