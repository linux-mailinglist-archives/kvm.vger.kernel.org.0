Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3A9297F1E
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764987AbgJXVhg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764732AbgJXVfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:52 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E50C0613DF;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=FRrY6MEJjYQP0r1yTo24lr6Wep/KFRGuH0gs6Z6h+gY=; b=PZwehCifxy9oGFTZsoyQQWPMYW
        8hb65XgYDurnOCry9q5zsfSfbrDyDCVvd07vdLC3J3JY4UljdzSro5qDGrPEw5zHaTAh6xSwkBFN+
        q9fioKpvL0dHrnPEYh/uQ1lBhmmSG/idC7EMKvAF3TCZ6CMiMqiYRwRKz4AzH1GgcGqejG5NFOH6B
        6+XoFDQhkn3INBMHT9jAjDJwLMDk8ZYJGHw9t/j49lky+GQV4qGDHmp5Rd+NwDNIaEDtPDskC0HY5
        w4PGqsg8SVMzS+sFz81PdyYR3f8TNOTayiMYP1n0IwS92nJS2nepoqIQ2RZF8JVDvcQCtwasERJYm
        R0t4B0zw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCT-0008Be-Cn; Sat, 24 Oct 2020 21:35:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPO-Bh; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 28/35] x86/ioapic: Use irq_find_matching_fwspec() to find remapping irqdomain
Date:   Sat, 24 Oct 2020 22:35:28 +0100
Message-Id: <20201024213535.443185-29-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201024213535.443185-1-dwmw2@infradead.org>
References: <e6601ff691afb3266e365a91e8b221179daf22c2.camel@infradead.org>
 <20201024213535.443185-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

All possible parent domains have a select method now. Make use of it.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ea983da1a57f..443d2c9086b9 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2320,36 +2320,37 @@ static inline void __init check_timer(void)
 
 static int mp_irqdomain_create(int ioapic)
 {
-	struct irq_alloc_info info;
 	struct irq_domain *parent;
 	int hwirqs = mp_ioapic_pin_count(ioapic);
 	struct ioapic *ip = &ioapics[ioapic];
 	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
 	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
 	struct fwnode_handle *fn;
-	char *name = "IO-APIC";
+	struct irq_fwspec fwspec;
 
 	if (cfg->type == IOAPIC_DOMAIN_INVALID)
 		return 0;
 
-	init_irq_alloc_info(&info, NULL);
-	info.type = X86_IRQ_ALLOC_TYPE_IOAPIC_GET_PARENT;
-	info.devid = mpc_ioapic_id(ioapic);
-	parent = irq_remapping_get_irq_domain(&info);
-	if (!parent)
-		parent = x86_vector_domain;
-	else
-		name = "IO-APIC-IR";
-
 	/* Handle device tree enumerated APICs proper */
 	if (cfg->dev) {
 		fn = of_node_to_fwnode(cfg->dev);
 	} else {
-		fn = irq_domain_alloc_named_id_fwnode(name, ioapic);
+		fn = irq_domain_alloc_named_id_fwnode("IO-APIC", ioapic);
 		if (!fn)
 			return -ENOMEM;
 	}
 
+	fwspec.fwnode = fn;
+	fwspec.param_count = 1;
+	fwspec.param[0] = ioapic;
+
+	parent = irq_find_matching_fwspec(&fwspec, DOMAIN_BUS_ANY);
+	if (!parent) {
+		if (!cfg->dev)
+			irq_domain_free_fwnode(fn);
+		return -ENODEV;
+	}
+
 	ip->irqdomain = irq_domain_create_linear(fn, hwirqs, cfg->ops,
 						 (void *)(long)ioapic);
 
-- 
2.26.2

