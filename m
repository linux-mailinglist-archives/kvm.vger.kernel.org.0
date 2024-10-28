Return-Path: <kvm+bounces-29844-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DD39C9B309D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:44:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55ED1B2285D
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:44:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66DA41DE2A1;
	Mon, 28 Oct 2024 12:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zsr6xoHs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8283B1DDA3D;
	Mon, 28 Oct 2024 12:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119316; cv=none; b=G0X9yLc7JRTA5/emfxEeAOdE4gwZy+gQsOua7Pb8+HQfxO2y4lV/8gS3kPyVRRNvRSUOZJ3pT7W/J8hj9X+3/mhPM8FpCXiVVaAN8wJVcoZKs9D4KP49bljz8zu5weaBNvtFgnwxqq43xS+212Gr9h8jeR/pUFbrAVlF/X08S5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119316; c=relaxed/simple;
	bh=dbEwOeZLWbtfj3Idsrbh8dS2ndV48vJaSFF7rAbMt00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5DnWHs/E11nXbsNjhqtM5NSAx/R8eXDuMx8u3PoEdVL5BFAWlEXL1R1zBdJTQGFTTFnBzqU/QTqRXzRsLJozlkm7NJCO0JogPuQEp+6h4/4HjLOongMgLV/ecOmUxHerQrviCi3Bk7SSmYAI2odT/ffxV/LnVoWwFUftzKKwEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zsr6xoHs; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119314; x=1761655314;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dbEwOeZLWbtfj3Idsrbh8dS2ndV48vJaSFF7rAbMt00=;
  b=Zsr6xoHsM/gqpMz1f9tga6TwDWWKam6V9q8aAjDeAEhtnvv3wmnBeZ3E
   QmzTr9RhhXkR3Z7SyTMs31vfnvb9ruMvJbD/KpMshsDxrRqe+9s831L6W
   nTEeHHm8rSaMfrnexk0ebCVAMYSgnKCiI5Vs7cN8TsxkA8wY8incHvoyc
   jMSem7bFEn+urx4FN5stbLItEJdGZfYjOPaJVioHVB0DaKccDQxvewwgl
   or8W3bYMoYXmh87gDROaa/LhP3suUywWbto9iRx6qY0pfPboaBecihjz2
   WdhuQFhssvHit/sQydjDANb6OHFp3sOsboyRjtrjY9wbVxEh3EkNbN9/6
   w==;
X-CSE-ConnectionGUID: Cs6Rg1DbSo6T5woxc2sFfg==
X-CSE-MsgGUID: mK8+tJFDTym81/ihRM93IA==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575306"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575306"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:54 -0700
X-CSE-ConnectionGUID: ybLgAxg8RcGNcMT0EOwAZg==
X-CSE-MsgGUID: Ur7js3MBQgy7mBqHvo/pXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420933"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:50 -0700
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
Subject: [PATCH v6 07/10] x86/virt/tdx: Trim away tail null CMRs
Date: Tue, 29 Oct 2024 01:41:09 +1300
Message-ID: <03e8e509f8a6c298807af771ebf1a37a82660565.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
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


