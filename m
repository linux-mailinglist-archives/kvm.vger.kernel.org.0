Return-Path: <kvm+bounces-47543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C591DAC2053
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:59:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C1C4F7B868B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29C7239E9B;
	Fri, 23 May 2025 09:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f0gmSpKF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAA2227581;
	Fri, 23 May 2025 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994031; cv=none; b=qEV5rpOCALLR8eX0gbrYuHKh/mQM40DLumZZuEiczxPt6RDbvqF9jFd0fmxyjBPd8aDLDMDXi03JYbiK3aRamH6EWURDw/W2LRB7TnXLQf7M3jR7U1C0bymse6q9GwXtFhP1YEoKPKmrFPajuRNevLIV7tgl1F7AI8dqQ5krifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994031; c=relaxed/simple;
	bh=pqs2fT0FExKmtK8ExkzV11HkOUb8WOY0k/NicrtCV3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdhFCfUfYK0aLFJ5sO2IzxOs4E3f8bQYEurLkj1Q/Ky0s6WOU3JyA3NMMq1KJvWowKGvIAUkt0h8tAW1PK3fykB/imdtD57+2ZSojjGIg4lEkaRKYN+oUn1R1lbl7zcBP0Z9zvyGmDZ7Q2uhi3GYxcDmUIsu0SusNqe4hjQOf5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f0gmSpKF; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994029; x=1779530029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pqs2fT0FExKmtK8ExkzV11HkOUb8WOY0k/NicrtCV3A=;
  b=f0gmSpKFYboUMvCa5JJ9O70T3nIiKqowpA80LTtLJ96tmINWLogkuthU
   szDcaaAJBXfvsKsMY1N2bslidCLUL+8Mi67ylAuY8Q5/ZC4u72/Ja/Hcv
   0HdJofwFHjxzZwNqXpkKyUT/mXjfmcUwCzcRiutY4Fzaig+XZNRaxRfgQ
   mTyPCG/atsMyu/HDu1b17mcE/qwlobFwLSw7pPJyOx2F5jDRVsl15awGY
   3OJDGs1RD79Chu+w3J2UcjlVPYtWXe/ilz3rnM0L2l8JCOOoLfKVTUZ9h
   bRyBS8R6ilj3sp9CjWqATUj3KQ5ijhAMNb3LUDJ6cNBdOD8XiYgiK8gon
   Q==;
X-CSE-ConnectionGUID: mFrt7oR4RyWC8/WLXUh+ZQ==
X-CSE-MsgGUID: N7Get2sIQxGpo+d11VwsgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444160"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444160"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:49 -0700
X-CSE-ConnectionGUID: 3n44T+BMTJGu4lMSXb3TpA==
X-CSE-MsgGUID: g1cW/pqGRRepyiH7XwWPRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315063"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:48 -0700
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
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 08/20] x86/virt/seamldr: Implement FW_UPLOAD sysfs ABI for TD-Preserving Updates
Date: Fri, 23 May 2025 02:52:31 -0700
Message-ID: <20250523095322.88774-9-chao.gao@intel.com>
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

Implement a fw_upload interface to coordinate TD-Preserving updates. The
explicit file selection capabilities of fw_upload is preferred over the
implicit file selection of request_firmware() for the following reasons:

a. Intel distributes all versions of the TDX module, allowing admins to
load any version rather than always defaulting to the latest. This
flexibility is necessary because future extensions may require reverting to
a previous version to clear fatal errors.

b. Some module version series are platform-specific. For example, the 1.5.x
series is for certain platform generations, while the 2.0.x series is
intended for others.

c. The update policy for TD-Preserving is non-linear at times. The latest
TDX module may not be TD-Preserving capable. For example, TDX module
1.5.x may be updated to 1.5.y but not to 1.5.y+1. This policy is documented
separately in a file released along with each TDX module release.

So, the default policy of "request_firmware()" of "always load latest", is
not suitable for TDX. Userspace needs to deploy a more sophisticated policy
check (i.e. latest may not be TD-Preserving capable), and there is
potential operator choice to consider.

Just have userspace pick rather than add kernel mechanism to change the
default policy of request_firmware().

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/Kconfig                |  2 +
 arch/x86/virt/vmx/tdx/seamldr.c | 77 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamldr.h |  2 +
 arch/x86/virt/vmx/tdx/tdx.c     |  4 ++
 4 files changed, 85 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8b1e0986b7f8..31385104a6ee 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1935,6 +1935,8 @@ config INTEL_TDX_HOST
 config INTEL_TDX_MODULE_UPDATE
 	bool "Intel TDX module runtime update"
 	depends on INTEL_TDX_HOST
