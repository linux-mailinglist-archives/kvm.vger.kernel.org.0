Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7436E32F296
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhCESbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbhCESbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:31:31 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4603C061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:31:31 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id p136so3366088ybc.21
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Ez6kaNpvX5WDqy2a2Fkcncr/macPJ8v8cBzt3I2dkQE=;
        b=dfkixw7Hg7+i/kt8hB8quDhlBcEbqlneYKJ6B03h2Wx0CvZP4+Snl2WQetxtJNd0jX
         5gOhsLYc1pu+ulZlVbm3NLeNDAmJmqsQqYKmrOyTPy54SrI1n9vLdlbr6GOkpm0UM9gB
         nBwfuDJtq2pBBFr4SD4Q4l7PJdUQ5ftD3eUTNmfqsIGWwei32i62HMkMmibETTOzQzYf
         ZbeKu+JARUbN6rW0Eh4+3VVsb9Qfs4DDnlrXsU8e2MJQHB+D1YEZ0z8+ZeDH4PJY2xH7
         UwuOrejd7OFzcDiuDoBYV5AVbg+ximPGfQ5Quj6QKoq286j8ZCaNbDpyh4jWC0WAj/Y9
         U6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Ez6kaNpvX5WDqy2a2Fkcncr/macPJ8v8cBzt3I2dkQE=;
        b=h7uNsEKkxZ4/gh5deHzUuIbm8dU1DjaG34LHnbccZsW2lwirPBA8zHuOzyxeG/QXaC
         TCs9fq3NwadCgGwvI5eK34LF2DnkbXJ2ymD8MJ3MFKHhdLvGRM+1NefGTaNRKSmtAPqJ
         nHb93XbtcFgiv3oYyFy2gdD2BmRw3ig30lto3/srWsvr46Vl73nxICUSKIAPNJDXrJJ4
         jp5XZIkOLZc2ydiMQzCV1uMbPsY9mrVgPIg7wq5vGv/lWa7DcpYyJuqB8ORHWmoETcPU
         q0H9sSrCiB19ECdT2XDVXaOwblu0P3+4KwlDtrDDe0KI7v2VZyC42QZx+KPrzK5Pn4hs
         RE3A==
X-Gm-Message-State: AOAM530xkeCPxsrCQtO9uuz+JZP6bwx42R5a2HrX0CpbQWJ8wmlNMzCY
        fMxi0la4WJ2XcxjmX2GtCdN452Pnsis=
X-Google-Smtp-Source: ABdhPJwkLqyDK3iGSyjPchE/cUxSowy6gHbbUTDSoVntlUxbds3j6SZNNAXArYdWVUJrLeKFz/AcmKhqb6w=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:7613:: with SMTP id r19mr15575268ybc.212.1614969090998;
 Fri, 05 Mar 2021 10:31:30 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  5 Mar 2021 10:31:13 -0800
In-Reply-To: <20210305183123.3978098-1-seanjc@google.com>
Message-Id: <20210305183123.3978098-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210305183123.3978098-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v4 01/11] KVM: x86: Get active PCID only when writing a CR3 value
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Retrieve the active PCID only when writing a guest CR3 value, i.e. don't
get the PCID when using EPT or NPT.  The PCID is especially problematic
for EPT as the bits have different meaning, and so the PCID and must be
manually stripped, which is annoying and unnecessary.  And on VMX,
getting the active PCID also involves reading the guest's CR3 and
CR4.PCIDE, i.e. may add pointless VMREADs.

Opportunistically rename the pgd/pgd_level params to root_hpa and
root_level to better reflect their new roles.  Keep the function names,
as "load the guest PGD" is still accurate/correct.

