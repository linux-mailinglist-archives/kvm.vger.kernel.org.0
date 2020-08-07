Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75FBC23E986
	for <lists+kvm@lfdr.de>; Fri,  7 Aug 2020 10:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgHGIq6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Aug 2020 04:46:58 -0400
Received: from mga06.intel.com ([134.134.136.31]:65145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727981AbgHGIqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Aug 2020 04:46:54 -0400
IronPort-SDR: mjLd4oKi7pji6zI2iwk5GBWVHWkqWxfFbQWm33YDuRstjsFGruQKe+FAxZkjvx188mHvde8K4y
 m5iMdCNj3Pzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9705"; a="214565732"
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="214565732"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2020 01:46:54 -0700
IronPort-SDR: yH1muHlAK2pbJ2xEbXcQhXqLLn6ZXISE8u1S7WhCCdXDl3h1XE656dZ9vaGmkLo/8YaMB/nFG9
 gs5D3oYTrN2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,445,1589266800"; 
   d="scan'208";a="307317172"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga002.jf.intel.com with ESMTP; 07 Aug 2020 01:46:51 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 4/7] KVM: MMU: Refactor pkr_mask to cache condition
Date:   Fri,  7 Aug 2020 16:48:38 +0800
Message-Id: <20200807084841.7112-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200807084841.7112-1-chenyi.qiang@intel.com>
References: <20200807084841.7112-1-chenyi.qiang@intel.com>
Sender: kvm-owner@vger.kernel.org
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
index 0c2fdf0abf22..7fb4c63d5704 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -202,11 +202,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
index 481442f5e27a..333b4da739f8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4737,21 +4737,25 @@ static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
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

