Return-Path: <kvm+bounces-30927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E0AE9BE5D7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:43:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC72CB22341
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5996A1DEFE3;
	Wed,  6 Nov 2024 11:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f55ksqmW"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749F457333;
	Wed,  6 Nov 2024 11:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730893392; cv=none; b=j+yWniQE6jr+IhvUJ2QvNV5o6fOTELn8zSaE2H5p9xrXxOBA3hcV0VYOlVGQ6LrwfP9Ywxwy/b0ORDhGW21ekVSsnqyoE3KSNK3R0JI6CbRqhj32chg9EsfFWvMm3JaVKkz8+nR9n5rvfEGdV3VI6xeTlbNoOUv+Klo6AVLdQYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730893392; c=relaxed/simple;
	bh=CZlxUMF7h6qY7n2j8niZdY+BvTgqh4tqKKQndIQgF1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mVA9+P7V7kXMs1Teij5xsY3vIeOB6pd92IckPTa+jNkouO2mXOS1cUpXYqIy1aejCSb+zVGjxjNC9mV7mirQqfWjVRQURjqJIroZ1yqjFEc3oEONC1IvGmOGa8tjApDhiJxzn7I6zqB2GRfMDTC95xRmUaWG8ZSCVvVhddgDdmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f55ksqmW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46F5C4CECD;
	Wed,  6 Nov 2024 11:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730893392;
	bh=CZlxUMF7h6qY7n2j8niZdY+BvTgqh4tqKKQndIQgF1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f55ksqmW4WB2ytuUuaXqtOk6lZw8OU1h4fp86og9ZiCOIrMBrE56cTF38d2+5GMu7
	 RSx7v4nNpm3AYPjXHPDyHlzDP0hBlB8hOk/HMZ5ZmqQpWIcJEonVGFgVvOASKI2Xyd
	 YtJwHV7PoP5fIKWwwT0r4zCG0pKoLDeB7lP16WpRXeL1XJKtcY/m3vFTDPBeAoy47/
	 MbtHn3oXogSwreZvOTbEJFIQlcWBw6/KsIsmU+PRtStWAvMUjrci7TvZxitmIHLKCk
	 wvEs4Os+qFnvW6z1kAdtHpan1tvKOx5EZYKz3it1Arl35EeafMmG9mpb/Y0m9S5Ib5
	 1Bq/ZfwniUT7g==
Date: Wed, 6 Nov 2024 11:43:03 +0000
From: Will Deacon <will@kernel.org>
To: Haris Okanovic <harisokn@amazon.com>
Cc: ankur.a.arora@oracle.com, catalin.marinas@arm.com,
	linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
	misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH 2/5] arm64: add __READ_ONCE_EX()
Message-ID: <20241106114302.GB13801@willie-the-truck>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
 <20241105183041.1531976-3-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105183041.1531976-3-harisokn@amazon.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 05, 2024 at 12:30:38PM -0600, Haris Okanovic wrote:
> Perform an exclusive load, which atomically loads a word and arms the
> exclusive monitor to enable wfet()/wfe() accelerated polling.
> 
> https://developer.arm.com/documentation/dht0008/a/arm-synchronization-primitives/exclusive-accesses/exclusive-monitors
> 
> Signed-off-by: Haris Okanovic <harisokn@amazon.com>
> ---
>  arch/arm64/include/asm/readex.h | 46 +++++++++++++++++++++++++++++++++
>  1 file changed, 46 insertions(+)
>  create mode 100644 arch/arm64/include/asm/readex.h
> 
> diff --git a/arch/arm64/include/asm/readex.h b/arch/arm64/include/asm/readex.h
> new file mode 100644
> index 000000000000..51963c3107e1
> --- /dev/null
> +++ b/arch/arm64/include/asm/readex.h
> @@ -0,0 +1,46 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Based on arch/arm64/include/asm/rwonce.h
> + *
> + * Copyright (C) 2020 Google LLC.
> + * Copyright (C) 2024 Amazon.com, Inc. or its affiliates.
> + */
> +
> +#ifndef __ASM_READEX_H
> +#define __ASM_READEX_H
> +
> +#define __LOAD_EX(sfx, regs...) "ldaxr" #sfx "\t" #regs
> +
> +#define __READ_ONCE_EX(x)						\
> +({									\
> +	typeof(&(x)) __x = &(x);					\
> +	int atomic = 1;							\
> +	union { __unqual_scalar_typeof(*__x) __val; char __c[1]; } __u;	\
> +	switch (sizeof(x)) {						\
> +	case 1:								\
> +		asm volatile(__LOAD_EX(b, %w0, %1)			\
> +			: "=r" (*(__u8 *)__u.__c)			\
> +			: "Q" (*__x) : "memory");			\
> +		break;							\
> +	case 2:								\
> +		asm volatile(__LOAD_EX(h, %w0, %1)			\
> +			: "=r" (*(__u16 *)__u.__c)			\
> +			: "Q" (*__x) : "memory");			\
> +		break;							\
> +	case 4:								\
> +		asm volatile(__LOAD_EX(, %w0, %1)			\
> +			: "=r" (*(__u32 *)__u.__c)			\
> +			: "Q" (*__x) : "memory");			\
> +		break;							\
> +	case 8:								\
> +		asm volatile(__LOAD_EX(, %0, %1)			\
> +			: "=r" (*(__u64 *)__u.__c)			\
> +			: "Q" (*__x) : "memory");			\
> +		break;							\
> +	default:							\
> +		atomic = 0;						\
> +	}								\
> +	atomic ? (typeof(*__x))__u.__val : (*(volatile typeof(__x))__x);\
> +})

I think this is a bad idea. Load-exclusive needs to be used very carefully,
preferably when you're able to see exactly what instructions it's
interacting with. By making this into a macro, we're at the mercy of the
compiler and we give the wrong impression that you could e.g. build atomic
critical sections out of this macro.

So I'm fairly strongly against this interface.

Will

