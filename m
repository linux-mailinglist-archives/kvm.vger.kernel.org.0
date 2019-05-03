Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96DB513303
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfECRQB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:16:01 -0400
Received: from foss.arm.com ([217.140.101.70]:37652 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfECRP7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:15:59 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5FF0715AD;
        Fri,  3 May 2019 10:15:59 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A9BF3F557;
        Fri,  3 May 2019 10:15:58 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 4/4] virtio/blk: Avoid taking pointer to packed struct
Date:   Fri,  3 May 2019 18:15:44 +0100
Message-Id: <20190503171544.260901-5-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503171544.260901-1-andre.przywara@arm.com>
References: <20190503171544.260901-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clang and GCC9 refuse to compile virtio/blk.c with the following message:
virtio/blk.c:161:37: error: taking address of packed member 'geometry' of class
      or structure 'virtio_blk_config' may result in an unaligned pointer value
      [-Werror,-Waddress-of-packed-member]
        struct virtio_blk_geometry *geo = &conf->geometry;

Since struct virtio_blk_geometry is in a kernel header, we can't do much
about the packed attribute, but as Peter pointed out, the solution is
rather simple: just get rid of the convenience variable and use the
original struct member directly.

Suggested-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virtio/blk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virtio/blk.c b/virtio/blk.c
index 50db6f5f..f267be15 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -161,7 +161,6 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 {
 	struct blk_dev *bdev = dev;
 	struct virtio_blk_config *conf = &bdev->blk_config;
-	struct virtio_blk_geometry *geo = &conf->geometry;
 
 	bdev->features = features;
 
@@ -170,7 +169,8 @@ static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
 	conf->seg_max = virtio_host_to_guest_u32(&bdev->vdev, conf->seg_max);
 
 	/* Geometry */
-	geo->cylinders = virtio_host_to_guest_u16(&bdev->vdev, geo->cylinders);
+	conf->geometry.cylinders = virtio_host_to_guest_u16(&bdev->vdev,
+						conf->geometry.cylinders);
 
 	conf->blk_size = virtio_host_to_guest_u32(&bdev->vdev, conf->blk_size);
 	conf->min_io_size = virtio_host_to_guest_u16(&bdev->vdev, conf->min_io_size);
-- 
2.17.1

