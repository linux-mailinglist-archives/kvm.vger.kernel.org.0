Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A01615BBB7
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 10:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbgBMJb7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 04:31:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49845 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729586AbgBMJb7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 04:31:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581586318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E4cV9ThXgXlizZ8497eGzx0V/2ZNcQLP7ghs+RahG+g=;
        b=eyy2V5eC8m9FRj2DVdNKIXDp74tTxAujehcYsELa3ZTEywdgbN6miXUcTMk4Xv/4AvljV5
        8KhU+f5FpYxAzVCKj3YRW1TBwLGQqNYRRdJmXtKjXLb1P8qXV9dUgFqzYuKRRf5dQtyLWh
        gCTr1PRnjc/6lQ+4sy3vlpZcstz5Juc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-9M9bJ2msMX2lr_oZJ0r8Kg-1; Thu, 13 Feb 2020 04:31:55 -0500
X-MC-Unique: 9M9bJ2msMX2lr_oZJ0r8Kg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E9A261005510;
        Thu, 13 Feb 2020 09:31:53 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A802926E7B;
        Thu, 13 Feb 2020 09:31:49 +0000 (UTC)
Date:   Thu, 13 Feb 2020 10:31:47 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        alexandru.elisei@arm.com, andre.przywara@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state
 check
Message-ID: <20200213093147.2d3o5x5rg7qwykx6@kamzik.brq.redhat.com>
References: <20200211133705.1398-1-drjones@redhat.com>
 <60c6c4c7-1d6b-5b64-adc1-8e96f45332c6@huawei.com>
 <20200211154135.vxxkpstt4cpoyqsp@kamzik.brq.redhat.com>
 <a8876667-934d-f617-682d-c488e7276d38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8876667-934d-f617-682d-c488e7276d38@huawei.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 12, 2020 at 10:57:09AM +0800, Zenghui Yu wrote:
