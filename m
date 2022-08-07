Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF9C58BD0E
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbiHGWCp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiHGWCd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:02:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44509647E;
        Sun,  7 Aug 2022 15:02:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909753; x=1691445753;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CPctVshAYvBZQeYePQA7/EdHee14GQa4BWG3ivvY6lo=;
  b=AX+xTwkFQTEjqdHMr+jOLTZm0jPUcfmS6He8Z5jiNVoQNCqkY3p4nuGG
   tXmvFcIfKPqsSvpqgmvo8TWzlqM003vSs6YnUCm+CBIux8HN84jaKknA3
   rlhBNojJBR0G3/RMVET6OOEjmq5dvpcbYpXX25r8GIBobFf+BNmSGr5e/
   zGDZkuVah2B7jitZ19DtLHpwayAFU5rFUtUpjAa5MHNC+vUSmlt7bGtko
   brRPa8a5oLW7JOYp6SKyH6zH+UDu4DeFXDwh4hpQdK546xrvWbPjJ44HZ
   0/ym4F6k4Xp2fGFc1Y74mr4xV/S/9ZBv7n/72K0rWXvpMqX0d6w/XHxyn
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224053"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224053"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682457"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:29 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 007/103] KVM: TDX: Add placeholders for TDX VM/vcpu structure
Date:   Sun,  7 Aug 2022 15:00:52 -0700
Message-Id: <435820db6a973d7befc70a75c25c4dd2888256d6.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 arch/x86/kvm/vmx/main.c |  8 +++---
 arch/x86/kvm/vmx/tdx.h  | 54 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 59 insertions(+), 3 deletions(-)
 create mode 100644 arch/x86/kvm/vmx/tdx.h

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 381e1ab760de..a0252cc0b48d 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -5,6 +5,7 @@
 #include "vmx.h"
 #include "nested.h"
 #include "pmu.h"
+#include "tdx.h"
 
 struct kvm_x86_ops vt_x86_ops __initdata = {
 	.name = "kvm_intel",
@@ -159,9 +160,10 @@ static int __init vt_init(void)
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

