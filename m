Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D260D283B51
	for <lists+kvm@lfdr.de>; Mon,  5 Oct 2020 17:41:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728779AbgJEPkz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Oct 2020 11:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727489AbgJEP3C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Oct 2020 11:29:02 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A27C0613AC;
        Mon,  5 Oct 2020 08:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=Wl3IkjJBUUxi3oxlkfGR/3vrMCl8kgivTGhAoZmqxgU=; b=lCd0XzlrYSd6b5lfYfJg99NYqp
        MDbQn98GnIajhGC1tuNDSTCUFl6Fmw5s/cIm/C1fpnQoGrD5hYxygBT0nYkqMcmsHxJx4bU/yt5Ov
        jwdSlL+WnndLsylOxJqEcENBz+2nSFUHjNMkBpnZPHv4qVmYE3EH4fHCh5p+/AlHJVGVuxf/p0PF7
        15OuOcNqunrSP4p41XExqUTJfPv6YbN3MNZ/iYsoDRMk+2LO2/gLfeGu6fC4x5bQfYurxgiv77kpI
        1m51xXY3N95F/EgoUvKO0Cquddr7cq0bRV/+N2+WFjqnVYJadu3SyMxdTmOu+P/Qcnwr0geb168OB
        CMedJzQw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kPSQ5-0004MJ-Cc; Mon, 05 Oct 2020 15:28:57 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kPSQ4-0045Qa-BS; Mon, 05 Oct 2020 16:28:56 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 06/13] genirq: Add default_affinity argument to __irq_alloc_descs()
Date:   Mon,  5 Oct 2020 16:28:49 +0100
Message-Id: <20201005152856.974112-6-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201005152856.974112-1-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org>
 <20201005152856.974112-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

It already takes an array of affinities for each individual irq being
allocated but that's awkward to allocate and populate in the case
where they're all the same and inherited from the irqdomain, so pass
the default in separately as a simple cpumask.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 include/linux/irq.h    | 10 ++++++----
 kernel/irq/devres.c    |  8 ++++++--
 kernel/irq/irqdesc.c   | 10 ++++++++--
 kernel/irq/irqdomain.c |  6 +++---
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/linux/irq.h b/include/linux/irq.h
index 1b7f4dfee35b..6e119594d35d 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -897,15 +897,17 @@ unsigned int arch_dynirq_lower_bound(unsigned int from);
 
 int __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		      struct module *owner,
-		      const struct irq_affinity_desc *affinity);
+		      const struct irq_affinity_desc *affinity,
+		      const struct cpumask *default_affinity);
 
 int __devm_irq_alloc_descs(struct device *dev, int irq, unsigned int from,
 			   unsigned int cnt, int node, struct module *owner,
-			   const struct irq_affinity_desc *affinity);
+			   const struct irq_affinity_desc *affinity,
+			   const struct cpumask *default_affinity);
 
 /* use macros to avoid needing export.h for THIS_MODULE */
 #define irq_alloc_descs(irq, from, cnt, node)	\
-	__irq_alloc_descs(irq, from, cnt, node, THIS_MODULE, NULL)
+	__irq_alloc_descs(irq, from, cnt, node, THIS_MODULE, NULL, NULL)
 
 #define irq_alloc_desc(node)			\
 	irq_alloc_descs(-1, 0, 1, node)
@@ -920,7 +922,7 @@ int __devm_irq_alloc_descs(struct device *dev, int irq, unsigned int from,
 	irq_alloc_descs(-1, from, cnt, node)
 
 #define devm_irq_alloc_descs(dev, irq, from, cnt, node)		\
-	__devm_irq_alloc_descs(dev, irq, from, cnt, node, THIS_MODULE, NULL)
+	__devm_irq_alloc_descs(dev, irq, from, cnt, node, THIS_MODULE, NULL, NULL)
 
 #define devm_irq_alloc_desc(dev, node)				\
 	devm_irq_alloc_descs(dev, -1, 0, 1, node)
diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index f6e5515ee077..079339decc23 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -170,6 +170,8 @@ static void devm_irq_desc_release(struct device *dev, void *res)
  * @affinity:	Optional pointer to an irq_affinity_desc array of size @cnt
  *		which hints where the irq descriptors should be allocated
  *		and which default affinities to use
+ * @default_affinity: Optional pointer to a cpumask indicating the default
+ *              affinity to use where not specified by the @affinity array
  *
  * Returns the first irq number or error code.
  *
@@ -177,7 +179,8 @@ static void devm_irq_desc_release(struct device *dev, void *res)
  */
 int __devm_irq_alloc_descs(struct device *dev, int irq, unsigned int from,
 			   unsigned int cnt, int node, struct module *owner,
-			   const struct irq_affinity_desc *affinity)
+			   const struct irq_affinity_desc *affinity,
+			   const struct cpumask *default_affinity)
 {
 	struct irq_desc_devres *dr;
 	int base;
@@ -186,7 +189,8 @@ int __devm_irq_alloc_descs(struct device *dev, int irq, unsigned int from,
 	if (!dr)
 		return -ENOMEM;
 
-	base = __irq_alloc_descs(irq, from, cnt, node, owner, affinity);
+	base = __irq_alloc_descs(irq, from, cnt, node, owner, affinity,
+				 default_affinity);
 	if (base < 0) {
 		devres_free(dr);
 		return base;
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 4ac91b9fc618..fcc3b8a1fe01 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -770,15 +770,21 @@ EXPORT_SYMBOL_GPL(irq_free_descs);
  * @affinity:	Optional pointer to an affinity mask array of size @cnt which
  *		hints where the irq descriptors should be allocated and which
  *		default affinities to use
+ * @default_affinity: Optional pointer to a cpumask indicating the default
+ *              affinity where not specified in the @affinity array
  *
  * Returns the first irq number or error code
  */
 int __ref
 __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
-		  struct module *owner, const struct irq_affinity_desc *affinity)
+		  struct module *owner, const struct irq_affinity_desc *affinity,
+		  const struct cpumask *default_affinity)
 {
 	int start, ret;
 
+	if (!default_affinity)
+		default_affinity = irq_default_affinity;
+
 	if (!cnt)
 		return -EINVAL;
 
@@ -808,7 +814,7 @@ __irq_alloc_descs(int irq, unsigned int from, unsigned int cnt, int node,
 		if (ret)
 			goto unlock;
 	}
-	ret = alloc_descs(start, cnt, node, affinity, irq_default_affinity, owner);
+	ret = alloc_descs(start, cnt, node, affinity, default_affinity, owner);
 unlock:
 	mutex_unlock(&sparse_irq_lock);
 	return ret;
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 76cd7ebd1178..c93e00ca11d8 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1017,16 +1017,16 @@ int irq_domain_alloc_descs(int virq, unsigned int cnt, irq_hw_number_t hwirq,
 
 	if (virq >= 0) {
 		virq = __irq_alloc_descs(virq, virq, cnt, node, THIS_MODULE,
-					 affinity);
+					 affinity, NULL);
 	} else {
 		hint = hwirq % nr_irqs;
 		if (hint == 0)
 			hint++;
 		virq = __irq_alloc_descs(-1, hint, cnt, node, THIS_MODULE,
-					 affinity);
+					 affinity, NULL);
 		if (virq <= 0 && hint > 1) {
 			virq = __irq_alloc_descs(-1, 1, cnt, node, THIS_MODULE,
-						 affinity);
+						 affinity, NULL);
 		}
 	}
 
-- 
2.26.2

