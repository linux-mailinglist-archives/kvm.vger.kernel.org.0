Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7441737A17
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbfFFQw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:52:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35129 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfFFQw4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:52:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id m3so3196889wrv.2;
        Thu, 06 Jun 2019 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=NwazYYvakpD56nDBj7gStsrC67VjeBH73pfOomqk8lA=;
        b=ZGaUetw87vqubmmWUiUtavsWOuhKwptVHKcsquvX1Kj4P97MNbjJMlbui9xg5xTjaj
         zgRm7dDxRaVWIk7x3h3mNsViiER1bxs2NCdi8Y+vsZ8C3Coa8PafMRAlezkt4dt/JZA9
         ji3ydLReyZCPoy2VkIlBEnBBoSr0oR0JIWUJ2rfMLxaLotRzU9atEw7mGnJEYI/8iO6W
         jATFexQK/wHcCvtI5Ows6m/IlOFeezx/eLzZSz18ZUlUxD8MZk35xqDhPvZoYosQqY0D
         LtN5Yipwy/0waTatg+BpAeS2Q5B2P/HpOpROKLGQjPx8sdYFwfWbvadfiP7ZYW8cQgHI
         vXWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=NwazYYvakpD56nDBj7gStsrC67VjeBH73pfOomqk8lA=;
        b=kzh2bnOw75IuUq9FYuezUKNyZS+TDZ/M8d8EWyDM4CRHiNqOLYZzM4zrOtevfe5xQC
         2v2gC3Tu0/rPRYf6PHi/8k21k4WWNFBfDccW2PEg8Gc+b5IS8Mg2CaT2WnrgHEntbgAs
         Cv7K09nVwlF6vOl29Znw5obqEM1dcj+xrzZ97TVFvbwqsGm7AF0EJ3xxDnP1vD7LieWJ
         umH7BxGYAiLR4jn7UAKZUBQuJsUeVZMCvFGPWuEGQrH+Y6bGSCHInWw/ROi5LDoXYDjm
         wtXLQvJVAsVV5KELqNLc5MDoWDUUn7r1ot94yQ8WsUzcw9pXyqEiMyw2rdd5tvvzDIAo
         yvaA==
X-Gm-Message-State: APjAAAWBfpzD6p/vd0FfBVOOpSuvis/eWsr5YahA/GfNIDGabWINJzhW
        I5fKLtvV1TKMf97a8QVa3FRfAPoO
X-Google-Smtp-Source: APXvYqy6GNjkK/MlmeTuBC3pzhw8KIOl96r1qD1P6auyKICoMNZoLN9bpEDEAM/YH7o7hnrDlHFC0A==
X-Received: by 2002:adf:f083:: with SMTP id n3mr2283517wro.316.1559839973844;
        Thu, 06 Jun 2019 09:52:53 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f8sm3075900wrx.11.2019.06.06.09.52.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 09:52:53 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: x86: introduce is_pae_paging
Date:   Thu,  6 Jun 2019 18:52:52 +0200
Message-Id: <1559839972-124144-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Checking for 32-bit PAE is quite common around code that fiddles with
the PDPTRs.  Add a function to compress all checks into a single
invocation.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 3 +--
 arch/x86/kvm/vmx/vmx.c    | 4 ++--
 arch/x86/kvm/x86.c        | 8 ++++----
 arch/x86/kvm/x86.h        | 5 +++++
 4 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index be8afec29f68..33b2c0570419 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -962,8 +962,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 		 * If PAE paging and EPT are both on, CR3 is not used by the CPU and
 		 * must not be dereferenced.
 		 */
-		if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu) &&
-		    !nested_ept) {
+		if (is_pae_paging(vcpu) && !nested_ept) {
 			if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3)) {
 				*entry_failure_code = ENTRY_FAIL_PDPTE;
 				return -EINVAL;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c03396525e3b..70bcfbd1a4b0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2768,7 +2768,7 @@ static void ept_load_pdptrs(struct kvm_vcpu *vcpu)
 		      (unsigned long *)&vcpu->arch.regs_dirty))
 		return;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		vmcs_write64(GUEST_PDPTR0, mmu->pdptrs[0]);
 		vmcs_write64(GUEST_PDPTR1, mmu->pdptrs[1]);
 		vmcs_write64(GUEST_PDPTR2, mmu->pdptrs[2]);
@@ -2780,7 +2780,7 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 {
 	struct kvm_mmu *mmu = vcpu->arch.walk_mmu;
 
-	if (is_paging(vcpu) && is_pae(vcpu) && !is_long_mode(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		mmu->pdptrs[0] = vmcs_read64(GUEST_PDPTR0);
 		mmu->pdptrs[1] = vmcs_read64(GUEST_PDPTR1);
 		mmu->pdptrs[2] = vmcs_read64(GUEST_PDPTR2);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 88489af13e96..2da741329f6d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -719,7 +719,7 @@ bool pdptrs_changed(struct kvm_vcpu *vcpu)
 	gfn_t gfn;
 	int r;
 
-	if (is_long_mode(vcpu) || !is_pae(vcpu) || !is_paging(vcpu))
+	if (!is_pae_paging(vcpu))
 		return false;
 
 	if (!test_bit(VCPU_EXREG_PDPTR,
@@ -962,8 +962,8 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 	if (is_long_mode(vcpu) &&
 	    (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63)))
 		return 1;
-	else if (is_pae(vcpu) && is_paging(vcpu) &&
-		   !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+	else if (is_pae_paging(vcpu) &&
+		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
@@ -8596,7 +8596,7 @@ static int __set_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		kvm_update_cpuid(vcpu);
 
 	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	if (!is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu)) {
+	if (is_pae_paging(vcpu)) {
 		load_pdptrs(vcpu, vcpu->arch.walk_mmu, kvm_read_cr3(vcpu));
 		mmu_reset_needed = 1;
 	}
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 275b3b646023..e08a12892e8b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -139,6 +139,11 @@ static inline int is_paging(struct kvm_vcpu *vcpu)
 	return likely(kvm_read_cr0_bits(vcpu, X86_CR0_PG));
 }
 
+static inline bool is_pae_paging(struct kvm_vcpu *vcpu)
+{
+	return !is_long_mode(vcpu) && is_pae(vcpu) && is_paging(vcpu);
+}
+
 static inline u32 bit(int bitno)
 {
 	return 1 << (bitno & 31);
-- 
1.8.3.1

