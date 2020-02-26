Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1443F17093D
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2020 21:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgBZUNK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Feb 2020 15:13:10 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:53091 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727240AbgBZUNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Feb 2020 15:13:10 -0500
Received: by mail-pf1-f201.google.com with SMTP id v26so197906pfn.19
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2020 12:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WcjOhYarYrSlP0Y28DK/vHN2LbfwP4ntC96ZmKq5xCU=;
        b=wAINI25mJjJl67tX1Kffr6+OKjPnpiSQKExRYDmrxJsVK4yeiTII9ytqqzh0nNBfnm
         Z/PrSjhM+zvhzaE+E3T7RD9l2EzThsjdhZGMvaNgqp+J4bnXi91bByjJjZGGzBQiEpbM
         GGewkwAEJHuyaUGlL2rqkAdsFRNsHkeT8gklQ8xPkwybnGh+as4mf7MevI4uaCRxUXZy
         bb+h7bGyMiy4an1WLnoJ8doRV86KWxbTgga/sgJnLIJD/tdGiC3N8VIAt+kRQI2JX7EJ
         y5v8974mpnvmVCOSLBFRKFB0d4WbfzuyycTU+NA+bQ7Jkf0ntO7vZJvQNY1ryQ3fXduV
         ymgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WcjOhYarYrSlP0Y28DK/vHN2LbfwP4ntC96ZmKq5xCU=;
        b=DF6MHrVYPvqu2wx+aBlBDBsykKtXUlZD30qIYF15QrlhAUGPgNvN1J+opu/VydgxJI
         ln85BYRZClP9aQR+MfiMHGhPKuvm3pydYy3x1n1KwPwJ+KfXTheLOGe4TTAA0h30k9nY
         S1sJzyUtXIIzJUCQ/t7ooWGFACEffrrv//GtkOrJpRei4ZljpVm1fM9VxbABpWUP4OK5
         czNRok2QTfuGLCUZc+GB95NPapxfs4XhkZ64KA3xZ48dmhUBvdt3VHRMP11Ovwq9JOqy
         MZmFmk1ehsQ2yyJLxw9QqE0BrazaKfg1fB5wxy5tzA2I/zYs6tMW1cDJzxTbaLK0F3Ra
         H2wg==
X-Gm-Message-State: APjAAAXsntejhiVrUnuANgb5N2Q+xRc9cimG+Vhb8IDn2LtOeHsmijoC
        2/DBPcp9LnG+YfWa4h94DzmNRns5nE4RFWUCUbhCebHXvpi2p1/6aCtohmXI1HmX0rW7npEU+a8
        w++jtweEAlgXX4udgOVQsxq4RE5tapw/HiBh/09aYNP6VV59eC95y3Q==
X-Google-Smtp-Source: APXvYqxjQAOoT667LkNmXZwdmTFvsX2Z9Zt9+bUyXEroptKsm3SvG9u6lzkDS3mrqM8V7mlzEKuqreY40Q==
X-Received: by 2002:a63:c546:: with SMTP id g6mr495020pgd.243.1582747987695;
 Wed, 26 Feb 2020 12:13:07 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:12:38 -0800
In-Reply-To: <20200226201243.86988-1-morbo@google.com>
Message-Id: <20200226201243.86988-3-morbo@google.com>
Mime-Version: 1.0
References: <20200226094433.210968-1-morbo@google.com> <20200226201243.86988-1-morbo@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [kvm-unit-tests PATCH v3 2/7] pci: cast masks to uint32_t for
 unsigned long values
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, oupton@google.com, drjones@redhat.com,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The "pci_bar_*" functions use 64-bit masks, but the results are assigned
to 32-bit variables. Cast mask usages to 32-bit, since we're interested
only in the least significant 4-bits.

Signed-off-by: Bill Wendling <morbo@google.com>
---
 lib/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/pci.c b/lib/pci.c
index daa33e1..1b85411 100644
--- a/lib/pci.c
+++ b/lib/pci.c
@@ -107,7 +107,8 @@ pcidevaddr_t pci_find_dev(uint16_t vendor_id, uint16_t device_id)
 uint32_t pci_bar_mask(uint32_t bar)
 {
 	return (bar & PCI_BASE_ADDRESS_SPACE_IO) ?
-		PCI_BASE_ADDRESS_IO_MASK : PCI_BASE_ADDRESS_MEM_MASK;
+		(uint32_t)PCI_BASE_ADDRESS_IO_MASK :
+		(uint32_t)PCI_BASE_ADDRESS_MEM_MASK;
 }
 
 uint32_t pci_bar_get(struct pci_dev *dev, int bar_num)
-- 
2.25.1.481.gfbce0eb801-goog

