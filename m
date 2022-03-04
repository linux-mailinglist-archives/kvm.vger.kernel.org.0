Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712C44CDEB3
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 21:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiCDUFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiCDUFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:05:15 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E65F23D001;
        Fri,  4 Mar 2022 12:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646424039; x=1677960039;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rg8hgn95fglkNZIqjv1gWSem8sjNEP1K35CgK93HjXg=;
  b=AVdxrP03L2GmLfHDr53NeY2vwNOmq0MbeDapGLuDUbbwioHLq43NTV0N
   10loZjwVc7UYgUdpAPHNy4ntiAvWzzvPdY20PmY0G3lAjTNJ0DAhvZ5NX
   ZkYeWb1ILd/pYUKC8YdDsKkY5aDR8xQ2VqyhKVHKsmgOPgM/EO7BZfo48
   JBon+67s30r6GLYieytQZuyQYCMrJaswjBi+7HloQYV3pODxVdl8WqZBM
   MWqg8p6ieTJpEZtqb4zZnQlRRGLXr8Z2XAK1vDccoHsMYZmQeMxQEmiOs
   PlV7cBVpkM7tTPO2vKklI6m4UNCiVcuS0Sg1Q+dSBd5CSnpXjNdT/gIAd
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253983299"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253983299"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:04 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344086"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:04 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 006/104] KVM: TDX: Add placeholders for TDX VM/vcpu structure
Date:   Fri,  4 Mar 2022 11:48:22 -0800
Message-Id: <8572ed61be2bb771fc4dc1d366a1261c80b7f666.1646422845.git.isaku.yamahata@intel.com>
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

Add placeholders TDX VM/vcpu structure that overlays with VMX VM/vcpu
structures.  Initialize VM structure size and vcpu size/align so that x86
KVM common code knows those size irrespective of VMX or TDX.  Those
structures will be populated as guest creation logic develops.

Add helper functions to check if the VM is guest TD and add conversion
functions between KVM VM/VCPU and TDX VM/VCPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    |  3 +++
 arch/x86/kvm/vmx/tdx.c     | 11 +++++++++
 arch/x86/kvm/vmx/tdx.h     | 47 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  4 ++++
 4 files changed, 65 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 8ff13c7881f2..28a7597d0782 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -171,6 +171,9 @@ static int __init vt_init(void)
 	unsigned int vcpu_size = 0, vcpu_align = 0;
 	int r;
 
+	/* tdx_pre_kvm_init must be called before vmx_pre_kvm_init(). */
+	tdx_pre_kvm_init(&vcpu_size, &vcpu_align, &vt_x86_ops.vm_size);
+
 	vmx_pre_kvm_init(&vcpu_size, &vcpu_align);
 
 	r = kvm_init(&vt_init_ops, vcpu_size, vcpu_align, THIS_MODULE);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1acf08c310c4..8ed3ec342e28 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,6 +5,7 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "tdx.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
@@ -51,3 +52,13 @@ void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	if (__tdx_hardware_setup(&vt_x86_ops))
 		enable_tdx = false;
 }
+
+void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
+			unsigned int *vcpu_align, unsigned int *vm_size)
+{
+	*vcpu_size = sizeof(struct vcpu_tdx);
+	*vcpu_align = __alignof__(struct vcpu_tdx);
+
+	if (sizeof(struct kvm_tdx) > *vm_size)
+		*vm_size = sizeof(struct kvm_tdx);
+}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
new file mode 100644
index 000000000000..daf6bfc6502a
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_TDX_H
+#define __KVM_X86_TDX_H
+
+#ifdef CONFIG_INTEL_TDX_HOST
+struct kvm_tdx {
+	struct kvm kvm;
+};
+
+struct vcpu_tdx {
+	struct kvm_vcpu	vcpu;
+};
+
+static inline bool is_td(struct kvm *kvm)
+{
+	/*
+	 * TDX VM type isn't defined yet.
+	 * return kvm->arch.vm_type == KVM_X86_TDX_VM;
+	 */
+	return false;
+}
+
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu)
+{
+	return is_td(vcpu->kvm);
+}
+
+static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm)
+{
+	return container_of(kvm, struct kvm_tdx, kvm);
+}
+
+static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu)
+{
+	return container_of(vcpu, struct vcpu_tdx, vcpu);
+}
+#else
+struct kvm_tdx;
+struct vcpu_tdx;
+
+static inline bool is_td(struct kvm *kvm) { return false; }
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return NULL; }
+static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) { return NULL; }
+#endif /* CONFIG_INTEL_TDX_HOST */
+
+#endif /* __KVM_X86_TDX_H */
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 7da541e1c468..1bad27e592b5 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -127,8 +127,12 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
+void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
+			unsigned int *vcpu_align, unsigned int *vm_size);
 void __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
 #else
+static inline void tdx_pre_kvm_init(
+	unsigned int *vcpu_size, unsigned int *vcpu_align, unsigned int *vm_size) {}
 static inline void tdx_hardware_setup(struct kvm_x86_ops *x86_ops) {}
 #endif
 
-- 
2.25.1

