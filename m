Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51111297F2D
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765050AbgJXViM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764703AbgJXVfs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:48 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAA7C0613D5;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zijc/whkOmfLXIiirWH/gYILveEHShuI4ufUQxZE7qw=; b=fWt8dGKh7QTvP+OygUJewhm3u3
        U+nM12D9bRE5TDcVFQZQ7CvgupliaH6XLDlLzuaRe+oFKwMtHdwxJ90q1QXSdsHTHtp8I2XASVMJH
        zpYJrktcyQD78RM1USH+Jv/EzT5SA5o2+pR94AeKuaKxJG39oRdFzcQgBUER8/acKL3uNSNNH/ihR
        TGO19pNXmPwH1dNF0g9hi+bgw0iQDqUrNggvHMJNOXV8AXijNXeCqy1rJ3JNIH4fYFFjA2kibXi6J
        NbDaUK9QDnhfi63eDDjOyZhjh8GbWLtpS5IPLLNJdPr5GFm/qmheWsXfG0Y60kdmpPHkWOWcDSxkP
        akmrQgNg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0006HA-8N; Sat, 24 Oct 2020 21:35:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rO4-PJ; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 08/35] x86/apic: Cleanup destination mode
Date:   Sat, 24 Oct 2020 22:35:08 +0100
Message-Id: <20201024213535.443185-9-dwmw2@infradead.org>
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

apic::irq_dest_mode is actually a boolean, but defined as u32 and named in
a way which does not explain what it means.

