Return-Path: <kvm+bounces-43489-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AEC31A90C6A
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 21:34:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 298673B4A11
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 19:34:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A3992253F2;
	Wed, 16 Apr 2025 19:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T+A0oHTS"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E2121146F;
	Wed, 16 Apr 2025 19:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744832061; cv=none; b=g/EU9kR9cxKz8UEWbZP8AcluyV37kk73JbLtlhw4Bpqtug9xCkSExDlqDU5Ga/T8BRYNrb4LyrPgYhQ5bLrrA2mw5Mrl8uLil16alG8ejJqRBkxW45s/dlbE8oKOQLWSwMT97BO77cu+MjG6yCJQjRCVsQPI3LmE0zJder1tuSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744832061; c=relaxed/simple;
	bh=geLExcJtOAjXjEY3nYZsjfpMc2TX5ES0OBy8m9gKC/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yy005nBXdkAaHF1EwwQ8c0y9rp28Uo/T6FLQCmdaPAixt0MRl71W9muINEfO3tWan1DW7GfofxbeyYqcEsSTfbWbt0YFNf9c3yJCLJ5VZT1AiUPYf61FB/TDFjmvxDXOSIsXPCMIE1x1BYLlxFxn1W61cJz6FYTFwRbxKOi/doY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T+A0oHTS; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E34AC4CEE2;
	Wed, 16 Apr 2025 19:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744832059;
	bh=geLExcJtOAjXjEY3nYZsjfpMc2TX5ES0OBy8m9gKC/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T+A0oHTSymTtL9IlRxP2X49sZVIM+qKZykeUc2U1jckOh7Fab2nVwAlbNWbp/XYXH
	 72yCmdRJgMazizkaUaoxG0Wn7KFWs6aHcG6OfFWYy+IW8oFbj4GScY3vpMq0460m83
	 znneUQQNp70DChBAFipuLJMTCbl0QPbJuB9t45gg34S2XEtV2Xy7YIWXsmuR4MnGoB
	 ONm30k/EW8IhlQTZhxZ/RMNIYfZyo3oG6WmJH2ox1m2hZrI+VEcIhKMAYk9WTZNjB/
	 RizhkamT1QOnRjMZK46AjXuFi1Hwlokh2lbPLIBWcjDTJ5LJe25/TXY4xyWLb6lIOf
	 LWfCobji2UGcQ==
Date: Wed, 16 Apr 2025 22:34:16 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: chenlinxuan@uniontech.com
Cc: Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Peter Huewe <peterhuewe@gmx.de>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-integrity@vger.kernel.org,
	linux-kbuild@vger.kernel.org, llvm@lists.linux.dev,
	Winston Wen <wentao@uniontech.com>,
	Changbin Du <changbin.du@intel.com>
Subject: Re: [PATCH RFC v2 4/5] tpm: add __always_inline for
 tpm_is_hwrng_enabled
Message-ID: <aAAGOIN-IsnTK2gm@kernel.org>
References: <20250416-noautoinline-v2-0-e69a2717530f@uniontech.com>
 <20250416-noautoinline-v2-4-e69a2717530f@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250416-noautoinline-v2-4-e69a2717530f@uniontech.com>

