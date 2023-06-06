Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EF972439D
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 15:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbjFFNFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 09:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbjFFNFQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 09:05:16 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BDA118
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 06:05:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30af56f5f52so5243091f8f.1
        for <kvm@vger.kernel.org>; Tue, 06 Jun 2023 06:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686056713; x=1688648713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h/ixVhafCrLnwDcDpSyg5o/+ZmCnuYZQQzXZfM2c9ig=;
        b=Q3ykR9M1bjftPS/DYKcMsqfRnbYmL4jNnUTQHHVcMxg6Sz+EljZRiifVkoNTf+TzUy
         pOQ1YjlKOqOuGKHjYwsODK+kaISOSGulmKWRwENUTMUvG9hGSWngNn++9Q5E9wCNhP7J
         GNu4YS0g2ugDW27TBzWOa3FEMlOH87lakB6SuJcP0rLycymjDC/2W9CbAQC9jgXm/qrH
         SGjWXM9J+XZKMYV/MyOhvFIrIweLj9kJsRWmRzzhLs3smWePKMdneoFOvYMFV0fRs8RB
         yPnPMFZkp0fopKgWZi33XgcRoncWI3nHaBFokKma1CBPldjKduIVWWWnfVS2qzRoqLeL
         z+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686056713; x=1688648713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h/ixVhafCrLnwDcDpSyg5o/+ZmCnuYZQQzXZfM2c9ig=;
        b=i/55WD7jTAuk/OKMtxkxw27VgfY8iQI26z44DGl5UtJ1fOWjEAAZRVUV++GF0j8GE7
         FWi06yI4kRHajIH9LCO3gPupDRTBXdscE3YehMOnWnbNL4oo7s2dYjJTtUru4hlXBN/e
         MZjvJuvx+AoeF7/48vFkb2W9HYKIzxhwRWBlHZxXi78L0zohphSZpiJYr77OTGy0XK0B
         zclEWGVSwxWrLWf0ASCi11+CS6LVqTwwa+2veZBa4orcnFj5yLQWDHLeXUSP4YRM0PsW
         /ad6/41UzSj7/GzEpuwBfFsj0HcX5DKrGsQMNSVaT8uu/9vqQLGM6mAsrwgwW/f18yul
         V+fg==
X-Gm-Message-State: AC+VfDzuOgVVMZCtydU+G4/hv/w86oKUa+vzEBbPnLN0jhNS5MPEnttS
        9irTqOeeF9nja92bjD8bKTsCieR7FllpBBmbCZcMyQ==
X-Google-Smtp-Source: ACHHUZ6bw6WWzl/ocKpYiCMiuwJHztUfvRmJiLzDzffEL3c6MxYSBfVkaR7cbKUycyBj6sEClKor4g==
X-Received: by 2002:a05:6000:1209:b0:2dd:11b8:8aa9 with SMTP id e9-20020a056000120900b002dd11b88aa9mr1700889wrx.15.1686056712874;
        Tue, 06 Jun 2023 06:05:12 -0700 (PDT)
Received: from localhost.localdomain (5750a5b3.skybroadband.com. [87.80.165.179])
        by smtp.gmail.com with ESMTPSA id h14-20020a5d504e000000b00300aee6c9cesm12636125wrt.20.2023.06.06.06.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 06:05:12 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     kvm@vger.kernel.org, will@kernel.org
Cc:     andre.przywara@arm.com,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [PATCH kvmtool v2 01/17] virtio: Factor vhost initialization
Date:   Tue,  6 Jun 2023 14:04:10 +0100
Message-Id: <20230606130426.978945-2-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230606130426.978945-1-jean-philippe@linaro.org>
References: <20230606130426.978945-1-jean-philippe@linaro.org>
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

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
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
index a8bbaf21..4cc2e3d2 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -258,6 +258,7 @@ void virtio_set_guest_features(struct kvm *kvm, struct virtio_device *vdev,
 			       void *dev, u64 features);
 void virtio_notify_status(struct kvm *kvm, struct virtio_device *vdev,
 			  void *dev, u8 status);
+void virtio_vhost_init(struct kvm *kvm, int vhost_fd);
 
 int virtio_transport_parser(const struct option *opt, const char *arg, int unset);
 
diff --git a/virtio/net.c b/virtio/net.c
index bc20ce09..65fdbd17 100644
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
index 9af8a65c..621a8334 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -201,7 +201,6 @@ static struct virtio_ops scsi_dev_virtio_ops = {
 
 static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
 {
-	struct vhost_memory *mem;
 	u64 features;
 	int r;
 
@@ -209,20 +208,7 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
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
@@ -231,13 +217,8 @@ static void virtio_scsi_vhost_init(struct kvm *kvm, struct scsi_dev *sdev)
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
2.40.1

