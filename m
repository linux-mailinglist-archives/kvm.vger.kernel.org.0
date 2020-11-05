Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190B52A78B2
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 09:16:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730145AbgKEIQT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 03:16:19 -0500
Received: from mga04.intel.com ([192.55.52.120]:39805 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730239AbgKEIP4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 03:15:56 -0500
IronPort-SDR: 0XDyoRf56uZQ9s5XlysuM+4FjG94v3kzakyhZGtm8CinZH9t2gDh8wJMlUrnNYw87a9HTZ557X
 o6Zx+jQF8UAQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="166755722"
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="166755722"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 00:15:55 -0800
IronPort-SDR: jGP5lyEKTh9kmZkhozWS6Xdsix+wM7GvZzIv3dI8sa826/6LQKeIVxrxYFMYPUGmijn8O41+zx
 8MEladKUPyog==
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="539281474"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 00:15:53 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v3 5/7] KVM: MMU: Add support for PKS emulation
Date:   Thu,  5 Nov 2020 16:18:02 +0800
Message-Id: <20201105081805.5674-6-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201105081805.5674-1-chenyi.qiang@intel.com>
References: <20201105081805.5674-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Advertise pkr_mask to cache the conditions where pretection key checks
for supervisor pages are needed. When the accessed pages are those with
a translation for which the U/S flag is 0 in at least one
paging-structure entry controlling the translation, they are the
supervisor pages and PKRS enforces the access rights check.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  8 +++---
 arch/x86/kvm/mmu.h              | 12 ++++++---
 arch/x86/kvm/mmu/mmu.c          | 44 +++++++++++++++++----------------
 3 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7567952febd9..ba313c76a1b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -377,10 +377,10 @@ struct kvm_mmu {
 	u8 permissions[16];
 
 	/*
-	* The pkru_mask indicates if protection key checks are needed.  It
-	* consists of 16 domains indexed by page fault error code bits [4:1],
-	* with PFEC.RSVD replaced by ACC_USER_MASK from the page tables.
-	* Each domain has 2 bits which are ANDed with AD and WD from PKRU.
+	* The pkr_mask indicates if protection key checks are needed.
+	* It consists of 16 domains indexed by page fault error code
+	* bits[4:1]. Each domain has 2 bits which are ANDed with AD
+	* and WD from PKRU/PKRS.
 	*/
 	u32 pkr_mask;
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 8f05f7c0f6df..a3629f7b7499 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -192,15 +192,19 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
 	if (unlikely(mmu->pkr_mask)) {
 		u32 pkr_bits, offset;
+		u64 pkrs;
 
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
 		if (pte_access & PT_USER_MASK)
 			pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
+		else if (!kvm_get_msr(vcpu, MSR_IA32_PKRS, &pkrs))
+			pkr_bits = (pkrs >> (pte_pkey * 2)) & 3;
 		else
 			pkr_bits = 0;
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 39afa865dc1a..e5758911bb12 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4278,28 +4278,29 @@ static void update_permission_bitmask(struct kvm_vcpu *vcpu,
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
+* code (minus the P bit) forms an index into the pkr_mask. Both PKU and
+* PKS shares the same bitmask. Two bits of the pkr_mask are then extracted
+* and ANDed with the two bits of the PKEY register corresponding to
+* the protection key. For the first two conditions above the bits will be 00,
+* thus masking away both AD and WD. For all reads or if the last condition
+* holds, WD only will be masked away.
 */
 static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 				bool ept)
@@ -4312,8 +4313,9 @@ static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		return;
 	}
 
-	/* PKEY is enabled only if CR4.PKE and EFER.LMA are both set. */
-	if (!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) || !is_long_mode(vcpu)) {
+	/* PKEY is enabled only if CR4.PKE/CR4.PKS and EFER.LMA are both set. */
+	if ((!kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
+	    !kvm_read_cr4_bits(vcpu, X86_CR4_PKS)) || !is_long_mode(vcpu)) {
 		mmu->pkr_mask = 0;
 		return;
 	}
@@ -4342,14 +4344,14 @@ static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		check_pkey = (!ff && !rsvdf);
 
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
-- 
2.17.1

