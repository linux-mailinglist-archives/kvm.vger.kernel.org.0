Return-Path: <kvm+bounces-30094-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DEA59B6CA7
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:07:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D24B91F214C9
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9508022442B;
	Wed, 30 Oct 2024 19:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U9ZwbH0H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F2121A6F7;
	Wed, 30 Oct 2024 19:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314873; cv=none; b=Jxr0xIQdkzR3XHXOvp8K+qT58H0IYP11Jk3StoryDZl3Ifkn089ZxBf7g6h2CLduHx8Wb1/FJkAsmAFeeQt65HgqMCVJ29n9GLbKNp/ciuuNCyENLgoQ1FOWOBBYKNuzMwQwyG2aFHpvJob0xr6jk5xXhNqW1N1gce9O26RfvOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314873; c=relaxed/simple;
	bh=NVN/l0y1W8Q69PCUIhXwtLAbBTJp3BPF7W9IZxyskRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM3YrnWr93bu3RNRA0ofmAD6kMc2UyqVDpwMtvoS9zqbJWnnMAgEfqDR4tf89mWvUsPwKOhfBHMZEowh3LMAl0GKHbn2z42s8uq1GZ/gxRa7XpGqTamQ2EmjH2yftP9rsxz0z5tru85KiGsmLLj1sA2+2x4y5v1dQlknlSYTtOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U9ZwbH0H; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314871; x=1761850871;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NVN/l0y1W8Q69PCUIhXwtLAbBTJp3BPF7W9IZxyskRs=;
  b=U9ZwbH0HYGVTOazsEVwtry6Y7XcOj50gk6k1+WM680Shc4z5LuAlZA5z
   h4D5/6cXqqeJpw4ZHLCEBLUVW/zn1qDM9RdSN5JzZAxRcWLLP049qTYQX
   miPDk6vHNmhqgXdytIloNKKAB9zZ0TMPH3rjth+BzN9qRuyYL+eQvP7LR
   zy1ajSOJC2zWCCtrcf6hTWTSVfvG0HZFwRo4SGrRonlI61ofRgeT0Bg4j
   63+3UcSv+/OV5d/uRMDKXmAetmdl0hvjpQD30b8z5mP9U1pTss1E+xCE+
   0g4HPxIdjmwb/vX3WCAGE0180SivG7FgFPHV5xqZDb7kba7weJ/mTPFkG
   w==;
