Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7805C2FBEEC
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 19:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392534AbhASS0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 13:26:14 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48146 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbhASSQr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jan 2021 13:16:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JI9Ujr129644;
        Tue, 19 Jan 2021 18:16:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=Jht8y0GDOpOhrB/UuJl9RZfl5NEsnAsBx4Quts4qYrY=;
 b=VsJGtCyy/gHugQPybD95kO8TPL/bKU14YxLQFoj+N0sk0I/eEKNk1exCs9peV8wHux1J
 fjivDVgOmCm6mHgGYQuUSfstzoBnXV0U1m38Vwv6PCfEe9WbXNF/CRT8du0uTFUlos0B
 XxCD7oXj/hgHAKdJ7C2vfYdYgTnzhzepCOEuoJPA7AUcLVuOzF7+LucbUzwBf7vGVPv5
 HO6UogPcpc0T3k6NBasrM8pWmUh/FYyn9AOewx7RtcPDStunxg89td8PqT195bSPeoAd
 NquJ+9OY19DGjhkx3nP3XjpSV6D7d9XGSL69D3xDNBMSKriBuQPsnGn3oD0ef8VRyKo3 Iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 363xyhsrrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JIBdp7079540;
        Tue, 19 Jan 2021 18:16:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 3661njmm8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 18:16:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JIFxVX018594;
        Tue, 19 Jan 2021 18:15:59 GMT
Received: from ca-dev63.us.oracle.com (/10.211.8.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 10:15:59 -0800
From:   Steve Sistare <steven.sistare@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Steve Sistare <steven.sistare@oracle.com>
Subject: [PATCH V2 1/9] vfio: option to unmap all
Date:   Tue, 19 Jan 2021 09:48:21 -0800
Message-Id: <1611078509-181959-2-git-send-email-steven.sistare@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
References: <1611078509-181959-1-git-send-email-steven.sistare@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190102
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9869 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=1 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the UNMAP_DMA ioctl, delete all mappings if VFIO_DMA_UNMAP_FLAG_ALL
is set.  Define the corresponding VFIO_UNMAP_ALL extension.

Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
---
 include/uapi/linux/vfio.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9204705..55578b6 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -46,6 +46,9 @@
  */
 #define VFIO_NOIOMMU_IOMMU		8
 
+/* Supports VFIO_DMA_UNMAP_FLAG_ALL */
+#define VFIO_UNMAP_ALL			9
+
 /*
  * The IOCTL interface is designed for extensibility by embedding the
  * structure length (argsz) and flags into structures passed between
@@ -1074,6 +1077,7 @@ struct vfio_bitmap {
  * field.  No guarantee is made to the user that arbitrary unmaps of iova
  * or size different from those used in the original mapping call will
  * succeed.
+ *
  * VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP should be set to get the dirty bitmap
  * before unmapping IO virtual addresses. When this flag is set, the user must
  * provide a struct vfio_bitmap in data[]. User must provide zero-allocated
@@ -1083,11 +1087,15 @@ struct vfio_bitmap {
  * indicates that the page at that offset from iova is dirty. A Bitmap of the
  * pages in the range of unmapped size is returned in the user-provided
  * vfio_bitmap.data.
+ *
+ * If flags & VFIO_DMA_UNMAP_FLAG_ALL, unmap all addresses.  iova and size
+ * must be 0.  This may not be combined with the get-dirty-bitmap flag.
  */
 struct vfio_iommu_type1_dma_unmap {
 	__u32	argsz;
 	__u32	flags;
 #define VFIO_DMA_UNMAP_FLAG_GET_DIRTY_BITMAP (1 << 0)
+#define VFIO_DMA_UNMAP_FLAG_ALL		     (1 << 1)
 	__u64	iova;				/* IO virtual address */
 	__u64	size;				/* Size of mapping (bytes) */
 	__u8    data[];
-- 
1.8.3.1

