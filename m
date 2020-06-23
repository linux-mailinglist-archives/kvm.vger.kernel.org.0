Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F302058B3
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 19:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733054AbgFWReV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 13:34:21 -0400
Received: from 2.mo4.mail-out.ovh.net ([46.105.72.36]:58600 "EHLO
        2.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732408AbgFWReV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jun 2020 13:34:21 -0400
X-Greylist: delayed 8399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Jun 2020 13:34:19 EDT
Received: from player798.ha.ovh.net (unknown [10.110.115.113])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 71F7724187E
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 17:08:36 +0200 (CEST)
Received: from kaod.org (lfbn-tou-1-921-245.w86-210.abo.wanadoo.fr [86.210.152.245])
        (Authenticated sender: clg@kaod.org)
        by player798.ha.ovh.net (Postfix) with ESMTPSA id C552413C3C203;
        Tue, 23 Jun 2020 15:08:29 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-95G0011b9a0027-edf8-442a-be60-5d401cd56ded,EED1DA90FC9B795DFFB5AB62ED4F19E3D36D96F8) smtp.auth=clg@kaod.org
Subject: Re: [PATCH] KVM: PPC: Book3S HV: increase KVMPPC_NR_LPIDS on POWER8
 and POWER9
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Paul Mackerras <paulus@samba.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org
References: <20200608115714.1139735-1-clg@kaod.org>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <d73950f5-131a-962c-aea3-ac7e4275b85b@kaod.org>
Date:   Tue, 23 Jun 2020 17:08:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200608115714.1139735-1-clg@kaod.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 1942177340510145415
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudekhedgheekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeefffdvtddugeeifeduuefghfejgfeigeeigeeltedthefgieeiveeuiefhgeefgfenucfkpheptddrtddrtddrtddpkeeirddvuddtrdduhedvrddvgeehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeelkedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/8/20 1:57 PM, Cédric Le Goater wrote:
> POWER8 and POWER9 have 12-bit LPIDs. Change LPID_RSVD to support up to
> (4096 - 2) guests on these processors. POWER7 is kept the same with a
> limitation of (1024 - 2), but it might be time to drop KVM support for
> POWER7.
> 
> Tested with 2048 guests * 4 vCPUs on a witherspoon system with 512G
> RAM and a bit of swap.

For the record, it is possible to run 4094 guests * 4 vCPUs on a POWER9 
system with 1TB. It takes ~5m to boot them all.

CONFIG_NR_IRQS needs to be increased to support 4094 * 4 escalation 
interrupts.

Cheers,

C.


> 
> Signed-off-by: Cédric Le Goater <clg@kaod.org>
> ---
>  arch/powerpc/include/asm/reg.h      | 3 ++-
>  arch/powerpc/kvm/book3s_64_mmu_hv.c | 8 ++++++--
>  2 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
> index 88e6c78100d9..b70bbfb0ea3c 100644
> --- a/arch/powerpc/include/asm/reg.h
> +++ b/arch/powerpc/include/asm/reg.h
> @@ -473,7 +473,8 @@
>  #ifndef SPRN_LPID
>  #define SPRN_LPID	0x13F	/* Logical Partition Identifier */
>  #endif
> -#define   LPID_RSVD	0x3ff		/* Reserved LPID for partn switching */
> +#define   LPID_RSVD_POWER7	0x3ff	/* Reserved LPID for partn switching */
> +#define   LPID_RSVD		0xfff	/* Reserved LPID for partn switching */
>  #define	SPRN_HMER	0x150	/* Hypervisor maintenance exception reg */
>  #define   HMER_DEBUG_TRIG	(1ul << (63 - 17)) /* Debug trigger */
>  #define	SPRN_HMEER	0x151	/* Hyp maintenance exception enable reg */
> diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> index 18aed9775a3c..23035ab2ec50 100644
> --- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
> +++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
> @@ -260,11 +260,15 @@ int kvmppc_mmu_hv_init(void)
>  	if (!mmu_has_feature(MMU_FTR_LOCKLESS_TLBIE))
>  		return -EINVAL;
>  
> -	/* POWER7 has 10-bit LPIDs (12-bit in POWER8) */
>  	host_lpid = 0;
>  	if (cpu_has_feature(CPU_FTR_HVMODE))
>  		host_lpid = mfspr(SPRN_LPID);
> -	rsvd_lpid = LPID_RSVD;
> +
> +	/* POWER8 and above have 12-bit LPIDs (10-bit in POWER7) */
> +	if (cpu_has_feature(CPU_FTR_ARCH_207S))
> +		rsvd_lpid = LPID_RSVD;
> +	else
> +		rsvd_lpid = LPID_RSVD_POWER7;
>  
>  	kvmppc_init_lpid(rsvd_lpid + 1);
>  
> 

