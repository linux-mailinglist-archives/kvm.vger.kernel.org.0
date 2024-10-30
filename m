Return-Path: <kvm+bounces-30081-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B8FA9B6C8F
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:02:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82F3D1C20A2F
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:02:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B756A21747B;
	Wed, 30 Oct 2024 19:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPXnq3Sr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5534B1F4738;
	Wed, 30 Oct 2024 19:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314860; cv=none; b=Fqknj3u32TTen+lQdCziN3uqwduk6xH1tZ7G9/9VQGtLxrlTsrkk4dV8RYFJ/yYrjDQNWr2PBRvwE62rfYgpXuANa07F0BN2o9HgYUZLdujpSldBygMX9p+O0Fa/aD0enwbJscxp0+puEAhUzoAVNyN2WLSlx1CXFHBt9vPa4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314860; c=relaxed/simple;
	bh=acNVo783QACSFNE9UVnReuXtxBaw25XkhCJyiieeobw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TApTUd0lIJ9P72NkPRFPpVONnApP/BhGUaNmufbXMsQ+JTpUw0hyjo2MxkazWu+TEdXab9PWYb4do0vwcpJxL/sJRnRLRSGuoQUtvgz/2a/ufNm2fJOlA6rbBKeG5lsfAikYSR169e4VyZYYCsK63NQinUW3gwZDWkJgeP9JwUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPXnq3Sr; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314858; x=1761850858;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=acNVo783QACSFNE9UVnReuXtxBaw25XkhCJyiieeobw=;
  b=IPXnq3Sr+83LR8fI7cEe20rYNZ712mBKTn0qBgJqxtTqBz+Ao/zDWuk/
   D7OU+066vVPlkQ54ZJ5Eb4ZAitXR8nUWSJ2u3BvDmoeYS8NB41lAmxB04
   u+hzTOrOGNXU7o0A8so1GQnuOwdNL/xCsUjCqiDiftmdUFdobUwJNytL6
   psVdts5BzKczs3JRFeNGrjA/uZ+T7jxDNuKt5nByXTbwSQ/o1IMoKbwHd
   /L2Y6wOFOj9qIiddkotNMQ2wv5DWJwxF1rUz12+AB8ISjQkKAlar4xtGY
   ucELqQgQGu4OiduO6YBviIz2DXUxad7Z3r3KrjzG6VPaF1GcTEX1gtfJB
   A==;
X-CSE-ConnectionGUID: mBXb2JsZTUisZYvXNLuIdQ==
X-CSE-MsgGUID: nqFcW63qQd+auDk/Q6xQHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678719"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678719"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:56 -0700
X-CSE-ConnectionGUID: T//1YEvYSIC4gEiJMnxUTQ==
X-CSE-MsgGUID: w1jPkm1uQai1hT9JrUu75Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499319"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:55 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com
Subject: [PATCH v2 03/25] x86/virt/tdx: Read essential global metadata for KVM
Date: Wed, 30 Oct 2024 12:00:16 -0700
Message-ID: <20241030190039.77971-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kai Huang <kai.huang@intel.com>

KVM needs two classes of global metadata to create and run TDX guests:

 - "TD Control Structures"
 - "TD Configurability"

The first class contains the sizes of TDX guest per-VM and per-vCPU
control structures.  KVM will need to use them to allocate enough space
for those control structures.

The second class contains info which reports things like which features
are configurable to TDX guest etc.  KVM will need to use them to
properly configure TDX guests.

Read them for KVM TDX to use.

The code change is auto-generated by re-running the script in [1] after
uncommenting the "td_conf" and "td_ctrl" part to regenerate the
tdx_global_metadata.{hc} and update them to the existing ones in the
kernel.

  #python tdx.py global_metadata.json tdx_global_metadata.h \
	tdx_global_metadata.c

The 'global_metadata.json' can be fetched from [2].

Link: https://lore.kernel.org/kvm/0853b155ec9aac09c594caa60914ed6ea4dc0a71.camel@intel.com/ [1]
Link: https://cdrdv2.intel.com/v1/dl/getContent/795381 [2]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v2:
 - New patch
