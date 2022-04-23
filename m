Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB0250C709
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 05:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbiDWDvK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 23:51:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232626AbiDWDvI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 23:51:08 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8A71BD5C4
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:13 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id p18-20020aa78612000000b0050d1c170018so441193pfn.15
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 20:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=UpDwvHE3te50hhADXZwRX35cXLlp2sOCZQHjdNcE0rc=;
        b=COJtGw4Wavj/9yPBesyN/SgXH/HIWMsbDBmf9ECoXEaMXvPup15jFuJN/PKGgWnlrB
         jXQrLxE14lurQzFajjzsr6+93rpNVy0pIwYNdg8JIDm7VJdeWKnfDokdHbFVGSsHe+gq
         eF20CJ8Xb1pTUI6pAPJPUM2864n/FJqbcrJ0YL6xAH5iQ+PvmulL5BGd3XB/HtKO6VhW
         e/DLavN3/K0BJ4walqhBRroYuU43zEWA3Pyp2XgG7MNM/htDDPvXuw+CNjngMubCA+ND
         3tuYU6togv1tI/lvupH9gh2cO0JI1qNgVAmez5RGIc2Yz1u2xisxETb4wB3qCtqDONdi
         iBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=UpDwvHE3te50hhADXZwRX35cXLlp2sOCZQHjdNcE0rc=;
        b=XWJ6yySjygHvTCkcAusnFgsXbn3Lnk7X+C0oYjeqVgLYJzPwx56akGEmdlj63Ap4fG
         P/nUYvw6TWwoEbKLTkXaETgcPZCfE4cTDjpFXQ3RTqx1uR71AiTOvjCCpEUAgQwECRYS
         m6xSwT3IvWjYVtPKWMA26DYYKmN8IqgT+YmICqdkYKnPK0mA7ir8FbsuOMXpQNnFykLk
         8pGooYsW0Jzq5BFNlHf5No20QoinHiRJElgAQlzhQZH7bk+KRS2XkaVkhqKe3ZlFlC93
         VI5vbziXljKQ1Ac5/D+MdyEa6bWudV6xHAoYsVAXLMSYgfzrcNcXaZEEw1y5dXwitMZ+
         95dw==
X-Gm-Message-State: AOAM5331ICwDKZtrtCdjDOIwyaPj3Wneu0FEAwERVtiiHsp60c1dbVbk
        g/XgqSK6MM38MT6yA9TMNIwwM43J3lg=
X-Google-Smtp-Source: ABdhPJyXteO9JqYc3L2JBj7BFHCj5A5q1lxAeJctmp3IloEpb2fcn+tkkeSHQ58pOpEy2m1zzPRxNbsLstQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:c14a:b0:15b:9c29:935a with SMTP id
 10-20020a170902c14a00b0015b9c29935amr7612387plj.2.1650685692822; Fri, 22 Apr
 2022 20:48:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 03:47:41 +0000
In-Reply-To: <20220423034752.1161007-1-seanjc@google.com>
Message-Id: <20220423034752.1161007-2-seanjc@google.com>
Mime-Version: 1.0
References: <20220423034752.1161007-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH 01/12] KVM: x86/mmu: Don't treat fully writable SPTEs as
 volatile (modulo A/D)
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Chao Peng <chao.p.peng@linux.intel.com>
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

Don't treat SPTEs that are truly writable, i.e. writable in hardware, as
being volatile (unless they're volatile for other reasons, e.g. A/D bits).
KVM _sets_ the WRITABLE bit out of mmu_lock, but never _clears_ the bit
out of mmu_lock, so if the WRITABLE bit is set, it cannot magically get
cleared just because the SPTE is MMU-writable.

Rename the wrapper of MMU-writable to be more literal, the previous name
of spte_can_locklessly_be_made_writable() is wrong and misleading.

Fixes: c7ba5b48cc8d ("KVM: MMU: fast path of handling guest page fault")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c  | 17 +++++++++--------
 arch/x86/kvm/mmu/spte.h |  2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 904f0faff218..612316768e8e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -481,13 +481,15 @@ static bool spte_has_volatile_bits(u64 spte)
 	 * also, it can help us to get a stable is_writable_pte()
 	 * to ensure tlb flush is not missed.
 	 */
-	if (spte_can_locklessly_be_made_writable(spte) ||
-	    is_access_track_spte(spte))
+	if (!is_writable_pte(spte) && is_mmu_writable_spte(spte))
+		return true;
+
+	if (is_access_track_spte(spte))
 		return true;
 
 	if (spte_ad_enabled(spte)) {
-		if ((spte & shadow_accessed_mask) == 0 ||
-	    	    (is_writable_pte(spte) && (spte & shadow_dirty_mask) == 0))
+		if (!(spte & shadow_accessed_mask) ||
+		    (is_writable_pte(spte) && !(spte & shadow_dirty_mask)))
 			return true;
 	}
 
@@ -554,7 +556,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	 * we always atomically update it, see the comments in
 	 * spte_has_volatile_bits().
 	 */
-	if (spte_can_locklessly_be_made_writable(old_spte) &&
+	if (is_mmu_writable_spte(old_spte) &&
 	      !is_writable_pte(new_spte))
 		flush = true;
 
@@ -1192,7 +1194,7 @@ static bool spte_write_protect(u64 *sptep, bool pt_protect)
 	u64 spte = *sptep;
 
 	if (!is_writable_pte(spte) &&
-	      !(pt_protect && spte_can_locklessly_be_made_writable(spte)))
+	    !(pt_protect && is_mmu_writable_spte(spte)))
 		return false;
 
 	rmap_printk("spte %p %llx\n", sptep, *sptep);
@@ -3171,8 +3173,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * be removed in the fast path only if the SPTE was
 		 * write-protected for dirty-logging or access tracking.
 		 */
-		if (fault->write &&
-		    spte_can_locklessly_be_made_writable(spte)) {
+		if (fault->write && is_mmu_writable_spte(spte)) {
 			new_spte |= PT_WRITABLE_MASK;
 
 			/*
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index ad8ce3c5d083..570699682f6d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -398,7 +398,7 @@ static inline void check_spte_writable_invariants(u64 spte)
 			  "kvm: Writable SPTE is not MMU-writable: %llx", spte);
 }
 
-static inline bool spte_can_locklessly_be_made_writable(u64 spte)
+static inline bool is_mmu_writable_spte(u64 spte)
 {
 	return spte & shadow_mmu_writable_mask;
 }
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

