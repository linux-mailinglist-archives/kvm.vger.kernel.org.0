Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D047D258ED5
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 15:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgIANDY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 09:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727061AbgIALzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 07:55:18 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B1CC061244;
        Tue,  1 Sep 2020 04:55:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so638518pfp.11;
        Tue, 01 Sep 2020 04:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=A6+zZK0PRKc1I+vce+8JY6xxs7Mg0NJgZr5FU/ZHS1w=;
        b=lKxgZz62BU3j99HgKaMmS/kCvom0NQclIiW3BMeCVMOx546mVt7GmWi2yH1oYB2+0C
         gQcDgTHmMr27FGuNwZzHoJFeZofywU7V1kFwbSTY90VH9LNAZYU/jXdcTNfp/ViWmz2/
         KxqR2zXOuyX2hsRiv19TGMVtaVaWrn1onLTxaFyk5QddY2wzCTbhRAtQHEyc8Ub0p/qu
         GaE64kRyCCDlg3rBf9f5mXSATnbtYB7B1uShIoOLX2PycNd1X0PBoLNqxUrONjN5lpio
         J+rSHfLBE5fqPt47o0lwRGKxOMLMLzbamV9uKurjgVsP7z3KIrHeCKL/3YGL8Bg1gXsv
         UuDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=A6+zZK0PRKc1I+vce+8JY6xxs7Mg0NJgZr5FU/ZHS1w=;
        b=cIzFQUXMLO3ZEkGn2TZnDJxtc+mvi5MH6rtrSnuSyY2H/VtHI8/nikfsrHal0o6i6L
         v5UIAACze8JrcvYQPFYTB8iXzWkMDGSNVMCkbt2txkrkVmOKF8IMR8Q/4F2I2O+ZGmZK
         WB6EDBm0Q5pMBzoZJDsCJoZzAlOAV/+8CzZhzBHQ71ic+4ZJEAhN7B7BOu6mQLATo2Bq
         T+PvtpDLqXtKli65G2GOngAeq192WWXj8LpSxTQf9SBHsWi7cwKmhSbS6Zxe1CAwdLB6
         UZ5BLpqNS74Mxn1Q406d7qIhFk+XkRe4kTRwj5bnfbqiX/xoEqoN03x2RzOtX14VTqBF
         DxOg==
X-Gm-Message-State: AOAM533KnytxOWY8H1zfTquDTbPR8oerxhfLHUL3j45VvK7HsR54BtQI
        IfglCo1zuGKhPOoOlKK1xh3MM4LrFIE=
X-Google-Smtp-Source: ABdhPJzv9nDY12Kx6kNi2WR6XHoPB47fiHDLEBw9WzZGmJXBQV1jqv719wSs1cSwwcVUSJhPfOoWyA==
X-Received: by 2002:a62:6503:: with SMTP id z3mr1497322pfb.132.1598961308884;
        Tue, 01 Sep 2020 04:55:08 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.53])
        by smtp.gmail.com with ESMTPSA id z17sm1737531pfq.38.2020.09.01.04.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 04:55:07 -0700 (PDT)
From:   yulei.kernel@gmail.com
X-Google-Original-From: yuleixzhang@tencent.com
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        junaids@google.com, bgardon@google.com, vkuznets@redhat.com,
        xiaoguangrong.eric@gmail.com, kernellwp@gmail.com,
        lihaiwei.kernel@gmail.com, Yulei Zhang <yulei.kernel@gmail.com>,
        Yulei Zhang <yuleixzhang@tencent.com>
Subject: [RFC V2 5/9] Modify the page fault path to meet the direct build EPT requirement
Date:   Tue,  1 Sep 2020 19:56:02 +0800
Message-Id: <4a5c67fea73a18661cf4918860606e5a19f11b78.1598868204.git.yulei.kernel@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1598868203.git.yulei.kernel@gmail.com>
References: <cover.1598868203.git.yulei.kernel@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yulei Zhang <yulei.kernel@gmail.com>

Refine the fast page fault code so that it can be used in either
normal ept mode or direct build EPT mode.

Signed-off-by: Yulei Zhang <yuleixzhang@tencent.com>
---
 arch/x86/kvm/mmu/mmu.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f2124f52b286..fda6c4196854 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3443,12 +3443,13 @@ static bool page_fault_can_be_fast(u32 error_code)
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
+		(!sptep_to_sp(sptep)->role.direct));
 
 	/*
 	 * Theoretically we could also set dirty bit (and flush TLB) here in
@@ -3470,7 +3471,8 @@ fast_pf_fix_direct_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * The gfn of direct spte is stable since it is
 		 * calculated by sp->gfn.
 		 */
-		gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
+
+		gfn = gpa >> PAGE_SHIFT;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
 	}
 
@@ -3498,10 +3500,10 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
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
@@ -3515,8 +3517,15 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			if (!is_shadow_present_pte(spte))
 				break;
 
-		sp = sptep_to_sp(iterator.sptep);
-		if (!is_last_spte(spte, sp->role.level))
+		if (iterator.level < PG_LEVEL_4K)
+			pte_level  = PG_LEVEL_4K;
+		else
+			pte_level = iterator.level;
+
+		WARN_ON(!vcpu->arch.direct_build_tdp &&
+			(pte_level != sptep_to_sp(iterator.sptep)->role.level));
+
+		if (!is_last_spte(spte, pte_level))
 			break;
 
 		/*
@@ -3559,7 +3568,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			 *
 			 * See the comments in kvm_arch_commit_memory_region().
 			 */
-			if (sp->role.level > PG_LEVEL_4K)
+			if (pte_level > PG_LEVEL_4K)
 				break;
 		}
 
@@ -3573,7 +3582,7 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 * since the gfn is not stable for indirect shadow page. See
 		 * Documentation/virt/kvm/locking.rst to get more detail.
 		 */
-		fault_handled = fast_pf_fix_direct_spte(vcpu, sp,
+		fault_handled = fast_pf_fix_direct_spte(vcpu, cr2_or_gpa,
 							iterator.sptep, spte,
 							new_spte);
 		if (fault_handled)
@@ -4106,6 +4115,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (fast_page_fault(vcpu, gpa, error_code))
 		return RET_PF_RETRY;
 
+	if (vcpu->arch.direct_build_tdp)
+		return RET_PF_EMULATE;
+
 	r = mmu_topup_memory_caches(vcpu, false);
 	if (r)
 		return r;
-- 
2.17.1

