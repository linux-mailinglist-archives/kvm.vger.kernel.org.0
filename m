Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD1E66627E
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235167AbjAKSHK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234693AbjAKSG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:06:59 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B5918B0C
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=UYZN/5AAc8n/szdyLoZlW4CmEiWmNAf7HswnZjNKrkA=; b=pGjRduaejrSbHKBiuf2MuOk6Q+
        1uh/p5Ttw1brBjduFLCj1yxpNqlnnHDHRoFw9QPsv53znE4UtPWKz4lQheYSbqMd654sDaY9OYz/e
        uF5r6O8+6nKXbsPYDorL+1l1jqXks2pOIXLHlHSpbKsnEpQWr9jMj9w+YeLgr81mVymWxMUBGPQrU
        fG3UCf7OXOH1+vpbKYEuNcdkbUn+gTOE5JjG46z4qZuLyTnZk6Ia1CsQ1U/nDi5X8YhZIvv56OatJ
        zhYJYx9QMjlcZBfW5b1YH87RwZXQq8K0t7hxQ6wIe5pxq28MRwolnz5YSsA4S5iRD57JUZ1UJVdiO
        +jU9cqcg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pFfUp-003lMD-1q;
        Wed, 11 Jan 2023 18:06:43 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFfUx-0003kR-4I; Wed, 11 Jan 2023 18:06:51 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, paul <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 2/4] KVM: x86/xen: Fix potential deadlock in kvm_xen_update_runstate_guest()
Date:   Wed, 11 Jan 2023 18:06:49 +0000
Message-Id: <20230111180651.14394-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230111180651.14394-1-dwmw2@infradead.org>
References: <20230111180651.14394-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The kvm_xen_update_runstate_guest() function can be called when the vCPU
is being scheduled out, from a preempt notifier. It *opportunistically*
updates the runstate area in the guest memory, if the gfn_to_pfn_cache
which caches the appropriate address is still valid.

If there is *contention* when it attempts to obtain gpc->lock, then
locking inside the priority inheritance checks may cause a deadlock.
Lockdep reports:

[13890.148997] Chain exists of:
                 &gpc->lock --> &p->pi_lock --> &rq->__lock

[13890.149002]  Possible unsafe locking scenario:

[13890.149003]        CPU0                    CPU1
[13890.149004]        ----                    ----
[13890.149005]   lock(&rq->__lock);
[13890.149007]                                lock(&p->pi_lock);
[13890.149009]                                lock(&rq->__lock);
[13890.149011]   lock(&gpc->lock);
[13890.149013]
                *** DEADLOCK ***

In the general case, if there's contention for a read lock on gpc->lock,
that's going to be because something else is either invalidating or
revalidating the cache. Either way, we've raced with seeing it in an
invalid state, in which case we would have aborted the opportunistic
update anyway.

So in the 'atomic' case when called from the preempt notifier, just
switch to using read_trylock() and avoid the PI handling altogether.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 07e61cc9881e..809b82bdb9c3 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -272,7 +272,15 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	 * Attempt to obtain the GPC lock on *both* (if there are two)
 	 * gfn_to_pfn caches that cover the region.
 	 */
-	read_lock_irqsave(&gpc1->lock, flags);
+	if (atomic) {
+		local_irq_save(flags);
+		if (!read_trylock(&gpc1->lock)) {
+			local_irq_restore(flags);
+			return;
+		}
+	} else {
+		read_lock_irqsave(&gpc1->lock, flags);
+	}
 	while (!kvm_gpc_check(gpc1, user_len1)) {
 		read_unlock_irqrestore(&gpc1->lock, flags);
 
@@ -309,7 +317,14 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		 * gpc1 lock to make lockdep shut up about it.
 		 */
 		lock_set_subclass(&gpc1->lock.dep_map, 1, _THIS_IP_);
-		read_lock(&gpc2->lock);
+		if (atomic) {
+			if (!read_trylock(&gpc2->lock)) {
+				read_unlock_irqrestore(&gpc1->lock, flags);
+				return;
+			}
+		} else {
+			read_lock(&gpc2->lock);
+		}
 
 		if (!kvm_gpc_check(gpc2, user_len2)) {
 			read_unlock(&gpc2->lock);
-- 
2.35.3

