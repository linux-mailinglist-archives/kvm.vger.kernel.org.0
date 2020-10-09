Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378AC28874B
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 12:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387944AbgJIKr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 06:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387789AbgJIKq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Oct 2020 06:46:27 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43092C0613DC;
        Fri,  9 Oct 2020 03:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=a+wMpSAv5Ff83kPG4jc6b3ut+FENx6kjjKE2+uIBrrI=; b=aEzTBEL6vwUnRSBXzybFd0nFex
        qzGuFC05JDkxWUXUIZmzJHYeSoPZDQWXc5LW5J++oD2WlIWPJJvy6sAg+6YwtGjpO9Nq7S7rAdYeA
        aaGiT83/bOMaU0xqmfl4Ve4vl1/nhwkvzkhLpydM6hfIXeAQYNbyrIF2D9S9ToCxoyT9bt120jzDZ
        xVFQdtTq9ha0UMI0/Bpzdp4rx+3T3ekouyYrX2Gjo/5quAHYjuehQiiJsVcDSBt0504ROhYqgEb6h
        48aaxtyPs62S933io+3yFsPU3PWFl4P0huWuax9mABfW3hHvCO2xU2oEtUIHbsy7AJVZMG6yBw117
        1YIvc22g==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kQpuq-00050W-4r; Fri, 09 Oct 2020 10:46:24 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kQpup-005W4E-4N; Fri, 09 Oct 2020 11:46:23 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 5/8] x86/apic: Support 15 bits of APIC ID in MSI where available
Date:   Fri,  9 Oct 2020 11:46:13 +0100
Message-Id: <20201009104616.1314746-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201009104616.1314746-1-dwmw2@infradead.org>
References: <803bb6b2212e65c568c84ff6882c2aa8a0ee03d5.camel@infradead.org>
 <20201009104616.1314746-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Some hypervisors can allow the guest to use the Extended Destination ID
field in the MSI address to address up to 32768 CPUs.

This applies to all downstream devices which generate MSI cycles,
including HPET, I/OAPIC and PCI MSI.

HPET and PCI MSI use the same __irq_msi_compose_msg() function, while
I/OAPIC generates its own and had support for the extended bits added in
a previous commit.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/x86_init.h |  2 ++
 arch/x86/kernel/apic/apic.c     | 26 ++++++++++++++++++++++++--
 arch/x86/kernel/x86_init.c      |  1 +
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 397196fae24d..96a719fb2e53 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -114,6 +114,7 @@ struct x86_init_pci {
  * @init_platform:		platform setup
  * @guest_late_init:		guest late init
  * @x2apic_available:		X2APIC detection
+ * @msi_ext_dest_id:		MSI supports 15-bit APIC IDs
  * @init_mem_mapping:		setup early mappings during init_mem_mapping()
  * @init_after_bootmem:		guest init after boot allocator is finished
  */
@@ -121,6 +122,7 @@ struct x86_hyper_init {
 	void (*init_platform)(void);
 	void (*guest_late_init)(void);
 	bool (*x2apic_available)(void);
+	bool (*msi_ext_dest_id)(void);
 	void (*init_mem_mapping)(void);
 	void (*init_after_bootmem)(void);
 };
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index fba3ba383ad2..62e769c267c3 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -94,6 +94,11 @@ static unsigned int disabled_cpu_apicid __ro_after_init = BAD_APICID;
  */
 static int apic_extnmi __ro_after_init = APIC_EXTNMI_BSP;
 
+/*
+ * Hypervisor supports 15 bits of APIC ID in MSI Extended Destination ID
+ */
+static bool virt_ext_dest_id __ro_after_init;
+
 /*
  * Map cpu index to physical APIC ID
  */
@@ -1842,6 +1847,8 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		return;
 
 	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
+		u32 apic_limit = 255;
+
 		/*
 		 * Using X2APIC without IR is not architecturally supported
 		 * on bare metal but may be supported in guests.
@@ -1852,12 +1859,22 @@ static __init void try_to_enable_x2apic(int remap_mode)
 			return;
 		}
 
+		/*
+		 * If the hypervisor supports extended destination ID in
+		 * MSI, that increases the maximum APIC ID that can be
+		 * used for non-remapped IRQ domains.
+		 */
+		if (x86_init.hyper.msi_ext_dest_id()) {
+			virt_ext_dest_id = 1;
+			apic_limit = 32767;
+		}
+
 		/*
 		 * Without IR, all CPUs can be addressed by IOAPIC/MSI only
 		 * in physical mode, and CPUs with an APIC ID that cannnot
 		 * be addressed must not be brought online.
 		 */
-		x2apic_set_max_apicid(255);
+		x2apic_set_max_apicid(apic_limit);
 		x2apic_phys = 1;
 	}
 	x2apic_enable();
@@ -2504,10 +2521,15 @@ void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
 	 * Only the IOMMU itself can use the trick of putting destination
 	 * APIC ID into the high bits of the address. Anything else would
 	 * just be writing to memory if it tried that, and needs IR to
-	 * address higher APIC IDs.
+	 * address APICs which can't be addressed in the normal 32-bit
+	 * address range at 0xFFExxxxx. That is typically just 8 bits, but
+	 * some hypervisors allow the extended destination ID field in bits
+	 * 11-5 to be used, giving support for 15 bits of APIC IDs in total.
 	 */
 	if (dmar)
 		msg->address_hi |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid);
+	else if (virt_ext_dest_id && cfg->dest_apicid < 0x8000)
+		msg->address_lo |= MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid) >> 3;
 	else
 		WARN_ON_ONCE(MSI_ADDR_EXT_DEST_ID(cfg->dest_apicid));
 }
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index a3038d8deb6a..8b395821cb8d 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -110,6 +110,7 @@ struct x86_init_ops x86_init __initdata = {
 		.init_platform		= x86_init_noop,
 		.guest_late_init	= x86_init_noop,
 		.x2apic_available	= bool_x86_init_noop,
+		.msi_ext_dest_id	= bool_x86_init_noop,
 		.init_mem_mapping	= x86_init_noop,
 		.init_after_bootmem	= x86_init_noop,
 	},
-- 
2.26.2

