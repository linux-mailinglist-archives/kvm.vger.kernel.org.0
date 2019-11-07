Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C42F3059
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 14:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388641AbfKGNqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Nov 2019 08:46:43 -0500
Received: from foss.arm.com ([217.140.110.172]:56468 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbfKGNqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Nov 2019 08:46:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4921531B;
        Thu,  7 Nov 2019 05:46:42 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 339223F71A;
        Thu,  7 Nov 2019 05:46:41 -0800 (PST)
Date:   Thu, 7 Nov 2019 13:46:38 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Julien Grall <julien.grall.oss@gmail.com>
Subject: Re: [PATCH kvmtool 08/16] arm: Move anything related to RAM
 initialization in kvm__init_ram
Message-ID: <20191107134638.147f9712@donnerap.cambridge.arm.com>
In-Reply-To: <1569245722-23375-9-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
        <1569245722-23375-9-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Sep 2019 14:35:14 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

> From: Julien Grall <julien.grall@arm.com>
> 
> RAM initialization is currently split between kvm__init_ram and
> kvm__arch_init.  Move all code related to RAM initialization to
> kvm__init_ram.

The diff is a bit confusing to read, but indeed this just moves the code from arch_init() to init_ram() (confirmed by moving the code and comparing).
One thing to note is that this changes the order of initialisation slightly: the GIC is now created before the RAM (since we call arch_init() before init_ram()).

Nevertheless:

> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

> ---
>  arm/kvm.c | 75 +++++++++++++++++++++++++++++++--------------------------------
>  1 file changed, 37 insertions(+), 38 deletions(-)
> 
> diff --git a/arm/kvm.c b/arm/kvm.c
> index 5decc138fd3e..3e49db7704aa 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -29,44 +29,6 @@ void kvm__init_ram(struct kvm *kvm)
>  	int err;
>  	u64 phys_start, phys_size;
>  	void *host_mem;
> -
> -	phys_start	= ARM_MEMORY_AREA;
> -	phys_size	= kvm->ram_size;
> -	host_mem	= kvm->ram_start;
> -
> -	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> -	if (err)
> -		die("Failed to register %lld bytes of memory at physical "
> -		    "address 0x%llx [err %d]", phys_size, phys_start, err);
> -
> -	kvm->arch.memory_guest_start = phys_start;
> -}
> -
> -void kvm__arch_delete_ram(struct kvm *kvm)
> -{
> -	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
> -}
> -
> -void kvm__arch_read_term(struct kvm *kvm)
> -{
> -	serial8250__update_consoles(kvm);
> -	virtio_console__inject_interrupt(kvm);
> -}
> -
> -void kvm__arch_set_cmdline(char *cmdline, bool video)
> -{
> -}
> -
> -void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
> -{
> -	if (cfg->ram_size > ARM_MAX_MEMORY(cfg)) {
> -		cfg->ram_size = ARM_MAX_MEMORY(cfg);
> -		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
> -	}
> -}
> -
> -void kvm__arch_init(struct kvm *kvm)
> -{
>  	unsigned long alignment;
>  	/* Convenience aliases */
>  	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
> @@ -115,6 +77,43 @@ void kvm__arch_init(struct kvm *kvm)
>  	madvise(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size,
>  		MADV_HUGEPAGE);
>  
> +	phys_start	= ARM_MEMORY_AREA;
> +	phys_size	= kvm->ram_size;
> +	host_mem	= kvm->ram_start;
> +
> +	err = kvm__register_ram(kvm, phys_start, phys_size, host_mem);
> +	if (err)
> +		die("Failed to register %lld bytes of memory at physical "
> +		    "address 0x%llx [err %d]", phys_size, phys_start, err);
> +
> +	kvm->arch.memory_guest_start = phys_start;
> +}
> +
> +void kvm__arch_delete_ram(struct kvm *kvm)
> +{
> +	munmap(kvm->arch.ram_alloc_start, kvm->arch.ram_alloc_size);
> +}
> +
> +void kvm__arch_read_term(struct kvm *kvm)
> +{
> +	serial8250__update_consoles(kvm);
> +	virtio_console__inject_interrupt(kvm);
> +}
> +
> +void kvm__arch_set_cmdline(char *cmdline, bool video)
> +{
> +}
> +
> +void kvm__arch_sanitize_cfg(struct kvm_config *cfg)
> +{
> +	if (cfg->ram_size > ARM_MAX_MEMORY(cfg)) {
> +		cfg->ram_size = ARM_MAX_MEMORY(cfg);
> +		pr_warning("Capping memory to %lluMB", cfg->ram_size >> 20);
> +	}
> +}
> +
> +void kvm__arch_init(struct kvm *kvm)
> +{
>  	/* Create the virtual GIC. */
>  	if (gic__create(kvm, kvm->cfg.arch.irqchip))
>  		die("Failed to create virtual GIC");

