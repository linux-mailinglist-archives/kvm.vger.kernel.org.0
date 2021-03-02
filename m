Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF0D32B572
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356176AbhCCHQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:16:56 -0500
Received: from foss.arm.com ([217.140.110.172]:56736 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1580426AbhCBSDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 13:03:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 10CF7D6E;
        Tue,  2 Mar 2021 10:02:32 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15CAE3F766;
        Tue,  2 Mar 2021 10:02:30 -0800 (PST)
Subject: Re: [PATCH kvmtool v2 01/22] ioport: Remove ioport__setup_arch()
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Marc Zyngier <maz@kernel.org>,
        Sami Mujawar <sami.mujawar@arm.com>
References: <20210225005915.26423-1-andre.przywara@arm.com>
 <20210225005915.26423-2-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e4dc0a95-f0ee-7f98-1e96-12f30dc447bd@arm.com>
Date:   Tue, 2 Mar 2021 18:02:49 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225005915.26423-2-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 2/25/21 12:58 AM, Andre Przywara wrote:
> Since x86 had a special need for registering tons of special I/O ports,
> we had an ioport__setup_arch() callback, to allow each architecture
> to do the same. As it turns out no one uses it beside x86, so we remove
> that unnecessary abstraction.
>
> The generic function was registered via a device_base_init() call, so
> we just do the same for the x86 specific function only, and can remove
> the unneeded ioport__setup_arch().

Looks good, I did a compile test for arm64 and x86, and I grepped the kvmtool
directory for ioport__setup_arch. x86 is the only user left:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/ioport.c         | 5 -----
>  include/kvm/ioport.h | 1 -
>  ioport.c             | 6 ------
>  mips/kvm.c           | 5 -----
>  powerpc/ioport.c     | 6 ------
>  x86/ioport.c         | 3 ++-
>  6 files changed, 2 insertions(+), 24 deletions(-)
>
> diff --git a/arm/ioport.c b/arm/ioport.c
> index 2f0feb9a..24092c9d 100644
> --- a/arm/ioport.c
> +++ b/arm/ioport.c
> @@ -1,11 +1,6 @@
>  #include "kvm/ioport.h"
>  #include "kvm/irq.h"
>  
> -int ioport__setup_arch(struct kvm *kvm)
> -{
> -	return 0;
> -}
> -
>  void ioport__map_irq(u8 *irq)
>  {
>  	*irq = irq__alloc_line();
> diff --git a/include/kvm/ioport.h b/include/kvm/ioport.h
> index 039633f7..d0213541 100644
> --- a/include/kvm/ioport.h
> +++ b/include/kvm/ioport.h
> @@ -35,7 +35,6 @@ struct ioport_operations {
>  							    enum irq_type));
>  };
>  
> -int ioport__setup_arch(struct kvm *kvm);
>  void ioport__map_irq(u8 *irq);
>  
>  int __must_check ioport__register(struct kvm *kvm, u16 port, struct ioport_operations *ops,
> diff --git a/ioport.c b/ioport.c
> index 844a832d..a6972179 100644
> --- a/ioport.c
> +++ b/ioport.c
> @@ -221,12 +221,6 @@ out:
>  	return !kvm->cfg.ioport_debug;
>  }
>  
> -int ioport__init(struct kvm *kvm)
> -{
> -	return ioport__setup_arch(kvm);
> -}
> -dev_base_init(ioport__init);
> -
>  int ioport__exit(struct kvm *kvm)
>  {
>  	ioport__unregister_all();
> diff --git a/mips/kvm.c b/mips/kvm.c
> index 26355930..e110e5d5 100644
> --- a/mips/kvm.c
> +++ b/mips/kvm.c
> @@ -100,11 +100,6 @@ void kvm__irq_trigger(struct kvm *kvm, int irq)
>  		die_perror("KVM_IRQ_LINE ioctl");
>  }
>  
> -int ioport__setup_arch(struct kvm *kvm)
> -{
> -	return 0;
> -}
> -
>  bool kvm__arch_cpu_supports_vm(void)
>  {
>  	return true;
> diff --git a/powerpc/ioport.c b/powerpc/ioport.c
> index 0c188b61..a5cff4ee 100644
> --- a/powerpc/ioport.c
> +++ b/powerpc/ioport.c
> @@ -12,12 +12,6 @@
>  
>  #include <stdlib.h>
>  
> -int ioport__setup_arch(struct kvm *kvm)
> -{
> -	/* PPC has no legacy ioports to set up */
> -	return 0;
> -}
> -
>  void ioport__map_irq(u8 *irq)
>  {
>  }
> diff --git a/x86/ioport.c b/x86/ioport.c
> index 7ad7b8f3..a8d2bb1a 100644
> --- a/x86/ioport.c
> +++ b/x86/ioport.c
> @@ -69,7 +69,7 @@ void ioport__map_irq(u8 *irq)
>  {
>  }
>  
> -int ioport__setup_arch(struct kvm *kvm)
> +static int ioport__setup_arch(struct kvm *kvm)
>  {
>  	int r;
>  
> @@ -150,3 +150,4 @@ int ioport__setup_arch(struct kvm *kvm)
>  
>  	return 0;
>  }
> +dev_base_init(ioport__setup_arch);
