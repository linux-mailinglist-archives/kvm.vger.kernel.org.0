Return-Path: <kvm+bounces-30082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F067A9B6C91
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:03:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DAA21C2123E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 387F021790F;
	Wed, 30 Oct 2024 19:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AwVRXfiF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702FA213EE0;
	Wed, 30 Oct 2024 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314862; cv=none; b=DaVW+HpMC6TUU4l1EeY4hkCcM+SH8cQ5hcz1lSBi7QnKWXTqy3QcdAimyjorN0Xkhkx54D6nf0L4wnpp+KTfuse8UzNkwPWd3nQ+dwuYv5czMrSKo4CrDUYIZwIl2au+Ltctuh4tErg10vC1tDyDh1tduvJWoSXSa35CQq5KSTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314862; c=relaxed/simple;
	bh=r4DqlT6kr0U8khXg231vkLTSX6v5nFIoCA9SrxE9kFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p77VfcHYwQ6VV2ElIeuzP70aWatWARUrZ76IIQu9HijKtr118eLt4PsbC984TENkp80Yc7MPQ4XYlYV+mmA5DDWeGUv7xBN9XCXQr+FDdMYjY7MSaIp0pna3VGdBTvA/NqsWV1Eml3O6ZM66JCd550OlxRMxyVMn248gxQ/Y9ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AwVRXfiF; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314859; x=1761850859;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r4DqlT6kr0U8khXg231vkLTSX6v5nFIoCA9SrxE9kFg=;
  b=AwVRXfiFV6hX3m+3LF7zJnNfLWGfTON9ltYPpnxP88tguxjy5P+9HSDi
   7zZe99t4FxLIZraVi/zEhSXufX/zzaWuY1uhm1M6rly/s28TjPoHmJTna
   s96wmtrJLB3Pay0UCP0McsaMWqym24J89Uz3Bd5C2gJwAyVfMFPnjjlY6
   OowYy2xnl7nX/1ZcoGK2WlK9NkR0osoJM5qkx+gmR5sZY1PEM/onC5zIj
   U8H7nbRJ79/T5DToeqGsgodnqVQZdBoB3ReBupxThakaR+0zEMSYbT+Js
   KIxESzzUYNVZYp8tIYY3acnOMFE1qcrtNclvWtbllgU+JGnAw+0pdWuJT
   w==;
X-CSE-ConnectionGUID: vZbp1NL6TqywD4gW2QtCoQ==
X-CSE-MsgGUID: pf0hGTkDTrGEXGusvPHLkA==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678724"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678724"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:56 -0700
X-CSE-ConnectionGUID: PlJXjUXCTtiMXcl0KHZs0Q==
X-CSE-MsgGUID: I/VwUYewReu05n+gluy0sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499327"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:56 -0700
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
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v2 04/25] x86/virt/tdx: Add tdx_guest_keyid_alloc/free() to alloc and free TDX guest KeyID
Date: Wed, 30 Oct 2024 12:00:17 -0700
Message-ID: <20241030190039.77971-5-rick.p.edgecombe@intel.com>
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

Intel TDX protects guest VMs from malicious host and certain physical
attacks. Pre-TDX Intel hardware has support for a memory encryption
architecture called MK-TME, which repurposes several high bits of
physical address as "KeyID". The BIOS reserves a sub-range of MK-TME
KeyIDs as "TDX private KeyIDs".

Each TDX guest must be assigned with a unique TDX KeyID when it is
created. The kernel reserves the first TDX private KeyID for
crypto-protection of specific TDX module data which has a lifecycle that
exceeds the KeyID reserved for the TD's use. The rest of the KeyIDs are
left for TDX guests to use.

Create a small KeyID allocator. Export
tdx_guest_keyid_alloc()/tdx_guest_keyid_free() to allocate and free TDX
guest KeyID for KVM to use.

Don't provide the stub functions when CONFIG_INTEL_TDX_HOST=n since they
are not supposed to be called in this case.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - Move code from KVM to x86 core, and export them.
 - Update log.

uAPI breakout v1:
 - Update the commit message
 - Delete stale comment on global hkdi
 - Deleted WARN_ON_ONCE() as it doesn't seemed very usefull

v19:
 - Removed stale comment in tdx_guest_keyid_alloc() by Binbin
 - Update sanity check in tdx_guest_keyid_free() by Binbin

v18:
 - Moved the functions to kvm tdx from arch/x86/virt/vmx/tdx/
 - Drop exporting symbols as the host tdx does.
---
 arch/x86/include/asm/tdx.h  |  3 +++
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index b9758369d82c..d33e46d53d59 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -118,6 +118,9 @@ int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
+
+int tdx_guest_keyid_alloc(void);
+void tdx_guest_keyid_free(unsigned int keyid);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 7589c75eaa6c..b883c1a4b002 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -27,6 +27,7 @@
 #include <linux/log2.h>
 #include <linux/acpi.h>
 #include <linux/suspend.h>
+#include <linux/idr.h>
 #include <asm/page.h>
 #include <asm/special_insns.h>
 #include <asm/msr-index.h>
@@ -42,6 +43,8 @@ static u32 tdx_global_keyid __ro_after_init;
 static u32 tdx_guest_keyid_start __ro_after_init;
 static u32 tdx_nr_guest_keyids __ro_after_init;
 
+static DEFINE_IDA(tdx_guest_keyid_pool);
+
 static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
 static struct tdmr_info_list tdx_tdmr_list;
@@ -1545,3 +1548,17 @@ const struct tdx_sys_info *tdx_get_sysinfo(void)
 	return p;
 }
 EXPORT_SYMBOL_GPL(tdx_get_sysinfo);
+
+int tdx_guest_keyid_alloc(void)
+{
+	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
+			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
+			       GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
+
+void tdx_guest_keyid_free(unsigned int keyid)
+{
+	ida_free(&tdx_guest_keyid_pool, keyid);
+}
+EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
-- 
2.47.0


