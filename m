Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A2632A738
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 18:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1839092AbhCBQFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Mar 2021 11:05:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:29410 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238135AbhCBMpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 07:45:01 -0500
IronPort-SDR: NMiETf2VTufRZYNpzD7OZzCR0mBSCKfRSLDxCmzOQeh+2X9o/bCPEn916l5i4WyyCyL7wsnZXL
 jPA2VL0EEwfA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="184363144"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="184363144"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 04:39:41 -0800
IronPort-SDR: esX9dabqUCU8wQHcaUZc7LSandQ/1jiAANvdyf/JCeKBeibdHtgr1YuzG5sne3F3YFoI61C/t3
 1MAgfwwf76TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="427472702"
Received: from yiliu-dev.bj.intel.com (HELO dual-ub.bj.intel.com) ([10.238.156.135])
  by fmsmga004.fm.intel.com with ESMTP; 02 Mar 2021 04:39:36 -0800
From:   Liu Yi L <yi.l.liu@intel.com>
To:     qemu-devel@nongnu.org, alex.williamson@redhat.com,
        peterx@redhat.com, jasowang@redhat.com
Cc:     mst@redhat.com, pbonzini@redhat.com, eric.auger@redhat.com,
        david@gibson.dropbear.id.au, jean-philippe@linaro.org,
        kevin.tian@intel.com, yi.l.liu@intel.com, jun.j.tian@intel.com,
        yi.y.sun@intel.com, hao.wu@intel.com, kvm@vger.kernel.org,
        Lingshan.Zhu@intel.com, Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yi Sun <yi.y.sun@linux.intel.com>
Subject: [RFC v11 03/25] header file update VFIO/IOMMU vSVA APIs kernel 5.12-rc1
Date:   Wed,  3 Mar 2021 04:38:05 +0800
Message-Id: <20210302203827.437645-4-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210302203827.437645-1-yi.l.liu@intel.com>
References: <20210302203827.437645-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the kernel uapi/linux/iommu.h, vfio.h and ioasid.h.

This commit updates kernel headers from the below branch:
https://github.com/jacobpan/linux.git vsva-linux-5.12-rc1-v8

Note: this should be replaced with a full header files update when
the vSVA uPAPI is stable.

Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Yi Sun <yi.y.sun@linux.intel.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 linux-headers/linux/iommu.h | 413 ++++++++++++++++++++++++++++++++++++
 linux-headers/linux/vfio.h  |  84 ++++++++
 2 files changed, 497 insertions(+)
 create mode 100644 linux-headers/linux/iommu.h

