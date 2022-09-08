Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8896A5B210F
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbiIHOpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 10:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232689AbiIHOpS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 10:45:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436724507E
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 07:45:14 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t14so19207653wrx.8
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=iMuilEfj7jmAhWTDHVQA9P0ytfSJpQXdBND+Mw+wnUs=;
        b=QhDfTLSmlT6Er/AcE2lm1ek1w/nfCIXI7PLQZ/RidNtUB8INYpJi81izlFhBD3rGq7
         2qQifdGmiKiNSD4YIR4y1b+0SetPZecK9IaU13z2oHw+Ug3OJlUGqEVg3Z6+9CI83vzX
         2OKMDilyfzSmXNKeOzee2HcxgsRvXaTMME1NKCmLCN1EXqwCnbBWUWJdgTq1CLYYcjaJ
         W3yGOe6vi9Hzm1vmKMNoFFQQWLpt58k+0Wz6WhurCakf6ctJGLTmk2vag3Yxq3zykrgZ
         FOxhtucfZxknoBq7WKWxOfak0n/nApWXusFzJ4+H3AZTaHyNMJaaKC4qLMK/9dMSceNn
         XtIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=iMuilEfj7jmAhWTDHVQA9P0ytfSJpQXdBND+Mw+wnUs=;
        b=4eDW8mLefMTKyEAE0EgfmHlyKQ4H9Oop2a305sqfKbU2ebArFQSg53i6LJNCjnKP6Y
         uc2NTHoPDavm08B7fmnKBjBysPgwGfsy58fILpvwS6FDoQ3y0sHkkn3kOWZBRlnNUNY+
         aXQsgwo+aiHk/Sw2m2IBYVuRJisukv6YdDbmnoQJXOjqDwONDlZaRKvXtjMZSQC+ZGBg
         8gfd5YpxnlG844zRSo20sNMUJa5b+RLy6IdnsNvJXaqM+NCViRrk81XtgI7GpDUg16oQ
         S9pwp5KkM3dBuDwfpuv2mSX74r8JJe32PJkHF9gKN7O1iZu7Eh5AQ9Jal0IV8efno/Xy
         4SLQ==
X-Gm-Message-State: ACgBeo15nQPX5CgJCdwdVVd/S7eSkpaUiaYXdqebJtrf7zmLyffzeiNc
        bEtesF4MIdASBYTQAMu8zcaeTA==
X-Google-Smtp-Source: AA6agR5uToV9+w4kOPRwRn+8oIToj/KlyuicDcPemRWRFszslpl/K2FkLQE5QkuG4CxkDAf1rEParA==
X-Received: by 2002:adf:eb84:0:b0:226:dc6e:7dd4 with SMTP id t4-20020adfeb84000000b00226dc6e7dd4mr5614305wrn.196.1662648313274;
        Thu, 08 Sep 2022 07:45:13 -0700 (PDT)
Received: from localhost.localdomain (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id x12-20020a05600c2d0c00b003a4efb794d7sm2969287wmf.36.2022.09.08.07.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 07:45:12 -0700 (PDT)
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     will@kernel.org
Cc:     andre.przywara@arm.com, alexandru.elisei@arm.com,
        kvm@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH kvmtool] pci: Disable writes to Status register
Date:   Thu,  8 Sep 2022 15:42:09 +0100
Message-Id: <20220908144208.231272-1-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
* Fine-grained filtering of the Command register, where only some bits
  are writable.

Also remove the old hack that filtered accesses. It was wrong and not
properly explained in the git history, but whatever it was guarding
against should be prevented by these new checks.

Reported-by: Pierre Gondois <pierre.gondois@arm.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
Note that the issue described here only shows up during ACPI boot for
me, because edac_init() happens after PCI enumeration. With DT boot,
edac_pci_clear_parity_errors() runs earlier and doesn't find any device.
---
 pci.c | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/pci.c b/pci.c
index a769ae27..84dc7d1d 100644
--- a/pci.c
+++ b/pci.c
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
@@ -368,12 +386,12 @@ void pci__config_wr(struct kvm *kvm, union pci_config_address addr, void *data,
 	if (pci_hdr->cfg_ops.write)
 		pci_hdr->cfg_ops.write(kvm, pci_hdr, offset, data, size);
 
-	/*
-	 * legacy hack: ignore writes to uninitialized regions (e.g. ROM BAR).
-	 * Not very nice but has been working so far.
-	 */
-	if (*(u32 *)(base + offset) == 0)
-		return;
+	/* We don't sanity-check capabilities for the moment */
+	if (offset < PCI_STD_HEADER_SIZEOF) {
+		memcpy(&mask, pci_config_writable + offset, size);
+		if (!mask)
+			return;
+	}
 
 	if (offset == PCI_COMMAND) {
 		memcpy(&value, data, size);
@@ -419,8 +437,13 @@ static void pci_config_mmio_access(struct kvm_cpu *vcpu, u64 addr, u8 *data,
 	cfg_addr.w		= (u32)addr;
 	cfg_addr.enable_bit	= 1;
 
-	if (len > 4)
-		len = 4;
+	/*
+	 * "Root Complex implementations are not required to support the
+	 * generation of Configuration Requests from accesses that cross DW
+	 * [4 bytes] boundaries."
+	 */
+	if ((addr & 3) + len > 4)
+		return;
 
 	if (is_write)
 		pci__config_wr(kvm, cfg_addr, data, len);
-- 
2.37.3

