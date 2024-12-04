Return-Path: <kvm+bounces-33005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEAB29E3815
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 11:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AEBAB33A55
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2024 10:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CFD41F755D;
	Wed,  4 Dec 2024 10:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XXjN++tr"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A161F708F;
	Wed,  4 Dec 2024 10:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733308299; cv=none; b=IXj7uCuJ8bs4Y1scHD3++Yq0V7b9EGsQdhOHJyoiDPf5rXicMlSZdptRJRNxrPpImdq+wti6Yu/HfhocNgDElhVcHERYa4ziYUPIEGlDQZr3k1XzCNfun92dzKLeXf0vE73RtIdORDly/ALNJz7swHwFc68s62/fZvL79KDW/zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733308299; c=relaxed/simple;
	bh=YK8Xz8+1HBZC1KCeA5iRV66eibX/0rxr2Iq0ZSzs5gc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gtPcsIz6tUFdTLsA5B8zJE0HEHdWxz+u7FQ5k4O7KXhpaZTMtrdaJr7pDeBMCI4JmTIF2AaqYzGVDL54/fBcOC6ScRfAfx4FmO2aHR4u/nNAwcDGw5/GtSz0XdKrxjD2ZZZQmhEyAyoTTzd5Je40I73qLUnPI6A+9xA1A3elrxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XXjN++tr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52AEC4CED6;
	Wed,  4 Dec 2024 10:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733308299;
	bh=YK8Xz8+1HBZC1KCeA5iRV66eibX/0rxr2Iq0ZSzs5gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXjN++tr3nJpppSQ36E+mmlXFifOu7uwFoxPYB+9u17Pm7Te4qr6z78slxErRyFVk
	 MVBWywv1t1grcWnYTEhxgobgpJxOZ/peN19WA6mpX2NF4LGiw+0fAc/yYCnE8+ecb9
	 1aI/zx/nbCsy9FghTq4PE64AiEBOk62aoeqqAZ5aU06+Zw9i7fRWdr84A0nuT6uhS6
	 JjpY5bK6x5qz4bb1FJtXrPaRSJ1ArNVVzsGgvoueqGGgfYQhLA4wq93FQgGQStxLbs
	 iD5sO/kw4zgLCAh3ORATpDDo2SEf+eWRMV6T8w+48HdgjCut/kxjcqUIekGRw40gvS
	 MibZNPsfVR35w==
From: Arnd Bergmann <arnd@kernel.org>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andy Shevchenko <andy@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Davide Ciminaghi <ciminaghi@gnudd.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH 10/11] x86: remove old STA2x11 support
Date: Wed,  4 Dec 2024 11:30:41 +0100
Message-Id: <20241204103042.1904639-11-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241204103042.1904639-1-arnd@kernel.org>
References: <20241204103042.1904639-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

ST ConneXt STA2x11 was an interface chip for Atom E6xx processors,
using a number of components usually found on Arm SoCs. Most of this
was merged upstream, but it was never complete enough to actually work
and has been abandoned for many years.

We already had an agreement on removing it in 2022, but nobody ever
submitted the patch to do it.

Without STA2x11, the CONFIG_X86_32_NON_STANDARD no longer has any
use.

Link: https://lore.kernel.org/lkml/Yw3DKCuDoPkCaqxE@arcana.i.gnudd.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/x86/Kconfig               |  30 +----
 arch/x86/include/asm/sta2x11.h |  13 --
 arch/x86/pci/Makefile          |   2 -
 arch/x86/pci/sta2x11-fixup.c   | 233 ---------------------------------
 4 files changed, 3 insertions(+), 275 deletions(-)
 delete mode 100644 arch/x86/include/asm/sta2x11.h
 delete mode 100644 arch/x86/pci/sta2x11-fixup.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fa6dd9ec4bdf..6b5144f10ad7 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -543,7 +543,6 @@ config X86_EXTENDED_PLATFORM
 		AMD Elan
 		RDC R-321x SoC
 		SGI 320/540 (Visual Workstation)
-		STA2X11-based (e.g. Northville)
 
 	  64-bit platforms (CONFIG_64BIT=y):
 		Numascale NumaChip
@@ -723,16 +722,6 @@ config X86_RDC321X
 	  as R-8610-(G).
 	  If you don't have one of these chips, you should say N here.
 
