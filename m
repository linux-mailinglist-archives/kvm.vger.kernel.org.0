Return-Path: <kvm+bounces-6593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AA9083794A
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:35:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D84F31F27F04
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0134159B56;
	Mon, 22 Jan 2024 23:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gRx6JLWq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463C758129;
	Mon, 22 Jan 2024 23:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967710; cv=none; b=VH72zmwRIFysbOdeJI0/OgKnqD97Aqb7N+dZL20kSBzKgNmpG34TTLyDQUH/qleEP/fdt9gwl1jfUeqDUYz8O5Wt4C24tLVKkTC2/2iVJsckaA+9ckEXEgcW/y3oT6zWp/ZeRKjww36DG8xWWd6IpfoQ7vWesxP28tXtF3EjCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967710; c=relaxed/simple;
	bh=1oYWjOZIrk0U3bgww2CB7zkQIPLu2lCv3No03Am3Apc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UfvMmu3+8gvBH/sJxzBrPykQ3F6u/Zr+KTebDMPAHZpJe6qIJ7iMIVzkae4mxdGdLrN1ydEZHxBwqpemwE/lp+kGQgYDsZhx8SFUdqn1U+ckKG7WmY6JON+ff07yr4Au7MasKJ1SmQyqHkpyG+955enCAywxqR2Jrc1s1im7N58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gRx6JLWq; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967708; x=1737503708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1oYWjOZIrk0U3bgww2CB7zkQIPLu2lCv3No03Am3Apc=;
  b=gRx6JLWq+P7cv2w+S893ZMGCJpu2jQISOjBxtV6nDiMezgwgaLUHstz3
   96Vo+v1f4bAC2O1KV+bCxmxKXm3tbqA3l0X912uaPUweLU3YTiNYtGlZj
   80yoz5mxEmX96vNbHyW/2zcF1Qj/e45djEzV3vW34Ago0U4XBCEaKabHn
   SG3tdXyejUpVl0Yj6yVJsXUV9soGQec5araIgI1QLgWjbDbbKBBIppnZW
   hj8K4Be9qoHwiTY5CrYHLfS5LfahtrHFhuoiZBsunA2fcia8WHE3S5vFD
   2wzrv8lEg7qfinHar4vRARbiLc6Xg2safL1H3rh5TRgIPJ5jQhRmmFao8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1243782"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1243782"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="819888478"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="819888478"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:06 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v18 020/121] x86/virt/tdx: Get system-wide info about TDX module on initialization
Date: Mon, 22 Jan 2024 15:52:56 -0800
Message-Id: <d82142369de93661bdb57b8819a409694cede56e.1705965634.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM needs system-wide information about the TDX module, store it in
struct tdx_info.

TODO: Once TDX host patch series introduces a framework to read TDX meta
data, convert the code to it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Change v18:
- Newly Added
---
 arch/x86/include/uapi/asm/kvm.h | 11 +++++
 arch/x86/kvm/vmx/main.c         |  9 +++-
 arch/x86/kvm/vmx/tdx.c          | 79 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h      |  2 +
 4 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index aa7a56a47564..45b2c2304491 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -567,4 +567,15 @@ struct kvm_pmu_event_filter {
 #define KVM_X86_TDX_VM		2
 #define KVM_X86_SNP_VM		3
 
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
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 62236bde3779..f181620b2922 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -47,6 +47,13 @@ static __init int vt_hardware_setup(void)
 	return 0;
 }
 
+static void vt_hardware_unsetup(void)
+{
+	if (enable_tdx)
+		tdx_hardware_unsetup();
+	vmx_hardware_unsetup();
+}
+
 static int vt_vm_init(struct kvm *kvm)
 {
 	if (is_td(kvm))
@@ -69,7 +76,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.check_processor_compatibility = vmx_check_processor_compat,
 
-	.hardware_unsetup = vmx_hardware_unsetup,
+	.hardware_unsetup = vt_hardware_unsetup,
 
 	.hardware_enable = vt_hardware_enable,
 	.hardware_disable = vmx_hardware_disable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1608bdf2381d..55399136b680 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -67,7 +67,7 @@ static size_t tdx_md_element_size(u64 fid)
 	}
 }
 
