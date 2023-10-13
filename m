Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AA37C8E03
	for <lists+kvm@lfdr.de>; Fri, 13 Oct 2023 21:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjJMT6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Oct 2023 15:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjJMT55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Oct 2023 15:57:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8ECC0
        for <kvm@vger.kernel.org>; Fri, 13 Oct 2023 12:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697227030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MsZgdilxXuo6E3ojTuBeVz+DZ8bCj4cd69shv70/6nQ=;
        b=HoARlyZ8bxugylzKqOxcKyG5WBVi5Dzqfbbm+7quaMnRrd4t7rMFJ6G/DE6GhCmQHY1B35
        6S+/7LYvJDO8l3+5JMaHuQVvskQS9e3IfpnmF4vffjrR/mO6R3J1CUj4mmTbe6hCU+8npf
        hWOc4pk1HxF64s9BGBecgdmr+ZCQX+Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-584-hqB_LhTUOWa20Kjdy25Klw-1; Fri, 13 Oct 2023 15:57:06 -0400
X-MC-Unique: hqB_LhTUOWa20Kjdy25Klw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7942588B7AC;
        Fri, 13 Oct 2023 19:57:06 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.10.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EF0940C6CA0;
        Fri, 13 Oct 2023 19:57:06 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, clg@redhat.com
Subject: [PATCH 1/2] vfio/mtty: Fix eventfd leak
Date:   Fri, 13 Oct 2023 13:56:52 -0600
Message-Id: <20231013195653.1222141-2-alex.williamson@redhat.com>
In-Reply-To: <20231013195653.1222141-1-alex.williamson@redhat.com>
References: <20231013195653.1222141-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Found via kmemleak, eventfd context is leaked if not explicitly torn
down by userspace.  Clear pointers to track released contexts.  Also
remove unused irq_fd field in mtty structure, set but never used.

Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 samples/vfio-mdev/mtty.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 5af00387c519..0a2760818e46 100644
--- a/samples/vfio-mdev/mtty.c
+++ b/samples/vfio-mdev/mtty.c
@@ -127,7 +127,6 @@ struct serial_port {
 /* State of each mdev device */
 struct mdev_state {
 	struct vfio_device vdev;
-	int irq_fd;
 	struct eventfd_ctx *intx_evtfd;
 	struct eventfd_ctx *msi_evtfd;
 	int irq_index;
@@ -938,8 +937,10 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 		{
 			if (flags & VFIO_IRQ_SET_DATA_NONE) {
 				pr_info("%s: disable INTx\n", __func__);
-				if (mdev_state->intx_evtfd)
+				if (mdev_state->intx_evtfd) {
 					eventfd_ctx_put(mdev_state->intx_evtfd);
+					mdev_state->intx_evtfd = NULL;
+				}
 				break;
 			}
 
@@ -955,7 +956,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 						break;
 					}
 					mdev_state->intx_evtfd = evt;
-					mdev_state->irq_fd = fd;
 					mdev_state->irq_index = index;
 					break;
 				}
@@ -971,8 +971,10 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
 			if (flags & VFIO_IRQ_SET_DATA_NONE) {
-				if (mdev_state->msi_evtfd)
+				if (mdev_state->msi_evtfd) {
 					eventfd_ctx_put(mdev_state->msi_evtfd);
+					mdev_state->msi_evtfd = NULL;
+				}
 				pr_info("%s: disable MSI\n", __func__);
 				mdev_state->irq_index = VFIO_PCI_INTX_IRQ_INDEX;
 				break;
@@ -993,7 +995,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 					break;
 				}
 				mdev_state->msi_evtfd = evt;
-				mdev_state->irq_fd = fd;
 				mdev_state->irq_index = index;
 			}
 			break;
@@ -1262,6 +1263,22 @@ static unsigned int mtty_get_available(struct mdev_type *mtype)
 	return atomic_read(&mdev_avail_ports) / type->nr_ports;
 }
 
+static void mtty_close(struct vfio_device *vdev)
+{
+	struct mdev_state *mdev_state =
+		container_of(vdev, struct mdev_state, vdev);
+
+	if (mdev_state->intx_evtfd) {
+		eventfd_ctx_put(mdev_state->intx_evtfd);
+		mdev_state->intx_evtfd = NULL;
+	}
+	if (mdev_state->msi_evtfd) {
+		eventfd_ctx_put(mdev_state->msi_evtfd);
+		mdev_state->msi_evtfd = NULL;
+	}
+	mdev_state->irq_index = -1;
+}
+
 static const struct vfio_device_ops mtty_dev_ops = {
 	.name = "vfio-mtty",
 	.init = mtty_init_dev,
@@ -1273,6 +1290,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
 	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
 	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
 	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
+	.close_device	= mtty_close,
 };
 
 static struct mdev_driver mtty_driver = {
-- 
2.40.1

