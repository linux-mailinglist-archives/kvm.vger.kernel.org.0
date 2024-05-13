Return-Path: <kvm+bounces-17344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BEC28C460A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 28B161F2187C
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:30:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233251BF40;
	Mon, 13 May 2024 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WyvnryIL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378621C6BD;
	Mon, 13 May 2024 17:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715621411; cv=none; b=nOghBcD2NKc7Mgk4pr6ADYzUDuC2ZDS4IH8WuDrzun9sQtR3xIKDOc6ZIdF9FeB/7M96N/K3Y48/qyk1fuuNoQUDGnGUczLrAnU4i34rbjv5fVFRJvWXkoHgGHvGycSvhCEQd0bZQ+siCo6HoUGQjsf+5yhKfyzIFn57ZFRBC6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715621411; c=relaxed/simple;
	bh=DR8jZ69miHfLN6RA278vWtF1Q++hEjEfLoVuHTEHdlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l20JM/WKvTHgc6+3LYnp3p6GBbmEDw/7MCbqN1H6iznOPVZntYsjW0gdJFeUlbeWMbURN3N8NP8RCBxmLGpojsg4qLRQbKCLLYnG5ftMeX1xWxEhfuehZMlWxL6bS3gfNerqBlToKrJoNYXBH7KGXKc1OtHjX2TIKVHdlq5kiF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WyvnryIL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70519C113CC;
	Mon, 13 May 2024 17:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715621411;
	bh=DR8jZ69miHfLN6RA278vWtF1Q++hEjEfLoVuHTEHdlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WyvnryILwoH46oQY60Sd0tWHReEVP7XtxcJy9oCodoVoEvlTUGXW/jQh8T9RgFEmc
	 SiNYJutIB4CR5lxhnhG3Abd6V8o4FuQP24bUHbudJuSMxkvo5hOXGLFoVljXGPGP2Q
	 75GIfK8EiFZBp3b/lRQ+Qje6iD33uvYHOXzPjbBGZKSxmikKV7mElKl+CO9d4qCIMf
	 3BdRsXYsdS1IRM8b8wi7+iTrs/s0ILgCH4ODstVjUis+JFfXdshXgwHsM7XhYiLvd6
	 5MVNf5fdsdyXbRsv0Tp3zK7WXY585wbPITYM6FN0Jp7Ju0/cDKzV7ZibjFOpjHtmnO
	 W3wWcM9psdfHw==
Date: Mon, 13 May 2024 18:30:05 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v3 10/12] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <20240513173005.GB29051@willie-the-truck>
References: <20240510112645.3625702-1-ptosi@google.com>
 <20240510112645.3625702-11-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240510112645.3625702-11-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 12:26:39PM +0100, Pierre-Clément Tosi wrote:
> The compiler implements kCFI by adding type information (u32) above
> every function that might be indirectly called and, whenever a function
> pointer is called, injects a read-and-compare of that u32 against the
> value corresponding to the expected type. In case of a mismatch, a BRK
> instruction gets executed. When the hypervisor triggers such an
> exception in nVHE, it panics and triggers and exception return to EL1.
> 
> Therefore, teach nvhe_hyp_panic_handler() to detect kCFI errors from the
> ESR and report them. If necessary, remind the user that EL2 kCFI is not
> affected by CONFIG_CFI_PERMISSIVE.
> 
> Pass $(CC_FLAGS_CFI) to the compiler when building the nVHE hyp code.
> 
> Use SYM_TYPED_FUNC_START() for __pkvm_init_switch_pgd, as nVHE can't
> call it directly and must use a PA function pointer from C (because it
> is part of the idmap page), which would trigger a kCFI failure if the
> type ID wasn't present.
> 
> Signed-off-by: Pierre-Clément Tosi <ptosi@google.com>
> ---
>  arch/arm64/include/asm/esr.h       |  6 ++++++
>  arch/arm64/kvm/handle_exit.c       | 11 +++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
>  4 files changed, 25 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
> index 2bcf216be376..9eb9e6aa70cf 100644
> --- a/arch/arm64/include/asm/esr.h
> +++ b/arch/arm64/include/asm/esr.h
> @@ -391,6 +391,12 @@ static inline bool esr_is_data_abort(unsigned long esr)
>  	return ec == ESR_ELx_EC_DABT_LOW || ec == ESR_ELx_EC_DABT_CUR;
>  }
>  
> +static inline bool esr_is_cfi_brk(unsigned long esr)
> +{
> +	return ESR_ELx_EC(esr) == ESR_ELx_EC_BRK64 &&
> +	       (esr_brk_comment(esr) & ~CFI_BRK_IMM_MASK) == CFI_BRK_IMM_BASE;
> +}

