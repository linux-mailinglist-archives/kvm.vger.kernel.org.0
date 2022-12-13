Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396EB64AE30
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 04:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiLMDai (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 22:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiLMDag (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 22:30:36 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028B31B7BC
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:36 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id o18-20020a17090aac1200b00219ca917708so1357569pjq.8
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=RxUces6vMG4+c5LveealZEzgVFW4k2gLn9w4VIDwQ6E=;
        b=lq/GEj1d2zHrbru8iZ1qjB/Gm763m2IT0FGRntOmlZZGmAogcCDxjdxsgG8QUkA4gs
         3HmAKxedcc0SmnlM8mMF3b1XEjAJJvxaOoMkV2Rf73uEsd7wrce4ToRMMVotLxikcdaR
         8tz060UpDPZVxXEif4gg8Fr8oHHUzwhTIh9wNHGH3mv4KqwmTj6hVqMGxUosvHTwK5OQ
         p+Sy6U3lcLspFg0JRm7jXJbswBNorqyfcqMfRL/jBamIWn6JrUCyOw0houliRDImP+Cy
         foC16AHRKQ5j66k+3J656QAirqxqhzt1d+Gvjvuhg9DgO6b0TlhOiBsNE+MMy5oNTg7j
         LF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RxUces6vMG4+c5LveealZEzgVFW4k2gLn9w4VIDwQ6E=;
        b=2rX1uuvRYGGhJB9XP1MrITkq1Qz8ZQ/4MyZiSzSvYOox9ayvgH3aIIWAhjegvjp5Od
         GAJwmUZ4YMVkDCHf33JYkAf2RNlj4WR+Mq3e15zLwgIrAzg3+6pOf1ug1chRCIcdxYk5
         fjuu6PoigkbtgLAHgSTMkFgsM0ZQpVy6mZ7pWZhm0XGkIuZsGwLbq6vkAOu3imjjFSCW
         00keLoxymIDIK7tbybDpzFqlvPPyHYpAqIawcjsLRlh1Xr+i3ItuwgnbFCpdK7ei7rEp
         fskZ/Ylcoe7CXMS507LjFGhPkPWfv9A2ZUjEcbz+HjkMWxca6wQ2j2cljoF/oVRpMiBF
         maig==
X-Gm-Message-State: ANoB5pnXPg5jZE7NYoZcWhzaw/QhDeXPUyBAFeTmvrd/e7qLPUnwRuW+
        CmZYZONssKk45kcpww+/V9XeKpjnwAE=
X-Google-Smtp-Source: AA0mqf6qryuK6ZwUrNQzIll161MW/++Vqy4QNAji/aobG0I5SxIY9UBfBn5bggcEKUmcf9DPeqbhZxSZf4k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:2ecb:b0:219:5b3b:2b9f with SMTP id
 h11-20020a17090a2ecb00b002195b3b2b9fmr14549pjs.2.1670902235305; Mon, 12 Dec
 2022 19:30:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 03:30:26 +0000
In-Reply-To: <20221213033030.83345-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213033030.83345-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213033030.83345-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: x86/mmu: Don't attempt to map leaf if target TDP MMU
 SPTE is frozen
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Hoo <robert.hu@linux.intel.com>,
        Greg Thelen <gthelen@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
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

Hoist the is_removed_spte() check above the "level == goal_level" check
when walking SPTEs during a TDP MMU page fault to avoid attempting to map
a leaf entry if said entry is frozen by a different task/vCPU.

  ------------[ cut here ]------------
  WARNING: CPU: 3 PID: 939 at arch/x86/kvm/mmu/tdp_mmu.c:653 kvm_tdp_mmu_map+0x269/0x4b0
  Modules linked in: kvm_intel
  CPU: 3 PID: 939 Comm: nx_huge_pages_t Not tainted 6.1.0-rc4+ #67
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_tdp_mmu_map+0x269/0x4b0
  RSP: 0018:ffffc9000068fba8 EFLAGS: 00010246
  RAX: 00000000000005a0 RBX: ffffc9000068fcc0 RCX: 0000000000000005
  RDX: ffff88810741f000 RSI: ffff888107f04600 RDI: ffffc900006a3000
  RBP: 060000010b000bf3 R08: 0000000000000000 R09: 0000000000000000
  R10: 0000000000000000 R11: 000ffffffffff000 R12: 0000000000000005
  R13: ffff888113670000 R14: ffff888107464958 R15: 0000000000000000
  FS:  00007f01c942c740(0000) GS:ffff888277cc0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000117013006 CR4: 0000000000172ea0
  Call Trace:
   <TASK>
   kvm_tdp_page_fault+0x10c/0x130
   kvm_mmu_page_fault+0x103/0x680
   vmx_handle_exit+0x132/0x5a0 [kvm_intel]
   vcpu_enter_guest+0x60c/0x16f0
   kvm_arch_vcpu_ioctl_run+0x1e2/0x9d0
   kvm_vcpu_ioctl+0x271/0x660
   __x64_sys_ioctl+0x80/0xb0
   do_syscall_64+0x2b/0x50
   entry_SYSCALL_64_after_hwframe+0x46/0xb0
   </TASK>
  ---[ end trace 0000000000000000 ]---

Fixes: 63d28a25e04c ("KVM: x86/mmu: simplify kvm_tdp_mmu_map flow when guest has to retry")
Cc: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 764f7c87286f..b740f38fedcc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1162,9 +1162,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (fault->nx_huge_page_workaround_enabled)
 			disallowed_hugepage_adjust(fault, iter.old_spte, iter.level);
 
-		if (iter.level == fault->goal_level)
-			break;
-
 		/*
 		 * If SPTE has been frozen by another thread, just give up and
 		 * retry, avoiding unnecessary page table allocation and free.
@@ -1172,6 +1169,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (is_removed_spte(iter.old_spte))
 			goto retry;
 
+		if (iter.level == fault->goal_level)
+			break;
+
 		/* Step down into the lower level page table if it exists. */
 		if (is_shadow_present_pte(iter.old_spte) &&
 		    !is_large_pte(iter.old_spte))
-- 
2.39.0.rc1.256.g54fd8350bd-goog

