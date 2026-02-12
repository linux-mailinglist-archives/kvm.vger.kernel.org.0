Return-Path: <kvm+bounces-70966-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPGZGBHmjWms8QAAu9opvQ
	(envelope-from <kvm+bounces-70966-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:39:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C0D4312E521
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:39:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 392A23169272
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:36:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9140F35CBB6;
	Thu, 12 Feb 2026 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nl6i3z10"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6ED35CB6C;
	Thu, 12 Feb 2026 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906978; cv=none; b=KgtP+PRbfa9GzW2SZPTY4hm3NyTjf/H8Zy7CFH5rRZNd7olZy+kzjwXcuJLCFyEHW05F698U6bmraNfElDKGxV6GDYC7ahHBaHgtR7MKlMCDZckyebDl7u5bAV8kIY9v4SfXOQkuZuHBQMBci2RsrE/VNFY1I2rdwCCsMKiLVZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906978; c=relaxed/simple;
	bh=TVBKfeA7bJXJ8+DCH03hjvCM1PJseVe5z0PE4+HoCe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ltv8nSC/l5Zesgy8C64i6kDLM+pq6BleclVxVDVYQnWPJOyMhn/f/zWCXNPYP8ya/ftE5kHFNkIZTJayIW8hiMK/lBFbS+rGDKBSW28uaToiaiJOg/ODxow7739plI5jmQPSyEIoGJHSIo5MW9HZ4Xh4pS0Qp92b2kHUdAF+2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nl6i3z10; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906977; x=1802442977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TVBKfeA7bJXJ8+DCH03hjvCM1PJseVe5z0PE4+HoCe0=;
  b=nl6i3z10cHBXmukZV+I9sG0AIOY6siXmUFIqlEEkd7jhH9IcLoVG89U7
   DfZ9w2WI+WWRDph8bXPupp3Q7mSLS4XztLEIKR1wp70sHfXHj+P8Cb5ZQ
   knB8/51ua+p4l3y03j+ETich1t6JJSmScQYxcu/gDtNW8cMMArIENIL6Z
   tbCd3RzjBD5OiHz+c5wwO/jre0yutQgxZDwtUlJAMJKEgTSsPZO8r7yo1
   F+qljcb6+WQAymd8oZAq6bhverv2MWlnLiUU962+Ks2fCa0dNmA/QZpPH
   ZVl3SyfFpLwtfsUwcC12YU6dwXshqChvhhwTLa8TbZ5Jjbbh0B9/J5HNh
   w==;
X-CSE-ConnectionGUID: nrOQ2MARR7epqGKYMWSySg==
X-CSE-MsgGUID: 9CGIjjIkTJqr1ImBXairuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662776"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662776"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:16 -0800
X-CSE-ConnectionGUID: T4lpa21WQQms4YsWqAwhUw==
X-CSE-MsgGUID: aHoiO5EkSgakfb92FPMmHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428217"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:15 -0800
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
	Farrah Chen <farrah.chen@intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 05/24] x86/virt/seamldr: Retrieve P-SEAMLDR information
Date: Thu, 12 Feb 2026 06:35:08 -0800
Message-ID: <20260212143606.534586-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212143606.534586-1-chao.gao@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[27];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70966-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: C0D4312E521
X-Rspamd-Action: no action

P-SEAMLDR returns its information such as version number, in response to
the SEAMLDR.INFO SEAMCALL.

This information is useful for userspace. For example, the admin can decide
which TDX module versions are compatible with the P-SEAMLDR according to
the P-SEAMLDR version.

Retrieve P-SEAMLDR information in preparation for exposing P-SEAMLDR
version and other necessary information to userspace. Export the new kAPI
for use by tdx-host.ko.

Note that there are two distinct P-SEAMLDR APIs with similar names:

  SEAMLDR.INFO: Returns a SEAMLDR_INFO structure containing SEAMLDR
                information such as version and remaining updates.

  SEAMLDR.SEAMINFO: Returns a SEAMLDR_SEAMINFO structure containing SEAM
                    and system information such as Convertible Memory
		    Regions (CMRs) and number of CPUs and sockets.

The former is used here.

For details, see "Intel® Trust Domain Extensions - SEAM Loader (SEAMLDR)
Interface Specification" revision 343755-003.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
v4:
 - put seamldr_info on stack [Dave]
 - improve changelogs to explain SEAMLDR.INFO and SEAMLDR.SEAMINFO [Dave]
 - add SEAMLDR spec information in the changelog [Dave]
 - add proper comments above ABI structure definition [Dave]
 - add unused ABI structure fields rather than marking them as reserved
   to better align with the specc [Dave] (I omitted "not used by kernel"
   tags since there are 5-6 such fields and maintaining these tags would
   be tedious.)
---
 arch/x86/include/asm/seamldr.h  | 36 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/seamldr.c | 15 +++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/seamldr.h

diff --git a/arch/x86/include/asm/seamldr.h b/arch/x86/include/asm/seamldr.h
new file mode 100644
index 000000000000..954d850e34e3
--- /dev/null
+++ b/arch/x86/include/asm/seamldr.h
@@ -0,0 +1,36 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_SEAMLDR_H
+#define _ASM_X86_SEAMLDR_H
+
+#include <linux/types.h>
+
+/*
+ * This called the "SEAMLDR_INFO" data structure and is defined
+ * in "SEAM Loader (SEAMLDR) Interface Specification".
+ *
+ * The SEAMLDR.INFO documentation requires this to be aligned to a
+ * 256-byte boundary.
+ */
+struct seamldr_info {
+	u32	version;
+	u32	attributes;
+	u32	vendor_id;
+	u32	build_date;
+	u16	build_num;
+	u16	minor_version;
+	u16	major_version;
+	u16	update_version;
+	u32	acm_x2apicid;
+	u32	num_remaining_updates;
+	u8	seam_info[128];
+	u8	seam_ready;
+	u8	seam_debug;
+	u8	p_seam_ready;
+	u8	reserved[93];
+} __packed __aligned(256);
+
+static_assert(sizeof(struct seamldr_info) == 256);
+
+int seamldr_get_info(struct seamldr_info *seamldr_info);
+
+#endif /* _ASM_X86_SEAMLDR_H */
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index fb59b3e2aa37..d17db3c0151e 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -8,15 +8,20 @@
 
 #include <linux/spinlock.h>
 
+#include <asm/seamldr.h>
+
 #include "seamcall_internal.h"
 
+/* P-SEAMLDR SEAMCALL leaf function */
+#define P_SEAMLDR_INFO			0x8000000000000000
+
 /*
  * Serialize P-SEAMLDR calls since the hardware only allows a single CPU to
  * interact with P-SEAMLDR simultaneously.
  */
 static DEFINE_RAW_SPINLOCK(seamldr_lock);
 
-static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
+static int seamldr_call(u64 fn, struct tdx_module_args *args)
 {
 	/*
 	 * Serialize P-SEAMLDR calls and disable interrupts as the calls
@@ -25,3 +30,11 @@ static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
 	guard(raw_spinlock_irqsave)(&seamldr_lock);
 	return seamcall_prerr(fn, args);
 }
+
+int seamldr_get_info(struct seamldr_info *seamldr_info)
+{
+	struct tdx_module_args args = { .rcx = slow_virt_to_phys(seamldr_info) };
+
+	return seamldr_call(P_SEAMLDR_INFO, &args);
+}
+EXPORT_SYMBOL_FOR_MODULES(seamldr_get_info, "tdx-host");
-- 
2.47.3


