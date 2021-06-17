Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AF83ABF4C
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhFQXWK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232904AbhFQXWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:22:09 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CE8C061574
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:20:00 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id b23-20020a17090ae397b0290163949acb4dso5505288pjz.9
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=q3OMF5TZcGvzvXMBtYYHIDqrzCzLQc2VyhrpFeWf3GY=;
        b=dAN9TmPWyzZdxsuMCsUhrRO7Myowk4jVSEWLE4GJ/aNX01VyPiRwGcBrk+/ixjkzKL
         b3XwGrScxCmV37BAfM7/NtW1qdoMB8P0HCgT6YB7g398HbksxKhUajIOmFhrWhVNbXL2
         bR1nhOvFH3QlaV/Vfmky3hLimqxpaNsz1xLYDfmTG+WohDSk/InIGM8EAWb27pYfH5uI
         kgosm4jxOhGSOslRoHDmrFnhZMQXQdiHfxtu4yF3KwMur2y9QFc6MPiGKoJUolovktjG
         3rpzUCoCxS+fIZ1LugZbk6TLcltF4MhPTJEOq5m3iGgW4hqg2F+Dz7p842ajTghM1p5T
         9/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=q3OMF5TZcGvzvXMBtYYHIDqrzCzLQc2VyhrpFeWf3GY=;
        b=bUjYl1skCnC1oBidfCj+sbrdXWjNXpZ7C8aI47xUl4jK6SBJ7QvluIsHgag9cdj2oJ
         QekbSFdHFLjjf6zIEx5slwQ/QEmqxCLcQgOgDi5El5DbPH1eqlNjR/kuwPPSM2s77B/Y
         4yZgNqPi1GHBS8NdSaQ2+FHBh5Zp/EUIbfGNGA7K6RSPQeD3FdRnWw98Y/3YCfmgwKdr
         HaXzvJqgdhajoO0dx7TU+92famco/exZjTUlcKcHNLVk7UlHL6SrQWJv13mUGWfUkQkv
         UpwKjSvUmw2zV3a+LhO69g3MYtYRXsxfhPfBLNLJG3IeABrhcpFzhAmrIHwYGiewtPvE
         98WQ==
X-Gm-Message-State: AOAM533em24gyQxA6sE4g4MGvm+Gsa7PaEr4sPTVapJQt9uS7e47VISL
        gaCdwoZ2lRv6nIlS7DwCdApOklOV5ceDnEh+VNISWyvBwf4Se9IPu/dzTl48J44RyyObDtw8jvh
        ++2cJVgrlXVaT8EKM8g/0+mAmP9kwNeENaBrzMsg33cnrAtzAn4iqsiFeoy4rnY4=
X-Google-Smtp-Source: ABdhPJwOlYyJKwE4uxmdp04wSHMxVwudq58zMUJNop78b23hlFHC/gxM8COzZgWLJWYDx5r2RrmtGz/WsTqJJw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:8589:: with SMTP id
 m9mr18544267pjn.168.1623972000085; Thu, 17 Jun 2021 16:20:00 -0700 (PDT)
Date:   Thu, 17 Jun 2021 23:19:47 +0000
In-Reply-To: <20210617231948.2591431-1-dmatlack@google.com>
Message-Id: <20210617231948.2591431-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20210617231948.2591431-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 3/4] KVM: x86/mmu: Refactor is_tdp_mmu_root into is_tdp_mmu
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

This change simplifies the call sites slightly and also abstracts away
the implementation detail of looking at root_hpa as the mechanism for
determining if the mmu is the TDP MMU.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 4 ++--
 arch/x86/kvm/mmu/tdp_mmu.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e6bf2e207f6..4a4580243210 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3545,7 +3545,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		return reserved;
 	}
 
-	if (is_tdp_mmu_root(vcpu->arch.mmu->root_hpa))
+	if (is_tdp_mmu(vcpu->arch.mmu))
 		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
 		leaf = get_walk(vcpu, addr, sptes, &root);
@@ -3717,7 +3717,7 @@ static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 			     bool prefault, int max_level, bool is_tdp)
 {
-	bool is_tdp_mmu_fault = is_tdp_mmu_root(vcpu->arch.mmu->root_hpa);
+	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	bool write = error_code & PFERR_WRITE_MASK;
 	bool map_writable;
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 843ca2127faf..a63e35378e43 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -91,9 +91,10 @@ static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 #endif
 
-static inline bool is_tdp_mmu_root(hpa_t hpa)
+static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 {
 	struct kvm_mmu_page *sp;
+	hpa_t hpa = mmu->root_hpa;
 
 	if (WARN_ON(!VALID_PAGE(hpa)))
 		return false;
-- 
2.32.0.288.g62a8d224e6-goog

