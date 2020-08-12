Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE3E242E4B
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 19:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgHLRvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 13:51:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:8711 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgHLRvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 13:51:32 -0400
IronPort-SDR: SetiZDw/HCyivUTQmI71Wi+DwV83LWLpBzQq87qJFMpfuwKEm6V+mkHq/GcGeNJNkCa3emO5ds
 yAppI9f+2Gug==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="151683229"
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="151683229"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 10:51:30 -0700
IronPort-SDR: PaPn9eCBmBUz7md84VtPMA8A3zjis7ZWdVqCjt3lbfKIJiErQswbDanNY8VDImLLGFsDqt1LBW
 GkZ/ERpujdJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="277905359"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2020 10:51:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
Subject: [PATCH] KVM: nVMX: Morph notification vector IRQ on nested VM-Enter to pending PI
Date:   Wed, 12 Aug 2020 10:51:29 -0700
Message-Id: <20200812175129.12172-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On successful nested VM-Enter, check for pending interrupts and convert
the highest priority interrupt to a pending posted interrupt if it
matches L2's notification vector.  If the vCPU receives a notification
interrupt before nested VM-Enter (assuming L1 disables IRQs before doing
VM-Enter), the pending interrupt (for L1) should be recognized and
processed as a posted interrupt when interrupts become unblocked after
VM-Enter to L2.

This fixes a bug where L1/L2 will get stuck in an infinite loop if L1 is
trying to inject an interrupt into L2 by setting the appropriate bit in
L2's PIR and sending a self-IPI prior to VM-Enter (as opposed to KVM's
method of manually moving the vector from PIR->vIRR/RVI).  KVM will
observe the IPI while the vCPU is in L1 context and so won't immediately
morph it to a posted interrupt for L2.  The pending interrupt will be
seen by vmx_check_nested_events(), cause KVM to force an immediate exit
after nested VM-Enter, and eventually be reflected to L1 as a VM-Exit.
After handling the VM-Exit, L1 will see that L2 has a pending interrupt
in PIR, send another IPI, and repeat until L2 is killed.

Note, posted interrupts require virtual interrupt deliveriy, and virtual
interrupt delivery requires exit-on-interrupt, ergo interrupts will be
unconditionally unmasked on VM-Enter if posted interrupts are enabled.

Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
Cc: stable@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I am by no means 100% confident this the a complete, correct fix.  I also
don't like exporting two low level LAPIC functions.  But, the fix does
appear to work as intended.

 arch/x86/kvm/lapic.c      | 7 +++++++
 arch/x86/kvm/lapic.h      | 1 +
 arch/x86/kvm/vmx/nested.c | 8 ++++++++
 3 files changed, 16 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5ccbee7165a21..ce37376bc96ec 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -488,6 +488,12 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 	}
 }
 
+void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec)
+{
+	apic_clear_irr(vec, vcpu->arch.apic);
+}
+EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
+
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
 	struct kvm_vcpu *vcpu;
@@ -2461,6 +2467,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
+EXPORT_SYMBOL_GPL(kvm_apic_has_interrupt);
 
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 754f29beb83e3..4fb86e3a9dd3d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -89,6 +89,7 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int shorthand, unsigned int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
+void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec);
 bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 23b58c28a1c92..2acf33b110b5c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3528,6 +3528,14 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
 		goto vmentry_failed;
 
+	/* Emulate processing of posted interrupts on VM-Enter. */
+	if (nested_cpu_has_posted_intr(vmcs12) &&
+	    kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
+		vmx->nested.pi_pending = true;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
+	}
+
 	/* Hide L1D cache contents from the nested guest.  */
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
 
-- 
2.28.0

