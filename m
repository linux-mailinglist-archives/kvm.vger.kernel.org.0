Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5B3410A6A
	for <lists+kvm@lfdr.de>; Sun, 19 Sep 2021 08:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238240AbhISGpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Sep 2021 02:45:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:59358 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238277AbhISGpL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Sep 2021 02:45:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10111"; a="221116164"
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="221116164"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2021 23:43:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,305,1624345200"; 
   d="scan'208";a="510702199"
Received: from yiliu-dev.bj.intel.com (HELO iov-dual.bj.intel.com) ([10.238.156.135])
  by fmsmga008.fm.intel.com with ESMTP; 18 Sep 2021 23:43:39 -0700
From:   Liu Yi L <yi.l.liu@intel.com>
To:     alex.williamson@redhat.com, jgg@nvidia.com, hch@lst.de,
        jasowang@redhat.com, joro@8bytes.org
Cc:     jean-philippe@linaro.org, kevin.tian@intel.com, parav@mellanox.com,
        lkml@metux.net, pbonzini@redhat.com, lushenming@huawei.com,
        eric.auger@redhat.com, corbet@lwn.net, ashok.raj@intel.com,
        yi.l.liu@intel.com, yi.l.liu@linux.intel.com, jun.j.tian@intel.com,
        hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: [RFC 20/20] Doc: Add documentation for /dev/iommu
Date:   Sun, 19 Sep 2021 14:38:48 +0800
Message-Id: <20210919063848.1476776-21-yi.l.liu@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210919063848.1476776-1-yi.l.liu@intel.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document the /dev/iommu framework for user.

Open:
Do we want to document /dev/iommu in Documentation/userspace-api/iommu.rst?
Existing iommu.rst is for the vSVA interfaces, honestly, may need to rewrite
this doc entirely.

Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
---
 Documentation/userspace-api/index.rst   |   1 +
 Documentation/userspace-api/iommufd.rst | 183 ++++++++++++++++++++++++
 2 files changed, 184 insertions(+)
 create mode 100644 Documentation/userspace-api/iommufd.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index 0b5eefed027e..54df5a278023 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -25,6 +25,7 @@ place where this information is gathered.
    ebpf/index
    ioctl/index
    iommu
+   iommufd
    media/index
    sysfs-platform_profile
 
