Return-Path: <kvm+bounces-16724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E70DD8BCEA5
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 14:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CAF21F23009
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 12:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2EDA6EB53;
	Mon,  6 May 2024 12:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="W644jclk"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A510343687;
	Mon,  6 May 2024 12:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715000368; cv=none; b=kZQ5bpu9/oT3fSx8CWgBcinpBpYDF1yH9Dwg8os29g7oMjnWmSTkBH52QyFgaDjArwoObaJBgF7UEI9BFvRepxYtkwycFt4O+F3oqlElAtTYePoTnim3m4K3c5CQZ1XEFvYRWGLd0OV8gVGTgiLsJ4PgzYTeJQ/e8Qi5rarhBnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715000368; c=relaxed/simple;
	bh=u4YorYLo//Zdf2cB2fFMSFyysd7c8cFd6Z4cCfzLHho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rK3HoFTzbeOmHogrRyeExEKTPUxTRsFRPno6X8yLkykAypOZgtQ8exm3J3zEH+6X8qxzX2XE75AjshkLBPIm7a3KPj5aHl3n5mmvL6OuuATChgZ53M4481aOy/ury82+UMg+d078P8XnSRvNcBfH5R/ypjbW1+paEWgk0Kd5SDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=W644jclk; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 1F59140E0187;
	Mon,  6 May 2024 12:59:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 6YJBEWDVV4ff; Mon,  6 May 2024 12:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715000359; bh=pylzvv8NGZK4ROfBoCs4iOsfuRAG+JTsfYFB/x19Qwg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W644jclk1AM0sw2RlXxg82b3Fp4SesPBn/1UUCBoTGfGypjIrFtVIJFgPBFoQbV/u
	 XeyHQjWXmZ0MIsvEIPbtNOvf60SQ7IdgQluzugT5sBI4XwgYgp2xvduvOzp5vHP0wt
	 SHPvSrhxeuRtlNG/GKNH055324JiwZOQpotO1qnNnoWyUXTOX52QI0DlfhyBZa6P6c
	 cRq19SnK+BbZl/EhzjOt307iIlkpKoOwdACg5Ur2Kbrdx8VX1JjxIVz7c27s82aU79
	 QBA1ffIiAnpYx6FLjHSZaEZo4KqRlM5X183LjF0sjwJF8vlwpJ4Jp+ERsdABs68Ega
	 erD/khJZjsDeomY/FKp/f06De19HujqEZCOYD9rBzoCtXgs/kq+4DHcyonHNh0QIz4
	 +9NhsXN8rzl7ThLujh6lG/hcXOQBtH+mO5Jugd5PDuW4d0iT03bQxhyIoP8aRiWatk
	 u4jhNpWNqVh7YnoZPaAiRDMYC/dVtxd4Etc4zU8hS9o+6S/ChdNTN3jiSmJGwD5IXk
	 jqBN+mNVWSqE5LqKOGZYXHf+rNB4ae5U9i5t0h1QjxgqrNYEbgg8YvA/7tlU0W6qhh
	 oFSirzoOjJEqQxo7LKtbUT7OkxXoDJkW03hPCMRYe8lx4KD5JqQaimhMQ5O1tEqKT6
	 7Np6+H8aG9cHwR38au0pG0tY=
Received: from zn.tnic (pd953020b.dip0.t-ipconnect.de [217.83.2.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D622240E0249;
	Mon,  6 May 2024 12:58:53 +0000 (UTC)
Date: Mon, 6 May 2024 14:58:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
	seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
	hpa@zytor.com, rmk+kernel@armlinux.org.uk, peterz@infradead.org,
	james.morse@arm.com, lukas.bulwahn@gmail.com, arjan@linux.intel.com,
	j.granados@samsung.com, sibs@chinatelecom.cn, nik.borisov@suse.com,
	michael.roth@amd.com, nikunj.dadhania@amd.com, babu.moger@amd.com,
	x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	santosh.shukla@amd.com, ananth.narayan@amd.com,
	sandipan.das@amd.com
Subject: Re: [PATCH 1/3] x86/split_lock: Move Split and Bus lock code to a
 dedicated file
Message-ID: <20240506125847.GTZjjUB6D_cClwghMc@fat_crate.local>
References: <20240429060643.211-1-ravi.bangoria@amd.com>
 <20240429060643.211-2-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240429060643.211-2-ravi.bangoria@amd.com>

On Mon, Apr 29, 2024 at 11:36:41AM +0530, Ravi Bangoria wrote:
> Upcoming AMD uarch will support Bus Lock Detect, which functionally works
> identical to Intel. Move split_lock and bus_lock specific code from
> intel.c to a dedicated file so that it can be compiled and supported on
> non-intel platforms.
> 
> Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
> ---
>  arch/x86/include/asm/cpu.h           |   4 +
>  arch/x86/kernel/cpu/Makefile         |   1 +
>  arch/x86/kernel/cpu/intel.c          | 407 ---------------------------
>  arch/x86/kernel/cpu/split-bus-lock.c | 406 ++++++++++++++++++++++++++
>  4 files changed, 411 insertions(+), 407 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/split-bus-lock.c
> 
> diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
> index aa30fd8cad7f..4b5c31dc8112 100644
> --- a/arch/x86/include/asm/cpu.h
> +++ b/arch/x86/include/asm/cpu.h
> @@ -51,6 +51,10 @@ static inline u8 get_this_hybrid_cpu_type(void)
>  	return 0;
>  }
>  #endif
> +
> +void split_lock_init(void);
> +void bus_lock_init(void);
> +
>  #ifdef CONFIG_IA32_FEAT_CTL
>  void init_ia32_feat_ctl(struct cpuinfo_x86 *c);
>  #else
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index eb4dbcdf41f1..86a10472ad1d 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -27,6 +27,7 @@ obj-y			+= aperfmperf.o
>  obj-y			+= cpuid-deps.o
>  obj-y			+= umwait.o
>  obj-y 			+= capflags.o powerflags.o
> +obj-y 			+= split-bus-lock.o

Too fine-grained a name and those "-" should be "_".

Perhaps bus_lock.c only...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

