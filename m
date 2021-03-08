Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA9F3319B2
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 22:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhCHVu1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 16:50:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41383 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232035AbhCHVuA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Mar 2021 16:50:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615240199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RAa72pVdIFvN9TtnoqB8dYU4KzANd01qCZAe6yxIHp0=;
        b=Qu6O6si2neB8hMXCgv2M1Xd1WtPFMtaUeNqWfskzV2hjEM7atU89Uh/xdXT6DFjpikUZBM
        guFMQi93qB0DC5v76vjSP77yzm1ZAhIN6wSjYez5JJTbIf0ZlsbNzOSTvUhFeL81ryWRzu
        yFCP/pJ+5KhMBAjClu1IxchPi3iRAhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-2fEasTi1OZ-7yRhIqB4uJg-1; Mon, 08 Mar 2021 16:49:57 -0500
X-MC-Unique: 2fEasTi1OZ-7yRhIqB4uJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6207A108BD06;
        Mon,  8 Mar 2021 21:49:56 +0000 (UTC)
Received: from gimli.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96B805D9CD;
        Mon,  8 Mar 2021 21:49:49 +0000 (UTC)
Subject: [PATCH v1 14/14] vfio: Cleanup use of bare unsigned
From:   Alex Williamson <alex.williamson@redhat.com>
To:     alex.williamson@redhat.com
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com, peterx@redhat.com
Date:   Mon, 08 Mar 2021 14:49:49 -0700
Message-ID: <161524018910.3480.774661659452044338.stgit@gimli.home>
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
User-Agent: StGit/0.21-2-g8ef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace with 'unsigned int'.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_intrs.c             |   42 ++++++++++++++-----------
 drivers/vfio/pci/vfio_pci_private.h           |    4 +-
 drivers/vfio/platform/vfio_platform_irq.c     |   21 +++++++------
 drivers/vfio/platform/vfio_platform_private.h |    4 +-
 4 files changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 869dce5f134d..67de58d67908 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -364,8 +364,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_device *vdev,
 	return 0;
 }
 
