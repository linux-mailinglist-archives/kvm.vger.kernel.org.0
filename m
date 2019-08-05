Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2462A82137
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 18:05:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729818AbfHEQFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 12:05:41 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35575 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728760AbfHEQFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 12:05:40 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so84982622wrm.2
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2019 09:05:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F30R4qg1ehN1CROeEQ4O0h0Y95Idm2w6D1zzJAIh5ac=;
        b=J9cAExhPJ3YWklneaX2hjxbwf6xigZAVJbLffTnZ5vfiqP+vb61tWYDj1ldZzkvILo
         TUBtoNO6I2rINZK134XHXaSzZYNOWcPGkS38t9h2Qv+CsjvJJPED7lATUUnc2X0N6nE0
         SkT63ECK2/l4LpB3v8eMAJKJxWdAiQ3QRY6vF/go3M69wAb50WJX0NrxP0FMb0nbL1cb
         O+JVmRy1BpnN1XNSTxgqe1QOlaHnkg5wy4vCeDc27VK2kYVNh3tdGmR4U+CwEOlvymEZ
         HVRV1JWVq42tx7cFXplguMz8h8Pu1Cc14Q58+3j33dwswQNLp4rDm7w2WNT1aitn3/BU
         23uw==
X-Gm-Message-State: APjAAAV9ROQqTMr2KXBx5/QQwgfNam4FnH65RPQBenAZ3hWMg5Q/zJ4v
        8AYt+0pzpRQJhzc7mM4Oxx+YOb7JNdY=
X-Google-Smtp-Source: APXvYqy7A9JkVqAMIMky+gYE7j+6NzxtekmRVJCCCasvFXTPDZNrK+JWKAporAiSAWY+bNgMyEHjGg==
X-Received: by 2002:adf:f646:: with SMTP id x6mr18935724wrp.18.1565021137746;
        Mon, 05 Aug 2019 09:05:37 -0700 (PDT)
Received: from [192.168.178.40] ([151.21.165.91])
        by smtp.gmail.com with ESMTPSA id 2sm121528630wrn.29.2019.08.05.09.05.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 09:05:37 -0700 (PDT)
Subject: Re: [PATCH v3 00/19] KVM RISC-V Support
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20190805134201.2814-1-anup.patel@wdc.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c8ea136f-b34b-c7b4-c319-93906fa595bd@redhat.com>
Date:   Mon, 5 Aug 2019 18:05:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190805134201.2814-1-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/19 15:42, Anup Patel wrote:
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
> (https://lkml.org/lkml/2019/8/3/3) and it can be found in
> riscv_kvm_v3 branch at:
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
> 
> Changes since v2:
> - Removed references of KVM_REQ_IRQ_PENDING from all patches
> - Use kvm->srcu within in-kernel KVM run loop
> - Added percpu vsip_shadow to track last value programmed in VSIP CSR
> - Added comments about irqs_pending and irqs_pending_mask
> - Used kvm_arch_vcpu_runnable() in-place-of kvm_riscv_vcpu_has_interrupt()
>   in system_opcode_insn()
> - Removed unwanted smp_wmb() in kvm_riscv_stage2_vmid_update()
> - Use kvm_flush_remote_tlbs() in kvm_riscv_stage2_vmid_update()
> - Use READ_ONCE() in kvm_riscv_stage2_update_hgatp() for vmid
> 
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

Down to one comment, which can be addressed when applying (though I'd
prefer if you tested the one-token fix).

Palmer, Albert, can you give your Acked-by, especially for patches
2-3-18-19?

Thanks,

Paolo

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
>  arch/riscv/configs/defconfig            |  13 +
>  arch/riscv/configs/rv32_defconfig       |  13 +
>  arch/riscv/include/asm/csr.h            |  58 ++
>  arch/riscv/include/asm/kvm_host.h       | 243 ++++++
>  arch/riscv/include/asm/kvm_vcpu_timer.h |  32 +
>  arch/riscv/include/asm/pgtable-bits.h   |   1 +
>  arch/riscv/include/uapi/asm/kvm.h       |  98 +++
>  arch/riscv/kernel/asm-offsets.c         | 148 ++++
>  arch/riscv/kernel/smp.c                 |   2 +-
>  arch/riscv/kernel/time.c                |   1 +
>  arch/riscv/kvm/Kconfig                  |  34 +
>  arch/riscv/kvm/Makefile                 |  14 +
>  arch/riscv/kvm/main.c                   |  86 +++
>  arch/riscv/kvm/mmu.c                    | 905 ++++++++++++++++++++++
>  arch/riscv/kvm/tlb.S                    |  43 ++
>  arch/riscv/kvm/vcpu.c                   | 969 ++++++++++++++++++++++++
>  arch/riscv/kvm/vcpu_exit.c              | 556 ++++++++++++++
>  arch/riscv/kvm/vcpu_sbi.c               | 119 +++
>  arch/riscv/kvm/vcpu_switch.S            | 368 +++++++++
>  arch/riscv/kvm/vcpu_timer.c             | 106 +++
>  arch/riscv/kvm/vm.c                     |  86 +++
>  arch/riscv/kvm/vmid.c                   | 111 +++
>  drivers/clocksource/timer-riscv.c       |   8 +
>  include/clocksource/timer-riscv.h       |  16 +
>  include/uapi/linux/kvm.h                |   1 +
>  28 files changed, 4044 insertions(+), 1 deletion(-)
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

