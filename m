Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5212EB80B
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 03:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbhAFCXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 21:23:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:11615 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbhAFCXG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Jan 2021 21:23:06 -0500
IronPort-SDR: POJS33rztDDH2fqKX+mYWFztx7ziIFl8UeTeuu0G5sazk07/j+6agfSST7hF+JlJNqcUCxAHPf
 mUYlO6PdxV9w==
X-IronPort-AV: E=McAfee;i="6000,8403,9855"; a="176434265"
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="176434265"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 18:22:24 -0800
IronPort-SDR: lvosCEofn3NqCPoTagqfaij5BFhfdz+7ucbXBM2pvQxhyHHusFgMIc0CmyRifS5l2Hkguw+Db9
 5NWW9fVO7z3Q==
X-IronPort-AV: E=Sophos;i="5.78,478,1599548400"; 
   d="scan'208";a="395463872"
Received: from zhuoxuan-mobl.amr.corp.intel.com ([10.251.29.237])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2021 18:22:20 -0800
Message-ID: <9741ab3dc20c8149ae300bb9b2e2b154da919297.camel@intel.com>
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, joro@8bytes.org,
        vkuznets@redhat.com, wanpengli@tencent.com, corbet@lwn.net,
        jmattson@google.com
Date:   Wed, 06 Jan 2021 15:22:17 +1300
In-Reply-To: <cover.1609890536.git.kai.huang@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 (3.38.2-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry that I made mistake when copy and paste Jim's email address :( 
Remove the wrong email address (mattson@google.com) and add the correct one
(jmattson@gmail.com). Really apologize for the noise.

Thanks,
-Kai

On Wed, 2021-01-06 at 14:55 +1300, Kai Huang wrote:
> --- Disclaimer ---
> 
> These patches were originally written by Sean Christopherson while at Intel.
> Now that Sean has left Intel, I (Kai) have taken over getting them upstream.
> This series needs more review before it can be merged.  It is being posted
> publicly and under RFC so Sean and others can review it. Maintainers are safe
> ignoring it for now.
> 
> ------------------
> 
> Hi all,
> 
> This series adds KVM SGX virtualization support. The first 12 patches starting
> with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> 
> Please help to review this series. Also I'd like to hear what is the proper
> way to merge this series, since it contains change to both x86/SGX and KVM
> subsystem. Any feedback is highly appreciated. And please let me know if I
> forgot to CC anyone, or anyone wants to be removed from CC. Thanks in advance!
> 
> This series is based against latest tip tree's x86/sgx branch. You can also get
> the code from tip branch of kvm-sgx repo on github:
> 
>         https://github.com/intel/kvm-sgx.git tip
> 
> It also requires Qemu changes to create VM with SGX support. You can find Qemu
> repo here:
> 
> 	https://github.com/intel/qemu-sgx.git next
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
> KVM SGX virtualization Overview
> 
> - Virtual EPC
> 
> "Virtual EPC" is the EPC section exposed by KVM to guest so SGX software in
> guest can discover it and use it to create SGX enclaves. KVM exposes SGX to 
> guest via CPUID, and exposes one or more "virtual EPC" sections for guest.
> The size of "virtual EPC" is passed as Qemu parameter when creating the
> guest, and the base address is calcualted internally according to guest's
> configuration.
> 
> To support virtual EPC, add a new misc device /dev/sgx_virt_epc to SGX
> core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX driver,
> virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave associated,
> and how virtual EPC is used by guest is compeletely controlled by guest's SGX
> software.
> 
> Implement the "raw" EPC allocation in the x86 core-SGX subsystem via
> /dev/sgx_virt_epc rather than in KVM. Doing so has two major advantages:
> 
>   - Does not require changes to KVM's uAPI, e.g. EPC gets handled as
>     just another memory backend for guests.
> 
>   - EPC management is wholly contained in the SGX subsystem, e.g. SGX
>     does not have to export any symbols, changes to reclaim flows don't
>     need to be routed through KVM, SGX's dirty laundry doesn't have to
>     get aired out for the world to see, and so on and so forth.
> 
> The virtual EPC allocated to guests is currently not reclaimable, due to
> reclaiming EPC from KVM guests is not currently supported. Due to the
> complications of handling reclaim conflicts between guest and host, KVM
> EPC oversubscription, which allows total virtual EPC size greater than
> physical EPC by being able to reclaiming guests' EPC, is significantly more
> complex than basic support for SGX virtualization.
> 
> - Support SGX virtualization without SGX Launch Control unlocked mode
> 
> Although SGX driver requires SGX Launch Control unlocked mode to work, SGX
> virtualization doesn't, since how enclave is created is completely controlled
> by guest SGX software, which is not necessarily linux. Therefore, this series
> allows KVM to expose SGX to guest even SGX Launch Control is in locked mode,
> or is not present at all. The reason is the goal of SGX virtualization, or
> virtualization in general, is to expose hardware feature to guest, but not to
> make assumption how guest will use it. Therefore, KVM should support SGX guest
> as long as hardware is able to, to have chance to support more potential use
> cases in cloud environment.
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
> To grant guest being able to fully use SGX, guest needs to be able to create
> provisioning enclave. However provisioning key is sensitive and is restricted by
> /dev/sgx_provision in host SGX driver, therefore KVM SGX virtualization follows
> the same role: a new KVM_CAP_SGX_ATTRIBUTE is added to KVM uAPI, and only file
> descriptor of /dev/sgx_provision is passed to that CAP by usersppace hypervisor
> (Qemu) when creating the guest, it can access provisioning bit. This is done by
> making KVM trape ECREATE instruction from guest, and check the provisioning bit
> in ECREATE's attribute.
> 
> 
> Kai Huang (1):
>   x86/sgx: Add helper to update SGX_LEPUBKEYHASHn MSRs
> 
> Sean Christopherson (22):
>   x86/sgx: Split out adding EPC page to free list to separate helper
>   x86/sgx: Add enum for SGX_CHILD_PRESENT error code
>   x86/sgx: Introduce virtual EPC for use by KVM guests
>   x86/cpufeatures: Add SGX1 and SGX2 sub-features
>   x86/cpu/intel: Allow SGX virtualization without Launch Control support
>   x86/sgx: Expose SGX architectural definitions to the kernel
>   x86/sgx: Move ENCLS leaf definitions to sgx_arch.h
>   x86/sgx: Add SGX2 ENCLS leaf definitions (EAUG, EMODPR and EMODT)
>   x86/sgx: Add encls_faulted() helper
>   x86/sgx: Add helpers to expose ECREATE and EINIT to KVM
>   x86/sgx: Move provisioning device creation out of SGX driver
>   KVM: VMX: Convert vcpu_vmx.exit_reason to a union
>   KVM: x86: Export kvm_mmu_gva_to_gpa_{read,write}() for SGX (VMX)
>   KVM: x86: Define new #PF SGX error code bit
>   KVM: x86: Add SGX feature leaf to reverse CPUID lookup
>   KVM: VMX: Add basic handling of VM-Exit from SGX enclave
>   KVM: VMX: Frame in ENCLS handler for SGX virtualization
>   KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions
>   KVM: VMX: Add emulation of SGX Launch Control LE hash MSRs
>   KVM: VMX: Add ENCLS[EINIT] handler to support SGX Launch Control (LC)
>   KVM: VMX: Enable SGX virtualization for SGX1, SGX2 and LC
>   KVM: x86: Add capability to grant VM access to privileged SGX
>     attribute
> 
>  Documentation/virt/kvm/api.rst                |  23 +
>  arch/x86/Kconfig                              |  12 +
>  arch/x86/include/asm/cpufeature.h             |   5 +-
>  arch/x86/include/asm/cpufeatures.h            |   6 +-
>  arch/x86/include/asm/disabled-features.h      |   7 +-
>  arch/x86/include/asm/kvm_host.h               |   5 +
>  arch/x86/include/asm/required-features.h      |   2 +-
>  arch/x86/include/asm/sgx.h                    |  19 +
>  .../cpu/sgx/arch.h => include/asm/sgx_arch.h} |  20 +
>  arch/x86/include/asm/vmx.h                    |   1 +
>  arch/x86/include/uapi/asm/vmx.h               |   1 +
>  arch/x86/kernel/cpu/common.c                  |   4 +
>  arch/x86/kernel/cpu/feat_ctl.c                |  50 +-
>  arch/x86/kernel/cpu/sgx/Makefile              |   1 +
>  arch/x86/kernel/cpu/sgx/driver.c              |  17 -
>  arch/x86/kernel/cpu/sgx/encl.c                |   2 +-
>  arch/x86/kernel/cpu/sgx/encls.h               |  29 +-
>  arch/x86/kernel/cpu/sgx/ioctl.c               |  23 +-
>  arch/x86/kernel/cpu/sgx/main.c                |  79 ++-
>  arch/x86/kernel/cpu/sgx/sgx.h                 |   5 +-
>  arch/x86/kernel/cpu/sgx/virt.c                | 318 ++++++++++++
>  arch/x86/kernel/cpu/sgx/virt.h                |  14 +
>  arch/x86/kvm/Makefile                         |   2 +
>  arch/x86/kvm/cpuid.c                          |  58 ++-
>  arch/x86/kvm/cpuid.h                          |   1 +
>  arch/x86/kvm/vmx/nested.c                     |  70 ++-
>  arch/x86/kvm/vmx/nested.h                     |   5 +
>  arch/x86/kvm/vmx/sgx.c                        | 462 ++++++++++++++++++
>  arch/x86/kvm/vmx/sgx.h                        |  34 ++
>  arch/x86/kvm/vmx/vmcs12.c                     |   1 +
>  arch/x86/kvm/vmx/vmcs12.h                     |   4 +-
>  arch/x86/kvm/vmx/vmx.c                        | 171 +++++--
>  arch/x86/kvm/vmx/vmx.h                        |  27 +-
>  arch/x86/kvm/x86.c                            |  24 +
>  include/uapi/linux/kvm.h                      |   1 +
>  tools/testing/selftests/sgx/defines.h         |   2 +-
>  36 files changed, 1366 insertions(+), 139 deletions(-)
>  create mode 100644 arch/x86/include/asm/sgx.h
>  rename arch/x86/{kernel/cpu/sgx/arch.h => include/asm/sgx_arch.h} (96%)
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/virt.h
>  create mode 100644 arch/x86/kvm/vmx/sgx.c
>  create mode 100644 arch/x86/kvm/vmx/sgx.h
> 


