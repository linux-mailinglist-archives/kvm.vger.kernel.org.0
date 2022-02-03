Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682914A7D2C
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348693AbiBCBB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348702AbiBCBB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:26 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE775C06173B
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:25 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id n9-20020a17090a73c900b001b5cafefa27so802091pjk.2
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=dG8lD0mSLVvxVjmwCeTPEOlVoMVFkHAjpgklC5C2hr0=;
        b=Tb+hFO3l/tZXXnLRSMyCx+rNoSddClKnj5+cIBYTAX0vggUv5HCtzn+HcKfOhB7MrN
         xaL3mPzE8ojn/7c0A5nqichAroxT2P6lMZBG61FhbSmQEIF+XngX22mnisK394gW6H0P
         Tz+W7qoBAa9uLRiHSXLiy4LuBcrlz07C4pcb1Vi+uY6Hb7p3oR2/duOwL343mZiH8K94
         y5+/HJURWK3eSZM8O+RIk7IfG56TI1Jw7lcDhUO0Qs4HdwdB/1i//tc8jHsIpXrAtNUh
         r//XLjNrkrIRIANgWt0m2gfIU38w8d64Tj6OPvgwE32/ULqgT88lynZKtItvWdd2JpTO
         rYHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=dG8lD0mSLVvxVjmwCeTPEOlVoMVFkHAjpgklC5C2hr0=;
        b=ztw1Rx8xX69zJCjOm3ZaSXOoaPYyOi4cB12V95qK56YPiytLSxboew/kQGAyKgHWUh
         HHi9wNqlSoMNI+/vKMN+6b5l2cYT1RN0oK3PlFqvY7oNA4RpRz0pez43ky/AAwdDJrbD
         dcrzqHp49MYy2/RApacdBgcCuAI6Xfo+clwil1W4JLVbjbi1Rcxq+6bf3Q+bgTUiloX+
         Qi2Oj6qt7y39v6UJb9omtNcs+/r7YY49OJrJ6tFMtDa4jtuAM46FPqGKjrSbn6TMBJh2
         dXgotj1IJ+Ez7kSBKoUyCXlOuVDqQydQ22PHGShOgOEdY5GmOndUaB29ksjRBI0b5WF9
         etcA==
X-Gm-Message-State: AOAM531fdWnjs3mor9rFI7jwFnU6qp9HG3XHNaBRbSii6JlAUr32D5kP
        fVjelSkxqtvJBaU2J319AolJR6BERR3VIQ==
X-Google-Smtp-Source: ABdhPJwKB7lDChWUDiVhb8aJ/SmbuUf4xyHtt90S1m7+3fNDfb7XbDiAptxnp2AmDTOh97DW70jPs75bCEElMQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:300d:: with SMTP id
 o13mr33031316pla.110.1643850085134; Wed, 02 Feb 2022 17:01:25 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:43 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-16-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 15/23] KVM: x86/mmu: Pass access information to make_huge_page_split_spte()
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently make_huge_page_split_spte() assumes execute permissions can be
granted to any 4K SPTE when splitting huge pages. This is true for the
TDP MMU but is not necessarily true for the shadow MMU. Huge pages
mapped by the shadow MMU may be shadowing huge pages that the guest has
disallowed execute permissions.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/spte.c    | 5 +++--
 arch/x86/kvm/mmu/spte.h    | 3 ++-
 arch/x86/kvm/mmu/tdp_mmu.c | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 20cf9e0d45dd..7cba5cffc240 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -215,7 +215,8 @@ static u64 make_spte_executable(u64 spte)
  * This is used during huge page splitting to build the SPTEs that make up the
  * new page table.
  */
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
+			      unsigned int access)
 {
 	u64 child_spte;
 	int child_level;
@@ -243,7 +244,7 @@ u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index)
 		 * When splitting to a 4K page, mark the page executable as the
 		 * NX hugepage mitigation no longer applies.
 		 */
-		if (is_nx_huge_page_enabled())
+		if (is_nx_huge_page_enabled() && (access & ACC_EXEC_MASK))
 			child_spte = make_spte_executable(child_spte);
 	}
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..c7ccdd5c440d 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -415,7 +415,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
 	       u64 old_spte, bool prefetch, bool can_unsync,
 	       bool host_writable, u64 *new_spte);
-u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index);
+u64 make_huge_page_split_spte(u64 huge_spte, int huge_level, int index,
+			      unsigned int access);
 u64 make_nonleaf_spte(u64 *child_pt, bool ad_disabled);
 u64 make_mmio_spte(struct kvm_vcpu *vcpu, u64 gfn, unsigned int access);
 u64 mark_spte_for_access_track(u64 spte);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 34c451f1eac9..02bfbc1bebbe 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1310,7 +1310,7 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	 * not been linked in yet and thus is not reachable from any other CPU.
 	 */
 	for (i = 0; i < PT64_ENT_PER_PAGE; i++)
-		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i);
+		sp->spt[i] = make_huge_page_split_spte(huge_spte, level, i, ACC_ALL);
 
 	/*
 	 * Replace the huge spte with a pointer to the populated lower level
-- 
2.35.0.rc2.247.g8bbb082509-goog

