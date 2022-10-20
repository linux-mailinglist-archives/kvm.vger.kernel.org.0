Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B4C60671D
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 19:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiJTRgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 13:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiJTRgU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 13:36:20 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E1C11DA92
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:36:12 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bk15so46228wrb.13
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 10:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B8EXvFQblr3DKpT/gyAk0p2WP1dL6ejwPZEEYOcokdY=;
        b=kNZqyQvKGRJSGVhl7U1GYSLAZZYtw+M9dGLKYpyvdy5TRuhZlFcaphHbsf7AaXn6LB
         3tW/VV8UXZc1CpGu/BkDmjqVV8QnVOGHqxuaIkpfLSowHNHGfntgtpWbobLUvodnaDPX
         2rtUi4RZpzzBBE9rAgaEkpmhvcf3Fi8Izk2py/ABcINzLBpnQCCHNuI0NtVgSpiSxzA/
         nbUnPNEEC0u7dXzh4YxC5+0iv2qeMinWNwfwmPDdKpAlD+a03/LVMhAlsc1acn0b6khS
         Pwilai5VRp6I1XmYy6NZkoMAj8+3cisEm8e2R7jV6X7s/7S2ISSYIirLQI7cI4FE6IaO
         UHaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B8EXvFQblr3DKpT/gyAk0p2WP1dL6ejwPZEEYOcokdY=;
        b=cBHsEj/S1AuQLaifXK1aeU6y9J1zD0K81uVucYEOTtkR9nUlb4rVSUOAXI517oJJ6f
         psOsvBVyznA/5O0dxS9sJv/d88OzqwoI74toBTB6dNWaaC1SNLFgfSwot53ki+iUzLIR
         Vz9QsZC+vPyx5bI8iimXhmBf4vs/wtEn0NN3oUPo7SPwKFwjo/UEZtMLYXB1z04Mu63Q
         H3kEhCV/D5SrpmWDO8BcMl/nDma8yXIltblbKiBjC5MTk2gTorpHZEYmtI8upPP7KkIj
         Q5bZvzOwbuBja2OoXgWglJ0/9hA9PQJNvANW9iN1WjdXlQhOnpoVWyyo56pu8TygrNkq
         20lw==
X-Gm-Message-State: ACrzQf0b4/MfwXa4zC4ncQfaEVV1yl5Ed86IpwbhZpzXzBtl3rtgyaSf
        cbKUtMDXPeGQvoLFDJph8pxl4pZLIhnMYw==
X-Google-Smtp-Source: AMsMyM4+4GKoTyflh5y3QmK+RmvFkddiSjpMMJkS2i1E95DEBlE7ouSK5P9w6UQ+/rzOTRU3c3F4Ig==
X-Received: by 2002:a05:6000:1aca:b0:231:d8e5:5bde with SMTP id i10-20020a0560001aca00b00231d8e55bdemr9097674wry.446.1666287359998;
        Thu, 20 Oct 2022 10:35:59 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id a15-20020adfeecf000000b00228692033dcsm16313303wrp.91.2022.10.20.10.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 10:35:59 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH kvmtool v2] pci: Disable writes to Status register
Date:   Thu, 20 Oct 2022 18:34:53 +0100
Message-Id: <20221020173452.203043-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although the PCI Status register only contains read-only and
write-1-to-clear bits, we currently keep anything written there, which
can confuse a guest.

