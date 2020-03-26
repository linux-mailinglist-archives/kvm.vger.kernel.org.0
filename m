Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCD194318
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgCZPZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:27 -0400
Received: from foss.arm.com ([217.140.110.172]:33922 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbgCZPZ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:27 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4281F7FA;
        Thu, 26 Mar 2020 08:25:26 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5AE833F71E;
        Thu, 26 Mar 2020 08:25:25 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 28/32] pci: Toggle BAR I/O and memory space emulation
Date:   Thu, 26 Mar 2020 15:24:34 +0000
Message-Id: <20200326152438.6218-29-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
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

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 pci.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/pci.c b/pci.c
index 4ace190898f2..c2860e6707fe 100644
--- a/pci.c
+++ b/pci.c
@@ -163,6 +163,42 @@ static struct ioport_operations pci_config_data_ops = {
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
@@ -188,6 +224,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
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

