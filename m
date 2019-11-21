Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 821D61047C6
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 01:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbfKUA6q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 19:58:46 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:43295 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfKUA6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 19:58:46 -0500
Received: by ozlabs.org (Postfix, from userid 1007)
        id 47JLm43p1Sz9sQp; Thu, 21 Nov 2019 11:58:44 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=gibson.dropbear.id.au; s=201602; t=1574297924;
        bh=kjLCHlKyKt7jP0NFe7tI8vqbJnysCqs9Js2O7NlIAAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d5Yl8X8jt5f6X3VYPrSZIeC4Sr8ahHtnfT9r4tRoBX95XiR92/bUGI6IPEAELp+p/
         gj4PkS/PiYEpGg2AlbgHsnkezWv9MlYEin1RnA0QOdA8ICddY5MvLGDgMhrae1DmfQ
         tN1PBz0gCD0y8oOnF1ZySK7+BH5GU5e+myP++TYw=
From:   David Gibson <david@gibson.dropbear.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>, clg@kaod.org
Cc:     groug@kaod.org, philmd@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, qemu-devel@nongnu.org,
        Riku Voipio <riku.voipio@iki.fi>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH 5/5] spapr: Work around spurious warnings from vfio INTx initialization
Date:   Thu, 21 Nov 2019 11:56:07 +1100
Message-Id: <20191121005607.274347-6-david@gibson.dropbear.id.au>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191121005607.274347-1-david@gibson.dropbear.id.au>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Traditional PCI INTx for vfio devices can only perform well if using
an in-kernel irqchip.  Therefore, vfio_intx_update() issues a warning
if an in kernel irqchip is not available.

We usually do have an in-kernel irqchip available for pseries machines
on POWER hosts.  However, because the platform allows feature
negotiation of what interrupt controller model to use, we don't
currently initialize it until machine reset.  vfio_intx_update() is
called (first) from vfio_realize() before that, so it can issue a
spurious warning, even if we will have an in kernel irqchip by the
time we need it.

To workaround this, make a call to spapr_irq_update_active_intc() from
spapr_irq_init() which is called at machine realize time, before the
vfio realize.  This call will be pretty much obsoleted by the later
call at reset time, but it serves to suppress the spurious warning
from VFIO.

Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
---
 hw/ppc/spapr_irq.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
index 1d27034962..d6bb7fd2d6 100644
--- a/hw/ppc/spapr_irq.c
+++ b/hw/ppc/spapr_irq.c
@@ -373,6 +373,14 @@ void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
 
     spapr->qirqs = qemu_allocate_irqs(spapr_set_irq, spapr,
                                       smc->nr_xirqs + SPAPR_XIRQ_BASE);
+
+    /*
+     * Mostly we don't actually need this until reset, except that not
+     * having this set up can cause VFIO devices to issue a
+     * false-positive warning during realize(), because they don't yet
+     * have an in-kernel irq chip.
+     */
+    spapr_irq_update_active_intc(spapr);
 }
 
 int spapr_irq_claim(SpaprMachineState *spapr, int irq, bool lsi, Error **errp)
@@ -528,7 +536,8 @@ void spapr_irq_update_active_intc(SpaprMachineState *spapr)
          * this.
          */
         new_intc = SPAPR_INTC(spapr->xive);
-    } else if (spapr_ovec_test(spapr->ov5_cas, OV5_XIVE_EXPLOIT)) {
+    } else if (spapr->ov5_cas
+               && spapr_ovec_test(spapr->ov5_cas, OV5_XIVE_EXPLOIT)) {
         new_intc = SPAPR_INTC(spapr->xive);
     } else {
         new_intc = SPAPR_INTC(spapr->ics);
-- 
2.23.0

