Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE6C146997
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgAWNsk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:40 -0500
Received: from foss.arm.com ([217.140.110.172]:39770 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgAWNsj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2DAEFEC;
        Thu, 23 Jan 2020 05:48:38 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id AE9F43F68E;
        Thu, 23 Jan 2020 05:48:37 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 15/30] virtio: Don't ignore initialization failures
Date:   Thu, 23 Jan 2020 13:47:50 +0000
Message-Id: <20200123134805.1993-16-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Don't ignore an error in the bus specific initialization function in
virtio_init; don't ignore the result of virtio_init; and don't return 0
in virtio_blk__init and virtio_scsi__init when we encounter an error.
Hopefully this will save some developer's time debugging faulty virtio
devices in a guest.

To take advantage of the cleanup function virtio_blk__exit, we have
moved appending the new device to the list before the call to
virtio_init.

To safeguard against this in the future, virtio_init has been annoted
with the compiler attribute warn_unused_result.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/kvm.h        |  1 +
 include/kvm/virtio.h     |  7 ++++---
 include/linux/compiler.h |  2 +-
 virtio/9p.c              |  9 ++++++---
 virtio/balloon.c         | 10 +++++++---
 virtio/blk.c             | 14 +++++++++-----
 virtio/console.c         | 11 ++++++++---
 virtio/core.c            |  9 +++++----
 virtio/net.c             | 32 ++++++++++++++++++--------------
 virtio/scsi.c            | 14 +++++++++-----
 10 files changed, 68 insertions(+), 41 deletions(-)

diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
index 7a738183d67a..c6dc6ef72d11 100644
--- a/include/kvm/kvm.h
+++ b/include/kvm/kvm.h
@@ -8,6 +8,7 @@
 
 #include <stdbool.h>
 #include <linux/types.h>
+#include <linux/compiler.h>
 #include <time.h>
 #include <signal.h>
 #include <sys/prctl.h>
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 19b913732cd5..3a311f54f2a5 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -7,6 +7,7 @@
 #include <linux/virtio_pci.h>
 
 #include <linux/types.h>
+#include <linux/compiler.h>
 #include <linux/virtio_config.h>
 #include <sys/uio.h>
 
@@ -204,9 +205,9 @@ struct virtio_ops {
 	int (*reset)(struct kvm *kvm, struct virtio_device *vdev);
 };
 
-int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
-		struct virtio_ops *ops, enum virtio_trans trans,
-		int device_id, int subsys_id, int class);
+int __must_check virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
+			     struct virtio_ops *ops, enum virtio_trans trans,
+			     int device_id, int subsys_id, int class);
 int virtio_compat_add_message(const char *device, const char *config);
 const char* virtio_trans_name(enum virtio_trans trans);
 
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 898420b81aec..a662ba0a5c68 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -14,7 +14,7 @@
 #define __packed	__attribute__((packed))
 #define __iomem
 #define __force
-#define __must_check
+#define __must_check	__attribute__((warn_unused_result))
 #define unlikely
 
 #endif
