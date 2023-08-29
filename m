Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2AB78CC16
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 20:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238097AbjH2S3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 14:29:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238098AbjH2S3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 14:29:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E8D19F
        for <kvm@vger.kernel.org>; Tue, 29 Aug 2023 11:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693333677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Mk1FOmX7wMonn07S4mKNEYI4AkKcNYnYkjDJ92TTAB0=;
        b=YgMalnJpj4U7x+m06p1YlCt0W6IluueKo1Yn4yhbaEmE5EvYSWLXWEj5RYtqRmJ5/fdWwX
        GEk91QteqKrKFMuyAHEv0GL21EJs3g2hnOInVAYKFaaZGRYuU9wfI2GJbRuuH3in+o8C10
        Vdd8t99Y29HUoyo3cRsxmka1reRIBeI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-679-zSRMaMgfO4WdjIbmAU4BMw-1; Tue, 29 Aug 2023 14:27:53 -0400
X-MC-Unique: zSRMaMgfO4WdjIbmAU4BMw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A7DD101AA4E;
        Tue, 29 Aug 2023 18:27:53 +0000 (UTC)
Received: from localhost (unknown [10.39.192.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C17C240C6F4C;
        Tue, 29 Aug 2023 18:27:52 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     David Laight <David.Laight@ACULAB.COM>,
        linux-kernel@vger.kernel.org, "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 1/3] vfio: trivially use __aligned_u64 for ioctl structs
Date:   Tue, 29 Aug 2023 14:27:18 -0400
Message-ID: <20230829182720.331083-2-stefanha@redhat.com>
In-Reply-To: <20230829182720.331083-1-stefanha@redhat.com>
References: <20230829182720.331083-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index f9c6f3e2cf6e..94007ca348ed 100644
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
@@ -1443,7 +1443,7 @@ struct vfio_iommu_type1_info {
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

