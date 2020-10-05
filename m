Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA526283B31
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728748AbgJEPkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727530AbgJEP3L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:11 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D8CC0613B3;
        Mon,  5 Oct 2020 08:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=XZpeaCY1LXv0wJCD9ljKy5PuloAeL+yvhqxfkxIE2j4=; b=rRL24VUobJKY5mMHt//txZEHiE
        WMsuak0+jZk88U2WgfPSJ9NT7hifqNBRASBdU12LOZ8X8VGGkUN/+rTKa47g/iXdi1zTNJuPl2UEo
        GWNZ9Ct5GfvjCD0r1oaS0lG5fuZrpN4Y7M5eEsDUOVTjTWOj2dELhDbwrvbZ0UfggaMfGFPMrJA/8
        YxSN/hcfylRt1LLzuTUb+UsUWwoE6PqhympTTf01bF5jyNqTD/4CC/TIsV2vSIQCO13Wvn7FtBY61
        thLER1bEsp6cZgyILOWUj1b4SkqB4UPvNnu7x3rYEnJ7XhH9+wwn7cQdroXQT77scxYA+YNeeHjmZ
        dRKoZ2dg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ4-0001mL-RB; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045Qf-CD; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 07/13] irqdomain: Add max_affinity argument to irq_domain_alloc_descs()
Date:   Mon,  5 Oct 2020 16:28:50 +0100
Message-Id: <20201005152856.974112-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

This is the maximum possible set of CPUs which can be used. Use it
to calculate the default affinity requested from __irq_alloc_descs()
by first attempting to find the intersection with irq_default_affinity,
or falling back to using just the max_affinity if the intersection
would be empty.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/irqdomain.h |  3 ++-
 kernel/irq/ipi.c          |  2 +-
 kernel/irq/irqdomain.c    | 45 +++++++++++++++++++++++++++++++++------
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 44445d9de881..6b5576da77f0 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -278,7 +278,8 @@ extern void irq_set_default_host(struct irq_domain *host);
 extern struct irq_domain *irq_get_default_host(void);
 extern int irq_domain_alloc_descs(int virq, unsigned int nr_irqs,
 				  irq_hw_number_t hwirq, int node,
-				  const struct irq_affinity_desc *affinity);
+				  const struct irq_affinity_desc *affinity,
+				  const struct cpumask *max_affinity);
 
 static inline struct fwnode_handle *of_node_to_fwnode(struct device_node *node)
 {
diff --git a/kernel/irq/ipi.c b/kernel/irq/ipi.c
index 43e3d1be622c..13f56210eca9 100644
--- a/kernel/irq/ipi.c
+++ b/kernel/irq/ipi.c
@@ -75,7 +75,7 @@ int irq_reserve_ipi(struct irq_domain *domain,
 		}
 	}
 
-	virq = irq_domain_alloc_descs(-1, nr_irqs, 0, NUMA_NO_NODE, NULL);
+	virq = irq_domain_alloc_descs(-1, nr_irqs, 0, NUMA_NO_NODE, NULL, dest);
 	if (virq <= 0) {
 		pr_warn("Can't reserve IPI, failed to alloc descs\n");
 		return -ENOMEM;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index c93e00ca11d8..ffd41f21afca 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -660,7 +660,8 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	}
 
 	/* Allocate a virtual interrupt number */
-	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node), NULL);
+	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
+				      NULL, NULL);
 	if (virq <= 0) {
 		pr_debug("-> virq allocation failed\n");
 		return 0;
@@ -1011,25 +1012,57 @@ int irq_domain_translate_twocell(struct irq_domain *d,
 EXPORT_SYMBOL_GPL(irq_domain_translate_twocell);
 
 int irq_domain_alloc_descs(int virq, unsigned int cnt, irq_hw_number_t hwirq,
-			   int node, const struct irq_affinity_desc *affinity)
+			   int node, const struct irq_affinity_desc *affinity,
+			   const struct cpumask *max_affinity)
 {
+	cpumask_var_t default_affinity;
 	unsigned int hint;
+	int i;
+
+	/* Check requested per-IRQ affinities are in the possible range */
+	if (affinity && max_affinity) {
+		for (i = 0; i < cnt; i++)
+			if (!cpumask_subset(&affinity[i].mask, max_affinity))
+				return -EINVAL;
+	}
+
+	/*
+	 * Generate default affinity. Either the possible subset of
+	 * irq_default_affinity if such a subset is non-empty, or fall
+	 * back to the provided max_affinity if there is no intersection.
+	 * And just a copy of irq_default_affinity in the
+	 * !CONFIG_CPUMASK_OFFSTACK case.
+	 */
+	memset(&default_affinity, 0, sizeof(default_affinity));
+	if ((max_affinity &&
+	     !cpumask_subset(irq_default_affinity, max_affinity))) {
+		if (!alloc_cpumask_var(&default_affinity, GFP_KERNEL))
+			return -ENOMEM;
+		cpumask_and(default_affinity, max_affinity,
+			    irq_default_affinity);
+		if (cpumask_empty(default_affinity))
+			cpumask_copy(default_affinity, max_affinity);
+	} else if (cpumask_available(default_affinity))
+		cpumask_copy(default_affinity, irq_default_affinity);
 
 	if (virq >= 0) {
 		virq = __irq_alloc_descs(virq, virq, cnt, node, THIS_MODULE,
-					 affinity, NULL);
+					 affinity, default_affinity);
 	} else {
 		hint = hwirq % nr_irqs;
 		if (hint == 0)
 			hint++;
 		virq = __irq_alloc_descs(-1, hint, cnt, node, THIS_MODULE,
-					 affinity, NULL);
+					 affinity, default_affinity);
 		if (virq <= 0 && hint > 1) {
 			virq = __irq_alloc_descs(-1, 1, cnt, node, THIS_MODULE,
-						 affinity, NULL);
+						 affinity, default_affinity);
 		}
 	}
 
+	if (cpumask_available(default_affinity))
+		free_cpumask_var(default_affinity);
+
 	return virq;
 }
 
@@ -1342,7 +1375,7 @@ int __irq_domain_alloc_irqs(struct irq_domain *domain, int irq_base,
 		virq = irq_base;
 	} else {
 		virq = irq_domain_alloc_descs(irq_base, nr_irqs, 0, node,
-					      affinity);
+					      affinity, NULL);
 		if (virq < 0) {
 			pr_debug("cannot allocate IRQ(base %d, count %d)\n",
 				 irq_base, nr_irqs);
-- 
2.26.2

