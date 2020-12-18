Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4472DDC67
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 01:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgLRAci (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 19:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLRAch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 19:32:37 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD1DC061282
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:31:57 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id m203so557258ybf.1
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=oPInapfcZTUHbBkbVV08IPJRvv/+257Sb09FHDMXMx0=;
        b=BJM2457W/2DqIVdYPMvLElMFmLn+V9yNBpsNR5FdQfmquv2Pi/tsiRXYT/XV90HZuz
         q9wsNx7EMERv9CED+XDz1TDsMIELmhvQgDp4Z8RN4oAFaPp8hH+Lfjjj6F//A01INe8c
         hQWQaNaITd2hfeSEztvkBn9V8c0eByUkez8k3Y2PtvfGeupAZ5EWirZ6ZAYtQk6ddsZn
         KRK5CEWkZ7KN/UVc+VZmFveUdRpJWQJTbKNdR5IYQ9tty9vlQ6mB9bAOCKvhkMb8rbzH
         SQM1f2BzIbZYtXRvUtOFLzWxy80tWWVa9zIS7egAI4cBMi1hm/f9h0GUGso/HrUwDz2A
         mgww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=oPInapfcZTUHbBkbVV08IPJRvv/+257Sb09FHDMXMx0=;
        b=ZCdecGbEwmY29pj6AYtuXFl24hhqRp6z8BOVshXa08DFxkXA4y64DWiZxBE94/ucUw
         MsAU9rDNdUij/smWcbDqyJwsWB30gq5Z1gJZXX3Tmh0VZN5rqelYu6X/+OzyvgYfXeoK
         y5UCMNdPkXgzN5RcptFuFVWWkcqjqCKpdZEjzAk8N5l0SZYvTwWbYoNLuoC9tdJXJMIA
         z8Hkjq6tB+VWUqdwcVViWBAAZqruRLKyNphDE3MUzInBNVhcJFJI4WsRZFpDcZakMVC7
         43CAZ6hYk56p6ienBCTi7nA6TeKlaE8Ty6pmbgR2JZYTbKU3lJZm3fvph+BgGbSE63m/
         4emw==
X-Gm-Message-State: AOAM530GAmBA1uxPrh6qTDlhsnBpmTch+Yf/9o/exP6N5ZlMCCtmWm7o
        D95voCRwXXFxIn/0/AVaUySvBNbd7d4=
X-Google-Smtp-Source: ABdhPJwZql1VvyeiPF6SWvG4xyoDmI65yGXwGbsVO8dFZiPBHoEGM/0qw4KWY8ipQ5YL1H/pZm6Ie2PArzI=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a25:5303:: with SMTP id h3mr2709285ybb.58.1608251516871;
 Thu, 17 Dec 2020 16:31:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Dec 2020 16:31:37 -0800
In-Reply-To: <20201218003139.2167891-1-seanjc@google.com>
Message-Id: <20201218003139.2167891-3-seanjc@google.com>
Mime-Version: 1.0
References: <20201218003139.2167891-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH 2/4] KVM: x86/mmu: Get root level from walkers when retrieving
 MMIO SPTE
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Richard Herbert <rherbert@sympatico.ca>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Get the so called "root" level from the low level shadow page table
walkers instead of manually attempting to calculate it higher up the
stack, e.g. in get_mmio_spte().  When KVM is using PAE shadow paging,
the starting level of the walk, from the callers perspective, is not
the CR3 root but rather the PDPTR "root".  Checking for reserved bits
from the CR3 root causes get_mmio_spte() to consume uninitialized stack
data due to indexing into sptes[] for a level that was not filled by
get_walk().  This can result in false positives and/or negatives
depending on what garbage happens to be on the stack.

Opportunistically nuke a few extra newlines.

Fixes: 95fb5b0258b7 ("kvm: x86/mmu: Support MMIO in the TDP MMU")
Reported-by: Richard Herbert <rherbert@sympatico.ca>
Cc: Ben Gardon <bgardon@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 15 ++++++---------
 arch/x86/kvm/mmu/tdp_mmu.c |  5 ++++-
 arch/x86/kvm/mmu/tdp_mmu.h |  4 +++-
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a48cd12c01d7..52f36c879086 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3485,16 +3485,16 @@ static bool mmio_info_in_cache(struct kvm_vcpu *vcpu, u64 addr, bool direct)
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
  */
-static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	int leaf = -1;
 	u64 spte;
 
-
 	walk_shadow_page_lockless_begin(vcpu);
 
-	for (shadow_walk_init(&iterator, vcpu, addr);
+	for (shadow_walk_init(&iterator, vcpu, addr),
+	     *root_level = iterator.level;
 	     shadow_walk_okay(&iterator);
 	     __shadow_walk_next(&iterator, spte)) {
 		leaf = iterator.level;
@@ -3504,7 +3504,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
 
 		if (!is_shadow_present_pte(spte))
 			break;
-
 	}
 
 	walk_shadow_page_lockless_end(vcpu);
@@ -3517,9 +3516,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
 	u64 sptes[PT64_ROOT_MAX_LEVEL];
 	struct rsvd_bits_validate *rsvd_check;
-	int root = vcpu->arch.mmu->shadow_root_level;
-	int leaf;
-	int level;
+	int root, leaf, level;
 	bool reserved = false;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
@@ -3528,9 +3525,9 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	}
 
 	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
-		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes);
+		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
-		leaf = get_walk(vcpu, addr, sptes);
+		leaf = get_walk(vcpu, addr, sptes, &root);
 
 	if (unlikely(leaf < 0)) {
 		*sptep = 0ull;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 50cec7a15ddb..a4f9447f8327 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1148,13 +1148,16 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  * Return the level of the lowest level SPTE added to sptes.
  * That SPTE may be non-present.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes)
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
+	*root_level = vcpu->arch.mmu->shadow_root_level;
+
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf - 1] = iter.old_spte;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 556e065503f6..cbbdbadd1526 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -44,5 +44,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn);
 
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes);
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level);
+
 #endif /* __KVM_X86_MMU_TDP_MMU_H */
-- 
2.29.2.684.gfbc64c5ab5-goog

