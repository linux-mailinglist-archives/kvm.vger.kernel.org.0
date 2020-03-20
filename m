Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C137118DA33
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 22:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgCTV3C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 17:29:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:37251 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727464AbgCTV27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 17:28:59 -0400
IronPort-SDR: S+kNTz+Ca2P8ijDnvM4ENUShzw0Qsl+FciRF5cZRbg4RIWuQEbeof6UNBIcbBgJeRxYV/RNplb
 JeZnd8ySm1ng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 14:28:59 -0700
IronPort-SDR: Pz5h6Pt6IKRABLbELMnLS8nJe1vFzK0tlge+EwhI7nus2COGZVDL4pUxCbkINtsettnVsa3ond
 XpQs91dN3o+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,286,1580803200"; 
   d="scan'208";a="269224516"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 20 Mar 2020 14:28:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v3 31/37] KVM: x86/mmu: Add separate override for MMU sync during fast CR3 switch
Date:   Fri, 20 Mar 2020 14:28:27 -0700
Message-Id: <20200320212833.3507-32-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200320212833.3507-1-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a separate "skip" override for MMU sync, a future change to avoid
TLB flushes on nested VMX transitions may need to sync the MMU even if
the TLB flush is unnecessary.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ++-
 arch/x86/kvm/mmu/mmu.c          | 13 +++++++------
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 4 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 31aa93088bf9..6fca2e45886c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1517,7 +1517,8 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
-void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush);
+void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush,
+		     bool skip_mmu_sync);
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_page_level);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b95933198f4c..06e94ca59a2d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4307,7 +4307,7 @@ static bool fast_cr3_switch(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 
 static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 			      union kvm_mmu_page_role new_role,
-			      bool skip_tlb_flush)
+			      bool skip_tlb_flush, bool skip_mmu_sync)
 {
 	if (!fast_cr3_switch(vcpu, new_cr3, new_role)) {
 		kvm_mmu_free_roots(vcpu, vcpu->arch.mmu, KVM_MMU_ROOT_CURRENT);
@@ -4322,10 +4322,10 @@ static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	 */
 	kvm_make_request(KVM_REQ_LOAD_MMU_PGD, vcpu);
 
-	if (!skip_tlb_flush) {
+	if (!skip_mmu_sync)
 		kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
+	if (!skip_tlb_flush)
 		kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-	}
 
 	/*
 	 * The last MMIO access's GVA and GPA are cached in the VCPU. When
@@ -4338,10 +4338,11 @@ static void __kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3,
 	__clear_sp_write_flooding_count(page_header(vcpu->arch.mmu->root_hpa));
 }
 
-void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush)
+void kvm_mmu_new_cr3(struct kvm_vcpu *vcpu, gpa_t new_cr3, bool skip_tlb_flush,
+		     bool skip_mmu_sync)
 {
 	__kvm_mmu_new_cr3(vcpu, new_cr3, kvm_mmu_calc_root_page_role(vcpu),
-			  skip_tlb_flush);
+			  skip_tlb_flush, skip_mmu_sync);
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_cr3);
 
@@ -5034,7 +5035,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false);
+	__kvm_mmu_new_cr3(vcpu, new_eptp, new_role.base, false, false);
 
 	if (new_role.as_u64 == context->mmu_role.as_u64)
 		return;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 06fc0b68ecf3..dd58563ee793 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1123,7 +1123,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
 	}
 
 	if (!nested_ept)
-		kvm_mmu_new_cr3(vcpu, cr3, false);
+		kvm_mmu_new_cr3(vcpu, cr3, false, false);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 26c24af87cca..0d1572a0791c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1045,7 +1045,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
-	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush);
+	kvm_mmu_new_cr3(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
-- 
2.24.1

