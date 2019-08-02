Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6C267F059
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 11:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732058AbfHBJWb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 05:22:31 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45665 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbfHBJWb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 05:22:31 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so76393857wre.12
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 02:22:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tCaYIDdP2Ci1Rqrimk/5TgidRQI7nz3EH1dEhZNEucs=;
        b=MQjntH26ydNCT1zJjfLBqL03IqN+RgELCFU5WD3sD05VW1C2M1CTaMQk1DNLi0b73B
         bzv80gF9WisSn4Mfnh+fye8HUCnZYptL4gC88AdJ8DN4eNTQwcdCCh0LM00tsjUkjPFL
         TuUwFd9H1kGLkeaLajJEt0Ca1/gzsWL/12lxCnbOULuFA7ayVo29vhe6V8rBQ1ghve6V
         TqRDicubToDvMwe+dOonXjGNGt7ptXFZ0A17yliKg55RR02AW8DHvrCZiwzUhajnt3Er
         nq2nHRVaGb/RSgEnwbW/SDF/wSKglk3XkO9AwwCYbVF81G3EN98cqbHSewtqgSYkG2Ew
         j5+w==
X-Gm-Message-State: APjAAAVbdRo5tegS2WjHBbdWxdXAliCiEDTi3ZlmzQLLDJuMd7V2Ep1V
        JdkoZb/RDFsQXKZTn6CQjkxW8g==
X-Google-Smtp-Source: APXvYqyDQKnln1metCTCY1u5z6hKN9sOh4Pat8nTJ6NPmxbSAUWCt4kokXgFAvLvK7B7D+YkzXAPQw==
X-Received: by 2002:a05:6000:12c2:: with SMTP id l2mr30757948wrx.65.1564737748423;
        Fri, 02 Aug 2019 02:22:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id z1sm78098619wrp.51.2019.08.02.02.22.26
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 02:22:27 -0700 (PDT)
Subject: Re: [RFC PATCH v2 00/19] KVM RISC-V Support
To:     Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190802074620.115029-1-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <69900526-8d7d-1ccb-4e8f-262ac1ae078e@redhat.com>
Date:   Fri, 2 Aug 2019 11:22:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190802074620.115029-1-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/19 09:46, Anup Patel wrote:
> This series adds initial KVM RISC-V support. Currently, we are able to boot
> RISC-V 64bit Linux Guests with multiple VCPUs.
> 
> Few key aspects of KVM RISC-V added by this series are:
> 1. Minimal possible KVM world-switch which touches only GPRs and few CSRs.
> 2. Full Guest/VM switch is done via vcpu_get/vcpu_put infrastructure.
> 3. KVM ONE_REG interface for VCPU register access from user-space.
> 4. PLIC emulation is done in user-space. In-kernel PLIC emulation, will
>    be added in future.
> 5. Timer and IPI emuation is done in-kernel.
> 6. MMU notifiers supported.
> 7. FP lazy save/restore supported.
> 8. SBI v0.1 emulation for KVM Guest available.
> 
> Here's a brief TODO list which we will work upon after this series:
> 1. Handle trap from unpriv access in reading Guest instruction
> 2. Handle trap from unpriv access in SBI v0.1 emulation
> 3. Implement recursive stage2 page table programing
> 4. SBI v0.2 emulation in-kernel
> 5. SBI v0.2 hart hotplug emulation in-kernel
> 6. In-kernel PLIC emulation
> 7. ..... and more .....
> 
> This series is based upon KVM pre-patches sent by Atish earlier
> (https://lkml.org/lkml/2019/7/31/1503) and it can be found in
> riscv_kvm_v2 branch at:
> https//github.com/avpatel/linux.git
> 
> Our work-in-progress KVMTOOL RISC-V port can be found in riscv_v1 branch at:
> https//github.com/avpatel/kvmtool.git
> 
> We need OpenSBI with RISC-V hypervisor extension support which can be
> found in hyp_ext_changes_v1 branch at:
> https://github.com/riscv/opensbi.git
> 
> The QEMU RISC-V hypervisor emulation is done by Alistair and is available
> in riscv-hyp-work.next branch at:
> https://github.com/alistair23/qemu.git
> 
> To play around with KVM RISC-V, here are few reference commands:
> 1) To cross-compile KVMTOOL:
>    $ make lkvm-static
> 2) To launch RISC-V Host Linux:
>    $ qemu-system-riscv64 -monitor null -cpu rv64,h=true -M virt \
>    -m 512M -display none -serial mon:stdio \
>    -kernel opensbi/build/platform/qemu/virt/firmware/fw_jump.elf \
>    -device loader,file=build-riscv64/arch/riscv/boot/Image,addr=0x80200000 \
>    -initrd ./rootfs_kvm_riscv64.img \
>    -append "root=/dev/ram rw console=ttyS0 earlycon=sbi"
> 3) To launch RISC-V Guest Linux with 9P rootfs:
>    $ ./apps/lkvm-static run -m 128 -c2 --console serial \
>    -p "console=ttyS0 earlycon=uart8250,mmio,0x3f8" -k ./apps/Image --debug
> 4) To launch RISC-V Guest Linux with initrd:
>    $ ./apps/lkvm-static run -m 128 -c2 --console serial \
>    -p "console=ttyS0 earlycon=uart8250,mmio,0x3f8" -k ./apps/Image \
>    -i ./apps/rootfs.img --debug