-static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned start,
-			      unsigned count, int32_t *fds, bool msix)
+static int vfio_msi_set_block(struct vfio_pci_device *vdev, unsigned int start,
+			      unsigned int count, int32_t *fds, bool msix)
 {
 	int i, j, ret = 0;
 
@@ -418,8 +418,9 @@ static void vfio_msi_disable(struct vfio_pci_device *vdev, bool msix)
  * IOCTL support
  */
 static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -445,8 +446,9 @@ static int vfio_pci_set_intx_unmask(struct vfio_pci_device *vdev,
 }
 
 static int vfio_pci_set_intx_mask(struct vfio_pci_device *vdev,
-				  unsigned index, unsigned start,
-				  unsigned count, uint32_t flags, void *data)
+				  unsigned int index, unsigned int start,
+				  unsigned int count, uint32_t flags,
+				  void *data)
 {
 	if (!is_intx(vdev) || start != 0 || count != 1)
 		return -EINVAL;
@@ -465,8 +467,9 @@ static int vfio_pci_set_intx_mask(struct vfio_pci_device *vdev,
 }
 
 static int vfio_pci_set_intx_trigger(struct vfio_pci_device *vdev,
-				     unsigned index, unsigned start,
-				     unsigned count, uint32_t flags, void *data)
+				     unsigned int index, unsigned int start,
+				     unsigned int count, uint32_t flags,
+				     void *data)
 {
 	if (is_intx(vdev) && !count && (flags & VFIO_IRQ_SET_DATA_NONE)) {
 		vfio_intx_disable(vdev);
@@ -508,8 +511,9 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_device *vdev,
 }
 
 static int vfio_pci_set_msi_trigger(struct vfio_pci_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	int i;
 	bool msix = (index == VFIO_PCI_MSIX_IRQ_INDEX) ? true : false;
@@ -614,8 +618,9 @@ static int vfio_pci_set_ctx_trigger_single(struct eventfd_ctx **ctx,
 }
 
 static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (index != VFIO_PCI_ERR_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
@@ -625,8 +630,9 @@ static int vfio_pci_set_err_trigger(struct vfio_pci_device *vdev,
 }
 
 static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
-				    unsigned index, unsigned start,
-				    unsigned count, uint32_t flags, void *data)
+				    unsigned int index, unsigned int start,
+				    unsigned int count, uint32_t flags,
+				    void *data)
 {
 	if (index != VFIO_PCI_REQ_IRQ_INDEX || start != 0 || count > 1)
 		return -EINVAL;
@@ -636,11 +642,11 @@ static int vfio_pci_set_req_trigger(struct vfio_pci_device *vdev,
 }
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev, uint32_t flags,
-			    unsigned index, unsigned start, unsigned count,
-			    void *data)
+			    unsigned int index, unsigned int start,
+			    unsigned int count, void *data)
 {
-	int (*func)(struct vfio_pci_device *vdev, unsigned index,
-		    unsigned start, unsigned count, uint32_t flags,
+	int (*func)(struct vfio_pci_device *vdev, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
 	switch (index) {
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 49a60585cf9c..93f47044e2e5 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -153,8 +153,8 @@ void vfio_pci_intx_mask(struct vfio_pci_device *vdev);
 void vfio_pci_intx_unmask(struct vfio_pci_device *vdev);
 
 int vfio_pci_set_irqs_ioctl(struct vfio_pci_device *vdev,
-			    uint32_t flags, unsigned index,
-			    unsigned start, unsigned count, void *data);
+			    uint32_t flags, unsigned int index,
+			    unsigned int start, unsigned int count, void *data);
 
 ssize_t vfio_pci_config_rw(struct vfio_pci_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite);
diff --git a/drivers/vfio/platform/vfio_platform_irq.c b/drivers/vfio/platform/vfio_platform_irq.c
index c5b09ec0a3c9..90d87ab44131 100644
--- a/drivers/vfio/platform/vfio_platform_irq.c
+++ b/drivers/vfio/platform/vfio_platform_irq.c
@@ -39,8 +39,8 @@ static int vfio_platform_mask_handler(void *opaque, void *unused)
 }
 
 static int vfio_platform_set_irq_mask(struct vfio_platform_device *vdev,
-				      unsigned index, unsigned start,
-				      unsigned count, uint32_t flags,
+				      unsigned int index, unsigned int start,
+				      unsigned int count, uint32_t flags,
 				      void *data)
 {
 	if (start != 0 || count != 1)
@@ -99,8 +99,8 @@ static int vfio_platform_unmask_handler(void *opaque, void *unused)
 }
 
 static int vfio_platform_set_irq_unmask(struct vfio_platform_device *vdev,
-					unsigned index, unsigned start,
-					unsigned count, uint32_t flags,
+					unsigned int index, unsigned int start,
+					unsigned int count, uint32_t flags,
 					void *data)
 {
 	if (start != 0 || count != 1)
@@ -216,8 +216,8 @@ static int vfio_set_trigger(struct vfio_platform_device *vdev, int index,
 }
 
 static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
-					 unsigned index, unsigned start,
-					 unsigned count, uint32_t flags,
+					 unsigned int index, unsigned int start,
+					 unsigned int count, uint32_t flags,
 					 void *data)
 {
 	struct vfio_platform_irq *irq = &vdev->irqs[index];
@@ -254,11 +254,12 @@ static int vfio_platform_set_irq_trigger(struct vfio_platform_device *vdev,
 }
 
 int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
-				 uint32_t flags, unsigned index, unsigned start,
-				 unsigned count, void *data)
+				 uint32_t flags, unsigned int index,
+				 unsigned int start, unsigned int count,
+				 void *data)
 {
-	int (*func)(struct vfio_platform_device *vdev, unsigned index,
-		    unsigned start, unsigned count, uint32_t flags,
+	int (*func)(struct vfio_platform_device *vdev, unsigned int index,
+		    unsigned int start, unsigned int count, uint32_t flags,
 		    void *data) = NULL;
 
 	switch (flags & VFIO_IRQ_SET_ACTION_TYPE_MASK) {
diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
index 2aa12d41f9c6..09870bf07e95 100644
--- a/drivers/vfio/platform/vfio_platform_private.h
+++ b/drivers/vfio/platform/vfio_platform_private.h
@@ -86,8 +86,8 @@ int vfio_platform_irq_init(struct vfio_platform_device *vdev);
 void vfio_platform_irq_cleanup(struct vfio_platform_device *vdev);
 
 int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
-				 uint32_t flags, unsigned index,
-				 unsigned start, unsigned count,
+				 uint32_t flags, unsigned int index,
+				 unsigned int start, unsigned int count,
 				 void *data);
 
 void __vfio_platform_register_reset(struct vfio_platform_reset_node *n);