On Wed, Apr 16, 2025 at 05:44:50PM +0800, Chen Linxuan via B4 Relay wrote:
> From: Winston Wen <wentao@uniontech.com>
> 
> Presume that kernel is compiled for x86_64 with gcc version 13.3.0:
> 
>   make defconfig
>   ./scripts/kconfig/merge_config.sh .config <(
>     echo CONFIG_TCG_TPM=y
>     echo CONFIG_HW_RANDOM=m
>   )
>   make KCFLAGS="-fno-inline-small-functions -fno-inline-functions-called-once"
> 
> This results a link error:
> 
>   ld: vmlinux.o: in function `tpm_add_hwrng':
>   tpm-chip.c:(.text+0x6c5924): undefined reference to `hwrng_register'
>   ld: vmlinux.o: in function `tpm_chip_unregister':
>   (.text+0x6c5bc9): undefined reference to `hwrng_unregister'
>   ld: vmlinux.o: in function `tpm_chip_register':
>   (.text+0x6c5c9b): undefined reference to `hwrng_unregister'
> 
> With `CONFIG_TCG_TPM=y` and `CONFIG_HW_RANDOM=m`,
> the functions `tpm_add_hwrng`, `tpm_chip_unregister`, and
> `tpm_chip_register` are compiled into `vmlinux.o`
> and reference the symbols `hwrng_register` and `hwrng_unregister`.
> These symbols, however, are compiled into `rng-core.ko`, which results
> in the linking error.
> 
> I am not sure but I think this weird linking error only arises when
> auto inlining is disabled because of some dead code elimination.
> 
> `CONFIG_TCG_TPM=y` and `CONFIG_HW_RANDOM=m` set `CONFIG_HW_RANDOM_TPM=n`.
> This causes the function `tpm_is_hwrng_enabled` to always return
> `false`, as shown below:
> 
>   static bool tpm_is_hwrng_enabled(struct tpm_chip *chip)
>   {
>       if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM))
>           return false;
>       if (tpm_is_firmware_upgrade(chip))
>           return false;
>       if (chip->flags & TPM_CHIP_FLAG_HWRNG_DISABLED)
>           return false;
>       return true;
>   }
> 
> When `tpm_is_hwrng_enabled` is inlined, dead code elimination
> optimizations are applied and the reference to the `hwrng_*` functions
> will been removed.
> For instance, in the `tpm_chip_unregister` function:
> 
>   void tpm_chip_unregister(struct tpm_chip *chip)
>   {
>   #ifdef CONFIG_TCG_TPM2_HMAC
>       int rc;
> 
>       rc = tpm_try_get_ops(chip);
>       if (!rc) {
>           tpm2_end_auth_session(chip);
>           tpm_put_ops(chip);
>       }
>   #endif
> 
>       tpm_del_legacy_sysfs(chip);
>       if (tpm_is_hwrng_enabled(chip))
>           hwrng_unregister(&chip->hwrng);
>       tpm_bios_log_teardown(chip);
>       if (chip->flags & TPM_CHIP_FLAG_TPM2 && !tpm_is_firmware_upgrade(chip))
>           tpm_devs_remove(chip);
>       tpm_del_char_device(chip);
>   }
> 
> When `tpm_is_hwrng_enabled` is inlined and always returns `false`,
> the call to `hwrng_unregister` is effectively part of a `if (false)`
> block, which I guess that will be then optimized out.
> 
> However, when the `-fno-inline-small-functions` and
> `-fno-inline-functions-called-once` flags are used,
> tpm_is_hwrng_enabled is not inline.
> 
> And this optimization some how cannot occur,
> leading to the undefined reference errors during linking.
> 
> Adding the `__always_inline` attribute ensures that
> `tpm_is_hwrng_enabled` is inlined regardless of the compiler flags.
> This allows the dead code elimination to proceed as expected,
> resolving the linking issue.
> 
> Co-developed-by: Chen Linxuan <chenlinxuan@uniontech.com>
> Signed-off-by: Chen Linxuan <chenlinxuan@uniontech.com>
> Signed-off-by: Winston Wen <wentao@uniontech.com>
> ---
>  drivers/char/tpm/tpm-chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index e25daf2396d37bcaeae8a96267764df0861ad1be..48cc74d84247e258a39f2118e03aa10d0cbb066a 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -534,7 +534,7 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  	return tpm_get_random(chip, data, max);
>  }
>  
> -static bool tpm_is_hwrng_enabled(struct tpm_chip *chip)
> +static __always_inline bool tpm_is_hwrng_enabled(struct tpm_chip *chip)
>  {
>  	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM))
>  		return false;
> 
> -- 
> 2.48.1
> 
> 
> 

Thank you.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>


BR, Jarkko

