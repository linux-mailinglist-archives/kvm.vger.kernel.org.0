Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10ABF1B93
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 17:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732269AbfKFQrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 11:47:33 -0500
Received: from foss.arm.com ([217.140.110.172]:43014 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732243AbfKFQrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 11:47:33 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71ACF46A;
        Wed,  6 Nov 2019 08:47:32 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F0E13F719;
        Wed,  6 Nov 2019 08:47:31 -0800 (PST)
Date:   Wed, 6 Nov 2019 16:47:28 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Julien Grall <julien.grall.oss@gmail.com>
Subject: Re: [PATCH kvmtool 02/16] kvm__arch_init: Don't pass hugetlbfs_path
 and ram_size in parameter
Message-ID: <20191106164728.7cba9e9e@donnerap.cambridge.arm.com>
In-Reply-To: <1569245722-23375-3-git-send-email-alexandru.elisei@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
        <1569245722-23375-3-git-send-email-alexandru.elisei@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 23 Sep 2019 14:35:08 +0100
Alexandru Elisei <alexandru.elisei@arm.com> wrote:

Hi,

> From: Julien Grall <julien.grall@arm.com>
> 
> The structure KVM already contains a pointer to the configuration. Both
> hugetlbfs_path and ram_size are part of the configuration, so is it not
> necessary to path them again in parameter.
> 
> Signed-off-by: Julien Grall <julien.grall@arm.com>
> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arm/kvm.c         | 5 ++++-
>  include/kvm/kvm.h | 2 +-
>  kvm.c             | 2 +-
>  mips/kvm.c        | 5 ++++-
>  powerpc/kvm.c     | 5 ++++-
>  x86/kvm.c         | 5 ++++-
>  6 files changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/arm/kvm.c b/arm/kvm.c
> index 1c5bdb8026bf..198cee5c0997 100644
> --- a/arm/kvm.c
> +++ b/arm/kvm.c
> @@ -57,9 +57,12 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
>  {
>  }
>  
> -void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
> +void kvm__arch_init(struct kvm *kvm)
>  {
>  	unsigned long alignment;
> +	/* Convenience aliases */
> +	u64 ram_size = kvm->cfg.ram_size;
> +	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;

Do we really need these aliases?
Definitely we should lose the comment ...

>  	/*
>  	 * Allocate guest memory. If the user wants to use hugetlbfs, then the
> diff --git a/include/kvm/kvm.h b/include/kvm/kvm.h
> index 7a738183d67a..635ce0f40b1e 100644
> --- a/include/kvm/kvm.h
> +++ b/include/kvm/kvm.h
> @@ -140,7 +140,7 @@ int kvm__enumerate_instances(int (*callback)(const char *name, int pid));
>  void kvm__remove_socket(const char *name);
>  
>  void kvm__arch_set_cmdline(char *cmdline, bool video);
> -void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size);
> +void kvm__arch_init(struct kvm *kvm);
>  void kvm__arch_delete_ram(struct kvm *kvm);
>  int kvm__arch_setup_firmware(struct kvm *kvm);
>  int kvm__arch_free_firmware(struct kvm *kvm);
> diff --git a/kvm.c b/kvm.c
> index 57c4ff98ec4c..36b238791fc1 100644
> --- a/kvm.c
> +++ b/kvm.c
> @@ -392,7 +392,7 @@ int kvm__init(struct kvm *kvm)
>  		goto err_vm_fd;
>  	}
>  
> -	kvm__arch_init(kvm, kvm->cfg.hugetlbfs_path, kvm->cfg.ram_size);
> +	kvm__arch_init(kvm);
>  
>  	INIT_LIST_HEAD(&kvm->mem_banks);
>  	kvm__init_ram(kvm);
> diff --git a/mips/kvm.c b/mips/kvm.c
> index 211770da0d85..e2a0c63b14b8 100644
> --- a/mips/kvm.c
> +++ b/mips/kvm.c
> @@ -57,9 +57,12 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
>  }
>  
>  /* Architecture-specific KVM init */
> -void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
> +void kvm__arch_init(struct kvm *kvm)
>  {
>  	int ret;
> +	/* Convenience aliases */
> +	u64 ram_size = kvm->cfg.ram_size;
> +	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;

Same here, there is only one user of hugetlbfs_path.

>  	kvm->ram_start = mmap_anon_or_hugetlbfs(kvm, hugetlbfs_path, ram_size);
>  	kvm->ram_size = ram_size;
> diff --git a/powerpc/kvm.c b/powerpc/kvm.c
> index 702d67dca614..034bc4608ad9 100644
> --- a/powerpc/kvm.c
> +++ b/powerpc/kvm.c
> @@ -88,10 +88,13 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
>  }
>  
>  /* Architecture-specific KVM init */
> -void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
> +void kvm__arch_init(struct kvm *kvm)
>  {
>  	int cap_ppc_rma;
>  	unsigned long hpt;
> +	/* Convenience aliases */

Not needed and not even true for hugetlbfs_path.

> +	u64 ram_size = kvm->cfg.ram_size;

This is somewhat pointless, the only user is right below the next line ...

> +	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;

We need to keep that, though, as the code modifies it.

>  
>  	kvm->ram_size		= ram_size;
>  
> diff --git a/x86/kvm.c b/x86/kvm.c
> index 3e0f0b743f8c..5abb41e370bb 100644
> --- a/x86/kvm.c
> +++ b/x86/kvm.c
> @@ -130,10 +130,13 @@ void kvm__arch_set_cmdline(char *cmdline, bool video)
>  }
>  
>  /* Architecture-specific KVM init */
> -void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
> +void kvm__arch_init(struct kvm *kvm)
>  {
>  	struct kvm_pit_config pit_config = { .flags = 0, };
>  	int ret;
> +	/* Convenience aliases */

I don't think the comment is needed.

Otherwise it's a nice cleanup.

Cheers,
Andre

> +	u64 ram_size = kvm->cfg.ram_size;
> +	const char *hugetlbfs_path = kvm->cfg.hugetlbfs_path;
>  
>  	ret = ioctl(kvm->vm_fd, KVM_SET_TSS_ADDR, 0xfffbd000);
>  	if (ret < 0)

