Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC8C4BD7E2
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 09:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346857AbiBUIGh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 03:06:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346837AbiBUIGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 03:06:23 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25324C67;
        Mon, 21 Feb 2022 00:05:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645430760; x=1676966760;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=4S7pwNqMgl8HjBOPyc6KlZZcCoErgo5E2rdLMOpKoJ0=;
  b=OVp8yNB+uTaVkRy4zSZhYsRIxt4LpG236nmPuV5IiJee4KVJaga8qNsv
   j8Z4kSWBTXL9oLekxPwNhM3LPvtB2KoVP2MrVbojosHpLVUakmuBdqKbN
   fxk8u1GhjDHyDP4oLxp34N6/jqUjW3O6NKqfyL+2ryvk+Stp37PsYtMVq
   5kiNQbICB88OfJfDSZPjEuMbdtUZkx/f45puFYBL67Sgj/2z7P18Em0Fq
   u4uTMEaYEY0ji3Hc60C2ovw+tSNAkD4jayrsxyP8WW0VdBfNK4Ptiwqnn
   RnTDR5zUi/COPNx/xlQHHI9wdwJpF5Dh93/+15LJFld4IkC/mz8PtRW93
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="250277878"
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="250277878"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,385,1635231600"; 
   d="scan'208";a="638472341"
Received: from unknown (HELO chenyi-pc.sh.intel.com) ([10.239.159.73])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 00:05:50 -0800
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
Subject: [PATCH v6 5/7] KVM: MMU: Add support for PKS emulation
Date:   Mon, 21 Feb 2022 16:08:38 +0800
Message-Id: <20220221080840.7369-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220221080840.7369-1-chenyi.qiang@intel.com>
References: <20220221080840.7369-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 arch/x86/include/asm/kvm_host.h | 10 ++--
 arch/x86/kvm/mmu.h              | 17 +++---
 arch/x86/kvm/mmu/mmu.c          | 91 +++++++++++++++++++++------------
 3 files changed, 76 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c37cd23b6764..5c53efe0012e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -370,6 +370,7 @@ union kvm_mmu_extended_role {
 		unsigned int cr4_smap:1;
 		unsigned int cr4_smep:1;
 		unsigned int cr4_la57:1;
+		unsigned int cr4_pks:1;
 		unsigned int efer_lma:1;
 	};
 };
@@ -450,10 +451,11 @@ struct kvm_mmu {
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
index 9e216d205c8d..0dacd3bb8602 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -45,7 +45,8 @@
 #define PT32E_ROOT_LEVEL 3
 
 #define KVM_MMU_CR4_ROLE_BITS (X86_CR4_PSE | X86_CR4_PAE | X86_CR4_LA57 | \
-			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE)
+			       X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE | \
+			       X86_CR4_PKS)
 
 #define KVM_MMU_CR0_ROLE_BITS (X86_CR0_PG | X86_CR0_WP)
 
@@ -277,14 +278,18 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkr_mask)) {
 		u32 pkr_bits, offset;
+		u32 pkr;
 
 		/*
-		* PKRU defines 32 bits, there are 16 domains and 2
-		* attribute bits per domain in pkru.  pte_pkey is the
-		* index of the protection domain, so pte_pkey * 2 is
-		* is the index of the first bit for the domain.
+		* PKRU and PKRS both define 32 bits. There are 16 domains
+		* and 2 attribute bits per domain in them. pte_key is the
+		* index of the protection domain, so pte_pkey * 2 is the
+		* index of the first bit for the domain. The use of PKRU
+		* versus PKRS is selected by the address type, as determined
+		* by the U/S bit in the paging-structure entries.
 		*/
-		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
+		pkr = pte_access & PT_USER_MASK ? vcpu->arch.pkru : kvm_read_pkrs(vcpu);
+		pkr_bits = (pkr >> pte_pkey * 2) & 3;
 
 		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
 		offset = (pfec & ~1) +
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 83597161b5f9..ea19ccfa4da3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -220,6 +220,7 @@ BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smep, X86_CR4_SMEP);
 BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, smap, X86_CR4_SMAP);
 BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pke, X86_CR4_PKE);
 BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, la57, X86_CR4_LA57);
+BUILD_MMU_ROLE_REGS_ACCESSOR(cr4, pks, X86_CR4_PKS);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, nx, EFER_NX);
 BUILD_MMU_ROLE_REGS_ACCESSOR(efer, lma, EFER_LMA);
 
@@ -242,6 +243,7 @@ BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smep);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, smap);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pke);
 BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, la57);
+BUILD_MMU_ROLE_ACCESSOR(ext,  cr4, pks);
 BUILD_MMU_ROLE_ACCESSOR(base, efer, nx);
 
 static struct kvm_mmu_role_regs vcpu_to_role_regs(struct kvm_vcpu *vcpu)
