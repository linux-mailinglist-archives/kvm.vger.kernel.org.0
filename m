Return-Path: <kvm+bounces-68983-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLBNHpGNc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68983-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:02:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 17D27776C2
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:02:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 818BD300B18B
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24FCA34DCE0;
	Fri, 23 Jan 2026 15:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="do6/lEXu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D7933C50E;
	Fri, 23 Jan 2026 15:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180425; cv=none; b=tXPSIZU/kHKFQ/NZ57qE+JNMbkPa4z7YC/D8CQB2JGzcLrDylkD360Q0qZgTzrY+PBa1qfU+Idx0DXGAy3lswPVl+gZOzAEQQfxJeiLGJKOiC32XY/RSsejSRulGZJteFHXfsBZpg+wlger6iVSIi8Jfe6yR4++VPrQNOVD2LBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180425; c=relaxed/simple;
	bh=5q4zqWajw/8RUodFT+CwqmTk6wtdoZ/kJ+GQJqa5ufU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyE58XjNAbwdpbQGhbx78V8AJFy00uhleQ0cdMyGMaGQ6oFc9Gf+eOxeIRDPg/DidNIYivZMhaw3jYhDzZoFScU4Lm0K8PshJ6fymkTrSSFYzzknyvO5gUYroRY1j8c5REZmPTLMObxQQ4Too6BixjvWG4aaFBdfVe+QopBT1YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=do6/lEXu; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180421; x=1800716421;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5q4zqWajw/8RUodFT+CwqmTk6wtdoZ/kJ+GQJqa5ufU=;
  b=do6/lEXuqdHN3xuiLeXvxy2yOaP+KE4m5hsHiek1UWhJA/CTOqexwttU
   3gNkzvOfUJKX2PSV1TbVonniSG59jmIvF3aX2RJCqxGvTxfP2wNslL6vw
   cPqVMCVVPqtDI/XxdgcFAlOHa7L5nW3K/FQi6PgB4sc5kDtoNkb/GZBzz
   yhxRDS0vHSKvZYbI7QVruCSiIKwiX+nCrrLlIObG8Huoye6148Iav3/2P
   vhKxlXTRjhsd0RhA7VwTcxrseC7FFHfLBFbNtAlz8OsdnWVW0bN/lwl61
   ypJDM5XZV7j25dTENyedlisVpc5znoW56Uq9Fj9hOohM4kdhjHDzp+HmI
   A==;
X-CSE-ConnectionGUID: e+dp7VzGQdCsJBizYz7bOQ==
X-CSE-MsgGUID: 9Gmy41/PSauL3FYWZ9wsKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334390"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334390"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:12 -0800
X-CSE-ConnectionGUID: v1yJjE8FR869Sza7hB3BRg==
X-CSE-MsgGUID: 7Ue34iN0Tw6r5nEkThgzlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697104"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:12 -0800
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org
Cc: reinette.chatre@intel.com,
	ira.weiny@intel.com,
	kai.huang@intel.com,
	dan.j.williams@intel.com,
	yilun.xu@linux.intel.com,
	sagis@google.com,
	vannapurve@google.com,
	paulmck@kernel.org,
	nik.borisov@suse.com,
	zhenzhong.duan@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	kas@kernel.org,
	dave.hansen@linux.intel.com,
	vishal.l.verma@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3 08/26] x86/virt/seamldr: Retrieve P-SEAMLDR information
Date: Fri, 23 Jan 2026 06:55:16 -0800
Message-ID: <20260123145645.90444-9-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260123145645.90444-1-chao.gao@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68983-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 17D27776C2
X-Rspamd-Action: no action

P-SEAMLDR returns its information e.g., version and supported features, in
response to the SEAMLDR.INFO SEAMCALL.

This information is useful for userspace. For example, the admin can decide
which TDX module versions are compatible with the P-SEAMLDR according to
the P-SEAMLDR version.

Add and export seamldr_get_info() which retrieves P-SEAMLDR information by
invoking SEAMLDR.INFO SEAMCALL in preparation for exposing P-SEAMLDR
version and other necessary information to userspace.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/include/asm/seamldr.h  | 27 +++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamldr.c | 17 ++++++++++++++++-
 2 files changed, 43 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/seamldr.h

diff --git a/arch/x86/include/asm/seamldr.h b/arch/x86/include/asm/seamldr.h
new file mode 100644
index 000000000000..d1e9f6e16e8d
--- /dev/null
+++ b/arch/x86/include/asm/seamldr.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_SEAMLDR_H
+#define _ASM_X86_SEAMLDR_H
+
+#include <linux/types.h>
+
+struct seamldr_info {
+	u32	version;
+	u32	attributes;
+	u32	vendor_id;
+	u32	build_date;
+	u16	build_num;
+	u16	minor_version;
+	u16	major_version;
+	u16	update_version;
+	u8	reserved0[4];
+	u32	num_remaining_updates;
+	u8	reserved1[224];
+} __packed;
+
+#ifdef CONFIG_INTEL_TDX_MODULE_UPDATE
+const struct seamldr_info *seamldr_get_info(void);
+#else
+static inline const struct seamldr_info *seamldr_get_info(void) { return NULL; }
+#endif
+
+#endif
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index b99d73f7bb08..6a83ae405fac 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -9,9 +9,16 @@
 #include <linux/irqflags.h>
 #include <linux/types.h>
 
+#include <asm/seamldr.h>
+
 #include "seamcall.h"
 
-static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
+/* P-SEAMLDR SEAMCALL leaf function */
+#define P_SEAMLDR_INFO			0x8000000000000000
+
+static struct seamldr_info seamldr_info __aligned(256);
+
+static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
 {
 	unsigned long flags;
 	u64 vmcs;
@@ -54,3 +61,11 @@ static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
 	WARN_ONCE(1, "Failed to save/restore the current VMCS");
 	return -EIO;
 }
+
+const struct seamldr_info *seamldr_get_info(void)
+{
+	struct tdx_module_args args = { .rcx = __pa(&seamldr_info) };
+
+	return seamldr_call(P_SEAMLDR_INFO, &args) ? NULL : &seamldr_info;
+}
+EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
-- 
2.47.3


