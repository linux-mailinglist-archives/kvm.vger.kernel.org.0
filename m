Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4C46E8475
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 00:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjDSWRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 18:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjDSWRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 18:17:33 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616541718
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:30 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a66888cb89so4498525ad.3
        for <kvm@vger.kernel.org>; Wed, 19 Apr 2023 15:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20221208.gappssmtp.com; s=20221208; t=1681942650; x=1684534650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bHSOgTgczHoSpVKp/2cbvFdlvzihl0SXPdnpVyAQEXE=;
        b=BEqP6G9EMWgC3XGd8MFyO1/zN07IG/ZOcdvKNw2uvUe6FY9MwYMD9OtT/e6Hpsh+d1
         UTBw0SQO/dfPji/vJHTQDRu1iDUarJ1tS8TRJuTOO+KYKTKVWfmVRS/Xp1euAnU845Gl
         HHL+bdzN6lJB4kFW+YVJlX+ztx23Vcd8AuVprRPD1kNdS6LLAlflOX5ATt9IweQywq5l
         Kd6OhXAFXqN5HuxtdNo8NV2Lp/SReOMX0ij2xUdlRnElKqTtVrWyvcnLURzPo/12F526
         EtapUBzLLKw514EMqqXGsXvC8TxYgg37pxXtw48fvr8B9i2gaBLQlmF4jAsOItZdgUPw
         hT2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681942650; x=1684534650;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bHSOgTgczHoSpVKp/2cbvFdlvzihl0SXPdnpVyAQEXE=;
        b=DL4vUyqgRdSiNGYrOMHCCVu4riGRO6TrGo1DMsCNj21i34QIMYALJ6YUiRrVJ4AHQa
         /0lenc6c7z184DYUnvLr+Gk9gK91jTtpCGGoxf0oSd5WCxlEH/oeMESULCwbZvq7ISa/
         SYtk8S1n40/SJMMyFLhiwGJ/GqNUiLUstAhzUQEyK/J9mnvbcsxSFTHplvuZDmVmMvkp
         EVX9RlX+6b0vRZzFxIBAypY/QtQ67+/rYMryTYOleU+OJgC8E5EmXAYeEQFHQArA51AF
         ecQhyroUPkrUbxJ0M0NEDA4CTOoMRKUYu3+KT4z/nVbdSzKOZ00MXZw4l9frUjfmws5b
         KiTg==
X-Gm-Message-State: AAQBX9dKFfwtAoajXySB00zr6/75C7kBRLx6bObbtcm2TzQbr9fRQGUQ
        n94YVtzkPNVSkXOPa89Z3hA7cg==
X-Google-Smtp-Source: AKy350Y1OWd64M/bf149HGPoUtfJifI71gsxEsz1b7/l7KAq0ZkmbQRTGD/Vma1+6cmuF5BUtL2Hew==
X-Received: by 2002:a17:902:bcc3:b0:1a6:7b92:15ec with SMTP id o3-20020a170902bcc300b001a67b9215ecmr6654089pls.41.1681942649644;
        Wed, 19 Apr 2023 15:17:29 -0700 (PDT)
Received: from atishp.ba.rivosinc.com ([66.220.2.162])
        by smtp.gmail.com with ESMTPSA id jn11-20020a170903050b00b00196807b5189sm11619190plb.292.2023.04.19.15.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:17:29 -0700 (PDT)
From:   Atish Patra <atishp@rivosinc.com>
To:     linux-kernel@vger.kernel.org
Cc:     Atish Patra <atishp@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anup Patel <anup@brainfault.org>,
        Atish Patra <atishp@atishpatra.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@rivosinc.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Dylan Reid <dylan@rivosinc.com>,
        abrestic@rivosinc.com, Samuel Ortiz <sameo@rivosinc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Conor Dooley <conor.dooley@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guo Ren <guoren@kernel.org>, Heiko Stuebner <heiko@sntech.de>,
        Jiri Slaby <jirislaby@kernel.org>,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>,
        Uladzislau Rezki <urezki@gmail.com>
