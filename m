Return-Path: <kvm+bounces-16134-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A718B50B9
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 07:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F5871F21F4E
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 05:28:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8807DDF59;
	Mon, 29 Apr 2024 05:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vme8Aj58"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB368BE2;
	Mon, 29 Apr 2024 05:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714368492; cv=none; b=qbnC+ZYdMZuvoPPV2l0FHN4k+jllSRDk7mCscCifkLy2nyin/dNIG5HK/+OmHy1ayFIWkqF6kM6nyaBANMa8A7EygmrTJ4ADVgdponobENz+FTRWXRnhyh2gA5AMOXS7hSEl5r4kyhCNPyihA60mF7tGTkfHloK9Zdy9rF62Abs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714368492; c=relaxed/simple;
	bh=GXqfD+mhyD93lvJEnldh1X3LIZPQ3b/q2ihJ2sJw/ro=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=biksD/hoYmv+4l4SCAEKI9e2bhp0YGRIomX9xDc4u2MSZyR8RDRxB2rFY8yRsUK0HJfQnLhZSphcBYgDKl7AkEvfiOd/SMm4dDhOijGj/+nvA/NW+VkoBzTGGBZ1Bb44MI9dPdJzVIUqenxsuGJulNiwsOnqTcBQbqXlYSdjsk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vme8Aj58; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714368490; x=1745904490;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GXqfD+mhyD93lvJEnldh1X3LIZPQ3b/q2ihJ2sJw/ro=;
  b=Vme8Aj58La4mYqruOYJDgN7jqbkmpQ16tRlBMs8EQeu/TXMfflsc+VUF
   rzsvZr0icbC6Uda2W1GrewUfe7Uy1eg61vsWwCPnwxh9cM3DABuWuGx3L
   G2ktXRK5UEFfRR1qeTClXVk5PQItlJ6eMUQG3dQbvTrCC3OsCzj9WgPE1
   +3VBil4TcuZBGt0A/ei3+is4r+17GOlSZGY3QB8FFv0tuVR4PeaAT2/Yc
   Jw9sw30szqaA5lu/wUsXDjjX/x8pTb9ISxGQyQC7mMw/uRvU+r+k9UshC
   b1zUUsLSmcbmIlolWKbOlDliIkJDB3jF0cAc40Vr2F7rs/U3pK8RKvE0J
   Q==;
X-CSE-ConnectionGUID: gV32TAbYQG2TJ/p8Oe5S3w==
X-CSE-MsgGUID: q14eGwziTpalN2GE7YBPlw==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="9897621"
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="9897621"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 22:28:09 -0700
X-CSE-ConnectionGUID: oOkl1dw2Tz2klj8z8Bo35Q==
X-CSE-MsgGUID: pGxZfn3vSp2sKJgivZmbMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="26070351"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 22:28:06 -0700
Message-ID: <a9e7004f-0d2d-4a32-b663-a57391a9cedd@intel.com>
Date: Mon, 29 Apr 2024 13:28:02 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 3/4] KVM: x86: Add a capability to configure bus
 frequency for APIC timer
To: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com,
 pbonzini@redhat.com, erdemaktas@google.com, vkuznets@redhat.com,
 seanjc@google.com, vannapurve@google.com, jmattson@google.com,
 mlevitsk@redhat.com, chao.gao@intel.com, rick.p.edgecombe@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <6748a4c12269e756f0c48680da8ccc5367c31ce7.1714081726.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <6748a4c12269e756f0c48680da8ccc5367c31ce7.1714081726.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/26/2024 6:07 AM, Reinette Chatre wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Add KVM_CAP_X86_APIC_BUS_CYCLES_NS capability to configure the APIC
