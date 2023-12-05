Return-Path: <kvm+bounces-3516-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D65805179
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 12:03:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7579B20C07
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 11:03:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA1B53818;
	Tue,  5 Dec 2023 11:03:36 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 886C49A
	for <kvm@vger.kernel.org>; Tue,  5 Dec 2023 03:03:32 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E040F139F;
	Tue,  5 Dec 2023 03:04:18 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.42.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C7E03F5A1;
	Tue,  5 Dec 2023 03:03:30 -0800 (PST)
Date: Tue, 5 Dec 2023 11:03:16 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v3 0/3] arm64: Drop support for VPIPT i-cache policy
Message-ID: <ZW8DXGQCSWO1wB2m@FVFF77S0Q05N>
References: <20231204143606.1806432-1-maz@kernel.org>
 <ZW3l6Bq7ortEGB8I@FVFF77S0Q05N>
 <86h6kxbz8u.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86h6kxbz8u.wl-maz@kernel.org>

On Mon, Dec 04, 2023 at 06:26:25PM +0000, Marc Zyngier wrote:
> On Mon, 04 Dec 2023 14:44:56 +0000,
> Mark Rutland <mark.rutland@arm.com> wrote:
> > 
> > On Mon, Dec 04, 2023 at 02:36:03PM +0000, Marc Zyngier wrote:
> > > ARMv8.2 introduced support for VPIPT i-caches, the V standing for
> > > VMID-tagged. Although this looked like a reasonable idea, no
> > > implementation has ever made it into the wild.
> > > 
> > > Linux has supported this for over 6 years (amusingly, just as the
> > > architecture was dropping support for AIVIVT i-caches), but we had no
> > > way to even test it, and it is likely that this code was just
> > > bit-rotting.
> > > 
> > > However, in a recent breakthrough (XML drop 2023-09, tagged as
> > > d55f5af8e09052abe92a02adf820deea2eaed717), the architecture has
> > > finally been purged of this option, making VIPT and PIPT the only two
> > > valid options.
> > > 
> > > This really means this code is just dead code. Nobody will ever come
> > > up with such an implementation, and we can just get rid of it.
> > > 
> > > Most of the impact is on KVM, where we drop a few large comment blocks
> > > (and a bit of code), while the core arch code loses the detection code
> > > itself.
> > > 
> > > * From v2:
> > >   - Fix reserved naming for RESERVED_AIVIVT
> > >   - Collected RBs from Anshuman an Zenghui
> > > 
> > > Marc Zyngier (3):
> > >   KVM: arm64: Remove VPIPT I-cache handling
> > >   arm64: Kill detection of VPIPT i-cache policy
> > >   arm64: Rename reserved values for CTR_EL0.L1Ip
> > 
> > For the series:
> > 
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> 
> Thanks.
> 
> > Looking forward, we can/should probably replace __icache_flags with a single
> > ICACHE_NOALIASING or ICACHE_PIPT cpucap, which'd get rid of a bunch of
> > duplicated logic and make that more sound in the case of races around cpu
> > onlining.
> 
> As long as we refuse VIPT CPUs coming up late (i.e. after we have
> patched the kernel to set ICACHE_PIPT), it should be doable. I guess
> we already have this restriction as userspace is able to probe the
> I-cache policy anyway.
> 
> How about the patch below (tested in a guest with a bunch of hacks to
> expose different L1Ip values)?

That's roughly what I was thinking; the diff looks good, minor comments below.

> 
> Thanks,
> 
> 	M.
> 
> From 8f88afb0b317213dcbf18ea460a508bfccc18568 Mon Sep 17 00:00:00 2001
> From: Marc Zyngier <maz@kernel.org>
> Date: Mon, 4 Dec 2023 18:09:40 +0000
> Subject: [PATCH] arm64: Make icache detection a cpu capability
> 
> Now that we only have two icache policies, we are in a good position
> to make the whole detection business more robust.
> 
> Let's replace __icache_flags by a single capability (ICACHE_PIPT),
> and use this if all CPUs are indeed PIPT. It means we can rely on
> existing logic to mandate that a VIPT CPU coming up late will be
> denied booting, which is the safe thing to do.
> 
> This also leads to some nice cleanups in pKVM, and KVM as a whole
> can use ARM64_ICACHE_PIPT as a final cap.
> 
> Suggested-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/cache.h   |  9 ++-------
>  arch/arm64/include/asm/kvm_hyp.h |  1 -
>  arch/arm64/include/asm/kvm_mmu.h |  2 +-
>  arch/arm64/kernel/cpufeature.c   |  7 +++++++
>  arch/arm64/kernel/cpuinfo.c      | 34 --------------------------------
>  arch/arm64/kvm/arm.c             |  1 -
>  arch/arm64/kvm/hyp/nvhe/pkvm.c   |  3 ---
>  arch/arm64/tools/cpucaps         |  1 +
>  arch/arm64/tools/sysreg          |  2 +-
>  9 files changed, 12 insertions(+), 48 deletions(-)

Nice diffstat!

[...]

>  /*
>   * Whilst the D-side always behaves as PIPT on AArch64, aliasing is
>   * permitted in the I-cache.
>   */
>  static inline int icache_is_aliasing(void)
>  {
> -	return test_bit(ICACHEF_ALIASING, &__icache_flags);
> +	return !cpus_have_cap(ARM64_ICACHE_PIPT);
>  }

It might be nicer to use alternative_has_cap_{likely,unlikely}(...) for
consistency with other cap checks, though that won't matter for hyp code and I
don't think the likely/unlikely part particularly matters either.

[...]

> -static void cpuinfo_detect_icache_policy(struct cpuinfo_arm64 *info)
> -{
> -	unsigned int cpu = smp_processor_id();
> -	u32 l1ip = CTR_L1IP(info->reg_ctr);
> -
> -	switch (l1ip) {
> -	case CTR_EL0_L1Ip_PIPT:
> -		break;
> -	case CTR_EL0_L1Ip_VIPT:
> -	default:
> -		/* Assume aliasing */
> -		set_bit(ICACHEF_ALIASING, &__icache_flags);
> -		break;
> -	}
> -
> -	pr_info("Detected %s I-cache on CPU%d\n", icache_policy_str(l1ip), cpu);
> -}

Not printing this for each CPU is a nice bonus!

[...]

> diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
> index c5af75b23187..db8c96841138 100644
> --- a/arch/arm64/tools/sysreg
> +++ b/arch/arm64/tools/sysreg
> @@ -2003,7 +2003,7 @@ Field	28	IDC
>  Field	27:24	CWG
>  Field	23:20	ERG
>  Field	19:16	DminLine
> -Enum	15:14	L1Ip
> +UnsignedEnum	15:14	L1Ip
>  	# This was named as VPIPT in the ARM but now documented as reserved
>  	0b00	RESERVED_VPIPT
>  	# This is named as AIVIVT in the ARM but documented as reserved

I was initially surprised by the use of UnsignedEnum, but given PIPT is 0b11, I
can see that works. Otherwise, we can keep this as an enum and use a helper
that checks for an exact match.

Mark.