Last, and probably least, pass root_hpa as a hpa_t/u64 instead of an
unsigned long.  The EPTP holds a 64-bit value, even in 32-bit mode, so
in theory EPT could support HIGHMEM for 32-bit KVM.  Never mind that
doing so would require changing the MMU page allocators and reworking
the MMU to use kmap().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu.h              |  4 ++--
 arch/x86/kvm/svm/svm.c          | 10 ++++++----
 arch/x86/kvm/vmx/vmx.c          | 13 ++++++-------
 arch/x86/kvm/vmx/vmx.h          |  3 +--
 5 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2da6c9f5935a..51725e994451 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1245,8 +1245,8 @@ struct kvm_x86_ops {
 	int (*set_identity_map_addr)(struct kvm *kvm, u64 ident_addr);
 	u64 (*get_mt_mask)(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
-	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, unsigned long pgd,
-			     int pgd_level);
+	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			     int root_level);
 
 	bool (*has_wbinvd_exit)(void);
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 67e8c7c7a6ce..88d0ed5225a4 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -107,8 +107,8 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 	if (!VALID_PAGE(root_hpa))
 		return;
 
-	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa | kvm_get_active_pcid(vcpu),
-				 vcpu->arch.mmu->shadow_root_level);
+	static_call(kvm_x86_load_mmu_pgd)(vcpu, root_hpa,
+					  vcpu->arch.mmu->shadow_root_level);
 }
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dfc8fe231e8b..c7a685bf6862 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3902,14 +3902,14 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	return svm_exit_handlers_fastpath(vcpu);
 }
 
-static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
+static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long cr3;
 
 	if (npt_enabled) {
-		svm->vmcb->control.nested_cr3 = __sme_set(root);
+		svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
@@ -3917,9 +3917,11 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 			return;
 		cr3 = vcpu->arch.cr3;
 	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
-		cr3 = __sme_set(root);
+		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
 	} else {
-		cr3 = root;
+		/* PCID in the guest should be impossible with a 32-bit MMU. */
+		WARN_ON_ONCE(kvm_get_active_pcid(vcpu));
+		cr3 = root_hpa;
 	}
 
 	svm->vmcb->save.cr3 = cr3;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6d7e760fdfa0..dde2ebc7cf3a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3088,8 +3088,7 @@ static int vmx_get_max_tdp_level(void)
 	return 4;
 }
 
-u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
-		   int root_level)
+u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level)
 {
 	u64 eptp = VMX_EPTP_MT_WB;
 
@@ -3098,13 +3097,13 @@ u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
 	if (enable_ept_ad_bits &&
 	    (!is_guest_mode(vcpu) || nested_ept_ad_enabled(vcpu)))
 		eptp |= VMX_EPTP_AD_ENABLE_BIT;
-	eptp |= (root_hpa & PAGE_MASK);
+	eptp |= root_hpa;
 
 	return eptp;
 }
 
-static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
-			     int pgd_level)
+static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
+			     int root_level)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool update_guest_cr3 = true;
@@ -3112,7 +3111,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 	u64 eptp;
 
 	if (enable_ept) {
-		eptp = construct_eptp(vcpu, pgd, pgd_level);
+		eptp = construct_eptp(vcpu, root_hpa, root_level);
 		vmcs_write64(EPT_POINTER, eptp);
 
 		if (kvm_x86_ops.tlb_remote_flush) {
@@ -3131,7 +3130,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd,
 			update_guest_cr3 = false;
 		vmx_ept_load_pdptrs(vcpu);
 	} else {
-		guest_cr3 = pgd;
+		guest_cr3 = root_hpa | kvm_get_active_pcid(vcpu);
 	}
 
 	if (update_guest_cr3)
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 89da5e1251f1..4795955490cb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -376,8 +376,7 @@ void set_cr4_guest_host_mask(struct vcpu_vmx *vmx);
 void ept_save_pdptrs(struct kvm_vcpu *vcpu);
 void vmx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
 void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
-u64 construct_eptp(struct kvm_vcpu *vcpu, unsigned long root_hpa,
-		   int root_level);
+u64 construct_eptp(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 
 void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu);
 void vmx_update_msr_bitmap(struct kvm_vcpu *vcpu);
-- 
2.30.1.766.gb4fecdf3b7-goog

