Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 117D51469A6
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgAWNsx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:53 -0500
Received: from foss.arm.com ([217.140.110.172]:39858 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729225AbgAWNsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 836C2106F;
        Thu, 23 Jan 2020 05:48:52 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 823BA3F68E;
        Thu, 23 Jan 2020 05:48:51 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 26/30] pci: Toggle BAR I/O and memory space emulation
Date:   Thu, 23 Jan 2020 13:48:01 +0000
Message-Id: <20200123134805.1993-27-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During configuration of the BAR addresses, a Linux guest disables and
enables access to I/O and memory space. When access is disabled, we don't
stop emulating the memory regions described by the BARs. Now that we have
callbacks for activating and deactivating emulation for a BAR region,
let's use that to stop emulation when access is disabled, and
re-activate it when access is re-enabled.

The vesa emulation hasn't been designed with toggling on and off in
mind, so refuse writes to the PCI command register that disable memory
or IO access.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 hw/vesa.c | 16 ++++++++++++++++
 pci.c     | 42 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/hw/vesa.c b/hw/vesa.c
index 74ebebbefa6b..3044a86078fb 100644
--- a/hw/vesa.c
+++ b/hw/vesa.c
@@ -81,6 +81,18 @@ static int vesa__bar_deactivate(struct kvm *kvm,
 	return -EINVAL;
 }
 
+static void vesa__pci_cfg_write(struct kvm *kvm, struct pci_device_header *pci_hdr,
+				u8 offset, void *data, int sz)
+{
+	u32 value;
+
+	if (offset == PCI_COMMAND) {
+		memcpy(&value, data, sz);
+		value |= (PCI_COMMAND_IO | PCI_COMMAND_MEMORY);
+		memcpy(data, &value, sz);
+	}
+}
+
 struct framebuffer *vesa__init(struct kvm *kvm)
 {
 	struct vesa_dev *vdev;
@@ -114,6 +126,10 @@ struct framebuffer *vesa__init(struct kvm *kvm)
 		.bar_size[1]		= VESA_MEM_SIZE,
 	};
 
+	vdev->pci_hdr.cfg_ops = (struct pci_config_operations) {
+		.write	= vesa__pci_cfg_write,
+	};
+
 	vdev->fb = (struct framebuffer) {
 		.width			= VESA_WIDTH,
 		.height			= VESA_HEIGHT,
diff --git a/pci.c b/pci.c
index 5412f2defa2e..98331a1fc205 100644
--- a/pci.c
+++ b/pci.c
@@ -157,6 +157,42 @@ static struct ioport_operations pci_config_data_ops = {
 	.io_out	= pci_config_data_out,
 };
 
+static void pci_config_command_wr(struct kvm *kvm,
+				  struct pci_device_header *pci_hdr,
+				  u16 new_command)
+{
+	int i;
+	bool toggle_io, toggle_mem;
+
+	toggle_io = (pci_hdr->command ^ new_command) & PCI_COMMAND_IO;
+	toggle_mem = (pci_hdr->command ^ new_command) & PCI_COMMAND_MEMORY;
+
+	for (i = 0; i < 6; i++) {
+		if (!pci_bar_is_implemented(pci_hdr, i))
+			continue;
+
+		if (toggle_io && pci__bar_is_io(pci_hdr, i)) {
+			if (__pci__io_space_enabled(new_command))
+				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
+							 pci_hdr->data);
+			else
+				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
+							   pci_hdr->data);
+		}
+
+		if (toggle_mem && pci__bar_is_memory(pci_hdr, i)) {
+			if (__pci__memory_space_enabled(new_command))
+				pci_hdr->bar_activate_fn(kvm, pci_hdr, i,
+							 pci_hdr->data);
+			else
+				pci_hdr->bar_deactivate_fn(kvm, pci_hdr, i,
+							   pci_hdr->data);
+		}
+	}
+
+	pci_hdr->command = new_command;
+}
+
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
 {
 	void *base;
@@ -182,6 +218,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	if (*(u32 *)(base + offset) == 0)
 		return;
 
+	if (offset == PCI_COMMAND) {
+		memcpy(&value, data, size);
+		pci_config_command_wr(kvm, pci_hdr, (u16)value);
+		return;
+	}
+
 	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
 
 	/*
-- 
2.20.1

