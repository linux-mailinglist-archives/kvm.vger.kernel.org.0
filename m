Return-Path: <kvm+bounces-23902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A44CC94F9E1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C96C91C21A92
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 623A219DF82;
	Mon, 12 Aug 2024 22:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e16vSp34"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BC719D070;
	Mon, 12 Aug 2024 22:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502918; cv=none; b=bjK2OqFTc9MHojqn12BlIgZBtk26NchpgIvWxbbcVRrU+JDB0Vwgh+D+uL+bqdid7aX9y/YDMaa5Nl4WOjVD0bvIgidelJRQ/f7yOs9hUg9Fvycb5zgyTKNrbNPHycGyVfu/N1tNbPm/DvnDAifrwoxukQC5IWEoGCqgtACc2Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502918; c=relaxed/simple;
	bh=j4Y2BGbvsHIJYnljwI5pMtQGF+TawdHNTeLi+06hyjs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aOW8c0UBXw56s2Ym8tKj09JlD9nn06iGp0t5WY7eAljMHQnnR2u75Atn8t3m/sQwicvE7MfyBYOqWNrpMXBPb/WuNRxYyRSYISfzaBCvl3QTg4ZlpkfXD4OpJhaI0lBaA8IuH+LW9ntKCgjH0o1t2d1OWvISuyBGEUlMRmYdzww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e16vSp34; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502916; x=1755038916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j4Y2BGbvsHIJYnljwI5pMtQGF+TawdHNTeLi+06hyjs=;
  b=e16vSp34OlLQehOlN4MgOJ7wIQiPsv/UQyPYr72WjjCVXEIm/z39SlpP
   06dsK9+Z6GOaa2UfaENEtk2gysgeZdet5yI1FQCQNaDNcmbJ80DNosGHv
   UhV5EbZ4pH0O27Kq1+f8Xu4KSG/THFqCE7p/UHfwIdgzXwICoWaeO8AhM
   LDqMqtkNPcYo00bOIUpO/lCwllpIpflT4Nk3ipBrIZ/SszjChHrF0j34F
   jMN5zbOn+c0fges3rmPbwTqOocmGzh1E7EVb21Unse7umZkTh44kkY+8K
   R+jinHAOOHbpdHr7zppOGbWyywM5/CpV+xxIsOQMgMW/qv26bRc/IqsEc
   A==;
X-CSE-ConnectionGUID: CGzepzP2Rd68ETRH7N/Dxw==
X-CSE-MsgGUID: dcHGAejCRiKrfa70Eas6Nw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041386"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041386"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:31 -0700
X-CSE-ConnectionGUID: eIQJRq6aRjKJJEqy2kwwxA==
X-CSE-MsgGUID: y8Hkr8EvSkSIroagU+9mgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008391"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:31 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on initialization
Date: Mon, 12 Aug 2024 15:48:04 -0700
Message-Id: <20240812224820.34826-10-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM needs system-wide information about the TDX module, store it in
struct tdx_info.  Release the allocated memory on module unloading by
hardware_unsetup() callback.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
uAPI breakout v1:
 - Mention about hardware_unsetup(). (Binbin)
 - Added Reviewed-by. (Binbin)
 - Eliminated tdx_md_read(). (Kai)
 - Include "x86_ops.h" to tdx.c as the patch to initialize TDX module
   doesn't include it anymore.
 - Introduce tdx_vm_ioctl() as the first tdx func in x86_ops.h

v19:
 - Added features0
 - Use tdx_sys_metadata_read()
 - Fix error recovery path by Yuan

Change v18:
 - Newly Added
---
 arch/x86/include/uapi/asm/kvm.h | 28 +++++++++++++
 arch/x86/kvm/vmx/tdx.c          | 70 +++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index d91f1bad800e..47caf508cca7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -952,4 +952,32 @@ struct kvm_tdx_cmd {
 	__u64 hw_error;
 };
 
+#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
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
index de14e80d8f3a..90b44ebaf864 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3,6 +3,7 @@
 #include <asm/tdx.h>
 #include "capabilities.h"
 #include "x86_ops.h"
+#include "mmu.h"
 #include "tdx.h"
 
 #undef pr_fmt
@@ -30,6 +31,72 @@ static void __used tdx_guest_keyid_free(int keyid)
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
 
+static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
+{
+	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	struct kvm_tdx_capabilities __user *user_caps;
+	struct kvm_tdx_capabilities *caps = NULL;
+	int i, ret = 0;
+
+	/* flags is reserved for future use */
+	if (cmd->flags)
+		return -EINVAL;
+
+	caps = kmalloc(sizeof(*caps), GFP_KERNEL);
+	if (!caps)
+		return -ENOMEM;
+
+	user_caps = u64_to_user_ptr(cmd->data);
+	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (caps->nr_cpuid_configs < td_conf->num_cpuid_config) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	*caps = (struct kvm_tdx_capabilities) {
+		.attrs_fixed0 = td_conf->attributes_fixed0,
+		.attrs_fixed1 = td_conf->attributes_fixed1,
+		.xfam_fixed0 = td_conf->xfam_fixed0,
+		.xfam_fixed1 = td_conf->xfam_fixed1,
+		.supported_gpaw = TDX_CAP_GPAW_48 |
+		((kvm_host.maxphyaddr >= 52 &&
+		  cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0),
+		.nr_cpuid_configs = td_conf->num_cpuid_config,
+		.padding = 0,
+	};
+
+	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	for (i = 0; i < td_conf->num_cpuid_config; i++) {
+		struct kvm_tdx_cpuid_config cpuid_config = {
+			.leaf = (u32)td_conf->cpuid_config_leaves[i],
+			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
+			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
+			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
+			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
+			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
+		};
+
+		if (copy_to_user(&(user_caps->cpuid_configs[i]), &cpuid_config,
+					sizeof(struct kvm_tdx_cpuid_config))) {
+			ret = -EFAULT;
+			break;
+		}
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
@@ -48,6 +115,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {
+	case KVM_TDX_CAPABILITIES:
+		r = tdx_get_capabilities(&tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
-- 
2.34.1


