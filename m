Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2E9C732E72
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 12:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344986AbjFPKck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 06:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344979AbjFPKbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 06:31:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AB95258;
        Fri, 16 Jun 2023 03:27:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 300E2636CF;
        Fri, 16 Jun 2023 10:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E07EC433CA;
        Fri, 16 Jun 2023 10:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686911269;
        bh=dn5j7Vy0jR4DMgOQyC3ikE20OKqZTT31zJIwWxDUmwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJoHwIKvL3mzgti39/RXbbstgFIYYnawMpVWcLu5Ky6yfUEUoNmaS12NI/HWhK8la
         KTlcZ3rQD0NdX+W/T5f1/kXumGcXh19HfFNte38LRz1ayLK32Sv8TfC/ZjoGHuVcvd
         HQmE94W6lxKIG7Tpyc8vRELJzNn045RRkwY4mPQMFWvIKSL5UeDn1STAEIZN4fahY6
         +mriVQ4rEo6AuS+k6n1uWt/I3lhEmjfvBdXBuYLZ2zOYIECupGieHlLpNb6LjN8lE8
         sRnnFt9le4kSDu8Bdy7XTf9wpn23hVN5Znf5yFzDrbA6HwJRP46vuYwuRq8Q0cYAHI
         b/12vRATueGGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 15/16] vhost_vdpa: tell vqs about the negotiated
Date:   Fri, 16 Jun 2023 06:27:18 -0400
Message-Id: <20230616102721.673775-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616102721.673775-1-sashal@kernel.org>
References: <20230616102721.673775-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.117
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 376daf317753ccb6b1ecbdece66018f7f6313a7f ]

As is done in the net, iscsi, and vsock vhost support, let the vdpa vqs
know about the features that have been negotiated.  This allows vhost
to more safely make decisions based on the features, such as when using
PACKED vs split queues.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20230424225031.18947-2-shannon.nelson@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 299a995326185..1f9670e6ecec2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -278,7 +278,10 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_dev *d = &v->vdev;
+	u64 actual_features;
 	u64 features;
+	int i;
 
 	/*
 	 * It's not allowed to change the features after they have
@@ -293,6 +296,16 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 	if (vdpa_set_features(vdpa, features))
 		return -EINVAL;
 
+	/* let the vqs know what has been configured */
+	actual_features = ops->get_driver_features(vdpa);
+	for (i = 0; i < d->nvqs; ++i) {
+		struct vhost_virtqueue *vq = d->vqs[i];
+
+		mutex_lock(&vq->mutex);
+		vq->acked_features = actual_features;
+		mutex_unlock(&vq->mutex);
+	}
+
 	return 0;
 }
 
-- 
2.39.2

