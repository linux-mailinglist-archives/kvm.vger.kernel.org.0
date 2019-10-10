Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A48D3077
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2019 20:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbfJJSfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Oct 2019 14:35:46 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:46002 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbfJJSfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Oct 2019 14:35:46 -0400
Received: by mail-pg1-f201.google.com with SMTP id x31so5011340pgl.12
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2019 11:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=byAY/eTBNLsBVkb20fBKKyqlgQhkiEQH/5g179LmxWs=;
        b=Fx0sVl5iz2EuJj6yU18p/v2otdgV5gb8u2d8srVAFM4S5ILXk2W9gmDrfVVqh6C5DP
         67VP0nFRtAZypetkgL9T/C0xN/6Q4rT2LNVyyLHsES7nDRBrKuCsAKC9ZYtTDe2rXshC
         VwK2S+xxEVWMK+rihmnoLgi4PousIcIJqoFrPx3gFKQn7swF0IffronT2Ktvgf25L0m9
         a8brnYd8W3StBrhWdaPzge7jgLiMdd7xvH8rGMlOjv+y+hap7THn1KsQFXgT7bkH0Ed6
         SIXA4/m0DyrCmmvOlrNqn7F4DrsWcifhRn/+4dkBcdNMhiZXSWvBs/IRpb26shjiRPNs
         0N+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=byAY/eTBNLsBVkb20fBKKyqlgQhkiEQH/5g179LmxWs=;
        b=ueDcaWVZovK96Y/3Gt4+IT2qoYWr7XPWA5JQjvatCYqbLHiDVD3/J037Iz1j+SW6Kv
         uflVdZYqC4slh5xQkZlwy5b8ANRMfU0UX/4T4bfFUh8rhQF1TmW6fZDAYUc/OccwIOZd
         jCMYkG8VAfPpDpMpIj/1by9RFYky1Tgm3ULziix57yC6BDYyLveKAV1W7PokuMbTlnLJ
         tmo95Qsf+ZrxhZq/7HDlfrzkubb3AgszHEF5PIGSLLQUU4f62tirGNRcVis2sqlW9kaI
         tqXACH3LVIft6kRuKZaZwspmG0D3nkQa8BTkMesOyMpQmlBIS/MdhaznwTvxwKx8AhZp
         ALyw==
X-Gm-Message-State: APjAAAWkEmCGoNGjutuidjoiOP3KtehpjutR+IFICPrRFZseFdiHKkfp
        EiXW3mKsYFMungSHzfdH1VcVOvT8bp/lh4lpjugcCh+d5q8FMuUovQoAH6fTjFYnoZhxL7RZzA/
        bCrvmaRNWSTchy4viTrgGrQbpd2IpOzs8WS/pHaAOPnmzWHzDyeJI+w==
X-Google-Smtp-Source: APXvYqyQOwPJZmRYN55XnS/pMjyBE3ggUxBPdR3rdY/6SN+U0eRohINZDOhv4O1CSOCpixRMHxRnDmOCGQ==
X-Received: by 2002:a63:1b44:: with SMTP id b4mr12903823pgm.421.1570732544721;
 Thu, 10 Oct 2019 11:35:44 -0700 (PDT)
Date:   Thu, 10 Oct 2019 11:35:05 -0700
In-Reply-To: <20191010183506.129921-1-morbo@google.com>
Message-Id: <20191010183506.129921-3-morbo@google.com>
Mime-Version: 1.0
References: <20191010183506.129921-1-morbo@google.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [kvm-unit-tests PATCH 2/3] pci: use uint64_t for unsigned long values
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "pci_bar_*" functions work with unsigned long values, but were using
uint32_t for the data types. Clang complains about this. So we bump up
the type to uint64_t.

  lib/pci.c:110:3: error: implicit conversion from 'unsigned long' to 'uint32_t' (aka 'unsigned int') changes value from 18446744073709551612 to 4294967292 [-Werror,-Wconstant-conversion]
                  PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
                ^~~~~~~~~~~~~~~~~~~~~~~~
  /usr/local/google/home/morbo/kvm-unit-tests/lib/linux/pci_regs.h:100:36: note: expanded from macro 'PCI_BASE_ADDRESS_IO_MASK'
  #define  PCI_BASE_ADDRESS_IO_MASK       (~0x03UL)
                                           ^~~~~~~
  lib/pci.c:110:30: error: implicit conversion from 'unsigned long' to 'uint32_t' (aka 'unsigned int') changes value from 18446744073709551600 to 4294967280 [-Werror,-Wconstant-conversion]
                  PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
                                           ^~~~~~~~~~~~~~~~~~~~~~~~~
  /usr/local/google/home/morbo/kvm-unit-tests/lib/linux/pci_regs.h:99:37: note: expanded from macro 'PCI_BASE_ADDRESS_MEM_MASK'
  #define  PCI_BASE_ADDRESS_MEM_MASK      (~0x0fUL)
                                         ^~~~~~~

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/pci.c | 18 +++++++++---------
 lib/pci.h |  4 ++--
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/lib/pci.c b/lib/pci.c
index daa33e1..e554209 100644
--- a/lib/pci.c
+++ b/lib/pci.c
@@ -104,13 +104,13 @@ pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_t device_id)
 	return PCIDEVADDR_INVALID;
 }
 
