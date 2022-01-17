Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A70D4911A3
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 23:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243586AbiAQWM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 17:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243583AbiAQWM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 17:12:27 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DE4C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:26 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id m3so48948542lfu.0
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3dg5qMs/jLVh4rqWX/R2a3/ADRqY2cFlmw8Vwbsq/N4=;
        b=MoPV2ZTyHOADUIs1Btbj9k8EFUGScwx8XGmUQy0LSThxqOEwEO4vMlfFKdoIsorhY/
         YwzTZd4NYbETf5wMKoDBZx7KK26bC2SqzUwp3H9TYOGu1VK7gQjM6tErumq1UZD3nydV
         +i7LY3M36a53QtfhnxUi5YTteIGa5IbR5q4pMaqYaJlSiJ88r+tKx05BCMzW5J4U3Lk4
         YTSBKPtOfNFOp1RoND5wVNoJ1aFceHJ66+16LgOXGMMB58bFkVdcK/MDjOpSHkIwDDz1
         UW4XCL3DSHwDLyGB2DM2se0nDlPX0bN4CR6GS2VrsPrlD6CzuRN6JzhiU4T8ztwM7Wu3
         3xPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3dg5qMs/jLVh4rqWX/R2a3/ADRqY2cFlmw8Vwbsq/N4=;
        b=boibVlVffMI7RbG5pP9Xe2hwtt7dpGYEmZTde/eWfWa7D393QgpQPz/iKBJ3MEg7Be
         xg4IwzqFfJuc4iojQIrJ8t+Jkrij3Xuax7Iq2gb761+aQTcmRXjm7aAlWNSmjClNYeRz
         XSM6Jj6xWhI57QxIPD5j3bcWyN2R32hJTrVlSrOSPuK2jjx+VolP7VNM4JfeEuDVOh/7
         vUA4yuIK0uZs9h/2fRtRm180fmLbYVaxsvK0+xxGa3Wku1xqW5iQlnbfiUdOaUeG0WWz
         h3GADRUTWYaFAkwnWDWg4MzQrUwabi3pWv464p0T0rAJ4343DcFdArhfcn/0iz+Sv/jc
         gjzg==
X-Gm-Message-State: AOAM530zoEZnmmBPGSczrQDBHPzefMpMYabiKOqhpzbZUBg2Z2IKO/Kl
        MdjhHwj5rQvQg+D89B9LjzRxdQ1ERkAPnQ==
X-Google-Smtp-Source: ABdhPJxN0X5RKnh6mlE/ig08iLH0CNbdeLHKOpbkSTD9c7MUsukE2MJPq+RmqKwyjxLO6lCjSeKSoA==
X-Received: by 2002:a2e:9099:: with SMTP id l25mr7138442ljg.38.1642457544898;
        Mon, 17 Jan 2022 14:12:24 -0800 (PST)
Received: from localhost.localdomain (88-115-234-133.elisa-laajakaista.fi. [88.115.234.133])
        by smtp.gmail.com with ESMTPSA id c32sm1458094ljr.107.2022.01.17.14.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:12:24 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 1/5] virtio: Sanitize config accesses
Date:   Tue, 18 Jan 2022 00:11:59 +0200
Message-Id: <4a68381d2251d4bdbc0a31f0210f3e0f1c3d18ce.1642457047.git.martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The handling of VIRTIO_PCI_O_CONFIG is prone to buffer access overflows.
This patch sanitizes this operation by using the newly added virtio op
get_config_size. Any access which goes beyond the config structure's
size is prevented and a failure is returned.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  1 +
 virtio/9p.c             | 19 ++++++++++++++++---
 virtio/balloon.c        |  6 ++++++
 virtio/blk.c            |  6 ++++++
 virtio/console.c        |  6 ++++++
 virtio/mmio.c           | 19 +++++++++++++++----
 virtio/net.c            |  6 ++++++
 virtio/pci.c            | 19 ++++++++++++++++++-
 virtio/rng.c            |  6 ++++++
 virtio/scsi.c           |  6 ++++++
 virtio/vsock.c          |  6 ++++++
 12 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/include/kvm/virtio-9p.h b/include/kvm/virtio-9p.h
