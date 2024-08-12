Return-Path: <kvm+bounces-23904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 278AF94F9E5
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4B4BF1C20FE8
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D4B919E7CF;
	Mon, 12 Aug 2024 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fUYhOnLH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E087519D088;
	Mon, 12 Aug 2024 22:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502919; cv=none; b=Q7kL6W4fy+gSwVyxR/xJuy7r0rwuffbbiWMSJRXb+G5pA8MQVwAuehw0AhOB9maMI1E15Jc1ikf4o+iURLp/rG+Q3aY6woTXc/IBP2GvB5f5EfT0rhna5esWitrrjUNqYXi+TJWEhUQwCV80kA9gJTBCTDjetuREXi6y5uzCivc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502919; c=relaxed/simple;
	bh=jsaF1/4L2ZlPKq7Wkr79QD6T8YiApcLdcfsVHvTCHZw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GPyVQOKV4CrpsvEXqHDnGtM4DDQYc2QNkasD8b1LRCZpFULC+pdQJRaOuKFDTf6BI1fh/PQ81xry9gjcXGTC61v0qt62G4MH8islYxr7pu5+e/V4ukHPp7z830WLGlFqCEdyeA1rhHOTqumDdTC3sKFjoB01tPVO0H1aDQlczak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fUYhOnLH; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502917; x=1755038917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jsaF1/4L2ZlPKq7Wkr79QD6T8YiApcLdcfsVHvTCHZw=;
  b=fUYhOnLH29/jhiOzZy3IF8yxwohcWayZUoh7ChHRSG6mgDq0MWgNOmzD
   LRMhZG0dvo6V3ZrCBbVvzJqPoVAFaAYbGb/QGQko6ZRTyAfCTXe6Mf5fM
   J0rZINtF3FPA0Bs2C+U9/vyZNbTbpXUreemtwGC9A5okPVNpHFEDvkor1
   vBbXuksGKImW+6xSQHHU7jje6148cRDSgVQoC83enmGm79IvJR6/KkOoA
   CgoJQ9MswLM6V7Nn0irJKx4OR7044dY2z507Hyj0Al4V+z+6eU1UlE2aY
   kQL3yAqie08mIA0kVZ0WAOmkyL3Y0FDWn9fpseoB0fkVgRT0olNToDP8S
   w==;
X-CSE-ConnectionGUID: ExkMCNS3Rq2kJBoYRmU9YA==
X-CSE-MsgGUID: LUEpLIe1R3i3CrkFgAsNpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041392"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041392"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:31 -0700
X-CSE-ConnectionGUID: HQ/zeQ9XRhCATq3TeOPOYA==
X-CSE-MsgGUID: XTMaglR/Q7OVjKVurpAJWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008395"
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
	rick.p.edgecombe@intel.com
Subject: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities when module setup
Date: Mon, 12 Aug 2024 15:48:05 -0700
Message-Id: <20240812224820.34826-11-rick.p.edgecombe@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

While TDX module reports a set of capabilities/features that it
supports, what KVM currently supports might be a subset of them.
E.g., DEBUG and PERFMON are supported by TDX module but currently not
supported by KVM.

Introduce a new struct kvm_tdx_caps to store KVM's capabilities of TDX.
supported_attrs and suppported_xfam are validated against fixed0/1
values enumerated by TDX module. Configurable CPUID bits derive from TDX
module plus applying KVM's capabilities (KVM_GET_SUPPORTED_CPUID),
i.e., mask off the bits that are configurable in the view of TDX module
but not supported by KVM yet.

KVM_TDX_CPUID_NO_SUBLEAF is the concept from TDX module, switch it to 0
and use KVM_CPUID_FLAG_SIGNIFCANT_INDEX, which are the concept of KVM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - Change setup_kvm_tdx_caps() to use the exported 'struct tdx_sysinfo'
   pointer.
 - Change how to copy 'kvm_tdx_cpuid_config' since 'struct tdx_sysinfo'
   doesn't have 'kvm_tdx_cpuid_config'.
 - Updates for uAPI changes
