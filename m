Return-Path: <kvm+bounces-4877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FC20819638
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 771DE1C2565F
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E40C38BFB;
	Wed, 20 Dec 2023 01:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RTqLDCef"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED3A749C;
	Wed, 20 Dec 2023 01:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703035715; x=1734571715;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4yO2cVd32Ql1SfMr3bHpIUH8k8s6HyzQGwFybGU/+uU=;
  b=RTqLDCefF8SS/Tm/NDJr8XjRHQbB4rn377s7uWZ6LwBbDYey/sj1eT60
   egDX9E8PiVFa8XWaTdrZQ2RKL/IjRovkpznEK/XmlKtofTognoW6t8fR2
   UMgOfJAbdPzuykyWbBNMIRQp4oJ3yDF14/ifE7A/hgB6CpkSSzn3kydXj
   w+rbTAQd1uvbubiSVuzlWT2LtbHCcavGwa4RmK9q6vrCQxbmRFsgi5WFX
   QylWFyLfWu2MRBDpAQhwELahY9QIuKdSM7E5kb9RzZ+BJlre4u4DOkzIP
   CqSPJskJAIxz1Xy8iaYPoOAaGWe37s7kQSLilc3EYGBYg9KNOdrGeDc1D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="2965719"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="2965719"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 17:28:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10929"; a="1023319058"
X-IronPort-AV: E=Sophos;i="6.04,290,1695711600"; 
   d="scan'208";a="1023319058"
Received: from allen-box.sh.intel.com ([10.239.159.127])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2023 17:28:31 -0800
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v9 01/14] iommu: Move iommu fault data to linux/iommu.h
Date: Wed, 20 Dec 2023 09:23:19 +0800
Message-Id: <20231220012332.168188-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220012332.168188-1-baolu.lu@linux.intel.com>
References: <20231220012332.168188-1-baolu.lu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The iommu fault data is currently defined in uapi/linux/iommu.h, but is
only used inside the iommu subsystem. Move it to linux/iommu.h, where it
will be more accessible to kernel drivers.

With this done, uapi/linux/iommu.h becomes empty and can be removed from
the tree.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Longfang Liu <liulongfang@huawei.com>
---
 include/linux/iommu.h      | 152 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/iommu.h | 161 -------------------------------------
 MAINTAINERS                |   1 -
 3 files changed, 151 insertions(+), 163 deletions(-)
 delete mode 100644 include/uapi/linux/iommu.h

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3a556996fea7..80dfdc40b267 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -14,7 +14,6 @@
 #include <linux/err.h>
 #include <linux/of.h>
 #include <linux/iova_bitmap.h>
-#include <uapi/linux/iommu.h>
 
 #define IOMMU_READ	(1 << 0)
 #define IOMMU_WRITE	(1 << 1)
@@ -44,6 +43,157 @@ struct iommu_sva;
 struct iommu_fault_event;
 struct iommu_dma_cookie;
 
