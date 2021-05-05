Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3F0C374992
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 22:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235131AbhEEUnW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 16:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233990AbhEEUnV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 16:43:21 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E188C061574
        for <kvm@vger.kernel.org>; Wed,  5 May 2021 13:42:24 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y5-20020a2586050000b02904ee36d3b170so3634222ybk.10
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 13:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=p4KYU6vAoyfFP2I+rWAeMqwqBN6gnusP1gZ9ljdBr6Y=;
        b=AjLwt9XuECLQRfJeY4C1g/NLMSd3Z/WcBVmKEAtlvoOnl0rUzczKpDXVnH6NK3LtKZ
         9ZZvjHHyMm+Wuc+YSHuZlEirzwFpM1scYyEVMew0zlJjE5ZB57ymqhQUmtjUtM5TmTqF
         hf7AVyJCbtf25Ym6BaID/QCGmVEtnymL5yzlbkMfH4oz5AeT88vFuQptzkMQ0rVqr0mA
         oWLd5LgtTGdBeEmVa/mGYT649ljN2e1e8rm6TC88NEpQaw0kXjxbZszaEDwKaJzyxQsE
         UN/4R85u1MsrwZy6MqIcTt1zAGMZrEsOo4tptC3JY7feT3p2Mz/56Eae2wvbs892dY8a
         udsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=p4KYU6vAoyfFP2I+rWAeMqwqBN6gnusP1gZ9ljdBr6Y=;
        b=G7MVZz73oLfiWU/khx+x5TtpeiHGAspejKoWz4dQqkI6ASGhEGgWo+Rt8oFo6rKp3p
         y265zgFPuiq5B8OJgZB8rinEZYEs8N1LyeXtU9+eJmeCw0/SIN+LkIjP5cIdgESlhIdo
         d2MlzBncy9tHRW+nxE/dFKw11l6jjwSK9szW1Pxiq3tHh1NUYoQexzvk6Z5VSA2mtbqx
         cob93dSdH7+4QXstRGBqwbzQMMuwrd5LGa3sgcx7I1ZdIKhgnT5cyd39rhf6nfikdVKg
         OtBw8u6dEHZTOs1lMZcwgeVh8cnhYv/p4jQ7RChBuyCFRDxyn3qcJ82IQIF16eFwU8fe
         9/Mw==
X-Gm-Message-State: AOAM533ZtRuO9RAQUL6gpbzVUSyurOno1/bpqo3g/jiljaZpaWxQ7TmX
        VBZrvEsgUkSjDrUNXBMqbDWV0eGTHxI=
X-Google-Smtp-Source: ABdhPJyhxsVq7IOOVFOBQ7XJ7A9Ak4ReXLqq9wnO5KfzeBNv+2Ch/rAhuQ9n1wP7zLmYmUm5Fr/DG+iz/Cg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:820b:3fc:8d69:7035])
 (user=seanjc job=sendgmr) by 2002:a5b:f02:: with SMTP id x2mr892065ybr.99.1620247343885;
 Wed, 05 May 2021 13:42:23 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  5 May 2021 13:42:21 -0700
Message-Id: <20210505204221.1934471-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.527.g47e6f16901-goog
Subject: [PATCH v2] KVM: x86: Prevent KVM SVM from loading on kernels with
 5-level paging
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Disallow loading KVM SVM if 5-level paging is supported.  In theory, NPT
for L1 should simply work, but there unknowns with respect to how the
guest's MAXPHYADDR will be handled by hardware.

Nested NPT is more problematic, as running an L1 VMM that is using
2-level page tables requires stacking single-entry PDP and PML4 tables in
KVM's NPT for L2, as there are no equivalent entries in L1's NPT to
shadow.  Barring hardware magic, for 5-level paging, KVM would need stack
another layer to handle PML5.

Opportunistically rename the lm_root pointer, which is used for the
aforementioned stacking when shadowing 2-level L1 NPT, to pml4_root to
call out that it's specifically for PML4.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 20 ++++++++++----------
 arch/x86/kvm/svm/svm.c          |  5 +++++
 3 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3e5fc80a35c8..bf35f369b49e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -407,7 +407,7 @@ struct kvm_mmu {
 	u32 pkru_mask;
 
 	u64 *pae_root;
-	u64 *lm_root;
+	u64 *pml4_root;
 
 	/*
 	 * check zero bits on shadow page table entries, these
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 930ac8a7e7c9..04c869794ab3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3310,12 +3310,12 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
-		if (WARN_ON_ONCE(!mmu->lm_root)) {
+		if (WARN_ON_ONCE(!mmu->pml4_root)) {
 			r = -EIO;
 			goto out_unlock;
 		}
 
-		mmu->lm_root[0] = __pa(mmu->pae_root) | pm_mask;
+		mmu->pml4_root[0] = __pa(mmu->pae_root) | pm_mask;
 	}
 
 	for (i = 0; i < 4; ++i) {
@@ -3335,7 +3335,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	}
 
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL)
-		mmu->root_hpa = __pa(mmu->lm_root);
+		mmu->root_hpa = __pa(mmu->pml4_root);
 	else
 		mmu->root_hpa = __pa(mmu->pae_root);
 
@@ -3350,7 +3350,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	u64 *lm_root, *pae_root;
+	u64 *pml4_root, *pae_root;
 
 	/*
 	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
@@ -3369,14 +3369,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(mmu->shadow_root_level != PT64_ROOT_4LEVEL))
 		return -EIO;
 
-	if (mmu->pae_root && mmu->lm_root)
+	if (mmu->pae_root && mmu->pml4_root)
 		return 0;
 
 	/*
 	 * The special roots should always be allocated in concert.  Yell and
 	 * bail if KVM ends up in a state where only one of the roots is valid.
 	 */
-	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->lm_root))
+	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root))
 		return -EIO;
 
 	/*
@@ -3387,14 +3387,14 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	if (!pae_root)
 		return -ENOMEM;
 
-	lm_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!lm_root) {
+	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	if (!pml4_root) {
 		free_page((unsigned long)pae_root);
 		return -ENOMEM;
 	}
 
 	mmu->pae_root = pae_root;
-	mmu->lm_root = lm_root;
+	mmu->pml4_root = pml4_root;
 
 	return 0;
 }
@@ -5261,7 +5261,7 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	if (!tdp_enabled && mmu->pae_root)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
-	free_page((unsigned long)mmu->lm_root);
+	free_page((unsigned long)mmu->pml4_root);
 }
 
 static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 14ff7f0963e9..d29dfe4a6503 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -447,6 +447,11 @@ static int has_svm(void)
 		return 0;
 	}
 
+	if (pgtable_l5_enabled()) {
+		pr_info("KVM doesn't yet support 5-level paging on AMD SVM\n");
+		return 0;
+	}
+
 	return 1;
 }
 
-- 
2.31.1.527.g47e6f16901-goog

