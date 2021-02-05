Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 882C43106DE
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 09:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhBEIh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 03:37:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:19410 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229669AbhBEIfM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Feb 2021 03:35:12 -0500
IronPort-SDR: J7ShmcpVmm5/IAjoWFf7ttyYXQt9Ybv/QRed8QfffAnFdgIPW1bHH0KlwRp8myw2kTeOsVg3Mm
 iedO1PwrgP/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="181550706"
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="181550706"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:10 -0800
IronPort-SDR: 0NeR+bQ/YTZ1igDnv2gHsd6+JUldaS5pLsUu8kkkJ8A9hCyMvLOS2vRyRzjp1y4U0p7AL6BRyU
 iZiJf9ipG7CA==
X-IronPort-AV: E=Sophos;i="5.81,154,1610438400"; 
   d="scan'208";a="393761939"
Received: from chenyi-pc.sh.intel.com ([10.239.159.24])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 00:34:08 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/5] KVM: MMU: Add support for PKS emulation
Date:   Fri,  5 Feb 2021 16:37:05 +0800
Message-Id: <20210205083706.14146-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210205083706.14146-1-chenyi.qiang@intel.com>
References: <20210205083706.14146-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In addition to the pkey check for user pages, advertise pkr_mask also to
cache the conditions where protection key checks for supervisor pages
are needed. Add CR4_PKS in mmu_role_bits to track the pkr_mask update on
a per-mmu basis.

In original cache conditions of pkr_mask, U/S bit in page tables is a
judgement condition and replace the PFEC.RSVD in page fault error code
to form the index of 16 domains. PKS support would extend the U/S bits
(if U/S=0, PKS check required). It adds an additional check for
cr4_pke/cr4_pks to ensure the necessity and distinguish PKU and PKS from
each other.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++---
 arch/x86/kvm/mmu.h              | 13 ++++---
 arch/x86/kvm/mmu/mmu.c          | 63 +++++++++++++++++++--------------
 arch/x86/kvm/x86.c              |  3 +-
 4 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1909d34cbac8..e515f1cecb88 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -294,7 +294,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr0_pg:1;
 		unsigned int cr4_pae:1;
 		unsigned int cr4_pse:1;
-		unsigned int cr4_pke:1;
+		unsigned int cr4_pkr:1;
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
 		unsigned int maxphyaddr:6;
@@ -378,10 +378,11 @@ struct kvm_mmu {
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
index a77bd20c83f9..55b71c28e46e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -192,14 +192,17 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
+		pkr = pte_access & PT_USER_MASK ? vcpu->arch.pkru : vcpu->arch.pkrs;
+		pkr_bits = (pkr >> pte_pkey * 2) & 3;
 
 		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
 		offset = (pfec & ~1) +
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d22c0813e4b9..92b24fa71f93 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4278,42 +4278,49 @@ static void update_permission_bitmask(struct kvm_vcpu *vcpu,
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
 static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				bool ept)
 {
 	unsigned bit;
-	bool wp;
+	bool wp, cr4_pke, cr4_pks;
 
 	if (ept) {
 		mmu->pkr_mask = 0;
 		return;
 	}
 
-	/* PKEY is enabled only if CR4.PKE and EFER.LMA are both set. */
-	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) || !is_long_mode(vcpu)) {
+	cr4_pke = kvm_read_cr4_bits(vcpu, X86_CR4_PKE) != 0;
+	cr4_pks = kvm_read_cr4_bits(vcpu, X86_CR4_PKS) != 0;
+
+	/* PKEY is enabled only if CR4.PKE/CR4.PKS and EFER.LMA are both set. */
+	if ((!cr4_pke && !cr4_pks) || !is_long_mode(vcpu)) {
 		mmu->pkr_mask = 0;
 		return;
 	}
@@ -4333,19 +4340,22 @@ static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
@@ -4427,7 +4437,8 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu)
 	ext.cr4_smep = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMEP);
 	ext.cr4_smap = !!kvm_read_cr4_bits(vcpu, X86_CR4_SMAP);
 	ext.cr4_pse = !!is_pse(vcpu);
-	ext.cr4_pke = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE);
+	ext.cr4_pkr = !!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+		      !!kvm_read_cr4_bits(vcpu, X86_CR4_PKS);
 	ext.maxphyaddr = cpuid_maxphyaddr(vcpu);
 
 	ext.valid = 1;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 684ef760481c..aec889a4eb66 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -982,7 +982,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP;
-	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE;
+	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE |
+				      X86_CR4_PKS;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
-- 
2.17.1

