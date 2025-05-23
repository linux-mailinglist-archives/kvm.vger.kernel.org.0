Return-Path: <kvm+bounces-47638-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84966AC2C4F
	for <lists+kvm@lfdr.de>; Sat, 24 May 2025 01:32:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A66E1BA3069
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 23:32:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3772236EE;
	Fri, 23 May 2025 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x2C8vesQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635EC21884B
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 23:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043062; cv=none; b=oWYlzXcABwCuyz8xPXAOtPSvXtCTHMsRLhzOf4muedW8b8Th2V1NgWsg34V8MpXKp9vUUroRkpqdT5kMqKMJ13mE5vl4TdTa7MbuoSarLoP6lMeiVptREqKv0FZcBsn7Zg2JnYfQXywxV+xMPXZlQ3oGSE+t8NIxXZxTFSntajI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043062; c=relaxed/simple;
	bh=vWlGzt8s+Kk627a08q+Sglk8IljZNn0mmb0hNiI9dhM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E1TQOZ3PJwx9WYS1Fti4w2EUN1CeXKED0qEW6M6xsAvQLeUL8eq2O7sOnU9L7veI/eEu0Rjalr+Ziyb/AHEBV6pBVC0Cp/biqLE7OxsQ3N25NsMTmUXu8gjl71+/XZb0F6HiwZLi5+gv/844BMQyvtv5FZdZ6JCaOrahgjH8yzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x2C8vesQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-30eac9886ffso325469a91.1
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 16:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748043060; x=1748647860; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bWw0k27VBMqhEzZ5PBypu3ARmcQZZ5GbWXp8VsW01CY=;
        b=x2C8vesQ2Za7W8oLbl8BnkCa2hj5rv+tMsaPOuRZhgonQmQlRGgr1zJJZq3HKYJ5Ba
         qn6p5iLl5IDx+YeMx+Uhs7d2hAAzqRd4p87jers9TVB61JLaCJzqd/DPoNJb6W9C/FgS
         9Q0ZXcUScNIIZFiWBaMb3BC36CkcMRNzi2lq9/oAXVkvNxKj0cfkS1QHAQjPC7KtheiA
         z6bT4BxdhhUbVnLWZhCJ9QEtR3DS/26cRP2jJJZPn/lAa1lFgnplzDz8qZc6hIj+y5QP
         1yj7M/r54KUO0rE1qp+KxC3q9XwVA83UgPn8rEssb+T5Yinh0UM0efw8DblrqJ5jDxuV
         2DqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748043060; x=1748647860;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bWw0k27VBMqhEzZ5PBypu3ARmcQZZ5GbWXp8VsW01CY=;
        b=PTxs0VtJ+rjnMGn/HQ8MUtxxRi6mOvy8U+6/uVVu5/ws3RC4OFm7gqLfizlWsKInSm
         q+69GFG+tb9h2ek1ggMpjAWdJ87d2e09FK0ENjRRISqxEbZKUotR1JGRA2bPuJv4j9ap
         bEPPjt4ixHomjsN+g/14MGXYaax7SaOfDuIP4vaXfBWIet8tPhA6767tGufm9ROuuYog
         Jgv9eLOVWjsXDg1ttCmmQCCV5z7PjilwQxniXvHeAYc5+qD3DYdziO/bxY18sSJR0k2d
         euQKIlBnyN8bSVccG9xuzTqeEVL3cy/seONJfSpruKMf9WbMQuATGgFV9hVzbx8T0ReE
         Aa7A==
X-Forwarded-Encrypted: i=1; AJvYcCWCyX0CVDjRUTzksXvRz4bIMZKHnDnmmu8iwnNCbhRwyJwIGZxxd1aF0HFy8iECcjx1EMk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQm0uU9y9x9xby65hCpWZFAdCAOI5hz52BNbtp8D7+jK7sYHee
	Zlz6SWCAXzYS9jE4AXFYG/z4vtwSRezofQmO4hvDpTfUJkM1MGqIwkJyTlYy1A6+ZuaR8ffQaFv
	w/4FbtqPsU2STvQ==
