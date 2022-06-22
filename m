Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A092A554014
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 03:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiFVB3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 21:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiFVB3y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 21:29:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BE6432ED9
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 18:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655861392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BoDu7G6x72FjrLLwN0eQPK25v2hz35SxV4bj0Qgj7NA=;
        b=T/vN8HC3Rolq5Z1srPPjwWgqMGK13ATxsYI/qBxHWxXE/AS99XaE7C2TxUFJKewAbO7R+n
        S31rZHk+3qmt4/Ajoweg3Nug4oVveOmsrmUfp2jbAUhEZtRurnGwK95/8LdpEpPoti/+n+
        EEI2287UVgWvTx9MBsEfzPdaXxzAq/k=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-ccm6934pN5SeGemNeoKc_w-1; Tue, 21 Jun 2022 21:29:48 -0400
X-MC-Unique: ccm6934pN5SeGemNeoKc_w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 099E229AB40F;
        Wed, 22 Jun 2022 01:29:48 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-93.pek2.redhat.com [10.72.13.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE08B40CF8E2;
        Wed, 22 Jun 2022 01:29:42 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     cohuck@redhat.com, pasic@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, agordeev@linux.ibm.com,
        mst@redhat.com, jasowang@redhat.com, linux-s390@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ben@decadent.org.uk, david@redhat.com
Subject: [PATCH V3] virtio: disable notification hardening by default
Date:   Wed, 22 Jun 2022 09:29:40 +0800
Message-Id: <20220622012940.21441-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
Changes since V2:
- Tweak the Kconfig help
- Add comment for the read_lock() pairing in virtio_ccw
---
 drivers/s390/virtio/virtio_ccw.c |  9 ++++++++-
 drivers/virtio/Kconfig           | 13 +++++++++++++
 drivers/virtio/virtio.c          |  2 ++
 drivers/virtio/virtio_ring.c     | 12 ++++++++++++
 include/linux/virtio_config.h    |  2 ++
 5 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 97e51c34e6cf..1f6a358f65f0 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1136,8 +1136,13 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 			vcdev->err = -EIO;
 	}
 	virtio_ccw_check_activity(vcdev, activity);
-	/* Interrupts are disabled here */
+#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
+	/*
+	 * Paried with virtio_ccw_synchronize_cbs() and interrupts are
+	 * disabled here.
+	 */
 	read_lock(&vcdev->irq_lock);
+#endif
 	for_each_set_bit(i, indicators(vcdev),
 			 sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
 		/* The bit clear must happen before the vring kick. */
@@ -1146,7 +1151,9 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
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
index b5adf6abd241..c04f370a1e5c 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -35,6 +35,19 @@ menuconfig VIRTIO_MENU
 
 if VIRTIO_MENU
 
+config VIRTIO_HARDEN_NOTIFICATION
+        bool "Harden virtio notification"
+        help
+          Enable this to harden the device notifications and suppress
+          those that happen at a time where notifications are illegal.
+
+          Experimental: Note that several drivers still have bugs that
+          may cause crashes or hangs when correct handling of
+          notifications is enforced; depending on the subset of
+          drivers and devices you use, this may or may not work.
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

