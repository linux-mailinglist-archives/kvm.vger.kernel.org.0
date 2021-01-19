Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F4A2FBEB9
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392416AbhASSRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:17:16 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48162 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391122AbhASSQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:48 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JI9jJ8129733;
        Tue, 19 Jan 2021 18:16:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=YFNeoKGhCVAU6qiedug8a4e93cWz1KRioNtyc7yZ6XQ=;
 b=ZrTwxLzY36R2w1X18/EFmW1yS+ZuU9L21NUdBuXuWH13ud5aOHjFH4Cuf2IcKqYYtI5g
 1Q0ixrbHaJHtbOsqUaBCKJ85Hn19q+kv0A8rxJpZfMYA6ZU23iK/moFL75dmwCGqLhNT
 HNP44b0S26o4RzguyIV+qp6AnVfMqazM17Fp6tWs7Hx7DjFh6/DS8yev6uKC97lb8IQI
 xgDypRHvm8iVuuqx5//pHxoOlW4QpBVLGRUExjpOkcpZ2GrmL/ojuteC+i7ZYv765Blv
 l7IUCdUHFsfexsX155XMb3YoSRxg1boaYlLyX7Wn4GpKUayAEXsHrIeMm26OaV9OA7Yk cw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 363xyhsrrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIAdTZ051070;
        Tue, 19 Jan 2021 18:16:02 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3661khmfth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:02 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JIG1AO027639;
        Tue, 19 Jan 2021 18:16:01 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:16:01 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 5/9] vfio: interfaces to update vaddr
Date:   Tue, 19 Jan 2021 09:48:25 -0800
Message-Id: <1611078509-181959-6-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Define interfaces that allow the underlying memory object of an iova
range to be mapped to a new host virtual address in the host process:

  - VFIO_DMA_UNMAP_FLAG_VADDR for VFIO_IOMMU_UNMAP_DMA
  - VFIO_DMA_MAP_FLAG_VADDR flag for VFIO_IOMMU_MAP_DMA
  - VFIO_UPDATE_VADDR extension for VFIO_CHECK_EXTENSION

Unmap vaddr invalidates the host virtual address in an iova range, and
blocks vfio translation of host virtual addresses.  DMA to already-mapped
pages continues.  Map vaddr updates the base VA and resumes translation.
See comments in uapi/linux/vfio.h for more details.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 include/uapi/linux/vfio.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 55578b6..85bb89a 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -49,6 +49,9 @@
 /* Supports VFIO_DMA_UNMAP_FLAG_ALL */
 #define VFIO_UNMAP_ALL			9
 
+/* Supports the vaddr flag for DMA map and unmap */
+#define VFIO_UPDATE_VADDR		10
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -1049,12 +1052,22 @@ struct vfio_iommu_type1_info_cap_migration {
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
@@ -1090,12 +1103,18 @@ struct vfio_bitmap {
  *
  * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
  * must be 0.  This may not be combined with the get-dirty-bitmap flag.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_VADDR, do not unmap, but invalidate host
+ * virtual addresses in the iova range.  Tasks that attempt to translate an
+ * iova's vaddr will block.  DMA to already-mapped pages continues.  This may
+ * not be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
 #define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
+#define VFIO_DMA_UNMAP_FLAG_VADDR	     (1 << 2)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];
-- 
1.8.3.1

