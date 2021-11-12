Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A9644EA87
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 16:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhKLPla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 10:41:30 -0500
Received: from mga03.intel.com ([134.134.136.65]:34471 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235156AbhKLPlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 10:41:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233093191"
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="233093191"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2021 07:38:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,229,1631602800"; 
   d="scan'208";a="453182119"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga006.jf.intel.com with ESMTP; 12 Nov 2021 07:37:57 -0800
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
Subject: [PATCH 06/11] KVM: x86: Disable in-kernel I/O APIC and level routes for TDX
Date:   Fri, 12 Nov 2021 23:37:28 +0800
Message-Id: <20211112153733.2767561-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211112153733.2767561-1-xiaoyao.li@intel.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@linux.intel.com>

Introduce kvm_eoi_intercept_disallowed() to disallow the in-kernel
I/O APIC, level triggered routes for a userspace I/O APIC, and anything
else that relies on being able to intercept EOIs. It's currently for
TDX, since TDX module does not allow intercepting EOI.

Note, technically KVM could partially emulate the I/O APIC by allowing
only edge triggered interrupts, but that adds a lot of complexity for
basically zero benefit.  Ideally KVM wouldn't even allow I/O APIC route
reservation, but disabling that is a train wreck for Qemu.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/ioapic.c   | 5 +++++
 arch/x86/kvm/irq_comm.c | 9 +++++++--
 arch/x86/kvm/lapic.c    | 3 ++-
 arch/x86/kvm/x86.c      | 6 ++++++
 arch/x86/kvm/x86.h      | 5 +++++
 5 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 816a82515dcd..f9fb2c694c83 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -45,6 +45,7 @@
 #include "ioapic.h"
 #include "lapic.h"
 #include "irq.h"
+#include "x86.h"
 
 static int ioapic_service(struct kvm_ioapic *vioapic, int irq,
 		bool line_status);
@@ -311,6 +312,10 @@ void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm)
 {
 	if (!ioapic_in_kernel(kvm))
 		return;
+
+	if (WARN_ON_ONCE(kvm_eoi_intercept_disallowed(kvm)))
+		return;
+
 	kvm_make_scan_ioapic_request(kvm);
 }
 
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d5b72a08e566..f9f643e31893 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -123,7 +123,12 @@ EXPORT_SYMBOL_GPL(kvm_set_msi_irq);
 static inline bool kvm_msi_route_invalid(struct kvm *kvm,
 		struct kvm_kernel_irq_routing_entry *e)
 {
-	return kvm->arch.x2apic_format && (e->msi.address_hi & 0xff);
+	struct msi_msg msg = { .address_lo = e->msi.address_lo,
+			       .address_hi = e->msi.address_hi,
+			       .data = e->msi.data };
+	return  (kvm_eoi_intercept_disallowed(kvm) &&
+		 msg.arch_data.is_level) ||
+		(kvm->arch.x2apic_format && (msg.address_hi & 0xff));
 }
 
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
@@ -385,7 +390,7 @@ int kvm_setup_empty_irq_routing(struct kvm *kvm)
 
 void kvm_arch_post_irq_routing_update(struct kvm *kvm)
 {
-	if (!irqchip_split(kvm))
+	if (!irqchip_split(kvm) || kvm_eoi_intercept_disallowed(kvm))
 		return;
 	kvm_make_scan_ioapic_request(kvm);
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d6ac32f3f650..235971c016d9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -281,7 +281,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	if (old)
 		call_rcu(&old->rcu, kvm_apic_map_free);
 
-	kvm_make_scan_ioapic_request(kvm);
+	if (!kvm_eoi_intercept_disallowed(kvm))
+		kvm_make_scan_ioapic_request(kvm);
 }
 
 static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 34dd93b29932..113ed9aa5c82 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6023,6 +6023,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto create_irqchip_unlock;
 
 		r = -EINVAL;
+		if (kvm_eoi_intercept_disallowed(kvm))
+			goto create_irqchip_unlock;
+
 		if (kvm->created_vcpus)
 			goto create_irqchip_unlock;
 
@@ -6053,6 +6056,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		u.pit_config.flags = KVM_PIT_SPEAKER_DUMMY;
 		goto create_pit;
 	case KVM_CREATE_PIT2:
+		r = -EINVAL;
+		if (kvm_eoi_intercept_disallowed(kvm))
+			goto out;
 		r = -EFAULT;
 		if (copy_from_user(&u.pit_config, argp,
 				   sizeof(struct kvm_pit_config)))
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 0d8435b32bf5..65c8c77e507b 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -451,6 +451,11 @@ static __always_inline bool kvm_tsc_immutable(struct kvm_vcpu *vcpu)
 	return vcpu->kvm->arch.vm_type == KVM_X86_TDX_VM;
 }
 
+static __always_inline bool kvm_eoi_intercept_disallowed(struct kvm *kvm)
+{
+	return kvm->arch.vm_type == KVM_X86_TDX_VM;
+}
+
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-- 
2.27.0

