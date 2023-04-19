Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 908536E7AB3
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbjDSN2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbjDSN1y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:54 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6B7AF18
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:50 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id a8-20020a05600c348800b003f17ddb04e3so1370864wmq.2
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910869; x=1684502869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jl9r/SrtoqzL08B+Mo9CU9ryDJ9DromwEAR1LvYPmow=;
        b=nGOp9ESTpMcF48UcXqxvhnG4mwz/jSO8A1V4V6+hSFKP8aoAl8AM0EhAJ7b/Ex5Ohc
         jyD6oYNmXnl3IYxYPX1cc83MCnLSTjhxSyI56cyve/vgJM+BuPzoq1cYn0Ii1A/iVSB3
         MjLqA5wMxRG/y+oTReCviguincuz6KKIPCzP8jmvusXcaXq+n7qk3cN8NZV2SUKWgF9p
         xdNB1HRr+BDMYOF5xtGheCDNTFGvURQbMiDbgJScaUOO+LUeRO14ybv+ng8qdnRjaF66
         fZ0osc/fjuIg+Lc0zRgqqdtjKc5AKW9VKjOMIHIuNraPlYFyHIq69FwHv+pjMDQ9vHuv
         YP+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910869; x=1684502869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jl9r/SrtoqzL08B+Mo9CU9ryDJ9DromwEAR1LvYPmow=;
        b=NLgiELvEgEqJ4nO7OZrWYrGT4Pg8Rp/YJ92Lj41NbRR3gO8wyTHxu7Ie1TmI2i9J6g
         t3/0dI0O4rzcNK5LDgbTMjuHc00N6cbY8F/j6so77iE0CTq9kLA/hlynBVrICgBhrihk
         KcNGiC88S2cjXIE6zkwSRxid1Qq8iF2T8zRv/K4l3Iefg90FqbL9Fpww3r3Jmr6reWou
         5rnpf8s+RWfbOvmN+GZSDD6LKgSw1mIEKGKSaDhA6CopgNggQkSepxx6ZXzaAvNI/fbX
         4pBmDfUIYDIdV7/a+fG8IUWzY/6bauoV+7KQBFEKYqo2AqdKV0vtSWd9yKco0aU1YDDn
         3Slg==
X-Gm-Message-State: AAQBX9d0GIVkIAoQzH4qwedYH+5RTiMoKZq/XBmizQGsg6jzN4JZzGfx
        pzmEdU8jbDKaD37uX1Q33ZY9T+B3iqce4lwdL9s=
X-Google-Smtp-Source: AKy350atw9xXHyTP1rNg5en1YnZQh7WRU4SFZ3oUSVwB0iANrEUPcLhhjwg1/THfR+Ac0dqXFH9N8w==
X-Received: by 2002:a7b:cbcb:0:b0:3f1:7675:fb82 with SMTP id n11-20020a7bcbcb000000b003f17675fb82mr6753735wmi.10.1681910869043;
        Wed, 19 Apr 2023 06:27:49 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:48 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 11/16] virtio/net: Fix feature selection
Date:   Wed, 19 Apr 2023 14:21:15 +0100
Message-Id: <20230419132119.124457-12-jean-philippe@linaro.org>
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
index 519dcbb7..56dcfdb0 100644
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
2.40.0

