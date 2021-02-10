Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6B5316D1D
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 18:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhBJRpr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 12:45:47 -0500
Received: from foss.arm.com ([217.140.110.172]:41708 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232270AbhBJRpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 12:45:30 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F97511D4;
        Wed, 10 Feb 2021 09:44:44 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 748FA3F73B;
        Wed, 10 Feb 2021 09:44:43 -0800 (PST)
Subject: Re: [PATCH kvmtool 01/21] ioport: Remove ioport__setup_arch()
To:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>
References: <20201210142908.169597-1-andre.przywara@arm.com>
 <20201210142908.169597-2-andre.przywara@arm.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <814e0cd9-5e54-fade-f05c-80ea2b4a9039@arm.com>
Date:   Wed, 10 Feb 2021 17:44:59 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201210142908.169597-2-andre.przywara@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 12/10/20 2:28 PM, Andre Przywara wrote:
> Since x86 had a special need for registering tons of special I/O ports,
> we had an ioport__setup_arch() callback, to allow each architecture
> to do the same. As it turns out no one uses it beside x86, so we remove
> that unnecessary abstraction.
>
> The generic function was registered via a device_base_init() call, so
> we just do the same for the x86 specific function only, and can remove
> the unneeded ioport__setup_arch().
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arm/ioport.c         |  5 -----
>  include/kvm/ioport.h |  1 -
>  ioport.c             | 28 ----------------------------
>  mips/kvm.c           |  5 -----
>  powerpc/ioport.c     |  6 ------
>  x86/ioport.c         | 25 ++++++++++++++++++++++++-
>  6 files changed, 24 insertions(+), 46 deletions(-)
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
> index 844a832d..667e8386 100644
> --- a/ioport.c
> +++ b/ioport.c
> @@ -158,21 +158,6 @@ int ioport__unregister(struct kvm *kvm, u16 port)
>  	return 0;
>  }
>  
> -static void ioport__unregister_all(void)
> -{
> -	struct ioport *entry;
> -	struct rb_node *rb;
> -	struct rb_int_node *rb_node;
> -
> -	rb = rb_first(&ioport_tree);
> -	while (rb) {
> -		rb_node = rb_int(rb);
> -		entry = ioport_node(rb_node);
> -		ioport_unregister(&ioport_tree, entry);
> -		rb = rb_first(&ioport_tree);
> -	}
> -}

I get the impression this is a rebasing artifact. The commit message doesn't
mention anything about removing ioport__exit() -> ioport__unregister_all(), and as
far as I can tell it's still needed because there are places other than
ioport__setup_arch() from where ioport__register() is called.

Thanks,

Alex

> -
>  static const char *to_direction(int direction)
>  {
>  	if (direction == KVM_EXIT_IO_IN)
> @@ -220,16 +205,3 @@ out:
>  
>  	return !kvm->cfg.ioport_debug;
>  }
> -
> -int ioport__init(struct kvm *kvm)
> -{
> -	return ioport__setup_arch(kvm);
> -}
> -dev_base_init(ioport__init);
> -
> -int ioport__exit(struct kvm *kvm)
> -{
> -	ioport__unregister_all();
> -	return 0;
> -}
> -dev_base_exit(ioport__exit);
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
> index 7ad7b8f3..8c5c7699 100644
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
> @@ -150,3 +150,26 @@ int ioport__setup_arch(struct kvm *kvm)
>  
>  	return 0;
>  }
> +dev_base_init(ioport__setup_arch);
> +
> +static int ioport__remove_arch(struct kvm *kvm)
> +{
> +	ioport__unregister(kvm, 0x510);
> +	ioport__unregister(kvm, 0x402);
> +	ioport__unregister(kvm, 0x03D5);
> +	ioport__unregister(kvm, 0x03D4);
> +	ioport__unregister(kvm, 0x0378);
> +	ioport__unregister(kvm, 0x0278);
> +	ioport__unregister(kvm, 0x00F0);
> +	ioport__unregister(kvm, 0x00ED);
> +	ioport__unregister(kvm, IOPORT_DBG);
> +	ioport__unregister(kvm, 0x00C0);
> +	ioport__unregister(kvm, 0x00A0);
> +	ioport__unregister(kvm, 0x0092);
> +	ioport__unregister(kvm, 0x0040);
> +	ioport__unregister(kvm, 0x0020);
> +	ioport__unregister(kvm, 0x0000);
> +
> +	return 0;
> +}
> +dev_base_exit(ioport__remove_arch);
