Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A422A6E7ABA
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbjDSN2L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbjDSN17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:59 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2D3118FA
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:52 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id r15so7559027wmo.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910871; x=1684502871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Ul6nlKXm3ANtzcLKZeMo4cAjbCzXANhKz5rZh2m+ZQ=;
        b=N62vmmjaWYEgd6+Ca7GeNKRCDccrrRr3UTUqFWSvB/sgClUg4HZQw8xL9+tOocTO51
         drEU/WceHlbHuQCcj4+5+YftlIq65qr1zsqyXJcxeSirDUa/WyZXrvNMgUp8+NwwW6lO
         RNUacN8SZg20nw4oU8VN5PDWs6dJRh8682nCiW9mu4dK5fOWZH+jW/S0dd2nqfg0rAsm
         IZfLOec1tt6kG/+XaJl2ceN52JRe7Df2hEKUXrmHy81mzkdR+R5BYc/yXN2O9OpHURsu
         XE5zlTToEsg0pXIfhGyEeUoHt5ijNWfyCTPNZqMH15rWWoMb4dH3bAEyoKYc70UbA+8x
         8jvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910871; x=1684502871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Ul6nlKXm3ANtzcLKZeMo4cAjbCzXANhKz5rZh2m+ZQ=;
        b=eFiwbiWo1hTkerQ01vGiYAq2vb4Yeot7lWMXBtfpkjJsZApxOYrJ3R/OBknVXBwdzC
         lDoZnsJIFF5QAJX54uL4Z5KqxAS2e7ozxOx9XFlymKdU8tEcikkANHkHNzQXlclr0Nbu
         GAKvgygYHwoNewBcoNgB/sTEyA9c7WuKITzjafToYvNoS/xEIs1ykGx7DYWAdScofG8r
         kkqXsu7FoUE/1AHJtcY4eApXkr4lqR6EhiqZpagxj5LwmjB/A/lgnJOf4HIey9Dg822T
         hDv+naBKk3sf1d/5rPUoeLsaHMJ7mbN7w0zMh3WcoZblzt2/GwgzUQ6XwuKPFbGCfduO
         XCmg==
X-Gm-Message-State: AAQBX9dwuph5on/m5bwFph2eI28HJ/FCdgur3XQTXjzAH7Dt28bWTe6z
        H7xN7GjTAKqxjem2kjRdnBn3Bhl5iuJol+yuP+g=
X-Google-Smtp-Source: AKy350alkcrnhkUhfGnjbqJPl6ndrTvfvrxepSMuq7YGBS8Z0COGdbqa9VJ725gLBwg21V/WFgywYQ==
X-Received: by 2002:a1c:4c15:0:b0:3f1:7bac:d408 with SMTP id z21-20020a1c4c15000000b003f17bacd408mr4009790wmf.26.1681910871363;
        Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:51 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 15/16] virtio/vhost: Support line interrupt signaling
Date:   Wed, 19 Apr 2023 14:21:19 +0100
Message-Id: <20230419132119.124457-16-jean-philippe@linaro.org>
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
index 96c7b3ea..738efcd1 100644
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
@@ -256,8 +258,8 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
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
index 568243ab..b31ea46b 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -197,6 +197,7 @@ void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
 	vq->endian		= vdev->endian;
 	vq->use_event_idx	= (vdev->features & (1UL << VIRTIO_RING_F_EVENT_IDX));
 	vq->enabled		= true;
+	vq->vdev		= vdev;
 
 	if (addr->legacy) {
 		unsigned long base = (u64)addr->pfn * addr->pgsize;
diff --git a/virtio/net.c b/virtio/net.c
index 56dcfdb0..9568b055 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -674,8 +674,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 	if (ndev->vhost_fd == 0)
 		return;
 
-	virtio_vhost_set_vring_call(kvm, ndev->vhost_fd, vq, gsi,
-				    &queue->vq);
+	virtio_vhost_set_vring_irqfd(kvm, gsi, &queue->vq);
 }
 
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 02afee2a..60b5bc36 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -121,8 +121,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
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
-	if (r < 0)
-		die_perror("KVM_IRQFD failed");
+	if (queue->gsi)
+		irq__del_irqfd(kvm, queue->gsi, fd);
+	else
+		/* Disconnect user polling thread */
+		epoll_ctl(epoll.fd, EPOLL_CTL_DEL, fd, NULL);
 
-	r = ioctl(vhost_fd, VHOST_SET_VRING_CALL, &file);
+	/* Connect the direct IRQFD route */
+	r = irq__add_irqfd(kvm, gsi, fd, -1);
 	if (r < 0)
-		die_perror("VHOST_SET_VRING_CALL failed");
+		die_perror("KVM_IRQFD failed");
 
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
2.40.0

