Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5EF33A4B7A
	for <lists+kvm@lfdr.de>; Sat, 12 Jun 2021 01:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFKX72 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 19:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhFKX72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Jun 2021 19:59:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1BDC061574
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:21 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g9-20020a25ae490000b029052f9e5b7d3fso6357724ybe.4
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 16:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OMqXSsbUPy1mE5TkMzPWO/uoFpvb3vaQpXE4qPNr8II=;
        b=LfuLk077tzr0eaOz3LfPD9uMxSH+qmrjvOZvqQRucLbXdwkGyNpPao9ajwRjLK8l2U
         kpbw0e2r6WOf6CE+13+AoW+vrJuP32SwQBmBOEUXinN2hf5sTmamp36UAtg8HNuJ33Gj
         +QydKTadKcb+7spufQH61hy53Ncge2QsnZRB+LmyYvxiAWAbbevR3hlrTNWhXY9cWCPk
         F5I/2mtHLu9vCL9YD2tmxLdsb6BGskAL9rNkqhqkAQnXg1ys8K4PUJN8OpvhFQmZlYtv
         Sx/hSByJ7FzlBqGaOSlwMCE+P1XJxwwI1U1u6Rjm3uAnZTC2X746r2wRB9Pl6VdSlLJ/
         EhLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OMqXSsbUPy1mE5TkMzPWO/uoFpvb3vaQpXE4qPNr8II=;
        b=nqLU6IwuTUN3a1koFp0o2pUk6Fc4IGOGFpWTaI0qUG3lVa6zflQQiINZ7R6i2DucCY
         nTh0I0t50ZkA7Wyst6rxMBAKSc06Du2UAtHy5VVmfq7mMhN6i/IdsXhHXaDQlk4xYA+3
         moMDj3BgoRndUZ/sCVYaQc6FrZpBOWneE+QF+RZNR0SyG/jeg553mKgkvYOQw+JOM4C2
         LzOg9Ary9LdoI7bqumhZolMK6Af5mLN42ntK2SUmw7qyTT0yXlpPdVfQYsEMTjOiy3Hw
         pRWJESQzIf+XCdQv3wmdP8/TmdyaFGPBfrf6a3CqorGD4KkT3U/FSWo1uWZvDwq9MpHf
         qqJw==
X-Gm-Message-State: AOAM5323fcmL0fXXH2WONGm3OhPOIWBkqaQuSi8CPjY4mKv85MBu076z
        DGT6mmCUnb4LYoeZB1dwXNWwCtee0nKi+rugQU4mZOgP2sVTJHYhNnHEZVIsBsUDgmJkLZ23q6I
        iPVq6msJ0GOKExdRXPxa8wsQTNAnRX9tTFwveIknxGsSEiwA06E0Ia1TCMkHcEjo=
X-Google-Smtp-Source: ABdhPJwMsMZPNFxRSpRXIDJFRq8IlTvkO7sDTVRyVAX0QMccusSmhvTSXkJou42ip06mmtNJmNRhVWKfsggy4Q==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a25:7109:: with SMTP id
 m9mr9688589ybc.274.1623455840709; Fri, 11 Jun 2021 16:57:20 -0700 (PDT)
Date:   Fri, 11 Jun 2021 23:56:54 +0000
In-Reply-To: <20210611235701.3941724-1-dmatlack@google.com>
Message-Id: <20210611235701.3941724-2-dmatlack@google.com>
Mime-Version: 1.0
References: <20210611235701.3941724-1-dmatlack@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH 1/8] KVM: x86/mmu: Refactor is_tdp_mmu_root()
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor is_tdp_mmu_root() into is_vcpu_using_tdp_mmu() to reduce
duplicated code at call sites and make the code more readable.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c     | 10 +++++-----
 arch/x86/kvm/mmu/tdp_mmu.c |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.h |  8 +++++---
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..eccd889d20a5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3545,7 +3545,7 @@ static bool get_mmio_spte(struct kvm_vcpu *vcpu, u64 addr, u64 *sptep)
 		return reserved;
 	}
 
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_vcpu_using_tdp_mmu(vcpu))
 		leaf = kvm_tdp_mmu_get_walk(vcpu, addr, sptes, &root);
 	else
 		leaf = get_walk(vcpu, addr, sptes, &root);
@@ -3729,7 +3729,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (page_fault_handle_page_track(vcpu, error_code, gfn))
 		return RET_PF_EMULATE;
 
-	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
+	if (!is_vcpu_using_tdp_mmu(vcpu)) {
 		r = fast_page_fault(vcpu, gpa, error_code);
 		if (r != RET_PF_INVALID)
 			return r;
@@ -3751,7 +3751,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	r = RET_PF_RETRY;
 
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_vcpu_using_tdp_mmu(vcpu))
 		read_lock(&vcpu->kvm->mmu_lock);
 	else
 		write_lock(&vcpu->kvm->mmu_lock);
@@ -3762,7 +3762,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 	if (r)
 		goto out_unlock;
 
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_vcpu_using_tdp_mmu(vcpu))
 		r = kvm_tdp_mmu_map(vcpu, gpa, error_code, map_writable, max_level,
 				    pfn, prefault);
 	else
@@ -3770,7 +3770,7 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 prefault, is_tdp);
 
 out_unlock:
-	if (is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa))
+	if (is_vcpu_using_tdp_mmu(vcpu))
 		read_unlock(&vcpu->kvm->mmu_lock);
 	else
 		write_unlock(&vcpu->kvm->mmu_lock);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 237317b1eddd..f4cc79dabeae 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -979,7 +979,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 
 	if (WARN_ON(!VALID_PAGE(vcpu->arch.mmu->root_hpa)))
 		return RET_PF_RETRY;
-	if (WARN_ON(!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)))
+	if (WARN_ON(!is_vcpu_using_tdp_mmu(vcpu)))
 		return RET_PF_RETRY;
 
 	level = kvm_mmu_hugepage_adjust(vcpu, gfn, max_level, &pfn,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 5fdf63090451..c8cf12809fcf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -91,16 +91,18 @@ static inline bool is_tdp_mmu_enabled(struct kvm *kvm) { return false; }
 static inline bool is_tdp_mmu_page(struct kvm_mmu_page *sp) { return false; }
 #endif
 
-static inline bool is_tdp_mmu_root(struct kvm *kvm, hpa_t hpa)
+static inline bool is_vcpu_using_tdp_mmu(struct kvm_vcpu *vcpu)
 {
+	struct kvm *kvm = vcpu->kvm;
 	struct kvm_mmu_page *sp;
+	hpa_t root_hpa = vcpu->arch.mmu->root_hpa;
 
 	if (!is_tdp_mmu_enabled(kvm))
 		return false;
-	if (WARN_ON(!VALID_PAGE(hpa)))
+	if (WARN_ON(!VALID_PAGE(root_hpa)))
 		return false;
 
-	sp = to_shadow_page(hpa);
+	sp = to_shadow_page(root_hpa);
 	if (WARN_ON(!sp))
 		return false;
 
-- 
2.32.0.272.g935e593368-goog

