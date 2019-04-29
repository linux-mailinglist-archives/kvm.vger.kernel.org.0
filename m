Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26298DE3D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2019 10:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfD2IrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Apr 2019 04:47:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:48129 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727480AbfD2Iq7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Apr 2019 04:46:59 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 44syvM42m0z9s70; Mon, 29 Apr 2019 18:46:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1556527615; bh=i+Wv/z49P326KmfFQzJzbCpD2oPczgYevwA3iDXog7o=;
        h=Date:From:To:Cc:Subject:From;
        b=JEe/y7eb/wET0JMiHLX6IkXeSakXhDBO7jNf9PCRbdbqc51W6LzCfg60rKhIydqrZ
         ly2Li8iH7OHS0WckWUl8w9A/SEjTexHREEEUuSIqyVeTqbviznPsu2uDCOytZi9+hY
         fzPhyRXjdqrOo3I52D3oy6NYBVgbOi+l+07wm3Qx3Okc4gYtdCYvyP2utDKSe2X7QW
         o6VAgZnta1T1OS1Sw7hzpQZS8SCJAJTVAxqJOeRhUoZ5Yny116MTcDqyyjV7IFYwnI
         2PN2wG22RDwERMNSkz+sEA3FblELPLyhzA9yMKnBwx2YPHyV0KnNnSanlhXcQA/wcz
         STaY789DYxIIg==
Date:   Mon, 29 Apr 2019 15:42:36 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, benh@ozlabs.org
Subject: [PATCH] KVM: PPC: Book3S HV: Fix XICS-on-XIVE H_IPI when priority = 0
Message-ID: <20190429054236.GA15557@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This fixes a bug in the XICS emulation on POWER9 machines which is
triggered by the guest doing a H_IPI with priority = 0 (the highest
priority).  What happens is that the notification interrupt arrives
at the destination at priority zero.  The loop in scan_interrupts()
sees that a priority 0 interrupt is pending, but because xc->mfrr is
zero, we break out of the loop before taking the notification
interrupt out of the queue and EOI-ing it.  (This doesn't happen
when xc->mfrr != 0; in that case we process the priority-0 notification
interrupt on the first iteration of the loop, and then break out of
a subsequent iteration of the loop with hirq == XICS_IPI.)

To fix this, we move the prio >= xc->mfrr check down to near the end
of the loop.  However, there are then some other things that need to
be adjusted.  Since we are potentially handling the notification
interrupt and also delivering an IPI to the guest in the same loop
iteration, we need to update pending and handle any q->pending_count
value before the xc->mfrr check, rather than at the end of the loop.
Also, we need to update the queue pointers when we have processed and
EOI-ed the notification interrupt, since we may not do it later.

Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_xive_template.c | 71 ++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_xive_template.c b/arch/powerpc/kvm/book3s_xive_template.c
index 033363d..593c412 100644
--- a/arch/powerpc/kvm/book3s_xive_template.c
+++ b/arch/powerpc/kvm/book3s_xive_template.c
@@ -130,21 +130,6 @@ static u32 GLUE(X_PFX,scan_interrupts)(struct kvmppc_xive_vcpu *xc,
 		 */
 		prio = ffs(pending) - 1;
 
-		/*
-		 * If the most favoured prio we found pending is less
-		 * favored (or equal) than a pending IPI, we return
-		 * the IPI instead.
-		 *
-		 * Note: If pending was 0 and mfrr is 0xff, we will
-		 * not spurriously take an IPI because mfrr cannot
-		 * then be smaller than cppr.
-		 */
-		if (prio >= xc->mfrr && xc->mfrr < xc->cppr) {
-			prio = xc->mfrr;
-			hirq = XICS_IPI;
-			break;
-		}
-
 		/* Don't scan past the guest cppr */
 		if (prio >= xc->cppr || prio > 7)
 			break;
@@ -184,9 +169,12 @@ static u32 GLUE(X_PFX,scan_interrupts)(struct kvmppc_xive_vcpu *xc,
 		 * been set and another occurrence of the IPI will trigger.
 		 */
 		if (hirq == XICS_IPI || (prio == 0 && !qpage)) {
-			if (scan_type == scan_fetch)
+			if (scan_type == scan_fetch) {
 				GLUE(X_PFX,source_eoi)(xc->vp_ipi,
 						       &xc->vp_ipi_data);
+				q->idx = idx;
+				q->toggle = toggle;
+			}
 			/* Loop back on same queue with updated idx/toggle */
 #ifdef XIVE_RUNTIME_CHECKS
 			WARN_ON(hirq && hirq != XICS_IPI);
@@ -199,32 +187,41 @@ static u32 GLUE(X_PFX,scan_interrupts)(struct kvmppc_xive_vcpu *xc,
 		if (hirq == XICS_DUMMY)
 			goto skip_ipi;
 
-		/* If fetching, update queue pointers */
-		if (scan_type == scan_fetch) {
-			q->idx = idx;
-			q->toggle = toggle;
-		}
-
-		/* Something found, stop searching */
-		if (hirq)
-			break;
-
-		/* Clear the pending bit on the now empty queue */
-		pending &= ~(1 << prio);
+		/* Clear the pending bit if the queue is now empty */
+		if (!hirq) {
+			pending &= ~(1 << prio);
 
-		/*
-		 * Check if the queue count needs adjusting due to
-		 * interrupts being moved away.
-		 */
-		if (atomic_read(&q->pending_count)) {
-			int p = atomic_xchg(&q->pending_count, 0);
-			if (p) {
+			/*
+			 * Check if the queue count needs adjusting due to
+			 * interrupts being moved away.
+			 */
+			if (atomic_read(&q->pending_count)) {
+				int p = atomic_xchg(&q->pending_count, 0);
+				if (p) {
 #ifdef XIVE_RUNTIME_CHECKS
-				WARN_ON(p > atomic_read(&q->count));
+					WARN_ON(p > atomic_read(&q->count));
 #endif
-				atomic_sub(p, &q->count);
+					atomic_sub(p, &q->count);
+				}
 			}
 		}
+
+		/*
+		 * If the most favoured prio we found pending is less
+		 * favored (or equal) than a pending IPI, we return
+		 * the IPI instead.
+		 */
+		if (prio >= xc->mfrr && xc->mfrr < xc->cppr) {
+			prio = xc->mfrr;
+			hirq = XICS_IPI;
+			break;
+		}
+
+		/* If fetching, update queue pointers */
+		if (scan_type == scan_fetch) {
+			q->idx = idx;
+			q->toggle = toggle;
+		}
 	}
 
 	/* If we are just taking a "peek", do nothing else */
-- 
2.7.4

