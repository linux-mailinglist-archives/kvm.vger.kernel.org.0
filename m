Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3147CB6B1
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbjJPWsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 18:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233661AbjJPWsg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 18:48:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832DC83
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 15:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697496463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tXJ14VVA08YHYM8iib0tGHyXN3Dk+BThLs8CmtNlHyQ=;
        b=A0/mxoF+XDDhsuCS+bARePROYCGXrluJq9wAaslwEIvYhHplkkDxjjDG/wO9r8ljHmj4/C
        Y/IqwN4pMfFzMdxXiFNCFpzf2UPhXn/iV3d6FIMHqvxeROUBFwP3javPHjVjGvOOk4aSD0
        +yqPYxpuZHJZbYeRrBZjJql3c3zN8Bs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-TghPh6eYNAWmletDkxfk9w-1; Mon, 16 Oct 2023 18:47:42 -0400
X-MC-Unique: TghPh6eYNAWmletDkxfk9w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A37F185A797;
        Mon, 16 Oct 2023 22:47:41 +0000 (UTC)
Received: from omen.home.shazbot.org (unknown [10.22.10.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 23B7125C9;
        Mon, 16 Oct 2023 22:47:41 +0000 (UTC)
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, clg@redhat.com
Subject: [PATCH v2 1/2] vfio/mtty: Overhaul mtty interrupt handling
Date:   Mon, 16 Oct 2023 16:47:35 -0600
Message-Id: <20231016224736.2575718-2-alex.williamson@redhat.com>
In-Reply-To: <20231016224736.2575718-1-alex.williamson@redhat.com>
References: <20231016224736.2575718-1-alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The mtty driver does not currently conform to the vfio SET_IRQS uAPI.
For example, it claims to support mask and unmask of INTx, but actually
does nothing.  It claims to support AUTOMASK for INTx, but doesn't.  It
fails to teardown eventfds under the full semantics specified by the
SET_IRQS ioctl.  It also fails to teardown eventfds when the device is
closed, leading to memory leaks.  It claims to support the request IRQ,
but doesn't.

Fix all these.

A side effect of this is that QEMU will now report a warning:

vfio <uuid>: Failed to set up UNMASK eventfd signaling for interrupt \
INTX-0: VFIO_DEVICE_SET_IRQS failure: Inappropriate ioctl for device

The fact is that the unmask eventfd was never supported but quietly
failed.  mtty never honored the AUTOMASK behavior, therefore there
was nothing to unmask.  QEMU is verbose about the failure, but
properly falls back to userspace unmasking.

Fixes: 9d1a546c53b4 ("docs: Sample driver to demonstrate how to use Mediated device framework.")
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 samples/vfio-mdev/mtty.c | 239 +++++++++++++++++++++++++++------------
 1 file changed, 166 insertions(+), 73 deletions(-)

diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
index 5af00387c519..245db52bedf2 100644
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
@@ -141,6 +140,7 @@ struct mdev_state {
 	struct mutex rxtx_lock;
 	struct vfio_device_info dev_info;
 	int nr_ports;
+	u8 intx_mask:1;
 };
 
 static struct mtty_type {
@@ -166,10 +166,6 @@ static const struct file_operations vd_fops = {
 
 static const struct vfio_device_ops mtty_dev_ops;
 
-/* function prototypes */
-
-static int mtty_trigger_interrupt(struct mdev_state *mdev_state);
-
 /* Helper functions */
 
 static void dump_buffer(u8 *buf, uint32_t count)
@@ -186,6 +182,36 @@ static void dump_buffer(u8 *buf, uint32_t count)
 #endif
 }
 
+static bool is_intx(struct mdev_state *mdev_state)
+{
+	return mdev_state->irq_index == VFIO_PCI_INTX_IRQ_INDEX;
+}
+
+static bool is_msi(struct mdev_state *mdev_state)
+{
+	return mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX;
+}
+
+static bool is_noirq(struct mdev_state *mdev_state)
+{
+	return !is_intx(mdev_state) && !is_msi(mdev_state);
+}
+
+static void mtty_trigger_interrupt(struct mdev_state *mdev_state)
+{
+	lockdep_assert_held(&mdev_state->ops_lock);
+
+	if (is_msi(mdev_state)) {
+		if (mdev_state->msi_evtfd)
+			eventfd_signal(mdev_state->msi_evtfd, 1);
+	} else if (is_intx(mdev_state)) {
+		if (mdev_state->intx_evtfd && !mdev_state->intx_mask) {
+			eventfd_signal(mdev_state->intx_evtfd, 1);
+			mdev_state->intx_mask = true;
+		}
+	}
+}
+
 static void mtty_create_config_space(struct mdev_state *mdev_state)
 {
 	/* PCI dev ID */
@@ -921,6 +947,25 @@ static ssize_t mtty_write(struct vfio_device *vdev, const char __user *buf,
 	return -EFAULT;
 }
 
+static void mtty_disable_intx(struct mdev_state *mdev_state)
+{
+	if (mdev_state->intx_evtfd) {
+		eventfd_ctx_put(mdev_state->intx_evtfd);
+		mdev_state->intx_evtfd = NULL;
+		mdev_state->intx_mask = false;
+		mdev_state->irq_index = -1;
+	}
+}
+
+static void mtty_disable_msi(struct mdev_state *mdev_state)
+{
+	if (mdev_state->msi_evtfd) {
+		eventfd_ctx_put(mdev_state->msi_evtfd);
+		mdev_state->msi_evtfd = NULL;
+		mdev_state->irq_index = -1;
+	}
+}
+
 static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 			 unsigned int index, unsigned int start,
 			 unsigned int count, void *data)
@@ -932,59 +977,113 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 	case VFIO_PCI_INTX_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
+			if (!is_intx(mdev_state) || start != 0 || count != 1) {
+				ret = -EINVAL;
+				break;
+			}
+
+			if (flags & VFIO_IRQ_SET_DATA_NONE) {
+				mdev_state->intx_mask = true;
+			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+				uint8_t mask = *(uint8_t *)data;
+
+				if (mask)
+					mdev_state->intx_mask = true;
+			} else if (flags &  VFIO_IRQ_SET_DATA_EVENTFD) {
+				ret = -ENOTTY; /* No support for mask fd */
+			}
+			break;
 		case VFIO_IRQ_SET_ACTION_UNMASK:
+			if (!is_intx(mdev_state) || start != 0 || count != 1) {
+				ret = -EINVAL;
+				break;
+			}
+
+			if (flags & VFIO_IRQ_SET_DATA_NONE) {
+				mdev_state->intx_mask = false;
+			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+				uint8_t mask = *(uint8_t *)data;
+
+				if (mask)
+					mdev_state->intx_mask = false;
+			} else if (flags &  VFIO_IRQ_SET_DATA_EVENTFD) {
+				ret = -ENOTTY; /* No support for unmask fd */
+			}
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-		{
-			if (flags & VFIO_IRQ_SET_DATA_NONE) {
-				pr_info("%s: disable INTx\n", __func__);
-				if (mdev_state->intx_evtfd)
-					eventfd_ctx_put(mdev_state->intx_evtfd);
+			if (is_intx(mdev_state) && !count &&
+			    (flags & VFIO_IRQ_SET_DATA_NONE)) {
+				mtty_disable_intx(mdev_state);
+				break;
+			}
+
+			if (!(is_intx(mdev_state) || is_noirq(mdev_state)) ||
+			    start != 0 || count != 1) {
+				ret = -EINVAL;
 				break;
 			}
 
 			if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 				int fd = *(int *)data;
+				struct eventfd_ctx *evt;
+
+				mtty_disable_intx(mdev_state);
+
+				if (fd < 0)
+					break;
 
-				if (fd > 0) {
-					struct eventfd_ctx *evt;
-
-					evt = eventfd_ctx_fdget(fd);
-					if (IS_ERR(evt)) {
-						ret = PTR_ERR(evt);
-						break;
-					}
-					mdev_state->intx_evtfd = evt;
-					mdev_state->irq_fd = fd;
-					mdev_state->irq_index = index;
+				evt = eventfd_ctx_fdget(fd);
+				if (IS_ERR(evt)) {
+					ret = PTR_ERR(evt);
 					break;
 				}
+				mdev_state->intx_evtfd = evt;
+				mdev_state->irq_index = index;
+				break;
+			}
+
+			if (!is_intx(mdev_state)) {
+				ret = -EINVAL;
+				break;
+			}
+
+			if (flags & VFIO_IRQ_SET_DATA_NONE) {
+				mtty_trigger_interrupt(mdev_state);
+			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+				uint8_t trigger = *(uint8_t *)data;
+
+				if (trigger)
+					mtty_trigger_interrupt(mdev_state);
 			}
 			break;
 		}
-		}
 		break;
 	case VFIO_PCI_MSI_IRQ_INDEX:
 		switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
 		case VFIO_IRQ_SET_ACTION_MASK:
 		case VFIO_IRQ_SET_ACTION_UNMASK:
+			ret = -ENOTTY;
 			break;
 		case VFIO_IRQ_SET_ACTION_TRIGGER:
-			if (flags & VFIO_IRQ_SET_DATA_NONE) {
-				if (mdev_state->msi_evtfd)
-					eventfd_ctx_put(mdev_state->msi_evtfd);
-				pr_info("%s: disable MSI\n", __func__);
-				mdev_state->irq_index = VFIO_PCI_INTX_IRQ_INDEX;
+			if (is_msi(mdev_state) && !count &&
+			    (flags & VFIO_IRQ_SET_DATA_NONE)) {
+				mtty_disable_msi(mdev_state);
 				break;
 			}
+
+			if (!(is_msi(mdev_state) || is_noirq(mdev_state)) ||
+			    start != 0 || count != 1) {
+				ret = -EINVAL;
+				break;
+			}
+
 			if (flags & VFIO_IRQ_SET_DATA_EVENTFD) {
 				int fd = *(int *)data;
 				struct eventfd_ctx *evt;
 
-				if (fd <= 0)
-					break;
+				mtty_disable_msi(mdev_state);
 
-				if (mdev_state->msi_evtfd)
+				if (fd < 0)
 					break;
 
 				evt = eventfd_ctx_fdget(fd);
@@ -993,20 +1092,37 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 					break;
 				}
 				mdev_state->msi_evtfd = evt;
-				mdev_state->irq_fd = fd;
 				mdev_state->irq_index = index;
+				break;
+			}
+
+			if (!is_msi(mdev_state)) {
+				ret = -EINVAL;
+				break;
+			}
+
+			if (flags & VFIO_IRQ_SET_DATA_NONE) {
+				mtty_trigger_interrupt(mdev_state);
+			} else if (flags & VFIO_IRQ_SET_DATA_BOOL) {
+				uint8_t trigger = *(uint8_t *)data;
+
+				if (trigger)
+					mtty_trigger_interrupt(mdev_state);
 			}
 			break;
-	}
-	break;
+		}
+		break;
 	case VFIO_PCI_MSIX_IRQ_INDEX:
-		pr_info("%s: MSIX_IRQ\n", __func__);
+		dev_dbg(mdev_state->vdev.dev, "%s: MSIX_IRQ\n", __func__);
+		ret = -ENOTTY;
 		break;
 	case VFIO_PCI_ERR_IRQ_INDEX:
-		pr_info("%s: ERR_IRQ\n", __func__);
+		dev_dbg(mdev_state->vdev.dev, "%s: ERR_IRQ\n", __func__);
+		ret = -ENOTTY;
 		break;
 	case VFIO_PCI_REQ_IRQ_INDEX:
-		pr_info("%s: REQ_IRQ\n", __func__);
+		dev_dbg(mdev_state->vdev.dev, "%s: REQ_IRQ\n", __func__);
+		ret = -ENOTTY;
 		break;
 	}
 
