Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D04B4516BF
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 22:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347035AbhKOVmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 16:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347606AbhKOVbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 16:31:40 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF23DC07978F
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 13:17:12 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id u4-20020a056a00098400b004946fc3e863so10608098pfg.8
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 13:17:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=XKLWlLaz9dMMXpY7vqrKj+gJX43hfIjMlaR58B8E1J0=;
        b=KsbuBZr2cvOp1RXmqbysm7ST4ITB8FxHBMsGtm6YNxN6qNLWMEjiO3fgxBW7T2fuv4
         7iJeku2Ir8e2JTr4OPAr1j4Ovv+xija18RivWUEOeuJJKhLPD/Ys550gcBWPOonQ6w1T
         4xaz5cR0/TJOC1yErdqvrcQMRK2lfJhAaQYBPwFC+7XNBvSmjWCIDuc3tn+8KFC7mina
         0dMMy7Y6WktLt9+4K4yQWlwu6v4lJyuml23ipqIYwoxNgAvZax9JCHtJv1zjD+tJo3Pj
         /WyCiKmyHOknsqo6r9ZmReSL4jbzbRjhUYUUVD6poQ0JtGG5mL4n5IQ9u8Ieul542ckd
         4IsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=XKLWlLaz9dMMXpY7vqrKj+gJX43hfIjMlaR58B8E1J0=;
        b=DNyUf7saNnhy6LAEoUJ6PNw3oNuSnTt7xpdexXU8kt8jzmuMAMs1rz7Fwtm2tt3eST
         FHOl2l5hagU2WQroJcsj4EfJVmlwfLMETFeGgT7/M+BMxgFz8jxMrAU2fsBZnu7L243m
         mXfPUAMYdYJNe8BACUNivD7BXD9rQlVnOKvWGj7gAY388DE3K1oKQ1Ow4GN5JTkky5Mk
         H6KkyTUn9Mj3PT6NOqj9NCXp/Up2Gx+xRT1z415BZGn+hWkpOIH62Hr/Lx6EP7SwSWHZ
         oa7sRPZT1WQA3gxyjgXs0ABUq+Yt4Qez+jCR6ijnAqmcfEKsk1fYHYG74RLEB6xFtCpy
         6lsg==
X-Gm-Message-State: AOAM530tpuB/adBqn6x2D6mfkXT4lTIojGss/JWxaRnNiny0TmB8kN8P
        NCLYZsaYUmQjydMMy7VGgbJ12dqi8zWf
X-Google-Smtp-Source: ABdhPJzTHdkyhPUStS6JfR8W1Vb+jz+OWtaRuA2J8PFkGBP9eQbWPebsjSpHeALvCb1Vqmgfk70L/+Rp81kD
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a17:902:ba84:b0:142:5514:8dd7 with SMTP id
 k4-20020a170902ba8400b0014255148dd7mr39012600pls.87.1637011032196; Mon, 15
 Nov 2021 13:17:12 -0800 (PST)
Date:   Mon, 15 Nov 2021 13:17:04 -0800
Message-Id: <20211115211704.2621644-1-bgardon@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 1/1] KVM: x86/mmu: Fix TLB flush range when handling
 disconnected pt
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When recursively clearing out disconnected pts, the range based TLB
flush in handle_removed_tdp_mmu_page uses the wrong starting GFN,
resulting in the flush mostly missing the affected range. Fix this by
using base_gfn for the flush.

In response to feedback from David Matlack on the RFC version of this
patch, also move a few definitions into the for loop in the function to
prevent unintended references to them in the future.

Fixes: a066e61f13cf ("KVM: x86/mmu: Factor out handling of removed page tables")
CC: stable@vger.kernel.org

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c5dd83e52de..4bd541050d21 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -317,9 +317,6 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 	struct kvm_mmu_page *sp = sptep_to_sp(rcu_dereference(pt));
 	int level = sp->role.level;
 	gfn_t base_gfn = sp->gfn;
-	u64 old_child_spte;
-	u64 *sptep;
-	gfn_t gfn;
 	int i;
 
 	trace_kvm_mmu_prepare_zap_page(sp);
@@ -327,8 +324,9 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 	tdp_mmu_unlink_page(kvm, sp, shared);
 
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-		sptep = rcu_dereference(pt) + i;
-		gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
+		u64 *sptep = rcu_dereference(pt) + i;
+		gfn_t gfn = base_gfn + i * KVM_PAGES_PER_HPAGE(level);
+		u64 old_child_spte;
 
 		if (shared) {
 			/*
@@ -374,7 +372,7 @@ static void handle_removed_tdp_mmu_page(struct kvm *kvm, tdp_ptep_t pt,
 				    shared);
 	}
 
-	kvm_flush_remote_tlbs_with_address(kvm, gfn,
+	kvm_flush_remote_tlbs_with_address(kvm, base_gfn,
 					   KVM_PAGES_PER_HPAGE(level + 1));
 
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
-- 
2.34.0.rc1.387.gb447b232ab-goog

