Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BB76D6EE1
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 23:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236398AbjDDVYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 17:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbjDDVYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 17:24:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036EB19BD
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 14:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680643430;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wN65mwnOl0cJ7VCIj2dGHYdaX8HViyuK9uZH/ketQAk=;
        b=g/L2PVCdPMqOWRjXrq+qa4LZ9S/d1RN8javZaX4dQRMlamYp8pkqXEo93K+/wzaIaOZ6oK
        P61/MvKkygyqZJfoobVJg16UbEfkCXAovGStr2No3MOIob2EGyi03fUIrTl7gRM5yLBJPd
        1vyk9w1SEfZ6cU95NKPSKjgxUoe5Dgk=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-230-OqS77cg2M1mUBVBGBWTTGA-1; Tue, 04 Apr 2023 17:23:49 -0400
X-MC-Unique: OqS77cg2M1mUBVBGBWTTGA-1
Received: by mail-il1-f198.google.com with SMTP id d6-20020a92d786000000b00316f1737173so22738770iln.16
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 14:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680643426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wN65mwnOl0cJ7VCIj2dGHYdaX8HViyuK9uZH/ketQAk=;
        b=pISKHhFO+Lq+XF1N2up+c63bABa2DxGMpLlFdiicqI15aPdhByMbHCgew0tAk298ys
         wkWEpxMnsPkAkCAcH8uTczeV5cV4VvxYlf2d1CKI192VkhViCHejwxo9+Af4ejQTAItv
         cbIuZefvuPZx1gXnbPmFStbo9iJvldg1ohQlw+1yriLAC6zL5FvYxjZX6RCbE317azoA
         APICthcOf9yOjGfCtEsxQocx01rfCQlf/UoWk7X9SWH4q8edZR5+08H4piGoiayniC8L
         7rXRJTUmRNCWr48kWA25+C6vf1nUMR+Q9hH2gzpFBOX5H2kyvl9o3pd338p5ffPTIC6D
         5Bhg==
X-Gm-Message-State: AAQBX9cztrkfRLEbwGO+A4NgmaLWLiBzaeh6I07gK+ZSsGwNHIpJn7qg
        r0cz+VbQ0HB3HSEMTaOLooaF7qg2anuSXDtT0cEWuvjp6jDCF2b6Vn9vbaOfAjQkWjVuUvFVZe6
        cl2iJAP7srAXg
X-Received: by 2002:a6b:f60a:0:b0:75a:abfc:27e4 with SMTP id n10-20020a6bf60a000000b0075aabfc27e4mr3106499ioh.9.1680643426535;
        Tue, 04 Apr 2023 14:23:46 -0700 (PDT)
X-Google-Smtp-Source: AKy350aSgkWP5XhDrBsbjSoZ+3Kif0QnEue2HBucu6oUQFbA8Hwc5thex8OPsB0pvMBLSJ/0rcTV8g==
X-Received: by 2002:a6b:f60a:0:b0:75a:abfc:27e4 with SMTP id n10-20020a6bf60a000000b0075aabfc27e4mr3106482ioh.9.1680643426207;
        Tue, 04 Apr 2023 14:23:46 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id u20-20020a6be914000000b0074c8a021d4csm3563919iof.44.2023.04.04.14.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 14:23:45 -0700 (PDT)
Date:   Tue, 4 Apr 2023 15:23:43 -0600
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 08/12] vfio/pci: Renaming for accepting device fd in
 hot reset path
Message-ID: <20230404152343.790d6e78.alex.williamson@redhat.com>
In-Reply-To: <20230401144429.88673-9-yi.l.liu@intel.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
        <20230401144429.88673-9-yi.l.liu@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat,  1 Apr 2023 07:44:25 -0700
Yi Liu <yi.l.liu@intel.com> wrote:

