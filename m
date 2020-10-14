Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479BA28D84D
	for <lists+kvm@lfdr.de>; Wed, 14 Oct 2020 04:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgJNCJ6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Oct 2020 22:09:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:51170 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgJNCJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Oct 2020 22:09:56 -0400
IronPort-SDR: Q8QMPy2lC9QZei9sWYU58m6kN02htWsHqrqFNegPXRLHdsIqVjghbr8q21riYLK6DRy1YHG6W5
 v18j4B0bDmJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9773"; a="227659799"
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="227659799"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 19:09:55 -0700
IronPort-SDR: V3aq9B9jgPf4LWjECQ64jqbZbbzod5sbsERtSd10x+HH7jntfVtiI1j/y1uEqQjLB2oU4N6AmP
 HPVPBA6kPJZA==
X-IronPort-AV: E=Sophos;i="5.77,373,1596524400"; 
   d="scan'208";a="530645144"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2020 19:09:53 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v2 4/7] KVM: MMU: Refactor pkr_mask to cache condition
Date:   Wed, 14 Oct 2020 10:11:53 +0800
Message-Id: <20201014021157.18022-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201014021157.18022-1-chenyi.qiang@intel.com>
References: <20201014021157.18022-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

pkr_mask bitmap indicates if protection key checks are needed for user
pages currently. It is indexed by page fault error code bits [4:1] with
PFEC.RSVD replaced by the ACC_USER_MASK from the page tables. Refactor
it by reverting to the use of PFEC.RSVD. After that, PKS and PKU can
share the same bitmap.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 arch/x86/kvm/mmu.h     | 10 ++++++----
 arch/x86/kvm/mmu/mmu.c | 16 ++++++++++------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 306608248594..597b9159c10b 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -204,11 +204,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		* index of the protection domain, so pte_pkey * 2 is
 		* is the index of the first bit for the domain.
 		*/
-		pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
+		if (pte_access & PT_USER_MASK)
+			pkr_bits = (vcpu->arch.pkru >> (pte_pkey * 2)) & 3;
+		else
+			pkr_bits = 0;
 
-		/* clear present bit, replace PFEC.RSVD with ACC_USER_MASK. */
-		offset = (pfec & ~1) +
-			((pte_access & PT_USER_MASK) << (PFERR_RSVD_BIT - PT_USER_SHIFT));
+		/* clear present bit */
+		offset = (pfec & ~1);
 
 		pkr_bits &= mmu->pkr_mask >> offset;
 		errcode |= -pkr_bits & PFERR_PK_MASK;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 834a95cf49fa..f9814ab0596d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4716,21 +4716,25 @@ static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
 	for (bit = 0; bit < ARRAY_SIZE(mmu->permissions); ++bit) {
 		unsigned pfec, pkey_bits;
-		bool check_pkey, check_write, ff, uf, wf, pte_user;
+		bool check_pkey, check_write, ff, uf, wf, rsvdf;
 
 		pfec = bit << 1;
 		ff = pfec & PFERR_FETCH_MASK;
 		uf = pfec & PFERR_USER_MASK;
 		wf = pfec & PFERR_WRITE_MASK;
 
-		/* PFEC.RSVD is replaced by ACC_USER_MASK. */
-		pte_user = pfec & PFERR_RSVD_MASK;
+		/*
+		 * PFERR_RSVD_MASK bit is not set if the
+		 * access is subject to PK restrictions.
+		 */
+		rsvdf = pfec & PFERR_RSVD_MASK;
 
 		/*
-		 * Only need to check the access which is not an
-		 * instruction fetch and is to a user page.
+		 * need to check the access which is not an
+		 * instruction fetch and is not a rsvd fault.
 		 */
-		check_pkey = (!ff && pte_user);
+		check_pkey = (!ff && !rsvdf);
+
 		/*
 		 * write access is controlled by PKRU if it is a
 		 * user access or CR0.WP = 1.
-- 
2.17.1

