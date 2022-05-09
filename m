Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB19520615
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:41:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiEIUpA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiEIUog (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:44:36 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7C0285EC6
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:40:33 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id bu29so25915147lfb.0
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eJPn2410LQQ8jrnx3po4937PuKsQGW+evw8rOwjEAKU=;
        b=TlZkZV6MrHwtsDZIrWjuVTb9NVqa6tKiHiR4Jq/cpviYLi988o5LZr0UmX+OupLxEU
         Ejj/5Bi0waGLOjRhhxnmK09FRSgr2nq9rlWeXKaPApJwaBRtTVFxSpXBJpP02UmJK7Yx
         d23TsZIPua1YlgSjUDn1OWUGSic6r4sDDlHXak31t7KO6jR1l6fCPZQDTUf34O4RR8d9
         dITOMWrA+Ljm6us1ruFrL7vIfmbHFWCkVctrlpFNoNZ/xFoelK5KqPrDcHIoB/8KNyLo
         gZGuOgJW/n4/kr8azBM4+FBhRVMPgGuIBXs03d8XWihjAv4NM7M09RNr9WkoU5O0kk/5
         kqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eJPn2410LQQ8jrnx3po4937PuKsQGW+evw8rOwjEAKU=;
        b=d20qQgFJ8jOFRXF7e5AmcgrbwCZRe0Y25bPLp4w61falcD4t56kphgOxKimT/bylup
         +jB6y7yKfTRQTyryU1CSlLK21b8yOHQWv7QTbNUPqRbfjnps4xfhxEHv71bGlEoVOcPG
         /l6MvP336UHgriECUB6qoYedfWWDPlf99hqFxMR/dx3RxkyNg5ChnGt0r6Oul9jkLooO
         gY3g9D6tT547DP7//DVwAWd8aaU8YN0LJjFE6qgBtfbfppl8LfQNcp3J/SGuNk4PCSwY
         rSGyitcYZQcjzUKOK611ssE2V3pYOnfirvriP6CfRBNzZXRwvfogjUcERlg6Jz+CWtO8
         0KoQ==
X-Gm-Message-State: AOAM533+gaJB7QxelBMry/GD1CkIbk6PqYGvw4U4095XdvOccni11CUo
        dtp3gOHyTOAly0n38v9TnJGrIOf0wlg=
X-Google-Smtp-Source: ABdhPJxUE0hLI/XZbPhna3Y7EPcNTB74HLX3ZT9q3MaeE2SrNUahlWeiMY1G5OfHIrRYJUt7m42Ckw==
X-Received: by 2002:a05:6512:3e16:b0:473:b70b:8bfa with SMTP id i22-20020a0565123e1600b00473b70b8bfamr13760905lfv.559.1652128830961;
        Mon, 09 May 2022 13:40:30 -0700 (PDT)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b0047255d21121sm2051961lfi.80.2022.05.09.13.40.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:40:30 -0700 (PDT)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, alexandru.elisei@arm.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v3 kvmtool 4/6] virtio: Sanitize config accesses
Date:   Mon,  9 May 2022 23:39:38 +0300
Message-Id: <20220509203940.754644-5-martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220509203940.754644-1-martin.b.radev@gmail.com>
References: <20220509203940.754644-1-martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The handling of VIRTIO_PCI_O_CONFIG is prone to buffer access overflows.
This patch sanitizes this operation by using the newly added virtio op
get_config_size. Any access which goes beyond the config structure's
size is prevented and a failure is returned.

