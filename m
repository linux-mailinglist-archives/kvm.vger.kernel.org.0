Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457351B5277
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 04:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgDWCZ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 22:25:56 -0400
Received: from mga05.intel.com ([192.55.52.43]:43420 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgDWCZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 22:25:55 -0400
IronPort-SDR: PBtXlPbCYjHb5PWE2+UKniXZQP0fwMd80Rn55KecCtOjSdBBCa8ZXnNNgYGdavfMRW0ZhWKMLX
 bka5aVbcKS9Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 19:25:54 -0700
IronPort-SDR: d4SYGUjyFo0ArnHT9KsSbY4ttXZC48ZmHxFFgQYMg8axD1qCJoGlYChMUaQ/JOlTOtM4X7m7rr
 kg2WlQY4qTCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,305,1583222400"; 
   d="scan'208";a="259273932"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 19:25:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Subject: [PATCH 01/13] KVM: nVMX: Preserve exception priority irrespective of exiting behavior
Date:   Wed, 22 Apr 2020 19:25:38 -0700
Message-Id: <20200423022550.15113-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200423022550.15113-1-sean.j.christopherson@intel.com>
References: <20200423022550.15113-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Short circuit vmx_check_nested_events() if an exception is pending and
needs to be injected into L2, priority between coincident events is not
dependent on exiting behavior.  This fixes a bug where a single-step #DB
that is not intercepted by L1 is incorrectly dropped due to servicing a
VMX Preemption Timer VM-Exit.

Injected exceptions also need to be blocked if nested VM-Enter is
pending or an exception was already injected, otherwise injecting the
exception could overwrite an existing event injection from L1.
Technically, this scenario should be impossible, i.e. KVM shouldn't
inject its own exception during nested VM-Enter.  This will be addressed
in a future patch.

Note, event priority between SMI, NMI and INTR is incorrect for L2, e.g.
SMI should take priority over VM-Exit on NMI/INTR, and NMI that is
injected into L2 should take priority over VM-Exit INTR.  This will also
be addressed in a future patch.

Fixes: b6b8a1451fc4 ("KVM: nVMX: Rework interception of IRQs and NMIs")
Reported-by: Jim Mattson <jmattson@google.com>
Cc: Oliver Upton <oupton@google.com>
Cc: Peter Shier <pshier@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index f228339cd0a0..dc7315b31fee 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3716,11 +3716,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	/*
 	 * Process any exceptions that are not debug traps before MTF.
 	 */
-	if (vcpu->arch.exception.pending &&
-	    !vmx_pending_dbg_trap(vcpu) &&
-	    nested_vmx_check_exception(vcpu, &exit_qual)) {
+	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
 		if (block_nested_events)
 			return -EBUSY;
+		if (!nested_vmx_check_exception(vcpu, &exit_qual))
+			goto no_vmexit;
 		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
 		return 0;
 	}
@@ -3733,10 +3733,11 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
-	if (vcpu->arch.exception.pending &&
-	    nested_vmx_check_exception(vcpu, &exit_qual)) {
+	if (vcpu->arch.exception.pending) {
 		if (block_nested_events)
 			return -EBUSY;
+		if (!nested_vmx_check_exception(vcpu, &exit_qual))
+			goto no_vmexit;
 		nested_vmx_inject_exception_vmexit(vcpu, exit_qual);
 		return 0;
 	}
@@ -3771,6 +3772,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+no_vmexit:
 	vmx_complete_nested_posted_interrupt(vcpu);
 	return 0;
 }
-- 
2.26.0

