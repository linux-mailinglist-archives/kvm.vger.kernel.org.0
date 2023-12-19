Return-Path: <kvm+bounces-4782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D53D818378
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 09:36:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D7A781F24EDF
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 08:36:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702CB1426B;
	Tue, 19 Dec 2023 08:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IkTRuIQi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B84211725;
	Tue, 19 Dec 2023 08:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702974919; x=1734510919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QOT8xDWFhRMaeV97RW8V0jSs4k7dpFvDcqIoLtVT2/Y=;
  b=IkTRuIQixJexHuJfGzdGwdYW+nsHu77FUm/qj7H+Y6uY/Hoadurm1fHv
   WwROvIVeZxQWrC5DMWnAoa68v/GD2I88c66FToYJWYVQ+sSajdd+JleDa
   Fa0458SxNmZXNt1DiQoXMKuvj9loPV0fz/exqGcHxdggNw+pmT/Lx3gsW
   pVhXnxOVQiocm6WdNsoq+GSqHTwHkIpwDPpWy7OObpKdPPuNBFY6Z8zER
   kztPWRYkFu/zm8pGt5moYnWH1AkdZ382e7H78LdDz2trFQZ6X/hPBUiAj
   i3dedo1YS2XFKbQPQXjSj8bYKPn+QqFcKm8Kn2vXd9WvNgTHl2Um4hU60
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="395355765"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="395355765"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="725658907"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="725658907"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2023 00:34:55 -0800
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Vishal Annapurve <vannapurve@google.com>,
	Jim Mattson <jmattson@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH v3 3/4] KVM: X86: Add a capability to configure bus frequency for APIC timer
Date: Tue, 19 Dec 2023 00:34:40 -0800
Message-Id: <f393da364d3389f8e65c7fae3e5d9210ffe7a2db.1702974319.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1702974319.git.isaku.yamahata@intel.com>
References: <cover.1702974319.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add KVM_CAP_X86_BUS_FREQUENCY_CONTROL capability to configure the core
crystal clock (or processor's bus clock) for APIC timer emulation.  Allow
KVM_ENABLE_CAPABILITY(KVM_CAP_X86_BUS_FREQUENCY_CONTROL) to set the
frequency.

The TDX architecture hard-codes the APIC bus frequency to 25MHz.  The TDX
mandates it to be enumerated in CPUIID leaf 0x15 and doesn't allow the VMM
to override its value.  The KVM APIC timer emulation hard-codes the
frequency to 1GHz.  The KVM doesn't enumerate it to the guest unless the
user space VMM sets the CPUID leaf 0x15 by KVM_SET_CPUID.  If the CPUID
leaf 0x15 is enumerated, the guest kernel uses it as the APIC bus
frequency.  If not, the guest kernel measures the frequency based on other
known timers like the ACPI timer or the legacy PIT.  The TDX guest kernel
gets timer interrupt more times by (1GHz as the frequency KVM used) /
(25MHz as TDX CPUID enumerates).  To ensure that the guest doesn't have a
conflicting view of the APIC bus frequency, allow the userspace to tell KVM
to use the same frequency that TDX mandates instead of the default 1Ghz.

There are several options to address this.
1. Make the KVM able to configure APIC bus frequency (This patch).
   Pro: It resembles the existing hardware.  The recent Intel CPUs
        adapts 25MHz.
   Con: Require the VMM to emulate the APIC timer at 25MHz.
2. Make the TDX architecture enumerate CPUID 0x15 to configurable
   frequency or not enumerate it.
   Pro: Any APIC bus frequency is allowed.
   Con: Deviation from the real hardware.
3. Make the TDX guest kernel use 1GHz when it's running on KVM.
   Con: The kernel ignores CPUID leaf 0x15.
4. Change CPUID.15H under TDX to report the crystal clock frequency as
   1 GHz.
   Pro: This has been the virtual APIC frequency for KVM guests for 13
        years.
   Pro: This requires changing only one hard-coded constant in TDX.
   Con: It doesn't work with other VMMs as TDX isn't specific to KVM.

This patch doesn't affect the TSC deadline timer emulation.  The APIC timer
emulation path calculates the TSC value from the TMICT register value and
uses the TSC deadline timer path.  This patch touches only the APIC
timer-specific code.

[1] https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
Reported-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

---
Changes v3:
- Added reviewed-by Maxim Levitsky.
- minor update of the commit message.

Changes v2:
- Add check if vcpu isn't created.
- Add check if lapic chip is in-kernel emulation.
- Fix build error for i386.
- Add document to api.rst.
- typo in the commit message.
---
 Documentation/virt/kvm/api.rst | 14 ++++++++++++++
 arch/x86/kvm/x86.c             | 33 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 48 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7025b3751027..cc976df2651e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7858,6 +7858,20 @@ This capability is aimed to mitigate the threat that malicious VMs can
 cause CPU stuck (due to event windows don't open up) and make the CPU
 unavailable to host or other VMs.
 
+7.34 KVM_CAP_X86_BUS_FREQUENCY_CONTROL
+--------------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is the value of apic bus clock frequency
+:Returns: 0 on success, -EINVAL if args[0] contains invalid value for the
+          frequency, or -ENXIO if virtual local APIC isn't enabled by
+          KVM_CREATE_IRQCHIP, or -EBUSY if any vcpu is created.
+
+This capability sets the APIC bus clock frequency (or core crystal clock
+frequency) for kvm to emulate APIC in the kernel.  The default value is 1000000
+(1GHz).
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d7d865f7c847..97f81d612366 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4625,6 +4625,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ENABLE_CAP:
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
+	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -6616,6 +6617,38 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_X86_BUS_FREQUENCY_CONTROL: {
+		u64 bus_frequency = cap->args[0];
+		u64 bus_cycle_ns;
+
+		if (!bus_frequency)
+			return -EINVAL;
+		/* CPUID[0x15] only support 32bits.  */
+		if (bus_frequency != (u32)bus_frequency)
+			return -EINVAL;
+
+		/* Cast to avoid 64bit division on 32bit platform. */
+		bus_cycle_ns = 1000000000UL / (u32)bus_frequency;
+		if (!bus_cycle_ns)
+			return -EINVAL;
+
+		r = 0;
+		mutex_lock(&kvm->lock);
+		/*
+		 * Don't allow to change the frequency dynamically during vcpu
+		 * running to avoid potentially bizarre behavior.
+		 */
+		if (kvm->created_vcpus)
+			r = -EBUSY;
+		/* This is for in-kernel vAPIC emulation. */
+		else if (!irqchip_in_kernel(kvm))
+			r = -ENXIO;
+
+		if (!r)
+			kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
+		mutex_unlock(&kvm->lock);
+		return r;
+	}
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 211b86de35ac..d74a057df173 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1201,6 +1201,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 #define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
+#define KVM_CAP_X86_BUS_FREQUENCY_CONTROL 231
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.25.1


