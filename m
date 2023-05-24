Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4843D70FF19
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 22:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbjEXUUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 16:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjEXUUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 16:20:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7005A113
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:20:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684959602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EegkfqA5EXlXDaMvCtZ7J4hr1cwSStqvb2N7Cuhj6OE=;
        b=Q2T0ZfjLP2MalDfub66nmgSbR+B1FDDDsgYlp/cctN8dVIuuHvRXiDQaglGlQ7Q+7ENwDG
        QTA4d6qKUXDTluMx7l8P1toqXyuL7yzZxuz8EnO51hTv9+137DezvguUv+QY9iCWuxns1o
        aAfF8N5Awz2la7DUmv6LZVtlpYMvgnQ=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-ssxpg5gbNuyYvGKEtdTwEg-1; Wed, 24 May 2023 16:20:01 -0400
X-MC-Unique: ssxpg5gbNuyYvGKEtdTwEg-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3381796d685so19464735ab.1
        for <kvm@vger.kernel.org>; Wed, 24 May 2023 13:20:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684959600; x=1687551600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EegkfqA5EXlXDaMvCtZ7J4hr1cwSStqvb2N7Cuhj6OE=;
        b=GNLqsBRu95NPmNrG9V4foEHT98aLkdlAvPpNT5/dO8Ey9D2cit8Cxj0raVANm01PJn
         dkNkdmRxTd2Ozu/K/u8gn2iQhap0XeaUuBUcVEG/QE4bkvJ7mWzMznU4yAu0KUBjeolu
         e03qG8dHxVy7iVEYBoMzV3tIdX5qT0QHYhy3niu6p84CP87SnRG7zc+XMxrv2oOxZrD5
         vRltRBFN8EM8XMgOyREOI6ZQQZ1zR16Fr5aGdb6xygBbTaV0mZGzsEYukffLib/0FmAG
         yMKAb+2cv2MvVzhJM0dm4g0POzryYrs0Yx58qfzdGIcrhlkIW9qaQEGNMxuC36HHhWo2
         ha2Q==
X-Gm-Message-State: AC+VfDz4KQjKxC8raSBvN7m+khMWNg7GhQX9/DjumbAR9apvMf7UW2Av
        Bax1JyhOLAlNW4xZe6AYwQsIhIKXk5cxWF2VDuXRR1LXpZtz8Pz44qaL2h+Tm1zimm54QAU2Zrj
        A12JaxOTnojzdN6/z+gnT
X-Received: by 2002:a92:d389:0:b0:328:8770:b9c2 with SMTP id o9-20020a92d389000000b003288770b9c2mr12706837ilo.14.1684959600172;
        Wed, 24 May 2023 13:20:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6FYSLSN+5lwBDopAeR4Gv749KmekrgMjBNu5QEmxHCyoEg5poCQBqc1LLm7wH3pqfsS9JOPQ==
X-Received: by 2002:a92:d389:0:b0:328:8770:b9c2 with SMTP id o9-20020a92d389000000b003288770b9c2mr12706825ilo.14.1684959599888;
        Wed, 24 May 2023 13:19:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b1-20020a029581000000b003c4e02148e5sm3333184jai.53.2023.05.24.13.19.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 13:19:59 -0700 (PDT)
Date:   Wed, 24 May 2023 14:19:56 -0600
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
Subject: Re: [PATCH v6 10/10] vfio/pci: Allow passing zero-length fd array
 in VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <20230524141956.3655fab5.alex.williamson@redhat.com>
In-Reply-To: <20230522115751.326947-11-yi.l.liu@intel.com>
References: <20230522115751.326947-1-yi.l.liu@intel.com>
        <20230522115751.326947-11-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 May 2023 04:57:51 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> This is the way user to invoke hot-reset for the devices opened by cdev
