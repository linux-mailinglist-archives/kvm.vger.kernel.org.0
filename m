Return-Path: <kvm+bounces-16761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 281418BD4B4
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 20:37:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D49B6283760
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 18:37:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACCBA15921A;
	Mon,  6 May 2024 18:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L/Ns84LR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08271158D84;
	Mon,  6 May 2024 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715020587; cv=none; b=AcUU6JSIFTWPR9HdF9KpaqqBjxk6wYW3VlEF5PvODin1L9LozB3ta6KhTZ1vnnvLG4ZU9mTDGEOcZCXRp+eblm9G39lLhrKL6zIeZjN5TWDZffsuXNRQv0sxhcpbO64bE8HbsnfdAR9ijryOsHvC2cKyfiaJaaIn5OJH3TDPBs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715020587; c=relaxed/simple;
	bh=0MgHNgq04PAuwzWmHgs3NlDZm14HBu1aJPkRBeg0xmM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KFCNBMJGNhHy9+RHdDoO6o1adc4VUzlvj+VLJQFb/uWOspxzqrb9ZN0rFJfOVb5KkNbEzOJA2Rf2/0o947i1t+4AI1p2cVYMJqcMA7XZbWWDiPXXYY6gAMpI79Djcf22WAQdMHS9+34r6VfYVqXkxK7tBpSuvVN1VQrCV8ZF6nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L/Ns84LR; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715020586; x=1746556586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0MgHNgq04PAuwzWmHgs3NlDZm14HBu1aJPkRBeg0xmM=;
  b=L/Ns84LRK9wEJ7TIcKNZOFA+7F9AykE+JkfCJL6HcLqNEW5b0ZqdoLra
   WchU9VsHLhCz2T4TvEoQ5tapE/5XAqbL8kwQt8jgvZjzbePTEjZ8sKLiq
   DdB7NEXl+o2Gg+uVDCR7mucqp9mWg09rXIFbKLSkibFGZOxo4yCtyOcz+
   GlEEiBafFhnc4i5sTRHcLliv9jhUc9SDCNWIWh5CEt/w5XidPzpfTnCLK
   FWZw52b+QFk1j9Fg+qs/N8OM33KQ/hsH2LhGvMFyyG/Uh4tTvY1vCm5rZ
   oZmUuTSHIzkQPYzJOhGIm+lsBBSGTVwI3h3v7S8nBewSihqkLwMrZeF1K
   A==;
X-CSE-ConnectionGUID: HRYMwKGVRl6PBy1QlFZLNw==
X-CSE-MsgGUID: 10EUrWGzRSu/p9HtBiGzCw==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="21455752"
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="21455752"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 11:36:10 -0700
X-CSE-ConnectionGUID: zYu8lbR1RA6/HudOC8wTSA==
X-CSE-MsgGUID: opfrFNdRS4+NGuKtkK5jqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,259,1708416000"; 
   d="scan'208";a="28237812"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 11:36:10 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: isaku.yamahata@intel.com,
	pbonzini@redhat.com,
	erdemaktas@google.com,
	vkuznets@redhat.com,
	seanjc@google.com,
	vannapurve@google.com,
	jmattson@google.com,
	mlevitsk@redhat.com,
	xiaoyao.li@intel.com,
	chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	yuan.yao@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V6 3/4] KVM: x86: Add a capability to configure bus frequency for APIC timer
Date: Mon,  6 May 2024 11:35:57 -0700
Message-Id: <2b69deffadfd5f52355eee26c45a8d97e75d4f8c.1715017765.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1715017765.git.reinette.chatre@intel.com>
References: <cover.1715017765.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add KVM_CAP_X86_APIC_BUS_CYCLES_NS capability to configure the APIC
bus clock frequency for APIC timer emulation.
Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_CYCLES_NS) to set the
frequency in nanoseconds. When using this capability, the user space
VMM should configure CPUID leaf 0x15 to advertise the frequency.

Vishal reported that the TDX guest kernel expects a 25MHz APIC bus
frequency but ends up getting interrupts at a significantly higher rate.

The TDX architecture hard-codes the core crystal clock frequency to
25MHz and mandates exposing it via CPUID leaf 0x15. The TDX architecture
does not allow the VMM to override the value.

In addition, per Intel SDM:
    "The APIC timer frequency will be the processor’s bus clock or core
     crystal clock frequency (when TSC/core crystal clock ratio is
     enumerated in CPUID leaf 0x15) divided by the value specified in
     the divide configuration register."

The resulting 25MHz APIC bus frequency conflicts with the KVM hardcoded
APIC bus frequency of 1GHz.

The KVM doesn't enumerate CPUID leaf 0x15 to the guest unless the user
space VMM sets it using KVM_SET_CPUID. If the CPUID leaf 0x15 is
enumerated, the guest kernel uses it as the APIC bus frequency. If not,
the guest kernel measures the frequency based on other known timers like
the ACPI timer or the legacy PIT. As reported by Vishal the TDX guest
kernel expects a 25MHz timer frequency but gets timer interrupt more
frequently due to the 1GHz frequency used by KVM.

