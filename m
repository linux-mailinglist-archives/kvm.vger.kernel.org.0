Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3119E62CEBC
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 00:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbiKPXcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 18:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiKPXce (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 18:32:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DF5F68697
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 15:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668641499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6zeJtuNwFdybeIiNnx/BlEJZCi37i4iRqtZKKgKEqBY=;
        b=fz7I3oJg4FSzolNa6Li75K3WG1FrBIEgAwbiIOadTWVVPik/aAuC7YWgIgJUV/qIBRQNBe
        1NvkZts3cqctPv4aqMEzp/OzmO9mKzsuj5EOs6/pMRzdUFcWM0DIL3TS6dV29afB5aqYBs
        UUXtJzwF4CnN2r5GYislf5WQDqbXBxk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-523-GXZAlK2DOiqdzdjx7-1oiA-1; Wed, 16 Nov 2022 18:31:37 -0500
X-MC-Unique: GXZAlK2DOiqdzdjx7-1oiA-1
Received: by mail-il1-f199.google.com with SMTP id l9-20020a056e02066900b0030259ce0d5eso115451ilt.20
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 15:31:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6zeJtuNwFdybeIiNnx/BlEJZCi37i4iRqtZKKgKEqBY=;
        b=EE16ix/TEe633rGwA/TEG3tO8yF1NWOlsyzEyEOPuPFgqO9jbIczA0QLw0S3otiGM9
         k+AGR2KJ+zPBcRtflWOsSP6bzuCpZtav9Fc5H3iKOl4H1d7sx+LdAGZ79+DSaeRDrSjW
         Xr60ELt7UnJgFMA75Yxyr5jVLFNQBc2PswozaPicrf8buZ72RjETCZtwEKkt65YBXBVd
         W5ESI3EQBxEztfB7eHp0JtzMBAILVOJ1c6x9k00J5kz6iH4xv7G8Ua00twEmK1Uhq7kZ
         i6zEhUhZII2zbEIg1ZVwfgPZI0NVUGMyIDciHZzXuB8qkxfGynPrfnE2E0Nh+1WqTXgt
         B4pg==
X-Gm-Message-State: ANoB5plKJPRSqw90yOiqMvcw3CishszUqrvKCXUE4z+u/enfXAqGDsNp
        HsVE9vuvX/vjCMaK9m3luSAHhOLyHfX59Ph+O7ad5A5n7lggKdd7mnS0ZiVP41lPZWUoYP13uuN
        zh5iQHZQ/KlOQ
X-Received: by 2002:a5e:8601:0:b0:6c0:92d2:7be1 with SMTP id z1-20020a5e8601000000b006c092d27be1mr267614ioj.62.1668641497289;
        Wed, 16 Nov 2022 15:31:37 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6yK5qwjvI0SB5ocXwCpsNU6GgebPHSRIS5b1HFSGKNP4awlFj+oaZWKcgwUWOKKhfTZcu0hw==
X-Received: by 2002:a5e:8601:0:b0:6c0:92d2:7be1 with SMTP id z1-20020a5e8601000000b006c092d27be1mr267602ioj.62.1668641496980;
        Wed, 16 Nov 2022 15:31:36 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ca9-20020a0566381c0900b003754394cc3bsm6122448jab.114.2022.11.16.15.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Nov 2022 15:31:36 -0800 (PST)
Date:   Wed, 16 Nov 2022 16:31:33 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 06/11] vfio-iommufd: Allow iommufd to be used in
 place of a container fd
Message-ID: <20221116163133.7303b0ed.alex.williamson@redhat.com>
In-Reply-To: <6-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
        <6-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Nov 2022 17:05:31 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This makes VFIO_GROUP_SET_CONTAINER accept both a vfio container FD and an
