Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF022D5B81
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 14:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388602AbgLJNVx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 08:21:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387816AbgLJNVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 08:21:39 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B9E023DE8;
        Thu, 10 Dec 2020 13:20:58 +0000 (UTC)
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1knLsO-0005VR-76; Thu, 10 Dec 2020 13:20:56 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Dec 2020 13:20:56 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: Re: [PATCH kvmtool] arm64: Determine kernel offset even on
 non-seekable file descriptors
In-Reply-To: <20201020123032.167234-1-andre.przywara@arm.com>
References: <20201020123032.167234-1-andre.przywara@arm.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <3d9099f63baed918b043c72909ee1e60@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: andre.przywara@arm.com, will@kernel.org, julien.thierry.kdev@gmail.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, alexandru.elisei@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-10-20 13:30, Andre Przywara wrote:
> Commit c9acdae1d2e7 ("arm64: Use default kernel offset when the image
> file can't be seeked") "guessed" the arm64 kernel offset to be the old
> default of 512K if the file descriptor for the kernel image could not
> be seeked. This mostly works today because most modern kernels are
> somewhat forgiving when loaded at the wrong offset, but emit a warning:
> 
> [Firmware Bug]: Kernel image misaligned at boot, please fix your 
> bootloader!
> 
> To fix this properly, let's drop the seek operation altogether, instead
> give the kernel header parsing function a memory buffer, containing the
> first 64 bytes of the kernel file. We read the rest of the file into 
> the
> right location after this function has decoded the proper kernel 
> offset.
> 
> This brings back proper loading even for kernels loaded via pipes.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/aarch64/include/kvm/kvm-arch.h |  3 ++-
>  arm/aarch64/kvm.c                  | 26 ++++++++------------------
>  arm/kvm.c                          | 13 ++++++++++---
>  3 files changed, 20 insertions(+), 22 deletions(-)
> 
> diff --git a/arm/aarch64/include/kvm/kvm-arch.h
> b/arm/aarch64/include/kvm/kvm-arch.h
> index 55ef8ed1..7e6cffb6 100644
> --- a/arm/aarch64/include/kvm/kvm-arch.h
> +++ b/arm/aarch64/include/kvm/kvm-arch.h
> @@ -2,7 +2,8 @@
>  #define KVM__KVM_ARCH_H
> 
>  struct kvm;
> -unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd);
> +unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, void 
> *header,
> +					     unsigned int bufsize);
> 
>  #define ARM_MAX_MEMORY(kvm)	((kvm)->cfg.arch.aarch32_guest	?	\
>  				ARM_LOMAP_MAX_MEMORY		:	\
> diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
> index 49e1dd31..9a6460ac 100644
> --- a/arm/aarch64/kvm.c
> +++ b/arm/aarch64/kvm.c
> @@ -10,39 +10,29 @@
>   * instead of Little-Endian. BE kernels of this vintage may fail to
>   * boot. See Documentation/arm64/booting.rst in your local kernel 
> tree.
>   */
> -unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm, int fd)
> +unsigned long long kvm__arch_get_kern_offset(struct kvm *kvm,
> +					     void *buffer, unsigned int bufsize)
>  {
> -	struct arm64_image_header header;
> -	off_t cur_offset;
> -	ssize_t size;
> +	struct arm64_image_header *header = buffer;
>  	const char *warn_str;
> 
>  	/* the 32bit kernel offset is a well known value */
>  	if (kvm->cfg.arch.aarch32_guest)
>  		return 0x8000;
> 
> -	cur_offset = lseek(fd, 0, SEEK_CUR);
> -	if (cur_offset == (off_t)-1 ||
> -	    lseek(fd, 0, SEEK_SET) == (off_t)-1) {
> -		warn_str = "Failed to seek in kernel image file";
> +	if (bufsize < sizeof(*header)) {
> +		warn_str = "Provided kernel header too small";
>  		goto fail;
>  	}
> 
> -	size = xread(fd, &header, sizeof(header));
> -	if (size < 0 || (size_t)size < sizeof(header))
> -		die("Failed to read kernel image header");
> -
> -	lseek(fd, cur_offset, SEEK_SET);
> -
> -	if (memcmp(&header.magic, ARM64_IMAGE_MAGIC, sizeof(header.magic)))
> +	if (memcmp(&header->magic, ARM64_IMAGE_MAGIC, sizeof(header->magic)))
>  		pr_warning("Kernel image magic not matching");
> 
> -	if (le64_to_cpu(header.image_size))
> -		return le64_to_cpu(header.text_offset);
> +	if (le64_to_cpu(header->image_size))
> +		return le64_to_cpu(header->text_offset);
> 
>  	warn_str = "Image size is 0";
>  fail:
>  	pr_warning("%s, assuming TEXT_OFFSET to be 0x80000", warn_str);
>  	return 0x80000;
>  }
> -
> diff --git a/arm/kvm.c b/arm/kvm.c
> index 5aea18fe..685fabb1 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -90,12 +90,14 @@ void kvm__arch_init(struct kvm *kvm, const char
> *hugetlbfs_path, u64 ram_size)
> 
>  #define FDT_ALIGN	SZ_2M
>  #define INITRD_ALIGN	4
> +#define MAX_KERNEL_HEADER_SIZE	64

Isn't that arm64 specific? AFAICR, 32bit doesn't need any of this.

>  bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int 
> fd_initrd,
>  				 const char *kernel_cmdline)
>  {
>  	void *pos, *kernel_end, *limit;
>  	unsigned long guest_addr;
>  	ssize_t file_size;
> +	char header[MAX_KERNEL_HEADER_SIZE];
> 
>  	/*
>  	 * Linux requires the initrd and dtb to be mapped inside lowmem,
> @@ -103,16 +105,21 @@ bool kvm__arch_load_kernel_image(struct kvm
> *kvm, int fd_kernel, int fd_initrd,
>  	 */
>  	limit = kvm->ram_start + min(kvm->ram_size, (u64)SZ_256M) - 1;
> 
> -	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, fd_kernel);
> +	if (xread(fd_kernel, header, sizeof(header)) != sizeof(header))
> +		die_perror("kernel header read");

Same thing: 32bit doesn't require any preliminary read.

> +	pos = kvm->ram_start + kvm__arch_get_kern_offset(kvm, header,
> +							 sizeof(header));
>  	kvm->arch.kern_guest_start = host_to_guest_flat(kvm, pos);
> -	file_size = read_file(fd_kernel, pos, limit - pos);
> +	memcpy(pos, header, sizeof(header));
> +	file_size = read_file(fd_kernel, pos + sizeof(header),
> +			      limit - pos - sizeof(header));
>  	if (file_size < 0) {
>  		if (errno == ENOMEM)
>  			die("kernel image too big to contain in guest memory.");
> 
>  		die_perror("kernel read");
>  	}
> -	kernel_end = pos + file_size;
> +	kernel_end = pos + file_size + sizeof(header);
>  	pr_debug("Loaded kernel to 0x%llx (%zd bytes)",
>  		 kvm->arch.kern_guest_start, file_size);

I'd prefer the whole thing to be kept in the arm64-specific code, TBH.
Or the 32bit support to be purged from kvmtool, which would simplify
tons of things.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
