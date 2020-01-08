Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00B3C1343B0
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 14:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgAHNWO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 08:22:14 -0500
Received: from foss.arm.com ([217.140.110.172]:44460 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbgAHNWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 08:22:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F1A531B;
        Wed,  8 Jan 2020 05:22:13 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDF5C3F703;
        Wed,  8 Jan 2020 05:22:11 -0800 (PST)
Subject: Re: [kvmtool RFC PATCH 3/8] riscv: Implement Guest/VM arch functions
To:     Anup Patel <Anup.Patel@wdc.com>, Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>
References: <20191225025945.108466-1-anup.patel@wdc.com>
 <20191225025945.108466-4-anup.patel@wdc.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <cb49e776-0673-d6cf-d4dc-ec89a946e5b0@arm.com>
Date:   Wed, 8 Jan 2020 13:22:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191225025945.108466-4-anup.patel@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

On 12/25/19 3:00 AM, Anup Patel wrote:
> This patch implements all kvm__arch_<xyz> Guest/VM arch functions.
>
> These functions mostly deal with:
> 1. Guest/VM RAM initialization
> 2. Updating terminals on character read
> 3. Loading kernel and initrd images
>
> Firmware loading is not implemented currently because initially we
> will be booting kernel directly without any bootloader. In future,
> we will certainly support firmware loading.
>
> Signed-off-by: Anup Patel <anup.patel@wdc.com>
> ---
>  riscv/include/kvm/kvm-arch.h |  15 +++++
>  riscv/kvm.c                  | 126 +++++++++++++++++++++++++++++++++--
>  2 files changed, 135 insertions(+), 6 deletions(-)
>
> diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
> index 7e9c578..b3ec2d6 100644
> --- a/riscv/include/kvm/kvm-arch.h
> +++ b/riscv/include/kvm/kvm-arch.h
> @@ -45,6 +45,21 @@
>  struct kvm;
>  
>  struct kvm_arch {
> +	/*
> +	 * We may have to align the guest memory for virtio, so keep the
> +	 * original pointers here for munmap.
> +	 */
> +	void	*ram_alloc_start;
> +	u64	ram_alloc_size;
> +
> +	/*
> +	 * Guest addresses for memory layout.
> +	 */
> +	u64	memory_guest_start;
> +	u64	kern_guest_start;
> +	u64	initrd_guest_start;
> +	u64	initrd_size;
> +	u64	dtb_guest_start;
>  };
>  
>  static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
> diff --git a/riscv/kvm.c b/riscv/kvm.c
> index e816ef5..c0d3639 100644
> --- a/riscv/kvm.c
> +++ b/riscv/kvm.c
> @@ -1,5 +1,7 @@
>  #include "kvm/kvm.h"
>  #include "kvm/util.h"
> +#include "kvm/8250-serial.h"
> +#include "kvm/virtio-console.h"
>  #include "kvm/fdt.h"
>  
>  #include <linux/kernel.h>
> @@ -19,33 +21,145 @@ bool kvm__arch_cpu_supports_vm(void)
>  
>  void kvm__init_ram(struct kvm *kvm)
>  {
> -	/* TODO: */
> +	int err;
> +	u64 phys_start, phys_size;
> +	void *host_mem;
> +
> +	phys_start	= RISCV_RAM;
> +	phys_size	= kvm->ram_size;
> +	host_mem	= kvm->ram_start;
> +
> +	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> +	if (err)
> +		die("Failed to register %lld bytes of memory at physical "
> +		    "address 0x%llx [err %d]", phys_size, phys_start, err);
> +
> +	kvm->arch.memory_guest_start = phys_start;
>  }
>  
>  void kvm__arch_delete_ram(struct kvm *kvm)
>  {
> -	/* TODO: */
> +	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
>  }
>  
>  void kvm__arch_read_term(struct kvm *kvm)
>  {
> -	/* TODO: */
> +	serial8250__update_consoles(kvm);
> +	virtio_console__inject_interrupt(kvm);
>  }
>  
>  void kvm__arch_set_cmdline(char *cmdline, bool video)
>  {
> -	/* TODO: */
>  }
>  
>  void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
>  {
> -	/* TODO: */
> +	/*
> +	 * Allocate guest memory. We must align our buffer to 64K to
> +	 * correlate with the maximum guest page size for virtio-mmio.
> +	 * If using THP, then our minimal alignment becomes 2M.
> +	 * 2M trumps 64K, so let's go with that.
> +	 */
> +	kvm->ram_size = min(ram_size, (u64)RISCV_MAX_MEMORY(kvm));
> +	kvm->arch.ram_alloc_size = kvm->ram_size + SZ_2M;
> +	kvm->arch.ram_alloc_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path,
> +						kvm->arch.ram_alloc_size);
> +
> +	if (kvm->arch.ram_alloc_start == MAP_FAILED)
> +		die("Failed to map %lld bytes for guest memory (%d)",
> +		    kvm->arch.ram_alloc_size, errno);
> +
> +	kvm->ram_start = (void *)ALIGN((unsigned long)kvm->arch.ram_alloc_start,
> +					SZ_2M);
> +
> +	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> +		MADV_MERGEABLE);
> +
> +	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
> +		MADV_HUGEPAGE);
>  }
>  
> +#define FDT_ALIGN	SZ_4M
> +#define INITRD_ALIGN	4
>  bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
>  				 const char *kernel_cmdline)
>  {
> -	/* TODO: */
> +	void *pos, *kernel_end, *limit;
> +	unsigned long guest_addr, kernel_offset;
> +	ssize_t file_size;
> +
> +	/*
> +	 * Linux requires the initrd and dtb to be mapped inside lowmem,
> +	 * so we can't just place them at the top of memory.
> +	 */
> +	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
> +
> +#if __riscv_xlen == 64
> +	/* Linux expects to be booted at 2M boundary for RV64 */
> +	kernel_offset = 0x200000;
> +#else
> +	/* Linux expects to be booted at 4M boundary for RV32 */
> +	kernel_offset = 0x400000;
> +#endif
> +
> +	pos = kvm->ram_start + kernel_offset;
> +	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
> +	file_size = read_file(fd_kernel, pos, limit - pos);
> +	if (file_size < 0) {
> +		if (errno == ENOMEM)
> +			die("kernel image too big to fit in guest memory.");
> +
> +		die_perror("kernel read");
> +	}
> +	kernel_end = pos + file_size;
> +	pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
> +		 kvm->arch.kern_guest_start, file_size);
> +
> +	/* Place FDT just after kernel at FDT_ALIGN address */
> +	pos = kernel_end + FDT_ALIGN;
> +	guest_addr = ALIGN(host_to_guest_flat(kvm, pos), FDT_ALIGN);
> +	pos = guest_flat_to_host(kvm, guest_addr);
> +	if (pos < kernel_end)
> +		die("fdt overlaps with kernel image.");
> +
> +	kvm->arch.dtb_guest_start = guest_addr;
> +	pr_debug("Placing fdt at 0x%llx - 0x%llx",
> +		 kvm->arch.dtb_guest_start,
> +		 host_to_guest_flat(kvm, limit));
> +	limit = pos;

