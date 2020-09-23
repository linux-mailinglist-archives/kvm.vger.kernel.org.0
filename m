Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A77275F67
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 20:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgIWSFU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 14:05:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:16542 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbgIWSEP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 14:04:15 -0400
IronPort-SDR: chf+stAV9PLR/PM6FHkVhP1JZpAXxuYiNK7LcsLB3kKVF9kRSpfBy9FKKfdiY5JW/+81ikg0p6
 KG4e5ptSKKNQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="148637138"
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="148637138"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 11:04:12 -0700
IronPort-SDR: q1WeNgmHjf5+QY7p//TdKZzQvlT8meVf0Ubk5TISC/rm/33xll1ExtYt62+Rq9jlVfIpwEuRev
 rOie6SPhJKRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,293,1596524400"; 
   d="scan'208";a="322670288"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga002.jf.intel.com with ESMTP; 23 Sep 2020 11:04:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 09/15] KVM: VMX: Check guest support for RDTSCP before processing MSR_TSC_AUX
Date:   Wed, 23 Sep 2020 11:04:03 -0700
Message-Id: <20200923180409.32255-10-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200923180409.32255-1-sean.j.christopherson@intel.com>
References: <20200923180409.32255-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check for RDTSCP support prior to checking if MSR_TSC_AUX is in the uret
MSRs array so that the array lookup and manipulation are back-to-back.
This paves the way toward adding a helper to wrap the lookup and
manipulation.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index ca41ee8fac5d..ed9ce25d3807 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1722,9 +1722,11 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	index = __vmx_find_uret_msr(vmx, MSR_EFER);
 	if (index >= 0 && update_transition_efer(vmx, index))
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
-	index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
-	if (index >= 0 && guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
-		move_msr_up(vmx, index, nr_active_uret_msrs++);
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)) {
+		index = __vmx_find_uret_msr(vmx, MSR_TSC_AUX);
+		if (index >= 0)
+			move_msr_up(vmx, index, nr_active_uret_msrs++);
+	}
 	index = __vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 	if (index >= 0)
 		move_msr_up(vmx, index, nr_active_uret_msrs++);
-- 
2.28.0

