Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343D564AE33
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 04:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiLMDao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 22:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234186AbiLMDai (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 22:30:38 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7181B9C0
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:37 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z13-20020aa79f8d000000b00576b614b7d2so1194339pfr.14
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WY93OmoN1ux/tTDsy/tXvpjucXkE3Hq9WCIGoG2/2Ro=;
        b=c84xiWKEpndzuiMaNG1kDZ8jnOBwSJ+AFzzh0cHgXLjDodX/RCj9/pfIC1BM7I69vp
         24oYlPG55M9I7fXzE/cMae1AkD2EfxvVlpjiGU83Rly4H4pNY9RqkumpEzUtpx5i0ZV2
         tWY6E8tjPEc3vvTxX7yJS7sdcVtTJRtA4UWrLl2WnWxonVPIY8oFLEISYCCyFQI3rNRq
         8cl/ZFve0dE3oTqie4ycJF0P/qsiQnNx/IOwfeptTUls2hh10WRroIEUL7Mqj07cenB5
         ovmTWCvC68SMwZUcZ3l2YmNPvdIde0z+sCGHFwEnyrcPhNOCEf9yb8x5xoLCpi71FI5q
         n9Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WY93OmoN1ux/tTDsy/tXvpjucXkE3Hq9WCIGoG2/2Ro=;
        b=hL/DbbEGW752rYAz8n/JPIr9ItYRwizWH89ZPiHXoxnO0eps+xp+Mbqr17XoCheGrB
         odp/BYAV9Bgo7DoP1x2jgN/Ti2zH5JZhvL9xH/75l4j/+u9nrLkyQ7/RQ1xBwMf65Ybm
         RlVQlsTtcAPsY3a75CyHoRkaNiyOhbUESaK6bOS2tNwGklNVkS8Dfm5jFxhfjNzCqzFs
         mR/AwA4jfSa8S2As1vo/uHxUMMSk+loEwCx5kH47jhHc373EefnqjG36a/Q42NbxhN47
         lJe9I3fv/bC0VgdVJZNr/Y3V03q/lNamqjPatAclZbeqeJEv1CNlve83H/1931c7TuWg
         CYyQ==
X-Gm-Message-State: ANoB5pk2H/ixHUL4fcUCWpKMSGlQshRl5MBVpWNikZyX/kvD042l21L+
        Eds3g9ibJURlBKkFal0eyDmT77WlsWo=
X-Google-Smtp-Source: AA0mqf4NbGT81kWDESNvAhfrPrSzTGHBidto4HN9ho/rsmU8aS4x/inM5F67X43g8KpvLrvXXQLrWBuo6AQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1647:b0:576:c5e1:9b13 with SMTP id
 m7-20020a056a00164700b00576c5e19b13mr22847830pfc.67.1670902237147; Mon, 12
 Dec 2022 19:30:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 03:30:27 +0000
In-Reply-To: <20221213033030.83345-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213033030.83345-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213033030.83345-3-seanjc@google.com>
Subject: [PATCH 2/5] KVM: x86/mmu: Map TDP MMU leaf SPTE iff target level is reached
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

Map the leaf SPTE when handling a TDP MMU page fault if and only if the
target level is reached.  A recent commit reworked the retry logic and
incorrectly assumed that walking SPTEs would never "fail", as the loop
either bails (retries) or installs parent SPs.  However, the iterator
itself will bail early if it detects a frozen (REMOVED) SPTE when
stepping down.   The TDP iterator also rereads the current SPTE before
stepping down specifically to avoid walking into a part of the tree that
is being removed, which means it's possible to terminate the loop without
the guts of the loop observing the frozen SPTE, e.g. if a different task
zaps a parent SPTE between the initial read and try_step_down()'s refresh.

Mapping a leaf SPTE at the wrong level results in all kinds of badness as
page table walkers interpret the SPTE as a page table, not a leaf, and
walk into the weeds.

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 1025 at arch/x86/kvm/mmu/tdp_mmu.c:1070 kvm_tdp_mmu_map+0x481/0x510
  Modules linked in: kvm_intel
  CPU: 1 PID: 1025 Comm: nx_huge_pages_t Tainted: G        W          6.1.0-rc4+ #64
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:kvm_tdp_mmu_map+0x481/0x510
  RSP: 0018:ffffc9000072fba8 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffffc9000072fcc0 RCX: 0000000000000027
  RDX: 0000000000000027 RSI: 00000000ffffdfff RDI: ffff888277c5b4c8
  RBP: ffff888107d45a10 R08: ffff888277c5b4c0 R09: ffffc9000072fa48
  R10: 0000000000000001 R11: 0000000000000001 R12: ffffc9000073a0e0
  R13: ffff88810fc54800 R14: ffff888107d1ae60 R15: ffff88810fc54f90
  FS:  00007fba9f853740(0000) GS:ffff888277c40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000010aa7a003 CR4: 0000000000172ea0
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
  Invalid SPTE change: cannot replace a present leaf
  SPTE with another present leaf SPTE mapping a
  different PFN!
  as_id: 0 gfn: 100200 old_spte: 600000112400bf3 new_spte: 6000001126009f3 level: 2
  ------------[ cut here ]------------
  kernel BUG at arch/x86/kvm/mmu/tdp_mmu.c:559!
  invalid opcode: 0000 [#1] SMP
  CPU: 1 PID: 1025 Comm: nx_huge_pages_t Tainted: G        W          6.1.0-rc4+ #64
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__handle_changed_spte.cold+0x95/0x9c
  RSP: 0018:ffffc9000072faf8 EFLAGS: 00010246
  RAX: 00000000000000c1 RBX: ffffc90000731000 RCX: 0000000000000027
  RDX: 0000000000000000 RSI: 00000000ffffdfff RDI: ffff888277c5b4c8
  RBP: 0600000112400bf3 R08: ffff888277c5b4c0 R09: ffffc9000072f9a0
  R10: 0000000000000001 R11: 0000000000000001 R12: 06000001126009f3
  R13: 0000000000000002 R14: 0000000012600901 R15: 0000000012400b01
  FS:  00007fba9f853740(0000) GS:ffff888277c40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 000000010aa7a003 CR4: 0000000000172ea0
  Call Trace:
   <TASK>
   kvm_tdp_mmu_map+0x3b0/0x510
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
  Modules linked in: kvm_intel
  ---[ end trace 0000000000000000 ]---

Fixes: 63d28a25e04c ("KVM: x86/mmu: simplify kvm_tdp_mmu_map flow when guest has to retry")
Cc: Robert Hoo <robert.hu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index b740f38fedcc..e2e197d41780 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1170,7 +1170,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			goto retry;
 
 		if (iter.level == fault->goal_level)
-			break;
+			goto map_target_level;
 
 		/* Step down into the lower level page table if it exists. */
 		if (is_shadow_present_pte(iter.old_spte) &&
@@ -1192,8 +1192,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
-		 * Also force the guest to retry the access if the upper level SPTEs
-		 * aren't in place.
+		 * Force the guest to retry if installing an upper level SPTE
+		 * failed, e.g. because a different task modified the SPTE.
 		 */
 		if (r) {
 			tdp_mmu_free_sp(sp);
@@ -1208,6 +1208,14 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		}
 	}
 
+	/*
+	 * The walk aborted before reaching the target level, e.g. because the
+	 * iterator detected an upper level SPTE was frozen during traversal.
+	 */
+	WARN_ON_ONCE(iter.level == fault->goal_level);
+	goto retry;
+
+map_target_level:
 	ret = tdp_mmu_map_handle_target_level(vcpu, fault, &iter);
 
 retry:
-- 
2.39.0.rc1.256.g54fd8350bd-goog