> bus clock frequency for APIC timer emulation.
> Allow KVM_ENABLE_CAPABILITY(KVM_CAP_X86_APIC_BUS_CYCLES_NS) to set the
> frequency in nanoseconds. When using this capability, the user space
> VMM should configure CPUID leaf 0x15 to advertise the frequency.
> 
> Vishal reported that the TDX guest kernel expects a 25MHz APIC bus
> frequency but ends up getting interrupts at a significantly higher rate.
> 
> The TDX architecture hard-codes the core crystal clock frequency to
> 25MHz and mandates exposing it via CPUID leaf 0x15. The TDX architecture
> does not allow the VMM to override the value.
> 
> In addition, per Intel SDM:
>      "The APIC timer frequency will be the processor’s bus clock or core
>       crystal clock frequency (when TSC/core crystal clock ratio is
>       enumerated in CPUID leaf 0x15) divided by the value specified in
>       the divide configuration register."
> 
> The resulting 25MHz APIC bus frequency conflicts with the KVM hardcoded
> APIC bus frequency of 1GHz.
> 
> The KVM doesn't enumerate CPUID leaf 0x15 to the guest unless the user
> space VMM sets it using KVM_SET_CPUID. If the CPUID leaf 0x15 is
> enumerated, the guest kernel uses it as the APIC bus frequency. If not,
> the guest kernel measures the frequency based on other known timers like
> the ACPI timer or the legacy PIT. As reported by Vishal the TDX guest
> kernel expects a 25MHz timer frequency but gets timer interrupt more
> frequently due to the 1GHz frequency used by KVM.
> 
> To ensure that the guest doesn't have a conflicting view of the APIC bus
> frequency, allow the userspace to tell KVM to use the same frequency that
> TDX mandates instead of the default 1Ghz.
> 
> There are several options to address this:
> 1. Make the KVM able to configure APIC bus frequency (this series).
>     Pro: It resembles the existing hardware.  The recent Intel CPUs
>          adapts 25MHz.
>     Con: Require the VMM to emulate the APIC timer at 25MHz.
> 2. Make the TDX architecture enumerate CPUID leaf 0x15 to configurable
>     frequency or not enumerate it.
>     Pro: Any APIC bus frequency is allowed.
>     Con: Deviates from TDX architecture.
> 3. Make the TDX guest kernel use 1GHz when it's running on KVM.
>     Con: The kernel ignores CPUID leaf 0x15.
> 4. Change CPUID leaf 0x15 under TDX to report the crystal clock frequency
>     as 1 GHz.
>     Pro: This has been the virtual APIC frequency for KVM guests for 13
>          years.
>     Pro: This requires changing only one hard-coded constant in TDX.
>     Con: It doesn't work with other VMMs as TDX isn't specific to KVM.
>     Con: Core crystal clock frequency is also used to calculate TSC
>          frequency.
>     Con: If it is configured to value different from hardware, it will
>          break the correctness of INTEL-PT Mini Time Count (MTC) packets
>          in TDs.
> 
> Reported-by: Vishal Annapurve <vannapurve@google.com>
> Closes: https://lore.kernel.org/lkml/20231006011255.4163884-1-vannapurve@google.com/
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Co-developed-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
> Changes v5:
> - Rename capability KVM_CAP_X86_APIC_BUS_FREQUENCY ->
>    KVM_CAP_X86_APIC_BUS_CYCLES_NS. (Xiaoyao Li)
> - Add Rick's Reviewed-by tag.
> 
> Changes v4:
> - Rework implementation following Sean's guidance in:
>    https://lore.kernel.org/all/ZdjzIgS6EAeCsUue@google.com/
> - Reword con #2 to acknowledge feedback. (Sean)
> - Add the "con" information from Xiaoyao during earlier review of v2.
> - Rework changelog to address comments related to "bus clock" vs
>    "core crystal clock" frequency. (Xiaoyao)
> - Drop snippet about impact on TSC deadline timer emulation. (Maxim)
> - Drop Maxim Levitsky's "Reviewed-by" tag due to many changes to patch
>    since tag received.
> - Switch "Subject:" to match custom "KVM: X86:" -> "KVM: x86:"
> 
> Changes v3:
> - Added reviewed-by Maxim Levitsky.
> - Minor update of the commit message.
> 
> Changes v2:
> - Add check if vcpu isn't created.
> - Add check if lapic chip is in-kernel emulation.
> - Fix build error for i386.
> - Add document to api.rst.
> - Typo in the commit message.
> 
>   Documentation/virt/kvm/api.rst | 17 +++++++++++++++++
>   arch/x86/kvm/x86.c             | 27 +++++++++++++++++++++++++++
>   include/uapi/linux/kvm.h       |  1 +
>   3 files changed, 45 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f0b76ff5030d..f014cd9b2217 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8063,6 +8063,23 @@ error/annotated fault.
>   
>   See KVM_EXIT_MEMORY_FAULT for more information.
>   
> +7.35 KVM_CAP_X86_APIC_BUS_CYCLES_NS
> +-----------------------------------
> +
> +:Architectures: x86
> +:Target: VM
> +:Parameters: args[0] is the desired APIC bus clock rate, in nanoseconds
> +:Returns: 0 on success, -EINVAL if args[0] contains an invalid value for the
> +          frequency or if any vCPUs have been created, -ENXIO if a virtual
> +          local APIC has not been created using KVM_CREATE_IRQCHIP.
> +
> +This capability sets VM's APIC bus clock frequency, used by KVM's in-kernel
> +virtual APIC when emulating APIC timers.  KVM's default value can be retrieved
> +by KVM_CHECK_EXTENSION.
> +
> +Note: Userspace is responsible for correctly configuring CPUID 0x15, a.k.a. the
> +core crystal clock frequency, if a non-zero CPUID 0x15 is exposed to the guest.
> +
>   8. Other capabilities.
>   ======================
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 10e6315103f4..fa6954c9a9d2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4715,6 +4715,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   	case KVM_CAP_MEMORY_FAULT_INFO:
>   		r = 1;
>   		break;
> +	case KVM_CAP_X86_APIC_BUS_CYCLES_NS:
> +		r = APIC_BUS_CYCLE_NS_DEFAULT;
> +		break;
>   	case KVM_CAP_EXIT_HYPERCALL:
>   		r = KVM_EXIT_HYPERCALL_VALID_MASK;
>   		break;
> @@ -6755,6 +6758,30 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   		}
>   		mutex_unlock(&kvm->lock);
>   		break;
> +	case KVM_CAP_X86_APIC_BUS_CYCLES_NS: {
> +		u64 bus_cycle_ns = cap->args[0];
> +		u64 unused;
> +
> +		r = -EINVAL;
> +		/*
> +		 * Guard against overflow in tmict_to_ns(). 128 is the highest
> +		 * divide value that can be programmed in APIC_TDCR.
> +		 */
> +		if (!bus_cycle_ns ||
> +		    check_mul_overflow((u64)U32_MAX * 128, bus_cycle_ns, &unused))
> +			break;
> +
> +		r = 0;
> +		mutex_lock(&kvm->lock);
> +		if (!irqchip_in_kernel(kvm))
> +			r = -ENXIO;
> +		else if (kvm->created_vcpus)
> +			r = -EINVAL;
> +		else
> +			kvm->arch.apic_bus_cycle_ns = bus_cycle_ns;
> +		mutex_unlock(&kvm->lock);
> +		break;
> +	}
>   	default:
>   		r = -EINVAL;
>   		break;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 2190adbe3002..6a4d9432ab11 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -917,6 +917,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_MEMORY_ATTRIBUTES 233
>   #define KVM_CAP_GUEST_MEMFD 234
>   #define KVM_CAP_VM_TYPES 235
> +#define KVM_CAP_X86_APIC_BUS_CYCLES_NS 236
>   
>   struct kvm_irq_routing_irqchip {
>   	__u32 irqchip;


