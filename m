Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 538AA9F543
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730890AbfH0Vku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:40:50 -0400
Received: from mga03.intel.com ([134.134.136.65]:61893 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730845AbfH0Vkt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919771"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 11/14] KVM: VMX: Remove EMULATE_FAIL handling in handle_invalid_guest_state()
Date:   Tue, 27 Aug 2019 14:40:37 -0700
Message-Id: <20190827214040.18710-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that EMULATE_FAIL is completely unused, remove the last remaning
usage where KVM does something functional in response to EMULATE_FAIL.
Leave the check in place as a WARN_ON_ONCE to provide a better paper
trail when EMULATE_{DONE,FAIL,USER_EXIT} are completely removed.

Opportunistically remove the gotos in handle_invalid_guest_state().
With the EMULATE_FAIL handling gone there is no need to have a common
handler for emulation failure and the gotos only complicate things,
e.g. the signal_pending() check always returns '1', but this is far
from obvious when glancing through the code.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 85a378075725..71368712e698 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5169,7 +5169,6 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	enum emulation_result err = EMULATE_DONE;
-	int ret = 1;
 	bool intr_window_requested;
 	unsigned count = 130;
 
@@ -5192,38 +5191,38 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 
 		err = kvm_emulate_instruction(vcpu, 0);
 
-		if (err == EMULATE_USER_EXIT) {
-			ret = 0;
-			goto out;
-		}
+		if (err == EMULATE_USER_EXIT)
+			return 0;
 
-		if (err != EMULATE_DONE)
-			goto emulation_error;
+		if (WARN_ON_ONCE(err == EMULATE_FAIL))
+			return 1;
 
 		if (vmx->emulation_required && !vmx->rmode.vm86_active &&
-		    vcpu->arch.exception.pending)
-			goto emulation_error;
+		    vcpu->arch.exception.pending) {
+			vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+			vcpu->run->internal.suberror =
+						KVM_INTERNAL_ERROR_EMULATION;
+			vcpu->run->internal.ndata = 0;
+			return 0;
+		}
 
 		if (vcpu->arch.halt_request) {
 			vcpu->arch.halt_request = 0;
-			ret = kvm_vcpu_halt(vcpu);
-			goto out;
+			return kvm_vcpu_halt(vcpu);
 		}
 
+		/*
+		 * Note, return 1 and not 0, vcpu_run() is responsible for
+		 * morphing the pending signal into the proper return code.
+		 */
 		if (signal_pending(current))
-			goto out;
+			return 1;
+
 		if (need_resched())
 			schedule();
 	}
 
-out:
-	return ret;
-
-emulation_error:
-	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-	vcpu->run->internal.ndata = 0;
-	return 0;
+	return 1;
 }
 
 static void grow_ple_window(struct kvm_vcpu *vcpu)
-- 
2.22.0

