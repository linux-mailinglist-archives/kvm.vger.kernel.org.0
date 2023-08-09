Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E90F5776A0F
	for <lists+kvm@lfdr.de>; Wed,  9 Aug 2023 22:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234491AbjHIUdD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Aug 2023 16:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbjHIUc5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Aug 2023 16:32:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A40A2106
        for <kvm@vger.kernel.org>; Wed,  9 Aug 2023 13:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691613130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tz48GrTBzSUxnQ1VqRtR32fCLt9+pV1rjI76RU5Y25Q=;
        b=hJOYktI3qJL9UFBL3+rkeiiTEpFe0uAOhBwoWpSt/AtQ6N7iO1Nu+E5TKnIpmEbY4i0F5c
        1DTXSXwgYC+1bBqoyOAUXhktG7YUIKJlXClALzlufZ7okdRKtqI6PHoWhLRjiAnQdMRxga
        Ut0wPz4H2Psf6WNo9GuVaa7VPgGsoQc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-670-DsxpBh6kPfKUeEYKiQ6uXA-1; Wed, 09 Aug 2023 16:32:09 -0400
X-MC-Unique: DsxpBh6kPfKUeEYKiQ6uXA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00BFF857A84;
        Wed,  9 Aug 2023 20:32:09 +0000 (UTC)
Received: from localhost (unknown [10.39.192.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 701AC40D2839;
        Wed,  9 Aug 2023 20:32:08 +0000 (UTC)
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: [PATCH v3] vfio: align capability structures
Date:   Wed,  9 Aug 2023 16:31:44 -0400
Message-ID: <20230809203144.2880050-1-stefanha@redhat.com>
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

The VFIO_DEVICE_GET_INFO, VFIO_DEVICE_GET_REGION_INFO, and
VFIO_IOMMU_GET_INFO ioctls fill in an info struct followed by capability
structs:

  +------+---------+---------+-----+
  | info | caps[0] | caps[1] | ... |
  +------+---------+---------+-----+

Both the info and capability struct sizes are not always multiples of
sizeof(u64), leaving u64 fields in later capability structs misaligned.

Userspace applications currently need to handle misalignment manually in
order to support CPU architectures and programming languages with strict
alignment requirements.

Make life easier for userspace by ensuring alignment in the kernel. This
is done by padding info struct definitions and by copying out zeroes
after capability structs that are not aligned.

The new layout is as follows:

  +------+---------+---+---------+-----+
  | info | caps[0] | 0 | caps[1] | ... |
  +------+---------+---+---------+-----+

In this example caps[0] has a size that is not multiples of sizeof(u64),
so zero padding is added to align the subsequent structure.

Adding zero padding between structs does not break the uapi. The memory
layout is specified by the info.cap_offset and caps[i].next fields
filled in by the kernel. Applications use these field values to locate
structs and are therefore unaffected by the addition of zero padding.

Note that code that copies out info structs with padding is updated to
always zero the struct and copy out as many bytes as userspace
requested. This makes the code shorter and avoids potential information
leaks by ensuring padding is initialized.

Originally-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
v3:
- Also align capability structs in drivers/iommu/iommufd/vfio_compat.c
  [Jason]

 include/uapi/linux/vfio.h           |  2 ++
 drivers/iommu/iommufd/vfio_compat.c |  2 ++
 drivers/vfio/pci/vfio_pci_core.c    | 11 ++---------
 drivers/vfio/vfio_iommu_type1.c     | 11 ++---------
 drivers/vfio/vfio_main.c            |  6 ++++++
 5 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 20c804bdc09c..8fe85f5c7b61 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -217,6 +217,7 @@ struct vfio_device_info {
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
+	__u32   pad;
 };
 #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
 
@@ -1304,6 +1305,7 @@ struct vfio_iommu_type1_info {
 #define VFIO_IOMMU_INFO_CAPS	(1 << 1)	/* Info supports caps */
 	__u64	iova_pgsizes;	/* Bitmap of supported page sizes */
 	__u32   cap_offset;	/* Offset within info struct of first cap */
+	__u32   pad;
 };
 
 /*
diff --git a/drivers/iommu/iommufd/vfio_compat.c b/drivers/iommu/iommufd/vfio_compat.c
index fe02517c73cc..6c810bf80f99 100644
--- a/drivers/iommu/iommufd/vfio_compat.c
+++ b/drivers/iommu/iommufd/vfio_compat.c
@@ -483,6 +483,8 @@ static int iommufd_vfio_iommu_get_info(struct iommufd_ctx *ictx,
 			rc = cap_size;
 			goto out_put;
 		}
+		cap_size = ALIGN(cap_size, sizeof(u64));
+
 		if (last_cap && info.argsz >= total_cap_size &&
 		    put_user(total_cap_size, &last_cap->next)) {
 			rc = -EFAULT;
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 20d7b69ea6ff..e2ba2a350f6c 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -920,24 +920,17 @@ static int vfio_pci_ioctl_get_info(struct vfio_pci_core_device *vdev,
 				   struct vfio_device_info __user *arg)
 {
 	unsigned long minsz = offsetofend(struct vfio_device_info, num_irqs);
-	struct vfio_device_info info;
+	struct vfio_device_info info = {};
 	struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
-	unsigned long capsz;
 	int ret;
 
-	/* For backward compatibility, cannot require this */
-	capsz = offsetofend(struct vfio_iommu_type1_info, cap_offset);
-
 	if (copy_from_user(&info, arg, minsz))
 		return -EFAULT;
 
 	if (info.argsz < minsz)
 		return -EINVAL;
 
-	if (info.argsz >= capsz) {
-		minsz = capsz;
-		info.cap_offset = 0;
-	}
+	minsz = min_t(size_t, info.argsz, sizeof(info));
 
 	info.flags = VFIO_DEVICE_FLAGS_PCI;
 
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ebe0ad31d0b0..f812c475a626 100644
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
+	minsz = min_t(size_t, info.argsz, sizeof(info));
 
 	mutex_lock(&iommu->lock);
 	info.flags = VFIO_IOMMU_INFO_PGSIZES;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index f0ca33b2e1df..2850478301d2 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1172,6 +1172,9 @@ struct vfio_info_cap_header *vfio_info_cap_add(struct vfio_info_cap *caps,
 	void *buf;
 	struct vfio_info_cap_header *header, *tmp;
 
+	/* Ensure that the next capability struct will be aligned */
+	size = ALIGN(size, sizeof(u64));
+
 	buf = krealloc(caps->buf, caps->size + size, GFP_KERNEL);
 	if (!buf) {
 		kfree(caps->buf);
@@ -1205,6 +1208,9 @@ void vfio_info_cap_shift(struct vfio_info_cap *caps, size_t offset)
 	struct vfio_info_cap_header *tmp;
 	void *buf = (void *)caps->buf;
 
+	/* Capability structs should start with proper alignment */
+	WARN_ON(!IS_ALIGNED(offset, sizeof(u64)));
+
 	for (tmp = buf; tmp->next; tmp = buf + tmp->next - offset)
 		tmp->next += offset;
 }
-- 
2.41.0

