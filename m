Return-Path: <kvm+bounces-29647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF0F49AE86A
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 16:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9304A28FE97
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 14:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFB81F4FD4;
	Thu, 24 Oct 2024 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+PJztDa"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062EB1E3766;
	Thu, 24 Oct 2024 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729779472; cv=none; b=qPw6U5I3L+L1kf92qTwO+t+xm9lDXqAKifbBmbUlGw4cOEwt7+Rsut8GVEHERG8CVq8CswJNeBJq1t1/U9llSuWQcY4ebpTwCZkuUB7lgxo/xuSt29g+cylb32y+O+mB450qrUcfwpnceEnqdd90kb3eq3ox7+rjfrNkFsb65qA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729779472; c=relaxed/simple;
	bh=4uD2k8h2vy1UgxcQ+HHmd+XNAwZMm6TvGvEVPby1hNs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YSnwCd36FHGH7CMW3xrnDW0g2mkUEFktBocht6Jh21g/IXTJNrBeV8qm4P5e6HxIOlWtwtkJEr20fFXqPYbqObmemauwSHRW1IAAPsHqGXyiKkbfAW4DUCloTzNgNg3PoE4/SPRVxmF+MJdhqee3DZCruVznK7/+/TkmCPQ9zg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+PJztDa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18BAC4CEC7;
	Thu, 24 Oct 2024 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729779471;
	bh=4uD2k8h2vy1UgxcQ+HHmd+XNAwZMm6TvGvEVPby1hNs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Z+PJztDa3DLJi8zczBtunJjYtTgbSB/pWYuOXBfkLIyw6TJiCAQ0WRq/AQHNYvMIO
	 ypPUss6EbEuI+coFbJNqOQ7DB+SW8zeDyvxK1TRcGHKz3TKoE8rdW6wGUWGYFTZfzL
	 pqbUZrnT461zBGjqAr82cZ5oVy50OPec5abANxSAzPIpWWUz5lKPIPkuWR2RcW+Ak/
	 Lc6LA81PZMJ5+ZtTF2j46hgvE/ZCfmDp2TRENpjxGGbiUvUVIlIorJpIWJWxPb7jXl
	 4P5XKju/mwmLSgkExTYhQYAm8xCA2feq6F05VCgttXD1PUf43IL0rqbydLFMxZfMKo
	 QUgNloX/6Rwnw==
X-Mailer: emacs 31.0.50 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: Re: [PATCH v5 04/43] arm64: RME: Handle Granule Protection Faults
 (GPFs)
In-Reply-To: <20241004152804.72508-5-steven.price@arm.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-5-steven.price@arm.com>
Date: Thu, 24 Oct 2024 19:47:41 +0530
Message-ID: <yq5a8qudmvp6.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steven Price <steven.price@arm.com> writes:

> If the host attempts to access granules that have been delegated for use
> in a realm these accesses will be caught and will trigger a Granule
> Protection Fault (GPF).
>
> A fault during a page walk signals a bug in the kernel and is handled by
> oopsing the kernel. A non-page walk fault could be caused by user space
> having access to a page which has been delegated to the kernel and will
> trigger a SIGBUS to allow debugging why user space is trying to access a
> delegated page.
>

A non-page walk fault can also be caused by host kernel trying to access a
page which it had delegated before. It would be nice to dump details
like FAR in that case. Right now it shows only the below.

[  285.122310] Internal error: Granule Protection Fault not on table walk: 0000000096000068 [#1] PREEMPT SMP               
[  285.122427] Modules linked in:                                                                                                                                                
[  285.122512] CPU: 1 UID: 0 PID: 217 Comm: kvm-vcpu-0 Not tainted 6.12.0-rc1-00082-g8461d8333829 #42
[  285.122656] Hardware name: FVP Base RevC (DT)
[  285.122733] pstate: 81400009 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
[  285.122871] pc : clear_page+0x18/0x50
[  285.122975] lr : kvm_gmem_get_pfn+0xbc/0x190
[  285.123110] sp : ffff800082cef900
[  285.123182] x29: ffff800082cef910 x28: 0000000090000000 x27: 0000000090000006
.....

-aneesh

>
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v2:
>  * Include missing "Granule Protection Fault at level -1"
> ---
>  arch/arm64/mm/fault.c | 31 +++++++++++++++++++++++++------
>  1 file changed, 25 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index 8b281cf308b3..f9d72a936d48 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -804,6 +804,25 @@ static int do_tag_check_fault(unsigned long far, unsigned long esr,
>  	return 0;
>  }
>  
> +static int do_gpf_ptw(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	const struct fault_info *inf = esr_to_fault_info(esr);
> +
> +	die_kernel_fault(inf->name, far, esr, regs);
> +	return 0;
> +}
> +
> +static int do_gpf(unsigned long far, unsigned long esr, struct pt_regs *regs)
> +{
> +	const struct fault_info *inf = esr_to_fault_info(esr);
> +
> +	if (!is_el1_instruction_abort(esr) && fixup_exception(regs))
> +		return 0;
> +
> +	arm64_notify_die(inf->name, regs, inf->sig, inf->code, far, esr);
> +	return 0;
> +}
> +
>  static const struct fault_info fault_info[] = {
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"ttbr address size fault"	},
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"level 1 address size fault"	},
> @@ -840,12 +859,12 @@ static const struct fault_info fault_info[] = {
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 32"			},
>  	{ do_alignment_fault,	SIGBUS,  BUS_ADRALN,	"alignment fault"		},
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 34"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 35"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 36"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 37"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 38"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 39"			},
> -	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 40"			},
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level -1" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 0" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 1" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 2" },
> +	{ do_gpf_ptw,		SIGKILL, SI_KERNEL,	"Granule Protection Fault at level 3" },
> +	{ do_gpf,		SIGBUS,  SI_KERNEL,	"Granule Protection Fault not on table walk" },
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"level -1 address size fault"	},
>  	{ do_bad,		SIGKILL, SI_KERNEL,	"unknown 42"			},
>  	{ do_translation_fault,	SIGSEGV, SEGV_MAPERR,	"level -1 translation fault"	},
> -- 
> 2.34.1

