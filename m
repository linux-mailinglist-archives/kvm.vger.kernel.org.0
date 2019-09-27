Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20C15C0D8B
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 23:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728604AbfI0Vp3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 17:45:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:45957 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbfI0Vp3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 17:45:29 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 14:45:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,557,1559545200"; 
   d="scan'208";a="196852082"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 27 Sep 2019 14:45:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 8/8] KVM: x86: Fold decache_cr3() into cache_reg()
Date:   Fri, 27 Sep 2019 14:45:23 -0700
Message-Id: <20190927214523.3376-9-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190927214523.3376-1-sean.j.christopherson@intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Handle caching CR3 (from VMX's VMCS) into struct kvm_vcpu via the common
cache_reg() callback and drop the dedicated decache_cr3().  The name
decache_cr3() is somewhat confusing as the caching behavior of CR3
follows that of GPRs, RFLAGS and PDPTRs, (handled via cache_reg()), and
has nothing in common with the caching behavior of CR0/CR4 (whose
decache_cr{0,4}_guest_bits() likely provided the 'decache' verbiage).

Note, this effectively adds a BUG() if KVM attempts to cache CR3 on SVM.
Opportunistically add a WARN_ON_ONCE() in VMX to provide an equivalent
check.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kvm/kvm_cache_regs.h   |  2 +-
 arch/x86/kvm/svm.c              |  5 -----
 arch/x86/kvm/vmx/vmx.c          | 15 ++++++---------
 4 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a27f7f6b6b7a..0411dc0a27b0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1040,7 +1040,6 @@ struct kvm_x86_ops {
 			    struct kvm_segment *var, int seg);
 	void (*get_cs_db_l_bits)(struct kvm_vcpu *vcpu, int *db, int *l);
 	void (*decache_cr0_guest_bits)(struct kvm_vcpu *vcpu);
-	void (*decache_cr3)(struct kvm_vcpu *vcpu);
 	void (*decache_cr4_guest_bits)(struct kvm_vcpu *vcpu);
 	void (*set_cr0)(struct kvm_vcpu *vcpu, unsigned long cr0);
 	void (*set_cr3)(struct kvm_vcpu *vcpu, unsigned long cr3);
diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index 9c2bc528800b..f18177cd0030 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -145,7 +145,7 @@ static inline ulong kvm_read_cr4_bits(struct kvm_vcpu *vcpu, ulong mask)
 static inline ulong kvm_read_cr3(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-		kvm_x86_ops->decache_cr3(vcpu);
+		kvm_x86_ops->cache_reg(vcpu, VCPU_EXREG_CR3);
 	return vcpu->arch.cr3;
 }
 
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index f8ecb6df5106..3102c44c12c6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -2517,10 +2517,6 @@ static void svm_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
 {
 }
 
-static void svm_decache_cr3(struct kvm_vcpu *vcpu)
-{
-}
-
 static void svm_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
 }
@@ -7208,7 +7204,6 @@ static struct kvm_x86_ops svm_x86_ops __ro_after_init = {
 	.get_cpl = svm_get_cpl,
 	.get_cs_db_l_bits = kvm_get_cs_db_l_bits,
 	.decache_cr0_guest_bits = svm_decache_cr0_guest_bits,
-	.decache_cr3 = svm_decache_cr3,
 	.decache_cr4_guest_bits = svm_decache_cr4_guest_bits,
 	.set_cr0 = svm_set_cr0,
 	.set_cr3 = svm_set_cr3,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ed03d0cd1cc8..c84798026e85 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2188,7 +2188,12 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		if (enable_ept)
 			ept_save_pdptrs(vcpu);
 		break;
+	case VCPU_EXREG_CR3:
+		if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
+			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
+		break;
 	default:
+		WARN_ON_ONCE(1);
 		break;
 	}
 }
@@ -2859,13 +2864,6 @@ static void vmx_decache_cr0_guest_bits(struct kvm_vcpu *vcpu)
 	vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & cr0_guest_owned_bits;
 }
 
-static void vmx_decache_cr3(struct kvm_vcpu *vcpu)
-{
-	if (enable_unrestricted_guest || (enable_ept && is_paging(vcpu)))
-		vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
-}
-
 static void vmx_decache_cr4_guest_bits(struct kvm_vcpu *vcpu)
 {
 	ulong cr4_guest_owned_bits = vcpu->arch.cr4_guest_owned_bits;
@@ -2910,7 +2908,7 @@ static void ept_update_paging_mode_cr0(unsigned long *hw_cr0,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
 	if (!kvm_register_is_available(vcpu, VCPU_EXREG_CR3))
-		vmx_decache_cr3(vcpu);
+		vmx_cache_reg(vcpu, VCPU_EXREG_CR3);
 	if (!(cr0 & X86_CR0_PG)) {
 		/* From paging/starting to nonpaging */
 		exec_controls_setbit(vmx, CPU_BASED_CR3_LOAD_EXITING |
@@ -7792,7 +7790,6 @@ static struct kvm_x86_ops vmx_x86_ops __ro_after_init = {
 	.get_cpl = vmx_get_cpl,
 	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
 	.decache_cr0_guest_bits = vmx_decache_cr0_guest_bits,
-	.decache_cr3 = vmx_decache_cr3,
 	.decache_cr4_guest_bits = vmx_decache_cr4_guest_bits,
 	.set_cr0 = vmx_set_cr0,
 	.set_cr3 = vmx_set_cr3,
-- 
2.22.0

