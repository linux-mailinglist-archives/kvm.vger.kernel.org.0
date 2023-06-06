Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F287243AB
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237971AbjFFNFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbjFFNFZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:25 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DDFE78
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:23 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f739ec88b2so21792495e9.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056722; x=1688648722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdfytQloM9GeRF7CxB2XjlnNueBYEnZCkjNuVpc2Ttw=;
        b=lSQpQlaZ8OdCRKVxOclE35LDsH9mDXhUQNEpYW1nGHq+pQ+7fSuQQ+0AmcEoRi4ZaZ
         NgPQhlAMV5TGnFqV7HIwNH+xdpsEu1gTcANWSf3DYZMyHB9Zc0LBGZTLZhFoA+Swdm0H
         LtJRg6jyV29b9s+8L485hM+ThB3RyqJHPCG0kb3p0pfa9/VOw/2YRlo+Y78ZuErVnGnr
         dMUyxwNuOZY/vc4Q/04l+2B9c3D6u1oGs0HJuQs4vnQtBMQ03ZLUrnyPbBF5ZEQdWYI3
         bUYJV3KflDPVsk8Rk/aqLIY2gDi+zoD8ww4U/e40Gdq+4q0sTjY+fMJEENbav0YZd0WN
         zz0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056722; x=1688648722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdfytQloM9GeRF7CxB2XjlnNueBYEnZCkjNuVpc2Ttw=;
        b=j6PiV0LOU0XmW2lB6YA3MXEzjky3g8eqTYkyH+3pc2/SfJHb8JQhziNqCtGCZMc7FT
         swW+RtfranuG3CX0EZWpOzEw9ZN/ilTeFmVs9KtYG2JS9Sm6Z2BYwvI3nKTqFkP525ab
         LzTOWzvq+XgdTgnCaJ3mU6laq0gw5KXXt5ty5vDFrpk3uKPtjQm2B2rWj3wEz0K9rNiL
         YnCF7ldgr2xvKU467qsR6Nm+kwj1KvCzGiHJTM8cmMddcbXq5lm53S1uV/91kL9utcxx
         3nM3yqpjpWyt0xKJdAl3ntqSl3TWDtvZ8xBVO+SffTaTzkNH4M6xgt6+GyLreM0jnP9l
         q9ag==
X-Gm-Message-State: AC+VfDxe2G+P+JJh2y85De+dXIm0gdS0SxTtnA+9qNabNvdDWb5gpt5u
        eBdiLSPfO6LpAX5HTbhqhGJad1E0oSZBg8QGPBg2IQ==
X-Google-Smtp-Source: ACHHUZ73Fj0AX18apnyC3Af20nKXQt8bwuhd/9TkJB8q7tAZX1RkHMyF8uueo3TnlEJqUHz0pwp/5A==
X-Received: by 2002:adf:ec43:0:b0:30e:4265:c903 with SMTP id w3-20020adfec43000000b0030e4265c903mr1626264wrn.66.1686056722490;
        Tue, 06 Jun 2023 06:05:22 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:22 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 17/17] virtio/vhost: Clear VIRTIO_F_ACCESS_PLATFORM
Date:   Tue,  6 Jun 2023 14:04:26 +0100
Message-Id: <20230606130426.978945-18-jean-philippe@linaro.org>
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

Vhost interprets the VIRTIO_F_ACCESS_PLATFORM flag as if accesses need
to use vhost-iotlb, and since kvmtool does not implement vhost-iotlb,
vhost will fail to access the virtqueue.

This fix is preventive. Kvmtool does not set VIRTIO_F_ACCESS_PLATFORM at
the moment but the Arm CCA and pKVM changes will likely hit the issue
(as experienced with the CCA development tree), so we might as well fix
it now.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/virtio.h |  1 +
 virtio/net.c         | 16 +++++-----------
 virtio/scsi.c        |  3 +--
 virtio/vhost.c       | 11 +++++++++++
 virtio/vsock.c       |  4 ++--
 5 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 1fa33e5b..95b5142b 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -273,6 +273,7 @@ void virtio_vhost_set_vring_irqfd(struct kvm *kvm, u32 gsi,
 				  struct virt_queue *queue);
 void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 			      struct virt_queue *queue);
+int virtio_vhost_set_features(int vhost_fd, u64 features);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index 2b4b3661..f09dd0a4 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -517,23 +517,17 @@ static u64 get_host_features(struct kvm *kvm, void *dev)
 	return features;
 }
 
-static int virtio_net__vhost_set_features(struct net_dev *ndev)
-{
-	/* VHOST_NET_F_VIRTIO_NET_HDR clashes with VIRTIO_F_ANY_LAYOUT! */
-	u64 features = ndev->vdev.features &
-			~(1UL << VHOST_NET_F_VIRTIO_NET_HDR);
-
-	return ioctl(ndev->vhost_fd, VHOST_SET_FEATURES, &features);
-}
-
 static void virtio_net_start(struct net_dev *ndev)
 {
+	/* VHOST_NET_F_VIRTIO_NET_HDR clashes with VIRTIO_F_ANY_LAYOUT! */
+	u64 features = ndev->vdev.features & ~(1UL << VHOST_NET_F_VIRTIO_NET_HDR);
+
 	if (ndev->mode == NET_MODE_TAP) {
 		if (!virtio_net__tap_init(ndev))
 			die_perror("TAP device initialized failed because");
 
-		if (ndev->vhost_fd &&
-				virtio_net__vhost_set_features(ndev) != 0)
+		if (ndev->vhost_fd && virtio_vhost_set_features(ndev->vhost_fd,
+								features))
 			die_perror("VHOST_SET_FEATURES failed");
 	} else {
 		ndev->info.vnet_hdr_len = virtio_net_hdr_len(ndev);
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 27cb3798..a842290b 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -69,8 +69,7 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	u16 endian = vdev->endian;
 
 	if (status & VIRTIO__STATUS_START) {
-		r = ioctl(sdev->vhost_fd, VHOST_SET_FEATURES,
-			  &sdev->vdev.features);
+		r = virtio_vhost_set_features(sdev->vhost_fd, sdev->vdev.features);
 		if (r != 0)
 			die_perror("VHOST_SET_FEATURES failed");
 
diff --git a/virtio/vhost.c b/virtio/vhost.c
index 0049003b..ea640fa6 100644
--- a/virtio/vhost.c
+++ b/virtio/vhost.c
@@ -196,3 +196,14 @@ void virtio_vhost_reset_vring(struct kvm *kvm, int vhost_fd, u32 index,
 	close(queue->irqfd);
 	queue->irqfd = 0;
 }
+
+int virtio_vhost_set_features(int vhost_fd, u64 features)
+{
+	/*
+	 * vhost interprets VIRTIO_F_ACCESS_PLATFORM as meaning there is an
+	 * iotlb. Since this is not the case for kvmtool, mask it.
+	 */
+	u64 masked_feat = features & ~(1ULL << VIRTIO_F_ACCESS_PLATFORM);
+
+	return ioctl(vhost_fd, VHOST_SET_FEATURES, &masked_feat);
+}
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 5d22bd24..7d4053a1 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -107,8 +107,8 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	if (status & VIRTIO__STATUS_START) {
 		start = 1;
 
-		r = ioctl(vdev->vhost_fd, VHOST_SET_FEATURES,
-			  &vdev->vdev.features);
+		r = virtio_vhost_set_features(vdev->vhost_fd,
+					      vdev->vdev.features);
 		if (r != 0)
 			die_perror("VHOST_SET_FEATURES failed");
 	} else if (status & VIRTIO__STATUS_STOP) {
-- 
2.40.1

