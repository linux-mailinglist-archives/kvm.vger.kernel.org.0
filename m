Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FFA1B8993
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 23:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbgDYVXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 17:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgDYVXt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 17:23:49 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97C1C09B04D;
        Sat, 25 Apr 2020 14:23:48 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jSSGr-0004Jy-HJ; Sat, 25 Apr 2020 23:23:33 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id F334F10071F; Sat, 25 Apr 2020 23:23:32 +0200 (CEST)
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
Subject: Re: [PATCH RFC 03/15] drivers/base: Allocate/free platform-msi interrupts by group
In-Reply-To: <158751204550.36773.459505651659406529.stgit@djiang5-desk3.ch.intel.com>
References: <158751095889.36773.6009825070990637468.stgit@djiang5-desk3.ch.intel.com> <158751204550.36773.459505651659406529.stgit@djiang5-desk3.ch.intel.com>
Date:   Sat, 25 Apr 2020 23:23:32 +0200
Message-ID: <87sggrtg2z.fsf@nanos.tec.linutronix.de>
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
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -135,6 +135,12 @@ enum platform_msi_type {
>  	GEN_PLAT_MSI = 1,
>  };
>  
> +struct platform_msi_group_entry {
> +	unsigned int group_id;
> +	struct list_head group_list;
> +	struct list_head entry_list;

I surely told you before that struct members want to be written tabular.

> +};
> +
>  /* Helpers to hide struct msi_desc implementation details */
>  #define msi_desc_to_dev(desc)		((desc)->dev)
>  #define dev_to_msi_list(dev)		(&(dev)->msi_list)
> @@ -145,21 +151,31 @@ enum platform_msi_type {
>  #define for_each_msi_entry_safe(desc, tmp, dev)	\
>  	list_for_each_entry_safe((desc), (tmp), dev_to_msi_list((dev)), list)
>  
> -#define dev_to_platform_msi_list(dev)	(&(dev)->platform_msi_list)
> -#define first_platform_msi_entry(dev)		\
> -	list_first_entry(dev_to_platform_msi_list((dev)), struct msi_desc, list)
> -#define for_each_platform_msi_entry(desc, dev)	\
> -	list_for_each_entry((desc), dev_to_platform_msi_list((dev)), list)
> -#define for_each_platform_msi_entry_safe(desc, tmp, dev)	\
> -	list_for_each_entry_safe((desc), (tmp), dev_to_platform_msi_list((dev)), list)
> +#define dev_to_platform_msi_group_list(dev)    (&(dev)->platform_msi_list)
> +
> +#define first_platform_msi_group_entry(dev)				\
> +	list_first_entry(dev_to_platform_msi_group_list((dev)),		\
> +			 struct platform_msi_group_entry, group_list)
>  
> -#define first_msi_entry_common(dev)	\
> -	list_first_entry_select((dev)->platform_msi_type, dev_to_platform_msi_list((dev)),	\
> +#define platform_msi_current_group_entry_list(dev)			\
> +	(&((list_last_entry(dev_to_platform_msi_group_list((dev)),	\
> +			    struct platform_msi_group_entry,		\
> +			    group_list))->entry_list))
> +
> +#define first_msi_entry_current_group(dev)				\
> +	list_first_entry_select((dev)->platform_msi_type,		\
> +				platform_msi_current_group_entry_list((dev)),	\
>  				dev_to_msi_list((dev)), struct msi_desc, list)
>  
> -#define for_each_msi_entry_common(desc, dev)	\
> -	list_for_each_entry_select((dev)->platform_msi_type, desc, dev_to_platform_msi_list((dev)), \
> -				   dev_to_msi_list((dev)), list)	\
> +#define for_each_msi_entry_current_group(desc, dev)			\
> +	list_for_each_entry_select((dev)->platform_msi_type, desc,	\
> +				   platform_msi_current_group_entry_list((dev)),\
> +				   dev_to_msi_list((dev)), list)
> +
> +#define for_each_platform_msi_entry_in_group(desc, platform_msi_group, group, dev)	\
> +	list_for_each_entry((platform_msi_group), dev_to_platform_msi_group_list((dev)), group_list)	\
> +		if (((platform_msi_group)->group_id) == (group))			\
> +			list_for_each_entry((desc), (&(platform_msi_group)->entry_list), list)

Yet more unreadable macro maze to obfuscate what the code is actually
doing. 

>  /* When an MSI domain is used as an intermediate domain */
>  int msi_domain_prepare_irqs(struct irq_domain *domain, struct device *dev,
> diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
> index bc5f9e32387f..899ade394ec8 100644
> --- a/kernel/irq/msi.c
> +++ b/kernel/irq/msi.c
> @@ -320,7 +320,7 @@ int msi_domain_populate_irqs(struct irq_domain *domain, struct device *dev,
>  	struct msi_desc *desc;
>  	int ret = 0;
>  
> -	for_each_msi_entry_common(desc, dev) {
> +	for_each_msi_entry_current_group(desc, dev) {

How is anyone supposed to figure out what the heck this means without
going through several layers of macro maze and some magic type/group
storage in struct device?

Again, function arguments exist for a reason.

Thanks,

        tglx
