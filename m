Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C037CAECF
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjJPQSJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234140AbjJPQRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:17:47 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C56310E7;
        Mon, 16 Oct 2023 09:17:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473035; x=1729009035;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=te/VzOZA6RdNyTzGAxnR8umZmCmcWLX+cMrw0t3eFuQ=;
  b=E9+Ine9JCE261LGYWX9axWGBVRNvdq4GlruUXNkAK4wgu8xe2eYhS4MF
   OfNIxCRvK9cgWqinlGPq3AlVdbzrwFirV1UPf0jkpGrLJkCupyt3y37g1
   HAp25Mx/DQbmawr5G17rfvzQhg2rJOA5jrVYQdd2FF1AbCmmIJ/kNUEb+
   Zlj1NzlARH+rvHbaUSofFwphCq55lLdXMt2NAGuIe0DpbGoqWR55F2e5D
   At4baITnh0iw/MXGkmGouf493AM27H/a/1hamvRw72DXUyqO+ljR+OLuy
   Hx1p1GXsMdBhn1SccHBSidzORCfE6TfrhfwhTKSlMWiasYolcfuqvDxw/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="364921822"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="364921822"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="846448157"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="846448157"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:15:47 -0700
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
Subject: [PATCH v16 056/116] KVM: TDX: MTRR: implement get_mt_mask() for TDX
Date:   Mon, 16 Oct 2023 09:14:08 -0700
Message-Id: <65d13fa6ce67b025ce609aeeaa7f0624c9870c13.1697471314.git.isaku.yamahata@intel.com>
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
index 077eee12e7b6..22b9d44ee29f 100644
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
@@ -347,7 +355,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
+	.get_mt_mask = vt_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index cad6f9beda50..a5f1b3e75764 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -363,6 +363,29 @@ int tdx_vm_init(struct kvm *kvm)
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
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 562e567953c0..e2a8b59adf2d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -150,6 +150,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -176,6 +177,7 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1

