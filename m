Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFFC6E7AAC
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 15:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjDSN1s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 09:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232784AbjDSN1r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 09:27:47 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57915469A
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id o6-20020a05600c4fc600b003ef6e6754c5so1442395wmq.5
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 06:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681910864; x=1684502864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h3zoHmoW9qrNtTnR3VsgQ7FWQYUQLqEmc0mtF1/E1WY=;
        b=F/DprwDvywW/AQ7aZhge8nnu6bAuRdw85BZU0yLLzIdPgvREjnLHWqyMzvE+CqEbQD
         trYNJOfQNax6u14UnYxesDsPdm0nU/e/ZuK1yRdV56gqqCmqOjcKCFrWz+Iy8lZ/Tdke
         jb4ZC/hvvfHFD+u06peYv4IpivJIwZDFfc1p1ur2fZtNwgGDGySkqVbTZoIYid6kkdOY
         CN0gOg1zAZxBqkIkZogXL4PDooBxjtaUJKVvtN8gUDnIRSjN3egiw0hRHm/k9h0rrmwI
         EGVYPE41EPBymUQ4Wt92i1rhRbAF8ZaSbMdCz6Hqi9+izTzlMRwe0JD6CwvXnVBbuRW5
         lvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681910864; x=1684502864;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h3zoHmoW9qrNtTnR3VsgQ7FWQYUQLqEmc0mtF1/E1WY=;
        b=OYzQRt5/bOTsfeGjvSQtOlROlg5PB00aV7kFP29tmoQsn6QxI4QdPLNNuO/Q+qis4u
         9xyB9bY13El1t1SOFB8q8VLYbJqdbb6iSVu/8Wp7TnVYNJ6J0tEzWzbGK3MIMrplGqIZ
         us2RpiDJGrtg0YRckTMwPcrA47P9sPrAAJrSZZ74APQ64e7hpkzT2leb5B8IrP+XfSD2
         svrfoErEtTVnkopRk5STZLABV1ox9aInIdCX0GiRoH3upLRTh3Ycr8mymSn6ppjSkul6
         iBaW6WSwqQoDvz+H1t+tD+YpPxstHdwvB/NXkxd+2peKM61Cke2gdp/3MsvaG2X1FpWF
         JwkQ==
X-Gm-Message-State: AAQBX9caVzcp5BmcFkTuCpmSa0kVm/QPUs2XB4/QKm/f8CsJREU1yKkL
        5JKeBJbs4y6p8ot5SYug1gAZJ+T6FNdbjk/J9I4=
X-Google-Smtp-Source: AKy350YQbd+vOREgQGmpY2sbirpsOvUDvFGWsvX7nxv6nSF3QpKa3NadOW4jwbRDAMAj1AsJEWb/kQ==
X-Received: by 2002:a7b:c850:0:b0:3ee:96f0:ea31 with SMTP id c16-20020a7bc850000000b003ee96f0ea31mr17293584wml.18.1681910863805;
        Wed, 19 Apr 2023 06:27:43 -0700 (PDT)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id p8-20020a05600c358800b003f1738d0d13sm3497017wmq.1.2023.04.19.06.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:27:43 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     suzuki.poulose@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool 01/16] virtio: Factor vhost initialization
Date:   Wed, 19 Apr 2023 14:21:05 +0100
Message-Id: <20230419132119.124457-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230419132119.124457-1-jean-philippe@linaro.org>
References: <20230419132119.124457-1-jean-philippe@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move vhost owner and memory table setup to virtio/vhost.c.

This also fixes vsock and SCSI which did not support multiple memory
regions until now (vsock didn't allocate the right region size and would
trigger a buffer overflow).

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 Makefile             |  1 +
 include/kvm/virtio.h |  1 +
 virtio/net.c         | 29 +----------------------------
 virtio/scsi.c        | 21 +--------------------
 virtio/vhost.c       | 36 ++++++++++++++++++++++++++++++++++++
 virtio/vsock.c       | 29 ++---------------------------
 6 files changed, 42 insertions(+), 75 deletions(-)
 create mode 100644 virtio/vhost.c

