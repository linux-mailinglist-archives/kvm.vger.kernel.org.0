Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A96776AA7
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 23:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjHIVEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 17:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjHIVEV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 17:04:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB692138
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 14:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691615016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wyGZDO6+cs0Dn/l2naooCm9LYp0IvC76ZpjNX9Hb8V4=;
        b=Bru75B7S4xAyoqb3OI30B6++ywPZeXByR0SL46EBtoK9GXhICoHMVy8zPer2cekKulxYYz
        TMMq/ybfdCpyRJXoZ7LtDkzr63bWEWrf88PbrPAh1Hg5YHyXKju1uWR4x9E7Yc8ihJXrYu
        eocMV5m0QteEqnDKbXp4c+2UWFgVcvk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-kXMhG4BlMWOXEsD45UptFQ-1; Wed, 09 Aug 2023 17:03:34 -0400
X-MC-Unique: kXMhG4BlMWOXEsD45UptFQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4774E2999B23;
        Wed,  9 Aug 2023 21:03:34 +0000 (UTC)
Received: from localhost (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8D3C140E914;
        Wed,  9 Aug 2023 21:03:17 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 1/4] vfio: trivially use __aligned_u64 for ioctl structs
Date:   Wed,  9 Aug 2023 17:02:45 -0400
Message-ID: <20230809210248.2898981-2-stefanha@redhat.com>
In-Reply-To: <20230809210248.2898981-1-stefanha@redhat.com>
References: <20230809210248.2898981-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
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

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 20c804bdc09c..b1dfcf3b7665 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -276,8 +276,8 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_FLAG_CAPS	(1 << 3) /* Info supports caps */
 	__u32	index;		/* Region index */
 	__u32	cap_offset;	/* Offset within info struct of first cap */
-	__u64	size;		/* Region size (bytes) */
-	__u64	offset;		/* Region offset from start of device fd */
+	__aligned_u64	size;	/* Region size (bytes) */
+	__aligned_u64	offset;	/* Region offset from start of device fd */
 };
 #define VFIO_DEVICE_GET_REGION_INFO	_IO(VFIO_TYPE, VFIO_BASE + 8)
 
@@ -293,8 +293,8 @@ struct vfio_region_info {
 #define VFIO_REGION_INFO_CAP_SPARSE_MMAP	1
 
 struct vfio_region_sparse_mmap_area {
-	__u64	offset;	/* Offset of mmap'able area within region */
-	__u64	size;	/* Size of mmap'able area */
+	__aligned_u64	offset;	/* Offset of mmap'able area within region */
+	__aligned_u64	size;	/* Size of mmap'able area */
 };
 
 struct vfio_region_info_cap_sparse_mmap {
@@ -449,9 +449,9 @@ struct vfio_device_migration_info {
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
@@ -475,7 +475,7 @@ struct vfio_device_migration_info {
 
 struct vfio_region_info_cap_nvlink2_ssatgt {
 	struct vfio_info_cap_header header;
-	__u64 tgt;
+	__aligned_u64 tgt;
 };
 
 /*
-- 
2.41.0

