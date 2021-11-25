Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42C45D1A8
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 01:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353119AbhKYAYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 19:24:45 -0500
Received: from mga14.intel.com ([192.55.52.115]:6415 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352821AbhKYAYU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 19:24:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10178"; a="235649687"
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="235649687"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:09 -0800
X-IronPort-AV: E=Sophos;i="5.87,261,1631602800"; 
   d="scan'208";a="675042174"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2021 16:21:09 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v3 21/59] KVM: x86: Add per-VM flag to disable in-kernel I/O APIC and level routes
Date:   Wed, 24 Nov 2021 16:20:04 -0800
Message-Id: <7e6bd50b0fc8fbeb22a276ac6fdf9e226584eb78.1637799475.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Kai Huang <kai.huang@linux.intel.com>

Add a flag to let TDX disallow the in-kernel I/O APIC, level triggered
routes for a userspace I/O APIC, and anything else that relies on being
able to intercept EOIs.  TDX-SEAM does not allow intercepting EOI.

Note, technically KVM could partially emulate the I/O APIC by allowing
only edge triggered interrupts, but that adds a lot of complexity for
basically zero benefit.  Ideally KVM wouldn't even allow I/O APIC route
reservation, but disabling that is a train wreck for Qemu.

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/ioapic.c           | 4 ++++
 arch/x86/kvm/irq_comm.c         | 9 +++++++--
 arch/x86/kvm/lapic.c            | 3 ++-
 arch/x86/kvm/x86.c              | 6 ++++++
 5 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f3808672c720..545b556e420c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1132,6 +1132,7 @@ struct kvm_arch {
 
 	enum kvm_irqchip_mode irqchip_mode;
 	u8 nr_reserved_ioapic_pins;
+	bool eoi_intercept_unsupported;
 
 	bool disabled_lapic_found;
 
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 816a82515dcd..39a9031e11b1 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -311,6 +311,10 @@ void kvm_arch_post_irq_ack_notifier_list_update(struct kvm *kvm)
 {
 	if (!ioapic_in_kernel(kvm))
 		return;
+
+	if (WARN_ON_ONCE(kvm->arch.eoi_intercept_unsupported))
+		return;
+
 	kvm_make_scan_ioapic_request(kvm);
 }
 
diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
index d5b72a08e566..bcfac99db579 100644
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
+	return  (kvm->arch.eoi_intercept_unsupported &&
+		 msg.arch_data.is_level) ||
+		(kvm->arch.x2apic_format && (msg.address_hi & 0xff));
 }
 
 int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
@@ -385,7 +390,7 @@ int kvm_setup_empty_irq_routing(struct kvm *kvm)
 
 void kvm_arch_post_irq_routing_update(struct kvm *kvm)
 {
-	if (!irqchip_split(kvm))
+	if (!irqchip_split(kvm) || kvm->arch.eoi_intercept_unsupported)
 		return;
 	kvm_make_scan_ioapic_request(kvm);
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 759952dd1222..1bfcd325d0d2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -281,7 +281,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	if (old)
 		call_rcu(&old->rcu, kvm_apic_map_free);
 
-	kvm_make_scan_ioapic_request(kvm);
+	if (!kvm->arch.eoi_intercept_unsupported)
+		kvm_make_scan_ioapic_request(kvm);
 }
 
 static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 535f65b0915d..1573dddd1e43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6110,6 +6110,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto create_irqchip_unlock;
 
 		r = -EINVAL;
+		if (kvm->arch.eoi_intercept_unsupported)
+			goto create_irqchip_unlock;
+
 		if (kvm->created_vcpus)
 			goto create_irqchip_unlock;
 
@@ -6140,6 +6143,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 		u.pit_config.flags = KVM_PIT_SPEAKER_DUMMY;
 		goto create_pit;
 	case KVM_CREATE_PIT2:
+		r = -EINVAL;
+		if (kvm->arch.eoi_intercept_unsupported)
+			goto out;
 		r = -EFAULT;
 		if (copy_from_user(&u.pit_config, argp,
 				   sizeof(struct kvm_pit_config)))
-- 
2.25.1

