Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71BA432DED5
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhCEBLO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCEBLO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:14 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0699C061574
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:13 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id e9so174258qvf.21
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=K8AhprUmOUnoVow3QoDb0P3U2ocrp0Lj4++kLQ400/Y=;
        b=VFYT7tWkcgjtrx9pCym1KVbaXpHcUfG/Mnj/zrzk0Xs9QJWbaW5mGlk0dxJ6pSYc2i
         /hAc2E3MUJpYXLab9PEal3+KIpetekVMUpCZZ59Yt9+gSpKWy6uvaetcwtBboscWrK5x
         v5vFwWao1zsiEnJCHmrUH+pMxXwK9Phq45ItsyUVdIAkkOHchtR7spV749sT+pcxOhuI
         wKkOUCBQnhZ3ZnXSQbokvu9mGjeCoSUX9q/bfXjAfBACPKQfN+7D4Uk9heNejihJdQNN
         HJLQ+Xe4sOy0OWQgf91ZNVWF9We2XFlO8QdYVZoASCM8Srz4kJMueYeMcx+hcqz/gisb
         b9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=K8AhprUmOUnoVow3QoDb0P3U2ocrp0Lj4++kLQ400/Y=;
        b=fITYxXLezfVhnV05fEhcugzQ32DYOxL7cGtlo+LmkNXcZ2oLMlKI61nhpkt/y+/syX
         qiJN2a1G6YXaMS2pFZKZEsFNjo7xrL6sO96S/5T05F0va5o95sStLsV732iNmvG13987
         h3j9TcUfVv9a5+KWlZzOgo8hFzYaGzb+l6+H1c3qblltnLyQT2PdRBklj+7qgXi/sn+A
         +w+KDKlb3+RVFoOoiB+vglBxZ2F3zD5D8kB3Qo8pPimGsy5mnr9ZVTKOc/aSKnjaTygy
         Wb3hpFSDbrptZX6LE5tjRg0r2Pdd8JiZmm6g90L5u7JU4wrbnorDYDPYeYMZ25lLybnf
         dGVw==
X-Gm-Message-State: AOAM533ZnKiCcKNdsYeXOi+SqwgO8TWit3ZzuMWnXxP+xKmSKktlP489
        hNDP/FFzhyZ3nOZX2JvDFwnjrp4Xufc=
X-Google-Smtp-Source: ABdhPJwzVa3OhqR281felvSFKO7UbSwcrz+Q6E+bTsf0Zl1fOWtG+LUMiiKa6iD3xJ8fkKBwsVeGq7J9PdA=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:ad4:55ef:: with SMTP id bu15mr6602357qvb.46.1614906673054;
 Thu, 04 Mar 2021 17:11:13 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:47 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-4-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 03/17] KVM: x86/mmu: Capture 'mmu' in a local variable when
 allocating roots
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Grab 'mmu' and do s/vcpu->arch.mmu/mmu to shorten line lengths and yield
smaller diffs when moving code around in future cleanup without forcing
the new code to use the same ugly pattern.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 58 ++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ed3fac1244e..c4f8e59f596c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3235,7 +3235,8 @@ static hpa_t mmu_alloc_root(struct kvm_vcpu *vcpu, gfn_t gfn, gva_t gva,
 
 static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 {
-	u8 shadow_root_level = vcpu->arch.mmu->shadow_root_level;
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
+	u8 shadow_root_level = mmu->shadow_root_level;
 	hpa_t root;
 	unsigned i;
 
@@ -3244,42 +3245,43 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
-		vcpu->arch.mmu->root_hpa = root;
+		mmu->root_hpa = root;
 	} else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
 		root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
 				      true);
 
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
-		vcpu->arch.mmu->root_hpa = root;
+		mmu->root_hpa = root;
 	} else if (shadow_root_level == PT32E_ROOT_LEVEL) {
 		for (i = 0; i < 4; ++i) {
-			MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
+			MMU_WARN_ON(VALID_PAGE(mmu->pae_root[i]));
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
 			if (!VALID_PAGE(root))
 				return -ENOSPC;
-			vcpu->arch.mmu->pae_root[i] = root | PT_PRESENT_MASK;
+			mmu->pae_root[i] = root | PT_PRESENT_MASK;
 		}
-		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
+		mmu->root_hpa = __pa(mmu->pae_root);
 	} else
 		BUG();
 
 	/* root_pgd is ignored for direct MMUs. */
