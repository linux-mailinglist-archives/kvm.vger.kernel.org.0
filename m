Return-Path: <kvm+bounces-38641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BEA7A3D104
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 06:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3CFA1890463
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 05:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C951E2611;
	Thu, 20 Feb 2025 05:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LoCagbYm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521A8A930;
	Thu, 20 Feb 2025 05:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740030634; cv=none; b=cVvIawECkywNyEOJI8G3R2Hkgtn8d0RDie4hiNFGoLBGdvOL9b9aqEB3Fw8lJm417gNPRxXWBD1rSVW0X5HYAE4SNUPKG9Fd2aXEuipOZEisXrfOm3cv+4mJfLcBmG2T0ylp/rBCl0kYNLKGk2AdXG5DasE/0CyARk3fSYns4sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740030634; c=relaxed/simple;
	bh=U+5M+vqypOZJDPsf+vu1hgdXyegXZEK1rQU8Y2jt+zA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WgLJATcUeECu3A5RtwbYjdGJDlgbELi2ooyYVa3dNjP77LIh6VsHdtZLkL93BGy61ihqYttUOjVLGN5Y5QyFXRtfyCrPvL5i9cMwpXCcUZqMe87VFFKjjUyajcBDpK8MaxYvaBDi0ug7wVZByOyYidh5qYK0/kwoUskjGAAwUec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LoCagbYm; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740030632; x=1771566632;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=U+5M+vqypOZJDPsf+vu1hgdXyegXZEK1rQU8Y2jt+zA=;
  b=LoCagbYmlDiVuHUYXZi6zo7SPwYbuOguvzAmNuHNPDJwMti843qK2IJT
   4N2nvr9iSGAVMPimJBbZl9482EB00a1DEzHdY1Og91eSroJK6zQIVcBVO
   cPKPpYfpjXromI3S9Hhkqw2yK0AfHxLL3dKJh9eC2k0Hb4P3EQ+xBjzu3
   KMTrhBxjxFwN6duZWwTxDW8QFwG7ONI3iQhjw8fnaWaKzBjEmMmdkA6tt
   MaclPmr5ujV0ZE7aEb0lp+JB01k8J2/zV96tyBTrXjWytRmWWWZsHOY1q
   SX/lTKb22y7i+DwG7kEfJkjLKJNXvAFDFYv8vbD6l7HXzWwRriJu50Vmp
   w==;
X-CSE-ConnectionGUID: HnWpCWvqROCZ7l7q8MwmdQ==
X-CSE-MsgGUID: NzH+ZFn9QsqkE6DxUnOdJA==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="58338299"
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="58338299"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 21:50:31 -0800
X-CSE-ConnectionGUID: I2BuGFMCTd+x0fIdquXZug==
X-CSE-MsgGUID: iIbZapYTSC63ZIWg6mXlww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="114777626"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 21:50:28 -0800
Message-ID: <c88a93e4-3314-4372-bacf-b9b2e234b1da@intel.com>
Date: Thu, 20 Feb 2025 13:50:24 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 18/18] Documentation/virt/kvm: Document on Trust Domain
 Extensions(TDX)
To: "Huang, Kai" <kai.huang@intel.com>, Binbin Wu
 <binbin.wu@linux.intel.com>, pbonzini@redhat.com, seanjc@google.com,
 kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com, adrian.hunter@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com,
 linux-kernel@vger.kernel.org
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
 <20241210004946.3718496-19-binbin.wu@linux.intel.com>
 <9cdf63d6-6e8d-4f68-a4be-c16ca4c22426@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <9cdf63d6-6e8d-4f68-a4be-c16ca4c22426@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/19/2025 6:23 PM, Huang, Kai wrote:
> 
> 
> On 10/12/2024 1:49 pm, Binbin Wu wrote:
...
>> +
>> +
>> +API description
>> +===============
>> +
>> +KVM_MEMORY_ENCRYPT_OP
>> +---------------------
>> +:Type: vm ioctl, vcpu ioctl
>> +
>> +For TDX operations, KVM_MEMORY_ENCRYPT_OP is re-purposed to be generic
>> +ioctl with TDX specific sub ioctl command.
> 
> command -> commands.
> 
>> +
>> +::
>> +
>> +  /* Trust Domain eXtension sub-ioctl() commands. */
> 
> I think "Extensions" is used in every place in the kernel, so 
> "eXtension" -> "Extensions".
> 
> And lack of consistency between "sub ioctl commands" and "sub-ioctl() 
> commands".  Perhaps just use "sub-commands" for all the places.

