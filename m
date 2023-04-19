Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99CD6E7AAD
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbjDSN1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjDSN1u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:50 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C641946B8
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o9-20020a05600c510900b003f17012276fso1448207wms.4
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910864; x=1684502864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dG6Xi5SOJYX9tPMmvGwZ7Yq19JpXfFx6Wpu13jh0dK4=;
        b=oFJ4QFuwFgqBqWtibkqRDTRIkNYgbXPA3V1/WyazATLUi0tY0SbP62P69xfI/lffFw
         mqBt4/w/hqRPdQi+c5enMUyEaTJDZ27DXPz6Gwi1okOdz9JEh5r1EpwIlY3KN6xjmi9I
         vnMRWX8H6rnnFK4NTI2uS5ZLRE/KfnZ6HMBOmODaCA9nvmzR1IuI+dPoJlayGaz7SYW5
         p2ZEJS/wVH9XwvR0B6m6OXGq2h0Qrkg5s7RaSBi8RNXz19/dKqEoz3rIy3CtPi5+Ao8M
         fSUBgV6N2ftM8AWzsDTYjOX3/oE5xJGEV1hI3oVC52uwcgcK8llC3+Cvf3BziFbfDOK/
         iFbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910864; x=1684502864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dG6Xi5SOJYX9tPMmvGwZ7Yq19JpXfFx6Wpu13jh0dK4=;
        b=Amg4zW0q3Ruz4s/EJlePkyEWii4hGIP97lSfVSBg5AudC3necrhnaSEeuWtGuqPAtW
         A/sjkkR7Kcu70UiU0n8rlkhS3dT3HIR/K8r9nWn+El5fLST4UfcjR6sSQwcWa1i6Byit
         VjtrXE2oUgFRX7gz/d/siCicUu8OahFifvJxR09u7eaAPbFLwW/8XBfEZtE2CEITIWuD
         O1499CULWIpIga7L8pafP2gxu3R0U4TrtWx2lH34cN83xAb71K+Byv4/HLL9b913XBDR
         cdPKjQtBWai3WZHfvNxJCF0XYmIpBXwx+sXhPGygTkltHriSdpv9VUhyKsQvpfbtMzzX
         KqZQ==
X-Gm-Message-State: AAQBX9ecsmpaxMGRjqFbYX0Fr7oCRqE6jdpYzv8ft6ATZzfqJBSaRnJb
        ilONmAAtGy7K4anHFxnRUrGYp0lrdLKKBR2EUKw=
X-Google-Smtp-Source: AKy350YzkwRMfalEPSFShkUHuKhHcYo43UfGZEbaXgMqzSFZiwoCQ7qHivH+MzE9VfQz7OeHqwztaw==
X-Received: by 2002:a05:600c:b49:b0:3f1:7123:fd12 with SMTP id k9-20020a05600c0b4900b003f17123fd12mr9723612wmr.34.1681910864296;
        Wed, 19 Apr 2023 06:27:44 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:44 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 02/16] virtio/vhost: Factor vring operation
Date:   Wed, 19 Apr 2023 14:21:06 +0100
Message-Id: <20230419132119.124457-3-jean-philippe@linaro.org>
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

The VHOST_VRING* ioctls are common to all device types, move them to
virtio/vhost.c

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  2 ++
 virtio/net.c         | 25 +------------------------
 virtio/scsi.c        | 24 +-----------------------
 virtio/vhost.c       | 33 ++++++++++++++++++++++++++++++++-
 virtio/vsock.c       | 30 ++----------------------------
 5 files changed, 38 insertions(+), 76 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index cd72bf11..c8fd69e0 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -248,6 +248,8 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
 void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
+void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
+			    struct virt_queue *queue);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index 6b44754f..021c81d3 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -600,10 +600,8 @@ static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
-	struct vhost_vring_state state = { .index = vq };
 	struct vhost_vring_file file = { .index = vq };
 	struct net_dev_queue *net_queue;
-	struct vhost_vring_addr addr;
 	struct net_dev *ndev = dev;
 	struct virt_queue *queue;
 	int r;
@@ -634,28 +632,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 		return 0;
 	}
 