---
 arch/x86/include/asm/tdx_global_metadata.h  | 19 +++++++++
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c | 46 +++++++++++++++++++++
 2 files changed, 65 insertions(+)

diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index fde370b855f1..206090c9952f 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -32,11 +32,30 @@ struct tdx_sys_info_cmr {
 	u64 cmr_size[32];
 };
 
+struct tdx_sys_info_td_ctrl {
+	u16 tdr_base_size;
+	u16 tdcs_base_size;
+	u16 tdvps_base_size;
+};
+
+struct tdx_sys_info_td_conf {
+	u64 attributes_fixed0;
+	u64 attributes_fixed1;
+	u64 xfam_fixed0;
+	u64 xfam_fixed1;
+	u16 num_cpuid_config;
+	u16 max_vcpus_per_td;
+	u64 cpuid_config_leaves[32];
+	u64 cpuid_config_values[32][2];
+};
+
 struct tdx_sys_info {
 	struct tdx_sys_info_version version;
 	struct tdx_sys_info_features features;
 	struct tdx_sys_info_tdmr tdmr;
 	struct tdx_sys_info_cmr cmr;
+	struct tdx_sys_info_td_ctrl td_ctrl;
+	struct tdx_sys_info_td_conf td_conf;
 };
 
 #endif
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 2fe57e084453..44c2b3e079de 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -76,6 +76,50 @@ static int get_tdx_sys_info_cmr(struct tdx_sys_info_cmr *sysinfo_cmr)
 	return ret;
 }
 
+static int get_tdx_sys_info_td_ctrl(struct tdx_sys_info_td_ctrl *sysinfo_td_ctrl)
+{
+	int ret = 0;
+	u64 val;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000000, &val)))
+		sysinfo_td_ctrl->tdr_base_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000100, &val)))
+		sysinfo_td_ctrl->tdcs_base_size = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9800000100000200, &val)))
+		sysinfo_td_ctrl->tdvps_base_size = val;
+
+	return ret;
+}
+
+static int get_tdx_sys_info_td_conf(struct tdx_sys_info_td_conf *sysinfo_td_conf)
+{
+	int ret = 0;
+	u64 val;
+	int i, j;
+
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000000, &val)))
+		sysinfo_td_conf->attributes_fixed0 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000001, &val)))
+		sysinfo_td_conf->attributes_fixed1 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000002, &val)))
+		sysinfo_td_conf->xfam_fixed0 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x1900000300000003, &val)))
+		sysinfo_td_conf->xfam_fixed1 = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000004, &val)))
+		sysinfo_td_conf->num_cpuid_config = val;
+	if (!ret && !(ret = read_sys_metadata_field(0x9900000100000008, &val)))
+		sysinfo_td_conf->max_vcpus_per_td = val;
+	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
+		if (!ret && !(ret = read_sys_metadata_field(0x9900000300000400 + i, &val)))
+			sysinfo_td_conf->cpuid_config_leaves[i] = val;
+	for (i = 0; i < sysinfo_td_conf->num_cpuid_config; i++)
+		for (j = 0; j < 2; j++)
+			if (!ret && !(ret = read_sys_metadata_field(0x9900000300000500 + i * 2 + j, &val)))
+				sysinfo_td_conf->cpuid_config_values[i][j] = val;
+
+	return ret;
+}
+
 static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 {
 	int ret = 0;
@@ -84,6 +128,8 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	ret = ret ?: get_tdx_sys_info_features(&sysinfo->features);
 	ret = ret ?: get_tdx_sys_info_tdmr(&sysinfo->tdmr);
 	ret = ret ?: get_tdx_sys_info_cmr(&sysinfo->cmr);
+	ret = ret ?: get_tdx_sys_info_td_ctrl(&sysinfo->td_ctrl);
+	ret = ret ?: get_tdx_sys_info_td_conf(&sysinfo->td_conf);
 
 	return ret;
 }
-- 
2.47.0


