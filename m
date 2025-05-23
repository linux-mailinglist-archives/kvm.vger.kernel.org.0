Return-Path: <kvm+bounces-47551-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60DF2AC2052
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:58:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 278583A6FDD
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:58:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D440023F40F;
	Fri, 23 May 2025 09:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ts7g1Rsw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BA1241665;
	Fri, 23 May 2025 09:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994038; cv=none; b=bR/jloo06sxMjUjmfuL4y015h58eXnIWkgPN5CLyCQlhoLBwWdjM096oH0tqizqz4x9IPFaL6+SpMx0dLOFo3uWDiZm7559/tZeyQgiwcjcGXiV9zu7ZHAnKaNflC224alVCSNj+Hmo8x2R5Tv7rcIdYoPEfV6V9L/t1Djp2mmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994038; c=relaxed/simple;
	bh=MHYI6BG+L0TzNrsOZ1WeYjrr84DT6xKaIAXH83HbkR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHc3sHdEWeIQWA6h66bsSbnbrJsW0ZxkhZeBPKVUKgTQ0VI7MulnGydvS1YOZBWk9lmX9c4gPQyR/1eca5FpLh6mI5NqTrduD/umfC9pQLQw4Xh903QxLKxkmtm7AA3uv8y5B9tIF7lg2X14X2v++lFj7ZJLF4PDmv+KEQVVH7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ts7g1Rsw; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994037; x=1779530037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MHYI6BG+L0TzNrsOZ1WeYjrr84DT6xKaIAXH83HbkR8=;
  b=Ts7g1RswhkzqtXJ5OCVlE6Ebf/JXq3i1PV9EmcDt3SnuVqYdIiWXr1b8
   G0QfRrCUOLAWVDjYr3Vsn5JQG+b8xbnZDUp44FIk0ohyMl3h8OLbBAkGx
   Ws+OnMJLI1wSNL+5unj2gOGttDB/1rWq65JCB4xxkFGalsCzKYrb9W5C4
   Rt5aNBGdCh0ev3kDfwSSVF8MuZaTgjGbQCqVAqa3DI1VB59/nXNQQmo+c
   tG1rAzyuMBXjJm2iUuWUC4P79+pOgTrKiGNGXr6kLIqKDXIMFiWQkzVcu
   u259YWZqNOP6d6925stPyXLo7jWiA3ggb24erU+w/cRP3CDTXSyFiNXXa
   g==;
X-CSE-ConnectionGUID: eVF2TLUvQpGNKLIs9ihCoQ==
X-CSE-MsgGUID: 3B2QM1U/TQauvINc9+7xiQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444243"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444243"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:56 -0700
X-CSE-ConnectionGUID: pWgkUhH1SnGujQhMaoDXKg==
X-CSE-MsgGUID: t2+7IjtaTu+hILJ8cKt8pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315091"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:56 -0700
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
Subject: [RFC PATCH 17/20] x86/virt/tdx: Establish contexts for the new module
Date: Fri, 23 May 2025 02:52:40 -0700
Message-ID: <20250523095322.88774-18-chao.gao@intel.com>
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

TD-Preserving doesn't need to re-configure the global HKID, TDMRs or PAMTs.
The new module can import the handoff data created by the old module to
establish all necessary contexts. The TDH.SYS.UPDATE API is introduced for
the import process

Once the import is done, the module update is complete, and the new module
is ready to handle requests from the VMM and guests.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c |  7 +++++++
 arch/x86/virt/vmx/tdx/tdx.c     | 16 ++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h     |  2 ++
 3 files changed, 25 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index c4e1b7540a43..168fd2afd0c9 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -246,6 +246,7 @@ enum tdp_state {
 	TDP_SHUTDOWN,
 	TDP_CPU_INSTALL,
 	TDP_CPU_INIT,
+	TDP_RUN_UPDATE,
 	TDP_DONE,
 };
 
@@ -322,6 +323,12 @@ static int do_seamldr_install_module(void *params)
 			case TDP_CPU_INIT:
 				ret = tdx_cpu_enable();
 				break;
+			case TDP_RUN_UPDATE:
+				if (!primary)
+					break;
+
+				ret = tdx_module_run_update();
+				break;
 			default:
 				break;
 			}
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 331c86eeddcf..5f678c9da4ee 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1390,6 +1390,22 @@ void tdx_module_set_error(void)
 	tdx_module_status = TDX_MODULE_ERROR;
 }
 
+int tdx_module_run_update(void)
+{
+	struct tdx_module_args args = {};
+	int ret;
+
+	ret = seamcall(TDH_SYS_UPDATE, &args);
+	if (ret) {
+		tdx_module_status = TDX_MODULE_ERROR;
+		pr_info("module update failed: %d\n", ret);
+		return ret;
+	}
+
+	tdx_module_status = TDX_MODULE_INITIALIZED;
+	return ret;
+}
+
 static bool is_pamt_page(unsigned long phys)
 {
 	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index ed3d74c991f6..a05e3c21e7f5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -49,6 +49,7 @@
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
 #define TDH_SYS_SHUTDOWN		52
+#define TDH_SYS_UPDATE		53
 
 /*
  * SEAMCALL leaf:
@@ -126,5 +127,6 @@ int seamldr_prerr(u64 fn, struct tdx_module_args *args);
 
 int tdx_module_shutdown(void);
 void tdx_module_set_error(void);
+int tdx_module_run_update(void);
 
 #endif
-- 
2.47.1


