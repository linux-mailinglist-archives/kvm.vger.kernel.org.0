Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A93355CEE4
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbiF0Vy7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241231AbiF0Vyu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:54:50 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84AC62CB;
        Mon, 27 Jun 2022 14:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366889; x=1687902889;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=azLn1KZFSAvulODwww3zGI7nQIQ/QojtxTEnsgybckA=;
  b=exOpChkE2FqXbZUqBeyx1lcqEYifgACPZmBze2UxNUr3ppr+/T2D08ZX
   52W/zxplz/GGRHHqsxcbdT3rAABLMcxsFa1tELAGsy5ZG/VKRjb4IZIkg
   E31bQ0Q4riZxt5MbNLEmptjnaJ3JHHJ8FX1BSkbcOW70qvl14CUsPT1FS
   1OT/8V9APzbhQh5a/8WpKBUzcnqjIbuspFSA1gU0wm2HR8WJ60YuLnlkl
   C7cWu6dSdA03HCvhHtuPkvOprBJGQ2Hu17P3lNeC+U2acTjv+hWuAlTxN
   Y1aUT2WPaUyd2jJjtZ3JhfMuirUCbVRhlZA26qKYI6fpTjyu6xUPAk5eC
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609503"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609503"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:49 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863456"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 009/102] KVM: TDX: Add placeholders for TDX VM/vcpu structure
Date:   Mon, 27 Jun 2022 14:53:01 -0700
Message-Id: <aa6fd228ab98769e4c7a48dc6818fc6d39b56b64.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
 arch/x86/kvm/vmx/main.c |  8 +++---
 arch/x86/kvm/vmx/tdx.c  |  1 +
 arch/x86/kvm/vmx/tdx.h  | 54 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 371dad728166..349534412216 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,7 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 static bool __read_mostly enable_tdx = IS_ENABLED(CONFIG_INTEL_TDX_HOST);
 module_param_named(tdx, enable_tdx, bool, 0444);
@@ -175,9 +176,10 @@ static int __init vt_init(void)
 	unsigned int vcpu_size, vcpu_align;
 	int r;
 
-	vt_x86_ops.vm_size = sizeof(struct kvm_vmx);
-	vcpu_size = sizeof(struct vcpu_vmx);
-	vcpu_align = __alignof__(struct vcpu_vmx);
+	vt_x86_ops.vm_size = max(sizeof(struct kvm_vmx), sizeof(struct kvm_tdx));
+	vcpu_size = max(sizeof(struct vcpu_vmx), sizeof(struct vcpu_tdx));
+	vcpu_align = max(__alignof__(struct vcpu_vmx),
+			__alignof__(struct vcpu_tdx));
 
 	hv_vp_assist_page_init();
 	vmx_init_early();
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c12e61cdddea..2617389ef466 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -5,6 +5,7 @@
 
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "tdx.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt) "tdx: " fmt
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

