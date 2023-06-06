Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA252724397
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbjFFNF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238046AbjFFNFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489C8E78
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:15 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30c2bd52f82so6200285f8f.3
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056714; x=1688648714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JloPPQ1qbkFN5goPusSpNn9bb4SJrlcsJMCIiGexgDs=;
        b=gX3hw9OR9nrLa44yB9razmn8dCcgDmYHZMMdYYlL/XQ81CgdmesUhyYYGyZHfMN1KP
         UX/5OQJUcoCa5VukebfZr7KguCNCkQKNxOYaH4jFkhQBTqO6t0Q9n/AHAm+M823QO2LT
         /JFacp6jKeK9aqEwBggLfY/fShGtfGC88H8WeQgtUUp+VXdJMzEuPVPlrT7KfdVae5iS
         9RVtKXAyISNXjfapdrhFMkCgpbgfXi6TmH/Mhd98FcUhRoaaSBFpFSMihppTJvEDkAXL
         Orn1b9KzcZh7iAi/Y79EpmQy37UFjJcbWEzcEP62+rsk9+wwjyBjJSRXknJr064b3HdO
         rz3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056714; x=1688648714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JloPPQ1qbkFN5goPusSpNn9bb4SJrlcsJMCIiGexgDs=;
        b=QzFIwaymP/s17V6t+oG4kWk+sFR9k3kkTgJhzckwYy2d7gWCuP/ewy66AYtzqx43on
         KHafe4cE72gM19Pmu2ZoEIiVUIxAOWawD9aVaWoCsvOiV2y6kivMvbwVvzrKFJIKefXm
         s9XW6DK0UVsrMDQHU8GMiBqAhB5PMBqiI/FapdPN/7OJaLbQVi/un0257cunjYKejt3w
         9BeKurd7+KhNcvJcvHlww/wHQCUanLuupiLyE6hSwZBl4wmsU0dzclfCsNhLoaDxoewa
         v527LIhEmUJzpGJMWeZi5ayjDjKO8SoB1lLQDSjlHLuPbsOLzSVpBB/ufSDjkf72AuzS
         w+/A==
X-Gm-Message-State: AC+VfDyL84Y90XuZNZPSGwpTCjcR/u9Yfzmw/Kvh/9KDMbXYQxW4tBWH
        XUyOb9zrlB6Umt7rBJYL0lfXtFVgPLG32zb4AXh9+g==
X-Google-Smtp-Source: ACHHUZ6Y0Pmr4FBKzBkJ4oAYPHb/yMHTYZxtIk/9VokRTHSwN6rU/G/SdZmuAHB1XuvExObYEr/H7A==
X-Received: by 2002:a05:6000:9:b0:30a:d517:2359 with SMTP id h9-20020a056000000900b0030ad5172359mr2064159wrx.64.1686056713910;
        Tue, 06 Jun 2023 06:05:13 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:13 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 03/17] virtio/vhost: Factor notify_vq_eventfd()
Date:   Tue,  6 Jun 2023 14:04:12 +0100
Message-Id: <20230606130426.978945-4-jean-philippe@linaro.org>
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

All vhost devices perform the same operation when setting up the
ioeventfd. Move it to virtio/vhost.c

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  2 ++
 virtio/net.c         |  9 +--------
 virtio/scsi.c        |  9 +--------
 virtio/vhost.c       | 14 ++++++++++++++
 virtio/vsock.c       | 14 ++------------
 5 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index daea8554..6912875e 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -261,6 +261,8 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
 void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			    struct virt_queue *queue);
+void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
+				 u32 index, int event_fd);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index b7c64a08..c0871163 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -701,18 +701,11 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
 {
 	struct net_dev *ndev = dev;
-	struct vhost_vring_file file = {
-		.index	= vq,
-		.fd	= efd,
-	};
-	int r;
 
 	if (ndev->vhost_fd == 0 || is_ctrl_vq(ndev, vq))
 		return;
 
-	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_KICK, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_KICK failed");
+	virtio_vhost_set_vring_kick(kvm, ndev->vhost_fd, vq, efd);
 }
 
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 6aa0909f..ebddec36 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -121,18 +121,11 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
 {
 	struct scsi_dev *sdev = dev;
-	struct vhost_vring_file file = {
-		.index	= vq,
-		.fd	= efd,
-	};
-	int r;
 
 	if (sdev->vhost_fd == 0)
 		return;
 
-	r = ioctl(sdev->vhost_fd, VHOST_SET_VRING_KICK, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_KICK failed");
+	virtio_vhost_set_vring_kick(kvm, sdev->vhost_fd, vq, efd);
 }
 
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
diff --git a/virtio/vhost.c b/virtio/vhost.c
index afe37465..3acfd30a 100644
--- a/virtio/vhost.c
+++ b/virtio/vhost.c
@@ -65,3 +65,17 @@ void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 	if (r < 0)
 		die_perror("VHOST_SET_VRING_ADDR failed");
 }
+
+void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
+				 u32 index, int event_fd)
+{
+	int r;
+	struct vhost_vring_file file = {
+		.index	= index,
+		.fd	= event_fd,
+	};
+
+	r = ioctl(vhost_fd, VHOST_SET_VRING_KICK, &file);
+	if (r < 0)
+		die_perror("VHOST_SET_VRING_KICK failed");
+}
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 2f7906f2..0ada9e09 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -80,21 +80,11 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
 {
 	struct vsock_dev *vdev = dev;
-	struct vhost_vring_file file = {
-		.index	= vq,
-		.fd	= efd,
-	};
-	int r;
 
-	if (is_event_vq(vq))
+	if (vdev->vhost_fd == -1 || is_event_vq(vq))
 		return;
 
-	if (vdev->vhost_fd == -1)
-		return;
-
-	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_KICK, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_KICK failed");
+	virtio_vhost_set_vring_kick(kvm, vdev->vhost_fd, vq, efd);
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
-- 
2.40.1

