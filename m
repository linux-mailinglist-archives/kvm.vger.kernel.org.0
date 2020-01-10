Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7719137410
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 17:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAJQtx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 11:49:53 -0500
Received: from foss.arm.com ([217.140.110.172]:48428 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbgAJQtx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 11:49:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EB0D30E;
        Fri, 10 Jan 2020 08:49:52 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ECF013F6C4;
        Fri, 10 Jan 2020 08:49:50 -0800 (PST)
Date:   Fri, 10 Jan 2020 16:49:47 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Anup Patel <anup@brainfault.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Will Deacon <will.deacon@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>
Subject: Re: [kvmtool RFC PATCH 2/8] riscv: Initial skeletal support
Message-ID: <20200110164947.2301096a@donnerap.cambridge.arm.com>
In-Reply-To: <CAAhSdy12is7QU5BHrDMGVnxHPm2soTHu62XQqkxPSnZCUdhVqA@mail.gmail.com>
References: <20191225025945.108466-1-anup.patel@wdc.com>
        <20191225025945.108466-3-anup.patel@wdc.com>
        <c655ed3a-151e-0450-3439-d913ff22f5b1@arm.com>
        <CAAhSdy1XuwQGg=o0c957YfbOL9BMgzXFY08fYt4NOdoo=3NTzQ@mail.gmail.com>
        <70acbb6e-f076-8883-14bd-0b5df3c4fb2a@arm.com>
        <CAAhSdy12is7QU5BHrDMGVnxHPm2soTHu62XQqkxPSnZCUdhVqA@mail.gmail.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 Jan 2020 17:05:28 +0530
Anup Patel <anup@brainfault.org> wrote:

Hi,

[ ... ]

> > >>> +
> > >>> +#define RISCV_IOPORT         0x00000000ULL
> > >>> +#define RISCV_IOPORT_SIZE    0x00010000ULL
> > >>> +#define RISCV_PLIC           0x0c000000ULL
> > >>> +#define RISCV_PLIC_SIZE              0x04000000ULL
> > >>> +#define RISCV_MMIO           0x10000000ULL
> > >>> +#define RISCV_MMIO_SIZE              0x20000000ULL
> > >>> +#define RISCV_PCI            0x30000000ULL
> > >>> +#define RISCV_PCI_CFG_SIZE   0x10000000ULL  
> > >> In the DTB you're advertising the PCI node as CAM compatible, which is the right
> > >> thing to do. Legacy PCI configuration space is 16MB, not 256MB (PCI Express is 256MB).  
> > > I was confused here so I did what was done for ARM. I will check with other
> > > architectures and update like you suggested.  
> >
> > For ARM, it's 16 MB (taken from arm/include/arm-common/kvm-arch.h)
> >
> > #define ARM_PCI_CFG_SIZE    (1ULL << 24)
> >
> > which was duplicated from include/kvm/pci.h:
> >
> > #define PCI_CFG_SIZE        (1ULL << 24)**
> >
> > It's not a question of what other architectures do, it's about kvmtool emulating
> > the legacy PCI 3.0 protocol which uses 24 bits for device addressing. You can
> > declare the PCI configuration space to be 256 MB (i.e 28 bit addresses), but
> > kvmtool will only use the bottom 16MB.  
> 
> Thanks for the PCI related explanation.
> 
> I will update PCI config size to 16M.

Actually, looking forward, you should at least reserve 256 MB, since we plan to upgrade kvmtool to PCIe soonish. You might as well keep your current 256MB, but have a comment about it currently using only the first 16MB. This comment could then be deleted after the upgrade.

Cheers,
Andre.

> >
> > Thanks,
> > Alex  
> > >  
> > >>> +#define RISCV_PCI_SIZE               0x50000000ULL
> > >>> +#define RISCV_PCI_MMIO_SIZE  (RISCV_PCI_SIZE - RISCV_PCI_CFG_SIZE)
> > >>> +
> > >>> +#define RISCV_RAM            0x80000000ULL  
> > >> I'm not sure about the reasons for choosing RAM to start at 2GB. For arm we do the
> > >> same, but qemu starts memory at 1GB and this mismatch has caused some issues in
> > >> the past. For example, 32 bit kvm-unit-tests currently do not run under kvmtool
> > >> because the text address is hardcoded to the qemu default value.  
> > > Actually in RISC-V world, it is kind of a un-documented standard that
> > > RAM starts at
> > > 2GB (0x80000000) for both RV32 and RV64. This is true for all existing HW,
> > > QEMU RISC-V virt machine and here. This will be soon explicitly documented in
> > > RISC-V Unix platform spec.
> > >  
> > >> As a more general observation, I know that other architectures (like arm) declare
> > >> the memory layout in hexadecimal numbers, but it might be a better idea to use the
> > >> sizes from include/linux/sizes.h, since it makes the memory layout a lot more
> > >> readable and mistakes are easier to spot.  
> > > Sure, I will try to use linux/sizes.h in next patch version.
> > >  
> > >>> +
> > >>> +#define RISCV_LOMAP_MAX_MEMORY       ((1ULL << 32) - RISCV_RAM)
> > >>> +#define RISCV_HIMAP_MAX_MEMORY       ((1ULL << 40) - RISCV_RAM)
> > >>> +
> > >>> +#if __riscv_xlen == 64
> > >>> +#define RISCV_MAX_MEMORY(kvm)        RISCV_HIMAP_MAX_MEMORY
> > >>> +#elif __riscv_xlen == 32
> > >>> +#define RISCV_MAX_MEMORY(kvm)        RISCV_LOMAP_MAX_MEMORY
> > >>> +#endif
> > >>> +
> > >>> +#define KVM_IOPORT_AREA              RISCV_IOPORT
> > >>> +#define KVM_PCI_CFG_AREA     RISCV_PCI
> > >>> +#define KVM_PCI_MMIO_AREA    (KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
> > >>> +#define KVM_VIRTIO_MMIO_AREA RISCV_MMIO
> > >>> +
> > >>> +#define KVM_IOEVENTFD_HAS_PIO        0
> > >>> +
> > >>> +#define KVM_IRQ_OFFSET               0
> > >>> +
> > >>> +#define KVM_VM_TYPE          0
> > >>> +
> > >>> +#define VIRTIO_DEFAULT_TRANS(kvm)    VIRTIO_MMIO
> > >>> +
> > >>> +#define VIRTIO_RING_ENDIAN   VIRTIO_ENDIAN_LE
> > >>> +
> > >>> +struct kvm;
> > >>> +
> > >>> +struct kvm_arch {
> > >>> +};
> > >>> +
> > >>> +static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
> > >>> +{
> > >>> +     u64 limit = KVM_IOPORT_AREA + RISCV_IOPORT_SIZE;
> > >>> +     return phys_addr >= KVM_IOPORT_AREA && phys_addr < limit;
> > >>> +}
> > >>> +
> > >>> +enum irq_type;
> > >>> +
> > >>> +#endif /* KVM__KVM_ARCH_H */
> > >>> diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
> > >>> new file mode 100644
> > >>> index 0000000..60c7333
> > >>> --- /dev/null
> > >>> +++ b/riscv/include/kvm/kvm-config-arch.h
> > >>> @@ -0,0 +1,9 @@
> > >>> +#ifndef KVM__KVM_CONFIG_ARCH_H
> > >>> +#define KVM__KVM_CONFIG_ARCH_H
> > >>> +
> > >>> +#include "kvm/parse-options.h"
> > >>> +
> > >>> +struct kvm_config_arch {
> > >>> +};
> > >>> +
> > >>> +#endif /* KVM__KVM_CONFIG_ARCH_H */
> > >>> diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
> > >>> new file mode 100644
> > >>> index 0000000..09a50e8
> > >>> --- /dev/null
> > >>> +++ b/riscv/include/kvm/kvm-cpu-arch.h
> > >>> @@ -0,0 +1,49 @@
> > >>> +#ifndef KVM__KVM_CPU_ARCH_H
> > >>> +#define KVM__KVM_CPU_ARCH_H
> > >>> +
> > >>> +#include <linux/kvm.h>
> > >>> +#include <pthread.h>
> > >>> +#include <stdbool.h>
> > >>> +
> > >>> +#include "kvm/kvm.h"
> > >>> +
> > >>> +struct kvm;  
> > >> Shouldn't kvm.h already have a definition for struct kvm? Also, the arm
> > >> corresponding header doesn't have the include here, I don't think it's needed
> > >> (unless I'm missing something).  
> > > Sure, I will drop this forward declaration here.
> > >
> > > Regards,
> > > Anup
> > >  
> > >> Thanks,
> > >> Alex  
> > >>> +
> > >>> +struct kvm_cpu {
> > >>> +     pthread_t       thread;
> > >>> +
> > >>> +     unsigned long   cpu_id;
> > >>> +
> > >>> +     struct kvm      *kvm;
> > >>> +     int             vcpu_fd;
> > >>> +     struct kvm_run  *kvm_run;
> > >>> +     struct kvm_cpu_task     *task;
> > >>> +
> > >>> +     u8              is_running;
> > >>> +     u8              paused;
> > >>> +     u8              needs_nmi;
> > >>> +
> > >>> +     struct kvm_coalesced_mmio_ring  *ring;
> > >>> +};
> > >>> +
> > >>> +static inline bool kvm_cpu__emulate_io(struct kvm_cpu *vcpu, u16 port,
> > >>> +                                    void *data, int direction,
> > >>> +                                    int size, u32 count)
> > >>> +{
> > >>> +     return false;
> > >>> +}
> > >>> +
> > >>> +static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr,
> > >>> +                                      u8 *data, u32 len, u8 is_write)
> > >>> +{
> > >>> +     if (riscv_addr_in_ioport_region(phys_addr)) {
> > >>> +             int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
> > >>> +             u16 port = (phys_addr - KVM_IOPORT_AREA) & USHRT_MAX;
> > >>> +
> > >>> +             return kvm__emulate_io(vcpu, port, data, direction, len, 1);
> > >>> +     }
> > >>> +
> > >>> +     return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
> > >>> +}
> > >>> +
> > >>> +#endif /* KVM__KVM_CPU_ARCH_H */
> > >>> diff --git a/riscv/ioport.c b/riscv/ioport.c
> > >>> new file mode 100644
> > >>> index 0000000..bdd30b6
> > >>> --- /dev/null
> > >>> +++ b/riscv/ioport.c
> > >>> @@ -0,0 +1,11 @@
> > >>> +#include "kvm/ioport.h"
> > >>> +#include "kvm/irq.h"
> > >>> +
> > >>> +void ioport__setup_arch(struct kvm *kvm)
> > >>> +{
> > >>> +}
> > >>> +
> > >>> +void ioport__map_irq(u8 *irq)
> > >>> +{
> > >>> +     *irq = irq__alloc_line();
> > >>> +}
> > >>> diff --git a/riscv/irq.c b/riscv/irq.c
> > >>> new file mode 100644
> > >>> index 0000000..8e605ef
> > >>> --- /dev/null
> > >>> +++ b/riscv/irq.c
> > >>> @@ -0,0 +1,13 @@
> > >>> +#include "kvm/kvm.h"
> > >>> +#include "kvm/kvm-cpu.h"
> > >>> +#include "kvm/irq.h"
> > >>> +
> > >>> +void kvm__irq_line(struct kvm *kvm, int irq, int level)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +void kvm__irq_trigger(struct kvm *kvm, int irq)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
> > >>> new file mode 100644
> > >>> index 0000000..e4b8fa5
> > >>> --- /dev/null
> > >>> +++ b/riscv/kvm-cpu.c
> > >>> @@ -0,0 +1,64 @@
> > >>> +#include "kvm/kvm-cpu.h"
> > >>> +#include "kvm/kvm.h"
> > >>> +#include "kvm/virtio.h"
> > >>> +#include "kvm/term.h"
> > >>> +
> > >>> +#include <asm/ptrace.h>
> > >>> +
> > >>> +static int debug_fd;
> > >>> +
> > >>> +void kvm_cpu__set_debug_fd(int fd)
> > >>> +{
> > >>> +     debug_fd = fd;
> > >>> +}
> > >>> +
> > >>> +int kvm_cpu__get_debug_fd(void)
> > >>> +{
> > >>> +     return debug_fd;
> > >>> +}
> > >>> +
> > >>> +struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +     return NULL;
> > >>> +}
> > >>> +
> > >>> +void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
> > >>> +{
> > >>> +}
> > >>> +
> > >>> +void kvm_cpu__delete(struct kvm_cpu *vcpu)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +     return false;
> > >>> +}
> > >>> +
> > >>> +void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
> > >>> +{
> > >>> +     return VIRTIO_ENDIAN_LE;
> > >>> +}
> > >>> +
> > >>> +void kvm_cpu__show_code(struct kvm_cpu *vcpu)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> diff --git a/riscv/kvm.c b/riscv/kvm.c
> > >>> new file mode 100644
> > >>> index 0000000..e816ef5
> > >>> --- /dev/null
> > >>> +++ b/riscv/kvm.c
> > >>> @@ -0,0 +1,61 @@
> > >>> +#include "kvm/kvm.h"
> > >>> +#include "kvm/util.h"
> > >>> +#include "kvm/fdt.h"
> > >>> +
> > >>> +#include <linux/kernel.h>
> > >>> +#include <linux/kvm.h>
> > >>> +#include <linux/sizes.h>
> > >>> +
> > >>> +struct kvm_ext kvm_req_ext[] = {
> > >>> +     { DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
> > >>> +     { 0, 0 },
> > >>> +};
> > >>> +
> > >>> +bool kvm__arch_cpu_supports_vm(void)
> > >>> +{
> > >>> +     /* The KVM capability check is enough. */
> > >>> +     return true;
> > >>> +}
> > >>> +
> > >>> +void kvm__init_ram(struct kvm *kvm)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +void kvm__arch_delete_ram(struct kvm *kvm)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +void kvm__arch_read_term(struct kvm *kvm)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +void kvm__arch_set_cmdline(char *cmdline, bool video)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +}
> > >>> +
> > >>> +bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
> > >>> +                              const char *kernel_cmdline)
> > >>> +{
> > >>> +     /* TODO: */
> > >>> +     return true;
> > >>> +}
> > >>> +
> > >>> +bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
> > >>> +{
> > >>> +     /* TODO: Firmware loading to be supported later. */
> > >>> +     return false;
> > >>> +}
> > >>> +
> > >>> +int kvm__arch_setup_firmware(struct kvm *kvm)
> > >>> +{
> > >>> +     return 0;
> > >>> +}
> > >>> diff --git a/util/update_headers.sh b/util/update_headers.sh
> > >>> index bf87ef6..78eba1f 100755
> > >>> --- a/util/update_headers.sh
> > >>> +++ b/util/update_headers.sh
> > >>> @@ -36,7 +36,7 @@ copy_optional_arch () {
> > >>>       fi
> > >>>  }
> > >>>
> > >>> -for arch in arm arm64 mips powerpc x86
> > >>> +for arch in arm arm64 mips powerpc riscv x86
> > >>>  do
> > >>>       case "$arch" in
> > >>>               arm) KVMTOOL_PATH=arm/aarch32 ;;  