diff --git a/linux-headers/linux/iommu.h b/linux-headers/linux/iommu.h
new file mode 100644
index 0000000000..8824029e53
--- /dev/null
+++ b/linux-headers/linux/iommu.h
@@ -0,0 +1,413 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * IOMMU user API definitions
+ */
+
+#ifndef _IOMMU_H
+#define _IOMMU_H
+
+#include <linux/types.h>
+
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
+/* defines the granularity of the invalidation */
+enum iommu_inv_granularity {
+	IOMMU_INV_GRANU_DOMAIN,	/* domain-selective invalidation */
+	IOMMU_INV_GRANU_PASID,	/* PASID-selective invalidation */
+	IOMMU_INV_GRANU_ADDR,	/* page-selective invalidation */
+	IOMMU_INV_GRANU_NR,	/* number of invalidation granularities */
+};
+
+/**
+ * struct iommu_inv_addr_info - Address Selective Invalidation Structure
+ *
+ * @flags: indicates the granularity of the address-selective invalidation
+ * - If the PASID bit is set, the @pasid field is populated and the invalidation
+ *   relates to cache entries tagged with this PASID and matching the address
+ *   range.
+ * - If ARCHID bit is set, @archid is populated and the invalidation relates
+ *   to cache entries tagged with this architecture specific ID and matching
+ *   the address range.
+ * - Both PASID and ARCHID can be set as they may tag different caches.
+ * - If neither PASID or ARCHID is set, global addr invalidation applies.
+ * - The LEAF flag indicates whether only the leaf PTE caching needs to be
+ *   invalidated and other paging structure caches can be preserved.
+ * @pasid: process address space ID
+ * @archid: architecture-specific ID
+ * @addr: first stage/level input address
+ * @granule_size: page/block size of the mapping in bytes
+ * @nb_granules: number of contiguous granules to be invalidated
+ */
+struct iommu_inv_addr_info {
+#define IOMMU_INV_ADDR_FLAGS_PASID	(1 << 0)
+#define IOMMU_INV_ADDR_FLAGS_ARCHID	(1 << 1)
+#define IOMMU_INV_ADDR_FLAGS_LEAF	(1 << 2)
+	__u32	flags;
+	__u32	archid;
+	__u64	pasid;
+	__u64	addr;
+	__u64	granule_size;
+	__u64	nb_granules;
+};
+
+/**
+ * struct iommu_inv_pasid_info - PASID Selective Invalidation Structure
+ *
+ * @flags: indicates the granularity of the PASID-selective invalidation
+ * - If the PASID bit is set, the @pasid field is populated and the invalidation
+ *   relates to cache entries tagged with this PASID and matching the address
+ *   range.
+ * - If the ARCHID bit is set, the @archid is populated and the invalidation
+ *   relates to cache entries tagged with this architecture specific ID and
+ *   matching the address range.
+ * - Both PASID and ARCHID can be set as they may tag different caches.
+ * - At least one of PASID or ARCHID must be set.
+ * @pasid: process address space ID
+ * @archid: architecture-specific ID
+ */
+struct iommu_inv_pasid_info {
+#define IOMMU_INV_PASID_FLAGS_PASID	(1 << 0)
+#define IOMMU_INV_PASID_FLAGS_ARCHID	(1 << 1)
+	__u32	flags;
+	__u32	archid;
+	__u64	pasid;
+};
+
+/**
+ * struct iommu_cache_invalidate_info - First level/stage invalidation
+ *     information
+ * @argsz: User filled size of this data
+ * @version: API version of this structure
+ * @cache: bitfield that allows to select which caches to invalidate
+ * @granularity: defines the lowest granularity used for the invalidation:
+ *     domain > PASID > addr
+ * @padding: reserved for future use (should be zero)
+ * @pasid_info: invalidation data when @granularity is %IOMMU_INV_GRANU_PASID
+ * @addr_info: invalidation data when @granularity is %IOMMU_INV_GRANU_ADDR
+ *
+ * Not all the combinations of cache/granularity are valid:
+ *
+ * +--------------+---------------+---------------+---------------+
+ * | type /       |   DEV_IOTLB   |     IOTLB     |      PASID    |
+ * | granularity  |               |               |      cache    |
+ * +==============+===============+===============+===============+
+ * | DOMAIN       |       N/A     |       Y       |       Y       |
+ * +--------------+---------------+---------------+---------------+
+ * | PASID        |       Y       |       Y       |       Y       |
+ * +--------------+---------------+---------------+---------------+
+ * | ADDR         |       Y       |       Y       |       N/A     |
+ * +--------------+---------------+---------------+---------------+
+ *
+ * Invalidations by %IOMMU_INV_GRANU_DOMAIN don't take any argument other than
+ * @version and @cache.
+ *
+ * If multiple cache types are invalidated simultaneously, they all
+ * must support the used granularity.
+ */
+struct iommu_cache_invalidate_info {
+	__u32	argsz;
+#define IOMMU_CACHE_INVALIDATE_INFO_VERSION_1 1
+	__u32	version;
+/* IOMMU paging structure cache */
+#define IOMMU_CACHE_INV_TYPE_IOTLB	(1 << 0) /* IOMMU IOTLB */
+#define IOMMU_CACHE_INV_TYPE_DEV_IOTLB	(1 << 1) /* Device IOTLB */
+#define IOMMU_CACHE_INV_TYPE_PASID	(1 << 2) /* PASID cache */
+#define IOMMU_CACHE_INV_TYPE_NR		(3)
+	__u8	cache;
+	__u8	granularity;
+	__u8	padding[6];
+	union {
+		struct iommu_inv_pasid_info pasid_info;
+		struct iommu_inv_addr_info addr_info;
+	} granu;
+};
+
+/**
+ * struct iommu_gpasid_bind_data_vtd - Intel VT-d specific data on device and guest
+ * SVA binding.
+ *
+ * @flags:	VT-d PASID table entry attributes
+ * @pat:	Page attribute table data to compute effective memory type
+ * @emt:	Extended memory type
+ *
+ * Only guest vIOMMU selectable and effective options are passed down to
+ * the host IOMMU.
+ */
+struct iommu_gpasid_bind_data_vtd {
+#define IOMMU_SVA_VTD_GPASID_SRE	(1 << 0) /* supervisor request */
+#define IOMMU_SVA_VTD_GPASID_EAFE	(1 << 1) /* extended access enable */
+#define IOMMU_SVA_VTD_GPASID_PCD	(1 << 2) /* page-level cache disable */
+#define IOMMU_SVA_VTD_GPASID_PWT	(1 << 3) /* page-level write through */
+#define IOMMU_SVA_VTD_GPASID_EMTE	(1 << 4) /* extended mem type enable */
+#define IOMMU_SVA_VTD_GPASID_CD		(1 << 5) /* PASID-level cache disable */
+#define IOMMU_SVA_VTD_GPASID_LAST	(1 << 6)
+	__u64 flags;
+	__u32 pat;
+	__u32 emt;
+};
+
+#define IOMMU_SVA_VTD_GPASID_MTS_MASK	(IOMMU_SVA_VTD_GPASID_CD | \
+					 IOMMU_SVA_VTD_GPASID_EMTE | \
+					 IOMMU_SVA_VTD_GPASID_PCD |  \
+					 IOMMU_SVA_VTD_GPASID_PWT)
+
+/**
+ * struct iommu_gpasid_bind_data - Information about device and guest PASID binding
+ * @argsz:	User filled size of this data
+ * @version:	Version of this data structure
+ * @format:	PASID table entry format
+ * @flags:	Additional information on guest bind request
+ * @gpgd:	Guest page directory base of the guest mm to bind
+ * @hpasid:	Process address space ID used for the guest mm in host IOMMU
+ * @gpasid:	Process address space ID used for the guest mm in guest IOMMU
+ * @addr_width:	Guest virtual address width
+ * @padding:	Reserved for future use (should be zero)
+ * @vtd:	Intel VT-d specific data
+ *
+ * Guest to host PASID mapping can be an identity or non-identity, where guest
+ * has its own PASID space. For non-identify mapping, guest to host PASID lookup
+ * is needed when VM programs guest PASID into an assigned device. VMM may
+ * trap such PASID programming then request host IOMMU driver to convert guest
+ * PASID to host PASID based on this bind data.
+ */
+struct iommu_gpasid_bind_data {
+	__u32 argsz;
+#define IOMMU_GPASID_BIND_VERSION_1	1
+	__u32 version;
+#define IOMMU_PASID_FORMAT_INTEL_VTD	1
+#define IOMMU_PASID_FORMAT_LAST		2
+	__u32 format;
+	__u32 addr_width;
+#define IOMMU_SVA_GPASID_VAL	(1 << 0) /* guest PASID valid */
+	__u64 flags;
+	__u64 gpgd;
+	__u64 hpasid;
+	__u64 gpasid;
+	__u8  padding[8];
+	/* Vendor specific data */
+	union {
+		struct iommu_gpasid_bind_data_vtd vtd;
+	} vendor;
+};
+
+/*
+ * struct iommu_nesting_info_vtd - Intel VT-d specific nesting info.
+ *
+ * @flags:	VT-d specific flags. Currently reserved for future
+ *		extension. must be set to 0.
+ * @cap_reg:	Describe basic capabilities as defined in VT-d capability
+ *		register.
+ * @ecap_reg:	Describe the extended capabilities as defined in VT-d
+ *		extended capability register.
+ */
+struct iommu_nesting_info_vtd {
+	__u32	flags;
+	__u8	padding[12];
+	__u64	cap_reg;
+	__u64	ecap_reg;
+};
+
+/*
+ * struct iommu_nesting_info - Information for nesting-capable IOMMU.
+ *			       userspace should check it before using
+ *			       nesting capability.
+ *
+ * @argsz:	size of the whole structure.
+ * @flags:	currently reserved for future extension. must set to 0.
+ * @format:	PASID table entry format, the same definition as struct
+ *		iommu_gpasid_bind_data @format.
+ * @features:	supported nesting features.
+ * @addr_width:	the output addr width of first level/stage translation
+ * @pasid_bits:	maximum supported PASID bits, 0 represents no PASID
+ *		support.
+ * @vendor:	vendor specific data, structure type can be deduced from
+ *		@format field.
+ *
+ * +===============+======================================================+
+ * | feature       |  Notes                                               |
+ * +===============+======================================================+
+ * | BIND_PGTBL    |  IOMMU vendor driver sets it to mandate userspace to |
+ * |               |  bind the first level/stage page table to associated |
+ * |               |  PASID (either the one specified in bind request or  |
+ * |               |  the default PASID of iommu domain), through IOMMU   |
+ * |               |  UAPI.                                               |
+ * +---------------+------------------------------------------------------+
+ * | CACHE_INVLD   |  IOMMU vendor driver sets it to mandate userspace to |
+ * |               |  explicitly invalidate the IOMMU cache through IOMMU |
+ * |               |  UAPI according to vendor-specific requirement when  |
+ * |               |  changing the 1st level/stage page table.            |
+ * +---------------+------------------------------------------------------+
+ *
+ * data struct types defined for @format:
+ * +================================+=====================================+
+ * | @format                        | data struct                         |
+ * +================================+=====================================+
+ * | IOMMU_PASID_FORMAT_INTEL_VTD   | struct iommu_nesting_info_vtd       |
+ * +--------------------------------+-------------------------------------+
+ *
+ */
+struct iommu_nesting_info {
+	__u32	argsz;
+	__u32	flags;
+	__u32	format;
+#define IOMMU_NESTING_FEAT_BIND_PGTBL		(1 << 0)
+#define IOMMU_NESTING_FEAT_CACHE_INVLD		(1 << 1)
+	__u32	features;
+	__u16	addr_width;
+	__u16	pasid_bits;
+	__u8	padding[12];
+	/* Vendor specific data */
+	union {
+		struct iommu_nesting_info_vtd vtd;
+	} vendor;
+};
+
+#endif /* _IOMMU_H */
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 609099e455..59fbf7f109 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -14,6 +14,7 @@
 
 #include <linux/types.h>
 #include <linux/ioctl.h>
