Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62C1E636F00
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 01:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiKXAfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 19:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKXAfJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 19:35:09 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB82D2290
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:35:08 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pi2-20020a17090b1e4200b0021834843687so2259719pjb.0
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aa92OzuNoBifDWEmUJ37YxXFRFKD6dSrfroenfrQMAw=;
        b=DtYlPkqcxBjB6stQugyXB3d+OA2pKjoq0X1ZBMK0DAnExd+ecz4AZENDjfSLIuHhwN
         vewM1COLZUoBL2Cdhbp+NT2QTniXTL8lSoLAjnto69yNAL0umhhfmpvHU1WpsRJmB8HI
         ywGsAFFeWlcb7EvN0owqEGzKKYVHzIl6gt59Ll9nTAjujcn+kyZsHbRu0KfKTg+d9qi4
         SeoguUN49skz5h1OXzZLWHGzgjPG5glRzmf8pG8BOc721nCZ+1yd1w6ZAatkuOxBgdec
         6BUklqSesouBeOMM1nd4JcWtQKfNEQaMY7Vf53rDwgDn3LwE3hZ82bOqXb63sHG95/rq
         f4Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aa92OzuNoBifDWEmUJ37YxXFRFKD6dSrfroenfrQMAw=;
        b=WvUIkiwKs+oXtCEcfDlFbbfMEwSdR++zttF6725xPFt+jLkC65dhcHyrRcjmau15pE
         zMTOToqkUmIBpLzUgfx55gWY4NNeW/qx9vU8KG68VsploW7Jv0syZ3Z87M9l5hWHbXKD
         UF+zyFa+3HV8nXupz51kKpc+VG2Ayy6ssQHluin2MPqVAAZ7LdP0Qq4D6efSaINL6PaE
         vpHjkx5+oCwvv9bIohWHxTzI7iU5SvHY2wrdeOEc7qV1id49KCaYBtD2sDu9aEy67wxF
         0VeJG2xiLKz75aFE78EQFp+fOzAtdAam6NE6Fnh8Rh+bZi/6FLdD28iXOU/U9rY+SEF0
         Gj1g==
X-Gm-Message-State: ANoB5pn798sqoEBWWY69bDwO3FA90MrzmbfmueA2Pzmt/MOrZp60RIm8
        PzJJlvc90HNKaRRBkC1RmVEm15E2FU88
X-Google-Smtp-Source: AA0mqf5bJx9VFHyerkx+DoKsNpJVyPLUTNwqVVgK15nWTonGlB8AHUTBjViG6oG9g5qOomcfW1LruAfk31yb
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:aa7:8115:0:b0:571:f667:4d85 with SMTP id
 b21-20020aa78115000000b00571f6674d85mr15468130pfi.70.1669250108075; Wed, 23
 Nov 2022 16:35:08 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Thu, 24 Nov 2022 00:35:05 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221124003505.424617-1-mizhang@google.com>
Subject: [RFC PATCH v2] KVM: x86/mmu: replace BUG() with KVM_BUG() in shadow mmu
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nagareddy Reddy <nspreddy@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
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

From cloud computing service perspective, BUG() or BUG_ON() is probably no
longer appropriate as the host reliability is top priority. Crashing the
physical machine is almost never a good option as it eliminates innocent
VMs and cause service outage in a larger scope. Even worse, if attacker can
reliably triggers this code by diverting the control flow or corrupting the
memory, then this becomes vm-of-death attack. This is a huge attack vector
to cloud providers, as the death of one single host machine is not the end
of the story. Without manual interferences, a failed cloud job may be
dispatched to other hosts and continue host crashes until all of them are
dead.

Because of the above reasons, shrink the scope of crash to the target VM
only. KVM_BUG() and KVM_BUG_ON() requires a valid struct kvm which requires
extra plumbing. Avoid it in this version by just using
kvm_get_running_vcpu()->kvm instead.

Compile tested only.

v1 -> v2:
 - compile test the code.
 - fill KVM_BUG() with kvm_get_running_vcpu()->kvm

v1:
https://lore.kernel.org/all/20221123231206.274392-1-mizhang@google.com/

Cc: Nagareddy Reddy <nspreddy@google.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: David Matlack <dmatlack@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4736d7849c60..f3b307c588ac 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -955,12 +955,12 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 
 	if (!rmap_head->val) {
 		pr_err("%s: %p 0->BUG\n", __func__, spte);
-		BUG();
+		KVM_BUG(true, kvm_get_running_vcpu()->kvm, "");
 	} else if (!(rmap_head->val & 1)) {
 		rmap_printk("%p 1->0\n", spte);
 		if ((u64 *)rmap_head->val != spte) {
 			pr_err("%s:  %p 1->BUG\n", __func__, spte);
-			BUG();
+			KVM_BUG(true, kvm_get_running_vcpu()->kvm, "");
 		}
 		rmap_head->val = 0;
 	} else {
@@ -979,7 +979,7 @@ static void pte_list_remove(u64 *spte, struct kvm_rmap_head *rmap_head)
 			desc = desc->more;
 		}
 		pr_err("%s: %p many->many\n", __func__, spte);
-		BUG();
+		KVM_BUG(true, kvm_get_running_vcpu()->kvm, "");
 	}
 }
 
-- 
2.38.1.584.g0f3c55d4c2-goog

