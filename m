Return-Path: <kvm+bounces-31446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D459C3C44
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 11:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76A191F22561
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 10:44:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FFFB199FC9;
	Mon, 11 Nov 2024 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FeOE1+oe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5B219F10A;
	Mon, 11 Nov 2024 10:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731321641; cv=none; b=IpL83H69BtpoKvwEzijFNpn4q7s3ufM/oYmIzGBPSpPtZd0QK/f4G5S/6wBByKjAs36CWhLM8uJM/26RRWc3o6212Q9cCTI+fYgLufi6W2GXJIDFfmQn/8wStQ+J4TW5YP2QYWhU5Q1KaWHBwTPp88uMRdimwXYkiuFx3P+/6d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731321641; c=relaxed/simple;
	bh=aZ8+f4GROkZqKaKg5wu8PQ8kGTjZHQoa0vIdMvSYgZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oR6fvBjBdBrSHwwuugklFhfoMO4lp7LVrbRLr0BC58C+ZTN9eGHihYeTsYgWKHLIBIyOYj7Ypcj1xGDkum9kfDEB4t95L72mbsvYCNRHSgUjvb3MrLwgT+FbA03kXKHvgyYQcIKn2uLvMDQFjDHCSlkh2d6J1DgIKRi0LEai9yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FeOE1+oe; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731321641; x=1762857641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aZ8+f4GROkZqKaKg5wu8PQ8kGTjZHQoa0vIdMvSYgZU=;
  b=FeOE1+oefrGUqr7E7Y4KUzC3HwNNg1On8BGSEhFmwrimZCyoTaPqJqmz
   IFylviw7EAO02XmwKuickhi5GcI0Kn+2pAX43HHfMif6dr7WyHu+u5hmM
   nHrx0mDIpgeavjG/fpEARtcZ/jkkfIXSshZwNyrg8fPcb+xXwm2CG4Frx
   c+EOGN2X/wEyr591qTrlCdVvb8NyFJWTre0UqmLfco2CxQFhOMABeeD8Q
   wvFc/RxLDC4JTTtHr0gLfJCgjopcliIdNR5t3JLT+shrxCRYKSbK4/2dc
   zMYH6n258xw3Ngnpz/tTCXoKybeYC4NvVUWYIvSXUpQy++090+AaiElRI
   A==;
X-CSE-ConnectionGUID: OQM0cnwLSpekHPNVHZ9Kdw==
X-CSE-MsgGUID: 4IlD9C3QSLO1xyMovugs8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41682712"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41682712"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:40 -0800
X-CSE-ConnectionGUID: pK6plwuhS4WVakTI/nvndQ==
X-CSE-MsgGUID: tWgoqvApTS+buOhb7UiBnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,144,1728975600"; 
   d="scan'208";a="117667571"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.207])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 02:40:36 -0800
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
Subject: [PATCH v7 07/10] x86/virt/tdx: Trim away tail null CMRs
Date: Mon, 11 Nov 2024 23:39:43 +1300
Message-ID: <fba5b229f4e0a80aa8bb1001c1aa27fddec5f172.1731318868.git.kai.huang@intel.com>
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

TDX architecturally supports up to 32 CMRs.  The global metadata field
"NUM_CMRS" reports the number of CMR entries that can be read by the
kernel.  However, that field may just report the maximum number of CMRs
albeit the actual number of CMRs is smaller, in which case there are
tail null CMRs (size is 0).

Trim away those null CMRs, and print valid CMRs since they are useful
at least to developers.

More information about CMR can be found at "Intel TDX ISA Background:
Convertible Memory Ranges (CMRs)" in TDX 1.5 base spec [1], and
"CMR_INFO" in TDX 1.5 ABI spec [2].

Now get_tdx_sys_info() just reads kernel-needed global metadata to
kernel structure, and it is auto-generated.  Add a wrapper function
init_tdx_sys_info() to invoke get_tdx_sys_info() and provide room to do
additional things like dealing with CMRs.

Link: https://cdrdv2.intel.com/v1/dl/getContent/733575 [1]
Link: https://cdrdv2.intel.com/v1/dl/getContent/733579 [2]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 56 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 43ec56db5084..e81bdcfc20bf 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -272,6 +272,60 @@ static int read_sys_metadata_field(u64 field_id, u64 *data)
 
 #include "tdx_global_metadata.c"
 
+/* Update the @sysinfo_cmr->num_cmrs to trim tail null CMRs */
+static void trim_null_tail_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
+{
+	int i;
+
+	/*
+	 * The TDX module may report the maximum number of CMRs that
+	 * TDX architecturally supports as the actual number of CMRs,
+	 * despite the latter is smaller.  In this case some tail
+	 * CMR(s) will be null (size is 0).  Trim them away.
+	 *
+	 * Note the CMRs are generated by the BIOS, but the MCHECK
+	 * verifies CMRs before enabling TDX on hardware.  Skip other
+	 * sanity checks (e.g., verify CMR is 4KB aligned) but trust
+	 * MCHECK to work properly.
+	 *
+	 * The spec doesn't say whether it's legal to have null CMRs
+	 * in the middle of valid CMRs.  For now assume no sane BIOS
+	 * would do that (even MCHECK allows).
+	 */
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++)
+		if (!sysinfo_cmr->cmr_size[i])
+			break;
+
+	sysinfo_cmr->num_cmrs = i;
+}
+
+static void print_cmrs(struct tdx_sys_info_cmr *sysinfo_cmr)
+{
+	int i;
+
+	for (i = 0; i < sysinfo_cmr->num_cmrs; i++) {
+		u64 cmr_base = sysinfo_cmr->cmr_base[i];
+		u64 cmr_size = sysinfo_cmr->cmr_size[i];
+
+		pr_info("CMR[%d]: [0x%llx, 0x%llx)\n", i, cmr_base,
+				cmr_base + cmr_size);
+	}
+}
+
+static int init_tdx_sys_info(struct tdx_sys_info *sysinfo)
+{
+	int ret;
+
+	ret = get_tdx_sys_info(sysinfo);
+	if (ret)
+		return ret;
+
+	trim_null_tail_cmrs(&sysinfo->cmr);
+	print_cmrs(&sysinfo->cmr);
+
+	return 0;
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1051,7 +1105,7 @@ static int init_tdx_module(void)
 	struct tdx_sys_info sysinfo;
 	int ret;
 
-	ret = get_tdx_sys_info(&sysinfo);
+	ret = init_tdx_sys_info(&sysinfo);
 	if (ret)
 		return ret;
 
-- 
2.46.2


