Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877DDAA39D
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbfIEM6e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 08:58:34 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:13534 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726968AbfIEM6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 08:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1567688312; x=1599224312;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=ETZlDN4IdF0kxziLoR9hjkO844T65juEVcnxEPAUrBo=;
  b=YSuQ5o6P52iMHkPH4XY/9D7nyNN8jJvFLoBQdTsQ6xvrV7/9vYGjPf+A
   VAXbT3z7RE0+H3yxl9LuAM1lbjQGlqCneYsp4qgi/nU4ayJAHAriTy91X
   U1gnl/XwtCfspVut5kl/sGoSW2xjAZVrlVHTvV+rybqTIPppJAucPoSDI
   s=;
X-IronPort-AV: E=Sophos;i="5.64,470,1559520000"; 
   d="scan'208";a="827706210"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 05 Sep 2019 12:58:30 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id DB0B4A2822;
        Thu,  5 Sep 2019 12:58:29 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 5 Sep 2019 12:58:29 +0000
Received: from u79c5a0a55de558.ant.amazon.com (10.43.161.243) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 5 Sep 2019 12:58:26 +0000
From:   Alexander Graf <graf@amazon.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v3] KVM: x86: Disable posted interrupts for odd IRQs
Date:   Thu, 5 Sep 2019 14:58:18 +0200
Message-ID: <20190905125818.22395-1-graf@amazon.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.243]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can easily route hardware interrupts directly into VM context when
they target the "Fixed" or "LowPriority" delivery modes.

However, on modes such as "SMI" or "Init", we need to go via KVM code
to actually put the vCPU into a different mode of operation, so we can
not post the interrupt

Add code in the VMX and SVM PI logic to explicitly refuse to establish
posted mappings for advanced IRQ deliver modes. This reflects the logic
in __apic_accept_irq() which also only ever passes Fixed and LowPriority
interrupts as posted interrupts into the guest.

This fixes a bug I have with code which configures real hardware to
inject virtual SMIs into my guest.

Signed-off-by: Alexander Graf <graf@amazon.com>

---

v1 -> v2:

  - Make error message more unique
  - Update commit message to point to __apic_accept_irq()

v2 -> v3:

  - Use if() rather than switch()
  - Move abort logic into existing if() branch for broadcast irqs
  -> remove the updated error message again (thus remove R-B tag from Liran)
  - Fold VMX and SVM changes into single commit
  - Combine postability check into helper function kvm_irq_is_postable()
---
 arch/x86/include/asm/kvm_host.h | 7 +++++++
 arch/x86/kvm/svm.c              | 4 +++-
 arch/x86/kvm/vmx/vmx.c          | 6 +++++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 44a5ce57a905..5b14aa1fbeeb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1581,6 +1581,13 @@ bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
 void kvm_set_msi_irq(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 		     struct kvm_lapic_irq *irq);
 
+static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
+{
+	/* We can only post Fixed and LowPrio IRQs */
+	return (irq->delivery_mode == dest_Fixed ||
+		irq->delivery_mode == dest_LowestPrio);
+}
+
 static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
 {
 	if (kvm_x86_ops->vcpu_blocking)
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 1f220a85514f..f5b03d0c9bc6 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5260,7 +5260,8 @@ get_pi_vcpu_info(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *e,
 
 	kvm_set_msi_irq(kvm, e, &irq);
 
-	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
+	if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+	    !kvm_irq_is_postable(&irq)) {
 		pr_debug("SVM: %s: use legacy intr remap mode for irq %u\n",
 			 __func__, irq.vector);
 		return -1;
@@ -5314,6 +5315,7 @@ static int svm_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		 * 1. When cannot target interrupt to a specific vcpu.
 		 * 2. Unsetting posted interrupt.
 		 * 3. APIC virtialization is disabled for the vcpu.
+		 * 4. IRQ has incompatible delivery mode (SMI, INIT, etc)
 		 */
 		if (!get_pi_vcpu_info(kvm, e, &vcpu_info, &svm) && set &&
 		    kvm_vcpu_apicv_active(&svm->vcpu)) {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 570a233e272b..63f3d88b36cc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7382,10 +7382,14 @@ static int vmx_update_pi_irte(struct kvm *kvm, unsigned int host_irq,
 		 * irqbalance to make the interrupts single-CPU.
 		 *
 		 * We will support full lowest-priority interrupt later.
+		 *
+		 * In addition, we can only inject generic interrupts using
+		 * the PI mechanism, refuse to route others through it.
 		 */
 
 		kvm_set_msi_irq(kvm, e, &irq);
-		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu)) {
+		if (!kvm_intr_is_single_vcpu(kvm, &irq, &vcpu) ||
+		    !kvm_irq_is_postable(&irq)) {
 			/*
 			 * Make sure the IRTE is in remapped mode if
 			 * we don't handle it in posted mode.
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Ralf Herbrich
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



