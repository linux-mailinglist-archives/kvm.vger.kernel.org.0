Return-Path: <kvm+bounces-532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 239FD7E0B00
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 23:16:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53F131C210BC
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 22:16:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53FF52421D;
	Fri,  3 Nov 2023 22:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jxvyfrGM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F63C2376B
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 22:16:30 +0000 (UTC)
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CE4D53
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 15:16:28 -0700 (PDT)
Date: Fri, 3 Nov 2023 22:16:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1699049787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=H3/jOLfQWxeMpsE5A2AJR8sMG+CdRlkPOnDTOJYMQmA=;
	b=jxvyfrGMPXL528qtaIf8Eo7ZaCIp5M7CGzKE9OLaAqFJ+kmyCCfWRpX+4NNIjuQKqS9ZGF
	Tm22k2OnfjWnLLNRsjL7xLq2264+lMoCOLBT7VbenwRWL+Bd3glPu+DAyhuy2e8Hh8U7ks
	gfR/hvTYhMlEDLxR/8UDQLBWdMPzo68=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Colton Lewis <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 2/3] KVM: arm64: selftests: Guarantee interrupts are
 handled
Message-ID: <ZUVxNs7q1yRyDq4a@linux.dev>
References: <20231103192915.2209393-1-coltonlewis@google.com>
 <20231103192915.2209393-3-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231103192915.2209393-3-coltonlewis@google.com>
X-Migadu-Flow: FLOW_OUT

Hi Colton,

On Fri, Nov 03, 2023 at 07:29:14PM +0000, Colton Lewis wrote:
> Break up the asm instructions poking daifclr and daifset to handle
> interrupts. R_RBZYL specifies pending interrupts will be handle after
> context synchronization events such as an ISB.
> 
> Introduce a function wrapper for the WFI instruction.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

What's missing from the changelog is that you've spotted an actual bug,
and this is really a bugfix.

> ---
>  tools/testing/selftests/kvm/aarch64/vgic_irq.c    | 12 ++++++------
>  tools/testing/selftests/kvm/include/aarch64/gic.h |  3 +++
>  tools/testing/selftests/kvm/lib/aarch64/gic.c     |  5 +++++
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> index d3bf584d2cc1..85f182704d79 100644
> --- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> +++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
> @@ -269,13 +269,13 @@ static void guest_inject(struct test_args *args,
>  	KVM_INJECT_MULTI(cmd, first_intid, num);
> 
>  	while (irq_handled < num) {
> -		asm volatile("wfi\n"
> -			     "msr daifclr, #2\n"
> -			     /* handle IRQ */
> -			     "msr daifset, #2\n"
> -			     : : : "memory");
> +		gic_wfi();
> +		local_irq_enable();
> +		isb();
> +		/* handle IRQ */

nit: this comment should appear above the isb()

> +		local_irq_disable();
>  	}
> -	asm volatile("msr daifclr, #2" : : : "memory");
> +	local_irq_enable();
> 
>  	GUEST_ASSERT_EQ(irq_handled, num);
>  	for (i = first_intid; i < num + first_intid; i++)
> diff --git a/tools/testing/selftests/kvm/include/aarch64/gic.h b/tools/testing/selftests/kvm/include/aarch64/gic.h
> index 9043eaef1076..f474714e4cb2 100644
> --- a/tools/testing/selftests/kvm/include/aarch64/gic.h
> +++ b/tools/testing/selftests/kvm/include/aarch64/gic.h
> @@ -47,4 +47,7 @@ void gic_irq_clear_pending(unsigned int intid);
>  bool gic_irq_get_pending(unsigned int intid);
>  void gic_irq_set_config(unsigned int intid, bool is_edge);
> 
> +/* Execute a Wait For Interrupt instruction. */
> +void gic_wfi(void);
> +

WFIs have nothing to do with the GIC, they're an instruction supported
by the CPU. I'd just merge the definition and declaration into the
header while you're at it.

So, could you throw something like this in aarch64/processor.h?

static inline void wfi(void)
{
	asm volatile("wfi");
}

-- 
Thanks,
Oliver

