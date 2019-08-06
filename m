Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2C5082EB4
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2019 11:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732493AbfHFJaP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Aug 2019 05:30:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfHFJaP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Aug 2019 05:30:15 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5159B7BDB0;
        Tue,  6 Aug 2019 09:30:15 +0000 (UTC)
Received: from localhost (dhcp-192-181.str.redhat.com [10.33.192.181])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E1985C296;
        Tue,  6 Aug 2019 09:30:04 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Auger Eric <eric.auger@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2] vfio: re-arrange vfio region definitions
Date:   Tue,  6 Aug 2019 11:30:00 +0200
Message-Id: <20190806093000.30149-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 06 Aug 2019 09:30:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is easy to miss already defined region types. Let's re-arrange
the definitions a bit and add more comments to make it hopefully
a bit clearer.

No functional change.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
v1 -> v2:
  - moved all pci subtypes together
  - tweaked comments a bit more
---
 include/uapi/linux/vfio.h | 45 ++++++++++++++++++++++-----------------
 1 file changed, 26 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748dac79..e809b22f6a60 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -295,15 +295,38 @@ struct vfio_region_info_cap_type {
 	__u32 subtype;	/* type specific */
 };
 
+/*
+ * List of region types, global per bus driver.
+ * If you introduce a new type, please add it here.
+ */
+
+/* PCI region type containing a PCI vendor part */
 #define VFIO_REGION_TYPE_PCI_VENDOR_TYPE	(1 << 31)
 #define VFIO_REGION_TYPE_PCI_VENDOR_MASK	(0xffff)
+#define VFIO_REGION_TYPE_GFX                    (1)
+#define VFIO_REGION_TYPE_CCW			(2)
+
+/* sub-types for VFIO_REGION_TYPE_PCI_* */
 
-/* 8086 Vendor sub-types */
+/* 8086 vendor PCI sub-types */
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_OPREGION	(1)
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_HOST_CFG	(2)
 #define VFIO_REGION_SUBTYPE_INTEL_IGD_LPC_CFG	(3)
 
-#define VFIO_REGION_TYPE_GFX                    (1)
+/* 10de vendor PCI sub-types */
+/*
+ * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
+ */
+#define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
+
+/* 1014 vendor PCI sub-types */
+/*
+ * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
+ * to do TLB invalidation on a GPU.
+ */
+#define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
+
+/* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
 
 /**
@@ -353,25 +376,9 @@ struct vfio_region_gfx_edid {
 #define VFIO_DEVICE_GFX_LINK_STATE_DOWN  2
 };
 
-#define VFIO_REGION_TYPE_CCW			(2)
-/* ccw sub-types */
+/* sub-types for VFIO_REGION_TYPE_CCW */
 #define VFIO_REGION_SUBTYPE_CCW_ASYNC_CMD	(1)
 
-/*
- * 10de vendor sub-type
- *
- * NVIDIA GPU NVlink2 RAM is coherent RAM mapped onto the host address space.
- */
-#define VFIO_REGION_SUBTYPE_NVIDIA_NVLINK2_RAM	(1)
-
-/*
- * 1014 vendor sub-type
- *
- * IBM NPU NVlink2 ATSD (Address Translation Shootdown) register of NPU
- * to do TLB invalidation on a GPU.
- */
-#define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
-
 /*
  * The MSIX mappable capability informs that MSIX data of a BAR can be mmapped
  * which allows direct access to non-MSIX registers which happened to be within
-- 
2.20.1