-	if (queue->endian != VIRTIO_ENDIAN_HOST)
-		die_perror("VHOST requires the same endianness in guest and host");
-
-	state.num = queue->vring.num;
-	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_NUM, &state);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_NUM failed");
-	state.num = 0;
-	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_BASE, &state);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_BASE failed");
-
-	addr = (struct vhost_vring_addr) {
-		.index = vq,
-		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
-		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
-		.used_user_addr = (u64)(unsigned long)queue->vring.used,
-	};
-
-	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_ADDR failed");
+	virtio_vhost_set_vring(kvm, ndev->vhost_fd, vq, queue);
 
 	file.fd = ndev->tap_fd;
 	r = ioctl(ndev->vhost_fd, VHOST_NET_SET_BACKEND, &file);
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 4dee24a0..674aad34 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -74,11 +74,8 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
-	struct vhost_vring_state state = { .index = vq };
-	struct vhost_vring_addr addr;
 	struct scsi_dev *sdev = dev;
 	struct virt_queue *queue;
-	int r;
 
 	compat__remove_message(compat_id);
 
@@ -89,26 +86,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 	if (sdev->vhost_fd == 0)
 		return 0;
 
-	state.num = queue->vring.num;
-	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_NUM, &state);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_NUM failed");
-	state.num = 0;
-	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_BASE, &state);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_BASE failed");
-
-	addr = (struct vhost_vring_addr) {
-		.index = vq,
-		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
-		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
-		.used_user_addr = (u64)(unsigned long)queue->vring.used,
-	};
-
-	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_ADDR failed");
-
+	virtio_vhost_set_vring(kvm, sdev->vhost_fd, vq, queue);
 	return 0;
 }
 
diff --git a/virtio/vhost.c b/virtio/vhost.c
index f9f72f51..afe37465 100644
--- a/virtio/vhost.c
+++ b/virtio/vhost.c
@@ -1,7 +1,8 @@
+#include "kvm/virtio.h"
+
 #include <linux/kvm.h>
 #include <linux/vhost.h>
 #include <linux/list.h>
-#include "kvm/virtio.h"
 
 void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
 {
@@ -34,3 +35,33 @@ void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
 
 	free(mem);
 }
+
+void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
+			    struct virt_queue *queue)
+{
+	int r;
+	struct vhost_vring_addr addr = {
+		.index = index,
+		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
+		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
+		.used_user_addr = (u64)(unsigned long)queue->vring.used,
+	};
+	struct vhost_vring_state state = { .index = index };
+
+	if (queue->endian != VIRTIO_ENDIAN_HOST)
+		die("VHOST requires the same endianness in guest and host");
+
+	state.num = queue->vring.num;
+	r = ioctl(vhost_fd, VHOST_SET_VRING_NUM, &state);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_NUM failed");
+
+	state.num = 0;
+	r = ioctl(vhost_fd, VHOST_SET_VRING_BASE, &state);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_BASE failed");
+
+	r = ioctl(vhost_fd, VHOST_SET_VRING_ADDR, &addr);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_ADDR failed");
+}
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 4b8be8d7..2f7906f2 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -62,44 +62,18 @@ static bool is_event_vq(u32 vq)
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
-	struct vhost_vring_state state = { .index = vq };
-	struct vhost_vring_addr addr;
 	struct vsock_dev *vdev = dev;
 	struct virt_queue *queue;
-	int r;
 
 	compat__remove_message(compat_id);
 
 	queue		= &vdev->vqs[vq];
 	virtio_init_device_vq(kvm, &vdev->vdev, queue, VIRTIO_VSOCK_QUEUE_SIZE);
 
-	if (vdev->vhost_fd == -1)
+	if (vdev->vhost_fd == -1 || is_event_vq(vq))
 		return 0;
 
-	if (is_event_vq(vq))
-		return 0;
-
-	state.num = queue->vring.num;
-	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_NUM, &state);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_NUM failed");
-
-	state.num = 0;
-	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_BASE, &state);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_BASE failed");
-
-	addr = (struct vhost_vring_addr) {
-		.index = vq,
-		.desc_user_addr = (u64)(unsigned long)queue->vring.desc,
-		.avail_user_addr = (u64)(unsigned long)queue->vring.avail,
-		.used_user_addr = (u64)(unsigned long)queue->vring.used,
-	};
-
-	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_ADDR, &addr);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_ADDR failed");
-
+	virtio_vhost_set_vring(kvm, vdev->vhost_fd, vq, queue);
 	return 0;
 }
 
-- 
2.40.0

