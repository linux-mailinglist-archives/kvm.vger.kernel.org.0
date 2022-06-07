Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84686540440
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 19:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbiFGRDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jun 2022 13:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345339AbiFGRDT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jun 2022 13:03:19 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3BF5FF586
        for <kvm@vger.kernel.org>; Tue,  7 Jun 2022 10:03:17 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 95412153B;
        Tue,  7 Jun 2022 10:03:17 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2CC9C3F66F;
        Tue,  7 Jun 2022 10:03:16 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sasha.levin@oracle.com, jean-philippe@linaro.org
Subject: [PATCH kvmtool 03/24] virtio/vsock: Remove redundant state tracking
Date:   Tue,  7 Jun 2022 18:02:18 +0100
Message-Id: <20220607170239.120084-4-jean-philippe.brucker@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
References: <20220607170239.120084-1-jean-philippe.brucker@arm.com>
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

The core already tells us whether a device is being started or stopped.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 virtio/vsock.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virtio/vsock.c b/virtio/vsock.c
index 64b4e95a..780169b1 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -31,7 +31,6 @@ struct vsock_dev {
 	struct virtio_device		vdev;
 	struct list_head		list;
 	struct kvm			*kvm;
-	bool				started;
 };
 
 static u8 *get_config(struct kvm *kvm, void *dev)
@@ -140,15 +139,16 @@ static void notify_status(struct kvm *kvm, void *dev, u32 status)
 	struct vsock_dev *vdev = dev;
 	int r, start;
 
-	start = !!(status & VIRTIO_CONFIG_S_DRIVER_OK);
-	if (vdev->started == start)
+	if (status & VIRTIO__STATUS_START)
+		start = 1;
+	else if (status & VIRTIO__STATUS_STOP)
+		start = 0;
+	else
 		return;
 
 	r = ioctl(vdev->vhost_fd, VHOST_VSOCK_SET_RUNNING, &start);
 	if (r != 0)
 		die("VHOST_VSOCK_SET_RUNNING failed %d", errno);
-
-	vdev->started = start;
 }
 
 static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
-- 
2.36.1

