Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EBD9724394
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbjFFNFV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238050AbjFFNFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:17 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE62C10C0
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:15 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-30af86a96b4so4963220f8f.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056714; x=1688648714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0xP9PWAS49h9In3aRW4DLV5cYu/h2mprcrQV5sIQmY=;
        b=wQXMA41ppkAmBOVA/A1V6+guQdMNibhN0DKfwZOF5Jqu5qUFXZK1fOuCV4Av0nEFqg
         rklos2Kz+Q840HAtL8F+qRFKDZIPnJi0dWa5lWy8KnLtuFIym0kkc6AKmEF/B+LPLGMK
         wJsrEfNNUjZHpJp3AaiybwNF3E5PBavwqE+/t+pSXgAL26pws7V5xBTTbxFzoYeTX/2O
         /drlLAFIhDRuV1fSoRHh9GeSSY+l3mIvDk8YOYHCCa2Coz8ldV4xMFgUkS7VdSL7rS92
         zBOpeNVgW/gnI+fhHhXBK9uhdBjoSCSRyAAnhTe5d5YgphtGwE2fuj+z6r22VZFx4Agk
         CFTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056714; x=1688648714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0xP9PWAS49h9In3aRW4DLV5cYu/h2mprcrQV5sIQmY=;
        b=CarhFCM4HsI+kABwKnTd4qfCxM5FvWqftaEeVGoa7IeCfHNUYXDcS9pzOxuQlklkox
         xsajsf0v29+yVM71YaosHdxDUVEbx+ulxed9glL5UhRtiywQegwaAhSTVrTfcpvujwKU
         DV5Rxot9C71r8D0CjywL0e26huAAyJYHtqWTapCnKUsyI9Bp9u7rPd8aiRx5z2G3KUMG
         J6aykmO6RD0DPpkx47iJi5jpfMwIw0Ptnwlhpb/ZjO3IorCFj9kb65LqooGBHVk7KIgC
         O4LkzhT2Xih8GIatb6hACffSEe7uG0BWDxvJnNoyc704SNRCxy4lWm9HStChn6LMEQsq
         a02A==
X-Gm-Message-State: AC+VfDzawyNEAzht0TsNBTTWe2GuEvbxvJRCMd47gYGwNHqnwJusiqdO
        sphOakoVRXLul2VTbpQrSeT+0RAGHhibGhcdnWY+Tw==
X-Google-Smtp-Source: ACHHUZ4MDaxxFktj8qI7LMYGdD8Dpnh/5txMVVroWMJ1EzhHy26rvHfF9r/kMDqFmttZaL5I80GUqQ==
X-Received: by 2002:a5d:6449:0:b0:306:28f4:963c with SMTP id d9-20020a5d6449000000b0030628f4963cmr1658532wrw.23.1686056714404;
        Tue, 06 Jun 2023 06:05:14 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:14 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 04/17] virtio/vhost: Factor notify_vq_gsi()
Date:   Tue,  6 Jun 2023 14:04:13 +0100
Message-Id: <20230606130426.978945-5-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
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

Also correct notify_vq_gsi() in net.c, to check which virtqueue is being
configured. Since vhost only manages the data queues, we shouldn't try
to setup GSI routing for the control queue. This hasn't been a problem
so far because the Linux guest doesn't use IRQs for the control queue.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  8 ++++++++
 virtio/net.c         | 32 +++++---------------------------
 virtio/scsi.c        | 15 ++-------------
 virtio/vhost.c       | 35 +++++++++++++++++++++++++++++++++++
 virtio/vsock.c       | 26 +++-----------------------
 5 files changed, 53 insertions(+), 63 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 6912875e..a2f8355a 100644
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
@@ -263,6 +267,10 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			    struct virt_queue *queue);
 void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
 				 u32 index, int event_fd);
+void virtio_vhost_set_vring_call(struct kvm *kvm, int vhost_fd, u32 index,
+				 u32 gsi, struct virt_queue *queue);
+void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
+			      struct virt_queue *queue);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index c0871163..3e1aedf7 100644
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
 
-	if (ndev->vhost_fd == 0)
+	if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq))
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
index ebddec36..708fb23a 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -90,25 +90,14 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 
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
 
-	if (vdev->vhost_fd == -1)
+	if (vdev->vhost_fd == -1 || is_event_vq(vq))
 		return;
 
-	if (is_event_vq(vq))
-		return;
-
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
2.40.1

