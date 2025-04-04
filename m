Return-Path: <kvm+bounces-42753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D5A6A7C42A
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 21:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECEAD16A543
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70340254AF3;
	Fri,  4 Apr 2025 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NZ/p00yx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC4254840
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795705; cv=none; b=TByzm/JfvHjFjlNhdfY12JsMOmtd273dYOPsLi/lxuNAiSajiKbMztsmrEQV89A63XFSsbhkkMX1UJjqNg1I//hvhJ+OwaTwsxh51UrfA4fMrfUJEi3ebkuNGHJMbP5E4e8JgSOLyZxflwUd976wio3ctWTrdoINfdxwiiLzWmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795705; c=relaxed/simple;
	bh=GrR7H4RmB+od4casAPRpt3gnDwjfh8mPMr/HODGBiFA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IKxH6A0OkoCaUbUWfmYS9SxWqoo1u1yqqw1gI1aKa6i/kpmJRYGNhZGZx/21qg6EvqCIj9rZkFrWR3pYomsVFsIzoR8e+WBADjORG2e7UgixGO4AxOcIdEqfMQQ0YT1vRMb14Sv6HjjEaBD5Wlv1Przu9JzyNdweCfT8uXQoKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NZ/p00yx; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-af972dd0cd6so1649456a12.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795702; x=1744400502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CchHgbdkU85V21Tg2RoLnh3SW6H2rHKoJBvsnARZ2sw=;
        b=NZ/p00yximP2RpkXOCAC93JLw8XHynM6zCuge8onffUZ6BYSd+Eic9x6ZHoBApf2Eb
         nWRHDp9KtH98VMBX4hgWbBljYinsmGkHadvPS2LmBHWLZMgIJcL6c88x94Myz5r1t4hW
         bBp4nQ4hkwaGL2JhQQjbRFY3W10leMlh33Ho1eH+7CoiG/VtJvWvcqBB+9eiYyG2/PqE
         BBc8ME9M+H9mETooYHyo/rdXWgODLSZZFsYK+1DMx5wz5dLPyo5ZRTz6hENL1uIjmhR/
         4iCk/If20Ya6xAkhMLozrzVjs9X/hdtF9mo1Pomvnndotbv8M+LxY39Xv/o8vBipCXxO
         tE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795702; x=1744400502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CchHgbdkU85V21Tg2RoLnh3SW6H2rHKoJBvsnARZ2sw=;
        b=Od+xyABa4K/XKjvKj5zyqIS0OMH/27Ohu4k3jhNdDeSOvUaAgFOv1uSezAmWNofS4y
         rgZ1jNUTVk9ibwNI/6JO44tzydpvJdE828/Nj/QUaUj0Wmcn3Qb3y2JguHVB/n/WpvwB
         ADcqDjIAyfom8dlhm++4FdmXSYVLfBkcyw7LH4hET+a3d/ZdV4KV147JB5TnGqtFbNuC
         ryeHn+jyl8PS+LofWgmXH8BVGEnfuXn7kgze7j0cVqrcgzpLb2sCADGZepfljqtPaK4O
         UMqEW0zzJtSZxjaqIg3o9aggLk2gdw0lNrfgVldMUSKZLze3d96OFE+i4GKcF2YIsFDj
         fPMA==
X-Gm-Message-State: AOJu0YxqyrxQnOvVF0msJaHbt3bP3L0+Nt4U/Hk/XDWlAxvWPsAYeF+y
	j7PXI6jysW5+LFSrFkRSm/xLkLfXSmiMGWdQdfJOOGLNHCBjtL/A+OHZMq/8IQ40nCfqJyuqtnk
	x1Q==
X-Google-Smtp-Source: AGHT+IESNzAoFEjQQTPfehzk55GF3aFqjfkUVb4xQqmA4zoG2du8f0bXh5+kaR4evFBRnH7os/w/UOsfz4E=
X-Received: from pgct21.prod.google.com ([2002:a05:6a02:5295:b0:af2:3b16:9767])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12d4:b0:1f5:8605:9530
 with SMTP id adf61e73a8af0-2010818982emr5025411637.28.1743795702576; Fri, 04
 Apr 2025 12:41:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:39:22 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-68-seanjc@google.com>
Subject: [PATCH 67/67] *** DO NOT MERGE *** KVM: selftests: WIP posted
 interrupts test
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   2 +
 .../selftests/kvm/include/vfio_pci_util.h     | 149 ++++++
 .../selftests/kvm/include/x86/processor.h     |  21 +
 .../testing/selftests/kvm/lib/vfio_pci_util.c | 201 ++++++++
 tools/testing/selftests/kvm/mercury_device.h  | 118 +++++
 tools/testing/selftests/kvm/vfio_irq_test.c   | 429 ++++++++++++++++++
 6 files changed, 920 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/include/vfio_pci_util.h
 create mode 100644 tools/testing/selftests/kvm/lib/vfio_pci_util.c
 create mode 100644 tools/testing/selftests/kvm/mercury_device.h
 create mode 100644 tools/testing/selftests/kvm/vfio_irq_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index f773f8f99249..8f017b858d4b 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -15,6 +15,7 @@ LIBKVM += lib/sparsebit.c
 LIBKVM += lib/test_util.c
 LIBKVM += lib/ucall_common.c
 LIBKVM += lib/userfaultfd_util.c
+LIBKVM += lib/vfio_pci_util.c
 
 LIBKVM_STRING += lib/string_override.c
 
