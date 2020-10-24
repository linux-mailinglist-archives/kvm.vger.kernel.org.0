Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11608297ED0
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764754AbgJXVfy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764726AbgJXVfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:52 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834DCC0613D7;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=dVWYqwOpG66oKX5svS6ZlXfTZXDaQ+ZmZqMxCBBPuTc=; b=b7bS7Q7YjADoKR9ro46av1BMgb
        jIzp/la1E+nYqRcak3fiLzA1rLgljrnoA7LB5ZL0nADGU9VuZNrP2rT+jHbLUzHn/ebU/yKeR/82D
        a99KuP6VnnXsANM6mveqdHru9/5UCZQb8Kx264lN1mRPoSIhq7vTkjTRSyGhp0rNzqrpDS7aAlgUZ
        TFtHhMOizrN2xPM1jhDD1PBCyxgEMV5omsxK8z3r9TvTmjoCitN5In7lHOUgYdLUxeLM96K6Ohr7G
        /4VfjGaET8Y24X7EOUQa/2mHm6Z3nG2KfFLTdWIKZRwK3TcMpl8pMNilsKnFvlmVJ5loCzDBW35Qv
        fLenPPjA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCS-0008BT-Pg; Sat, 24 Oct 2020 21:35:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rO0-OJ; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 07/35] x86/apic: Get rid of apic::dest_logical
Date:   Sat, 24 Oct 2020 22:35:07 +0100
Message-Id: <20201024213535.443185-8-dwmw2@infradead.org>
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

From: Thomas Gleixner <tglx@linutronix.de>

struct apic has two members which store information about the destination
mode: dest_logical and irq_dest_mode.

dest_logical contains a mask which was historically used to set the
destination mode in IPI messages. Over time the usage was reduced and the
logical/physical functions were seperated.

There are only a few places which still use 'dest_logical' but they can
ues 'irq_dest_mode' instead.

irq_dest_mode is actually a boolean where 0 means physical destination mode
and 1 means logical destination mode. Of course the name does not reflect
the functionality. This will be cleaned up in a subsequent change.

