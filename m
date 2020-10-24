Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D968297F4B
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1765139AbgJXVjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764664AbgJXVfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:45 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280FFC0613D6;
        Sat, 24 Oct 2020 14:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=C0ceQD7RpCrLmfkKsXqDNRC608zY/4Bwc4glHhGbq80=; b=TwEX9h4adZHoXwYi8vmInLnsVN
        +L00VhuxtBSQRwLUTSJ5jmMYv/ofpq6xWavAf2eLtMgt0QerE2T6qWmlGIPDOYYUoXErC5wT7MW6J
        OC3nYqgXSRYuxPwEPXglZnUB/2RMNn2oWJNVb1sOKN+TmcTG6+YkCmW2KvstC6FwMIFj0W2uU7oUO
        tq2zyrZwt3lZfapPP3J3Uxixizj72G6QEJQ2AhuyKyhF6MJER9cH/0ylydQ+wdoXyp6eB7M+co4/g
        vtQz3atVW+BnhGqrD1RuATTwH9Fu5W0er2CXYIFso+7o8LQ1S10Um/57zMAu8buVBVlL3QoKdVQPa
        H63NuUvg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCO-0008B4-Gj; Sat, 24 Oct 2020 21:35:40 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCM-001rNo-Lh; Sat, 24 Oct 2020 22:35:38 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 04/35] x86/devicetree: Fix the ioapic interrupt type table
Date:   Sat, 24 Oct 2020 22:35:04 +0100
Message-Id: <20201024213535.443185-5-dwmw2@infradead.org>
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

The ioapic interrupt type table is wrong as it assumes that polarity in
IO/APIC context means active high when set. But the IO/APIC polarity is
working the other way round. This works because the ordering of the entries
is consistent with the device tree and the type information is not used by
the IO/APIC interrupt chip.

The whole trigger and polarity business of IO/APIC is misleading and the
corresponding constants which are defined as 0/1 are not used consistently
and are going to be removed.

Rename the type table members to 'is_level' and 'active_low' and adjust the
type information for consistency sake.

No functional change.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/devicetree.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index ddffd80f5c52..6a4cb71c2498 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -184,31 +184,31 @@ static unsigned int ioapic_id;
 
 struct of_ioapic_type {
 	u32 out_type;
-	u32 trigger;
-	u32 polarity;
+	u32 is_level;
+	u32 active_low;
 };
 
 static struct of_ioapic_type of_ioapic_type[] =
 {
 	{
-		.out_type	= IRQ_TYPE_EDGE_RISING,
-		.trigger	= IOAPIC_EDGE,
-		.polarity	= 1,
+		.out_type	= IRQ_TYPE_EDGE_FALLING,
+		.is_level	= 0,
+		.active_low	= 1,
 	},
 	{
-		.out_type	= IRQ_TYPE_LEVEL_LOW,
-		.trigger	= IOAPIC_LEVEL,
-		.polarity	= 0,
+		.out_type	= IRQ_TYPE_LEVEL_HIGH,
+		.is_level	= 1,
+		.active_low	= 0,
 	},
 	{
-		.out_type	= IRQ_TYPE_LEVEL_HIGH,
-		.trigger	= IOAPIC_LEVEL,
-		.polarity	= 1,
+		.out_type	= IRQ_TYPE_LEVEL_LOW,
+		.is_level	= 1,
+		.active_low	= 1,
 	},
 	{
-		.out_type	= IRQ_TYPE_EDGE_FALLING,
-		.trigger	= IOAPIC_EDGE,
-		.polarity	= 0,
+		.out_type	= IRQ_TYPE_EDGE_RISING,
+		.is_level	= 0,
+		.active_low	= 0,
 	},
 };
 
@@ -228,7 +228,7 @@ static int dt_irqdomain_alloc(struct irq_domain *domain, unsigned int virq,
 		return -EINVAL;
 
 	it = &of_ioapic_type[type_index];
-	ioapic_set_alloc_attr(&tmp, NUMA_NO_NODE, it->trigger, it->polarity);
+	ioapic_set_alloc_attr(&tmp, NUMA_NO_NODE, it->is_level, it->active_low);
 	tmp.devid = mpc_ioapic_id(mp_irqdomain_ioapic_idx(domain));
 	tmp.ioapic.pin = fwspec->param[0];
 
-- 
2.26.2

