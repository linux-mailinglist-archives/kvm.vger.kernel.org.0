Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9821A557011
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 03:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359556AbiFWBqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 21:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359719AbiFWBqW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 21:46:22 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311A1434B2;
        Wed, 22 Jun 2022 18:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655948781; x=1687484781;
  h=message-id:date:mime-version:cc:subject:to:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QCwPmWYcD+MquAMSOXPCydTeGHAkPZLuW112dPh/u+U=;
  b=XweCD7xUIXkAvbggPhGUMSEFlIMelIS4GuZfMfSY06KClvLanY8AGkOh
   hHouaYKAE5T0q7YHREd6ISd5lzT9zWfk0I93WC2+CdlXmU90BkX2hIaJZ
   e2Rwabmt0TmMZPcSuG0NFNxcn/Ma1DoGKGGmfaZVO3e9Ljr0+lX05Xf7r
   opwvW3HC0TupbWF958QRrV/EXbJusaGPJ5qkqvePGEuCfA+23zsV19Uyg
   V0uj8/e9ngG/Jwvi3OydXGMleO37UQYF5sNBFztVv6nCPBpmXMOz3EPcD
   KKxZtVHh6C4vbhyFaWnczyp+1RdQQ4fx3ijhoOAC+TAnUC2wepP2BV9rY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="260413503"
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="260413503"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 18:46:20 -0700
X-IronPort-AV: E=Sophos;i="5.92,215,1650956400"; 
   d="scan'208";a="644487121"
Received: from yutaoxu-mobl.ccr.corp.intel.com (HELO [10.249.172.190]) ([10.249.172.190])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 18:46:18 -0700
Message-ID: <e18cca4c-c324-c1ab-7a2f-0f97c6387475@linux.intel.com>
Date:   Thu, 23 Jun 2022 09:46:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Cc:     baolu.lu@linux.intel.com, kvm@vger.kernel.org,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, jgg@nvidia.com
Subject: Re: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Content-Language: en-US
To:     Robin Murphy <robin.murphy@arm.com>, alex.williamson@redhat.com,
        cohuck@redhat.com
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
From:   Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/22 20:04, Robin Murphy wrote:
> Since IOMMU groups are mandatory for drivers to support, it stands to
> reason that any device which has been successfully be added to a group
> must be on a bus supported by that IOMMU driver, and therefore a domain
> viable for any device in the group must be viable for all devices in
> the group. This already has to be the case for the IOMMU API's internal
> default domain, for instance. Thus even if the group contains devices on
> different buses, that can only mean that the IOMMU driver actually
> supports such an odd topology, and so without loss of generality we can
> expect the bus type of any device in a group to be suitable for IOMMU
> API calls.

Ideally we could remove bus->iommu_ops and all IOMMU APIs go through the
dev_iommu_ops().

> 
> Replace vfio_bus_type() with a simple call to resolve an appropriate
> member device from which to then derive a bus type. This is also a step
> towards removing the vague bus-based interfaces from the IOMMU API, when
> we can subsequently switch to using this device directly.
> 
> Furthermore, scrutiny reveals a lack of protection for the bus being
> removed while vfio_iommu_type1_attach_group() is using it; the reference
> that VFIO holds on the iommu_group ensures that data remains valid, but
> does not prevent the group's membership changing underfoot. Holding the
> vfio_device for as long as we need here also neatly solves this.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>

Best regards,
baolu