Additionally, PCI accesses which span more than a single byte are prevented
and a warning is printed because the implementation does not currently
support the behavior correctly.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/virtio-9p.h |  1 +
 include/kvm/virtio.h    |  1 +
 virtio/9p.c             | 25 ++++++++++++++++++++-----
 virtio/balloon.c        |  8 ++++++++
 virtio/blk.c            |  8 ++++++++
 virtio/console.c        |  8 ++++++++
 virtio/mmio.c           | 18 ++++++++++++++----
 virtio/net.c            |  8 ++++++++
 virtio/pci.c            | 29 +++++++++++++++++++++++++++++
 virtio/rng.c            |  6 ++++++
 virtio/scsi.c           |  8 ++++++++
 virtio/vsock.c          |  8 ++++++++
 12 files changed, 119 insertions(+), 9 deletions(-)

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
index b78f2b3..57cd6d0 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1375,6 +1375,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(p9dev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct p9_dev *p9dev = dev;
+
+	return p9dev->config_size;
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_9P_MOUNT_TAG;
@@ -1469,6 +1476,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 struct virtio_ops p9_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
@@ -1568,7 +1576,9 @@ virtio_dev_init(virtio_9p__init);
 int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 {
 	struct p9_dev *p9dev;
-	int err = 0;
+	size_t tag_length;
+	size_t config_size;
+	int err;
 
 	p9dev = calloc(1, sizeof(*p9dev));
 	if (!p9dev)
@@ -1577,29 +1587,34 @@ int virtio_9p__register(struct kvm *kvm, const char *root, const char *tag_name)
 	if (!tag_name)
 		tag_name = VIRTIO_9P_DEFAULT_TAG;
 
-	p9dev->config = calloc(1, sizeof(*p9dev->config) + strlen(tag_name) + 1);
+	tag_length = strlen(tag_name);
+	/* The tag_name zero byte is intentionally excluded */
+	config_size = sizeof(*p9dev->config) + tag_length;
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
+	p9dev->config->tag_len = tag_length;
 	if (p9dev->config->tag_len > MAX_TAG_LEN) {
 		err = -EINVAL;
 		goto free_p9dev_config;
 	}
 
-	memcpy(&p9dev->config->tag, tag_name, strlen(tag_name));
+	memcpy(&p9dev->config->tag, tag_name, tag_length);
 
 	list_add(&p9dev->list, &devs);
 
 	if (compat_id == -1)
 		compat_id = virtio_compat_add_message("virtio-9p", "CONFIG_NET_9P_VIRTIO");
 
-	return err;
+	return 0;
 
 free_p9dev_config:
 	free(p9dev->config);
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 8e8803f..5bcd6ab 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -181,6 +181,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&bdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct bln_dev *bdev = dev;
+
+	return sizeof(bdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1 << VIRTIO_BALLOON_F_STATS_VQ;
@@ -251,6 +258,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 struct virtio_ops bln_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/blk.c b/virtio/blk.c
index 4d02d10..af71c0c 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -146,6 +146,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&bdev->blk_config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct blk_dev *bdev = dev;
+
+	return sizeof(bdev->blk_config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	struct blk_dev *bdev = dev;
@@ -291,6 +298,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops blk_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/console.c b/virtio/console.c
index e0b98df..dae6034 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -121,6 +121,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&cdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct con_dev *cdev = dev;
+
+	return sizeof(cdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 0;
@@ -216,6 +223,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops con_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 979fa8c..5ff2a5b 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -103,6 +103,8 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 					u8 is_write, struct virtio_device *vdev)
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
+	u8 *config;
+	size_t config_size;
 	u32 i;
 
 	/* Check for wrap-around and zero length. */
@@ -111,13 +113,21 @@ static void virtio_mmio_device_specific(struct kvm_cpu *vcpu,
 		return;
 	}
 
+	config = vdev->ops->get_config(vmmio->kvm, vmmio->dev);
+	config_size = vdev->ops->get_config_size(vmmio->kvm, vmmio->dev);
+
+	/* Prevent invalid accesses which go beyond the config */
+	if (config_size < addr + len) {
+		WARN_ONCE(1, "Offset (%llu) Length (%u) goes beyond config size (%zu).\n",
+			addr, len, config_size);
+		return;
+	}
+
 	for (i = 0; i < len; i++) {
 		if (is_write)
-			vdev->ops->get_config(vmmio->kvm, vmmio->dev)[addr + i] =
-					      *(u8 *)data + i;
+			config[addr + i] = *(u8 *)data + i;
 		else
-			data[i] = vdev->ops->get_config(vmmio->kvm,
-							vmmio->dev)[addr + i];
+			data[i] = config[addr + i];
 	}
 }
 
diff --git a/virtio/net.c b/virtio/net.c
index 1ee3c19..ec5dc1f 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -480,6 +480,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&ndev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct net_dev *ndev = dev;
+
+	return sizeof(ndev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	u32 features;
@@ -757,6 +764,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops net_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.get_vq_count		= get_vq_count,
diff --git a/virtio/pci.c b/virtio/pci.c
index bcb205a..050cfea 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -136,7 +136,21 @@ static bool virtio_pci__specific_data_in(struct kvm *kvm, struct virtio_device *
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
 		u8 cfg;
+		size_t config_size;
+
+		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
+		if (config_offset + size > config_size) {
+			/* Access goes beyond the config size, so return failure. */
+			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
+				config_offset, config_size);
+			return false;
+		}
 
+		/* TODO: Handle access lengths beyond one byte */
+		if (size != 1) {
+			WARN_ONCE(1, "Size (%u) not supported\n", size);
+			return false;
+		}
 		cfg = vdev->ops->get_config(kvm, vpci->dev)[config_offset];
 		ioport__write8(data, cfg);
 		return true;
@@ -276,6 +290,21 @@ static bool virtio_pci__specific_data_out(struct kvm *kvm, struct virtio_device
 
 		return true;
 	} else if (type == VIRTIO_PCI_O_CONFIG) {
+		size_t config_size;
+
+		config_size = vdev->ops->get_config_size(kvm, vpci->dev);
+		if (config_offset + size > config_size) {
+			/* Access goes beyond the config size, so return failure. */
+			WARN_ONCE(1, "Config access offset (%u) is beyond config size (%zu)\n",
+				config_offset, config_size);
+			return false;
+		}
+
+		/* TODO: Handle access lengths beyond one byte */
+		if (size != 1) {
+			WARN_ONCE(1, "Size (%u) not supported\n", size);
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
index 16a86cb..8f1c348 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -38,6 +38,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&sdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct scsi_dev *sdev = dev;
+
+	return sizeof(sdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return	1UL << VIRTIO_RING_F_EVENT_IDX |
@@ -176,6 +183,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops scsi_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 5b99838..34397b6 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -41,6 +41,13 @@ static u8 *get_config(struct kvm *kvm, void *dev)
 	return ((u8 *)(&vdev->config));
 }
 
+static size_t get_config_size(struct kvm *kvm, void *dev)
+{
+	struct vsock_dev *vdev = dev;
+
+	return sizeof(vdev->config);
+}
+
 static u32 get_host_features(struct kvm *kvm, void *dev)
 {
 	return 1UL << VIRTIO_RING_F_EVENT_IDX
@@ -204,6 +211,7 @@ static int get_vq_count(struct kvm *kvm, void *dev)
 
 static struct virtio_ops vsock_dev_virtio_ops = {
 	.get_config		= get_config,
+	.get_config_size	= get_config_size,
 	.get_host_features	= get_host_features,
 	.set_guest_features	= set_guest_features,
 	.init_vq		= init_vq,
-- 
2.25.1