> interface. User should check the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED
> in the output of VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl before doing
> hot-reset for cdev devices.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 56 +++++++++++++++++++++++++-------
>  include/uapi/linux/vfio.h        | 14 ++++++++
>  2 files changed, 59 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 890065f846e4..67f1cb426505 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -181,7 +181,8 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  struct vfio_pci_group_info;
>  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups);
> +				      struct vfio_pci_group_info *groups,
> +				      struct iommufd_ctx *iommufd_ctx);
>  
>  /*
>   * INTx masking requires the ability to disable INTx signaling via PCI_COMMAND
> @@ -1301,8 +1302,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  	if (ret)
>  		return ret;
>  
> -	/* Somewhere between 1 and count is OK */
> -	if (!array_count || array_count > count)
> +	if (array_count > count || vfio_device_cdev_opened(&vdev->vdev))
>  		return -EINVAL;
>  
>  	group_fds = kcalloc(array_count, sizeof(*group_fds), GFP_KERNEL);
> @@ -1351,7 +1351,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  	info.count = array_count;
>  	info.files = files;
>  
> -	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> +	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info, NULL);
>  
>  hot_reset_release:
>  	for (file_idx--; file_idx >= 0; file_idx--)
> @@ -1380,7 +1380,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	else if (pci_probe_reset_bus(vdev->pdev->bus))
>  		return -ENODEV;
>  
> -	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> +	if (hdr.count)
> +		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, hdr.count, slot, arg);
> +
> +	return vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, NULL,
> +					  vfio_iommufd_device_ictx(&vdev->vdev));
>  }
>  
>  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
> @@ -2347,13 +2351,16 @@ const struct pci_error_handlers vfio_pci_core_err_handlers = {
>  };
>  EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
>  
> -static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> +static bool vfio_dev_in_groups(struct vfio_device *vdev,
>  			       struct vfio_pci_group_info *groups)
>  {
>  	unsigned int i;
>  
> +	if (!groups)
> +		return false;
> +
>  	for (i = 0; i < groups->count; i++)
> -		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> +		if (vfio_file_has_dev(groups->files[i], vdev))
>  			return true;
>  	return false;
>  }
> @@ -2429,7 +2436,8 @@ static int vfio_pci_dev_set_pm_runtime_get(struct vfio_device_set *dev_set)
>   * get each memory_lock.
>   */
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups)
> +				      struct vfio_pci_group_info *groups,
> +				      struct iommufd_ctx *iommufd_ctx)
>  {
>  	struct vfio_pci_core_device *cur_mem;
>  	struct vfio_pci_core_device *cur_vma;
> @@ -2459,11 +2467,37 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  		goto err_unlock;
>  
>  	list_for_each_entry(cur_vma, &dev_set->device_list, vdev.dev_set_list) {
> +		bool owned;
> +
>  		/*
> -		 * Test whether all the affected devices are contained by the
> -		 * set of groups provided by the user.
> +		 * Test whether all the affected devices can be reset by the
> +		 * user.
> +		 *
> +		 * If the user provides a set of groups, all the devices
> +		 * in the dev_set should be contained by the set of groups
> +		 * provided by the user.

"If called from a group opened device and the user provides a set of
groups,..."

> +		 *
> +		 * If the user provides a zero-length group fd array, then

"If called from a cdev opened device and the user provides a
zero-length array,..."


> +		 * all the devices in the dev_set must be bound to the same
> +		 * iommufd_ctx as the input iommufd_ctx.  If there is any
> +		 * device that has not been bound to iommufd_ctx yet, check
> +		 * if its iommu_group has any device bound to the input
> +		 * iommufd_ctx Such devices can be considered owned by

"."...........................^

> +		 * the input iommufd_ctx as the device cannot be owned
> +		 * by another iommufd_ctx when its iommu_group is owned.
> +		 *
> +		 * Otherwise, reset is not allowed.


In the case where a non-null array is provided,
vfio_pci_ioctl_pci_hot_reset_groups() explicitly tests
vfio_device_cdev_opened(), so we exclude cdev devices from providing a
group list.  However, what prevents a compat opened group device from
providing a null array?

I thought it would be that this function is called with groups == NULL
and therefore the vfio_dev_in_groups() test below fails, but I don't
think that's true for a compat opened device.  Thanks,

Alex


>  		 */
> -		if (!vfio_dev_in_groups(cur_vma, groups)) {
> +		if (iommufd_ctx) {
> +			int devid = vfio_iommufd_device_hot_reset_devid(&cur_vma->vdev,
> +									iommufd_ctx);
> +
> +			owned = (devid != VFIO_PCI_DEVID_NOT_OWNED);
> +		} else {
> +			owned = vfio_dev_in_groups(&cur_vma->vdev, groups);
> +		}
> +
> +		if (!owned) {
>  			ret = -EINVAL;
>  			goto err_undo;
>  		}
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 01203215251a..24858b650562 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -686,6 +686,9 @@ enum {
>   *	  Flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED would be set when all the
>   *	  affected devices are owned by the user.  This flag is available only
>   *	  when VFIO_PCI_HOT_RESET_FLAG_DEV_ID is set, otherwise reserved.
> + *	  When set, user could invoke VFIO_DEVICE_PCI_HOT_RESET with a zero
> + *	  length fd array on the calling device as the ownership is validated
> + *	  by iommufd_ctx.
>   *
>   * Return: 0 on success, -errno on failure:
>   *	-enospc = insufficient buffer, -enodev = unsupported for device.
> @@ -717,6 +720,17 @@ struct vfio_pci_hot_reset_info {
>   * VFIO_DEVICE_PCI_HOT_RESET - _IOW(VFIO_TYPE, VFIO_BASE + 13,
>   *				    struct vfio_pci_hot_reset)
>   *
> + * Userspace requests hot reset for the devices it operates.  Due to the
> + * underlying topology, multiple devices can be affected in the reset
> + * while some might be opened by another user.  To avoid interference
> + * the calling user must ensure all affected devices are owned by itself.
> + *
> + * As the ownership described by VFIO_DEVICE_GET_PCI_HOT_RESET_INFO, the
> + * cdev opened devices must exclusively provide a zero-length fd array and
> + * the group opened devices must exclusively use an array of group fds for
> + * proof of ownership.  Mixed access to devices between cdev and legacy
> + * groups are not supported by this interface.
> + *
>   * Return: 0 on success, -errno on failure.
>   */
>  struct vfio_pci_hot_reset {

