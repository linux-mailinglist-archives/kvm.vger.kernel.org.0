Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4818E23D14F
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgHET6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 15:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgHEQmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 12:42:12 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C490C0A893E;
        Wed,  5 Aug 2020 07:13:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so24507508pgh.3;
        Wed, 05 Aug 2020 07:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=K8w/qRSPiRGvQfAwvAEG9vaPeWJJC258oA4XZ+7V/5A=;
        b=avfgyGCIXlq9hgjbIhnPyKTrkyyn6mfx28wepMCd18SZQV5YadO4f1/77RoRfKQk/w
         7hWcQobOQlYZsmU2TThr1U1rcS3ZAskU+bXk3/esFuaDmWguaROHOw1cLPbwGvE6+A89
         1p3NirG7Bzxc9KqwFuMIfjKIyCoTMQJg5KyiOzVG8Nye336rAHCimiHnLxXpaMGXQtMB
         hPGvLgLKLBuRkqZF9u3VAhS7s9bCCoJNIYyBAtDVyMoKaBKn/xrYWoOcwJUn85+pe+bm
         4ECjc6m1GBH9UTj6EiCLRTBQ2TRgPvq9TVBlRLMoR4ger3biT7guANBuqaZw5bSsPlM2
         X8cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K8w/qRSPiRGvQfAwvAEG9vaPeWJJC258oA4XZ+7V/5A=;
        b=kJ9Fp0v3vBnoi2OsYraSNaAkTghC4u2689vM6s9P8NPjJI5cRlXdPE5wxnUtUhqgfS
         VPAsr2jeOJU6kChJoG8EbamKCE2Egilk+a584vgirK28wltcPkeyFxVK0SddChbrDtDc
         darTP/rrqVIujdsR0Y+LAttI8ykRznH+7iKEh3k/X/X5OUyr7DoQkZp3Yj7Lyp3/phUT
         koMW8mE5f/OMUI/IyTh1rOsPv8/Ui1VewrbfYZo7/xdC0mfdF3sDP/VOgCz8CZBrGbwr
         uBRIfLOHJLHmcRjwdJjbQ57rMVSV+ky4wCVah0eY4U3yTbvyvr7MOqoL0svknsnLMf6F
         +iyQ==
X-Gm-Message-State: AOAM533Skji63u14xl3E+l6IoIBnKwdYDEDhPR2G8dnWt9aUZhti/OIQ
        mKG8vZkR/Q04a2QxVcj5W70=
X-Google-Smtp-Source: ABdhPJwp7Pld0z9vhrmzbG+AcO5ZnyP1GtoGFHh+Zphz7eH956FtbmT0Oys2jB12nUif/4/UGozEYg==
X-Received: by 2002:a63:3816:: with SMTP id f22mr3228491pga.311.1596636822205;
        Wed, 05 Aug 2020 07:13:42 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.56])
        by smtp.gmail.com with ESMTPSA id a129sm4069834pfd.165.2020.08.05.07.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 07:13:41 -0700 (PDT)
From:   Yulei Zhang <yulei.kernel@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, xiaoguangrong.eric@gmail.com,
        kernellwp@gmail.com, lihaiwei.kernel@gmail.com,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC 5/9] Modify the page fault path to meet the direct build EPT requirement
Date:   Wed,  5 Aug 2020 22:14:31 +0800
Message-Id: <20200805141431.9137-1-yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yuleixzhang@tencent.com>

Refine the fast page fault code so that it can be used in either
normal ept mode or direct build EPT mode.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index df703deac928..b59a4502d1f6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3471,12 +3471,13 @@ static bool page_fault_can_be_fast(u32 error_code)
  * someone else modified the SPTE from its original value.
  */
 static bool
-fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, gpa_t gpa,
 			u64 *sptep, u64 old_spte, u64 new_spte)
 {
 	gfn_t gfn;
 
-	WARN_ON(!sp->role.direct);
+	WARN_ON(!vcpu->arch.direct_build_tdp &&
+		(!page_header(__pa(sptep))->role.direct));
 
 	/*
 	 * Theoretically we could also set dirty bit (and flush TLB) here in
@@ -3498,7 +3499,7 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * The gfn of direct spte is stable since it is
 		 * calculated by sp->gfn.
 		 */
-		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+		gfn = gpa >> PAGE_SHIFT;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
 	}
 
@@ -3526,10 +3527,10 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    u32 error_code)
 {
 	struct kvm_shadow_walk_iterator iterator;
-	struct kvm_mmu_page *sp;
 	bool fault_handled = false;
 	u64 spte = 0ull;
 	uint retry_count = 0;
+	int pte_level = 0;
 
 	if (!page_fault_can_be_fast(error_code))
 		return false;
@@ -3539,12 +3540,20 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	do {
 		u64 new_spte;
 
-		for_each_shadow_entry_lockless(vcpu, cr2_or_gpa, iterator, spte)
+		for_each_shadow_entry_lockless(vcpu, cr2_or_gpa, iterator, spte) {
 			if (!is_shadow_present_pte(spte))
 				break;
+		}
+
+		if (iterator.level < PT_PAGE_TABLE_LEVEL)
+			pte_level  = PT_PAGE_TABLE_LEVEL;
+		else
+			pte_level = iterator.level;
+
+		WARN_ON(!vcpu->arch.direct_build_tdp &&
+			(pte_level != page_header(__pa(iterator.sptep))->role.level));
 
-		sp = page_header(__pa(iterator.sptep));
-		if (!is_last_spte(spte, sp->role.level))
+		if (!is_last_spte(spte, pte_level))
 			break;
 
 		/*
@@ -3587,7 +3596,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			 *
 			 * See the comments in kvm_arch_commit_memory_region().
 			 */
-			if (sp->role.level > PT_PAGE_TABLE_LEVEL)
+			if (pte_level > PT_PAGE_TABLE_LEVEL)
 				break;
 		}
 
@@ -3601,7 +3610,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.txt to get more detail.
 		 */
-		fault_handled = fast_pf_fix_direct_spte(vcpu, sp,
+		fault_handled = fast_pf_fix_direct_spte(vcpu, cr2_or_gpa,
 							iterator.sptep, spte,
 							new_spte);
 		if (fault_handled)
@@ -4153,6 +4162,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (fast_page_fault(vcpu, gpa, error_code))
 		return RET_PF_RETRY;
 
+	if (vcpu->arch.direct_build_tdp)
+		return RET_PF_EMULATE;
+
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-- 
2.17.1