+#include <linux/iommu.h>
 
 #define VFIO_API_VERSION	0
 
@@ -46,6 +47,12 @@
  */
 #define VFIO_NOIOMMU_IOMMU		8
 
+/* Supports VFIO_DMA_UNMAP_FLAG_ALL */
+#define VFIO_UNMAP_ALL			9
+
+/* Supports the vaddr flag for DMA map and unmap */
+#define VFIO_UPDATE_VADDR		10
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -1067,6 +1074,24 @@ struct vfio_iommu_type1_info_dma_avail {
 	__u32	avail;
 };
 
+/*
+ * The nesting capability allows to report the related capability
+ * and info for nesting iommu type.
+ *
+ * The structures below define version 1 of this capability.
+ *
+ * Nested capabilities should be checked by the userspace after
+ * setting VFIO_TYPE1_NESTING_IOMMU.
+ *
+ * @info: the nesting info provided by IOMMU driver.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_CAP_NESTING  4
+
+struct vfio_iommu_type1_info_cap_nesting {
+	struct	vfio_info_cap_header header;
+	struct	iommu_nesting_info info;
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
@@ -1074,12 +1099,22 @@ struct vfio_iommu_type1_info_dma_avail {
  *
  * Map process virtual addresses to IO virtual addresses using the
  * provided struct vfio_dma_map. Caller sets argsz. READ &/ WRITE required.
+ *
+ * If flags & VFIO_DMA_MAP_FLAG_VADDR, update the base vaddr for iova, and
+ * unblock translation of host virtual addresses in the iova range.  The vaddr
+ * must have previously been invalidated with VFIO_DMA_UNMAP_FLAG_VADDR.  To
+ * maintain memory consistency within the user application, the updated vaddr
+ * must address the same memory object as originally mapped.  Failure to do so
+ * will result in user memory corruption and/or device misbehavior.  iova and
+ * size must match those in the original MAP_DMA call.  Protection is not
+ * changed, and the READ & WRITE flags must be 0.
  */
 struct vfio_iommu_type1_dma_map {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_MAP_FLAG_READ (1 << 0)		/* readable from device */
 #define VFIO_DMA_MAP_FLAG_WRITE (1 << 1)	/* writable from device */
+#define VFIO_DMA_MAP_FLAG_VADDR (1 << 2)
 	__u64	vaddr;				/* Process virtual address */
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
@@ -1102,6 +1137,7 @@ struct vfio_bitmap {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ *
  * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
  * before unmapping IO virtual addresses. When this flag is set, the user must
  * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
@@ -1111,11 +1147,21 @@ struct vfio_bitmap {
  * indicates that the page at that offset from iova is dirty. A Bitmap of the
  * pages in the range of unmapped size is returned in the user-provided
  * vfio_bitmap.data.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
+ * must be 0.  This cannot be combined with the get-dirty-bitmap flag.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
+ * virtual addresses in the iova range.  Tasks that attempt to translate an
+ * iova's vaddr will block.  DMA to already-mapped pages continues.  This
+ * cannot be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
+#define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
+#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];
@@ -1181,6 +1227,44 @@ struct vfio_iommu_type1_dirty_bitmap_get {
 
 #define VFIO_IOMMU_DIRTY_PAGES             _IO(VFIO_TYPE, VFIO_BASE + 17)
 
+/**
+ * VFIO_IOMMU_NESTING_OP - _IOW(VFIO_TYPE, VFIO_BASE + 18,
+ *				struct vfio_iommu_type1_nesting_op)
+ *
+ * This interface allows userspace to utilize the nesting IOMMU
+ * capabilities as reported in VFIO_IOMMU_TYPE1_INFO_CAP_NESTING
+ * cap through VFIO_IOMMU_GET_INFO. For platforms which require
+ * system wide PASID, PASID will be allocated by VFIO_IOMMU_PASID
+ * _REQUEST.
+ *
+ * @data[] types defined for each op:
+ * +=================+===============================================+
+ * | NESTING OP      |      @data[]                                  |
+ * +=================+===============================================+
+ * | BIND_PGTBL      |      struct iommu_gpasid_bind_data            |
+ * +-----------------+-----------------------------------------------+
+ * | UNBIND_PGTBL    |      struct iommu_gpasid_bind_data            |
+ * +-----------------+-----------------------------------------------+
+ * | CACHE_INVLD     |      struct iommu_cache_invalidate_info       |
+ * +-----------------+-----------------------------------------------+
+ *
+ * returns: 0 on success, -errno on failure.
+ */
+struct vfio_iommu_type1_nesting_op {
+	__u32	argsz;
+	__u32	flags;
+#define VFIO_NESTING_OP_MASK	(0xffff) /* lower 16-bits for op */
+	__u8	data[];
+};
+
+enum {
+	VFIO_IOMMU_NESTING_OP_BIND_PGTBL,
+	VFIO_IOMMU_NESTING_OP_UNBIND_PGTBL,
+	VFIO_IOMMU_NESTING_OP_CACHE_INVLD,
+};
+
+#define VFIO_IOMMU_NESTING_OP		_IO(VFIO_TYPE, VFIO_BASE + 18)
+
 /* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
 
 /*
-- 
2.25.1

