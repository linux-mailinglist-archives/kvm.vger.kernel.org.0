Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335D072D39C
	for <lists+kvm@lfdr.de>; Mon, 12 Jun 2023 23:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238341AbjFLVxc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jun 2023 17:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238556AbjFLVxK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jun 2023 17:53:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15DE10DF
        for <kvm@vger.kernel.org>; Mon, 12 Jun 2023 14:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686606736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ztcLq6iN7Kxeqcv6DBtb36tEcmqErOPWSDB6ZeSMBrg=;
        b=RI4s42HzmKJMPDvHkrTgeGjk34igl4yX05wW4ISjiOBPRTS/1m8ZQNZmwKEVV5U/XAshyp
        qIdew8YL5pfjfQQawRKga2T3z37JX/cXo1+6ry2z46qmlhvv7L0WrhwkmcvDVTzbgtgQA4
        FYktcmVbqeC50NlnsevY2F3motIOmqA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-288-K4ZwTKK3OaWhVGOMFP2ROg-1; Mon, 12 Jun 2023 17:52:11 -0400
X-MC-Unique: K4ZwTKK3OaWhVGOMFP2ROg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F1508032FE;
        Mon, 12 Jun 2023 21:52:09 +0000 (UTC)
Received: from omen (unknown [10.22.33.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F912C034A3;
        Mon, 12 Jun 2023 21:52:07 +0000 (UTC)
Date:   Mon, 12 Jun 2023 15:52:07 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     jgg@nvidia.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v12 06/24] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Message-ID: <20230612155207.51d8cf1d@omen>
In-Reply-To: <20230602121653.80017-7-yi.l.liu@intel.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-7-yi.l.liu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Jun 2023 05:16:35 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This avoids passing too much parameters in multiple functions. Per the
> input parameter change, rename the function to be vfio_df_open/close().
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c     | 20 ++++++++++++++------
>  drivers/vfio/vfio.h      |  8 ++++----
>  drivers/vfio/vfio_main.c | 25 +++++++++++++++----------
>  3 files changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index b56e19d2a02d..caf53716ddb2 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -169,8 +169,9 @@ static void vfio_device_group_get_kvm_safe(struct vfio_device *device)
>  	spin_unlock(&device->group->kvm_ref_lock);
>  }
>  
> -static int vfio_device_group_open(struct vfio_device *device)
> +static int vfio_df_group_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
>  	int ret;
>  
>  	mutex_lock(&device->group->group_lock);
> @@ -190,7 +191,11 @@ static int vfio_device_group_open(struct vfio_device *device)
>  	if (device->open_count == 0)
>  		vfio_device_group_get_kvm_safe(device);
>  
> -	ret = vfio_device_open(device, device->group->iommufd);
> +	df->iommufd = device->group->iommufd;
> +
> +	ret = vfio_df_open(df);
> +	if (ret)
> +		df->iommufd = NULL;
>  
>  	if (device->open_count == 0)
>  		vfio_device_put_kvm(device);
> @@ -202,12 +207,15 @@ static int vfio_device_group_open(struct vfio_device *device)
>  	return ret;
>  }
>  
> -void vfio_device_group_close(struct vfio_device *device)
> +void vfio_df_group_close(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +
>  	mutex_lock(&device->group->group_lock);
>  	mutex_lock(&device->dev_set->lock);
>  
> -	vfio_device_close(device, device->group->iommufd);
> +	vfio_df_close(df);
> +	df->iommufd = NULL;
>  
>  	if (device->open_count == 0)
>  		vfio_device_put_kvm(device);
> @@ -228,7 +236,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  		goto err_out;
>  	}
>  
> -	ret = vfio_device_group_open(device);
> +	ret = vfio_df_group_open(df);
>  	if (ret)
>  		goto err_free;
>  
> @@ -260,7 +268,7 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
>  	return filep;
>  
>  err_close_device:
> -	vfio_device_group_close(device);
> +	vfio_df_group_close(df);
>  err_free:
>  	kfree(df);
>  err_out:
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index 69e1a0692b06..f9eb52eb9ed7 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -20,13 +20,13 @@ struct vfio_device_file {
>  	struct vfio_device *device;
>  	spinlock_t kvm_ref_lock; /* protect kvm field */
>  	struct kvm *kvm;
> +	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
>  };
>  
>  void vfio_device_put_registration(struct vfio_device *device);
>  bool vfio_device_try_get_registration(struct vfio_device *device);
> -int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd);
> -void vfio_device_close(struct vfio_device *device,
> -		       struct iommufd_ctx *iommufd);
> +int vfio_df_open(struct vfio_device_file *df);
> +void vfio_df_close(struct vfio_device_file *df);
>  struct vfio_device_file *
>  vfio_allocate_device_file(struct vfio_device *device);
>  
> @@ -91,7 +91,7 @@ void vfio_device_group_register(struct vfio_device *device);
>  void vfio_device_group_unregister(struct vfio_device *device);
>  int vfio_device_group_use_iommu(struct vfio_device *device);
>  void vfio_device_group_unuse_iommu(struct vfio_device *device);
> -void vfio_device_group_close(struct vfio_device *device);
> +void vfio_df_group_close(struct vfio_device_file *df);
>  struct vfio_group *vfio_group_from_file(struct file *file);
>  bool vfio_group_enforced_coherent(struct vfio_group *group);
>  void vfio_group_set_kvm(struct vfio_group *group, struct kvm *kvm);
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 8ef9210ad2aa..a3c5817fc545 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -434,9 +434,10 @@ vfio_allocate_device_file(struct vfio_device *device)
>  	return df;
>  }
>  
> -static int vfio_device_first_open(struct vfio_device *device,
> -				  struct iommufd_ctx *iommufd)
> +static int vfio_device_first_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +	struct iommufd_ctx *iommufd = df->iommufd;
>  	int ret;
>  
>  	lockdep_assert_held(&device->dev_set->lock);
> @@ -468,9 +469,11 @@ static int vfio_device_first_open(struct vfio_device *device,
>  	return ret;
>  }
>  
> -static void vfio_device_last_close(struct vfio_device *device,
> -				   struct iommufd_ctx *iommufd)
> +static void vfio_device_last_close(struct vfio_device_file *df)