+	select FW_LOADER
+	select FW_UPLOAD
 	help
 	  This enables the kernel to support TDX module runtime update. This allows
 	  the admin to upgrade the TDX module to a newer one without the need to
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index b628555daf55..da862e71ebce 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -8,6 +8,8 @@
 
 #include <linux/cleanup.h>
 #include <linux/device.h>
+#include <linux/firmware.h>
+#include <linux/gfp.h>
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 
@@ -32,6 +34,15 @@ struct seamldr_info {
 	u8	reserved1[224];
 } __packed;
 
+
+#define TDX_FW_STATE_BITS	32
+#define TDX_FW_CANCEL		0
+struct tdx_status {
+	DECLARE_BITMAP(fw_state, TDX_FW_STATE_BITS);
+};
+
+struct fw_upload *tdx_fwl;
+static struct tdx_status tdx_status;
 static struct seamldr_info seamldr_info __aligned(256);
 
 static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
@@ -101,3 +112,69 @@ int get_seamldr_info(void)
 
 	return seamldr_call(P_SEAMLDR_INFO, &args);
 }
+
+static int seamldr_install_module(const u8 *data, u32 size)
+{
+	return -EOPNOTSUPP;
+}
+
+static enum fw_upload_err tdx_fw_prepare(struct fw_upload *fwl,
+					 const u8 *data, u32 size)
+{
+	struct tdx_status *status = fwl->dd_handle;
+
+	if (test_and_clear_bit(TDX_FW_CANCEL, status->fw_state))
+		return FW_UPLOAD_ERR_CANCELED;
+
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static enum fw_upload_err tdx_fw_write(struct fw_upload *fwl, const u8 *data,
+				       u32 offset, u32 size, u32 *written)
+{
+	struct tdx_status *status = fwl->dd_handle;
+
+	if (test_and_clear_bit(TDX_FW_CANCEL, status->fw_state))
+		return FW_UPLOAD_ERR_CANCELED;
+
+	/*
+	 * No partial write will be returned to callers so @offset should
+	 * always be zero.
+	 */
+	WARN_ON_ONCE(offset);
+	if (seamldr_install_module(data, size))
+		return FW_UPLOAD_ERR_FW_INVALID;
+
+	*written = size;
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static enum fw_upload_err tdx_fw_poll_complete(struct fw_upload *fwl)
+{
+	return FW_UPLOAD_ERR_NONE;
+}
+
+static void tdx_fw_cancel(struct fw_upload *fwl)
+{
+	struct tdx_status *status = fwl->dd_handle;
+
+	set_bit(TDX_FW_CANCEL, status->fw_state);
+}
+
+static const struct fw_upload_ops tdx_fw_ops = {
+	.prepare = tdx_fw_prepare,
+	.write = tdx_fw_write,
+	.poll_complete = tdx_fw_poll_complete,
+	.cancel = tdx_fw_cancel,
+};
+
+void seamldr_init(struct device *dev)
+{
+	int ret;
+
+	tdx_fwl = firmware_upload_register(THIS_MODULE, dev, "seamldr_upload",
+					   &tdx_fw_ops, &tdx_status);
+	ret = PTR_ERR_OR_ZERO(tdx_fwl);
+	if (ret)
+		pr_err("failed to register module uploader %d\n", ret);
+}
diff --git a/arch/x86/virt/vmx/tdx/seamldr.h b/arch/x86/virt/vmx/tdx/seamldr.h
index 15597cb5036d..00fa3a4e9155 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.h
+++ b/arch/x86/virt/vmx/tdx/seamldr.h
@@ -6,9 +6,11 @@
 extern struct attribute_group seamldr_group;
 #define SEAMLDR_GROUP (&seamldr_group)
 int get_seamldr_info(void);
+void seamldr_init(struct device *dev);
 #else
 #define SEAMLDR_GROUP NULL
 static inline int get_seamldr_info(void) { return 0; }
+static inline void seamldr_init(struct device *dev) { }
 #endif
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index aa6a23d46494..22ffc15b4299 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1178,6 +1178,10 @@ static void tdx_subsys_init(void)
 		goto err_bus;
 	}
 
+	struct device *dev_root __free(put_device) = bus_get_dev_root(&tdx_subsys);
+	if (dev_root)
+		seamldr_init(dev_root);
+
 	return;
 
 err_bus:
-- 
2.47.1


