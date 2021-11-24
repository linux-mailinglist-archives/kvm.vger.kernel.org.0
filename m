Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFAC45C47C
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 14:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351832AbhKXNt3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 08:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345655AbhKXNrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 08:47:33 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71AFC04CC95;
        Wed, 24 Nov 2021 04:22:02 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so4914768pja.1;
        Wed, 24 Nov 2021 04:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lxRHUxGSkSQXehchPRqK/OWhl6PvsYSKhbqxCMpqdXc=;
        b=h2/shSb1uy0pc7QPKfGdipbuEmLdi8hryEYMLwz8yo8+IkmNkA+OdOQnHq8gnu4MnO
         zRQvgBi/i50xVh2Q4Grqsk8mrgo1H+4sCCg2aCA5XPuunbAI6XvyF+6e0NCvx9iVdpp/
         ugYpBngAYgsdJp66fmVEdX6BRY2Q8zzOVEEZNB2wnrPx8F2Vx/ew1XNy+twDndmBmfKA
         g0gmxRn5bgI1edUSrzy5bUwW/N4U/5d6F0SL8lQRDvxYrq0XWQmONOivk6IwyjdVstMN
         OpSt4hLDSGpPgwk18xzcHqYBB3oZ6+gSb3XAtN9LPODtfDy1h7fgMuqFVTXAimHoeVDL
         DDPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lxRHUxGSkSQXehchPRqK/OWhl6PvsYSKhbqxCMpqdXc=;
        b=xo3gP5WEdSQrXXM+X+az1rJNYmDfwO9JTBcS+4UdsI//wCAX6ehyVTZbcQ6MJUwH3/
         2TXs1Iltku33ijOhCbszl8d5NvMIhZk+MU9vC7GxZs1Gw0RrSmUpkNvdtEMySlXacBSh
         WXGEjYbQd6TWUTkkQPLXqnHrLj+LYMqeuQMImKGKM0s4fiRi4Ox097x6ISgpoycqS6pn
         7pvNzHRIRxqe1OxGLUo/2zX7YnfcdyabI11C9Yi9ZNIauIJrooL9HX8zYRr+kvIQ75Ql
         xRvLUkGduTZRZCqRAtwBhMxOMMi8igcpH3/8ALpEe8K2nyZYxH/rJfmBJ2AJuaRMkI8d
         DvVA==
X-Gm-Message-State: AOAM531Y9BzJ0e1PKrHm33JfmeI1ic/bI0W89I4PKMbnKv8V8hmBfeRC
        56JMKeZJSG5sLRQTnfhxzTLCZF+T5RE=
X-Google-Smtp-Source: ABdhPJxoqRaN0zOI/6JvZaMIjMwZpYRfPZaj4SveV0iDhsk/xfqEI3N9gGxmXbGsSbGpZHpBGddKhA==
X-Received: by 2002:a17:903:2352:b0:142:76bc:de3b with SMTP id c18-20020a170903235200b0014276bcde3bmr18098433plh.36.1637756521936;
        Wed, 24 Nov 2021 04:22:01 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id m6sm10944871pgc.17.2021.11.24.04.22.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Nov 2021 04:22:01 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 10/12] KVM: X86: Remove mmu parameter from load_pdptrs()
Date:   Wed, 24 Nov 2021 20:20:52 +0800
Message-Id: <20211124122055.64424-11-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211124122055.64424-1-jiangshanlai@gmail.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

It uses vcpu->arch.walk_mmu always.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/svm/nested.c       |  4 ++--
 arch/x86/kvm/svm/svm.c          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/x86.c              | 12 ++++++------
 5 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01e50703c878..c106ad7efe23 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1591,7 +1591,7 @@ void kvm_mmu_zap_all(struct kvm *kvm);
 void kvm_mmu_invalidate_mmio_sptes(struct kvm *kvm, u64 gen);
 void kvm_mmu_change_mmu_pages(struct kvm *kvm, unsigned long kvm_nr_mmu_pages);
 
