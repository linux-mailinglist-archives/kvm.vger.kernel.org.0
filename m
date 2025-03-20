Return-Path: <kvm+bounces-41583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE00A6AB97
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:59:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D89917E557
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52E2822371B;
	Thu, 20 Mar 2025 16:59:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DF2222259C
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742489965; cv=none; b=j/MRRSZSe9LVw2Kxc3iRNKvKasrYP57WboqnRHh+NauNLZdwW6CZaFyrWGWJs3I5VhozpTP//FH1RoiBvxaWFVpQw+OZBeBT9a6C+hTF7TvOFuIXuOR1wXRpmMgy4Nltk0yghXGJHO1YYx46oQzYzLkPUaHk0eN4hGRdFu6j3iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742489965; c=relaxed/simple;
	bh=Rg+R789JNp8vEyk5G/mlh7kJ7G+xEmfCdqGB3O93DY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uihSnyfVaYSCtcaJLUMbkuzUBBskpg3pyN0VMzCE8Yk5PrG3JEIaNBx4nezFGK+EdzUCRyzc7gWWj5VV2ocPkKxgQYgNL1DlT9wX8mg2cBTWqYD8Yo6LOUWSfkgjBi1NKvaNQIrbAwDBwUap1wUaX9QmvM8u7IfD2SPvngvPwT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 208FD113E;
	Thu, 20 Mar 2025 09:59:31 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74CA43F673;
	Thu, 20 Mar 2025 09:59:22 -0700 (PDT)
Date: Thu, 20 Mar 2025 16:59:19 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, kvm@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: Re: [RFC kvmtool 3/9] arm64: Combine kvm.c
Message-ID: <Z9xJZ05PpGECmmiw@raptor>
References: <20250314222516.1302429-1-oliver.upton@linux.dev>
 <20250314222516.1302429-4-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250314222516.1302429-4-oliver.upton@linux.dev>

Hi Oliver,

On Fri, Mar 14, 2025 at 03:25:10PM -0700, Oliver Upton wrote:
> Glue together the ARM common and previously arm64-specific bits into one
> source file.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  Makefile                                   |   1 -
>  arm/aarch64/include/kvm/kvm-arch.h         |  22 ---
>  arm/aarch64/kvm.c                          | 212 ---------------------
>  arm/include/{arm-common => kvm}/kvm-arch.h |   4 +
>  arm/kvm.c                                  | 210 ++++++++++++++++++++
>  5 files changed, 214 insertions(+), 235 deletions(-)
>  delete mode 100644 arm/aarch64/include/kvm/kvm-arch.h
>  delete mode 100644 arm/aarch64/kvm.c
>  rename arm/include/{arm-common => kvm}/kvm-arch.h (97%)
> 
> diff --git a/Makefile b/Makefile
> index cf50cf7..72027e0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -180,7 +180,6 @@ ifeq ($(ARCH), arm64)
>  	OBJS		+= hw/serial.o
>  	OBJS		+= arm/arm-cpu.o
>  	OBJS		+= arm/aarch64/kvm-cpu.o
> -	OBJS		+= arm/aarch64/kvm.o
>  	OBJS		+= arm/pvtime.o
>  	OBJS		+= arm/pmu.o
>  	ARCH_INCLUDE	:= arm/include
> diff --git a/arm/aarch64/include/kvm/kvm-arch.h b/arm/aarch64/include/kvm/kvm-arch.h
> deleted file mode 100644
> index 2d1a4ed..0000000
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> deleted file mode 100644
> index 98b2437..0000000
> diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/kvm/kvm-arch.h
> similarity index 97%
> rename from arm/include/arm-common/kvm-arch.h
> rename to arm/include/kvm/kvm-arch.h
> index 60eec02..b55b3bf 100644
> --- a/arm/include/arm-common/kvm-arch.h
> +++ b/arm/include/kvm/kvm-arch.h
> @@ -84,6 +84,10 @@
>  
>  #define ARCH_HAS_PCI_EXP	1
>  
> +#define MAX_PAGE_SIZE	SZ_64K
> +
> +#define ARCH_HAS_CFG_RAM_ADDRESS	1

Would you mind grouping ARCH_HAS_* defines together?

