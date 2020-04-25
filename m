Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 115471B89C2
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 00:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgDYWOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 18:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726220AbgDYWOQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 25 Apr 2020 18:14:16 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1CDAC09B04F;
        Sat, 25 Apr 2020 15:14:15 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jST3e-0004cM-Tb; Sun, 26 Apr 2020 00:13:59 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 611E9100605; Sun, 26 Apr 2020 00:13:58 +0200 (CEST)
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
Subject: Re: [PATCH RFC 06/15] ims-msi: Enable IMS interrupts
In-Reply-To: <158751206394.36773.12409950149228811741.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com> <158751206394.36773.12409950149228811741.stgit@djiang5-desk3.ch.intel.com>
Date:   Sun, 26 Apr 2020 00:13:58 +0200
Message-ID: <87imhntdqx.fsf@nanos.tec.linutronix.de>
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
> +struct irq_domain *dev_get_ims_domain(struct device *dev)
> +{
> +	struct irq_alloc_info info;
> +
> +	if (dev_is_mdev(dev))
> +		dev = mdev_to_parent(dev);
> +
> +	init_irq_alloc_info(&info, NULL);
> +	info.type = X86_IRQ_ALLOC_TYPE_IMS;

So all IMS capabale devices run on X86? I thought these things are PCIe
cards which can be plugged into any platform which supports PCIe.

> +	info.dev = dev;
> +
> +	return irq_remapping_get_irq_domain(&info);
> +}
> +
>  static struct msi_domain_ops dev_ims_domain_ops = {
>  	.get_hwirq	= dev_ims_get_hwirq,
>  	.msi_prepare	= dev_ims_prepare,
> diff --git a/drivers/base/platform-msi.c b/drivers/base/platform-msi.c
> index 6d8840db4a85..204ce8041c17 100644
> --- a/drivers/base/platform-msi.c
> +++ b/drivers/base/platform-msi.c
> @@ -118,6 +118,8 @@ static void platform_msi_free_descs(struct device *dev, int base, int nvec,
>  			kfree(platform_msi_group);
>  		}
>  	}
> +
> +	dev->platform_msi_type = 0;

I can clearly see the advantage of using '0' over 'NOT_PLAT_MSI'
here. '0' is definitely more intuitive.

>  }
>  
>  static int platform_msi_alloc_descs_with_irq(struct device *dev, int virq,
> @@ -205,18 +207,22 @@ platform_msi_alloc_priv_data(struct device *dev, unsigned int nvec,
>  	 * accordingly (which would impact the max number of MSI
>  	 * capable devices).
>  	 */
> -	if (!dev->msi_domain || !platform_ops->write_msg || !nvec ||
> -	    nvec > MAX_DEV_MSIS)
> +	if (!platform_ops->write_msg || !nvec || nvec > MAX_DEV_MSIS)
>  		return ERR_PTR(-EINVAL);
> -	if (dev->msi_domain->bus_token != DOMAIN_BUS_PLATFORM_MSI) {
> -		dev_err(dev, "Incompatible msi_domain, giving up\n");
> -		return ERR_PTR(-EINVAL);
> -	}
> +	if (dev->platform_msi_type == GEN_PLAT_MSI) {
> +		if (!dev->msi_domain)
> +			return ERR_PTR(-EINVAL);
> +
> +		if (dev->msi_domain->bus_token != DOMAIN_BUS_PLATFORM_MSI) {
> +			dev_err(dev, "Incompatible msi_domain, giving up\n");
> +			return ERR_PTR(-EINVAL);
> +		}
>  
> -	/* Already had a helping of MSI? Greed... */
> -	if (!list_empty(platform_msi_current_group_entry_list(dev)))
> -		return ERR_PTR(-EBUSY);
> +		/* Already had a helping of MSI? Greed... */
> +		if (!list_empty(platform_msi_current_group_entry_list(dev)))
> +			return ERR_PTR(-EBUSY);
> +	}
>  
>  	datap = kzalloc(sizeof(*datap), GFP_KERNEL);
>  	if (!datap)
> @@ -254,6 +260,7 @@ static void platform_msi_free_priv_data(struct platform_msi_priv_data *data)
>  int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
>  				   const struct platform_msi_ops *platform_ops)
>  {
> +	dev->platform_msi_type = GEN_PLAT_MSI;
>  	return platform_msi_domain_alloc_irqs_group(dev, nvec, platform_ops,
>  									NULL);
>  }
> @@ -265,12 +272,18 @@ int platform_msi_domain_alloc_irqs_group(struct device *dev, unsigned int nvec,
>  {
>  	struct platform_msi_group_entry *platform_msi_group;
>  	struct platform_msi_priv_data *priv_data;
> +	struct irq_domain *domain;
>  	int err;
>  
> -	dev->platform_msi_type = GEN_PLAT_MSI;

Groan. If you move the type assignment to the caller then do so in a
separate patch. These all in one combo changes are simply not reviewable
without getting nuts.

> -	if (group_id)
> +	if (!dev->platform_msi_type) {

That's really consistent. If the caller does not store a type upfront
then it becomes IMS automagically. Can you pretty please stop to think
that this IMS stuff is the center of the universe? To be clear, it's
just another variant of half thought out hardware design fail as all the
other stuff we already have to support.

Abusing dev->platform_msi_type to decide about the nature of the call
and then decide that anything which does not set it upfront is IMS is
really future proof.

>  		*group_id = ++dev->group_id;
> +		dev->platform_msi_type = IMS;

Oh a new type name 'IMS'. Well suited into the naming scheme. 

> +		domain = dev_get_ims_domain(dev);

No. This is completely inconsistent again and a blatant violation of
layering.

Thanks,

        tglx
