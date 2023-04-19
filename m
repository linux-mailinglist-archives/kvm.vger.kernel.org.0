Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC026E7AB0
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjDSN14 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233159AbjDSN1w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:52 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820D349C1
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id o9-20020a05600c510900b003f17012276fso1448241wms.4
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910866; x=1684502866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+MhtDXpNm5xTXmxBDZjwHd5dF/CwFonCJebOs/Sjv0=;
        b=ag8TNikmslT8ZwFI28bXZQp0jQ2NEOpkgY1fledFnA3HspOJqQuC4vKaUQPFtaNgyV
         4qReeD36oVcndfZECBFEYE5iQ0T62fncXo5R9OscHdNX1BKP/zRUx+Ni9W2vaJHtqOHl
         JHDq2Evn9NM2B1i48cuyKZ0aeRcDlRB/O5drzibvpmQ3GNAgcVuOi7sJqxtvAxuIbHf8
         DRDbs/MPy9+4/C9xM9MwGd71FCZ67MdCfTehpUusYkgze7IF9voBDe984dgGYekxiVNg
         lzzuvNJJUFjT5MrLY85cB+gU/1LEpneLTrQMt+mzMz10VsAJN2Z1LQgET+mAkwqGM+7g
         nh5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910866; x=1684502866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+MhtDXpNm5xTXmxBDZjwHd5dF/CwFonCJebOs/Sjv0=;
        b=ReHc3QFlk0Yj8XrMwUkpj7PfrHbxRTLkvNYPsKEqjGkCt1JFR/GzTfFwxLJ4YSbKTB
         MbF9S8ldjU8D30bgv1Yuyir7m2dkn6Hpz4341I5WjrWMp96lttLqzaK40dVjQ0QN3foJ
         udfkhX5YgXbBnRP5URJQ32z9zE31tJZaCpzNWELk/Qnl6R7+dl/NX5EzEqWw2jYRo3Sw
         jcLkyLTAlvb0x3OtjBJ74M0EIorhU9mUMtuG1rRS2OaAaDybtPZ3pif2ki9j/H4EGyCm
         3jH5IqQ6DtQ4GJyjBojsqsX74Cws7Q7cvGlxrNKIFLAME1w92b+d3pP7w/u3wJCQaHiF
         z8Mw==
X-Gm-Message-State: AAQBX9eDIH9op5rPmSf+q7cCpIHOAtBKssOKwkixokOZKfscL8NMPte7
        GYK6iMRNfLRRja/bMS2v8pw6f97PWht0umOJ6kE=
X-Google-Smtp-Source: AKy350YOmAzAPp044dVvjFGW2cY2ENgXf3qvzYHzQDkOSeSSjV8wtfZTiZqj2aN7T6bI3I+fiN1Bow==
X-Received: by 2002:a05:600c:2195:b0:3f1:7277:eaa with SMTP id e21-20020a05600c219500b003f172770eaamr8244940wme.31.1681910865802;
        Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 05/16] virtio/scsi: Move VHOST_SCSI_SET_ENDPOINT to device start
Date:   Wed, 19 Apr 2023 14:21:09 +0100
Message-Id: <20230419132119.124457-6-jean-philippe@linaro.org>
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

The vhost driver expects virtqueues to be operational by the time we
call SET_ENDPOINT. We currently do it too early. Device start, which
happens when the driver writes the DRIVER_OK status, is a good time to
do this.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/scsi.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/virtio/scsi.c b/virtio/scsi.c
index 29acf57c..2bc1ec20 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -56,6 +56,13 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct virtio_device *vdev = &sdev->vdev;
 	struct virtio_scsi_config *conf = &sdev->config;
 
+	if (status & VIRTIO__STATUS_START) {
+		int r = ioctl(sdev->vhost_fd, VHOST_SCSI_SET_ENDPOINT,
+			      &sdev->target);
+		if (r != 0)
+			die("VHOST_SCSI_SET_ENDPOINT failed %d", errno);
+	}
+
 	if (!(status & VIRTIO__STATUS_CONFIG))
 		return;
 
@@ -93,20 +100,12 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
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
2.40.0

