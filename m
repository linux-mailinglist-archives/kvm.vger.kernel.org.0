Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0BD194303
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 16:25:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgCZPY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 11:24:58 -0400
Received: from foss.arm.com ([217.140.110.172]:33692 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbgCZPY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 11:24:57 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A67FE1045;
        Thu, 26 Mar 2020 08:24:57 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A56703F71E;
        Thu, 26 Mar 2020 08:24:56 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        andre.przywara@arm.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH v3 kvmtool 03/32] pci: Fix BAR resource sizing arbitration
Date:   Thu, 26 Mar 2020 15:24:09 +0000
Message-Id: <20200326152438.6218-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200326152438.6218-1-alexandru.elisei@arm.com>
References: <20200326152438.6218-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sami Mujawar <sami.mujawar@arm.com>

According to the 'PCI Local Bus Specification, Revision 3.0,
February 3, 2004, Section 6.2.5.1, Implementation Notes, page 227'

    "Software saves the original value of the Base Address register,
    writes 0 FFFF FFFFh to the register, then reads it back. Size
    calculation can be done from the 32-bit value read by first
    clearing encoding information bits (bit 0 for I/O, bits 0-3 for
    memory), inverting all 32 bits (logical NOT), then incrementing
    by 1. The resultant 32-bit value is the memory/I/O range size
    decoded by the register. Note that the upper 16 bits of the result
    is ignored if the Base Address register is for I/O and bits 16-31
    returned zero upon read."

kvmtool was returning the actual BAR resource size which would be
incorrect as the software software drivers would invert all 32 bits
(logical NOT), then incrementing by 1. This ends up with a very large
resource size (in some cases more than 4GB) due to which drivers
assert/fail to work.

e.g if the BAR resource size was 0x1000, kvmtool would return 0x1000
instead of 0xFFFFF00x.

Fixed pci__config_wr() to return the size of the BAR in accordance with
the PCI Local Bus specification, Implementation Notes.

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Sami Mujawar <sami.mujawar@arm.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
[Reworked algorithm, removed power-of-two check]
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 pci.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/pci.c b/pci.c
index 689869cb79a3..3198732935eb 100644
--- a/pci.c
+++ b/pci.c
@@ -149,6 +149,8 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	u8 bar, offset;
 	struct pci_device_header *pci_hdr;
 	u8 dev_num = addr.device_number;
+	u32 value = 0;
+	u32 mask;
 
 	if (!pci_device_exists(addr.bus_number, dev_num, 0))
 		return;
@@ -169,13 +171,41 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	bar = (offset - PCI_BAR_OFFSET(0)) / sizeof(u32);
 
 	/*
-	 * If the kernel masks the BAR it would expect to find the size of the
-	 * BAR there next time it reads from it. When the kernel got the size it
-	 * would write the address back.
+	 * If the kernel masks the BAR, it will expect to find the size of the
+	 * BAR there next time it reads from it. After the kernel reads the
+	 * size, it will write the address back.
 	 */
-	if (bar < 6 && ioport__read32(data) == 0xFFFFFFFF) {
-		u32 sz = pci_hdr->bar_size[bar];
-		memcpy(base + offset, &sz, sizeof(sz));
+	if (bar < 6) {
+		if (pci_hdr->bar[bar] & PCI_BASE_ADDRESS_SPACE_IO)
+			mask = (u32)PCI_BASE_ADDRESS_IO_MASK;
+		else
+			mask = (u32)PCI_BASE_ADDRESS_MEM_MASK;
+		/*
+		 * According to the PCI local bus specification REV 3.0:
+		 * The number of upper bits that a device actually implements
+		 * depends on how much of the address space the device will
+		 * respond to. A device that wants a 1 MB memory address space
+		 * (using a 32-bit base address register) would build the top
+		 * 12 bits of the address register, hardwiring the other bits
+		 * to 0.
+		 *
+		 * Furthermore, software can determine how much address space
+		 * the device requires by writing a value of all 1's to the
+		 * register and then reading the value back. The device will
+		 * return 0's in all don't-care address bits, effectively
+		 * specifying the address space required.
+		 *
+		 * Software computes the size of the address space with the
+		 * formula S = ~B + 1, where S is the memory size and B is the
+		 * value read from the BAR. This means that the BAR value that
+		 * kvmtool should return is B = ~(S - 1).
+		 */
+		memcpy(&value, data, size);
+		if (value == 0xffffffff)
+			value = ~(pci_hdr->bar_size[bar] - 1);
+		/* Preserve the special bits. */
+		value = (value & mask) | (pci_hdr->bar[bar] & ~mask);
+		memcpy(base + offset, &value, size);
 	} else {
 		memcpy(base + offset, data, size);
 	}
-- 
2.20.1

