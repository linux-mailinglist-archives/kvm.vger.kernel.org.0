Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD59676266D
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjGYWWq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbjGYWVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:21:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161F44C10;
        Tue, 25 Jul 2023 15:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323452; x=1721859452;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RoRPfiwgJ6rjNJNRpk7JXwHtQZgo3QvdZiTbdTSMJwE=;
  b=KUGBjQH91al4xUHuPhnbNvcMBC/iBKPsMis7v/isFuSITab7bf+ikCg9
   qJSOHyBUhqgEK3Gv4Uk14FPuSr7H9C0RpOj4vQS8LoVlw/lw2DpRoH8Sw
   4ymEfS7obMUd3UYUg2Y1E/QN9p7Uozq4jkKnkvTwcLsrfT6QoYVgaHQyz
   DqOK6TtxyLb7tY1lQOtfg3LyTd6lyPxB94fssde7BplBQmQbZCeBgchqI
   NMHREByW+0foqhXH3dDEH0NfrRXwE5AdpVkWUjfCVVg9rYcLsbWSEKFRK
   KoWmhJQGOBlnQ6PI4CBVH5NJQ8EGBVZxcrZUbQHWmjTnpYvI9jvYEpbxc
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863330"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863330"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938969"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938969"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:42 -0700
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
Subject: [PATCH v15 056/115] KVM: TDX: MTRR: implement get_mt_mask() for TDX
Date:   Tue, 25 Jul 2023 15:14:07 -0700
Message-Id: <ac1a1745813790b217a9541fa5223fcd83687afd.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Because TDX virtualize cpuid[0x1].EDX[MTRR: bit 12] to fixed 1, guest TD
thinks MTRR is supported.  Although TDX supports only WB for private GPA,
it's desirable to support MTRR for shared GPA.  As guest access to MTRR
MSRs causes #VE and KVM/x86 tracks the values of MTRR MSRs, the remining
part is to implement get_mt_mask method for TDX for shared GPA.

Pass around shared bit from kvm fault handler to get_mt_mask method so that
it can determine if the gfn is shared or private.  Implement get_mt_mask()
following vmx case for shared GPA and return WB for private GPA.
the existing vmx_get_mt_mask() can't be directly used as CPU state(CR0.CD)
is protected.  GFN passed to kvm_mtrr_check_gfn_range_consistency() should
include shared bit.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 10 +++++++++-
 arch/x86/kvm/vmx/tdx.c     | 23 +++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5b499a71701b..2eaed14a9542 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -228,6 +228,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
 }
 
+static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_get_mt_mask(vcpu, gfn, is_mmio);
+
+	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -346,7 +354,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
+	.get_mt_mask = vt_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d543e78899f0..e367351f8d71 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -344,6 +344,29 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	if (is_mmio)
+		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+
+	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+
+	/*
+	 * TDX enforces CR0.CD = 0 and KVM MTRR emulation enforces writeback.
+	 * TODO: implement MTRR MSR emulation so that
+	 * MTRRCap: SMRR=0: SMRR interface unsupported
+	 *          WC=0: write combining unsupported
+	 *          FIX=0: Fixed range registers unsupported
+	 *          VCNT=0: number of variable range regitsers = 0
+	 * MTRRDefType: E=1, FE=0, type=writeback only. Don't allow other value.
+	 *              E=1: enable MTRR
+	 *              FE=0: disable fixed range MTRRs
+	 *              type: default memory type=writeback
+	 */
+	return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	/*
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 8c6b7df02df2..ed93accd29e6 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -151,6 +151,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -177,6 +178,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1