@@ -1014,33 +1130,6 @@ static int mtty_set_irqs(struct mdev_state *mdev_state, uint32_t flags,
 	return ret;
 }
 
-static int mtty_trigger_interrupt(struct mdev_state *mdev_state)
-{
-	int ret = -1;
-
-	if ((mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX) &&
-	    (!mdev_state->msi_evtfd))
-		return -EINVAL;
-	else if ((mdev_state->irq_index == VFIO_PCI_INTX_IRQ_INDEX) &&
-		 (!mdev_state->intx_evtfd)) {
-		pr_info("%s: Intr eventfd not found\n", __func__);
-		return -EINVAL;
-	}
-
-	if (mdev_state->irq_index == VFIO_PCI_MSI_IRQ_INDEX)
-		ret = eventfd_signal(mdev_state->msi_evtfd, 1);
-	else
-		ret = eventfd_signal(mdev_state->intx_evtfd, 1);
-
-#if defined(DEBUG_INTR)
-	pr_info("Intx triggered\n");
-#endif
-	if (ret != 1)
-		pr_err("%s: eventfd signal failed (%d)\n", __func__, ret);
-
-	return ret;
-}
-
 static int mtty_get_region_info(struct mdev_state *mdev_state,
 			 struct vfio_region_info *region_info,
 			 u16 *cap_type_id, void **cap_type)
