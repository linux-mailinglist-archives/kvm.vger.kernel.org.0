Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E17F297EBF
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764673AbgJXVfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764652AbgJXVfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E7C0613D4;
        Sat, 24 Oct 2020 14:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=j8yx8UZGkkgJFZytyZ6qp2N6IE4R2j2WOfRw0cU2eg0=; b=c4PrqY0Sw2gyT5FhUqzJHyXFpX
        9RfjAP4Dhw2AKcmR9PtzNHMnOf5hPAi+yquiWwoNlA871X+qNPC/7SpDCBNx3xz/wsqG/iB+wjd0Y
        jAkl2FAD4QTDHF3k48QuLt+fAKwOssUFb3bEfec5cQwhmnSgMU726YLLNoyitQgqEBsrzcRqKIDs+
        tPuno7XMj3Ae77yIDTJ5I80NPe1LQNQx5P9ztCppsD9OaHWpgogD7l1MoszYtaNGJlldzolP3tkYF
        /ZiuY4JC9JmxQwTaimrifxv6lu3Pa9Cu3ZreP2dE9sljzvfb6Q0eeFBfjnm+JNg2Z15w+jjag0b3N
        PTUC5J9Q==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCN-0006Ge-Uw; Sat, 24 Oct 2020 21:35:41 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rNc-JR; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 01/35] x86/apic: Fix x2apic enablement without interrupt remapping
Date:   Sat, 24 Oct 2020 22:35:01 +0100
Message-Id: <20201024213535.443185-2-dwmw2@infradead.org>
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

Currently, Linux as a hypervisor guest will enable x2apic only if there are
no CPUs present at boot time with an APIC ID above 255.

Hotplugging a CPU later with a higher APIC ID would result in a CPU which
cannot be targeted by external interrupts.

Add a filter in x2apic_apic_id_valid() which can be used to prevent such
CPUs from coming online, and allow x2apic to be enabled even if they are
present at boot time.

Fixes: ce69a784504 ("x86/apic: Enable x2APIC without interrupt remapping under KVM")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h        |  1 +
 arch/x86/kernel/apic/apic.c        | 14 ++++++++------
 arch/x86/kernel/apic/x2apic_phys.c |  9 +++++++++
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 1c129abb7f09..b0fd204e0023 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -259,6 +259,7 @@ static inline u64 native_x2apic_icr_read(void)
 
 extern int x2apic_mode;
 extern int x2apic_phys;
+extern void __init x2apic_set_max_apicid(u32 apicid);
 extern void __init check_x2apic(void);
 extern void x2apic_setup(void);
 static inline int x2apic_enabled(void)
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b3eef1d5c903..113f6ca7b828 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1841,20 +1841,22 @@ static __init void try_to_enable_x2apic(int remap_mode)
 		return;
 
 	if (remap_mode != IRQ_REMAP_X2APIC_MODE) {
-		/* IR is required if there is APIC ID > 255 even when running
-		 * under KVM
+		/*
+		 * Using X2APIC without IR is not architecturally supported
+		 * on bare metal but may be supported in guests.
 		 */
-		if (max_physical_apicid > 255 ||
-		    !x86_init.hyper.x2apic_available()) {
+		if (!x86_init.hyper.x2apic_available()) {
 			pr_info("x2apic: IRQ remapping doesn't support X2APIC mode\n");
 			x2apic_disable();
 			return;
 		}
 
 		/*
-		 * without IR all CPUs can be addressed by IOAPIC/MSI
-		 * only in physical mode
+		 * Without IR, all CPUs can be addressed by IOAPIC/MSI only
+		 * in physical mode, and CPUs with an APIC ID that cannnot
+		 * be addressed must not be brought online.
 		 */
+		x2apic_set_max_apicid(255);
 		x2apic_phys = 1;
 	}
 	x2apic_enable();
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index bc9693841353..e14eae6d6ea7 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -8,6 +8,12 @@
 int x2apic_phys;
 
 static struct apic apic_x2apic_phys;
+static u32 x2apic_max_apicid __ro_after_init;
+
+void __init x2apic_set_max_apicid(u32 apicid)
+{
+	x2apic_max_apicid = apicid;
+}
 
 static int __init set_x2apic_phys_mode(char *arg)
 {
@@ -98,6 +104,9 @@ static int x2apic_phys_probe(void)
 /* Common x2apic functions, also used by x2apic_cluster */
 int x2apic_apic_id_valid(u32 apicid)
 {
+	if (x2apic_max_apicid && apicid > x2apic_max_apicid)
+		return 0;
+
 	return 1;
 }
 
-- 
2.26.2

