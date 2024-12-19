Return-Path: <kvm+bounces-34152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4F69F7C81
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 14:37:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 554B916B5DB
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 13:35:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F971171C;
	Thu, 19 Dec 2024 13:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G/XiPXPE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C568679F2
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 13:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734615340; cv=none; b=G5R6l0zRCwAvaw47p2/IIlfACbVRgnawLs5vnNFUj2gbQ3MNBZxh8kxmvpvjgYMqpYyLlTYXD2RkZitBrN0MV9fdofH49PNOGYxg+O3rCdaprxVja9We6jV7sDgFWB3SyA2wsJUY4kPULXSulQN0uDYdEVfXez9rEaIg+G1gGtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734615340; c=relaxed/simple;
	bh=DPzSxv9vMP7mIpXdsVlzuxzRhKS8p8nA3AZc3wGiDlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cGDac4l/iH5yZbHUq9l7DTv25IoMHJBDQxW79+/yAYzckMsY0UpAm6ii4ozBQYxlFMWXLclVjxjdIa5LKEQjSD94SfOHCC/EQ782gN5vKJn7rP+kvWCxwhitYf/qO9UHgycylgxEZ3z60IZxyLSptmwy0iSQ8ancFVMkoDRGWhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G/XiPXPE; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734615338; x=1766151338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DPzSxv9vMP7mIpXdsVlzuxzRhKS8p8nA3AZc3wGiDlM=;
  b=G/XiPXPEfk25zZCaqv8+vfIzqlUldongzX4bAfapptmjq3EfHcVquWc7
   kdLKItndXm+nSRV8qgJXqTDlw8ZsSZ5s/CYrNGMnCsMX7htphq1K4hTFv
   6eat+A9/bBsh8T/ufA0AmpPwHzWEIl3XfOFh7mqA6RCNFn0xl0ric5dVS
   /KUFmLNMQAW5Rg45tygvuWudWXD60hjy5AM8aDfN2r0nN3MuIo7Akc4+w
   KasJhzfGXQPWvcbHk+iZvzaclw6m6/vDQdF0ee2XQtiyGpe8CKYyRABAb
   VSnXCCEboP1wrcoWJzfWMicuKUa2+DQ5taZTbh7y0ivyjvBBBJJo4jMIJ
   g==;
X-CSE-ConnectionGUID: g0ZndZuySomSACGa/JNLCQ==
X-CSE-MsgGUID: 5Z7RXJIgSxyXHBQKWxPUMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11290"; a="60504298"
X-IronPort-AV: E=Sophos;i="6.12,247,1728975600"; 
   d="scan'208";a="60504298"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2024 05:35:37 -0800
X-CSE-ConnectionGUID: xH0wpkPYSbSDnEByFQUdrg==
X-CSE-MsgGUID: XCImA4HBQR6Ngs0T3whgXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103197877"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by orviesa005.jf.intel.com with ESMTP; 19 Dec 2024 05:35:37 -0800
From: Yi Liu <yi.l.liu@intel.com>
To: alex.williamson@redhat.com,
	kevin.tian@intel.com
Cc: jgg@nvidia.com,
	eric.auger@redhat.com,
	nicolinc@nvidia.com,
	kvm@vger.kernel.org,
	yi.l.liu@intel.com,
	chao.p.peng@linux.intel.com,
	zhenzhong.duan@intel.com,
	willy@infradead.org,
	zhangfei.gao@linaro.org,
	vasant.hegde@amd.com
Subject: [PATCH v6 1/5] ida: Add ida_find_first_range()
Date: Thu, 19 Dec 2024 05:35:30 -0800
Message-Id: <20241219133534.16422-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241219133534.16422-1-yi.l.liu@intel.com>
References: <20241219133534.16422-1-yi.l.liu@intel.com>
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
of a range and two variants based on it.

Caller can check if a given ID is allocated or not by:

	bool ida_exists(struct ida *ida, unsigned int id)

Caller can iterate all allocated IDs by:

	int id;
	while ((id = ida_find_first(&pasid_ida)) >= 0) {
		//anything to do with the allocated ID
		ida_free(pasid_ida, pasid);
	}

Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
---
 include/linux/idr.h | 11 +++++++
 lib/idr.c           | 67 +++++++++++++++++++++++++++++++++++++++++++
 lib/test_ida.c      | 70 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index da5f5fa4a3a6..718f9b1b91af 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -257,6 +257,7 @@ struct ida {
 int ida_alloc_range(struct ida *, unsigned int min, unsigned int max, gfp_t);
 void ida_free(struct ida *, unsigned int id);
 void ida_destroy(struct ida *ida);
+int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max);
 
 /**
  * ida_alloc() - Allocate an unused ID.
@@ -328,4 +329,14 @@ static inline bool ida_is_empty(const struct ida *ida)
 {
 	return xa_empty(&ida->xa);
 }
+
+static inline bool ida_exists(struct ida *ida, unsigned int id)
+{
+	return ida_find_first_range(ida, id, id) == id;
+}
+
+static inline int ida_find_first(struct ida *ida)
+{
+	return ida_find_first_range(ida, 0, ~0);
+}
 #endif /* __IDR_H__ */
diff --git a/lib/idr.c b/lib/idr.c
index da36054c3ca0..e2adc457abb4 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -476,6 +476,73 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 }
 EXPORT_SYMBOL(ida_alloc_range);
 
