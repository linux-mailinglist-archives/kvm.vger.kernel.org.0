Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4FF107AB1
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 23:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKVWkS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 17:40:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:61229 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfKVWkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 17:40:05 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:40:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="409029702"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2019 14:40:05 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/13] KVM: x86: Add helper to "handle" internal emulation error
Date:   Fri, 22 Nov 2019 14:39:57 -0800
Message-Id: <20191122223959.13545-12-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122223959.13545-1-sean.j.christopherson@intel.com>
References: <20191122223959.13545-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a helper to set the appropriate error codes in vcpu->run when
emulation fails (future patches will add additional failure scenarios).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/x86.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 418717876ad0..4667a51b4f25 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6401,6 +6401,14 @@ void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip)
 }
 EXPORT_SYMBOL_GPL(kvm_inject_realmode_interrupt);
 
+static int internal_emulation_error(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->internal.ndata = 0;
+	return 0;
+}
+
 static int handle_emulation_failure(struct x86_emulate_ctxt *ctxt,
 				    int emulation_type)
 {
@@ -6414,21 +6422,13 @@ static int handle_emulation_failure(struct x86_emulate_ctxt *ctxt,
 		return 1;
 	}
 
-	if (emulation_type & EMULTYPE_SKIP) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-		return 0;
-	}
+	if (emulation_type & EMULTYPE_SKIP)
+		return internal_emulation_error(vcpu);
 
 	kvm_queue_exception(vcpu, UD_VECTOR);
 
-	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-		return 0;
-	}
+	if (!is_guest_mode(vcpu) && kvm_x86_ops->get_cpl(vcpu) == 0)
+		return internal_emulation_error(vcpu);
 
 	return 1;
 }
@@ -8830,12 +8830,8 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 
 	ret = emulator_task_switch(ctxt, tss_selector, idt_index, reason,
 				   has_error_code, error_code);
-	if (ret) {
-		vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-		vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
-		vcpu->run->internal.ndata = 0;
-		return 0;
-	}
+	if (ret)
+		return internal_emulation_error(vcpu);
 
 	kvm_rip_write(vcpu, ctxt->eip);
 	kvm_set_rflags(vcpu, ctxt->eflags);
-- 
2.24.0

