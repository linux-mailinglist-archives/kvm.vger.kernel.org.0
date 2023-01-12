Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59319667BA4
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241063AbjALQoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240254AbjALQig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:38:36 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90AF1C92B;
        Thu, 12 Jan 2023 08:34:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541245; x=1705077245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kGj7lf1BwM0y3y4OyluOHfWFRQbcBoAQHQBpnj4zLi8=;
  b=DJArdW1Dn1uMoigCy/hbgEO2XVFbokHW1r9YnfG2lWZ/uqX/vf0XW8oC
   fbdpz+dNsLtsjRG6hkgQhUiFUuN1o4PuO0AMNgiwHBDKY64HZXYINpQx6
   RBnYYB1grg1P6+e90MwnbKh2m5YsNhATjDwEzgpz3N5D0A9aOP4hGX1FN
   fGz7ydU3NX2dvyO3ltgoed1RWzmkYY/a1T5yu9FHtmfna7V3WAbWLYmQm
   vJc4Bxuk2FMuVNn41Esu8hJcF9P//6VNvTsyuzDKcMWyBW09G0twy84j/
   w7aiBxVX7dQMJCoJotNQ6rzjD8HEVAD8u6lbsr6012+xSbvI2ITZrQVPe
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811939"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811939"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151837"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151837"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:30 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 058/113] KVM: TDX: MTRR: implement get_mt_mask() for TDX
Date:   Thu, 12 Jan 2023 08:32:06 -0800
Message-Id: <21e0d94ccf2fd3d766d6aa7b45441791c04e5e4f.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Although TDX supports only WB for private GPA, MTRR/PAT for shared GPA
should be supported. Implement get_mt_mask() following vmx case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 10 +++++++++-
 arch/x86/kvm/vmx/tdx.c     | 19 +++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 770d1b29d1c3..4319f6d7a4da 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -158,6 +158,14 @@ static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
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
@@ -267,7 +275,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.set_tss_addr = vmx_set_tss_addr,
 	.set_identity_map_addr = vmx_set_identity_map_addr,
-	.get_mt_mask = vmx_get_mt_mask,
+	.get_mt_mask = vt_get_mt_mask,
 
 	.get_exit_info = vmx_get_exit_info,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e68816999387..c4c5a8f786c1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -309,6 +309,25 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
+{
+	/* TDX private GPA is always WB. */
+	if (gfn & kvm_gfn_shared_mask(vcpu->kvm)) {
+		WARN_ON_ONCE(is_mmio);
+		return  MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
+	}
+
+	if (is_mmio)
+		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
+
+	/*
+	 * Device assignemnt without VT-d snooping capability with shared-GPA
+	 * is dubious.
+	 */
+	WARN_ON_ONCE(kvm_arch_has_noncoherent_dma(vcpu->kvm));
+	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
+}
+
 int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *e;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 8ae689929347..d903e0f606d3 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -154,6 +154,7 @@ void tdx_vm_free(struct kvm *kvm);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
+u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
@@ -176,6 +177,7 @@ static inline void tdx_vm_free(struct kvm *kvm) {}
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
+static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-- 
2.25.1

