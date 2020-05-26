Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2851D354C
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 17:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbgENPix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 11:38:53 -0400
Received: from foss.arm.com ([217.140.110.172]:39220 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728026AbgENPiw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 May 2020 11:38:52 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AACC51FB;
        Thu, 14 May 2020 08:38:51 -0700 (PDT)
Received: from e121566-lin.arm.com (unknown [10.57.31.200])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 92FB73F71E;
        Thu, 14 May 2020 08:38:50 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v4 kvmtool 09/12] pci: Toggle BAR I/O and memory space emulation
Date:   Thu, 14 May 2020 16:38:26 +0100
Message-Id: <1589470709-4104-10-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
References: <1589470709-4104-1-git-send-email-alexandru.elisei@arm.com>
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

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 pci.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/pci.c b/pci.c
index b8e71b5f8d6c..96239160110c 100644
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
2.7.4