X-CSE-ConnectionGUID: U2WuM+7dQP+0AxVaV1yz+w==
X-CSE-MsgGUID: 1HS+nAOURqulNR5tHGPx5g==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678802"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678802"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:04 -0700
X-CSE-ConnectionGUID: kP2ChCDPQBeG5h8dz2bBQw==
X-CSE-MsgGUID: 5dloIss8TS+yjaN9BLjLTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499417"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:03 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>
Subject: [PATCH v2 16/25] KVM: TDX: Get system-wide info about TDX module on initialization
Date: Wed, 30 Oct 2024 12:00:29 -0700
Message-ID: <20241030190039.77971-17-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM needs system-wide information about the TDX module. Generate the
data based on tdx_sysinfo td_conf CPUID data.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
---
uAPI breakout v2:
 - Update stale patch description (Binbin)
 - Add KVM_TDX_CAPABILITIES where it's first used (Binbin)
 - Drop Drop unused KVM_TDX_CPUID_NO_SUBLEAF (Chao)
 - Drop mmu.h, it's only needed in later patches (Binbin)
 - Fold in Xiaoyao's capabilities changes (Tony)
 - Generate data without struct kvm_tdx_caps (Tony)
 - Use struct kvm_cpuid_entry2 as suggested (Binbin)
 - Use helpers for phys_addr_bits (Paolo)
 - Check TDX and KVM capabilities on _tdx_bringup() (Xiaoyao)
 - Change code around cpuid_config_value since
   struct tdx_cpuid_config_value {} is removed (Kai)

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
 arch/x86/include/uapi/asm/kvm.h |   9 +++
 arch/x86/kvm/vmx/tdx.c          | 137 ++++++++++++++++++++++++++++++++
 2 files changed, 146 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index b6cb87f2b477..0630530af334 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -928,6 +928,8 @@ struct kvm_hyperv_eventfd {
 
 /* Trust Domain eXtension sub-ioctl() commands. */
 enum kvm_tdx_cmd_id {
+	KVM_TDX_CAPABILITIES = 0,
+
 	KVM_TDX_CMD_NR_MAX,
 };
 
@@ -950,4 +952,11 @@ struct kvm_tdx_cmd {
 	__u64 hw_error;
 };
 
+struct kvm_tdx_capabilities {
+	__u64 supported_attrs;
+	__u64 supported_xfam;
+	__u64 reserved[254];
+	struct kvm_cpuid2 cpuid;
+};
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 76655d82f749..253debbe685f 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -30,6 +30,134 @@ static enum cpuhp_state tdx_cpuhp_state;
 
 static const struct tdx_sys_info *tdx_sysinfo;
 
+#define KVM_SUPPORTED_TD_ATTRS (TDX_TD_ATTR_SEPT_VE_DISABLE)
+
+static u64 tdx_get_supported_attrs(const struct tdx_sys_info_td_conf *td_conf)
+{
+	u64 val = KVM_SUPPORTED_TD_ATTRS;
+
+	if ((val & td_conf->attributes_fixed1) != td_conf->attributes_fixed1)
+		return 0;
+
+	val &= td_conf->attributes_fixed0;
+
+	return val;
+}
+
+static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
+{
+	u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
+
+	/*
+	 * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
+	 * and, CET support.
+	 */
+	val |= XFEATURE_MASK_PT | XFEATURE_MASK_CET_USER |
+	       XFEATURE_MASK_CET_KERNEL;
+
+	if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
+		return 0;
+
+	val &= td_conf->xfam_fixed0;
+
+	return val;
+}
+
+static u32 tdx_set_guest_phys_addr_bits(const u32 eax, int addr_bits)
+{
+	return (eax & ~GENMASK(23, 16)) | (addr_bits & 0xff) << 16;
+}
+
+#define KVM_TDX_CPUID_NO_SUBLEAF	((__u32)-1)
+
+static void td_init_cpuid_entry2(struct kvm_cpuid_entry2 *entry, unsigned char idx)
+{
+	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
+
+	entry->function = (u32)td_conf->cpuid_config_leaves[idx];
+	entry->index = td_conf->cpuid_config_leaves[idx] >> 32;
+	entry->eax = (u32)td_conf->cpuid_config_values[idx][0];
+	entry->ebx = td_conf->cpuid_config_values[idx][0] >> 32;
+	entry->ecx = (u32)td_conf->cpuid_config_values[idx][1];
+	entry->edx = td_conf->cpuid_config_values[idx][1] >> 32;
+
+	if (entry->index == KVM_TDX_CPUID_NO_SUBLEAF)
+		entry->index = 0;
+
+	/* Work around missing support on old TDX modules */
+	if (entry->function == 0x80000008)
+		entry->eax = tdx_set_guest_phys_addr_bits(entry->eax, 0xff);
+}
+
+static int init_kvm_tdx_caps(const struct tdx_sys_info_td_conf *td_conf,
+			     struct kvm_tdx_capabilities *caps)
+{
+	int i;
+
+	caps->supported_attrs = tdx_get_supported_attrs(td_conf);
+	if (!caps->supported_attrs)
+		return -EIO;
+
+	caps->supported_xfam = tdx_get_supported_xfam(td_conf);
+	if (!caps->supported_xfam)
+		return -EIO;
+
+	caps->cpuid.nent = td_conf->num_cpuid_config;
+
+	for (i = 0; i < td_conf->num_cpuid_config; i++)
+		td_init_cpuid_entry2(&caps->cpuid.entries[i], i);
+
+	return 0;
+}
+
+static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
+{
+	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
+	struct kvm_tdx_capabilities __user *user_caps;
+	struct kvm_tdx_capabilities *caps = NULL;
+	int ret = 0;
+
+	/* flags is reserved for future use */
+	if (cmd->flags)
+		return -EINVAL;
+
+	caps = kmalloc(sizeof(*caps) +
+		       sizeof(struct kvm_cpuid_entry2) * td_conf->num_cpuid_config,
+		       GFP_KERNEL);
+	if (!caps)
+		return -ENOMEM;
+
+	user_caps = u64_to_user_ptr(cmd->data);
+	if (copy_from_user(caps, user_caps, sizeof(*caps))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (caps->cpuid.nent < td_conf->num_cpuid_config) {
+		ret = -E2BIG;
+		goto out;
+	}
+
+	ret = init_kvm_tdx_caps(td_conf, caps);
+	if (ret)
+		goto out;
+
+	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (copy_to_user(user_caps->cpuid.entries, caps->cpuid.entries,
+			 caps->cpuid.nent *
+			 sizeof(caps->cpuid.entries[0])))
+		ret = -EFAULT;
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
@@ -48,6 +176,9 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 	mutex_lock(&kvm->lock);
 
 	switch (tdx_cmd.id) {
+	case KVM_TDX_CAPABILITIES:
+		r = tdx_get_capabilities(&tdx_cmd);
+		break;
 	default:
 		r = -EINVAL;
 		goto out;
@@ -147,11 +278,17 @@ static int __init __tdx_bringup(void)
 		goto get_sysinfo_err;
 	}
 
+	/* Check TDX module and KVM capabilities */
+	if (!tdx_get_supported_attrs(&tdx_sysinfo->td_conf) ||
+	    !tdx_get_supported_xfam(&tdx_sysinfo->td_conf))
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
-- 
2.47.0


