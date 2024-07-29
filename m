Return-Path: <kvm+bounces-22516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D89C93FB39
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 18:33:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED90F284101
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2024 16:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238DD188CBE;
	Mon, 29 Jul 2024 16:24:31 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F48155CB3
	for <kvm@vger.kernel.org>; Mon, 29 Jul 2024 16:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722270270; cv=none; b=ddKaXGXGasejNtLUE+Su/WZeKSKka1Fy/ubYSaACbBp0aT4e3Eo+7tSng3MigCmq0BfNWGqdd0jUEbsmBopuN6ho8Eu/zPsmsmQx49fWJBeqDUXrj9h3jbvlyR94hRRjKHOSZyZ19vKPTuOke8Qfrq9z8cQsYRRTrzAqpG/+tKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722270270; c=relaxed/simple;
	bh=ZPl/Zmnqt2pDbqbogHkpC7W+mhG/65XSGe0MGDEQiOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bggienfVDsMdTXj4zTkosCZEXArNQ5aKK+M9/qOVN7+557sy564T0jFuI91pG1fDTxPnjfM6ME4PRIUcd3+2BQzCDqkjSHlLoQ9KFzl1ZHNjq/qAy5rHZwOaHyxcpvR33SJ9296o7SsZ7eIRGeH4/8zVij0RwP2wqG4Yt4iv5VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F20531007;
	Mon, 29 Jul 2024 09:24:53 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4F3F33F766;
	Mon, 29 Jul 2024 09:24:27 -0700 (PDT)
Date: Mon, 29 Jul 2024 17:24:24 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: =?utf-8?Q?J=2E_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Cc: kvm@vger.kernel.org, Alyssa Ross <hi@alyssa.is>, will@kernel.org,
	julien.thierry.kdev@gmail.com
Subject: Re: [PATCH kvmtool v2 2/2] Get __WORDSIZE from <sys/reg.h> for musl
 compat
Message-ID: <ZqfCOOhF9dGf3G_c@raptor>
References: <20240727-musl-v2-0-b106252a1cba@gmx.net>
 <20240727-musl-v2-2-b106252a1cba@gmx.net>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240727-musl-v2-2-b106252a1cba@gmx.net>

Hi,

CC'ing the maintainers (can be found in README).

On Sat, Jul 27, 2024 at 07:11:03PM +0200, J. Neuschäfer wrote:
> musl-libc doesn't provide <bits/wordsize.h>, but it defines __WORDSIZE
> in <sys/reg.h> and <sys/user.h>.
> 
> Signed-off-by: J. Neuschäfer <j.neuschaefer@gmx.net>
> ---
>  include/linux/bitops.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index ae33922..4f133ba 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -1,7 +1,7 @@
>  #ifndef _KVM_LINUX_BITOPS_H_
>  #define _KVM_LINUX_BITOPS_H_
> 
> -#include <bits/wordsize.h>
> +#include <sys/reg.h>

When cross-compiling on x86 for arm64, as well as when compiling natively for
arm64 I get this error:

In file included from include/linux/bitmap.h:7,
                 from util/find.c:4:
include/linux/bitops.h:5:10: fatal error: sys/reg.h: No such file or directory
    5 | #include <sys/reg.h>
      |          ^~~~~~~~~~~
compilation terminated.
make: *** [Makefile:510: util/find.o] Error 1
make: *** Waiting for unfinished jobs....
In file included from include/linux/bitmap.h:7,
                 from util/bitmap.c:9:
include/linux/bitops.h:5:10: fatal error: sys/reg.h: No such file or directory
    5 | #include <sys/reg.h>
      |          ^~~~~~~~~~~
compilation terminated.
make: *** [Makefile:510: util/bitmap.o] Error 1

Also, grep finds __WORDSIZE only in bits/wordsize.h on an x86 and arm64 machine:

$ grep -r "define __WORDSIZE" /usr/include/
/usr/include/bits/wordsize.h:# define __WORDSIZE			64
/usr/include/bits/wordsize.h:# define __WORDSIZE			32
/usr/include/bits/wordsize.h:# define __WORDSIZE32_SIZE_ULONG	1
/usr/include/bits/wordsize.h:# define __WORDSIZE32_PTRDIFF_LONG	1
/usr/include/bits/wordsize.h:#define __WORDSIZE_TIME64_COMPAT32	0


Thanks,
Alex

> 
>  #include <linux/kernel.h>
>  #include <linux/compiler.h>
> 
> --
> 2.43.0
> 
> 

