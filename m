Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55D645BFA9B
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 11:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiIUJTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 05:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiIUJSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 05:18:46 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F6E58F978
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 02:18:06 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B363139F;
        Wed, 21 Sep 2022 02:17:30 -0700 (PDT)
Received: from [10.57.50.65] (unknown [10.57.50.65])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 491803F73D;
        Wed, 21 Sep 2022 02:17:22 -0700 (PDT)
Message-ID: <877e241c-d39b-76e3-15c9-774b83255969@arm.com>
Date:   Wed, 21 Sep 2022 10:17:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4 1/8] mm: Do not enable PG_arch_2 for all 64-bit
 architectures
Content-Language: en-GB
To:     Peter Collingbourne <pcc@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20220921035140.57513-1-pcc@google.com>
 <20220921035140.57513-2-pcc@google.com>
From:   Steven Price <steven.price@arm.com>
In-Reply-To: <20220921035140.57513-2-pcc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/09/2022 04:51, Peter Collingbourne wrote:
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> Commit 4beba9486abd ("mm: Add PG_arch_2 page flag") introduced a new
> page flag for all 64-bit architectures. However, even if an architecture
> is 64-bit, it may still have limited spare bits in the 'flags' member of
> 'struct page'. This may happen if an architecture enables SPARSEMEM
> without SPARSEMEM_VMEMMAP as is the case with the newly added loongarch.
> This architecture port needs 19 more bits for the sparsemem section
> information and, while it is currently fine with PG_arch_2, adding any
> more PG_arch_* flags will trigger build-time warnings.
> 
> Add a new CONFIG_ARCH_USES_PG_ARCH_X option which can be selected by
> architectures that need more PG_arch_* flags beyond PG_arch_1. Select it
> on arm64.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Price <steven.price@arm.com>

Reviewed-by: Steven Price <steven.price@arm.com>

> ---
>  arch/arm64/Kconfig             | 1 +
>  fs/proc/page.c                 | 2 +-
>  include/linux/page-flags.h     | 2 +-
>  include/trace/events/mmflags.h | 8 ++++----
>  mm/Kconfig                     | 8 ++++++++
>  mm/huge_memory.c               | 2 +-
>  6 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index f6737d2f37b2..f2435b62e0ba 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1948,6 +1948,7 @@ config ARM64_MTE
>  	depends on ARM64_PAN
>  	select ARCH_HAS_SUBPAGE_FAULTS
>  	select ARCH_USES_HIGH_VMA_FLAGS
> +	select ARCH_USES_PG_ARCH_X
>  	help
>  	  Memory Tagging (part of the ARMv8.5 Extensions) provides
>  	  architectural support for run-time, always-on detection of
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index a2873a617ae8..6f4b4bcb9b0d 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -218,7 +218,7 @@ u64 stable_page_flags(struct page *page)
>  	u |= kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
>  	u |= kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
>  	u |= kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
> -#ifdef CONFIG_64BIT
> +#ifdef CONFIG_ARCH_USES_PG_ARCH_X
>  	u |= kpf_copy_bit(k, KPF_ARCH_2,	PG_arch_2);
>  #endif
>  
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0b0ae5084e60..5dc7977edf9d 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -132,7 +132,7 @@ enum pageflags {
>  	PG_young,
>  	PG_idle,
>  #endif
> -#ifdef CONFIG_64BIT
> +#ifdef CONFIG_ARCH_USES_PG_ARCH_X
>  	PG_arch_2,
>  #endif
>  #ifdef CONFIG_KASAN_HW_TAGS
> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
> index 11524cda4a95..4673e58a7626 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -90,10 +90,10 @@
>  #define IF_HAVE_PG_IDLE(flag,string)
>  #endif
>  
> -#ifdef CONFIG_64BIT
> -#define IF_HAVE_PG_ARCH_2(flag,string) ,{1UL << flag, string}
> +#ifdef CONFIG_ARCH_USES_PG_ARCH_X
> +#define IF_HAVE_PG_ARCH_X(flag,string) ,{1UL << flag, string}
>  #else
> -#define IF_HAVE_PG_ARCH_2(flag,string)
> +#define IF_HAVE_PG_ARCH_X(flag,string)
>  #endif
>  
>  #ifdef CONFIG_KASAN_HW_TAGS
> @@ -129,7 +129,7 @@ IF_HAVE_PG_UNCACHED(PG_uncached,	"uncached"	)		\
>  IF_HAVE_PG_HWPOISON(PG_hwpoison,	"hwpoison"	)		\
>  IF_HAVE_PG_IDLE(PG_young,		"young"		)		\
>  IF_HAVE_PG_IDLE(PG_idle,		"idle"		)		\
> -IF_HAVE_PG_ARCH_2(PG_arch_2,		"arch_2"	)		\
> +IF_HAVE_PG_ARCH_X(PG_arch_2,		"arch_2"	)		\
>  IF_HAVE_PG_SKIP_KASAN_POISON(PG_skip_kasan_poison, "skip_kasan_poison")
>  
>  #define show_page_flags(flags)						\
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ceec438c0741..a976cbb07bd6 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -999,6 +999,14 @@ config ARCH_USES_HIGH_VMA_FLAGS
>  config ARCH_HAS_PKEYS
>  	bool
>  
> +config ARCH_USES_PG_ARCH_X
> +	bool
> +	help
> +	  Enable the definition of PG_arch_x page flags with x > 1. Only
> +	  suitable for 64-bit architectures with CONFIG_FLATMEM or
> +	  CONFIG_SPARSEMEM_VMEMMAP enabled, otherwise there may not be
> +	  enough room for additional bits in page->flags.
> +
>  config VM_EVENT_COUNTERS
>  	default y
>  	bool "Enable VM event counters for /proc/vmstat" if EXPERT
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1cc4a5f4791e..24974a4ce28f 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2444,7 +2444,7 @@ static void __split_huge_page_tail(struct page *head, int tail,
>  			 (1L << PG_workingset) |
>  			 (1L << PG_locked) |
>  			 (1L << PG_unevictable) |
> -#ifdef CONFIG_64BIT
> +#ifdef CONFIG_ARCH_USES_PG_ARCH_X
>  			 (1L << PG_arch_2) |
>  #endif
>  			 (1L << PG_dirty) |