-int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
+static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
 {
 	struct tdx_md_map *m;
 	int ret, i;
@@ -85,9 +85,39 @@ int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
 	return 0;
 }
 
+struct tdx_info {
+	u64 attributes_fixed0;
+	u64 attributes_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+
+	u16 num_cpuid_config;
+	/* This must the last member. */
+	DECLARE_FLEX_ARRAY(struct kvm_tdx_cpuid_config, cpuid_configs);
+};
+
+/* Info about the TDX module. */
+static struct tdx_info *tdx_info;
+
 static int __init tdx_module_setup(void)
 {
+	u16 num_cpuid_config;
 	int ret;
+	u32 i;
+
+	struct tdx_md_map mds[] = {
+		TDX_MD_MAP(NUM_CPUID_CONFIG, &num_cpuid_config),
+	};
+
+#define TDX_INFO_MAP(_field_id, _member)			\
+	TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
+
+	struct tdx_metadata_field_mapping tdx_info_md[] = {
+		TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
+		TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
+		TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
+		TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
+	};
 
 	ret = tdx_enable();
 	if (ret) {
@@ -95,7 +125,49 @@ static int __init tdx_module_setup(void)
 		return ret;
 	}
 
+	ret = tdx_md_read(mds, ARRAY_SIZE(mds));
+	if (ret)
+		return ret;
+
+	tdx_info = kzalloc(sizeof(*tdx_info) +
+			   sizeof(*tdx_info->cpuid_configs) * num_cpuid_config,
+			   GFP_KERNEL);
+	if (!tdx_info)
+		return -ENOMEM;
+	tdx_info->num_cpuid_config = num_cpuid_config;
+
+	ret = tdx_sys_metadata_read(tdx_info_md, ARRAY_SIZE(tdx_info_md), tdx_info);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < num_cpuid_config; i++) {
+		struct kvm_tdx_cpuid_config *c = &tdx_info->cpuid_configs[i];
+		u64 leaf, eax_ebx, ecx_edx;
+		struct tdx_md_map cpuids[] = {
+			TDX_MD_MAP(CPUID_CONFIG_LEAVES + i, &leaf),
+			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2, &eax_ebx),
+			TDX_MD_MAP(CPUID_CONFIG_VALUES + i * 2 + 1, &ecx_edx),
+		};
+
+		ret = tdx_md_read(cpuids, ARRAY_SIZE(cpuids));
+		if (ret)
+			goto error_sys_rd;
+
+		c->leaf = (u32)leaf;
+		c->sub_leaf = leaf >> 32;
+		c->eax = (u32)eax_ebx;
+		c->ebx = eax_ebx >> 32;
+		c->ecx = (u32)ecx_edx;
+		c->edx = ecx_edx >> 32;
+	}
+
 	return 0;
+
+error_sys_rd:
+	ret = -EIO;
+	/* kfree() accepts NULL. */
+	kfree(tdx_info);
+	return ret;
 }
 
 bool tdx_is_vm_type_supported(unsigned long type)
@@ -163,3 +235,8 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 out:
 	return r;
 }
+
+void tdx_hardware_unsetup(void)
+{
+	kfree(tdx_info);
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 5da7a5fd91cb..9523087ae355 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -136,9 +136,11 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_INTEL_TDX_HOST
 int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
+void tdx_hardware_unsetup(void);
 bool tdx_is_vm_type_supported(unsigned long type);
 #else
 static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -EOPNOTSUPP; }
+static inline void tdx_hardware_unsetup(void) {}
 static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
 #endif
 
-- 
2.25.1


