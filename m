Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5808F35F77E
	for <lists+kvm@lfdr.de>; Wed, 14 Apr 2021 17:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhDNPTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Apr 2021 11:19:41 -0400
Received: from foss.arm.com ([217.140.110.172]:57882 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233662AbhDNPTj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Apr 2021 11:19:39 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 28568113E;
        Wed, 14 Apr 2021 08:19:18 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 683573F73B;
        Wed, 14 Apr 2021 08:19:17 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests 2/8] arm/arm64: Move setup_vm into setup
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
Cc:     nikos.nikoleris@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
References: <20210407185918.371983-1-drjones@redhat.com>
 <20210407185918.371983-3-drjones@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5c4af26d-8858-9b88-74d3-42df61eba33f@arm.com>
Date:   Wed, 14 Apr 2021 16:19:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407185918.371983-3-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 4/7/21 7:59 PM, Andrew Jones wrote:
> Consolidate our setup calls to reduce the amount we need to do from
> init::start. Also remove a couple of pointless comments from setup().

This is a good idea. Looks good to me, and I compiled the code for arm and arm64,
so it must be correct:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arm/cstart.S    | 6 ------
>  arm/cstart64.S  | 5 -----
>  lib/arm/setup.c | 7 +++++--
>  3 files changed, 5 insertions(+), 13 deletions(-)
>
> diff --git a/arm/cstart.S b/arm/cstart.S
> index 653ab1e8a141..731f841695ce 100644
> --- a/arm/cstart.S
> +++ b/arm/cstart.S
> @@ -81,12 +81,7 @@ start:
>  	/* complete setup */
>  	pop	{r0-r1}
>  	bl	setup
> -	bl	get_mmu_off
> -	cmp	r0, #0
> -	bne	1f
> -	bl	setup_vm
>  
> -1:
>  	/* run the test */
>  	ldr	r0, =__argc
>  	ldr	r0, [r0]
> @@ -108,7 +103,6 @@ enable_vfp:
>  	vmsr	fpexc, r0
>  	mov	pc, lr
>  
> -.global get_mmu_off
>  get_mmu_off:
>  	ldr	r0, =auxinfo
>  	ldr	r0, [r0, #4]
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index d39cf4dfb99c..add60a2b4e74 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -95,11 +95,7 @@ start:
>  	/* complete setup */
>  	mov	x0, x4				// restore the addr of the dtb
>  	bl	setup
> -	bl	get_mmu_off
> -	cbnz	x0, 1f
> -	bl	setup_vm
>  
> -1:
>  	/* run the test */
>  	adrp	x0, __argc
>  	ldr	w0, [x0, :lo12:__argc]
> @@ -113,7 +109,6 @@ start:
>  
>  .text
>  
> -.globl get_mmu_off
>  get_mmu_off:
>  	adrp	x0, auxinfo
>  	ldr	x0, [x0, :lo12:auxinfo + 8]
> diff --git a/lib/arm/setup.c b/lib/arm/setup.c
> index 751ba980000a..9c16f6004e9f 100644
> --- a/lib/arm/setup.c
> +++ b/lib/arm/setup.c
> @@ -16,6 +16,8 @@
>  #include <alloc.h>
>  #include <alloc_phys.h>
>  #include <alloc_page.h>
> +#include <vmalloc.h>
> +#include <auxinfo.h>
>  #include <argv.h>
>  #include <asm/thread_info.h>
>  #include <asm/setup.h>
> @@ -233,7 +235,6 @@ void setup(const void *fdt)
>  		freemem += initrd_size;
>  	}
>  
> -	/* call init functions */
>  	mem_init(PAGE_ALIGN((unsigned long)freemem));
>  	cpu_init();
>  
> @@ -243,7 +244,6 @@ void setup(const void *fdt)
>  	/* mem_init must be called before io_init */
>  	io_init();
>  
> -	/* finish setup */
>  	timer_save_state();
>  
>  	ret = dt_get_bootargs(&bootargs);
> @@ -256,4 +256,7 @@ void setup(const void *fdt)
>  		memcpy(env, initrd, initrd_size);
>  		setup_env(env, initrd_size);
>  	}
> +
> +	if (!(auxinfo.flags & AUXINFO_MMU_OFF))
> +		setup_vm();
>  }