index 3ea7698..77c5062 100644
--- a/include/kvm/virtio-9p.h
+++ b/include/kvm/virtio-9p.h
@@ -44,6 +44,7 @@ struct p9_dev {
 	struct virtio_device	vdev;
 	struct rb_root		fids;
 
+	size_t config_size;
 	struct virtio_9p_config	*config;
 	u32			features;
 
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 3a311f5..3880e74 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -184,6 +184,7 @@ struct virtio_device {
 
 struct virtio_ops {
 	u8 *(*get_config)(struct kvm *kvm, void *dev);
+	size_t (*get_config_size)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
 	int (*get_vq_count)(struct kvm *kvm, void *dev);
diff --git a/virtio/9p.c b/virtio/9p.c
index b78f2b3..89bec5e 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1375,6 +1375,12 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(p9dev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct p9_dev *p9dev = dev;
+	return p9dev->config_size;
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_9P_MOUNT_TAG;
@@ -1469,6 +1475,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 struct virtio_ops p9_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
@@ -1569,6 +1576,8 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 {
 	struct p9_dev *p9dev;
 	int err = 0;
+	size_t tag_name_length = 0;
+	size_t config_size = 0;
 
 	p9dev = calloc(1, sizeof(*p9dev));
 	if (!p9dev)
@@ -1577,22 +1586,26 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 	if (!tag_name)
 		tag_name = VIRTIO_9P_DEFAULT_TAG;
 
-	p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
+	tag_name_length = strlen(tag_name);
+	config_size = sizeof(*p9dev->config) + tag_name_length + 1;
+
+	p9dev->config = calloc(1, config_size);
 	if (p9dev->config == NULL) {
 		err = -ENOMEM;
 		goto free_p9dev;
 	}
+	p9dev->config_size = config_size;
 
 	strncpy(p9dev->root_dir, root, sizeof(p9dev->root_dir));
 	p9dev->root_dir[sizeof(p9dev->root_dir)-1] = '\x00';
 
-	p9dev->config->tag_len = strlen(tag_name);
+	p9dev->config->tag_len = tag_name_length;
 	if (p9dev->config->tag_len > MAX_TAG_LEN) {
 		err = -EINVAL;
 		goto free_p9dev_config;
 	}
 
-	memcpy(&p9dev->config->tag, tag_name, strlen(tag_name));
+	memcpy(&p9dev->config->tag, tag_name, tag_name_length);
 
 	list_add(&p9dev->list, &devs);
 
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 8e8803f..233a3a5 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -181,6 +181,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&bdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return sizeof(struct virtio_balloon_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_BALLOON_F_STATS_VQ;
@@ -251,6 +256,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 struct virtio_ops bln_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/blk.c b/virtio/blk.c
index 4d02d10..9164b51 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -146,6 +146,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&bdev->blk_config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return sizeof(struct virtio_blk_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	struct blk_dev *bdev = dev;
@@ -291,6 +296,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops blk_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/console.c b/virtio/console.c
index e0b98df..00bafa2 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -121,6 +121,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&cdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return sizeof(struct virtio_console_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 0;
@@ -216,6 +221,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops con_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 875a288..32bba17 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -103,15 +103,26 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 					u8 is_write, struct virtio_device *vdev)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
+	u8 *config_aperture = NULL;
+	u32 config_aperture_size = 0;
 	u32 i;
 
+	config_aperture = vdev->ops->get_config(vmmio->kvm, vmmio->dev);
+	/* The cast here is safe because get_config_size will always fit in 32 bits. */
+	config_aperture_size = (u32)vdev->ops->get_config_size(vmmio->kvm, vmmio->dev);
+
+	/* Reduce length to no more than the config size to avoid buffer overflows. */
+	if (config_aperture_size < len) {
+		pr_warning("Length (%u) goes beyond config size (%u).\n",
+			len, config_aperture_size);
+		len = config_aperture_size;
+	}
+
 	for (i = 0; i < len; i++) {
 		if (is_write)
-			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
-					      *(u8 *)data + i;
+			config_aperture[addr + i] = *(u8 *)data + i;
 		else
-			data[i] = vdev->ops->get_config(vmmio->kvm,
-							vmmio->dev)[addr + i];
+			data[i] = config_aperture[addr+i];
 	}
 }
 
diff --git a/virtio/net.c b/virtio/net.c
index 1ee3c19..75d9ae5 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -480,6 +480,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&ndev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return sizeof(struct virtio_net_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	u32 features;
@@ -757,6 +762,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops net_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/pci.c b/virtio/pci.c
index 4108529..50fdaa4 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -136,7 +136,15 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
 		u8 cfg;
-
+		size_t config_size;
+
+		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
+		if (config_offset >= config_size) {
+			/* Access goes beyond the config size, so return failure. */
+			pr_warning("Config access offset (%u) is beyond config size (%zu)\n",
+				config_offset, config_size);
+			return false;
+		}
 		cfg = vdev->ops->get_config(kvm, vpci->dev)[config_offset];
 		ioport__write8(data, cfg);
 		return true;
@@ -276,6 +284,15 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
+		size_t config_size;
+
+		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
+		if (config_offset >= config_size) {
+			/* Access goes beyond the config size, so return failure. */
+			pr_warning("Config access offset (%u) is beyond config size (%zu)\n",
+				config_offset, config_size);
+			return false;
+		}
 		vdev->ops->get_config(kvm, vpci->dev)[config_offset] = *(u8 *)data;
 
 		return true;
diff --git a/virtio/rng.c b/virtio/rng.c
index 78eaa64..c7835a0 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -47,6 +47,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return 0;
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return 0;
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	/* Unused */
@@ -149,6 +154,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops rng_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 16a86cb..37418f8 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -38,6 +38,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&sdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return sizeof(struct virtio_scsi_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return	1UL << VIRTIO_RING_F_EVENT_IDX |
@@ -176,6 +181,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 5b99838..2df04d7 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -41,6 +41,11 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&vdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	return sizeof(struct virtio_vsock_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1UL << VIRTIO_RING_F_EVENT_IDX
@@ -204,6 +209,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops vsock_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
-- 
2.25.1

