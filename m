Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256B92DDC6B
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 01:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgLRAdO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Dec 2020 19:33:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbgLRAdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Dec 2020 19:33:13 -0500
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4147DC061248
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:32:00 -0800 (PST)
Received: by mail-qt1-x84a.google.com with SMTP id l7so523374qth.15
        for <kvm@vger.kernel.org>; Thu, 17 Dec 2020 16:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=31UxY3BjxhhaVQJHGm3+ViFf/MlRFopzIvlMkIG1nRk=;
        b=Hn2FNm68j9LqarEV9dPHPgK3Xa8kkSTIruyksHHOd6CxrYqKy25Xx4tzQT+Rqm+GFb
         ZCGYQOxmf1wkpIk1j+V9nnoT+BH3let0VtXfOkIpf1dpIR60LoFSAPfoPG0jEnce3FHR
         1etFrryYikPIGpU2gcVBo89wS4sBSvNuw+XtxSPpKv5J5RTrAIDuAOyOvxP0jtHRey6J
         pjk9Pjurj8MkO8tmhSxyJVR1r/JiQc8Tvbhv0Jfr7+0QgHqHJH9+GK9825r3t7tNEyOW
         1KMEvqn+JI3Gy+4Cwh8UIOdTNmZH7EZfVwSzubR8eV9zoz2yuJuEsxgzxP4AGUUjaKRd
         2teQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=31UxY3BjxhhaVQJHGm3+ViFf/MlRFopzIvlMkIG1nRk=;
        b=mz7mnPXKdgqWy6uEAk4Po9AUlAKKYixuLWN4M6dLNj/BfxVGtf+xgu3eBZYdmF4e8v
         j/PhREVuBPyNXvw3c4OLThRxTZN3HQUSVHuuSrU4uBb2RbMLAoBpkiDBAINMrtdZ9aiW
         0wkOCVmpE9M53KMNpjK7e8ewwUg9hoiT3M2PBScimW2YbrlV2U59H56DThCGLDjJ57DD
         HPd+V0lIDrRE1VQ64YgnKEzEu0kD4N4D+U9v087uXDp3jaXjNSGT5Ye7p6wLkNMI/CPm
         hHoJByzHU3inlACsbQc4O0icuYTyLPnJZtLVl5/ZlZvqOCAVYdS8H74y+K6aBHmSzxpj
         ZKDg==
X-Gm-Message-State: AOAM531FkB699HqPvzFquVDFPpeZawcW7E1e+ufoNpiBOUv6vB2prPxg
        jLEDaBEIVgf3b7izRBbz+p2zHGnFmtY=
X-Google-Smtp-Source: ABdhPJx+lcVCo2wS+9IQsGU5CWvwij4l21/N8yDEVb4j3SxnWb7tnXeTlyi47WM0DVQjnd6m2O7L/Xu2fAw=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a0c:aa55:: with SMTP id e21mr1897255qvb.43.1608251519493;
 Thu, 17 Dec 2020 16:31:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 17 Dec 2020 16:31:38 -0800
In-Reply-To: <20201218003139.2167891-1-seanjc@google.com>
Message-Id: <20201218003139.2167891-4-seanjc@google.com>
Mime-Version: 1.0
References: <20201218003139.2167891-1-seanjc@google.com>
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH 3/4] KVM: x86/mmu: Use raw level to index into MMIO walks'
 sptes array
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

Bump the size of the sptes array by one and use the raw level of the
SPTE to index into the sptes array.  Using the SPTE level directly
improves readability by eliminating the need to reason out why the level
is being adjusted when indexing the array.  The array is on the stack
and is not explicitly initialized; bumping its size is nothing more than
a superficial adjustment to the stack frame.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 15 +++++++--------
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 52f36c879086..4798a4472066 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3500,7 +3500,7 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 		leaf = iterator.level;
 		spte = mmu_spte_get_lockless(iterator.sptep);
 
-		sptes[leaf - 1] = spte;
+		sptes[leaf] = spte;
 
 		if (!is_shadow_present_pte(spte))
 			break;
@@ -3514,7 +3514,7 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 /* return true if reserved bit is detected on spte. */
 static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 {
-	u64 sptes[PT64_ROOT_MAX_LEVEL];
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1];
 	struct rsvd_bits_validate *rsvd_check;
 	int root, leaf, level;
 	bool reserved = false;
@@ -3537,16 +3537,15 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	rsvd_check = &vcpu->arch.mmu->shadow_zero_check;
 
 	for (level = root; level >= leaf; level--) {
-		if (!is_shadow_present_pte(sptes[level - 1]))
+		if (!is_shadow_present_pte(sptes[level]))
 			break;
 		/*
 		 * Use a bitwise-OR instead of a logical-OR to aggregate the
 		 * reserved bit and EPT's invalid memtype/XWR checks to avoid
 		 * adding a Jcc in the loop.
 		 */
-		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level - 1]) |
-			    __is_rsvd_bits_set(rsvd_check, sptes[level - 1],
-					       level);
+		reserved |= __is_bad_mt_xwr(rsvd_check, sptes[level]) |
+			    __is_rsvd_bits_set(rsvd_check, sptes[level], level);
 	}
 
 	if (reserved) {
@@ -3554,10 +3553,10 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		       __func__, addr);
 		for (level = root; level >= leaf; level--)
 			pr_err("------ spte 0x%llx level %d.\n",
-			       sptes[level - 1], level);
+			       sptes[level], level);
 	}
 
-	*sptep = sptes[leaf - 1];
+	*sptep = sptes[leaf];
 
 	return reserved;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a4f9447f8327..efef571806ad 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1160,7 +1160,7 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
-		sptes[leaf - 1] = iter.old_spte;
+		sptes[leaf] = iter.old_spte;
 	}
 
 	return leaf;
-- 
2.29.2.684.gfbc64c5ab5-goog

