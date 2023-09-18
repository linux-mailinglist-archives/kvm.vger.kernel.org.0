Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF497A5495
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 22:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjIRU5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 16:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbjIRU5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 16:57:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10EB114
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 13:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695070588;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BLJVBc/pzccugePJdqT4Or41HsOp/4DxwdzX8mZIktY=;
        b=GBuU2VNFIa7x2Rn1hpoRmVzTX+CZwhpfeD8MYztrOgaefg7qqz/Tnmr2oNSRcaNUf8dqG4
        jxCL2iy5w4gLIcKN/QGoyU71frml1AZfiJ3b6ETIbwgtXGq560Af38NwEGkSqi0TWcQTES
        Fz0hSHN188hJJ7bfX7NcSnEUQ+oAueE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-150-CjqjOcAdPzOEQ4KcAmIYmg-1; Mon, 18 Sep 2023 16:56:22 -0400
X-MC-Unique: CjqjOcAdPzOEQ4KcAmIYmg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96B51800883;
        Mon, 18 Sep 2023 20:56:21 +0000 (UTC)
Received: from localhost (unknown [10.39.195.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BD9040C2064;
        Mon, 18 Sep 2023 20:56:20 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v3 1/3] vfio: trivially use __aligned_u64 for ioctl structs
Date:   Mon, 18 Sep 2023 16:56:15 -0400
Message-ID: <20230918205617.1478722-2-stefanha@redhat.com>
In-Reply-To: <20230918205617.1478722-1-stefanha@redhat.com>
References: <20230918205617.1478722-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

u64 alignment behaves differently depending on the architecture and so
<uapi/linux/types.h> offers __aligned_u64 to achieve consistent behavior
in kernel<->userspace ABIs.

There are structs in <uapi/linux/vfio.h> that can trivially be updated
to __aligned_u64 because the struct sizes are multiples of 8 bytes.
There is no change in memory layout on any CPU architecture and
therefore this change is safe.

The commits that follow this one handle the trickier cases where
explanation about ABI breakage is necessary.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index afc1369216d9..4dc0182c6bcb 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -277,8 +277,8 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_FLAG_CAPS	(1 << 3) /* Info supports caps */
 	__u32	index;		/* Region index */
 	__u32	cap_offset;	/* Offset within info struct of first cap */
-	__u64	size;		/* Region size (bytes) */
-	__u64	offset;		/* Region offset from start of device fd */
+	__aligned_u64	size;	/* Region size (bytes) */
+	__aligned_u64	offset;	/* Region offset from start of device fd */
 };
 #define VFIO_DEVICE_GET_REGION_INFO	_IO(VFIO_TYPE, VFIO_BASE + 8)
 
@@ -294,8 +294,8 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_CAP_SPARSE_MMAP	1
 
 struct vfio_region_sparse_mmap_area {
-	__u64	offset;	/* Offset of mmap'able area within region */
-	__u64	size;	/* Size of mmap'able area */
+	__aligned_u64	offset;	/* Offset of mmap'able area within region */
+	__aligned_u64	size;	/* Size of mmap'able area */
 };
 
 struct vfio_region_info_cap_sparse_mmap {
@@ -450,9 +450,9 @@ struct vfio_device_migration_info {
 					     VFIO_DEVICE_STATE_V1_RESUMING)
 
 	__u32 reserved;
-	__u64 pending_bytes;
-	__u64 data_offset;
-	__u64 data_size;
+	__aligned_u64 pending_bytes;
+	__aligned_u64 data_offset;
+	__aligned_u64 data_size;
 };
 
 /*
@@ -476,7 +476,7 @@ struct vfio_device_migration_info {
 
 struct vfio_region_info_cap_nvlink2_ssatgt {
 	struct vfio_info_cap_header header;
-	__u64 tgt;
+	__aligned_u64 tgt;
 };
 
 /*
@@ -1449,7 +1449,7 @@ struct vfio_iommu_type1_info {
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
 #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
-	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
+	__aligned_u64	iova_pgsizes;		/* Bitmap of supported page sizes */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
 	__u32   pad;
 };
-- 
2.41.0

