Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 613C3194312
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbgCZPZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:25:19 -0400
Received: from foss.arm.com ([217.140.110.172]:33844 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbgCZPZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:25:17 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28A3B1045;
        Thu, 26 Mar 2020 08:25:17 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3FA2A3F71E;
        Thu, 26 Mar 2020 08:25:16 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com
Subject: [PATCH v3 kvmtool 20/32] pci: Add helpers for BAR values and memory/IO space access
Date:   Thu, 26 Mar 2020 15:24:26 +0000
Message-Id: <20200326152438.6218-21-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We're going to be checking the BAR type, the address written to it and if
access to memory or I/O space is enabled quite often when we add support
for reasignable BARs; make our life easier by adding helpers for it.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 include/kvm/pci.h   | 53 +++++++++++++++++++++++++++++++++++++++++++++
 pci.c               |  4 ++--
 powerpc/spapr_pci.c |  2 +-
 3 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/kvm/pci.h b/include/kvm/pci.h
index ccb155e3e8fe..adb4b5c082d5 100644
--- a/include/kvm/pci.h
+++ b/include/kvm/pci.h
@@ -5,6 +5,7 @@
 #include <linux/kvm.h>
 #include <linux/pci_regs.h>
 #include <endian.h>
+#include <stdbool.h>
 
 #include "kvm/devices.h"
 #include "kvm/msi.h"
@@ -161,4 +162,56 @@ void pci__config_rd(struct kvm *kvm, union pci_config_address addr, void *data,
 
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
+static inline u32 pci__bar_size(struct pci_device_header *pci_hdr, int bar_num)
+{
+	return pci_hdr->bar_size[bar_num];
+}
+
 #endif /* KVM__PCI_H */
diff --git a/pci.c b/pci.c
index b6892d974c08..7399c76c0819 100644
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
@@ -211,7 +211,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 		 */
 		memcpy(&value, data, size);
 		if (value == 0xffffffff)
-			value = ~(pci_hdr->bar_size[bar] - 1);
+			value = ~(pci__bar_size(pci_hdr, bar) - 1);
 		/* Preserve the special bits. */
 		value = (value & mask) | (pci_hdr->bar[bar] & ~mask);
 		memcpy(base + offset, &value, size);
diff --git a/powerpc/spapr_pci.c b/powerpc/spapr_pci.c
index a15f7d895a46..7be44d950acb 100644
--- a/powerpc/spapr_pci.c
+++ b/powerpc/spapr_pci.c
@@ -369,7 +369,7 @@ int spapr_populate_pci_devices(struct kvm *kvm,
 				of_pci_b_ddddd(devid) |
 				of_pci_b_fff(fn) |
 				of_pci_b_rrrrrrrr(bars[i]));
-			reg[n+1].size = cpu_to_be64(hdr->bar_size[i]);
+			reg[n+1].size = cpu_to_be64(pci__bar_size(hdr, i));
 			reg[n+1].addr = 0;
 
 			assigned_addresses[n].phys_hi = cpu_to_be32(
-- 
2.20.1

