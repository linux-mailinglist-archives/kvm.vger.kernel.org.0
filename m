Return-Path: <kvm+bounces-70978-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id R8W7N3LmjWkm8gAAu9opvQ
	(envelope-from <kvm+bounces-70978-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:40:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C4A12E580
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 15:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B89F03024072
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 14:37:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A38362143;
	Thu, 12 Feb 2026 14:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Byu5h1bU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415683612FF;
	Thu, 12 Feb 2026 14:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770906988; cv=none; b=o3eb2UZZDpSwxM5rfG5BlT0jb2Fxre7nzG7nwx8d3xdguxzbk0UgkBcoLTV0GSA/eupLDXDTnObQke/dYNKCacN8zTIvd8gTCW8VmPKVu8fQa2x7PbqxAb7P8PE8GCffuP//tWYKL0w8JIYueZMJ+HTOqkBYcB0SlctD3lEsKoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770906988; c=relaxed/simple;
	bh=BA2ZGp4j94N9vAD797Nyn3TZUMlHosoNbsEdv2PeF08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D49HHsWA4gavpoBPY1Zo9uRN7bQX1Riv0ZTQc49kqXiQpB2Hk5rYqFUP0EJOUIaaRXQ5Fm8muMhyswMOnbG+TWNQ4ZqiOpk9UkvfepED86Kx6rH2YNC1WqS4HBw6P2e0srsTdzmkh6OaF5o0iYT0/WA3AcTyr5fRCX4JX26WKnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Byu5h1bU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770906986; x=1802442986;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BA2ZGp4j94N9vAD797Nyn3TZUMlHosoNbsEdv2PeF08=;
  b=Byu5h1bU7pkSvuvZq+2r4MbgA8/qozFT9R6PpZD+mG6qG+klNY4i2Zs0
   MM/KABFysiCaIvLXWomHDBF8+ogHgJOHls8YLoi8VCq7bohQYdBItSVU0
   JJCS5zb+fdmXaBVkMUOEGg/lQn2VWxT9+6SaGhcv7sWCknMui7KtHElwq
   4Qpj7mjBX3/Bwg4zNKlxXBoYbmdXbgfg/+V+Cp93ApR7B9EVDwYiIXv3R
   jQJdg2QCtUsjCknAL6st060LHid/61EHAxtmgvkaz5zZscsGo8EydKt/I
   J+AsZG3SsrL6ngB26Gr+btirCa462RzsMuodvAPk89HZegIIGQqbhF7FU
   w==;
X-CSE-ConnectionGUID: MeyAe0pvTGuMhOFsdD4HIA==
X-CSE-MsgGUID: iqNvYQkAR3uvIfeYq16BVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="89662869"
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="89662869"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:26 -0800
X-CSE-ConnectionGUID: TGdHxgU3RF6EmxVdW0j6mw==
X-CSE-MsgGUID: /8AgZ/sbQ6SOMWg4HCer2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,286,1763452800"; 
   d="scan'208";a="211428279"
Received: from 984fee019967.jf.intel.com ([10.23.153.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 06:36:25 -0800
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
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 16/24] x86/virt/seamldr: Install a new TDX Module
Date: Thu, 12 Feb 2026 06:35:19 -0800
Message-ID: <20260212143606.534586-17-chao.gao@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70978-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+]
X-Rspamd-Queue-Id: 06C4A12E580
X-Rspamd-Action: no action

Following the shutdown of the existing TDX Module, the update process
continues with installing the new module. P-SEAMLDR provides the
SEAMLDR.INSTALL SEAMCALL to perform this installation, which must be
executed serially across all CPUs.

Implement SEAMLDR.INSTALL and execute it on every CPU.

Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index 4e0a98404c7f..4537311780b1 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -22,6 +22,7 @@
 
 /* P-SEAMLDR SEAMCALL leaf function */
 #define P_SEAMLDR_INFO			0x8000000000000000
+#define P_SEAMLDR_INSTALL		0x8000000000000001
 
 #define SEAMLDR_MAX_NR_MODULE_4KB_PAGES	496
 #define SEAMLDR_MAX_NR_SIG_4KB_PAGES	4
@@ -198,6 +199,7 @@ static struct seamldr_params *init_seamldr_params(const u8 *data, u32 size)
 enum tdp_state {
 	TDP_START,
 	TDP_SHUTDOWN,
+	TDP_CPU_INSTALL,
 	TDP_DONE,
 };
 
@@ -232,9 +234,10 @@ static void print_update_failure_message(void)
  * See multi_cpu_stop() from where this multi-cpu state-machine was
  * adopted, and the rationale for touch_nmi_watchdog()
  */
-static int do_seamldr_install_module(void *params)
+static int do_seamldr_install_module(void *seamldr_params)
 {
 	enum tdp_state newstate, curstate = TDP_START;
+	struct tdx_module_args args = {};
 	int cpu = smp_processor_id();
 	bool primary;
 	int ret = 0;
@@ -253,6 +256,10 @@ static int do_seamldr_install_module(void *params)
 				if (primary)
 					ret = tdx_module_shutdown();
 				break;
+			case TDP_CPU_INSTALL:
+				args.rcx = __pa(seamldr_params);
+				ret = seamldr_call(P_SEAMLDR_INSTALL, &args);
+				break;
 			default:
 				break;
 			}
-- 
2.47.3