-config X86_32_NON_STANDARD
-	bool "Support non-standard 32-bit SMP architectures"
-	depends on X86_32 && SMP
-	depends on X86_EXTENDED_PLATFORM
-	help
-	  This option compiles in the STA2X11 default
-	  subarchitecture.  It is intended for a generic binary
-	  kernel. If you select them all, kernel will probe it one by
-	  one and will fallback to default.
-
 # Alphabetically sorted list of Non standard 32 bit platforms
 
 config X86_SUPPORTS_MEMORY_FAILURE
@@ -744,19 +733,6 @@ config X86_SUPPORTS_MEMORY_FAILURE
 	depends on X86_64 || !SPARSEMEM
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 
-config STA2X11
-	bool "STA2X11 Companion Chip Support"
-	depends on X86_32_NON_STANDARD && PCI
-	select SWIOTLB
-	select MFD_STA2X11
-	select GPIOLIB
-	help
-	  This adds support for boards based on the STA2X11 IO-Hub,
-	  a.k.a. "ConneXt". The chip is used in place of the standard
-	  PC chipset, so all "standard" peripherals are missing. If this
-	  option is selected the kernel will still be able to boot on
-	  standard PC machines.
-
 config X86_32_IRIS
 	tristate "Eurobraille/Iris poweroff module"
 	depends on X86_32
@@ -1094,7 +1070,7 @@ config UP_LATE_INIT
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors" if !PCI_MSI
 	default PCI_MSI
-	depends on X86_32 && !SMP && !X86_32_NON_STANDARD
+	depends on X86_32 && !SMP
 	help
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -1119,7 +1095,7 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	def_bool y
-	depends on X86_64 || SMP || X86_32_NON_STANDARD || X86_UP_APIC || PCI_MSI
+	depends on X86_64 || SMP || X86_UP_APIC || PCI_MSI
 	select IRQ_DOMAIN_HIERARCHY
 
 config ACPI_MADT_WAKEUP
@@ -1579,7 +1555,7 @@ config ARCH_FLATMEM_ENABLE
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on X86_64 || NUMA || X86_32 || X86_32_NON_STANDARD
+	depends on X86_64 || NUMA || X86_32
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
deleted file mode 100644
index e0975e9c4f47..000000000000
--- a/arch/x86/include/asm/sta2x11.h
+++ /dev/null
@@ -1,13 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Header file for STMicroelectronics ConneXt (STA2X11) IOHub
- */
-#ifndef __ASM_STA2X11_H
-#define __ASM_STA2X11_H
-
-#include <linux/pci.h>
-
-/* This needs to be called from the MFD to configure its sub-devices */
-struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev);
-
-#endif /* __ASM_STA2X11_H */
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 48bcada5cabe..4933fb337983 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -12,8 +12,6 @@ obj-$(CONFIG_X86_INTEL_CE)      += ce4100.o
 obj-$(CONFIG_ACPI)		+= acpi.o
 obj-y				+= legacy.o irq.o
 
-obj-$(CONFIG_STA2X11)           += sta2x11-fixup.o
-
 obj-$(CONFIG_X86_NUMACHIP)	+= numachip.o
 
 obj-$(CONFIG_X86_INTEL_MID)	+= intel_mid_pci.o
diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
deleted file mode 100644
index 8c8ddc4dcc08..000000000000
--- a/arch/x86/pci/sta2x11-fixup.c
+++ /dev/null
@@ -1,233 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * DMA translation between STA2x11 AMBA memory mapping and the x86 memory mapping
- *
- * ST Microelectronics ConneXt (STA2X11/STA2X10)
- *
- * Copyright (c) 2010-2011 Wind River Systems, Inc.
- */
-
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
-#include <linux/export.h>
-#include <linux/list.h>
-#include <linux/dma-map-ops.h>
-#include <linux/swiotlb.h>
-#include <asm/iommu.h>
-#include <asm/sta2x11.h>
-
-#define STA2X11_SWIOTLB_SIZE (4*1024*1024)
-
-/*
- * We build a list of bus numbers that are under the ConneXt. The
- * main bridge hosts 4 busses, which are the 4 endpoints, in order.
- */
-#define STA2X11_NR_EP		4	/* 0..3 included */
-#define STA2X11_NR_FUNCS	8	/* 0..7 included */
-#define STA2X11_AMBA_SIZE	(512 << 20)
-
-struct sta2x11_ahb_regs { /* saved during suspend */
-	u32 base, pexlbase, pexhbase, crw;
-};
-
-struct sta2x11_mapping {
-	int is_suspended;
-	struct sta2x11_ahb_regs regs[STA2X11_NR_FUNCS];
-};
-
-struct sta2x11_instance {
-	struct list_head list;
-	int bus0;
-	struct sta2x11_mapping map[STA2X11_NR_EP];
-};
-
-static LIST_HEAD(sta2x11_instance_list);
-
-/* At probe time, record new instances of this bridge (likely one only) */
-static void sta2x11_new_instance(struct pci_dev *pdev)
-{
-	struct sta2x11_instance *instance;
-
-	instance = kzalloc(sizeof(*instance), GFP_ATOMIC);
-	if (!instance)
-		return;
-	/* This has a subordinate bridge, with 4 more-subordinate ones */
-	instance->bus0 = pdev->subordinate->number + 1;
-
-	if (list_empty(&sta2x11_instance_list)) {
-		int size = STA2X11_SWIOTLB_SIZE;
-		/* First instance: register your own swiotlb area */
-		dev_info(&pdev->dev, "Using SWIOTLB (size %i)\n", size);
-		if (swiotlb_init_late(size, GFP_DMA, NULL))
-			dev_emerg(&pdev->dev, "init swiotlb failed\n");
-	}
-	list_add(&instance->list, &sta2x11_instance_list);
-}
-DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, 0xcc17, sta2x11_new_instance);
-
-/*
- * Utility functions used in this file from below
- */
-static struct sta2x11_instance *sta2x11_pdev_to_instance(struct pci_dev *pdev)
-{
-	struct sta2x11_instance *instance;
-	int ep;
-
-	list_for_each_entry(instance, &sta2x11_instance_list, list) {
-		ep = pdev->bus->number - instance->bus0;
-		if (ep >= 0 && ep < STA2X11_NR_EP)
-			return instance;
-	}
-	return NULL;
-}
-
-static int sta2x11_pdev_to_ep(struct pci_dev *pdev)
-{
-	struct sta2x11_instance *instance;
-
-	instance = sta2x11_pdev_to_instance(pdev);
-	if (!instance)
-		return -1;
-
-	return pdev->bus->number - instance->bus0;
-}
-
-/* This is exported, as some devices need to access the MFD registers */
-struct sta2x11_instance *sta2x11_get_instance(struct pci_dev *pdev)
-{
-	return sta2x11_pdev_to_instance(pdev);
-}
-EXPORT_SYMBOL(sta2x11_get_instance);
-
-/* At setup time, we use our own ops if the device is a ConneXt one */
-static void sta2x11_setup_pdev(struct pci_dev *pdev)
-{
-	struct sta2x11_instance *instance = sta2x11_pdev_to_instance(pdev);
-
-	if (!instance) /* either a sta2x11 bridge or another ST device */
-		return;
-
-	/* We must enable all devices as master, for audio DMA to work */
-	pci_set_master(pdev);
-}
-DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, sta2x11_setup_pdev);
-
-/*
- * At boot we must set up the mappings for the pcie-to-amba bridge.
- * It involves device access, and the same happens at suspend/resume time
- */
-
-#define AHB_MAPB		0xCA4
-#define AHB_CRW(i)		(AHB_MAPB + 0  + (i) * 0x10)
-#define AHB_CRW_SZMASK			0xfffffc00UL
-#define AHB_CRW_ENABLE			(1 << 0)
-#define AHB_CRW_WTYPE_MEM		(2 << 1)
-#define AHB_CRW_ROE			(1UL << 3)	/* Relax Order Ena */
-#define AHB_CRW_NSE			(1UL << 4)	/* No Snoop Enable */
-#define AHB_BASE(i)		(AHB_MAPB + 4  + (i) * 0x10)
-#define AHB_PEXLBASE(i)		(AHB_MAPB + 8  + (i) * 0x10)
-#define AHB_PEXHBASE(i)		(AHB_MAPB + 12 + (i) * 0x10)
-
-/* At probe time, enable mapping for each endpoint, using the pdev */
-static void sta2x11_map_ep(struct pci_dev *pdev)
-{
-	struct sta2x11_instance *instance = sta2x11_pdev_to_instance(pdev);
-	struct device *dev = &pdev->dev;
-	u32 amba_base, max_amba_addr;
-	int i, ret;
-
-	if (!instance)
-		return;
-
-	pci_read_config_dword(pdev, AHB_BASE(0), &amba_base);
-	max_amba_addr = amba_base + STA2X11_AMBA_SIZE - 1;
-
-	ret = dma_direct_set_offset(dev, 0, amba_base, STA2X11_AMBA_SIZE);
-	if (ret)
-		dev_err(dev, "sta2x11: could not set DMA offset\n");
-
-	dev->bus_dma_limit = max_amba_addr;
-	dma_set_mask_and_coherent(&pdev->dev, max_amba_addr);
-
-	/* Configure AHB mapping */
-	pci_write_config_dword(pdev, AHB_PEXLBASE(0), 0);
-	pci_write_config_dword(pdev, AHB_PEXHBASE(0), 0);
-	pci_write_config_dword(pdev, AHB_CRW(0), STA2X11_AMBA_SIZE |
-			       AHB_CRW_WTYPE_MEM | AHB_CRW_ENABLE);
-
-	/* Disable all the other windows */
-	for (i = 1; i < STA2X11_NR_FUNCS; i++)
-		pci_write_config_dword(pdev, AHB_CRW(i), 0);
-
-	dev_info(&pdev->dev,
-		 "sta2x11: Map EP %i: AMBA address %#8x-%#8x\n",
-		 sta2x11_pdev_to_ep(pdev), amba_base, max_amba_addr);
-}
-DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, sta2x11_map_ep);
-
-#ifdef CONFIG_PM /* Some register values must be saved and restored */
-
-static struct sta2x11_mapping *sta2x11_pdev_to_mapping(struct pci_dev *pdev)
-{
-	struct sta2x11_instance *instance;
-	int ep;
-
-	instance = sta2x11_pdev_to_instance(pdev);
-	if (!instance)
-		return NULL;
-	ep = sta2x11_pdev_to_ep(pdev);
-	return instance->map + ep;
-}
-
-static void suspend_mapping(struct pci_dev *pdev)
-{
-	struct sta2x11_mapping *map = sta2x11_pdev_to_mapping(pdev);
-	int i;
-
-	if (!map)
-		return;
-
-	if (map->is_suspended)
-		return;
-	map->is_suspended = 1;
-
-	/* Save all window configs */
-	for (i = 0; i < STA2X11_NR_FUNCS; i++) {
-		struct sta2x11_ahb_regs *regs = map->regs + i;
-
-		pci_read_config_dword(pdev, AHB_BASE(i), &regs->base);
-		pci_read_config_dword(pdev, AHB_PEXLBASE(i), &regs->pexlbase);
-		pci_read_config_dword(pdev, AHB_PEXHBASE(i), &regs->pexhbase);
-		pci_read_config_dword(pdev, AHB_CRW(i), &regs->crw);
-	}
-}
-DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, suspend_mapping);
-
-static void resume_mapping(struct pci_dev *pdev)
-{
-	struct sta2x11_mapping *map = sta2x11_pdev_to_mapping(pdev);
-	int i;
-
-	if (!map)
-		return;
-
-
-	if (!map->is_suspended)
-		goto out;
-	map->is_suspended = 0;
-
-	/* Restore all window configs */
-	for (i = 0; i < STA2X11_NR_FUNCS; i++) {
-		struct sta2x11_ahb_regs *regs = map->regs + i;
-
-		pci_write_config_dword(pdev, AHB_BASE(i), regs->base);
-		pci_write_config_dword(pdev, AHB_PEXLBASE(i), regs->pexlbase);
-		pci_write_config_dword(pdev, AHB_PEXHBASE(i), regs->pexhbase);
-		pci_write_config_dword(pdev, AHB_CRW(i), regs->crw);
-	}
-out:
-	pci_set_master(pdev); /* Like at boot, enable master on all devices */
-}
-DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, resume_mapping);
-
-#endif /* CONFIG_PM */
-- 
2.39.5


