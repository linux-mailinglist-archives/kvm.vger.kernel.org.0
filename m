Return-Path: <kvm+bounces-18672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 537AF8D8561
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 16:46:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EEFE2813AF
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 14:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 280FB26AD5;
	Mon,  3 Jun 2024 14:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jv2UWfxH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521ADB65C;
	Mon,  3 Jun 2024 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717425936; cv=none; b=NnbDHzm2ULOPTN9dQPzhbNX0yRUk1/ohWI5K/ZHRHfSCph5UAwq93M7tZWC1Nkc6U2vrmN+vMlF4LEfwJYHw198POOApjPmknpV78W8ClXvcw2pFBzWPeUONX2K2KcyvhkFHKtAVdGmWxDK6NfvcrvQv3oHJq0/BAFN0SgzRZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717425936; c=relaxed/simple;
	bh=wOAkvHcu7QUTI1OGzXuCIt8lJzSCvubXPnqzx+mawaY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L85JbAHggjTuBTF6lO96oNUfgJGSQSRuesAu6qnEC+gyjUZBs2unC/fgJ6LRp8ohI3xTRdTZQhj3F5kz13uBZZQlgD2UE1dlQDog4Sm6I5jEWKW92Nu+HEoI0YVw+P/e3wEMbaRcGRGHP2aoq4uJsYVK4lfiERW+wkWr2bGsUWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jv2UWfxH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B5CAC2BD10;
	Mon,  3 Jun 2024 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717425935;
	bh=wOAkvHcu7QUTI1OGzXuCIt8lJzSCvubXPnqzx+mawaY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Jv2UWfxHjCJXTqZCBK7X9OvTw6vp74bczsx8wFgCj+oOl/7k+8UNz0nZTa2jSUNTw
	 4sXjrny/zzGvJF5MRx0Wzc9TEBHRo41W88UKzCJdQ9iTm5IL5+iZZEzFDcbJodU1H2
	 ZZFajxfGc0YntoT5RLAjB+SEhPSWxsUa/yN/qTXEfOAJE1aHk7pHDlklvv/thFdF5E
	 sn2FzqAI2+CEMcrEu7aFr5KTsWPzPl7Ymccz9jU0elC70cYm/ON0cHvZdMAvhr34aJ
	 QPBV9AgbzTOT/QG4YsbuRuV84eOtAXF75cucAXtrdYGiNtTNbzOj4CblYgt5AMDp/B
	 v6gV2H9fxSWQA==
Date: Mon, 3 Jun 2024 15:45:30 +0100
From: Will Deacon <will@kernel.org>
To: =?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v4 10/13] KVM: arm64: nVHE: Support CONFIG_CFI_CLANG at
 EL2
Message-ID: <20240603144530.GK19151@willie-the-truck>
References: <20240529121251.1993135-1-ptosi@google.com>
 <20240529121251.1993135-11-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529121251.1993135-11-ptosi@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 29, 2024 at 01:12:16PM +0100, Pierre-Clément Tosi wrote:
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
>  arch/arm64/kvm/handle_exit.c       | 10 ++++++++++
>  arch/arm64/kvm/hyp/nvhe/Makefile   |  6 +++---
>  arch/arm64/kvm/hyp/nvhe/hyp-init.S |  6 +++++-
>  3 files changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index b3d6657a259d..69b08ac7322d 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -417,6 +417,14 @@ static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
>  		(void *)(panic_addr + kaslr_offset()));
>  }
>  
> +static void kvm_nvhe_report_cfi_failure(u64 panic_addr)
> +{
> +	print_nvhe_hyp_panic("CFI failure", panic_addr);
> +
> +	if (IS_ENABLED(CONFIG_CFI_PERMISSIVE))
> +		kvm_err(" (CONFIG_CFI_PERMISSIVE ignored for hyp failures)\n");
> +}
> +
>  void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>  					      u64 elr_virt, u64 elr_phys,
>  					      u64 par, uintptr_t vcpu,
> @@ -446,6 +454,8 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
>  			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
>  		else
>  			print_nvhe_hyp_panic("BUG", panic_addr);
> +	} else if (IS_ENABLED(CONFIG_CFI_CLANG) && esr_is_cfi_brk(esr)) {
> +		kvm_nvhe_report_cfi_failure(panic_addr);
>  	} else {
>  		print_nvhe_hyp_panic("panic", panic_addr);
>  	}
> diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
> index 50fa0ffb6b7e..782b34b004be 100644
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
> index d859c4de06b6..b1c8977e2812 100644
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
> @@ -267,8 +268,11 @@ SYM_CODE_END(__kvm_handle_stub_hvc)
>  
>  /*
>   * void __pkvm_init_switch_pgd(phys_addr_t pgd, void *sp, void (*fn)(void));
> + *
> + * SYM_TYPED_FUNC_START() allows C to call this ID-mapped function indirectly
> + * using a physical pointer without triggering a kCFI failure.
>   */
> -SYM_FUNC_START(__pkvm_init_switch_pgd)
> +SYM_TYPED_FUNC_START(__pkvm_init_switch_pgd)
>  	/* Turn the MMU off */
>  	pre_disable_mmu_workaround
>  	mrs	x9, sctlr_el2

I still think this last hunk should be merged with the earlier patch
fixing up the prototype of __pkvm_init_switch_pgd().

With that:

Acked-by: Will Deacon <will@kernel.org>

Will

