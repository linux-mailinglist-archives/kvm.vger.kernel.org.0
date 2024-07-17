Return-Path: <kvm+bounces-21750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69C969335B7
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19EB41F23418
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E06C182B9;
	Wed, 17 Jul 2024 03:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qdbqqj9e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F2818EBF;
	Wed, 17 Jul 2024 03:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187662; cv=none; b=iIDYNWGEdO9KNwhppxDPd2hLV7bll76VUnAzGz4/A8n89IfWCqnemac8A7Z/8FRI+2TwyGb00Le05DEanjdSLxwP8TcXsNlWzl6qhcTEuhse/n+JUUiJHCObpwRuDfP/pSCKyuejesjADt3WuGPxRjhFTH5IG1USJHG7fKdl918=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187662; c=relaxed/simple;
	bh=h3e8pjgzVwqyW4ZTTNX7wyIE8YhVs1gALZoIAPRddgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho3U85kmmUhrtQtGK7me7PlftnY9bqh8DxXvNYVm38pr8SW0ERjRNaxcL8yqlYamsQXU9ia/S+4dKGcgYEFORpqyBL8oNdUAZquhStupq+60fWzocHTAs/RorkD5S2GWy6X5LW70zDTr3pZkMsXpQLRN/BvLbq+w2+aYbg+lXYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qdbqqj9e; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187661; x=1752723661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h3e8pjgzVwqyW4ZTTNX7wyIE8YhVs1gALZoIAPRddgE=;
  b=Qdbqqj9eKD+1SV/Xj+jBVJ1tz7KPq+4BsSbyTGXfjQRdGe+a7EQH1IXc
   M3iMNoyOWaAri31gUaN5NAWeZIOYVWDJzngpeG7XbIGx5WfGrUx7XOq8R
   Za3Yc13PZtTJj6efYyCeRx84eP4tKQRq1ZTGrqqA59HLPY+yY33bXVpWY
   4+hieSfO1Vf421qSAdqju3nrrnCQmAnDWlIIXyLArTegP9Mrn+CbzC3/h
   rpdK+cPAY0b+8oC1HmGhFs1FDQu2CcsjXQsRl0ERgJYLMS2H0HhlKJSSs
   +JocmHxW3ukyh/ilxpT3dzaqipflp3dd3RvI0YSY45okSYNxmA8fZEckq
   w==;
X-CSE-ConnectionGUID: 1QcLF/+RQCS8j4M1OTvfqQ==
X-CSE-MsgGUID: 32ccVNu0RqmfI6oD0iMv2g==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512391"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512391"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:50 -0700
X-CSE-ConnectionGUID: U+FkLDI9RqaMxLH1+YUJnA==
X-CSE-MsgGUID: I0nfvcbFSAeTPjfSUY0Efg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566719"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:46 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	dan.j.williams@intel.com
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH v2 04/10] x86/virt/tdx: Abstract reading multiple global metadata fields as a helper
Date: Wed, 17 Jul 2024 15:40:11 +1200
Message-ID: <b33f7ad2bde3e45185ffe00cfb3216ae3e260c85.1721186590.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
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
index 4644b324ff86..50d49c539e63 100644
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
2.45.2


