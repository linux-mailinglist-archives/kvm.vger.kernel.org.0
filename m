Return-Path: <kvm+bounces-68991-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGtFHtaPc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68991-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:12:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE5C778FB
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:12:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 41DB630476DF
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1500366079;
	Fri, 23 Jan 2026 15:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KwnkBJFA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98AC3570A9;
	Fri, 23 Jan 2026 15:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180435; cv=none; b=uigdjOGbREnjl7Cz1ynv22pKJhdeXByRkm6LJehQYUU4LK1buUkUAflNjZuh5XCDzORPIqgerc+4KS4PJIYT38GtvOQyXYXJET76fIYLayPgpcqnDwesFIy/w/+qXjIO8KKkh+epMq6mPrscM5nNdRe3XHIFlYtR4frOJPM8GH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180435; c=relaxed/simple;
	bh=eCHsjN/WFKTRp2ioiJ0lDE/cxmPQPl26vIGWgJI90qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgqX990h3Lx/Vj086ZHzLTur10nPXQ5RkR/qmGctJCAXihsPh/9SSTBKkKylB2ROaze/exBz2zkwFAatbaN1KoaiPrSXsgAnNX86Lctzyi39/zE8fxdsaE4+9zlVZhOKEfU/H/RSjmGBEJFJGM+wjyKswbGGjHV9WVIgPF1qfjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KwnkBJFA; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180433; x=1800716433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eCHsjN/WFKTRp2ioiJ0lDE/cxmPQPl26vIGWgJI90qs=;
  b=KwnkBJFABBlM3G/HaJT2KBQRfm4mUHj0E2sy+eaIL13wFRkpa+R8WB6H
   y2/2qHAwF3MIq7I4jBBKNBwcBu+TbiYwoOqMJkfDGBJ2n6Nja33Vmi4Yl
   mAJVjNTPrul6f47rsEOS9q5t4pKltVBQL0LyB3iLyNRmwJWxSkWbiWroA
   /anfw+b6e+4F2mfyTWxfCzRP9o5jhIn/IAHPLf7WkJnTts5x31WTCt63Z
   QaV/0R1dnAThen2hHDJDyvn7OWwCK4ocCX+Ks3LMrfy9C3f1W8b6TlNHL
   Ur7lpVpbMuxxvXc7gWx6up1au+zOvUaRqTIhaZPQ8qIOEI4+PaLFJRWIZ
   w==;
X-CSE-ConnectionGUID: V3ptGusdQUmWHGLI17Zgeg==
X-CSE-MsgGUID: AoknQZucSbeyYsmRDqRNBA==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334460"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334460"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:17 -0800
X-CSE-ConnectionGUID: UmfE6kZWTj6o/LxogLuewA==
X-CSE-MsgGUID: 8+YgL/bETrOzLc4/6nBu3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697166"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:17 -0800
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
Subject: [PATCH v3 16/26] x86/virt/seamldr: Shut down the current TDX module
Date: Fri, 23 Jan 2026 06:55:24 -0800
Message-ID: <20260123145645.90444-17-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68991-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: CCE5C778FB
X-Rspamd-Action: no action

TDX Module updates request shutting down the existing TDX module.
During this shutdown, the module generates hand-off data, which captures
the module's states essential for preserving running TDs. The new TDX
Module can utilize this hand-off data to establish its states.

Invoke the TDH_SYS_SHUTDOWN SEAMCALL on one CPU to perform the shutdown.
This SEAMCALL requires a hand-off module version. Use the module's own
hand-off version, as it is the highest version the module can produce and
is more likely to be compatible with new modules as new modules likely have
higher hand-off version.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
v3:
 - remove autogeneration stuff in the changelog
v2:
 - add a comment about how handoff version is chosen.
 - remove the first !ret in get_tdx_sys_info_handoff() as we edited the
   auto-generated code anyway
 - remove !! when determining whether a CPU is the primary one
 - remove unnecessary if-break nesting in TDP_SHUTDOWN
---
 arch/x86/include/asm/tdx_global_metadata.h  |  5 +++++
 arch/x86/virt/vmx/tdx/seamldr.c             | 10 ++++++++++
 arch/x86/virt/vmx/tdx/tdx.c                 | 16 ++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h                 |  3 +++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 13 +++++++++++++
 5 files changed, 47 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 40689c8dc67e..8a9ebd895e70 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -40,12 +40,17 @@ struct tdx_sys_info_td_conf {
 	u64 cpuid_config_values[128][2];
 };
 
+struct tdx_sys_info_handoff {
+	u16 module_hv;
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_version version;
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
 	struct tdx_sys_info_td_conf td_conf;
+	struct tdx_sys_info_handoff handoff;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index a13d526b38a7..76f404d1115c 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -19,6 +19,7 @@
 #include <asm/seamldr.h>
 
 #include "seamcall.h"
+#include "tdx.h"
 
 /* P-SEAMLDR SEAMCALL leaf function */
 #define P_SEAMLDR_INFO			0x8000000000000000
@@ -233,6 +234,7 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
  */
 enum tdp_state {
 	TDP_START,
+	TDP_SHUTDOWN,
 	TDP_DONE,
 };
 
@@ -265,8 +267,12 @@ static void ack_state(void)
 static int do_seamldr_install_module(void *params)
 {
 	enum tdp_state newstate, curstate = TDP_START;
+	int cpu = smp_processor_id();
+	bool primary;
 	int ret = 0;
 
+	primary = cpumask_first(cpu_online_mask) == cpu;
+
 	do {
 		/* Chill out and ensure we re-read tdp_data. */
 		cpu_relax();
@@ -275,6 +281,10 @@ static int do_seamldr_install_module(void *params)
 		if (newstate != curstate) {
 			curstate = newstate;
 			switch (curstate) {
+			case TDP_SHUTDOWN:
+				if (primary)
+					ret = tdx_module_shutdown();
+				break;
 			default:
 				break;
 			}
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index a0990c5dd78d..8b36a80cf229 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1175,6 +1175,22 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_enable);
 
+int tdx_module_shutdown(void)
+{
+	struct tdx_module_args args = {};
+
+	/*
+	 * Shut down the TDX Module and prepare handoff data for the next
+	 * TDX Module. This SEAMCALL requires a hand-off module version.
+	 * Use the module's own hand-off version, as it is the highest
+	 * version the module can produce and is more likely to be
+	 * compatible with new modules as new modules likely have higher
+	 * hand-off version.
+	 */
+	args.rcx = tdx_sysinfo.handoff.module_hv;
+	return seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
+}
+
 static bool is_pamt_page(unsigned long phys)
 {
 	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..1c4da9540ae0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,7 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_SYS_SHUTDOWN		52
 
 /*
  * SEAMCALL leaf:
@@ -118,4 +119,6 @@ struct tdmr_info_list {
 	int max_tdmrs;	/* How many 'tdmr_info's are allocated */
 };
 
+int tdx_module_shutdown(void);
+
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 4c9917a9c2c3..7f4ed9af1d8d 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -100,6 +100,18 @@ static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf
 	return ret;
 }
 
+static int get_tdx_sys_info_handoff(struct tdx_sys_info_handoff *sysinfo_handoff)
+{
+	int ret = 0;
+	u64 val;
+
+	if (tdx_supports_runtime_update(&tdx_sysinfo) &&
+	    !(ret = read_sys_metadata_field(0x8900000100000000, &val)))
+		sysinfo_handoff->module_hv = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
@@ -115,6 +127,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
 	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
+	ret = ret ?: get_tdx_sys_info_handoff(&sysinfo->handoff);
 
 	return ret;
 }
-- 
2.47.3


