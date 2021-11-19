Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C644579D1
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 00:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhKTABz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 19:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236254AbhKTAB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 19:01:26 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C07EAC06173E
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:23 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id a16-20020a17090aa51000b001a78699acceso7455234pjq.8
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 15:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WSjxVd+eIUHGILSD5cz53Ty6YrqZdmuc1hfDKll+vog=;
        b=QvwtB7h+duQXv3dzzrPANRhkI3y4CeNF7R9Z21cqkoZpgq4T8pL3s6G9edaV9bE8EV
         vpU0w7cWgje9IrgtkN+tdZ7QlxPoBRlfgNjPUqMm2sbDrsbOr/H8WZ+QsOKmL4UGV/Wv
         g5CDvpAGBFiGU2+JIjQp/IIaonmRkwSgO4wRilkGjKyx78GtLnIAS+QdkwkXDpxkYARJ
         lA+w9DMyFXDjUwsBRRrC0e/5U0LsmeqE7OwxeisO3e7XuVRM7XFvckMKG1/F8X/SbmvL
         C2fj53qUag/eCof8Ia53ZVMO0tWABU4En+GZx1WamrNay4xYslApyDEdKLjCrDmOTOJs
         dRSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WSjxVd+eIUHGILSD5cz53Ty6YrqZdmuc1hfDKll+vog=;
        b=iJQcVzNv2x+UEEh86/0GBrICfIx3bgihu5H8ffGivbKw3N7jkZboWS0eilhQb7vAYz
         xGqIGSVKeDC/ZamqLednp0FVL0UWkhHIK8krUXsm0vQYkfWmsyB14/FOwoPGZKXKXs2B
         b+m+lKaneZC3fhMu3gmVj93vCWQKXBlqe31rSQ0vy4MOg9JqbvNLPxZeODM4iPbvsXsA
         Tjsprwi3yCe+GziVtbSRxJWOlDyFE73AP4dgDoRgwil9/vyg2HhzQ29FAZEQ5ZhpaCO8
         s9ivPXT6St8KxVuXtUAz/cAQMfW73UNi4T5klozyTKHzh4xPnGlinsCTcb7Cp90WKxHD
         N+fw==
X-Gm-Message-State: AOAM5323sx/2oMzADjylvDEGszjizmWbbgF20mRXJoIOMkVEiRCh/Onm
        qHdMA4cx/atNLHClZ9RjitCXn+MVUhD/6g==
X-Google-Smtp-Source: ABdhPJxalh2bCjcDgQUc9QuZFQdQ9h6h3Ghsd3BB+2YaEjBodxA1MBl+2fDqDME4UqArL3EbXCW0bA84LJzy+w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:bc8b:b0:143:caf5:4a0e with SMTP
 id bb11-20020a170902bc8b00b00143caf54a0emr47960112plb.38.1637366303291; Fri,
 19 Nov 2021 15:58:23 -0800 (PST)
Date:   Fri, 19 Nov 2021 23:57:52 +0000
In-Reply-To: <20211119235759.1304274-1-dmatlack@google.com>
Message-Id: <20211119235759.1304274-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20211119235759.1304274-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [RFC PATCH 08/15] KVM: x86/mmu: Helper method to check for large and
 present sptes
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Consolidate is_large_pte and is_present_pte into a single helper. This
will be used in a follow-up commit to check for present large-pages
during Eager Page Splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.h    | 5 +++++
 arch/x86/kvm/mmu/tdp_mmu.c | 3 +--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index cc432f9a966b..e73c41d31816 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -257,6 +257,11 @@ static inline bool is_large_pte(u64 pte)
 	return pte & PT_PAGE_SIZE_MASK;
 }
 
+static inline bool is_large_present_pte(u64 pte)
+{
+	return is_shadow_present_pte(pte) && is_large_pte(pte);
+}
+
 static inline bool is_last_spte(u64 pte, int level)
 {
 	return (level == PG_LEVEL_4K) || is_large_pte(pte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ff4d83ad7580..f8c4337f1fcf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1011,8 +1011,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		 * than the target, that SPTE must be cleared and replaced
 		 * with a non-leaf SPTE.
 		 */
-		if (is_shadow_present_pte(iter.old_spte) &&
-		    is_large_pte(iter.old_spte)) {
+		if (is_large_present_pte(iter.old_spte)) {
 			if (!tdp_mmu_zap_spte_atomic(vcpu->kvm, &iter))
 				break;
 		}
-- 
2.34.0.rc2.393.gf8c9666880-goog