The problem was highlighted by recent Linux commit 6cd514e58f12 ("PCI:
Clear PCI_STATUS when setting up device"), which unconditionally writes
0xffff to the Status register in order to clear pending errors. Then the
EDAC driver sees the parity status bits set and attempts to clear them
by writing 0xc100, which in turn clears the Capabilities List bit.
Later on, when the virtio-pci driver starts probing, it assumes due to
missing capabilities that the device is using the legacy transport, and
fails to setup the device because of mismatched protocol.

Filter writes to the config space, keeping only those to writable
fields. Tighten the access size check while we're at it, to prevent
overflow. This is only a small step in the right direction, not a
foolproof solution, because a guest could still write both Command and
Status registers using a single 32-bit write. More work is needed for:
* Supporting arbitrary sized writes.
* Sanitizing accesses to capabilities, which are device-specific.

Also remove the old hack that filtered accesses. It was most likely
guarding against ROM BAR writes, which is now handled by the
pci_config_writable bitmap.

Reported-by: Pierre Gondois <pierre.gondois@arm.com>
Tested-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
Since v1 [1], I added Alex' suggestions:
* Filter PCI_COMMAND bits
* Also sanitize PIO access length. I'm not as comfortable rejecting a
  boundary-crossing accesses as for ECAM, since the PCI spec is not as
  clear cut, so just update the length. The guests I looked at seem to
  be sane anyway.
* Call VFIO write after checking the mask.

Note that the issue described here only shows up during ACPI boot for
me, because edac_init() happens after PCI enumeration. With DT boot,
edac_pci_clear_parity_errors() runs earlier and doesn't find any device.

[1] https://lore.kernel.org/kvm/20220908144208.231272-1-jean-philippe@linaro.org/
---
 pci.c | 54 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/pci.c b/pci.c
index a769ae27..b170885c 100644
--- a/pci.c
+++ b/pci.c
@@ -117,9 +117,6 @@ static void pci_config_data_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 {
 	union pci_config_address pci_config_address;
 
-	if (len > 4)
-		len = 4;
-
 	pci_config_address.w = ioport__read32(&pci_config_address_bits);
 	/*
 	 * If someone accesses PCI configuration space offsets that are not
@@ -127,6 +124,9 @@ static void pci_config_data_mmio(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	 */
 	pci_config_address.reg_offset = addr - PCI_CONFIG_DATA;
 
+	/* Ensure the access does not cross a 4-byte boundary */
+	len = min(len, 4U - pci_config_address.reg_offset);
+
 	if (is_write)
 		pci__config_wr(vcpu->kvm, pci_config_address, data, len);
 	else
@@ -350,6 +350,24 @@ static void pci_config_bar_wr(struct kvm *kvm,
 	pci_activate_bar_regions(kvm, old_addr, bar_size);
 }
 
+/*
+ * Bits that are writable in the config space header.
+ * Write-1-to-clear Status bits are missing since we never set them.
+ */
+static const u8 pci_config_writable[PCI_STD_HEADER_SIZEOF] = {
+	[PCI_COMMAND] =
+		PCI_COMMAND_IO |
+		PCI_COMMAND_MEMORY |
+		PCI_COMMAND_MASTER |
+		PCI_COMMAND_PARITY,
+	[PCI_COMMAND + 1] =
+		(PCI_COMMAND_SERR |
+		 PCI_COMMAND_INTX_DISABLE) >> 8,
+	[PCI_INTERRUPT_LINE] = 0xff,
+	[PCI_BASE_ADDRESS_0 ... PCI_BASE_ADDRESS_5 + 3] = 0xff,
+	[PCI_CACHE_LINE_SIZE] = 0xff,
+};
+
 void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data, int size)
 {
 	void *base;
@@ -357,7 +375,7 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	u16 offset;
 	struct pci_device_header *pci_hdr;
 	u8 dev_num = addr.device_number;
-	u32 value = 0;
+	u32 value = 0, mask = 0;
 
 	if (!pci_device_exists(addr.bus_number, dev_num, 0))
 		return;
@@ -365,19 +383,19 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	offset = addr.w & PCI_DEV_CFG_MASK;
 	base = pci_hdr = device__find_dev(DEVICE_BUS_PCI, dev_num)->data;
 
+	/* We don't sanity-check capabilities for the moment */
+	if (offset < PCI_STD_HEADER_SIZEOF) {
+		memcpy(&mask, pci_config_writable + offset, size);
+		if (!mask)
+			return;
+	}
+
 	if (pci_hdr->cfg_ops.write)
 		pci_hdr->cfg_ops.write(kvm, pci_hdr, offset, data, size);
 
-	/*
-	 * legacy hack: ignore writes to uninitialized regions (e.g. ROM BAR).
-	 * Not very nice but has been working so far.
-	 */
-	if (*(u32 *)(base + offset) == 0)
-		return;
-
 	if (offset == PCI_COMMAND) {
 		memcpy(&value, data, size);
-		pci_config_command_wr(kvm, pci_hdr, (u16)value);
+		pci_config_command_wr(kvm, pci_hdr, (u16)value & mask);
 		return;
 	}
 
@@ -419,8 +437,16 @@ static void pci_config_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	cfg_addr.w		= (u32)addr;
 	cfg_addr.enable_bit	= 1;
 
-	if (len > 4)
-		len = 4;
+	/*
+	 * To prevent some overflows, reject accesses that cross a 4-byte
+	 * boundary. The PCIe specification says:
+	 *
+	 *  "Root Complex implementations are not required to support the
+	 *  generation of Configuration Requests from accesses that cross DW
+	 *  [4 bytes] boundaries."
+	 */
+	if ((addr & 3) + len > 4)
+		return;
 
 	if (is_write)
 		pci__config_wr(kvm, cfg_addr, data, len);
-- 
2.37.3

