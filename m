Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56DE515400C
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 09:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgBFIV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 03:21:58 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56353 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727509AbgBFIV6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Feb 2020 03:21:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580977316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAjbX0lDttlHYIUFJvK+tG33P4SlGtxTHQs/PWfYsrM=;
        b=h/zeQQg9puC/gXsTB8XdXZLrYum7obLIvmOGdOCzmJ/UbrRYyPZKEctFF23pzLAE6cd6rE
        Sn0GeY+QgFIi8QRdt0uq1qmQH2FsMl7w3PWh6AUru1xJVTEmhSgjB/1y/osA8KHIGchfln
        s0AbVTZnYY7XtXLx/pPzEfuHDXEBgME=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-iFnjtePOOjiDDmYWBHAkCA-1; Thu, 06 Feb 2020 03:21:52 -0500
X-MC-Unique: iFnjtePOOjiDDmYWBHAkCA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 415048014D9;
        Thu,  6 Feb 2020 08:21:51 +0000 (UTC)
Received: from gondolin (dhcp-192-195.str.redhat.com [10.33.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43827790CF;
        Thu,  6 Feb 2020 08:21:47 +0000 (UTC)
Date:   Thu, 6 Feb 2020 09:21:44 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFCv2 15/37] KVM: s390: protvirt: Implement interruption
 injection
Message-ID: <20200206092144.616b23b7.cohuck@redhat.com>
In-Reply-To: <d02c7b36-77cc-3bbb-1f2c-dcafa881174c@de.ibm.com>
References: <20200203131957.383915-1-borntraeger@de.ibm.com>
        <20200203131957.383915-16-borntraeger@de.ibm.com>
        <f6980d81-f1a9-10a0-9783-8835eae2c124@redhat.com>
        <2a111d82-c9bf-1714-13fd-3cd726bf7e7a@de.ibm.com>
        <20200205122544.50eb32f1.cohuck@redhat.com>
        <d02c7b36-77cc-3bbb-1f2c-dcafa881174c@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Feb 2020 18:49:45 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 05.02.20 12:25, Cornelia Huck wrote:
> > On Wed, 5 Feb 2020 11:48:42 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> >   
> >> On 05.02.20 10:51, Thomas Huth wrote:  
> >>> On 03/02/2020 14.19, Christian Borntraeger wrote:    
> >>>> From: Michael Mueller <mimu@linux.ibm.com>
> >>>>
> >>>> The patch implements interruption injection for the following
> >>>> list of interruption types:
> >>>>
> >>>>   - I/O
> >>>>     __deliver_io (III)
> >>>>
> >>>>   - External
> >>>>     __deliver_cpu_timer (IEI)
> >>>>     __deliver_ckc (IEI)
> >>>>     __deliver_emergency_signal (IEI)
> >>>>     __deliver_external_call (IEI)
> >>>>
> >>>>   - cpu restart
> >>>>     __deliver_restart (IRI)
> >>>>
> >>>> The service interrupt is handled in a followup patch.
> >>>>
> >>>> Signed-off-by: Michael Mueller <mimu@linux.ibm.com>
> >>>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> >>>> [fixes]
> >>>> ---
> >>>>  arch/s390/include/asm/kvm_host.h |  8 +++
> >>>>  arch/s390/kvm/interrupt.c        | 93 ++++++++++++++++++++++----------
> >>>>  2 files changed, 74 insertions(+), 27 deletions(-)
> >>>>
> >>>> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> >>>> index a45d10d87a8a..989cea7a5591 100644
> >>>> --- a/arch/s390/include/asm/kvm_host.h
> >>>> +++ b/arch/s390/include/asm/kvm_host.h
> >>>> @@ -563,6 +563,14 @@ enum irq_types {
> >>>>  #define IRQ_PEND_MCHK_MASK ((1UL << IRQ_PEND_MCHK_REP) | \
> >>>>  			    (1UL << IRQ_PEND_MCHK_EX))
> >>>>  
> >>>> +#define IRQ_PEND_MCHK_REP_MASK (1UL << IRQ_PEND_MCHK_REP)
> >>>> +
> >>>> +#define IRQ_PEND_EXT_II_MASK ((1UL << IRQ_PEND_EXT_CPU_TIMER)  | \
> >>>> +			      (1UL << IRQ_PEND_EXT_CLOCK_COMP) | \
> >>>> +			      (1UL << IRQ_PEND_EXT_EMERGENCY)  | \
> >>>> +			      (1UL << IRQ_PEND_EXT_EXTERNAL)   | \
> >>>> +			      (1UL << IRQ_PEND_EXT_SERVICE))
> >>>> +
> >>>>  struct kvm_s390_interrupt_info {
> >>>>  	struct list_head list;
> >>>>  	u64	type;
> >>>> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> >>>> index c06c89d370a7..ecdec6960a60 100644
> >>>> --- a/arch/s390/kvm/interrupt.c
> >>>> +++ b/arch/s390/kvm/interrupt.c
> >>>> @@ -387,6 +387,12 @@ static unsigned long deliverable_irqs(struct kvm_vcpu *vcpu)
> >>>>  		__clear_bit(IRQ_PEND_EXT_SERVICE, &active_mask);
> >>>>  	if (psw_mchk_disabled(vcpu))
> >>>>  		active_mask &= ~IRQ_PEND_MCHK_MASK;
> >>>> +	/* PV guest cpus can have a single interruption injected at a time. */
> >>>> +	if (kvm_s390_pv_is_protected(vcpu->kvm) &&
> >>>> +	    vcpu->arch.sie_block->iictl != IICTL_CODE_NONE)
> >>>> +		active_mask &= ~(IRQ_PEND_EXT_II_MASK |
> >>>> +				 IRQ_PEND_IO_MASK |
> >>>> +				 IRQ_PEND_MCHK_REP_MASK);    
> >>>
> >>> I don't quite understand why there is a difference between
> >>> IRQ_PEND_MCHK_REP and IRQ_PEND_MCHK_EX here? Why not simply use
> >>> IRQ_PEND_MCHK_MASK here? Could you elaborate? (and maybe add a sentence
> >>> to the patch description)    
> >>
> >> I added that part. 
> >> My idea was that an exigent machine check would be kind of fatal that it can override
> >> the previous interrupt. Now we do not implement the override (kill the previous interrupt)
> >> so I agree, maybe lets use IRQ_PEND_MCHK_MASK  
> > 
> > This makes me wonder about interrupt priorities in general. Under which
> > circumstances can we have an interrupt with a lower priority already
> > injected (but not delivered) in the injection area when a
> > higher-priority interrupt comes along? I'm a bit confused here.  
> 
> This is not an issue. If the interrupt is already in the injection area, then you can consider
> that as delivered. And even highest priority interrupt cannot overtake an already delivered one.
> 

Ah, ok. That 'override' above made me think it was possible.

