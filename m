Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 583BF209717
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 01:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbgFXXVc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jun 2020 19:21:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728035AbgFXXV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jun 2020 19:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593040887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1qVm+qFHpBcFnajiwKWBoYJyF5SCnRnSLqkqB/nC2LI=;
        b=jFkzpH9owUc8bZLwn1UaSk89u6eTTma4xsChaQTztd2coDNmdyqW3VAVR+dPTunQqZX3/2
        U7/Tvyi0Yb0TkydH6yusCE2js+ur42hzFDpd2tzRpLX2M2Wjkr7FdrB4GDdIQ6+RJ5ULxI
        x/ZgWoa013gMBfmENfHn5OgiZdir4lE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-wMnrbZdRNN-TAcYD-NhjYQ-1; Wed, 24 Jun 2020 19:21:25 -0400
X-MC-Unique: wMnrbZdRNN-TAcYD-NhjYQ-1
Received: by mail-wm1-f70.google.com with SMTP id a21so4660786wmd.0
        for <kvm@vger.kernel.org>; Wed, 24 Jun 2020 16:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1qVm+qFHpBcFnajiwKWBoYJyF5SCnRnSLqkqB/nC2LI=;
        b=QeKG7+Gh/YzVvassk3QICntBWquTsBHuTjv+KIqon3N0D683Q9ryK5OBPrjF70JWBO
         WCcgJEEiBB6f9L3mD/UZ1C9fP9VLZXV/TqExZ2uuK0igHCHPBSqwzcxepulZtcBAW5db
         7BZeHhhkCXjo6F8B2BHjgnkUpNULqi6kDkNgOA+4sMASEUjYAp2qSd98iMHJ4XO0hoDv
         mZwfieNC0kxYsEO8t7kZ6SM4thZXCD4lv778Y0WOWgfhunpuwo9wQdsQvMvL4RMQOCHb
         sc8B0heo/alew0RMoGUzdfzq0FZkXH2JT47K6Rd/F4xMvcImOQIsa43gjKt0srQp7mYQ
         9v8A==
X-Gm-Message-State: AOAM531EbfxYaPVFWjHeFiqXsuQPlNY9iF7t6xaJuoVcV4M69J6Nazbk
        VJzvpFpkK9IWMa8qq1J2dXgzDonvTFAcigMEg4BFkqiufQVqJEUuJP0uke/XESkrW/PGJSZXRjN
        P+r06hNn4pmBi
X-Received: by 2002:adf:9205:: with SMTP id 5mr31880033wrj.232.1593040884077;
        Wed, 24 Jun 2020 16:21:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqFyNRbJvNmvq82fhlM5himBZXXkAKRBOYQGCEH/gPc8s0pO7SeqL9CkzgxhVJ/ckX6aHU5w==
X-Received: by 2002:adf:9205:: with SMTP id 5mr31880025wrj.232.1593040883843;
        Wed, 24 Jun 2020 16:21:23 -0700 (PDT)
Received: from redhat.com (bzq-79-182-31-92.red.bezeqint.net. [79.182.31.92])
        by smtp.gmail.com with ESMTPSA id c206sm10725877wmf.36.2020.06.24.16.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 16:21:23 -0700 (PDT)
Date:   Wed, 24 Jun 2020 19:21:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 1/2] virtio: VIRTIO_F_IOMMU_PLATFORM ->
 VIRTIO_F_ACCESS_PLATFORM
Message-ID: <20200624232035.704217-2-mst@redhat.com>
References: <20200624232035.704217-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624232035.704217-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the bit to match latest virtio spec.
Add a compat macro to avoid breaking existing userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/um/drivers/virtio_uml.c       |  2 +-
 drivers/vdpa/ifcvf/ifcvf_base.h    |  2 +-
 drivers/vdpa/vdpa_sim/vdpa_sim.c   |  4 ++--
 drivers/vhost/net.c                |  4 ++--
 drivers/vhost/vdpa.c               |  2 +-
 drivers/virtio/virtio_balloon.c    |  2 +-
 drivers/virtio/virtio_ring.c       |  2 +-
 include/linux/virtio_config.h      |  2 +-
 include/uapi/linux/virtio_config.h | 10 +++++++---
 tools/virtio/linux/virtio_config.h |  2 +-
 10 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 351aee52aca6..a6c4bb6c2c01 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -385,7 +385,7 @@ static irqreturn_t vu_req_interrupt(int irq, void *data)
 		}
 		break;
 	case VHOST_USER_SLAVE_IOTLB_MSG:
-		/* not supported - VIRTIO_F_IOMMU_PLATFORM */
+		/* not supported - VIRTIO_F_ACCESS_PLATFORM */
 	case VHOST_USER_SLAVE_VRING_HOST_NOTIFIER_MSG:
 		/* not supported - VHOST_USER_PROTOCOL_F_HOST_NOTIFIER */
 	default:
diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
index f4554412e607..24af422b5a3e 100644
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -29,7 +29,7 @@
 		 (1ULL << VIRTIO_F_VERSION_1)			| \
 		 (1ULL << VIRTIO_NET_F_STATUS)			| \
 		 (1ULL << VIRTIO_F_ORDER_PLATFORM)		| \
