Return-Path: <kvm+bounces-30926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E23F89BE5C7
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 12:40:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98DB81F248C2
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 128591DEFC5;
	Wed,  6 Nov 2024 11:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMLUxF40"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E1B1DE3AC;
	Wed,  6 Nov 2024 11:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730893203; cv=none; b=kI/qO93UgpHV9NUztVa6vRKLUABOiSrK78zn2AJEpV4dUNHLWGeX4jGQJ7XzqryWzj7QWcfGWQ46FbmAyaue6bhWbDOfKNPDY5ncsOLGKRlF+88JE1z3avfjFMG6Z5m0g/wy2W4xEdd5uFGJ3q5yR8UoCwED1i3XTT/ZhS7Br04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730893203; c=relaxed/simple;
	bh=LfdnWgo5Tult/Ytob/TpTZCRMLZX+e2O5Aaq1lroTOk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TL9203C4S/qLgePATzaPFGD78PIKsqdvNrcwZ6M1Pz7Haq3GqY1c1cw3XWHc6qcyqJVAFxrYCxQ6muAD+6GV8vjIX8P1CpJIgqKdPoclb12iFU1KTswfMcbot1JMpXP6PUO1TT7vMslhqZZdItMA32GDWJV32R2msnhwiBxRuxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMLUxF40; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DEAC4CECD;
	Wed,  6 Nov 2024 11:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730893202;
	bh=LfdnWgo5Tult/Ytob/TpTZCRMLZX+e2O5Aaq1lroTOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DMLUxF40Npvnh/AMFOwVE8QdM/kIH6EKpa2TMU3PnrLvzoByUUD2PJ69DHK6+lvXM
	 +P1Xf/ScqLVAK+44sbMBY+wWkgGaoK3rUU1ax1KCIxzmGjyFkYor/nNZOHWmcLs4YQ
	 tnDumX4PAM4bmx/Oc4/+ER7sml9dnjUBQW/iCLsOv6QV78QamVA/0ZCprB0U6wdU6O
	 zvUUGCE0sESuBvyd/P2dJx7Hh0YWN3Klb+47AFXFQFyamEyQLdyPOz/uy+IZ06p5My
	 JKou7Ixdg9i4eg8fqzBi9IfsCBT99V/ga/V2zDNlCy3rlBYsiulnKPsEgVnQq2ASjd
	 ejpqgVZZChPPg==
Date: Wed, 6 Nov 2024 11:39:54 +0000
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
Subject: Re: [PATCH 1/5] asm-generic: add smp_vcond_load_relaxed()
Message-ID: <20241106113953.GA13801@willie-the-truck>
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
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Nov 05, 2024 at 12:30:37PM -0600, Haris Okanovic wrote:
> Relaxed poll until desired mask/value is observed at the specified
> address or timeout.
> 
> This macro is a specialization of the generic smp_cond_load_relaxed(),
> which takes a simple mask/value condition (vcond) instead of an
> arbitrary expression. It allows architectures to better specialize the
> implementation, e.g. to enable wfe() polling of the address on arm.

This doesn't make sense to me. The existing smp_cond_load() functions
already use wfe on arm64 and I don't see why we need a special helper
just to do a mask.

> Signed-off-by: Haris Okanovic <harisokn@amazon.com>
> ---
>  include/asm-generic/barrier.h | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
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
> + * @addr: pointer to an integer
> + * @mask: a bit mask applied to read values
> + * @val: Expected value with mask
> + */
> +#ifndef smp_vcond_load_relaxed

I know naming is hard, but "vcond" is especially terrible.
Perhaps smp_cond_load_timeout()?

Will

