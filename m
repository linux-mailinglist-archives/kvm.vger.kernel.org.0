Return-Path: <kvm+bounces-53895-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D90B19FD6
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 12:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 065963BA663
	for <lists+kvm@lfdr.de>; Mon,  4 Aug 2025 10:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EB1E252917;
	Mon,  4 Aug 2025 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="sFnirjUT"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C7724C68D
	for <kvm@vger.kernel.org>; Mon,  4 Aug 2025 10:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.176.194.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754304095; cv=none; b=JaphNalw5wSLnxnhohuZNthhc9681kk+xKEpWOXSTLn32G2LC+Wg3wopFy4+J0pJI71AfJtuvJoCQnObJtGdsEwFtwDpXgF+4tlgPU4vGySmmlsFkjqXM8lV+nydPioXwqO+eET3Zy0qLZzlNqJeY7ADvsRYj5T4rE/Gs1CQj58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754304095; c=relaxed/simple;
	bh=5CxKrs9Yg7JOtPPBLOLEbwTBds1RoSB/ZDLyW3oRzbg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=meG31ZwX+FBQncRrVeN6VuqDYU6+NEJw6eV52p5pLqN4v3ta5in8H8F6DtPyZCGZ+Te9T67pmJ0p0hSYNf+HOnhtyiifVPYX9H2VyY1xQtjE2w6OqrgrEDe72n/3wPX5qdcfrNVmUPmo2HLI1Tw7zA2ZCUWf24TAoLKypijykZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=sFnirjUT; arc=none smtp.client-ip=63.176.194.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1754304093; x=1785840093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YbmtEjbp/iQbkmVpz8Zvkh7EZtXJ2RPf2aWQlqkwa0o=;
  b=sFnirjUTg/tvQYbRPtlZp26b/8fyhMCaIEFAS/kTAnEsdvkuuTSmONeU
   0dfZji57TbUwxg6KUjL2LkflRs+dcUTsM2+5Y3ZtzH4bI09B7sCSwmb5R
   W8JoEHRuHV1kxUuZafmOKn8oV5WKnDscGqR9GfbvUF/MwNtGRWc3E5xX4
   T9cWwq8j+6rpNcV0fNdqxgQdzj2d5EdQYLNQJ0Ne4sCcy45rSPCcwuHhv
   nARWLuFFl4YOAxOT+/Eb1bRx2ipfNlsvGXCjXimEavE1wS6fBMYRW2Ith
   tHa96kV8YnUNa5RBhpLBAsU2KJTdWrHqZXE7CjZMVURM8IF9xh6KBgTLi
   A==;
X-CSE-ConnectionGUID: QsbzCHWoRX6LLT1mkzvRyw==
X-CSE-MsgGUID: jIx61ZYDRL68sbFr9cV7Kw==
X-IronPort-AV: E=Sophos;i="6.17,258,1747699200"; 
   d="scan'208";a="529728"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-west-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 10:41:23 +0000
Received: from EX19MTAEUC001.ant.amazon.com [10.0.17.79:64644]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.27.198:2525] with esmtp (Farcaster)
 id b963e06a-288f-472e-ace8-0bce159cbecb; Mon, 4 Aug 2025 10:41:22 +0000 (UTC)
X-Farcaster-Flow-ID: b963e06a-288f-472e-ace8-0bce159cbecb
Received: from EX19D039EUC004.ant.amazon.com (10.252.61.190) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Mon, 4 Aug 2025 10:41:22 +0000
Received: from dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com
 (10.253.107.175) by EX19D039EUC004.ant.amazon.com (10.252.61.190) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14; Mon, 4 Aug 2025
 10:41:19 +0000
From: Mahmoud Adam <mngyadam@amazon.de>
To: <kvm@vger.kernel.org>
CC: <alex.williamson@redhat.com>, <jgg@ziepe.ca>, <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>, <pravkmr@amazon.de>,
	<nagy@khwaternagy.com>
Subject: [RFC PATCH 1/9] vfio: add mmap maple tree to vfio
Date: Mon, 4 Aug 2025 12:39:54 +0200
Message-ID: <20250804104012.87915-2-mngyadam@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804104012.87915-1-mngyadam@amazon.de>
References: <20250804104012.87915-1-mngyadam@amazon.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D044UWB002.ant.amazon.com (10.13.139.188) To
 EX19D039EUC004.ant.amazon.com (10.252.61.190)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

