Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC3D2234CEA
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729079AbgGaVX2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:50224 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728655AbgGaVX2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:28 -0400
IronPort-SDR: RcyqnpSecoO/Ccf9TaeG6VdztrKD+CF578Zgm+BOiHrpDQZgyFOTz6QrkEtf1hLJvP6+Ia8/On
 ZIK3n9Ctg60Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075129"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075129"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:27 -0700
IronPort-SDR: RSAMy2OpJI1Dt0mMuQewKa8YeQBi06oPFkDh8y7woTwL97jtt2H4A+yYsdoNwAFpV7Wy3ntjF+
 wlx3vGuGYHyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191301"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga007.jf.intel.com with ESMTP; 31 Jul 2020 14:23:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        eric van tassell <Eric.VanTassell@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH 3/8] KVM: x86/mmu: Refactor handling of not-present SPTEs in mmu_set_spte()
Date:   Fri, 31 Jul 2020 14:23:18 -0700
Message-Id: <20200731212323.21746-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return early from mmu_set_spte() if the new SPTE is not-present so as to
reduce the indentation of the code that performs metadata updates, e.g.
rmap manipulation.  Additional metadata updates will soon follow...

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 82f69a7456004..182f398036248 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3126,12 +3126,14 @@ static int mmu_set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	if (!was_rmapped && is_large_pte(*sptep))
 		++vcpu->kvm->stat.lpages;
 
-	if (is_shadow_present_pte(*sptep)) {
-		if (!was_rmapped) {
-			rmap_count = rmap_add(vcpu, sptep, gfn);
-			if (rmap_count > RMAP_RECYCLE_THRESHOLD)
-				rmap_recycle(vcpu, sptep, gfn);
-		}
+	/* No additional tracking necessary for not-present SPTEs. */
+	if (!is_shadow_present_pte(*sptep))
+		return ret;
+
+	if (!was_rmapped) {
+		rmap_count = rmap_add(vcpu, sptep, gfn);
+		if (rmap_count > RMAP_RECYCLE_THRESHOLD)
+			rmap_recycle(vcpu, sptep, gfn);
 	}
 
 	return ret;
-- 
2.28.0

