Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F904FA0C3
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 02:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240237AbiDIAl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 20:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240204AbiDIAlS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 20:41:18 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243A3CA6F0
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 17:39:01 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id u3-20020a632343000000b0039cac94652aso5037484pgm.11
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 17:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=U/xA/nSwurkGEdck/qaZkekmuGCzTuPGUBnd/eefe1E=;
        b=GRCcf0ghzrfbbfGPqwY8gcMpS9q954jGN54lbHMgexFfT28hQ7wCe/1fMEsMACZJLG
         wme9uxgGTLpC9IJ4eTZ4wcSG2DUeRLKZIkHNMncuDLYJ2/sTA6fTZlaY5U/tpm8Vu+30
         rvBeNLWZkKtk1FS9FfiSLYHuPY6iRwRovKOEPPKgs8/Qcd4iXizLjzQ25wl8AE3SVwnC
         Ex8AR1Ibxo4/MBl9xzZKBDYnrd5V2bYSHlgsRaZEHyXqlBxjA1+1d83VrYtyQpY9dFJK
         W1J9cSDqLj0Nmsxdl/jbgT6p9P9IOIOR5SGAvkAfvqxUN/oERnvTlipraI97zVJdnQob
         Diwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=U/xA/nSwurkGEdck/qaZkekmuGCzTuPGUBnd/eefe1E=;
        b=SXkepS+AacanZ4IDA2j+rxLpKvpX9TSYz99y97ZxQOT/prFKZ8E/GW22o2umP6o8+j
         NyAQCYIUYQS2iUwHaOK5iV2179o2WZC8qeD5/HpcvlbxXShkA+Grfkqjp73oplYboV6v
         suRj1M/aakcN4hhenqv/GSGaDu8DlRsgAQH2dmMOpja3F8KRJY+dQdjz4bpCrtvsy41n
         O9yVDKkjVCBuoeo0EJfffRwbeQ83zJXwNURrbIieGbIVQysx3eEcV/Aq8VxUOAePm//E
         jUtzjUXdel8k/G26giWIe6am+mP24swA+mJQzqFitLTUZ5P8Z8koPv+aZqDzAsxmug0K
         m0NA==
X-Gm-Message-State: AOAM531YwX5HhSgnldUXSOE97wv2bX8eG/6sJiNgI2Frb6amPNkwgNmv
        fvvjajX86853IznREVx+k6+ELD7y8Sw=
X-Google-Smtp-Source: ABdhPJzWm5cixOoYwZ2jCRkmulJdgu38wIoabB2kELlK12VuaYj5Ty1y/Ha2+rY56TAZL+3b/KTvyUsyzS4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:c94:b0:4fa:e134:4e6f with SMTP id
 a20-20020a056a000c9400b004fae1344e6fmr21792503pfv.66.1649464740605; Fri, 08
 Apr 2022 17:39:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  9 Apr 2022 00:38:47 +0000
In-Reply-To: <20220409003847.819686-1-seanjc@google.com>
Message-Id: <20220409003847.819686-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220409003847.819686-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH 6/6] KVM: x86/mmu: explicitly check nx_hugepage in disallowed_hugepage_adjust()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
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

From: Mingwei Zhang <mizhang@google.com>

Explicitly check if a NX huge page is disallowed when determining if a page
fault needs to be forced to use a smaller sized page. KVM incorrectly
assumes that the NX huge page mitigation is the only scenario where KVM
will create a shadow page instead of a huge page. Any scenario that causes
KVM to zap leaf SPTEs may result in having a SP that can be made huge
without violating the NX huge page mitigation. E.g. disabling of dirty
logging, zapping from mmu_notifier due to page migration, guest MTRR
changes that affect the viability of a huge page, etc...

Fixes: b8e8c8303ff2 ("kvm: mmu: ITLB_MULTIHIT mitigation")
Signed-off-by: Mingwei Zhang <mizhang@google.com>
[sean: add barrier comments, use spte_to_sp()]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 17 +++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c |  6 ++++++
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8b4f3550710a..c6f018c6d2f5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2908,6 +2908,19 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 	    cur_level == fault->goal_level &&
 	    is_shadow_present_pte(spte) &&
 	    !is_large_pte(spte)) {
+		u64 page_mask;
+
+		/*
+		 * Ensure nx_huge_page_disallowed is read after checking for a
+		 * present shadow page.  A different vCPU may be concurrently
+		 * installing the shadow page if mmu_lock is held for read.
+		 * Pairs with the smp_wmb() in kvm_tdp_mmu_map().
+		 */
+		smp_rmb();
+
+		if (!spte_to_sp(spte)->nx_huge_page_disallowed)
+			return;
+
 		/*
 		 * A small SPTE exists for this pfn, but FNAME(fetch)
 		 * and __direct_map would like to create a large PTE
@@ -2915,8 +2928,8 @@ void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_
 		 * patching back for them into pfn the next 9 bits of
 		 * the address.
 		 */
-		u64 page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
-				KVM_PAGES_PER_HPAGE(cur_level - 1);
+		page_mask = KVM_PAGES_PER_HPAGE(cur_level) -
+			    KVM_PAGES_PER_HPAGE(cur_level - 1);
 		fault->pfn |= fault->gfn & page_mask;
 		fault->goal_level--;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d0e6b341652c..5cae5cdcfcbc 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1185,6 +1185,12 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			tdp_mmu_init_child_sp(sp, &iter);
 
 			sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
+			/*
+			 * Ensure nx_huge_page_disallowed is visible before the
+			 * SP is marked present, as mmu_lock is held for read.
+			 * Pairs with the smp_rmb() in disallowed_hugepage_adjust().
+			 */
+			smp_wmb();
 
 			if (tdp_mmu_link_sp(kvm, &iter, sp, true)) {
 				tdp_mmu_free_sp(sp);
-- 
2.35.1.1178.g4f1659d476-goog

