Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA30E5635A0
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbiGAObI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbiGAOak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 743C07125D
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 019D31C00;
        Fri,  1 Jul 2022 07:25:30 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5C5713F792;
        Fri,  1 Jul 2022 07:25:28 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 06/12] virtio: Prepare for more feature bits
Date:   Fri,  1 Jul 2022 15:24:28 +0100
Message-Id: <20220701142434.75170-7-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
References: <20220701142434.75170-1-jean-philippe.brucker@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Modern virtio uses more than 32 bits of features. Bump the feature
bitfield size to 64 bits.

virtio_set_guest_features() changes in behavior because it will now be
called multiple times, each time the guest writes to a 32-bit slice of
the features.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 include/kvm/virtio.h | 6 +++---
 virtio/9p.c          | 2 +-
 virtio/balloon.c     | 2 +-
 virtio/blk.c         | 2 +-
 virtio/console.c     | 2 +-
 virtio/core.c        | 4 ++--
 virtio/net.c         | 4 ++--
 virtio/rng.c         | 2 +-
 virtio/scsi.c        | 2 +-
 virtio/vsock.c       | 2 +-
 10 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 8c05bae2..57da2047 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -203,14 +203,14 @@ struct virtio_device {
 	void			*virtio;
 	struct virtio_ops	*ops;
 	u16			endian;
-	u32			features;
+	u64			features;
 	u32			status;
 };
 
 struct virtio_ops {
 	u8 *(*get_config)(struct kvm *kvm, void *dev);
 	size_t (*get_config_size)(struct kvm *kvm, void *dev);
-	u32 (*get_host_features)(struct kvm *kvm, void *dev);
+	u64 (*get_host_features)(struct kvm *kvm, void *dev);
 	unsigned int (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq);
 	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
@@ -242,7 +242,7 @@ bool virtio_access_config(struct kvm *kvm, struct virtio_device *vdev, void *dev
 			  unsigned long offset, void *data, size_t size,
 			  bool is_write);
 void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
-			       void *dev, u32 features);
+			       void *dev, u64 features);
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
 
diff --git a/virtio/9p.c b/virtio/9p.c
index cb3a42a4..19b66df8 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1382,7 +1382,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return p9dev->config_size;
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_9P_MOUNT_TAG;
 }
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 6f10219e..3a734322 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -200,7 +200,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return sizeof(bdev->config);
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_BALLOON_F_STATS_VQ;
 }
diff --git a/virtio/blk.c b/virtio/blk.c
index 54035af4..2d06391f 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -169,7 +169,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return sizeof(bdev->blk_config);
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
 	struct blk_dev *bdev = dev;
 
diff --git a/virtio/console.c b/virtio/console.c
index c42c8b9f..d29319c8 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -120,7 +120,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return sizeof(cdev->config);
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_F_ANY_LAYOUT;
 }
diff --git a/virtio/core.c b/virtio/core.c
index 09abbf40..6688cb44 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -245,11 +245,11 @@ bool virtio_queue__should_signal(struct virt_queue *vq)
 }
 
 void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
-			       void *dev, u32 features)
+			       void *dev, u64 features)
 {
 	/* TODO: fail negotiation if features & ~host_features */
 
-	vdev->features = features;
+	vdev->features |= features;
 }
 
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
diff --git a/virtio/net.c b/virtio/net.c
index dcf9210d..c4e302bd 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -482,9 +482,9 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return sizeof(ndev->config);
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
-	u32 features;
+	u64 features;
 	struct net_dev *ndev = dev;
 
 	features = 1UL << VIRTIO_NET_F_MAC
diff --git a/virtio/rng.c b/virtio/rng.c
index 8fda9dd6..f9d607f6 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -52,7 +52,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return 0;
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
 	/* Unused */
 	return 0;
diff --git a/virtio/scsi.c b/virtio/scsi.c
index d69183b7..0286b86f 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -44,7 +44,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return sizeof(sdev->config);
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
 	return	1UL << VIRTIO_RING_F_EVENT_IDX |
 		1UL << VIRTIO_RING_F_INDIRECT_DESC;
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 02cee683..18b45f3b 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -49,7 +49,7 @@ static size_t get_config_size(struct kvm *kvm, void *dev)
 	return sizeof(vdev->config);
 }
 
-static u32 get_host_features(struct kvm *kvm, void *dev)
+static u64 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1UL << VIRTIO_RING_F_EVENT_IDX
 		| 1UL << VIRTIO_RING_F_INDIRECT_DESC;
-- 
2.36.1

