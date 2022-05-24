Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF36532CEA
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 17:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238737AbiEXPGf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 11:06:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238643AbiEXPGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 11:06:31 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C329BF77
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 08:06:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0014ED1;
        Tue, 24 May 2022 08:06:19 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E1B83F70D;
        Tue, 24 May 2022 08:06:18 -0700 (PDT)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Keir Fraser <keirf@google.com>
Subject: [PATCH kvmtool 1/4] update virtio_mmio.h
Date:   Tue, 24 May 2022 16:06:08 +0100
Message-Id: <20220524150611.523910-2-andre.przywara@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220524150611.523910-1-andre.przywara@arm.com>
References: <20220524150611.523910-1-andre.przywara@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

At the time we pulled in virtio_mmio.h from the kernel tree (commit
a08bb43a0c37c "kvmtool: Copy Linux' up-to-date virtio headers"), this was
not an official UAPI header file, so wasn't stable and was not shipped
with distributions.
This has changed with Linux commit 51be7a9a261c ("virtio_mmio: expose
header to userspace"), so we can now use that file officially.
However before that the name of some symbols have changed, so we have to
adjust their usage in our source.

This pulls in virtio_mmio.h from Linux v5.18.0.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/linux/virtio_mmio.h | 55 ++++++++++++++++++++++++++++++++-----
 virtio/mmio.c               |  8 +++---
 2 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/include/linux/virtio_mmio.h b/include/linux/virtio_mmio.h
index 5c7b6f0d..0650f91b 100644
--- a/include/linux/virtio_mmio.h
+++ b/include/linux/virtio_mmio.h
@@ -51,23 +51,29 @@
 /* Virtio vendor ID - Read Only */
 #define VIRTIO_MMIO_VENDOR_ID		0x00c
 
-/* Bitmask of the features supported by the host
+/* Bitmask of the features supported by the device (host)
  * (32 bits per set) - Read Only */
-#define VIRTIO_MMIO_HOST_FEATURES	0x010
+#define VIRTIO_MMIO_DEVICE_FEATURES	0x010
 
-/* Host features set selector - Write Only */
-#define VIRTIO_MMIO_HOST_FEATURES_SEL	0x014
+/* Device (host) features set selector - Write Only */
+#define VIRTIO_MMIO_DEVICE_FEATURES_SEL	0x014
 
-/* Bitmask of features activated by the guest
+/* Bitmask of features activated by the driver (guest)
  * (32 bits per set) - Write Only */
-#define VIRTIO_MMIO_GUEST_FEATURES	0x020
+#define VIRTIO_MMIO_DRIVER_FEATURES	0x020
 
 /* Activated features set selector - Write Only */
-#define VIRTIO_MMIO_GUEST_FEATURES_SEL	0x024
+#define VIRTIO_MMIO_DRIVER_FEATURES_SEL	0x024
+
+
+#ifndef VIRTIO_MMIO_NO_LEGACY /* LEGACY DEVICES ONLY! */
 
 /* Guest's memory page size in bytes - Write Only */
 #define VIRTIO_MMIO_GUEST_PAGE_SIZE	0x028
 
+#endif
+
+
 /* Queue selector - Write Only */
 #define VIRTIO_MMIO_QUEUE_SEL		0x030
 
@@ -77,12 +83,21 @@
 /* Queue size for the currently selected queue - Write Only */
 #define VIRTIO_MMIO_QUEUE_NUM		0x038
 
+
+#ifndef VIRTIO_MMIO_NO_LEGACY /* LEGACY DEVICES ONLY! */
+
 /* Used Ring alignment for the currently selected queue - Write Only */
 #define VIRTIO_MMIO_QUEUE_ALIGN		0x03c
 
 /* Guest's PFN for the currently selected queue - Read Write */
 #define VIRTIO_MMIO_QUEUE_PFN		0x040
 
+#endif
+
+
+/* Ready bit for the currently selected queue - Read Write */
+#define VIRTIO_MMIO_QUEUE_READY		0x044
+
 /* Queue notifier - Write Only */
 #define VIRTIO_MMIO_QUEUE_NOTIFY	0x050
 
@@ -95,6 +110,32 @@
 /* Device status register - Read Write */
 #define VIRTIO_MMIO_STATUS		0x070
 
+/* Selected queue's Descriptor Table address, 64 bits in two halves */
+#define VIRTIO_MMIO_QUEUE_DESC_LOW	0x080
+#define VIRTIO_MMIO_QUEUE_DESC_HIGH	0x084
+
+/* Selected queue's Available Ring address, 64 bits in two halves */
+#define VIRTIO_MMIO_QUEUE_AVAIL_LOW	0x090
+#define VIRTIO_MMIO_QUEUE_AVAIL_HIGH	0x094
+
+/* Selected queue's Used Ring address, 64 bits in two halves */
+#define VIRTIO_MMIO_QUEUE_USED_LOW	0x0a0
+#define VIRTIO_MMIO_QUEUE_USED_HIGH	0x0a4
+
+/* Shared memory region id */
+#define VIRTIO_MMIO_SHM_SEL             0x0ac
+
+/* Shared memory region length, 64 bits in two halves */
+#define VIRTIO_MMIO_SHM_LEN_LOW         0x0b0
+#define VIRTIO_MMIO_SHM_LEN_HIGH        0x0b4
+
+/* Shared memory region base address, 64 bits in two halves */
+#define VIRTIO_MMIO_SHM_BASE_LOW        0x0b8
+#define VIRTIO_MMIO_SHM_BASE_HIGH       0x0bc
+
+/* Configuration atomicity value */
+#define VIRTIO_MMIO_CONFIG_GENERATION	0x0fc
+
 /* The config space is defined by each driver as
  * the per-driver configuration space - Read Write */
 #define VIRTIO_MMIO_CONFIG		0x100
diff --git a/virtio/mmio.c b/virtio/mmio.c
index d08da1eb..3782d55a 100644
--- a/virtio/mmio.c
+++ b/virtio/mmio.c
@@ -142,7 +142,7 @@ static void virtio_mmio_config_in(struct kvm_cpu *vcpu,
 	case VIRTIO_MMIO_INTERRUPT_STATUS:
 		ioport__write32(data, *(u32 *)(((void *)&vmmio->hdr) + addr));
 		break;
-	case VIRTIO_MMIO_HOST_FEATURES:
+	case VIRTIO_MMIO_DEVICE_FEATURES:
 		if (vmmio->hdr.host_features_sel == 0)
 			val = vdev->ops->get_host_features(vmmio->kvm,
 							   vmmio->dev);
@@ -173,8 +173,8 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 	u32 val = 0;
 
 	switch (addr) {
-	case VIRTIO_MMIO_HOST_FEATURES_SEL:
-	case VIRTIO_MMIO_GUEST_FEATURES_SEL:
+	case VIRTIO_MMIO_DEVICE_FEATURES_SEL:
+	case VIRTIO_MMIO_DRIVER_FEATURES_SEL:
 		val = ioport__read32(data);
 		*(u32 *)(((void *)&vmmio->hdr) + addr) = val;
 		break;
@@ -193,7 +193,7 @@ static void virtio_mmio_config_out(struct kvm_cpu *vcpu,
 			vdev->endian = kvm_cpu__get_endianness(vcpu);
 		virtio_notify_status(kvm, vdev, vmmio->dev, vmmio->hdr.status);
 		break;
-	case VIRTIO_MMIO_GUEST_FEATURES:
+	case VIRTIO_MMIO_DRIVER_FEATURES:
 		if (vmmio->hdr.guest_features_sel == 0) {
 			val = ioport__read32(data);
 			virtio_set_guest_features(vmmio->kvm, vdev,
-- 
2.25.1