Subject: [RFC 00/48] RISC-V CoVE support
Date:   Wed, 19 Apr 2023 15:16:28 -0700
Message-Id: <20230419221716.3603068-1-atishp@rivosinc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch series adds the RISC-V Confidential VM Extension (CoVE) support to
Linux kernel. The RISC-V CoVE specification introduces non-ISA, SBI APIs. These
APIs enable a confidential environment in which a guest VM's data can be isolated
from the host while the host retains control of guest VM management and platform
resources(memory, CPU, I/O).

This is a very early WIP work. We want to share this with the community to get any
feedback on overall architecture and direction. Any other feedback is welcome too.

The detailed CoVE architecture document can be found here [0]. It used to be
called AP-TEE and renamed to CoVE recently to avoid overloading term of TEE in
general. The specification is in the draft stages and is subjected to change based
on the feedback from the community.

The CoVE specification introduces 3 new SBI extensions.
COVH - CoVE Host side interface
COVG - CoVE Guest side interface
COVI - CoVE Secure Interrupt management extension

Some key acronyms introduced:

TSM - TEE Security Manager
TVM - TEE VM (aka Confidential VM)

CoVE Architecture:
====================
The CoVE APIs are designed to be implementation and architecture agnostic,
allowing for different deployment models while retaining common host and guest
kernel code. Two examples are shown in Figure 1 and Figure 2.
As shown in both figures, the architecture introduces a new software component
called the "TEE Security Manager" (TSM) that runs in HS mode. The TSM has minimal
hw attested footprint on TCB as it is a passive component that doesn't support
scheduling or timer interrupts. Both example deployment models provide memory 
isolation between the host and the TEE VM (TVM).

        
	Non secure world       |         Secure world         |
                               |                              |
        Non                    |                              |
    Virtualized |  Virtualized |   Virtualized  Virtualized   |            
        Env     |      Env     |       Env          Env       |                
   +----------+ | +----------+ |  +----------+ +----------+   |  --------------        
   |          | | |          | |  |          | |          |   |  
   | Host Apps| | |   Apps   | |  |   Apps   | |   Apps   |   |        VU-Mode
   |  (VMM)   | | |          | |  |          | |          |   |         
   +----------+ | +----------+ |  +----------+ +----------+   |  --------------
        |       | +----------+ |  +----------+ +----------+   |                
        |       | |          | |  |          | |          |   |      
        |       | |          | |  |    TVM   | |    TVM   |   |      
        |       | |   Guest  | |  |   Guest  | |   Guest  |   |       VS-Mode
     Syscalls   | +----------+ |  +----------+ +----------+   |      
        |              |       |        |                     |
        |             SBI      |   SBI(COVG + COVI)           |   
        |              |       |        |                     |
  +--------------------------+ |  +---------------------------+  --------------
  |     Host (Linux)         | |  |       TSM (Salus)         |        
  +--------------------------+ |  +---------------------------+
             |                 |            |                       HS-Mode
     SBI (COVH + COVI)         |     SBI (COVH + COVI)            
             |                 |            |
  +-----------------------------------------------------------+  --------------
  |                    Firmware(OpenSBI) + TSM Driver         |        M-Mode
  +-----------------------------------------------------------+  --------------
 +-----------------------------------------------------------------------------
  |                    Hardware (RISC-V CPU + RoT + IOMMU)
  +---------------------------------------------------------------------------- 
 		Figure 1: Host in HS model


