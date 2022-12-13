Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8188D64AE2E
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 04:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiLMDan (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 22:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiLMDak (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 22:30:40 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4840A1B9E4
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:39 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id l10-20020a170902f68a00b00189d1728848so11977817plg.2
        for <kvm@vger.kernel.org>; Mon, 12 Dec 2022 19:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bLDSe44cZJY4RzP8rOml9E7i99VNmaADCbamzPObvzE=;
        b=mStYLDUilolo88aKNZelPa7R3nhuaL6QqfjDhv4UqW2a7w8/JewZlZWuBbsotirhp8
         gXJYjLrgktEjDDnVsfQCKA47IPpeF4J3geWrPF3yYu5TNgBKOnM2VWJGzxwMX68i/7L9
         t6xkATqedo9eqh40NrBVM7IHNi5Y8qpauTrufSI2OWK9XX7RPzwShQS/WC011ZFug9m5
         yk9liybJzj54qGiFEKmxVN5BB39J1WyDMmdHR+EUIiwhhLFU/zKVSz1MNixU4DI3iawL
         QmH9ro9g1VH7ViLX/eot/wXJAXJOADgvi5aNmQxud844kXBYojZNOlbUHpSdJbhQaECz
         495g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bLDSe44cZJY4RzP8rOml9E7i99VNmaADCbamzPObvzE=;
        b=tfpFnukqe3w38Uob29bpUBKDcB1YDAqLrmbksFM+3UH1oarYjMt3nsLfTYFZzbC0Qu
         PdPtGjP9OLqWbu7wRedsmxh9OFeCNqe0scKotvnT8clxY3FtNIdpPD53A/0JnFqcKdXK
         971/3GS5KRgwSfKXyFVhBLfMVZtTfI+Wvz22HP35YtujSdYAkk++DfllXYSJOdVC8KjS
         iOcpHtauoJFedHIdEJjYFx4Rz4nh19EqdmNj+Z8lrtbOxiUT/oGT9H6MEbDj4ub49jAE
         P0T+/DRK0GVJ1kgAY7q3torQacNLTDjMCyvmH7sZOOPp53DGm1SaeMRlu1ts9MssPQdx
         LJ+A==
X-Gm-Message-State: ANoB5pmhcPoCHBFHv5GKr1LuOR6OESArDpDmgCiQzBaJEoKz0PAZdaOk
        StKVhxteRgXTsgal3jWPEhpThPqhFHY=
X-Google-Smtp-Source: AA0mqf4+EgJDZIMfJxsGsWWfMENf5h3p9fSIQBhaeBMNTu/kkd+9qBQsQ6QfVCLjH0lsmXnkeMHO4utCSnw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ea02:b0:189:7441:1ad7 with SMTP id
 s2-20020a170902ea0200b0018974411ad7mr59350990plg.1.1670902238808; Mon, 12 Dec
 2022 19:30:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Dec 2022 03:30:28 +0000
In-Reply-To: <20221213033030.83345-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221213033030.83345-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213033030.83345-4-seanjc@google.com>
Subject: [PATCH 3/5] KVM: x86/mmu: Re-check under lock that TDP MMU SP
 hugepage is disallowed
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

Re-check sp->nx_huge_page_disallowed under the tdp_mmu_pages_lock spinlock
when adding a new shadow page in the TDP MMU.  To ensure the NX reclaim
kthread can't see a not-yet-linked shadow page, the page fault path links
the new page table prior to adding the page to possible_nx_huge_pages.

If the page is zapped by different task, e.g. because dirty logging is
disabled, between linking the page and adding it to the list, KVM can end
up triggering use-after-free by adding the zapped SP to the aforementioned
list, as the zapped SP's memory is scheduled for removal via RCU callback.
The bug is detected by the sanity checks guarded by CONFIG_DEBUG_LIST=y,
i.e. the below splat is just one possible signature.

  ------------[ cut here ]------------
  list_add corruption. prev->next should be next (ffffc9000071fa70), but was ffff88811125ee38. (prev=ffff88811125ee38).
  WARNING: CPU: 1 PID: 953 at lib/list_debug.c:30 __list_add_valid+0x79/0xa0
  Modules linked in: kvm_intel
  CPU: 1 PID: 953 Comm: nx_huge_pages_t Tainted: G        W          6.1.0-rc4+ #71
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:__list_add_valid+0x79/0xa0
  RSP: 0018:ffffc900006efb68 EFLAGS: 00010286
  RAX: 0000000000000000 RBX: ffff888116cae8a0 RCX: 0000000000000027
  RDX: 0000000000000027 RSI: 0000000100001872 RDI: ffff888277c5b4c8
  RBP: ffffc90000717000 R08: ffff888277c5b4c0 R09: ffffc900006efa08
  R10: 0000000000199998 R11: 0000000000199a20 R12: ffff888116cae930
  R13: ffff88811125ee38 R14: ffffc9000071fa70 R15: ffff88810b794f90
  FS:  00007fc0415d2740(0000) GS:ffff888277c40000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 0000000000000000 CR3: 0000000115201006 CR4: 0000000000172ea0
  Call Trace:
   <TASK>
   track_possible_nx_huge_page+0x53/0x80
   kvm_tdp_mmu_map+0x242/0x2c0
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

Fixes: 61f94478547b ("KVM: x86/mmu: Set disallowed_nx_huge_page in TDP MMU before setting SPTE")
Reported-by: Greg Thelen <gthelen@google.com>
Analyzed-by: David Matlack <dmatlack@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e2e197d41780..fd4ae99790d7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1203,7 +1203,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		if (fault->huge_page_disallowed &&
 		    fault->req_level >= iter.level) {
 			spin_lock(&kvm->arch.tdp_mmu_pages_lock);
-			track_possible_nx_huge_page(kvm, sp);
+			if (sp->nx_huge_page_disallowed)
+				track_possible_nx_huge_page(kvm, sp);
 			spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 		}
 	}
-- 
2.39.0.rc1.256.g54fd8350bd-goog

