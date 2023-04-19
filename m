Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 260D06E7AAE
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbjDSN1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233064AbjDSN1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456BA46BB
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id a8-20020a05600c348800b003f17ddb04e3so1370748wmq.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910865; x=1684502865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zXXPAPd7Lhm10tnhbD93859rtM6+xJNLXlNQi2l/X0c=;
        b=zZt2owNkIF/em6SsvBR4V2ThQ//6hSvYcdmLofZlZpRJP1kkWk0SvBziPb3CcDKqZi
         Sda5O9qv04fHV3XCa3iZYMmBfR7YJViUaPzy59Dn6m12n6dVZWpjqwP01y5a4LhCuF0j
         HcYlkO5McEtRNN0+mtrskx6f6cO8p83lSSrqlmEnemgtY430c47ZfHBaIXsqHm0t81v0
         BRC5Zr1wb3Ihr4xiC8bGtGM74NMdj05BHcmdco7h1GSn02JZ8NBhitOaP3+oE1lVoNNA
         iPJnlMGoYDomOCGcWoHfahdUuvRHc0hXbaok8W367KPE2BpuHKPHSv4NAFvZEe3UobtB
         krFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910865; x=1684502865;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zXXPAPd7Lhm10tnhbD93859rtM6+xJNLXlNQi2l/X0c=;
        b=Qa6x0y2ILfDpHivlbWGWlH9DBeyOzWuvpBA9SicNv2yxPAOzqwc3LpB2+s3VmvzF+5
         e+Um6ssRtR427wbZ7AGzpYPKkyLfrhRjJf0b0xIyRVcW8w48hVHbWC/7TvdZH1MehsWP
         ygHGeu2rM/NoeFmCv8BAUcYt5AX/TslXU05zw/5rti5rFkmcITjIdBjS00kBL4BmwOmi
         xAfUwFhdMC5Gkf/kY0pMCEnesCPRZJtPtNlIcBJE2+7IXSceLKI+LjcHONyyIUxsIM7s
         C8ihKqmeTFYAXFaKYIXCJvgU26DkSvKps0ctHjZ84wosrbNdz1u5pQFmW5T+uyfzbL0m
         1yKw==
X-Gm-Message-State: AAQBX9fEMuzMicrFLOImn0DwpecMzyxGDoOOAraIHuJkPccQe+MrNpqd
        joaIKbWPJhnEiQTXvW4HnugkXSs3QDlTiVRPitk=
X-Google-Smtp-Source: AKy350ZsTNOTfkGJNDgRAiMdWGQVr/Q+y7HhNQcCUcQkZvcAomHjBfYje6Zto9k4habQ3aunPzhTIg==
X-Received: by 2002:a7b:cbd3:0:b0:3f0:a785:f0f5 with SMTP id n19-20020a7bcbd3000000b003f0a785f0f5mr15850062wmi.16.1681910864795;
        Wed, 19 Apr 2023 06:27:44 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:44 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 03/16] virtio/vhost: Factor notify_vq_eventfd()
Date:   Wed, 19 Apr 2023 14:21:07 +0100
Message-Id: <20230419132119.124457-4-jean-philippe@linaro.org>
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

All vhost devices perform the same operation when setting up the
ioeventfd. Move it to virtio/vhost.c

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  2 ++
 virtio/net.c         |  9 +--------
 virtio/scsi.c        |  9 +--------
 virtio/vhost.c       | 14 ++++++++++++++
 virtio/vsock.c       | 14 ++------------
 5 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index c8fd69e0..4a364a02 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -250,6 +250,8 @@ void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
 void virtio_vhost_set_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			    struct virt_queue *queue);
+void virtio_vhost_set_vring_kick(struct kvm *kvm, int vhost_fd,
+				 u32 index, int event_fd);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index 021c81d3..b935d24f 100644
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
index 674aad34..1f757404 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -123,18 +123,11 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
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
-		return;
-
-	if (vdev->vhost_fd == -1)
+	if (vdev->vhost_fd == -1 || is_event_vq(vq))
 		return;
 
-	r = ioctl(vdev->vhost_fd, VHOST_SET_VRING_KICK, &file);
-	if (r < 0)
-		die_perror("VHOST_SET_VRING_KICK failed");
+	virtio_vhost_set_vring_kick(kvm, vdev->vhost_fd, vq, efd);
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
-- 
2.40.0

