Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBBF594E67
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 04:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiHPCDT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 22:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbiHPCB7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 22:01:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 597F5108945
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 14:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660600449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fg6AseMQKhGFaW1h59Li+nNVbNoTUAPXOEzU4kFeR3k=;
        b=DbjMH/AoK5rRTRtNRZEC2HLt9D5ui/A4IBUJB+ICC+Rs77LXvj64AQq5QVIFuzunyEcWdj
        BAMrV714PZOh/uZKjSFEavBbAjibAuA677T+u5xc4hc2hMSMSEWJbmYITd1azHQfvnYco0
        7E2d4XC0z0GshRX09I5MhSgSrXN04p4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-663-xDLU5KMfOcGqRS6AgfBnuA-1; Mon, 15 Aug 2022 17:54:00 -0400
X-MC-Unique: xDLU5KMfOcGqRS6AgfBnuA-1
Received: by mail-wr1-f70.google.com with SMTP id o3-20020adfa103000000b0022514e8e99bso120388wro.19
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 14:53:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=fg6AseMQKhGFaW1h59Li+nNVbNoTUAPXOEzU4kFeR3k=;
        b=KWP8l++6+P4Q70wXvH+cX7wlq1/8glheuid3Uv8h6Iqb2N9t+RniTKoWw9YrOZAYsy
         Jiw0z8k4JE5fXVOUhOAQ6V17ITNghqz1CjvVLSqVPYNIR4tr5bTv/p8Wj1qf1Xa6JYO+
         LlqnK2W9yRKHHnG9WqOgz/A6kV+JfdX+1hY7od3OBZSrjt7zA/3FYO/CKkvgoqoJao5j
         v4TQKXG4zl3KJXHlcOAxn6aOXth55DgJA6gQgZ5fRYqOvwsUBA0yTb7/zEinYH50Gd37
         VAk5vzY+BKCuG/cRjOdtlRUt/KmYlCgSBROJMpDOW5uKldQuG7xQBrIpGLTqe0h1JrOE
         ENIA==
X-Gm-Message-State: ACgBeo2XSQIn6cJZItcT8avIuMKdjkGmo7L7S8msYRKBPF0Z/JpiSPLj
        PGsiDqhmtjO5iG+vrw/9OKVJQqeS7BVWftcaCfdLc9f4Q/pGGsB1hvp/6cZro5zjH0OQOlzE6ht
        6kIk50zy/T4a1
X-Received: by 2002:a5d:688c:0:b0:21f:160d:8859 with SMTP id h12-20020a5d688c000000b0021f160d8859mr10167776wru.711.1660600438097;
        Mon, 15 Aug 2022 14:53:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7i3yRQDphQZIsyoh1v41BSMjkMtop58XMuZPufNQqNvzCeKRCE/8qJPk0HkyEzaJW0RSPyXA==
X-Received: by 2002:a5d:688c:0:b0:21f:160d:8859 with SMTP id h12-20020a5d688c000000b0021f160d8859mr10167756wru.711.1660600437733;
        Mon, 15 Aug 2022 14:53:57 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id q9-20020adff509000000b0021efc75914esm8326304wro.79.2022.08.15.14.53.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 14:53:57 -0700 (PDT)
Date:   Mon, 15 Aug 2022 17:53:50 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-um@lists.infradead.org, platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 5/5] virtio: Revert "virtio: find_vqs() add arg sizes"
Message-ID: <20220815215251.154451-8-mst@redhat.com>
References: <20220815215251.154451-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815215251.154451-1-mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This reverts commit a10fba0377145fccefea4dc4dd5915b7ed87e546: the
proposed API isn't supported on all transports but no
effort was made to address this.

It might not be hard to fix if we want to: maybe just
rename size to size_hint and make sure legacy
transports ignore the hint.

But it's not sure what the benefit is in any case, so
let's drop it.

Fixes: a10fba037714 ("virtio: find_vqs() add arg sizes")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/um/drivers/virtio_uml.c             |  2 +-
 drivers/platform/mellanox/mlxbf-tmfifo.c |  1 -
 drivers/remoteproc/remoteproc_virtio.c   |  1 -
 drivers/s390/virtio/virtio_ccw.c         |  1 -
 drivers/virtio/virtio_mmio.c             |  1 -
 drivers/virtio/virtio_pci_common.c       |  2 +-
 drivers/virtio/virtio_pci_common.h       |  2 +-
 drivers/virtio/virtio_pci_modern.c       |  7 ++-----
 drivers/virtio/virtio_vdpa.c             |  1 -
 include/linux/virtio_config.h            | 14 +++++---------
 10 files changed, 10 insertions(+), 22 deletions(-)

