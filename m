Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04EDD66627D
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 19:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbjAKSHC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 13:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjAKSG7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 13:06:59 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE59718B3F
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 10:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=l7BrqUCQb2EbrTTkRXkEhnBux6/v/whpCzUw9p5ijwk=; b=qza/6FpTnj5l6d16tGNcGYojFq
        KgVZGjbYIJIESn1jpflPQEpu6ZSmCs8XEhf7vY2RxUUGZGPmiYcy/pjfH9BR8uabfVvuhFU+EO+hr
        hJUUZ6G8do4EHheZK/ecgS0TEyt7r2acyAUfk5H0zld/jrlpNDMhIIJ8JY0eZwOJvq2dg9N0GmQUi
        yFUNK82u4c2Yu+Da0kb5ESBJinFyMUKJm2rSVn6DASqR2YXaEjRLI0B7AAzYmyF/nBjyWjKJsnNV2
        M09x3OqQvsgxxpVd3CrArHoXIB0tMeKtB364FnYn3OFr0tS1mmV0nmpMjGaemwLKqmyvftolB/4/C
        WEi7+tJA==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFfVA-004MOt-Uj; Wed, 11 Jan 2023 18:07:05 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pFfUx-0003kO-2U; Wed, 11 Jan 2023 18:06:51 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, paul <paul@xen.org>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH v2 1/4] KVM: x86/xen: Fix lockdep warning on "recursive" gpc locking
Date:   Wed, 11 Jan 2023 18:06:48 +0000
Message-Id: <20230111180651.14394-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

In commit 5ec3289b31 ("KVM: x86/xen: Compatibility fixes for shared runstate
area") we declared it safe to obtain two gfn_to_pfn_cache locks at the same
time:
	/*
	 * The guest's runstate_info is split across two pages and we
	 * need to hold and validate both GPCs simultaneously. We can
	 * declare a lock ordering GPC1 > GPC2 because nothing else
	 * takes them more than one at a time.
	 */

However, we forgot to tell lockdep. Do so, by setting a subclass on the
first lock before taking the second.

Fixes: 5ec3289b31 ("KVM: x86/xen: Compatibility fixes for shared runstate area")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/xen.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 402d9a34552c..07e61cc9881e 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -305,8 +305,10 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		 * The guest's runstate_info is split across two pages and we
 		 * need to hold and validate both GPCs simultaneously. We can
 		 * declare a lock ordering GPC1 > GPC2 because nothing else
-		 * takes them more than one at a time.
+		 * takes them more than one at a time. Set a subclass on the
+		 * gpc1 lock to make lockdep shut up about it.
 		 */
+		lock_set_subclass(&gpc1->lock.dep_map, 1, _THIS_IP_);
 		read_lock(&gpc2->lock);
 
 		if (!kvm_gpc_check(gpc2, user_len2)) {
-- 
2.35.3

