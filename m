Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FDF56359A
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiGAObK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 10:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiGAOak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 10:30:40 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1742D7125C
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 07:25:51 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 592DB1BF7;
        Fri,  1 Jul 2022 07:25:28 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BB5A13F792;
        Fri,  1 Jul 2022 07:25:26 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com, sashal@kernel.org,
        jean-philippe@linaro.org
Subject: [PATCH kvmtool v2 05/12] virtio/net: Set vhost backend after queue address
Date:   Fri,  1 Jul 2022 15:24:27 +0100
Message-Id: <20220701142434.75170-6-jean-philippe.brucker@arm.com>
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

We currently call VHOST_SET_BACKEND from notify_vq_gsi(), which can't
work with modern virtio because vhost checks that the virtqueue is
accessible when handling VHOST_SET_BACKEND, and the modern driver
initializes the MSIs before setting up the virtqueue. Move
VHOST_SET_BACKEND to init_vq().

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/net.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virtio/net.c b/virtio/net.c
index f8c40d40..dcf9210d 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -601,6 +601,7 @@ static bool is_ctrl_vq(struct net_dev *ndev, u32 vq)
 static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 {
 	struct vhost_vring_state state = { .index = vq };
+	struct vhost_vring_file file = { .index = vq };
 	struct net_dev_queue *net_queue;
 	struct vhost_vring_addr addr;
 	struct net_dev *ndev = dev;
@@ -656,6 +657,11 @@ static int init_vq(struct kvm *kvm, void *dev, u32 vq)
 	if (r < 0)
 		die_perror("VHOST_SET_VRING_ADDR failed");
 
+	file.fd = ndev->tap_fd;
+	r = ioctl(ndev->vhost_fd, VHOST_NET_SET_BACKEND, &file);
+	if (r < 0)
+		die_perror("VHOST_NET_SET_BACKEND failed");
+
 	return 0;
 }
 
@@ -713,11 +719,6 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 	r = ioctl(ndev->vhost_fd, VHOST_SET_VRING_CALL, &file);
 	if (r < 0)
 		die_perror("VHOST_SET_VRING_CALL failed");
-	file.fd = ndev->tap_fd;
-	r = ioctl(ndev->vhost_fd, VHOST_NET_SET_BACKEND, &file);
-	if (r != 0)
-		die("VHOST_NET_SET_BACKEND failed %d", errno);
-
 }
 
 static void notify_vq_eventfd(struct kvm *kvm, void *dev, u32 vq, u32 efd)
-- 
2.36.1