@@ -1084,22 +1173,16 @@ static int mtty_get_region_info(struct mdev_state *mdev_state,
 
 static int mtty_get_irq_info(struct vfio_irq_info *irq_info)
 {
-	switch (irq_info->index) {
-	case VFIO_PCI_INTX_IRQ_INDEX:
-	case VFIO_PCI_MSI_IRQ_INDEX:
-	case VFIO_PCI_REQ_IRQ_INDEX:
-		break;
-
-	default:
+	if (irq_info->index != VFIO_PCI_INTX_IRQ_INDEX &&
+	    irq_info->index != VFIO_PCI_MSI_IRQ_INDEX)
 		return -EINVAL;
-	}
 
 	irq_info->flags = VFIO_IRQ_INFO_EVENTFD;
 	irq_info->count = 1;
 
 	if (irq_info->index == VFIO_PCI_INTX_IRQ_INDEX)
-		irq_info->flags |= (VFIO_IRQ_INFO_MASKABLE |
-				VFIO_IRQ_INFO_AUTOMASKED);
+		irq_info->flags |= VFIO_IRQ_INFO_MASKABLE |
+				   VFIO_IRQ_INFO_AUTOMASKED;
 	else
 		irq_info->flags |= VFIO_IRQ_INFO_NORESIZE;
 
@@ -1262,6 +1345,15 @@ static unsigned int mtty_get_available(struct mdev_type *mtype)
 	return atomic_read(&mdev_avail_ports) / type->nr_ports;
 }
 
+static void mtty_close(struct vfio_device *vdev)
+{
+	struct mdev_state *mdev_state =
+				container_of(vdev, struct mdev_state, vdev);
+
+	mtty_disable_intx(mdev_state);
+	mtty_disable_msi(mdev_state);
+}
+
 static const struct vfio_device_ops mtty_dev_ops = {
 	.name = "vfio-mtty",
 	.init = mtty_init_dev,
@@ -1273,6 +1365,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
 	.unbind_iommufd	= vfio_iommufd_emulated_unbind,
 	.attach_ioas	= vfio_iommufd_emulated_attach_ioas,
 	.detach_ioas	= vfio_iommufd_emulated_detach_ioas,
+	.close_device	= mtty_close,
 };
 
 static struct mdev_driver mtty_driver = {
-- 
2.40.1

