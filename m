Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3666C28C9CD
	for <lists+kvm@lfdr.de>; Tue, 13 Oct 2020 10:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390954AbgJMILy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 04:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390479AbgJMILs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 04:11:48 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7668C0613D6;
        Tue, 13 Oct 2020 01:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tEXSxiZgiyhsPeGxpXN53zeSdpwjvDGCNA3IHBXORac=; b=oSwC0KbPAFSpC/WqgJP3XjFYGN
        NKckUFk2AQSKgJBBzcrp9P1GYZ3pSV0nmP4pB98Wgjo1JvgjUnq6xnn7YZV5W0/5di0w/+OdHht2+
        JTUx/UhUgRLiErsYEq3+zF2w6SwzDbRpW2JL5ek8P0D9JIuz2syNfv9o0gd4Zq7CLhuLpacg6GoAu
        z85UTdCLVWAA31bfa677lFTtjseIAhPTAQnBuiRBsbrvC83XmTDfp4/qjexVM96GM0fuIvcpTBQFy
        5ycGi5hFw8QbkqmddWmBr22ZewFqesFKD3CEIGNb6OxxsqiCIQpKBSzPZCuM49AnxDsGUTAKSlY+/
        zOJkwNYw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kSFPN-0005sW-Di; Tue, 13 Oct 2020 08:11:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kSFPM-006XXQ-Cx; Tue, 13 Oct 2020 09:11:44 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org
Subject: [PATCH 2/9] x86/apic: Add select() method on vector irqdomain
Date:   Tue, 13 Oct 2020 09:11:32 +0100
Message-Id: <20201013081139.1558200-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201013081139.1558200-1-dwmw2@infradead.org>
References: <0de733f6384874d68afba2606119d0d9b1e8b34e.camel@infradead.org>
 <20201013081139.1558200-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This will be used to select the irqdomain for I/OAPIC and HPET.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
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