@@ -133,6 +134,7 @@ TEST_GEN_PROGS_x86 += mmu_stress_test
 TEST_GEN_PROGS_x86 += rseq_test
 TEST_GEN_PROGS_x86 += set_memory_region_test
 TEST_GEN_PROGS_x86 += steal_time
+TEST_GEN_PROGS_x86 += vfio_irq_test
 TEST_GEN_PROGS_x86 += kvm_binary_stats_test
 TEST_GEN_PROGS_x86 += system_counter_offset_test
 TEST_GEN_PROGS_x86 += pre_fault_memory_test
diff --git a/tools/testing/selftests/kvm/include/vfio_pci_util.h b/tools/testing/selftests/kvm/include/vfio_pci_util.h
new file mode 100644
index 000000000000..2a697dcb741e
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/vfio_pci_util.h
@@ -0,0 +1,149 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022, Google LLC.
+ */
+
+#ifndef SELFTEST_KVM_VFIO_UTIL_H
+#define SELFTEST_KVM_VFIO_UTIL_H
+
+#include <linux/pci_regs.h>
+#include <linux/vfio.h>
+
+#include "kvm_util.h"
+#include "test_util.h"
+
+struct vfio_pci_dev {
+	int fd;
+	int group_fd;
+	int container_fd;
+};
+
+struct vfio_pci_dev *__vfio_pci_init(const char *bdf, unsigned long iommu_type);
+void vfio_pci_free(struct vfio_pci_dev *dev);
+
+static inline struct vfio_pci_dev *vfio_pci_init(const char *bdf)
+{
+	return __vfio_pci_init(bdf, VFIO_TYPE1v2_IOMMU);
+}
+
+#define __vfio_ioctl(vfio_fd, cmd, arg)				\
+({								\
+	__kvm_ioctl(vfio_fd, cmd, arg);				\
+})
+
+#define vfio_ioctl(vfio_fd, cmd, arg)				\
+({								\
+	int ret = __vfio_ioctl(vfio_fd, cmd, arg);		\
+								\
+	TEST_ASSERT(!ret, __KVM_IOCTL_ERROR(#cmd, ret));	\
+})
+
+static inline uint32_t vfio_pci_get_nr_irqs(struct vfio_pci_dev *dev,
+					    uint32_t irq_type)
+{
+	struct vfio_irq_info irq_info = {
+		.argsz = sizeof(struct vfio_irq_info),
+		.index = irq_type,
+	};
+
+	vfio_ioctl(dev->fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+
+	TEST_ASSERT(irq_info.flags & VFIO_IRQ_INFO_EVENTFD,
+		    "eventfd signalling unsupported by IRQ type '%u'", irq_type);
+	return irq_info.count;
+}
+
+static inline uint32_t vfio_pci_get_nr_msi_irqs(struct vfio_pci_dev *dev)
+{
+	return vfio_pci_get_nr_irqs(dev, VFIO_PCI_MSI_IRQ_INDEX);
+}
+
+static inline uint32_t vfio_pci_get_nr_msix_irqs(struct vfio_pci_dev *dev)
+{
+	return vfio_pci_get_nr_irqs(dev, VFIO_PCI_MSIX_IRQ_INDEX);
+}
+
+static inline void __vfio_pci_irq_eventfd(struct vfio_pci_dev *dev, int eventfd,
+					  uint32_t irq_type, uint32_t set)
+{
+	struct {
+		struct vfio_irq_set vfio;
+		uint32_t eventfd;
+	} buffer = {};
+
+	memset(&buffer, 0, sizeof(buffer));
+	buffer.vfio.argsz = sizeof(buffer);
+	buffer.vfio.flags = set | VFIO_IRQ_SET_ACTION_TRIGGER;
+	buffer.vfio.index = irq_type;
+	buffer.vfio.count = 1;
+	buffer.eventfd = eventfd;
+
+	vfio_ioctl(dev->fd, VFIO_DEVICE_SET_IRQS, &buffer.vfio);
+}
+
+static inline void vfio_pci_assign_irq_eventfd(struct vfio_pci_dev *dev,
+					       int eventfd, uint32_t irq_type)
+{
+	__vfio_pci_irq_eventfd(dev, eventfd, irq_type, VFIO_IRQ_SET_DATA_EVENTFD);
+}
+
+static inline void vfio_pci_assign_msix(struct vfio_pci_dev *dev, int eventfd)
+{
+	vfio_pci_assign_irq_eventfd(dev, eventfd, VFIO_PCI_MSIX_IRQ_INDEX);
+}
+
+static inline void vfio_pci_release_irq_eventfds(struct vfio_pci_dev *dev,
+						 uint32_t irq_type)
+{
+	struct vfio_irq_set vfio = {
+		.argsz = sizeof(struct vfio_irq_set),
+		.flags = VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
+		.index = irq_type,
+		.count = 0,
+	};
+
+	vfio_ioctl(dev->fd, VFIO_DEVICE_SET_IRQS, &vfio);
+}
+
+static inline void vfio_pci_release_msix(struct vfio_pci_dev *dev)
+{
+	vfio_pci_release_irq_eventfds(dev, VFIO_PCI_MSIX_IRQ_INDEX);
+}
+
+static inline void vfio_pci_send_irq_eventfd(struct vfio_pci_dev *dev,
+					     int eventfd, uint32_t irq_type)
+{
+	__vfio_pci_irq_eventfd(dev, eventfd, irq_type, VFIO_IRQ_SET_DATA_NONE);
+}
+
+static inline void vfio_pci_send_msix(struct vfio_pci_dev *dev, int eventfd)
+{
+	vfio_pci_send_irq_eventfd(dev, eventfd, VFIO_PCI_MSIX_IRQ_INDEX);
+}
+
+void *vfio_pci_map_bar(struct vfio_pci_dev *dev, unsigned int bar_idx,
+		       uint64_t *size);
+
+void vfio_pci_read_config_data(struct vfio_pci_dev *dev, size_t offset,
+			       size_t size, void *data);
+
+static inline uint16_t vfio_pci_config_read_u16(struct vfio_pci_dev *dev,
+						size_t offset)
+{
+	uint16_t val;
+
+	vfio_pci_read_config_data(dev, offset, sizeof(val), &val);
+	return le16toh(val);
+}
+
+static inline uint16_t vfio_pci_get_vendor_id(struct vfio_pci_dev *dev)
+{
+	return vfio_pci_config_read_u16(dev, PCI_VENDOR_ID);
+}
+
+static inline uint16_t vfio_pci_get_device_id(struct vfio_pci_dev *dev)
+{
+	return vfio_pci_config_read_u16(dev, PCI_DEVICE_ID);
+}
+
+#endif /* SELFTEST_KVM_VFIO_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/x86/processor.h b/tools/testing/selftests/kvm/include/x86/processor.h
index 32ab6ca7ec32..251dcc074503 100644
--- a/tools/testing/selftests/kvm/include/x86/processor.h
+++ b/tools/testing/selftests/kvm/include/x86/processor.h
@@ -19,6 +19,27 @@
 #include "kvm_util.h"
 #include "ucall_common.h"
 
+
+static inline void writel(uint32_t val, volatile void *addr)
+{
+	*(volatile uint32_t *)addr = val;
+}
+
+static inline uint32_t readl(volatile void *addr)
+{
+	return *(volatile uint32_t *)addr;
+}
+
+static inline void writeq(uint64_t val, volatile void *addr)
+{
+	*(volatile uint64_t *)addr = val;
+}
+
+static inline uint64_t readq(volatile void *addr)
+{
+	return *(volatile uint64_t *)addr;
+}
+
 extern bool host_cpu_is_intel;
 extern bool host_cpu_is_amd;
 extern uint64_t guest_tsc_khz;
diff --git a/tools/testing/selftests/kvm/lib/vfio_pci_util.c b/tools/testing/selftests/kvm/lib/vfio_pci_util.c
new file mode 100644
index 000000000000..878d91be2212
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/vfio_pci_util.c
@@ -0,0 +1,201 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <poll.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <endian.h>
+#include <sys/ioctl.h>
+#include <linux/mman.h>
+#include <asm/barrier.h>
+#include <sys/eventfd.h>
+#include <linux/limits.h>
+
+#include <linux/vfio.h>
+#include <linux/pci_regs.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "vfio_pci_util.h"
+
+#define VFIO_DEV_PATH	"/dev/vfio/vfio"
+#define PCI_SYSFS_PATH	"/sys/bus/pci/devices/"
+
+void *vfio_pci_map_bar(struct vfio_pci_dev *dev, unsigned int bar_idx,
+		       uint64_t *size)
+{
+	struct vfio_region_info info = {
+		.argsz = sizeof(struct vfio_region_info),
+		.index = bar_idx,
+	};
+	int fd = dev->fd;
+	void *bar;
+	int prot;
+
+	TEST_ASSERT(bar_idx <= VFIO_PCI_BAR5_REGION_INDEX,
+		    "Invalid BAR index: %d", bar_idx);
+
+	/* Currently only support the cases where the BAR can be mmap-ed */
+	vfio_ioctl(fd, VFIO_DEVICE_GET_REGION_INFO, &info);
+	TEST_ASSERT(info.flags & VFIO_REGION_INFO_FLAG_MMAP,
+		    "BAR%d doesn't support mmap", bar_idx);
+
+	TEST_ASSERT(info.flags & VFIO_REGION_INFO_FLAG_READ,
+		    "BAR%d doesn't support read?", bar_idx);
+
+	prot = PROT_READ;
+	if (info.flags & VFIO_REGION_INFO_FLAG_WRITE)
+		prot |= PROT_WRITE;
+
+	bar = mmap(NULL, info.size, prot, MAP_FILE | MAP_SHARED, fd, info.offset);
+	TEST_ASSERT(bar != MAP_FAILED, "mmap(BAR%d) failed", bar_idx);
+
+	*size = info.size;
+	return bar;
+}
+
+/*
+ * Read the PCI config space data
+ *
+ * Input Args:
+ *   vfio_pci: Pointer to struct vfio_pci_dev
+ *   config: The config space field's offset to read from (eg: PCI_VENDOR_ID)
+ *   size: The size to read from the config region (could be one or more fields).
+ *   data: Pointer to the region where the read data is to be copied into
+ *
+ *  The data returned is in little-endian format, which is the standard for PCI config space.
+ */
+void vfio_pci_read_config_data(struct vfio_pci_dev *dev, size_t offset,
+			       size_t size, void *data)
+{
+	struct vfio_region_info info = {
+		.argsz = sizeof(struct vfio_region_info),
+		.index = VFIO_PCI_CONFIG_REGION_INDEX,
+	};
+	int ret;
+
+	vfio_ioctl(dev->fd, VFIO_DEVICE_GET_REGION_INFO, &info);
+
+	TEST_ASSERT(offset + size <= PCI_CFG_SPACE_EXP_SIZE,
+		    "Requested config (%lu) and size (%lu) is out of bounds (%u)",
+		    offset, size, PCI_CFG_SPACE_EXP_SIZE);
+
+	ret = pread(dev->fd, data, size, info.offset + offset);
+	TEST_ASSERT(ret == size, "Failed to read the PCI config: 0x%lx\n", offset);
+}
+
+static unsigned int vfio_pci_get_group_from_dev(const char *bdf)
+{
+	char dev_iommu_group_path[PATH_MAX] = {0};
+	unsigned int pci_dev_sysfs_path_len;
+	char *pci_dev_sysfs_path;
+	unsigned int group;
+	int ret;
+
+	pci_dev_sysfs_path_len = strlen(PCI_SYSFS_PATH) + strlen("DDDD:BB:DD.F/iommu_group") + 1;
+
+	pci_dev_sysfs_path = calloc(1, pci_dev_sysfs_path_len);
+	TEST_ASSERT(pci_dev_sysfs_path, "Insufficient memory for pci dev sysfs path");
+
+	snprintf(pci_dev_sysfs_path, pci_dev_sysfs_path_len,
+		 "%s%s/iommu_group", PCI_SYSFS_PATH, bdf);
+
+	ret = readlink(pci_dev_sysfs_path, dev_iommu_group_path,
+		       sizeof(dev_iommu_group_path));
+	TEST_ASSERT(ret != -1, "Failed to get IOMMU group for device: %s", bdf);
+
+	ret = sscanf(basename(dev_iommu_group_path), "%u", &group);
+	TEST_ASSERT(ret == 1, "Failed to get IOMMU group for device: %s", bdf);
+
+	free(pci_dev_sysfs_path);
+	return group;
+}
+
+static void vfio_pci_setup_group(struct vfio_pci_dev *dev, const char *bdf)
+{
+	char group_path[32];
+	struct vfio_group_status group_status = {
+	    .argsz = sizeof(group_status),
+	};
+	int group;
+
+	group = vfio_pci_get_group_from_dev(bdf);
+	snprintf(group_path, sizeof(group_path), "/dev/vfio/%d", group);
+
+	dev->group_fd = open(group_path, O_RDWR);
+	TEST_ASSERT(dev->group_fd >= 0,
+		    "Failed to open the VFIO group %d for device: %s\n", group, bdf);
+
+	__vfio_ioctl(dev->group_fd, VFIO_GROUP_GET_STATUS, &group_status);
+	TEST_ASSERT(group_status.flags & VFIO_GROUP_FLAGS_VIABLE,
+		    "Group %d for device %s not viable.  Ensure all devices are bound to vfio-pci",
+		    group, bdf);
+
+	vfio_ioctl(dev->group_fd, VFIO_GROUP_SET_CONTAINER, &dev->container_fd);
+}
+
+static void vfio_pci_set_iommu(struct vfio_pci_dev *dev, unsigned long iommu_type)
+{
+	TEST_ASSERT_EQ(__vfio_ioctl(dev->container_fd, VFIO_CHECK_EXTENSION, (void *)iommu_type), 1);
+	vfio_ioctl(dev->container_fd, VFIO_SET_IOMMU, (void *)iommu_type);
+}
+
+static void vfio_pci_open_device(struct vfio_pci_dev *dev, const char *bdf)
+{
+	struct vfio_device_info dev_info = {
+		.argsz = sizeof(dev_info),
+	};
+
+	dev->fd = __vfio_ioctl(dev->group_fd, VFIO_GROUP_GET_DEVICE_FD, bdf);
+	TEST_ASSERT(dev->fd >= 0, "Failed to get the device fd\n");
+
+	vfio_ioctl(dev->fd, VFIO_DEVICE_GET_INFO, &dev_info);
+
+	TEST_ASSERT(!(dev_info.flags & VFIO_DEVICE_FLAGS_RESET),
+		    "If VFIO tries to reset the VF, it will fail.");
+
+	/* Require at least all BAR regions and the config space. */
+	TEST_ASSERT(dev_info.num_regions >= VFIO_PCI_CONFIG_REGION_INDEX,
+		    "Required number regions not supported (%d) for device: %s",
+		    dev_info.num_regions, bdf);
+
+	/* Check for at least VFIO_PCI_MSIX_IRQ_INDEX irqs */
+	TEST_ASSERT(dev_info.num_irqs >= VFIO_PCI_MSIX_IRQ_INDEX,
+		    "MSI-X IRQs (%d) not supported for device: %s",
+		    dev_info.num_irqs, bdf);
+}
+
+/* bdf: PCI device's Domain:Bus:Device:Function in "DDDD:BB:DD.F" format */
+struct vfio_pci_dev *__vfio_pci_init(const char *bdf, unsigned long iommu_type)
+{
+	struct vfio_pci_dev *dev;
+	int vfio_version;
+
+	TEST_ASSERT(bdf, "PCI BDF not supplied\n");
+
+	dev = calloc(1, sizeof(*dev));
+	TEST_ASSERT(dev, "Insufficient memory for vfio_pci_dev");
+
+	dev->container_fd = open_path_or_exit(VFIO_DEV_PATH, O_RDWR);
+
+	vfio_version = __vfio_ioctl(dev->container_fd, VFIO_GET_API_VERSION, NULL);
+	TEST_REQUIRE(vfio_version == VFIO_API_VERSION);
+
+
+	vfio_pci_setup_group(dev, bdf);
+	vfio_pci_set_iommu(dev, iommu_type);
+	vfio_pci_open_device(dev, bdf);
+
+	return dev;
+}
+
+void vfio_pci_free(struct vfio_pci_dev *dev)
+{
+	close(dev->fd);
+	vfio_ioctl(dev->group_fd, VFIO_GROUP_UNSET_CONTAINER, NULL);
+
+	close(dev->group_fd);
+	close(dev->container_fd);
+
+	free(dev);
+}
diff --git a/tools/testing/selftests/kvm/mercury_device.h b/tools/testing/selftests/kvm/mercury_device.h
new file mode 100644
index 000000000000..fd4a3a5bac25
--- /dev/null
+++ b/tools/testing/selftests/kvm/mercury_device.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022, Google LLC.
+ */
+
+#ifndef SELFTEST_KVM_MERCURY_DEVICE_H
+#define SELFTEST_KVM_MERCURY_DEVICE_H
+
+#include "processor.h"
+#include "test_util.h"
+
+#define MERCURY_VENDOR_ID	0x1ae0
+#define MERCURY_DEVICE_ID	0x0050
+
+/* The base registers of the mercury device begin at the below offset from BAR0 */
+#define MERCURY_BASE_OFFSET	(768 * 1024)
+
+#define MERCURY_MSIX_VECTOR	0
+#define MERCURY_MSIX_COUNT	1 /* Currently, only 1 vector is assigned to mercury */
+
+#define MERCURY_DMA_MAX_BUF_SIZE_BYTES		SZ_8K
+#define MERCURY_DMA_MEMCPY_MAX_BUF_SIZE_BYTES	SZ_1G
+
+/* Mercury device accepts the DMA size as double-word (4-bytes) */
+#define MERCURY_DMA_SIZE_STRIDE			4
+
+#define MERCURY_ABI_VERSION	0
+
+/* Register Offsets relative to MERCURY_BASE_OFFSET */
+/* Unless otherwise specified, all the registers are 32-bits */
+#define MERCURY_REG_VERSION		0x0	/* Read-only */
+#define MERCURY_REG_COMMAND		0x04	/* Write-only */
+#define MERCURY_REG_STATUS		0x08	/* Read-only, 64-bit register */
+#define MERCURY_REG_DMA_SRC_ADDR	0x10	/* Read/Write, 64-bit register */
+#define MERCURY_REG_DMA_DEST_ADDR	0x18	/* Read/Write, 64-bit register */
+#define MERCURY_REG_DMA_DW_LEN		0x20	/* Read/Write */
+#define MERCURY_REG_SCRATCH_REG0	0x24	/* Read/Write */
+#define MERCURY_REG_SCRATCH_REG1	0x1000	/* Read/Write */
+
+/* Bit positions of the STATUS register */
+enum mercury_status_bit {
+	MERCURY_STATUS_BIT_READY = 0,
+	MERCURY_STATUS_BIT_DMA_FROM_DEV_COMPLETE = 1,
+	MERCURY_STATUS_BIT_DMA_TO_DEV_COMPLETE = 2,
+	MERCURY_STATUS_BIT_DMA_MEMCPY_COMPLETE = 3,
+	MERCURY_STATUS_BIT_FORCE_INTERRUPT = 4,
+	MERCURY_STATUS_BIT_INVAL_DMA_SIZE = 5,
+	MERCURY_STATUS_BIT_DMA_ERROR = 6,
+	MERCURY_STATUS_BIT_CMD_ERR_INVAL_CMD = 7,
+	MERCURY_STATUS_BIT_CMD_ERR_DEV_NOT_READY = 8,
+};
+
+/* List of mercury commands that can be written into MERCURY_REG_COMMAND register */
+enum mercury_command {
+	MERCURY_COMMAND_RESET = 0,
+	MERCURY_COMMAND_TRIGGER_DMA_FROM_DEV = 1,
+	MERCURY_COMMAND_TRIGGER_DMA_TO_DEV = 2,
+	MERCURY_COMMAND_TRIGGER_DMA_MEMCPY = 3,
+	MERCURY_COMMAND_FORCE_INTERRUPT = 4,
+};
+
+static inline void mercury_write_reg64(void *bar0, uint32_t reg_off, uint64_t val)
+{
+	void *reg = bar0 + MERCURY_BASE_OFFSET + reg_off;
+
+	writeq(val, reg);
+}
+
+static inline void mercury_write_reg32(void *bar0, uint32_t reg_off, uint32_t val)
+{
+	void *reg = bar0 + MERCURY_BASE_OFFSET + reg_off;
+
+	writel(val, reg);
+}
+
+static inline uint32_t mercury_read_reg32(void *bar0, uint32_t reg_off)
+{
+	void *reg = bar0 + MERCURY_BASE_OFFSET + reg_off;
+
+	return readl(reg);
+}
+
+static inline uint64_t mercury_read_reg64(void *bar0, uint32_t reg_off)
+{
+	void *reg = bar0 + MERCURY_BASE_OFFSET + reg_off;
+
+	return readq(reg);
+}
+
+static inline uint64_t mercury_get_status(void *bar0)
+{
+	return mercury_read_reg64(bar0, MERCURY_REG_STATUS);
+}
+
+static inline void mercury_issue_command(void *bar0, enum mercury_command cmd)
+{
+	mercury_write_reg32(bar0, MERCURY_REG_COMMAND, cmd);
+}
+
+static inline void mercury_issue_reset(void *bar0)
+{
+	mercury_issue_command(bar0, MERCURY_COMMAND_RESET);
+}
+
+static inline void mercury_force_irq(void *bar0)
+{
+	mercury_issue_command(bar0, MERCURY_COMMAND_FORCE_INTERRUPT);
+}
+
+static inline void mercury_set_dma_size(void *bar0, size_t sz_bytes)
+{
+	/* Convert the DMA size from bytes to DWORDS, as accepted by the device */
+	size_t sz_dwords = sz_bytes / MERCURY_DMA_SIZE_STRIDE;
+
+	mercury_write_reg32(bar0, MERCURY_REG_DMA_DW_LEN, sz_dwords);
+}
+
+#endif /* SELFTEST_KVM_MERCURY_DEVICE_H */
diff --git a/tools/testing/selftests/kvm/vfio_irq_test.c b/tools/testing/selftests/kvm/vfio_irq_test.c
new file mode 100644
index 000000000000..1cdc6fee9e9a
--- /dev/null
+++ b/tools/testing/selftests/kvm/vfio_irq_test.c
@@ -0,0 +1,429 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "apic.h"
+#include "processor.h"
+#include "test_util.h"
+#include "kvm_util.h"
+
+#include <errno.h>
+#include <fcntl.h>
+#include <pthread.h>
+#include <sched.h>
+#include <semaphore.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <signal.h>
+#include <stdint.h>
+#include <syscall.h>
+#include <sys/ioctl.h>
+#include <sys/sysinfo.h>
+#include <time.h>
+
+#include <sys/eventfd.h>
+
+#include "vfio_pci_util.h"
+#include "mercury_device.h"
+
+#define MERCURY_GSI		32
+#define MERCURY_IRQ_VECTOR	0x80
+
+#define MERCURY_BAR0_GPA	0xc0000000ul
+#define MERCURY_BAR0_SLOT	10
+
+/* Shared variables. */
+static bool do_guest_irq = true;
+
+/* Guest-only variables, shared across vCPUs. */
+static int irqs_received;
+static int irqs_sent;
+
+/* Host-only variables, shared across threads. */
+static cpu_set_t possible_mask;
+static int min_cpu, max_cpu;
+static bool done;
+static struct kvm_vcpu *target_vcpu;
+static sem_t do_irq;
+
+static bool x2apic;
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	WRITE_ONCE(irqs_received, irqs_received + 1);
+
+	if (x2apic)
+		x2apic_write_reg(APIC_EOI, 0);
+	else
+		xapic_write_reg(APIC_EOI, 0);
+}
+
+static void guest_nmi_handler(struct ex_regs *regs)
+{
+	WRITE_ONCE(irqs_received, irqs_received + 1);
+}
+
+#define GUEST_VERIFY_IRQS()							\
+do {										\
+	int __received;								\
+										\
+	__received = READ_ONCE(irqs_received);					\
+	__GUEST_ASSERT(__received == irqs_sent,					\
+			"Sent %u IRQ, received %u IRQs", irqs_sent, __received);\
+} while (0)
+
+#define GUEST_WAIT_FOR_IRQ()	\
+do {				\
+	safe_halt();		\
+	GUEST_VERIFY_IRQS();	\
+	cli();			\
+} while (0)
+
+static void guest_code(uint32_t vcpu_id)
+{
+	/* GPA is identity mapped. */
+	void *mercury_bar0 = (void *)MERCURY_BAR0_GPA;
+	uint64_t status;
+	int i;
+
+	cli();
+
+	if (x2apic) {
+		x2apic_enable();
+		GUEST_ASSERT(x2apic_read_reg(APIC_ID) == vcpu_id);
+	} else {
+		xapic_enable();
+		GUEST_ASSERT(xapic_read_reg(APIC_ID) >> 24 == vcpu_id);
+	}
+
+	if (vcpu_id == 0) {
+		irqs_sent++;
+		GUEST_ASSERT(READ_ONCE(do_guest_irq));
+		mercury_issue_reset(mercury_bar0);
+		GUEST_WAIT_FOR_IRQ();
+
+		status = mercury_get_status(mercury_bar0);
+		__GUEST_ASSERT(status & BIT(MERCURY_STATUS_BIT_READY),
+			"Expected device ready after reset");
+		GUEST_SYNC(irqs_received);
+	}
+
+	for ( ; !READ_ONCE(done); ) {
+		irqs_sent++;
+		if (READ_ONCE(do_guest_irq))
+			mercury_force_irq(mercury_bar0);
+		GUEST_WAIT_FOR_IRQ();
+		GUEST_SYNC(irqs_received);
+	}
+
+	sti_nop();
+
+	for (i = 0; i < 1000; i++) {
+		mercury_force_irq(mercury_bar0);
+		cpu_relax();
+	}
+
+	GUEST_VERIFY_IRQS();
+	GUEST_SYNC(irqs_received);
+}
+
+static void *irq_worker(void *mercury_bar0)
+{
+	struct kvm_vcpu *vcpu;
+
+	for (;;) {
+		sem_wait(&do_irq);
+
+		if (READ_ONCE(done))
+			break;
+
+		vcpu = READ_ONCE(target_vcpu);
+		while (!vcpu_get_stat(vcpu, blocking))
+			cpu_relax();
+
+		mercury_force_irq(mercury_bar0);
+	}
+	return NULL;
+}
+
+static int next_cpu(int cpu)
+{
+	/*
+	 * Advance to the next CPU, skipping those that weren't in the original
+	 * affinity set.  Sadly, there is no CPU_SET_FOR_EACH, and cpu_set_t's
+	 * data storage is considered as opaque.  Note, if this task is pinned
+	 * to a small set of discontiguous CPUs, e.g. 2 and 1023, this loop will
+	 * burn a lot cycles and the test will take longer than normal to
+	 * complete.
+	 */
+	do {
+		cpu++;
+		if (cpu > max_cpu) {
+			cpu = min_cpu;
+			TEST_ASSERT(CPU_ISSET(cpu, &possible_mask),
+				    "Min CPU = %d must always be usable", cpu);
+			break;
+		}
+	} while (!CPU_ISSET(cpu, &possible_mask));
+
+	return cpu;
+}
+
+static void *migration_worker(void *__guest_tid)
+{
+	pid_t guest_tid = (pid_t)(unsigned long)__guest_tid;
+	cpu_set_t allowed_mask;
+	int r, i, cpu;
+
+	CPU_ZERO(&allowed_mask);
+
+	for (i = 0, cpu = min_cpu; !READ_ONCE(done); i++, cpu = next_cpu(cpu)) {
+		CPU_SET(cpu, &allowed_mask);
+
+		r = sched_setaffinity(guest_tid, sizeof(allowed_mask), &allowed_mask);
+		TEST_ASSERT(!r, "sched_setaffinity failed, errno = %d (%s)",
+			    errno, strerror(errno));
+
+		CPU_CLR(cpu, &allowed_mask);
+
+		usleep((i % 10) + 10);
+	}
+	return NULL;
+}
+
+static void calc_min_max_cpu(void)
+{
+	int i, cnt, nproc;
+
+	TEST_REQUIRE(CPU_COUNT(&possible_mask) >= 2);
+
+	/*
+	 * CPU_SET doesn't provide a FOR_EACH helper, get the min/max CPU that
+	 * this task is affined to in order to reduce the time spent querying
+	 * unusable CPUs, e.g. if this task is pinned to a small percentage of
+	 * total CPUs.
+	 */
+	nproc = get_nprocs_conf();
+	min_cpu = -1;
+	max_cpu = -1;
+	cnt = 0;
+
+	for (i = 0; i < nproc; i++) {
+		if (!CPU_ISSET(i, &possible_mask))
+			continue;
+		if (min_cpu == -1)
+			min_cpu = i;
+		max_cpu = i;
+		cnt++;
+	}
+
+	__TEST_REQUIRE(cnt >= 2, "Only one usable CPU, task migration not possible");
+}
+
+static void sanity_check_mercury_device(struct vfio_pci_dev *dev, void *bar0)
+{
+	uint16_t vendor_id, device_id;
+	uint32_t version;
+
+	vendor_id = vfio_pci_get_vendor_id(dev);
+	device_id = vfio_pci_get_device_id(dev);
+
+	TEST_ASSERT(vendor_id == MERCURY_VENDOR_ID &&
+		    device_id == MERCURY_DEVICE_ID,
+		    "Mercury vendor-id/device-id mismatch.  "
+		    "Expected vendor: 0x%04x, device: 0x%04x.  "
+		    "Got vendor: 0x%04x, device: 0x%04x",
+		    MERCURY_VENDOR_ID, MERCURY_DEVICE_ID,
+		    vendor_id, device_id);
+
+	version = mercury_read_reg32(bar0, MERCURY_REG_VERSION);
+	TEST_ASSERT_EQ(version, MERCURY_ABI_VERSION);
+}
+
+static void set_empty_routing(struct kvm_vm *vm, struct kvm_irq_routing *routing)
+{
+	routing->nr = 0;
+	routing->entries[0].gsi = MERCURY_GSI;
+	routing->entries[0].type = KVM_IRQ_ROUTING_IRQCHIP;
+	routing->entries[0].flags = 0;
+	routing->entries[0].u.msi.address_lo = 0;
+	routing->entries[0].u.msi.address_hi = 0;
+	routing->entries[0].u.msi.data = 0xfe;
+	vm_ioctl(vm, KVM_SET_GSI_ROUTING, routing);
+}
+
+static void set_gsi_dest(struct kvm_vcpu *vcpu, struct kvm_irq_routing *routing,
+			 bool do_nmi)
+{
+	routing->nr = 1;
+	routing->entries[0].gsi = MERCURY_GSI;
+	routing->entries[0].type = KVM_IRQ_ROUTING_MSI;
+	routing->entries[0].flags = 0;
+	routing->entries[0].u.msi.address_lo = (vcpu->id << 12);
+	routing->entries[0].u.msi.address_hi = 0;
+	if (do_nmi)
+		routing->entries[0].u.msi.data = NMI_VECTOR | (4 << 8);
+	else
+		routing->entries[0].u.msi.data = MERCURY_IRQ_VECTOR;
+	vm_ioctl(vcpu->vm, KVM_SET_GSI_ROUTING, routing);
+}
+
+static void vcpu_run_and_verify(struct kvm_vcpu *vcpu, int nr_irqs)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
+	TEST_ASSERT_EQ(uc.args[1], nr_irqs);
+}
+
+int main(int argc, char *argv[])
+{
+	bool migrate = false, nmi = false, async = false, empty = false;
+	pthread_t migration_thread, irq_thread;
+	struct kvm_irq_routing *routing;
+	struct vfio_pci_dev *dev;
+	struct kvm_vcpu *vcpus[2];
+	int opt, r, eventfd, i;
+	int nr_irqs = 10000;
+	struct kvm_vm *vm;
+	uint64_t bar_size;
+	char *bdf = NULL;
+	void *bar;
+
+	sem_init(&do_irq, 0, 0);
+
+	while ((opt = getopt(argc, argv, "had:ei:mnx")) != -1) {
+		switch (opt) {
+		case 'a':
+			async = true;
+			break;
+		case 'd':
+			bdf = strdup(optarg);
+			break;
+		case 'e':
+			empty = true;
+			break;
+		case 'i':
+			nr_irqs = atoi_positive("Number of IRQs", optarg);
+			break;
+		case 'm':
+			migrate = true;
+			break;
+		case 'n':
+			nmi = true;
+			break;
+		case 'x':
+			x2apic = false;
+			break;
+		case 'h':
+		default:
+			pr_info("Usage: %s [-h] <-d pci-bdf>\n\n", argv[0]);
+			pr_info("\t-d: PCI Domain, Bus, Device, Function in the format DDDD:BB:DD.F\n");
+			pr_info("\t-h: print this help screen\n");
+			exit(KSFT_SKIP);
+		}
+	}
+
+	__TEST_REQUIRE(bdf, "Required argument -d <pci-bdf> missing");
+
+	dev = vfio_pci_init(bdf);
+	bar = vfio_pci_map_bar(dev, VFIO_PCI_BAR0_REGION_INDEX, &bar_size);
+	sanity_check_mercury_device(dev, bar);
+
+	vm = vm_create_with_vcpus(ARRAY_SIZE(vcpus), guest_code, vcpus);
+	vm_install_exception_handler(vm, MERCURY_IRQ_VECTOR, guest_irq_handler);
+	vm_install_exception_handler(vm, NMI_VECTOR, guest_nmi_handler);
+
+	vcpu_args_set(vcpus[0], 1, 0);
+	vcpu_args_set(vcpus[1], 1, 1);
+
+	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
+
+	vm_set_user_memory_region(vm, MERCURY_BAR0_SLOT, 0, MERCURY_BAR0_GPA,
+				  bar_size, bar);
+	virt_map(vm, MERCURY_BAR0_GPA, MERCURY_BAR0_GPA,
+		 vm_calc_num_guest_pages(VM_MODE_DEFAULT, bar_size));
+
+	routing = kvm_gsi_routing_create();
+
+	eventfd = kvm_new_eventfd();
+	vfio_pci_assign_msix(dev, eventfd);
+	kvm_assign_irqfd(vm, MERCURY_GSI, eventfd);
+
+	r = sched_getaffinity(0, sizeof(possible_mask), &possible_mask);
+	TEST_ASSERT(!r, "sched_getaffinity failed, errno = %d (%s)", errno,
+		    strerror(errno));
+
+	if (migrate) {
+		calc_min_max_cpu();
+
+		pthread_create(&migration_thread, NULL, migration_worker,
+			       (void *)(unsigned long)syscall(SYS_gettid));
+	}
+
+	if (nmi || async)
+		pthread_create(&irq_thread, NULL, irq_worker, bar);
+
+	set_gsi_dest(vcpus[0], routing, false);
+	vcpu_run_and_verify(vcpus[0], 1);
+
+#if 0
+	/*
+	 * Hack if the user wants to manually mess with interrupt routing while
+	 * the test is running, e.g. by modifying smp_affinity in the host.
+	 */
+	for (i = 1; i < nr_irqs; i++) {
+		usleep(1000 * 1000);
+		vcpu_run_and_verify(vcpus[0], i + 1);
+	}
+#endif
+
+	for (i = 1; i < nr_irqs; i++) {
+		struct kvm_vcpu *vcpu = vcpus[!!(i & BIT(1))];
+		const bool do_nmi = nmi && (i & BIT(2));
+		const bool do_empty = empty && (i & BIT(3));
+		const bool do_async = nmi || async;
+
+		if (do_empty)
+			set_empty_routing(vm, routing);
+
+		set_gsi_dest(vcpu, routing, do_nmi);
+
+		WRITE_ONCE(do_guest_irq, !do_async);
+		sync_global_to_guest(vm, do_guest_irq);
+
+		if (do_async) {
+			WRITE_ONCE(target_vcpu, vcpu);
+			sem_post(&do_irq);
+		}
+
+		vcpu_run_and_verify(vcpu, i + 1);
+	}
+
+	WRITE_ONCE(done, true);
+	sync_global_to_guest(vm, done);
+	sem_post(&do_irq);
+
+	for (i = 0; empty && i < ARRAY_SIZE(vcpus); i++) {
+		struct kvm_vcpu *vcpu = vcpus[i];
+
+		if (!i)
+			set_gsi_dest(vcpu, routing, false);
+		set_empty_routing(vm, routing);
+		vcpu_run_and_verify(vcpu, nr_irqs);
+	}
+
+	set_gsi_dest(vcpus[0], routing, false);
+
+	if (migrate)
+		pthread_join(migration_thread, NULL);
+
+	if (nmi || async)
+		pthread_join(irq_thread, NULL);
+
+	r = munmap(bar, bar_size);
+	TEST_ASSERT(!r, __KVM_SYSCALL_ERROR("munmap()", r));
+
+	vfio_pci_free(dev);
+
+	return 0;
+}
-- 
2.49.0.504.g3bcea36a83-goog


