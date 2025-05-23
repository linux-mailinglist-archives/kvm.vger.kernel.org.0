Return-Path: <kvm+bounces-47553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9965DAC2058
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2E2487BAC0A
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9378C228CA3;
	Fri, 23 May 2025 09:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZXhL23M4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51B7242D9B;
	Fri, 23 May 2025 09:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994039; cv=none; b=Z7dWjIUHAoZ/BsqxNlqZCKbUG6NquysbrI+IqCTXLxKCknCGjuHzvP28TiRL3zPUk9NKKWJISKUlY8mQBQ3GV4yu/L+ahlyjHrj/eUSVIF5zmofowsrEOWibFC6vlbxHhzoPLK3Qxz2ozd8qHKn0buSO0OmGnbR8dpCtYUznBS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994039; c=relaxed/simple;
	bh=IeNltA/qaq4b+9CtIyLBU4ahh0Vwfgfh/OnoEQ8ozbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADepfRTwRfPqTxSxOFI9gH9mli/fU1OwJq8smhQvH7sBjCrE8DKgGSgwQLdjXxhZi6IYaN2LPCByXU79SwEoChN4NRg+B1SxrvCtUJwKGHZktkEf10OFKHwA8JQuabGHN/63tDb1gjntnZeCXjxlcMrw06eo/rx4G+1mlUCgbXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZXhL23M4; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994038; x=1779530038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IeNltA/qaq4b+9CtIyLBU4ahh0Vwfgfh/OnoEQ8ozbE=;
  b=ZXhL23M4jt1teQFtiLfI1eRa9TYg6I0mIqv5STczqmbFMTNn0vVIVILp
   67lHtC7kNJfGJC799rjeVrBmA45VejgPqfr/XQhrWiqfYaiK2KLE22goE
   /2qBLkfvE8MJ5jq2U6NDFQFOEcG7XhpxJxhPDOY2BFAbX2B425CL9o8SE
   gvE0YcYCA3mRN8ce1TVgj0l/pMHmfM6q4nVFFz28ZtRQYPIv+G/wsFLYN
   p/1hUuIxaPzwW+Y5iWnkz/A2RlodatD+MzxA8Zh4F2sbfMxSsomU3m5lS
   9WorycbWZwajVpwDyem0FLk/y2iVrlgXtoRHL9DMAFbfDzxDFjhvc1WbS
   w==;
X-CSE-ConnectionGUID: pI30BZlKTyG3v1ydgAfZ/Q==
X-CSE-MsgGUID: MN3Edbp/Rl2mwTLKTeDYbA==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444251"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444251"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:57 -0700
X-CSE-ConnectionGUID: qbH+nGkaRe6RYyIdM7Y3fQ==
X-CSE-MsgGUID: Mf96JNqmT+2uVx5yJeM35g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315094"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:57 -0700
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
Subject: [RFC PATCH 18/20] x86/virt/tdx: Update tdx_sysinfo and check features post-update
Date: Fri, 23 May 2025 02:52:41 -0700
Message-ID: <20250523095322.88774-19-chao.gao@intel.com>
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

tdx_sysinfo contains all metadata of the active TDX module, including
versions, supported features, and TDMR/TDCS/TDVPS information. These
elements may change over updates. Blindly refreshing the entire tdx_sysinfo
could disrupt running software, as it may subtly rely on the previous state
unless proven otherwise.

Adopt a conservative approach, like microcode updates, by only refreshing
version information that does not affect functionality, while ignoring
all other changes. This is acceptable as TD-Preserving-capable modules are
required to maintain backward compatibility.

Any updates to metadata beyond versions should be justified and reviewed on
a case-by-case basis.

Note that preallocating a tdx_sys_info buffer before updates is to avoid
having to handle -ENOMEM when updating tdx_sysinfo after a successful
update.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 13 ++++++++-
 arch/x86/virt/vmx/tdx/tdx.c     | 51 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h     |  1 +
 3 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 168fd2afd0c9..93385db56281 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -361,9 +361,16 @@ DEFINE_FREE(free_seamldr_params, struct seamldr_params *,
 
 static int seamldr_install_module(const u8 *data, u32 size)
 {
+	struct tdx_sys_info *info __free(kfree) = kzalloc(sizeof(*info),
+							  GFP_KERNEL);
+	int ret;
+
 	if (!td_preserving_ready)
 		return -EOPNOTSUPP;
 
+	if (!info)
+		return -ENOMEM;
+
 	struct seamldr_params *params __free(free_seamldr_params) =
 						init_seamldr_params(data, size);
 	if (IS_ERR(params))
@@ -371,7 +378,11 @@ static int seamldr_install_module(const u8 *data, u32 size)
 
 	atomic_set(&tdp_data.failed, 0);
 	set_state(TDP_START + 1);
-	return stop_machine(do_seamldr_install_module, params, cpu_online_mask);
+	ret = stop_machine(do_seamldr_install_module, params, cpu_online_mask);
+	if (ret)
+		return ret;
+
+	return tdx_module_post_update(info);
 }
 
 static enum fw_upload_err tdx_fw_prepare(struct fw_upload *fwl,
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5f678c9da4ee..55bdc99818a1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1406,6 +1406,57 @@ int tdx_module_run_update(void)
 	return ret;
 }
 
+/*
+ * Update tdx_sysinfo and check if any TDX module features changed after
+ * updates
+ */
+static void tdx_module_sysinfo_update_and_check(struct tdx_sys_info *info)
+{
+	struct tdx_sys_info_versions *old, *new;
+
+	guard(mutex)(&tdx_module_lock);
+
+	old = &tdx_sysinfo.versions;
+	new = &info->versions;
+	pr_info("version %d.%d.%d -> %d.%d.%d\n", old->major_version,
+						  old->minor_version,
+						  old->update_version,
+						  new->major_version,
+						  new->minor_version,
+						  new->update_version);
+
+	/*
+	 * Blindly refreshing the entire tdx_sysinfo could disrupt running
+	 * software, as it may subtly rely on the previous state unless
+	 * proven otherwise.
+	 *
+	 * Only refresh version information (including handoff version)
+	 * that does not affect functionality, and ignore all other
+	 * changes.
+	 */
+	tdx_sysinfo.versions	= info->versions;
+	tdx_sysinfo.handoff	= info->handoff;
+
+	if (!memcmp(&tdx_sysinfo, info, sizeof(*info)))
+		return;
+
+	pr_info("TDX module features have changed after updates, but might not take effect.\n");
+	pr_info("Please consider a potential BIOS update.\n");
+}
+
+int tdx_module_post_update(struct tdx_sys_info *info)
+{
+	int ret;
+
+	/* Shouldn't fail as the update has succeeded */
+	ret = get_tdx_sys_info(info);
+	if (WARN_ON_ONCE(ret))
+		return ret;
+
+	tdx_module_sysinfo_update_and_check(info);
+	return 0;
+}
+
 static bool is_pamt_page(unsigned long phys)
 {
 	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index a05e3c21e7f5..57ccceba5406 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -128,5 +128,6 @@ int seamldr_prerr(u64 fn, struct tdx_module_args *args);
 int tdx_module_shutdown(void);
 void tdx_module_set_error(void);
 int tdx_module_run_update(void);
+int tdx_module_post_update(struct tdx_sys_info *info);
 
 #endif
-- 
2.47.1