Make it a boolean and rename it to 'dest_mode_logical'

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/apic.h           | 2 +-
 arch/x86/kernel/apic/apic.c           | 2 +-
 arch/x86/kernel/apic/apic_flat_64.c   | 4 ++--
 arch/x86/kernel/apic/apic_noop.c      | 4 +---
 arch/x86/kernel/apic/apic_numachip.c  | 4 ++--
 arch/x86/kernel/apic/bigsmp_32.c      | 3 +--
 arch/x86/kernel/apic/io_apic.c        | 2 +-
 arch/x86/kernel/apic/msi.c            | 6 +++---
 arch/x86/kernel/apic/probe_32.c       | 3 +--
 arch/x86/kernel/apic/x2apic_cluster.c | 2 +-
 arch/x86/kernel/apic/x2apic_phys.c    | 2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    | 2 +-
 arch/x86/kernel/smpboot.c             | 7 ++-----
 arch/x86/platform/uv/uv_irq.c         | 2 +-
 arch/x86/xen/apic.c                   | 3 +--
 drivers/iommu/amd/amd_iommu_types.h   | 2 +-
 drivers/iommu/amd/iommu.c             | 8 ++++----
 drivers/iommu/intel/irq_remapping.c   | 2 +-
 18 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 019d7ac3b16e..652f62252349 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -309,7 +309,7 @@ struct apic {
 	u32	disable_esr;
 
 	enum apic_delivery_modes delivery_mode;
-	u32	irq_dest_mode;
+	bool	dest_mode_logical;
 
 	u32	(*calc_dest_apicid)(unsigned int cpu);
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 29d28b34cb2f..54f04355aaa2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1591,7 +1591,7 @@ static void setup_local_APIC(void)
 	apic->init_apic_ldr();
 
 #ifdef CONFIG_X86_32
-	if (apic->irq_dest_mode == 1) {
+	if (apic->dest_mode_logical) {
 		int logical_apicid, ldr_apicid;
 
 		/*
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index bbb1b89fe711..8f72b4351c9f 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -114,7 +114,7 @@ static struct apic apic_flat __ro_after_init = {
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	.irq_dest_mode			= 1, /* logical */
+	.dest_mode_logical		= true,
 
 	.disable_esr			= 0,
 
@@ -205,7 +205,7 @@ static struct apic apic_physflat __ro_after_init = {
 	.apic_id_registered		= flat_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	.irq_dest_mode			= 0, /* physical */
+	.dest_mode_logical		= false,
 
 	.disable_esr			= 0,
 
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 38f167ce5031..fe78319e0f7a 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -96,8 +96,7 @@ struct apic apic_noop __ro_after_init = {
 	.apic_id_registered		= noop_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	/* logical delivery broadcast to all CPUs: */
-	.irq_dest_mode			= 1,
+	.dest_mode_logical		= true,
 
 	.disable_esr			= 0,
 
@@ -105,7 +104,6 @@ struct apic apic_noop __ro_after_init = {
 	.init_apic_ldr			= noop_init_apic_ldr,
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
-
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= physid_set_mask_of_physid,
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 4ebf9fe2c95d..a54d817eb4b6 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -247,7 +247,7 @@ static const struct apic apic_numachip1 __refconst = {
 	.apic_id_registered		= numachip_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	.irq_dest_mode			= 0, /* physical */
+	.dest_mode_logical		= false,
 
 	.disable_esr			= 0,
 
@@ -294,7 +294,7 @@ static const struct apic apic_numachip2 __refconst = {
 	.apic_id_registered		= numachip_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	.irq_dest_mode			= 0, /* physical */
+	.dest_mode_logical		= false,
 
 	.disable_esr			= 0,
 
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 64c375b8c54e..77555f66c14d 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -128,8 +128,7 @@ static struct apic apic_bigsmp __ro_after_init = {
 	.apic_id_registered		= bigsmp_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	/* phys delivery to target CPU: */
-	.irq_dest_mode			= 0,
+	.dest_mode_logical		= false,
 
 	.disable_esr			= 1,
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index cff6cbc3d183..c6d92d2570d0 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2950,7 +2950,7 @@ static void mp_setup_entry(struct irq_cfg *cfg, struct mp_chip_data *data,
 {
 	memset(entry, 0, sizeof(*entry));
 	entry->delivery_mode = apic->delivery_mode;
-	entry->dest_mode     = apic->irq_dest_mode;
+	entry->dest_mode     = apic->dest_mode_logical;
 	entry->dest	     = cfg->dest_apicid;
 	entry->vector	     = cfg->vector;
 	entry->trigger	     = data->trigger;
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 516df47bde73..46ffd41a4238 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -30,9 +30,9 @@ static void __irq_msi_compose_msg(struct irq_cfg *cfg, struct msi_msg *msg,
 
 	msg->address_lo =
 		MSI_ADDR_BASE_LO |
-		((apic->irq_dest_mode == 0) ?
-			MSI_ADDR_DEST_MODE_PHYSICAL :
-			MSI_ADDR_DEST_MODE_LOGICAL) |
+		(apic->dest_mode_logical ?
+			MSI_ADDR_DEST_MODE_LOGICAL :
+			MSI_ADDR_DEST_MODE_PHYSICAL) |
 		MSI_ADDR_REDIRECTION_CPU |
 		MSI_ADDR_DEST_ID(cfg->dest_apicid);
 
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 97652aacf3e1..a61f642b1b90 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -70,8 +70,7 @@ static struct apic apic_default __ro_after_init = {
 	.apic_id_registered		= default_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	/* logical delivery broadcast to all CPUs: */
-	.irq_dest_mode			= 1,
+	.dest_mode_logical		= true,
 
 	.disable_esr			= 0,
 
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 53390fc9f51e..df6adc5674c9 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -185,7 +185,7 @@ static struct apic apic_x2apic_cluster __ro_after_init = {
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	.irq_dest_mode			= 1, /* logical */
+	.dest_mode_logical		= true,
 
 	.disable_esr			= 0,
 
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index ee0c4d08092c..0e4e81971567 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -158,7 +158,7 @@ static struct apic apic_x2apic_phys __ro_after_init = {
 	.apic_id_registered		= x2apic_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	.irq_dest_mode			= 0, /* physical */
+	.dest_mode_logical		= false,
 
 	.disable_esr			= 0,
 
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index d21a6853afee..de94181f4d0c 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -808,7 +808,7 @@ static struct apic apic_x2apic_uv_x __ro_after_init = {
 	.apic_id_registered		= uv_apic_id_registered,
 
 	.delivery_mode			= APIC_DELIVERY_MODE_FIXED,
-	.irq_dest_mode			= 0, /* Physical */
+	.dest_mode_logical		= false,
 
 	.disable_esr			= 0,
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6c14f1091f60..d133d6580f41 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -747,7 +747,7 @@ static void __init smp_quirk_init_udelay(void)
 int
 wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 {
-	u32 dm = apic->irq_dest_mode ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
+	u32 dm = apic->dest_mode_logical ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
 
@@ -981,10 +981,7 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 	if (!boot_error) {
 		enable_start_cpu0 = 1;
 		*cpu0_nmi_registered = 1;
-		if (apic->irq_dest_mode)
-			id = cpu0_logical_apicid;
-		else
-			id = apicid;
+		id = apic->dest_mode_logical ? cpu0_logical_apicid : apicid;
 		boot_error = wakeup_secondary_cpu_via_nmi(id, start_ip);
 	}
 
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index e7020d162949..1a536a187d74 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -36,7 +36,7 @@ static void uv_program_mmr(struct irq_cfg *cfg, struct uv_irq_2_mmr_pnode *info)
 	entry = (struct uv_IO_APIC_route_entry *)&mmr_value;
 	entry->vector		= cfg->vector;
 	entry->delivery_mode	= apic->delivery_mode;
-	entry->dest_mode	= apic->irq_dest_mode;
+	entry->dest_mode	= apic->dest_mode_logical;
 	entry->polarity		= 0;
 	entry->trigger		= 0;
 	entry->mask		= 0;
diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index c35c24b5bc01..0d46cc283cf5 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -148,8 +148,7 @@ static struct apic xen_pv_apic = {
 	.apic_id_valid 			= xen_id_always_valid,
 	.apic_id_registered 		= xen_id_always_registered,
 
-	/* .irq_delivery_mode - used in native_compose_msi_msg only */
-	/* .irq_dest_mode     - used in native_compose_msi_msg only */
+	/* .delivery_mode and .dest_mode_logical not used by XENPV */
 
 	.disable_esr			= 0,
 
diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index f696ac7c5f89..ba74a722a400 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -893,7 +893,7 @@ struct amd_ir_data {
 };
 
 struct amd_irte_ops {
-	void (*prepare)(void *, u32, u32, u8, u32, int);
+	void (*prepare)(void *, u32, bool, u8, u32, int);
 	void (*activate)(void *, u16, u16);
 	void (*deactivate)(void *, u16, u16);
 	void (*set_affinity)(void *, u16, u16, u8, u32);
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index bc81b91f89fe..d7f0c8908602 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3466,7 +3466,7 @@ static void free_irte(u16 devid, int index)
 }
 
 static void irte_prepare(void *entry,
-			 u32 delivery_mode, u32 dest_mode,
+			 u32 delivery_mode, bool dest_mode,
 			 u8 vector, u32 dest_apicid, int devid)
 {
 	union irte *irte = (union irte *) entry;
@@ -3480,7 +3480,7 @@ static void irte_prepare(void *entry,
 }
 
 static void irte_ga_prepare(void *entry,
-			    u32 delivery_mode, u32 dest_mode,
+			    u32 delivery_mode, bool dest_mode,
 			    u8 vector, u32 dest_apicid, int devid)
 {
 	struct irte_ga *irte = (struct irte_ga *) entry;
@@ -3672,7 +3672,7 @@ static void irq_remapping_prepare_irte(struct amd_ir_data *data,
 	data->irq_2_irte.devid = devid;
 	data->irq_2_irte.index = index + sub_handle;
 	iommu->irte_ops->prepare(data->entry, apic->delivery_mode,
-				 apic->irq_dest_mode, irq_cfg->vector,
+				 apic->dest_mode_logical, irq_cfg->vector,
 				 irq_cfg->dest_apicid, devid);
 
 	switch (info->type) {
@@ -3943,7 +3943,7 @@ int amd_iommu_deactivate_guest_mode(void *data)
 	entry->hi.val = 0;
 
 	entry->lo.fields_remap.valid       = valid;
-	entry->lo.fields_remap.dm          = apic->irq_dest_mode;
+	entry->lo.fields_remap.dm          = apic->dest_mode_logical;
 	entry->lo.fields_remap.int_type    = apic->delivery_mode;
 	entry->hi.fields.vector            = cfg->vector;
 	entry->lo.fields_remap.destination =
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index d44e719d1984..5628d43b795e 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1113,7 +1113,7 @@ static void prepare_irte(struct irte *irte, int vector, unsigned int dest)
 	memset(irte, 0, sizeof(*irte));
 
 	irte->present = 1;
-	irte->dst_mode = apic->irq_dest_mode;
+	irte->dst_mode = apic->dest_mode_logical;
 	/*
 	 * Trigger mode in the IRTE will always be edge, and for IO-APIC, the
 	 * actual level or edge trigger will be setup in the IO-APIC
-- 
2.26.2