To ensure that the guest doesn't have a conflicting view of the APIC bus
frequency, allow the userspace to tell KVM to use the same frequency that
TDX mandates instead of the default 1Ghz.

There are several options to address this:
1. Make the KVM able to configure APIC bus frequency (this series).
   Pro: It resembles the existing hardware.  The recent Intel CPUs
        adapts 25MHz.
   Con: Require the VMM to emulate the APIC timer at 25MHz.
2. Make the TDX architecture enumerate CPUID leaf 0x15 to configurable
   frequency or not enumerate it.
   Pro: Any APIC bus frequency is allowed.
   Con: Deviates from TDX architecture.
3. Make the TDX guest kernel use 1GHz when it's running on KVM.
   Con: The kernel ignores CPUID leaf 0x15.
4. Change CPUID leaf 0x15 under TDX to report the crystal clock frequency
   as 1 GHz.
   Pro: This has been the virtual APIC frequency for KVM guests for 13
        years.
   Pro: This requires changing only one hard-coded constant in TDX.
   Con: It doesn't work with other VMMs as TDX isn't specific to KVM.
   Con: Core crystal clock frequency is also used to calculate TSC
        frequency.
   Con: If it is configured to value different from hardware, it will
        break the correctness of INTEL-PT Mini Time Count (MTC) packets
        in TDs.

Reported-by: Vishal Annapurve <vannapurve@google.com>
Closes: https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
Changes v6:
- Add Yuan Yao's Reviewed-by tag.
- Add Xiaoyao Li's Reviewed-by tag.

Changes v5:
- Rename capability KVM_CAP_X86_APIC_BUS_FREQUENCY ->
  KVM_CAP_X86_APIC_BUS_CYCLES_NS. (Xiaoyao Li)
- Add Rick's Reviewed-by tag.

Changes v4:
- Rework implementation following Sean's guidance in:
  https://lore.kernel.org/all/ZdjzIgS6EAeCsUue@google.com/
- Reword con #2 to acknowledge feedback. (Sean)
- Add the "con" information from Xiaoyao during earlier review of v2.
- Rework changelog to address comments related to "bus clock" vs
  "core crystal clock" frequency. (Xiaoyao)
- Drop snippet about impact on TSC deadline timer emulation. (Maxim)
- Drop Maxim Levitsky's "Reviewed-by" tag due to many changes to patch
  since tag received.
- Switch "Subject:" to match custom "KVM: X86:" -> "KVM: x86:"

Changes v3:
- Added reviewed-by Maxim Levitsky.
- Minor update of the commit message.

Changes v2:
- Add check if vcpu isn't created.
- Add check if lapic chip is in-kernel emulation.
- Fix build error for i386.
- Add document to api.rst.
- Typo in the commit message.
---
 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 arch/x86/kvm/x86.c             | 27 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 45 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c6a57cebb65c..7f6d4b5e3a53 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8063,6 +8063,23 @@ error/annotated fault.
 
 See KVM_EXIT_MEMORY_FAULT for more information.
 
+7.35 KVM_CAP_X86_APIC_BUS_CYCLES_NS
+-----------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is the desired APIC bus clock rate, in nanoseconds
+:Returns: 0 on success, -EINVAL if args[0] contains an invalid value for the
+          frequency or if any vCPUs have been created, -ENXIO if a virtual
+          local APIC has not been created using KVM_CREATE_IRQCHIP.
+
+This capability sets VM's APIC bus clock frequency, used by KVM's in-kernel
+virtual APIC when emulating APIC timers.  KVM's default value can be retrieved
+by KVM_CHECK_EXTENSION.
+
+Note: Userspace is responsible for correctly configuring CPUID 0x15, a.k.a. the
+core crystal clock frequency, if a non-zero CPUID 0x15 is exposed to the guest.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc3c63e58488..f560811d658b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4712,6 +4712,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
+	case KVM_CAP_X86_APIC_BUS_CYCLES_NS:
+		r = APIC_BUS_CYCLE_NS_DEFAULT;
+		break;
 	case KVM_CAP_EXIT_HYPERCALL:
 		r = KVM_EXIT_HYPERCALL_VALID_MASK;
 		break;
@@ -6752,6 +6755,30 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_X86_APIC_BUS_CYCLES_NS: {
+		u64 bus_cycle_ns = cap->args[0];
+		u64 unused;
+
+		r = -EINVAL;
+		/*
+		 * Guard against overflow in tmict_to_ns(). 128 is the highest
+		 * divide value that can be programmed in APIC_TDCR.
+		 */
+		if (!bus_cycle_ns ||
+		    check_mul_overflow((u64)U32_MAX * 128, bus_cycle_ns, &unused))
+			break;
+
+		r = 0;
+		mutex_lock(&kvm->lock);
+		if (!irqchip_in_kernel(kvm))
+			r = -ENXIO;
+		else if (kvm->created_vcpus)
+			r = -EINVAL;
+		else
+			kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
+		mutex_unlock(&kvm->lock);
+		break;
+	}
 	default:
 		r = -EINVAL;
 		break;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..6a4d9432ab11 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_X86_APIC_BUS_CYCLES_NS 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.34.1


