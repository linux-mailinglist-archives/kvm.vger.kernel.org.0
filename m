Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E9863C7DF
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 20:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiK2TM6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 14:12:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236647AbiK2TMq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 14:12:46 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1476034E
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:12:43 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d2-20020a170902cec200b001899479b1d8so5092409plg.22
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 11:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mEiNt5ftXb0Jkq4g8/ocAWg6a33yQe2tEm6TyHr4HZE=;
        b=lZqioWnFf7DyOm6+UYrYKd/04nt1Aq0D3ZCgGce6on3ZtO4WSRm+HhLYbLnCI+9xlM
         hKFO1tqcxti6PMQ2mLl8VD69s58nYbxxU+Ql1VzAbnxtstmgiZ4yOjmDXHuauvX16A6E
         W4j9VMTVe1lsy8oBZxTGU3/853F2KnviDlm2HnQBwe+gZVu8vly/3kECViq/jUQTPusP
         ssc88dzR4CB7CiWvGR+LlFKfVhx6t1d0HyN108lbRHhcXn55CRpbqLeNdYcV3mC6TFwG
         1y/3IRRe+wTctm06tVpWwT0r7iT73qQZ7wEoDdOyQZOlAUrPV3gyrjcUHAz7wvnwJVu1
         y4dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mEiNt5ftXb0Jkq4g8/ocAWg6a33yQe2tEm6TyHr4HZE=;
        b=bW8cGGn3MaUEv99mG7H0UwbZ9aEC5vhAQrrgpW0uefO3fzZNcTdoHdm28DG9Gf2AOJ
         4id3fNB7ZjECujD1pZeuBen/ICyngLK4ylomATTVLlzksTLNzWwqSLPvqqZOcd/Hm5bT
         ksW1hc0OEJ6PU4lY8YhB8Dal0EkegV6Gs3lKQZlE9BYreOEmieUpgoaINLNo6rYxLzZG
         43fNxQdjK54Jx8ZM2XKhnpcscI2jWE80g4k2t0WTzBYvk/SQa0T2VMHxRRDLIXTp9NGR
         7bGWPyZXHgpeBSFfYOWXhbKazywYSqDvUM3NGNSZVgYuva9IKg07VLGUqnqC2NbiLNs+
         rzwg==
X-Gm-Message-State: ANoB5pndb6lL/8V0GnWl8GuvyJEYjfDe2iI6WOln6HoYEFxeyugvJHjW
        nkN85q5I0et/F2wrGN7xil6iln4nbYcU
X-Google-Smtp-Source: AA0mqf6jtD572zF0Y4wlCF2WJHZC9nAszbQ82UlVNIZTKigSri1YT8FozMjN7o20znUnyiHgn1QVt9xrZxwr
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a62:5242:0:b0:574:73fc:d260 with SMTP id
 g63-20020a625242000000b0057473fcd260mr30475727pfb.6.1669749163324; Tue, 29
 Nov 2022 11:12:43 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Tue, 29 Nov 2022 19:12:37 +0000
In-Reply-To: <20221129191237.31447-1-mizhang@google.com>
Mime-Version: 1.0
References: <20221129191237.31447-1-mizhang@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129191237.31447-3-mizhang@google.com>
Subject: [RFC PATCH v4 2/2] KVM: x86/mmu: replace BUG() with KVM_BUG() in
 shadow mmu
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace BUG() in pte_list_remove() with KVM_BUG() to avoid crashing the
host. MMU bug is difficult to discover due to various racing conditions and
corner cases and thus it extremely hard to debug. The situation gets much
worse when it triggers the shutdown of a host. Host machine crash
eliminates everything including the potential clues for debugging.

BUG() or BUG_ON() is probably no longer appropriate as the host reliability
is top priority in many business scenarios. Crashing the physical machine
is almost never a good option as it eliminates innocent VMs and cause
service outage in a larger scope. Even worse, if attacker can reliably
triggers this code by diverting the control flow or corrupting the memory
or leveraging a KVM bug, then this becomes vm-of-death attack. This is a
huge attack vector to cloud providers, as the death of one single host
machine is not the end of the story. Without manual interferences, a failed
cloud job may be dispatched to other hosts and continue host crashes until
all of them are dead.

Because of the above reasons, shrink the scope of crash to the target VM
only.

Cc: Nagareddy Reddy <nspreddy@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b5a44b8f5f7b..12790ccb8731 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -954,15 +954,16 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 	struct pte_list_desc *prev_desc;
 	int i;
 
-	if (!rmap_head->val) {
-		pr_err("%s: %p 0->BUG\n", __func__, spte);
-		BUG();
-	} else if (!(rmap_head->val & 1)) {
+	if (KVM_BUG(!rmap_head->val, kvm, "rmap for %p is empty", spte))
+		return;
+
+	if (!(rmap_head->val & 1)) {
 		rmap_printk("%p 1->0\n", spte);
-		if ((u64 *)rmap_head->val != spte) {
-			pr_err("%s:  %p 1->BUG\n", __func__, spte);
-			BUG();
-		}
+
+		if (KVM_BUG((u64 *)rmap_head->val != spte, kvm,
+			    "single rmap for %p doesn't match", spte))
+			return;
+
 		rmap_head->val = 0;
 	} else {
 		rmap_printk("%p many->many\n", spte);
@@ -979,8 +980,7 @@ static void pte_list_remove(struct kvm *kvm, u64 *spte,
 			prev_desc = desc;
 			desc = desc->more;
 		}
-		pr_err("%s: %p many->many\n", __func__, spte);
-		BUG();
+		KVM_BUG(true, kvm, "no rmap for %p (many->many)", spte);
 	}
 }
 
-- 
2.38.1.584.g0f3c55d4c2-goog