It's copied from the kernel header file, we need to fix there at first.

>> +  enum kvm_tdx_cmd_id {
>> +          KVM_TDX_CAPABILITIES = 0,
>> +          KVM_TDX_INIT_VM,
>> +          KVM_TDX_INIT_VCPU,
>> +          KVM_TDX_INIT_MEM_REGION,
>> +          KVM_TDX_FINALIZE_VM,
>> +          KVM_TDX_GET_CPUID,
>> +
>> +          KVM_TDX_CMD_NR_MAX,
>> +  };
>> +
>> +  struct kvm_tdx_cmd {
>> +        /* enum kvm_tdx_cmd_id */
>> +        __u32 id;
>> +        /* flags for sub-commend. If sub-command doesn't use this, 
>> set zero. */
> 
> commend -> command.

Ditto.

>> +        __u32 flags;
>> +        /*
>> +         * data for each sub-command. An immediate or a pointer to 
>> the actual
>> +         * data in process virtual address.  If sub-command doesn't 
>> use it,
>> +         * set zero.
>> +         */
>> +        __u64 data;
>> +        /*
>> +         * Auxiliary error code.  The sub-command may return TDX 
>> SEAMCALL
>> +         * status code in addition to -Exxx.
>> +         * Defined for consistency with struct kvm_sev_cmd.
>> +         */
> 
> "Defined for consistency with struct kvm_sev_cmd" got removed in the 
> code.  It should be removed here too.
> 
>> +        __u64 hw_error;
>> +  };
>> +
>> +KVM_TDX_CAPABILITIES
>> +--------------------
>> +:Type: vm ioctl
>> +
>> +Subset of TDSYSINFO_STRUCT retrieved by TDH.SYS.INFO TDX SEAM call 
>> will be
>> +returned. It describes the Intel TDX module.
> 
> We are not using TDH.SYS.INFO and TDSYSINFO_STRUCT anymore.  Perhaps:
> 
>      Retrive TDX moduel global capabilities for running TDX guests.

(some typos: Retrive => Retrieve, moduel => module)

It's not TDX module global capabilities. It has been adjuested by KVM to 
mask off the bits that are not supported by the KVM.

How about:

Return the TDX capabilities that current KVM supports with the specific 
TDX module loaeded in the system. It reports what features/capabilities 
are allowed to be configured to the TDX guest.

>> +
>> +- id: KVM_TDX_CAPABILITIES
>> +- flags: must be 0
>> +- data: pointer to struct kvm_tdx_capabilities
>> +- error: must be 0
>> +- unused: must be 0
> 
> @error should be @hw_error.
> 
> And I don't see @unused anyware in the 'struct kvm_tdx_cmd'.  Should be 
> removed.
> 
> The same to all below sub-commands.
> 
>> +
>> +::
>> +
>> +  struct kvm_tdx_capabilities {
>> +        __u64 supported_attrs;
>> +        __u64 supported_xfam;
>> +        __u64 reserved[254];
>> +        struct kvm_cpuid2 cpuid;
>> +  };
>> +
>> +
>> +KVM_TDX_INIT_VM
>> +---------------
>> +:Type: vm ioctl
> 
> I would add description for return values:
> 
>      :Returns: 0 on success, <0 on error.

+1,

I have added it for KVM_TDX_GET_CPUID internally.

> We can also repeat this in all sub-commands, but I am not sure it's 
> necessary.
> 
>> +
>> +Does additional VM initialization specific to TDX which corresponds to
>> +TDH.MNG.INIT TDX SEAM call.
> 
> "SEAM call" -> "SEAMCALL" for consistency.  And the same to below all 
> sub-commands.
> 
> Nit:
> 
> I am not sure whether we need to, or should, mention the detailed 
> SEAMCALL here.  To me the ABI doesn't need to document the detailed 
> implementation (i.e., which SEAMCALL is used) in the underneath kernel.

Agreed to drop mentioning the detailed SEAMCALL.

Maybe, we can mention the sequence requirement as well, that it needs to 
be called after KVM_CREATE_VM and before creating any VCPUs.

