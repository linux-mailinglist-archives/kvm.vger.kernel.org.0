Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9982D7C0
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 10:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfE2I0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 May 2019 04:26:42 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:40662 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726057AbfE2I0m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 May 2019 04:26:42 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D98F580D;
        Wed, 29 May 2019 01:26:41 -0700 (PDT)
Received: from [10.37.8.255] (unknown [10.37.8.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2030D3F5AF;
        Wed, 29 May 2019 01:26:37 -0700 (PDT)
Subject: Re: [PATCH v2 09/15] arm64: KVM: add support to save/restore SPE
 profiling buffer controls
To:     Sudeep Holla <sudeep.holla@arm.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>
References: <20190523103502.25925-1-sudeep.holla@arm.com>
 <20190523103502.25925-10-sudeep.holla@arm.com>
From:   Julien Thierry <julien.thierry@arm.com>
Message-ID: <fbd9f15d-2322-5808-de62-9e1010c9c961@arm.com>
Date:   Wed, 29 May 2019 09:26:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190523103502.25925-10-sudeep.holla@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sudeep,

On 05/23/2019 11:34 AM, Sudeep Holla wrote:
> Currently since we don't support profiling using SPE in the guests,
> we just save the PMSCR_EL1, flush the profiling buffers and disable
> sampling. However in order to support simultaneous sampling both in
> the host and guests, we need to save and reatore the complete SPE
> profiling buffer controls' context.
> 
> Let's add the support for the same and keep it disabled for now.
> We can enable it conditionally only if guests are allowed to use
> SPE.
> 
> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> ---
>  arch/arm64/kvm/hyp/debug-sr.c | 44 ++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
> index a2714a5eb3e9..a4e6eaf5934f 100644
> --- a/arch/arm64/kvm/hyp/debug-sr.c
> +++ b/arch/arm64/kvm/hyp/debug-sr.c
> @@ -66,7 +66,8 @@
>  	default:	write_debug(ptr[0], reg, 0);			\
>  	}
>  
> -static void __hyp_text __debug_save_spe_nvhe(struct kvm_cpu_context *ctxt)
> +static void __hyp_text
> +__debug_save_spe_nvhe(struct kvm_cpu_context *ctxt, bool full_ctxt)

Rather that add a boolean to just indicate "do more stuff" I'd suggest
having two separate functions.

Also this would be an opportunity to fix the naming of this function
which doesn't just save sve context, it also flushes the context and
disables it.

So maybe have a: void __debug_spe_flush_ctx(struct kvm_cpu_context *ctx);

Maybe adapt the name to make it understandable that it does save PMSCR.

and void __debug_spe_save_ctx(struct kvm_cpu_context *ctx);

Which would save the registers you save under the full_ctx condition.

Cheers,

Julien