> No functional change is intended.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 52 ++++++++++++++++----------------
>  1 file changed, 26 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 2a510b71edcb..da6325008872 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -177,10 +177,10 @@ static void vfio_pci_probe_mmaps(struct vfio_pci_core_device *vdev)
>  	}
>  }
>  
> -struct vfio_pci_group_info;
> +struct vfio_pci_file_info;
>  static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set);
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups,
> +				      struct vfio_pci_file_info *info,
>  				      struct iommufd_ctx *iommufd_ctx);
>  
>  /*
> @@ -800,7 +800,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
>  	return 0;
>  }
>  
> -struct vfio_pci_group_info {
> +struct vfio_pci_file_info {
>  	int count;
>  	struct file **files;
>  };
> @@ -1257,14 +1257,14 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  }
>  
>  static int
> -vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
> -				    struct vfio_pci_hot_reset *hdr,
> -				    bool slot,
> -				    struct vfio_pci_hot_reset __user *arg)
> +vfio_pci_ioctl_pci_hot_reset_files(struct vfio_pci_core_device *vdev,
> +				   struct vfio_pci_hot_reset *hdr,
> +				   bool slot,
> +				   struct vfio_pci_hot_reset __user *arg)
>  {
> -	int32_t *group_fds;
> +	int32_t *fds;
>  	struct file **files;
> -	struct vfio_pci_group_info info;
> +	struct vfio_pci_file_info info;
>  	int file_idx, count = 0, ret = 0;
>  
>  	/*
> @@ -1281,17 +1281,17 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  	if (hdr->count > count)
>  		return -EINVAL;
>  
> -	group_fds = kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
> +	fds = kcalloc(hdr->count, sizeof(*fds), GFP_KERNEL);
>  	files = kcalloc(hdr->count, sizeof(*files), GFP_KERNEL);
> -	if (!group_fds || !files) {
> -		kfree(group_fds);
> +	if (!fds || !files) {
> +		kfree(fds);
>  		kfree(files);
>  		return -ENOMEM;
>  	}
>  
> -	if (copy_from_user(group_fds, arg->group_fds,
> -			   hdr->count * sizeof(*group_fds))) {
> -		kfree(group_fds);
> +	if (copy_from_user(fds, arg->group_fds,
> +			   hdr->count * sizeof(*fds))) {
> +		kfree(fds);
>  		kfree(files);
>  		return -EFAULT;
>  	}
> @@ -1301,7 +1301,7 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  	 * the reset
>  	 */
>  	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
> -		struct file *file = fget(group_fds[file_idx]);
> +		struct file *file = fget(fds[file_idx]);
>  
>  		if (!file) {
>  			ret = -EBADF;
> @@ -1318,9 +1318,9 @@ vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
>  		files[file_idx] = file;
>  	}
>  
> -	kfree(group_fds);
> +	kfree(fds);
>  
> -	/* release reference to groups on error */
> +	/* release reference to fds on error */
>  	if (ret)
>  		goto hot_reset_release;
>  
> @@ -1358,7 +1358,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  		return -ENODEV;
>  
>  	if (hdr.count)
> -		return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
> +		return vfio_pci_ioctl_pci_hot_reset_files(vdev, &hdr, slot, arg);
>  
>  	iommufd = vfio_iommufd_physical_ictx(&vdev->vdev);
>  
> @@ -2329,16 +2329,16 @@ const struct pci_error_handlers vfio_pci_core_err_handlers = {
>  };
>  EXPORT_SYMBOL_GPL(vfio_pci_core_err_handlers);
>  
> -static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
> -			       struct vfio_pci_group_info *groups)
> +static bool vfio_dev_in_files(struct vfio_pci_core_device *vdev,
> +			      struct vfio_pci_file_info *info)
>  {
>  	unsigned int i;
>  
> -	if (!groups)
> +	if (!info)
>  		return false;
>  
> -	for (i = 0; i < groups->count; i++)
> -		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
> +	for (i = 0; i < info->count; i++)
> +		if (vfio_file_has_dev(info->files[i], &vdev->vdev))
>  			return true;
>  	return false;
>  }
> @@ -2429,7 +2429,7 @@ static bool vfio_dev_in_iommufd_ctx(struct vfio_pci_core_device *vdev,
>   * get each memory_lock.
>   */
>  static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
> -				      struct vfio_pci_group_info *groups,
> +				      struct vfio_pci_file_info *info,
>  				      struct iommufd_ctx *iommufd_ctx)
>  {
>  	struct vfio_pci_core_device *cur_mem;
> @@ -2478,7 +2478,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>  		 * the calling device is in a singleton dev_set.
>  		 */
>  		if (cur_vma->vdev.open_count &&
> -		    !vfio_dev_in_groups(cur_vma, groups) &&
> +		    !vfio_dev_in_files(cur_vma, info) &&
>  		    !vfio_dev_in_iommufd_ctx(cur_vma, iommufd_ctx) &&
>  		    (dev_set->device_count > 1)) {
>  			ret = -EINVAL;

At this point, vfio_dev_in_files() supports both group and cdev fds and
these can be used for both regular IOMMU protected and no-IOMMU
devices AFAICT.  We only add this 1-off dev_set device count test and
its subtle side-effects in order to support the null-array mode, which
IMO really has yet to be shown as a requirement.

IIRC, we were wanting to add that mode as part of the cdev interface so
that the existence of cdevs implies this support, but now we're already
making use of vfio_pci_hot_reset_info.flags to indicate group-id vs
dev-id in the output, so does anything prevent us from setting another
bit there if/when this feature proves itself useful and error free, to
indicate it's an available mode for the hot-reset ioctl?

With that I think we could drop patches 4 & 5 with a plan for
introducing them later without trying to strong arm the feature in
without a proven and available use case now.  Thanks,

Alex