>> +
>> +- id: KVM_TDX_INIT_VM
>> +- flags: must be 0
>> +- data: pointer to struct kvm_tdx_init_vm
>> +- error: must be 0
>> +- unused: must be 0
>> +
>> +::
>> +
>> +  struct kvm_tdx_init_vm {
>> +          __u64 attributes;
>> +          __u64 xfam;
>> +          __u64 mrconfigid[6];          /* sha384 digest */
>> +          __u64 mrowner[6];             /* sha384 digest */
>> +          __u64 mrownerconfig[6];       /* sha384 digest */
>> +
>> +          /* The total space for TD_PARAMS before the CPUIDs is 256 
>> bytes */
>> +          __u64 reserved[12];
>> +
>> +        /*
>> +         * Call KVM_TDX_INIT_VM before vcpu creation, thus before
>> +         * KVM_SET_CPUID2.
>> +         * This configuration supersedes KVM_SET_CPUID2s for VCPUs 
>> because the
>> +         * TDX module directly virtualizes those CPUIDs without VMM.  
>> The user
>> +         * space VMM, e.g. qemu, should make KVM_SET_CPUID2 
>> consistent with
>> +         * those values.  If it doesn't, KVM may have wrong idea of 
>> vCPUIDs of
>> +         * the guest, and KVM may wrongly emulate CPUIDs or MSRs that 
>> the TDX
>> +         * module doesn't virtualize.
>> +         */
>> +          struct kvm_cpuid2 cpuid;
>> +  };
>> +
>> +
>> +KVM_TDX_INIT_VCPU
>> +-----------------
>> +:Type: vcpu ioctl
>> +
>> +Does additional VCPU initialization specific to TDX which corresponds to
>> +TDH.VP.INIT TDX SEAM call.

Same for the TDH.VP.INIT SEAMCALL, I don't think we need to mention it.
And KVM_TDX_INIT_VCPU does more things other than TDH.VP.INIT.

How about just:

   Perform TDX specific VCPU initialization

>> +- id: KVM_TDX_INIT_VCPU
>> +- flags: must be 0
>> +- data: initial value of the guest TD VCPU RCX
>> +- error: must be 0
>> +- unused: must be 0
>> +
>> +KVM_TDX_INIT_MEM_REGION
>> +-----------------------
>> +:Type: vcpu ioctl
>> +
>> +Encrypt a memory continuous region which corresponding to 
>> TDH.MEM.PAGE.ADD
>> +TDX SEAM call.
> 
> "a contiguous guest memory region"?
> 
> And "which corresponding to .." has grammar issue.
> 
> How about:
> 
>      Load and encrypt a contiguous memory region from the source
>      memory which corresponds to the TDH.MEM.PAGE.ADD TDX SEAMCALL.

As sugguested above, I prefer to drop mentionting the detailed SEAMCALL.

Besides, it's better to call out the dependence that the gpa needs to be 
set to private attribute before calling KVM_TDX_INIT_MEM_REGION to 
initialize the priviate memory.

How about:

   Initialize @nr_pages TDX guest private memory starting from @gpa with
   userspace provided data from @source_addr.

   Note, before calling this sub command, memory attribute of the range
   [gpa, gpa + nr_pages] needs to be private. Userspace can use
   KVM_SET_MEMORY_ATTRIBUTES to set the attribute.


>> +If KVM_TDX_MEASURE_MEMORY_REGION flag is specified, it also extends 
>> measurement
>> +which corresponds to TDH.MR.EXTEND TDX SEAM call.
>> +
>> +- id: KVM_TDX_INIT_MEM_REGION
>> +- flags: flags
>> +            currently only KVM_TDX_MEASURE_MEMORY_REGION is defined
>> +- data: pointer to struct kvm_tdx_init_mem_region
>> +- error: must be 0
>> +- unused: must be 0
>> +
>> +::
>> +
>> +  #define KVM_TDX_MEASURE_MEMORY_REGION   (1UL << 0)
>> +
>> +  struct kvm_tdx_init_mem_region {
>> +          __u64 source_addr;
>> +          __u64 gpa;
>> +          __u64 nr_pages;
>> +  };
>> +
>> +
>> +KVM_TDX_FINALIZE_VM
>> +-------------------
>> +:Type: vm ioctl
>> +
>> +Complete measurement of the initial TD contents and mark it ready to run
>> +which corresponds to TDH.MR.FINALIZE
> 
> Missing period at the end of the sentence.
> 
> And nit again: I don't like the "which corresponds to TDH.MR.FINALIZE".
> 
>> +
>> +- id: KVM_TDX_FINALIZE_VM
>> +- flags: must be 0
>> +- data: must be 0
>> +- error: must be 0
>> +- unused: must be 0
> 
> 
> This patch doesn't contain KVM_TDX_GET_CPUID.  I saw in internal dev 
> branch we have it.
> 