LGTM apart from the comments I've sent about locking---which was the
focus of my review this time through---and the bug on reading VSIP).

Please try to have your GPG key signed by some other Linux maintainers
so that you can use signed pull requests for RISC-V KVM.

Paolo

> Changes since v1:
> - Fixed compile errors in building KVM RISC-V as module
> - Removed unused kvm_riscv_halt_guest() and kvm_riscv_resume_guest()
> - Set KVM_CAP_SYNC_MMU capability only after MMU notifiers are implemented
> - Made vmid_version as unsigned long instead of atomic
> - Renamed KVM_REQ_UPDATE_PGTBL to KVM_REQ_UPDATE_HGATP
> - Renamed kvm_riscv_stage2_update_pgtbl() to kvm_riscv_stage2_update_hgatp()
> - Configure HIDELEG and HEDELEG in kvm_arch_hardware_enable()
> - Updated ONE_REG interface for CSR access to user-space
> - Removed irqs_pending_lock and use atomic bitops instead
> - Added separate patch for FP ONE_REG interface
> - Added separate patch for updating MAINTAINERS file
> 
> Anup Patel (14):
>   KVM: RISC-V: Add KVM_REG_RISCV for ONE_REG interface
>   RISC-V: Add hypervisor extension related CSR defines
>   RISC-V: Add initial skeletal KVM support
>   RISC-V: KVM: Implement VCPU create, init and destroy functions
>   RISC-V: KVM: Implement VCPU interrupts and requests handling
>   RISC-V: KVM: Implement KVM_GET_ONE_REG/KVM_SET_ONE_REG ioctls
>   RISC-V: KVM: Implement VCPU world-switch
>   RISC-V: KVM: Handle MMIO exits for VCPU
>   RISC-V: KVM: Handle WFI exits for VCPU
>   RISC-V: KVM: Implement VMID allocator
>   RISC-V: KVM: Implement stage2 page table programming
>   RISC-V: KVM: Implement MMU notifiers
>   RISC-V: Enable VIRTIO drivers in RV64 and RV32 defconfig
>   RISC-V: KVM: Add MAINTAINERS entry
> 
> Atish Patra (5):
>   RISC-V: Export few kernel symbols
>   RISC-V: KVM: Add timer functionality
>   RISC-V: KVM: FP lazy save/restore
>   RISC-V: KVM: Implement ONE REG interface for FP registers
>   RISC-V: KVM: Add SBI v0.1 support
> 
>  MAINTAINERS                             |  10 +
>  arch/riscv/Kconfig                      |   2 +
>  arch/riscv/Makefile                     |   2 +
>  arch/riscv/configs/defconfig            |  23 +-
>  arch/riscv/configs/rv32_defconfig       |  13 +
>  arch/riscv/include/asm/csr.h            |  58 ++
>  arch/riscv/include/asm/kvm_host.h       | 228 ++++++
>  arch/riscv/include/asm/kvm_vcpu_timer.h |  32 +
>  arch/riscv/include/asm/pgtable-bits.h   |   1 +
>  arch/riscv/include/uapi/asm/kvm.h       |  98 +++
>  arch/riscv/kernel/asm-offsets.c         | 148 ++++
>  arch/riscv/kernel/smp.c                 |   2 +-
>  arch/riscv/kernel/time.c                |   1 +
>  arch/riscv/kvm/Kconfig                  |  34 +
>  arch/riscv/kvm/Makefile                 |  14 +
>  arch/riscv/kvm/main.c                   |  84 +++
>  arch/riscv/kvm/mmu.c                    | 904 +++++++++++++++++++++++
>  arch/riscv/kvm/tlb.S                    |  43 ++
>  arch/riscv/kvm/vcpu.c                   | 936 ++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_exit.c              | 554 ++++++++++++++
>  arch/riscv/kvm/vcpu_sbi.c               | 119 +++
>  arch/riscv/kvm/vcpu_switch.S            | 368 ++++++++++
>  arch/riscv/kvm/vcpu_timer.c             | 106 +++
>  arch/riscv/kvm/vm.c                     |  86 +++
>  arch/riscv/kvm/vmid.c                   | 124 ++++
>  drivers/clocksource/timer-riscv.c       |   8 +
>  include/clocksource/timer-riscv.h       |  16 +
>  include/uapi/linux/kvm.h                |   1 +
>  28 files changed, 4009 insertions(+), 6 deletions(-)
>  create mode 100644 arch/riscv/include/asm/kvm_host.h
>  create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
>  create mode 100644 arch/riscv/include/uapi/asm/kvm.h
>  create mode 100644 arch/riscv/kvm/Kconfig
>  create mode 100644 arch/riscv/kvm/Makefile
>  create mode 100644 arch/riscv/kvm/main.c
>  create mode 100644 arch/riscv/kvm/mmu.c
>  create mode 100644 arch/riscv/kvm/tlb.S
>  create mode 100644 arch/riscv/kvm/vcpu.c
>  create mode 100644 arch/riscv/kvm/vcpu_exit.c
>  create mode 100644 arch/riscv/kvm/vcpu_sbi.c
>  create mode 100644 arch/riscv/kvm/vcpu_switch.S
>  create mode 100644 arch/riscv/kvm/vcpu_timer.c
>  create mode 100644 arch/riscv/kvm/vm.c
>  create mode 100644 arch/riscv/kvm/vmid.c
>  create mode 100644 include/clocksource/timer-riscv.h
> 
> --
> 2.17.1
> 