> ---
> 
> After sleeping on it, I decided to type up the helper function approach
> to see how it looked in practice, and in doing so realised that with one
> more tweak it could also subsume the locking out of the common paths as
> well, so end up being a self-contained way for type1 to take care of its
> own concern, which I rather like.
> 
>   drivers/vfio/vfio.c             | 18 +++++++++++++++++-
>   drivers/vfio/vfio.h             |  3 +++
>   drivers/vfio/vfio_iommu_type1.c | 30 +++++++++++-------------------
>   3 files changed, 31 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 61e71c1154be..73bab04880d0 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -448,7 +448,7 @@ static void vfio_group_get(struct vfio_group *group)
>    * Device objects - create, release, get, put, search
>    */
>   /* Device reference always implies a group reference */
> -static void vfio_device_put(struct vfio_device *device)
> +void vfio_device_put(struct vfio_device *device)
>   {
>   	if (refcount_dec_and_test(&device->refcount))
>   		complete(&device->comp);
> @@ -475,6 +475,22 @@ static struct vfio_device *vfio_group_get_device(struct vfio_group *group,
>   	return NULL;
>   }
>   
> +struct vfio_device *vfio_device_get_from_iommu(struct iommu_group *iommu_group)
> +{
> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
> +	struct vfio_device *device;
> +
> +	mutex_lock(&group->device_lock);
> +	list_for_each_entry(device, &group->device_list, group_next) {
> +		if (vfio_device_try_get(device)) {
> +			mutex_unlock(&group->device_lock);
> +			return device;
> +		}
> +	}
> +	mutex_unlock(&group->device_lock);
> +	return NULL;
> +}
> +
>   /*
>    * VFIO driver API
>    */
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index a67130221151..e8f21e64541b 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -70,3 +70,6 @@ struct vfio_iommu_driver_ops {
>   
>   int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
>   void vfio_unregister_iommu_driver(const struct vfio_iommu_driver_ops *ops);
> +
> +struct vfio_device *vfio_device_get_from_iommu(struct iommu_group *iommu_group);
> +void vfio_device_put(struct vfio_device *device);
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index c13b9290e357..e38b8bfde677 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -1679,18 +1679,6 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
>   	return ret;
>   }
>   
> -static int vfio_bus_type(struct device *dev, void *data)
> -{
> -	struct bus_type **bus = data;
> -
> -	if (*bus && *bus != dev->bus)
> -		return -EINVAL;
> -
> -	*bus = dev->bus;
> -
> -	return 0;
> -}
> -
>   static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   			     struct vfio_domain *domain)
>   {
> @@ -2159,7 +2147,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   	struct vfio_iommu *iommu = iommu_data;
>   	struct vfio_iommu_group *group;
>   	struct vfio_domain *domain, *d;
> -	struct bus_type *bus = NULL;
> +	struct vfio_device *iommu_api_dev;
>   	bool resv_msi, msi_remap;
>   	phys_addr_t resv_msi_base = 0;
>   	struct iommu_domain_geometry *geo;
> @@ -2192,18 +2180,19 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   		goto out_unlock;
>   	}
>   
> -	/* Determine bus_type in order to allocate a domain */
> -	ret = iommu_group_for_each_dev(iommu_group, &bus, vfio_bus_type);
> -	if (ret)
> +	/* Resolve the group back to a member device for IOMMU API ops */
> +	ret = -ENODEV;
> +	iommu_api_dev = vfio_device_get_from_iommu(iommu_group);
> +	if (!iommu_api_dev)
>   		goto out_free_group;
>   
>   	ret = -ENOMEM;
>   	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
>   	if (!domain)
> -		goto out_free_group;
> +		goto out_put_dev;
>   
>   	ret = -EIO;
> -	domain->domain = iommu_domain_alloc(bus);
> +	domain->domain = iommu_domain_alloc(iommu_api_dev->dev->bus);
>   	if (!domain->domain)
>   		goto out_free_domain;
>   
> @@ -2258,7 +2247,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   	list_add(&group->next, &domain->group_list);
>   
>   	msi_remap = irq_domain_check_msi_remap() ||
> -		    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);
> +		    iommu_capable(iommu_api_dev->dev->bus, IOMMU_CAP_INTR_REMAP);
>   
>   	if (!allow_unsafe_interrupts && !msi_remap) {
>   		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
> @@ -2331,6 +2320,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   	iommu->num_non_pinned_groups++;
>   	mutex_unlock(&iommu->lock);
>   	vfio_iommu_resv_free(&group_resv_regions);
> +	vfio_device_put(iommu_api_dev);
>   
>   	return 0;
>   
> @@ -2342,6 +2332,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
>   	vfio_iommu_resv_free(&group_resv_regions);
>   out_free_domain:
>   	kfree(domain);
> +out_put_dev:
> +	vfio_device_put(iommu_api_dev);
>   out_free_group:
>   	kfree(group);
>   out_unlock:

