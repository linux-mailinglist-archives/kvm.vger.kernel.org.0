Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3A531529EB
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 12:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbgBELbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 06:31:48 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:58003 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbgBELbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Feb 2020 06:31:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580902306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=42c/rfwZKIH6SIaUlAMnLcET7ffvTl+eXozStSmV6NE=;
        b=CNO5nrlsRQsKtlPZ+tGNngb8NzZ22COcNtY4MZSTbPJsXBVHeGpcIvg18TvMgnnyIqxJxg
        3IIpa880ejH7tJLKMv1X+c2nyw9w6vvG0eJS7hLMFAv5RN+/q3W1AfYqAIIITJ96+2ez2D
        40KCo/9BHFxQB3dA2SHAb7KTmwY7z24=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-Gfn8Fu-VOqCSjNEtqf8QTQ-1; Wed, 05 Feb 2020 06:31:40 -0500
X-MC-Unique: Gfn8Fu-VOqCSjNEtqf8QTQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9340A190D340;
        Wed,  5 Feb 2020 11:31:39 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FDD386CCC;
        Wed,  5 Feb 2020 11:31:35 +0000 (UTC)
Date:   Wed, 5 Feb 2020 12:31:33 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
Message-ID: <20200205123133.34ac71a2.cohuck@redhat.com>
In-Reply-To: <20200203131957.383915-16-borntraeger@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-16-borntraeger@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Feb 2020 08:19:35 -0500
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> From: Michael Mueller <mimu@linux.ibm.com>
> 
> The patch implements interruption injection for the following
> list of interruption types:
> 
>   - I/O
>     __deliver_io (III)
> 
>   - External
>     __deliver_cpu_timer (IEI)
>     __deliver_ckc (IEI)
>     __deliver_emergency_signal (IEI)
>     __deliver_external_call (IEI)
> 
>   - cpu restart
>     __deliver_restart (IRI)

Hm... what do 'III', 'IEI', and 'IRI' stand for?

> 
> The service interrupt is handled in a followup patch.
> 
> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> [fixes]
> ---
>  arch/s390/include/asm/kvm_host.h |  8 +++
>  arch/s390/kvm/interrupt.c        | 93 ++++++++++++++++++++++----------
>  2 files changed, 74 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index a45d10d87a8a..989cea7a5591 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -563,6 +563,14 @@ enum irq_types {
>  #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
>  			    (1UL << IRQ_PEND_MCHK_EX))
>  
> +#define IRQ_PEND_MCHK_REP_MASK (1UL << IRQ_PEND_MCHK_REP)
> +
> +#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \

What does 'II' stand for? Interrupt Injection?

> +			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
> +			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
> +			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
> +			      (1UL << IRQ_PEND_EXT_SERVICE))
> +
>  struct kvm_s390_interrupt_info {
>  	struct list_head list;
>  	u64	type;

(...)

> @@ -1834,7 +1872,8 @@ static void __floating_irq_kick(struct kvm *kvm, u64 type)
>  		break;
>  	case KVM_S390_INT_IO_MIN...KVM_S390_INT_IO_MAX:
>  		if (!(type & KVM_S390_INT_IO_AI_MASK &&
> -		      kvm->arch.gisa_int.origin))
> +		      kvm->arch.gisa_int.origin) ||
> +		      kvm_s390_pv_handle_cpu(dst_vcpu))
>  			kvm_s390_set_cpuflags(dst_vcpu, CPUSTAT_IO_INT);
>  		break;
>  	default:

Looking at this... can you also talk about protected virt vs. exitless
interrupts?

