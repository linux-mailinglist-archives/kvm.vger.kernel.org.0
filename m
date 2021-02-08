Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66A883137D1
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 16:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbhBHPcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 10:32:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:20916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232893AbhBHP3Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Feb 2021 10:29:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612798075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Yq0Ti4bvg/0tu+i0KOgAFNuIbTb2acty2w5AsnsSKZY=;
        b=PWULkhXprQIVP8ZmQNLRL+L0myAAwYNruM+8TBm9i3mMZTxxsJmhBkDdvvw8MzBS9R5IJ+
        CqEHnBscPyALSGHrpMYL0HgMijoGp64MsrVa5MGDg+pGo5KVkpIj974pnOvso3o1uZlK76
        v6ISsYT98djoLbADRFql+J4rtJhgNOg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-314-cXkYk-baOmOqIGYjRUMP7Q-1; Mon, 08 Feb 2021 10:27:54 -0500
X-MC-Unique: cXkYk-baOmOqIGYjRUMP7Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76B6F107ACE3;
        Mon,  8 Feb 2021 15:27:52 +0000 (UTC)
Received: from [10.36.112.10] (ovpn-112-10.ams2.redhat.com [10.36.112.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32EDE1002388;
        Mon,  8 Feb 2021 15:27:47 +0000 (UTC)
Subject: Re: [RFC v4 3/3] vfio: platform: reset: add msi support
To:     Vikas Gupta <vikas.gupta@broadcom.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     vikram.prakash@broadcom.com, srinath.mannam@broadcom.com,
        ashwin.kamath@broadcom.com, zachary.schroff@broadcom.com,
        manish.kurup@broadcom.com
References: <20201214174514.22006-1-vikas.gupta@broadcom.com>
 <20210129172421.43299-1-vikas.gupta@broadcom.com>
 <20210129172421.43299-4-vikas.gupta@broadcom.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <27d82212-0d68-3df8-8741-cd79a21f2b48@redhat.com>
Date:   Mon, 8 Feb 2021 16:27:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210129172421.43299-4-vikas.gupta@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vikas,

On 1/29/21 6:24 PM, Vikas Gupta wrote:
> Add msi support for Broadcom FlexRm device.
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> ---
>  .../platform/reset/vfio_platform_bcmflexrm.c  | 72 ++++++++++++++++++-
>  1 file changed, 70 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c b/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
> index 96064ef8f629..6ca4ca12575b 100644
> --- a/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
> +++ b/drivers/vfio/platform/reset/vfio_platform_bcmflexrm.c
> @@ -21,7 +21,9 @@
>  #include <linux/init.h>
>  #include <linux/io.h>
>  #include <linux/kernel.h>
> +#include <linux/msi.h>
>  #include <linux/module.h>
> +#include <linux/vfio.h>
>  
>  #include "../vfio_platform_private.h"
>  
> @@ -33,6 +35,9 @@
>  #define RING_VER					0x000
>  #define RING_CONTROL					0x034
>  #define RING_FLUSH_DONE					0x038
> +#define RING_MSI_ADDR_LS				0x03c
> +#define RING_MSI_ADDR_MS				0x040
> +#define RING_MSI_DATA_VALUE				0x064
>  
>  /* Register RING_CONTROL fields */
>  #define CONTROL_FLUSH_SHIFT				5
> @@ -105,8 +110,71 @@ static int vfio_platform_bcmflexrm_reset(struct vfio_platform_device *vdev)
>  	return ret;
>  }
>  
> -module_vfio_reset_handler("brcm,iproc-flexrm-mbox",
> -			  vfio_platform_bcmflexrm_reset);
> +static u32 bcm_num_msi(struct vfio_platform_device *vdev)
Please use the same prefix as for reset, ie. vfio_platform_bcmflexrm_get_msi
> +{
> +	struct vfio_platform_region *reg = &vdev->regions[0];> +
> +	return (reg->size / RING_REGS_SIZE);
> +}
> +
> +static void bcm_write_msi(struct vfio_platform_device *vdev,
vfio_platform_bcmflexrm_msi_write?
> +		struct msi_desc *desc,
> +		struct msi_msg *msg)
> +{
> +	int i;
> +	int hwirq = -1;
> +	int msi_src;
> +	void __iomem *ring;
> +	struct vfio_platform_region *reg = &vdev->regions[0];
> +
> +	if (!reg)
> +		return;
why do you need this check? For this to be called, SET_IRQ IOCTL must
have been called. This can only happen after vfio_platform_open which
first calls vfio_platform_regions_init and then vfio_platform_irq_init
> +
> +	for (i = 0; i < vdev->num_irqs; i++)
> +		if (vdev->irqs[i].type == VFIO_IRQ_TYPE_MSI)
> +			hwirq = vdev->irqs[i].ctx[0].hwirq;
nit: It would have been easier to record in vdev the last index of wired
interrupts and just add the index of the MSI
> +
> +	if (hwirq < 0)
> +		return;
> +
> +	msi_src = desc->irq - hwirq;
> +
> +	if (!reg->ioaddr) {
> +		reg->ioaddr = ioremap(reg->addr, reg->size);
> +		if (!reg->ioaddr)
pr_warn_once("")?
> +			return;
> +	}
> +
> +	ring = reg->ioaddr + msi_src * RING_REGS_SIZE;
> +
> +	writel_relaxed(msg->address_lo, ring + RING_MSI_ADDR_LS);
> +	writel_relaxed(msg->address_hi, ring + RING_MSI_ADDR_MS);
> +	writel_relaxed(msg->data, ring + RING_MSI_DATA_VALUE);
> +}
> +
> +static struct vfio_platform_reset_node vfio_platform_bcmflexrm_reset_node = {
> +	.owner = THIS_MODULE,
> +	.compat = "brcm,iproc-flexrm-mbox",
> +	.of_reset = vfio_platform_bcmflexrm_reset,
> +	.of_get_msi = bcm_num_msi,
> +	.of_msi_write = bcm_write_msi
> +};
> +
> +static int __init vfio_platform_bcmflexrm_reset_module_init(void)
> +{
> +	__vfio_platform_register_reset(&vfio_platform_bcmflexrm_reset_node);
> +
> +	return 0;
> +}
> +
> +static void __exit vfio_platform_bcmflexrm_reset_module_exit(void)
> +{
> +	vfio_platform_unregister_reset("brcm,iproc-flexrm-mbox",
> +				       vfio_platform_bcmflexrm_reset);
> +}
> +
> +module_init(vfio_platform_bcmflexrm_reset_module_init);
> +module_exit(vfio_platform_bcmflexrm_reset_module_exit);
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_AUTHOR("Anup Patel <anup.patel@broadcom.com>");
> 

I think you should move the whole series in PATCH now.

Thanks

Eric