-int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3);
+int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3);
 
 int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			  const void *val, int bytes);
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 598843cfe6c4..6bcea96cdb92 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -461,7 +461,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 		return -EINVAL;
 
 	if (reload_pdptrs && !nested_npt && is_pae_paging(vcpu) &&
-	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)))
+	    CC(!load_pdptrs(vcpu, cr3)))
 		return -EINVAL;
 
 	if (!nested_npt)
@@ -1518,7 +1518,7 @@ static bool svm_get_nested_state_pages(struct kvm_vcpu *vcpu)
 		 * the guest CR3 might be restored prior to setting the nested
 		 * state which can lead to a load of wrong PDPTRs.
 		 */
-		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, vcpu->arch.cr3)))
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
 			return false;
 
 	if (!nested_svm_vmrun_msrpm(svm)) {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d855ba664fc2..e0c18682cbd0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1588,7 +1588,7 @@ static void svm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 	switch (reg) {
 	case VCPU_EXREG_PDPTR:
 		BUG_ON(!npt_enabled);
-		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
+		load_pdptrs(vcpu, kvm_read_cr3(vcpu));
 		break;
 	default:
 		KVM_BUG_ON(1, vcpu->kvm);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 20e126de1c96..d97588bebaaf 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1097,7 +1097,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	 * must not be dereferenced.
 	 */
 	if (reload_pdptrs && !nested_ept && is_pae_paging(vcpu) &&
-	    CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))) {
+	    CC(!load_pdptrs(vcpu, cr3))) {
 		*entry_failure_code = ENTRY_FAIL_PDPTE;
 		return -EINVAL;
 	}
@@ -3142,7 +3142,7 @@ static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
 		 * the guest CR3 might be restored prior to setting the nested
 		 * state which can lead to a load of wrong PDPTRs.
 		 */
-		if (CC(!load_pdptrs(vcpu, vcpu->arch.walk_mmu, vcpu->arch.cr3)))
+		if (CC(!load_pdptrs(vcpu, vcpu->arch.cr3)))
 			return false;
 	}
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 25e278ba4666..f94b0ebe9a4d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -798,8 +798,9 @@ static inline u64 pdptr_rsvd_bits(struct kvm_vcpu *vcpu)
 /*
  * Load the pae pdptrs.  Return 1 if they are all valid, 0 otherwise.
  */
-int load_pdptrs(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu, unsigned long cr3)
+int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 {
+	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 	gfn_t pdpt_gfn = cr3 >> PAGE_SHIFT;
 	gpa_t real_gpa;
 	int i;
@@ -887,7 +888,7 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 #endif
 	if (!(vcpu->arch.efer & EFER_LME) && (cr0 & X86_CR0_PG) &&
 	    is_pae(vcpu) && ((cr0 ^ old_cr0) & pdptr_bits) &&
-	    !load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu)))
+	    !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
 		return 1;
 
 	if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCIDE))
@@ -1063,8 +1064,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			return 1;
 	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
 		   && ((cr4 ^ old_cr4) & pdptr_bits)
-		   && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
-				   kvm_read_cr3(vcpu)))
+		   && !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
 		return 1;
 
 	if ((cr4 & X86_CR4_PCIDE) && !(old_cr4 & X86_CR4_PCIDE)) {
@@ -1153,7 +1153,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
 		return 1;
 
-	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, cr3))
 		return 1;
 
 	if (cr3 != kvm_read_cr3(vcpu))
@@ -10553,7 +10553,7 @@ static int __set_sregs_common(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs,
 	if (update_pdptrs) {
 		idx = srcu_read_lock(&vcpu->kvm->srcu);
 		if (is_pae_paging(vcpu)) {
-			load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
+			load_pdptrs(vcpu, kvm_read_cr3(vcpu));
 			*mmu_reset_needed = 1;
 		}
 		srcu_read_unlock(&vcpu->kvm->srcu, idx);
-- 
2.19.1.6.gb485710b