-		 (1ULL << VIRTIO_F_IOMMU_PLATFORM)		| \
+		 (1ULL << VIRTIO_F_ACCESS_PLATFORM)		| \
 		 (1ULL << VIRTIO_NET_F_MRG_RXBUF))
 
 /* Only one queue pair for now. */
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index c7334cc65bb2..a9bc5e0fb353 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -55,7 +55,7 @@ struct vdpasim_virtqueue {
 
 static u64 vdpasim_features = (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			      (1ULL << VIRTIO_F_VERSION_1)  |
-			      (1ULL << VIRTIO_F_IOMMU_PLATFORM);
+			      (1ULL << VIRTIO_F_ACCESS_PLATFORM);
 
 /* State of each vdpasim device */
 struct vdpasim {
@@ -450,7 +450,7 @@ static int vdpasim_set_features(struct vdpa_device *vdpa, u64 features)
 	struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
 
 	/* DMA mapping must be done by driver */
-	if (!(features & (1ULL << VIRTIO_F_IOMMU_PLATFORM)))
+	if (!(features & (1ULL << VIRTIO_F_ACCESS_PLATFORM)))
 		return -EINVAL;
 
 	vdpasim->features = features & vdpasim_features;
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index e992decfec53..8e0921d3805d 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -73,7 +73,7 @@ enum {
 	VHOST_NET_FEATURES = VHOST_FEATURES |
 			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
 			 (1ULL << VIRTIO_NET_F_MRG_RXBUF) |
-			 (1ULL << VIRTIO_F_IOMMU_PLATFORM)
+			 (1ULL << VIRTIO_F_ACCESS_PLATFORM)
 };
 
 enum {
@@ -1653,7 +1653,7 @@ static int vhost_net_set_features(struct vhost_net *n, u64 features)
 	    !vhost_log_access_ok(&n->dev))
 		goto out_unlock;
 
-	if ((features & (1ULL << VIRTIO_F_IOMMU_PLATFORM))) {
+	if ((features & (1ULL << VIRTIO_F_ACCESS_PLATFORM))) {
 		if (vhost_init_device_iotlb(&n->dev, true))
 			goto out_unlock;
 	}
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index a54b60d6623f..18869a35d408 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -31,7 +31,7 @@ enum {
 		(1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
 		(1ULL << VIRTIO_F_ANY_LAYOUT) |
 		(1ULL << VIRTIO_F_VERSION_1) |
-		(1ULL << VIRTIO_F_IOMMU_PLATFORM) |
+		(1ULL << VIRTIO_F_ACCESS_PLATFORM) |
 		(1ULL << VIRTIO_F_RING_PACKED) |
 		(1ULL << VIRTIO_F_ORDER_PLATFORM) |
 		(1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1f157d2f4952..fc7301406540 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -1120,7 +1120,7 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
-	__virtio_clear_bit(vdev, VIRTIO_F_IOMMU_PLATFORM);
+	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
 
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 58b96baa8d48..a1a5c2a91426 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2225,7 +2225,7 @@ void vring_transport_features(struct virtio_device *vdev)
 			break;
 		case VIRTIO_F_VERSION_1:
 			break;
-		case VIRTIO_F_IOMMU_PLATFORM:
+		case VIRTIO_F_ACCESS_PLATFORM:
 			break;
 		case VIRTIO_F_RING_PACKED:
 			break;
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index bb4cc4910750..f2cc2a0df174 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -171,7 +171,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
 	 * Note the reverse polarity of the quirk feature (compared to most
 	 * other features), this is for compatibility with legacy systems.
 	 */
-	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
+	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
 }
 
 static inline
diff --git a/include/uapi/linux/virtio_config.h b/include/uapi/linux/virtio_config.h
index ff8e7dc9d4dd..b5eda06f0d57 100644
--- a/include/uapi/linux/virtio_config.h
+++ b/include/uapi/linux/virtio_config.h
@@ -67,13 +67,17 @@
 #define VIRTIO_F_VERSION_1		32
 
 /*
- * If clear - device has the IOMMU bypass quirk feature.
- * If set - use platform tools to detect the IOMMU.
+ * If clear - device has the platform DMA (e.g. IOMMU) bypass quirk feature.
+ * If set - use platform DMA tools to access the memory.
  *
  * Note the reverse polarity (compared to most other features),
  * this is for compatibility with legacy systems.
  */
-#define VIRTIO_F_IOMMU_PLATFORM		33
+#define VIRTIO_F_ACCESS_PLATFORM	33
+#ifndef __KERNEL__
+/* Legacy name for VIRTIO_F_ACCESS_PLATFORM (for compatibility with old userspace) */
+#define VIRTIO_F_IOMMU_PLATFORM		VIRTIO_F_ACCESS_PLATFORM
+#endif /* __KERNEL__ */
 
 /* This feature indicates support for the packed virtqueue layout. */
 #define VIRTIO_F_RING_PACKED		34
diff --git a/tools/virtio/linux/virtio_config.h b/tools/virtio/linux/virtio_config.h
index dbf14c1e2188..f99ae42668e0 100644
--- a/tools/virtio/linux/virtio_config.h
+++ b/tools/virtio/linux/virtio_config.h
@@ -51,7 +51,7 @@ static inline bool virtio_has_iommu_quirk(const struct virtio_device *vdev)
 	 * Note the reverse polarity of the quirk feature (compared to most
 	 * other features), this is for compatibility with legacy systems.
 	 */
-	return !virtio_has_feature(vdev, VIRTIO_F_IOMMU_PLATFORM);
+	return !virtio_has_feature(vdev, VIRTIO_F_ACCESS_PLATFORM);
 }
 
 static inline bool virtio_is_little_endian(struct virtio_device *vdev)
-- 
MST

