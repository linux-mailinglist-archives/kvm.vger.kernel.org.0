Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EE7365666
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbhDTKm2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:28 -0400
Received: from mga17.intel.com ([192.55.52.151]:34977 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231697AbhDTKmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:16 -0400
IronPort-SDR: bKg/RhVOPFsfAia0KvIgBEyA9wznpUIvGw3QE9s9xRcUyzZlvXM6zs+xnL+LYVGPpMFSr2p+oL
 IbKpUgx4k1Vg==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590766"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590766"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:45 -0700
IronPort-SDR: avzNIe2EfRVI1KHEeRiND7sCqhU3jcW+7AIua84ac6MVqW72ezvavqY8w+reKKlzDdlCOfW0LS
 ifbrwgCNV2/A==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872783"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:45 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 06/10] KVM: x86/mmu: make handle_abnormal_pfn() receive single argument
Date:   Tue, 20 Apr 2021 03:39:16 -0700
Message-Id: <a36a983c3456f2b0df30bc2af127b32a03458a9c.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert handle_abnormal_pfn() to receive single argument,
struct kvm_page_fault, instead of many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 14 ++++++++------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index dac022a79c57..a16e1b228ac2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2936,18 +2936,21 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 	return -EFAULT;
 }
 
-static bool handle_abnormal_pfn(struct kvm_vcpu *vcpu, gva_t gva, gfn_t gfn,
-				kvm_pfn_t pfn, unsigned int access,
+static bool handle_abnormal_pfn(struct kvm_page_fault *kpf, unsigned int access,
 				int *ret_val)
 {
+	struct kvm_vcpu *vcpu = kpf->vcpu;
+	gva_t gva = kpf->is_tdp ? 0 : kpf->cr2_or_gpa;
+	kvm_pfn_t pfn = kpf->pfn;
+
 	/* The pfn is invalid, report the error! */
 	if (unlikely(is_error_pfn(pfn))) {
-		*ret_val = kvm_handle_bad_page(vcpu, gfn, pfn);
+		*ret_val = kvm_handle_bad_page(vcpu, kpf->gfn, pfn);
 		return true;
 	}
 
 	if (unlikely(is_noslot_pfn(pfn)))
-		vcpu_cache_mmio_info(vcpu, gva, gfn,
+		vcpu_cache_mmio_info(vcpu, gva, kpf->gfn,
 				     access & shadow_mmio_access_mask);
 
 	return false;
@@ -3694,7 +3697,6 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 	int max_level = kpf->max_level;
 	bool is_tdp = kpf->is_tdp;
 
-	gfn_t gfn = kpf->gfn;
 	unsigned long mmu_seq;
 	int r;
 
@@ -3717,7 +3719,7 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 	if (try_async_pf(kpf))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, is_tdp ? 0 : gpa, gfn, kpf->pfn, ACC_ALL, &r))
+	if (handle_abnormal_pfn(kpf, ACC_ALL, &r))
 		return r;
 
 	r = RET_PF_RETRY;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 7965786418af..7df68b5fdd10 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -853,7 +853,7 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	if (try_async_pf(kpf))
 		return RET_PF_RETRY;
 
-	if (handle_abnormal_pfn(vcpu, addr, walker.gfn, kpf->pfn, walker.pte_access, &r))
+	if (handle_abnormal_pfn(kpf, walker.pte_access, &r))
 		return r;
 
 	/*
-- 
2.25.1

