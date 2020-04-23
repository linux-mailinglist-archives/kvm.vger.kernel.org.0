Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320D31B621A
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 19:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729992AbgDWRjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 13:39:04 -0400
Received: from foss.arm.com ([217.140.110.172]:44756 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729802AbgDWRjE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 13:39:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C7F89C14;
        Thu, 23 Apr 2020 10:39:03 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A1FE3F68F;
        Thu, 23 Apr 2020 10:39:02 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Raphael Gault <raphael.gault@arm.com>,
        Sami Mujawar <sami.mujawar@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH kvmtool v4 1/5] virtio-mmio: Assign IRQ line directly before registering device
Date:   Thu, 23 Apr 2020 18:38:40 +0100
Message-Id: <20200423173844.24220-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200423173844.24220-1-andre.przywara@arm.com>
References: <20200423173844.24220-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the moment the IRQ line for a virtio-mmio device is assigned in the
generic device__register() routine in devices.c, by calling back into
virtio-mmio.c. This does not only sound slightly convoluted, but also
breaks when we try to register an MMIO device that is not a virtio-mmio
device. In this case container_of will return a bogus pointer (as it
assumes a struct virtio_mmio), and the IRQ allocation routine will
corrupt some data in the device_header (for instance the first byte
of the "data" pointer).

Simply assign the IRQ directly in virtio_mmio_init(), before calling
device__register(). This avoids the problem and looks actually much more
straightforward.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 devices.c                 |  4 ----
 include/kvm/virtio-mmio.h |  1 -
 virtio/mmio.c             | 10 ++--------
 3 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/devices.c b/devices.c
index a7c666a7..2c8b2665 100644
--- a/devices.c
+++ b/devices.c
@@ -1,7 +1,6 @@
 #include "kvm/devices.h"
 #include "kvm/kvm.h"
 #include "kvm/pci.h"
-#include "kvm/virtio-mmio.h"
 
 #include <linux/err.h>
 #include <linux/rbtree.h>
@@ -33,9 +32,6 @@ int device__register(struct device_header *dev)
 	case DEVICE_BUS_PCI:
 		pci__assign_irq(dev);
 		break;
-	case DEVICE_BUS_MMIO:
-		virtio_mmio_assign_irq(dev);
-		break;
 	default:
 		break;
 	}
diff --git a/include/kvm/virtio-mmio.h b/include/kvm/virtio-mmio.h
index 0528947a..6bc50bd1 100644
--- a/include/kvm/virtio-mmio.h
+++ b/include/kvm/virtio-mmio.h
@@ -57,5 +57,4 @@ int virtio_mmio_exit(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev);
 int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		      int device_id, int subsys_id, int class);
-void virtio_mmio_assign_irq(struct device_header *dev_hdr);
 #endif
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 5537c393..875a288c 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -280,14 +280,6 @@ static void generate_virtio_mmio_fdt_node(void *fdt,
 }
 #endif
 
-void virtio_mmio_assign_irq(struct device_header *dev_hdr)
-{
-	struct virtio_mmio *vmmio = container_of(dev_hdr,
-						 struct virtio_mmio,
-						 dev_hdr);
-	vmmio->irq = irq__alloc_line();
-}
-
 int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		     int device_id, int subsys_id, int class)
 {
@@ -316,6 +308,8 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		.data		= generate_virtio_mmio_fdt_node,
 	};
 
+	vmmio->irq = irq__alloc_line();
+
 	r = device__register(&vmmio->dev_hdr);
 	if (r < 0) {
 		kvm__deregister_mmio(kvm, vmmio->addr);
-- 
2.17.1

