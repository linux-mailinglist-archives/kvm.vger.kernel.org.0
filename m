Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35BD06A64A5
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 02:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCABTx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 20:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjCABTs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 20:19:48 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312C4659D;
        Tue, 28 Feb 2023 17:19:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677633585; x=1709169585;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pUnaHYjXRsiUVGbZOdMdxcQhv2SRJskrlW3fddI0SK4=;
  b=ZNQ+udP16NiyTMXBSWIt4wBEv5WfysP995j39RiwgpQPEqB6NuzkLzbA
   6Cb1RY0OxNNOjF+pi811p5FCQkHCGmtXBbnfwB6F+o6tDj3+XSuRohb3F
   yxRgBzXGy91S7XR0EuU0UyR28nQ/K9o8FRjFNjFMTzmVowaXM4dpdyHYe
   zxPsA2QKpwaVysieiufnduQ8efzqsPh3arQX25x5sDdrDooMWejWRZM0+
   BaiN6MQ62luH8wqHlVV9grbyhmoHxaIYaUg5IzUb8ucvbaXL8qtkiqGV1
   RhwGfNBSosy1UVEXploApXhc/ExrBhRxpFbQU6q+EUBXTvSRGgHrFe6PT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="361867119"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="361867119"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 17:19:38 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="798242345"
X-IronPort-AV: E=Sophos;i="5.98,223,1673942400"; 
   d="scan'208";a="798242345"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 17:19:38 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 4/6] KVM: TDX: Add placeholders for TDX VM/vcpu structure
Date:   Tue, 28 Feb 2023 17:19:14 -0800
Message-Id: <6dbc1fdfb61f552b7555802ac3672237570dbf1a.1677632938.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <b17eee6a7d5379bf16419c0b38ed99433afbf62f.1677632938.git.isaku.yamahata@intel.com>
References: <b17eee6a7d5379bf16419c0b38ed99433afbf62f.1677632938.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 arch/x86/kvm/vmx/main.c |  9 ++++++++
 arch/x86/kvm/vmx/tdx.h  | 50 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+)
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5c9f5e00b3c4..d21a7c7d18ea 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,7 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
@@ -211,6 +212,14 @@ static int __init vt_init(void)
 	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
 	vcpu_size = sizeof(struct vcpu_vmx);
 	vcpu_align = __alignof__(struct vcpu_vmx);
+	if (enable_tdx) {
+		vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size,
+					   sizeof(struct kvm_tdx));
+		vcpu_size = max_t(unsigned int, vcpu_size,
+				  sizeof(struct vcpu_tdx));
+		vcpu_align = max_t(unsigned int, vcpu_align,
+				   __alignof__(struct vcpu_tdx));
+	}
 	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
 	if (r)
 		goto err_kvm_init;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
new file mode 100644
index 000000000000..2210c8c1e893
--- /dev/null
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -0,0 +1,50 @@
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
+	return kvm->arch.vm_type == KVM_X86_PROTECTED_VM;
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

