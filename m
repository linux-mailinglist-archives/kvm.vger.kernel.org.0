Return-Path: <kvm+bounces-70984-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6N8bJiLnjWkm8gAAu9opvQ
	(envelope-from <kvm+bounces-70984-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:43:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3719912E615
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58075315496E
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC1735E545;
	Thu, 12 Feb 2026 14:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AObWr+cT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F0E364046;
	Thu, 12 Feb 2026 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906994; cv=none; b=raLLOeXkA1wBxnQrn/2FFrqDn6k8a3MfRAwigoXZyjPiFo5MctfKAuXba2FsRdFniATibH837Vb5xBLx3Y7G9aoed+EuLakGivvgx6LrsiAL/XsPXXxqW626Bq6Ctb/xauy0h8gkkqUt0azgJ0g6rwr76+wfMa2ninjH2UmureM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906994; c=relaxed/simple;
	bh=nHExH+UGA5YmGiZC8pd4BRYz6CGQhCuCe20y1z7bhrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2Mt7iKvAr3Qpw9edB8iiiW1aAZM2qMdjmcuzW1+6/NzlEl7aJflswbJLJNOwYwoDWV4uyvAgtCEiJfuQ4bqtpLEwV6kVZ+v9ruNNTBnwrJYMeqen+GA3wYEBKv7F/xHU6c+XWv/VnLXpCm2Aq7eFTAEPgcyhhP71fGFnATOugA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AObWr+cT; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906991; x=1802442991;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nHExH+UGA5YmGiZC8pd4BRYz6CGQhCuCe20y1z7bhrk=;
  b=AObWr+cT85K84evDDf55dkIZVPyL+Q2cxfpHPUtVqV4OjvHRstrSEk/b
   78lHPFlvgPXa/HCVYTK7QVoQ+rMH7dy4oEQUJKioh7vp1EnWIZXehDc1g
   hah5RAAPnniGzEEsxyKJ7S/sy5uvLyeQ1qJEbIaS4CJda1hmzo/dDTBkR
   OMA7NZI/Uj7DpNV8d+9M6pCpqQvm5yLEn6kQ6hxg3m5nibiaChMsJBjS5
   zI2v9IHwCyc6Od7O3Pw0ekxkEHqGzy+RawXVphmXrX8NwV1H5gNvCfwDC
   admc/vI+JyQ2uYqakknL+pJ7Dq7IdQNXFxLm538Z767XqPr7r2tUAnBPZ
   g==;
X-CSE-ConnectionGUID: AtZN0I/DQjmviurIxZ605g==
X-CSE-MsgGUID: 69obfHWHSZed44s8Zyy3nQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662915"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662915"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:30 -0800
X-CSE-ConnectionGUID: wcEqH8BOQLWyL88Q01EGzg==
X-CSE-MsgGUID: rfyVF6JIQ7qNz/IPe41Rng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428302"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:30 -0800
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
	binbin.wu@linux.intel.com,
	tony.lindgren@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v4 21/24] x86/virt/tdx: Avoid updates during update-sensitive operations
Date: Thu, 12 Feb 2026 06:35:24 -0800
Message-ID: <20260212143606.534586-22-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70984-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 3719912E615
X-Rspamd-Action: no action

TDX Module updates may cause TD management operations to fail if they
occur during phases of the TD lifecycle that are sensitive to update
compatibility.

Currently, there are two update-sensitive scenarios:
 - TD build, where TD Measurement Register (TDMR) accumulates over multiple
   TDH.MEM.PAGE.ADD, TDH.MR.EXTEND and TDH.MR.FINALIZE calls.

 - TD migration, where an intermediate crypto state is saved if a state
   migration function (TDH.EXPORT.STATE.* or TDH.IMPORT.STATE.*) is
   interrupted and restored when the function is resumed.

For example, if an update races with TD build operations, the TD
Measurement Register will become incorrect, causing the TD to fail
attestation.

The TDX Module offers two solutions:

1. Avoid updates during update-sensitive times

   The host VMM can instruct TDH.SYS.SHUTDOWN to fail if any of the TDs
   are currently in any update-sensitive cases.

2. Detect incompatibility after updates

   On TDH.SYS.UPDATE, the host VMM can configure the TDX Module to detect
   actual incompatibility cases. The TDX Module will then return a special
   error to signal the incompatibility, allowing the host VMM to restart
   the update-sensitive operations.

