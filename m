Return-Path: <kvm+bounces-38312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70E85A37227
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 06:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AFD447A3DF4
	for <lists+kvm@lfdr.de>; Sun, 16 Feb 2025 05:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC4A14EC7E;
	Sun, 16 Feb 2025 05:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OFRmrrA3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77764C70
	for <kvm@vger.kernel.org>; Sun, 16 Feb 2025 05:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739684803; cv=none; b=u4pGwHwt6XBsY9aCZx8BVjuCx5AENS5qbiKW/9+J8A3i/B7U8CIxGAdiamfn3g7RVvFUwkJWDJquN7RXPruYimdh7haHbEGbt7drjuR6e/HwUMoV4CoenHcaJDPJnemAI8lvNAJHU+Yl7sYDDLoTKZW0Ui4Yx4jnqn/GZLBjpjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739684803; c=relaxed/simple;
	bh=DPzSxv9vMP7mIpXdsVlzuxzRhKS8p8nA3AZc3wGiDlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tGP8KqDCj6bLVC6tsk16Mpq230GM2auQKfJvo9i8pf5yVC8u4t8VI/gPqLbT2CSf2NyVohTPkS1yep0PomY8E08NpA3ncbbPVQ09FAU2OuAgmT7TsQo4hhhiC5g6Gjdx/PEyO6slojYrI+WAfWRMc/Lfc2P9bLQhRBgKclHGdCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OFRmrrA3; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739684802; x=1771220802;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DPzSxv9vMP7mIpXdsVlzuxzRhKS8p8nA3AZc3wGiDlM=;
  b=OFRmrrA3pFRc3Iz1qFIUMzR6BA9jF7o8dwddu2n0gKkWUjsz0OAcV//y
   ZJlyf93B8BsOLs1jjynFW+njwmOOazkLhZM/aYa5bBYKi02kOUZTespNu
   4TjjzSPdIIQOUYexTx6k7aNFdePWy76ntelWYNNhi78Ml5v1XxwIOFF5n
   OGpM1O1I65eQ0ZZ0TGFnY2kID8VHDmD5jnWa3kc38vs6o0OU60ApaFRG2
   xCDGbibudK9w3FUhiYWlAugP6HhU8R2nDu4OOCYHMJfjjppD/fX/VPaQb
   7g+XBPoEXxP9r0iPzc9WEq76ldb5jLjv0BJGNuu/ZYKByZvvqAzV7u/Zs
   A==;
X-CSE-ConnectionGUID: ewGXA2uDSjGb+zcXvJ0abA==
X-CSE-MsgGUID: pNpWtTC7SCGUqKrrUU8RTA==
X-IronPort-AV: E=McAfee;i="6700,10204,11346"; a="51373248"
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="51373248"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2025 21:46:41 -0800
X-CSE-ConnectionGUID: pI2MlLO+TeefE0PsYBw1LA==
X-CSE-MsgGUID: DCAVUjtjRpuQN9D+ayYnrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,290,1732608000"; 
   d="scan'208";a="114330739"
Received: from 984fee00a4c6.jf.intel.com ([10.165.58.231])
  by fmviesa010.fm.intel.com with ESMTP; 15 Feb 2025 21:46:39 -0800
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
Subject: [PATCH v7 1/5] ida: Add ida_find_first_range()
Date: Sat, 15 Feb 2025 21:46:34 -0800
Message-Id: <20250216054638.24603-2-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250216054638.24603-1-yi.l.liu@intel.com>
References: <20250216054638.24603-1-yi.l.liu@intel.com>
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


