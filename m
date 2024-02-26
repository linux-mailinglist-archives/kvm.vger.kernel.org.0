Return-Path: <kvm+bounces-9660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B39F866C88
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:39:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EC081C21EE6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F555C60C;
	Mon, 26 Feb 2024 08:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c3c+959t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C825059B73;
	Mon, 26 Feb 2024 08:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936084; cv=none; b=UTa68KEDXNbMAHcoAf7bsLvhMDCx2N6Lmy7u3g0JOWicwndgrK1Jers3AdC2f7Sgk6UwNb13dqHQVsMkQdvLOKDSJIA0hWYeTQfZv3+1zgZxJKN50lLtbW3ORelf6M8HwqXyOtBLaSWk0edDzoQ1Swu6qgi8lCTMxvP4MAS0B4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936084; c=relaxed/simple;
	bh=l+3Kq91FdtoMuKPtJHkyFU2e9BGW3nCpaz0IbZQ7Utk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bWw0kzDEGHjA7TOGS1XkQKtEgAVnLFGFcuTSofaYR3kP2dm82VOO+ODsCIxEwF34Ccx2AzmEu7PCpNHz/ztsrmhAnG8VXigUlQ7DCeuNN7BFCp5Otc/zdDnzt3IwH2hASLFatjn1peJV5DOfGtHhFwyHQBSj69A9u9xX+m8kn5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c3c+959t; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936083; x=1740472083;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=l+3Kq91FdtoMuKPtJHkyFU2e9BGW3nCpaz0IbZQ7Utk=;
  b=c3c+959txCD2e1cHNnEVTrJDA8qmnTnCRlTxEbnJ410UEfwy5RdSM4bF
   u26yQnBLGyqEYQxDNobaUs9XrvzhVunc8LpHgNdR3EtKb9PF0iwL0ytcZ
   HpBaSER0Td2tSV+/HI8BT4dDiXmYsdFzY9p71lCAbJKlL7RejLnqLp6iu
   +GCSJfjG7e3HzZ/rwEPKjWyQqp/ZANHx/x17h+ZrGErd2LhV7cTp9s3g1
   KgC+6udG0nMtWS8MQqAAwzJsDNb31Jsp3/yE0KdIFaWAPVb7MC8xdutf9
   4uboLPs/qgQZy11/icakmdFTcXdhiRkbz0LfT5M1UYS0aGnl6qqdnFn2Z
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155306"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155306"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615624"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:01 -0800
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
Subject: [PATCH v19 036/130] KVM: TDX: x86: Add ioctl to get TDX systemwide parameters
Date: Mon, 26 Feb 2024 00:25:38 -0800
Message-Id: <167f8f7e9b19154d30c7fe8f733f947592eb244c.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
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

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
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
index 07a3f0f75f87..816ccdb4bc41 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include "capabilities.h"
 #include "x86_ops.h"
 #include "x86.h"
+#include "mmu.h"
 #include "tdx_arch.h"
 #include "tdx.h"
 
@@ -55,6 +56,58 @@ struct tdx_info {
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
@@ -68,6 +121,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
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


