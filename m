Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5363E8E13
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236987AbhHKKHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:07:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:49605 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236993AbhHKKHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Aug 2021 06:07:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="215083939"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="215083939"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:23 -0700
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="484785730"
Received: from chenyi-pc.sh.intel.com ([10.239.159.88])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 03:07:21 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Chenyi Qiang <chenyi.qiang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 5/7] KVM: MMU: Add support for PKS emulation
Date:   Wed, 11 Aug 2021 18:11:24 +0800
Message-Id: <20210811101126.8973-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210811101126.8973-1-chenyi.qiang@intel.com>
References: <20210811101126.8973-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Up until now, pkr_mask had 0 bits for supervisor pages (the U/S bit in
page tables replaces the PFEC.RSVD in page fault error code).
For PKS support, fill in the bits using the same algorithm used for user
mode pages, but with CR4.PKE replaced by CR4.PKS. Because of this
change, CR4.PKS must also be included in the MMU role.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 10 +++---
 arch/x86/kvm/mmu.h              | 15 +++++----
 arch/x86/kvm/mmu/mmu.c          | 58 ++++++++++++++++++++-------------
 3 files changed, 50 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3d55aca9167b..f31d19e851de 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -359,6 +359,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
 		unsigned int cr4_la57:1;
+		unsigned int cr4_pks:1;
 	};
 };
 
@@ -439,10 +440,11 @@ struct kvm_mmu {
 	u8 permissions[16];
 
 	/*
-	* The pkru_mask indicates if protection key checks are needed.  It
-	* consists of 16 domains indexed by page fault error code bits [4:1],
-	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
-	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
+	* The pkr_mask indicates if protection key checks are needed.
+	* It consists of 16 domains indexed by page fault error code
+	* bits[4:1] with PFEC.RSVD replaced by ACC_USER_MASK from the
+	* page tables. Each domain has 2 bits which are ANDed with AD
+	* and WD from PKRU/PKRS.
 	*/
 	u32 pkr_mask;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 5e94f6a90e80..5586c0341d28 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -46,7 +46,7 @@
 
 #define KVM_MMU_CR4_ROLE_BITS (X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE | \
 			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE | \
-			       X86_CR4_LA57)
+			       X86_CR4_LA57 | X86_CR4_PKS)
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
 
@@ -202,14 +202,17 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkr_mask)) {
 		u32 pkr_bits, offset;
+		u64 pkr;
 
 		/*
-		* PKRU defines 32 bits, there are 16 domains and 2
-		* attribute bits per domain in pkru.  pte_pkey is the
-		* index of the protection domain, so pte_pkey * 2 is
-		* is the index of the first bit for the domain.
+		* PKRU and PKRS both define 32 bits. There are 16 domains
+		* and 2 attribute bits per domain in them. pte_key is the
+		* index of the protection domain, so pte_pkey * 2 is the
+		* index of the first bit for the domain. The choice of
+		* PKRU and PKRS is determined by the accessed pages.
 		*/
-		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
+		pkr = pte_access & PT_USER_MASK ? vcpu->arch.pkru : kvm_read_pkrs(vcpu);
+		pkr_bits = (pkr >> pte_pkey * 2) & 3;
 
 		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
 		offset = (pfec & ~1) +
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 49fd2dc98cc6..ca83ad5f5716 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -205,6 +205,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smep, X86_CR4_SMEP);
 BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smap, X86_CR4_SMAP);
 BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pke, X86_CR4_PKE);
 BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pks, X86_CR4_PKS);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
 
