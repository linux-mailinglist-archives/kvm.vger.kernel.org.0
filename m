Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4AA3A20FB
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 01:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFIXp6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 19:45:58 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:53039 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhFIXpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 19:45:54 -0400
Received: by mail-qt1-f201.google.com with SMTP id z17-20020ac86b910000b0290244cba55754so9535964qts.19
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 16:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=K2ifrSGaCEQ+14CO+xHrLrRJvzgN5omyn9Y8rpPGs5U=;
        b=vBSSvL3SzM5RYdD8hznFl+2Av5Oh0maOv15Y8aCTl9T/9vVBRBd+QE0GfOUzE7OkQA
         1Pxidjlh5ytQSdf9DP3nFulJ/Tl2evzv5DXArI+cZGg8KxZvMEB+vvydaSXCHdglTSt9
         w4CE2swL95FjJyZXfXFhw5XfyTt/vgSzozO5UyyZU/8A83fxHR7NdSXyMx9y5SvIayu+
         Bj/ybC9GKy856/X4iHGQ0Ho8o5BxuozB42MmWa14cnO3nDfIyu7DcZFz345EEjxa6bVk
         kk/ktEY4SWLwrKPzqLFBvsUOlpY5GV22g570kcNlPzBzQajKik6IcanQI0V86yCdXAP2
         yvMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=K2ifrSGaCEQ+14CO+xHrLrRJvzgN5omyn9Y8rpPGs5U=;
        b=LGancHcpS0kIdyUYtcW7UA9tXO2N/fhADoue4jq14325coDO34tdwQ0ZdBIcJPO/80
         j8nW3gquqEJ6ey5U2iZbLrQ/KfFZoOpnyCBP7d+sX6CUjk2HVSZE3O5Xl8uIFYWDAiwS
         kxpeqDawxNqjimVzElMf7Ai0fc/P0ci5hEFVk5UFjfgC7k2cGAK9s7P7zQnBiZpyO0Xg
         t4OGr8VeMTdRfZtvwDbt9f3Esvop8SnZbUuZ3IjKwFSxHACni7bbZb9dK5CeG/JTHuzO
         h4nvqWDUNidF+bkJqqpxCmom6hD+8Ll++4s0iI8fI7b27Ldqxb+mcNCUqzpJo52s0evt
         5jUw==
X-Gm-Message-State: AOAM532+zcbcAAl8FzvBZBF/C0ugENlvMekfBwbGdCreKm08L2+gz9jw
        KBerCnQ6UnhZMgBw1XJZPyz5Rym7CSA=
X-Google-Smtp-Source: ABdhPJwXRZ4esdSqe6zj+H+ek2FyB5tVwuNcFmAOeZ9qQ6Ek9sDSd6Y17SrCPhl137vn3P4uPM1Rw/8+XDc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:8daf:e5e:ae50:4f28])
 (user=seanjc job=sendgmr) by 2002:ad4:4b71:: with SMTP id m17mr2374885qvx.45.1623282178456;
 Wed, 09 Jun 2021 16:42:58 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 16:42:27 -0700
In-Reply-To: <20210609234235.1244004-1-seanjc@google.com>
Message-Id: <20210609234235.1244004-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210609234235.1244004-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 07/15] KVM: x86: Drop skip MMU sync and TLB flush params from
 "new PGD" helpers
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop skip_mmu_sync and skip_tlb_flush from __kvm_mmu_new_pgd() now that
all call sites unconditionally skip both the sync and flush.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/mmu/mmu.c          | 17 +++++++----------
 arch/x86/kvm/svm/nested.c       |  2 +-
 arch/x86/kvm/vmx/nested.c       |  6 +-----
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6652e51a86fd..c05448d3beff 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1675,8 +1675,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gva_t gva, hpa_t root_hpa);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
-void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
-		     bool skip_mmu_sync);
+void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_max_root_level,
 		       int tdp_huge_page_level);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d7f29bf94ca3..a832e0fedf32 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3913,8 +3913,7 @@ static bool fast_pgd_switch(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 }
 
 static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
-			      union kvm_mmu_page_role new_role,
-			      bool skip_tlb_flush, bool skip_mmu_sync)
+			      union kvm_mmu_page_role new_role)
 {
 	if (!fast_pgd_switch(vcpu, new_pgd, new_role)) {
 		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
@@ -3929,10 +3928,10 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 	 */
 	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 
-	if (!skip_mmu_sync || force_flush_and_sync_on_reuse)
+	if (force_flush_and_sync_on_reuse) {
 		kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
-	if (!skip_tlb_flush || force_flush_and_sync_on_reuse)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+	}
 
 	/*
 	 * The last MMIO access's GVA and GPA are cached in the VCPU. When
@@ -3951,11 +3950,9 @@ static void __kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd,
 				to_shadow_page(vcpu->arch.mmu->root_hpa));
 }
 
-void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd, bool skip_tlb_flush,
-		     bool skip_mmu_sync)
+void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 {
-	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu),
-			  skip_tlb_flush, skip_mmu_sync);
+	__kvm_mmu_new_pgd(vcpu, new_pgd, kvm_mmu_calc_root_page_role(vcpu));
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
@@ -4648,7 +4645,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 	struct kvm_mmu *context = &vcpu->arch.guest_mmu;
 	union kvm_mmu_role new_role = kvm_calc_shadow_npt_root_page_role(vcpu);
 
-	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, true, true);
+	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 
 	if (new_role.as_u64 != context->mmu_role.as_u64) {
 		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
@@ -4700,7 +4697,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base, true, true);
+	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fe2705557960..ccd90ea93acd 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -416,7 +416,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	}
 
 	if (!nested_npt)
-		kvm_mmu_new_pgd(vcpu, cr3, true, true);
+		kvm_mmu_new_pgd(vcpu, cr3);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index e102a5c10a83..3fb87e5aead4 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1125,12 +1125,8 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		}
 	}
 
-	/*
-	 * Unconditionally skip the TLB flush on fast CR3 switch, all TLB
-	 * flushes are handled by nested_vmx_transition_tlb_flush().
-	 */
 	if (!nested_ept) {
-		kvm_mmu_new_pgd(vcpu, cr3, true, true);
+		kvm_mmu_new_pgd(vcpu, cr3);
 
 		/*
 		 * A TLB flush on VM-Enter/VM-Exit flushes all linear mappings
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02ceb1f606f4..117acfbc7ba9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1136,7 +1136,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 1;
 
 	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_new_pgd(vcpu, cr3, true, true);
+		kvm_mmu_new_pgd(vcpu, cr3);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
-- 
2.32.0.rc1.229.g3e70b5a671-goog

