Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8657298AAC
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 11:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770266AbgJZKsE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 06:48:04 -0400
Received: from foss.arm.com ([217.140.110.172]:34894 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1769871AbgJZKsE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Oct 2020 06:48:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 70FFB101E;
        Mon, 26 Oct 2020 03:48:03 -0700 (PDT)
Received: from [10.57.20.91] (unknown [10.57.20.91])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7DC93F719;
        Mon, 26 Oct 2020 03:48:01 -0700 (PDT)
Subject: Re: [PATCH 3/8] KVM: arm64: Drop useless PAN setting on host EL1 to
 EL2 transition
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-4-maz@kernel.org>
From:   Vladimir Murzin <vladimir.murzin@arm.com>
Message-ID: <8d798f0d-6bf4-ed26-9d40-b9d09bf2954e@arm.com>
Date:   Mon, 26 Oct 2020 10:48:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20201026095116.72051-4-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/26/20 9:51 AM, Marc Zyngier wrote:
> Setting PSTATE.PAN when entering EL2 on nVHE doesn't make much
> sense as this bit only means something for translation regimes
> that include EL0. This obviously isn't the case in the nVHE case,
> so let's drop this setting.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index ff9a0f547b9f..ed27f06a31ba 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -17,8 +17,6 @@ SYM_FUNC_START(__host_exit)
>  
>  	get_host_ctxt	x0, x1
>  
> -	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
> -
>  	/* Store the host regs x2 and x3 */
>  	stp	x2, x3,   [x0, #CPU_XREG_OFFSET(2)]
>  
> 

It was originally introduced in cb96408da4e1 (arm64: KVM: VHE: reset PSTATE.PAN on entry to EL2)
and indeed only applies to VHE (I even remember some attempts to put in under CONFIG_ARM64_VHE).

So, if it helps:
 
    Reviewed-by: Vladimir Murzin <vladimir.murzin@arm.com>

Cheers
Vladimir
