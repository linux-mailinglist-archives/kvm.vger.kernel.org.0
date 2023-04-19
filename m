Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7006E7AAF
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbjDSN1y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbjDSN1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:51 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B746A30D4
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id iw7-20020a05600c54c700b003f16fce55b5so1460170wmb.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910865; x=1684502865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sf5jQ7FsskeiIkP7ak2gohZd1HhOl8Mi8w0DmpQUx7Y=;
        b=twXb0VmsbnVwF0zIwgKqy9r2oFER1FayZMFEuxP3JdhNVOr/Ku6Z0C2+Q8u8nvOJuE
         OSGxynG974S7fbpBk9SV1RS4eSWlN6MxdnOsaovh5iMBblSRpx/42w+KmTbmsb62FR6Z
         sf9/O3DdVouA6a3E01oKWHW3oLpzAeZWD0JIYgfiZ7ATHrvldB1hUHNPx72lKL1WpVGF
         szHpDFl8YM1m8yiuslt9M79TfH9uiXUx2is3SH0GpOqD0vGIqzAZxEXrsNCKE1jtHR4/
         /2HJx6Ys/0B+VRcsOGjmyDP/Pno/id8VHOnuZjGHszuzDvBOrbphkg5q4pXTjuhwu6EC
         wUmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910865; x=1684502865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sf5jQ7FsskeiIkP7ak2gohZd1HhOl8Mi8w0DmpQUx7Y=;
        b=JjpoAS5rYoAUDF42327pquG2dWUXXb/JtIhU4FUuBNHLhVKMWeJitmvnYwfWBYImbK
         eAtWySZ8++6UAyWV9RUnRdv0HWHwFsDLNKm0EnhKEX1NfVvBZXuzgNa1WeAY/DQ/njkl
         NwKHMRPRzAAGtZ+EpdmMm+S5ZyfsF7yXJkQSm/uUwQmVx/cQukiF0XzkFsg+puq5a/GL
         fRdXAL/K1eRr2t/zzF6N0clSZ0YIDojlEa85jrR1qG73Jjscr+bIjYeZVR8m0vl5vp12
         YTramq2r4KTUTOxuDzWVIqi3LxLPur8WlqdWLHi4sumcd032MCOhlO95FO+OZfGRsVIy
         c+3A==
X-Gm-Message-State: AAQBX9fsAcm/tCPOGWSlgIgK0/Vv2fXZcZYSiZW9EDApADzqCwkXBXnZ
        wWZ2yfR8EXcHsBFb0YObE1q4Vb5Co5QTI6E5aHM=
X-Google-Smtp-Source: AKy350aLPsCQDPiEFrCFZTq4ivfnQTP/RVndwRTujvJwYN5/otW55YKff6iZ9kyiomZ9LxbX/FzvdA==
X-Received: by 2002:a7b:c309:0:b0:3f0:967e:2cfb with SMTP id k9-20020a7bc309000000b003f0967e2cfbmr17899956wmj.36.1681910865312;
        Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 04/16] virtio/vhost: Factor notify_vq_gsi()
Date:   Wed, 19 Apr 2023 14:21:08 +0100
Message-Id: <20230419132119.124457-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All vhost devices should perform the same operations when initializing
the IRQFD. Move it to virtio/vhost.c

