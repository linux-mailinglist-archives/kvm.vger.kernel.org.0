Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4172A10A3
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 23:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJ3WBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 18:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgJ3WBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 18:01:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 154B0C0613CF;
        Fri, 30 Oct 2020 15:01:09 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604095267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZrSPySqcQcgsfU3kuIbRjApMl6QJyJy0VjP/tJus60=;
        b=GyzrUO6hsGdW88qLMmGVvuNdOYpZfq0O448OrekB+80h4p3WsTxpXJzyoRT+1G8FH7zoy1
        6nrqSYDGZDLSsyTmJQHBDoD6XRwQhfpK6OWVcTbRCqFgt7zkTzqv19l+2yGa+ERzlTSo30
        sCQzdyResgcnl7B8E20ag1+V1DR0iHWRAIyN+cyD+0kpkJY+e/RACUh0ka404Q4Pv42087
        FisQaHl+YVV75wZafhO8LyvPEtl2D70Y/qyOLs1bSQk6gbLhlrbOrgpiFK3h0r1KgyQK/E
        pHGt1cKKXhvfmuVxlRfdFFgDbzNv/NmGX2p1TtZvJEraQkhlcs6bALu4ODlzeg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604095267;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AZrSPySqcQcgsfU3kuIbRjApMl6QJyJy0VjP/tJus60=;
        b=kpvwOqLjk1P2Px68Wml+7RtTTNJPJhCoXSDD5c5GTV+MSY2qkGMoo/pnJQfyaI5SHVa6vs
        16h/XUdDzBFMsfBw==
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@intel.com, maz@kernel.org, bhelgaas@google.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        jgg@mellanox.com, rafael@kernel.org, netanelg@mellanox.com,
        shahafs@mellanox.com, yan.y.zhao@linux.intel.com,
        pbonzini@redhat.com, samuel.ortiz@intel.com, mona.hossain@intel.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 01/17] irqchip: Add IMS (Interrupt Message Store) driver
In-Reply-To: <160408385476.912050.16205225207591080075.stgit@djiang5-desk3.ch.intel.com>
References: <160408357912.912050.17005584526266191420.stgit@djiang5-desk3.ch.intel.com> <160408385476.912050.16205225207591080075.stgit@djiang5-desk3.ch.intel.com>
Date:   Fri, 30 Oct 2020 23:01:07 +0100
Message-ID: <871rhfml0c.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30 2020 at 11:50, Dave Jiang wrote:
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -487,6 +487,8 @@ extern int irq_get_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
>  extern int irq_set_irqchip_state(unsigned int irq, enum irqchip_irq_state which,
>  				 bool state);
>  
> +int irq_set_auxdata(unsigned int irq, unsigned int which, u64 val);
....
> +EXPORT_SYMBOL_GPL(irq_set_auxdata);

Again: Read and follow documentation. This does not belong into this
driver patch and wants to be a standalone preperatory patch.

Also the core change, the irq chip, the iommu support and the device msi
dependency has to be completely seperate from this idxd series.

You cannot just dump a pile of patches touching several subsystems at
once plus having dependencies on stuff which is not even agreed on and
merged and then expect that everything just falls into place.

The various subsystems involved are not holding their breath and putting
a lock on development just because you have a series against some random
snapshot.

The dependencies, e.g. the device msi infrastructure, are not going to
make their way magically into the proper maintainer tree either.

If this ever goes into a mergeable state, then the merge logistics for
this whole thing need to be carefully sorted out and it's on you to make
that as simple as possible for every maintainer involved.

Thanks,

        tglx
