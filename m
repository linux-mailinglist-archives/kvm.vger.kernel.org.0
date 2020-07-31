Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBFC234CE9
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 23:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbgGaVXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 17:23:34 -0400
Received: from mga14.intel.com ([192.55.52.115]:50227 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729214AbgGaVXb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 17:23:31 -0400
IronPort-SDR: jSvX9znS4jgPNzwY9fCSJhN0VZliV99ABokru1ltozaS+1akuyWSu++E65Hqzp7gy/xJgNByaY
 mIhFa2rtwCMQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="151075133"
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="151075133"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2020 14:23:27 -0700
IronPort-SDR: n1XueUoeOVIDoIt4dEfR0g+zYAgDwHeFJJXQMA5ZiC6TDIlzXDPottjMbmZ0iNmQd0bWxq4Y0d
 BJKSY2GQ8QJg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,419,1589266800"; 
   d="scan'208";a="331191315"
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
Subject: [RFC PATCH 7/8] KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by SEV
Date:   Fri, 31 Jul 2020 14:23:22 -0700
Message-Id: <20200731212323.21746-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200731212323.21746-1-sean.j.christopherson@intel.com>
References: <20200731212323.21746-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a helper to directly (pun intended) fault-in a TDP page
without having to go through the full page fault path.  This allows
SEV to pin pages before booting the guest, provides the resulting pfn to
vendor code if should be needed in the future, and allows the RET_PF_*
enums to stay in mmu.c where they belong.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmu.h     |  3 +++
 arch/x86/kvm/mmu/mmu.c | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9f6554613babc..06f4475b8aad8 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -108,6 +108,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	return vcpu->arch.mmu->page_fault(vcpu, cr2_or_gpa, err, prefault);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level);
+
 /*
  * Currently, we have two sorts of write-protection, a) the first one
  * write-protects guest page to sync the guest modification, b) another one is
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 92b133d7b1713..06dbc1bb79a6a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4271,6 +4271,31 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
 				 max_level, true, &pfn);
 }
 
+kvm_pfn_t kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa,
+			       u32 error_code, int max_level)
+{
+	kvm_pfn_t pfn;
+	int r;
+
+	if (mmu_topup_memory_caches(vcpu, false))
+		return KVM_PFN_ERR_FAULT;
+
+	/*
+	 * Loop on the page fault path to handle the case where an mmu_notifier
+	 * invalidation triggers RET_PF_RETRY.  In the normal page fault path,
+	 * KVM needs to resume the guest in case the invalidation changed any
+	 * of the page fault properties, i.e. the gpa or error code.  For this
+	 * path, the gpa and error code are fixed by the caller, and the caller
+	 * expects failure if and only if the page fault can't be fixed.
+	 */
+	do {
+		r = direct_page_fault(vcpu, gpa, error_code, false, max_level,
+				      true, &pfn);
+	} while (r == RET_PF_RETRY && !is_error_noslot_pfn(pfn));
+	return pfn;
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_map_tdp_page);
+
 static void nonpaging_init_context(struct kvm_vcpu *vcpu,
 				   struct kvm_mmu *context)
 {
-- 
2.28.0