X-Google-Smtp-Source: AGHT+IHNcA1GDJETrzBilxauzS41thz8K3l8Z2PEqbNaNlPOmCg/xfWRbYHZJglPySS4i9KJmWBtEd22ICfWeg==
X-Received: from pjbkl8.prod.google.com ([2002:a17:90b:4988:b0:310:f76d:7b8d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:52c6:b0:2ee:ab29:1a63 with SMTP id 98e67ed59e1d1-3110f0ee8a9mr1331931a91.3.1748043059767;
 Fri, 23 May 2025 16:30:59 -0700 (PDT)
Date: Fri, 23 May 2025 23:30:06 +0000
In-Reply-To: <20250523233018.1702151-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523233018.1702151-1-dmatlack@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523233018.1702151-22-dmatlack@google.com>
Subject: [RFC PATCH 21/33] vfio: selftests: Add driver for Intel CBDMA
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, Vinod Koul <vkoul@kernel.org>, 
	Fenghua Yu <fenghua.yu@intel.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, 
	Adhemerval Zanella <adhemerval.zanella@linaro.org>, Jiri Olsa <jolsa@kernel.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Takashi Iwai <tiwai@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, WangYuli <wangyuli@uniontech.com>, 
	Sean Christopherson <seanjc@google.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Eric Auger <eric.auger@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, Vipin Sharma <vipinsh@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Vinicius Costa Gomes <vinicius.gomes@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Add a driver for the Intel CBDMA device. This driver is based on and
named after the Linux driver for this device (drivers/dma/ioat/) and
also based on previous work from Peter Shier <pshier@google.com>.

The driver aims to be as simple as possible. It uses a single descriptor
to issue DMA operations, and only supports the copy operation. For "DMA
storms", the driver kicks off the maximum number of maximum-sized DMA
operations. On Skylake server parts, this was 2^16-1 copies of size 2M
and lasts about 15 seconds.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/vfio/lib/drivers/ioat.c | 235 ++++++++++++++++++
 tools/testing/selftests/vfio/lib/libvfio.mk   |   7 +
 .../selftests/vfio/lib/vfio_pci_driver.c      |  10 +-
 3 files changed, 251 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/vfio/lib/drivers/ioat.c

diff --git a/tools/testing/selftests/vfio/lib/drivers/ioat.c b/tools/testing/selftests/vfio/lib/drivers/ioat.c
new file mode 100644
index 000000000000..bb6d054e6c4b
--- /dev/null
+++ b/tools/testing/selftests/vfio/lib/drivers/ioat.c
@@ -0,0 +1,235 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <stdint.h>
+#include <unistd.h>
+
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/pci_ids.h>
+#include <linux/sizes.h>
+
+#include <vfio_util.h>
+
+#include <drivers/dma/ioat/hw.h>
+#include <drivers/dma/ioat/registers.h>
+
+#define IOAT_DMACOUNT_MAX UINT16_MAX
+
+struct ioat_state {
+	/* Single descriptor used to issue DMA memcpy operations */
+	struct ioat_dma_descriptor desc;
+
+	/* Copy buffers used by ioat_send_msi() to generate an interrupt. */
+	u64 send_msi_src;
+	u64 send_msi_dst;
+};
+
+static inline struct ioat_state *to_ioat_state(struct vfio_pci_device *device)
+{
+	return device->driver.region.vaddr;
+}
+
+static inline void *ioat_channel_registers(struct vfio_pci_device *device)
+{
+	return device->bars[0].vaddr + IOAT_CHANNEL_MMIO_SIZE;
+}
+
+static int ioat_probe(struct vfio_pci_device *device)
+{
+	u8 version;
+	int r;
+
+	if (!vfio_pci_device_match(device, PCI_VENDOR_ID_INTEL,
+				   PCI_DEVICE_ID_INTEL_IOAT_SKX))
+		return -EINVAL;
+
+	VFIO_ASSERT_NOT_NULL(device->bars[0].vaddr);
+
+	version = readb(device->bars[0].vaddr + IOAT_VER_OFFSET);
+	switch (version) {
+	case IOAT_VER_3_2:
+	case IOAT_VER_3_3:
+		r = 0;
+		break;
+	default:
+		printf("ioat: Unsupported version: 0x%x\n", version);
+		r = -EINVAL;
+	}
+	return r;
+}
+
+static u64 ioat_channel_status(void *bar)
+{
+	return readq(bar + IOAT_CHANSTS_OFFSET) & IOAT_CHANSTS_STATUS;
+}
+
+static void ioat_clear_errors(struct vfio_pci_device *device)
+{
+	void *registers = ioat_channel_registers(device);
+	u32 errors;
+
+	errors = vfio_pci_config_readl(device, IOAT_PCI_CHANERR_INT_OFFSET);
+	vfio_pci_config_writel(device, IOAT_PCI_CHANERR_INT_OFFSET, errors);
+
+	errors = vfio_pci_config_readl(device, IOAT_PCI_DMAUNCERRSTS_OFFSET);
+	vfio_pci_config_writel(device, IOAT_PCI_CHANERR_INT_OFFSET, errors);
+
+	errors = readl(registers + IOAT_CHANERR_OFFSET);
+	writel(errors, registers + IOAT_CHANERR_OFFSET);
+}
+
+static void ioat_reset(struct vfio_pci_device *device)
+{
+	void *registers = ioat_channel_registers(device);
+	u32 sleep_ms = 1, attempts = 5000 / sleep_ms;
+	u8 chancmd;
+
+	ioat_clear_errors(device);
+
+	writeb(IOAT_CHANCMD_RESET, registers + IOAT2_CHANCMD_OFFSET);
+
+	for (;;) {
+		chancmd = readb(registers + IOAT2_CHANCMD_OFFSET);
+		if (!(chancmd & IOAT_CHANCMD_RESET))
+			break;
+
+		VFIO_ASSERT_GT(--attempts, 0);
+		usleep(sleep_ms * 1000);
+	}
+
+	VFIO_ASSERT_EQ(ioat_channel_status(registers), IOAT_CHANSTS_HALTED);
+}
+
+static void ioat_init(struct vfio_pci_device *device)
+{
+	struct ioat_state *ioat = to_ioat_state(device);
+	u8 intrctrl;
+
+	VFIO_ASSERT_GE(device->driver.region.size, sizeof(*ioat));
+
+	vfio_pci_config_writew(device, PCI_COMMAND,
+			       PCI_COMMAND_MEMORY |
+			       PCI_COMMAND_MASTER |
+			       PCI_COMMAND_INTX_DISABLE);
+
+	ioat_reset(device);
+
+	/* Enable the use of MXI-x interrupts for channel interrupts. */
+	intrctrl = IOAT_INTRCTRL_MSIX_VECTOR_CONTROL;
+	writeb(intrctrl, device->bars[0].vaddr + IOAT_INTRCTRL_OFFSET);
+
+	vfio_pci_msix_enable(device, 0, device->msix_info.count);
+
+	device->driver.msi = 0;
+	device->driver.max_memcpy_size =
+		1UL << readb(device->bars[0].vaddr + IOAT_XFERCAP_OFFSET);
+	device->driver.max_memcpy_count = IOAT_DMACOUNT_MAX;
+}
+
+static void ioat_remove(struct vfio_pci_device *device)
+{
+	ioat_reset(device);
+	vfio_pci_msix_disable(device);
+}
+
+static void ioat_handle_error(struct vfio_pci_device *device)
+{
+	void *registers = ioat_channel_registers(device);
+
+	printf("Error detected during memcpy operation!\n"
+	       "  CHANERR: 0x%x\n"
+	       "  CHANERR_INT: 0x%x\n"
+	       "  DMAUNCERRSTS: 0x%x\n",
+	       readl(registers + IOAT_CHANERR_OFFSET),
+	       vfio_pci_config_readl(device, IOAT_PCI_CHANERR_INT_OFFSET),
+	       vfio_pci_config_readl(device, IOAT_PCI_DMAUNCERRSTS_OFFSET));
+
+	ioat_reset(device);
+}
+
+static int ioat_memcpy_wait(struct vfio_pci_device *device)
+{
+	void *registers = ioat_channel_registers(device);
+	u64 status;
+	int r = 0;
+
+	/* Wait until all operations complete. */
+	for (;;) {
+		status = ioat_channel_status(registers);
+		if (status == IOAT_CHANSTS_DONE)
+			break;
+
+		if (status == IOAT_CHANSTS_HALTED) {
+			ioat_handle_error(device);
+			return -1;
+		}
+	}
+
+	/* Put the channel into the SUSPENDED state. */
+	writeb(IOAT_CHANCMD_SUSPEND, registers + IOAT2_CHANCMD_OFFSET);
+	for (;;) {
+		status = ioat_channel_status(registers);
+		if (status == IOAT_CHANSTS_SUSPENDED)
+			break;
+	}
+
+	return r;
+}
+
+static void __ioat_memcpy_start(struct vfio_pci_device *device,
+				iova_t src, iova_t dst, u64 size,
+				u16 count, bool interrupt)
+{
+	void *registers = ioat_channel_registers(device);
+	struct ioat_state *ioat = to_ioat_state(device);
+	u64 desc_iova;
+	u16 chanctrl;
+
+	desc_iova = to_iova(device, &ioat->desc);
+	ioat->desc = (struct ioat_dma_descriptor) {
+		.ctl_f.op = IOAT_OP_COPY,
+		.ctl_f.int_en = interrupt,
+		.src_addr = src,
+		.dst_addr = dst,
+		.size = size,
+		.next = desc_iova,
+	};
+
+	/* Tell the device the address of the descriptor. */
+	writeq(desc_iova, registers + IOAT2_CHAINADDR_OFFSET);
+
+	/* (Re)Enable the channel interrupt and abort on any errors */
+	chanctrl = IOAT_CHANCTRL_INT_REARM | IOAT_CHANCTRL_ANY_ERR_ABORT_EN;
+	writew(chanctrl, registers + IOAT_CHANCTRL_OFFSET);
+
+	/* Kick off @count DMA copy operation(s). */
+	writew(count, registers + IOAT_CHAN_DMACOUNT_OFFSET);
+}
+
+static void ioat_memcpy_start(struct vfio_pci_device *device,
+			      iova_t src, iova_t dst, u64 size,
+			      u64 count)
+{
+	__ioat_memcpy_start(device, src, dst, size, count, false);
+}
+
+static void ioat_send_msi(struct vfio_pci_device *device)
+{
+	struct ioat_state *ioat = to_ioat_state(device);
+
+	__ioat_memcpy_start(device,
+			    to_iova(device, &ioat->send_msi_src),
+			    to_iova(device, &ioat->send_msi_dst),
+			    sizeof(ioat->send_msi_src), 1, true);
+
+	VFIO_ASSERT_EQ(ioat_memcpy_wait(device), 0);
+}
+
+const struct vfio_pci_driver_ops ioat_ops = {
+	.name = "ioat",
+	.probe = ioat_probe,
+	.init = ioat_init,
+	.remove = ioat_remove,
+	.memcpy_start = ioat_memcpy_start,
+	.memcpy_wait = ioat_memcpy_wait,
+	.send_msi = ioat_send_msi,
+};
diff --git a/tools/testing/selftests/vfio/lib/libvfio.mk b/tools/testing/selftests/vfio/lib/libvfio.mk
index 10a1a9316e4c..2ec24bb597fc 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.mk
+++ b/tools/testing/selftests/vfio/lib/libvfio.mk
@@ -1,8 +1,15 @@
+include $(top_srcdir)/scripts/subarch.include
+ARCH ?= $(SUBARCH)
+
 VFIO_DIR := $(selfdir)/vfio
 
 LIBVFIO_C := lib/vfio_pci_device.c
 LIBVFIO_C += lib/vfio_pci_driver.c
 
+ifeq ($(ARCH:x86_64=x86),x86)
+LIBVFIO_C += lib/drivers/ioat.c
+endif
+
 LIBVFIO_O := $(patsubst %.c, $(OUTPUT)/%.o, $(LIBVFIO_C))
 
 LIBVFIO_O_DIRS := $(shell dirname $(LIBVFIO_O) | uniq)
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
index c98bd2d31d8a..aa47360e47a9 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -4,7 +4,15 @@
 #include "../../../kselftest.h"
 #include <vfio_util.h>
 
-static struct vfio_pci_driver_ops *driver_ops[] = {};
+#ifdef __x86_64__
+extern struct vfio_pci_driver_ops ioat_ops;
+#endif
+
+static struct vfio_pci_driver_ops *driver_ops[] = {
+#ifdef __x86_64__
+	&ioat_ops,
+#endif
+};
 
 void vfio_pci_driver_probe(struct vfio_pci_device *device)
 {
-- 
2.49.0.1151.ga128411c76-goog


