Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36839F550
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 23:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730790AbfH0Vks (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 17:40:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:50847 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730707AbfH0Vkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 17:40:47 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 14:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="182919744"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 27 Aug 2019 14:40:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v2 03/14] KVM: x86: Refactor kvm_vcpu_do_singlestep() to remove out param
Date:   Tue, 27 Aug 2019 14:40:29 -0700
Message-Id: <20190827214040.18710-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827214040.18710-1-sean.j.christopherson@intel.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Return the single-step emulation result directly instead of via an out
param.  Presumably at some point in the past kvm_vcpu_do_singlestep()
could be called with *r==EMULATE_USER_EXIT, but that is no longer the
case, i.e. all callers are happy to overwrite their own return variable.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c6de5bc4fa5e..fe847f8eb947 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6377,7 +6377,7 @@ static int kvm_vcpu_check_hw_bp(unsigned long addr, u32 type, u32 dr7,
 	return dr6;
 }
 
-static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
+static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *kvm_run = vcpu->run;
 
@@ -6386,10 +6386,10 @@ static void kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu, int *r)
 		kvm_run->debug.arch.pc = vcpu->arch.singlestep_rip;
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
-		*r = EMULATE_USER_EXIT;
-	} else {
-		kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
+		return EMULATE_USER_EXIT;
 	}
+	kvm_queue_exception_p(vcpu, DB_VECTOR, DR6_BS);
+	return EMULATE_DONE;
 }
 
 int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
@@ -6410,7 +6410,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	 * that sets the TF flag".
 	 */
 	if (unlikely(rflags & X86_EFLAGS_TF))
-		kvm_vcpu_do_singlestep(vcpu, &r);
+		r = kvm_vcpu_do_singlestep(vcpu);
 	return r == EMULATE_DONE;
 }
 EXPORT_SYMBOL_GPL(kvm_skip_emulated_instruction);
@@ -6613,7 +6613,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu,
 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
 		kvm_rip_write(vcpu, ctxt->eip);
 		if (r == EMULATE_DONE && ctxt->tf)
-			kvm_vcpu_do_singlestep(vcpu, &r);
+			r = kvm_vcpu_do_singlestep(vcpu);
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP)
 			__kvm_set_rflags(vcpu, ctxt->eflags);
-- 
2.22.0

