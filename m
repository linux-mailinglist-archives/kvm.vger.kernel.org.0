Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B13E34202C
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 15:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCSOwa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 10:52:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhCSOw2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 10:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A94364F18;
        Fri, 19 Mar 2021 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616165548;
        bh=g+fGrFc6tO1GtHJCxGqoe84NJFw5BZpjZ5MylIcDQCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P5QAdrwvcD5zu4xYTDQJfsobjHsy2ji5EHxdnhpOyOwU2NoS6FVDY2Bi8tg1uTYcU
         OrHYzDlVqVLFt/Cf0F5CXcaYzjj3E9YYWU+CO5EPl8scINNcrXfnrbv95eJ+NGEkIH
         aE8sHhVCXEBvjAjVBCoiq1p7n5iTow1/SWmdHBrVH6Kg5czMfcQHbJiv41XDNoMBvB
         tciI0Leuyf1kKCix0tN/eWQgzt8cOzsD+1M4HIBWxfopdNMiYAqYi+540AUeCmyy2T
         BFbOBmYPC5cJWNYnmPnumtAxkrX/02GzWz1bWhulabrqm4K6z+Dzx5K0kZ6Nqf8IGB
         t18hIlKKEK72A==
Date:   Fri, 19 Mar 2021 16:52:01 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [PATCH v3 00/25] KVM SGX virtualization support
Message-ID: <YFS6kTe1SuAjiMFN@kernel.org>
References: <cover.1616136307.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1616136307.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 19, 2021 at 08:29:27PM +1300, Kai Huang wrote:
> This series adds KVM SGX virtualization support. The first 14 patches starting
> with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> This series is based against latest tip/x86/sgx, which has Jarkko's NUMA
> allocation support.
> 
> You can also get the code from upstream branch of kvm-sgx repo on github:
> 
>         https://github.com/intel/kvm-sgx.git upstream
> 
> It also requires Qemu changes to create VM with SGX support. You can find Qemu
> repo here:
> 
> 	https://github.com/intel/qemu-sgx.git upstream
> 
> Please refer to README.md of above qemu-sgx repo for detail on how to create
> guest with SGX support. At meantime, for your quick reference you can use below
> command to create SGX guest:
> 
> 	#qemu-system-x86_64 -smp 4 -m 2G -drive file=<your_vm_image>,if=virtio \
> 		-cpu host,+sgx_provisionkey \
> 		-sgx-epc id=epc1,memdev=mem1 \
> 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> 
> Please note that the SGX relevant part is:
> 
> 		-cpu host,+sgx_provisionkey \
> 		-sgx-epc id=epc1,memdev=mem1 \
> 		-object memory-backend-epc,id=mem1,size=64M,prealloc
> 
> And you can change other parameters of your qemu command based on your needs.
> 
> =========
> Changelog:
> 
> (Changelog here is for global changes. Please see each patch's changelog for
>  changes made to specific patch.)
> 
> v2->v3:
> 
>  - No big change in design, structure of patch series, etc.
>  - Rebased to lastest tip/x86/sgx, to resolve merge conflict of patch 3
>    (x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()).
>  - Addressed some Nit issues found by Sean in v2.
>  - Also addressed some Nit issues reported by checkpatch.pl. Now there's no
>    checkpatch issues.
>  - Updated patch 3 (x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()):
>    - Removed Jarkko from author, per request.
>    - Changed to replace all call sites of sgx_free_epc_page() with new
>      sgx_encl_free_epc_page(), to make this patch doesn't have functional
>      changes (except a WARN upon EREMOVE failure requestd by Dave).
>    - Rebased to tip/x86/sgx, which has Jarkko's NUMA allocation.
>    - Added Jarkko's Acked-by.
>  - Updated patch 8 (x86/sgx: Expose SGX architectural definitions to the
>    kernel) to add MAINTAINER file update to include new introduced asm/sgx.h.
>  - Updated patch 13 (x86/sgx: Add helpers to expose ECREATE and EINIT to KVM)
>    to use addr and size directly in access_ok()s (which won't be triggered
>    anyway).
> 
> v1->v2:
> 
>  - No big change in design, structural of patch series, etc.
>  - Addressed Boris's comments regarding to suppressing both SGX1 and SGX2 in
>    /proc/cpuinfo, and improvement in feat_ctl.c when enabling SGX (patch 2
>    and 6).
>  - Addressed Sean's comments for both x86 part patches and KVM patches (patch 3,
>    5, 9, 12, 19, 21).
>  - Addressed Dave's comments in RFC v6 series (patch 13).
> 
> RFC->v1:
> 
>  - Refined patch (x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()) to print
>    error msg that EPC page is leaked when EREMOVE failed, requested by Dave.
>  - Changelog history of all RFC series is removed in both this cover letter
>    and each individual patch, since majority of x86 part patches already got
>    Acked-by from Dave and Jarkko. And the changelogs are not quite useful from
>    my perspective.
> 
> =========
> KVM SGX virtualization Overview
> 
> - Virtual EPC
> 
> SGX enclave memory is special and is reserved specifically for enclave use.
> In bare-metal SGX enclaves, the kernel allocates enclave pages, copies data
> into the pages with privileged instructions, then allows the enclave to start.
> In this scenario, only initialized pages already assigned to an enclave are
> mapped to userspace.
> 
> In virtualized environments, the hypervisor still needs to do the physical
> enclave page allocation.  The guest kernel is responsible for the data copying
> (among other things).  This means that the job of starting an enclave is now
> split between hypervisor and guest.
> 
> This series introduces a new misc device: /dev/sgx_vepc.  This device allows
> the host to map *uninitialized* enclave memory into userspace, which can then
> be passed into a guest.
> 
> While it might be *possible* to start a host-side enclave with /dev/sgx_enclave
> and pass its memory into a guest, it would be wasteful and convoluted.
> 
> Implement the *raw* EPC allocation in the x86 core-SGX subsystem via
> /dev/sgx_vepc rather than in KVM.  Doing so has two major advantages:
> 
>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.
> 
>   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
>     does not have to export any symbols, changes to reclaim flows don't
>     need to be routed through KVM, SGX's dirty laundry doesn't have to
>     get aired out for the world to see, and so on and so forth.
> 
> The virtual EPC pages allocated to guests are currently not reclaimable.
> Reclaiming EPC page used by enclave requires a special reclaim mechanism
> separate from normal page reclaim, and that mechanism is not supported
> for virutal EPC pages.  Due to the complications of handling reclaim
> conflicts between guest and host, reclaiming virtual EPC pages is 
> significantly more complex than basic support for SGX virtualization.
> 
> - Support SGX virtualization without SGX Flexible Launch Control
> 
> SGX hardware supports two "launch control" modes to limit which enclaves can
> run.  In the "locked" mode, the hardware prevents enclaves from running unless
> they are blessed by a third party.  In the unlocked mode, the kernel is in
> full control of which enclaves can run.  The bare-metal SGX code refuses to
> launch enclaves unless it is in the unlocked mode.
> 
> This sgx_virt_epc driver does not have such a restriction.  This allows guests
> which are OK with the locked mode to use SGX, even if the host kernel refuses
> to.
> 
> - Support exposing SGX2
> 
> Due to the same reason above, SGX2 feature detection is added to core SGX code
> to allow KVM to expose SGX2 to guest, even currently SGX driver doesn't support
> SGX2, because SGX2 can work just fine in guest w/o any interaction to host SGX
> driver.
> 
> - Restricit SGX guest access to provisioning key
> 
> To grant guest being able to fully use SGX, guest needs to be able to access
> provisioning key.  The provisioning key is sensitive, and accessing to it should
> be restricted. In bare-metal driver, allowing enclave to access provisioning key
> is restricted by being able to open /dev/sgx_provision.
> 
> Add a new KVM_CAP_SGX_ATTRIBUTE to KVM uAPI to extend above mechanism to KVM
> guests as well.  When userspace hypervisor creates a new VM, the new cap is only
> added to VM when userspace hypervisior is able to open /dev/sgx_provision,
> following the same role as in bare-metal driver.  KVM then traps ECREATE from
> guest, and only allows ECREATE with provisioning key bit to run when guest
> supports KVM_CAP_SGX_ATTRIBUTE.
> 
> 
> Kai Huang (4):
>   x86/cpufeatures: Make SGX_LC feature bit depend on SGX bit
>   x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
>   x86/sgx: Initialize virtual EPC driver even when SGX driver is
>     disabled
>   x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
> 
> Sean Christopherson (21):
>   x86/cpufeatures: Add SGX1 and SGX2 sub-features
>   x86/sgx: Add SGX_CHILD_PRESENT hardware error code
>   x86/sgx: Introduce virtual EPC for use by KVM guests
>   x86/cpu/intel: Allow SGX virtualization without Launch Control support
>   x86/sgx: Expose SGX architectural definitions to the kernel
>   x86/sgx: Move ENCLS leaf definitions to sgx.h
>   x86/sgx: Add SGX2 ENCLS leaf definitions (EAUG, EMODPR and EMODT)
>   x86/sgx: Add encls_faulted() helper
>   x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
>   x86/sgx: Move provisioning device creation out of SGX driver
>   KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
>   KVM: x86: Define new #PF SGX error code bit
>   KVM: x86: Add support for reverse CPUID lookup of scattered features
>   KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
>   KVM: VMX: Add basic handling of VM-Exit from SGX enclave
>   KVM: VMX: Frame in ENCLS handler for SGX virtualization
>   KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
>   KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
>   KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
>   KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
>   KVM: x86: Add capability to grant VM access to privileged SGX
>     attribute
> 
>  Documentation/virt/kvm/api.rst                |  23 +
>  MAINTAINERS                                   |   1 +
>  arch/x86/Kconfig                              |  12 +
>  arch/x86/include/asm/cpufeatures.h            |   2 +
>  arch/x86/include/asm/kvm_host.h               |   5 +
>  .../cpu/sgx/arch.h => include/asm/sgx.h}      |  50 +-
>  arch/x86/include/asm/vmx.h                    |   1 +
>  arch/x86/include/uapi/asm/vmx.h               |   1 +
>  arch/x86/kernel/cpu/cpuid-deps.c              |   3 +
>  arch/x86/kernel/cpu/feat_ctl.c                |  71 ++-
>  arch/x86/kernel/cpu/scattered.c               |   2 +
>  arch/x86/kernel/cpu/sgx/Makefile              |   1 +
>  arch/x86/kernel/cpu/sgx/driver.c              |  17 -
>  arch/x86/kernel/cpu/sgx/encl.c                |  42 +-
>  arch/x86/kernel/cpu/sgx/encl.h                |   1 +
>  arch/x86/kernel/cpu/sgx/encls.h               |  30 +-
>  arch/x86/kernel/cpu/sgx/ioctl.c               |  29 +-
>  arch/x86/kernel/cpu/sgx/main.c                |  96 +++-
>  arch/x86/kernel/cpu/sgx/sgx.h                 |  13 +-
>  arch/x86/kernel/cpu/sgx/virt.c                | 369 ++++++++++++++
>  arch/x86/kvm/Makefile                         |   2 +
>  arch/x86/kvm/cpuid.c                          |  89 +++-
>  arch/x86/kvm/cpuid.h                          |  50 +-
>  arch/x86/kvm/vmx/nested.c                     |  28 +-
>  arch/x86/kvm/vmx/nested.h                     |   5 +
>  arch/x86/kvm/vmx/sgx.c                        | 481 ++++++++++++++++++
>  arch/x86/kvm/vmx/sgx.h                        |  34 ++
>  arch/x86/kvm/vmx/vmcs12.c                     |   1 +
>  arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
>  arch/x86/kvm/vmx/vmx.c                        | 109 +++-
>  arch/x86/kvm/vmx/vmx.h                        |   2 +
>  arch/x86/kvm/x86.c                            |  23 +
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/testing/selftests/sgx/defines.h         |   2 +-
>  34 files changed, 1476 insertions(+), 124 deletions(-)
>  rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx.h} (89%)
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
>  create mode 100644 arch/x86/kvm/vmx/sgx.c
>  create mode 100644 arch/x86/kvm/vmx/sgx.h
> 
> -- 
> 2.30.2
> 
> 

I just say add my ack to SGX specific patches where it is missing.
Good enough.

/Jarkko
