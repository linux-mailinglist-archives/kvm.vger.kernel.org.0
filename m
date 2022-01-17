Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CCA44911A4
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 23:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243588AbiAQWMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 17:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243583AbiAQWMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 17:12:32 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12766C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:32 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id s30so62998539lfo.7
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yq7ev1fQq1ZyePQoTSXJdEIub6ug3aOpaAUlJSMF/0g=;
        b=es3/SAUQ2W8NuNFdcJXdrnIFOJqwFw/W/XQGWC9P/fuIY9B3MABhNjYtAkPDU0TNbe
         kjusY2ArY6RiXmuZbvOpqRFnN8IF+pfGVzj2GrnAbfH86Bnpz/B0DPqHUhEFdS8DtLKt
         BXwFL9/8ZPoIO96HbWPJH+LAVDfJeR1Inpz5HuJkkyCOU2z5Z8SHqPIynPYYNjxQflyd
         moBRonLycLDZ48lo17I8ezjsy0sEWT02u11l5LHg4sTOyvFdLlHozZioF8ibquSdl6Vn
         Sp6FDaxU/El/Autl0ngmCrf+U4tlFaOArlBdhx0ORKqEsKwWWv1Eq+gnPdqdsjBoIqh3
         /u7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yq7ev1fQq1ZyePQoTSXJdEIub6ug3aOpaAUlJSMF/0g=;
        b=XhzfU3/uXy4Hw8J/wEFrINlpM4YVlaPrTTULjLYW4CrYnXlYxp9qYYarH6tHwujswV
         NB7J1OFDICN1z9huxz67j92k4szWmMdsVmRyRNyWkP+NysAPFmDu0RpUt0SdRkOTviyG
         fwSUhebvyEwr6zr6SiCEupowi7r8vPTM/SEyrtiEbENPhhmhR7lbOiLLla8PLwC4XS+4
         oLWBLueil72ablk0hrdy2qBC+6kmnNdp4AkE/xnl88I3KYC6tSkIpkcOW4VGeJ02EDTg
         0xVnzVZWVKuSdC+pyM0AW5J91T+Atjos11glMkCkInuLQUIVO+yM/TpclHi8+zaQx4I/
         ZFGA==
X-Gm-Message-State: AOAM531/Sg6uP5B6Ubbthm9cjj6yJjtlw+MF+Xt0gZrqOejCq0RAxdeX
        A9UUF2l154OPEdtu/JXKmhftlw30j2plhQ==
X-Google-Smtp-Source: ABdhPJxjAOA+hX+dVd3Ht/Xl3u/KTi6fsAq2AH7fDxCws6dr32De0MVYFJNbE7WMOnAdfrfp7rSsIA==
X-Received: by 2002:a2e:995:: with SMTP id 143mr17380178ljj.411.1642457550243;
        Mon, 17 Jan 2022 14:12:30 -0800 (PST)
Received: from localhost.localdomain (88-115-234-133.elisa-laajakaista.fi. [88.115.234.133])
        by smtp.gmail.com with ESMTPSA id c32sm1458094ljr.107.2022.01.17.14.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:12:29 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 2/5] virtio: Check for overflows in QUEUE_NOTIFY and QUEUE_SEL
Date:   Tue, 18 Jan 2022 00:12:00 +0200
Message-Id: <bd5048ca2de1c548fa599d12fea0fa21397688af.1642457047.git.martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch checks for overflows in QUEUE_NOTIFY and QUEUE_SEL in
the PCI and MMIO operation handling paths. Further, the return
value type of get_vq_count is changed from int to u32 since negative
doesn't carry any semantic meaning.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 include/kvm/virtio.h |  2 +-
 virtio/9p.c          |  2 +-
 virtio/balloon.c     |  2 +-
 virtio/blk.c         |  2 +-
 virtio/console.c     |  2 +-
 virtio/mmio.c        | 25 ++++++++++++++++++++++---
 virtio/net.c         |  2 +-
 virtio/pci.c         | 21 ++++++++++++++++++---
 virtio/rng.c         |  2 +-
 virtio/scsi.c        |  2 +-
 virtio/vsock.c       |  2 +-
 11 files changed, 49 insertions(+), 15 deletions(-)

diff --git a/include/kvm/virtio.h b/include/kvm/virtio.h
index 3880e74..40f2a6d 100644
--- a/include/kvm/virtio.h
+++ b/include/kvm/virtio.h
@@ -187,7 +187,7 @@ struct virtio_ops {
 	size_t (*get_config_size)(struct kvm *kvm, void *dev);
 	u32 (*get_host_features)(struct kvm *kvm, void *dev);
 	void (*set_guest_features)(struct kvm *kvm, void *dev, u32 features);
-	int (*get_vq_count)(struct kvm *kvm, void *dev);
+	u32 (*get_vq_count)(struct kvm *kvm, void *dev);
 	int (*init_vq)(struct kvm *kvm, void *dev, u32 vq, u32 page_size,
 		       u32 align, u32 pfn);
 	void (*exit_vq)(struct kvm *kvm, void *dev, u32 vq);
diff --git a/virtio/9p.c b/virtio/9p.c
index 89bec5e..8f1fc1f 100644
--- a/virtio/9p.c
+++ b/virtio/9p.c
@@ -1468,7 +1468,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/balloon.c b/virtio/balloon.c
index 233a3a5..de3882e 100644
--- a/virtio/balloon.c
+++ b/virtio/balloon.c
@@ -249,7 +249,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/blk.c b/virtio/blk.c
index 9164b51..46918a4 100644
--- a/virtio/blk.c
+++ b/virtio/blk.c
@@ -289,7 +289,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/console.c b/virtio/console.c
index 00bafa2..84466d0 100644
--- a/virtio/console.c
+++ b/virtio/console.c
@@ -214,7 +214,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VIRTIO_CONSOLE_NUM_QUEUES;
 }
