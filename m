Return-Path: <kvm+bounces-6594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 998A083797C
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:39:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEB97B28F37
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BB5259B67;
	Mon, 22 Jan 2024 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H3rJGzcF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0C958215;
	Mon, 22 Jan 2024 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967710; cv=none; b=V4ohe5FDuc5ux5HyXYh74KmfxRGFqbYjnnGacerwuF+/2MvXb7CE0VNgj/NHqplECdct/52+8pEMMYlyTr440mTdxg2xd/vJ/tb0gZRLjWTUPeb0oPuNlDh0mGqrXfuL+JKed3ZXxG7xS1bc4waMJpF+WepK2FV/ieeo7XG3QZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967710; c=relaxed/simple;
	bh=/IpXf6q2HIiffBzQTDZeHDqFau93VOm68NM2Sm+L3Rg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o/Uh6mPpqoDqZxgbNwEzwXx7O7hmdhMkdGMLHYtRPHb13l42f0eRGLdYQRogPDnYu7/sYmeatgT4o03Th7FL8JkZgUIjbcHVJvzTT2UugBqb4lzXbRIOfgobfJJaQvjYsO5cTr8kbQ0ZnhBRduVjR2+aaL2m5zUj6LdapYjSMqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H3rJGzcF; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967709; x=1737503709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/IpXf6q2HIiffBzQTDZeHDqFau93VOm68NM2Sm+L3Rg=;
  b=H3rJGzcFLfEcwQKEUO3VaQjYmsztktFsrXu/OK9HGOck9xdST4yNS69h
   WF9Q07zhYagaAxRNKzWqAugLTEnAN9jhumwHtB1K2BSBIOvFWhNCLqm3o
   zNqCbur8jR3KHUXHOcD/9M0ltbi0sSQNHYXKBL4RF6VYXMtpXAFDGqjUk
   4XHhOMcbBedS9OW1eADaiC6xTHmcKB42DUlEKSk5IpS9DKjk6NjDDrN7a
   hENWQXNr3SDwZTVWSsshIQJ4AE7SwutAmE699k1feUztGlVK0Z7kuNF4s
   3NcqinG0lTYy9yNlM7XVTbdRWoy27VX/o7tTjnuJsZhCRd6bdmj34P6dt
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243790"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243790"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888492"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888492"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:07 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v18 022/121] KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
Date: Mon, 22 Jan 2024 15:52:58 -0800
Message-Id: <0399cb7a1bc7198999b7a8050de0b272fa0480ff.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

Implement an ioctl to get system-wide parameters for TDX.  Although the
function is systemwide, vm scoped mem_enc ioctl works for userspace VMM
like qemu and device scoped version is not define, re-use vm scoped
mem_enc.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v18:
- drop the use of tdhsysinfo_struct and TDH.SYS.INFO, use TDH.SYS.RD().
  For that, dynamically allocate/free tdx_info.
- drop the change of tools/arch/x86/include/uapi/asm/kvm.h.

v14 -> v15:
- ABI change: added supported_gpaw and reserved area.
---
 arch/x86/include/uapi/asm/kvm.h | 17 ++++++++++
 arch/x86/kvm/vmx/tdx.c          | 56 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h          |  3 ++
 3 files changed, 76 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 9ea46d143bef..e28189c81691 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -604,4 +604,21 @@ struct kvm_tdx_cpuid_config {
 	__u32 edx;
 };
 
+/* supported_gpaw */
+#define TDX_CAP_GPAW_48	(1 << 0)
+#define TDX_CAP_GPAW_52	(1 << 1)
+
+struct kvm_tdx_capabilities {
+	__u64 attrs_fixed0;
+	__u64 attrs_fixed1;
+	__u64 xfam_fixed0;
+	__u64 xfam_fixed1;
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
index 56655e6bfd5e..8c463407f8a8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "x86.h"
+#include "mmu.h"
 #include "tdx_arch.h"
 #include "tdx.h"
 
@@ -99,6 +100,58 @@ struct tdx_info {
 /* Info about the TDX module. */
 static struct tdx_info *tdx_info;
 
+static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
+{
+	struct kvm_tdx_capabilities __user *user_caps;
+	struct kvm_tdx_capabilities *caps = NULL;
+	int ret = 0;
+
+	if (cmd->flags)
+		return -EINVAL;
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
+	if (caps->nr_cpuid_configs < tdx_info->num_cpuid_config) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	*caps = (struct kvm_tdx_capabilities) {
+		.attrs_fixed0 = tdx_info->attributes_fixed0,
+		.attrs_fixed1 = tdx_info->attributes_fixed1,
+		.xfam_fixed0 = tdx_info->xfam_fixed0,
+		.xfam_fixed1 = tdx_info->xfam_fixed1,
+		.supported_gpaw = TDX_CAP_GPAW_48 |
+		((kvm_get_shadow_phys_bits() >= 52 &&
+		  cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0),
+		.nr_cpuid_configs = tdx_info->num_cpuid_config,
+		.padding = 0,
+	};
+
+	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
+		ret = -EFAULT;
+		goto out;
+	}
+	if (copy_to_user(user_caps->cpuid_configs, &tdx_info->cpuid_configs,
+			 tdx_info->num_cpuid_config *
+			 sizeof(tdx_info->cpuid_configs[0]))) {
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
@@ -112,6 +165,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {
+	case KVM_TDX_CAPABILITIES:
+		r = tdx_get_capabilities(&tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 473013265bd8..22c0b57f69ca 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -3,6 +3,9 @@
 #define __KVM_X86_TDX_H
 
 #ifdef CONFIG_INTEL_TDX_HOST
+
+#include "tdx_ops.h"
+
 struct kvm_tdx {
 	struct kvm kvm;
 	/* TDX specific members follow. */
-- 
2.25.1


