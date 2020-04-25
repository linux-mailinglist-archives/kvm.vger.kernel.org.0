Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE241B8986
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 23:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgDYVOK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 17:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgDYVOJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 17:14:09 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BDF7C09B04D;
        Sat, 25 Apr 2020 14:14:09 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jSS7N-0004FG-8Z; Sat, 25 Apr 2020 23:13:45 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 8643610071F; Sat, 25 Apr 2020 23:13:44 +0200 (CEST)
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
Subject: Re: [PATCH RFC 02/15] drivers/base: Introduce a new platform-msi list
In-Reply-To: <158751203902.36773.2662739280103265908.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com> <158751203902.36773.2662739280103265908.stgit@djiang5-desk3.ch.intel.com>
Date:   Sat, 25 Apr 2020 23:13:44 +0200
Message-ID: <87v9lntgjb.fsf@nanos.tec.linutronix.de>
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

> From: Megha Dey <megha.dey@linux.intel.com>
>
> This is a preparatory patch to introduce Interrupt Message Store (IMS).
>
> The struct device has a linked list ('msi_list') of the MSI (msi/msi-x,
> platform-msi) descriptors of that device. This list holds only 1 type
> of descriptor since it is not possible for a device to support more
> than one of these descriptors concurrently.
>
> However, with the introduction of IMS, a device can support IMS as well
> as MSI-X at the same time. Instead of sharing this list between IMS (a
> type of platform-msi) and MSI-X descriptors, introduce a new linked list,
> platform_msi_list, which will hold all the platform-msi descriptors.
>
> Thus, msi_list will point to the MSI/MSIX descriptors of a device, while
> platform_msi_list will point to the platform-msi descriptors of a
> device.

Will point?

You're failing to explain that this actually converts the existing
platform code over to this new list. This also lacks an explanation why
this is not a functional change.

> Signed-off-by: Megha Dey <megha.dey@linux.intel.com>

Lacks an SOB from you.... 

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 139cdf7e7327..5a0116d1a8d0 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1984,6 +1984,7 @@ void device_initialize(struct device *dev)
>  	set_dev_node(dev, -1);
>  #ifdef CONFIG_GENERIC_MSI_IRQ
>  	INIT_LIST_HEAD(&dev->msi_list);
> +	INIT_LIST_HEAD(&dev->platform_msi_list);

