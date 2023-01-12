Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E04667B2B
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240479AbjALQkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjALQh3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:29 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4078310E4;
        Thu, 12 Jan 2023 08:33:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541229; x=1705077229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HvvKYI1Xf9Q8i4IYWiUvx8L3dyljg6f6JJmuQ6ZMQOs=;
  b=nAbZv1DoSAgjT8tgrOuDu9c52Fz+m//t7lIOcXdR40G8CHOU+0XtqL4h
   u2HvGeGkiD64OEDV5dMvCBXazIleYWPwQQf2JPu4AnjkCiDgoF7ks4Ct4
   oTZy8FyrEj2Lc5v+z1D0Jx168LIknXIk9kr/BH8+x3ELqghwbYvxOX2Tz
   Hplc/QY2KppyhhDsDEZk6tWVxQNNIiZU0uBKkbr73woXduvrdp0O8ek8p
   QkVzN/AHsoH8TpH6jaPJk3B4xvisxAMLsyXWw1uMZNwjGzVcYmhH0rgfC
   AGGoU5AH4vXNotLixPxtu9DIOJvv4rintoQ9N5zP/q0kfNylUYwNDzJi6
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811651"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811651"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:20 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151630"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151630"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:19 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 003/113] KVM: TDX: Add placeholders for TDX VM/vcpu structure
Date:   Thu, 12 Jan 2023 08:31:11 -0800
Message-Id: <fe6506f107b2537da6536fce641acf76481d9378.1673539699.git.isaku.yamahata@intel.com>
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

Add placeholders TDX VM/vcpu structure that overlays with VMX VM/vcpu
structures.  Initialize VM structure size and vcpu size/align so that x86
KVM common code knows those size irrespective of VMX or TDX.  Those
structures will be populated as guest creation logic develops.

Add helper functions to check if the VM is guest TD and add conversion
functions between KVM VM/VCPU and TDX VM/VCPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c |  8 +++---
 arch/x86/kvm/vmx/tdx.h  | 54 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 58474511a057..18f659d1d456 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,7 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = KBUILD_MODNAME,
@@ -181,9 +182,10 @@ static int __init vt_init(void)
 	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
 	 * exposed to userspace!
 	 */
-	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
-	vcpu_size = sizeof(struct vcpu_vmx);
-	vcpu_align = __alignof__(struct vcpu_vmx);
+	vt_x86_ops.vm_size = max(sizeof(struct kvm_vmx), sizeof(struct kvm_tdx));
+	vcpu_size = max(sizeof(struct vcpu_vmx), sizeof(struct vcpu_tdx));
+	vcpu_align = max(__alignof__(struct vcpu_vmx),
+			 __alignof__(struct vcpu_tdx));
 	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
 	if (r)
 		goto err_kvm_init;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
new file mode 100644
index 000000000000..060bf48ec3d6
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_X86_TDX_H
+#define __KVM_X86_TDX_H
+
+#ifdef CONFIG_INTEL_TDX_HOST
+struct kvm_tdx {
+	struct kvm kvm;
+	/* TDX specific members follow. */
+};
+
+struct vcpu_tdx {
+	struct kvm_vcpu	vcpu;
+	/* TDX specific members follow. */
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
+struct kvm_tdx {
+	struct kvm kvm;
+};
+
+struct vcpu_tdx {
+	struct kvm_vcpu	vcpu;
+};
+
+static inline bool is_td(struct kvm *kvm) { return false; }
+static inline bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
+static inline struct kvm_tdx *to_kvm_tdx(struct kvm *kvm) { return NULL; }
+static inline struct vcpu_tdx *to_tdx(struct kvm_vcpu *vcpu) { return NULL; }
+#endif /* CONFIG_INTEL_TDX_HOST */
+
+#endif /* __KVM_X86_TDX_H */
-- 
2.25.1

