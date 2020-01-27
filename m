Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6701314A970
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 19:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgA0SH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 13:07:57 -0500
Received: from foss.arm.com ([217.140.110.172]:47812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgA0SH4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 13:07:56 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32C9130E;
        Mon, 27 Jan 2020 10:07:56 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3190A3F67D;
        Mon, 27 Jan 2020 10:07:55 -0800 (PST)
Date:   Mon, 27 Jan 2020 18:07:52 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, will@kernel.org,
        julien.thierry.kdev@gmail.com, sami.mujawar@arm.com,
        lorenzo.pieralisi@arm.com, maz@kernel.org
Subject: Re: [PATCH v2 kvmtool 05/30] Check that a PCI device's memory size
 is power of two
Message-ID: <20200127180752.035856cb@donnerap.cambridge.arm.com>
In-Reply-To: <20200123134805.1993-6-alexandru.elisei@arm.com>
References: <20200123134805.1993-1-alexandru.elisei@arm.com>
        <20200123134805.1993-6-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 23 Jan 2020 13:47:40 +0000
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> According to the PCI local bus specification [1], a device's memory size
> must be a power of two. This is also implicit in the mechanism that a CPU
> uses to get the memory size requirement for a PCI device.
> 
> The vesa device requests a memory size that isn't a power of two.
> According to the same spec [1], a device is allowed to consume more memory
> than it actually requires. As a result, the amount of memory that the vesa
> device now reserves has been increased.
> 
> To prevent slip-ups in the future, a few BUILD_BUG_ON statements were added
> in places where the memory size is known at compile time.
> 
> [1] PCI Local Bus Specification Revision 3.0, section 6.2.5.1
> 
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre

> ---
>  hw/vesa.c          | 3 +++
>  include/kvm/util.h | 2 ++
>  include/kvm/vesa.h | 6 +++++-
>  virtio/pci.c       | 3 +++
>  4 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/vesa.c b/hw/vesa.c
> index f3c5114cf4fe..d75b4b316a1e 100644
> --- a/hw/vesa.c
> +++ b/hw/vesa.c
> @@ -58,6 +58,9 @@ struct framebuffer *vesa__init(struct kvm *kvm)
>  	char *mem;
>  	int r;
>  
> +	BUILD_BUG_ON(!is_power_of_two(VESA_MEM_SIZE));
> +	BUILD_BUG_ON(VESA_MEM_SIZE < VESA_BPP/8 * VESA_WIDTH * VESA_HEIGHT);
> +
>  	if (!kvm->cfg.vnc && !kvm->cfg.sdl && !kvm->cfg.gtk)
>  		return NULL;
>  
> diff --git a/include/kvm/util.h b/include/kvm/util.h
> index 4ca7aa9392b6..199724c4018c 100644
> --- a/include/kvm/util.h
> +++ b/include/kvm/util.h
> @@ -104,6 +104,8 @@ static inline unsigned long roundup_pow_of_two(unsigned long x)
>  	return x ? 1UL << fls_long(x - 1) : 0;
>  }
>  
> +#define is_power_of_two(x)	((x) > 0 ? ((x) & ((x) - 1)) == 0 : 0)
> +
>  struct kvm;
>  void *mmap_hugetlbfs(struct kvm *kvm, const char *htlbfs_path, u64 size);
>  void *mmap_anon_or_hugetlbfs(struct kvm *kvm, const char *hugetlbfs_path, u64 size);
> diff --git a/include/kvm/vesa.h b/include/kvm/vesa.h
> index 0fac11ab5a9f..e7d971343642 100644
> --- a/include/kvm/vesa.h
> +++ b/include/kvm/vesa.h
> @@ -5,8 +5,12 @@
>  #define VESA_HEIGHT	480
>  
>  #define VESA_MEM_ADDR	0xd0000000
> -#define VESA_MEM_SIZE	(4*VESA_WIDTH*VESA_HEIGHT)
>  #define VESA_BPP	32
> +/*
> + * We actually only need VESA_BPP/8*VESA_WIDTH*VESA_HEIGHT bytes. But the memory
> + * size must be a power of 2, so we round up.
> + */
> +#define VESA_MEM_SIZE	(1 << 21)
>  
>  struct kvm;
>  struct biosregs;
> diff --git a/virtio/pci.c b/virtio/pci.c
> index 99653cad2c0f..04e801827df9 100644
> --- a/virtio/pci.c
> +++ b/virtio/pci.c
> @@ -435,6 +435,9 @@ int virtio_pci__init(struct kvm *kvm, void *dev, struct virtio_device *vdev,
>  	vpci->kvm = kvm;
>  	vpci->dev = dev;
>  
> +	BUILD_BUG_ON(!is_power_of_two(IOPORT_SIZE));
> +	BUILD_BUG_ON(!is_power_of_two(PCI_IO_SIZE));
> +
>  	r = ioport__register(kvm, IOPORT_EMPTY, &virtio_pci__io_ops, IOPORT_SIZE, vdev);
>  	if (r < 0)
>  		return r;