@@ -4597,37 +4599,58 @@ static void update_permission_bitmask(struct kvm_mmu *mmu, bool ept)
 }
 
 /*
-* PKU is an additional mechanism by which the paging controls access to
-* user-mode addresses based on the value in the PKRU register.  Protection
-* key violations are reported through a bit in the page fault error code.
-* Unlike other bits of the error code, the PK bit is not known at the
-* call site of e.g. gva_to_gpa; it must be computed directly in
-* permission_fault based on two bits of PKRU, on some machine state (CR4,
-* CR0, EFER, CPL), and on other bits of the error code and the page tables.
-*
-* In particular the following conditions come from the error code, the
-* page tables and the machine state:
-* - PK is always zero unless CR4.PKE=1 and EFER.LMA=1
-* - PK is always zero if RSVD=1 (reserved bit set) or F=1 (instruction fetch)
-* - PK is always zero if U=0 in the page tables
-* - PKRU.WD is ignored if CR0.WP=0 and the access is a supervisor access.
-*
-* The PKRU bitmask caches the result of these four conditions.  The error
-* code (minus the P bit) and the page table's U bit form an index into the
-* PKRU bitmask.  Two bits of the PKRU bitmask are then extracted and ANDed
-* with the two bits of the PKRU register corresponding to the protection key.
-* For the first three conditions above the bits will be 00, thus masking
-* away both AD and WD.  For all reads or if the last condition holds, WD
-* only will be masked away.
-*/
+ * Protection Key Rights (PKR) is an additional mechanism by which data accesses
+ * with 4-level or 5-level paging (EFER.LMA=1) may be disabled based on the
+ * Protection Key Rights Userspace (PRKU) or Protection Key Rights Supervisor
+ * (PKRS) registers.  The Protection Key (PK) used for an access is a 4-bit
+ * value specified in bits 62:59 of the leaf PTE used to translate the address.
+ *
+ * PKRU and PKRS are 32-bit registers, with 16 2-bit entries consisting of an
+ * access-disable (AD) and write-disable (WD) bit.  The PK from the leaf PTE is
+ * used to index the appropriate PKR (see below), e.g. PK=1 would consume bits
+ * 3:2 (bit 3 == write-disable, bit 2 == access-disable).
+ *
+ * The PK register (PKRU vs. PKRS) indexed by the PK depends on the type of
+ * _address_ (not access type!).  For a user-mode address, PKRU is used; for a
+ * supervisor-mode address, PKRS is used.  An address is supervisor-mode if the
+ * U/S flag (bit 2) is 0 in at least one of the paging-structure entries, i.e.
+ * an address is user-mode if the U/S flag is 1 in _all_ entries.  Again, this
+ * is the address type, not the access type, e.g. a supervisor-mode _access_
+ * will consume PKRU if the _address_ is a user-mode address.
+ *
+ * As alluded to above, PKR checks are only performed for data accesses; code
+ * fetches are not subject to PKR checks.  Terminal page faults (!PRESENT or
+ * PFEC.RSVD=1) are also not subject to PKR checks.
+ *
+ * PKR write-disable checks for superivsor-mode _accesses_ are performed if and
+ * only if CR0.WP=1 (though access-disable checks still apply).
+ *
+ * In summary, PKR checks are based on (a) EFER.LMA, (b) CR4.PKE or CR4.PKS,
+ * (c) CR0.WP, (d) the PK in the leaf PTE, (e) two bits from the corresponding
+ * PKR{S,U} entry, (f) the access type (derived from the other PFEC bits), and
+ * (g) the address type (retrieved from the paging-structure entries).
+ *
+ * To avoid conditional branches in permission_fault(), the PKR bitmask caches
+ * the above inputs, except for (e) the PKR{S,U} entry.  The FETCH, USER, and
+ * WRITE bits of the PFEC and the effective value of the paging-structures' U/S
+ * bit (slotted into the PFEC.RSVD position, bit 3) are used to index into the
+ * PKR bitmask (similar to the 4-bit Protection Key itself).  The two bits of
+ * the PKR bitmask "entry" are then extracted and ANDed with the two bits of
+ * the PKR{S,U} register corresponding to the address type and protection key.
+ *
+ * E.g. for all values where PFEC.FETCH=1, the corresponding pkr_bitmask bits
+ * will be 00b, thus masking away the AD and WD bits from the PKR{S,U} register
+ * to suppress PKR checks on code fetches.
+ */
 static void update_pkr_bitmask(struct kvm_mmu *mmu)
 {
 	unsigned bit;
 	bool wp;
-
+	bool cr4_pke = is_cr4_pke(mmu);
+	bool cr4_pks = is_cr4_pks(mmu);
 	mmu->pkr_mask = 0;
 
-	if (!is_cr4_pke(mmu))
+	if (!cr4_pke && !cr4_pks)
 		return;
 
 	wp = is_cr0_wp(mmu);
@@ -4645,19 +4668,22 @@ static void update_pkr_bitmask(struct kvm_mmu *mmu)
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
@@ -4708,6 +4734,7 @@ static union kvm_mmu_extended_role kvm_calc_mmu_role_ext(struct kvm_vcpu *vcpu,
 		/* PKEY and LA57 are active iff long mode is active. */
 		ext.cr4_pke = ____is_efer_lma(regs) && ____is_cr4_pke(regs);
 		ext.cr4_la57 = ____is_efer_lma(regs) && ____is_cr4_la57(regs);
+		ext.cr4_pks = ____is_efer_lma(regs) && ____is_cr4_pks(regs);
 		ext.efer_lma = ____is_efer_lma(regs);
 	}
 
-- 
2.17.1

