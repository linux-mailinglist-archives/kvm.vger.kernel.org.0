Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A57447E97A
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350488AbhLWW0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350465AbhLWWZs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:25:48 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B69C061D60
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:22 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id u4-20020a63ef04000000b0033ab2693122so3899002pgh.3
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=i4nDji1SAHJbfO4zc501SdWktURErA1mUSQbrDpHUlE=;
        b=Vxi1bRmXVR+CNUOdcODHvIqCIBGCK2G+5hIJ9+PzOmq1mK96Z4q4egX1RRZyJHLHbt
         jF8dMrqHbGaeuyWGDCWXRo2rENE0tvf6LPsdMhVpFX8tYhzsxymxaWwuvGyWft1jEQpr
         G/Fujwj3v+cC/YmylaG5Xiz2drcALyabHBoFJjp8l8DKtQTPCkRVaOCq9vQA7XzkIOI+
         nSTS2VjQDNZKzXdA7m/bknnYeAP3GAq0l0aEExO1A1hhfAzrba5riS5ygrhwsJVZY8rT
         MK2xHJAKGNT/30Pz3m1J64UKRo56T+w7hNdDiVWptVRWGEcag1pwRBtQLY+v5PlP2e+Q
         oSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=i4nDji1SAHJbfO4zc501SdWktURErA1mUSQbrDpHUlE=;
        b=jiIKvcEt/ekRhDxuh14gCZyx/TkdzrCzGLFi05e5QOc9R0gByE2cv7vLz3/tqC0U8S
         U8iByxTjwc7vr99Q8900FHgAhxUMHhkkfFq3i7tmeoUBfEsCGkrNF7sWiSNKZ3oBE2Uy
         gpIi3v9ytN4ecEHKkwssROGNJmWhDGJp3jFU5kbsPetipG4uB9mdxaIXLhrqLHADwl0O
         ZfwAVMDN/PW6UTgD/yEjyaY5WMGIB91EOnF0y5rLcuTISiULzGywShFsTIyTeY5wB7wA
         K0wahHAp7uwPQSsnfGDaZxQZnoNYZD6Fps+7W8oPUmgmwtgSTt+v8JT4nxK1MId3JGvR
         7E8g==
X-Gm-Message-State: AOAM53152RDVOVGTMJE85ZEfMTf4GVu75PqikSgTupxO37TZxoUxHen6
        kmOFgaMYDNA/j4kmFe8+nUZmNn15S2Q=
X-Google-Smtp-Source: ABdhPJwdARqSCG1hVN6DRUH0JKvPblGfx8biIe15EHWBYkiuHI2pwAJaGdlVBYMwzWDgbhK/EfoR/O/E8HE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:809:b0:4ba:da08:496f with SMTP id
 m9-20020a056a00080900b004bada08496fmr4359945pfk.60.1640298262474; Thu, 23 Dec
 2021 14:24:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:13 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-26-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 25/30] KVM: x86/mmu: Zap roots in two passes to avoid
 inducing RCU stalls
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When zapping a TDP MMU root, perform the zap in two passes to avoid
zapping an entire top-level SPTE while holding RCU, which can induce RCU
stalls.  In the first pass, zap SPTEs at PG_LEVEL_1G, and then
zap top-level entries in the second pass.

With 4-level paging, zapping a PGD that is fully populated with 4kb leaf
SPTEs take up to ~7 or so seconds (time varies based number of kernel
config, CPUs, vCPUs, etc...).  With 5-level paging, that time can balloon
well into hundreds of seconds.

Before remote TLB flushes were omitted, the problem was even worse as
waiting for all active vCPUs to respond to the IPI introduced significant
overhead for VMs with large numbers of vCPUs.

By zapping 1gb SPTEs (both shadow pages and hugepages) in the first pass,
the amount of work that is done without dropping RCU protection is
strictly bounded, with the worst case latency for a single operation
being less than 100ms.

