Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 376E320ED1
	for <lists+kvm@lfdr.de>; Thu, 16 May 2019 20:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfEPSkh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 May 2019 14:40:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23839 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbfEPSkg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 May 2019 14:40:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 217FA307D85B;
        Thu, 16 May 2019 18:40:30 +0000 (UTC)
Received: from x1.home (ovpn-117-92.phx2.redhat.com [10.3.117.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 43B2A60C71;
        Thu, 16 May 2019 18:40:27 +0000 (UTC)
Date:   Thu, 16 May 2019 12:40:26 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     sebott@linux.vnet.ibm.com, gerald.schaefer@de.ibm.com,
        pasic@linux.vnet.ibm.com, borntraeger@de.ibm.com,
        walling@linux.ibm.com, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [PATCH 4/4] vfio: vfio_iommu_type1: implement
 VFIO_IOMMU_INFO_CAPABILITIES
Message-ID: <20190516124026.415bf671@x1.home>
In-Reply-To: <1557476555-20256-5-git-send-email-pmorel@linux.ibm.com>
References: <1557476555-20256-1-git-send-email-pmorel@linux.ibm.com>
        <1557476555-20256-5-git-send-email-pmorel@linux.ibm.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 16 May 2019 18:40:35 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 10 May 2019 10:22:35 +0200
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We implement a capability intercafe for VFIO_IOMMU_GET_INFO and add the
> first capability: VFIO_IOMMU_INFO_CAPABILITIES.
> 
> When calling the ioctl, the user must specify
> VFIO_IOMMU_INFO_CAPABILITIES to retrieve the capabilities and must check
> in the answer if capabilities are supported.
> Older kernel will not check nor set the VFIO_IOMMU_INFO_CAPABILITIES in
> the flags of vfio_iommu_type1_info.
> 
> The iommu get_attr callback will be called to retrieve the specific
> attributes and fill the capabilities, VFIO_IOMMU_INFO_CAP_QFN for the
> PCI query function attributes and VFIO_IOMMU_INFO_CAP_QGRP for the
> PCI query function group.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 95 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 94 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index d0f731c..f7f8120 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1658,6 +1658,70 @@ static int vfio_domains_have_iommu_cache(struct vfio_iommu *iommu)
>  	return ret;
>  }
>  
> +int vfio_iommu_type1_caps(struct vfio_iommu *iommu, struct vfio_info_cap *caps,
> +			  size_t size)
> +{
> +	struct vfio_domain *d;
> +	struct vfio_iommu_type1_info_block *info_fn;
> +	struct vfio_iommu_type1_info_block *info_grp;
> +	unsigned long total_size, fn_size, grp_size;
> +	int ret;
> +
> +	d = list_first_entry(&iommu->domain_list, struct vfio_domain, next);
> +	if (!d)
> +		return -ENODEV;
> +	/* The size of these capabilities are device dependent */
> +	fn_size = iommu_domain_get_attr(d->domain,
> +					DOMAIN_ATTR_ZPCI_FN_SIZE, NULL);
> +	if (fn_size < 0)
> +		return fn_size;

What if non-Z archs want to use this?  The function is architected
specifically for this one use case, fail if any component is not there
which means it requires a re-write to add further support.  If
ZPCI_FN_SIZE isn't support, move on to the next thing.

> +	fn_size +=  sizeof(struct vfio_info_cap_header);
> +	total_size = fn_size;

Here too, total_size should be initialized to zero and each section +=
the size they'd like to add.

> +
> +	grp_size = iommu_domain_get_attr(d->domain,
> +					 DOMAIN_ATTR_ZPCI_GRP_SIZE, NULL);
> +	if (grp_size < 0)
> +		return grp_size;
> +	grp_size +=  sizeof(struct vfio_info_cap_header);
> +	total_size += grp_size;
> +
> +	/* Tell caller to call us with a greater buffer */
> +	if (total_size > size) {
> +		caps->size = total_size;
> +		return 0;
> +	}
> +
> +	info_fn = kzalloc(fn_size, GFP_KERNEL);
> +	if (!info_fn)
> +		return -ENOMEM;

Maybe fn_size was zero because we're not on Z.

> +	ret = iommu_domain_get_attr(d->domain,
> +				    DOMAIN_ATTR_ZPCI_FN, &info_fn->data);

Kernel internal structures != user api.  Thanks,

Alex

> +	if (ret < 0)
> +		return ret;
> +
> +	info_fn->header.id = VFIO_IOMMU_INFO_CAP_QFN;
> +
> +	ret = vfio_info_add_capability(caps, &info_fn->header, fn_size);
> +	if (ret)
> +		goto err_fn;
> +
> +	info_grp = kzalloc(grp_size, GFP_KERNEL);
> +	if (!info_grp)
> +		goto err_fn;
> +	ret = iommu_domain_get_attr(d->domain,
> +				    DOMAIN_ATTR_ZPCI_GRP, &info_grp->data);
> +	if (ret < 0)
> +		goto err_grp;
> +	info_grp->header.id = VFIO_IOMMU_INFO_CAP_QGRP;
> +	ret = vfio_info_add_capability(caps, &info_grp->header, grp_size);
> +
> +err_grp:
> +	kfree(info_grp);
> +err_fn:
> +	kfree(info_fn);
> +	return ret;
> +}
> +
>  static long vfio_iommu_type1_ioctl(void *iommu_data,
>  				   unsigned int cmd, unsigned long arg)
>  {
> @@ -1679,6 +1743,8 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		}
>  	} else if (cmd == VFIO_IOMMU_GET_INFO) {
>  		struct vfio_iommu_type1_info info;
> +		struct vfio_info_cap caps = { .buf = NULL, .size = 0 };
> +		int ret;
>  
>  		minsz = offsetofend(struct vfio_iommu_type1_info, iova_pgsizes);
>  
> @@ -1688,7 +1754,34 @@ static long vfio_iommu_type1_ioctl(void *iommu_data,
>  		if (info.argsz < minsz)
>  			return -EINVAL;
>  
> -		info.flags = VFIO_IOMMU_INFO_PGSIZES;
> +		if (info.flags & VFIO_IOMMU_INFO_CAPABILITIES) {
> +			minsz = offsetofend(struct vfio_iommu_type1_info,
> +					    cap_offset);
> +			if (info.argsz < minsz)
> +				return -EINVAL;
> +			ret = vfio_iommu_type1_caps(iommu, &caps,
> +						    info.argsz - sizeof(info));
> +			if (ret)
> +				return ret;
> +		}
> +		if (caps.size) {
> +			if (info.argsz < sizeof(info) + caps.size) {
> +				info.argsz = sizeof(info) + caps.size;
> +				info.cap_offset = 0;
> +			} else {
> +				if (copy_to_user((void __user *)arg +
> +						 sizeof(info), caps.buf,
> +						 caps.size)) {
> +					kfree(caps.buf);
> +					return -EFAULT;
> +				}
> +
> +				info.cap_offset = sizeof(info);
> +			}
> +			kfree(caps.buf);
> +		}
> +
> +		info.flags |= VFIO_IOMMU_INFO_PGSIZES;
>  
>  		info.iova_pgsizes = vfio_pgsize_bitmap(iommu);
>  

