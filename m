Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFA1297ED2
	for <lists+kvm@lfdr.de>; Sat, 24 Oct 2020 23:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764763AbgJXVfz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Oct 2020 17:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1764731AbgJXVfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Oct 2020 17:35:52 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0229C0613E0;
        Sat, 24 Oct 2020 14:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=vY4VeUNE4ub3qAa7/DTejR8N6Au5nI3L6gpKsZbam04=; b=CGS6AgmuJiEDHlbp5JlgH7kVgj
        k+HJBGTucA4hUi1p3n2w+cpMW82eiAZ3Geyn1TGSRU++jsSdxIec+aHNgWAS/AU/WHduV39C9RgiK
        QsQmtOlCnTq328mjkLW20vokGI7r0AG3Xr5xYljGRr5ZfUJ+EZppTl2z01CwN1PNCW2M/iG/anCCO
        0LIFbjKAV7ZXWMTE0gaU3XFMEvGae9zd2WTwFWNxnm9D1XpTbDRYvrMtDY2z6NqT1i4/7ArzCSwOG
        UaFP/j0A93As3oEnW6GRZ6awGGRomCxj77XZhIx1xEwsaiSL38oazQWUf0mRmlni2E6a5RT6ynqov
        uUvnig5A==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kWRCT-0008Bd-CB; Sat, 24 Oct 2020 21:35:45 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kWRCN-001rPK-Az; Sat, 24 Oct 2020 22:35:39 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     kvm <kvm@vger.kernel.org>, iommu@lists.linux-foundation.org,
        joro@8bytes.org, Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        Dexuan Cui <decui@microsoft.com>
Subject: [PATCH v3 27/35] x86/hpet: Use irq_find_matching_fwspec() to find remapping irqdomain
Date:   Sat, 24 Oct 2020 22:35:27 +0100
Message-Id: <20201024213535.443185-28-dwmw2@infradead.org>
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
 arch/x86/kernel/hpet.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 3b8b12769f3b..08651a4e6aa0 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -543,8 +543,8 @@ static struct irq_domain *hpet_create_irq_domain(int hpet_id)
 {
 	struct msi_domain_info *domain_info;
 	struct irq_domain *parent, *d;
-	struct irq_alloc_info info;
 	struct fwnode_handle *fn;
+	struct irq_fwspec fwspec;
 
 	if (x86_vector_domain == NULL)
 		return NULL;
@@ -556,15 +556,6 @@ static struct irq_domain *hpet_create_irq_domain(int hpet_id)
 	*domain_info = hpet_msi_domain_info;
 	domain_info->data = (void *)(long)hpet_id;
 
-	init_irq_alloc_info(&info, NULL);
-	info.type = X86_IRQ_ALLOC_TYPE_HPET_GET_PARENT;
-	info.devid = hpet_id;
-	parent = irq_remapping_get_irq_domain(&info);
-	if (parent == NULL)
-		parent = x86_vector_domain;
-	else
-		hpet_msi_controller.name = "IR-HPET-MSI";
-
 	fn = irq_domain_alloc_named_id_fwnode(hpet_msi_controller.name,
 					      hpet_id);
 	if (!fn) {
@@ -572,6 +563,19 @@ static struct irq_domain *hpet_create_irq_domain(int hpet_id)
 		return NULL;
 	}
 
+	fwspec.fwnode = fn;
+	fwspec.param_count = 1;
+	fwspec.param[0] = hpet_id;
+
+	parent = irq_find_matching_fwspec(&fwspec, DOMAIN_BUS_ANY);
+	if (!parent) {
+		irq_domain_free_fwnode(fn);
+		kfree(domain_info);
+		return NULL;
+	}
+	if (parent != x86_vector_domain)
+		hpet_msi_controller.name = "IR-HPET-MSI";
+
 	d = msi_create_irq_domain(fn, domain_info, parent);
 	if (!d) {
 		irq_domain_free_fwnode(fn);
-- 
2.26.2

