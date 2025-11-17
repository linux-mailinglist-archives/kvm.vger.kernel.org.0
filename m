Return-Path: <kvm+bounces-63307-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id B3222C621AC
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:39:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BE6D1360000
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62458265CC2;
	Mon, 17 Nov 2025 02:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RjT7IoAW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D051B24EAB1;
	Mon, 17 Nov 2025 02:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347102; cv=none; b=ZwF4SP3NkAU8zuPaBP9VKHYyWHp/Gko6+7b8rW8+AKKD8NhaV35vUbYLSE/XvTZdZ4k1coUWjAClE9Z6CCwTJDVKXqvFxycjk/wBXgMkrWzQt3qD2k6EvVoMWPXkXXHziB6uhMWkHJXKKx2901r3Ooj+RgjYzm4pZhngMOeF3yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347102; c=relaxed/simple;
	bh=CUfitXBEKhWWRq7ue5rb8F5I+c8tczv8PbchN0QVA4M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LXTjYwyinRiqZoJHBDdK1LMJgDfmNHmS+drKGv6PRllGGa0ddjFauvjjl/hlbtKwTiJLNMUzSQ5iLQNF6MVTzeRqFFty2ZXbwqhTI89DLjlVnqjVkSDSGcu6wU6oYS9VDqPkNq1zw8ZP3hCZn/gbCcydr4csGftuvL5Wbq3xdks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RjT7IoAW; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347101; x=1794883101;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CUfitXBEKhWWRq7ue5rb8F5I+c8tczv8PbchN0QVA4M=;
  b=RjT7IoAWlC1kKwz3o2g32Ntz7dEGu7F+xUWpjDoNbyYiOZjs8ZVO1dEe
   XwVwB2xhkQMPlDN+6Kf+xYQVrlRJhAaLdpq4VvwUiEcbIVUy4x3TPKWv1
   GKrfgkDJ7eyFj/4BrMHL2QevqgyheVIzCyukKh6sqc2wUEfFLHum6sx6V
   3t+488y4hHNGn8dxZRmvnkj9KYfx+NEZJdz9K/fmmBIap1Vc1i47vVhrp
   xivvyUnGZkjOsXTFCs10YVCzXZ4Yhga/n3Fs/1DuZB5szHWbvl7tAej5s
   rwr3rTbl76snRgHzh4blMqo9ndxXee+BQmEkyXTG+YtIalkuR4N9jGoVw
   g==;
X-CSE-ConnectionGUID: MLAU1I20Rq2IllG2iM4taQ==
X-CSE-MsgGUID: vNT/3YWWQrynioTGHj6Edw==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729521"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729521"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:38:21 -0800
X-CSE-ConnectionGUID: wtwdRdzEQ+e55Insjy9eSg==
X-CSE-MsgGUID: SExPnkMySVmvUbr67t4qzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658225"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:17 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: linux-coco@lists.linux.dev,
	linux-pci@vger.kernel.org
Cc: chao.gao@intel.com,
	dave.jiang@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	dan.j.williams@intel.com,
	kas@kernel.org,
	x86@kernel.org
Subject: [PATCH v1 07/26] x86/virt/tdx: Read TDX global metadata for TDX Module Extensions
Date: Mon, 17 Nov 2025 10:22:51 +0800
Message-Id: <20251117022311.2443900-8-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
References: <20251117022311.2443900-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the global metadata for TDX core to enable extensions. They are:

 - "memory_pool_required_pages"
   Specify the required number of memory pool pages for the present
   extensions.

 - "ext_required"
   Specify if TDX.EXT.INIT is required.

Note for these 2 fields, a value of 0 doesn't mean extensions are not
supported.  It means no need to call TDX.EXT.MEM.ADD or TDX.EXT.INIT.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/tdx_global_metadata.h  |  6 ++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 060a2ad744bf..2aa741190b93 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -34,11 +34,17 @@ struct tdx_sys_info_td_conf {
 	u64 cpuid_config_values[128][2];
 };
 
+struct tdx_sys_info_ext {
+	u16 memory_pool_required_pages;
+	u8 ext_required;
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_td_ctrl td_ctrl;
 	struct tdx_sys_info_td_conf td_conf;
+	struct tdx_sys_info_ext ext;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 360963bc9328..c3b2e2748b3e 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -85,6 +85,19 @@ static __init int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_
 	return ret;
 }
 
+static __init int get_tdx_sys_info_ext(struct tdx_sys_info_ext *sysinfo_ext)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x3100000100000000, &val)))
+		sysinfo_ext->memory_pool_required_pages = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x3100000100000001, &val)))
+		sysinfo_ext->ext_required = val;
+
+	return ret;
+}
+
 static __init int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
@@ -93,6 +106,7 @@ static __init int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
 	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
+	ret = ret ?: get_tdx_sys_info_ext(&sysinfo->ext);
 
 	return ret;
 }
-- 
2.25.1


