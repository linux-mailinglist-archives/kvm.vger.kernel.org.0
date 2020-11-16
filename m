Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5806C2B4FBD
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388455AbgKPScT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:32:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:20632 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388071AbgKPS2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:28:04 -0500
IronPort-SDR: xW2djYd6UIkYTVsm89L1yjIXtKJZgBEvrlrawqI9tIGcuVrY0jr8bAVSYA4lVlN0tG1HhWlwgw
 lPQNWq4VqXmw==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232410033"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232410033"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:03 -0800
IronPort-SDR: 9VpXd3tfmiTiB2v42AVl1c4CsTDzG49xG8gcTbofRCACxUXSjLMK35E4OrfO5ttYRpxuxucSkZ
 33pCbPmc+L6A==
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="400527995"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 10:28:03 -0800
From:   isaku.yamahata@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 24/67] KVM: x86: Add per-VM flag to disable in-kernel I/O APIC and level routes
Date:   Mon, 16 Nov 2020 10:26:09 -0800
Message-Id: <b379033c7cc157444993dac67755575b486cb232.1605232743.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1605232743.git.isaku.yamahata@intel.com>
References: <cover.1605232743.git.isaku.yamahata@intel.com>
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
---
 arch/x86/include/asm/kvm_host.h | 1 +
 arch/x86/kvm/ioapic.c           | 4 ++++
 arch/x86/kvm/irq_comm.c         | 6 +++++-
 arch/x86/kvm/lapic.c            | 3 ++-
 arch/x86/kvm/x86.c              | 6 ++++++
 5 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e5b706889d09..7537ba0bada2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -977,6 +977,7 @@ struct kvm_arch {
 
 	enum kvm_irqchip_mode irqchip_mode;
 	u8 nr_reserved_ioapic_pins;
+	bool eoi_intercept_unsupported;
 
 	bool disabled_lapic_found;
 
diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 698969e18fe3..e2de6e552d25 100644
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
index 4aa1c2e00e2a..1523e9d66867 100644
--- a/arch/x86/kvm/irq_comm.c
+++ b/arch/x86/kvm/irq_comm.c
@@ -307,6 +307,10 @@ int kvm_set_routing_entry(struct kvm *kvm,
 		e->msi.address_hi = ue->u.msi.address_hi;
 		e->msi.data = ue->u.msi.data;
 
+		if (kvm->arch.eoi_intercept_unsupported &&
+		    e->msi.data & (1 << MSI_DATA_TRIGGER_SHIFT))
+			return -EINVAL;
+
 		if (kvm_msi_route_invalid(kvm, e))
 			return -EINVAL;
 		break;
@@ -390,7 +394,7 @@ int kvm_setup_empty_irq_routing(struct kvm *kvm)
 
 void kvm_arch_post_irq_routing_update(struct kvm *kvm)
 {
-	if (!irqchip_split(kvm))
+	if (!irqchip_split(kvm) || kvm->arch.eoi_intercept_unsupported)
 		return;
 	kvm_make_scan_ioapic_request(kvm);
 }
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 105e7859d1f2..e6c0aaf4044e 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -278,7 +278,8 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 	if (old)
 		call_rcu(&old->rcu, kvm_apic_map_free);
 
-	kvm_make_scan_ioapic_request(kvm);
+	if (!kvm->arch.eoi_intercept_unsupported)
+		kvm_make_scan_ioapic_request(kvm);
 }
 
 static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4060f3d91f74..8d58141256c5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5454,6 +5454,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
 			goto create_irqchip_unlock;
 
 		r = -EINVAL;
+		if (kvm->arch.eoi_intercept_unsupported)
+			goto create_irqchip_unlock;
+
 		if (kvm->created_vcpus)
 			goto create_irqchip_unlock;
 
@@ -5484,6 +5487,9 @@ long kvm_arch_vm_ioctl(struct file *filp,
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
2.17.1

