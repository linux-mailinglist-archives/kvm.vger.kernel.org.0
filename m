Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 554D47243A3
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237962AbjFFNFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237895AbjFFNFU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374E1E5D
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:19 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-30c5e5226bdso4123031f8f.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056717; x=1688648717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TRqOAAr0go5z5Hhx7QytTfw699MDxCAnmUjosYF7e0M=;
        b=Nbw4sqNGJ9UISJbM7xRTYoCv+x1Ajy/AOlHsecUsda5WWz/Z5CzLT/bngCanJUhyML
         Hy7lBIdQq9YSuTTs2/ROaQPhhXxEHTK0FLZ7imQZMD1pFv9u5FBvpgYK4uX/jHFJJCik
         ZN1Nx7VLuBMbw+epduRsPfHkGFVhnPHSCdKKmwd6yypLersx8V7RE/MLOWKCbjNu0ITU
         v/7Nla2YNTnT9yelBtJGFEgIlXlGNvy1LEKANa7UrEvsEzZiQ//JwvkqedaG7MrK9MKB
         sTLMidxiYjfBYM2+tfGin7O2DdX2tV3OlC8rdG5q1TEX+riNYpCYD+U9gPlTGQyei0zb
         wLSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056717; x=1688648717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TRqOAAr0go5z5Hhx7QytTfw699MDxCAnmUjosYF7e0M=;
        b=cQtQXGAsCDEpVCcD5sxZsveQ1QXBgsbtuSKswBHWv34PYPbhzwyZwoWqxO53gwwev1
         OOShq0TzLf8HgTJ64Tqh4qlMEhsSpVc37+uKbNMHRfVEN+b73SB1S5bYsFiILZIpciMW
         arso3POSaATLgxYh5E2Alpobi9qVjlEsk62sJqzzEKlW6XXgYrD7MOl63lHGsKMw09Nz
         6zkd6lTDKxfYsr5EjvoKBYye0G1tXiiFV5jnP9cThxVRAmCDNfmOdj37ONWUq6hfw8Ya
         UR/zRUCY3fZsMIAJa6YZAdbkaASQF0GBoAQfsXzxCZJ6BCWT85BkldSwQd/LWyappbyV
         lbNw==
X-Gm-Message-State: AC+VfDze5FhgwQn8Icuem4ZCm7TlQbdFjMuWF3t7Ls0aIOL0hn+LW4KN
        /vjJ9q6KmozoLHd/H1v9Z8SF3MJrDjYjhQFkTOiesw==
X-Google-Smtp-Source: ACHHUZ6GWYE8INrWNnx7RSKrqhXGsloyGvknuoUQ3r3PIf7b04Nmdmmy2NvvZGbkpSXTsSvVaz59sQ==
X-Received: by 2002:adf:dec3:0:b0:309:49e3:efb4 with SMTP id i3-20020adfdec3000000b0030949e3efb4mr1773175wrn.63.1686056717751;
        Tue, 06 Jun 2023 06:05:17 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:17 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 09/17] virtio/scsi: Fix feature selection
Date:   Tue,  6 Jun 2023 14:04:18 +0100
Message-Id: <20230606130426.978945-10-jean-philippe@linaro.org>
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
index 4d1ed9b8..50f184c7 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -46,19 +46,35 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 
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
 	u16 endian = vdev->endian;
 
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
@@ -161,23 +177,12 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 
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
2.40.1

