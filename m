Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A59017AA5DD
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 02:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjIVAA4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 20:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjIVAAz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 20:00:55 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298B1F9;
        Thu, 21 Sep 2023 17:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1695340847;
        bh=R/VgVhr9X0HDtbhByU19PzH3x9CzJFuyVh93BLbm8XY=;
        h=From:To:Subject:In-Reply-To:References:Date:From;
        b=EUj1hKtv69g+9+nHaOHHtRLCs4SHBdba41Ptbk8nE0yB2aVWS47UCVmbCiEPRl3OS
         OOOmwbvjXOGRW4+l+Fl5Db4/dr1OmHm7MrwulVHxJbKTdyEHQ3NTGcdOMdEgeyjp8x
         Bnhvsybnbj7XLRupXWsVSvlbZl5l0MkRPAmNgCHLopPgDW88Klsc03QWfixcsMp1ds
         +aTlrZPTdD+D3j3dxUqa8Amstg4Jm6Ls7tDlHjwAmIJRs0+hlsAiHuqOW6oF7u3daV
         6pJaAyNaWqCjBOraN+K5IIYx7vpYRHJKUfWFE2ALkjnpNdro2udTrbfcUvW8kYfIQr
         Wz7OBF1jOw3AQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RsC8Y0yCxz4x2b;
        Fri, 22 Sep 2023 10:00:45 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        James Morse <james.morse@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Marc Zyngier <maz@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, x86@kernel.org,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c unless VFIO
 is selected
In-Reply-To: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
Date:   Fri, 22 Sep 2023 10:00:44 +1000
Message-ID: <87leczm5zn.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jason Gunthorpe <jgg@nvidia.com> writes:
> There are a bunch of reported randconfig failures now because of this,
> something like:
>
>>> arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7: warning: attribute declaration must precede definition [-Wignored-attributes]
>            fn = symbol_get(vfio_file_iommu_group);
>                 ^
>    include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
>    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
>
> It happens because the arch forces KVM_VFIO without knowing if VFIO is
> even enabled.
>
> Split the kconfig so the arch selects the usual HAVE_KVM_ARCH_VFIO and
> then KVM_VFIO is only enabled if the arch wants it and VFIO is turned on.
>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308251949.5IiaV0sz-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202309030741.82aLACDG-lkp@intel.com/
> Closes: https://lore.kernel.org/oe-kbuild-all/202309110914.QLH0LU6L-lkp@intel.com/
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Fixes: c1cce6d079b8 ("vfio: Compile vfio_group infrastructure optionally")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  arch/arm64/kvm/Kconfig   | 2 +-
>  arch/powerpc/kvm/Kconfig | 2 +-
>  arch/s390/kvm/Kconfig    | 2 +-
>  arch/x86/kvm/Kconfig     | 2 +-
>  virt/kvm/Kconfig         | 7 ++++++-
>  5 files changed, 10 insertions(+), 5 deletions(-)
>
> Sean's large series will also address this:
>
> https://lore.kernel.org/kvm/20230916003118.2540661-7-seanjc@google.com/
>
> I don't know if it is sever enough to fix in the rc cycle, but here is the
> patch.

Thanks for debugging this, I had seen it but hadn't got around to it.

I think it's definitely worth fixing now. It's a pretty simple patch and
it's still early in the rc cycle.

Tested-by: Michael Ellerman <mpe@ellerman.id.au>

cheers

> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 83c1e09be42e5b..7c43eaea51ce05 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -28,7 +28,7 @@ menuconfig KVM
>  	select KVM_MMIO
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  	select KVM_XFER_TO_GUEST_WORK
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_IRQFD
>  	select HAVE_KVM_DIRTY_RING_ACQ_REL
> diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
> index 902611954200df..b64824e4cbc1eb 100644
> --- a/arch/powerpc/kvm/Kconfig
> +++ b/arch/powerpc/kvm/Kconfig
> @@ -22,7 +22,7 @@ config KVM
>  	select PREEMPT_NOTIFIERS
>  	select HAVE_KVM_EVENTFD
>  	select HAVE_KVM_VCPU_ASYNC_IOCTL
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select IRQ_BYPASS_MANAGER
>  	select HAVE_KVM_IRQ_BYPASS
>  	select INTERVAL_TREE
> diff --git a/arch/s390/kvm/Kconfig b/arch/s390/kvm/Kconfig
> index 45fdf2a9b2e326..d206ad3a777d5d 100644
> --- a/arch/s390/kvm/Kconfig
> +++ b/arch/s390/kvm/Kconfig
> @@ -31,7 +31,7 @@ config KVM
>  	select HAVE_KVM_IRQ_ROUTING
>  	select HAVE_KVM_INVALID_WAKEUPS
>  	select HAVE_KVM_NO_POLL
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select INTERVAL_TREE
>  	select MMU_NOTIFIER
>  	help
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index ed90f148140dfe..8e70e693f90e30 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -45,7 +45,7 @@ config KVM
>  	select HAVE_KVM_NO_POLL
>  	select KVM_XFER_TO_GUEST_WORK
>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -	select KVM_VFIO
> +	select HAVE_KVM_ARCH_VFIO
>  	select INTERVAL_TREE
>  	select HAVE_KVM_PM_NOTIFIER if PM
>  	select KVM_GENERIC_HARDWARE_ENABLING
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index 484d0873061ca5..0bf34809e1bbfe 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -59,9 +59,14 @@ config HAVE_KVM_MSI
>  config HAVE_KVM_CPU_RELAX_INTERCEPT
>         bool
>  
> -config KVM_VFIO
> +config HAVE_KVM_ARCH_VFIO
>         bool
>  
> +config KVM_VFIO
> +       def_bool y
> +       depends on HAVE_KVM_ARCH_VFIO
> +       depends on VFIO
> +
>  config HAVE_KVM_INVALID_WAKEUPS
>         bool
>  
>
> base-commit: 0bb80ecc33a8fb5a682236443c1e740d5c917d1d
> -- 
> 2.42.0