+#define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
+#define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
+#define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */
+#define IOMMU_FAULT_PERM_PRIV	(1 << 3) /* privileged */
+
+/* Generic fault types, can be expanded IRQ remapping fault */
+enum iommu_fault_type {
+	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
+	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
+};
+
+enum iommu_fault_reason {
+	IOMMU_FAULT_REASON_UNKNOWN = 0,
+
+	/* Could not access the PASID table (fetch caused external abort) */
+	IOMMU_FAULT_REASON_PASID_FETCH,
+
+	/* PASID entry is invalid or has configuration errors */
+	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
+
+	/*
+	 * PASID is out of range (e.g. exceeds the maximum PASID
+	 * supported by the IOMMU) or disabled.
+	 */
+	IOMMU_FAULT_REASON_PASID_INVALID,
+
+	/*
+	 * An external abort occurred fetching (or updating) a translation
+	 * table descriptor
+	 */
+	IOMMU_FAULT_REASON_WALK_EABT,
+
+	/*
+	 * Could not access the page table entry (Bad address),
+	 * actual translation fault
+	 */
+	IOMMU_FAULT_REASON_PTE_FETCH,
+
+	/* Protection flag check failed */
+	IOMMU_FAULT_REASON_PERMISSION,
+
+	/* access flag check failed */
+	IOMMU_FAULT_REASON_ACCESS,
+
+	/* Output address of a translation stage caused Address Size fault */
+	IOMMU_FAULT_REASON_OOR_ADDRESS,
+};
+
+/**
+ * struct iommu_fault_unrecoverable - Unrecoverable fault data
+ * @reason: reason of the fault, from &enum iommu_fault_reason
+ * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
+ * @pasid: Process Address Space ID
+ * @perm: requested permission access using by the incoming transaction
+ *        (IOMMU_FAULT_PERM_* values)
+ * @addr: offending page address
+ * @fetch_addr: address that caused a fetch abort, if any
+ */
+struct iommu_fault_unrecoverable {
+	__u32	reason;
+#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
+#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
+#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
+	__u32	flags;
+	__u32	pasid;
+	__u32	perm;
+	__u64	addr;
+	__u64	fetch_addr;
+};
+
+/**
+ * struct iommu_fault_page_request - Page Request data
+ * @flags: encodes whether the corresponding fields are valid and whether this
+ *         is the last page in group (IOMMU_FAULT_PAGE_REQUEST_* values).
+ *         When IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID is set, the page response
+ *         must have the same PASID value as the page request. When it is clear,
+ *         the page response should not have a PASID.
+ * @pasid: Process Address Space ID
+ * @grpid: Page Request Group Index
+ * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
+ * @addr: page address
+ * @private_data: device-specific private information
+ */
+struct iommu_fault_page_request {
+#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
+#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
+#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
+#define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
+	__u32	flags;
+	__u32	pasid;
+	__u32	grpid;
+	__u32	perm;
+	__u64	addr;
+	__u64	private_data[2];
+};
+
+/**
+ * struct iommu_fault - Generic fault data
+ * @type: fault type from &enum iommu_fault_type
+ * @padding: reserved for future use (should be zero)
+ * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
+ * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
+ * @padding2: sets the fault size to allow for future extensions
+ */
+struct iommu_fault {
+	__u32	type;
+	__u32	padding;
+	union {
+		struct iommu_fault_unrecoverable event;
+		struct iommu_fault_page_request prm;
+		__u8 padding2[56];
+	};
+};
+
+/**
+ * enum iommu_page_response_code - Return status of fault handlers
+ * @IOMMU_PAGE_RESP_SUCCESS: Fault has been handled and the page tables
+ *	populated, retry the access. This is "Success" in PCI PRI.
+ * @IOMMU_PAGE_RESP_FAILURE: General error. Drop all subsequent faults from
+ *	this device if possible. This is "Response Failure" in PCI PRI.
+ * @IOMMU_PAGE_RESP_INVALID: Could not handle this fault, don't retry the
+ *	access. This is "Invalid Request" in PCI PRI.
+ */
+enum iommu_page_response_code {
+	IOMMU_PAGE_RESP_SUCCESS = 0,
+	IOMMU_PAGE_RESP_INVALID,
+	IOMMU_PAGE_RESP_FAILURE,
+};
+
+/**
+ * struct iommu_page_response - Generic page response information
+ * @argsz: User filled size of this data
+ * @version: API version of this structure
+ * @flags: encodes whether the corresponding fields are valid
+ *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
+ * @pasid: Process Address Space ID
+ * @grpid: Page Request Group Index
+ * @code: response code from &enum iommu_page_response_code
+ */
+struct iommu_page_response {
+	__u32	argsz;
+#define IOMMU_PAGE_RESP_VERSION_1	1
+	__u32	version;
+#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
+	__u32	flags;
+	__u32	pasid;
+	__u32	grpid;
+	__u32	code;
+};
+
+
 /* iommu fault flags */
 #define IOMMU_FAULT_READ	0x0
 #define IOMMU_FAULT_WRITE	0x1
diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
deleted file mode 100644
index 65d8b0234f69..000000000000
--- a/include/uapi/linux/iommu.h
+++ /dev/null
@@ -1,161 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
-/*
- * IOMMU user API definitions
- */
-
-#ifndef _UAPI_IOMMU_H
-#define _UAPI_IOMMU_H
-
-#include <linux/types.h>
-
-#define IOMMU_FAULT_PERM_READ	(1 << 0) /* read */
-#define IOMMU_FAULT_PERM_WRITE	(1 << 1) /* write */
-#define IOMMU_FAULT_PERM_EXEC	(1 << 2) /* exec */
-#define IOMMU_FAULT_PERM_PRIV	(1 << 3) /* privileged */
-
-/* Generic fault types, can be expanded IRQ remapping fault */
-enum iommu_fault_type {
-	IOMMU_FAULT_DMA_UNRECOV = 1,	/* unrecoverable fault */
-	IOMMU_FAULT_PAGE_REQ,		/* page request fault */
-};
-
-enum iommu_fault_reason {
-	IOMMU_FAULT_REASON_UNKNOWN = 0,
-
-	/* Could not access the PASID table (fetch caused external abort) */
-	IOMMU_FAULT_REASON_PASID_FETCH,
-
-	/* PASID entry is invalid or has configuration errors */
-	IOMMU_FAULT_REASON_BAD_PASID_ENTRY,
-
-	/*
-	 * PASID is out of range (e.g. exceeds the maximum PASID
-	 * supported by the IOMMU) or disabled.
-	 */
-	IOMMU_FAULT_REASON_PASID_INVALID,
-
-	/*
-	 * An external abort occurred fetching (or updating) a translation
-	 * table descriptor
-	 */
-	IOMMU_FAULT_REASON_WALK_EABT,
-
-	/*
-	 * Could not access the page table entry (Bad address),
-	 * actual translation fault
-	 */
-	IOMMU_FAULT_REASON_PTE_FETCH,
-
-	/* Protection flag check failed */
-	IOMMU_FAULT_REASON_PERMISSION,
-
-	/* access flag check failed */
-	IOMMU_FAULT_REASON_ACCESS,
-
-	/* Output address of a translation stage caused Address Size fault */
-	IOMMU_FAULT_REASON_OOR_ADDRESS,
-};
-
-/**
- * struct iommu_fault_unrecoverable - Unrecoverable fault data
- * @reason: reason of the fault, from &enum iommu_fault_reason
- * @flags: parameters of this fault (IOMMU_FAULT_UNRECOV_* values)
- * @pasid: Process Address Space ID
- * @perm: requested permission access using by the incoming transaction
- *        (IOMMU_FAULT_PERM_* values)
- * @addr: offending page address
- * @fetch_addr: address that caused a fetch abort, if any
- */
-struct iommu_fault_unrecoverable {
-	__u32	reason;
-#define IOMMU_FAULT_UNRECOV_PASID_VALID		(1 << 0)
-#define IOMMU_FAULT_UNRECOV_ADDR_VALID		(1 << 1)
-#define IOMMU_FAULT_UNRECOV_FETCH_ADDR_VALID	(1 << 2)
-	__u32	flags;
-	__u32	pasid;
-	__u32	perm;
-	__u64	addr;
-	__u64	fetch_addr;
-};
-
-/**
- * struct iommu_fault_page_request - Page Request data
- * @flags: encodes whether the corresponding fields are valid and whether this
- *         is the last page in group (IOMMU_FAULT_PAGE_REQUEST_* values).
- *         When IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID is set, the page response
- *         must have the same PASID value as the page request. When it is clear,
- *         the page response should not have a PASID.
- * @pasid: Process Address Space ID
- * @grpid: Page Request Group Index
- * @perm: requested page permissions (IOMMU_FAULT_PERM_* values)
- * @addr: page address
- * @private_data: device-specific private information
- */
-struct iommu_fault_page_request {
-#define IOMMU_FAULT_PAGE_REQUEST_PASID_VALID	(1 << 0)
-#define IOMMU_FAULT_PAGE_REQUEST_LAST_PAGE	(1 << 1)
-#define IOMMU_FAULT_PAGE_REQUEST_PRIV_DATA	(1 << 2)
-#define IOMMU_FAULT_PAGE_RESPONSE_NEEDS_PASID	(1 << 3)
-	__u32	flags;
-	__u32	pasid;
-	__u32	grpid;
-	__u32	perm;
-	__u64	addr;
-	__u64	private_data[2];
-};
-
-/**
- * struct iommu_fault - Generic fault data
- * @type: fault type from &enum iommu_fault_type
- * @padding: reserved for future use (should be zero)
- * @event: fault event, when @type is %IOMMU_FAULT_DMA_UNRECOV
- * @prm: Page Request message, when @type is %IOMMU_FAULT_PAGE_REQ
- * @padding2: sets the fault size to allow for future extensions
- */
-struct iommu_fault {
-	__u32	type;
-	__u32	padding;
-	union {
-		struct iommu_fault_unrecoverable event;
-		struct iommu_fault_page_request prm;
-		__u8 padding2[56];
-	};
-};
-
-/**
- * enum iommu_page_response_code - Return status of fault handlers
- * @IOMMU_PAGE_RESP_SUCCESS: Fault has been handled and the page tables
- *	populated, retry the access. This is "Success" in PCI PRI.
- * @IOMMU_PAGE_RESP_FAILURE: General error. Drop all subsequent faults from
- *	this device if possible. This is "Response Failure" in PCI PRI.
- * @IOMMU_PAGE_RESP_INVALID: Could not handle this fault, don't retry the
- *	access. This is "Invalid Request" in PCI PRI.
- */
-enum iommu_page_response_code {
-	IOMMU_PAGE_RESP_SUCCESS = 0,
-	IOMMU_PAGE_RESP_INVALID,
-	IOMMU_PAGE_RESP_FAILURE,
-};
-
-/**
- * struct iommu_page_response - Generic page response information
- * @argsz: User filled size of this data
- * @version: API version of this structure
- * @flags: encodes whether the corresponding fields are valid
- *         (IOMMU_FAULT_PAGE_RESPONSE_* values)
- * @pasid: Process Address Space ID
- * @grpid: Page Request Group Index
- * @code: response code from &enum iommu_page_response_code
- */
-struct iommu_page_response {
-	__u32	argsz;
-#define IOMMU_PAGE_RESP_VERSION_1	1
-	__u32	version;
-#define IOMMU_PAGE_RESP_PASID_VALID	(1 << 0)
-	__u32	flags;
-	__u32	pasid;
-	__u32	grpid;
-	__u32	code;
-};
-
-#endif /* _UAPI_IOMMU_H */
diff --git a/MAINTAINERS b/MAINTAINERS
index 9104430e148e..4b84164c69bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11074,7 +11074,6 @@ F:	drivers/iommu/
 F:	include/linux/iommu.h
 F:	include/linux/iova.h
 F:	include/linux/of_iommu.h
-F:	include/uapi/linux/iommu.h
 
 IOMMUFD
 M:	Jason Gunthorpe <jgg@nvidia.com>
-- 
2.34.1


