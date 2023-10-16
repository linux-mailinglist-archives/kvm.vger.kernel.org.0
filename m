Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4EB7CAF4D
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjJPQbr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbjJPQbP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:31:15 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8965FC2;
        Mon, 16 Oct 2023 09:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473298; x=1729009298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ePwmCk41sQLQ6wkrkviFxffp0UqznxIySqtpaKEc/uI=;
  b=EdFArOdGhLejM05Q9RyAEleszOoJJ/P8l6wUvfG26o5lnY8nfVo7KuJr
   7v53pb0LFggejdBeSrKrjneMX5beFjlUrOR27faLForsYMnxRqyYDdJC8
   pznAmhlxd2Jn8ssh8KVYuSFNj/kcfOzy7AsJFPNLe2Mfz7Nmp125HY9+a
   Yo9yLyoG5lYsSljR4oKV20ND0kJMe9p60N5IlBcl5v6+uUaGQE1X8Oztw
   8BHp4F5vjVbIut+o7PRo41bKddnPZzFzmT2vImSI6tPpvtKxzdcg1RBvw
   H4IeSCoGtD7PIAHOQIhmYAV38PAsAEzlP4Sv9WPcx8zXKIqrAOD6ewqxj
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364922078"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364922078"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448329"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448329"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:16:06 -0700
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
Subject: [PATCH v16 097/116] KVM: TDX: Handle MSR MTRRCap and MTRRDefType access
Date:   Mon, 16 Oct 2023 09:14:49 -0700
Message-Id: <d8264a24c479cd9a76f426459fdfd517125895dc.1697471314.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697471314.git.isaku.yamahata@intel.com>
References: <cover.1697471314.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 41f7ad98cab5..726e28f30354 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -580,18 +580,7 @@ u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
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
 
@@ -1930,7 +1919,9 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 	case MSR_IA32_UCODE_REV:
 	case MSR_IA32_ARCH_CAPABILITIES:
 	case MSR_IA32_POWER_CTL:
+	case MSR_MTRRcap:
 	case MSR_IA32_CR_PAT:
+	case MSR_MTRRdefType:
 	case MSR_IA32_TSC_DEADLINE:
 	case MSR_IA32_MISC_ENABLE:
 	case MSR_PLATFORM_INFO:
@@ -1972,16 +1963,47 @@ bool tdx_has_emulated_msr(u32 index, bool write)
 
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
@@ -2730,6 +2752,45 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
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
@@ -2767,6 +2828,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
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

