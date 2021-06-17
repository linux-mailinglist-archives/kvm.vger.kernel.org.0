Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072A53ABF4D
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhFQXWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbhFQXWL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:22:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C480C061574
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:20:02 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y17-20020a17090aa411b02901649daab2b1so4236357pjp.5
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XWHGPcravhGhTAyO8386YDif3tw3JT3HgF/phaVp8zY=;
        b=fI/MTvGa8Ew0kXrtJpvptwgy7qIxwSRLRboX3MJFkirQDuA3gqfIPSvZvwewTUxXDR
         n2EJJ+sD5MyfUwLA0I1wGgVfiXUm8nxLElase8HFD8c41pjn6StclWBjzsSu/XNglXFo
         h+SIs5n0PSNwIZA5O3IGuBkD5aEyt8XSHDIXB1yPPMHu8t69LGGmDRhVOBt8l2CQ6AXX
         O6flhhry8YSE2OQeNG0uOJ0zxkooUvlZsLc/mdnVKdKL9+EiJvpFIZmda8GLffXPVQ7S
         D/itKomuYfW5J4UzAWlWGPSkB8di79+rvojmXNgRIDsHUmpGZ83ncYW44mK2B1JyB/lY
         jyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XWHGPcravhGhTAyO8386YDif3tw3JT3HgF/phaVp8zY=;
        b=pz9KnkK3OT80r0v/FeWt56/5h9Q93jJdu/opSnl/we3Xi8/nvpAHpMt40qGiFite5Z
         sM2k+g9aN4NJi5xb/WpJB3H66bguQem0/dc8+VAc/ITG9e6SFfO9yf7i5CUXJ2XEUbCf
         ZSLVUEgUqsjv/6iDjk0ATswP9dhkvEav+yGmbwu7/5V4IMgzELkMV0BS5PCQS3Vn4aBc
         NE06JzzPrkT2iWDung0xtg4fRwoSTCvzTNFPnV5re3PphOUhkiTbdUGUNtlqvt3D1zq7
         4wQofwbqqYMAWYxIR2qdccAEW/aTXadr9o/b3vxtjd5pX3dKqvTsQsE3JGong/oLYqVi
         3OAQ==
X-Gm-Message-State: AOAM531RubSCyjHQwkk896PhqFE4GlJLTyuYCy/PQLDt6gF4A2ucpgCc
        TA8Yp9jLa/gPUQE6L5nl10blMeT4UpnfzFkfDP0ooPhPNTqBtjbcSTlJWYdS+R90BWPCDiGHbwQ
        OEfj8jKIXIEyjm7eQUmxJly/IKxEnRHdJXaT3oSidhMYmBIKUFb9Cm1gpg5nVjMI=
X-Google-Smtp-Source: ABdhPJwhUoEbdeMp24kbOo1twepcQ+Me0xy1ZH3YuuF2bsPWKxMr2UiLEacWb01hmMcDvCjmqix5ssO4WVu05w==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:17e7:: with SMTP id
 q94mr7732437pja.117.1623972001484; Thu, 17 Jun 2021 16:20:01 -0700 (PDT)
Date:   Thu, 17 Jun 2021 23:19:48 +0000
In-Reply-To: <20210617231948.2591431-1-dmatlack@google.com>
Message-Id: <20210617231948.2591431-5-dmatlack@google.com>
Mime-Version: 1.0
References: <20210617231948.2591431-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 4/4] KVM: x86/mmu: Remove redundant root_hpa checks
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The root_hpa checks below the top-level check in kvm_mmu_page_fault are
theoretically redundant since there is no longer a way for the root_hpa
to be reset during a page fault. The details of why are described in
commit ddce6208217c ("KVM: x86/mmu: Move root_hpa validity checks to top
of page fault handler")

__direct_map, kvm_tdp_mmu_map, and get_mmio_spte are all only reachable
through kvm_mmu_page_fault, therefore their root_hpa checks are
redundant.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 8 --------
 arch/x86/kvm/mmu/tdp_mmu.c | 3 ---
 2 files changed, 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4a4580243210..2e36430e54e6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2827,9 +2827,6 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	gfn_t base_gfn = gfn;
 
-	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
-		return RET_PF_RETRY;
-
 	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
 					huge_page_disallowed, &req_level);
 
@@ -3540,11 +3537,6 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 	int root, leaf, level;
 	bool reserved = false;
 
-	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa)) {
-		*sptep = 0ull;
-		return reserved;
-	}
-
 	if (is_tdp_mmu(vcpu->arch.mmu))
 		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 5888f2ba417c..fa436a4ae01d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -977,9 +977,6 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	int level;
 	int req_level;
 
-	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
-		return RET_PF_RETRY;
-
 	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
 					huge_page_disallowed, &req_level);
 
-- 
2.32.0.288.g62a8d224e6-goog

