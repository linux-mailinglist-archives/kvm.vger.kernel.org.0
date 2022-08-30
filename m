Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2C15A62AC
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiH3MCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiH3MB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:01:58 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC3BE58B0;
        Tue, 30 Aug 2022 05:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860917; x=1693396917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ecJt3wo84iM3H4djjCHx3xWGtpp+Oi5DdaN0Ffz4IIQ=;
  b=HZLNJCdd/PFUoPFqL1D4quktOkYUlmwt/RRq72WB9+eEyHbRWNPu/nC9
   heNaH2pCYNzsfhPaAHqzyOA+svHu9LEpfCqO16bBNi8sOA87RAxMqMxWz
   T6sCvdjA+Jj+2S/WSXNxOq5uMrZB6xihdb/8Et5oV73X3R5FtgW2lx38H
   BABtvJrgrZMnm6XHqiIwEtoIN5stbJGVAbeCLtN168VH684v8m1YZ8mw/
   X+xm38ZPNgBJ3ztu9VOwTVH02SxgNp1u+LGHSAhn3M+EPcarBMB0EJRI7
   OVwT7iqFzIghNWL5eUw49GTWyVWmhgtZLml5HH3UuKv/Lh1DLJm6uVfn2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870957"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870957"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469616"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:55 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 03/19] KVM: x86: Move check_processor_compatibility from init ops to runtime ops
Date:   Tue, 30 Aug 2022 05:01:18 -0700
Message-Id: <ca14ea2d9582d4e08fc4a432f494d1180a1d60ac.1661860550.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661860550.git.isaku.yamahata@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chao Gao <chao.gao@intel.com>

so that KVM can do compatibility checks on hotplugged CPUs. Drop __init
from check_processor_compatibility() and its callees.

use a static_call() to invoke .check_processor_compatibility.

Opportunistically rename {svm,vmx}_check_processor_compat to conform
to the naming convention of fields of kvm_x86_ops.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20220216031528.92558-2-chao.gao@intel.com
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  2 +-
 arch/x86/kvm/svm/svm.c             |  4 ++--
 arch/x86/kvm/vmx/vmx.c             | 14 +++++++-------
 arch/x86/kvm/x86.c                 |  3 +--
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 51f777071584..3bc45932e2d1 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -129,6 +129,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(check_processor_compatibility)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c96c43c313a..5df5d88d345f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1445,6 +1445,7 @@ static inline u16 kvm_lapic_irq_dest_mode(bool dest_mode_logical)
 struct kvm_x86_ops {
 	const char *name;
 
+	int (*check_processor_compatibility)(void);
 	int (*hardware_enable)(void);
 	void (*hardware_disable)(void);
 	void (*hardware_unsetup)(void);
@@ -1655,7 +1656,6 @@ struct kvm_x86_nested_ops {
 struct kvm_x86_init_ops {
 	int (*cpu_has_kvm_support)(void);
 	int (*disabled_by_bios)(void);
-	int (*check_processor_compatibility)(void);
 	int (*hardware_setup)(void);
 	unsigned int (*handle_intel_pt_intr)(void);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f3813dbacb9f..371300f03f55 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4134,7 +4134,7 @@ svm_patch_hypercall(struct kvm_vcpu *vcpu, unsigned char *hypercall)
 	hypercall[2] = 0xd9;
 }
 
-static int __init svm_check_processor_compat(void)
+static int svm_check_processor_compatibility(void)
 {
 	return 0;
 }
@@ -4740,6 +4740,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.name = "kvm_amd",
 
 	.hardware_unsetup = svm_hardware_unsetup,
+	.check_processor_compatibility = svm_check_processor_compatibility,
 	.hardware_enable = svm_hardware_enable,
 	.hardware_disable = svm_hardware_disable,
 	.has_emulated_msr = svm_has_emulated_msr,
@@ -5122,7 +5123,6 @@ static struct kvm_x86_init_ops svm_init_ops __initdata = {
 	.cpu_has_kvm_support = has_svm,
 	.disabled_by_bios = is_disabled,
 	.hardware_setup = svm_hardware_setup,
-	.check_processor_compatibility = svm_check_processor_compat,
 
 	.runtime_ops = &svm_x86_ops,
 	.pmu_ops = &amd_pmu_ops,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d7f8331d6f7e..3cf7f18a4115 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2495,8 +2495,8 @@ static bool cpu_has_sgx(void)
 	return cpuid_eax(0) >= 0x12 && (cpuid_eax(0x12) & BIT(0));
 }
 
-static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
-				      u32 msr, u32 *result)
+static int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
+			       u32 msr, u32 *result)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 ctl = ctl_min | ctl_opt;
@@ -2514,7 +2514,7 @@ static __init int adjust_vmx_controls(u32 ctl_min, u32 ctl_opt,
 	return 0;
 }
 
-static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
+static u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 {
 	u64 allowed;
 
@@ -2523,8 +2523,8 @@ static __init u64 adjust_vmx_controls64(u64 ctl_opt, u32 msr)
 	return  ctl_opt & allowed;
 }
 
-static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
-				    struct vmx_capability *vmx_cap)
+static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
+			     struct vmx_capability *vmx_cap)
 {
 	u32 vmx_msr_low, vmx_msr_high;
 	u32 min, opt, min2, opt2;
@@ -7417,7 +7417,7 @@ static int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
-static int __init vmx_check_processor_compat(void)
+static int vmx_check_processor_compatibility(void)
 {
 	struct vmcs_config vmcs_conf;
 	struct vmx_capability vmx_cap;
@@ -8015,6 +8015,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
+	.check_processor_compatibility = vmx_check_processor_compatibility,
 	.hardware_enable = vmx_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
@@ -8404,7 +8405,6 @@ static __init int hardware_setup(void)
 static struct kvm_x86_init_ops vmx_init_ops __initdata = {
 	.cpu_has_kvm_support = cpu_has_kvm_support,
 	.disabled_by_bios = vmx_disabled_by_bios,
-	.check_processor_compatibility = vmx_check_processor_compat,
 	.hardware_setup = hardware_setup,
 	.handle_intel_pt_intr = NULL,
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7d5fff68befe..985487fe0d63 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11997,7 +11997,6 @@ void kvm_arch_hardware_unsetup(void)
 int kvm_arch_check_processor_compat(void *opaque)
 {
 	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
-	struct kvm_x86_init_ops *ops = opaque;
 
 	WARN_ON(!irqs_disabled());
 
@@ -12005,7 +12004,7 @@ int kvm_arch_check_processor_compat(void *opaque)
 	    __cr4_reserved_bits(cpu_has, &boot_cpu_data))
 		return -EIO;
 
-	return ops->check_processor_compatibility();
+	return static_call(kvm_x86_check_processor_compatibility)();
 }
 
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
-- 
2.25.1

