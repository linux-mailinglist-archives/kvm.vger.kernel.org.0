Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401C87243AA
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237934AbjFFNFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbjFFNFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:25 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A57118
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:23 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-30ad8f33f1aso5346793f8f.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056722; x=1688648722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zut6N+o9DqsqZ3QqueaCrmqxL7T3XNKiHLWPtWI/Av8=;
        b=ISRALrDCAoS9krTJIYl8JyD+rV5oBa2m9aFPptO95FfYWEe2NdMGe/R6a6uAk649Hs
         QxM8LjoECCcdhAyuBr8vpGvH6RDj37USyzjRvoHSHeS7Fr9diGxuLYzKrPU8l/tK8ArR
         p6X7C+e5ki4p1gNWGbSfOPwAhqyP+H4ad87Q7D63SMacqHbRI7o8+dVSgKYRKUYJncrr
         l6ztgP9xGwyAhc+LJrMb6GrTCX4aK3fNsZbsdwy3CgWOsU0C18sSrrcwaILcuFUpJLVj
         MIIjfPpggeHGKvgLbSOusRe0fCkJjTDDl/yipLQCuS7MrTAqQDKH2+abrzz6CqrPTKjK
         BhQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056722; x=1688648722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zut6N+o9DqsqZ3QqueaCrmqxL7T3XNKiHLWPtWI/Av8=;
        b=Q4lrw7cFtZL0/+VkWbbs/Nitq+AEFf8mMzKj0jRIB3fpYbB+oNi+a2kMkO3+ej3qla
         Wd6rsKSIMKQ3pUjhPGZ20wMclwlyn7w3YK2sQyRB3KihmbrZGaNg6blKNj6zfu2LR2xx
         6SWmg0X6IzfelXADth04G+WJ04tl9vjtJRr8wcEvAnNTq+bu86BHKdbi79WTAxSb7y5V
         oMUO+gA0SGdpvmrqhgc7269Ll770ZfD26oDzyG6OpAbde2d6k2S6SCpenYhgSfEMiNSp
         GLCkzbgA9/o/U+VFspZVuQiJWKfahfoTadfltC883Pol94xIvPs5nBlVac2+mQgd3kKu
         Xsxg==
X-Gm-Message-State: AC+VfDzA6ueQ7aW/JsOlkNCT9i4J97X0ENurhAwHI8RIwvxjDYae8QsS
        4jrMq3G2s2nFSLLpiAq1Nv0b8IkHkL57ba8ecpF2vQ==
X-Google-Smtp-Source: ACHHUZ774OHoW2or+KWWTTDVMXbviLDTvKqQJ7cF5VRST8yYqvnIXQydzR9iwSDPBRrP4K1ryuvhBg==
X-Received: by 2002:a05:6000:1142:b0:30a:eeff:3e77 with SMTP id d2-20020a056000114200b0030aeeff3e77mr1679893wrx.14.1686056721931;
        Tue, 06 Jun 2023 06:05:21 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:21 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 16/17] virtio/vhost: Support line interrupt signaling
Date:   Tue,  6 Jun 2023 14:04:25 +0100
Message-Id: <20230606130426.978945-17-jean-philippe@linaro.org>
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

To signal a virtqueue, a kernel vhost worker writes an eventfd
registered by kvmtool with VHOST_SET_VRING_CALL. When MSIs are
supported, this eventfd is connected directly to KVM IRQFD to inject the
interrupt into the guest. However direct injection does not work when
MSIs are not supported. The virtio-mmio transport does not support MSIs
at all, and even with virtio-pci, the guest may use INTx if the irqchip
does not support MSIs (e.g. irqchip=gicv3 on arm64).