-uint32_t pci_bar_mask(uint32_t bar)
+uint64_t pci_bar_mask(uint32_t bar)
 {
 	return (bar & PCI_BASE_ADDRESS_SPACE_IO) ?
 		PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
 }
 
-uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)
+uint64_t pci_bar_get(struct pci_dev *dev, int bar_num)
 {
 	ASSERT_BAR_NUM(bar_num);
 
@@ -120,13 +120,13 @@ uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)
 
 static phys_addr_t __pci_bar_get_addr(struct pci_dev *dev, int bar_num)
 {
-	uint32_t bar = pci_bar_get(dev, bar_num);
-	uint32_t mask = pci_bar_mask(bar);
+	uint64_t bar = pci_bar_get(dev, bar_num);
+	uint64_t mask = pci_bar_mask(bar);
 	uint64_t addr = bar & mask;
 	phys_addr_t phys_addr;
 
 	if (pci_bar_is64(dev, bar_num))
-		addr |= (uint64_t)pci_bar_get(dev, bar_num + 1) << 32;
+		addr |= pci_bar_get(dev, bar_num + 1) << 32;
 
 	phys_addr = pci_translate_addr(dev->bdf, addr);
 	assert(phys_addr != INVALID_PHYS_ADDR);
@@ -189,7 +189,7 @@ static uint32_t pci_bar_size_helper(struct pci_dev *dev, int bar_num)
 
 phys_addr_t pci_bar_size(struct pci_dev *dev, int bar_num)
 {
-	uint32_t bar, size;
+	uint64_t bar, size;
 
 	size = pci_bar_size_helper(dev, bar_num);
 	if (!size)
@@ -210,7 +210,7 @@ phys_addr_t pci_bar_size(struct pci_dev *dev, int bar_num)
 
 bool pci_bar_is_memory(struct pci_dev *dev, int bar_num)
 {
-	uint32_t bar = pci_bar_get(dev, bar_num);
+	uint64_t bar = pci_bar_get(dev, bar_num);
 
 	return !(bar & PCI_BASE_ADDRESS_SPACE_IO);
 }
@@ -222,7 +222,7 @@ bool pci_bar_is_valid(struct pci_dev *dev, int bar_num)
 
 bool pci_bar_is64(struct pci_dev *dev, int bar_num)
 {
-	uint32_t bar = pci_bar_get(dev, bar_num);
+	uint64_t bar = pci_bar_get(dev, bar_num);
 
 	if (bar & PCI_BASE_ADDRESS_SPACE_IO)
 		return false;
@@ -234,7 +234,7 @@ bool pci_bar_is64(struct pci_dev *dev, int bar_num)
 void pci_bar_print(struct pci_dev *dev, int bar_num)
 {
 	phys_addr_t size, start, end;
-	uint32_t bar;
+	uint64_t bar;
 
 	if (!pci_bar_is_valid(dev, bar_num))
 		return;
diff --git a/lib/pci.h b/lib/pci.h
index 689f03c..cd12938 100644
--- a/lib/pci.h
+++ b/lib/pci.h
@@ -60,8 +60,8 @@ extern pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_t device_id);
 extern phys_addr_t pci_bar_get_addr(struct pci_dev *dev, int bar_num);
 extern void pci_bar_set_addr(struct pci_dev *dev, int bar_num, phys_addr_t addr);
 extern phys_addr_t pci_bar_size(struct pci_dev *dev, int bar_num);
-extern uint32_t pci_bar_get(struct pci_dev *dev, int bar_num);
-extern uint32_t pci_bar_mask(uint32_t bar);
+extern uint64_t pci_bar_get(struct pci_dev *dev, int bar_num);
+extern uint64_t pci_bar_mask(uint32_t bar);
 extern bool pci_bar_is64(struct pci_dev *dev, int bar_num);
 extern bool pci_bar_is_memory(struct pci_dev *dev, int bar_num);
 extern bool pci_bar_is_valid(struct pci_dev *dev, int bar_num);
-- 
2.23.0.700.g56cf767bdb-goog