Zapping at 1gb in the first pass is not arbitrary.  First and foremost,
KVM relies on being able to zap 1gb shadow pages in a single shot when
when repacing a shadow page with a hugepage.  Zapping a 1gb shadow page
that is fully populated with 4kb dirty SPTEs also triggers the worst case
latency due writing back the struct page accessed/dirty bits for each 4kb
page, i.e. the two-pass approach is guaranteed to work so long as KVM can
cleany zap a 1gb shadow page.

  rcu: INFO: rcu_sched self-detected stall on CPU
  rcu:     52-....: (20999 ticks this GP) idle=7be/1/0x4000000000000000
                                          softirq=15759/15759 fqs=5058
   (t=21016 jiffies g=66453 q=238577)
  NMI backtrace for cpu 52
  Call Trace:
   ...
   mark_page_accessed+0x266/0x2f0
   kvm_set_pfn_accessed+0x31/0x40
   handle_removed_tdp_mmu_page+0x259/0x2e0
   __handle_changed_spte+0x223/0x2c0
   handle_removed_tdp_mmu_page+0x1c1/0x2e0
   __handle_changed_spte+0x223/0x2c0
   handle_removed_tdp_mmu_page+0x1c1/0x2e0
   __handle_changed_spte+0x223/0x2c0
   zap_gfn_range+0x141/0x3b0
   kvm_tdp_mmu_zap_invalidated_roots+0xc8/0x130
   kvm_mmu_zap_all_fast+0x121/0x190
   kvm_mmu_invalidate_zap_pages_in_memslot+0xe/0x10
   kvm_page_track_flush_slot+0x5c/0x80
   kvm_arch_flush_shadow_memslot+0xe/0x10
   kvm_set_memslot+0x172/0x4e0
   __kvm_set_memory_region+0x337/0x590
   kvm_vm_ioctl+0x49c/0xf80

Reported-by: David Matlack <dmatlack@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Mingwei Zhang <mizhang@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index aec97e037a8d..2e28f5e4b761 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -809,6 +809,18 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	gfn_t end = tdp_mmu_max_gfn_host();
 	gfn_t start = 0;
 
+	/*
+	 * To avoid RCU stalls due to recursively removing huge swaths of SPs,
+	 * split the zap into two passes.  On the first pass, zap at the 1gb
+	 * level, and then zap top-level SPs on the second pass.  "1gb" is not
+	 * arbitrary, as KVM must be able to zap a 1gb shadow page without
+	 * inducing a stall to allow in-place replacement with a 1gb hugepage.
+	 *
+	 * Because zapping a SP recurses on its children, stepping down to
+	 * PG_LEVEL_4K in the iterator itself is unnecessary.
+	 */
+	int zap_level = PG_LEVEL_1G;
+
 	/*
 	 * The root must have an elevated refcount so that it's reachable via
 	 * mmu_notifier callbacks, which allows this path to yield and drop
@@ -825,12 +837,9 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	/*
-	 * No need to try to step down in the iterator when zapping an entire
-	 * root, zapping an upper-level SPTE will recurse on its children.
-	 */
+start:
 	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   root->role.level, start, end) {
+				   zap_level, start, end) {
 retry:
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
 			continue;
@@ -838,6 +847,9 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (!is_shadow_present_pte(iter.old_spte))
 			continue;
 
+		if (iter.level > zap_level)
+			continue;
+
 		if (!shared) {
 			tdp_mmu_set_spte(kvm, &iter, 0);
 		} else if (!tdp_mmu_set_spte_atomic(kvm, &iter, 0)) {
@@ -846,6 +858,11 @@ static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 		}
 	}
 
+	if (zap_level < root->role.level) {
+		zap_level = root->role.level;
+		goto start;
+	}
+
 	rcu_read_unlock();
 }
 
-- 
2.34.1.448.ga2b2bfdf31-goog

