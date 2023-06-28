Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8C8741BD2
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 00:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbjF1Wn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 18:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjF1Wn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 18:43:27 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1892704;
        Wed, 28 Jun 2023 15:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687992203; x=1719528203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jWafnjK1vMbps3ygDg0zyljZpP2h9t350GzjKyOqVDk=;
  b=SrqraJa1Cts979EPRTFgyP3P0LU4gYDAOV42S1tzS/yon9Zh+vI+xkDk
   zwUN2NWk7yDSSM3229462ztaVzT4OJbpyV2XX8sz1b/K2TivByPeqZom2
   YMLAz1H6IOGP7u5+5F2qchfoxbTcMAJTxIqOqJEp3hwtVc7+yAjy30RW4
   POtzpbPGJyaqHazN/9P9phTXNZXxpLG6xxnhxXEG/b8EZibO8PDfB/H7u
   BhsM30SBwB85gqjq8qsIq9ULAAEk5+4vNNmlVu76idumZikr6Mk9OX67d
   TGqATiVVpDjCxX0801VBspBZwpWmlXCzs3NXhKgR7NZZ1KVgaEftXEArt
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="392699138"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="392699138"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="830299992"
X-IronPort-AV: E=Sophos;i="6.01,166,1684825200"; 
   d="scan'208";a="830299992"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2023 15:43:21 -0700
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
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v3 04/11] KVM: x86: Add is_vm_type_supported callback
Date:   Wed, 28 Jun 2023 15:43:03 -0700
Message-Id: <f9d3c7f910b1f157cca31943119562dc088744ea.1687991811.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1687991811.git.isaku.yamahata@intel.com>
References: <cover.1687991811.git.isaku.yamahata@intel.com>
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

For TDX, allow the backend can override the supported vm type.  Add
KVM_X86_TDX_VM to reserve the bit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v2 -> v3:
- no change
- didn't bother to rename KVM_X86_PROTECTED_VM to KVM_X86_SW_PROTECTED_VM

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
index 8ae131dc645d..3ca93e75041f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1543,6 +1543,7 @@ struct kvm_x86_ops {
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

