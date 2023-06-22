Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F8673AD14
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 01:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbjFVXRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 19:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231700AbjFVXRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 19:17:50 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CBBD26B0;
        Thu, 22 Jun 2023 16:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687475854; x=1719011854;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BD6pXTs5JxVG1xLxlJ9ylWBhK590xLSHJkxsDTrYBeo=;
  b=ZBjCB8nhfDeF4EJvPg9bdCYQR9UOPyTY2IjR97f0p03UlKcIj2BrhHT/
   0Lm2x9sHgDqEmR4/sFG2HAwRFg6aKWEA5uMGDaRo4Hh7/n6z7P2hM8gfi
   otBzFP8PjtyiQS/n6ewH9SSXi834a/bsEUtbWkJorIOMbfTldgvXJyaoP
   QXpg8w8QToxaMl9S5gUPyxFBkeoKIfGEvqvuLAmk/ugaJ1ZoEx37bCkQF
   7RLYiNz2HQ0wQrNDoVWh9iZ99auCTjBAxI21S3zwQOK+RH6Ex3TfGvdFy
   Q72/XLDf0lNxW3xzIsl1C83IABjyRHkFWIhvJJym73i+fuUMsfE1J0Lbs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="358129749"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="358129749"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10749"; a="718285989"
X-IronPort-AV: E=Sophos;i="6.01,150,1684825200"; 
   d="scan'208";a="718285989"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2023 16:17:13 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>
Subject: [RFC PATCH v2 6/6] KVM: x86: Add is_vm_type_supported callback
Date:   Thu, 22 Jun 2023 16:16:30 -0700
Message-Id: <af9d610e4cba313aa09f1516dbb9bccc72049355.1687474039.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687474039.git.isaku.yamahata@intel.com>
References: <cover.1687474039.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

For TDX, allow the backend can override the supported vm type.  Add
KVM_X86_TDX_VM to reserve the bit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes v1 -> v2
- no change
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/include/uapi/asm/kvm.h    |  1 +
 arch/x86/kvm/svm/svm.c             |  7 +++++++
 arch/x86/kvm/vmx/vmx.c             |  6 ++++++
 arch/x86/kvm/x86.c                 | 10 +++++++++-
 arch/x86/kvm/x86.h                 |  2 ++
 7 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 13bc212cd4bc..c0143906fe6d 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,7 @@ KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
+KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(vm_destroy)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5afeefc7a516..6adcc6be6466 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1549,6 +1549,7 @@ struct kvm_x86_ops {
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
+	bool (*is_vm_type_supported)(unsigned long vm_type);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 6afbfbb32d56..53d382b3b423 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -561,5 +561,6 @@ struct kvm_pmu_event_filter {
 
 #define KVM_X86_DEFAULT_VM	0
 #define KVM_X86_PROTECTED_VM	1
+#define KVM_X86_TDX_VM		2
 
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index eb308c9994f9..e9ed8729f63b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4756,6 +4756,12 @@ static void svm_vm_destroy(struct kvm *kvm)
 	sev_vm_destroy(kvm);
 }
 
+static bool svm_is_vm_type_supported(unsigned long type)
+{
+	/* FIXME: Check if CPU is capable of SEV. */
+	return __kvm_is_vm_type_supported(type);
+}
+
 static int svm_vm_init(struct kvm *kvm)
 {
 	if (!pause_filter_count || !pause_filter_thresh)
@@ -4784,6 +4790,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vcpu_free = svm_vcpu_free,
 	.vcpu_reset = svm_vcpu_reset,
 
+	.is_vm_type_supported = svm_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_svm),
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..b5394ba8cb9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7469,6 +7469,11 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	return err;
 }
 
+static bool vmx_is_vm_type_supported(unsigned long type)
+{
+	return __kvm_is_vm_type_supported(type);
+}
+
 #define L1TF_MSG_SMT "L1TF CPU bug present and SMT on, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 #define L1TF_MSG_L1D "L1TF CPU bug present and virtualization mitigation disabled, data leak possible. See CVE-2018-3646 and https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/l1tf.html for details.\n"
 
@@ -8138,6 +8143,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
+	.is_vm_type_supported = vmx_is_vm_type_supported,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 	.vm_destroy = vmx_vm_destroy,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c9e1c9369be2..b5f865f39a00 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4418,12 +4418,18 @@ static int kvm_ioctl_get_supported_hv_cpuid(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static bool kvm_is_vm_type_supported(unsigned long type)
+bool __kvm_is_vm_type_supported(unsigned long type)
 {
 	return type == KVM_X86_DEFAULT_VM ||
 	       (type == KVM_X86_PROTECTED_VM &&
 	        IS_ENABLED(CONFIG_KVM_PROTECTED_VM) && tdp_enabled);
 }
+EXPORT_SYMBOL_GPL(__kvm_is_vm_type_supported);
+
+static bool kvm_is_vm_type_supported(unsigned long type)
+{
+	return static_call(kvm_x86_is_vm_type_supported)(type);
+}
 
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
@@ -4618,6 +4624,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = BIT(KVM_X86_DEFAULT_VM);
 		if (kvm_is_vm_type_supported(KVM_X86_PROTECTED_VM))
 			r |= BIT(KVM_X86_PROTECTED_VM);
+		if (kvm_is_vm_type_supported(KVM_X86_TDX_VM))
+			r |= BIT(KVM_X86_TDX_VM);
 		break;
 	default:
 		break;
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index c544602d07a3..7d5aa8f0571a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -9,6 +9,8 @@
 #include "kvm_cache_regs.h"
 #include "kvm_emulate.h"
 
+bool __kvm_is_vm_type_supported(unsigned long type);
+
 struct kvm_caps {
 	/* control of guest tsc rate supported? */
 	bool has_tsc_control;
-- 
2.25.1

