Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5356697E6
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241433AbjAMNBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:01:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241310AbjAMNA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:00:27 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D8B87F2A;
        Fri, 13 Jan 2023 04:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1DUb3B7waW5odEw04POoGMWila232+t7SZb2vjo28Us=; b=J9D0BI8dDExb7i3ZX/1BsCrR29
        veSqoJ+6VcD7dyaYv3NABXoY/CxEv6JnNcLBLtzQdnPwqzzco20zJM/3/Qy0ZEYd5f68ImSQAYbX4
        RgfLGUsbIRywulWBLTra7BDQWewHjL7+g6gAztAn+QopRPyw51nY5odgYV/JtsJ9vxnfr5H9po/NN
        mKN7yYQ10bSCrdQxkPOxTPFjacYPAKDA19GIBhouNVyY4H5ByXfp2uIvK7T51ZA+DButc3iraobBG
        x+UYkj2TXU9zNpFMvxjL+DAUionlpCsyfvIQWJWfAbcOeEi67pNvOadXYiwPs/OvqFEFMKHJJrDfr
        ye4nFsXQ==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGJRy-0065y3-Tb; Fri, 13 Jan 2023 12:46:27 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGJRl-0002jj-Fy; Fri, 13 Jan 2023 12:46:13 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 1/3] KVM: Show lockdep the kvm->mutex vs. kvm->srcu ordering rule
Date:   Fri, 13 Jan 2023 12:46:04 +0000
Message-Id: <20230113124606.10221-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230113124606.10221-1-dwmw2@infradead.org>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113124606.10221-1-dwmw2@infradead.org>
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

Lockdep is learning to spot deadlocks with sleepable RCU vs. mutexes,
which can occur where one code path calls synchronize_scru() with a
mutex held, while another code path attempts to obtain the same mutex
while in a read-side section.

Since lockdep isn't very good at reading the English prose in
Documentation/virt/kvm/locking.rst, give it a demonstration by calling
synchronize_scru(&kvm->srcu) while holding kvm->lock in kvm_create_vm().
The cases where this happens naturally are relatively esoteric and may
not happen otherwise.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 virt/kvm/kvm_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 13e88297f999..285b3c5a6364 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1173,6 +1173,16 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
 	if (init_srcu_struct(&kvm->irq_srcu))
 		goto out_err_no_irq_srcu;
 
+#ifdef CONFIG_LOCKDEP
+	/*
+	 * Ensure lockdep knows that it's not permitted to lock kvm->lock
+	 * from a SRCU read section on kvm->srcu.
+	 */
+	mutex_lock(&kvm->lock);
+	synchronize_srcu(&kvm->srcu);
+	mutex_unlock(&kvm->lock);
+#endif
+
 	refcount_set(&kvm->users_count, 1);
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		for (j = 0; j < 2; j++) {
-- 
2.35.3

