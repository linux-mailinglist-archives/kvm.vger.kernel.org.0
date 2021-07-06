Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA573BD91A
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232531AbhGFO4I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:56:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32850 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231852AbhGFO4I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:56:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625583209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J6NVm2pYc7KkCmbLNwpdJR5mdsiFS18TYkWg9Ro+c24=;
        b=iiZ1shVMZOjoIyAhpeVV2oVHemQrUNQjMrr+lP+/frmEOmatLMZBI/kGMXnjesUhyGpNZS
        NkzN4CEIPE89bNSKggv2XFgorAhXTP0/hbkCQ3PbosLipKM2S9hA5SLKXBhq1+DBwOGSE2
        NnKpmXeobHkFebB5DckbIAMLVG8kLVo=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-390-zGEPMvYyM4StA3apsm6UKg-1; Tue, 06 Jul 2021 10:53:27 -0400
X-MC-Unique: zGEPMvYyM4StA3apsm6UKg-1
Received: by mail-ej1-f70.google.com with SMTP id h14-20020a1709070b0eb02904d7c421e00bso2776917ejl.2
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:53:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J6NVm2pYc7KkCmbLNwpdJR5mdsiFS18TYkWg9Ro+c24=;
        b=m7OTlga9UGOzBMHt5IGZzGbylmbDWT/pMLY6kV46RJXvYeJ6tYtJal8y9Y0jyRi/D9
         xRKSrIrUKdW8h1z2viN8xaIoKP2392gW8XO9VAndVvPcmYGd+0B504Q+ZNUS2Ul9rEiv
         NtwYB2P8d+3dZQyeUbtoT2oFCEJnOciVSaQKITQK7xZiaQpCknNgOib2BJZJhlKNFd/l
         5KR0S741UTxu1/ERNxTFEKe8m6pa7Dg4Wl+DGv9IU2Sb/ikmULX1f9D8cfYLiuvqK4Wq
         al0KMxvcyYhEcDC2D8cmIBVq435sSj/mkE9dXoF9bhzTVudGh2E7NEQa6jLzdmumVRzX
         71LA==
X-Gm-Message-State: AOAM533A7bFbSW2mKJ4LXs//NoLQOxi7ESUE5hAgjhgDDKYshWOnXoRY
        scjnld5Ai1+AXA1mz7fCuIMLQnhmLgT265FxhGsIFm97vGTkHs/8c+/XNTTYY8jVpuvqVYCtGiQ
        Ys1MIkHUFHDuY
X-Received: by 2002:a17:906:6047:: with SMTP id p7mr18832599ejj.206.1625583206551;
        Tue, 06 Jul 2021 07:53:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzx38vUyETr6B4m1Myr9dqa8Lha/dt9+ZFh6SdGAKHQ3/e68Y+6MWCf3cD0kN+63CtGaRWZYw==
X-Received: by 2002:a17:906:6047:: with SMTP id p7mr18832585ejj.206.1625583206360;
        Tue, 06 Jul 2021 07:53:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id b5sm3368939ejz.122.2021.07.06.07.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:53:25 -0700 (PDT)
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com
References: <cover.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH v2 00/69] KVM: X86: TDX support
Message-ID: <9531986f-867f-6858-3e09-d1e8a64f5518@redhat.com>
Date:   Tue, 6 Jul 2021 16:53:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <cover.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Based on the initial review, I think patches 2-3-17-18-19-20-23-49 can 
already be merged for 5.15.

The next part should be the introduction of vm_types, blocking ioctls 
depending on the vm_type (patches 24-31).  Perhaps this blocking should 
be applied already to SEV-ES, so that the corresponding code in QEMU can 
be added early.