diff --git a/virtio/9p.c b/virtio/9p.c
index ac70dbc31207..b78f2b3f0e09 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1551,11 +1551,14 @@ int virtio_9p_img_name_parser(const struct option *opt, const char *arg, int uns
 int virtio_9p__init(struct kvm *kvm)
 {
 	struct p9_dev *p9dev;
+	int r;
 
 	list_for_each_entry(p9dev, &devs, list) {
-		virtio_init(kvm, p9dev, &p9dev->vdev, &p9_dev_virtio_ops,
-			    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_9P,
-			    VIRTIO_ID_9P, PCI_CLASS_9P);
+		r = virtio_init(kvm, p9dev, &p9dev->vdev, &p9_dev_virtio_ops,
+				VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_9P,
+				VIRTIO_ID_9P, PCI_CLASS_9P);
+		if (r < 0)
+			return r;
 	}
 
 	return 0;
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 0bd16703dfee..8e8803fed607 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -264,6 +264,8 @@ struct virtio_ops bln_dev_virtio_ops = {
 
 int virtio_bln__init(struct kvm *kvm)
 {
+	int r;
+
 	if (!kvm->cfg.balloon)
 		return 0;
 
@@ -273,9 +275,11 @@ int virtio_bln__init(struct kvm *kvm)
 	bdev.stat_waitfd	= eventfd(0, 0);
 	memset(&bdev.config, 0, sizeof(struct virtio_balloon_config));
 
-	virtio_init(kvm, &bdev, &bdev.vdev, &bln_dev_virtio_ops,
-		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLN,
-		    VIRTIO_ID_BALLOON, PCI_CLASS_BLN);
+	r = virtio_init(kvm, &bdev, &bdev.vdev, &bln_dev_virtio_ops,
+			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLN,
+			VIRTIO_ID_BALLOON, PCI_CLASS_BLN);
+	if (r < 0)
+		return r;
 
 	if (compat_id == -1)
 		compat_id = virtio_compat_add_message("virtio-balloon", "CONFIG_VIRTIO_BALLOON");
diff --git a/virtio/blk.c b/virtio/blk.c
index f267be1563dc..4d02d101af81 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -306,6 +306,7 @@ static struct virtio_ops blk_dev_virtio_ops = {
 static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 {
 	struct blk_dev *bdev;
+	int r;
 
 	if (!disk)
 		return -EINVAL;
@@ -323,12 +324,14 @@ static int virtio_blk__init_one(struct kvm *kvm, struct disk_image *disk)
 		.kvm			= kvm,
 	};
 
-	virtio_init(kvm, bdev, &bdev->vdev, &blk_dev_virtio_ops,
-		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLK,
-		    VIRTIO_ID_BLOCK, PCI_CLASS_BLK);
-
 	list_add_tail(&bdev->list, &bdevs);
 
+	r = virtio_init(kvm, bdev, &bdev->vdev, &blk_dev_virtio_ops,
+			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_BLK,
+			VIRTIO_ID_BLOCK, PCI_CLASS_BLK);
+	if (r < 0)
+		return r;
+
 	disk_image__set_callback(bdev->disk, virtio_blk_complete);
 
 	if (compat_id == -1)
@@ -359,7 +362,8 @@ int virtio_blk__init(struct kvm *kvm)
 
 	return 0;
 cleanup:
-	return virtio_blk__exit(kvm);
+	virtio_blk__exit(kvm);
+	return r;
 }
 virtio_dev_init(virtio_blk__init);
 
diff --git a/virtio/console.c b/virtio/console.c
index f1be02549222..e0b98df37965 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -230,12 +230,17 @@ static struct virtio_ops con_dev_virtio_ops = {
 
 int virtio_console__init(struct kvm *kvm)
 {
+	int r;
+
 	if (kvm->cfg.active_console != CONSOLE_VIRTIO)
 		return 0;
 
-	virtio_init(kvm, &cdev, &cdev.vdev, &con_dev_virtio_ops,
-		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_CONSOLE,
-		    VIRTIO_ID_CONSOLE, PCI_CLASS_CONSOLE);
+	r = virtio_init(kvm, &cdev, &cdev.vdev, &con_dev_virtio_ops,
+			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_CONSOLE,
+			VIRTIO_ID_CONSOLE, PCI_CLASS_CONSOLE);
+	if (r < 0)
+		return r;
+
 	if (compat_id == -1)
 		compat_id = virtio_compat_add_message("virtio-console", "CONFIG_VIRTIO_CONSOLE");
 
diff --git a/virtio/core.c b/virtio/core.c
index e10ec362e1ea..f5b3c07fc100 100644
--- a/virtio/core.c
+++ b/virtio/core.c
@@ -259,6 +259,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		int device_id, int subsys_id, int class)
 {
 	void *virtio;
+	int r;
 
 	switch (trans) {
 	case VIRTIO_PCI:
@@ -272,7 +273,7 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		vdev->ops->init			= virtio_pci__init;
 		vdev->ops->exit			= virtio_pci__exit;
 		vdev->ops->reset		= virtio_pci__reset;
-		vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
+		r = vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
 		break;
 	case VIRTIO_MMIO:
 		virtio = calloc(sizeof(struct virtio_mmio), 1);
@@ -285,13 +286,13 @@ int virtio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 		vdev->ops->init			= virtio_mmio_init;
 		vdev->ops->exit			= virtio_mmio_exit;
 		vdev->ops->reset		= virtio_mmio_reset;
-		vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
+		r = vdev->ops->init(kvm, dev, vdev, device_id, subsys_id, class);
 		break;
 	default:
-		return -1;
+		r = -1;
 	};
 
-	return 0;
+	return r;
 }
 
 int virtio_compat_add_message(const char *device, const char *config)
diff --git a/virtio/net.c b/virtio/net.c
index 091406912a24..425c13ba1136 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -910,7 +910,7 @@ done:
 
 static int virtio_net__init_one(struct virtio_net_params *params)
 {
-	int i, err;
+	int i, r;
 	struct net_dev *ndev;
 	struct virtio_ops *ops;
 	enum virtio_trans trans = VIRTIO_DEFAULT_TRANS(params->kvm);
@@ -920,10 +920,8 @@ static int virtio_net__init_one(struct virtio_net_params *params)
 		return -ENOMEM;
 
 	ops = malloc(sizeof(*ops));
-	if (ops == NULL) {
-		err = -ENOMEM;
-		goto err_free_ndev;
-	}
+	if (ops == NULL)
+		return -ENOMEM;
 
 	list_add_tail(&ndev->list, &ndevs);
 
@@ -969,8 +967,10 @@ static int virtio_net__init_one(struct virtio_net_params *params)
 				   virtio_trans_name(trans));
 	}
 
-	virtio_init(params->kvm, ndev, &ndev->vdev, ops, trans,
-		    PCI_DEVICE_ID_VIRTIO_NET, VIRTIO_ID_NET, PCI_CLASS_NET);
+	r = virtio_init(params->kvm, ndev, &ndev->vdev, ops, trans,
+			PCI_DEVICE_ID_VIRTIO_NET, VIRTIO_ID_NET, PCI_CLASS_NET);
+	if (r < 0)
+		return r;
 
 	if (params->vhost)
 		virtio_net__vhost_init(params->kvm, ndev);
@@ -979,19 +979,17 @@ static int virtio_net__init_one(struct virtio_net_params *params)
 		compat_id = virtio_compat_add_message("virtio-net", "CONFIG_VIRTIO_NET");
 
 	return 0;
-
-err_free_ndev:
-	free(ndev);
-	return err;
 }
 
 int virtio_net__init(struct kvm *kvm)
 {
-	int i;
+	int i, r;
 
 	for (i = 0; i < kvm->cfg.num_net_devices; i++) {
 		kvm->cfg.net_params[i].kvm = kvm;
-		virtio_net__init_one(&kvm->cfg.net_params[i]);
+		r = virtio_net__init_one(&kvm->cfg.net_params[i]);
+		if (r < 0)
+			goto cleanup;
 	}
 
 	if (kvm->cfg.num_net_devices == 0 && kvm->cfg.no_net == 0) {
@@ -1007,10 +1005,16 @@ int virtio_net__init(struct kvm *kvm)
 		str_to_mac(kvm->cfg.guest_mac, net_params.guest_mac);
 		str_to_mac(kvm->cfg.host_mac, net_params.host_mac);
 
-		virtio_net__init_one(&net_params);
+		r = virtio_net__init_one(&net_params);
+		if (r < 0)
+			goto cleanup;
 	}
 
 	return 0;
+
+cleanup:
+	virtio_net__exit(kvm);
+	return r;
 }
 virtio_dev_init(virtio_net__init);
 
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 1ec78fe0945a..16a86cb7e0e6 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -234,6 +234,7 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
 static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
 {
 	struct scsi_dev *sdev;
+	int r;
 
 	if (!disk)
 		return -EINVAL;
@@ -260,12 +261,14 @@ static int virtio_scsi_init_one(struct kvm *kvm, struct disk_image *disk)
 	strlcpy((char *)&sdev->target.vhost_wwpn, disk->wwpn, sizeof(sdev->target.vhost_wwpn));
 	sdev->target.vhost_tpgt = strtol(disk->tpgt, NULL, 0);
 
-	virtio_init(kvm, sdev, &sdev->vdev, &scsi_dev_virtio_ops,
-		    VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_SCSI,
-		    VIRTIO_ID_SCSI, PCI_CLASS_BLK);
-
 	list_add_tail(&sdev->list, &sdevs);
 
+	r = virtio_init(kvm, sdev, &sdev->vdev, &scsi_dev_virtio_ops,
+			VIRTIO_DEFAULT_TRANS(kvm), PCI_DEVICE_ID_VIRTIO_SCSI,
+			VIRTIO_ID_SCSI, PCI_CLASS_BLK);
+	if (r < 0)
+		return r;
+
 	virtio_scsi_vhost_init(kvm, sdev);
 
 	if (compat_id == -1)
@@ -302,7 +305,8 @@ int virtio_scsi_init(struct kvm *kvm)
 
 	return 0;
 cleanup:
-	return virtio_scsi_exit(kvm);
+	virtio_scsi_exit(kvm);
+	return r;
 }
 virtio_dev_init(virtio_scsi_init);
 
-- 
2.20.1

