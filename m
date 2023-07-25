Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA90E76268D
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjGYWYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233032AbjGYWXU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:23:20 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661D455AF;
        Tue, 25 Jul 2023 15:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323519; x=1721859519;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RpcCPxBgvrrF2LrPG1804injK1mZCQv/0KkU30+BTQU=;
  b=D8aLsDUI+CF5OUHRmelLNC9kgu5ww4Okvi9JDVMlLJZEKDe2PLzLlAu7
   WTee/a2VoB/kgAmR7QrCJaMKnmfF/CpFGIkNhUdeY6IqJW413KLsBE7OX
   Lg1gs1lIIPA2h2WjeHZEYjvdAoeAKiRnNCghVfDE4ZFmLlC5bI1tEaoAo
   6a5foJrZK5q2UVzUinkBSqpnY5rEb7OJ6HE4uaOl2sOQ/nHlSw+C61ED6
   SiD6yMAylEIsIhnPEg34aB/9q65w1JNLJ/2F/Cn5EOwqE0yYznTlpMhqQ
   Me/7ZjPvjDINUjp8jugELdkw0HQ8TqjJH4kkAysBFemC3eG9+H8J3pFAb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882727"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882727"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001923"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001923"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:05 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 098/115] KVM: TDX: Handle MSR MTRRCap and MTRRDefType access
Date:   Tue, 25 Jul 2023 15:14:49 -0700
Message-Id: <08fc4e86a10adeac0379b8dd364d2ee96b467dce.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
index 98bdcfc06283..3775db455f29 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -544,18 +544,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
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
 
@@ -1786,7 +1775,9 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_ARCH_CAPABILITIES:
 	case MSR_IA32_POWER_CTL:
+	case MSR_MTRRcap:
 	case MSR_IA32_CR_PAT:
+	case MSR_MTRRdefType:
 	case MSR_IA32_TSC_DEADLINE:
 	case MSR_IA32_MISC_ENABLE:
 	case MSR_PLATFORM_INFO:
@@ -1828,16 +1819,47 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 
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
@@ -2596,6 +2618,45 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
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
@@ -2633,6 +2694,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
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

