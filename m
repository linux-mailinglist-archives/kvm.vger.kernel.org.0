Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3CB732EB5
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 12:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345330AbjFPKeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 06:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345243AbjFPKdx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 06:33:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122EE55A4;
        Fri, 16 Jun 2023 03:28:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42A8F6367E;
        Fri, 16 Jun 2023 10:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9531EC433C9;
        Fri, 16 Jun 2023 10:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686911300;
        bh=9Ic3zvxvs32HgoIukQvQqhLJ77dhfcSj+VWERrDzR4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3++e//z28HIvY5u/a2wRONuNAmBS5dzoSl5ktdT268KiZwKDuzTCX0I1dKxzPLBw
         3AKGwVvimmRJvzK+6LmWOFz7fCvP30tkgwwrY5/SbO63bPvvUbifWo2Ud90J8QEX/z
         ZDrF5ggnYYQMFj413i8Y5ZfL/VFfZOccOldmiTWt2fGSFjeOuDp8IAYgLJnmxuKP1l
         7b9GwS/ghWSpaiXDSVmtFEc/Plw06MjTuFnQpDwy90UhzYZ1wbSM4INA6uOF22c+o/
         t8ULuDBtzbgqkx5d9b6pZhcP+nqTYJnFSu9H6+TZAU6EkephN1nDCAtF+LWgMg+wCb
         y1zQwbDeGnItA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shannon Nelson <shannon.nelson@amd.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 14/14] vhost_vdpa: tell vqs about the negotiated
Date:   Fri, 16 Jun 2023 06:27:51 -0400
Message-Id: <20230616102753.673975-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230616102753.673975-1-sashal@kernel.org>
References: <20230616102753.673975-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.10.184
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 04578aa87e4da..d3a7a5a2f207b 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -281,7 +281,10 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
 {
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
+	struct vhost_dev *d = &v->vdev;
+	u64 actual_features;
 	u64 features;
+	int i;
 
 	/*
 	 * It's not allowed to change the features after they have
@@ -296,6 +299,16 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
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

