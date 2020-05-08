Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C0E1CBB50
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 01:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgEHXh4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 19:37:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:18506 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727934AbgEHXh4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 19:37:56 -0400
IronPort-SDR: G5QTfzukAK/xxcAVOFUpuQODtBlWQmp+H4pyWS/9qRXKNpgvjz555j4Y/ATYLHZmVKCKhuPgkB
 arynb8vK8VuQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 16:37:55 -0700
IronPort-SDR: nskYbpXcg3aL2xjCO5ZbZPqNER0UOODRipa26VvaWqS/3iYCRsu89UzDueaSj+1jFAmhzvCK+c
 T3Mkc/R1YfDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,369,1583222400"; 
   d="scan'208";a="279184846"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga002.jf.intel.com with ESMTP; 08 May 2020 16:37:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH] KVM: x86: Restore update of required xstate size in guest's CPUID
Date:   Fri,  8 May 2020 16:37:49 -0700
Message-Id: <20200508233749.3417-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restore a guest CPUID update that was unintentional collateral damage
when the per-vCPU guest_xstate_size field was removed.

Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Fixes: d87277414b851 ("kvm: x86: Cleanup vcpu->arch.guest_xstate_size")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

There's nothing more thrilling than watching bisect home in on your own
commits, only to land on someone else's on the very last step.

 arch/x86/kvm/cpuid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 35845704cf57a..cd708b0b460a0 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -84,11 +84,13 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
 				   kvm_read_cr4_bits(vcpu, X86_CR4_PKE));
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 0);
-	if (!best)
+	if (!best) {
 		vcpu->arch.guest_supported_xcr0 = 0;
-	else
+	} else {
 		vcpu->arch.guest_supported_xcr0 =
 			(best->eax | ((u64)best->edx << 32)) & supported_xcr0;
+		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
+	}
 
 	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
-- 
2.26.0

