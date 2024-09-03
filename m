Return-Path: <kvm+bounces-25724-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91AC79696AD
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C45421C23904
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:14:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C150205E36;
	Tue,  3 Sep 2024 08:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4Wk+xdO"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707AB20125C;
	Tue,  3 Sep 2024 08:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725351237; cv=none; b=kMsreHPBGuRkWQteoJGUZqTrFTHnnoNv4eDJusbSZQlvfrfdHuC0aR4x697CCG/fN6HwibI2onk4Cn9WzZn6z/+PZzcn7uP2zTUAhA4RxP4jul5KmTnLSNjtaSa7cLzg3cGoE19mdKwqvMh0IIp1ofC4m+V+FsEnSVeBvqO+BWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725351237; c=relaxed/simple;
	bh=jfoD+aB4zanqaDijLR2Aek6vFEYVgBitxkyNvmY57ps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fLe6Gp4GpHRxJFYGr28e+jQNWMoVdS8B1DAdw86ob/b+9a8wf1XB4ylOUE90KKnN5iqGGIzxK/2eRshbscbYcyIabL8OYtLmARODTV76t332k77C8XFcwCr+LIm/wi33kS23gj3eQzG3/SgksU2CI2ocNeCFERInw3jcDPUonLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4Wk+xdO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C9CC4CEC5;
	Tue,  3 Sep 2024 08:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725351236;
	bh=jfoD+aB4zanqaDijLR2Aek6vFEYVgBitxkyNvmY57ps=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e4Wk+xdORlAkSEIXDFWAsq4vMACrh4IXT2FEaGkPd66v6ShtvrS3HMJoFwINO7mqX
	 d9cTkoNfNcGUk7e5X7LxBqCPWhNmTzNrI0if/rqcZCubNWkvwEtlJhm/AKoULdnEW1
	 8hXtO1vSo3fMGV31APF0x8UO3p2R5z55zHBcJf/jPe1igBm+VKa9HOOOn+55nU95aL
	 /EhPnOcZlVfGYTAbcp/4CqrMYIadP9U6RD1rvIc0YkSvLxc3rN11gfIEjSziHrFLF9
	 PmPMP9jGOX1MNBE0hU/XUTsNZCE0IzGN06cpvqia+NCpZCvtq1yjKfGU2F2MNWSznc
	 gsy7x+1Ul76Vw==
Date: Tue, 3 Sep 2024 09:13:48 +0100
From: Will Deacon <will@kernel.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	catalin.marinas@arm.com, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
	vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
	peterz@infradead.org, arnd@arndb.de, lenb@kernel.org,
	mark.rutland@arm.com, harisokn@amazon.com, mtosatti@redhat.com,
	sudeep.holla@arm.com, cl@gentwo.org, misono.tomohiro@fujitsu.com,
	maobibo@loongson.cn, joao.m.martins@oracle.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 09/10] arm64: support cpuidle-haltpoll
Message-ID: <20240903081348.GB12270@willie-the-truck>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
 <20240830222844.1601170-10-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830222844.1601170-10-ankur.a.arora@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Aug 30, 2024 at 03:28:43PM -0700, Ankur Arora wrote:
> Add architectural support for cpuidle-haltpoll driver by defining
> arch_haltpoll_*().
> 
> Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
> selected, and given that we have an optimized polling mechanism
> in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.
> 
> smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
> a memory region in exclusive state and the WFE waiting for any
> stores to it.
> 
> In the edge case -- no CPU stores to the waited region and there's no
> interrupt -- the event-stream will provide the terminating condition
> ensuring we don't wait forever, but because the event-stream runs at
> a fixed frequency (configured at 10kHz) we might spend more time in
> the polling stage than specified by cpuidle_poll_time().
> 
> This would only happen in the last iteration, since overshooting the
> poll_limit means the governor moves out of the polling stage.
> 
> Tested-by: Haris Okanovic <harisokn@amazon.com>
> Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  arch/arm64/Kconfig                        | 10 ++++++++++
>  arch/arm64/include/asm/cpuidle_haltpoll.h | 10 ++++++++++
>  arch/arm64/kernel/Makefile                |  1 +
>  arch/arm64/kernel/cpuidle_haltpoll.c      | 22 ++++++++++++++++++++++
>  4 files changed, 43 insertions(+)
>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>  create mode 100644 arch/arm64/kernel/cpuidle_haltpoll.c
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index a2f8ff354ca6..9bd93ce2f9d9 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -36,6 +36,7 @@ config ARM64
>  	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>  	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>  	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
> +	select ARCH_HAS_OPTIMIZED_POLL
>  	select ARCH_HAS_PTE_DEVMAP
>  	select ARCH_HAS_PTE_SPECIAL
>  	select ARCH_HAS_HW_PTE_YOUNG
> @@ -2385,6 +2386,15 @@ config ARCH_HIBERNATION_HEADER
>  config ARCH_SUSPEND_POSSIBLE
>  	def_bool y
>  
> +config ARCH_CPUIDLE_HALTPOLL
> +	bool "Enable selection of the cpuidle-haltpoll driver"
> +	default n

nit: this 'default n' line is redundant.

> +	help
> +	  cpuidle-haltpoll allows for adaptive polling based on
> +	  current load before entering the idle state.
> +
> +	  Some virtualized workloads benefit from using it.

nit: This sentence is meaningless ^^.

> +
>  endmenu # "Power management options"
>  
>  menu "CPU Power Management"
> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
> new file mode 100644
> index 000000000000..ed615a99803b
> --- /dev/null
> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _ARCH_HALTPOLL_H
> +#define _ARCH_HALTPOLL_H
> +
> +static inline void arch_haltpoll_enable(unsigned int cpu) { }
> +static inline void arch_haltpoll_disable(unsigned int cpu) { }
> +
> +bool arch_haltpoll_want(bool force);
> +#endif
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 2b112f3b7510..bbfb57eda2f1 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -70,6 +70,7 @@ obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
>  obj-$(CONFIG_ARM64_MTE)			+= mte.o
>  obj-y					+= vdso-wrap.o
>  obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
> +obj-$(CONFIG_ARCH_CPUIDLE_HALTPOLL)	+= cpuidle_haltpoll.o
>  
>  # Force dependency (vdso*-wrap.S includes vdso.so through incbin)
>  $(obj)/vdso-wrap.o: $(obj)/vdso/vdso.so
> diff --git a/arch/arm64/kernel/cpuidle_haltpoll.c b/arch/arm64/kernel/cpuidle_haltpoll.c
> new file mode 100644
> index 000000000000..63fc5ebca79b
> --- /dev/null
> +++ b/arch/arm64/kernel/cpuidle_haltpoll.c
> @@ -0,0 +1,22 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/kernel.h>
> +#include <clocksource/arm_arch_timer.h>
> +#include <asm/cpuidle_haltpoll.h>
> +
> +bool arch_haltpoll_want(bool force)
> +{
> +	/*
> +	 * Enabling haltpoll requires two things:
> +	 *
> +	 * - Event stream support to provide a terminating condition to the
> +	 *   WFE in the poll loop.
> +	 *
> +	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_disable().
> +	 *
> +	 * Given that the second is missing, allow haltpoll to only be force
> +	 * loaded.
> +	 */
> +	return (arch_timer_evtstrm_available() && false) || force;
> +}
> +EXPORT_SYMBOL_GPL(arch_haltpoll_want);

This seems a bit over-the-top to justify a new C file. Just have a static
inline in the header which returns 'force'. The '&& false' is misleading
and unnecessary with the comment.

Will

