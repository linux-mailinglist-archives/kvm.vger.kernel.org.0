Return-Path: <kvm+bounces-23022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8E0945B98
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 11:56:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 77C7D282FFF
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2024 09:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043C61DC47C;
	Fri,  2 Aug 2024 09:56:01 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2657A1DB449
	for <kvm@vger.kernel.org>; Fri,  2 Aug 2024 09:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722592560; cv=none; b=WGV2j2jBtNbkaNarG4Le0uzUyh9w6gFyQdMxTvvvvhDDpGXsB5IA/UVWpj8mFwCN9SxjY6HGhctjIjs2ZfxtFTc8l5OI3kZIg5V6AItvxrFmUtPc9oPGEr1sgBhw/zcF4oFSXQuDrUmLOF8D8aMnH55VUBvCwQYnVluIDL8CNyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722592560; c=relaxed/simple;
	bh=MNmymIlvW+Trg0dmP8N1q4HTzW4RcUeUXnOtnCf9AEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D3EOcGUz2QLJidYKfDfUm3c29wdfeXBm5e3ABjOKnLHXgexIg8S+eyMfJVRpz1BpS0iL3Br34yunzizke/Agz0fTzGD6I7CiaHlfoKu/GdO5u5Hjffjl0oDgZPiKW9F7f+h1vmwuk6CuO1u12ruqo4aUL2JK11D4ZWvAbmYm5JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3CBA51007;
	Fri,  2 Aug 2024 02:56:24 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 895CF3F64C;
	Fri,  2 Aug 2024 02:55:57 -0700 (PDT)
Date: Fri, 2 Aug 2024 10:55:54 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andre Przywara <andre.przywara@arm.com>
Cc: Will Deacon <will@kernel.org>,
	Julien Thierry <julien.thierry.kdev@gmail.com>, kvm@vger.kernel.org,
	J =?utf-8?Q?=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: Re: [PATCH kvmtool] remove wordsize.h inclusion (for musl
 compatibility)
Message-ID: <ZqytKiGEeqMLYvO3@raptor>
References: <20240801111054.818765-1-andre.przywara@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240801111054.818765-1-andre.przywara@arm.com>

Hi Andre,

On Thu, Aug 01, 2024 at 12:10:54PM +0100, Andre Przywara wrote:
> The wordsize.h header file and the __WORDSIZE definition do not seem
> to be universal, the musl libc for instance has the definition in a
> different header file. This breaks compilation of kvmtool against musl.
> 
> The two leading underscores suggest a compiler-internal symbol anyway, so
> let's just remove that particular macro usage entirely, and replace it
> with the number we really want: the size of a "long" type.
> 
> Reported-by: J. Neuschäfer <j.neuschaefer@gmx.net>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
> Hi,
> 
> can someone test this on a proper/pure musl installation? I tested this
> with Ubuntu's musl-gcc wrapper, but this didn't show the problem before,
> so I guess there are subtle differences.
> 
> Cheers,
> Andre
> 
>  include/linux/bitops.h | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index ae33922f5..ee8fd5609 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -1,15 +1,13 @@
>  #ifndef _KVM_LINUX_BITOPS_H_
>  #define _KVM_LINUX_BITOPS_H_
>  
> -#include <bits/wordsize.h>
> -
>  #include <linux/kernel.h>
>  #include <linux/compiler.h>
>  #include <asm/hweight.h>
>  
> -#define BITS_PER_LONG __WORDSIZE
>  #define BITS_PER_BYTE           8
> -#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
> +#define BITS_PER_LONG           (BITS_PER_BYTE * sizeof(long))
> +#define BITS_TO_LONGS(nr)       DIV_ROUND_UP(nr, BITS_PER_LONG)

This makes perfect sense to me. I would just like to point out that the code
already used this definition for the number of bits in a long, in the
BITS_TO_LONGS() macro, where it used BITS_PER_BYTE * sizeof(long) instead of
BITS_PER_LONG.

Also tested this by cross-compiling for arm and arm64 on an x86 host, and
compiling natively for arm64.

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex

>  
>  #define BIT_WORD(nr)		((nr) / BITS_PER_LONG)
>  
> -- 
> 2.25.1
> 

