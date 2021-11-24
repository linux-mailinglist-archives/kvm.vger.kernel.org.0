Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFEE45CF68
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 22:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245305AbhKXVro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 16:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245108AbhKXVrn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 16:47:43 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC36AC061746
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 13:44:32 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id o8-20020a170902d4c800b001424abc88f3so1315428plg.2
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 13:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=DKZg3S3JbC7UFqx9XCubd9jpAZSz45i7flp00buaAHE=;
        b=kk++MEItvROlWLszZzrY5qGEoiEejSnf1FCstJWlTkjXIOG5nqJdeRHa+vJK+/A62e
         F4NoxKsphCndXXx2ZW4KntcqDVDZFRM0ldgGecJqL4klapNgWd13eztbrZKran6iSFZA
         k9pOvYrVq73NZl+6AQM+TO+oinrwyb6lp79BCoOA0lZIL/V0oekiVvAkVgd+xpHCsZ9x
         L/Y6WBfhKsSARhC0uO1QAEPxcC2QBmLW/CvF5Va+u/argZzQ8XEb00MMeMHJLyJfb7U6
         srSmZlqpfKT2QJzg6PpaXYarZyPxbGATpgcV6ombE8pj0/9tEu9dz0bhHTjHB1ldun01
         2wxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=DKZg3S3JbC7UFqx9XCubd9jpAZSz45i7flp00buaAHE=;
        b=S84bOtAQK5G+2QbZFaW86lowZIiD0kA7CHV8Bel+gYNkc19G4nvInDTZBHnENAEGz0
         TUn2eWqCieTyD4t/VYPldc/Zp4fZhlocOR3SzRhmQ+5gX/laMLPtyVj0jGqwNweu3V91
         b2JJrZ52nOoDXzsxTe0z3ZfboLgq5JVI9i/ZsfEI9lhOqpfXg8riIvmx/E+6Kl2shLNJ
         w588bATXHxTOq9P2SmtkvFbYgEqMQesK5ReHT1NnlcnbBXBcrGv6TAdoL0X0LafMSi5v
         J9bcm293NIZG/o3n/7V3nOmW9LtUPIDCbgHcHmw5unjLxz6RFFdNBYda0YUS7uFWcnrZ
         NMgw==
X-Gm-Message-State: AOAM531je3Rbojl7kaasaFdSyuTMBImmRMatqCo+RavDH0SsMI+nYHQn
        bJIZjMdT8mHhUV/Fcl24aMUttHwnJ3tn
X-Google-Smtp-Source: ABdhPJx2paf/6vK9rPra05A3zyHt7H9t3DEFsf1JmydeX70xnxn3B+OjjqN0M4pSOwMpUQyKH7cN/C9/v7a2
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr325050pjf.1.1637790271817; Wed, 24 Nov 2021 13:44:31 -0800 (PST)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 24 Nov 2021 21:44:20 +0000
In-Reply-To: <20211124214421.458549-1-mizhang@google.com>
Message-Id: <20211124214421.458549-2-mizhang@google.com>
Mime-Version: 1.0
References: <20211124214421.458549-1-mizhang@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 1/2] Revert "KVM: x86/mmu: Don't step down in the TDP iterator
 when zapping all SPTEs"
From:   Mingwei Zhang <mizhang@google.com>
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

Not stepping down in TDP iterator in `zap_all` case avoids re-reading the
non-leaf SPTEs, thus accelerates the zapping process . But when the number
of SPTEs is too large, we may run out of CPU time and causes a RCU stall
warnings in __handle_changed_pte() in the context of zap_gfn_range().

Revert this patch to allow eliminating RCU stall warning using a two-phase
zapping for `zap_all` case.

This reverts commit 0103098fb4f13b447b26ed514bcd3140f6791047.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: David Matlack <dmatlack@google.com>

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7c5dd83e52de..89d16bb104de 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -706,12 +706,6 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 	bool zap_all = (start == 0 && end >= max_gfn_host);
 	struct tdp_iter iter;
 
-	/*
-	 * No need to try to step down in the iterator when zapping all SPTEs,
-	 * zapping the top-level non-leaf SPTEs will recurse on their children.
-	 */
-	int min_level = zap_all ? root->role.level : PG_LEVEL_4K;
-
 	/*
 	 * Bound the walk at host.MAXPHYADDR, guest accesses beyond that will
 	 * hit a #PF(RSVD) and never get to an EPT Violation/Misconfig / #NPF,
@@ -723,8 +717,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 	rcu_read_lock();
 
-	for_each_tdp_pte_min_level(iter, root->spt, root->role.level,
-				   min_level, start, end) {
+	tdp_root_for_each_pte(iter, root, start, end) {
 retry:
 		if (can_yield &&
 		    tdp_mmu_iter_cond_resched(kvm, &iter, flush, shared)) {
-- 
2.34.0.rc2.393.gf8c9666880-goog