Paolo

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> * What's TDX?
> TDX stands for Trust Domain Extensions which isolates VMs from the
> virtual-machine manager (VMM)/hypervisor and any other software on the
> platform. [1] For details, the specifications, [2], [3], [4], [5], [6], [7], are
> available.
> 
> 
> * The goal of this RFC patch
> The purpose of this post is to get feedback early on high level design issue of
> KVM enhancement for TDX. The detailed coding (variable naming etc) is not cared
> of. This patch series is incomplete (not working). So it's RFC.  Although
> multiple software components, not only KVM but also QEMU, guest Linux and
> virtual bios, need to be updated, this includes only KVM VMM part. For those who
> are curious to changes to other component, there are public repositories at
> github. [8], [9]
> 
> 
> * Patch organization
> The patch 66 is main change.  The preceding patches(1-65) The preceding
> patches(01-61) are refactoring the code and introducing additional hooks.
> 
> - 01-12: They are preparations. introduce architecture constants, code
>           refactoring, export symbols for following patches.
> - 13-40: start to introduce the new type of VM and allow the coexistence of
>           multiple type of VM. allow/disallow KVM ioctl where
>           appropriate. Especially make per-system ioctl to per-VM ioctl.
> - 41-65: refactoring KVM VMX/MMU and adding new hooks for Secure EPT.
> - 66:    main patch to add "basic" support for building/running TDX.
> - 67:    trace points for
> - 68-69:  Documentation
> 
> * TODOs
> Those major features are missing from this patch series to keep this patch
> series small.
> 
> - load/initialize TDX module
>    split out from this patch series.
> - unmapping private page
>    Will integrate Kirill's patch to show how kvm will utilize it.
> - qemu gdb stub support
> - Large page support
> - guest PMU support
> - TDP MMU support
> - and more
> 
> Changes from v1:
> - rebase to v5.13
> - drop load/initialization of TDX module
> - catch up the update of related specifications.
> - rework on C-wrapper function to invoke seamcall
> - various code clean up
> 
> [1] TDX specification
>     https://software.intel.com/content/www/us/en/develop/articles/intel-trust-domain-extensions.html
> [2] Intel Trust Domain Extensions (Intel TDX)
>     https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-whitepaper-final9-17.pdf
> [3] Intel CPU Architectural Extensions Specification
>     https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-cpu-architectural-specification.pdf
> [4] Intel TDX Module 1.0 EAS
>     https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-module-1eas-v0.85.039.pdf
> [5] Intel TDX Loader Interface Specification
>    https://software.intel.com/content/dam/develop/external/us/en/documents-tps/intel-tdx-seamldr-interface-specification.pdf
> [6] Intel TDX Guest-Hypervisor Communication Interface
>     https://software.intel.com/content/dam/develop/external/us/en/documents/intel-tdx-guest-hypervisor-communication-interface.pdf
> [7] Intel TDX Virtual Firmware Design Guide
>     https://software.intel.com/content/dam/develop/external/us/en/documents/tdx-virtual-firmware-design-guide-rev-1.pdf
> [8] intel public github
>     kvm TDX branch: https://github.com/intel/tdx/tree/kvm
>     TDX guest branch: https://github.com/intel/tdx/tree/guest
>     qemu TDX https://github.com/intel/qemu-tdx
> [9] TDVF
>      https://github.com/tianocore/edk2-staging/tree/TDVF
> 
> Isaku Yamahata (11):
>    KVM: TDX: introduce config for KVM TDX support
>    KVM: X86: move kvm_cpu_vmxon() from vmx.c to virtext.h
>    KVM: X86: move out the definition vmcs_hdr/vmcs from kvm to x86
>    KVM: TDX: add a helper function for kvm to call seamcall
>    KVM: TDX: add trace point before/after TDX SEAMCALLs
>    KVM: TDX: Print the name of SEAMCALL status code
>    KVM: Add per-VM flag to mark read-only memory as unsupported
>    KVM: x86: add per-VM flags to disable SMI/INIT/SIPI
>    KVM: TDX: add trace point for TDVMCALL and SEPT operation
>    KVM: TDX: add document on TDX MODULE
>    Documentation/virtual/kvm: Add Trust Domain Extensions(TDX)
> 
> Kai Huang (2):
>    KVM: x86: Add per-VM flag to disable in-kernel I/O APIC and level
>      routes
>    cpu/hotplug: Document that TDX also depends on booting CPUs once
> 
> Rick Edgecombe (1):
>    KVM: x86: Add infrastructure for stolen GPA bits
> 
> Sean Christopherson (53):
>    KVM: TDX: Add TDX "architectural" error codes
>    KVM: TDX: Add architectural definitions for structures and values
>    KVM: TDX: define and export helper functions for KVM TDX support
>    KVM: TDX: Add C wrapper functions for TDX SEAMCALLs
>    KVM: Export kvm_io_bus_read for use by TDX for PV MMIO
>    KVM: Enable hardware before doing arch VM initialization
>    KVM: x86: Split core of hypercall emulation to helper function
>    KVM: x86: Export kvm_mmio tracepoint for use by TDX for PV MMIO
>    KVM: x86/mmu: Zap only leaf SPTEs for deleted/moved memslot by default
>    KVM: Add infrastructure and macro to mark VM as bugged
>    KVM: Export kvm_make_all_cpus_request() for use in marking VMs as
>      bugged
>    KVM: x86: Use KVM_BUG/KVM_BUG_ON to handle bugs that are fatal to the
>      VM
>    KVM: x86/mmu: Mark VM as bugged if page fault returns RET_PF_INVALID
>    KVM: Add max_vcpus field in common 'struct kvm'
>    KVM: x86: Add vm_type to differentiate legacy VMs from protected VMs
>    KVM: x86: Hoist kvm_dirty_regs check out of sync_regs()
>    KVM: x86: Introduce "protected guest" concept and block disallowed
>      ioctls
>    KVM: x86: Add per-VM flag to disable direct IRQ injection
>    KVM: x86: Add flag to disallow #MC injection / KVM_X86_SETUP_MCE
>    KVM: x86: Add flag to mark TSC as immutable (for TDX)
>    KVM: Add per-VM flag to disable dirty logging of memslots for TDs
>    KVM: x86: Allow host-initiated WRMSR to set X2APIC regardless of CPUID
>    KVM: x86: Add kvm_x86_ops .cache_gprs() and .flush_gprs()
>    KVM: x86: Add support for vCPU and device-scoped KVM_MEMORY_ENCRYPT_OP
>    KVM: x86: Introduce vm_teardown() hook in kvm_arch_vm_destroy()
>    KVM: x86: Add a switch_db_regs flag to handle TDX's auto-switched
>      behavior
>    KVM: x86: Check for pending APICv interrupt in kvm_vcpu_has_events()
>    KVM: x86: Add option to force LAPIC expiration wait
>    KVM: x86: Add guest_supported_xss placholder
>    KVM: Export kvm_is_reserved_pfn() for use by TDX
>    KVM: x86/mmu: Explicitly check for MMIO spte in fast page fault
>    KVM: x86/mmu: Allow non-zero init value for shadow PTE
>    KVM: x86/mmu: Refactor shadow walk in __direct_map() to reduce
>      indentation
>    KVM: x86/mmu: Return old SPTE from mmu_spte_clear_track_bits()
>    KVM: x86/mmu: Frame in support for private/inaccessible shadow pages
>    KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
>    KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX
>    KVM: VMX: Modify NMI and INTR handlers to take intr_info as param
>    KVM: VMX: Move NMI/exception handler to common helper
>    KVM: x86/mmu: Allow per-VM override of the TDP max page level
>    KVM: VMX: Split out guts of EPT violation to common/exposed function
>    KVM: VMX: Define EPT Violation architectural bits
>    KVM: VMX: Define VMCS encodings for shared EPT pointer
>    KVM: VMX: Add 'main.c' to wrap VMX and TDX
>    KVM: VMX: Move setting of EPT MMU masks to common VT-x code
>    KVM: VMX: Move register caching logic to common code
>    KVM: TDX: Define TDCALL exit reason
>    KVM: TDX: Stub in tdx.h with structs, accessors, and VMCS helpers
>    KVM: VMX: Add macro framework to read/write VMCS for VMs and TDs
>    KVM: VMX: Move AR_BYTES encoder/decoder helpers to common.h
>    KVM: VMX: MOVE GDT and IDT accessors to common code
>    KVM: VMX: Move .get_interrupt_shadow() implementation to common VMX
>      code
>    KVM: TDX: Add "basic" support for building and running Trust Domains
> 
> Xiaoyao Li (2):
>    KVM: TDX: Introduce pr_seamcall_ex_ret_info() to print more info when
>      SEAMCALL fails
>    KVM: X86: Introduce initial_tsc_khz in struct kvm_arch
> 
>   Documentation/virt/kvm/api.rst        |    6 +-
>   Documentation/virt/kvm/intel-tdx.rst  |  441 ++++++
>   Documentation/virt/kvm/tdx-module.rst |   48 +
>   arch/arm64/include/asm/kvm_host.h     |    3 -
>   arch/arm64/kvm/arm.c                  |    7 +-
>   arch/arm64/kvm/vgic/vgic-init.c       |    6 +-
>   arch/x86/Kbuild                       |    1 +
>   arch/x86/include/asm/cpufeatures.h    |    2 +
>   arch/x86/include/asm/kvm-x86-ops.h    |    8 +
>   arch/x86/include/asm/kvm_boot.h       |   30 +
>   arch/x86/include/asm/kvm_host.h       |   55 +-
>   arch/x86/include/asm/virtext.h        |   25 +
>   arch/x86/include/asm/vmx.h            |   17 +
>   arch/x86/include/uapi/asm/kvm.h       |   60 +
>   arch/x86/include/uapi/asm/vmx.h       |    7 +-
>   arch/x86/kernel/asm-offsets_64.c      |   15 +
>   arch/x86/kvm/Kconfig                  |   11 +
>   arch/x86/kvm/Makefile                 |    3 +-
>   arch/x86/kvm/boot/Makefile            |    6 +
>   arch/x86/kvm/boot/seam/tdx_common.c   |  242 +++
>   arch/x86/kvm/boot/seam/tdx_common.h   |   13 +
>   arch/x86/kvm/ioapic.c                 |    4 +
>   arch/x86/kvm/irq_comm.c               |   13 +-
>   arch/x86/kvm/lapic.c                  |    7 +-
>   arch/x86/kvm/lapic.h                  |    2 +-
>   arch/x86/kvm/mmu.h                    |   31 +-
>   arch/x86/kvm/mmu/mmu.c                |  526 +++++--
>   arch/x86/kvm/mmu/mmu_internal.h       |    3 +
>   arch/x86/kvm/mmu/paging_tmpl.h        |   25 +-
>   arch/x86/kvm/mmu/spte.c               |   15 +-
>   arch/x86/kvm/mmu/spte.h               |   18 +-
>   arch/x86/kvm/svm/svm.c                |   18 +-
>   arch/x86/kvm/trace.h                  |  138 ++
>   arch/x86/kvm/vmx/common.h             |  178 +++
>   arch/x86/kvm/vmx/main.c               | 1098 ++++++++++++++
>   arch/x86/kvm/vmx/posted_intr.c        |    6 +
>   arch/x86/kvm/vmx/seamcall.S           |   64 +
>   arch/x86/kvm/vmx/seamcall.h           |   68 +
>   arch/x86/kvm/vmx/tdx.c                | 1958 +++++++++++++++++++++++++
>   arch/x86/kvm/vmx/tdx.h                |  267 ++++
>   arch/x86/kvm/vmx/tdx_arch.h           |  370 +++++
>   arch/x86/kvm/vmx/tdx_errno.h          |  202 +++
>   arch/x86/kvm/vmx/tdx_ops.h            |  218 +++
>   arch/x86/kvm/vmx/tdx_stubs.c          |   45 +
>   arch/x86/kvm/vmx/vmcs.h               |   11 -
>   arch/x86/kvm/vmx/vmenter.S            |  146 ++
>   arch/x86/kvm/vmx/vmx.c                |  509 ++-----
>   arch/x86/kvm/x86.c                    |  285 +++-
>   include/linux/kvm_host.h              |   51 +-
>   include/uapi/linux/kvm.h              |    2 +
>   kernel/cpu.c                          |    4 +
>   tools/arch/x86/include/uapi/asm/kvm.h |   55 +
>   tools/include/uapi/linux/kvm.h        |    2 +
>   virt/kvm/kvm_main.c                   |   44 +-
>   54 files changed, 6717 insertions(+), 672 deletions(-)
>   create mode 100644 Documentation/virt/kvm/intel-tdx.rst
>   create mode 100644 Documentation/virt/kvm/tdx-module.rst
>   create mode 100644 arch/x86/include/asm/kvm_boot.h
>   create mode 100644 arch/x86/kvm/boot/Makefile
>   create mode 100644 arch/x86/kvm/boot/seam/tdx_common.c
>   create mode 100644 arch/x86/kvm/boot/seam/tdx_common.h
>   create mode 100644 arch/x86/kvm/vmx/common.h
>   create mode 100644 arch/x86/kvm/vmx/main.c
>   create mode 100644 arch/x86/kvm/vmx/seamcall.S
>   create mode 100644 arch/x86/kvm/vmx/seamcall.h
>   create mode 100644 arch/x86/kvm/vmx/tdx.c
>   create mode 100644 arch/x86/kvm/vmx/tdx.h
>   create mode 100644 arch/x86/kvm/vmx/tdx_arch.h
>   create mode 100644 arch/x86/kvm/vmx/tdx_errno.h
>   create mode 100644 arch/x86/kvm/vmx/tdx_ops.h
>   create mode 100644 arch/x86/kvm/vmx/tdx_stubs.c
> 

