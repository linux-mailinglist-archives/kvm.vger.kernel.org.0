Return-Path: <kvm+bounces-47547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33832AC2049
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:57:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B976189EA49
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9F123F431;
	Fri, 23 May 2025 09:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YR0Fcjkx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C7923C4F4;
	Fri, 23 May 2025 09:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994035; cv=none; b=VhRKdfmZyYrvOpEBuih0kY8nkrEkGieJOvu0UWgLWoXDfSI0aKDcCxMpwtjWodc772MBBavuES5NYYWm3nNnK2vw27dUQvvnpVmXMONJedhcc/QGbMApeiWwzQHrkCj9Vmd79FrnrihiFYPJ1ZqRHHN57AA8si0jHUgr12xP918=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994035; c=relaxed/simple;
	bh=Ji+zxcDg6HyiUmEYaMcKATRfTO8H0bwmGnt9rZMxtXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP007gVTZK5xmbyx6hofxMs+m98HKYWV2gmHCrSCz/C0oFpAe1UcPXEEfPfbepv8WhzcWNN0vau2fokuDGUOmVX7yZ2BGCUv8DoxTjy8p4ck3g9wHYKQZrwgQz200QRZpw3CjZJpalGxNjDx58e1JbKBk6+3IyKbtQS+G8Y6JV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YR0Fcjkx; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994034; x=1779530034;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ji+zxcDg6HyiUmEYaMcKATRfTO8H0bwmGnt9rZMxtXc=;
  b=YR0FcjkxMD2eZvFFyH7AnZKrlLAhE/wR7RN8Z3ENeNCwsJFZZY00F3HC
   KztFl+HbDHE5zb/H57rJzgzIT0B/XxyXoKAyjz4by9V6+IdU92qwRxPGh
   73/Zz3RH82mcUVK1PlASR9E9HyoaHCssczzeVSDsgjAZbaDIC4AM/fq8A
   /5Q+AWPFiQqFDaLSFl18QpFgGETcQtZEMNQXyhbS8owtiCb9cSMLCmKqW
   8tYb5uE8UrIjsMYKZl3P7S/XERjGHJh3Mv+7jRsmYP9LT5SzlWzxlxNL9
   Q62UCKDs46Eiit1t5hh0BA8zHWFImxzeQDXQ3wqEGStFH4kkwLe1PzqUQ
   w==;
X-CSE-ConnectionGUID: Y9/ApZheQomJqfyJ5i18Ww==
X-CSE-MsgGUID: fNzGqi9WT6eaQyybQqiiCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444198"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444198"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:53 -0700
X-CSE-ConnectionGUID: 4VgRQ3HmRYqAuDsvbP3F/A==
X-CSE-MsgGUID: x0cVf/4WRmGgBXTovuESyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315075"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:52 -0700
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
Subject: [RFC PATCH 12/20] x86/virt/seamldr: Shut down the current TDX module
Date: Fri, 23 May 2025 02:52:35 -0700
Message-ID: <20250523095322.88774-13-chao.gao@intel.com>
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

TD-Preserving updates request shutting down the existing TDX module.
During this shutdown, the module generates hand-off data, which captures
the module's states essential for preserving running TDs. The new TDX
module can utilize this hand-off data to establish its states.

Invoke the TDH_SYS_SHUTDOWN API on one CPU to perform the shutdown. This
API requires a hand-off module version. Use the module's own hand-off
version, as it is the highest version the module can produce and is more
likely to be compatible with new modules.

Changes to tdx_global_metadata.{hc} are auto-generated by following the
instructions detailed in [1], after adding the following section to the
tdx.py script:

    "handoff": [
       "MODULE_HV",
    ],

Add a check to ensure that module_hv is guarded by the TDX module's
support for TD-Preserving.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
Link: https://lore.kernel.org/kvm/20250226181453.2311849-12-pbonzini@redhat.com/ [1]
---
 arch/x86/include/asm/tdx_global_metadata.h  |  5 +++++
 arch/x86/virt/vmx/tdx/seamldr.c             | 11 +++++++++++
 arch/x86/virt/vmx/tdx/tdx.c                 | 18 ++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h                 |  4 ++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 13 +++++++++++++
 5 files changed, 51 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index ce0370f4a5b9..a2011a3575ff 100644
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
 	struct tdx_sys_info_versions versions;
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
 	struct tdx_sys_info_td_conf td_conf;
+	struct tdx_sys_info_handoff handoff;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 9d0d37a92bfd..11c0c5a93c32 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -241,6 +241,7 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
 
 enum tdp_state {
 	TDP_START,
+	TDP_SHUTDOWN,
 	TDP_DONE,
 };
 
@@ -281,8 +282,12 @@ static void ack_state(void)
 static int do_seamldr_install_module(void *params)
 {
 	enum tdp_state newstate, curstate = TDP_START;
+	int cpu = smp_processor_id();
+	bool primary;
 	int ret = 0;
 
+	primary = !!(cpumask_first(cpu_online_mask) == cpu);
+
 	do {
 		/* Chill out and ensure we re-read tdp_data. */
 		cpu_relax();
@@ -291,6 +296,12 @@ static int do_seamldr_install_module(void *params)
 		if (newstate != curstate) {
 			curstate = newstate;
 			switch (curstate) {
+			case TDP_SHUTDOWN:
+				if (!primary)
+					break;
+
+				ret = tdx_module_shutdown();
+				break;
 			default:
 				break;
 			}
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 22ffc15b4299..fa6b3f1eb197 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -295,6 +295,11 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 	return 0;
 }
 
+static bool tdx_has_td_preserving(void)
+{
+	return tdx_sysinfo.features.tdx_features0 & TDX_FEATURES0_TD_PRESERVING;
+}
+
 #include "tdx_global_metadata.c"
 
 static int check_features(struct tdx_sys_info *sysinfo)
@@ -1341,6 +1346,19 @@ int tdx_enable(void)
 }
 EXPORT_SYMBOL_GPL(tdx_enable);
 
+int tdx_module_shutdown(void)
+{
+	struct tdx_module_args args = {};
+
+	/*
+	 * Shut down TDX module and prepare handoff data for the next TDX module.
+	 * Following a successful TDH_SYS_SHUTDOWN, further TDX module APIs will
+	 * fail.
+	 */
+	args.rcx = tdx_sysinfo.handoff.module_hv;
+	return seamcall_prerr(TDH_SYS_SHUTDOWN, &args);
+}
+
 static bool is_pamt_page(unsigned long phys)
 {
 	struct tdmr_info_list *tdmr_list = &tdx_tdmr_list;
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 48c0a850c621..3830dee4da91 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -48,6 +48,7 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_SYS_SHUTDOWN		52
 
 /*
  * SEAMCALL leaf:
@@ -87,6 +88,7 @@ struct tdmr_info {
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
 /* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_TD_PRESERVING	BIT(1)
 #define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
 
 /*
@@ -122,4 +124,6 @@ struct tdmr_info_list {
 
 int seamldr_prerr(u64 fn, struct tdx_module_args *args);
 
+int tdx_module_shutdown(void);
+
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 088e5bff4025..a17cbb82e6b8 100644
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
+	if (!ret && tdx_has_td_preserving() &&
+	    !(ret = read_sys_metadata_field(0x8900000100000000, &val)))
+		sysinfo_handoff->module_hv = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
@@ -109,6 +121,7 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
 	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
+	ret = ret ?: get_tdx_sys_info_handoff(&sysinfo->handoff);
 
 	return ret;
 }
-- 
2.47.1