The deployment model shown in Figure 1 runs the host in HS mode where it is peer
to the TSM which also runs in HS mode. It requires another component known as TSM
Driver running in higher privilege mode than host/TSM. It is responsible for switching
the context between the host and the TSM. TSM driver also manages the platform
specific hardware solution via confidential domain bit as described in the specification[0]
to provide the required memory isolation.

 
	     Non secure world  |         Secure world
                               |
         Virtualized Env       |   Virtualized   Virtualized  |                  
             		              Env           Env       |                       
   +-------------------------+ |  +----------+  +----------+  |    ------------ 
   |          | | |          | |  |          |  |          |  |                           
   | Host Apps| | |   Apps   | |  |   Apps   |  |   Apps   |  |        VU-Mode              
   +----------+ | +----------+ |  +----------+  +----------+  |    ------------ 
        |                      |        |             |       |                          
    Syscalls             SBI   |      	|             |       |                           
        |                      |        |             |       |                           
  +--------------------------+ |  +-----------+ +-----------+ |                          
  |     Host (Linux)         | |  |  TVM Guest| |  TVM Guest| |       VS-Mode                
  +--------------------------+ |  +-----------+ +-----------+ |               
             |                 |        |             |       |               
     SBI (COVH + COVI)         |       SBI           SBI      |              
             |                 |   (COVG + COVI) (COVG + COVI)|              
	     |                 |        |             |       |              
  +-----------------------------------------------------------+    --------------
  |                    TSM(Salus)	                      |        HS-Mode
  +-----------------------------------------------------------+    --------------
 			      | 
  			     SBI
			      |
  +---------------------------------------------------------+    --------------
  |                    Firmware(OpenSBI)                  |        M-Mode
  +---------------------------------------------------------+    --------------
 +-----------------------------------------------------------------------------
  |                    Hardware (RISC-V CPU + RoT + IOMMU)
  +---------------------------------------------------------------------------- 
 			Figure 2: Host in VS model


The deployment model shown in Figure 2 simplifies the context switch and memory isolation
by running the host in VS mode as a guest of TSM. Thus, the memory isolation is
achieved by gstage mapping by the TSM. We don't need any additional hardware confidential
domain bit to provide memory isolation. The downside of this model the host has to run the
non-confidential VMs in nested environment which may have lower performance (yet to be measured).
The current implementation Salus(TSM) doesn't support full nested virtualization yet.

The platform must have a RoT to provide attestation in either model.
This patch series implements the APIs defined by CoVE. The current TSM implementation
allows the host to run TVMs as shown in figure 2. We are working on deployment
model 1 in parallel. We do not expect any significant changes in either host/guest side
ABI due to that.

Shared memory between the host & TSM:
=====================================
To accelerate the H-mode CSR/GPR access, CoVE also reuses the Nested Acceleration (NACL)
SBI extension[1]. NACL defines a per physical cpu shared memory area that is allocated
at the boot. It allows the host running in VS mode to access H-mode CSR/GPR easily
without trapping into the TSM. The CoVE specification clearly defines the exact
state of the shared memory with r/w permissions at every call. 

Secure Interrupt management:
===========================
The CoVE specification relies on the MSI based interrupt scheme defined in Advanced Interrupt
Architecture specification[2]. The COVI SBI extension adds functions to bind
a guest interrupt file to a TVMs. After that, only TCB components (TSM, TVM, TSM driver)
can modify that. The host can inject an interrupt via TSM only. 
The TVMs are also in complete control of which interrupts it can receive. By default,
all interrupts are denied. In this proof-of-concept implementation, all the interrupts
are allowed by the guest at boot time to keep it simple.

Device I/O: 
===========
In order to support paravirt I/O devices, SWIOTLB bounce buffer must be used by the
guest. As the host can not access confidential memory, this buffer memory
must be shared with the host via share/unshare functions defined in COVG SBI extension.
RISC-V implementation achieves this generalizing mem_encrypt_init() similar to TDX/SEV/CCA.
That's why, the CoVE Guest is only allowed to use virtio devices with VIRTIO_F_ACCESS_PLATFORM
and VIRTIO_F_VERSION_1 as they force virtio drivers to use the DMA API.

