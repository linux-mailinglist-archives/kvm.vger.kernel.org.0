Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA11344EA7C
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbhKLPk4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:40:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:34487 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235403AbhKLPkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:40:36 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093155"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093155"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:37:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182048"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:37:42 -0800
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     xiaoyao.li@intel.com, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: [PATCH 02/11] KVM: x86: Disable direct IRQ injection for TDX
Date:   Fri, 12 Nov 2021 23:37:24 +0800
Message-Id: <20211112153733.2767561-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

For TDX VM, direct IRQ injection is not supported.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 arch/x86/kvm/x86.h | 5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c080c68e4386..23617582712d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4455,7 +4455,7 @@ static int kvm_vcpu_ready_for_interrupt_injection(struct kvm_vcpu *vcpu)
 static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu,
 				    struct kvm_interrupt *irq)
 {
-	if (irq->irq >= KVM_NR_INTERRUPTS)
+	if (irq->irq >= KVM_NR_INTERRUPTS || kvm_irq_injection_disallowed(vcpu))
 		return -EINVAL;
 
 	if (!irqchip_in_kernel(vcpu->kvm)) {
@@ -8891,6 +8891,7 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
 static int dm_request_for_irq_injection(struct kvm_vcpu *vcpu)
 {
 	return vcpu->run->request_interrupt_window &&
+	       !kvm_irq_injection_disallowed(vcpu) &&
 		likely(!pic_in_kernel(vcpu->kvm));
 }
 
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ea264c4502e4..a2813892740d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -436,6 +436,11 @@ static inline void kvm_machine_check(void)
 #endif
 }
 
+static __always_inline bool kvm_irq_injection_disallowed(struct kvm_vcpu *vcpu)
+{
+	return vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.27.0