I added it in the internal branch. Next version post should have it.

>> +
>> +KVM TDX creation flow
>> +=====================
>> +In addition to KVM normal flow, new TDX ioctls need to be called.  
>> The control flow
>> +looks like as follows.
>> +
>> +#. system wide capability check
> 
> To make all consistent:
> 
> Check system wide capability
> 
>> +
>> +   * KVM_CAP_VM_TYPES: check if VM type is supported and if 
>> KVM_X86_TDX_VM
>> +     is supported.
>> +
>> +#. creating VM
> 
> Create VM
>> +
>> +   * KVM_CREATE_VM
>> +   * KVM_TDX_CAPABILITIES: query if TDX is supported on the platform.
> 
> "TDX is supported or not" is already checked in step 1.
> 
> I think we should say:
> 
> query TDX global capabilities for creating TDX guests.

I don't like the "global" term and I don't think it's correct.

KVM_TDX_CAPABILITIES was requested to change from the platform-scope 
ioctl to VM-scope. It should only report the per-TD capabilities, though 
it's identical for all TDs currently.

>> +   * KVM_ENABLE_CAP_VM(KVM_CAP_MAX_VCPUS): set max_vcpus. 
>> KVM_MAX_VCPUS by
>> +     default.  KVM_MAX_VCPUS is not a part of ABI, but kernel 
>> internal constant
>> +     that is subject to change.  Because max vcpus is a part of 
>> attestation, max
>> +     vcpus should be explicitly set.
> 
> This is out-of-date.
> 
>        * KVM_CHECK_EXTENSION(KVM_CAP_MAX_VCPUS): query maximum vcpus the
>      TDX guest can support (TDX has its own limitation on this).

More precisely, KVM_CHECK_EXTESION(KVM_CAP_MAX_VCPUS) at vm level

>> +   * KVM_SET_TSC_KHZ for vm. optional
> 
> For consistency:
> 
>        * KVM_SET_TSC_KHZ: optional

More precisely, KVM_SET_TSC_KHZ at VM-level if userspace desires a 
different TSC frequency than the host. Otherwise, host's TSC frequency 
will be configured for the TD.

> 
>> +   * KVM_TDX_INIT_VM: pass TDX specific VM parameters.
>> +
>> +#. creating VCPU
> 
> Create vCPUs
> 
>> +
>> +   * KVM_CREATE_VCPU
>> +   * KVM_TDX_INIT_VCPU: pass TDX specific VCPU parameters.
>> +   * KVM_SET_CPUID2: Enable CPUID[0x1].ECX.X2APIC(bit 21)=1 so that 
>> the following
>> +     setting of MSR_IA32_APIC_BASE success. Without this,
>> +     KVM_SET_MSRS(MSR_IA32_APIC_BASE) fails.
> 
> I would prefer to put X2APIC specific to a note:
> 
>        * KVM_SET_CPUID2: configure guest's CPUIDs.  Note: Enable ...
> 
>> +   * KVM_SET_MSRS: Set the initial reset value of MSR_IA32_APIC_BASE to
>> +     APIC_DEFAULT_ADDRESS(0xfee00000) | XAPIC_ENABLE(bit 10) |
>> +     X2APIC_ENABLE(bit 11) [| MSR_IA32_APICBASE_BSP(bit 8) optional]

This is not true now. MSR_IA32_APICBASE is read-only MSR for TDX. KVM 
disallows userspace to set MSR_IA32_APICBASE and 
ioctl(KVM_TDX_INIT_VCPU) initialize a correct value for 
MSR_IA32_APICBASE internally.

> Ditto, I believe there are other MSRs to be set too.

It seems no must-to-be-set MSR for TDX guest.

>> +
>> +#. initializing guest memory
> 
> Initialize initial guest memory
> 
>> +
>> +   * allocate guest memory and initialize page same to normal KVM case
> 
> Cannot parse this.
> 
>> +     In TDX case, parse and load TDVF into guest memory in addition.
> 
> Don't understand "parse TDVF" either.
> 
>> +   * KVM_TDX_INIT_MEM_REGION to add and measure guest pages.
>> +     If the pages has contents above, those pages need to be added.
>> +     Otherwise the contents will be lost and guest sees zero pages.
>> +   * KVM_TDX_FINALIAZE_VM: Finalize VM and measurement
>> +     This must be after KVM_TDX_INIT_MEM_REGION.
> 
> Perhaps refine the above to:
> 
> 
>        * Allocate guest memory in the same way as allocating memory for
>      normal VMs.
>        * KVM_TDX_INIT_MEM_REGION to add initial guest memory.  Note for
>      now TDX guests only works with TDVF, thus the TDVF needs to be
>      included in the initial guest memory.
>        * KVM_TDX_FINALIZE_VM: Finalize the measurement of the TDX guest.

