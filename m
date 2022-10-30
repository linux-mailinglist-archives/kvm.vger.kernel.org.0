Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB890612804
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiJ3G0N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbiJ3GZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:25:01 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55476EE;
        Sat, 29 Oct 2022 23:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111053; x=1698647053;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=szdQR9xxXHuaOtlsKWph90ODmbm52oomOuydVveFV2E=;
  b=DcjTsKRNsIyq77HM19WJrVQV6WgaWwesTV5qn37+2SvpHIJIRsk2fayw
   M1ikJvAn6vvMLvgx0SSXPvbe7t1gGSEiBj7KHXHKrEaLbPqXh36T5+S0B
   ud6A2Zz9vwBtk2hB/pwL8bRyfvZcCIjvZK1xUXgIfCCOwbP7rjK9u8nbv
   KxDWv7fPKi5ulRekvigPhlO3Uzcj679XHPm3sSYtoOylCurIHCrK0PbXh
   sGfJIQAcOwzao8ZxS6LbYTnP7+PwtylrH0znZEtoTV0edmIBmqSW9VIED
   kT51lRLH8kFpN5iWdoeO5i4JlJG9vrXCitZCCoVqFrrXrZd/6ou4bpZAM
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037168"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037168"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:06 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393024"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393024"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:06 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v10 055/108] KVM: TDX: Add load_mmu_pgd method for TDX
Date:   Sat, 29 Oct 2022 23:22:56 -0700
Message-Id: <e82e13d94157b1bba4c2872b4dad19cfd1b7f473.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

For virtual IO, the guest TD shares guest pages with VMM without
encryption.  Shared EPT is used to map guest pages in unprotected way.

Add the VMCS field encoding for the shared EPTP, which will be used by
TDX to have separate EPT walks for private GPAs (existing EPTP) versus
shared GPAs (new shared EPTP).

Set shared EPT pointer value for the TDX guest to initialize TDX MMU.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/main.c    | 11 ++++++++++-
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 752d53652007..1205018b5b6b 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -234,6 +234,7 @@ enum vmcs_field {
 	TSC_MULTIPLIER_HIGH             = 0x00002033,
 	TERTIARY_VM_EXEC_CONTROL	= 0x00002034,
 	TERTIARY_VM_EXEC_CONTROL_HIGH	= 0x00002035,
+	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 9fb6eb626a9a..974e00fd3260 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -100,6 +100,15 @@ static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	return vmx_vcpu_reset(vcpu, init_event);
 }
 
+static void vt_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			int pgd_level)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+
+	vmx_load_mmu_pgd(vcpu, root_hpa, pgd_level);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -219,7 +228,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.write_tsc_offset = vmx_write_tsc_offset,
 	.write_tsc_multiplier = vmx_write_tsc_multiplier,
 
-	.load_mmu_pgd = vmx_load_mmu_pgd,
+	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e80f9cf79b2e..6328eaa65126 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -394,6 +394,11 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->kvm->vm_bugged = true;
 }
 
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
+{
+	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
+}
+
 int tdx_dev_ioctl(void __user *argp)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index fda1b2eaebc6..dd05991afbad 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -147,6 +147,8 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
+
+void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return 0; }
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
@@ -165,6 +167,8 @@ static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

