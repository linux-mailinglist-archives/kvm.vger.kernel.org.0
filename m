Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 491C93B8A32
	for <lists+kvm@lfdr.de>; Wed, 30 Jun 2021 23:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbhF3Vuv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Jun 2021 17:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3Vuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Jun 2021 17:50:50 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57513C061756
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:21 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id c10-20020a17090a558ab029017019f7ec8fso2068037pji.8
        for <kvm@vger.kernel.org>; Wed, 30 Jun 2021 14:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1h8e+apG3TTK1wRFhX1YgohezWt8EbM/GUKeu+wHNLA=;
        b=TtIfBmZfHCJ2cr5jLzgT3clLRpf8lqr4lK1J+gSBwh8JoI65zvLR3SA46owrDYkD4z
         cOzWzvLa4J28heFnsTro9kHcfuwn3uD2vI85vK1rXG6bQXPwHWjirmsuPRO61MoDQcfM
         ZwaKFSy+44VC+oZuRhPtkbVfjSy/pgaug39/jpiS8pERPzFSw7DTRoiCG9panhRREmL+
         DShfcinj3BZTWc24EZF0ORkQjJyF6PSkn4CDLlmCN1C+VLIofRtF9mA7Z5W5RG6rFEpA
         jtFO6k/HCqX+Jgq1hve/RYZnKGr3CN4JMyDKMNxIOYeJFEHqXc9InxXzkpGUnAH40hqQ
         U1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1h8e+apG3TTK1wRFhX1YgohezWt8EbM/GUKeu+wHNLA=;
        b=MgW2vVJr2Nup+Eq4zejPnI3bIq1FOu0dyAvWvtBIqjP0p3FvgP4j2v08JpRhAK8z8C
         08HlD1FyfIvsyJSYLYxNkulrjoJMRi0yYMMhM8Yp1zby9ZDBhUo/sGtbUAQGyu93imV3
         n+gMfvkKnAp0OAwwdAKULgMTTMrwa0Oo3zKJSTfh2kf5ISYLGw021tVZJxSfL+J9njPv
         8dQ8fEiFyu+HvvR8TiKNyJhRCtthe4Q9pgXWZkGy5wWfp5hjHGje4BtsV3LF00d5W4KI
         CM/XpIxPhm+YEn0f0/bzmKpf3Il8lc1sUdRNAuKffVA4TkE9xDqJprRUNnrhGJZ4QhPz
         ktkA==
X-Gm-Message-State: AOAM530JCAZ2rEQJIZ+lH3NfGlZKNBKvIpqQYyNX06AQhQgbQ5aOlqxO
        hYBrtAt/S1DH9C4SOXkvhvnEKgweOejK0PKLH4p1HfvD5cO+AuBILB4BqXJokxRjiHwMYaVgjDt
        IoBXJA1RnBBDBtO0Rpc9/NhmURYnf2/WUn5L+wuhGvUtFnEW83fakmy60vWAYEKo=
X-Google-Smtp-Source: ABdhPJy/+bjigqQpu7LXftTmsvbM3zANLjDLlj3pASUu0wshlCndt+Uzut1h4+IlM2ZnzFbToNGOnteFCAUpdg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:4a0a:: with SMTP id
 kk10mr40665935pjb.16.1625089700683; Wed, 30 Jun 2021 14:48:20 -0700 (PDT)
Date:   Wed, 30 Jun 2021 21:47:57 +0000
In-Reply-To: <20210630214802.1902448-1-dmatlack@google.com>
Message-Id: <20210630214802.1902448-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210630214802.1902448-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 1/6] KVM: x86/mmu: Rename cr2_or_gpa to gpa in fast_page_fault
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Yu Zhao <yuzhao@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

fast_page_fault is only called from direct_page_fault where we know the
address is a gpa.

Fixes: 736c291c9f36 ("KVM: x86: Use gpa_t for cr2/gpa to fix TDP support on 32-bit KVM")
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b888385d1933..45274436d3c0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3098,8 +3098,7 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
-static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-			   u32 error_code)
+static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
@@ -3115,7 +3114,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	do {
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, cr2_or_gpa, iterator, spte)
+		for_each_shadow_entry_lockless(vcpu, gpa, iterator, spte)
 			if (!is_shadow_present_pte(spte))
 				break;
 
@@ -3194,8 +3193,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	} while (true);
 
-	trace_fast_page_fault(vcpu, cr2_or_gpa, error_code, iterator.sptep,
-			      spte, ret);
+	trace_fast_page_fault(vcpu, gpa, error_code, iterator.sptep, spte, ret);
 	walk_shadow_page_lockless_end(vcpu);
 
 	return ret;
-- 
2.32.0.93.g670b81a890-goog

