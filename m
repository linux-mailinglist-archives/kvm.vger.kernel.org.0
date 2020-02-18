Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4DA916372A
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 00:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgBRX35 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 18:29:57 -0500
Received: from mga04.intel.com ([192.55.52.120]:38639 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728015AbgBRX34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 18:29:56 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 15:29:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="282936659"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Feb 2020 15:29:56 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 05/13] KVM: x86: Refactor emulated exception injection to take the emul context
Date:   Tue, 18 Feb 2020 15:29:45 -0800
Message-Id: <20200218232953.5724-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200218232953.5724-1-sean.j.christopherson@intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invert the vcpu->context derivation in inject_emulated_exception() in
preparation for dynamically allocating the emulation context.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 772e704e8083..79d1113ad6e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6399,9 +6399,10 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
 	}
 }
 
-static bool inject_emulated_exception(struct kvm_vcpu *vcpu)
+static bool inject_emulated_exception(struct x86_emulate_ctxt *ctxt)
 {
-	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
 	if (ctxt->exception.vector == PF_VECTOR)
 		return kvm_propagate_fault(vcpu, &ctxt->exception);
 
@@ -6806,7 +6807,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				 */
 				WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR ||
 					     exception_type(ctxt->exception.vector) == EXCPT_TRAP);
-				inject_emulated_exception(vcpu);
+				inject_emulated_exception(ctxt);
 				return 1;
 			}
 			return handle_emulation_failure(vcpu, emulation_type);
@@ -6860,7 +6861,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 
 	if (ctxt->have_exception) {
 		r = 1;
-		if (inject_emulated_exception(vcpu))
+		if (inject_emulated_exception(ctxt))
 			return r;
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
-- 
2.24.1

