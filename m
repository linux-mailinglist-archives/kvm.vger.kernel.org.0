Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522863F0386
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 14:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbhHRMKZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 08:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236763AbhHRMI6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 08:08:58 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB20FC0612A8
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 05:08:00 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k24so2014063pgh.8
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 05:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h3cBaHMfU52s7B4IKQZfv/Mv4AwRAWrj25gFgUhSo0U=;
        b=BSEezFXK8s9mIq1KmFaXULVeK3aSeyUogMR5eD4dSvtorIgyvtWBSxykWIDi2Mf8pr
         X5b162/G8WPmPUAGFLqIwL0ckm9Ys6EESEOmKMZOP0yUwunUWxu3972h2sop/3olzLJy
         +IddzNhjRBi9dNG9AR0ALhnxsPULvsgdBtWjeyQNb90yCiAG9ofU/B/rl//+ZPKJ4xvC
         +dt5yiC6AAS7EhGnuWJ7Q9BYkTy7pDDvx8baBuxDEgJnKxcO7qGyGDW7avh8GUwYddOo
         33vORXAaeWGUY3lf7K8R+UkAVom11YqRB/1UwDF/3jh8VGWc6YZBRKuzp3zS4SAgt24N
         IbFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h3cBaHMfU52s7B4IKQZfv/Mv4AwRAWrj25gFgUhSo0U=;
        b=l+eoGiR7eV9mVt9YN+lYutDpdS9kj6XxseUqsRTQjPybDbPe8MlksWnWpnqAkPIBeC
         Yq3BS6RWyG14dY+fq+hvEXEH+Nvd3TH0sEuHIoMsO6LXwbh2jl5wCOQGelCJ0bUEB72C
         mayY1qwdIgN8TRmtGR32LOIAxGi0+GpjVVtA4kEaxwtk402LOa8hczTTfQA2pYfbE+8A
         VdDnkq6D8bH2jZNVgGqinlTTnMPd++3OUj1qfW9Sl2Hxp2l5zmhZbTqdOwOkVm8eCdSN
         zfwcV7H9endYkw+wOozqHk5C1xOm6uj2fYyu0uOOdO1ZMBAx1CpNjo6VbyiHvYSYhXRb
         kAHQ==
X-Gm-Message-State: AOAM530uWxdnqwhMjp7PMUDEcgAibHS9AEWbN9vT3r2sH74xRIvsCEkZ
        0ugpE5gw2KJXBe0hQU2BUJOE
X-Google-Smtp-Source: ABdhPJylpJBebPvrUUXvngWerpOz2/KsXpZmy7xMNWLgfzpdybMKiIoAmHmo7Y5tBNvbw/zln+2/Kg==
X-Received: by 2002:a62:e90b:0:b029:30e:4530:8dca with SMTP id j11-20020a62e90b0000b029030e45308dcamr9110885pfh.17.1629288480323;
        Wed, 18 Aug 2021 05:08:00 -0700 (PDT)
Received: from localhost ([139.177.225.253])
        by smtp.gmail.com with ESMTPSA id 73sm6785078pfz.73.2021.08.18.05.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 05:07:59 -0700 (PDT)
From:   Xie Yongji <xieyongji@bytedance.com>
To:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com
Cc:     songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 04/12] vdpa: Add reset callback in vdpa_config_ops
Date:   Wed, 18 Aug 2021 20:06:34 +0800
Message-Id: <20210818120642.165-5-xieyongji@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120642.165-1-xieyongji@bytedance.com>
References: <20210818120642.165-1-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This adds a new callback to support device specific reset
behavior. The vdpa bus driver will call the reset function
instead of setting status to zero during resetting if device
driver supports the new callback.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
---
 drivers/vhost/vdpa.c |  9 +++++++--
 include/linux/vdpa.h | 11 ++++++++++-
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index b07aa161f7ad..b1c91b4db0ba 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -157,7 +157,7 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	u8 status, status_old;
-	int nvqs = v->nvqs;
+	int ret, nvqs = v->nvqs;
 	u16 i;
 
 	if (copy_from_user(&status, statusp, sizeof(status)))
@@ -172,7 +172,12 @@ static long vhost_vdpa_set_status(struct vhost_vdpa *v, u8 __user *statusp)
 	if (status != 0 && (ops->get_status(vdpa) & ~status) != 0)
 		return -EINVAL;
 
-	ops->set_status(vdpa, status);
+	if (status == 0 && ops->reset) {
+		ret = ops->reset(vdpa);
+		if (ret)
+			return ret;
+	} else
+		ops->set_status(vdpa, status);
 
 	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old & VIRTIO_CONFIG_S_DRIVER_OK))
 		for (i = 0; i < nvqs; i++)
diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
index 8a645f8f4476..af7ea5ad795f 100644
--- a/include/linux/vdpa.h
+++ b/include/linux/vdpa.h
@@ -196,6 +196,9 @@ struct vdpa_iova_range {
  *				@vdev: vdpa device
  *				Returns the iova range supported by
  *				the device.
+ * @reset:			Reset device (optional)
+ *				@vdev: vdpa device
+ *				Returns integer: success (0) or error (< 0)
  * @set_map:			Set device memory mapping (optional)
  *				Needed for device that using device
  *				specific DMA translation (on-chip IOMMU)
@@ -263,6 +266,7 @@ struct vdpa_config_ops {
 			   const void *buf, unsigned int len);
 	u32 (*get_generation)(struct vdpa_device *vdev);
 	struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
+	int (*reset)(struct vdpa_device *vdev);
 
 	/* DMA ops */
 	int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
@@ -351,12 +355,17 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
 	return vdev->dma_dev;
 }
 
-static inline void vdpa_reset(struct vdpa_device *vdev)
+static inline int vdpa_reset(struct vdpa_device *vdev)
 {
 	const struct vdpa_config_ops *ops = vdev->config;
 
 	vdev->features_valid = false;
+	if (ops->reset)
+		return ops->reset(vdev);
+
 	ops->set_status(vdev, 0);
+
+	return 0;
 }
 
 static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
-- 
2.11.0

