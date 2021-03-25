Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E0373499E6
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 20:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhCYTAC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 15:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhCYS7w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 14:59:52 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A41DC06174A;
        Thu, 25 Mar 2021 11:59:52 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1616698788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T/p64BufgVH9g51vdo+tdjRTIo004u23/9QlrIozmDs=;
        b=Tz9I0ZCzmEcJ0RLWv4hoKx04BqEYq6oH8MBEaejHx534tWCfSODFAFXp96n3GQkUMsFoG1
        r6X9S5Sf8Xy+Qi7IUmU3s+cSXBTY8q6lBOre9EOMr5JPtt+dl9SmV+Gwa2b1xulOLq+NyW
        dHi7TSFcS+eKXobxhdGBnZoF5P9UBpFTE20bRBS0chIq3A95tPYv//HbbLuW8w8A3RQZ6K
        knzBCFnv3XrsYl6SF/a2yhfbM5r/lvhJiD19au5RbsZwvUohe7MoE1bjFTWVt9zkaGQ8Vx
        6YAM3e1uD3AP7tpeu5a7EXaxnopU0G7jhfym5Ne5VUllr0J1oa9+lHaVavwHIg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1616698788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T/p64BufgVH9g51vdo+tdjRTIo004u23/9QlrIozmDs=;
        b=zm2kjDs/iCzE5MKpJJ1nUJ/2rivtSgTWniubBpLqQAw39kWsdPDVZU1Pko+Aom4Bj965YF
        q+h7jShqaTt8mtBA==
To:     Marc Zyngier <maz@kernel.org>, Megha Dey <megha.dey@intel.com>
Cc:     linux-kernel@vger.kernel.org, dave.jiang@intel.com,
        ashok.raj@intel.com, kevin.tian@intel.com, dwmw@amazon.co.uk,
        x86@kernel.org, tony.luck@intel.com, dan.j.williams@intel.com,
        jgg@mellanox.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, alex.williamson@redhat.com,
        bhelgaas@google.com, linux-pci@vger.kernel.org,
        baolu.lu@linux.intel.com, ravi.v.shankar@intel.com
Subject: Re: [Patch V2 08/13] genirq: Set auxiliary data for an interrupt
In-Reply-To: <871rc3rvuc.wl-maz@kernel.org>
References: <1614370277-23235-1-git-send-email-megha.dey@intel.com> <1614370277-23235-9-git-send-email-megha.dey@intel.com> <871rc3rvuc.wl-maz@kernel.org>
Date:   Thu, 25 Mar 2021 19:59:48 +0100
Message-ID: <87im5fvz2z.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 25 2021 at 17:23, Marc Zyngier wrote:
>> +/**
>> + * irq_set_auxdata - Set auxiliary data
>> + * @irq:	Interrupt to update
>> + * @which:	Selector which data to update
>> + * @auxval:	Auxiliary data value
>> + *
>> + * Function to update auxiliary data for an interrupt, e.g. to update data
>> + * which is stored in a shared register or data storage (e.g. IMS).
>> + */
>> +int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val)
>
> This looks to me like a massively generalised version of
> irq_set_irqchip_state(), only without any defined semantics when it
> comes to the 'which' state, making it look like the irqchip version of
> an ioctl.
>
> We also have the irq_set_vcpu_affinity() callback that is used to
> perpetrate all sort of sins (and I have abused this interface more
> than I should admit it).
>
> Can we try and converge on a single interface that allows for
> "side-band state" to be communicated, with documented state?
>
>> +{
>> +	struct irq_desc *desc;
>> +	struct irq_data *data;
>> +	unsigned long flags;
>> +	int res = -ENODEV;
>> +
>> +	desc = irq_get_desc_buslock(irq, &flags, 0);
>> +	if (!desc)
>> +		return -EINVAL;
>> +
>> +	for (data = &desc->irq_data; data; data = irqd_get_parent_data(data)) {
>> +		if (data->chip->irq_set_auxdata) {
>> +			res = data->chip->irq_set_auxdata(data, which, val);
>
> And this is where things can break: because you don't define what
> 'which' is, you can end-up with two stacked layers clashing in their
> interpretation of 'which', potentially doing the wrong thing.
>
> Short of having a global, cross architecture definition of all the
> possible states, this is frankly dodgy.

My bad, I suggested this in the first place.

So what you suggest is to make 'which' an enum and have that in
include/linux/whatever.h so we end up with unique identifiers accross
architectures, irqdomains and whatever, right?

That makes a lot of sense.

Though that leaves the question of the data type for 'val'. While u64 is
probably good enough for most stuff, anything which needs more than that
is left out (again). union as arguments are horrible especially if you
need the counterpart irq_get_auxdata() for which you need a pointer and
then you can't do a forward declaration. Something like this might work
though and avoid to make the pointer business unconditional:

        struct irq_auxdata {
               union {
        	     u64        val;
                     struct foo *foo;
               };
        };

Thanks,

        tglx