diff --git a/arch/um/drivers/virtio_uml.c b/arch/um/drivers/virtio_uml.c
index 79e38afd4b91..e719af8bdf56 100644
--- a/arch/um/drivers/virtio_uml.c
+++ b/arch/um/drivers/virtio_uml.c
@@ -1011,7 +1011,7 @@ static struct virtqueue *vu_setup_vq(struct virtio_device *vdev,
 
 static int vu_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		       struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		       const char * const names[], u32 sizes[], const bool *ctx,
+		       const char * const names[], const bool *ctx,
 		       struct irq_affinity *desc)
 {
 	struct virtio_uml_device *vu_dev = to_virtio_uml_device(vdev);
diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 8be13d416f48..1ae3c56b66b0 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -928,7 +928,6 @@ static int mlxbf_tmfifo_virtio_find_vqs(struct virtio_device *vdev,
 					struct virtqueue *vqs[],
 					vq_callback_t *callbacks[],
 					const char * const names[],
-					u32 sizes[],
 					const bool *ctx,
 					struct irq_affinity *desc)
 {
diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 81c4f5776109..0f7706e23eb9 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -158,7 +158,6 @@ static int rproc_virtio_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 				 struct virtqueue *vqs[],
 				 vq_callback_t *callbacks[],
 				 const char * const names[],
-				 u32 sizes[],
 				 const bool * ctx,
 				 struct irq_affinity *desc)
 {
diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 896896e32664..a10dbe632ef9 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -637,7 +637,6 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			       struct virtqueue *vqs[],
 			       vq_callback_t *callbacks[],
 			       const char * const names[],
-			       u32 sizes[],
 			       const bool *ctx,
 			       struct irq_affinity *desc)
 {
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index dfcecfd7aba1..3ff746e3f24a 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -474,7 +474,6 @@ static int vm_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		       struct virtqueue *vqs[],
 		       vq_callback_t *callbacks[],
 		       const char * const names[],
-		       u32 sizes[],
 		       const bool *ctx,
 		       struct irq_affinity *desc)
 {
diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index 7ad734584823..ad258a9d3b9f 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -396,7 +396,7 @@ static int vp_find_vqs_intx(struct virtio_device *vdev, unsigned int nvqs,
 /* the config->find_vqs() implementation */
 int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], u32 sizes[], const bool *ctx,
+		const char * const names[], const bool *ctx,
 		struct irq_affinity *desc)
 {
 	int err;
diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
index a5ff838b85a5..23112d84218f 100644
--- a/drivers/virtio/virtio_pci_common.h
+++ b/drivers/virtio/virtio_pci_common.h
@@ -110,7 +110,7 @@ void vp_del_vqs(struct virtio_device *vdev);
 /* the config->find_vqs() implementation */
 int vp_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 		struct virtqueue *vqs[], vq_callback_t *callbacks[],
-		const char * const names[], u32 sizes[], const bool *ctx,
+		const char * const names[], const bool *ctx,
 		struct irq_affinity *desc);
 const char *vp_bus_name(struct virtio_device *vdev);
 
diff --git a/drivers/virtio/virtio_pci_modern.c b/drivers/virtio/virtio_pci_modern.c
index be51ec849252..c3b9f2761849 100644
--- a/drivers/virtio/virtio_pci_modern.c
+++ b/drivers/virtio/virtio_pci_modern.c
@@ -347,15 +347,12 @@ static struct virtqueue *setup_vq(struct virtio_pci_device *vp_dev,
 static int vp_modern_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 			      struct virtqueue *vqs[],
 			      vq_callback_t *callbacks[],
-			      const char * const names[],
-			      u32 sizes[],
-			      const bool *ctx,
+			      const char * const names[], const bool *ctx,
 			      struct irq_affinity *desc)
 {
 	struct virtio_pci_device *vp_dev = to_vp_device(vdev);
 	struct virtqueue *vq;
-	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, sizes, ctx,
-			     desc);
+	int rc = vp_find_vqs(vdev, nvqs, vqs, callbacks, names, ctx, desc);
 
 	if (rc)
 		return rc;
diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
index 9bc4d110b800..c6b9b5062043 100644
--- a/drivers/virtio/virtio_vdpa.c
+++ b/drivers/virtio/virtio_vdpa.c
@@ -272,7 +272,6 @@ static int virtio_vdpa_find_vqs(struct virtio_device *vdev, unsigned int nvqs,
 				struct virtqueue *vqs[],
 				vq_callback_t *callbacks[],
 				const char * const names[],
-				u32 sizes[],
 				const bool *ctx,
 				struct irq_affinity *desc)
 {
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 888f7e96f0c7..36ec7be1f480 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -55,7 +55,6 @@ struct virtio_shm_region {
  *		include a NULL entry for vqs that do not need a callback
  *	names: array of virtqueue names (mainly for debugging)
  *		include a NULL entry for vqs unused by driver
- *	sizes: array of virtqueue sizes
  *	Returns 0 on success or error status
  * @del_vqs: free virtqueues found by find_vqs().
  * @synchronize_cbs: synchronize with the virtqueue callbacks (optional)
@@ -104,9 +103,7 @@ struct virtio_config_ops {
 	void (*reset)(struct virtio_device *vdev);
 	int (*find_vqs)(struct virtio_device *, unsigned nvqs,
 			struct virtqueue *vqs[], vq_callback_t *callbacks[],
-			const char * const names[],
-			u32 sizes[],
-			const bool *ctx,
+			const char * const names[], const bool *ctx,
 			struct irq_affinity *desc);
 	void (*del_vqs)(struct virtio_device *);
 	void (*synchronize_cbs)(struct virtio_device *);
@@ -215,7 +212,7 @@ struct virtqueue *virtio_find_single_vq(struct virtio_device *vdev,
 	const char *names[] = { n };
 	struct virtqueue *vq;
 	int err = vdev->config->find_vqs(vdev, 1, &vq, callbacks, names, NULL,
-					 NULL, NULL);
+					 NULL);
 	if (err < 0)
 		return ERR_PTR(err);
 	return vq;
@@ -227,8 +224,7 @@ int virtio_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 			const char * const names[],
 			struct irq_affinity *desc)
 {
-	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
-				      NULL, desc);
+	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL, desc);
 }
 
 static inline
@@ -237,8 +233,8 @@ int virtio_find_vqs_ctx(struct virtio_device *vdev, unsigned nvqs,
 			const char * const names[], const bool *ctx,
 			struct irq_affinity *desc)
 {
-	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, NULL,
-				      ctx, desc);
+	return vdev->config->find_vqs(vdev, nvqs, vqs, callbacks, names, ctx,
+				      desc);
 }
 
 /**
-- 
MST

