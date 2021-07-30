Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842793DC126
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbhG3Wh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbhG3WhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:37:25 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCBDC06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:19 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id x12-20020a05620a14acb02903b8f9d28c19so6550062qkj.23
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DVeQW96yDje60l1vMNxOEQha2Pu/nzO8XHDKxp1dy1o=;
        b=LhEp5DVrxD5oHu/gzk50OVffOBhsi4k+j8Lc1A3h639Z07Be9R02s/XJbWwN+r0hJm
         XST7lu9uGQzNaqPWzPuVY5cdmDmhYI67Ro6yELPT+ZUSzSL5tjifgj3i0CSAk0j2g8qK
         ZeSrIR5F3OO4HKNtb3SJrjYDgcrjg6OsGzmRlMjmQhl5ud2tTI8TYssBmrQbhEmXFJpY
         6zHzDcYHuS6GJTN1P9ydGxY3u8VXCK5FY3lebP9WDVSLNDuez4aZt3BkYIuDol2mh8v7
         IViDBYfkz5D7KeikNiTV4/Avo/6VNR4zY8o6tGCoyE6xxLqETSEhBCh0PO8/JzS60ioC
         gd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DVeQW96yDje60l1vMNxOEQha2Pu/nzO8XHDKxp1dy1o=;
        b=nWPKeE/lwtOyla0lT8ByzjYMakjxj3PVUnTWb+hUIWbwXU94Vb1tIQZpk/GNsa8vJQ
         2wB80mNO3PQZp60gid6zSjFOjsjwLRCiBizMlvF3kACDFx+ceCvSEPguS3zRPjMwwnAh
         qst7oxsFrSwfKZntLzD+MBb9RsMuTumAwjcyB0YGMxBbk4aT/WctGLm9aqvhdpIL2V6o
         SLzez4tD03qk3USwRpYThtqf775GxzzxEdiLLpdyk+igySyqqIdCu5lVNYqcif4NQiJD
         xgLksOy0U+bq0RPzAvie4VY2jbcryvvsaPgqJgKLK5glu51ZoHwS+dEQrdh4K8IM4QLZ
         uprQ==
X-Gm-Message-State: AOAM533dr17lK20ZCZtRE/hCEeP9q5ZIBcrVa4FGlUmMma/xxyXFCBms
        upBkKiXQY4FoxAhhY84XN9HCGY8FUKq0vkhUBdwshQZU/VlXkYkkosTLAdIl71nTQEeYIESUzEP
        mcRFqkMEi9mP1J5QdA1VqfDTQUQs59XS/t2Y9MweGa3/vopL1nqrTGwHDZ5Hg/bU=
X-Google-Smtp-Source: ABdhPJwC9qCk9bZ/jZxxOerVx4mYD76+MVxUaByt8pYh/M2A2qsqnHeJcnFBoPMQVZAGsT/opI4NbN4g89Upog==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a0c:d801:: with SMTP id
 h1mr5090968qvj.60.1627684638295; Fri, 30 Jul 2021 15:37:18 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:37:04 +0000
In-Reply-To: <20210730223707.4083785-1-dmatlack@google.com>
Message-Id: <20210730223707.4083785-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210730223707.4083785-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH 3/6] KVM: x86/mmu: Speed up dirty logging in tdp_mmu_map_handle_target_level
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
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The existing TDP MMU methods to handle dirty logging are vcpu-agnostic
since they can be driven by MMU notifiers and other non-vcpu-specific
events in addition to page faults. However this means that the TDP MMU
is not benefiting from the new vcpu->lru_slot_index. Fix that by special
casing dirty logging in tdp_mmu_map_handle_target_level.

This improves "Populate memory time" in dirty_log_perf_test by 5%:

Command                         | Before           | After
------------------------------- | ---------------- | -------------
./dirty_log_perf_test -v64 -x64 | 5.472321072s     | 5.169832886s

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 43f12f5d12c0..1467f99c846d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -929,10 +929,19 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu, int write,
 					 map_writable, !shadow_accessed_mask,
 					 &new_spte);
 
-	if (new_spte == iter->old_spte)
+	if (new_spte == iter->old_spte) {
 		ret = RET_PF_SPURIOUS;
-	else if (!tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
-		return RET_PF_RETRY;
+	} else {
+		if (!tdp_mmu_set_spte_atomic_no_dirty_log(vcpu->kvm, iter, new_spte))
+			return RET_PF_RETRY;
+
+		/*
+		 * Mark the gfn dirty here rather that through the vcpu-agnostic
+		 * handle_changed_spte_dirty_log to leverage vcpu->lru_slot_index.
+		 */
+		if (is_writable_pte(new_spte))
+			kvm_vcpu_mark_page_dirty(vcpu, iter->gfn);
+	}
 
 	/*
 	 * If the page fault was caused by a write but the page is write
-- 
2.32.0.554.ge1b32706d8-goog

