Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060B9297EF3
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764791AbgJXVf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764739AbgJXVfx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:53 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31340C0613E6;
        Sat, 24 Oct 2020 14:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=OE9caHtKVAbbkR0cfBXWlcVFnqSvA7/Lmq44I08qI5I=; b=GCAbAkVIFbHumL2299a5wxDUA/
        gjaEa4zQ2RllzKThgAWemncflm5Gy3WO8LrTdnqIcXCeTDL5DSMw/5PzJXVX/ft7Cn68kGTd/7wEP
        NoiG3OTa7gGO/UCD11hiDn+wvL8t64WAlzbYocnYc5GBw1R+IldiiCP4GdFGtQJrWLe3qjwLQsYwZ
        Zwlne46aIccl0GFDn/UqnpVlenyJ2hHElqCSqh9jcoGvoxK/iNt22kNLtIQp5qLEy9WYJxuNfohpK
        LxCHZuVxEiPQpxVCAKSqfff07Jc6Yl/zaGA+s14azNBwQrrPdPCaVuds31tZeBz+7umzzaurR0ZrN
        ji+IFt7A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HG-Mr; Sat, 24 Oct 2020 21:35:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rP4-7z; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 23/35] x86/apic: Add select() method on vector irqdomain
Date:   Sat, 24 Oct 2020 22:35:23 +0100
Message-Id: <20201024213535.443185-24-dwmw2@infradead.org>
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

From: David Woodhouse <dwmw@amazon.co.uk>

This will be used to select the irqdomain for I/O-APIC and HPET.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irqdomain.h |  3 +++
 arch/x86/kernel/apic/vector.c    | 43 ++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/x86/include/asm/irqdomain.h b/arch/x86/include/asm/irqdomain.h
index cd684d45cb5f..125c23b7bad3 100644
--- a/arch/x86/include/asm/irqdomain.h
+++ b/arch/x86/include/asm/irqdomain.h
@@ -12,6 +12,9 @@ enum {
 	X86_IRQ_ALLOC_LEGACY				= 0x2,
 };
 
+extern int x86_fwspec_is_ioapic(struct irq_fwspec *fwspec);
+extern int x86_fwspec_is_hpet(struct irq_fwspec *fwspec);
+
 extern struct irq_domain *x86_vector_domain;
 
 extern void init_irq_alloc_info(struct irq_alloc_info *info,
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index bb2e2a2488a5..b9b05caa28a4 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -636,7 +636,50 @@ static void x86_vector_debug_show(struct seq_file *m, struct irq_domain *d,
 }
 #endif
 
+int x86_fwspec_is_ioapic(struct irq_fwspec *fwspec)
+{
+	if (fwspec->param_count != 1)
+		return 0;
+
+	if (is_fwnode_irqchip(fwspec->fwnode)) {
+		const char *fwname = fwnode_get_name(fwspec->fwnode);
+		return fwname && !strncmp(fwname, "IO-APIC-", 8) &&
+			simple_strtol(fwname+8, NULL, 10) == fwspec->param[0];
+	}
+	return to_of_node(fwspec->fwnode) &&
+		of_device_is_compatible(to_of_node(fwspec->fwnode),
+					"intel,ce4100-ioapic");
+}
+
+int x86_fwspec_is_hpet(struct irq_fwspec *fwspec)
+{
+	if (fwspec->param_count != 1)
+		return 0;
+
+	if (is_fwnode_irqchip(fwspec->fwnode)) {
+		const char *fwname = fwnode_get_name(fwspec->fwnode);
+		return fwname && !strncmp(fwname, "HPET-MSI-", 9) &&
+			simple_strtol(fwname+9, NULL, 10) == fwspec->param[0];
+	}
+	return 0;
+}
+
+static int x86_vector_select(struct irq_domain *d, struct irq_fwspec *fwspec,
+			     enum irq_domain_bus_token bus_token)
+{
+	/*
+	 * HPET and I/OAPIC cannot be parented in the vector domain
+	 * if IRQ remapping is enabled. APIC IDs above 15 bits are
+	 * only permitted if IRQ remapping is enabled, so check that.
+	 */
+	if (apic->apic_id_valid(32768))
+		return 0;
+
+	return x86_fwspec_is_ioapic(fwspec) || x86_fwspec_is_hpet(fwspec);
+}
+
 static const struct irq_domain_ops x86_vector_domain_ops = {
+	.select		= x86_vector_select,
 	.alloc		= x86_vector_alloc_irqs,
 	.free		= x86_vector_free_irqs,
 	.activate	= x86_vector_activate,
-- 
2.26.2