MMIO emulation:
======================
TVM can register regions of address space as MMIO regions to be emulated by
the host. TSM provides explicit SBI functions i.e. SBI_EXT_COVG_[ADD/REMOVE]_MMIO_REGION
to request/remove MMIO regions. Any reads or writes to those MMIO region after
SBI_EXT_COVG_ADD_MMIO_REGION call are forwarded to the host for emulation. 

This series allows any ioremapped memory to be emulated as MMIO region with
above APIs via arch hookups inspired from pKVM work. We are aware that this model
doesn't address all the threat vectors. We have also implemented the device 
filtering/authorization approach adopted by TDX[4]. However, those patches are not
part of this series as the base TDX patches are still under active development.
RISC-V CoVE will also adapt the revamped device filtering work once it is accepted
by the Linux community in the future.

The direct assignment of devices are a work in progress and will be added in the future[4].

VMM support:
============
This series is only tested with kvmtool support. Other VMM support (qemu-kvm, crossvm/rust-vmm)
will be added later.

Test cases:
===========
We are working on kvm selftest for CoVE. We will post them as soon as they are ready.
We haven't started any work on kvm unit-tests as RISC-V doesn't have basic infrastructure
to support that. Once the kvm uni-test infrastructure is in place, we will add
support for CoVE as well. 

Open design questions:
======================

1. The current implementation has two separate configs for guest(CONFIG_RISCV_COVE_GUEST)
and the host (RISCV_COVE_HOST). The default defconfig will enable both so that
same unified image works as both host & guest. Most likely distro prefer this way
to minimize the maintenance burden but some may want a minimal CoVE guest image
that has only hardened drivers. In addition to that, Android runs a microdroid instance
in the confidential guests. A separate config will help in those case. Please let us
know if there is any concern with two configs. 

2. Lazy gstage page allocation vs upfront allocation with page pool.
Currently, all gstage mappings happen at runtime during the fault. This is expensive
as we need to convert that page to confidential memory as well. A page pool framework
may be a better choice which can hold all the confidential pages which can be
pre-allocated upfront. A generic page pool infrastructure may benefit other CC solutions ?

3. In order to allow both confidential VM and non-confidential VM, the series
uses regular branching instead of static branches for CoVE VM specific cases through
out KVM. That may cause a few more branch penalties while running regular VMs. 
The alternate option is to use function pointers for any function that needs to
take a different path. As per my understanding, that would be worse than branches.  

Patch organization:
===================
This series depends on quite a few RISC-V patches that are not upstream yet. 
Here are the dependencies.

1. RISC-V IPI improvement series
2. RISC-V AIA support series.
3. RISC-V NACL support series

In this series, PATCH [0-5] are generic improvement and cleanup patches which
can be merged independently.

PATCH [6-26, 34-37] adds host side for CoVE.
PATCH [27-33] adds the interrupt related changes.
PATCH [34-49] Adds the guest side changes for CoVE.

The TSM project is written in rust and can be found here:
https://github.com/rivosinc/salus

Running the stack
====================

To run/test the stack, you would need the following components :

1) Qemu
2) Common Host & Guest Kernel
3) kvmtool
4) Host RootFS with KVMTOOL and Guest Kernel
5) Salus

The detailed steps are available at[6]

The Linux kernel patches are also available at [7] and the kvmtool patches
are available at [8].

TODOs
=======
As this is a very early work, the todo list is quite long :).
Here are some of them (not in any specific order)

1. Support fd based private memory interface proposed in
   https://lkml.org/lkml/2022/1/18/395
2. Align with updated guest runtime device filtering approach.
3. IOMMU integration
4. Dedicated device assignment via TDSIP & SPDM[4]
5. Support huge pages
6. Page pool allocator to avoid convert/reclaim at every fault
7. Other VMM support (qemu-kvm, crossvm)
8. Complete the PoC for the deployment model 1 where host runs in HS mode
9. Attestation integration
10. Harden the interrupt allowed list
11. kvm self-tests support for CoVE
11. kvm unit-tests support for CoVE
12. Guest hardening
13. Port pKVM on RISC-V using CoVE
14. Any other ?