add mmap maple tree for vfio_device_file, this allows vfio devices to
create per mmap request options. the vfio device needs to
insert/allocate the region range offset & size and make it accessible
for the user, probably when the user is calling
DEVICE_GET_REGION_INFO, and then vfio uses the maple_tree to find the
entry (vfio_mmap) needed for mmap op, this adds the vfio_mmap_init &
vfio_mmap_free for initialization and freeing the entry, the freeing
is done through the free callback in the vfio_mmap_ops, which
vfio_devices should implement if they are allocating an entry.

Signed-off-by: Mahmoud Adam <mngyadam@amazon.de>
---
I didn't find a situation where we would need to use ref counting for
now, so I didn't implement it, I think most cases are already handled
by file ref counting, but maybe I'm overlooking something here.

 drivers/vfio/vfio.h      |  1 +
 drivers/vfio/vfio_main.c | 29 +++++++++++++++++++++++++++++
 include/linux/vfio.h     | 17 +++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 50128da18bcaf..3f0cf2dd41116 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -19,6 +19,7 @@ struct vfio_container;
 struct vfio_device_file {
 	struct vfio_device *device;
 	struct vfio_group *group;
+	struct maple_tree mmap_mt;
 
 	u8 access_granted;
 	u32 devid; /* only valid when iommufd is valid */
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1fd261efc582d..4c4af4de60d12 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -39,6 +39,7 @@
 #include <linux/interval_tree.h>
 #include <linux/iova_bitmap.h>
 #include <linux/iommufd.h>
+#include <linux/maple_tree.h>
 #include "vfio.h"
 
 #define DRIVER_VERSION	"0.3"
@@ -498,6 +499,7 @@ vfio_allocate_device_file(struct vfio_device *device)
 
 	df->device = device;
 	spin_lock_init(&df->kvm_ref_lock);
+	mt_init_flags(&df->mmap_mt, MT_FLAGS_ALLOC_RANGE);
 
 	return df;
 }
@@ -622,6 +624,25 @@ static inline void vfio_device_pm_runtime_put(struct vfio_device *device)
 		pm_runtime_put(dev);
 }
 
+void vfio_mmap_init(struct vfio_device *vdev, struct vfio_mmap *vmmap,
+		    u32 region_flags, u64 offset, u64 size,
+		    struct vfio_mmap_ops *ops)
+{
+	vmmap->owner = vdev;
+	vmmap->offset = offset;
+	vmmap->ops = ops;
+	vmmap->size = size;
+	vmmap->region_flags = region_flags;
+}
+EXPORT_SYMBOL_GPL(vfio_mmap_init);
+
+void vfio_mmap_free(struct vfio_mmap *vmmap)
+{
+	if (vmmap->ops && vmmap->ops->free)
+		vmmap->ops->free(vmmap);
+}
+EXPORT_SYMBOL_GPL(vfio_mmap_free);
+
 /*
  * VFIO Device fd
  */
@@ -629,14 +650,22 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	struct vfio_mmap *vmmap;
+	unsigned long index = 0;
 
 	if (df->group)
 		vfio_df_group_close(df);
 	else
 		vfio_df_unbind_iommufd(df);
 
+	mt_for_each(&df->mmap_mt, vmmap, index, ULONG_MAX) {
+		mtree_erase(&df->mmap_mt, index);
+		vfio_mmap_free(vmmap);
+	}
+
 	vfio_device_put_registration(device);
 
+	mtree_destroy(&df->mmap_mt);
 	kfree(df);
 
 	return 0;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 707b00772ce1f..6e0aca05aa406 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -80,6 +80,19 @@ struct vfio_device {
 #endif
 };
 
+struct vfio_mmap {
+	struct vfio_device *owner;
+	u64 offset;
+	u64 size;
+	u32 region_flags;
+	struct vfio_mmap_ops *ops;
+};
+
+struct vfio_mmap_ops {
+	void	(*free)(struct vfio_mmap *vmmap);
+};
+
+
 /**
  * struct vfio_device_ops - VFIO bus driver device callbacks
  *
@@ -338,6 +351,10 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
 void vfio_unpin_pages(struct vfio_device *device, dma_addr_t iova, int npage);
 int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova,
 		void *data, size_t len, bool write);
+void vfio_mmap_init(struct vfio_device *vdev, struct vfio_mmap *vmmap,
+		    u32 region_flags, u64 offset, u64 size,
+		    struct vfio_mmap_ops *ops);
+void vfio_mmap_free(struct vfio_mmap *vmmap);
 
 /*
  * Sub-module helpers
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


