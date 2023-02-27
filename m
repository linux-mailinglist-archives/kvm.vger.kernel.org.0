Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859456A3C6B
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbjB0IYZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjB0IYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:09 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878C01B56A;
        Mon, 27 Feb 2023 00:24:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486248; x=1709022248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZHtH5cD+sidHdCeHBrWYu6ZRCepDrZPF+TBklpC+idg=;
  b=QmvguWykQ707u+UBZ3vMGTw5NcHoVZtVruPyeP5ffPiQsXSfdHBtZTze
   m/jfmbIzkXdagwzpeQEJZMhMd5/pHiq4n+1VhiYaLoKjiMLxgypuUyMEv
   +FRdwCD3HhzyvqyXn8/RSO+SaLisKk3NmAqKBrB196YnexZBiMTpPL4zq
   Nn9r+BIM+//m4yH1GL9QbWqrz+jbYcYNMghgz6sGZi4BLZUpqyuku2pWD
   YlZ5YsR1HUJFb+uJwmEkapW0/PoxCsYqCK+Kwi9GceLPkTLQzNSWL7YH4
   43iZtUrKEylXnqcAnpV4i3NTGPwUvQeEBeVJD9pQZphpPkb2AzsveAcgf
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608705"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608705"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242044"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242044"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:02 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 011/106] KVM: x86, tdx: Make KVM_CAP_MAX_VCPUS backend specific
Date:   Mon, 27 Feb 2023 00:22:10 -0800
Message-Id: <ec9ee6f90f8c5702baee7f70e03caa2f4e92adf7.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX has its own limitation on the maximum number of vcpus.  Make it backend
specific and return TDX specific value for KVM_CAP_MAX_VCPUS.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  1 +
 arch/x86/kvm/vmx/main.c            | 13 +++++++++++++
 arch/x86/kvm/x86.c                 |  2 ++
 4 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 58fbaa05fc8c..6914f1d61803 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -21,6 +21,7 @@ KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
+KVM_X86_OP_OPTIONAL(max_vcpus);
 KVM_X86_OP(vm_init)
 KVM_X86_OP_OPTIONAL(vm_destroy)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 58fc697095fd..1c761c9e1edb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1547,6 +1547,7 @@ struct kvm_x86_ops {
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
+	int (*max_vcpus)(struct kvm *kvm);
 	unsigned int vm_size;
 	int (*vm_init)(struct kvm *kvm);
 	void (*vm_destroy)(struct kvm *kvm);
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d90da9fd75bf..41c2e4a1b157 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -6,6 +6,7 @@
 #include "nested.h"
 #include "pmu.h"
 #include "tdx.h"
+#include "tdx_arch.h"
 
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
@@ -16,6 +17,17 @@ static bool vt_is_vm_type_supported(unsigned long type)
 		(enable_tdx && tdx_is_vm_type_supported(type));
 }
 
+static int vt_max_vcpus(struct kvm *kvm)
+{
+	if (!kvm)
+		return KVM_MAX_VCPUS;
+
+	if (is_td(kvm))
+		return min3(kvm->max_vcpus, KVM_MAX_VCPUS, TDX_MAX_VCPUS);
+
+	return kvm->max_vcpus;
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -68,6 +80,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.is_vm_type_supported = vt_is_vm_type_supported,
+	.max_vcpus = vt_max_vcpus,
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vt_vm_init,
 	.vm_destroy = vmx_vm_destroy,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e00fb7863a8..c54baa3973f2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4490,6 +4490,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		break;
 	case KVM_CAP_MAX_VCPUS:
 		r = KVM_MAX_VCPUS;
+		if (kvm_x86_ops.max_vcpus)
+			r = static_call(kvm_x86_max_vcpus)(kvm);
 		break;
 	case KVM_CAP_MAX_VCPU_ID:
 		r = KVM_MAX_VCPU_IDS;
-- 
2.25.1

