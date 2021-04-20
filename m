Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E209365665
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhDTKmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:34980 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231688AbhDTKmQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:16 -0400
IronPort-SDR: CCL9UJ4KaTmGnyHYhmuF5CtM66CJ7lkcLE03SQvdCdJN1CQACvjNKged2U28B/0/hYDHGADlcu
 dIvzU17h+jIw==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590763"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590763"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:45 -0700
IronPort-SDR: Sc1dSw8P7i1v5ArdxdxiBnb0BZmbyXICErxgf85WAdHl6NgJhpHm3gn2XxkGCXCbJxnS57DDx+
 ZIA9isiDZ/7g==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872776"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:44 -0700
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>
Cc:     isaku.yamahata@gmail.com, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [RFC PATCH 05/10] KVM: x86/mmu: make page_fault_handle_page_track() receive single argument
Date:   Tue, 20 Apr 2021 03:39:15 -0700
Message-Id: <a4bf5fac17495a5cf2b61f52628b147d0d2562c6.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert page_fault_handle_page_trace() to receive single argument,
struct kvm_page_fault, instead of many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c         | 9 +++++----
 arch/x86/kvm/mmu/paging_tmpl.h | 4 ++--
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a2422bd9f59b..dac022a79c57 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3598,9 +3598,10 @@ static int handle_mmio_page_fault(struct kvm_vcpu *vcpu, u64 addr, bool direct)
 	return RET_PF_RETRY;
 }
 
-static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
-					 u32 error_code, gfn_t gfn)
+static bool page_fault_handle_page_track(struct kvm_page_fault *kpf)
 {
+	u32 error_code = kpf->error_code;
+
 	if (unlikely(error_code & PFERR_RSVD_MASK))
 		return false;
 
@@ -3612,7 +3613,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_page_track_is_active(vcpu, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_page_track_is_active(kpf->vcpu, kpf->gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	return false;
@@ -3697,7 +3698,7 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 	unsigned long mmu_seq;
 	int r;
 
-	if (page_fault_handle_page_track(vcpu, error_code, gfn))
+	if (page_fault_handle_page_track(kpf))
 		return RET_PF_EMULATE;
 
 	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f2beb7f7c378..7965786418af 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -827,7 +827,8 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 		return RET_PF_RETRY;
 	}
 
-	if (page_fault_handle_page_track(vcpu, error_code, walker.gfn)) {
+	kpf->gfn = walker.gfn;
+	if (page_fault_handle_page_track(kpf)) {
 		shadow_page_table_clear_flood(vcpu, addr);
 		return RET_PF_EMULATE;
 	}
@@ -849,7 +850,6 @@ static int FNAME(page_fault)(struct kvm_page_fault *kpf)
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
-	kpf->gfn = walker.gfn;
 	if (try_async_pf(kpf))
 		return RET_PF_RETRY;
 
-- 
2.25.1