This can now be used by early_brk64().

>  static inline bool esr_fsc_is_translation_fault(unsigned long esr)
>  {
>  	/* Translation fault, level -1 */
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 0bcafb3179d6..0db23a6304ce 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -383,6 +383,15 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
>  		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
>  }
>  
> +static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
> +{
> +	kvm_err("nVHE hyp CFI failure at: [<%016llx>] %pB!\n", panic_addr,
> +		(void *)(panic_addr + kaslr_offset()));

Perhaps add a helper for displaying a hyp panic banner so that we remain
consistent?

> +
> +	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
> +		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
> +}
> +
>  void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>  					      u64 elr_virt, u64 elr_phys,
>  					      u64 par, uintptr_t vcpu,
> @@ -413,6 +422,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>  		else
>  			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
>  					(void *)(panic_addr + kaslr_offset()));
> +	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
> +		kvm_nvhe_report_cfi_failure(panic_addr);
>  	} else {
>  		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
>  				(void *)(panic_addr + kaslr_offset()));
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 2250253a6429..2eb915d8943f 100644
> --- a/arch/arm64/kvm/hyp/nvhe/Makefile
> +++ b/arch/arm64/kvm/hyp/nvhe/Makefile
> @@ -89,9 +89,9 @@ quiet_cmd_hyprel = HYPREL  $@
>  quiet_cmd_hypcopy = HYPCOPY $@
>        cmd_hypcopy = $(OBJCOPY) --prefix-symbols=__kvm_nvhe_ $< $@
>  
> -# Remove ftrace, Shadow Call Stack, and CFI CFLAGS.
> -# This is equivalent to the 'notrace', '__noscs', and '__nocfi' annotations.
> -KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS) $(CC_FLAGS_CFI), $(KBUILD_CFLAGS))
> +# Remove ftrace and Shadow Call Stack CFLAGS.
> +# This is equivalent to the 'notrace' and '__noscs' annotations.
> +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
>  # Starting from 13.0.0 llvm emits SHT_REL section '.llvm.call-graph-profile'
>  # when profile optimization is applied. gen-hyprel does not support SHT_REL and
>  # causes a build failure. Remove profile optimization flags.
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 5a15737b4233..33fb5732ab83 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -5,6 +5,7 @@
>   */
>  
>  #include <linux/arm-smccc.h>
> +#include <linux/cfi_types.h>
>  #include <linux/linkage.h>
>  
>  #include <asm/alternative.h>
> @@ -268,8 +269,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
>  /*
>   * void __pkvm_init_switch_pgd(struct kvm_nvhe_init_params *params,
>   *                             void (*finalize_fn)(void));
> + *
> + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> + * using a physical pointer without triggering a kCFI failure.
>   */
> -SYM_FUNC_START(__pkvm_init_switch_pgd)
> +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
>  	/* Load the inputs from the VA pointer before turning the MMU off */
>  	ldr	x5, [x0, #NVHE_INIT_PGD_PA]
>  	ldr	x0, [x0, #NVHE_INIT_STACK_HYP_VA]

Unrelated hunk?

Will

