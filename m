Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595F7281D20
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgJBUuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:50:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41977 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgJBUuw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:50:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601671850;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PJQhB+t94WBF6cwzUrrUQvGU9wSuYBixWW1qSFR2D3E=;
        b=KD/bJfs08kaPgGJQQ2om3ipdfj7+RQm2ceCUf/ZSIGMrAcMD6piyNaq1CvB0W+TT47Awav
        AfM5xpK2Bynol5cAJELohLtol97I8zC/M3ClRThR7vUm6pYLe8BRlzp04H+Q+WX6lTfipz
        stsO08JWuMVlFArgi+QH1pfd/+4Tjtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-550-WMUo00QQNr2hZx7ntc84fA-1; Fri, 02 Oct 2020 16:50:48 -0400
X-MC-Unique: WMUo00QQNr2hZx7ntc84fA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1EDFB18829D3;
        Fri,  2 Oct 2020 20:50:47 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BB22B60C17;
        Fri,  2 Oct 2020 20:50:43 +0000 (UTC)
Date:   Fri, 2 Oct 2020 14:50:43 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Diana Craciun <diana.craciun@oss.nxp.com>
Cc:     kvm@vger.kernel.org, bharatb.linux@gmail.com,
        linux-kernel@vger.kernel.org, eric.auger@redhat.com,
        Bharat Bhushan <Bharat.Bhushan@nxp.com>
Subject: Re: [PATCH v5 09/10] vfio/fsl-mc: Add read/write support for fsl-mc
 devices
Message-ID: <20201002145043.3d663f92@x1.home>
In-Reply-To: <20200929090339.17659-10-diana.craciun@oss.nxp.com>
References: <20200929090339.17659-1-diana.craciun@oss.nxp.com>
        <20200929090339.17659-10-diana.craciun@oss.nxp.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Sep 2020 12:03:38 +0300
Diana Craciun <diana.craciun@oss.nxp.com> wrote:

> The software uses a memory-mapped I/O command interface (MC portals) to
> communicate with the MC hardware. This command interface is used to
> discover, enumerate, configure and remove DPAA2 objects. The DPAA2
> objects use MSIs, so the command interface needs to be emulated
> such that the correct MSI is configured in the hardware (the guest
> has the virtual MSIs).
> 
> This patch is adding read/write support for fsl-mc devices. The mc
> commands are emulated by the userspace. The host is just passing
> the correct command to the hardware.
> 
> Also the current patch limits userspace to write complete
> 64byte command once and read 64byte response by one ioctl.
> 
> Signed-off-by: Bharat Bhushan <Bharat.Bhushan@nxp.com>
> Signed-off-by: Diana Craciun <diana.craciun@oss.nxp.com>
> ---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c         | 118 +++++++++++++++++++++-
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h |   1 +
>  2 files changed, 116 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> index 82157837f37a..0aff99cdf722 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
> @@ -12,6 +12,7 @@
>  #include <linux/types.h>
>  #include <linux/vfio.h>
>  #include <linux/fsl/mc.h>
> +#include <linux/delay.h>
>  
>  #include "vfio_fsl_mc_private.h"
>  
> @@ -115,7 +116,9 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>  				!(vdev->regions[i].size & ~PAGE_MASK))
>  			vdev->regions[i].flags |=
>  					VFIO_REGION_INFO_FLAG_MMAP;
> -
> +		vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_READ;
> +		if (!(mc_dev->regions[i].flags & IORESOURCE_READONLY))
> +			vdev->regions[i].flags |= VFIO_REGION_INFO_FLAG_WRITE;
>  	}
>  
>  	return 0;
> @@ -123,6 +126,11 @@ static int vfio_fsl_mc_regions_init(struct vfio_fsl_mc_device *vdev)
>  
>  static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
>  {
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	int i;
> +
> +	for (i = 0; i < mc_dev->obj_desc.region_count; i++)
> +		iounmap(vdev->regions[i].ioaddr);
>  	kfree(vdev->regions);
>  }
>  
> @@ -301,13 +309,117 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
>  static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
>  				size_t count, loff_t *ppos)
>  {
> -	return -EINVAL;
> +	struct vfio_fsl_mc_device *vdev = device_data;
> +	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
> +	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	struct vfio_fsl_mc_region *region;
> +	u64 data[8];
> +	int i;
> +
> +	if (index >= mc_dev->obj_desc.region_count)
> +		return -EINVAL;
> +
> +	region = &vdev->regions[index];
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_READ))
> +		return -EINVAL;