Links
============
[0] CoVE architecture Specification.
    https://github.com/riscv-non-isa/riscv-ap-tee/blob/main/specification/riscv-aptee-spec.pdf
[1] https://lists.riscv.org/g/sig-hypervisors/message/260 
[2] https://github.com/riscv/riscv-aia/releases/download/1.0-RC2/riscv-interrupts-1.0-RC2.pdf 
[3] https://github.com/rivosinc/linux/tree/cove_integration_device_filtering1
[4] https://github.com/intel/tdx/commits/guest-filter-upstream 
[5] https://lists.riscv.org/g/tech-ap-tee/message/83
[6] https://github.com/rivosinc/cove/wiki/CoVE-KVM-RISCV64-on-QEMU
[7] https://github.com/rivosinc/linux/commits/cove-integration
[8] https://github.com/rivosinc/kvmtool/tree/cove-integration-03072023

Atish Patra (33):
RISC-V: KVM: Improve KVM error reporting to the user space
RISC-V: KVM: Invoke aia_update with preempt disabled/irq enabled
RISC-V: KVM: Add a helper function to get pgd size
RISC-V: Add COVH SBI extensions definitions
RISC-V: KVM: Implement COVH SBI extension
RISC-V: KVM: Add a barebone CoVE implementation
RISC-V: KVM: Add UABI to support static memory region attestation
RISC-V: KVM: Add CoVE related nacl helpers
RISC-V: KVM: Implement static memory region measurement
RISC-V: KVM: Use the new VM IOCTL for measuring pages
RISC-V: KVM: Exit to the user space for trap redirection
RISC-V: KVM: Return early for gstage modifications
RISC-V: KVM: Skip dirty logging updates for TVM
RISC-V: KVM: Add a helper function to trigger fence ops
RISC-V: KVM: Skip most VCPU requests for TVMs
RISC-V : KVM: Skip vmid/hgatp management for TVMs
RISC-V: KVM: Skip TLB management for TVMs
RISC-V: KVM: Register memory regions as confidential for TVMs
RISC-V: KVM: Add gstage mapping for TVMs
RISC-V: KVM: Handle SBI call forward from the TSM
RISC-V: KVM: Implement vcpu load/put functions for CoVE guests
RISC-V: KVM: Wireup TVM world switch
RISC-V: KVM: Skip HVIP update for TVMs
RISC-V: KVM: Implement COVI SBI extension
RISC-V: KVM: Add interrupt management functions for TVM
RISC-V: KVM: Skip AIA CSR updates for TVMs
RISC-V: KVM: Perform limited operations in hardware enable/disable
RISC-V: KVM: Indicate no support user space emulated IRQCHIP
RISC-V: KVM: Add AIA support for TVMs
RISC-V: KVM: Hookup TVM VCPU init/destroy
RISC-V: KVM: Initialize CoVE
RISC-V: KVM: Add TVM init/destroy calls
drivers/hvc: sbi: Disable HVC console for TVMs

Rajnesh Kanwal (15):
mm/vmalloc: Introduce arch hooks to notify ioremap/unmap changes
RISC-V: KVM: Update timer functionality for TVMs.
RISC-V: Add COVI extension definitions
RISC-V: KVM: Read/write gprs from/to shmem in case of TVM VCPU.
RISC-V: Add COVG SBI extension definitions
RISC-V: Add CoVE guest config and helper functions
RISC-V: Implement COVG SBI extension
RISC-V: COVE: Add COVH invalidate, validate, promote, demote and
remove APIs.
RISC-V: KVM: Add host side support to handle COVG SBI calls.
RISC-V: Allow host to inject any ext interrupt id to a CoVE guest.
RISC-V: Add base memory encryption functions.
RISC-V: Add cc_platform_has() for RISC-V for CoVE
RISC-V: ioremap: Implement for arch specific ioremap hooks
riscv/virtio: Have CoVE guests enforce restricted virtio memory
access.
RISC-V: Add shared bounce buffer to support DBCN for CoVE Guest.

