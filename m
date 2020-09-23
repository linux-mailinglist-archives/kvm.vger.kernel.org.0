Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43D0276385
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 00:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgIWWGw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 18:06:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:60333 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIWWGw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 18:06:52 -0400
IronPort-SDR: SJjsRWrYPm612yw+822RD6iyL91rv7ik/1E3yzzLXwZ2Dbi/OXvUdEGTdK0RJoLKrTpI/62d+Z
 irBdVLL+sjBw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="158381355"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="158381355"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 15:04:27 -0700
IronPort-SDR: KIhEFfAypVQ/Us+45SPZtGOVgIQZi1kqg0e3zMTsg0Kkp9lKuNwa/U1d9fWClXTtEfmrqAhwMc
 zlBKEgaLzLcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="335647656"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga004.fm.intel.com with ESMTP; 23 Sep 2020 15:04:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 4/4] KVM: x86/mmu: Bail early from final #PF handling on spurious faults
Date:   Wed, 23 Sep 2020 15:04:25 -0700
Message-Id: <20200923220425.18402-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923220425.18402-1-sean.j.christopherson@intel.com>
References: <20200923220425.18402-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Detect spurious page faults, e.g. page faults that occur when multiple
vCPUs simultaneously access a not-present page, and skip the SPTE write,
prefetch, and stats update for spurious faults.

Note, the performance benefits of skipping the write and prefetch are
likely negligible, and the false positive stats adjustment is probably
lost in the noise.  The primary motivation is to play nice with TDX's
SEPT in the long term.  SEAMCALLs (to program SEPT entries) are quite
costly, e.g. thousands of cycles, and a spurious SEPT update will result
in a SEAMCALL error (which KVM will ideally treat as fatal).

Reported-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 17 ++++++++++++++++-
 arch/x86/kvm/mmu/paging_tmpl.h |  3 +++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9253bcecbfe3..9bd657a8e78b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2973,6 +2973,7 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 /* Bits which may be returned by set_spte() */
 #define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
+#define SET_SPTE_SPURIOUS		BIT(2)
 
 static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		    unsigned int pte_access, int level,
@@ -3061,7 +3062,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		spte = mark_spte_for_access_track(spte);
 
 set_pte:
-	if (mmu_spte_update(sptep, spte))
+	if (*sptep == spte)
+		ret |= SET_SPTE_SPURIOUS;
+	else if (mmu_spte_update(sptep, spte))
 		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
 	return ret;
 }
@@ -3116,6 +3119,15 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (unlikely(is_mmio_spte(*sptep)))
 		ret = RET_PF_EMULATE;
 
+	/*
+	 * The fault is fully spurious if and only if the new SPTE and old SPTE
+	 * are identical, and emulation is not required.
+	 */
+	if ((set_spte_ret & SET_SPTE_SPURIOUS) && ret == RET_PF_FIXED) {
+		WARN_ON_ONCE(!was_rmapped);
+		return RET_PF_SPURIOUS;
+	}
+
 	pgprintk("%s: setting spte %llx\n", __func__, *sptep);
 	trace_kvm_mmu_set_spte(level, gfn, sptep);
 	if (!was_rmapped && is_large_pte(*sptep))
@@ -3352,6 +3364,9 @@ static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
 	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
 			   write, level, base_gfn, pfn, prefault,
 			   map_writable);
+	if (ret == RET_PF_SPURIOUS)
+		return ret;
+
 	direct_pte_prefetch(vcpu, it.sptep);
 	++vcpu->stat.pf_fixed;
 	return ret;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 4dd6b1e5b8cf..dda09c27ff25 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -711,6 +711,9 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 
 	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault,
 			   it.level, base_gfn, pfn, prefault, map_writable);
+	if (ret == RET_PF_SPURIOUS)
+		return ret;
+
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
 	++vcpu->stat.pf_fixed;
 	return ret;
-- 
2.28.0