I'm not sure if we need to mention TDVF here. I think KVM doesn't care 
about it. People can always create a new virtual bios for TDX guest 
themselves.

>> +
>> +#. run vcpu
> 
> Run vCPUs
> 
>> +
>> +Design discussion
>> +=================
> 
> "discussion" won't be appropriate after merge.  Let's just use "Design 
> details".
> 
>> +
>> +Coexistence of normal(VMX) VM and TD VM
> 
> normal (VMX) VM
> 
>> +---------------------------------------
>> +It's required to allow both legacy(normal VMX) VMs and new TD VMs to
>> +coexist. Otherwise the benefits of VM flexibility would be eliminated.
>> +The main issue for it is that the logic of kvm_x86_ops callbacks for
>> +TDX is different from VMX. On the other hand, the variable,
>> +kvm_x86_ops, is global single variable. Not per-VM, not per-vcpu.
>> +
>> +Several points to be considered:
>> +
>> +  * No or minimal overhead when TDX is 
>> disabled(CONFIG_INTEL_TDX_HOST=n).
>> +  * Avoid overhead of indirect call via function pointers.
>> +  * Contain the changes under arch/x86/kvm/vmx directory and share logic
>> +    with VMX for maintenance.
>> +    Even though the ways to operation on VM (VMX instruction vs TDX
>> +    SEAM call) are different, the basic idea remains the same. So, many
>> +    logic can be shared.
>> +  * Future maintenance
>> +    The huge change of kvm_x86_ops in (near) future isn't expected.
>> +    a centralized file is acceptable.
>> +
>> +- Wrapping kvm x86_ops: The current choice
>> +
>> +  Introduce dedicated file for arch/x86/kvm/vmx/main.c (the name,
>> +  main.c, is just chosen to show main entry points for callbacks.) and
>> +  wrapper functions around all the callbacks with
>> +  "if (is-tdx) tdx-callback() else vmx-callback()".
>> +
>> +  Pros:
>> +
>> +  - No major change in common x86 KVM code. The change is (mostly)
>> +    contained under arch/x86/kvm/vmx/.
>> +  - When TDX is disabled(CONFIG_INTEL_TDX_HOST=n), the overhead is
>> +    optimized out.
>> +  - Micro optimization by avoiding function pointer.
>> +
>> +  Cons:
>> +
>> +  - Many boiler plates in arch/x86/kvm/vmx/main.c.
>> +
>> +KVM MMU Changes
>> +---------------
>> +KVM MMU needs to be enhanced to handle Secure/Shared-EPT. The
>> +high-level execution flow is mostly same to normal EPT case.
>> +EPT violation/misconfiguration -> invoke TDP fault handler ->
>> +resolve TDP fault -> resume execution. (or emulate MMIO)
>> +The difference is, that S-EPT is operated(read/write) via TDX SEAM
>> +call which is expensive instead of direct read/write EPT entry.
>> +One bit of GPA (51 or 47 bit) is repurposed so that it means shared
>> +with host(if set to 1) or private to TD(if cleared to 0).
>> +
>> +- The current implementation
>> +
>> +  * Reuse the existing MMU code with minimal update.  Because the
>> +    execution flow is mostly same. But additional operation, TDX call
>> +    for S-EPT, is needed. So add hooks for it to kvm_x86_ops.
>> +  * For performance, minimize TDX SEAM call to operate on S-EPT. When
>> +    getting corresponding S-EPT pages/entry from faulting GPA, don't
>> +    use TDX SEAM call to read S-EPT entry. Instead create shadow copy
>> +    in host memory.
>> +    Repurpose the existing kvm_mmu_page as shadow copy of S-EPT and
>> +    associate S-EPT to it.
>> +  * Treats share bit as attributes. mask/unmask the bit where
>> +    necessary to keep the existing traversing code works.
>> +    Introduce kvm.arch.gfn_shared_mask and use "if (gfn_share_mask)"
>> +    for special case.
>> +
>> +    * 0 : for non-TDX case
>> +    * 51 or 47 bit set for TDX case.
>> +
>> +  Pros:
>> +
>> +  - Large code reuse with minimal new hooks.
>> +  - Execution path is same.
>> +
>> +  Cons:
>> +
>> +  - Complicates the existing code.
>> +  - Repurpose kvm_mmu_page as shadow of Secure-EPT can be confusing.
>> +
>> +New KVM API, ioctl (sub)command, to manage TD VMs
>> +-------------------------------------------------
>> +Additional KVM APIs are needed to control TD VMs. The operations on TD
>> +VMs are specific to TDX.
>> +
>> +- Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP
>> +
>> +  Although operations for TD VMs aren't necessarily related to memory
>> +  encryption, define sub operations of KVM_MEMORY_ENCRYPT_OP for TDX 
>> specific
>> +  ioctls.
>> +
>> +  Pros:
>> +
>> +  - No major change in common x86 KVM code.
>> +  - Follows the SEV case.
>> +
>> +  Cons:
>> +
>> +  - The sub operations of KVM_MEMORY_ENCRYPT_OP aren't necessarily 
>> memory
>> +    encryption, but operations on TD VMs.
> 
> I vote to get rid of the above "design discussion" completely.
> 
> amd-memory-encryption.rst doesn't seem to have such details.
> 
>> +
>> +References
>> +==========
>> +
>> +.. [1] TDX specification
>> +   https://software.intel.com/content/www/us/en/develop/articles/ 
>> intel-trust-domain-extensions.html
>> +.. [2] Intel Trust Domain Extensions (Intel TDX)
>> +   https://software.intel.com/content/dam/develop/external/us/en/ 
>> documents/tdx-whitepaper-final9-17.pdf
>> +.. [3] Intel CPU Architectural Extensions Specification
>> +   https://software.intel.com/content/dam/develop/external/us/en/ 
>> documents/intel-tdx-cpu-architectural-specification.pdf
>> +.. [4] Intel TDX Module 1.0 EAS
>> +   https://software.intel.com/content/dam/develop/external/us/en/ 
>> documents/intel-tdx-module-1eas.pdf
>> +.. [5] Intel TDX Loader Interface Specification
>> +   https://software.intel.com/content/dam/develop/external/us/en/ 
>> documents/intel-tdx-seamldr-interface-specification.pdf
>> +.. [6] Intel TDX Guest-Hypervisor Communication Interface
>> +   https://software.intel.com/content/dam/develop/external/us/en/ 
>> documents/intel-tdx-guest-hypervisor-communication-interface.pdf
>> +.. [7] Intel TDX Virtual Firmware Design Guide
>> +   https://software.intel.com/content/dam/develop/external/us/en/ 
>> documents/tdx-virtual-firmware-design-guide-rev-1.
> 
> As said above, I think we can just provide a link which contains all -- 
> whitepaper, specs, and other things like source code.
> 
>> +.. [8] intel public github
>> +
>> +   * kvm TDX branch: https://github.com/intel/tdx/tree/kvm
>> +   * TDX guest branch: https://github.com/intel/tdx/tree/guest
> 
> I don't think this should be included.
> 
>> +
>> +.. [9] tdvf
>> +    https://github.com/tianocore/edk2-staging/tree/TDVF
>> +.. [10] KVM forum 2020: Intel Virtualization Technology Extensions to
>> +     Enable Hardware Isolated VMs
>> +     https://osseu2020.sched.com/event/eDzm/intel-virtualization- 
>> technology-extensions-to-enable-hardware-isolated-vms-sean- 
>> christopherson-intel
>> +.. [11] Linux Security Summit EU 2020:
>> +     Architectural Extensions for Hardware Virtual Machine Isolation
>> +     to Advance Confidential Computing in Public Clouds - Ravi Sahita
>> +     & Jun Nakajima, Intel Corporation
>> +     https://osseu2020.sched.com/event/eDOx/architectural-extensions- 
>> for-hardware-virtual-machine-isolation-to-advance-confidential- 
>> computing-in-public-clouds-ravi-sahita-jun-nakajima-intel-corporation
> 
> [...]
> 
>> +.. [12] [RFCv2,00/16] KVM protected memory extension
>> +     https://lore.kernel.org/all/20201020061859.18385-1- 
>> kirill.shutemov@linux.intel.com/
> 
> Why putting this RFC here.
> 


