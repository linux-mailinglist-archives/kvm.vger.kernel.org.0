Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7653276361
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 23:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726621AbgIWVxx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 17:53:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:36586 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgIWVxx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 17:53:53 -0400
IronPort-SDR: mIUDTGRSymmnYE56UqDrp3ysb3zWZ8dzw3+EjMmI/iOqT/3six//cTpABbIfwe8fjlAi/i5IDt
 4StO1k5Tuyhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="141037930"
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="141037930"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 14:53:53 -0700
IronPort-SDR: R8tPOzfBFwE35C1bIv0L7gPeceJWTkWVyRmhP0IgOBgtYibE1kjpJIRFNJGMnsKj3nb9ynqiWJ
 bWoyTp8rGWow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,295,1596524400"; 
   d="scan'208";a="455085173"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by orsmga004.jf.intel.com with ESMTP; 23 Sep 2020 14:53:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>
Subject: [PATCH] KVM: x86: Reset MMU context if guest toggles CR4.SMAP or CR4.PKE
Date:   Wed, 23 Sep 2020 14:53:52 -0700
Message-Id: <20200923215352.17756-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reset the MMU context during kvm_set_cr4() if SMAP or PKE is toggled.
Recent commits to (correctly) not reload PDPTRs when SMAP/PKE are
toggled inadvertantly skipped the MMU context reset due to the mask
of bits that triggers PDPTR loads also being used to trigger MMU context
resets.

Fixes: 427890aff855 ("kvm: x86: Toggling CR4.SMAP does not load PDPTEs in PAE mode")
Fixes: cb957adb4ea4 ("kvm: x86: Toggling CR4.PKE does not load PDPTEs in PAE mode")
Cc: Jim Mattson <jmattson@google.com>
Cc: Peter Shier <pshier@google.com>
Cc: Oliver Upton <oupton@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 17f4995e80a7..fd0da41bc149 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -977,6 +977,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	unsigned long old_cr4 = kvm_read_cr4(vcpu);
 	unsigned long pdptr_bits = X86_CR4_PGE | X86_CR4_PSE | X86_CR4_PAE |
 				   X86_CR4_SMEP;
+	unsigned long mmu_role_bits = pdptr_bits | X86_CR4_SMAP | X86_CR4_PKE;
 
 	if (kvm_valid_cr4(vcpu, cr4))
 		return 1;
@@ -1004,7 +1005,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (kvm_x86_ops.set_cr4(vcpu, cr4))
 		return 1;
 
-	if (((cr4 ^ old_cr4) & pdptr_bits) ||
+	if (((cr4 ^ old_cr4) & mmu_role_bits) ||
 	    (!(cr4 & X86_CR4_PCIDE) && (old_cr4 & X86_CR4_PCIDE)))
 		kvm_mmu_reset_context(vcpu);
 
-- 
2.28.0

