Return-Path: <kvm+bounces-15986-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC86A8B2CCE
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 00:13:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 434AB1F25490
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8E417F363;
	Thu, 25 Apr 2024 22:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c+6mi16P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCFF179949;
	Thu, 25 Apr 2024 22:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714082837; cv=none; b=Z1vERTeFAbtA/riMyvj4wYZ5Y2GotFIrqwZ6fYVTuJEKrzVbEiM5vgdulEMIJT/5+/CGbrpvj4/EVb6LQcz4mPkhpbsCBzpdPnPwYkqsP5Mhv+s5QCYvMXrwFR86ep1c60VkZr/QB7au2moWRRw0vIZW6guVsUbgclKCNzmI1LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714082837; c=relaxed/simple;
	bh=JTl16X5bj/MmJ0bJePdBwMZKkUZ2jYt38s2m5j8ERRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aNm9mlc6QOe9BfvVwv2dRDB4fr9wMIBBWGPBHyWrR/NDFtud17DgJQLGjXQgcqBthk1u9XNCdLLHHqJVyByh5T7Vom+EGR664gy+kSiM0mJ3E0AWzv+bVofKYIipFrLoWWh9Bw7ainU7mNPOWRsCJDCaXZDHodefhiEzrfTK4VQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c+6mi16P; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714082835; x=1745618835;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JTl16X5bj/MmJ0bJePdBwMZKkUZ2jYt38s2m5j8ERRc=;
  b=c+6mi16PrnTkT+LSkT/4eoNurnbr1mmrrOQZvz3VHkoILBMXrVEGS7iE
   0T5YtszKnObDaSYgdai6WWYMrFHFmhxo3DiL5mdMFFK8eHE59ghD74w3m
   5mKDZaHgdK8wbUXgOfQT6cStrSApO1+xMQKic5zbS+4utAC5ds79fBX2Q
   09hwyBohkTmBG9NfQl74dan7YEAxKNMMCd/LrxLuxFWLV8O/FewC18cgQ
   PvCCJAgyLqsI02oCcMNFBygNJK/W/bc1qhIROauPB5ByZlkB5etSP1WAY
   1HBG6UQv6z1OFTNy4tCf0YBCqbIOBlQNf/ZbVhuaCR4MXoQu/YplWe+nX
   A==;
X-CSE-ConnectionGUID: rV3aXN13Qvq68ya70YYWTw==
X-CSE-MsgGUID: EX6W0NKPQa6teORcnFCqzw==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="13585404"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="13585404"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:07:12 -0700
X-CSE-ConnectionGUID: FvHonqxtRE2EyLhryIWq9w==
X-CSE-MsgGUID: PR+gXpIJTkqgG3N6K0UOmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25185089"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 15:07:12 -0700
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
	rick.p.edgecombe@intel.com
Cc: reinette.chatre@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V5 3/4] KVM: x86: Add a capability to configure bus frequency for APIC timer
Date: Thu, 25 Apr 2024 15:07:01 -0700
Message-Id: <6748a4c12269e756f0c48680da8ccc5367c31ce7.1714081726.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1714081725.git.reinette.chatre@intel.com>
References: <cover.1714081725.git.reinette.chatre@intel.com>
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
Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
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

 Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
 arch/x86/kvm/x86.c             | 27 +++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 3 files changed, 45 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index f0b76ff5030d..f014cd9b2217 100644
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
index 10e6315103f4..fa6954c9a9d2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4715,6 +4715,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
+	case KVM_CAP_X86_APIC_BUS_CYCLES_NS:
+		r = APIC_BUS_CYCLE_NS_DEFAULT;
+		break;
 	case KVM_CAP_EXIT_HYPERCALL:
 		r = KVM_EXIT_HYPERCALL_VALID_MASK;
 		break;
@@ -6755,6 +6758,30 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
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