diff --git a/Makefile b/Makefile
index ed2414bd..86e19339 100644
--- a/Makefile
+++ b/Makefile
@@ -76,6 +76,7 @@ OBJS	+= virtio/pci.o
 OBJS	+= virtio/vsock.o
 OBJS	+= virtio/pci-legacy.o
 OBJS	+= virtio/pci-modern.o
+OBJS	+= virtio/vhost.o
 OBJS	+= disk/blk.o
 OBJS	+= disk/qcow.o
 OBJS	+= disk/raw.o
diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 0e8c7a67..cd72bf11 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -247,6 +247,7 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 			       void *dev, u64 features);
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
+void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index 8749ebfe..6b44754f 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -791,40 +791,13 @@ static struct virtio_ops net_dev_virtio_ops = {
 
 static void virtio_net__vhost_init(struct kvm *kvm, struct net_dev *ndev)
 {
-	struct kvm_mem_bank *bank;
-	struct vhost_memory *mem;
-	int r, i;
-
 	ndev->vhost_fd = open("/dev/vhost-net", O_RDWR);
 	if (ndev->vhost_fd < 0)
 		die_perror("Failed openning vhost-net device");
 
-	mem = calloc(1, sizeof(*mem) + kvm->mem_slots * sizeof(struct vhost_memory_region));
-	if (mem == NULL)
-		die("Failed allocating memory for vhost memory map");
-
-	i = 0;
-	list_for_each_entry(bank, &kvm->mem_banks, list) {
-		mem->regions[i] = (struct vhost_memory_region) {
-			.guest_phys_addr = bank->guest_phys_addr,
-			.memory_size	 = bank->size,
-			.userspace_addr	 = (unsigned long)bank->host_addr,
-		};
-		i++;
-	}
-	mem->nregions = i;
-
-	r = ioctl(ndev->vhost_fd, VHOST_SET_OWNER);
-	if (r != 0)
-		die_perror("VHOST_SET_OWNER failed");
-
-	r = ioctl(ndev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
-	if (r != 0)
-		die_perror("VHOST_SET_MEM_TABLE failed");
+	virtio_vhost_init(kvm, ndev->vhost_fd);
 
 	ndev->vdev.use_vhost = true;
-
-	free(mem);
 }
 
 static inline void str_to_mac(const char *str, char *mac)
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 893dfe60..4dee24a0 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -203,7 +203,6 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 
 static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
 {
-	struct vhost_memory *mem;
 	u64 features;
 	int r;
 
@@ -211,20 +210,7 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
 	if (sdev->vhost_fd < 0)
 		die_perror("Failed openning vhost-scsi device");
 
-	mem = calloc(1, sizeof(*mem) + sizeof(struct vhost_memory_region));
-	if (mem == NULL)
-		die("Failed allocating memory for vhost memory map");
-
-	mem->nregions = 1;
-	mem->regions[0] = (struct vhost_memory_region) {
-		.guest_phys_addr	= 0,
-		.memory_size		= kvm->ram_size,
-		.userspace_addr		= (unsigned long)kvm->ram_start,
-	};
-
-	r = ioctl(sdev->vhost_fd, VHOST_SET_OWNER);
-	if (r != 0)
-		die_perror("VHOST_SET_OWNER failed");
+	virtio_vhost_init(kvm, sdev->vhost_fd);
 
 	r = ioctl(sdev->vhost_fd, VHOST_GET_FEATURES, &features);
 	if (r != 0)
@@ -233,13 +219,8 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
 	r = ioctl(sdev->vhost_fd, VHOST_SET_FEATURES, &features);
 	if (r != 0)
 		die_perror("VHOST_SET_FEATURES failed");
-	r = ioctl(sdev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
-	if (r != 0)
-		die_perror("VHOST_SET_MEM_TABLE failed");
 
 	sdev->vdev.use_vhost = true;
-
-	free(mem);
 }
 
 
diff --git a/virtio/vhost.c b/virtio/vhost.c
new file mode 100644
index 00000000..f9f72f51
--- /dev/null
+++ b/virtio/vhost.c
@@ -0,0 +1,36 @@
+#include <linux/kvm.h>
+#include <linux/vhost.h>
+#include <linux/list.h>
+#include "kvm/virtio.h"
+
+void virtio_vhost_init(struct kvm *kvm, int vhost_fd)
+{
+	struct kvm_mem_bank *bank;
+	struct vhost_memory *mem;
+	int i = 0, r;
+
+	mem = calloc(1, sizeof(*mem) +
+		     kvm->mem_slots * sizeof(struct vhost_memory_region));
+	if (mem == NULL)
+		die("Failed allocating memory for vhost memory map");
+
+	list_for_each_entry(bank, &kvm->mem_banks, list) {
+		mem->regions[i] = (struct vhost_memory_region) {
+			.guest_phys_addr = bank->guest_phys_addr,
+			.memory_size	 = bank->size,
+			.userspace_addr	 = (unsigned long)bank->host_addr,
+		};
+		i++;
+	}
+	mem->nregions = i;
+
+	r = ioctl(vhost_fd, VHOST_SET_OWNER);
+	if (r != 0)
+		die_perror("VHOST_SET_OWNER failed");
+
+	r = ioctl(vhost_fd, VHOST_SET_MEM_TABLE, mem);
+	if (r != 0)
+		die_perror("VHOST_SET_MEM_TABLE failed");
+
+	free(mem);
+}
diff --git a/virtio/vsock.c b/virtio/vsock.c
index a108e637..4b8be8d7 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -218,37 +218,14 @@ static struct virtio_ops vsock_dev_virtio_ops = {
 
 static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
 {
-	struct kvm_mem_bank *bank;
-	struct vhost_memory *mem;
 	u64 features;
-	int r, i;
+	int r;
 
 	vdev->vhost_fd = open("/dev/vhost-vsock", O_RDWR);
 	if (vdev->vhost_fd < 0)
 		die_perror("Failed opening vhost-vsock device");
 
-	mem = calloc(1, sizeof(*mem) + sizeof(struct vhost_memory_region));
-	if (mem == NULL)
-		die("Failed allocating memory for vhost memory map");
-
-	i = 0;
-	list_for_each_entry(bank, &kvm->mem_banks, list) {
-		mem->regions[i] = (struct vhost_memory_region) {
-			.guest_phys_addr = bank->guest_phys_addr,
-			.memory_size	 = bank->size,
-			.userspace_addr	 = (unsigned long)bank->host_addr,
-		};
-		i++;
-	}
-	mem->nregions = i;
-
-	r = ioctl(vdev->vhost_fd, VHOST_SET_OWNER);
-	if (r != 0)
-		die_perror("VHOST_SET_OWNER failed");
-
-	r = ioctl(vdev->vhost_fd, VHOST_SET_MEM_TABLE, mem);
-	if (r != 0)
-		die_perror("VHOST_SET_MEM_TABLE failed");
+	virtio_vhost_init(kvm, vdev->vhost_fd);
 
 	r = ioctl(vdev->vhost_fd, VHOST_GET_FEATURES, &features);
 	if (r != 0)
@@ -263,8 +240,6 @@ static void virtio_vhost_vsock_init(struct kvm *kvm, struct vsock_dev *vdev)
 		die_perror("VHOST_VSOCK_SET_GUEST_CID failed");
 
 	vdev->vdev.use_vhost = true;
-
-	free(mem);
 }
 
 static int virtio_vsock_init_one(struct kvm *kvm, u64 guest_cid)
-- 
2.40.0

