Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6728324848
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 02:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234024AbhBYBE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 20:04:29 -0500
Received: from foss.arm.com ([217.140.110.172]:58550 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235094AbhBYBCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 20:02:52 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 36C5A14FF;
        Wed, 24 Feb 2021 17:00:57 -0800 (PST)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE02D3F73B;
        Wed, 24 Feb 2021 17:00:55 -0800 (PST)
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
Subject: [PATCH kvmtool v2 20/22] arm: Reorganise and document memory map
Date:   Thu, 25 Feb 2021 00:59:13 +0000
Message-Id: <20210225005915.26423-21-andre.przywara@arm.com>
X-Mailer: git-send-email 2.14.1
In-Reply-To: <20210225005915.26423-1-andre.przywara@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The hardcoded memory map we expose to a guest is currently described
using a series of partially interconnected preprocessor constants,
which is hard to read and follow.

In preparation for moving the UART and RTC to some different MMIO
region, document the current map with some ASCII art, and clean up the
definition of the sections.

No functional change.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/include/arm-common/kvm-arch.h | 41 ++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index d84e50cd..b12255b0 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -7,14 +7,33 @@
 
 #include "arm-common/gic.h"
 
+/*
+ * The memory map used for ARM guests (not to scale):
+ *
+ * 0      64K  16M     32M     48M            1GB       2GB
+ * +-------+-..-+-------+-------+--....--+-----+--.....--+---......
+ * | (PCI) |////| int.  |       |        |     |         |
+ * |  I/O  |////| MMIO: | Flash | virtio | GIC |   PCI   |  DRAM
+ * | ports |////| UART, |       |  MMIO  |     |  (AXI)  |
+ * |       |////| RTC   |       |        |     |         |
+ * +-------+-..-+-------+-------+--....--+-----+--.....--+---......
+ */
+
 #define ARM_IOPORT_AREA		_AC(0x0000000000000000, UL)
-#define ARM_FLASH_AREA		_AC(0x0000000002000000, UL)
-#define ARM_MMIO_AREA		_AC(0x0000000003000000, UL)
+#define ARM_MMIO_AREA		_AC(0x0000000001000000, UL)
 #define ARM_AXI_AREA		_AC(0x0000000040000000, UL)
 #define ARM_MEMORY_AREA		_AC(0x0000000080000000, UL)
 
-#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
-#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
+#define KVM_IOPORT_AREA		ARM_IOPORT_AREA
+#define ARM_IOPORT_SIZE		(1U << 16)
+
+
+#define KVM_FLASH_MMIO_BASE	(ARM_MMIO_AREA + 0x1000000)
+#define KVM_FLASH_MAX_SIZE	0x1000000
+
+#define KVM_VIRTIO_MMIO_AREA	(KVM_FLASH_MMIO_BASE + KVM_FLASH_MAX_SIZE)
+#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - \
+				(KVM_VIRTIO_MMIO_AREA + ARM_GIC_SIZE))
 
 #define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
 #define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
@@ -22,19 +41,17 @@
 #define ARM_GIC_DIST_SIZE	0x10000
 #define ARM_GIC_CPUI_SIZE	0x20000
 
-#define KVM_FLASH_MMIO_BASE	ARM_FLASH_AREA
-#define KVM_FLASH_MAX_SIZE	(ARM_MMIO_AREA - ARM_FLASH_AREA)
 
-#define ARM_IOPORT_SIZE		(1U << 16)
-#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
+#define KVM_PCI_CFG_AREA	ARM_AXI_AREA
 #define ARM_PCI_CFG_SIZE	(1ULL << 24)
+#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
 #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
 				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
 
-#define KVM_IOPORT_AREA		ARM_IOPORT_AREA
-#define KVM_PCI_CFG_AREA	ARM_AXI_AREA
-#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
-#define KVM_VIRTIO_MMIO_AREA	ARM_MMIO_AREA
+
+#define ARM_LOMAP_MAX_MEMORY	((1ULL << 32) - ARM_MEMORY_AREA)
+#define ARM_HIMAP_MAX_MEMORY	((1ULL << 40) - ARM_MEMORY_AREA)
+
 
 #define KVM_IOEVENTFD_HAS_PIO	0
 
-- 
2.17.5

