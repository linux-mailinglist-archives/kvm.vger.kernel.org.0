Return-Path: <kvm+bounces-14410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA8A88A292B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71BAC282051
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AD09502A9;
	Fri, 12 Apr 2024 08:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CUAZmbE7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD41E4F200
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 08:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712910087; cv=none; b=OdSLbZQrNTaWIqVROcIlQ/vaC/3g1+6l3s0fdd6GwkgWBFltrvGNPcY089zD4qDiI//wsHedzJiDWv6P3x5y9jWsHwrCfz0i2YyE92sYjfcKpqea7dSG9KDaphUqHaPNGSaN0ccR81dYr2P/4j9bnKGzJ3DcJ2fHzx9Dd1+ofSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712910087; c=relaxed/simple;
	bh=J9o3x43TbGr2JUn0TLrAoMDW7Sz3u0xuDfohbhTmsXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=biv5gOwNXjBNNNEztNN6VPvqtoxUvMdITSty0S0OoMmNHkcmGsw1H1IQULYemcvVUpwJm80x+HssBvfideU8KWNySH132Sgr3aqaCZ23NbWxujMmxLK7SyqOmvC6tz8WH+/0yKCuZkYwz/qBbKzXmCbZ9u5xCKMlCGjIgKeEHuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CUAZmbE7; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712910085; x=1744446085;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J9o3x43TbGr2JUn0TLrAoMDW7Sz3u0xuDfohbhTmsXA=;
  b=CUAZmbE7RQqMLZSJ8Sx5Is0ZOIfVtx4MxDN3XUnFx//2/7QlgEljwOrq
   DLG4KM1eizvObDrwks27kKP+tUdN5zdwceiK1ICUqNsxQCo+JuklA/7Tl
   sGgynMYV8wKuP38oKIUSdlnxcJzCImPHByBd5JX21gcD8sYW6mHXVag17
   mrKXZXbPcMA9uZBD/S9tS/RLbveQfk2MMPZ539lhoH3x1dMPDVg5kt5sU
   XXdOEZspISuQjFZp/TvfGef6HXbO86kDq34exxlMfNDHn/NI4qMbcE+Mo
   mo4IcNeutS1GbJQN2cIjuQO9XVYN79YpId4Prf3yYtAA8Ez+q1IChR5dC
   A==;
X-CSE-ConnectionGUID: cI0mlL3IRyePlMYsO196QQ==
X-CSE-MsgGUID: HdPPVtuiR62tZmkc3PpxGw==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="19069400"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="19069400"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 01:21:23 -0700
X-CSE-ConnectionGUID: wqJn8sOjTB23aFVZoWCV1w==
X-CSE-MsgGUID: 4TYuzYl+SUqu4LzzqjBcxQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="25836249"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa003.jf.intel.com with ESMTP; 12 Apr 2024 01:21:23 -0700
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: joro@8bytes.org,
	robin.murphy@arm.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com,
	yi.l.liu@intel.com,
	iommu@lists.linux.dev,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	jacob.jun.pan@intel.com,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 1/4] ida: Add ida_get_lowest()
Date: Fri, 12 Apr 2024 01:21:18 -0700
Message-Id: <20240412082121.33382-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412082121.33382-1-yi.l.liu@intel.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no helpers for user to check if a given ID is allocated or not,
neither a helper to loop all the allocated IDs in an IDA and do something
for cleanup. With the two needs, a helper to get the lowest allocated ID
of a range can help to achieve it.

Caller can check if a given ID is allocated or not by:
	int id = 200, rc;

	rc = ida_get_lowest(&ida, id, id);
	if (rc == id)
		//id 200 is used
	else
		//id 200 is not used

Caller can iterate all allocated IDs by:
	int id = 0;

	while (!ida_is_empty(&pasid_ida)) {
		id = ida_get_lowest(pasid_ida, id, INT_MAX);
		if (id < 0)
			break;
		//anything to do with the allocated ID
		ida_free(pasid_ida, pasid);
	}

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/linux/idr.h |  1 +
 lib/idr.c           | 67 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index da5f5fa4a3a6..1dae71d4a75d 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -257,6 +257,7 @@ struct ida {
 int ida_alloc_range(struct ida *, unsigned int min, unsigned int max, gfp_t);
 void ida_free(struct ida *, unsigned int id);
 void ida_destroy(struct ida *ida);
+int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max);
 
 /**
  * ida_alloc() - Allocate an unused ID.
diff --git a/lib/idr.c b/lib/idr.c
index da36054c3ca0..03e461242fe2 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -476,6 +476,73 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 }
 EXPORT_SYMBOL(ida_alloc_range);
 
+/**
+ * ida_get_lowest - Get the lowest used ID.
+ * @ida: IDA handle.
+ * @min: Lowest ID to get.
+ * @max: Highest ID to get.
+ *
+ * Get the lowest used ID between @min and @max, inclusive.  The returned
+ * ID will not exceed %INT_MAX, even if @max is larger.
+ *
+ * Context: Any context. Takes and releases the xa_lock.
+ * Return: The lowest used ID, or errno if no used ID is found.
+ */
+int ida_get_lowest(struct ida *ida, unsigned int min, unsigned int max)
+{
+	unsigned long index = min / IDA_BITMAP_BITS;
+	unsigned int offset = min % IDA_BITMAP_BITS;
+	unsigned long *addr, size, bit;
+	unsigned long flags;
+	void *entry;
+	int ret;
+
+	if (min >= INT_MAX)
+		return -EINVAL;
+	if (max >= INT_MAX)
+		max = INT_MAX;
+
+	xa_lock_irqsave(&ida->xa, flags);
+
+	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
+	if (!entry) {
+		ret = -ENOTTY;
+		goto err_unlock;
+	}
+
+	if (index > min / IDA_BITMAP_BITS)
+		offset = 0;
+	if (index * IDA_BITMAP_BITS + offset > max) {
+		ret = -ENOTTY;
+		goto err_unlock;
+	}
+
+	if (xa_is_value(entry)) {
+		unsigned long tmp = xa_to_value(entry);
+
+		addr = &tmp;
+		size = BITS_PER_XA_VALUE;
+	} else {
+		addr = ((struct ida_bitmap *)entry)->bitmap;
+		size = IDA_BITMAP_BITS;
+	}
+
+	bit = find_next_bit(addr, size, offset);
+
+	xa_unlock_irqrestore(&ida->xa, flags);
+
+	if (bit == size ||
+	    index * IDA_BITMAP_BITS + bit > max)
+		return -ENOTTY;
+
+	return index * IDA_BITMAP_BITS + bit;
+
+err_unlock:
+	xa_unlock_irqrestore(&ida->xa, flags);
+	return ret;
+}
+EXPORT_SYMBOL(ida_get_lowest);
+
 /**
  * ida_free() - Release an allocated ID.
  * @ida: IDA handle.
-- 
2.34.1


