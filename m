Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C91D72439B
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237976AbjFFNFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238045AbjFFNFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:16 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF89012F
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-30aeee7c8a0so4400954f8f.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056713; x=1688648713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I5RAi9Tjtg+0tkfH2bckb9u+xg+1YndWuvZYGgLAmRU=;
        b=pDvZfjHqEAKLC8nx+Mv5Ui4fiK6UuQtOnUzRlghm8ggbA1Qt2S61QtBp61+sQg+gZO
         4l5+XHu7pwrK+G7JiLpGiITAEzVlbbL7VqHKqB1JkgsEp1t6MrSExaFZh4I24qKP1398
         YETVEvBVRfZXHVStqYxozbaoi0kXwgmGI1WKryQXgbSnXN3Nb8HnWdq3XIAFuVABpjhe
         FKaSNPs2qd3zK/djEAvu9LYoTgxuD8TZpScI0Cn3Gn5S0LVF7s6oYo5nqzAMSTOfaumL
         LXWb83tk7QV0v+kZP7XVjIAQwxrDiS10Q9Jnl4Cx+/Ra7BsbxJ6/Dik4e95vYcjC6862
         XPlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056713; x=1688648713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I5RAi9Tjtg+0tkfH2bckb9u+xg+1YndWuvZYGgLAmRU=;
        b=l82DnrL1hkEUxuCdWiRQlyd2iLfUdIUtFrSBG0gcmoERf8EcyCLiVypf3DvSP3Se2N
         KUcGBSRMhYHK6Qis4np5uid6Depjk31+HVbc8dlT3VUxZ11KHUVFb1f/VoWYfWZS1r9Y
         S9up0WO47U3RNuQdLQsY6eHi3Akrjmh6DJWRCU/cEnFTjtFiHJZboTZ0Ozc3Gli57q9V
         M3TzilwJ0/m8JCUwz63GoXht/H4iWG6WplZrSDCsdInuvqCqLrsQvBLIqE+uKaXB7lhH
         yL6a3P0FyLrpxVmQNLEYN6L32spGrkfX5ellTu50qkORI//cgGVkhw7sE+sH8USnx0mq
         8GHA==
X-Gm-Message-State: AC+VfDyFj5Om+3UOAe7D1d1nPj1Ivsv/6rSUIr8ZG0C04XgNDBUzedCG
        kt9nVFoDBM5S9lJ4U94TLECpGtKYykuit6+MY9JhIA==
X-Google-Smtp-Source: ACHHUZ7mn64NhP17ugCoFl9Kv0DRiLKXJdNVeVj4qhRwNaTn3fQg+aQIXqGU1vRE44XunOFYeWKUAQ==
X-Received: by 2002:a05:6000:1052:b0:2f0:583:44be with SMTP id c18-20020a056000105200b002f0058344bemr2064652wrx.0.1686056713359;
        Tue, 06 Jun 2023 06:05:13 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:13 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 02/17] virtio/vhost: Factor vring operation
Date:   Tue,  6 Jun 2023 14:04:11 +0100
Message-Id: <20230606130426.978945-3-jean-philippe@linaro.org>
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

The VHOST_VRING* ioctls are common to all device types, move them to
virtio/vhost.c

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  2 ++
 virtio/net.c         | 25 +------------------------
 virtio/scsi.c        | 24 +-----------------------
 virtio/vhost.c       | 33 ++++++++++++++++++++++++++++++++-
 virtio/vsock.c       | 30 ++----------------------------
 5 files changed, 38 insertions(+), 76 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 4cc2e3d2..daea8554 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -259,6 +259,8 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
 void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
+void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
+			    struct virt_queue *queue);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index 65fdbd17..b7c64a08 100644
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
index 621a8334..6aa0909f 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -72,11 +72,8 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
-	struct vhost_vring_state state = { .index = vq };
-	struct vhost_vring_addr addr;
 	struct scsi_dev *sdev = dev;
 	struct virt_queue *queue;
-	int r;
 
 	compat__remove_message(compat_id);
 
@@ -87,26 +84,7 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
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
2.40.1

