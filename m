Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7004942A593
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbhJLNZz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 09:25:55 -0400
Received: from foss.arm.com ([217.140.110.172]:42198 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236873AbhJLNZy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 09:25:54 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9D09AED1;
        Tue, 12 Oct 2021 06:23:52 -0700 (PDT)
Received: from monolith.cable.virginm.net (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9BF073F66F;
        Tue, 12 Oct 2021 06:23:51 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, jean-philippe@linaro.org
Subject: [PATCH v2 kvmtool 7/7] vfio/pci: Align MSIX Table and PBA size to guest maximum page size
Date:   Tue, 12 Oct 2021 14:25:10 +0100
Message-Id: <20211012132510.42134-8-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211012132510.42134-1-alexandru.elisei@arm.com>
References: <20211012132510.42134-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When allocating MMIO space for the MSI-X table, kvmtool rounds the
allocation to the host's page size to make it as easy as possible for the
guest to map the table to a page, if it wants to (and doesn't do BAR
reassignment, like the x86 architecture for example). However, the host's
page size can differ from the guest's on architectures which support
multiple page sizes. For example, arm64 supports three different page size,
and it is possible for the host to be using 4k pages, while the guest is
using 64k pages.

To make sure the allocation is always aligned to a guest's page size, round
it up to the maximum architectural page size. Do the same for the pending
bit array if it lives in its own BAR.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch32/include/kvm/kvm-arch.h | 4 ++++
 arm/aarch64/include/kvm/kvm-arch.h | 4 ++++
 mips/include/kvm/kvm-arch.h        | 3 +++
 powerpc/include/kvm/kvm-arch.h     | 3 +++
 vfio/pci.c                         | 6 ++++--
 x86/include/kvm/kvm-arch.h         | 3 +++
 6 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arm/aarch32/include/kvm/kvm-arch.h b/arm/aarch32/include/kvm/kvm-arch.h
index a772bb1..bee2fc2 100644
--- a/arm/aarch32/include/kvm/kvm-arch.h
+++ b/arm/aarch32/include/kvm/kvm-arch.h
@@ -1,10 +1,14 @@
 #ifndef KVM__KVM_ARCH_H
 #define KVM__KVM_ARCH_H
 
+#include <linux/sizes.h>
+
 #define kvm__arch_get_kern_offset(...)	0x8000
 
 #define ARM_MAX_MEMORY(...)	ARM_LOMAP_MAX_MEMORY
 
+#define MAX_PAGE_SIZE	SZ_4K
+
 #include "arm-common/kvm-arch.h"
 
 #endif /* KVM__KVM_ARCH_H */
diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
index 159567b..5e5ee41 100644
--- a/arm/aarch64/include/kvm/kvm-arch.h
+++ b/arm/aarch64/include/kvm/kvm-arch.h
@@ -1,6 +1,8 @@
 #ifndef KVM__KVM_ARCH_H
 #define KVM__KVM_ARCH_H
 
+#include <linux/sizes.h>
+
 struct kvm;
 unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
 int kvm__arch_get_ipa_limit(struct kvm *kvm);
@@ -21,6 +23,8 @@ int kvm__arch_get_ipa_limit(struct kvm *kvm);
 	max_ram;							\
 })
 
+#define MAX_PAGE_SIZE	SZ_64K
+
 #include "arm-common/kvm-arch.h"
 
 #endif /* KVM__KVM_ARCH_H */
diff --git a/mips/include/kvm/kvm-arch.h b/mips/include/kvm/kvm-arch.h
index fdc09d8..e2f048a 100644
--- a/mips/include/kvm/kvm-arch.h
+++ b/mips/include/kvm/kvm-arch.h
@@ -1,6 +1,7 @@
 #ifndef KVM__KVM_ARCH_H
 #define KVM__KVM_ARCH_H
 
+#include <linux/sizes.h>
 
 /*
  * Guest memory map is:
@@ -36,6 +37,8 @@
 
 #define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_PCI
 
+#define MAX_PAGE_SIZE		SZ_64K
+
 #include <stdbool.h>
 
 #include "linux/types.h"
diff --git a/powerpc/include/kvm/kvm-arch.h b/powerpc/include/kvm/kvm-arch.h
index 26d440b..8eeca50 100644
--- a/powerpc/include/kvm/kvm-arch.h
+++ b/powerpc/include/kvm/kvm-arch.h
@@ -13,6 +13,7 @@
 
 #include <stdbool.h>
 #include <linux/types.h>
+#include <linux/sizes.h>
 #include <time.h>
 
 /*
@@ -48,6 +49,8 @@
 
 #define KVM_IOEVENTFD_HAS_PIO		0
 
+#define MAX_PAGE_SIZE			SZ_256K
+
 #define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_PCI
 
 struct spapr_phb;
diff --git a/vfio/pci.c b/vfio/pci.c
index a08352d..78f5ca5 100644
--- a/vfio/pci.c
+++ b/vfio/pci.c
@@ -1,3 +1,5 @@
+#include "linux/sizes.h"
+
 #include "kvm/irq.h"
 #include "kvm/kvm.h"
 #include "kvm/kvm-cpu.h"
@@ -926,7 +928,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 	if (!info.size)
 		return -EINVAL;
 
-	map_size = ALIGN(info.size, PAGE_SIZE);
+	map_size = ALIGN(info.size, MAX_PAGE_SIZE);
 	table->guest_phys_addr = pci_get_mmio_block(map_size);
 	if (!table->guest_phys_addr) {
 		pr_err("cannot allocate MMIO space");
@@ -958,7 +960,7 @@ static int vfio_pci_create_msix_table(struct kvm *kvm, struct vfio_device *vdev)
 		if (!info.size)
 			return -EINVAL;
 
-		map_size = ALIGN(info.size, PAGE_SIZE);
+		map_size = ALIGN(info.size, MAX_PAGE_SIZE);
 		pba->guest_phys_addr = pci_get_mmio_block(map_size);
 		if (!pba->guest_phys_addr) {
 			pr_err("cannot allocate MMIO space");
diff --git a/x86/include/kvm/kvm-arch.h b/x86/include/kvm/kvm-arch.h
index 85cd336..d8a7312 100644
--- a/x86/include/kvm/kvm-arch.h
+++ b/x86/include/kvm/kvm-arch.h
@@ -5,6 +5,7 @@
 
 #include <stdbool.h>
 #include <linux/types.h>
+#include <linux/sizes.h>
 #include <time.h>
 
 /*
@@ -30,6 +31,8 @@
 
 #define KVM_IOEVENTFD_HAS_PIO	1
 
+#define MAX_PAGE_SIZE		SZ_4K
+
 #define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_PCI
 
 struct kvm_arch {
-- 
2.20.1

