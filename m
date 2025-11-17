Return-Path: <kvm+bounces-63318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E93C621E8
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 03:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B95D3ADE4A
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 02:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FEE274FEF;
	Mon, 17 Nov 2025 02:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzUN5VJ9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F8C274669;
	Mon, 17 Nov 2025 02:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763347141; cv=none; b=dyMjP0CXT6wFj0qcdSHEYite+1/jgvGmQxzO4n4eBebZYawGJSVcnVQwvD5v8ODr67TNybsnzod6XBQ8f5u4qj05f3ZsAcUwSvAWkbt55KRmZll610JDW7EXO5vqf/ZpBw6FwKvZh1F5G+8xiQE/T09oH61Ys8Ul7okckn02z+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763347141; c=relaxed/simple;
	bh=QTibGhtmwXwng57rlsbkwdBCg6bxoi+IDUdVq6vmjwc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b8t7CrDLaxvdKWOOdLzjcyX+irxz1Bdlponk26Lq41M/Xl8iXLDaQTQ0h8w0sU54haElZYVtE13Mi05c6MMmlT5eo+mkgMmKGJB+7HyWvvqbGpbZ22WR0xae+zuJV1m+IXtAXDqX2K9oSZxiub+QKX7HOsDnRanUpxtH+WiKY8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzUN5VJ9; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763347140; x=1794883140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QTibGhtmwXwng57rlsbkwdBCg6bxoi+IDUdVq6vmjwc=;
  b=bzUN5VJ9wP69C+221DntBuj1iWOY8thIFf6JCopoSnXLlFN+tEs71Uqe
   H8rv5Rnde5WesFZNB6hVpudhpDeN3kFmYvNBix7RFvcLEOoZem4buqoqd
   HCLIvcp/WEJEs7Gj3k74nWsckaaKr2RG8hnhstHHV+VAf4Q6mWz59/txr
   HYKehJOVxWdahSc77WNuVHLk02UWL42WPyJ+oTBH5qq58VFhh2mSHa7bM
   BLJDzozaflJu0M02Vc7JyYjn9K1swHoR7wFWdE72T1I7K7ugA2suF+uF7
   9n1ws4KOHElLOdgqoAxBY4ohOnt2pVpCX0hu1FekDPszvhWtuN4XVHBi7
   A==;
X-CSE-ConnectionGUID: 8GzryhD6QlCYtyZHjkh7Jw==
X-CSE-MsgGUID: 4xfgJTmxS4mAukQiiKSJsQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="82729589"
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="82729589"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2025 18:39:00 -0800
X-CSE-ConnectionGUID: PEqMfBZwSSGcK7vhgyWSAw==
X-CSE-MsgGUID: 4mutLJvWQ3CDOFFSdEXCgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,310,1754982000"; 
   d="scan'208";a="227658397"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa001.jf.intel.com with ESMTP; 16 Nov 2025 18:38:56 -0800
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
Subject: [PATCH v1 18/26] iommu/vt-d: Export a helper to do function for each dmar_drhd_unit
Date: Mon, 17 Nov 2025 10:23:02 +0800
Message-Id: <20251117022311.2443900-19-yilun.xu@linux.intel.com>
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

Enable the tdx-host module to get VTBAR address for every IOMMU device.
The VTBAR address is for TDX Module to identify the IOMMU device and
setup its trusted configuraion.

Suggested-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 include/linux/dmar.h       |  2 ++
 drivers/iommu/intel/dmar.c | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 692b2b445761..cd8d9f440975 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -86,6 +86,8 @@ extern struct list_head dmar_drhd_units;
 				dmar_rcu_check())			\
 		if (i=drhd->iommu, 0) {} else 
 
+int do_for_each_drhd_unit(int (*fn)(struct dmar_drhd_unit *));
+
 static inline bool dmar_rcu_check(void)
 {
 	return rwsem_is_locked(&dmar_global_lock) ||
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index e9d65b26ad64..645b72270967 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -2452,3 +2452,19 @@ bool dmar_platform_optin(void)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dmar_platform_optin);
+
+int do_for_each_drhd_unit(int (*fn)(struct dmar_drhd_unit *))
+{
+	struct dmar_drhd_unit *drhd;
+	int ret;
+
+	guard(rwsem_read)(&dmar_global_lock);
+
+	for_each_drhd_unit(drhd) {
+		ret = fn(drhd);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(do_for_each_drhd_unit);
-- 
2.25.1


