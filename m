Return-Path: <kvm+bounces-9658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83A36866C84
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:38:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A6DDF1C21085
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 622F05B5B8;
	Mon, 26 Feb 2024 08:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PhExB/FN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2648358AD6;
	Mon, 26 Feb 2024 08:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936083; cv=none; b=ADl7j/XI4HIG/rXcG87UHUPSwJfmhbu4Dv5Yh6Vb4/hs9hmJSFLvd59Skai3dUwXIkazZQc4PAcg71JxlQaU/VwbhiAbrG958XOVlLhYoAuducPoVOFM5nXkIgkJBp3SH0XmYowxFIEY5zl1hSSf571lUTv0kAiAubOzoaIlhmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936083; c=relaxed/simple;
	bh=K69f0zNuV/UzQ9kbwGm3AyR8yiZyeyS3gj6Lw7kZQdg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qv+yZ/DhCi/unAL6B8ZLmX6h6SIZX57vIcXgLK2B+RqBAF/QuZX7gliJ+sa0vkXWuINGi2FdtFK/N8w2lt0+ahBNc101UsSyGIQiAfyV95oQjeTa2AeLJg/tZ1iNUV/DxblV+JPPe0cpOvN1BQOpT4wn5742FnZTmoAZZNtca8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PhExB/FN; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936081; x=1740472081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K69f0zNuV/UzQ9kbwGm3AyR8yiZyeyS3gj6Lw7kZQdg=;
  b=PhExB/FN9Mbs5mJnYZEQ351zxzrc/UjJSQKhCo2v//8jRsokNIwnT+jS
   UqkgPKqI1oV8yDFYf0J5G4+tDiNfA8ajlDEE1oUaZ3HGWAyByvoZjl3zo
   feWdtTZTRslyC7DgdFCxuU4BNrwHuxBB5/MRVbMx1H4letvInF/fuiIxF
   TJjQIExyPltW+vxNlOYQhjwQP6AnNDDcT/7NZTd8BCHb6nkjNFHzR2F74
   J8pGjXSoEcn/uZWHWuSgrLweaNqjWdPjx3pDpGfeLb/HrCGu4F2FPmRDj
   lW8KGG5YofQSMzNFYunOQLfLtFtp9bno7clhiIbzzfT6gSnwy6gRYFjDE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="6155292"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6155292"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6615583"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:59 -0800
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
Subject: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX module on initialization
Date: Mon, 26 Feb 2024 00:25:36 -0800
Message-Id: <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM needs system-wide information about the TDX module, store it in
struct tdx_info.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
v19:
- Added features0
- Use tdx_sys_metadata_read()
- Fix error recovery path by Yuan

Change v18:
- Newly Added

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/uapi/asm/kvm.h | 11 +++++
 arch/x86/kvm/vmx/main.c         |  9 +++-
 arch/x86/kvm/vmx/tdx.c          | 80 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx/x86_ops.h      |  2 +
 4 files changed, 100 insertions(+), 2 deletions(-)

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
index fa19682b366c..a948a6959ac7 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -32,6 +32,13 @@ static __init int vt_hardware_setup(void)
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
@@ -54,7 +61,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.check_processor_compatibility = vmx_check_processor_compat,
 
-	.hardware_unsetup = vmx_hardware_unsetup,
+	.hardware_unsetup = vt_hardware_unsetup,
 
 	/* TDX cpu enablement is done by tdx_hardware_setup(). */
 	.hardware_enable = vmx_hardware_enable,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dce21f675155..5edfb99abb89 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -40,6 +40,21 @@ static void __used tdx_guest_keyid_free(int keyid)
 	ida_free(&tdx_guest_keyid_pool, keyid);
 }
 
+struct tdx_info {
+	u64 features0;
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
 #define TDX_MD_MAP(_fid, _ptr)			\
 	{ .fid = MD_FIELD_ID_##_fid,		\
 	  .ptr = (_ptr), }
@@ -66,7 +81,7 @@ static size_t tdx_md_element_size(u64 fid)
 	}
 }
 
-static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
+static int tdx_md_read(struct tdx_md_map *maps, int nr_maps)
 {
 	struct tdx_md_map *m;
 	int ret, i;
@@ -84,9 +99,26 @@ static int __used tdx_md_read(struct tdx_md_map *maps, int nr_maps)
 	return 0;
 }
 
+#define TDX_INFO_MAP(_field_id, _member)			\
+	TD_SYSINFO_MAP(_field_id, struct tdx_info, _member)
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
+	struct tdx_metadata_field_mapping fields[] = {
+		TDX_INFO_MAP(FEATURES0, features0),
+		TDX_INFO_MAP(ATTRS_FIXED0, attributes_fixed0),
+		TDX_INFO_MAP(ATTRS_FIXED1, attributes_fixed1),
+		TDX_INFO_MAP(XFAM_FIXED0, xfam_fixed0),
+		TDX_INFO_MAP(XFAM_FIXED1, xfam_fixed1),
+	};
 
 	ret = tdx_enable();
 	if (ret) {
@@ -94,7 +126,48 @@ static int __init tdx_module_setup(void)
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
+	ret = tdx_sys_metadata_read(fields, ARRAY_SIZE(fields), tdx_info);
+	if (ret)
+		goto error_out;
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
+			goto error_out;
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
+error_out:
+	/* kfree() accepts NULL. */
+	kfree(tdx_info);
+	return ret;
 }
 
 bool tdx_is_vm_type_supported(unsigned long type)
@@ -162,3 +235,8 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 out:
 	return r;
 }
+
+void tdx_hardware_unsetup(void)
+{
+	kfree(tdx_info);
+}
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f4da88a228d0..e8cb4ae81cf1 100644
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