> --- a/drivers/base/platform-msi.c
> +++ b/drivers/base/platform-msi.c
> @@ -110,7 +110,8 @@ static void platform_msi_free_descs(struct device *dev, int base, int nvec)
>  {
>  	struct msi_desc *desc, *tmp;
>  
> -	list_for_each_entry_safe(desc, tmp, dev_to_msi_list(dev), list) {
> +	list_for_each_entry_safe(desc, tmp, dev_to_platform_msi_list(dev),
> +				 list) {
>  		if (desc->platform.msi_index >= base &&
>  		    desc->platform.msi_index < (base + nvec)) {
>  			list_del(&desc->list);
>  	datap = kzalloc(sizeof(*datap), GFP_KERNEL);
> @@ -255,6 +256,8 @@ int platform_msi_domain_alloc_irqs(struct device *dev, unsigned int nvec,
>  	struct platform_msi_priv_data *priv_data;
>  	int err;
>  
> +	dev->platform_msi_type = GEN_PLAT_MSI;

What the heck is GEN_PLAT_MSI? Can you please use

   1) A proper name space starting with PLATFORM_MSI_ or such

   2) A proper suffix which is self explaining.

instead of coming up with nonsensical garbage which even lacks any
explanation at the place where it is defined.

> diff --git a/include/linux/device.h b/include/linux/device.h
> index ac8e37cd716a..cbcecb14584e 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -567,6 +567,8 @@ struct device {
>  #endif
>  #ifdef CONFIG_GENERIC_MSI_IRQ
>  	struct list_head	msi_list;
> +	struct list_head	platform_msi_list;
> +	unsigned int		platform_msi_type;

You use an enum for the types so why are you not using an enum for the
struct member which stores it?

>  
> +/**
> + * list_entry_select - get the correct struct for this entry based on condition
> + * @condition:	the condition to choose a particular &struct list head pointer
> + * @ptr_a:      the &struct list_head pointer if @condition is not met.
> + * @ptr_b:      the &struct list_head pointer if @condition is met.
> + * @type:       the type of the struct this is embedded in.
> + * @member:     the name of the list_head within the struct.
> + */
> +#define list_entry_select(condition, ptr_a, ptr_b, type, member)\
> +	(condition) ? list_entry(ptr_a, type, member) :		\
> +		      list_entry(ptr_b, type, member)

This is related to $Subject in which way? It's not a entirely new
process rule that infrastructure changes which touch a completely
different subsystem have to be separate and explained and justified on
their own.

>  
> +enum platform_msi_type {
> +	NOT_PLAT_MSI = 0,

NOT_PLAT_MSI? Not used anywhere and of course equally self explaining as
the other one.

> +	GEN_PLAT_MSI = 1,
> +};
> +
>  /* Helpers to hide struct msi_desc implementation details */
>  #define msi_desc_to_dev(desc)		((desc)->dev)
>  #define dev_to_msi_list(dev)		(&(dev)->msi_list)
> @@ -140,6 +145,22 @@ struct msi_desc {
>  #define for_each_msi_entry_safe(desc, tmp, dev)	\
>  	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
>  
> +#define dev_to_platform_msi_list(dev)	(&(dev)->platform_msi_list)
> +#define first_platform_msi_entry(dev)		\
> +	list_first_entry(dev_to_platform_msi_list((dev)), struct msi_desc, list)
> +#define for_each_platform_msi_entry(desc, dev)	\
> +	list_for_each_entry((desc), dev_to_platform_msi_list((dev)), list)
> +#define for_each_platform_msi_entry_safe(desc, tmp, dev)	\
> +	list_for_each_entry_safe((desc), (tmp), dev_to_platform_msi_list((dev)), list)

New lines to seperate macros are bad for readability, right? 

> +#define first_msi_entry_common(dev)	\
> +	list_first_entry_select((dev)->platform_msi_type, dev_to_platform_msi_list((dev)),	\
> +				dev_to_msi_list((dev)), struct msi_desc, list)
> +
> +#define for_each_msi_entry_common(desc, dev)	\
> +	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
> +				   dev_to_msi_list((dev)), list)	\
> +
>  #ifdef CONFIG_IRQ_MSI_IOMMU
>  static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
>  {
> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
> index eb95f6106a1e..bc5f9e32387f 100644
> --- a/kernel/irq/msi.c
> +++ b/kernel/irq/msi.c
> @@ -320,7 +320,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
>  	struct msi_desc *desc;
>  	int ret = 0;
>  
> -	for_each_msi_entry(desc, dev) {
> +	for_each_msi_entry_common(desc, dev) {

This is absolutely unreadable. What's common here? You hide the decision
which list to iterate behind a misnomed macro. 

And looking at the implementation:

> +#define for_each_msi_entry_common(desc, dev)	\
> +	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
> +				   dev_to_msi_list((dev)), list)	\

So you implicitely make the decision based on:

   (dev)->platform_msi_type != 0

What? How is that ever supposed to work? The changelog says:

> However, with the introduction of IMS, a device can support IMS as well
> as MSI-X at the same time. Instead of sharing this list between IMS (a
> type of platform-msi) and MSI-X descriptors, introduce a new linked list,
> platform_msi_list, which will hold all the platform-msi descriptors.

So you are not serious about storing the decision in the device struct
and then calling into common code?

That's insane at best. There is absolutely ZERO explanation how this is
supposed to work and why this could even be remotely correct and safe.

Ever heard of the existance of function arguments?

Sorry, this is just voodoo programming and not going anywhere.

Thanks,

        tglx
