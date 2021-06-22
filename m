Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED203B0C04
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 19:59:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232677AbhFVSBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232671AbhFVSAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:00:43 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2885DC061787
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:22 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id y17-20020ad445b10000b029027389e9530fso7397931qvu.4
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=w2Kt+/2qENUIrhf0LV790hqbhtHihwRSzE//krnionw=;
        b=WOP77fC3Ucs4V8/L6vxTB/JiH0DwuxnXT6BnGHWWO+6w3nDkR4dayPBlG3Kz4N3loF
         6nzwP4ABmUvOQGpc/ZfhyXvTlYr1PA0Rawxk9ENqAY1+PPF8ykvgWEShpq8lDijd/xYM
         O8InonsZbIK7zabxNSsdWGRH7t1GWgq2l95mMPwCDZF2HWTd2/XpVKflZTh2MyAbgTPK
         ytoKjzM1evJ4/sTgqtYZLGY8vuqRId3e7lLzVw/XWA1Bl74jWZ9DNBu7qtNyXEQ7vXwP
         vqo+f7q8R0IOtGVqimnpjc8SUNp3ILAzsUA2hr6NSWv+3cm+wWrD7D5Pd0VATPRSzsce
         dONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=w2Kt+/2qENUIrhf0LV790hqbhtHihwRSzE//krnionw=;
        b=lzruU7mwoNaw9eQusmnf1A84f044ilj5+9ThelfkLHRwHpU5V9JbrMHt8UDVvno0z6
         TFgsRaVmd3P/kV2q0ago6kBx5RNB82h/3jTZp0xGgyEJwzFYBh+LeftrRbeyfnkCfofl
         73EvWiSZ0JGTslRouL732e7w0P/AwrZrFlG6g2GC8DcJEw6Ln2jC7snBotcWCRNbhZLf
         bsxpZ0aKkpgqXpDhEY574nvZXwTGR+jr4EhV+o3q8zr235QCEpiLjAXXz+x8/Ip0QpNb
         T+U3SBgrQlsd148zg3czJARPHW499U/hdMuchD3oMPd/aVnB3Slc5Rj/lyOx2S3UDdaR
         qm3w==
X-Gm-Message-State: AOAM53173RTN1Juhfh1VzePcMFvFdkrsysf/37mVQ5BlNZ0eHVNswiXL
        1FK3nfmm8AZQQv0hbosXY0uSiOWRaa0=
X-Google-Smtp-Source: ABdhPJyYEvOaW0sEkmBKcm9Z+YODGpl5E/7J7NUNoQhsTWSaxBw75d9oUqOvwvow9P+dR7Wygfia25GCgF4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a25:ada5:: with SMTP id z37mr6434317ybi.415.1624384701324;
 Tue, 22 Jun 2021 10:58:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:56:56 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 11/54] KVM: x86/mmu: WARN and zap SP when sync'ing if MMU role mismatches
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When synchronizing a shadow page, WARN and zap the page if its mmu role
isn't compatible with the current MMU context, where "compatible" is an
exact match sans the bits that have no meaning in the overall MMU context
or will be explicitly overwritten during the sync.  Many of the helpers
used by sync_page() are specific to the current context, updating a SMM
vs. non-SMM shadow page would use the wrong memslots, updating L1 vs. L2
PTEs might work but would be extremely bizaree, and so on and so forth.

Drop the guard with respect to 8-byte vs. 4-byte PTEs in
__kvm_sync_page(), it was made useless when kvm_mmu_get_page() stopped
trying to sync shadow pages irrespective of the current MMU context.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         |  5 +----
 arch/x86/kvm/mmu/paging_tmpl.h | 27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9f277c5bab76..2e2d66319325 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1784,10 +1784,7 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 static bool __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 			    struct list_head *invalid_list)
 {
-	union kvm_mmu_page_role mmu_role = vcpu->arch.mmu->mmu_role.base;
-
-	if (sp->role.gpte_is_8_bytes != mmu_role.gpte_is_8_bytes ||
-	    vcpu->arch.mmu->sync_page(vcpu, sp) == 0) {
+	if (vcpu->arch.mmu->sync_page(vcpu, sp) == 0) {
 		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
 		return false;
 	}
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 52fffd68b522..b632606a87d6 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -1030,13 +1030,36 @@ static gpa_t FNAME(gva_to_gpa_nested)(struct kvm_vcpu *vcpu, gpa_t vaddr,
  */
 static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
+	union kvm_mmu_page_role mmu_role = vcpu->arch.mmu->mmu_role.base;
 	int i, nr_present = 0;
 	bool host_writable;
 	gpa_t first_pte_gpa;
 	int set_spte_ret = 0;
 
-	/* direct kvm_mmu_page can not be unsync. */
-	BUG_ON(sp->role.direct);
+	/*
+	 * Ignore various flags when verifying that it's safe to sync a shadow
+	 * page using the current MMU context.
+	 *
+	 *  - level: not part of the overall MMU role and will never match as the MMU's
+	 *           level tracks the root level
+	 *  - access: updated based on the new guest PTE
+	 *  - quadrant: not part of the overall MMU role (similar to level)
+	 */
+	const union kvm_mmu_page_role sync_role_ign = {
+		.level = 0xf,
+		.access = 0x7,
+		.quadrant = 0x3,
+	};
+
+	/*
+	 * Direct pages can never be unsync, and KVM should never attempt to
+	 * sync a shadow page for a different MMU context, e.g. if the role
+	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
+	 * reserved bits checks will be wrong, etc...
+	 */
+	if (WARN_ON_ONCE(sp->role.direct ||
+			 (sp->role.word ^ mmu_role.word) & ~sync_role_ign.word))
+		return 0;
 
 	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
 
-- 
2.32.0.288.g62a8d224e6-goog

