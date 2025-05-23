Return-Path: <kvm+bounces-47540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F0093AC203C
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:55:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49D6E1B6773E
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB11B22B8C8;
	Fri, 23 May 2025 09:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F+Wj8gfM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A87022A811;
	Fri, 23 May 2025 09:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994012; cv=none; b=kZQIw+4RQDgq9fZSXFC/LjuJs8edPeo0ZZz+sQ3HoBQT5lb1wrytGefkNR2mHLHiD9J/zAkDj3FZP0EDwY9k9baXD9YI0KL3LySRcrgEGBOgUStN41c7L6r4JjlUdz3M/h5c1xk2eBX8A4q84t50Kb0PsIlmXI17jHdnmULUGP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994012; c=relaxed/simple;
	bh=OibNJt1km/E8jMW2mZIujvgR8XYQKYqW9ezu6qz/Fms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmlbxDM6h58L0g4o3CY2eCD2l3aOEnM/QMyzSBXrvhJS6l4KgI8S7mwt+RLyssk2dKqCZEW5zeGjJ0UpwR8eCTyQaotbxttw4Kb0wQdN6F3F/Y8isPj3Aq7bKxcRAncERpw0bhyleEyYtzX+5YTojTqNKg9yPhhq6k8pg7E7jaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F+Wj8gfM; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994011; x=1779530011;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OibNJt1km/E8jMW2mZIujvgR8XYQKYqW9ezu6qz/Fms=;
  b=F+Wj8gfMfxF3dRVADwtOHinMpTMUen9X3NFWE0GjmDF8447xpv/j9BC2
   WKxUGOJbd+QN1Zi/fu5hqs5syymJELTcio3i0Dd66xOj5drsI5oW3yRBT
   yPgkM6USrkN/M6S6TD+GAojKXtBtzJzACKpa6QUoZyT/jkY9hBfbC+PSr
   LSePfFzAeOewiCfO7wTMoyVOFjj3opx+WkXGybOwWSO1Sq1ULx74Ry4Np
   flNLQCztYp7Rq1kqwy8SCjH61dnnA7/0APRgqbx6dq4x7MKkTnw3AsBWJ
   f08iGE4vwDdzXkqrJuJkId6+mMYohILMwyWDSGz7iEpnWtXvhwjuuy1nH
   w==;
X-CSE-ConnectionGUID: ZilhcLM+T4yNIANJXbXbJw==
X-CSE-MsgGUID: sC7fCO0gRR2YdLEGta2/3w==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444124"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444124"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:31 -0700
X-CSE-ConnectionGUID: LVwKt817Sh+O4MHA8NEgIA==
X-CSE-MsgGUID: VkEOvRNdTJiz7rIPsRTvJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315052"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:30 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 05/20] x86/virt/tdx: Export tdx module attributes via sysfs
Date: Fri, 23 May 2025 02:52:28 -0700
Message-ID: <20250523095322.88774-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TD-Preserving updates depend on a userspace tool to select the appropriate
module to load. To facilitate this decision-making process, expose the
necessary information to userspace.

Expose the current module versions so that userspace can verify
compatibility with new modules. version information is also valuable for
debugging, as knowing the exact module version can help reproduce
TDX-related issues.

Attach the TDX module attributes to the virtual TDX_TSM device, which
represents the TDX module and its features, such as TDX Connect.

Note changes to tdx_global_metadata.{hc} are auto-generated by following
the instructions detailed in [1], after modifying "version" to "versions"
in the TDX_STRUCT of tdx.py to accurately reflect that it is a collection
of versions.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://lore.kernel.org/kvm/20250226181453.2311849-12-pbonzini@redhat.com/ [1]
---
 Documentation/ABI/testing/sysfs-devices-tdx |  8 ++++++++
 MAINTAINERS                                 |  1 +
 arch/x86/include/asm/tdx_global_metadata.h  |  7 +++++++
 arch/x86/virt/vmx/tdx/tdx.c                 | 19 +++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 16 ++++++++++++++++
 5 files changed, 51 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-devices-tdx

diff --git a/Documentation/ABI/testing/sysfs-devices-tdx b/Documentation/ABI/testing/sysfs-devices-tdx
new file mode 100644
index 000000000000..ccbe6431241e
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-devices-tdx
@@ -0,0 +1,8 @@
+What:		/sys/devices/virtual/tdx/tdx_tsm/version
+Date:		March 2025
+KernelVersion:	v6.15
+Contact:	linux-coco@lists.linux.dev
+Description:	(RO) Report the version of the loaded TDX module. The TDX module
+		version is formatted as x.y.z, where "x" is the major version,
+		"y" is the minor version and "z" is the update version. Versions
+		are used for bug reporting, TD-Preserving updates and etc.
diff --git a/MAINTAINERS b/MAINTAINERS
index c59316109e3f..0d58256c765b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26227,6 +26227,7 @@ L:	x86@kernel.org
 L:	linux-coco@lists.linux.dev
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/tdx
+F:	Documentation/ABI/testing/sysfs-devices-tdx
 F:	arch/x86/boot/compressed/tdx*
 F:	arch/x86/coco/tdx/
 F:	arch/x86/include/asm/shared/tdx.h
diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 060a2ad744bf..ce0370f4a5b9 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -5,6 +5,12 @@
 
 #include <linux/types.h>
 
+struct tdx_sys_info_versions {
+	u16 minor_version;
+	u16 major_version;
+	u16 update_version;
+};
+
 struct tdx_sys_info_features {
 	u64 tdx_features0;
 };
@@ -35,6 +41,7 @@ struct tdx_sys_info_td_conf {
 };
 
 struct tdx_sys_info {
+	struct tdx_sys_info_versions versions;
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9719df2f2634..5f1f463ddfe1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1090,6 +1090,24 @@ struct tdx_tsm {
 	struct device dev;
 };
 
+static ssize_t version_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	const struct tdx_sys_info_versions *v = &tdx_sysinfo.versions;
+
+	return sysfs_emit(buf, "%u.%u.%u\n", v->major_version,
+					     v->minor_version,
+					     v->update_version);
+}
+
+static DEVICE_ATTR_RO(version);
+
+static struct attribute *tdx_module_attrs[] = {
+	&dev_attr_version.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(tdx_module);
+
 static struct tdx_tsm *alloc_tdx_tsm(void)
 {
 	struct tdx_tsm *tsm = kzalloc(sizeof(*tsm), GFP_KERNEL);
@@ -1117,6 +1135,7 @@ static struct tdx_tsm *init_tdx_tsm(void)
 		return tsm;
 
 	dev = &tsm->dev;
+	dev->groups = tdx_module_groups;
 	ret = dev_set_name(dev, "tdx_tsm");
 	if (ret)
 		return ERR_PTR(ret);
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 13ad2663488b..088e5bff4025 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -7,6 +7,21 @@
  * Include this file to other C file instead.
  */
 
+static int get_tdx_sys_info_versions(struct tdx_sys_info_versions *sysinfo_versions)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000003, &val)))
+		sysinfo_versions->minor_version = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000004, &val)))
+		sysinfo_versions->major_version = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x0800000100000005, &val)))
+		sysinfo_versions->update_version = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info_features(struct tdx_sys_info_features *sysinfo_features)
 {
 	int ret = 0;
@@ -89,6 +104,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
 
+	ret = ret ?: get_tdx_sys_info_versions(&sysinfo->versions);
 	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
-- 
2.47.1


