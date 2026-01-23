Return-Path: <kvm+bounces-68995-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KPmIFImOc2l0xAAAu9opvQ
	(envelope-from <kvm+bounces-68995-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F2C0F77771
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 16:06:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 440F83043271
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 15:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83FC36EA93;
	Fri, 23 Jan 2026 15:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLixZieV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD2636212E;
	Fri, 23 Jan 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769180437; cv=none; b=j55619OlgBV4Tsd8mWIBS5vtA/TuSsvz2h3noFVLkoNiJyxes9G+B26K8KZqHEPJNag/6SAsguAFB+lE5OUM2aAFJr1vYYvf/YI3vzRXcqHqW1p8gafl4NZqEZw37370v24aOBaWnLHJr8NZqmW3JtuEaiOTuP71e3n6arkwX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769180437; c=relaxed/simple;
	bh=xW4j0l2qmTh00vzb82ZFjrNGHJwRR46YR7Za6lDhCTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTecjTq179h5TOl35pOB7jm7Vyjlf3gAPwsWPrAqm2QgIint2RD9eQlexD6CXYKah/YaoG/bWH7tOSHTQHQ274DRNRrlyaLO6Qh7BDptSeE7dkGaOGDAFzHHA3trHN2T/WYyqlldphbRPi4O+xta5UCBo+kur6uqJkdNKcC/5IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLixZieV; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769180436; x=1800716436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xW4j0l2qmTh00vzb82ZFjrNGHJwRR46YR7Za6lDhCTM=;
  b=nLixZieVFWr2Mij+xWRMmBYa0ROECXZ/ATUeYN4kvROpD/lc+GSli4qS
   wqhTlfA+gMKbIcXtip9F2swfq/TYHjGAIJ73UUPYf2ndTD0YQyiQ0Pv8m
   CWmnE8kn2ATTgXKnM4NFl2g6T3Bh/x+8rSBp2Ln7eA0HAwVaSEyRnvnKa
   vxuKtW/SxiDG/K+txtwd0EXi4BfX+JtY5A8ZI5QdqoSMfa4usknu+IiwT
   jrTkwO6KYNYC0YvvZHVOCSeskVU5psQZcaNta9hAGvpYQhgjDGUQXknpQ
   Dqq0CgC0JJBVhMio2Xb7fEqDUNfU33Lark9FeiVw49RTuQgRsXa9rfUdV
   g==;
X-CSE-ConnectionGUID: ahBA78O5Q2qpCL1LSUv8Hw==
X-CSE-MsgGUID: z1vSkS9VS3eAIugAFHQd1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11680"; a="70334506"
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="70334506"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:19 -0800
X-CSE-ConnectionGUID: GrFZaddoSyyEii7M73hpiA==
X-CSE-MsgGUID: TzUN+6HIRUWT81G8RXPZyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,248,1763452800"; 
   d="scan'208";a="237697199"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2026 07:00:19 -0800
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
Subject: [PATCH v3 21/26] x86/virt/tdx: Establish contexts for the new TDX Module
Date: Fri, 23 Jan 2026 06:55:29 -0800
Message-ID: <20260123145645.90444-22-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[25];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68995-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: F2C0F77771
X-Rspamd-Action: no action

After being installed, the new TDX Module shouldn't re-configure the
global HKID, TDMRs or PAMTs. Instead, to preserve running TDs, it should
import the handoff data from the old module to establish all necessary
contexts.

Once the import is done, the TDX Module update is complete, and the new
module is ready to handle requests from the VMM and guests.

Call the TDH.SYS.UPDATE SEAMCALL to import the handoff data from the old
module.

Note that the location and the format of handoff data is defined by the
TDX Module. The new module knows where to get the handoff data and how to
parse it. The kernel doesn't need to provide its location, format etc.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
v3:
 - use seamcall_prerr() rather than raw seamcall() [Binbin]
 - use pr_err() to print error message [Binbin]
---
 arch/x86/virt/vmx/tdx/seamldr.c |  5 +++++
 arch/x86/virt/vmx/tdx/tdx.c     | 16 ++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h     |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index ee672f381dd5..7fa68c0c6ce4 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -240,6 +240,7 @@ enum tdp_state {
 	TDP_SHUTDOWN,
 	TDP_CPU_INSTALL,
 	TDP_CPU_INIT,
+	TDP_RUN_UPDATE,
 	TDP_DONE,
 };
 
@@ -307,6 +308,10 @@ static int do_seamldr_install_module(void *seamldr_params)
 			case TDP_CPU_INIT:
 				ret = tdx_cpu_enable();
 				break;
+			case TDP_RUN_UPDATE:
+				if (primary)
+					ret = tdx_module_run_update();
+				break;
 			default:
 				break;
 			}
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 2763c1869b78..2654aa169dda 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1202,6 +1202,22 @@ int tdx_module_shutdown(void)
 	return 0;
 }
 
+int tdx_module_run_update(void)
+{
+	struct tdx_module_args args = {};
+	int ret;
+
+	ret = seamcall_prerr(TDH_SYS_UPDATE, &args);
+	if (ret) {
+		pr_err("TDX-Module update failed (%d)\n", ret);
+		tdx_module_status = TDX_MODULE_ERROR;
+		return ret;
+	}
+
+	tdx_module_status = TDX_MODULE_INITIALIZED;
+	return 0;
+}
+
 static bool is_pamt_page(unsigned long phys)
 {
 	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 1c4da9540ae0..0887debfd139 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -47,6 +47,7 @@
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
 #define TDH_SYS_SHUTDOWN		52
+#define TDH_SYS_UPDATE		53
 
 /*
  * SEAMCALL leaf:
@@ -120,5 +121,6 @@ struct tdmr_info_list {
 };
 
 int tdx_module_shutdown(void);
+int tdx_module_run_update(void);
 
 #endif
-- 
2.47.3


