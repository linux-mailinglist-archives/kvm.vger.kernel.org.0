Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B39177B8C3
	for <lists+kvm@lfdr.de>; Mon, 14 Aug 2023 14:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjHNMhe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Aug 2023 08:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbjHNMhK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Aug 2023 08:37:10 -0400
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D41AE5B;
        Mon, 14 Aug 2023 05:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1692016627;
        bh=sJ1XfdJ8koVOpLPFh5lgGOWx8nQ+9eqY27+qcXXvzaM=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=AyQtOYZ0fJ2oyt3zcRf92PdYESgUvJqcbG7m4mh6cpaXYGCmf5P0Wli7vr8PB3Ybw
         5g8Uvmu+S0YIo2KQMSTHPdjnod3sCd3Lbs8Ao2exiIqAq7fcy3/nrvCr48CdTGqXRw
         qMbFT6gCgpljE4unS9Hsb4k1rhL76Qb/7Cuu3lbgE0Dz7LzfA8gWTDTXEHkolTVPSN
         4HX9tj+fsr50VXJ6nAAsPLbTSAPM28CxTHpp3aC1fe5A1YxZY7CW1Xv9hToSYy386C
         1fqMx1xtKpA9oAaE/nww8WtYJwEyZzDEmZsIy7Y/EPVNyANuZ2jlMumSFYoAWgM/vS
         DwlQminVcd0Jw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RPYnH5xwHz4wZJ;
        Mon, 14 Aug 2023 22:37:07 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] powerpc: Make virt_to_pfn() a static inline
In-Reply-To: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
References: <20230809-virt-to-phys-powerpc-v1-1-12e912a7d439@linaro.org>
Date:   Mon, 14 Aug 2023 22:37:07 +1000
Message-ID: <87a5uter64.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:
> Making virt_to_pfn() a static inline taking a strongly typed
> (const void *) makes the contract of a passing a pointer of that
> type to the function explicit and exposes any misuse of the
> macro virt_to_pfn() acting polymorphic and accepting many types
> such as (void *), (unitptr_t) or (unsigned long) as arguments
> without warnings.
...
> diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
> index f2b6bf5687d0..9ee4b6d4a82a 100644
> --- a/arch/powerpc/include/asm/page.h
> +++ b/arch/powerpc/include/asm/page.h
> @@ -9,6 +9,7 @@
>  #ifndef __ASSEMBLY__
>  #include <linux/types.h>
>  #include <linux/kernel.h>
> +#include <linux/bug.h>
>  #else
>  #include <asm/types.h>
>  #endif
> @@ -119,16 +120,6 @@ extern long long virt_phys_offset;
>  #define ARCH_PFN_OFFSET		((unsigned long)(MEMORY_START >> PAGE_SHIFT))
>  #endif
>  
> -#define virt_to_pfn(kaddr)	(__pa(kaddr) >> PAGE_SHIFT)
> -#define virt_to_page(kaddr)	pfn_to_page(virt_to_pfn(kaddr))
> -#define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
> -
> -#define virt_addr_valid(vaddr)	({					\
> -	unsigned long _addr = (unsigned long)vaddr;			\
> -	_addr >= PAGE_OFFSET && _addr < (unsigned long)high_memory &&	\
> -	pfn_valid(virt_to_pfn(_addr));					\
> -})
> -
>  /*
>   * On Book-E parts we need __va to parse the device tree and we can't
>   * determine MEMORY_START until then.  However we can determine PHYSICAL_START
> @@ -233,6 +224,25 @@ extern long long virt_phys_offset;
>  #endif
>  #endif
>  
> +#ifndef __ASSEMBLY__
> +static inline unsigned long virt_to_pfn(const void *kaddr)
> +{
> +	return __pa(kaddr) >> PAGE_SHIFT;
> +}
> +
> +static inline const void *pfn_to_kaddr(unsigned long pfn)
> +{
> +	return (const void *)(((unsigned long)__va(pfn)) << PAGE_SHIFT);

Any reason to do it this way rather than:

+       return __va(pfn << PAGE_SHIFT);

Seems to be equivalent and much cleaner?

cheers