@@ -227,6 +228,7 @@ BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pks);
 BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
 
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
@@ -4420,35 +4422,41 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 }
 
 /*
-* PKU is an additional mechanism by which the paging controls access to
-* user-mode addresses based on the value in the PKRU register.  Protection
-* key violations are reported through a bit in the page fault error code.
+* Protection Keys (PKEY) is an additional mechanism by which
+* the paging controls access to user-mode/supervisor-mode address
+* based on the values in PKEY registers (PKRU/PKRS). Protection key
+* violations are reported through a bit in the page fault error code.
 * Unlike other bits of the error code, the PK bit is not known at the
 * call site of e.g. gva_to_gpa; it must be computed directly in
-* permission_fault based on two bits of PKRU, on some machine state (CR4,
-* CR0, EFER, CPL), and on other bits of the error code and the page tables.
+* permission_fault based on two bits of PKRU/PKRS, on some machine
+* state (CR4, CR0, EFER, CPL), and on other bits of the error code
+* and the page tables.
 *
 * In particular the following conditions come from the error code, the
 * page tables and the machine state:
-* - PK is always zero unless CR4.PKE=1 and EFER.LMA=1
+* - PK is always zero unless CR4.PKE=1/CR4.PKS=1 and EFER.LMA=1
 * - PK is always zero if RSVD=1 (reserved bit set) or F=1 (instruction fetch)
-* - PK is always zero if U=0 in the page tables
-* - PKRU.WD is ignored if CR0.WP=0 and the access is a supervisor access.
+* - PK is always zero if
+*       - U=0 in the page tables and CR4.PKS=0
+*       - U=1 in the page tables and CR4.PKU=0
+* - (PKRU/PKRS).WD is ignored if CR0.WP=0 and the access is a supervisor access.
 *
-* The PKRU bitmask caches the result of these four conditions.  The error
-* code (minus the P bit) and the page table's U bit form an index into the
-* PKRU bitmask.  Two bits of the PKRU bitmask are then extracted and ANDed
-* with the two bits of the PKRU register corresponding to the protection key.
-* For the first three conditions above the bits will be 00, thus masking
-* away both AD and WD.  For all reads or if the last condition holds, WD
-* only will be masked away.
+* The pkr_mask caches the result of these three conditions. The error
+* code (minus the P bit) and the page table's U bit form an index into
+* the pkr_mask. Two bits of the pkr_mask are then extracted and ANDed with
+* the two bits of the PKEY register corresponding to the protection key.
+* For the first three conditions above the bits will be 00, thus masking away
+* both AD and WD. For all reads or if the last condition holds, WD only will be
+* masked away.
 */
 static void update_pkr_bitmask(struct kvm_mmu *mmu)
 {
 	unsigned bit;
 	bool wp;
+	bool cr4_pke = is_cr4_pke(mmu);
+	bool cr4_pks = is_cr4_pks(mmu);
 
-	if (!is_cr4_pke(mmu)) {
+	if (!cr4_pke && !cr4_pks) {
 		mmu->pkr_mask = 0;
 		return;
 	}
@@ -4468,19 +4476,22 @@ static void update_pkr_bitmask(struct kvm_mmu *mmu)
 		pte_user = pfec & PFERR_RSVD_MASK;
 
 		/*
-		 * Only need to check the access which is not an
-		 * instruction fetch and is to a user page.
+		 * need to check the access which is not an
+		 * instruction fetch and
+		 * - if cr4_pke 1-setting when accessing a user page.
+		 * - if cr4_pks 1-setting when accessing a supervisor page.
 		 */
-		check_pkey = (!ff && pte_user);
+		check_pkey = !ff && (pte_user ? cr4_pke : cr4_pks);
+
 		/*
-		 * write access is controlled by PKRU if it is a
-		 * user access or CR0.WP = 1.
+		 * write access is controlled by PKRU/PKRS if
+		 * it is a user access or CR0.WP = 1.
 		 */
 		check_write = check_pkey && wf && (uf || wp);
 
-		/* PKRU.AD stops both read and write access. */
+		/* PKRU/PKRS.AD stops both read and write access. */
 		pkey_bits = !!check_pkey;
-		/* PKRU.WD stops write access. */
+		/* PKRU/PKRS.WD stops write access. */
 		pkey_bits |= (!!check_write) << 1;
 
 		mmu->pkr_mask |= (pkey_bits & 3) << pfec;
@@ -4531,6 +4542,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 		/* PKEY and LA57 are active iff long mode is active. */
 		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
 		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
+		ext.cr4_pks = ____is_efer_lma(regs) && ____is_cr4_pks(regs);
 	}
 
 	ext.valid = 1;
-- 
2.17.1

