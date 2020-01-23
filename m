Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21D5914699A
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 14:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgAWNsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 08:48:46 -0500
Received: from foss.arm.com ([217.140.110.172]:39806 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729190AbgAWNsp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 08:48:45 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B190FEC;
        Thu, 23 Jan 2020 05:48:45 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08C2F3F68E;
        Thu, 23 Jan 2020 05:48:43 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: [PATCH v2 kvmtool 20/30] pci: Add helpers for BAR values and memory/IO space access
Date:   Thu, 23 Jan 2020 13:47:55 +0000
Message-Id: <20200123134805.1993-21-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200123134805.1993-1-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We're going to be checking the BAR type, the address written to it and
if access to memory or I/O space is enabled quite often when we add
support for reasignable BARs, add helpers for it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/pci.h | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 pci.c             |  2 +-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index ccb155e3e8fe..235cd82fff3c 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -5,6 +5,7 @@
 #include <linux/kvm.h>
 #include <linux/pci_regs.h>
 #include <endian.h>
+#include <stdbool.h>
 
 #include "kvm/devices.h"
 #include "kvm/msi.h"
@@ -161,4 +162,51 @@ void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data,
 
 void *pci_find_cap(struct pci_device_header *hdr, u8 cap_type);
 
+static inline bool __pci__memory_space_enabled(u16 command)
+{
+	return command & PCI_COMMAND_MEMORY;
+}
+
+static inline bool pci__memory_space_enabled(struct pci_device_header *pci_hdr)
+{
+	return __pci__memory_space_enabled(pci_hdr->command);
+}
+
+static inline bool __pci__io_space_enabled(u16 command)
+{
+	return command & PCI_COMMAND_IO;
+}
+
+static inline bool pci__io_space_enabled(struct pci_device_header *pci_hdr)
+{
+	return __pci__io_space_enabled(pci_hdr->command);
+}
+
+static inline bool __pci__bar_is_io(u32 bar)
+{
+	return bar & PCI_BASE_ADDRESS_SPACE_IO;
+}
+
+static inline bool pci__bar_is_io(struct pci_device_header *pci_hdr, int bar_num)
+{
+	return __pci__bar_is_io(pci_hdr->bar[bar_num]);
+}
+
+static inline bool pci__bar_is_memory(struct pci_device_header *pci_hdr, int bar_num)
+{
+	return !pci__bar_is_io(pci_hdr, bar_num);
+}
+
+static inline u32 __pci__bar_address(u32 bar)
+{
+	if (__pci__bar_is_io(bar))
+		return bar & PCI_BASE_ADDRESS_IO_MASK;
+	return bar & PCI_BASE_ADDRESS_MEM_MASK;
+}
+
+static inline u32 pci__bar_address(struct pci_device_header *pci_hdr, int bar_num)
+{
+	return __pci__bar_address(pci_hdr->bar[bar_num]);
+}
+
 #endif /* KVM__PCI_H */
diff --git a/pci.c b/pci.c
index b6892d974c08..4f7b863298f6 100644
--- a/pci.c
+++ b/pci.c
@@ -185,7 +185,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	 * size, it will write the address back.
 	 */
 	if (bar < 6) {
-		if (pci_hdr->bar[bar] & PCI_BASE_ADDRESS_SPACE_IO)
+		if (pci__bar_is_io(pci_hdr, bar))
 			mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
 		else
 			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
-- 
2.20.1

