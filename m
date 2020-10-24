Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FAB297F3A
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764692AbgJXVfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764651AbgJXVfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:45 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77379C0613D2;
        Sat, 24 Oct 2020 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=8TaiqqYUSgEw+NzR3JQBSjax7MA1MOxCn8TG1p+kRr4=; b=r9db4GP31D5p/054Y24Ez72LKS
        N/XaCYLdz1IDFNPBCkSOAKU7WLYUZRrZ33nc3F+OubHzk0l8JLVOEHBhLRZPA+VRdRKm5zujhfzGP
        Fjn8wQPuhP3DvWmINE/z3rE/6vpAa39evTXgxQ7hW2b9UgpIBj5ALBxL5Wv96wY3z7uzqCYtS6854
        txGAhWYokXAbn4UhmlOwswzn7iUjrPO+vYlD/y3noSji8HMVqP5cr2lO84541xHxpNReS4c8vG0/i
        0fnygyXXe1Tn7loE2gXIWpPIkB5P/UEVN+hca48B26Ym3OpZOIlw0C1vUokmyP45mIDlzs/pKQ4ZK
        FRxIwBfw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCN-0006Gf-V2; Sat, 24 Oct 2020 21:35:41 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPe-FR; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 32/35] x86/apic: Support 15 bits of APIC ID in MSI where available
Date:   Sat, 24 Oct 2020 22:35:32 +0100
Message-Id: <20201024213535.443185-33-dwmw2@infradead.org>
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

Some hypervisors can allow the guest to use the Extended Destination ID
field in the MSI address to address up to 32768 CPUs.

This applies to all downstream devices which generate MSI cycles,
including HPET, I/OAPIC and PCI MSI.

HPET and PCI MSI use the same __irq_msi_compose_msg() function, while
I/OAPIC generates its own and had support for the extended bits added in
a previous commit.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20201009104616.1314746-6-dwmw2@infradead.org
---
 arch/x86/include/asm/msi.h      |  3 ++-
 arch/x86/include/asm/x86_init.h |  2 ++
 arch/x86/kernel/apic/apic.c     | 26 ++++++++++++++++++++++++--
 arch/x86/kernel/x86_init.c      |  1 +
 4 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/msi.h b/arch/x86/include/asm/msi.h
index 322fd905da9c..b85147d75626 100644
--- a/arch/x86/include/asm/msi.h
+++ b/arch/x86/include/asm/msi.h
@@ -29,7 +29,8 @@ typedef struct x86_msi_addr_lo {
 			u32	reserved_0		:  2,
 				dest_mode_logical	:  1,
 				redirect_hint		:  1,
-				reserved_1		:  8,
+				reserved_1		:  1,
+				virt_destid_8_14	:  7,
 				destid_0_7		:  8,
 				base_address		: 12;
 		};
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index dde5b3f1e7cd..5c69f7eb5d47 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -116,6 +116,7 @@ struct x86_init_pci {
  * @init_platform:		platform setup
  * @guest_late_init:		guest late init
  * @x2apic_available:		X2APIC detection
+ * @msi_ext_dest_id:		MSI supports 15-bit APIC IDs
  * @init_mem_mapping:		setup early mappings during init_mem_mapping()
  * @init_after_bootmem:		guest init after boot allocator is finished
  */
@@ -123,6 +124,7 @@ struct x86_hyper_init {
 	void (*init_platform)(void);
 	void (*guest_late_init)(void);
 	bool (*x2apic_available)(void);
+	bool (*msi_ext_dest_id)(void);
 	void (*init_mem_mapping)(void);
 	void (*init_after_bootmem)(void);
 };
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f7196ee0f005..6bd20c0de8bc 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -93,6 +93,11 @@ static unsigned int disabled_cpu_apicid __ro_after_init = BAD_APICID;
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
@@ -1841,6 +1846,8 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		return;
 
 	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
+		u32 apic_limit = 255;
+
 		/*
 		 * Using X2APIC without IR is not architecturally supported
 		 * on bare metal but may be supported in guests.
@@ -1851,12 +1858,22 @@ static __init void try_to_enable_x2apic(int remap_mode)
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
@@ -2497,10 +2514,15 @@ void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
 	 * Only the IOMMU itself can use the trick of putting destination
 	 * APIC ID into the high bits of the address. Anything else would
 	 * just be writing to memory if it tried that, and needs IR to
-	 * address higher APIC IDs.
+	 * address APICs which can't be addressed in the normal 32-bit
+	 * address range at 0xFFExxxxx. That is typically just 8 bits, but
+	 * some hypervisors allow the extended destination ID field in bits
+	 * 5-11 to be used, giving support for 15 bits of APIC IDs in total.
 	 */
 	if (dmar)
 		msg->arch_addr_hi.destid_8_31 = cfg->dest_apicid >> 8;
+	else if (virt_ext_dest_id && cfg->dest_apicid < 0x8000)
+		msg->arch_addr_lo.virt_destid_8_14 = cfg->dest_apicid >> 8;
 	else
 		WARN_ON_ONCE(cfg->dest_apicid > 0xFF);
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

