Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46B45EF51E
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 14:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiI2MTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 08:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiI2MT0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 08:19:26 -0400
Received: from smtp1.irit.fr (smtp1.irit.fr [141.115.24.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368AF147CEE
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 05:19:19 -0700 (PDT)
From:   Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
To:     kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2] virtio-net: Fix vq->use_event_idx flag check
Date:   Thu, 29 Sep 2022 14:18:58 +0200
Message-Id: <20220929121858.156-1-dinhngoc.tu@irit.fr>
In-Reply-To: <20220929122136.38f74d7f@donnerap.cambridge.arm.com>
References: <20220929122136.38f74d7f@donnerap.cambridge.arm.com>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VIRTIO_RING_F_EVENT_IDX is a bit position value, but
virtio_init_device_vq populates vq->use_event_idx by ANDing this value
directly to vdev->features.

Fix the check for this flag in virtio_init_device_vq.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Tu Dinh Ngoc <dinhngoc.tu@irit.fr>
---
 virtio/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virtio/core.c b/virtio/core.c
index f432421..ea0e5b6 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -165,7 +165,7 @@ void virtio_init_device_vq(struct kvm *kvm, struct virtio_device *vdev,
 	struct vring_addr *addr = &vq->vring_addr;
 
 	vq->endian		= vdev->endian;
-	vq->use_event_idx	= (vdev->features & VIRTIO_RING_F_EVENT_IDX);
+	vq->use_event_idx	= (vdev->features & (1UL << VIRTIO_RING_F_EVENT_IDX));
 	vq->enabled		= true;
 
 	if (addr->legacy) {
-- 
2.25.1