Implement option #1 to fail updates if the feature is available. Also,
distinguish this update failure from other failures by returning -EBUSY,
which will be converted to a firmware update error code indicating that the
firmware is busy.

Options like "do nothing" or option #2 are not viable [1] because the
former allows damage to propagate to multiple, potentially unknown
components (adding significant complexity to the whole ecosystem), while
the latter may make existing KVM ioctls unstable.

Based on a reference patch by Vishal [2].

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Link: https://lore.kernel.org/linux-coco/aQIbM5m09G0FYTzE@google.com/ # [1]
Link: https://lore.kernel.org/linux-coco/CAGtprH_oR44Vx9Z0cfxvq5-QbyLmy_+Gn3tWm3wzHPmC1nC0eg@mail.gmail.com/ # [2]
---
 arch/x86/include/asm/tdx.h   | 13 +++++++++++--
 arch/x86/kvm/vmx/tdx_errno.h |  2 --
 arch/x86/virt/vmx/tdx/tdx.c  | 23 +++++++++++++++++++----
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index ad62a7be0443..50a58160deef 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -26,15 +26,19 @@
 #define TDX_SEAMCALL_GP			(TDX_SW_ERROR | X86_TRAP_GP)
 #define TDX_SEAMCALL_UD			(TDX_SW_ERROR | X86_TRAP_UD)
 
+#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+
 /*
  * TDX module SEAMCALL leaf function error codes
  */
-#define TDX_SUCCESS		0ULL
-#define TDX_RND_NO_ENTROPY	0x8000020300000000ULL
+#define TDX_SUCCESS			0ULL
+#define TDX_RND_NO_ENTROPY		0x8000020300000000ULL
+#define TDX_UPDATE_COMPAT_SENSITIVE	0x8000051200000000ULL
 
 /* Bit definitions of TDX_FEATURES0 metadata field */
 #define TDX_FEATURES0_TD_PRESERVING	BIT_ULL(1)
 #define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
+#define TDX_FEATURES0_UPDATE_COMPAT	BIT_ULL(47)
 #ifndef __ASSEMBLER__
 
 #include <uapi/asm/mce.h>
@@ -111,6 +115,11 @@ static inline bool tdx_supports_runtime_update(const struct tdx_sys_info *sysinf
 	return sysinfo->features.tdx_features0 & TDX_FEATURES0_TD_PRESERVING;
 }
 
+static inline bool tdx_supports_update_compatibility(const struct tdx_sys_info *sysinfo)
+{
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_UPDATE_COMPAT;
+}
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 6ff4672c4181..215c00d76a94 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -4,8 +4,6 @@
 #ifndef __KVM_X86_TDX_ERRNO_H
 #define __KVM_X86_TDX_ERRNO_H
 
-#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
-
 /*
  * TDX SEAMCALL Status Codes (returned in RAX)
  */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 3f5edbc33a4f..2cf3a01d0b9c 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1176,10 +1176,13 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_enable);
 
+#define TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE BIT(16)
+
 int tdx_module_shutdown(void)
 {
 	struct tdx_module_args args = {};
-	int ret, cpu;
+	u64 ret;
+	int cpu;
 
 	/*
 	 * Shut down the TDX Module and prepare handoff data for the next
@@ -1189,9 +1192,21 @@ int tdx_module_shutdown(void)
 	 * modules as new modules likely have higher handoff version.
 	 */
 	args.rcx = tdx_sysinfo.handoff.module_hv;
-	ret = seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
-	if (ret)
-		return ret;
+
+	if (tdx_supports_update_compatibility(&tdx_sysinfo))
+		args.rcx |= TDX_SYS_SHUTDOWN_AVOID_COMPAT_SENSITIVE;
+
+	ret = seamcall(TDH_SYS_SHUTDOWN, &args);
+
+	/*
+	 * Return -EBUSY to signal that there is one or more ongoing flows
+	 * which may not be compatible with an updated TDX module, so that
+	 * userspace can retry on this error.
+	 */
+	if ((ret & TDX_SEAMCALL_STATUS_MASK) == TDX_UPDATE_COMPAT_SENSITIVE)
+		return -EBUSY;
+	else if (ret)
+		return -EIO;
 
 	tdx_module_status = TDX_MODULE_UNINITIALIZED;
 	sysinit_done = false;
-- 
2.47.3


