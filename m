Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBA9108BC4
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2019 11:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727570AbfKYKck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Nov 2019 05:32:40 -0500
Received: from foss.arm.com ([217.140.110.172]:47752 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727553AbfKYKcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Nov 2019 05:32:39 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 31C051045;
        Mon, 25 Nov 2019 02:32:39 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 492553F52E;
        Mon, 25 Nov 2019 02:32:38 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH kvmtool 08/16] arm/pci: Fix PCI IO region
Date:   Mon, 25 Nov 2019 10:30:25 +0000
Message-Id: <20191125103033.22694-9-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191125103033.22694-1-alexandru.elisei@arm.com>
References: <20191125103033.22694-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Current PCI IO region that is exposed through the DT contains ports that
are reserved by non-PCI devices.

Use the proper PCI IO start so that the region exposed through DT can
actually be used to reassign device BARs.

Cc: julien.thierry.kdev@gmail.com
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/include/arm-common/pci.h |  1 +
 arm/kvm.c                    |  3 +++
 arm/pci.c                    | 21 ++++++++++++++++++---
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
index 9008a0ed072e..aea42b8895e9 100644
--- a/arm/include/arm-common/pci.h
+++ b/arm/include/arm-common/pci.h
@@ -1,6 +1,7 @@
 #ifndef ARM_COMMON__PCI_H
 #define ARM_COMMON__PCI_H
 
+void pci__arm_init(struct kvm *kvm);
 void pci__generate_fdt_nodes(void *fdt);
 
 #endif /* ARM_COMMON__PCI_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index 1f85fc60588f..5c30ec1e0515 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -6,6 +6,7 @@
 #include "kvm/fdt.h"
 
 #include "arm-common/gic.h"
+#include "arm-common/pci.h"
 
 #include <linux/kernel.h>
 #include <linux/kvm.h>
@@ -86,6 +87,8 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 	/* Create the virtual GIC. */
 	if (gic__create(kvm, kvm->cfg.arch.irqchip))
 		die("Failed to create virtual GIC");
+
+	pci__arm_init(kvm);
 }
 
 #define FDT_ALIGN	SZ_2M
diff --git a/arm/pci.c b/arm/pci.c
index ed325fa4a811..1c0949a22408 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -1,3 +1,5 @@
+#include "linux/sizes.h"
+
 #include "kvm/devices.h"
 #include "kvm/fdt.h"
 #include "kvm/kvm.h"
@@ -7,6 +9,11 @@
 
 #include "arm-common/pci.h"
 
+#define ARM_PCI_IO_START ALIGN(PCI_IOPORT_START, SZ_4K)
+
+/* Must be a multiple of 4k */
+#define ARM_PCI_IO_SIZE ((ARM_MMIO_AREA - ARM_PCI_IO_START) & ~(SZ_4K - 1))
+
 /*
  * An entry in the interrupt-map table looks like:
  * <pci unit address> <pci interrupt pin> <gic phandle> <gic interrupt>
@@ -24,6 +31,14 @@ struct of_interrupt_map_entry {
 	struct of_gic_irq		gic_irq;
 } __attribute__((packed));
 
+void pci__arm_init(struct kvm *kvm)
+{
+	u32 align_pad = ARM_PCI_IO_START - PCI_IOPORT_START;
+
+	/* Make PCI port allocation start at a properly aligned address */
+	pci_get_io_port_block(align_pad);
+}
+
 void pci__generate_fdt_nodes(void *fdt)
 {
 	struct device_header *dev_hdr;
@@ -40,10 +55,10 @@ void pci__generate_fdt_nodes(void *fdt)
 			.pci_addr = {
 				.hi	= cpu_to_fdt32(of_pci_b_ss(OF_PCI_SS_IO)),
 				.mid	= 0,
-				.lo	= 0,
+				.lo	= cpu_to_fdt32(ARM_PCI_IO_START),
 			},
-			.cpu_addr	= cpu_to_fdt64(KVM_IOPORT_AREA),
-			.length		= cpu_to_fdt64(ARM_IOPORT_SIZE),
+			.cpu_addr	= cpu_to_fdt64(ARM_PCI_IO_START),
+			.length		= cpu_to_fdt64(ARM_PCI_IO_SIZE),
 		},
 		{
 			.pci_addr = {
-- 
2.20.1