---
 arch/x86/include/uapi/asm/kvm.h |  2 -
 arch/x86/kvm/vmx/tdx.c          | 81 +++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 47caf508cca7..c9eb2e2f5559 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -952,8 +952,6 @@ struct kvm_tdx_cmd {
 	__u64 hw_error;
 };
 
-#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
-
 struct kvm_tdx_cpuid_config {
 	__u32 leaf;
 	__u32 sub_leaf;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 90b44ebaf864..d89973e554f6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -31,6 +31,19 @@ static void __used tdx_guest_keyid_free(int keyid)
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
 
+#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
+
+struct kvm_tdx_caps {
+	u64 supported_attrs;
+	u64 supported_xfam;
+
+	u16 num_cpuid_config;
+	/* This must the last member. */
+	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
+};
+
+static struct kvm_tdx_caps *kvm_tdx_caps;
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
@@ -131,6 +144,68 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	return r;
 }
 
+#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
+
+static int __init setup_kvm_tdx_caps(void)
+{
+	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	u64 kvm_supported;
+	int i;
+
+	kvm_tdx_caps = kzalloc(sizeof(*kvm_tdx_caps) +
+			       sizeof(struct kvm_tdx_cpuid_config) * td_conf->num_cpuid_config,
+			       GFP_KERNEL);
+	if (!kvm_tdx_caps)
+		return -ENOMEM;
+
+	kvm_supported = KVM_SUPPORTED_TD_ATTRS;
+	if ((kvm_supported & td_conf->attributes_fixed1) != td_conf->attributes_fixed1)
+		goto err;
+
+	kvm_tdx_caps->supported_attrs = kvm_supported & td_conf->attributes_fixed0;
+
+	kvm_supported = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
+
+	/*
+	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
+	 * and, CET support.
+	 */
+	kvm_supported |= XFEATURE_MASK_PT | XFEATURE_MASK_CET_USER |
+			 XFEATURE_MASK_CET_KERNEL;
+	if ((kvm_supported & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
+		goto err;
+
+	kvm_tdx_caps->supported_xfam = kvm_supported & td_conf->xfam_fixed0;
+
+	kvm_tdx_caps->num_cpuid_config = td_conf->num_cpuid_config;
+	for (i = 0; i < td_conf->num_cpuid_config; i++) {
+		struct kvm_tdx_cpuid_config source = {
+			.leaf = (u32)td_conf->cpuid_config_leaves[i],
+			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
+			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
+			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
+			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
+			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
+		};
+		struct kvm_tdx_cpuid_config *dest =
+			&kvm_tdx_caps->cpuid_configs[i];
+
+		memcpy(dest, &source, sizeof(struct kvm_tdx_cpuid_config));
+		if (dest->sub_leaf == KVM_TDX_CPUID_NO_SUBLEAF)
+			dest->sub_leaf = 0;
+	}
+
+	return 0;
+err:
+	kfree(kvm_tdx_caps);
+	return -EIO;
+}
+
+static void free_kvm_tdx_cap(void)
+{
+	kfree(kvm_tdx_caps);
+}
+
 static int tdx_online_cpu(unsigned int cpu)
 {
 	unsigned long flags;
@@ -217,11 +292,16 @@ static int __init __tdx_bringup(void)
 		goto get_sysinfo_err;
 	}
 
+	r = setup_kvm_tdx_caps();
+	if (r)
+		goto get_sysinfo_err;
+
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
 	 * successfully.  TDX CPU hotplug depends on this.
 	 */
 	return 0;
+
 get_sysinfo_err:
 	__do_tdx_cleanup();
 tdx_bringup_err:
@@ -232,6 +312,7 @@ static int __init __tdx_bringup(void)
 void tdx_cleanup(void)
 {
 	if (enable_tdx) {
+		free_kvm_tdx_cap();
 		__do_tdx_cleanup();
 		kvm_disable_virtualization();
 	}
-- 
2.34.1


