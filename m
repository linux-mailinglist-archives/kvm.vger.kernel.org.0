Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C4C2A78B3
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 09:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgKEIPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 03:15:55 -0500
Received: from mga04.intel.com ([192.55.52.120]:39805 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730126AbgKEIPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Nov 2020 03:15:53 -0500
IronPort-SDR: 0pRtLZMx62orJVVWj++mThYAe9TPKTWgHS8NRQERuNcR2dalu8ITZLH823HedZPcqFinZ7qwGg
 Xd50dRkDucTw==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="166755719"
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="166755719"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 00:15:53 -0800
IronPort-SDR: inp/WlUKIgOZgD0RspSds4o5QRKCjulq1Y1PJvNpueDjV5CEEmua0DmDtV4uE6wPegjC8GIJhl
 Nat0UVLNX92g==
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="539281452"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 00:15:50 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v3 4/7] KVM: MMU: Refactor pkr_mask to cache condition
Date:   Thu,  5 Nov 2020 16:18:01 +0800
Message-Id: <20201105081805.5674-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201105081805.5674-1-chenyi.qiang@intel.com>
References: <20201105081805.5674-1-chenyi.qiang@intel.com>
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
index a77bd20c83f9..8f05f7c0f6df 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -199,11 +199,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
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
index d22c0813e4b9..39afa865dc1a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4322,21 +4322,25 @@ static void update_pkr_bitmask(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 
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