This fixes vsock, which didn't go through the irq__add_irqfd() helper
and couldn't be used on systems that require GSI translation (GICv2m).

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  8 ++++++++
 virtio/net.c         | 30 ++++--------------------------
 virtio/scsi.c        | 15 ++-------------
 virtio/vhost.c       | 35 +++++++++++++++++++++++++++++++++++
 virtio/vsock.c       | 26 +++-----------------------
 5 files changed, 52 insertions(+), 62 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 4a364a02..96c7b3ea 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -77,6 +77,10 @@ struct virt_queue {
 	u16		endian;
 	bool		use_event_idx;
 	bool		enabled;
+
+	/* vhost IRQ handling */
+	int		gsi;
+	int		irqfd;
 };
 
 /*
@@ -252,6 +256,10 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			    struct virt_queue *queue);
 void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
 				 u32 index, int event_fd);
+void virtio_vhost_set_vring_call(struct kvm *kvm, int vhost_fd, u32 index,
+				 u32 gsi, struct virt_queue *queue);
+void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
+			      struct virt_queue *queue);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index b935d24f..519dcbb7 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -4,12 +4,12 @@
 #include "kvm/mutex.h"
 #include "kvm/util.h"
 #include "kvm/kvm.h"
-#include "kvm/irq.h"
 #include "kvm/uip.h"
 #include "kvm/guest_compat.h"
 #include "kvm/iovec.h"
 #include "kvm/strbuf.h"
 
+#include <linux/list.h>
 #include <linux/vhost.h>
 #include <linux/virtio_net.h>
 #include <linux/if_tun.h>
@@ -25,7 +25,6 @@
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/wait.h>
-#include <sys/eventfd.h>
 
 #define VIRTIO_NET_QUEUE_SIZE		256
 #define VIRTIO_NET_NUM_QUEUES		8
@@ -44,8 +43,6 @@ struct net_dev_queue {
 	pthread_t			thread;
 	struct mutex			lock;
 	pthread_cond_t			cond;
-	int				gsi;
-	int				irqfd;
 };
 
 struct net_dev {
@@ -647,11 +644,7 @@ static void exit_vq(struct kvm *kvm, void *dev, u32 vq)
 	struct net_dev *ndev = dev;
 	struct net_dev_queue *queue = &ndev->queues[vq];
 
-	if (!is_ctrl_vq(ndev, vq) && queue->gsi) {
-		irq__del_irqfd(kvm, queue->gsi, queue->irqfd);
-		close(queue->irqfd);
-		queue->gsi = queue->irqfd = 0;
-	}
+	virtio_vhost_reset_vring(kvm, ndev->vhost_fd, vq, &queue->vq);
 
 	/*
 	 * TODO: vhost reset owner. It's the only way to cleanly stop vhost, but
@@ -675,27 +668,12 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
 	struct net_dev *ndev = dev;
 	struct net_dev_queue *queue = &ndev->queues[vq];
-	struct vhost_vring_file file;
-	int r;
 
 	if (ndev->vhost_fd == 0)
 		return;
 
-	file = (struct vhost_vring_file) {
-		.index	= vq,
-		.fd	= eventfd(0, 0),
-	};
-
-	r = irq__add_irqfd(kvm, gsi, file.fd, -1);
-	if (r < 0)
-		die_perror("KVM_IRQFD failed");
-
-	queue->irqfd = file.fd;
-	queue->gsi = gsi;
-
-	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_CALL, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_CALL failed");
+	virtio_vhost_set_vring_call(kvm, ndev->vhost_fd, vq, gsi,
+				    &queue->vq);
 }
 
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 1f757404..29acf57c 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -92,25 +92,14 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 
 static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
-	struct vhost_vring_file file;
 	struct scsi_dev *sdev = dev;
 	int r;
 
 	if (sdev->vhost_fd == 0)
 		return;
 
-	file = (struct vhost_vring_file) {
-		.index	= vq,
-		.fd	= eventfd(0, 0),
-	};
-
-	r = irq__add_irqfd(kvm, gsi, file.fd, -1);
-	if (r < 0)
-		die_perror("KVM_IRQFD failed");
-
-	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_CALL, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_CALL failed");
+	virtio_vhost_set_vring_call(kvm, sdev->vhost_fd, vq, gsi,
+				    &sdev->vqs[vq]);
 
 	if (vq > 0)
 		return;
diff --git a/virtio/vhost.c b/virtio/vhost.c
index 3acfd30a..cd83645c 100644
--- a/virtio/vhost.c
+++ b/virtio/vhost.c
@@ -1,9 +1,12 @@
+#include "kvm/irq.h"
 #include "kvm/virtio.h"
 
 #include <linux/kvm.h>
 #include <linux/vhost.h>
 #include <linux/list.h>
 
+#include <sys/eventfd.h>
+
 void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
 {
 	struct kvm_mem_bank *bank;
@@ -79,3 +82,35 @@ void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
 	if (r < 0)
 		die_perror("VHOST_SET_VRING_KICK failed");
 }
+
+void virtio_vhost_set_vring_call(struct kvm *kvm, int vhost_fd, u32 index,
+				 u32 gsi, struct virt_queue *queue)
+{
+	int r;
+	struct vhost_vring_file file = {
+		.index	= index,
+		.fd	= eventfd(0, 0),
+	};
+
+	r = irq__add_irqfd(kvm, gsi, file.fd, -1);
+	if (r < 0)
+		die_perror("KVM_IRQFD failed");
+
+	r = ioctl(vhost_fd, VHOST_SET_VRING_CALL, &file);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_CALL failed");
+
+	queue->irqfd = file.fd;
+	queue->gsi = gsi;
+}
+
+void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
+			      struct virt_queue *queue)
+
+{
+	if (queue->gsi) {
+		irq__del_irqfd(kvm, queue->gsi, queue->irqfd);
+		close(queue->irqfd);
+		queue->gsi = queue->irqfd = 0;
+	}
+}
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 0ada9e09..559fbaba 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -131,33 +131,13 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 
 static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
-	struct vhost_vring_file file;
 	struct vsock_dev *vdev = dev;
-	struct kvm_irqfd irq;
-	int r;
-
-	if (vdev->vhost_fd == -1)
-		return;
 
-	if (is_event_vq(vq))
+	if (vdev->vhost_fd == -1 || is_event_vq(vq))
 		return;
 
-	irq = (struct kvm_irqfd) {
-		.gsi	= gsi,
-		.fd	= eventfd(0, 0),
-	};
-	file = (struct vhost_vring_file) {
-		.index	= vq,
-		.fd	= irq.fd,
-	};
-
-	r = ioctl(kvm->vm_fd, KVM_IRQFD, &irq);
-	if (r < 0)
-		die_perror("KVM_IRQFD failed");
-
-	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_CALL, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_CALL failed");
+	virtio_vhost_set_vring_call(kvm, vdev->vhost_fd, vq, gsi,
+				    &vdev->vqs[vq]);
 }
 
 static unsigned int get_vq_count(struct kvm *kvm, void *dev)
-- 
2.40.0

