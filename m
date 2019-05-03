Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220C913302
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 19:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfECRP7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 13:15:59 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:37644 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbfECRP6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 13:15:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B1DE15A2;
        Fri,  3 May 2019 10:15:58 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 358E63F557;
        Fri,  3 May 2019 10:15:57 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        kvm@vger.kernel.org
Subject: [PATCH kvmtool 3/4] vfio: rework vfio_irq_set payload setting
Date:   Fri,  3 May 2019 18:15:43 +0100
Message-Id: <20190503171544.260901-4-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190503171544.260901-1-andre.przywara@arm.com>
References: <20190503171544.260901-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct vfio_irq_set from the kernel headers contains a variable sized
array to hold a payload. The vfio_irq_eventfd struct puts the "fd"
member right after this, hoping it to automatically fit in the payload slot.
But having a variable sized type not at the end of a struct is a GNU C
extension, so clang will refuse to compile this.

Solve this by somewhat doing the compiler's job and place the payload
manually at the end of the structure.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 vfio/pci.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/vfio/pci.c b/vfio/pci.c
index a4086326..76e24c15 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -9,11 +9,16 @@
 #include <sys/time.h>
 
 /* Wrapper around UAPI vfio_irq_set */
-struct vfio_irq_eventfd {
+union vfio_irq_eventfd {
 	struct vfio_irq_set	irq;
-	int			fd;
+	u8 buffer[sizeof(struct vfio_irq_set) + sizeof(int)];
 };
 
+static void set_vfio_irq_eventd_payload(union vfio_irq_eventfd *evfd, int fd)
+{
+	memcpy(&evfd->irq.data, &fd, sizeof(fd));
+}
+
 #define msi_is_enabled(state)		((state) & VFIO_PCI_MSI_STATE_ENABLED)
 #define msi_is_masked(state)		((state) & VFIO_PCI_MSI_STATE_MASKED)
 #define msi_is_empty(state)		((state) & VFIO_PCI_MSI_STATE_EMPTY)
@@ -38,7 +43,7 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 	int *eventfds;
 	struct vfio_pci_device *pdev = &vdev->pci;
 	struct vfio_pci_msi_common *msis = msix ? &pdev->msix : &pdev->msi;
-	struct vfio_irq_eventfd single = {
+	union vfio_irq_eventfd single = {
 		.irq = {
 			.argsz	= sizeof(single),
 			.flags	= VFIO_IRQ_SET_DATA_EVENTFD |
@@ -117,7 +122,7 @@ static int vfio_pci_enable_msis(struct kvm *kvm, struct vfio_device *vdev,
 			continue;
 
 		single.irq.start = i;
-		single.fd = fd;
+		set_vfio_irq_eventd_payload(&single, fd);
 
 		ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &single);
 		if (ret < 0) {
@@ -1021,8 +1026,8 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 {
 	int ret;
 	int trigger_fd, unmask_fd;
-	struct vfio_irq_eventfd	trigger;
-	struct vfio_irq_eventfd	unmask;
+	union vfio_irq_eventfd	trigger;
+	union vfio_irq_eventfd	unmask;
 	struct vfio_pci_device *pdev = &vdev->pci;
 	int gsi = pdev->intx_gsi;
 
@@ -1058,7 +1063,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.start	= 0,
 		.count	= 1,
 	};
-	trigger.fd = trigger_fd;
+	set_vfio_irq_eventd_payload(&trigger, trigger_fd);
 
 	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &trigger);
 	if (ret < 0) {
@@ -1073,7 +1078,7 @@ static int vfio_pci_enable_intx(struct kvm *kvm, struct vfio_device *vdev)
 		.start	= 0,
 		.count	= 1,
 	};
-	unmask.fd = unmask_fd;
+	set_vfio_irq_eventd_payload(&unmask, unmask_fd);
 
 	ret = ioctl(vdev->fd, VFIO_DEVICE_SET_IRQS, &unmask);
 	if (ret < 0) {
-- 
2.17.1

