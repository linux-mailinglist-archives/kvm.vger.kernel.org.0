Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1237B5EE052
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 17:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbiI1P1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 11:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiI1P0k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 11:26:40 -0400
X-Greylist: delayed 566 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 28 Sep 2022 08:26:13 PDT
Received: from smtp1.irit.fr (smtp1.irit.fr [141.115.24.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B79EA5713
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 08:26:12 -0700 (PDT)
From:   dinhngoc.tu@irit.fr
To:     kvm@vger.kernel.org
Cc:     Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
Subject: [PATCH kvmtool] virtio-net: Fix vq->use_event_idx flag check
Date:   Wed, 28 Sep 2022 17:16:15 +0200
Message-Id: <20220928151615.1792-1-dinhngoc.tu@irit.fr>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tu Dinh Ngoc <dinhngoc.tu@irit.fr>

VIRTIO_RING_F_EVENT_IDX is a bit position value, but
virtio_init_device_vq populates vq->use_event_idx by ANDing this value
directly to vdev->features.

Fix the check for this flag in virtio_init_device_vq.
---
 virtio/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/core.c b/virtio/core.c
index f432421..32e6a7a 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -165,7 +165,7 @@ void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
 	struct vring_addr *addr = &vq->vring_addr;
 
 	vq->endian		= vdev->endian;
-	vq->use_event_idx	= (vdev->features & VIRTIO_RING_F_EVENT_IDX);
+	vq->use_event_idx	= (vdev->features & (1 << VIRTIO_RING_F_EVENT_IDX));
 	vq->enabled		= true;
 
 	if (addr->legacy) {
-- 
2.25.1

