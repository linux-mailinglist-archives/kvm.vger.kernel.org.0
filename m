Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C017105AD9
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 21:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKUULU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 15:11:20 -0500
Received: from 2.mo4.mail-out.ovh.net ([46.105.72.36]:44430 "EHLO
        2.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUULU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 15:11:20 -0500
X-Greylist: delayed 11994 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2019 15:11:19 EST
Received: from player694.ha.ovh.net (unknown [10.108.35.59])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id B5EA921417B
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 17:35:19 +0100 (CET)
Received: from kaod.org (deibp9eh1--blueice1n4.emea.ibm.com [195.212.29.166])
        (Authenticated sender: clg@kaod.org)
        by player694.ha.ovh.net (Postfix) with ESMTPSA id 79604C51FA12;
        Thu, 21 Nov 2019 16:35:04 +0000 (UTC)
Subject: Re: [PATCH 5/5] spapr: Work around spurious warnings from vfio INTx
 initialization
To:     David Gibson <david@gibson.dropbear.id.au>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     groug@kaod.org, philmd@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, Riku Voipio <riku.voipio@iki.fi>,
        =?UTF-8?Q?Marc-Andr=c3=a9_Lureau?= <marcandre.lureau@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
References: <20191121005607.274347-1-david@gibson.dropbear.id.au>
 <20191121005607.274347-6-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <0819835c-c066-af2f-79dd-a094d4d281ae@kaod.org>
Date:   Thu, 21 Nov 2019 17:35:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191121005607.274347-6-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13602841201740909557
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddgledvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdqfffguegfifdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpudelhedrvdduvddrvdelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrheileegrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/2019 01:56, David Gibson wrote:
> Traditional PCI INTx for vfio devices can only perform well if using
> an in-kernel irqchip.  Therefore, vfio_intx_update() issues a warning
> if an in kernel irqchip is not available.
> 
> We usually do have an in-kernel irqchip available for pseries machines
> on POWER hosts.  However, because the platform allows feature
> negotiation of what interrupt controller model to use, we don't
> currently initialize it until machine reset.  vfio_intx_update() is
> called (first) from vfio_realize() before that, so it can issue a
> spurious warning, even if we will have an in kernel irqchip by the
> time we need it.
> 
> To workaround this, make a call to spapr_irq_update_active_intc() from
> spapr_irq_init() which is called at machine realize time, before the
> vfio realize.  This call will be pretty much obsoleted by the later
> call at reset time, but it serves to suppress the spurious warning
> from VFIO.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

> ---
>  hw/ppc/spapr_irq.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
> index 1d27034962..d6bb7fd2d6 100644
> --- a/hw/ppc/spapr_irq.c
> +++ b/hw/ppc/spapr_irq.c
> @@ -373,6 +373,14 @@ void spapr_irq_init(SpaprMachineState *spapr, Error **errp)
>  
>      spapr->qirqs = qemu_allocate_irqs(spapr_set_irq, spapr,
>                                        smc->nr_xirqs + SPAPR_XIRQ_BASE);
> +
> +    /*
> +     * Mostly we don't actually need this until reset, except that not
> +     * having this set up can cause VFIO devices to issue a
> +     * false-positive warning during realize(), because they don't yet
> +     * have an in-kernel irq chip.
> +     */
> +    spapr_irq_update_active_intc(spapr);
>  }
>  
>  int spapr_irq_claim(SpaprMachineState *spapr, int irq, bool lsi, Error **errp)
> @@ -528,7 +536,8 @@ void spapr_irq_update_active_intc(SpaprMachineState *spapr)
>           * this.
>           */
>          new_intc = SPAPR_INTC(spapr->xive);
> -    } else if (spapr_ovec_test(spapr->ov5_cas, OV5_XIVE_EXPLOIT)) {
> +    } else if (spapr->ov5_cas
> +               && spapr_ovec_test(spapr->ov5_cas, OV5_XIVE_EXPLOIT)) {
>          new_intc = SPAPR_INTC(spapr->xive);
>      } else {
>          new_intc = SPAPR_INTC(spapr->ics);
> 

