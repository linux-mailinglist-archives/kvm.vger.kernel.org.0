Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF1F2CE26C
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 00:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgLCXMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 18:12:21 -0500
Received: from mga06.intel.com ([134.134.136.31]:10122 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbgLCXMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Dec 2020 18:12:20 -0500
IronPort-SDR: q5GbxELDt/co57YyDe6NXV66HxshuS6BjYc3tVg5xgrhZOwn3fYGKIrIy7SquN/00fDHzDNhSV
 q0lkagWuNS3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9824"; a="234898997"
X-IronPort-AV: E=Sophos;i="5.78,390,1599548400"; 
   d="scan'208";a="234898997"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 15:11:37 -0800
IronPort-SDR: RHehqE03i+OUaLR24hnwbvdoWF9Zx/PjOcdhCrZEpNpL7BpF1/NRISekTJFhDQX3AGlSdCuxvw
 EaKSOIWoYgvw==
X-IronPort-AV: E=Sophos;i="5.78,390,1599548400"; 
   d="scan'208";a="482155324"
Received: from rpedgeco-mobl.amr.corp.intel.com (HELO localhost.intel.com) ([10.209.137.176])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2020 15:11:37 -0800
From:   Rick Edgecombe <rick.p.edgecombe@intel.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        bgardon@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH] kvm: x86/mmu: Use cpuid to determine max gfn
Date:   Thu,  3 Dec 2020 15:11:20 -0800
Message-Id: <20201203231120.27307-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the TDP MMU, use shadow_phys_bits to dermine the maximum possible GFN
mapped in the guest for zapping operations. boot_cpu_data.x86_phys_bits
may be reduced in the case of HW features that steal HPA bits for other
purposes. However, this doesn't necessarily reduce GPA space that can be
accessed via TDP. So zap based on a maximum gfn calculated with MAXPHYADDR
retrieved from CPUID. This is already stored in shadow_phys_bits, so use
it instead of x86_phys_bits.

Fixes: faaf05b00aec ("kvm: x86/mmu: Support zapping SPTEs in the TDP MMU")
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ff28a5c6abd6..84c8f06bec26 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -66,7 +66,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
-	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 
 	lockdep_assert_held(&kvm->mmu_lock);
 
@@ -456,7 +456,7 @@ bool kvm_tdp_mmu_zap_gfn_range(struct kvm *kvm, gfn_t start, gfn_t end)
 
 void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 {
-	gfn_t max_gfn = 1ULL << (boot_cpu_data.x86_phys_bits - PAGE_SHIFT);
+	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
 	bool flush;
 
 	flush = kvm_tdp_mmu_zap_gfn_range(kvm, 0, max_gfn);
-- 
2.20.1