-	vcpu->arch.mmu->root_pgd = 0;
+	mmu->root_pgd = 0;
 
 	return 0;
 }
 
 static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 {
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	u64 pdptr, pm_mask;
 	gfn_t root_gfn, root_pgd;
 	hpa_t root;
 	int i;
 
-	root_pgd = vcpu->arch.mmu->get_guest_pgd(vcpu);
+	root_pgd = mmu->get_guest_pgd(vcpu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -3289,14 +3291,14 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * Do we shadow a long mode page table? If so we need to
 	 * write-protect the guests page table root.
 	 */
-	if (vcpu->arch.mmu->root_level >= PT64_ROOT_4LEVEL) {
-		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->root_hpa));
+	if (mmu->root_level >= PT64_ROOT_4LEVEL) {
+		MMU_WARN_ON(VALID_PAGE(mmu->root_hpa));
 
 		root = mmu_alloc_root(vcpu, root_gfn, 0,
-				      vcpu->arch.mmu->shadow_root_level, false);
+				      mmu->shadow_root_level, false);
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
-		vcpu->arch.mmu->root_hpa = root;
+		mmu->root_hpa = root;
 		goto set_root_pgd;
 	}
 
@@ -3306,7 +3308,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK;
-	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
+	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
 		/*
@@ -3314,21 +3316,21 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 		 * with 64-bit only when needed.  Unlike 32-bit NPT, it doesn't
 		 * need to be in low mem.  See also lm_root below.
 		 */
-		if (!vcpu->arch.mmu->pae_root) {
+		if (!mmu->pae_root) {
 			WARN_ON_ONCE(!tdp_enabled);
 
-			vcpu->arch.mmu->pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-			if (!vcpu->arch.mmu->pae_root)
+			mmu->pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+			if (!mmu->pae_root)
 				return -ENOMEM;
 		}
 	}
 
 	for (i = 0; i < 4; ++i) {
-		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
-		if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL) {
-			pdptr = vcpu->arch.mmu->get_pdptr(vcpu, i);
+		MMU_WARN_ON(VALID_PAGE(mmu->pae_root[i]));
+		if (mmu->root_level == PT32E_ROOT_LEVEL) {
+			pdptr = mmu->get_pdptr(vcpu, i);
 			if (!(pdptr & PT_PRESENT_MASK)) {
-				vcpu->arch.mmu->pae_root[i] = 0;
+				mmu->pae_root[i] = 0;
 				continue;
 			}
 			root_gfn = pdptr >> PAGE_SHIFT;
@@ -3340,9 +3342,9 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 				      PT32_ROOT_LEVEL, false);
 		if (!VALID_PAGE(root))
 			return -ENOSPC;
-		vcpu->arch.mmu->pae_root[i] = root | pm_mask;
+		mmu->pae_root[i] = root | pm_mask;
 	}
-	vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
+	mmu->root_hpa = __pa(mmu->pae_root);
 
 	/*
 	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
@@ -3351,24 +3353,24 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * on demand, as running a 32-bit L1 VMM is very rare.  The PDP is
 	 * handled above (to share logic with PAE), deal with the PML4 here.
 	 */
-	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
-		if (vcpu->arch.mmu->lm_root == NULL) {
+	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
+		if (mmu->lm_root == NULL) {
 			u64 *lm_root;
 
 			lm_root = (void*)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 			if (!lm_root)
 				return -ENOMEM;
 
-			lm_root[0] = __pa(vcpu->arch.mmu->pae_root) | pm_mask;
+			lm_root[0] = __pa(mmu->pae_root) | pm_mask;
 
-			vcpu->arch.mmu->lm_root = lm_root;
+			mmu->lm_root = lm_root;
 		}
 
-		vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->lm_root);
+		mmu->root_hpa = __pa(mmu->lm_root);
 	}
 
 set_root_pgd:
-	vcpu->arch.mmu->root_pgd = root_pgd;
+	mmu->root_pgd = root_pgd;
 
 	return 0;
 }
-- 
2.30.1.766.gb4fecdf3b7-goog