+/**
+ * ida_find_first_range - Get the lowest used ID.
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
+int ida_find_first_range(struct ida *ida, unsigned int min, unsigned int max)
+{
+	unsigned long index = min / IDA_BITMAP_BITS;
+	unsigned int offset = min % IDA_BITMAP_BITS;
+	unsigned long *addr, size, bit;
+	unsigned long tmp = 0;
+	unsigned long flags;
+	void *entry;
+	int ret;
+
+	if ((int)min < 0)
+		return -EINVAL;
+	if ((int)max < 0)
+		max = INT_MAX;
+
+	xa_lock_irqsave(&ida->xa, flags);
+
+	entry = xa_find(&ida->xa, &index, max / IDA_BITMAP_BITS, XA_PRESENT);
+	if (!entry) {
+		ret = -ENOENT;
+		goto err_unlock;
+	}
+
+	if (index > min / IDA_BITMAP_BITS)
+		offset = 0;
+	if (index * IDA_BITMAP_BITS + offset > max) {
+		ret = -ENOENT;
+		goto err_unlock;
+	}
+
+	if (xa_is_value(entry)) {
+		tmp = xa_to_value(entry);
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
+		return -ENOENT;
+
+	return index * IDA_BITMAP_BITS + bit;
+
+err_unlock:
+	xa_unlock_irqrestore(&ida->xa, flags);
+	return ret;
+}
+EXPORT_SYMBOL(ida_find_first_range);
+
 /**
  * ida_free() - Release an allocated ID.
  * @ida: IDA handle.
diff --git a/lib/test_ida.c b/lib/test_ida.c
index c80155a1956d..63078f8dc13f 100644
--- a/lib/test_ida.c
+++ b/lib/test_ida.c
@@ -189,6 +189,75 @@ static void ida_check_bad_free(struct ida *ida)
 	IDA_BUG_ON(ida, !ida_is_empty(ida));
 }
 
+/*
+ * Check ida_find_first_range() and varriants.
+ */
+static void ida_check_find_first(struct ida *ida)
+{
+	/* IDA is empty; all of the below should be not exist */
+	IDA_BUG_ON(ida, ida_exists(ida, 0));
+	IDA_BUG_ON(ida, ida_exists(ida, 3));
+	IDA_BUG_ON(ida, ida_exists(ida, 63));
+	IDA_BUG_ON(ida, ida_exists(ida, 1023));
+	IDA_BUG_ON(ida, ida_exists(ida, (1 << 20) - 1));
+
+	/* IDA contains a single value entry */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 3, GFP_KERNEL) != 3);
+	IDA_BUG_ON(ida, ida_exists(ida, 0));
+	IDA_BUG_ON(ida, !ida_exists(ida, 3));
+	IDA_BUG_ON(ida, ida_exists(ida, 63));
+	IDA_BUG_ON(ida, ida_exists(ida, 1023));
+	IDA_BUG_ON(ida, ida_exists(ida, (1 << 20) - 1));
+
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 63, GFP_KERNEL) != 63);
+	IDA_BUG_ON(ida, ida_exists(ida, 0));
+	IDA_BUG_ON(ida, !ida_exists(ida, 3));
+	IDA_BUG_ON(ida, !ida_exists(ida, 63));
+	IDA_BUG_ON(ida, ida_exists(ida, 1023));
+	IDA_BUG_ON(ida, ida_exists(ida, (1 << 20) - 1));
+
+	/* IDA contains a single bitmap */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, 1023, GFP_KERNEL) != 1023);
+	IDA_BUG_ON(ida, ida_exists(ida, 0));
+	IDA_BUG_ON(ida, !ida_exists(ida, 3));
+	IDA_BUG_ON(ida, !ida_exists(ida, 63));
+	IDA_BUG_ON(ida, !ida_exists(ida, 1023));
+	IDA_BUG_ON(ida, ida_exists(ida, (1 << 20) - 1));
+
+	/* IDA contains a tree */
+	IDA_BUG_ON(ida, ida_alloc_min(ida, (1 << 20) - 1, GFP_KERNEL) != (1 << 20) - 1);
+	IDA_BUG_ON(ida, ida_exists(ida, 0));
+	IDA_BUG_ON(ida, !ida_exists(ida, 3));
+	IDA_BUG_ON(ida, !ida_exists(ida, 63));
+	IDA_BUG_ON(ida, !ida_exists(ida, 1023));
+	IDA_BUG_ON(ida, !ida_exists(ida, (1 << 20) - 1));
+
+	/* Now try to find first */
+	IDA_BUG_ON(ida, ida_find_first(ida) != 3);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, -1, 2) != -EINVAL);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 0, 2) != -ENOENT); // no used ID
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 0, 3) != 3);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 1, 3) != 3);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 3, 3) != 3);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 2, 4) != 3);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 4, 3) != -ENOENT); // min > max, fail
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 4, 60) != -ENOENT); // no used ID
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 4, 64) != 63);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 63, 63) != 63);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 64, 1026) != 1023);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 1023, 1023) != 1023);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 1023, (1 << 20) - 1) != 1023);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, 1024, (1 << 20) - 1) != (1 << 20) - 1);
+	IDA_BUG_ON(ida, ida_find_first_range(ida, (1 << 20), INT_MAX) != -ENOENT);
+
+	ida_free(ida, 3);
+	ida_free(ida, 63);
+	ida_free(ida, 1023);
+	ida_free(ida, (1 << 20) - 1);
+
+	IDA_BUG_ON(ida, !ida_is_empty(ida));
+}
+
 static DEFINE_IDA(ida);
 
 static int ida_checks(void)
@@ -202,6 +271,7 @@ static int ida_checks(void)
 	ida_check_max(&ida);
 	ida_check_conv(&ida);
 	ida_check_bad_free(&ida);
+	ida_check_find_first(&ida);
 
 	printk("IDA: %u of %u tests passed\n", tests_passed, tests_run);
 	return (tests_run != tests_passed) ? 0 : -EINVAL;
-- 
2.34.1


