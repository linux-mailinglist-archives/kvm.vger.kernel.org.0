Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B790E105A1E
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 20:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKUTBb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 14:01:31 -0500
Received: from 5.mo177.mail-out.ovh.net ([46.105.39.154]:55939 "EHLO
        5.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKUTBa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 14:01:30 -0500
X-Greylist: delayed 8769 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Nov 2019 14:01:30 EST
Received: from player759.ha.ovh.net (unknown [10.109.159.62])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 52489114D98
        for <kvm@vger.kernel.org>; Thu, 21 Nov 2019 17:35:20 +0100 (CET)
Received: from kaod.org (deibp9eh1--blueice1n4.emea.ibm.com [195.212.29.166])
        (Authenticated sender: clg@kaod.org)
        by player759.ha.ovh.net (Postfix) with ESMTPSA id 30959C6C33A6;
        Thu, 21 Nov 2019 16:35:03 +0000 (UTC)
Subject: Re: [PATCH 4/5] spapr: Handle irq backend changes with VFIO PCI
 devices
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
 <20191121005607.274347-5-david@gibson.dropbear.id.au>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Message-ID: <30d4fd1d-61f7-ebe2-a593-0917d187cab5@kaod.org>
Date:   Thu, 21 Nov 2019 17:35:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191121005607.274347-5-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 13603122676374014965
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrudehvddgleefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdqfffguegfifdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucfkpheptddrtddrtddrtddpudelhedrvdduvddrvdelrdduieeinecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejheelrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedu
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/11/2019 01:56, David Gibson wrote:
> pseries machine type can have one of two different interrupt controllers in
> use depending on feature negotiation with the guest.  Usually this is
> invisible to devices, because they route to a common set of qemu_irqs which
> in turn dispatch to the correct back end.
> 
> VFIO passthrough devices, however, wire themselves up directly to the KVM
> irqchip for performance, which means they are affected by this change in
> interrupt controller.  To get them to adjust correctly for the change in
> irqchip, we need to fire the kvm irqchip change notifier.
> 
> Cc: Alex Williamson <alex.williamson@redhat.com>
> Cc: Alexey Kardashevskiy <aik@ozlabs.ru>
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>


Reviewed-by: Cédric Le Goater <clg@kaod.org>

> ---
>  hw/ppc/spapr_irq.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
> index 168044be85..1d27034962 100644
> --- a/hw/ppc/spapr_irq.c
> +++ b/hw/ppc/spapr_irq.c
> @@ -508,6 +508,12 @@ static void set_active_intc(SpaprMachineState *spapr,
>      }
>  
>      spapr->active_intc = new_intc;
> +
> +    /*
> +     * We've changed the kernel irqchip, let VFIO devices know they
> +     * need to readjust.
> +     */
> +    kvm_irqchip_change_notify();
>  }
>  
>  void spapr_irq_update_active_intc(SpaprMachineState *spapr)
> 

