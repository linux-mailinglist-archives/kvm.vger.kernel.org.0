Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE187243A5
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbjFFNFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbjFFNFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:21 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F83E12F
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:20 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f735bfcbbbso24389335e9.2
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056719; x=1688648719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZXTqbmcrb3RPdtDiUPuxGbbBbDZFyzE4xKU+0q08Rc=;
        b=UemHrYou4X8b5dcNO5RoPfJvHltDScdRjge5X6YP9HDCaoUrpzC/YGcW5e4Zp3sl+M
         ihaZ0n3QkObuT70zQvbLn5s8f4/fijR3M0Rqf7hoMaZB5XFFolmysOxuUiEnr62qnOhw
         Hx9/6ns39fT3rrGdkFX9GPWwk6+TzN46jlRIaGhscfLuex5aMlYtQykHOK8oWjNbi6xS
         +ffPR2/CTfvH4OXwoqqE943d0HyIjnHKimLSYS5HxFA/JC8WkHThjZWup+oW+F1LmoNo
         YO10rAoQTy/6BBobjQyTv/w/6cKYQEdCpLYRJgv8bd+U/QrCub2P4TBrBqdiQ1t/XoA4
         CDxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056719; x=1688648719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZXTqbmcrb3RPdtDiUPuxGbbBbDZFyzE4xKU+0q08Rc=;
        b=iZEHKxY0oWNjiCNb1qnZR3F/+OYW/XEd0aLiiYhUsZ2nuZen08cY5asRuR+AujrCd/
         MxHN9A1h+lO0GEhN4X/MRkIG6CNSNujV5+OYiUlYIyw4RswbUMZBpINySX7zSRR5Lfye
         PYLx8Yu8vrUQQ8twV8V3UoDlntB1J4h0dbmXMSNWN6Q5a3wXT54ew+i0iDfNgiNy5QeH
         9wQ1DfcQMGVL+tkfo2kUVKnYJbeF5O5/AGdVodCII3aglQlvzq6N33zQRrRH7r2sKXY+
         5vHpUj1CalH4R6WX3wQCPdf3Az9HZb7PznxIFm985qlyD+qoRK12nlnGo14CmN5T2+28
         ME8g==
X-Gm-Message-State: AC+VfDybMTxZyrz/7yS5sIMGi1GWj5s5jYvlEe6BJjYuLPTN6CL1ptD6
        LYfOoD4eXTP8w1ybWq+1ywZKoIGb4RdcRALdq1saJQ==
X-Google-Smtp-Source: ACHHUZ4QelMp3kWl9CI8l2y8c77Tmi0A4PApbzGf4lrW3T46cLLI0k5zZSOYa0MW9NLeWas89oTkxA==
X-Received: by 2002:a05:600c:cf:b0:3f7:33cd:59b3 with SMTP id u15-20020a05600c00cf00b003f733cd59b3mr2158014wmm.22.1686056718899;
        Tue, 06 Jun 2023 06:05:18 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:18 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 11/17] virtio/net: Fix feature selection
Date:   Tue,  6 Jun 2023 14:04:20 +0100
Message-Id: <20230606130426.978945-12-jean-philippe@linaro.org>
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

Move VHOST_GET_FEATURES to get_host_features() so the guest is aware of
what will actually be supported. This removes the invalid guess about
VIRTIO_NET_F_MRG_RXBUF (if vhost didn't support it, we shouldn't let the
guest negotiate it).

Note the masking of VHOST_NET_F_VIRTIO_NET_HDR when handing features to
vhost. Unfortunately the vhost-net driver interprets VIRTIO_F_ANY_LAYOUT
as VHOST_NET_F_VIRTIO_NET_HDR, which is specific to vhost and forces
vhost-net to supply the vnet header. Since this is done by tap, we don't
want to set the bit.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 virtio/net.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/virtio/net.c b/virtio/net.c
index 3e1aedf7..c4d20f22 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -505,21 +505,23 @@ static u64 get_host_features(struct kvm *kvm, void *dev)
 		features |= (1UL << VIRTIO_NET_F_HOST_UFO
 				| 1UL << VIRTIO_NET_F_GUEST_UFO);
 
+	if (ndev->vhost_fd) {
+		u64 vhost_features;
+
+		if (ioctl(ndev->vhost_fd, VHOST_GET_FEATURES, &vhost_features) != 0)
+			die_perror("VHOST_GET_FEATURES failed");
+
+		features &= vhost_features;
+	}
+
 	return features;
 }
 
 static int virtio_net__vhost_set_features(struct net_dev *ndev)
 {
-	u64 features = 1UL << VIRTIO_RING_F_EVENT_IDX;
-	u64 vhost_features;
-
-	if (ioctl(ndev->vhost_fd, VHOST_GET_FEATURES, &vhost_features) != 0)
-		die_perror("VHOST_GET_FEATURES failed");
-
-	/* make sure both side support mergable rx buffers */
-	if (vhost_features & 1UL << VIRTIO_NET_F_MRG_RXBUF &&
-			has_virtio_feature(ndev, VIRTIO_NET_F_MRG_RXBUF))
-		features |= 1UL << VIRTIO_NET_F_MRG_RXBUF;
+	/* VHOST_NET_F_VIRTIO_NET_HDR clashes with VIRTIO_F_ANY_LAYOUT! */
+	u64 features = ndev->vdev.features &
+			~(1UL << VHOST_NET_F_VIRTIO_NET_HDR);
 
 	return ioctl(ndev->vhost_fd, VHOST_SET_FEATURES, &features);
 }
-- 
2.40.1