arch/riscv/Kbuild                       |    2 +
arch/riscv/Kconfig                      |   27 +
arch/riscv/cove/Makefile                |    2 +
arch/riscv/cove/core.c                  |   40 +
arch/riscv/cove/cove_guest_sbi.c        |  109 +++
arch/riscv/include/asm/cove.h           |   27 +
arch/riscv/include/asm/covg_sbi.h       |   38 +
arch/riscv/include/asm/csr.h            |    2 +
arch/riscv/include/asm/kvm_cove.h       |  206 +++++
arch/riscv/include/asm/kvm_cove_sbi.h   |  101 +++
arch/riscv/include/asm/kvm_host.h       |   10 +-
arch/riscv/include/asm/kvm_vcpu_sbi.h   |    3 +
arch/riscv/include/asm/mem_encrypt.h    |   26 +
arch/riscv/include/asm/sbi.h            |  107 +++
arch/riscv/include/uapi/asm/kvm.h       |   17 +
arch/riscv/kernel/irq.c                 |   12 +
arch/riscv/kernel/setup.c               |    2 +
arch/riscv/kvm/Makefile                 |    1 +
arch/riscv/kvm/aia.c                    |  101 ++-
arch/riscv/kvm/aia_device.c             |   41 +-
arch/riscv/kvm/aia_imsic.c              |  127 ++-
arch/riscv/kvm/cove.c                   | 1005 +++++++++++++++++++++++
arch/riscv/kvm/cove_sbi.c               |  490 +++++++++++
arch/riscv/kvm/main.c                   |   30 +-
arch/riscv/kvm/mmu.c                    |   45 +-
arch/riscv/kvm/tlb.c                    |   11 +-
arch/riscv/kvm/vcpu.c                   |   69 +-
arch/riscv/kvm/vcpu_exit.c              |   34 +-
arch/riscv/kvm/vcpu_insn.c              |  115 ++-
arch/riscv/kvm/vcpu_sbi.c               |   16 +
arch/riscv/kvm/vcpu_sbi_covg.c          |  232 ++++++
arch/riscv/kvm/vcpu_timer.c             |   26 +-
arch/riscv/kvm/vm.c                     |   34 +-
arch/riscv/kvm/vmid.c                   |   17 +-
arch/riscv/mm/Makefile                  |    3 +
arch/riscv/mm/init.c                    |   17 +-
arch/riscv/mm/ioremap.c                 |   45 +
arch/riscv/mm/mem_encrypt.c             |   61 ++
drivers/tty/hvc/hvc_riscv_sbi.c         |    5 +
drivers/tty/serial/earlycon-riscv-sbi.c |   51 +-
include/uapi/linux/kvm.h                |    8 +
mm/vmalloc.c                            |   16 +
42 files changed, 3222 insertions(+), 109 deletions(-)
create mode 100644 arch/riscv/cove/Makefile
create mode 100644 arch/riscv/cove/core.c
create mode 100644 arch/riscv/cove/cove_guest_sbi.c
create mode 100644 arch/riscv/include/asm/cove.h
create mode 100644 arch/riscv/include/asm/covg_sbi.h
create mode 100644 arch/riscv/include/asm/kvm_cove.h
create mode 100644 arch/riscv/include/asm/kvm_cove_sbi.h
create mode 100644 arch/riscv/include/asm/mem_encrypt.h
create mode 100644 arch/riscv/kvm/cove.c
create mode 100644 arch/riscv/kvm/cove_sbi.c
create mode 100644 arch/riscv/kvm/vcpu_sbi_covg.c
create mode 100644 arch/riscv/mm/ioremap.c
create mode 100644 arch/riscv/mm/mem_encrypt.c

--
2.25.1