> Hi Drew,
> 
> On 2020/2/11 23:41, Andrew Jones wrote:
> > On Tue, Feb 11, 2020 at 10:50:58PM +0800, Zenghui Yu wrote:
> > > Hi Drew,
> > > 
> > > On 2020/2/11 21:37, Andrew Jones wrote:
> > > > Let's bail out of the wait loop if we see the expected state
> > > > to save over six seconds of run time. Make sure we wait a bit
> > > > before reading the registers and double check again after,
> > > > though, to somewhat mitigate the chance of seeing the expected
> > > > state by accident.
> > > > 
> > > > We also take this opportunity to push more IRQ state code to
> > > > the library.
> > > > 
> > > > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > > 
> > > [...]
> > > 
> > > > +
> > > > +enum gic_irq_state gic_irq_state(int irq)
> > > 
> > > This is a *generic* name while this function only deals with PPI.
> > > Maybe we can use something like gic_ppi_state() instead?  Or you
> > > will have to take all interrupt types into account in a single
> > > function, which is not a easy job I think.
> > 
> > Very good point.
> > 
> > > 
> > > > +{
> > > > +	enum gic_irq_state state;
> > > > +	bool pending = false, active = false;
> > > > +	void *base;
> > > > +
> > > > +	assert(gic_common_ops);
> > > > +
> > > > +	switch (gic_version()) {
> > > > +	case 2:
> > > > +		base = gicv2_dist_base();
> > > > +		pending = readl(base + GICD_ISPENDR) & (1 << PPI(irq));
> > > > +		active = readl(base + GICD_ISACTIVER) & (1 << PPI(irq));
> > > > +		break;
> > > > +	case 3:
> > > > +		base = gicv3_sgi_base();
> > > > +		pending = readl(base + GICR_ISPENDR0) & (1 << PPI(irq));
> > > > +		active = readl(base + GICR_ISACTIVER0) & (1 << PPI(irq));
> > > 
> > > And you may also want to ensure that the 'irq' is valid for PPI().
> > > Or personally, I'd just use a real PPI number (PPI(info->irq)) as
> > > the input parameter of this function.
> > 
> > Indeed, if we want to make this a general function we should require
> > the caller to pass PPI(irq).
> > 
> > > 
> > > > +		break;
> > > > +	}
> > > > +
> > > > +	if (!active && !pending)
> > > > +		state = GIC_IRQ_STATE_INACTIVE;
> > > > +	if (pending)
> > > > +		state = GIC_IRQ_STATE_PENDING;
> > > > +	if (active)
> > > > +		state = GIC_IRQ_STATE_ACTIVE;
> > > > +	if (active && pending)
> > > > +		state = GIC_IRQ_STATE_ACTIVE_PENDING;
> > > > +
> > > > +	return state;
> > > > +}
> > > > 
> > > 
> > > Otherwise,
> > > 
> > > Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
> > > Tested-by: Zenghui Yu <yuzenghui@huawei.com>
> > 
> > Thanks, but I guess I should squash in changes to make this function more
> > general. My GIC/SPI skills are weak, so I'm not sure this is right,
> > especially because the SPI stuff doesn't yet have a user to validate it.
> 
> (I guess the PL031 can be another new user.)
> 
> > However, if all reviewers think it's correct, then I'll squash it into
> > the arm/queue branch. I've added Andre and Eric to help review too.
> > 
> > Thanks,
> > drew
> > 
> > 
> > diff --git a/arm/timer.c b/arm/timer.c
> > index ae5fdbf54b35..44621b4f2967 100644
> > --- a/arm/timer.c
> > +++ b/arm/timer.c
> > @@ -189,9 +189,9 @@ static bool gic_timer_check_state(struct timer_info *info,
> >   	/* Wait for up to 1s for the GIC to sample the interrupt. */
> >   	for (i = 0; i < 10; i++) {
> >   		mdelay(100);
> > -		if (gic_irq_state(info->irq) == expected_state) {
> > +		if (gic_irq_state(PPI(info->irq)) == expected_state) {
> >   			mdelay(100);
> > -			if (gic_irq_state(info->irq) == expected_state)
> > +			if (gic_irq_state(PPI(info->irq)) == expected_state)
> >   				return true;
> >   		}
> >   	}
> > diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> > index 0563b31132c8..3924dd1d1ee6 100644
> > --- a/lib/arm/gic.c
> > +++ b/lib/arm/gic.c
> > @@ -150,22 +150,37 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
> >   enum gic_irq_state gic_irq_state(int irq)
> >   {
> >   	enum gic_irq_state state;
> > -	bool pending = false, active = false;
> > -	void *base;
> > +	void *ispendr, *isactiver;
> > +	bool pending, active;
> >   	assert(gic_common_ops);
> 
> We can also assert that only interrupts with ID smaller than 1020
> will be handled.

Good idea

> 
> >   	switch (gic_version()) {
> >   	case 2:
> > -		base = gicv2_dist_base();
> > -		pending = readl(base + GICD_ISPENDR) & (1 << PPI(irq));
> > -		active = readl(base + GICD_ISACTIVER) & (1 << PPI(irq));
> > +		ispendr = gicv2_dist_base() + GICD_ISPENDR;
> > +		isactiver = gicv2_dist_base() + GICD_ISACTIVER;
> >   		break;
> >   	case 3:
> > -		base = gicv3_sgi_base();
> > -		pending = readl(base + GICR_ISPENDR0) & (1 << PPI(irq));
> > -		active = readl(base + GICR_ISACTIVER0) & (1 << PPI(irq));
> > +		if (irq < GIC_NR_PRIVATE_IRQS) {
> > +			ispendr = gicv3_sgi_base() + GICR_ISPENDR0;
> > +			isactiver = gicv3_sgi_base() + GICR_ISACTIVER0;
> > +		} else {
> > +			ispendr = gicv3_dist_base() + GICD_ISPENDR;
> > +			isactiver = gicv3_dist_base() + GICD_ISACTIVER;
> > +		}
> >   		break;
> > +	default:
> > +		assert(0);
> > +	}
> > +
> > +	if (irq < GIC_NR_PRIVATE_IRQS) {
> > +		pending = readl(ispendr) & (1 << irq);
> > +		active = readl(isactiver) & (1 << irq);
> > +	} else {
> > +		int offset = (irq - GIC_FIRST_SPI) / 32;
> > +		int mask = 1 << ((irq - GIC_FIRST_SPI) % 32);
> 
> No need to minus GIC_FIRST_SPI.  And therefore these two cases
> can actually be merged.

Yup, will do

> 
> > +		pending = readl(ispendr + offset) & mask;
> > +		active = readl(isactiver + offset) & mask;
> >   	}
> >   	if (!active && !pending)
> 
> Otherwise this looks good enough (to me) for now, and let's wait
> other reviewers to comment.  I've used the following diff to give
> the pl031 test a go (roughly written, not dig into PL031 so much),
> it just works fine :)
> 
> 
> Thanks,
> Zenghui
> 
> diff --git a/arm/pl031.c b/arm/pl031.c
> index 86035fa..2d4160f 100644
> --- a/arm/pl031.c
> +++ b/arm/pl031.c
> @@ -118,11 +118,12 @@ static int check_rtc_freq(void)
>  	return 0;
>  }
> 
> -static bool gic_irq_pending(void)
> +static bool gic_pl031_pending(void)
>  {
> -	uint32_t offset = (pl031_irq / 32) * 4;
> +	enum gic_irq_state state = gic_irq_state(pl031_irq);
> 
> -	return readl(gic_ispendr + offset) & (1 << (pl031_irq & 31));
> +	return state == GIC_IRQ_STATE_PENDING ||
> +		state == GIC_IRQ_STATE_ACTIVE_PENDING;

Nice way to test, but I'll leave this change out.

>  }
> 
>  static void gic_irq_unmask(void)
> 
> [...]
> /* replace all gic_irq_pending() with gic_pl031_pending() */
> [...]
> 
> diff --git a/lib/arm/gic.c b/lib/arm/gic.c
> index 3924dd1..34d77e3 100644
> --- a/lib/arm/gic.c
> +++ b/lib/arm/gic.c
> @@ -152,6 +152,7 @@ enum gic_irq_state gic_irq_state(int irq)
>  	enum gic_irq_state state;
>  	void *ispendr, *isactiver;
>  	bool pending, active;
> +	int offset, mask;
> 
>  	assert(gic_common_ops);
> 
> @@ -173,15 +174,10 @@ enum gic_irq_state gic_irq_state(int irq)
>  		assert(0);
>  	}
> 
> -	if (irq < GIC_NR_PRIVATE_IRQS) {
> -		pending = readl(ispendr) & (1 << irq);
> -		active = readl(isactiver) & (1 << irq);
> -	} else {
> -		int offset = (irq - GIC_FIRST_SPI) / 32;
> -		int mask = 1 << ((irq - GIC_FIRST_SPI) % 32);
> -		pending = readl(ispendr + offset) & mask;
> -		active = readl(isactiver + offset) & mask;
> -	}
> +	offset = (irq / 32) * 4;
> +	mask = 1 << (irq % 32);
> +	pending = readl(ispendr + offset) & mask;
> +	active = readl(isactiver + offset) & mask;
> 
>  	if (!active && !pending)
>  		state = GIC_IRQ_STATE_INACTIVE;
>

I'll send a final patch now for review, but I'm pretty happy with this so
I've gone ahead and squashed it into arm/queue already. I kept Alex's
r-b as there shouldn't be any functional change with respect to what
he reviewed.

Thanks,
drew

