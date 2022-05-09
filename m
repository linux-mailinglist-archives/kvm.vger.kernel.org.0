Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B41520613
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 22:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiEIUov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 16:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiEIUob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 16:44:31 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D830E285AF7
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 13:40:33 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id d15so17362320lfk.5
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 13:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zgvumxJQGPH2xtoBPL1ScsQa16uL/b+EJikjz9MD1Js=;
        b=amiyuenF6R+JBjEbhimIJlFHlgLiUXUIrL2QuFUYPS6sZa/BZnuO7eB9p3HN8C4IO9
         2U6+DwTLXUGYr8GySvBwQtrPxWutdiE4KnV+/PwVO+9v8W+sEefsO/afd3829V41dYSj
         60D9x4/8mQL4kNOcOmeHIxZmYyTjIe27kCz3IMwJYRp7LtFZ8R5B/V7zW5G60X0RyF56
         ENdUE7WN5MAxRPlaForctliNGIFF6/sA+L3hnIjxjKZi+p7UUzhX2s1bItu6jRgC1y1W
         y9LPbj5BnuZfUoNeq4tEGPSU/H8XgFS0RFjMJNheQm2/d7FhiwmKxAsmIQGEMRTi/Fim
         FaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zgvumxJQGPH2xtoBPL1ScsQa16uL/b+EJikjz9MD1Js=;
        b=CV85mE+KAnjhwyEiLQIoBp6VjRH+mqyhmZ8Y9G7Iqao1W9Aw9rdSSKPZfqJ2aKY88J
         Kw0HfEjchA+DELP+DhL4qpOtQXhZHyjoSHnhti8i38FK5jKrJ3Re6Td5v2gXFOr1stz1
         95MpEzs8hAu/8TD68HtAEX6iWdghSVjQxdJjM611mcMVese1IpxG3vcXbOS4FJpiiaJZ
         Ea1nhhUXiQhN/JnrFwqVdb3156edKhNz9ZQ+0w2F6j0EEn5xafX4bDHewGpBk3jlFpJI
         LKvffHVM0jkpzBmZpOXT/3/7dNpJXU166uygL9QA5jKSid5rrgEN+sy3aPIO9rrGSRfa
         8GdQ==
X-Gm-Message-State: AOAM53179evEMsaV0ojBF6fOYHRPBDkZNBW+f7ex8MtKAvmp9pjIVEC2
        PF6Jw4vWeZugP6tNIQw6dVuC2TFNzhU=
X-Google-Smtp-Source: ABdhPJzYHFCP/ak//cf0snBU9EO/l0ujIy/Q/4XFcZA0/8iDMqoiJ38Eg1i9OuE1GOBefjZH8pQ3zA==
X-Received: by 2002:a19:4343:0:b0:474:d7a:634d with SMTP id m3-20020a194343000000b004740d7a634dmr10277782lfj.168.1652128832046;
        Mon, 09 May 2022 13:40:32 -0700 (PDT)
Received: from localhost.localdomain (88-115-234-153.elisa-laajakaista.fi. [88.115.234.153])
        by smtp.gmail.com with ESMTPSA id o25-20020ac24959000000b0047255d21121sm2051961lfi.80.2022.05.09.13.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 13:40:31 -0700 (PDT)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, alexandru.elisei@arm.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH v3 kvmtool 5/6] virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
Date:   Mon,  9 May 2022 23:39:39 +0300
Message-Id: <20220509203940.754644-6-martin.b.radev@gmail.com>
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

This patch checks for overflows in QUEUE_NOTIFY and QUEUE_SEL in
the PCI and MMIO operation handling paths. Further, the return
value type of get_vq_count is changed from int to uint since negative
doesn't carry any semantic meaning.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/virtio.h |  2 +-
 virtio/9p.c          |  2 +-
 virtio/balloon.c     |  2 +-
 virtio/blk.c         |  2 +-
 virtio/console.c     |  2 +-
 virtio/mmio.c        | 16 +++++++++++++++-
 virtio/net.c         |  2 +-
 virtio/pci.c         | 17 +++++++++++++++--
 virtio/rng.c         |  2 +-
 virtio/scsi.c        |  2 +-
 virtio/vsock.c       |  2 +-
 11 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 3880e74..ad274ac 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -187,7 +187,7 @@ struct virtio_ops {
 	size_t (*get_config_size)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
-	int (*get_vq_count)(struct kvm *kvm, void *dev);
+	unsigned int (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
 		       u32 align, u32 pfn);
 	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
diff --git a/virtio/9p.c b/virtio/9p.c
index 57cd6d0..7c9d792 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1469,7 +1469,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 5bcd6ab..450b36a 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -251,7 +251,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/blk.c b/virtio/blk.c
index af71c0c..46ee028 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -291,7 +291,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/console.c b/virtio/console.c
index dae6034..8315808 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -216,7 +216,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VIRTIO_CONSOLE_NUM_QUEUES;
 }
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 5ff2a5b..f2d8630 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -175,13 +175,22 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 {
 	struct virtio_mmio *vmmio = vdev->virtio;
 	struct kvm *kvm = vmmio->kvm;
+	unsigned int vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
 	u32 val = 0;
 
 	switch (addr) {
 	case VIRTIO_MMIO_HOST_FEATURES_SEL:
 	case VIRTIO_MMIO_GUEST_FEATURES_SEL:
+		val = ioport__read32(data);
+		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+		break;
 	case VIRTIO_MMIO_QUEUE_SEL:
 		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
 		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
 		break;
 	case VIRTIO_MMIO_STATUS:
@@ -227,6 +236,11 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 		break;
 	case VIRTIO_MMIO_QUEUE_NOTIFY:
 		val = ioport__read32(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
 		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
 		break;
 	case VIRTIO_MMIO_INTERRUPT_ACK:
@@ -346,7 +360,7 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	unsigned int vq;
 	struct virtio_mmio *vmmio = vdev->virtio;
 
 	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vmmio->dev); vq++)
diff --git a/virtio/net.c b/virtio/net.c
index ec5dc1f..67070d6 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -755,7 +755,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	struct net_dev *ndev = dev;
 
diff --git a/virtio/pci.c b/virtio/pci.c
index 050cfea..23831d5 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -320,9 +320,11 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 	struct virtio_pci *vpci;
 	struct kvm *kvm;
 	u32 val;
+	unsigned int vq_count;
 
 	kvm = vcpu->kvm;
 	vpci = vdev->virtio;
+	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
 
 	switch (offset) {
 	case VIRTIO_PCI_GUEST_FEATURES:
@@ -342,10 +344,21 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 		}
 		break;
 	case VIRTIO_PCI_QUEUE_SEL:
-		vpci->queue_selector = ioport__read16(data);
+		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
+		vpci->queue_selector = val;
 		break;
 	case VIRTIO_PCI_QUEUE_NOTIFY:
 		val = ioport__read16(data);
+		if (val >= vq_count) {
+			WARN_ONCE(1, "QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
 		vdev->ops->notify_vq(kvm, vpci->dev, val);
 		break;
 	case VIRTIO_PCI_STATUS:
@@ -638,7 +651,7 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	unsigned int vq;
 	struct virtio_pci *vpci = vdev->virtio;
 
 	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
diff --git a/virtio/rng.c b/virtio/rng.c
index c7835a0..75b682e 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -147,7 +147,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 8f1c348..60432cc 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -176,7 +176,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 34397b6..64b4e95 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -204,7 +204,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 		die_perror("VHOST_SET_VRING_CALL failed");
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static unsigned int get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VSOCK_VQ_MAX;
 }
-- 
2.25.1

