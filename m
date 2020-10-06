Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB262853DA
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 23:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727525AbgJFV0Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 17:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727334AbgJFV0Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 17:26:24 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FFBC061755;
        Tue,  6 Oct 2020 14:26:24 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602019582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9tgJmD3H+kQvwmmqg/DvlciSq+QY0pyLjKsrBXUuu/A=;
        b=cFZqIT7fnWiav7/ztiQ2eAZrNezy6ROUKWOKBglQIHXDFoiq3KUUqCJCc5Wp39X9/Eg/h+
        6DlYgVyjN9FUH/Z/swKRJ1r9WHK9/Wat8PDyz7jVThsRanPge08+fbZnY5oRymbD0eP6LT
        GsTabN4RzNPO0qgLhRxj8CmGRqE9UfFtO/PefUZd0Zis2ykaWtmw7jeg/rJEisMmQ726XB
        wHaOtOeTMSTZZD/TiVsJZGOGS8qcn/VaFUWw7A1ns2jX5CHxYeLPonhKtSMFIbgTUSP4fZ
        FTk2JISn0dEb5Ni3gQJz9230XCZuzW8A21AOyPT5rCiS+K4ngwGaMp28rWdfCg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602019582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9tgJmD3H+kQvwmmqg/DvlciSq+QY0pyLjKsrBXUuu/A=;
        b=icOFZZbqoBxXqalrREJjpN5TJ4yXrK7d43bToBL6O7AO9brurovFGjOxPaxYzqSMXBxJMR
        QbIvBKtz5ojRUsBQ==
To:     David Woodhouse <dwmw2@infradead.org>, x86@kernel.org
Cc:     iommu <iommu@lists.linux-foundation.org>,
        kvm <kvm@vger.kernel.org>, linux-hyperv@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 07/13] irqdomain: Add max_affinity argument to irq_domain_alloc_descs()
In-Reply-To: <20201005152856.974112-7-dwmw2@infradead.org>
References: <77e64f977f559412f62b467fd062d051ea288f14.camel@infradead.org> <20201005152856.974112-1-dwmw2@infradead.org> <20201005152856.974112-7-dwmw2@infradead.org>
Date:   Tue, 06 Oct 2020 23:26:22 +0200
Message-ID: <87lfgj59mp.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 05 2020 at 16:28, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> This is the maximum possible set of CPUs which can be used. Use it
> to calculate the default affinity requested from __irq_alloc_descs()
> by first attempting to find the intersection with irq_default_affinity,
> or falling back to using just the max_affinity if the intersection
> would be empty.

And why do we need that as yet another argument?

This is an optional property of the irq domain, really and no caller has
any business with that. 

>  int irq_domain_alloc_descs(int virq, unsigned int cnt, irq_hw_number_t hwirq,
> -			   int node, const struct irq_affinity_desc *affinity)
> +			   int node, const struct irq_affinity_desc *affinity,
> +			   const struct cpumask *max_affinity)
>  {
> +	cpumask_var_t default_affinity;
>  	unsigned int hint;
> +	int i;
> +
> +	/* Check requested per-IRQ affinities are in the possible range */
> +	if (affinity && max_affinity) {
> +		for (i = 0; i < cnt; i++)
> +			if (!cpumask_subset(&affinity[i].mask, max_affinity))
> +				return -EINVAL;

https://lore.kernel.org/r/alpine.DEB.2.20.1701171956290.3645@nanos

What is preventing the affinity spreading code from spreading the masks
out to unusable CPUs? The changelog is silent about that part.

> +	/*
> +	 * Generate default affinity. Either the possible subset of
> +	 * irq_default_affinity if such a subset is non-empty, or fall
> +	 * back to the provided max_affinity if there is no intersection.
..
> +	 * And just a copy of irq_default_affinity in the
> +	 * !CONFIG_CPUMASK_OFFSTACK case.

We know that already...

> +	 */
> +	memset(&default_affinity, 0, sizeof(default_affinity));

Right, memset() before allocating is useful.

> +	if ((max_affinity &&
> +	     !cpumask_subset(irq_default_affinity, max_affinity))) {
> +		if (!alloc_cpumask_var(&default_affinity, GFP_KERNEL))
> +			return -ENOMEM;
> +		cpumask_and(default_affinity, max_affinity,
> +			    irq_default_affinity);
> +		if (cpumask_empty(default_affinity))
> +			cpumask_copy(default_affinity, max_affinity);
> +	} else if (cpumask_available(default_affinity))
> +		cpumask_copy(default_affinity, irq_default_affinity);

That's garbage and unreadable.

Thanks,

        tglx
