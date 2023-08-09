Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87269776AAB
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 23:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjHIVEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 17:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjHIVEa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 17:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 823A71BD9
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 14:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691615023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Dj3+t39K/qBj5MrzSksnLCUG1VrR0qcfWhwfuxcrlk=;
        b=Gku1CW8a5Ktaq+W2jv5V5ntYYIZTCQd6clONwxXQgMobAeWB23DeYBtZuY0zSMktpJuWyd
        CeKLiZqLcPX3WIWj7jaK65Y3sa1pmLgllIhM48uTQ/5+MZQslmhqfjMpPhOtQbrX4tpPZz
        9D5CdwtihBxAxum7vZRjLwY/jfGTh2k=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-696-l9RuCBQtNjyNy_v5wdxC-Q-1; Wed, 09 Aug 2023 17:03:39 -0400
X-MC-Unique: l9RuCBQtNjyNy_v5wdxC-Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31D3B2999B26;
        Wed,  9 Aug 2023 21:03:39 +0000 (UTC)
Received: from localhost (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AC59C15BAE;
        Wed,  9 Aug 2023 21:03:38 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Tian, Kevin" <kevin.tian@intel.com>, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH 3/4] vfio: use __aligned_u64 in struct vfio_iommu_type1_info
Date:   Wed,  9 Aug 2023 17:02:47 -0400
Message-ID: <20230809210248.2898981-4-stefanha@redhat.com>
In-Reply-To: <20230809210248.2898981-1-stefanha@redhat.com>
References: <20230809210248.2898981-1-stefanha@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory layout of struct vfio_iommu_type1_info is
architecture-dependent due to a u64 field and a struct size that is not
a multiple of 8 bytes:
- On x86_64 the struct size is padded to a multiple of 8 bytes.
- On x32 the struct size is only a multiple of 4 bytes, not 8.
- Other architectures may vary.

Use __aligned_u64 to make memory layout consistent. This reduces the
chance of holes that result in an information leak and the chance that
32-bit userspace on a 64-bit kernel breakage.

This patch increases the struct size on x32 but this is safe because of
the struct's argsz field. The kernel may grow the struct as long as it
still supports smaller argsz values from userspace (e.g. applications
compiled against older kernel headers).

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
 include/uapi/linux/vfio.h       |  3 ++-
 drivers/vfio/vfio_iommu_type1.c | 11 ++---------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 45db62d74064..0b5786ec50d8 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1303,8 +1303,9 @@ struct vfio_iommu_type1_info {
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
 #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
-	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
+	__aligned_u64	iova_pgsizes;		/* Bitmap of supported page sizes */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
+	__u32   reserved;
 };
 
 /*
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ebe0ad31d0b0..f51159a7a4de 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2762,27 +2762,20 @@ static int vfio_iommu_dma_avail_build_caps(struct vfio_iommu *iommu,
 static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
 				     unsigned long arg)
 {
-	struct vfio_iommu_type1_info info;
+	struct vfio_iommu_type1_info info = {};
 	unsigned long minsz;
 	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
-	unsigned long capsz;
 	int ret;
 
 	minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
 
-	/* For backward compatibility, cannot require this */
-	capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
-
 	if (copy_from_user(&info, (void __user *)arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz)
 		return -EINVAL;
 
-	if (info.argsz >= capsz) {
-		minsz = capsz;
-		info.cap_offset = 0; /* output, no-recopy necessary */
-	}
+	minsz = min_t(unsigned long, info.argsz, sizeof(info));
 
 	mutex_lock(&iommu->lock);
 	info.flags = VFIO_IOMMU_INFO_PGSIZES;
-- 
2.41.0

