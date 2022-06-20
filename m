Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12C5550E9F
	for <lists+kvm@lfdr.de>; Mon, 20 Jun 2022 04:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236024AbiFTCmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 22:42:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232916AbiFTCmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 22:42:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EA15B2BF
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 19:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655692935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/oknfccPAIxyEAuYdT4y1IrsCu7NWdjJuGzW6X5z710=;
        b=PSzCY3UuIzA6rR+Nsr3B/Bg7uRAth8uXsrF5Q50GqFWZ7JnyP/rXU3ji2+WRc+R7ogko9J
        6lO+XeORR5aQbuIYdEhI9bmvFvH6R39tvkmFgFZAP+lxxcJCHisDXFySa6aaoZPhRVEonN
        VymahPKcO5uJjudBSRuRzl95JySk0l8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-147-ROevF3OlOLOOELPM_umplw-1; Sun, 19 Jun 2022 22:42:06 -0400
X-MC-Unique: ROevF3OlOLOOELPM_umplw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 66EDE101A56C;
        Mon, 20 Jun 2022 02:42:05 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-16.pek2.redhat.com [10.72.12.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CB65C08087;
        Mon, 20 Jun 2022 02:42:00 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     cohuck@redhat.com, pasic@linux.ibm.com, jasowang@redhat.com,
        mst@redhat.com
Cc:     gor@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] virtio: disable notification hardening by default
Date:   Mon, 20 Jun 2022 10:41:58 +0800
Message-Id: <20220620024158.2505-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We try to harden virtio device notifications in 8b4ec69d7e09 ("virtio:
harden vring IRQ"). It works with the assumption that the driver or
core can properly call virtio_device_ready() at the right
place. Unfortunately, this seems to be not true and uncover various
bugs of the existing drivers, mainly the issue of using
virtio_device_ready() incorrectly.

So let's having a Kconfig option and disable it by default. It gives
us a breath to fix the drivers and then we can consider to enable it
by default.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V1:
- tweak the Kconfig prompt
- don't hold spinlock for IRQ path in s390
---
 drivers/s390/virtio/virtio_ccw.c |  4 ++++
 drivers/virtio/Kconfig           | 11 +++++++++++
 drivers/virtio/virtio.c          |  2 ++
 drivers/virtio/virtio_ring.c     | 12 ++++++++++++
 include/linux/virtio_config.h    |  2 ++
 5 files changed, 31 insertions(+)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 97e51c34e6cf..89bbf7ccfdd1 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1136,8 +1136,10 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 			vcdev->err = -EIO;
 	}
 	virtio_ccw_check_activity(vcdev, activity);
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	/* Interrupts are disabled here */
 	read_lock(&vcdev->irq_lock);
+#endif
 	for_each_set_bit(i, indicators(vcdev),
 			 sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
 		/* The bit clear must happen before the vring kick. */
@@ -1146,7 +1148,9 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 		vq = virtio_ccw_vq_by_ind(vcdev, i);
 		vring_interrupt(0, vq);
 	}
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	read_unlock(&vcdev->irq_lock);
+#endif
 	if (test_bit(0, indicators2(vcdev))) {
 		virtio_config_changed(&vcdev->vdev);
 		clear_bit(0, indicators2(vcdev));
diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index b5adf6abd241..96ec56d44b91 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -35,6 +35,17 @@ menuconfig VIRTIO_MENU
 
 if VIRTIO_MENU
 
+config VIRTIO_HARDEN_NOTIFICATION
+        bool "Harden virtio notification"
+        help
+          Enable this to harden the device notifications and supress
+          the ones that are illegal.
+
+          Experimental: not all drivers handle this correctly at this
+          point.
+
+          If unsure, say N.
+
 config VIRTIO_PCI
 	tristate "PCI driver for virtio devices"
 	depends on PCI
diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index ef04a96942bf..21dc08d2f32d 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -220,6 +220,7 @@ static int virtio_features_ok(struct virtio_device *dev)
  * */
 void virtio_reset_device(struct virtio_device *dev)
 {
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	/*
 	 * The below virtio_synchronize_cbs() guarantees that any
 	 * interrupt for this line arriving after
@@ -228,6 +229,7 @@ void virtio_reset_device(struct virtio_device *dev)
 	 */
 	virtio_break_device(dev);
 	virtio_synchronize_cbs(dev);
+#endif
 
 	dev->config->reset(dev);
 }
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 13a7348cedff..d9d3b6e201fb 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1688,7 +1688,11 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->we_own_ring = true;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	vq->broken = true;
+#else
+	vq->broken = false;
+#endif
 	vq->last_used_idx = 0;
 	vq->event_triggered = false;
 	vq->num_added = 0;
@@ -2135,9 +2139,13 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 	}
 
 	if (unlikely(vq->broken)) {
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 		dev_warn_once(&vq->vq.vdev->dev,
 			      "virtio vring IRQ raised before DRIVER_OK");
 		return IRQ_NONE;
+#else
+		return IRQ_HANDLED;
+#endif
 	}
 
 	/* Just a hint for performance: so it's ok that this can be racy! */
@@ -2180,7 +2188,11 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->we_own_ring = false;
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	vq->broken = true;
+#else
+	vq->broken = false;
+#endif
 	vq->last_used_idx = 0;
 	vq->event_triggered = false;
 	vq->num_added = 0;
diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 9a36051ceb76..d15c3cdda2d2 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -257,6 +257,7 @@ void virtio_device_ready(struct virtio_device *dev)
 
 	WARN_ON(status & VIRTIO_CONFIG_S_DRIVER_OK);
 
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	/*
 	 * The virtio_synchronize_cbs() makes sure vring_interrupt()
 	 * will see the driver specific setup if it sees vq->broken
@@ -264,6 +265,7 @@ void virtio_device_ready(struct virtio_device *dev)
 	 */
 	virtio_synchronize_cbs(dev);
 	__virtio_unbreak_device(dev);
+#endif
 	/*
 	 * The transport should ensure the visibility of vq->broken
 	 * before setting DRIVER_OK. See the comments for the transport
-- 
2.25.1