Remove apic::dest_logical and fixup the remaining users.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/apic.h           | 2 --
 arch/x86/kernel/apic/apic.c           | 2 +-
 arch/x86/kernel/apic/apic_flat_64.c   | 8 ++------
 arch/x86/kernel/apic/apic_noop.c      | 4 +---
 arch/x86/kernel/apic/apic_numachip.c  | 8 ++------
 arch/x86/kernel/apic/bigsmp_32.c      | 4 +---
 arch/x86/kernel/apic/probe_32.c       | 4 +---
 arch/x86/kernel/apic/x2apic_cluster.c | 4 +---
 arch/x86/kernel/apic/x2apic_phys.c    | 4 +---
 arch/x86/kernel/apic/x2apic_uv_x.c    | 4 +---
 arch/x86/kernel/smpboot.c             | 5 +++--
 arch/x86/xen/apic.c                   | 4 +---
 12 files changed, 15 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 53bb62e0fdd5..019d7ac3b16e 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -306,8 +306,6 @@ struct apic {
 	void	(*send_IPI_all)(int vector);
 	void	(*send_IPI_self)(int vector);
 
-	/* dest_logical is used by the IPI functions */
-	u32	dest_logical;
 	u32	disable_esr;
 
 	enum apic_delivery_modes delivery_mode;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 113f6ca7b828..29d28b34cb2f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1591,7 +1591,7 @@ static void setup_local_APIC(void)
 	apic->init_apic_ldr();
 
 #ifdef CONFIG_X86_32
-	if (apic->dest_logical) {
+	if (apic->irq_dest_mode == 1) {
 		int logical_apicid, ldr_apicid;
 
 		/*
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 6df837fd5081..bbb1b89fe711 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -117,11 +117,9 @@ static struct apic apic_flat __ro_after_init = {
 	.irq_dest_mode			= 1, /* logical */
 
 	.disable_esr			= 0,
-	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= NULL,
 
+	.check_apicid_used		= NULL,
 	.init_apic_ldr			= flat_init_apic_ldr,
-
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
@@ -210,11 +208,9 @@ static struct apic apic_physflat __ro_after_init = {
 	.irq_dest_mode			= 0, /* physical */
 
 	.disable_esr			= 0,
-	.dest_logical			= 0,
-	.check_apicid_used		= NULL,
 
+	.check_apicid_used		= NULL,
 	.init_apic_ldr			= physflat_init_apic_ldr,
-
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 4fc934b11851..38f167ce5031 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -100,11 +100,9 @@ struct apic apic_noop __ro_after_init = {
 	.irq_dest_mode			= 1,
 
 	.disable_esr			= 0,
-	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= default_check_apicid_used,
 
+	.check_apicid_used		= default_check_apicid_used,
 	.init_apic_ldr			= noop_init_apic_ldr,
-
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= NULL,
 
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index db715d082ec9..4ebf9fe2c95d 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -250,11 +250,9 @@ static const struct apic apic_numachip1 __refconst = {
 	.irq_dest_mode			= 0, /* physical */
 
 	.disable_esr			= 0,
-	.dest_logical			= 0,
-	.check_apicid_used		= NULL,
 
+	.check_apicid_used		= NULL,
 	.init_apic_ldr			= flat_init_apic_ldr,
-
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
@@ -299,11 +297,9 @@ static const struct apic apic_numachip2 __refconst = {
 	.irq_dest_mode			= 0, /* physical */
 
 	.disable_esr			= 0,
-	.dest_logical			= 0,
-	.check_apicid_used		= NULL,
 
+	.check_apicid_used		= NULL,
 	.init_apic_ldr			= flat_init_apic_ldr,
-
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 7f6461f5d349..64c375b8c54e 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -132,11 +132,9 @@ static struct apic apic_bigsmp __ro_after_init = {
 	.irq_dest_mode			= 0,
 
 	.disable_esr			= 1,
-	.dest_logical			= 0,
-	.check_apicid_used		= bigsmp_check_apicid_used,
 
+	.check_apicid_used		= bigsmp_check_apicid_used,
 	.init_apic_ldr			= bigsmp_init_apic_ldr,
-
 	.ioapic_phys_id_map		= bigsmp_ioapic_phys_id_map,
 	.setup_apic_routing		= bigsmp_setup_apic_routing,
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 77c6e2e04a1f..97652aacf3e1 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -74,11 +74,9 @@ static struct apic apic_default __ro_after_init = {
 	.irq_dest_mode			= 1,
 
 	.disable_esr			= 0,
-	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= default_check_apicid_used,
 
+	.check_apicid_used		= default_check_apicid_used,
 	.init_apic_ldr			= default_init_apic_ldr,
-
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map,
 	.setup_apic_routing		= setup_apic_flat_routing,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index f77e9fb7aac1..53390fc9f51e 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -188,11 +188,9 @@ static struct apic apic_x2apic_cluster __ro_after_init = {
 	.irq_dest_mode			= 1, /* logical */
 
 	.disable_esr			= 0,
-	.dest_logical			= APIC_DEST_LOGICAL,
-	.check_apicid_used		= NULL,
 
+	.check_apicid_used		= NULL,
 	.init_apic_ldr			= init_x2apic_ldr,
-
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 437e8439db67..ee0c4d08092c 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -161,11 +161,9 @@ static struct apic apic_x2apic_phys __ro_after_init = {
 	.irq_dest_mode			= 0, /* physical */
 
 	.disable_esr			= 0,
-	.dest_logical			= 0,
-	.check_apicid_used		= NULL,
 
+	.check_apicid_used		= NULL,
 	.init_apic_ldr			= init_x2apic_ldr,
-
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 49deefdded68..d21a6853afee 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -811,11 +811,9 @@ static struct apic apic_x2apic_uv_x __ro_after_init = {
 	.irq_dest_mode			= 0, /* Physical */
 
 	.disable_esr			= 0,
-	.dest_logical			= APIC_DEST_PHYSICAL,
-	.check_apicid_used		= NULL,
 
+	.check_apicid_used		= NULL,
 	.init_apic_ldr			= uv_init_apic_ldr,
-
 	.ioapic_phys_id_map		= NULL,
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index de776b2e6046..6c14f1091f60 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -747,13 +747,14 @@ static void __init smp_quirk_init_udelay(void)
 int
 wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 {
+	u32 dm = apic->irq_dest_mode ? APIC_DEST_LOGICAL : APIC_DEST_PHYSICAL;
 	unsigned long send_status, accept_status = 0;
 	int maxlvt;
 
 	/* Target chip */
 	/* Boot on the stack */
 	/* Kick the second */
-	apic_icr_write(APIC_DM_NMI | apic->dest_logical, apicid);
+	apic_icr_write(APIC_DM_NMI | dm, apicid);
 
 	pr_debug("Waiting for send to finish...\n");
 	send_status = safe_apic_wait_icr_idle();
@@ -980,7 +981,7 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 	if (!boot_error) {
 		enable_start_cpu0 = 1;
 		*cpu0_nmi_registered = 1;
-		if (apic->dest_logical == APIC_DEST_LOGICAL)
+		if (apic->irq_dest_mode)
 			id = cpu0_logical_apicid;
 		else
 			id = apicid;
diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index e82fd1910dae..c35c24b5bc01 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -152,11 +152,9 @@ static struct apic xen_pv_apic = {
 	/* .irq_dest_mode     - used in native_compose_msi_msg only */
 
 	.disable_esr			= 0,
-	/* .dest_logical      -  default_send_IPI_ use it but we use our own. */
-	.check_apicid_used		= default_check_apicid_used, /* Used on 32-bit */
 
+	.check_apicid_used		= default_check_apicid_used, /* Used on 32-bit */
 	.init_apic_ldr			= xen_noop, /* setup_local_APIC calls it */
-
 	.ioapic_phys_id_map		= default_ioapic_phys_id_map, /* Used on 32-bit */
 	.setup_apic_routing		= NULL,
 	.cpu_present_to_apicid		= xen_cpu_present_to_apicid,
-- 
2.26.2

