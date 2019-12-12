Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62F3211C90A
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 10:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfLLJXO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 04:23:14 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:53963 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbfLLJXO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Dec 2019 04:23:14 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifKgi-0006Yn-9w; Thu, 12 Dec 2019 10:23:12 +0100
To:     Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH 3/3] kvm/arm: Standardize kvm exit reason field
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 12 Dec 2019 09:23:11 +0000
From:   Marc Zyngier <maz@kernel.org>
Cc:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <rkrcmar@redhat.com>,
        <paulus@ozlabs.org>, <jhogan@kernel.org>, <drjones@redhat.com>,
        <vkuznets@redhat.com>
In-Reply-To: <20191212024512.39930-4-gshan@redhat.com>
References: <20191212024512.39930-4-gshan@redhat.com>
Message-ID: <2e960d77afc7ac75f1be73a56a9aca66@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: gshan@redhat.com, kvm@vger.kernel.org, pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org, jhogan@kernel.org, drjones@redhat.com, vkuznets@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Gavin,

On 2019-12-12 02:45, Gavin Shan wrote:
> This standardizes kvm exit reason field name by replacing "esr_ec"
> with "exit_reason".
>
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>  virt/kvm/arm/trace.h | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/virt/kvm/arm/trace.h b/virt/kvm/arm/trace.h
> index 204d210d01c2..0ac774fd324d 100644
> --- a/virt/kvm/arm/trace.h
> +++ b/virt/kvm/arm/trace.h
> @@ -27,25 +27,27 @@ TRACE_EVENT(kvm_entry,
>  );
>
>  TRACE_EVENT(kvm_exit,
> -	TP_PROTO(int ret, unsigned int esr_ec, unsigned long vcpu_pc),
> -	TP_ARGS(ret, esr_ec, vcpu_pc),
> +	TP_PROTO(int ret, unsigned int exit_reason, unsigned long vcpu_pc),
> +	TP_ARGS(ret, exit_reason, vcpu_pc),
>
>  	TP_STRUCT__entry(
>  		__field(	int,		ret		)
> -		__field(	unsigned int,	esr_ec		)
> +		__field(	unsigned int,	exit_reason	)

I don't think the two are the same thing. The exit reason should be
exactly that: why has the guest exited (exception, host interrupt, 
trap).

What we're reporting here is the exception class, which doesn't apply 
to
interrupts, for example (hence the 0 down below, which we treat as a
catch-all).

>  		__field(	unsigned long,	vcpu_pc		)
>  	),
>
>  	TP_fast_assign(
>  		__entry->ret			= ARM_EXCEPTION_CODE(ret);
> -		__entry->esr_ec = ARM_EXCEPTION_IS_TRAP(ret) ? esr_ec : 0;
> +		__entry->exit_reason =
> +			ARM_EXCEPTION_IS_TRAP(ret) ? exit_reason: 0;
>  		__entry->vcpu_pc		= vcpu_pc;
>  	),
>
>  	TP_printk("%s: HSR_EC: 0x%04x (%s), PC: 0x%08lx",
>  		  __print_symbolic(__entry->ret, kvm_arm_exception_type),
> -		  __entry->esr_ec,
> -		  __print_symbolic(__entry->esr_ec, kvm_arm_exception_class),
> +		  __entry->exit_reason,
> +		  __print_symbolic(__entry->exit_reason,
> +				   kvm_arm_exception_class),
>  		  __entry->vcpu_pc)
>  );

The last thing is whether such a change is an ABI change or not. I've 
been very
reluctant to change any of this for that reason.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