> iommufd.
> 
> In iommufd mode an IOAS will exist after the SET_CONTAINER, but it will
> not be attached to any groups.
> 
> For VFIO this means that the VFIO_GROUP_GET_STATUS and
> VFIO_GROUP_FLAGS_VIABLE works subtly differently. With the container FD
> the iommu_group_claim_dma_owner() is done during SET_CONTAINER but for
> IOMMUFD this is done during VFIO_GROUP_GET_DEVICE_FD. Meaning that
> VFIO_GROUP_FLAGS_VIABLE could be set but GET_DEVICE_FD will fail due to
> viability.
> 
> As GET_DEVICE_FD can fail for many reasons already this is not expected to
> be a meaningful difference.
> 
> Reorganize the tests for if the group has an assigned container or iommu
> into a vfio_group_has_iommu() function and consolidate all the duplicated
> WARN_ON's etc related to this.
> 
> Call container functions only if a container is actually present on the
> group.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yi Liu <yi.l.liu@intel.com>
> Tested-by: Lixiao Yang <lixiao.yang@intel.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yu He <yu.he@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/Kconfig     |  1 +
>  drivers/vfio/container.c |  7 +++-
>  drivers/vfio/vfio.h      |  2 +
>  drivers/vfio/vfio_main.c | 86 +++++++++++++++++++++++++++++++++-------
>  4 files changed, 80 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 86c381ceb9a1e9..1118d322eec97d 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -2,6 +2,7 @@
>  menuconfig VFIO
>  	tristate "VFIO Non-Privileged userspace driver framework"
>  	select IOMMU_API
> +	depends on IOMMUFD || !IOMMUFD
>  	select VFIO_IOMMU_TYPE1 if MMU && (X86 || S390 || ARM || ARM64)
>  	select INTERVAL_TREE
>  	help
> diff --git a/drivers/vfio/container.c b/drivers/vfio/container.c
> index d97747dfb05d02..8772dad6808539 100644
> --- a/drivers/vfio/container.c
> +++ b/drivers/vfio/container.c
> @@ -516,8 +516,11 @@ int vfio_group_use_container(struct vfio_group *group)
>  {
>  	lockdep_assert_held(&group->group_lock);
>  
> -	if (!group->container || !group->container->iommu_driver ||
> -	    WARN_ON(!group->container_users))
> +	/*
> +	 * The container fd has been assigned with VFIO_GROUP_SET_CONTAINER but
> +	 * VFIO_SET_IOMMU hasn't been done yet.
> +	 */
> +	if (!group->container->iommu_driver)
>  		return -EINVAL;
>  
>  	if (group->type == VFIO_NO_IOMMU && !capable(CAP_SYS_RAWIO))
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 247590334e14b0..985e13d52989ca 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -10,6 +10,7 @@
>  #include <linux/cdev.h>
>  #include <linux/module.h>
>  
> +struct iommufd_ctx;
>  struct iommu_group;
>  struct vfio_device;
>  struct vfio_container;
> @@ -60,6 +61,7 @@ struct vfio_group {
>  	struct kvm			*kvm;
>  	struct file			*opened_file;
>  	struct blocking_notifier_head	notifier;
> +	struct iommufd_ctx		*iommufd;
>  };
>  
>  /* events for the backend driver notify callback */
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5c0e810f8b4d08..8c124290ce9f0d 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -35,6 +35,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/interval_tree.h>
>  #include <linux/iova_bitmap.h>
> +#include <linux/iommufd.h>
>  #include "vfio.h"
>  
>  #define DRIVER_VERSION	"0.3"
> @@ -665,6 +666,16 @@ EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>  /*
>   * VFIO Group fd, /dev/vfio/$GROUP
>   */
> +static bool vfio_group_has_iommu(struct vfio_group *group)
> +{
> +	lockdep_assert_held(&group->group_lock);
> +	if (!group->container)
> +		WARN_ON(group->container_users);
> +	else
> +		WARN_ON(!group->container_users);

I think this is just carrying forward the WARN_ON that gets replaced in
set_container, but I don't really see how this bit of paranoia is ever
a possibility.  If it is, a comment would be good, and perhaps simplify
to:

	WARN_ON(group->container ^ group->container_users);


> +	return group->container || group->iommufd;
> +}
> +
>  /*
>   * VFIO_GROUP_UNSET_CONTAINER should fail if there are other users or
>   * if there was no container to unset.  Since the ioctl is called on
[snip]
> @@ -900,7 +945,14 @@ static int vfio_group_ioctl_get_status(struct vfio_group *group,
>  		return -ENODEV;
>  	}
>  
> -	if (group->container)
> +	/*
> +	 * With the container FD the iommu_group_claim_dma_owner() is done
> +	 * during SET_CONTAINER but for IOMMFD this is done during
> +	 * VFIO_GROUP_GET_DEVICE_FD. Meaning that with iommufd
> +	 * VFIO_GROUP_FLAGS_VIABLE could be set but GET_DEVICE_FD will fail due
> +	 * to viability.
> +	 */
> +	if (group->container || group->iommufd)

Why didn't this use the vfio_group_has_iommu() helper?  This is only
skipping the paranoia checks, which aren't currently obvious to me
anyway.  Thanks,

Alex

>  		status.flags |= VFIO_GROUP_FLAGS_CONTAINER_SET |
>  				VFIO_GROUP_FLAGS_VIABLE;
>  	else if (!iommu_group_dma_owner_claimed(group->iommu_group))

