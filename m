Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC2A4CDE17
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiCDUHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiCDUHA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:07:00 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2196CA76FD;
        Fri,  4 Mar 2022 12:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424097; x=1677960097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zhkd9vMW4IoFvLpPP2WdaDbfud+1lrbpgFdFlKEXWIw=;
  b=Xtw+KfuQGKjvX5po7xEKUzAik6Ma++SegukFzj/Wr2Xun7Uj3fcU0izl
   W6KRzJRStBzn+qCUEksHVtpzcC+4hM6TWNg1cY2aN2RjOGWoyjko5DjGu
   /IuE2uzsFR3MahAczvgeZbQc5NaiubQqqpbikWAX9+cvAv/U3rIRjb8Ed
   ZGby3iVYny1LS0jxVqcxikytz3HiAuSUG+6v7rUIkjMfn3q+fd9i7cm3a
   N0InC3ueZTrvTKAht5e0M3t2G/j40N5VzE9F2z6ljv0VFIpb6ogCR/jUI
   r1/5Eg0iLJ8rRdQeRPTVBk93iCUNKs/8uliE4UvLGf4x9Mkii6HYZUDa5
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983376"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983376"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:12 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344222"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:12 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 020/104] KVM: TDX: allocate per-package mutex
Date:   Fri,  4 Mar 2022 11:48:36 -0800
Message-Id: <f7b44d1d5a61f788294c399b63b505b3ff4d301b.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Several TDX SEAMCALLs are per-package scope (concretely per memory
controller) and they need to be serialized per-package.  Allocate mutex for
it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  8 +++++++-
 arch/x86/kvm/vmx/tdx.c     | 18 ++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8103d1c32cc9..6111c6485d8e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -25,6 +25,12 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static void vt_hardware_unsetup(void)
+{
+	tdx_hardware_unsetup();
+	vmx_hardware_unsetup();
+}
+
 static int vt_vm_init(struct kvm *kvm)
 {
 	int ret;
@@ -42,7 +48,7 @@ static int vt_vm_init(struct kvm *kvm)
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
 
-	.hardware_unsetup = vmx_hardware_unsetup,
+	.hardware_unsetup = vt_hardware_unsetup,
 
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e8d293a3c11c..1c8222f54764 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -34,6 +34,8 @@ struct tdx_capabilities {
 /* Capabilities of KVM + the TDX module. */
 struct tdx_capabilities tdx_caps;
 
+static struct mutex *tdx_mng_key_config_lock;
+
 static u64 hkid_mask __ro_after_init;
 static u8 hkid_start_pos __ro_after_init;
 
@@ -112,7 +114,9 @@ bool tdx_is_vm_type_supported(unsigned long type)
 
 static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 {
+	int max_pkgs;
 	u32 max_pa;
+	int i;
 
 	if (!enable_ept) {
 		pr_warn("Cannot enable TDX with EPT disabled\n");
@@ -127,6 +131,14 @@ static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
 		return -EIO;
 
+	max_pkgs = topology_max_packages();
+	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
+				   GFP_KERNEL);
+	if (!tdx_mng_key_config_lock)
+		return -ENOMEM;
+	for (i = 0; i < max_pkgs; i++)
+		mutex_init(&tdx_mng_key_config_lock[i]);
+
 	max_pa = cpuid_eax(0x80000008) & 0xff;
 	hkid_start_pos = boot_cpu_data.x86_phys_bits;
 	hkid_mask = GENMASK_ULL(max_pa - 1, hkid_start_pos);
@@ -147,6 +159,12 @@ void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 		enable_tdx = false;
 }
 
+void tdx_hardware_unsetup(void)
+{
+	/* kfree accepts NULL. */
+	kfree(tdx_mng_key_config_lock);
+}
+
 void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
 			unsigned int *vcpu_align, unsigned int *vm_size)
 {
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 78331dbc29f7..da32b4b86b19 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -131,11 +131,13 @@ void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
 			unsigned int *vcpu_align, unsigned int *vm_size);
 bool tdx_is_vm_type_supported(unsigned long type);
 void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+void tdx_hardware_unsetup(void);
 #else
 static inline void tdx_pre_kvm_init(
 	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
+static inline void tdx_hardware_unsetup(void) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

