Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 060E772439F
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbjFFNFf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238049AbjFFNFR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:17 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92066F4
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:16 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f6da07feb2so60669415e9.0
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056715; x=1688648715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1z+0zhNC212zBv9qAk/OMWR4cU4by9XEvjFcTPlw7g=;
        b=oU4JU2zAU7G1Ka0jsaqEKUl0gVS5ra9i4Tar3gwglmOEUGEaUWQBGTImV07tdLKWUk
         aPg0kBRnMvbF8wB5wdEj0udhZHIGRNd1YyChODuydet6nh+wwtDoSBRaBZ27YaQ8FQnU
         HJqA8A210dK4uEBiicYQzCxxl7CWTpPt4XN2k4yYLDoJxhONkdt0QegwJ2reyuHmAa8B
         uHVpU+45fh2BnVn7Q63FhulSBD00ePY9fdiYf0FwK84fbsH/oepk10168Mn6Bjpk1aAW
         ZGvhnK0k6kvDrfTH4ipsCar07uoQaO9rEg//kLGSr35hD4VTbKNFBqynZgR1odc/RjDn
         M3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056715; x=1688648715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J1z+0zhNC212zBv9qAk/OMWR4cU4by9XEvjFcTPlw7g=;
        b=kFUkZXW5wQERdbCVGeOi+HNGmPitUvDJhR2KnG1R5lp3T5yR/w2wtae02jQ3xDE/ov
         +5FPpgsx2/168Owh8dMPmIc5b4ujZUEVLaX6SrrrT3cXN3KsN5Qpf49mgqh7ZPbdJ5vH
         PhVrzqr7oOJR5gWzqf5rt0PwDuvv3VmQpvMKCwi9eHRD5MxeEAj+qfyBW969/d+Gzb/9
         WUwg4A34aTLR5mcaoZJE/+KrFYaGPFt64QKQRahHfcy4fH8gEjMLAwc+xKV198dKqEjK
         P+y6kokDd33ZgeGrmNhQM9BH8AQE9r7Y751TVt15kWxaMQD7GBbMcijbKIRIHbI4aTSr
         IURQ==
X-Gm-Message-State: AC+VfDwLZt6S3gJWKTuHpMSshVyicPNAOgOXEMcxslSh/M17yi35Rmpj
        2sDy2hk+Nkq2hDifJ3rKraN1ca8YEj7odXYCoBvm9Q==
X-Google-Smtp-Source: ACHHUZ4NJLr6SxPw7r5fyTpbA3bQoGABJyNAApfStsTrsNES7sRVKmt/GUKflSF4XiJTkDC8a07mZQ==
X-Received: by 2002:a7b:ce87:0:b0:3f1:72fb:461a with SMTP id q7-20020a7bce87000000b003f172fb461amr1999928wmj.2.1686056714968;
        Tue, 06 Jun 2023 06:05:14 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:14 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 05/17] virtio/scsi: Move VHOST_SCSI_SET_ENDPOINT to device start
Date:   Tue,  6 Jun 2023 14:04:14 +0100
Message-Id: <20230606130426.978945-6-jean-philippe@linaro.org>
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

The vhost driver expects virtqueues to be operational by the time we
call SET_ENDPOINT. We currently do it too early. Device start, which
happens when the driver writes the DRIVER_OK status, is a good time to
do this.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/scsi.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/virtio/scsi.c b/virtio/scsi.c
index 708fb23a..8249a9cd 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -57,6 +57,13 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct virtio_scsi_config *conf = &sdev->config;
 	u16 endian = vdev->endian;
 
+	if (status & VIRTIO__STATUS_START) {
+		int r = ioctl(sdev->vhost_fd, VHOST_SCSI_SET_ENDPOINT,
+			      &sdev->target);
+		if (r != 0)
+			die("VHOST_SCSI_SET_ENDPOINT failed %d", errno);
+	}
+
 	if (!(status & VIRTIO__STATUS_CONFIG))
 		return;
 
@@ -91,20 +98,12 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 {
 	struct scsi_dev *sdev = dev;
-	int r;
 
 	if (sdev->vhost_fd == 0)
 		return;
 
 	virtio_vhost_set_vring_call(kvm, sdev->vhost_fd, vq, gsi,
 				    &sdev->vqs[vq]);
-
-	if (vq > 0)
-		return;
-
-	r = ioctl(sdev->vhost_fd, VHOST_SCSI_SET_ENDPOINT, &sdev->target);
-	if (r != 0)
-		die("VHOST_SCSI_SET_ENDPOINT failed %d", errno);
 }
 
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
-- 
2.40.1

