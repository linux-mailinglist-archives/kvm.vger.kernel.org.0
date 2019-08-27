Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361CD9DB11
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 03:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfH0Bfp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Aug 2019 21:35:45 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:37169 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfH0Bfp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Aug 2019 21:35:45 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 46HWfQ70K5z9sBF; Tue, 27 Aug 2019 11:35:42 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1566869742; bh=9E9V0XgWnpOd14JVRGHFpTnEq0jq/mMU+nBl6t5zops=;
        h=Date:From:To:Cc:Subject:From;
        b=jy39pw7gkEi0bqbY6XV+ca45NcPu8pBdAS0qqKmFxEeAU7plvOSWeLa/zISu5VJnw
         hGJt7sWhLl4JPJzN3k0sQ9e9aja7tLOWsfmgieOUlj+YZNWe+tu2/aXHonwyd8Mkcl
         ifDmw8tuFvV0Z/M2OAqt/LWLjaCAbP0csddV6z6AVPA3Dt5iQ9+Po5X/02yk+KAXF6
         6DlF/Ibw5SMeGPL5k6Hh++606GDAhVy43nkdEnjyVdNa6p2gh/I/kp2+Fu4pRyTnfz
         6TFmBGqpCg0B9iZOEve2KZtP3jrqKyFebvJ4GdHQta1cNyM49hYtw8a0vJgLJknssN
         t/esBTEcY+upA==
Date:   Tue, 27 Aug 2019 11:31:37 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] KVM: PPC: Book3S HV: Check for MMU ready on piggybacked
 virtual cores
Message-ID: <20190827013137.GB16075@blackberry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When we are running multiple vcores on the same physical core, they
could be from different VMs and so it is possible that one of the
VMs could have its arch.mmu_ready flag cleared (for example by a
concurrent HPT resize) when we go to run it on a physical core.
We currently check the arch.mmu_ready flag for the primary vcore
but not the flags for the other vcores that will be run alongside
it.  This adds that check, and also a check when we select the
secondary vcores from the preempted vcores list.

Cc: stable@vger.kernel.org # v4.14+
Fixes: 38c53af85306 ("KVM: PPC: Book3S HV: Fix exclusion between HPT resizing and other HPT updates")
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
---
 arch/powerpc/kvm/book3s_hv.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index eaed043..ca6c6ec 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -2861,7 +2861,7 @@ static void collect_piggybacks(struct core_info *cip, int target_threads)
 		if (!spin_trylock(&pvc->lock))
 			continue;
 		prepare_threads(pvc);
-		if (!pvc->n_runnable) {
+		if (!pvc->n_runnable || !pvc->kvm->arch.mmu_ready) {
 			list_del_init(&pvc->preempt_list);
 			if (pvc->runner == NULL) {
 				pvc->vcore_state = VCORE_INACTIVE;
@@ -2882,15 +2882,20 @@ static void collect_piggybacks(struct core_info *cip, int target_threads)
 	spin_unlock(&lp->lock);
 }
 
-static bool recheck_signals(struct core_info *cip)
+static bool recheck_signals_and_mmu(struct core_info *cip)
 {
 	int sub, i;
 	struct kvm_vcpu *vcpu;
+	struct kvmppc_vcore *vc;
 
-	for (sub = 0; sub < cip->n_subcores; ++sub)
-		for_each_runnable_thread(i, vcpu, cip->vc[sub])
+	for (sub = 0; sub < cip->n_subcores; ++sub) {
+		vc = cip->vc[sub];
+		if (!vc->kvm->arch.mmu_ready)
+			return true;
+		for_each_runnable_thread(i, vcpu, vc)
 			if (signal_pending(vcpu->arch.run_task))
 				return true;
+	}
 	return false;
 }
 
@@ -3120,7 +3125,7 @@ static noinline void kvmppc_run_core(struct kvmppc_vcore *vc)
 	local_irq_disable();
 	hard_irq_disable();
 	if (lazy_irq_pending() || need_resched() ||
-	    recheck_signals(&core_info) || !vc->kvm->arch.mmu_ready) {
+	    recheck_signals_and_mmu(&core_info)) {
 		local_irq_enable();
 		vc->vcore_state = VCORE_INACTIVE;
 		/* Unlock all except the primary vcore */
-- 
2.7.4