diff --git a/virtio/mmio.c b/virtio/mmio.c
index 32bba17..fd9a411 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -171,14 +171,26 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 	struct virtio_mmio *vmmio = vdev->virtio;
 	struct kvm *kvm = vmmio->kvm;
 	u32 val = 0;
+	u32 vq_count = 0;
+	vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
 
 	switch (addr) {
 	case VIRTIO_MMIO_HOST_FEATURES_SEL:
 	case VIRTIO_MMIO_GUEST_FEATURES_SEL:
-	case VIRTIO_MMIO_QUEUE_SEL:
 		val = ioport__read32(data);
 		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
 		break;
+	case VIRTIO_MMIO_QUEUE_SEL:
+		{
+			val = ioport__read32(data);
+			if (val >= vq_count) {
+				pr_warning("QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+					val, vq_count);
+				break;
+			}
+			*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
+			break;
+		}
 	case VIRTIO_MMIO_STATUS:
 		vmmio->hdr.status = ioport__read32(data);
 		if (!vmmio->hdr.status) /* Sample endianness on reset */
@@ -222,6 +234,11 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 		break;
 	case VIRTIO_MMIO_QUEUE_NOTIFY:
 		val = ioport__read32(data);
+		if (val > vq_count) {
+			pr_warning("QUEUE_NOTIFY value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			break;
+		}
 		vdev->ops->notify_vq(vmmio->kvm, vmmio->dev, val);
 		break;
 	case VIRTIO_MMIO_INTERRUPT_ACK:
@@ -341,10 +358,12 @@ int virtio_mmio_init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_mmio_reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	u32 vq;
 	struct virtio_mmio *vmmio = vdev->virtio;
+	u32 vq_count;
 
-	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vmmio->dev); vq++)
+	vq_count = vdev->ops->get_vq_count(kvm, vmmio->dev);
+	for (vq = 0; vq < vq_count; vq++)
 		virtio_mmio_exit_vq(kvm, vdev, vq);
 
 	return 0;
diff --git a/virtio/net.c b/virtio/net.c
index 75d9ae5..9a25bfa 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -753,7 +753,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	struct net_dev *ndev = dev;
 
diff --git a/virtio/pci.c b/virtio/pci.c
index 50fdaa4..60ae2cb 100644
--- a/virtio/pci.c
+++ b/virtio/pci.c
@@ -308,9 +308,11 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 	struct virtio_pci *vpci;
 	struct kvm *kvm;
 	u32 val;
+	u32 vq_count;
 
 	kvm = vcpu->kvm;
 	vpci = vdev->virtio;
+	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
 
 	switch (offset) {
 	case VIRTIO_PCI_GUEST_FEATURES:
@@ -330,10 +332,21 @@ static bool virtio_pci__data_out(struct kvm_cpu *vcpu, struct virtio_device *vde
 		}
 		break;
 	case VIRTIO_PCI_QUEUE_SEL:
-		vpci->queue_selector = ioport__read16(data);
+		val = ioport__read16(data);
+		if (val >= vq_count) {
+			pr_warning("QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
+		vpci->queue_selector = val;
 		break;
 	case VIRTIO_PCI_QUEUE_NOTIFY:
 		val = ioport__read16(data);
+		if (val >= vq_count) {
+			pr_warning("QUEUE_SEL value (%u) is larger than VQ count (%u)\n",
+				val, vq_count);
+			return false;
+		}
 		vdev->ops->notify_vq(kvm, vpci->dev, val);
 		break;
 	case VIRTIO_PCI_STATUS:
@@ -626,10 +639,12 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
 
 int virtio_pci__reset(struct kvm *kvm, struct virtio_device *vdev)
 {
-	int vq;
+	u32 vq;
 	struct virtio_pci *vpci = vdev->virtio;
+	u32 vq_count;
 
-	for (vq = 0; vq < vdev->ops->get_vq_count(kvm, vpci->dev); vq++)
+	vq_count = vdev->ops->get_vq_count(kvm, vpci->dev);
+	for (vq = 0; vq < vq_count; vq++)
 		virtio_pci_exit_vq(kvm, vdev, vq);
 
 	return 0;
diff --git a/virtio/rng.c b/virtio/rng.c
index c7835a0..d9b9e68 100644
--- a/virtio/rng.c
+++ b/virtio/rng.c
@@ -147,7 +147,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/scsi.c b/virtio/scsi.c
index 37418f8..cdf553d 100644
--- a/virtio/scsi.c
+++ b/virtio/scsi.c
@@ -174,7 +174,7 @@ static int set_size_vq(struct kvm *kvm, void *dev, u32 vq, int size)
 	return size;
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	return NUM_VIRT_QUEUES;
 }
diff --git a/virtio/vsock.c b/virtio/vsock.c
index 2df04d7..7d523df 100644
--- a/virtio/vsock.c
+++ b/virtio/vsock.c
@@ -202,7 +202,7 @@ static void notify_vq_gsi(struct kvm *kvm, void *dev, u32 vq, u32 gsi)
 		die_perror("VHOST_SET_VRING_CALL failed");
 }
 
-static int get_vq_count(struct kvm *kvm, void *dev)
+static u32 get_vq_count(struct kvm *kvm, void *dev)
 {
 	return VSOCK_VQ_MAX;
 }
-- 
2.25.1

