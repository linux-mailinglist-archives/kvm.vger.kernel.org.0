Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C236E7AB6
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbjDSN2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbjDSN14 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:56 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE315B85
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id v3so4079213wml.0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910868; x=1684502868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dixA9kKFl5JSfKMwpuKUuIPy386aRkC3mwFk4r9wlY8=;
        b=Y3KwykM3BE51NzROM2NHye3ECanMguJpIUmsLTQn+5ija77ydBuqvzFyau3aOfT9a3
         occxsEWlpknfvqwLvMSPyRvKGWazl7cRxE1fJOJ+W1tTLwH7JFH78a2EJdryxUNZVHnk
         soRKNwTJJGUMvga7rG2Yv4srg8X3tDFUd7JAwDasU1HCdADnCeXO1t/yv/GXv0j58paq
         uxMbEI8ES8GQR7NrKftErhK8cQYwltpbWg6wGnlke5YBWOSLLE59dwUG+l+d3LNk5gtu
         9irel1dUak0g5OVrCPsJzLxuv03m05HDUndqfsIuRary7HjDzzJc/BYq5z4QynvYh3Yg
         x4bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910868; x=1684502868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dixA9kKFl5JSfKMwpuKUuIPy386aRkC3mwFk4r9wlY8=;
        b=H5uc7ZNpH5f0c+KlmXJPVxsLzgwNJUWlR1LpaCVXKtvu8NlZj5jo6MlNGm8IizpO7G
         RMWvYrcKgX/xX26+bbHgJ9Lk9zM/f3QGV1Oz4wzKzqXlZvdyKlHDFIrZoVk7JByMAtDO
         TUDRsCJdnreXw1j4nOvtAYuDxiG9AOm9Nq8gEUE7JHCHWo8e1kLnBA6/KvrTnvnnYaJA
         EhUu+Ul437XQnx16jr/wuVyCke6PuDRbhfJVk6cwiDpyMRIVxLqdvIX9U4jXI+JVCFum
         i5sqonwaqaKczmYT76LobwCOJmo0HvLllviHSTZE9VEJXpxiWqFiFtc68UssQNHigkQf
         WPyg==
X-Gm-Message-State: AAQBX9e2APdjyhqiZqLno8XpYGKJNWJELWu9yHTnES00Gq9VqZZ6Ky3f
        j9mdOu1jhXpajbEVe6+8+W7eHcqyDWWSmRJnBZ8=
X-Google-Smtp-Source: AKy350ZxldFMhe1QuQBvEujxYp1jIY6xzrKkIHksCqeF2ngc5eLqwL03sgg+U4Zg0WfUbDMhUTBaYw==
X-Received: by 2002:a05:600c:2241:b0:3f1:7a44:317c with SMTP id a1-20020a05600c224100b003f17a44317cmr4207622wmm.24.1681910868493;
        Wed, 19 Apr 2023 06:27:48 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:48 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 10/16] virtio/vsock: Fix feature selection
Date:   Wed, 19 Apr 2023 14:21:14 +0100
Message-Id: <20230419132119.124457-11-jean-philippe@linaro.org>
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

We should advertise to the guest only the features supported by vhost
and kvmtool. Then we should set in vhost only the features acked by the
guest. Move vhost feature query to get_host_features(), and vhost
feature setting to device start (after the guest has acked features).

This fixes vsock because we used to enable all vhost features including
VIRTIO_F_ACCESS_PLATFORM, which forces vhost to use vhost-iotlb and
isn't supported by kvmtool.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/vsock.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/virtio/vsock.c b/virtio/vsock.c
index 559fbaba..64512713 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -51,8 +51,17 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 
 static u64 get_host_features(struct kvm *kvm, void *dev)
 {
-	return 1UL << VIRTIO_RING_F_EVENT_IDX
-		| 1UL << VIRTIO_RING_F_INDIRECT_DESC;
+	int r;
+	u64 features;
+	struct vsock_dev *vdev = dev;
+
+	r = ioctl(vdev->vhost_fd, VHOST_GET_FEATURES, &features);
+	if (r != 0)
+		die_perror("VHOST_GET_FEATURES failed");
+
+	return features &
+		(1ULL << VIRTIO_RING_F_EVENT_IDX |
+		 1ULL << VIRTIO_RING_F_INDIRECT_DESC);
 }
 
 static bool is_event_vq(u32 vq)
@@ -95,12 +104,18 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	if (status & VIRTIO__STATUS_CONFIG)
 		vdev->config.guest_cid = cpu_to_le64(vdev->guest_cid);
 
-	if (status & VIRTIO__STATUS_START)
+	if (status & VIRTIO__STATUS_START) {
 		start = 1;
-	else if (status & VIRTIO__STATUS_STOP)
+
+		r = ioctl(vdev->vhost_fd, VHOST_SET_FEATURES,
+			  &vdev->vdev.features);
+		if (r != 0)
+			die_perror("VHOST_SET_FEATURES failed");
+	} else if (status & VIRTIO__STATUS_STOP) {
 		start = 0;
-	else
+	} else {
 		return;
+	}
 
 	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_RUNNING, &start);
 	if (r != 0)
@@ -162,7 +177,6 @@ static struct virtio_ops vsock_dev_virtio_ops = {
 
 static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
 {
-	u64 features;
 	int r;
 
 	vdev->vhost_fd = open("/dev/vhost-vsock", O_RDWR);
@@ -171,14 +185,6 @@ static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
 
 	virtio_vhost_init(kvm, vdev->vhost_fd);
 
-	r = ioctl(vdev->vhost_fd, VHOST_GET_FEATURES, &features);
-	if (r != 0)
-		die_perror("VHOST_GET_FEATURES failed");
-
-	r = ioctl(vdev->vhost_fd, VHOST_SET_FEATURES, &features);
-	if (r != 0)
-		die_perror("VHOST_SET_FEATURES failed");
-
 	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_GUEST_CID, &vdev->guest_cid);
 	if (r != 0)
 		die_perror("VHOST_VSOCK_SET_GUEST_CID failed");
-- 
2.40.0

