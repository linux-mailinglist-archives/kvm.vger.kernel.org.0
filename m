Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD869107AAE
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfKVWkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:61220 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbfKVWkD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029663"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:02 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/13] KVM: x86: Refactor emulated exception injection to take the emul context
Date:   Fri, 22 Nov 2019 14:39:51 -0800
Message-Id: <20191122223959.13545-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
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
index a0e87f13af82..9dc6762edb96 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6309,9 +6309,10 @@ static void toggle_interruptibility(struct kvm_vcpu *vcpu, u32 mask)
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
 
@@ -6718,7 +6719,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 				 */
 				WARN_ON_ONCE(ctxt->exception.vector == UD_VECTOR ||
 					     exception_type(ctxt->exception.vector) == EXCPT_TRAP);
-				inject_emulated_exception(vcpu);
+				inject_emulated_exception(ctxt);
 				return 1;
 			}
 			return handle_emulation_failure(vcpu, emulation_type);
@@ -6772,7 +6773,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 
 	if (ctxt->have_exception) {
 		r = 1;
-		if (inject_emulated_exception(vcpu))
+		if (inject_emulated_exception(ctxt))
 			return r;
 	} else if (vcpu->arch.pio.count) {
 		if (!vcpu->arch.pio.in) {
-- 
2.24.0