Shouldn't these now be vfio_df_... functions too?  Thanks,

Ale

>  {
> +	struct vfio_device *device = df->device;
> +	struct iommufd_ctx *iommufd = df->iommufd;
> +
>  	lockdep_assert_held(&device->dev_set->lock);
>  
>  	if (device->ops->close_device)
> @@ -482,15 +485,16 @@ static void vfio_device_last_close(struct vfio_device *device,
>  	module_put(device->dev->driver->owner);
>  }
>  
> -int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
> +int vfio_df_open(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
>  	int ret = 0;
>  
>  	lockdep_assert_held(&device->dev_set->lock);
>  
>  	device->open_count++;
>  	if (device->open_count == 1) {
> -		ret = vfio_device_first_open(device, iommufd);
> +		ret = vfio_device_first_open(df);
>  		if (ret)
>  			device->open_count--;
>  	}
> @@ -498,14 +502,15 @@ int vfio_device_open(struct vfio_device *device, struct iommufd_ctx *iommufd)
>  	return ret;
>  }
>  
> -void vfio_device_close(struct vfio_device *device,
> -		       struct iommufd_ctx *iommufd)
> +void vfio_df_close(struct vfio_device_file *df)
>  {
> +	struct vfio_device *device = df->device;
> +
>  	lockdep_assert_held(&device->dev_set->lock);
>  
>  	vfio_assert_device_open(device);
>  	if (device->open_count == 1)
> -		vfio_device_last_close(device, iommufd);
> +		vfio_device_last_close(df);
>  	device->open_count--;
>  }
>  
> @@ -550,7 +555,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	struct vfio_device_file *df = filep->private_data;
>  	struct vfio_device *device = df->device;
>  
> -	vfio_device_group_close(device);
> +	vfio_df_group_close(df);
>  
>  	vfio_device_put_registration(device);
>  

