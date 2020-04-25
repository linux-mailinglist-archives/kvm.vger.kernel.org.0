Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9FC1B89A6
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 23:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgDYVtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 17:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgDYVtz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 17:49:55 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49004C09B04D;
        Sat, 25 Apr 2020 14:49:55 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jSSgD-0004U7-FC; Sat, 25 Apr 2020 23:49:45 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id D0EAA10071F; Sat, 25 Apr 2020 23:49:44 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Dave Jiang <dave.jiang@intel.com>, vkoul@kernel.org,
        megha.dey@linux.intel.com, maz@kernel.org, bhelgaas@google.com,
        rafael@kernel.org, gregkh@linuxfoundation.org, hpa@zytor.com,
        alex.williamson@redhat.com, jacob.jun.pan@intel.com,
        ashok.raj@intel.com, jgg@mellanox.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com
Cc:     dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC 05/15] ims-msi: Add mask/unmask routines
In-Reply-To: <158751205785.36773.16321096654677399376.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com> <158751205785.36773.16321096654677399376.stgit@djiang5-desk3.ch.intel.com>
Date:   Sat, 25 Apr 2020 23:49:44 +0200
Message-ID: <87lfmjtevb.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dave Jiang <dave.jiang@intel.com> writes:
>  
> +static u32 __dev_ims_desc_mask_irq(struct msi_desc *desc, u32 flag)

...mask_irq()? This is doing both mask and unmask depending on the
availability of the ops callbacks. 

> +{
> +	u32 mask_bits = desc->platform.masked;
> +	const struct platform_msi_ops *ops;
> +
> +	ops = desc->platform.msi_priv_data->ops;
> +	if (!ops)
> +		return 0;
> +
> +	if (flag) {

flag? Darn, this has a clear boolean meaning of mask or unmask and 'u32
flag' is the most natural and obvious self explaining expression for
this, right?

> +		if (ops->irq_mask)
> +			mask_bits = ops->irq_mask(desc);
> +	} else {
> +		if (ops->irq_unmask)
> +			mask_bits = ops->irq_unmask(desc);
> +	}
> +
> +	return mask_bits;

What's mask_bits? This is about _ONE_ IMS interrupt. Can it have
multiple mask bits and if so then the explanation which I decoded by
crystal ball probably looks like this:

Bit  0:  Don't know whether it's masked
Bit  1:  Perhaps it's masked
Bit  2:  Probably it's masked
Bit  3:  Mostly masked
...
Bit 31:  Fully masked

Or something like that. Makes a lot of sense in a XKCD cartoon at least.

> +}
> +
> +/**
> + * dev_ims_mask_irq - Generic irq chip callback to mask IMS interrupts
> + * @data: pointer to irqdata associated to that interrupt
> + */
> +static void dev_ims_mask_irq(struct irq_data *data)
> +{
> +	struct msi_desc *desc = irq_data_get_msi_desc(data);
> +
> +	desc->platform.masked = __dev_ims_desc_mask_irq(desc, 1);

The purpose of this masked information is?

Thanks,

        tglx