> +
>  static inline bool arm_addr_in_ioport_region(u64 phys_addr)
>  {
>  	u64 limit = KVM_IOPORT_AREA + ARM_IOPORT_SIZE;
> diff --git a/arm/kvm.c b/arm/kvm.c
> index cc0cc4f..5e7fe77 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -7,10 +7,19 @@
>  
>  #include "arm-common/gic.h"
>  
> +#include <linux/byteorder.h>
> +#include <linux/cpumask.h>
>  #include <linux/kernel.h>
>  #include <linux/kvm.h>
>  #include <linux/sizes.h>
>  
> +#include <asm/image.h>
> +
> +#include <kvm/util.h>

kvm/util.h is already included at the top of the file. Otherwise looks good
to me.

Thanks,
Alex

> +
> +
> +static struct arm64_image_header *kernel_header;
> +
>  struct kvm_ext kvm_req_ext[] = {
>  	{ DEFINE_KVM_EXT(KVM_CAP_IRQCHIP) },
>  	{ DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
> @@ -87,6 +96,33 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
>  {
>  }
>  
> +static void kvm__arch_enable_mte(struct kvm *kvm)
> +{
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_ARM_MTE,
> +	};
> +
> +	if (kvm->cfg.arch.aarch32_guest) {
> +		pr_debug("MTE is incompatible with AArch32");
> +		return;
> +	}
> +
> +	if (kvm->cfg.arch.mte_disabled) {
> +		pr_debug("MTE disabled by user");
> +		return;
> +	}
> +
> +	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_MTE)) {
> +		pr_debug("MTE capability not available");
> +		return;
> +	}
> +
> +	if (ioctl(kvm->vm_fd, KVM_ENABLE_CAP, &cap))
> +		die_perror("KVM_ENABLE_CAP(KVM_CAP_ARM_MTE)");
> +
> +	pr_debug("MTE capability enabled");
> +}
> +
>  void kvm__arch_init(struct kvm *kvm)
>  {
>  	/* Create the virtual GIC. */
> @@ -96,6 +132,90 @@ void kvm__arch_init(struct kvm *kvm)
>  	kvm__arch_enable_mte(kvm);
>  }
>  
> +static u64 kvm__arch_get_payload_region_size(struct kvm *kvm)
> +{
> +	if (kvm->cfg.arch.aarch32_guest)
> +		return SZ_256M;
> +
> +	return SZ_512M;
> +}
> +
> +/*
> + * Return the TEXT_OFFSET value that the guest kernel expects. Note
> + * that pre-3.17 kernels expose this value using the native endianness
> + * instead of Little-Endian. BE kernels of this vintage may fail to
> + * boot. See Documentation/arm64/booting.rst in your local kernel tree.
> + */
> +static u64 kvm__arch_get_kern_offset(struct kvm *kvm)
> +{
> +	const char *debug_str;
> +
> +	/* the 32bit kernel offset is a well known value */
> +	if (kvm->cfg.arch.aarch32_guest)
> +		return 0x8000;
> +
> +	if (!kernel_header) {
> +		debug_str = "Kernel header is missing";
> +		goto default_offset;
> +	}
> +
> +	if (!le64_to_cpu(kernel_header->image_size)) {
> +		debug_str = "Image size is 0";
> +		goto default_offset;
> +	}
> +
> +	return le64_to_cpu(kernel_header->text_offset);
> +
> +default_offset:
> +	pr_debug("%s, assuming TEXT_OFFSET to be 0x80000", debug_str);
> +	return 0x80000;
> +}
> +
> +static void kvm__arch_read_kernel_header(struct kvm *kvm, int fd)
> +{
> +	const char *debug_str;
> +	off_t cur_offset;
> +	ssize_t size;
> +
> +	if (kvm->cfg.arch.aarch32_guest)
> +		return;
> +
> +	kernel_header = malloc(sizeof(*kernel_header));
> +	if (!kernel_header)
> +		return;
> +
> +	cur_offset = lseek(fd, 0, SEEK_CUR);
> +	if (cur_offset == (off_t)-1 || lseek(fd, 0, SEEK_SET) == (off_t)-1) {
> +		debug_str = "Failed to seek in kernel image file";
> +		goto fail;
> +	}
> +
> +	size = xread(fd, kernel_header, sizeof(*kernel_header));
> +	if (size < 0 || (size_t)size < sizeof(*kernel_header))
> +		die("Failed to read kernel image header");
> +
> +	lseek(fd, cur_offset, SEEK_SET);
> +
> +	if (memcmp(&kernel_header->magic, ARM64_IMAGE_MAGIC, sizeof(kernel_header->magic))) {
> +		debug_str = "Kernel image magic not matching";
> +		kernel_header = NULL;
> +		goto fail;
> +	}
> +
> +	return;
> +
> +fail:
> +	pr_debug("%s, using defaults", debug_str);
> +}
> +
> +static u64 kvm__arch_get_kernel_size(struct kvm *kvm)
> +{
> +	if (kvm->cfg.arch.aarch32_guest || !kernel_header)
> +		return 0;
> +
> +	return le64_to_cpu(kernel_header->image_size);
> +}
> +
>  #define FDT_ALIGN	SZ_2M
>  #define INITRD_ALIGN	4
>  bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
> @@ -264,3 +384,93 @@ int kvm__arch_setup_firmware(struct kvm *kvm)
>  {
>  	return 0;
>  }
> +
> +int vcpu_affinity_parser(const struct option *opt, const char *arg, int unset)
> +{
> +	struct kvm *kvm = opt->ptr;
> +	const char *cpulist = arg;
> +	cpumask_t *cpumask;
> +	int cpu, ret;
> +
> +	kvm->cfg.arch.vcpu_affinity = cpulist;
> +
> +	cpumask = calloc(1, cpumask_size());
> +	if (!cpumask)
> +		die_perror("calloc");
> +
> +	ret = cpulist_parse(cpulist, cpumask);
> +	if (ret) {
> +		free(cpumask);
> +		return ret;
> +	}
> +
> +	kvm->arch.vcpu_affinity_cpuset = CPU_ALLOC(NR_CPUS);
> +	if (!kvm->arch.vcpu_affinity_cpuset)
> +		die_perror("CPU_ALLOC");
> +	CPU_ZERO_S(CPU_ALLOC_SIZE(NR_CPUS), kvm->arch.vcpu_affinity_cpuset);
> +
> +	for_each_cpu(cpu, cpumask)
> +		CPU_SET(cpu, kvm->arch.vcpu_affinity_cpuset);
> +
> +	return 0;
> +}
> +
> +void kvm__arch_validate_cfg(struct kvm *kvm)
> +{
> +
> +	if (kvm->cfg.ram_addr < ARM_MEMORY_AREA) {
> +		die("RAM address is below the I/O region ending at %luGB",
> +		    ARM_MEMORY_AREA >> 30);
> +	}
> +
> +	if (kvm->cfg.arch.aarch32_guest &&
> +	    kvm->cfg.ram_addr + kvm->cfg.ram_size > SZ_4G) {
> +		die("RAM extends above 4GB");
> +	}
> +}
> +
> +u64 kvm__arch_default_ram_address(void)
> +{
> +	return ARM_MEMORY_AREA;
> +}
> +
> +static int kvm__arch_get_ipa_limit(struct kvm *kvm)
> +{
> +	int ret;
> +
> +	ret = ioctl(kvm->sys_fd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE);
> +	if (ret <= 0)
> +		ret = 0;
> +
> +	return ret;
> +}
> +
> +int kvm__get_vm_type(struct kvm *kvm)
> +{
> +	unsigned int ipa_bits, max_ipa_bits;
> +	unsigned long max_ipa;
> +
> +	/* If we're running on an old kernel, use 0 as the VM type */
> +	max_ipa_bits = kvm__arch_get_ipa_limit(kvm);
> +	if (!max_ipa_bits)
> +		return 0;
> +
> +	/* Otherwise, compute the minimal required IPA size */
> +	max_ipa = kvm->cfg.ram_addr + kvm->cfg.ram_size - 1;
> +	ipa_bits = max(32, fls_long(max_ipa));
> +	pr_debug("max_ipa %lx ipa_bits %d max_ipa_bits %d",
> +		 max_ipa, ipa_bits, max_ipa_bits);
> +
> +	if (ipa_bits > max_ipa_bits)
> +		die("Memory too large for this system (needs %d bits, %d available)", ipa_bits, max_ipa_bits);
> +
> +	return KVM_VM_TYPE_ARM_IPA_SIZE(ipa_bits);
> +}
> +
> +static int kvm__arch_free_kernel_header(struct kvm *kvm)
> +{
> +	free(kernel_header);
> +
> +	return 0;
> +}
> +late_exit(kvm__arch_free_kernel_header);
> -- 
> 2.39.5
> 
> 

