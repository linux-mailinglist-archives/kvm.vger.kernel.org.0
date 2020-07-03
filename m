Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC48E21314A
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 04:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGCCRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 22:17:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:21810 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgGCCRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 22:17:16 -0400
IronPort-SDR: bUvTDnkPh/59zNiuLnmEnkow26H7nX1LTZUYTzDsI1ZlX2ugG/TTPXrKyjXlU6hMF9bhTa7glH
 hINkzVGKTQAw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="144590189"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="144590189"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 19:17:15 -0700
IronPort-SDR: +3WoxbufimQHFebrJ3blixPWYmnB7hwijeZvQzzByt5Xe4sj4dygcx1PGO9r2az0zSkToIEfLE
 DBAeTeHCm8bA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="356637992"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga001.jf.intel.com with ESMTP; 02 Jul 2020 19:17:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastien Boeuf <sebastien.boeuf@intel.com>
Subject: [PATCH] KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode
Date:   Thu,  2 Jul 2020 19:17:14 -0700
Message-Id: <20200703021714.5549-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inject a #GP on MOV CR4 if CR4.LA57 is toggled in 64-bit mode, which is
illegal per Intel's SDM:

  CR4.LA57
    57-bit linear addresses (bit 12 of CR4) ... blah blah blah ...
    This bit cannot be modified in IA-32e mode.

Note, the pseudocode for MOV CR doesn't call out the fault condition,
which is likely why the check was missed during initial development.
This is arguably an SDM bug and will hopefully be fixed in future
release of the SDM.

Fixes: fd8cb433734ee ("KVM: MMU: Expose the LA57 feature to VM.")
Cc: stable@vger.kernel.org
Reported-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00c88c2f34e4..2bb48896dbdc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -975,6 +975,8 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 	if (is_long_mode(vcpu)) {
 		if (!(cr4 & X86_CR4_PAE))
 			return 1;
+		if ((cr4 ^ old_cr4) & X86_CR4_LA57)
+			return 1;
 	} else if (is_paging(vcpu) && (cr4 & X86_CR4_PAE)
 		   && ((cr4 ^ old_cr4) & pdptr_bits)
 		   && !load_pdptrs(vcpu, vcpu->arch.walk_mmu,
-- 
2.26.0

