Return-Path: <kvm+bounces-43336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADF6A89888
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 11:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D29916AC45
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 09:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E11289377;
	Tue, 15 Apr 2025 09:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="CReVAz9Q"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-bc08.mail.infomaniak.ch (smtp-bc08.mail.infomaniak.ch [45.157.188.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77A828DF14
	for <kvm@vger.kernel.org>; Tue, 15 Apr 2025 09:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.157.188.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744710324; cv=none; b=eO/vR9xD7TMI6sEDrk9b5eV+OcKDzND4yS/5qnY0N4RujOe5gK2+V9cqs1JvoWEoE6j3dCKDvvq8st84WkJkFq6zi/qR6ZOA/XweayAkB69/9994sEcKmeIAYYuJhzEv2qLyrxjmodpjNriqvqDdIngQxDHZls5uBPfA4mVh/pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744710324; c=relaxed/simple;
	bh=28UsXXE8f6JRjCoy1GJYsta2nK9fbaJ05h8GUvK8dSA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DmpvHCcIsBOVUlCe6RDKPdW1FuiKp1NjZbOqfn2Q3W9Vj7j3g5qMzOqhFl27+mVqcZdrzxn9eS4M1/eX2WZA1q1eB6xWWaTgTP8NWxLuFpUyPdIpVKEbgvcfLYd9CNMASCa/sCC0d9I+HB29uviv3Vl+jcmsCalSBc4hTgpCvn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=CReVAz9Q; arc=none smtp.client-ip=45.157.188.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4ZcJlS14QNzF0Y;
	Tue, 15 Apr 2025 11:29:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1744709380;
	bh=w122IkwKpIFchvBGmJYVkBlhuud7xib14rHOWPuOBeU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CReVAz9QmeMt6VWs6yrVjd11gGpMGlnPk5sxckRYh+Es6+AAi4jlw7z5eZ2M6EFjj
	 aJz+crKM5FfCBX/J5BMBUehYfOeNwFWzcaa9LD9K4HluhHfG8df+K0LXj4ZkZrIlH4
	 Qgxf5RcqPcllnq+RMaFeIcXEHrDWJAy8wWwyEfVk=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4ZcJlQ5hXSzJSG;
	Tue, 15 Apr 2025 11:29:38 +0200 (CEST)
Date: Tue, 15 Apr 2025 11:29:38 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jon Kohler <jon@nutanix.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Alexander Grest <Alexander.Grest@microsoft.com>, 
	Nicolas Saenz Julienne <nsaenz@amazon.es>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Tao Su <tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Zhao Liu <zhao1.liu@intel.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Message-ID: <20250415.AegioKi3ioda@digikod.net>
References: <20250313203702.575156-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250313203702.575156-1-jon@nutanix.com>
X-Infomaniak-Routing: alpha

Hi,

This series looks good, just some inlined questions.

Sean, Paolo, what do you think?

Jon, what is the status of the QEMU patches?

Regards,
 Mickaël

On Thu, Mar 13, 2025 at 01:36:39PM -0700, Jon Kohler wrote:
> ## Summary
> This series introduces support for Intel Mode-Based Execute Control
> (MBEC) to KVM and nested VMX virtualization, aiming to significantly
> reduce VMexits and improve performance for Windows guests running with
> Hypervisor-Protected Code Integrity (HVCI).
> 
> ## What?
> Intel MBEC is a hardware feature, introduced in the Kabylake
> generation, that allows for more granular control over execution
> permissions. MBEC enables the separation and tracking of execution
> permissions for supervisor (kernel) and user-mode code. It is used as
> an accelerator for Microsoft's Memory Integrity [1] (also known as
> hypervisor-protected code integrity or HVCI).
> 
> ## Why?
> The primary reason for this feature is performance.
> 
> Without hardware-level MBEC, enabling Windows HVCI runs a 'software
> MBEC' known as Restricted User Mode, which imposes a runtime overhead
> due to increased state transitions between the guest's L2 root
> partition and the L2 secure partition for running kernel mode code
> integrity operations.
> 
> In practice, this results in a significant number of exits. For
> example, playing a YouTube video within the Edge Browser produces
> roughly 1.2 million VMexits/second across an 8 vCPU Windows 11 guest.
> 
> Most of these exits are VMREAD/VMWRITE operations, which can be
> emulated with Enlightened VMCS (eVMCS). However, even with eVMCS, this
> configuration still produces around 200,000 VMexits/second.
> 
> With MBEC exposed to the L1 Windows Hypervisor, the same scenario
> results in approximately 50,000 VMexits/second, a *24x* reduction from
> the baseline.
> 
> Not a typo, 24x reduction in VMexits.
> 
> ## How?
> This series implements core KVM support for exposing the MBEC bit in
> secondary execution controls (bit 22) to L1 and L2, based on
> configuration from user space and a module parameter
> 'enable_pt_guest_exec_control'. The inspiration for this series
> started with Mickaël's series for Heki [3], where we've extracted,
> refactored, and extended the MBEC-specific use case to be
> general-purpose.
> 
> MBEC, which appears in Linux /proc/cpuinfo as ept_mode_based_exec,
> splits the EPT exec bit (bit 2 in PTE) into two bits. When secondary
> execution control bit 22 is set, PTE bit 2 reflects supervisor mode
> executable, and PTE bit 10 reflects user mode executable.
> 
> The semantics for EPT violation qualifications also change when MBEC
> is enabled, with bit 5 reflecting supervisor/kernel mode execute
> permissions and bit 6 reflecting user mode execute permissions.
> This ultimately serves to expose this feature to the L1 hypervisor,
> which consumes MBEC and informs the L2 partitions not to use the
> software MBEC by removing bit 14 in 0x40000004 EAX [4].
> 
> ## Where?
> Enablement spans both VMX code and MMU code to teach the shadow MMU
> about the different execution modes, as well as user space VMM to pass
> secondary execution control bit 22. A patch for QEMU enablement is
> available [5].
> 
> ## Testing
> Initial testing has been on done on 6.12-based code with:
>   Guests
>     - Windows 11 24H2 26100.2894
>     - Windows Server 2025 24H2 26100.2894
>     - Windows Server 2022 W1H2 20348.825
>   Processors:
>     - Intel Skylake 6154
>     - Intel Sapphire Rapids 6444Y
> 
> ## Acknowledgements
> Special thanks to all contributors and reviewers who have provided
> valuable feedback and support for this patch series.
> 
> [1] https://learn.microsoft.com/en-us/windows/security/hardware-security/enable-virtualization-based-protection-of-code-integrity
> [2] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/nested-virtualization#enlightened-vmcs-intel
> [3] https://patchwork.kernel.org/project/kvm/patch/20231113022326.24388-6-mic@digikod.net/
> [4] https://learn.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#implementation-recommendations---0x40000004
> [5] https://github.com/JonKohler/qemu/tree/mbec-rfc-v1
> 
> Cc: Alexander Grest <Alexander.Grest@microsoft.com>
> Cc: Nicolas Saenz Julienne <nsaenz@amazon.es>
> Cc: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Cc: Mickaël Salaün <mic@digikod.net>
> Cc: Tao Su <tao1.su@linux.intel.com>
> Cc: Xiaoyao Li <xiaoyao.li@intel.com>
> Cc: Zhao Liu <zhao1.liu@intel.com>
> 
> Jon Kohler (11):
>   KVM: x86: Add module parameter for Intel MBEC
>   KVM: x86: Add pt_guest_exec_control to kvm_vcpu_arch
>   KVM: VMX: Wire up Intel MBEC enable/disable logic
>   KVM: x86/mmu: Remove SPTE_PERM_MASK
>   KVM: VMX: Extend EPT Violation protection bits
>   KVM: x86/mmu: Introduce shadow_ux_mask
>   KVM: x86/mmu: Adjust SPTE_MMIO_ALLOWED_MASK to understand MBEC
>   KVM: x86/mmu: Extend make_spte to understand MBEC
>   KVM: nVMX: Setup Intel MBEC in nested secondary controls
>   KVM: VMX: Allow MBEC with EVMCS
>   KVM: x86: Enable module parameter for MBEC
> 
> Mickaël Salaün (5):
>   KVM: VMX: add cpu_has_vmx_mbec helper
>   KVM: VMX: Define VMX_EPT_USER_EXECUTABLE_MASK
>   KVM: x86/mmu: Extend access bitfield in kvm_mmu_page_role
>   KVM: VMX: Enhance EPT violation handler for PROT_USER_EXEC
>   KVM: x86/mmu: Extend is_executable_pte to understand MBEC
> 
> Nikolay Borisov (1):
>   KVM: VMX: Remove EPT_VIOLATIONS_ACC_*_BIT defines
> 
> Sean Christopherson (1):
>   KVM: nVMX: Decouple EPT RWX bits from EPT Violation protection bits
> 
>  arch/x86/include/asm/kvm_host.h | 13 +++++----
>  arch/x86/include/asm/vmx.h      | 45 ++++++++++++++++++++---------
>  arch/x86/kvm/mmu.h              |  3 +-
>  arch/x86/kvm/mmu/mmu.c          | 13 +++++----
>  arch/x86/kvm/mmu/mmutrace.h     | 23 ++++++++++-----
>  arch/x86/kvm/mmu/paging_tmpl.h  | 19 +++++++++---
>  arch/x86/kvm/mmu/spte.c         | 51 ++++++++++++++++++++++++++++-----
>  arch/x86/kvm/mmu/spte.h         | 36 +++++++++++++++--------
>  arch/x86/kvm/mmu/tdp_mmu.c      |  2 +-
>  arch/x86/kvm/vmx/capabilities.h |  6 ++++
>  arch/x86/kvm/vmx/hyperv.c       |  5 +++-
>  arch/x86/kvm/vmx/hyperv_evmcs.h |  1 +
>  arch/x86/kvm/vmx/nested.c       |  4 +++
>  arch/x86/kvm/vmx/vmx.c          | 21 ++++++++++++--
>  arch/x86/kvm/vmx/vmx.h          |  7 +++++
>  arch/x86/kvm/x86.c              |  4 +++
>  16 files changed, 192 insertions(+), 61 deletions(-)
> 
> -- 
> 2.43.0
> 
> 

