Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597196E7AB5
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbjDSN2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbjDSN1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:55 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CBC59F0
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id r15so7558937wmo.1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910868; x=1684502868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SkoSoKNv/YXHE8EKeXeR9Q6UNSRCk5/IST0YxoWr2N8=;
        b=npOrSGVDRUHtOj31sPo069NHOAG1xZsv+DPlGjIbzXnTcQf6Ij9BUoS9lz2M7Vd/7N
         Tx4eiu/f66QO5nko83CWd5KYN9IMzj54DkDOSbmHFzO3tWqmpXz2eROF9z52Rh0T17XJ
         wKuVzQFmCBlo+Kvm7+WDTdJEj9yAfgzblGEZoHVwjirUH+ffhOzLkq6ZsEJc4j+GEgaV
         g9c+ZUJOq0MnQ7N+m+9bq4q9ruMhWXBNymUNtaDzj3C8eWrqyqR/K0sq/KmcJB+hgTOS
         U/B4I6HC3tMtPDwsg7oFUfzobuYwJod9/PY7C+Yi2MhSBuDcGJfNPzHOHxgoEm3dcYF2
         CXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910868; x=1684502868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SkoSoKNv/YXHE8EKeXeR9Q6UNSRCk5/IST0YxoWr2N8=;
        b=PhAoIKoIkhFxi4MqcR/BQCEIOjE6nm8Eo0DEZ0LiDOw3NU9nfbeEBGwPgha8vSuhfG
         yK+1xVLARWgisb4bSY5qLYMZtLeim31R3tBSerq6grOlqWcWwpK+v6pNaiREyyITgpNN
         4BtxXjvkzEh6a87O9fG1+62MYbab4PhyOlW/gkrFT+ohhh0JiEaAZjwqafej2C0M++h+
         +cZ3WZPbdEKw8GNTCKMnhiFxOly991rL3M/nzgW5ZXbrbRf5BsJ5ueAmfuwIMHZKpmuU
         WxisuaJWOk9P15PfDKw/aOiYO4EkwgaaiHxsgo68dxC0zOF8WPL1tM2VkzWUrHqpuXbn
         bqbQ==
X-Gm-Message-State: AAQBX9ethLMPvYZbFlDmcFGp34pzWKF04Cqmy2UJHdWbT41sSiwH5Adf
        nZtuIhME7otwDJq4UZl6ZfDLXGBSZ1/ZFVLo+40=
X-Google-Smtp-Source: AKy350bKrOHr39CsBEQClTVd7Dgwd3ZhsMnjPwIG/93FjsB0ZrwgjSOd+rSxZJnpL77vMQWG07wgyg==
X-Received: by 2002:a7b:c3cc:0:b0:3f1:6fca:d5a5 with SMTP id t12-20020a7bc3cc000000b003f16fcad5a5mr9258589wmj.17.1681910867904;
        Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 09/16] virtio/scsi: Fix feature selection
Date:   Wed, 19 Apr 2023 14:21:13 +0100
Message-Id: <20230419132119.124457-10-jean-philippe@linaro.org>
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

This fixes scsi because we used to enable all vhost features including
VIRTIO_SCSI_F_T10_PI which changes the request layout and caused
inconsistency between guest and vhost.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/scsi.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/virtio/scsi.c b/virtio/scsi.c
index fc1c2ad9..5f392814 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -46,18 +46,34 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 
 static u64 get_host_features(struct kvm *kvm, void *dev)
 {
-	return	1UL << VIRTIO_RING_F_EVENT_IDX |
-		1UL << VIRTIO_RING_F_INDIRECT_DESC;
+	int r;
+	u64 features;
+	struct scsi_dev *sdev = dev;
+
+	r = ioctl(sdev->vhost_fd, VHOST_GET_FEATURES, &features);
+	if (r != 0)
+		die_perror("VHOST_GET_FEATURES failed");
+
+	return features &
+		(1ULL << VIRTIO_RING_F_EVENT_IDX |	\
+		 1ULL << VIRTIO_RING_F_INDIRECT_DESC |	\
+		 1ULL << VIRTIO_F_ANY_LAYOUT);
 }
 
 static void notify_status(struct kvm *kvm, void *dev, u32 status)
 {
+	int r;
 	struct scsi_dev *sdev = dev;
 	struct virtio_device *vdev = &sdev->vdev;
 	struct virtio_scsi_config *conf = &sdev->config;
 
 	if (status & VIRTIO__STATUS_START) {
-		int r = ioctl(sdev->vhost_fd, VHOST_SCSI_SET_ENDPOINT,
+		r = ioctl(sdev->vhost_fd, VHOST_SET_FEATURES,
+			  &sdev->vdev.features);
+		if (r != 0)
+			die_perror("VHOST_SET_FEATURES failed");
+
+		r = ioctl(sdev->vhost_fd, VHOST_SCSI_SET_ENDPOINT,
 			      &sdev->target);
 		if (r != 0)
 			die("VHOST_SCSI_SET_ENDPOINT failed %d", errno);
@@ -163,23 +179,12 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 
 static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
 {
-	u64 features;
-	int r;
-
 	sdev->vhost_fd = open("/dev/vhost-scsi", O_RDWR);
 	if (sdev->vhost_fd < 0)
 		die_perror("Failed openning vhost-scsi device");
 
 	virtio_vhost_init(kvm, sdev->vhost_fd);
 
-	r = ioctl(sdev->vhost_fd, VHOST_GET_FEATURES, &features);
-	if (r != 0)
-		die_perror("VHOST_GET_FEATURES failed");
-
-	r = ioctl(sdev->vhost_fd, VHOST_SET_FEATURES, &features);
-	if (r != 0)
-		die_perror("VHOST_SET_FEATURES failed");
-
 	sdev->vdev.use_vhost = true;
 }
 
-- 
2.40.0