diff --git a/Documentation/userspace-api/iommufd.rst b/Documentation/userspace-api/iommufd.rst
new file mode 100644
index 000000000000..abffbb47dc02
--- /dev/null
+++ b/Documentation/userspace-api/iommufd.rst
@@ -0,0 +1,183 @@
+.. SPDX-License-Identifier: GPL-2.0
+.. iommu:
+
+===================
+IOMMU Userspace API
+===================
+
+Direct device access from userspace has been a crtical feature in
+high performance computing and virtualization usages. Linux now
+includes multiple device-passthrough frameworks (e.g. VFIO and vDPA)
+to manage secure device access from the userspace. One critical
+task of those frameworks is to put the assigned device in a secure,
+IOMMU-protected context so the device is prevented from doing harm
+to the rest of the system.
+
+Currently those frameworks implement their own logic for managing
+I/O page tables to isolate user-initiated DMAs. This doesn't scale
+to support many new IOMMU features, such as PASID-granular DMA
+remapping, nested translation, I/O page fault, IOMMU dirty bit, etc.
+
+The /dev/iommu framework provides an unified interface for managing
+I/O page tables for passthrough devices. Existing passthrough
+frameworks are expected to use this interface instead of continuing
+their ad-hoc implementations.
+
+IOMMUFDs, IOASIDs, Devices and Groups
+-------------------------------------
+
+The core concepts in /dev/iommu are IOMMUFDs and IOASIDs. IOMMUFD (by
+opening /dev/iommu) is the container holding multiple I/O address
+spaces for a user, while IOASID is the fd-local software handle
+representing an I/O address space and associated with a single I/O
+page table. User manages those address spaces through fd operations,
+e.g. by using vfio type1v2 mapping semantics to manage respective
+I/O page tables.
+
+IOASID is comparable to the conatiner concept in VFIO. The latter
+is also associated to a single I/O address space. A main difference
+between them is that multiple IOASIDs in the same IOMMUFD can be
+nested together (not supported yet) to allow centralized accounting
+of locked pages, while multiple containers are disconnected thus
+duplicated accounting is incurred. Typically one IOMMUFD is
+sufficient for all intended IOMMU usages for a user.
+
+An I/O address space takes effect in the IOMMU only after it is
+attached by a device. One I/O address space can be attached by
+multiple devices. One device can be only attached to a single I/O
+address space at this point (on par with current vfio behavior).
+
+Device must be bound to an iommufd before the attach operation can
+be conducted. The binding operation builds the connection between
+the devicefd (opened via device-passthrough framework) and IOMMUFD.
+IOMMU-protected security context is esbliashed when the binding
+operation is completed. The passthrough framework must block user
+access to the assigned device until bind() returns success.
+
+The entire /dev/iommu framework adopts a device-centric model w/o
+carrying any container/group legacy as current vfio does. However
+the group is the minimum granularity that must be used to ensure
+secure user access (refer to vfio.rst). This framework relies on
+the IOMMU core layer to map device-centric model into group-granular
+isolation.
+
+Managing I/O Address Spaces
+---------------------------
+
+When creating an I/O address space (by allocating IOASID), the user
+must specify the type of underlying I/O page table. Currently only
+one type (kernel-managed) is supported. In the future other types
+will be introduced, e.g. to support user-managed I/O page table or
+a shared I/O page table which is managed by another kernel sub-
+system (mm, ept, etc.). Kernel-managed I/O page table is currently
+managed via vfio type1v2 equivalent mapping semantics.
+
+The user also needs to specify the format of the I/O page table
+when allocating an IOASID. The format must be compatible to the
+attached devices (or more specifically to the IOMMU which serves
+the DMA from the attached devices). User can query the device IOMMU
+format via IOMMUFD once a device is successfully bound. Attaching a
+device to an IOASID with incompatible format is simply rejected.
+
+Currently no-snoop DMA is not supported yet. This implies that
+IOASID must be created in an enforce-snoop format and only devices
+which can be forced to snoop cache by IOMMU are allowed to be
+attached to IOASID. The user should check uAPI extension and get
+device info via IOMMUFD to handle such restriction.
+
+Usage Example
+-------------
+
+Assume user wants to access PCI device 0000:06:0d.0, which is
+exposed under the new /dev/vfio/devices directory by VFIO:
+
+	/* Open device-centric interface and /dev/iommu interface */
+	device_fd = open("/dev/vfio/devices/0000:06:0d.0", O_RDWR);
+	iommu_fd = open("/dev/iommu", O_RDWR);
+
+	/* Bind device to IOMMUFD */
+	bind_data = { .iommu_fd = iommu_fd, .dev_cookie = cookie };
+	ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &bind_data);
+
+	/* Query per-device IOMMU capability/format */
+	info = { .dev_cookie = cookie, };
+	ioctl(iommu_fd, IOMMU_DEVICE_GET_INFO, &info);
+
+	if (!(info.flags & IOMMU_DEVICE_INFO_ENFORCE_SNOOP)) {
+		if (!ioctl(iommu_fd, IOMMU_CHECK_EXTENSION,
+				EXT_DMA_NO_SNOOP))
+			/* No support of no-snoop DMA */
+	}
+
+	if (!ioctl(iommu_fd, IOMMU_CHECK_EXTENSION, EXT_MAP_TYPE1V2))
+		/* No support of vfio type1v2 mapping semantics */
+
+	/* Decides IOASID alloc fields based on info */
+	alloc_data = { .type = IOMMU_IOASID_TYPE_KERNEL,
+		       .flags = IOMMU_IOASID_ENFORCE_SNOOP,
+		       .addr_width = info.addr_width, };
+
+	/* Allocate IOASID */
+	gpa_ioasid = ioctl(iommu_fd, IOMMU_IOASID_ALLOC, &alloc_data);
+
+	/* Attach device to an IOASID */
+	at_data = { .iommu_fd = iommu_fd; .ioasid = gpa_ioasid};
+	ioctl(device_fd, VFIO_DEVICE_ATTACH_IOASID, &at_data);
+
+	/* Setup GPA mapping [0 - 1GB] */
+	dma_map = {
+		.ioasid	= gpa_ioasid,
+		.data {
+			.flags  = R/W		/* permission */
+			.iova	= 0,		/* GPA */
+			.vaddr	= 0x40000000,	/* HVA */
+			.size	= 1GB,
+		},
+	};
+	ioctl(iommu_fd, IOMMU_MAP_DMA, &dma_map);
+
+	/* DMA */
+
+	/* Unmap GPA mapping [0 - 1GB] */
+	dma_unmap = {
+		.ioasid	= gpa_ioasid,
+		.data {
+			.iova	= 0,		/* GPA */
+			.size	= 1GB,
+		},
+	};
+	ioctl(iommu_fd, IOMMU_UNMAP_DMA, &dma_unmap);
+
+	/* Detach device from an IOASID */
+	dt_data = { .iommu_fd = iommu_fd; .ioasid = gpa_ioasid};
+	ioctl(device_fd, VFIO_DEVICE_DETACH_IOASID, &dt_data);
+
+	/* Free IOASID */
+	ioctl(iommu_fd, IOMMU_IOASID_FREE, gpa_ioasid);
+
+	close(device_fd);
+	close(iommu_fd);
+
+API for device-passthrough frameworks
+-------------------------------------
+
+iommufd binding and IOASID attach/detach are initiated via the device-
+passthrough framework uAPI.
+
+When a binding operation is requested by the user, the passthrough
+framework should call iommufd_bind_device(). When the device fd is
+closed by the user, iommufd_unbind_device() should be called
+automatically::
+
+	struct iommufd_device *
+	iommufd_bind_device(int fd, struct device *dev,
+			   u64 dev_cookie);
+	void iommufd_unbind_device(struct iommufd_device *idev);
+
+IOASID attach/detach operations are per iommufd_device which is
+returned by iommufd_bind_device():
+
+	int iommufd_device_attach_ioasid(struct iommufd_device *idev,
+					int ioasid);
+	void iommufd_device_detach_ioasid(struct iommufd_device *idev,
+					int ioasid);
-- 
2.25.1

