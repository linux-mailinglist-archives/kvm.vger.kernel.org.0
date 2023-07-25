Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7E97625DC
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjGYWQd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231862AbjGYWQA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:16:00 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85E210F7;
        Tue, 25 Jul 2023 15:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323343; x=1721859343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FS2KQf5q2nLsELGXmMGvnBKPdHJQHT10RFv7m7kWMKA=;
  b=CGYift4CD17OEvYMWHfGuZO3zSRAdbahGzesAPdVaQnoUsIDNmKp6QpI
   n3bMixmIVIWsBirl5c1GHHVR4V0eoI3Z+CclRTHSZH7j456PE+MQmPWZ3
   WI6RnlbPH8QKrp6F6d4Cc3+pP46fSizHSUAEBjGKaOH8pOrfff9rlAyId
   xSHtaSsgcaVZYaHt/Q6AJ8XOjbXPs16m05wr6VcsgUZZ8NQMHhVrU83Qx
   OEKihaZZWufvh2ocVehQ2YS84tM81cLANRxbuoM7gu0q1ekRYoiRyKm33
   B9o4IWwSnHyveR2K6qKdWQwqog/6sytzXNAal3MrgecYGUeUHqjodCmfL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="357863124"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="357863124"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="1056938825"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="1056938825"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:22 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v15 018/115] KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
Date:   Tue, 25 Jul 2023 15:13:29 -0700
Message-Id: <e84e0b8e16cf7cd573a8a10a8903689fb9cda713.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

Implement an ioctl to get system-wide parameters for TDX.  Although the
function is systemwide, vm scoped mem_enc ioctl works for userspace VMM
like qemu and device scoped version is not define, re-use vm scoped
mem_enc.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v14 -> v15:
- ABI change: added supported_gpaw and reserved area,
---
 arch/x86/include/uapi/asm/kvm.h       | 24 ++++++++++
 arch/x86/kvm/vmx/tdx.c                | 64 +++++++++++++++++++++++++++
 tools/arch/x86/include/uapi/asm/kvm.h | 52 ++++++++++++++++++++++
 3 files changed, 140 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 615fb60b3717..3fbd43d5177b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -593,4 +593,28 @@ struct kvm_tdx_cmd {
 	__u64 error;
 };
 
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+#define TDX_CAP_GPAW_48	(1 << 0)
+#define TDX_CAP_GPAW_52	(1 << 1)
+	__u32 supported_gpaw;
+	__u32 padding;
+	__u64 reserved[251];
+
+	__u32 nr_cpuid_configs;
+	struct kvm_tdx_cpuid_config cpuid_configs[];
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ead229e34813..229c079d7686 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "x86.h"
+#include "mmu.h"
 #include "tdx.h"
 
 #undef pr_fmt
@@ -16,6 +17,66 @@
 		offsetof(struct tdsysinfo_struct, cpuid_configs))	\
 		/ sizeof(struct tdx_cpuid_config))
 
+static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx_capabilities __user *user_caps;
+	const struct tdsysinfo_struct *tdsysinfo;
+	struct kvm_tdx_capabilities *caps = NULL;
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
+		     sizeof(struct tdx_cpuid_config));
+
+	if (cmd->flags)
+		return -EINVAL;
+
+	tdsysinfo = tdx_get_sysinfo();
+	if (!tdsysinfo)
+		return -EOPNOTSUPP;
+
+	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
+	if (!caps)
+		return -ENOMEM;
+
+	user_caps = (void __user *)cmd->data;
+	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (caps->nr_cpuid_configs < tdsysinfo->num_cpuid_config) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	*caps = (struct kvm_tdx_capabilities) {
+		.attrs_fixed0 = tdsysinfo->attributes_fixed0,
+		.attrs_fixed1 = tdsysinfo->attributes_fixed1,
+		.xfam_fixed0 = tdsysinfo->xfam_fixed0,
+		.xfam_fixed1 = tdsysinfo->xfam_fixed1,
+		.supported_gpaw = TDX_CAP_GPAW_48 |
+		(kvm_get_shadow_phys_bits() >= 52 &&
+		 cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0,
+		.nr_cpuid_configs = tdsysinfo->num_cpuid_config,
+		.padding = 0,
+	};
+
+	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (copy_to_user(user_caps->cpuid_configs, &tdsysinfo->cpuid_configs,
+			 tdsysinfo->num_cpuid_config *
+			 sizeof(struct tdx_cpuid_config))) {
+		ret = -EFAULT;
+	}
+
+out:
+	/* kfree() accepts NULL. */
+	kfree(caps);
+	return ret;
+}
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
 	struct kvm_tdx_cmd tdx_cmd;
@@ -29,6 +90,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {
+	case KVM_TDX_CAPABILITIES:
+		r = tdx_get_capabilities(&tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/tools/arch/x86/include/uapi/asm/kvm.h b/tools/arch/x86/include/uapi/asm/kvm.h
index 1a6a1f987949..7a08723e99e2 100644
--- a/tools/arch/x86/include/uapi/asm/kvm.h
+++ b/tools/arch/x86/include/uapi/asm/kvm.h
@@ -562,4 +562,56 @@ struct kvm_pmu_event_filter {
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
 #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
 
+/* Trust Domain eXtension sub-ioctl() commands. */
+enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+
+	KVM_TDX_CMD_NR_MAX,
+};
+
+struct kvm_tdx_cmd {
+	/* enum kvm_tdx_cmd_id */
+	__u32 id;
+	/* flags for sub-commend. If sub-command doesn't use this, set zero. */
+	__u32 flags;
+	/*
+	 * data for each sub-command. An immediate or a pointer to the actual
+	 * data in process virtual address.  If sub-command doesn't use it,
+	 * set zero.
+	 */
+	__u64 data;
+	/*
+	 * Auxiliary error code.  The sub-command may return TDX SEAMCALL
+	 * status code in addition to -Exxx.
+	 * Defined for consistency with struct kvm_sev_cmd.
+	 */
+	__u64 error;
+	/* Reserved: Defined for consistency with struct kvm_sev_cmd. */
+	__u64 unused;
+};
+
+struct kvm_tdx_cpuid_config {
+	__u32 leaf;
+	__u32 sub_leaf;
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
+#define TDX_CAP_GPAW_48		(1 << 0)
+#define TDX_CAP_GPAW_52		(1 << 1)
+	__u32 supported_gpaw;
+	__u32 padding;
+	__u64 reserved[251];
+
+	__u32 nr_cpuid_configs;
+	struct kvm_tdx_cpuid_config cpuid_configs[];
+};
+
 #endif /* _ASM_X86_KVM_H */
-- 
2.25.1

