Return-Path: <kvm+bounces-30920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 335E79BE53A
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:08:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB93B285054
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00E221DE4E1;
	Wed,  6 Nov 2024 11:08:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A31E18C00E;
	Wed,  6 Nov 2024 11:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730891303; cv=none; b=OdF3O9Apx8RWcCUf5Wpksj2FOJw9q7VszwjcYgyC3ixA065qiJVmAgiCHVcp0RSFrxLnE7L6QCkVBw9OPiFx3CxtuKFC6LqmeS3FA0WrzsDCXzr8nhPAbs/JbLevvx6M33O49e/ZTrRHRt694dY8+Wr4WUnn/LgZkwW/Gev8Tc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730891303; c=relaxed/simple;
	bh=O4y3JTBicmTSlJdnHiQSpamitaviXOau9AsHU/b8xpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LhazJ5YkaL0w2ubW2NZPdZsUlWqdhTgbwivX34im1sFIVlVJvCQxQnCjUNYH2x744wvGiKPUOovTEkY6cMHaWa5RpKi0qwD+dV9AlS6dmtT+jYcA8eSyGcimdNX+/6VnSX/o+1iEc3U5TaYnRoKqY3afETdzKV78WJZHQggu9ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147B3C4CECD;
	Wed,  6 Nov 2024 11:08:17 +0000 (UTC)
Date: Wed, 6 Nov 2024 11:08:15 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Haris Okanovic <harisokn@amazon.com>
Cc: ankur.a.arora@oracle.com, linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
	misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
	joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
	konrad.wilk@oracle.com
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Message-ID: <ZytOH2oigoC-qVLK@arm.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
 <20241105183041.1531976-2-harisokn@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105183041.1531976-2-harisokn@amazon.com>

On Tue, Nov 05, 2024 at 12:30:37PM -0600, Haris Okanovic wrote:
> diff --git a/include/asm-generic/barrier.h b/include/asm-generic/barrier.h
> index d4f581c1e21d..112027eabbfc 100644
> --- a/include/asm-generic/barrier.h
> +++ b/include/asm-generic/barrier.h
> @@ -256,6 +256,31 @@ do {									\
>  })
>  #endif
>  
> +/**
> + * smp_vcond_load_relaxed() - (Spin) wait until an expected value at address
> + * with no ordering guarantees. Spins until `(*addr & mask) == val` or
> + * `nsecs` elapse, and returns the last observed `*addr` value.
> + *
> + * @nsecs: timeout in nanoseconds

FWIW, I don't mind the relative timeout, it makes the API easier to use.
Yes, it may take longer in absolute time if the thread is scheduled out
before local_clock_noinstr() is read but the same can happen in the
caller anyway. It's similar to udelay(), it can take longer if the
thread is scheduled out.

> + * @addr: pointer to an integer
> + * @mask: a bit mask applied to read values
> + * @val: Expected value with mask
> + */
> +#ifndef smp_vcond_load_relaxed
> +#define smp_vcond_load_relaxed(nsecs, addr, mask, val) ({	\
> +	const u64 __start = local_clock_noinstr();		\
> +	u64 __nsecs = (nsecs);					\
> +	typeof(addr) __addr = (addr);				\
> +	typeof(*__addr) __mask = (mask);			\
> +	typeof(*__addr) __val = (val);				\
> +	typeof(*__addr) __cur;					\
> +	smp_cond_load_relaxed(__addr, (				\
> +		(VAL & __mask) == __val ||			\
> +		local_clock_noinstr() - __start > __nsecs	\
> +	));							\
> +})

The generic implementation has the same problem as Ankur's current
series. smp_cond_load_relaxed() can't wait on anything other than the
variable at __addr. If it goes into a WFE, there's nothing executed to
read the timer and check for progress. Any generic implementation of
such function would have to use cpu_relax() and polling.

-- 
Catalin

