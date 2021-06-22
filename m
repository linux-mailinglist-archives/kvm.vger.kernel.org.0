Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F83B0C5F
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 20:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhFVSHb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 14:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232649AbhFVSGs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 14:06:48 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFBFAC035468
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:55 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id 44-20020aed30af0000b029024e8ccfcd07so74271qtf.11
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 10:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=wT/dm8cE+d6lo3Bb4AloJvwz2DyF/vxG+6pSp7piqUc=;
        b=vODvpVd/aV/+C3hrbB7LmkOt9TLPWBJrnp4HDVmBSvtNkk/XhhwpGqRjmD8LQ35TYx
         aT46oCsvARGg8Y5XqWGcw6dBr/OLNgdXh4giv0iKHCsBCcz840knZGUdWNINCm4EjA/x
         41kz3dKNZpETycko4uTAKjq2E353Sxmw48wwPD/oLASTXbydu7qaNtnCBa1bgFjgjrue
         9NgRt4OyM+lKsurHIcEyGRLKgQMeC3uujOBdv+FzfHMrm93Kl1iEf7Ykni8GAapvLSwY
         eORtAZ0tMxLhWrxhzuUcNA223E9vR6Af6t7klIQlyZaZYAiU0msihVOK7EDbwAWhOrDP
         2cJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=wT/dm8cE+d6lo3Bb4AloJvwz2DyF/vxG+6pSp7piqUc=;
        b=sbt8pO/XuD7Xa6r9zs4bYVEZCxsqr6irnB3zGUDOqxFPMU7LRHFmYRWvJ19S5wciPA
         ypTBfnXixHTNuefYwF94unsWty6tSxxfRdNypN1XWZ4GaeSk13QRTw0y3VsBAOhOStdQ
         jPqO+ZzoUURCCw2o8HHHhtyYvbaQ8g9xh54JSGLh+95uo4+o9DR+WRAICP9ylH9WkwAH
         GwfOd7+Pf6R4FpZav6LOWdkXn+dDgrMAo2j/SoPPADWwrYu1F67EIeEsvRVhs+Vt6w+r
         5hOLYp4Dmv6oqq9E0vcfmEs1H1E1V1AtGJvJ8YjkBaWHpHzl1AGWUz4WPi9+nw1E94RB
         L1hA==
X-Gm-Message-State: AOAM532k7t9NrnW0mNVww0/NKdMkJIX0bvQDXTvGqBtKWltxdyI0U0FR
        WdUnDKT2srmNA4dU1d/YQgDYdwG2YYk=
X-Google-Smtp-Source: ABdhPJzrVPF6qRfoHU/js/FPcvbFY8LsAicQYbANz8g6CGZgDt5fVOp0cv0lfhr2lG5KFLK0p88JNOQuxf4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:5722:92ce:361f:3832])
 (user=seanjc job=sendgmr) by 2002:a05:6214:c6b:: with SMTP id
 t11mr26682145qvj.31.1624384794991; Tue, 22 Jun 2021 10:59:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 10:57:37 -0700
In-Reply-To: <20210622175739.3610207-1-seanjc@google.com>
Message-Id: <20210622175739.3610207-53-seanjc@google.com>
Mime-Version: 1.0
References: <20210622175739.3610207-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 52/54] KVM: x86/mmu: Get CR0.WP from MMU, not vCPU, in shadow
 page fault
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

Use the current MMU instead of vCPU state to query CR0.WP when handling
a page fault.  In the nested NPT case, the current CR0.WP reflects L2,
whereas the page fault is shadowing L1's NPT.  Practically speaking, this
is a nop a NPT walks are always user faults, but fix it up for
consistency.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h             | 5 -----
 arch/x86/kvm/mmu/paging_tmpl.h | 5 ++---
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 62844bacd13f..83e6c6965f1e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -165,11 +165,6 @@ static inline bool is_writable_pte(unsigned long pte)
 	return pte & PT_WRITABLE_MASK;
 }
 
-static inline bool is_write_protection(struct kvm_vcpu *vcpu)
-{
-	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
-}
-
 /*
  * Check if a given access (described through the I/D, W/R and U/S bits of a
  * page fault error code pfec) causes a permission fault with the given PTE
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index ec1de57f3572..260a9c06d764 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -795,7 +795,7 @@ FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
 	bool self_changed = false;
 
 	if (!(walker->pte_access & ACC_WRITE_MASK ||
-	      (!is_write_protection(vcpu) && !user_fault)))
+	    (!is_cr0_wp(vcpu->arch.mmu) && !user_fault)))
 		return false;
 
 	for (level = walker->level; level <= walker->max_level; level++) {
@@ -893,8 +893,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
 	 * we will cache the incorrect access into mmio spte.
 	 */
 	if (write_fault && !(walker.pte_access & ACC_WRITE_MASK) &&
-	     !is_write_protection(vcpu) && !user_fault &&
-	      !is_noslot_pfn(pfn)) {
+	    !is_cr0_wp(vcpu->arch.mmu) && !user_fault && !is_noslot_pfn(pfn)) {
 		walker.pte_access |= ACC_WRITE_MASK;
 		walker.pte_access &= ~ACC_USER_MASK;
 
-- 
2.32.0.288.g62a8d224e6-goog

