Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D58297F27
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765019AbgJXVhw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764729AbgJXVfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F81C0613DB;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wH4zdtlPHtTRbohjSTH2M3pmJlqwW7kIz3LA78TDQsk=; b=Yd7ssv37MjMjvm3OvFGzbUq3ou
        Wa3CF0IG2EsibDDUnPHsHtBHRoSCa0rx/QXBDjnpOB3dmZOYJrDFYzYyKHwu+h13ak23/v5KuQzGa
        1H0aARvn4DVv7Y6Go7nWXD5b6TkpL/m+/3a89kLR5qk/WpWRR1qpIo1rNm9KvQfa7Gp3ahUzWGB4p
        ADSyE7EGROV8etSXyYtIv6PhffqRO3Iv69zTZoYpt9PMTWXZrIpcBwAX0ZnTou8uMHHjPP5EWuni6
        i9gl8FTtQSmfItae3DSdDfUlajoW/wt3hEUJhq/g+e/SxRBCT8fwaJFuT6HHx14iivCaceyvMEk6m
        VShFODEw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HC-EX; Sat, 24 Oct 2020 21:35:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rOX-W7; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 15/35] PCI: vmd: Use msi_msg shadow structs
Date:   Sat, 24 Oct 2020 22:35:15 +0100
Message-Id: <20201024213535.443185-16-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Use the x86 shadow structs in msi_msg instead of the macros.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 drivers/pci/controller/vmd.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index aa1b12bac9a1..72de3c6f644e 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -18,7 +18,6 @@
 #include <asm/irqdomain.h>
 #include <asm/device.h>
 #include <asm/msi.h>
-#include <asm/msidef.h>
 
 #define VMD_CFGBAR	0
 #define VMD_MEMBAR1	2
@@ -131,10 +130,10 @@ static void vmd_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
 	struct vmd_irq_list *irq = vmdirq->irq;
 	struct vmd_dev *vmd = irq_data_get_irq_handler_data(data);
 
-	msg->address_hi = MSI_ADDR_BASE_HI;
-	msg->address_lo = MSI_ADDR_BASE_LO |
-			  MSI_ADDR_DEST_ID(index_from_irqs(vmd, irq));
-	msg->data = 0;
+	memset(&msg, 0, sizeof(*msg);
+	msg->address_hi = X86_MSI_BASE_ADDRESS_HIGH;
+	msg->arch_addr_lo.base_address = X86_MSI_BASE_ADDRESS_LOW;
+	msg->arch_addr_lo.destid_0_7 = index_from_irqs(vmd, irq);
 }
 
 /*
-- 
2.26.2

