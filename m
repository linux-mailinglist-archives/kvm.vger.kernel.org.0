Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEA02DC1AB
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 14:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgLPNz0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 08:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbgLPNz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 08:55:26 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2716BC061794;
        Wed, 16 Dec 2020 05:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VcjIrN5FyTZolDv+Rn4aJudbB/mo6LJSIs57tLjGV9E=; b=rSJh99DceSgMq5jxGxn6SzKncN
        PF80gFlqTd2qHds0K4vMiVwur9ao4Gs3fQ4ryLjfz5d6MsjtduZL8ylq7LhxfdC+r3FSvD9p45tsI
        yKuBCxGc8hN/IF7V3WVmU6A79qB1sPXiJh4LAFpaLIKkhR6BLDo4IXfmKOM90CriOPwuZmGzyghD5
        4ARJeUI+ZvsEQo3pM7vqy/5+RFqUv7Dz7hy2hJU/3j9Ab2C3REcXpjoWISfNY+73uhGgPWmeqpXdn
        0EDSRNx6QPAJOFDdC+4icm5vOezUUvMiekOErU1tQhTUOcLU1tFNNZaiSvabdk4U2Y4lpFEimIyf7
        Fb1nAipA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpXGJ-0004vH-Oz; Wed, 16 Dec 2020 13:54:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id DD348304D28;
        Wed, 16 Dec 2020 14:54:35 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C7551203EE86D; Wed, 16 Dec 2020 14:54:35 +0100 (CET)
Date:   Wed, 16 Dec 2020 14:54:35 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        ardb@kernel.org
Subject: [PATCH] jump_label: Fix usage in module __init
Message-ID: <20201216135435.GV3092@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216105926.GS3092@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216105926.GS3092@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Final patch looks like this.

---
Subject: jump_label: Fix usage in module __init
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Dec 16 12:21:36 CET 2020

When the static_key is part of the module, and the module calls
static_key_inc/enable() from it's __init section *AND* has a
static_branch_*() user in that very same __init section, things go
wobbly.

If the static_key lives outside the module, jump_label_add_module()
would append this module's sites to the key and jump_label_update()
would take the static_key_linked() branch and all would be fine.

If all the sites are outside of __init, then everything will be fine
too.

However, when all is aligned just as described above,
jump_label_update() calls __jump_label_update(.init = false) and we'll
not update sites in __init text.

Fixes: 19483677684b ("jump_label: Annotate entries that operate on __init code earlier")
Reported-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Jessica Yu <jeyu@kernel.org>
---
 kernel/jump_label.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -793,6 +793,7 @@ int jump_label_text_reserved(void *start
 static void jump_label_update(struct static_key *key)
 {
 	struct jump_entry *stop = __stop___jump_table;
+	bool init = system_state < SYSTEM_RUNNING;
 	struct jump_entry *entry;
 #ifdef CONFIG_MODULES
 	struct module *mod;
@@ -804,15 +805,16 @@ static void jump_label_update(struct sta
 
 	preempt_disable();
 	mod = __module_address((unsigned long)key);
-	if (mod)
+	if (mod) {
 		stop = mod->jump_entries + mod->num_jump_entries;
+		init = mod->state == MODULE_STATE_COMING;
+	}
 	preempt_enable();
 #endif
 	entry = static_key_entries(key);
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, stop,
-				    system_state < SYSTEM_RUNNING);
+		__jump_label_update(key, entry, stop, init);
 }
 
 #ifdef CONFIG_STATIC_KEYS_SELFTEST
