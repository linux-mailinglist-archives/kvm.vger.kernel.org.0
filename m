Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B70C34E32EB
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiCUWtr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiCUWt0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:26 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587D42AC77
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:12 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id b9-20020a17090aa58900b001b8b14b4aabso257292pjq.9
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=N/VqAqp6gLrZv99t4Njzo2cELtOAzHXSK8UPoavhuKQ=;
        b=mcmZRlLuczmyzx0s2+txXbdamltCrph70eCBEhtFHOvXlDp5ARTOrdpARtK5XjDuq/
         /QSyThdWNlgl09K6ie4aoRZsa9DnMIO4AUf1aB5quXDa++jLJLuDaq0r6RLOITOehL2G
         UxAyo1V2O2hF8uzY1cZAenEmg1GuRJK5040lKh/i24X9VFRn9j0DAufUUwfQcBbFP3la
         Z88KuHe2CPCmRF18dpZ3xHoVXM91Iibz0NcgSyPUGj9P6QvDko1CuxZd6bGhECq/uC4r
         8il+WcQub0GJ8/Sk8ATiI8TzN3XzIzg2blaYqcoRuenSpyio1nFgqwl+rbBRpHoV5kfc
         eeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=N/VqAqp6gLrZv99t4Njzo2cELtOAzHXSK8UPoavhuKQ=;
        b=BpGGwEBpRjtx92NJ4G0zgPHYwCfoGUJATgezPwOvkE6Q/y/A+zAm9YvBLhYz0gK/Z8
         85lkt5N9008UbW8ZVNz8bPoA4aXtyGuXXqu4qJtuZypfMSaeGdysq3p7XBp4KZlpjJpQ
         F4pXz22TiNV+Epr0fbXOGmRsJAMmIIQ7tnYHYdV2lGVNTD0TBhNpW/LHRYTpT6YGHIwh
         RCs8q9rwnRkx+muByGCyAufmNzgYK2QCLBWSB7ULw43wawDZlusFZsShUjVUGGE+D8vV
         Yid0G/XK14vsl22hKDkucjnuEpoumDR04zI/yrQabC0hoZsfEEZeXw2iewG6VmiKqSTQ
         YTaQ==
X-Gm-Message-State: AOAM530mzG/PqAYwLp6eqeCTGAxDlC0MJ3x7FqJWdoFiEo9OWP2aadbP
        hKQmG15KQMXxYKTVbIWaVQQIjHTofwzo
X-Google-Smtp-Source: ABdhPJxVGCsN92veaK7XgFpIeG5LFpswGfzkkUAPxNMiuzTEbr6kXLk7fUqQnVex+6LVlldWiThRI3baU2Ir
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a17:902:6b89:b0:154:623c:9517 with SMTP id
 p9-20020a1709026b8900b00154623c9517mr5803697plk.45.1647902651774; Mon, 21 Mar
 2022 15:44:11 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:53 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-5-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 4/9] KVM: x86/mmu: Replace vcpu argument with kvm pointer
 in make_spte
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No that nothing in make_spte actually needs the vCPU argument, just
pass in a pointer to the struct kvm. This allows the function to be used
in situations where there is no relevant struct vcpu.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 9 ++++-----
 arch/x86/kvm/mmu/spte.h | 2 +-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index ef2d85577abb..45e9c0c3932e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -90,7 +90,7 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+bool __make_spte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		 const struct kvm_memory_slot *slot, unsigned int pte_access,
 		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 		 bool can_unsync, bool host_writable, u64 mt_mask,
@@ -161,7 +161,7 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
+		if (mmu_try_to_unsync_pages(kvm, slot, gfn, can_unsync, prefetch)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			wrprot = true;
@@ -184,7 +184,7 @@ bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON(level > PG_LEVEL_4K);
-		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
+		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
 
 	*new_spte = spte;
@@ -202,10 +202,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	struct rsvd_bits_validate *shadow_zero_check =
 			&vcpu->arch.mmu->shadow_zero_check;
 
-	return __make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
+	return __make_spte(vcpu->kvm, sp, slot, pte_access, gfn, pfn, old_spte,
 			   prefetch, can_unsync, host_writable, mt_mask,
 			   shadow_zero_check, new_spte);
-
 }
 
 static u64 make_spte_executable(u64 spte)
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e8a051188eb6..cee02fe63429 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -410,7 +410,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+bool __make_spte(struct kvm *kvm, struct kvm_mmu_page *sp,
 		 const struct kvm_memory_slot *slot, unsigned int pte_access,
 		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 		 bool can_unsync, bool host_writable, u64 mt_mask,
-- 
2.35.1.894.gb6a874cedc-goog