In this case, injecting the interrupt requires writing an ISR register
in virtio to signal that it is a virtqueue notification rather than a
config change. Add a thread that polls the vhost eventfd for interrupts,
and notifies the guest. When the guest configures MSIs, disable polling
on the eventfd and enable direct injection.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |   6 ++-
 virtio/core.c        |   1 +
 virtio/net.c         |   3 +-
 virtio/scsi.c        |   3 +-
 virtio/vhost.c       | 110 +++++++++++++++++++++++++++++++++++++------
 virtio/vsock.c       |   3 +-
 6 files changed, 104 insertions(+), 22 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index a2f8355a..1fa33e5b 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -77,10 +77,12 @@ struct virt_queue {
 	u16		endian;
 	bool		use_event_idx;
 	bool		enabled;
+	struct virtio_device *vdev;
 
 	/* vhost IRQ handling */
 	int		gsi;
 	int		irqfd;
+	int		index;
 };
 
 /*
@@ -267,8 +269,8 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			    struct virt_queue *queue);
 void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
 				 u32 index, int event_fd);
-void virtio_vhost_set_vring_call(struct kvm *kvm, int vhost_fd, u32 index,
-				 u32 gsi, struct virt_queue *queue);
+void virtio_vhost_set_vring_irqfd(struct kvm *kvm, u32 gsi,
+				  struct virt_queue *queue);
 void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			      struct virt_queue *queue);
 
diff --git a/virtio/core.c b/virtio/core.c
index 63735fae..a77e23bc 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -198,6 +198,7 @@ void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
 	vq->endian		= vdev->endian;
 	vq->use_event_idx	= (vdev->features & (1UL << VIRTIO_RING_F_EVENT_IDX));
 	vq->enabled		= true;
+	vq->vdev		= vdev;
 
 	if (addr->legacy) {
 		unsigned long base = (u64)addr->pfn * addr->pgsize;
diff --git a/virtio/net.c b/virtio/net.c
index 02667176..2b4b3661 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -674,8 +674,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 	if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq))
 		return;
 
-	virtio_vhost_set_vring_call(kvm, ndev->vhost_fd, vq, gsi,
-				    &queue->vq);
+	virtio_vhost_set_vring_irqfd(kvm, gsi, &queue->vq);
 }
 
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 52bc4936..27cb3798 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -119,8 +119,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 	if (sdev->vhost_fd == 0)
 		return;
 
-	virtio_vhost_set_vring_call(kvm, sdev->vhost_fd, vq, gsi,
-				    &sdev->vqs[vq]);
+	virtio_vhost_set_vring_irqfd(kvm, gsi, &sdev->vqs[vq]);
 }
 
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
diff --git a/virtio/vhost.c b/virtio/vhost.c
index cd83645c..0049003b 100644
--- a/virtio/vhost.c
+++ b/virtio/vhost.c
@@ -1,5 +1,6 @@
 #include "kvm/irq.h"
 #include "kvm/virtio.h"
+#include "kvm/epoll.h"
 
 #include <linux/kvm.h>
 #include <linux/vhost.h>
@@ -7,12 +8,52 @@
 
 #include <sys/eventfd.h>
 
+static struct kvm__epoll epoll;
+
+static void virtio_vhost_signal_vq(struct kvm *kvm, struct epoll_event *ev)
+{
+	int r;
+	u64 tmp;
+	struct virt_queue *queue = ev->data.ptr;
+
+	if (read(queue->irqfd, &tmp, sizeof(tmp)) < 0)
+		pr_warning("%s: failed to read eventfd", __func__);
+
+	r = queue->vdev->ops->signal_vq(kvm, queue->vdev, queue->index);
+	if (r)
+		pr_warning("%s failed to signal virtqueue", __func__);
+}
+
+static int virtio_vhost_start_poll(struct kvm *kvm)
+{
+	if (epoll.fd)
+		return 0;
+
+	if (epoll__init(kvm, &epoll, "vhost-irq-worker",
+			virtio_vhost_signal_vq))
+		return -1;
+
+	return 0;
+}
+
+static int virtio_vhost_stop_poll(struct kvm *kvm)
+{
+	if (epoll.fd)
+		epoll__exit(&epoll);
+	return 0;
+}
+base_exit(virtio_vhost_stop_poll);
+
 void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
 {
 	struct kvm_mem_bank *bank;
 	struct vhost_memory *mem;
 	int i = 0, r;
 
+	r = virtio_vhost_start_poll(kvm);
+	if (r)
+		die("Unable to start vhost polling thread\n");
+
 	mem = calloc(1, sizeof(*mem) +
 		     kvm->mem_slots * sizeof(struct vhost_memory_region));
 	if (mem == NULL)
@@ -39,6 +80,16 @@ void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
 	free(mem);
 }
 
+static int virtio_vhost_get_irqfd(struct virt_queue *queue)
+{
+	if (!queue->irqfd) {
+		queue->irqfd = eventfd(0, 0);
+		if (queue->irqfd < 0)
+			die_perror("eventfd()");
+	}
+	return queue->irqfd;
+}
+
 void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			    struct virt_queue *queue)
 {
@@ -50,6 +101,16 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 		.used_user_addr = (u64)(unsigned long)queue->vring.used,
 	};
 	struct vhost_vring_state state = { .index = index };
+	struct vhost_vring_file file = {
+		.index	= index,
+		.fd	= virtio_vhost_get_irqfd(queue),
+	};
+	struct epoll_event event = {
+		.events = EPOLLIN,
+		.data.ptr = queue,
+	};
+
+	queue->index = index;
 
 	if (queue->endian != VIRTIO_ENDIAN_HOST)
 		die("VHOST requires the same endianness in guest and host");
@@ -67,6 +128,14 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 	r = ioctl(vhost_fd, VHOST_SET_VRING_ADDR, &addr);
 	if (r < 0)
 		die_perror("VHOST_SET_VRING_ADDR failed");
+
+	r = ioctl(vhost_fd, VHOST_SET_VRING_CALL, &file);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_CALL failed");
+
+	r = epoll_ctl(epoll.fd, EPOLL_CTL_ADD, file.fd, &event);
+	if (r < 0)
+		die_perror("EPOLL_CTL_ADD vhost call fd");
 }
 
 void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
@@ -83,24 +152,23 @@ void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
 		die_perror("VHOST_SET_VRING_KICK failed");
 }
 
-void virtio_vhost_set_vring_call(struct kvm *kvm, int vhost_fd, u32 index,
-				 u32 gsi, struct virt_queue *queue)
+void virtio_vhost_set_vring_irqfd(struct kvm *kvm, u32 gsi,
+				  struct virt_queue *queue)
 {
 	int r;
-	struct vhost_vring_file file = {
-		.index	= index,
-		.fd	= eventfd(0, 0),
-	};
+	int fd = virtio_vhost_get_irqfd(queue);
 
-	r = irq__add_irqfd(kvm, gsi, file.fd, -1);
+	if (queue->gsi)
+		irq__del_irqfd(kvm, queue->gsi, fd);
+	else
+		/* Disconnect user polling thread */
+		epoll_ctl(epoll.fd, EPOLL_CTL_DEL, fd, NULL);
+
+	/* Connect the direct IRQFD route */
+	r = irq__add_irqfd(kvm, gsi, fd, -1);
 	if (r < 0)
 		die_perror("KVM_IRQFD failed");
 
