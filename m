Return-Path: <kvm+bounces-19741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C480F909D35
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 14:03:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8B11C209D4
	for <lists+kvm@lfdr.de>; Sun, 16 Jun 2024 12:03:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40AA18F2E1;
	Sun, 16 Jun 2024 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SMZKnXCd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C5B18F2C8;
	Sun, 16 Jun 2024 12:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718539318; cv=none; b=ZbZpZTsi4cs52vYWu7qfOkqVePXeKTyhVn0yI4fkvu3UMTm7ze2FNAOAGHPk6xE8BL4DcF7v/NboeYWTuNQYs+nKaCMufl822jU8XdDxeWSjp4yttrds5uqMhJrAKk5lhhsv0YbjM4T1pUddRFfoxUBAHojpd1kkDleO5YvIWbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718539318; c=relaxed/simple;
	bh=GkDMHFREUSNasjUMb5V5YXtvJUS3nNxD/1yXJSwUY/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc4Cir53CiM/JqOPIQu2nWkFkZ4Y4NU/IctESpqRO9mW2gfkjsTtaiEIbXMMGGTlWAsCF03eIgdRBWjrp7E+BlOBhCRnNLCkfO3ZW7El2PP+K7M1wRemGFRTEB3D+C+Pw5NN/ONicueIilqj+GOeN2AQz56AV8lpWoEIPMCbF30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SMZKnXCd; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718539317; x=1750075317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GkDMHFREUSNasjUMb5V5YXtvJUS3nNxD/1yXJSwUY/A=;
  b=SMZKnXCd6zRlSuuSlLi1SIBsJCNFYPf6dNRtcc94mDJJQCp+AVl1LsbN
   EsbadkcWH/B2VZpvnoOgA4kDbpibOsoo9nuCY/mQusbSsYtDWBtNZiz9d
   58Nt+pFGpU0mrkZz15BhfwkgR5MVM6wcyr0MtCLTzpn0TW64ddw8nGBt4
   m5qVuYliiMv0/WP2IGiT5d9yJehxhdXSn+sE+z1qhAvy62TUC0ZrGwEa4
   JbNPZqNO63E9zAw5kG3UYR11S7OGm0S9vdQ62O/8aBJy64v+wbXZm1ws7
   oUNK8CC6/7d6jmjuCr94FAy1H1gHbNZGE4LcOck+pH4F0KzzOZ2uW+TV3
   w==;
X-CSE-ConnectionGUID: KEfVdNRKTxGHajUklKRCbg==
X-CSE-MsgGUID: HWs2Aat1T3m693nt5Q6Qgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11104"; a="26800015"
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="26800015"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:57 -0700
X-CSE-ConnectionGUID: nyGf/4kKSYue1fTMWZCKrQ==
X-CSE-MsgGUID: fjieSrYpRc6y5rrBztb9SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,242,1712646000"; 
   d="scan'208";a="46055849"
Received: from mgoodin-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.226])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2024 05:01:54 -0700
From: Kai Huang <kai.huang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kirill.shutemov@linux.intel.com,
	rick.p.edgecombe@intel.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org,
	isaku.yamahata@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH 4/9] x86/virt/tdx: Abstract reading multiple global metadata fields as a helper
Date: Mon, 17 Jun 2024 00:01:14 +1200
Message-ID: <dd4ab4f97fc12780e4052f7ece94ceadffafd24d.1718538552.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1718538552.git.kai.huang@intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For now the kernel only reads "TD Memory Region" (TDMR) related global
metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
module.  Future changes will need to read other metadata fields that
don't make sense to populate to the "struct tdx_tdmr_sysinfo".

Now the code in get_tdx_tdmr_sysinfo() to read multiple global metadata
fields is not bound to the 'struct tdx_tdmr_sysinfo', and can support
reading all metadata element sizes.  Abstract this code as a helper for
future use.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4392e82a9bcb..c68fbaf4aa15 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -304,6 +304,21 @@ struct field_mapping {
 	  .offset   = offsetof(_struct, _member),		\
 	  .size	    = sizeof(typeof(((_struct *)0)->_member)) }
 
+static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
+				  int nr_fields, void *stbuf)
+{
+	int i, ret;
+
+	for (i = 0; i < nr_fields; i++) {
+		ret = stbuf_read_sysmd_field(fields[i].field_id, stbuf,
+				      fields[i].offset, fields[i].size);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
 
@@ -318,18 +333,8 @@ static const struct field_mapping fields[] = {
 
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 {
-	int ret;
-	int i;
-
 	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
-	for (i = 0; i < ARRAY_SIZE(fields); i++) {
-		ret = stbuf_read_sysmd_field(fields[i].field_id, tdmr_sysinfo,
-				fields[i].offset, fields[i].size);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
+	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
 }
 
 /* Calculate the actual TDMR size */
-- 
2.43.2


