Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DBD365667
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 12:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhDTKma (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 06:42:30 -0400
Received: from mga17.intel.com ([192.55.52.151]:34983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231678AbhDTKmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 06:42:17 -0400
IronPort-SDR: h3Kv0EleMmw23fIm+hj4ynT4Rwwnvh+SvnNXnRwO8V+kj2NGq4JZ6HrJq+ghFQjQV4MxmirCTZ
 5nlah8fCVLmw==
X-IronPort-AV: E=McAfee;i="6200,9189,9959"; a="175590768"
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="175590768"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 03:41:45 -0700
IronPort-SDR: EeiCmqXixC7KxA1zVLISY0ltSE0IUkR07xAk2j3DlYPHqGQ8dNMUVNjv9GodX4FdBgQEPql7o9
 4MfGPjYca4Iw==
X-IronPort-AV: E=Sophos;i="5.82,236,1613462400"; 
   d="scan'208";a="426872789"
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
Subject: [RFC PATCH 07/10] KVM: x86/mmu: make fast_page_fault() receive single argument
Date:   Tue, 20 Apr 2021 03:39:17 -0700
Message-Id: <e74afe360a85d41e7ab4bad115210771d2a600ce.1618914692.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert fast_page_fault() to receive single argument, struct kvm_page_fault
instead of many arguments.

No functional change is intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a16e1b228ac2..ce48416380c3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3043,9 +3043,11 @@ static bool is_access_allowed(u32 fault_err_code, u64 spte)
 /*
  * Returns one of RET_PF_INVALID, RET_PF_FIXED or RET_PF_SPURIOUS.
  */
-static int fast_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-			   u32 error_code)
+static int fast_page_fault(struct kvm_page_fault *kpf)
 {
+	struct kvm_vcpu *vcpu = kpf->vcpu;
+	gpa_t cr2_or_gpa = kpf->cr2_or_gpa;
+	u32 error_code = kpf->error_code;
 	struct kvm_shadow_walk_iterator iterator;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_INVALID;
@@ -3704,7 +3706,7 @@ static int direct_page_fault(struct kvm_page_fault *kpf)
 		return RET_PF_EMULATE;
 
 	if (!is_tdp_mmu_root(vcpu->kvm, vcpu->arch.mmu->root_hpa)) {
-		r = fast_page_fault(vcpu, gpa, error_code);
+		r = fast_page_fault(kpf);
 		if (r != RET_PF_INVALID)
 			return r;
 	}
-- 
2.25.1