-	r = ioctl(vhost_fd, VHOST_SET_VRING_CALL, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_CALL failed");
-
-	queue->irqfd = file.fd;
 	queue->gsi = gsi;
 }
 
@@ -108,9 +176,23 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			      struct virt_queue *queue)
 
 {
+	struct vhost_vring_file file = {
+		.index	= index,
+		.fd	= -1,
+	};
+
+	if (!queue->irqfd)
+		return;
+
 	if (queue->gsi) {
 		irq__del_irqfd(kvm, queue->gsi, queue->irqfd);
-		close(queue->irqfd);
-		queue->gsi = queue->irqfd = 0;
+		queue->gsi = 0;
 	}
+
+	epoll_ctl(epoll.fd, EPOLL_CTL_DEL, queue->irqfd, NULL);
+
+	if (ioctl(vhost_fd, VHOST_SET_VRING_CALL, &file))
+		perror("SET_VRING_CALL");
+	close(queue->irqfd);
+	queue->irqfd = 0;
 }
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 070cfbb6..5d22bd24 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -151,8 +151,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 	if (vdev->vhost_fd == -1 || is_event_vq(vq))
 		return;
 
-	virtio_vhost_set_vring_call(kvm, vdev->vhost_fd, vq, gsi,
-				    &vdev->vqs[vq]);
+	virtio_vhost_set_vring_irqfd(kvm, gsi, &vdev->vqs[vq]);
 }
 
 static unsigned int get_vq_count(struct kvm *kvm, void *dev)
-- 
2.40.1

