Return-Path: <kvm+bounces-31449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 311E59C3C4F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:45:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 632771C2061F
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E44C1A2567;
	Mon, 11 Nov 2024 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QYzQQb/+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37DB1A0AF2;
	Mon, 11 Nov 2024 10:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321657; cv=none; b=LZMUlJRmKHt6JIdwI+HXm2z3OOiI6awjbztsrwfOOU/xQQIKXSEZLUVJ7yV7H6bbpKZYvl9NPtE3mIkZ27JNCUXMS5VDcn8F1yryZYT1ZbAcpVwqU6oclp/9gNFYUz5A9hX2gt38uRycOuG4eDq9dxLPhrob2Evu6BGI6IWO2ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321657; c=relaxed/simple;
	bh=WO0HYHGIIhSoO9GM+qLdMUDgHdtywJaoeUvB2JKTsDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KerZ7IGfRvOTLZV8T42XRvSXfKI5cA1rEfZF/Bj68SnPAMvepwmaNrX/VAmY25sS9CdH5ve+7/gfOFT4nVANvyRIqGPIEs3J6kal3G4/dhjcl17BGBXgOEgSjiRTAMs7DZjgRYnlOa4HdT062LZySNByk3wXQS5jI2zzGffaZyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QYzQQb/+; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321656; x=1762857656;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WO0HYHGIIhSoO9GM+qLdMUDgHdtywJaoeUvB2JKTsDU=;
  b=QYzQQb/+GXGI6anVV28j2K290lV4MV+EqPTLEYeqeHSPdA3mE0uZW6Mw
   DAqmdOOdxYv5U2SUpD2bhteQ32fgYlHeW1l0onFDnWjXLgf3vZ3WQelgF
   aedA5Saa1gINPeuvWRuf2D3ieayWHaMqmSPn/BseozfWpf8R+sCsSFBnN
   NlZiqd4todEusxWfAQQEVufAJgItX+eoa1pM8HdcrpHnchOOEHxhCjF48
   1b1RaggMw/ZMr4FnloODdE7+WXZuWbhFj7zRsh/EYK5bIV9a673JAkxp6
   E8XJA6nB4aOkyCiYVCUll8sG5G6eP0u7p2ibrECszu03ktdgPIe8dKZxd
   w==;
X-CSE-ConnectionGUID: rRz1mqcaTDqLMzj5ZiRXvg==
X-CSE-MsgGUID: JN7il901SkGiEDguWi0m1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31281445"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31281445"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:54 -0800
X-CSE-ConnectionGUID: OcNNUBwmQ4yr/dVU8S0xmQ==
X-CSE-MsgGUID: 8+L7Bm+ERdiuGObakp2fMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667684"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:48 -0800
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v7 10/10] x86/virt/tdx: Print TDX module version
Date: Mon, 11 Nov 2024 23:39:46 +1300
Message-ID: <6b5553756f56a8e3222bfc36d0bdb3e5192137b7.1731318868.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1731318868.git.kai.huang@intel.com>
References: <cover.1731318868.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the kernel doesn't print any TDX module version information.
In practice such information is useful, especially to the developers.

For instance:

1) When something goes wrong around using TDX, the module version is
   normally the first information the users want to know [1].

2) The users want to quickly know module version to see whether the
   loaded module is the expected one.

Dump TDX module version.  The actual dmesg will look like:

  virt/tdx: module version: 1.5.00.00.0481 (build_date 20230323).

And dump right after reading global metadata, so that this information is
printed no matter whether module initialization fails or not.

Link: https://lore.kernel.org/4b3adb59-50ea-419e-ad02-e19e8ca20dee@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9bc827a6cee8..6982e100536d 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -312,6 +312,23 @@ static void print_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
 	}
 }
 
+static void print_module_version(struct tdx_sys_info_version *version)
+{
+       /*
+	* TDX module version encoding:
+	*
+	*   <major>.<minor>.<update>.<internal>.<build_num>
+	*
+	* When printed as text, <major> and <minor> are 1-digit,
+	* <update> and <internal> are 2-digits and <build_num>
+	* is 4-digits.
+	*/
+	pr_info("module version: %u.%u.%02u.%02u.%04u (build_date %u).\n",
+			version->major_version,	 version->minor_version,
+			version->update_version, version->internal_version,
+			version->build_num,	 version->build_date);
+}
+
 static int init_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret;
@@ -322,6 +339,7 @@ static int init_tdx_sys_info(struct tdx_sys_info *sysinfo)
 
 	trim_null_tail_cmrs(&sysinfo->cmr);
 	print_cmrs(&sysinfo->cmr);
+	print_module_version(&sysinfo->version);
 
 	return 0;
 }
-- 
2.46.2


