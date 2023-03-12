Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD4D66B690B
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 18:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjCLR5z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 13:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjCLR5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 13:57:52 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EB43B23D;
        Sun, 12 Mar 2023 10:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678643871; x=1710179871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fHYFsmBYMZWWGVo5gVSDOb5YGEEu1qWAzdz4NCNlF9s=;
  b=BpXn/RS/eLE/XHBgUaD+B7qb2D254N3COVbT54GxabCoSq/EUgYlgV+n
   U/vSyZSHgS5XUUJBdX54sR98mHbRPZ3nSgCZjBBx7DKy7tVnZ3ynKtlpZ
   YTcOH8B8BTd8HcgfK6elmoffjGuiePDnvo9A4mFfay3rWDB3DW5915ecl
   Ox/YZYBxjf/HyK2vnkVQRmCNx7voYQW59Klnue02g8D6wZG6l3vzDTZwX
   C2hk4UNnHjvJ3Bj2DLUzRHZlhdhZMW3WA5FdqMb/swrjRYuhmuPDjwOVg
   mgm+/mT3JGaG6lEBdniAPtN13PIksJfT0nmgeAUwY4e774an+bsLkEcP9
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="320863553"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="320863553"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="628396909"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="628396909"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:57:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 004/113] KVM: TDX: Initialize logical processor when onlined
Date:   Sun, 12 Mar 2023 10:55:28 -0700
Message-Id: <82616f9c8a4fadeae48eea42c31aed270f3c25c4.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
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

TDX requires to call a TDX initialization function per logical processor
(LP) before the LP uses TDX.  When CPU is onlined, call the TDX LP
initialization API when cpu is onlined.  If it failed refuse onlininig of
the cpu for simplicity instead of TDX avoiding the LP.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c    | 15 ++++++++++++++-
 arch/x86/kvm/vmx/tdx.c     |  5 +++++
 arch/x86/kvm/vmx/x86_ops.h |  2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 5c9f5e00b3c4..d1c9c7f55050 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -9,6 +9,19 @@
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
+static int vt_hardware_enable(void)
+{
+	int ret;
+
+	ret = vmx_hardware_enable();
+	if (!ret && enable_tdx) {
+		ret = tdx_hardware_enable();
+		if (ret)
+			vmx_hardware_disable();
+	}
+	return ret;
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -40,7 +53,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = vmx_hardware_enable,
+	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f3eb0138b60b..e51314bbb439 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -10,6 +10,11 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+int tdx_hardware_enable(void)
+{
+	return tdx_cpu_enable();
+}
+
 static int __init tdx_module_setup(void)
 {
 	int ret;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 0f200aead411..010d02c86ba4 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -139,8 +139,10 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+int tdx_hardware_enable(void);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
+static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.25.1

