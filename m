Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3392A2FC8
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 17:27:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgKBQ1b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 11:27:31 -0500
Received: from foss.arm.com ([217.140.110.172]:33842 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726868AbgKBQ1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Nov 2020 11:27:31 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54BC931B;
        Mon,  2 Nov 2020 08:27:30 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 802183F719;
        Mon,  2 Nov 2020 08:27:29 -0800 (PST)
Subject: Re: [PATCH 8/8] KVM: arm64: Avoid repetitive stack access on host EL1
 to EL2 exception
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     kernel-team@android.com, Will Deacon <will@kernel.org>
References: <20201026095116.72051-1-maz@kernel.org>
 <20201026095116.72051-9-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <e4fa81b4-1071-e41c-7cc2-62c8116e28ba@arm.com>
Date:   Mon, 2 Nov 2020 16:28:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026095116.72051-9-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 10/26/20 9:51 AM, Marc Zyngier wrote:
> Registers x0/x1 get repeateadly pushed and poped during a host
> HVC call. Instead, leave the registers on the stack, saving
> a store instruction on the fast path for an add on the slow path.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/hyp/nvhe/host.S | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
> index e2d316d13180..7b69f9ff8da0 100644
> --- a/arch/arm64/kvm/hyp/nvhe/host.S
> +++ b/arch/arm64/kvm/hyp/nvhe/host.S
> @@ -13,8 +13,6 @@
>  	.text
>  
>  SYM_FUNC_START(__host_exit)
> -	stp	x0, x1, [sp, #-16]!
> -
>  	get_host_ctxt	x0, x1
>  
>  	/* Store the host regs x2 and x3 */
> @@ -99,13 +97,14 @@ SYM_FUNC_END(__hyp_do_panic)
>  	mrs	x0, esr_el2
>  	lsr	x0, x0, #ESR_ELx_EC_SHIFT
>  	cmp	x0, #ESR_ELx_EC_HVC64
> -	ldp	x0, x1, [sp], #16
> +	ldp	x0, x1, [sp]		// Don't fixup the stack yet

If I understand get_host_ctxt correctly, it will clobber x0 and x1, and this is
the first thing that __host_exit does. I think that the values of x0 and x1 are
only needed in host_el1_sync_vect: x0 to compare with HVC_STUB_HCALL_NR below, and
x1 for the call to __kvm_handle_stub_hvc. I was thinking that we can restore x0
just before the comparison with HVC_STUB_HCALL_NR, after the first branch to
__host_exit, to make it clear that it is not used by __host_exit. Not really
important, but it might make the code a bit easier to understand (it looks a bit
weird to me to have x0, x1 clobbered immediately after we restore them from the
stack).

Either way you prefer, the code looks correct to me: __host_exit assumes that x0
and x1 are at the top of the stack when it saves them, and the ADD in
host_el1_sync_vect (when the code doesn't branch to __host_exit) makes sure the
stack pointer is as expected:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,

Alex

>  	b.ne	__host_exit
>  
>  	/* Check for a stub HVC call */
>  	cmp	x0, #HVC_STUB_HCALL_NR
>  	b.hs	__host_exit
>  
> +	add	sp, sp, #16
>  	/*
>  	 * Compute the idmap address of __kvm_handle_stub_hvc and
>  	 * jump there. Since we use kimage_voffset, do not use the
