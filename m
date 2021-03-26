Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D313349F72
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 03:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhCZCUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 22:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbhCZCUN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 22:20:13 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B88C061761
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id x8so8408426ybo.6
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 19:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xb8DgI2xFcrM/12UvqDPQlPXHEZwzPOiZzDwlsIie/g=;
        b=LTA+FlztlbawA45c1WTNtB0+0k4zDG2JNcBSVgOBw6hAgXeXfNjZbqxa0273lIWLNe
         ttjcg3fq+z634BQAWTxUlSsrRwNAaP+NP0BoTVohovvNTClDA7Atl31Oegy0JstB9ddH
         QquMjA9vYXTD8sE0ETK+TS3DQ0/9PyHdPbhasPovVlJc6LBQ4ZzAIKNbkbAQxLe+0uY9
         5ul5DAL52znGITYaaSnYG1czEu70soT/ovFzF22WuRsZzZM2LTU5TaSfaNlMMeAYoxEh
         nxkXSMEvdAqjZ2IhpJWyzFxM0kGdcqc6rH1PgDdXHrzIHZH3KWpk77UxwCuoas+sWLNA
         Nygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xb8DgI2xFcrM/12UvqDPQlPXHEZwzPOiZzDwlsIie/g=;
        b=UPh9LKPSLS8qczQj9SZPnCFthZLlbf9HWqDUOSravNZ5mWolZYupBNt6sPLyv08Hn1
         EgU7w3JJ1flZ2WDKp+ht9GL18iw2WXoUIsmBwUNyJ+XI4VFANrLTZN6CuUOIGP1tjFn1
         fyoUw6PUhiUV0Qgq9wAcicNRPV2RnKT0wnlJWXx3fmT4RRMOPfw/Cwst2qfeIUqaemVp
         XbiLuFjXWlL9oL/AOjfkgxIRb+48qOY/IKEJAA+P3WkfW9/Tld7Uj2ffWn9ZoNEatVjg
         bNov9Gu57pUbTsPtEaQhlvabMjw170FA6MD4TxR2Dvqg/ppISK70xNDk/+3NSz2nJeSv
         MTZg==
X-Gm-Message-State: AOAM531NosBHzA8ANh3vzSY4chl/3DB329HlbDmHI2WVdVXWNqz3bEzV
        3gS+0Uuf51EfRqC3LPfdFTrHOrMSpSk=
X-Google-Smtp-Source: ABdhPJzT/d6MruEkvrArmoOcIHLexgvlTJlZNDyv9Tx14134QiRzKCyIxhCXc8QGkX5T07WTvqrR6kS/xTk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:37c1:: with SMTP id e184mr16469856yba.260.1616725212722;
 Thu, 25 Mar 2021 19:20:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 19:19:40 -0700
In-Reply-To: <20210326021957.1424875-1-seanjc@google.com>
Message-Id: <20210326021957.1424875-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210326021957.1424875-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 01/18] KVM: x86/mmu: Coalesce TDP MMU TLB flushes when zapping
 collapsible SPTEs
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When zapping collapsible SPTEs across multiple roots, gather pending
flushes and perform a single remote TLB flush at the end, as opposed to
flushing after processing every root.

Note, flush may be cleared by the result of zap_collapsible_spte_range().
This is intended and correct, e.g. yielding may have serviced a prior
pending flush.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 08667e3cf091..463f1be6ff0d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1278,21 +1278,21 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
  * Clear leaf entries which could be replaced by large mappings, for
  * GFNs within the slot.
  */
-static void zap_collapsible_spte_range(struct kvm *kvm,
+static bool zap_collapsible_spte_range(struct kvm *kvm,
 				       struct kvm_mmu_page *root,
-				       struct kvm_memory_slot *slot)
+				       struct kvm_memory_slot *slot,
+				       bool flush)
 {
 	gfn_t start = slot->base_gfn;
 	gfn_t end = start + slot->npages;
 	struct tdp_iter iter;
 	kvm_pfn_t pfn;
-	bool spte_set = false;
 
 	rcu_read_lock();
 
 	tdp_root_for_each_pte(iter, root, start, end) {
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, spte_set)) {
-			spte_set = false;
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, flush)) {
+			flush = false;
 			continue;
 		}
 
@@ -1308,12 +1308,12 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 
 		tdp_mmu_set_spte(kvm, &iter, 0);
 
-		spte_set = true;
+		flush = true;
 	}
 
 	rcu_read_unlock();
-	if (spte_set)
-		kvm_flush_remote_tlbs(kvm);
+
+	return flush;
 }
 
 /*
@@ -1324,6 +1324,7 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 				       struct kvm_memory_slot *slot)
 {
 	struct kvm_mmu_page *root;
+	bool flush = false;
 	int root_as_id;
 
 	for_each_tdp_mmu_root_yield_safe(kvm, root) {
@@ -1331,8 +1332,11 @@ void kvm_tdp_mmu_zap_collapsible_sptes(struct kvm *kvm,
 		if (root_as_id != slot->as_id)
 			continue;
 
-		zap_collapsible_spte_range(kvm, root, slot);
+		flush = zap_collapsible_spte_range(kvm, root, slot, flush);
 	}
+
+	if (flush)
+		kvm_flush_remote_tlbs(kvm);
 }
 
 /*
-- 
2.31.0.291.g576ba9dcdaf-goog