Nit, there are no regions w/o read access according to the regions_init
code above.  Maybe this is just for symmetry with write?  Keep it if
you prefer.  Thanks,

Alex

> +
> +	if (!region->ioaddr) {
> +		region->ioaddr = ioremap(region->addr, region->size);
> +		if (!region->ioaddr)
> +			return -ENOMEM;
> +	}
> +
> +	if (count != 64 || off != 0)
> +		return -EINVAL;
> +
> +	for (i = 7; i >= 0; i--)
> +		data[i] = readq(region->ioaddr + i * sizeof(uint64_t));
> +
> +	if (copy_to_user(buf, data, 64))
> +		return -EFAULT;
> +
> +	return count;
> +}
> +
> +#define MC_CMD_COMPLETION_TIMEOUT_MS    5000
> +#define MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS    500
> +
> +static int vfio_fsl_mc_send_command(void __iomem *ioaddr, uint64_t *cmd_data)
> +{
> +	int i;
> +	enum mc_cmd_status status;
> +	unsigned long timeout_usecs = MC_CMD_COMPLETION_TIMEOUT_MS * 1000;
> +
> +	/* Write at command parameter into portal */
> +	for (i = 7; i >= 1; i--)
> +		writeq_relaxed(cmd_data[i], ioaddr + i * sizeof(uint64_t));
> +
> +	/* Write command header in the end */
> +	writeq(cmd_data[0], ioaddr);
> +
> +	/* Wait for response before returning to user-space
> +	 * This can be optimized in future to even prepare response
> +	 * before returning to user-space and avoid read ioctl.
> +	 */
> +	for (;;) {
> +		u64 header;
> +		struct mc_cmd_header *resp_hdr;
> +
> +		header = cpu_to_le64(readq_relaxed(ioaddr));
> +
> +		resp_hdr = (struct mc_cmd_header *)&header;
> +		status = (enum mc_cmd_status)resp_hdr->status;
> +		if (status != MC_CMD_STATUS_READY)
> +			break;
> +
> +		udelay(MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS);
> +		timeout_usecs -= MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS;
> +		if (timeout_usecs == 0)
> +			return -ETIMEDOUT;
> +	}
> +
> +	return 0;
>  }
>  
>  static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
>  				 size_t count, loff_t *ppos)
>  {
> -	return -EINVAL;
> +	struct vfio_fsl_mc_device *vdev = device_data;
> +	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
> +	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
> +	struct fsl_mc_device *mc_dev = vdev->mc_dev;
> +	struct vfio_fsl_mc_region *region;
> +	u64 data[8];
> +	int ret;
> +
> +	if (index >= mc_dev->obj_desc.region_count)
> +		return -EINVAL;
> +
> +	region = &vdev->regions[index];
> +
> +	if (!(region->flags & VFIO_REGION_INFO_FLAG_WRITE))
> +		return -EINVAL;
> +
> +	if (!region->ioaddr) {
> +		region->ioaddr = ioremap(region->addr, region->size);
> +		if (!region->ioaddr)
> +			return -ENOMEM;
> +	}
> +
> +	if (count != 64 || off != 0)
> +		return -EINVAL;
> +
> +	if (copy_from_user(&data, buf, 64))
> +		return -EFAULT;
> +
> +	ret = vfio_fsl_mc_send_command(region->ioaddr, data);
> +	if (ret)
> +		return ret;
> +
> +	return count;
> +
>  }
>  
>  static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
> diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> index 7aa49b9ba60d..a97ee691ed47 100644
> --- a/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> +++ b/drivers/vfio/fsl-mc/vfio_fsl_mc_private.h
> @@ -32,6 +32,7 @@ struct vfio_fsl_mc_region {
>  	u32			type;
>  	u64			addr;
>  	resource_size_t		size;
> +	void __iomem		*ioaddr;
>  };
>  
>  struct vfio_fsl_mc_device {