This doesn't look right. pos points to the start of the DTB, not to the top of
free memory. You probably want to delete the line.

> +
> +	/* ... and finally the initrd, if we have one. */
> +	if (fd_initrd != -1) {
> +		struct stat sb;
> +		unsigned long initrd_start;
> +
> +		if (fstat(fd_initrd, &sb))
> +			die_perror("fstat");
> +
> +		pos -= (sb.st_size + INITRD_ALIGN);

This too doesn't look right. You're overwriting the DTB and most likely the kernel
with the initrd.

Thanks,
Alex
> +		guest_addr = ALIGN(host_to_guest_flat(kvm, pos), INITRD_ALIGN);
> +		pos = guest_flat_to_host(kvm, guest_addr);
> +		if (pos < kernel_end)
> +			die("initrd overlaps with kernel image.");
> +
> +		initrd_start = guest_addr;
> +		file_size = read_file(fd_initrd, pos, limit - pos);
> +		if (file_size == -1) {
> +			if (errno == ENOMEM)
> +				die("initrd too big to fit in guest memory.");
> +
> +			die_perror("initrd read");
> +		}
> +
> +		kvm->arch.initrd_guest_start = initrd_start;
> +		kvm->arch.initrd_size = file_size;
> +		pr_debug("Loaded initrd to 0x%llx (%llu bytes)",
> +			 kvm->arch.initrd_guest_start,
> +			 kvm->arch.initrd_size);
> +	} else {
> +		kvm->arch.initrd_size = 0;
> +	}
> +
>  	return true;
>  }
>  
