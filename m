Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509276D7877
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 11:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236931AbjDEJeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 05:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDEJen (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 05:34:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1624200
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 02:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680687156;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iJePrIKmM5p19yIm7M29IOK4mZgEMe/4wGNFN0wD5VI=;
        b=XVehvmbbe9TRuJNo5A8Ehe1bN3KYbTa2ssLYcM4ltWPb2jLcQ14yPFGRj+QUGR4NJjnMK3
        1CQp1YDnbi4tkrmhGFzNibn+T5ThwTCvhCUKb90YAwsKszBZFrYF9Sft+ZMHKDKXZesFMC
        KSFhTry/caMYm/TNkO6B2nIWQ6x/o6s=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-BVhfEG1SPmq2vzh9GQEDYQ-1; Wed, 05 Apr 2023 05:32:35 -0400
X-MC-Unique: BVhfEG1SPmq2vzh9GQEDYQ-1
Received: by mail-qv1-f69.google.com with SMTP id y19-20020ad445b3000000b005a5123cb627so15894657qvu.20
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 02:32:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680687155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJePrIKmM5p19yIm7M29IOK4mZgEMe/4wGNFN0wD5VI=;
        b=wq+2oLyJV9uHRSZXWiOSMuc6h7L9tzO/CYgl2D1ZSfA7bKKgzSW4V3nyWzq9bMNYoK
         mlx5Dt7kS919J4ZR+GdMAVbtKPgsZscgtLwCwTCabs9mH/KCE0cJ/r8a8tF9c9omSPnl
         LLQRxeQHRVyxxA0WnEmplJMm1j2QdKeku10oTI5baR178iIMPfIlJpZzWFG/19G1Ae0g
         aJMdcYc+Q+1Y78JGBWDS0mCNdk+JtJ3/Ocz6lNSVIR3r70xU6bGWom1V8GTXyNKaSEo0
         5xEQ1YemNPgh579QcxOV2l3k3MJJJRipUBlQ/snuIhiViCFs6xOnzhQo9N0WEsVdws1o
         WFdA==
X-Gm-Message-State: AAQBX9ejp76Y9ncZYyM8EhX/N8pxiL/57FY/SbjhD/P/A/jruf5OeO44
        fT3zmbMq7DsTaSLm4AVCVbc2KKzs0sYaYfae6zlOlURrJ3+9mxv4ylmwyUqosN4dnOBfzVrW4rC
        z8nnQvdq9eTnr
X-Received: by 2002:ac8:5d8d:0:b0:3bf:9f6e:a383 with SMTP id d13-20020ac85d8d000000b003bf9f6ea383mr3773377qtx.20.1680687154761;
        Wed, 05 Apr 2023 02:32:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350Za+7n9GSyWy9b45qFE/eA8nCSnC0CPFcZ7xK49KUKdqgO8AfWeVw15E1LUZ5+byQQ44jGWCQ==
X-Received: by 2002:ac8:5d8d:0:b0:3bf:9f6e:a383 with SMTP id d13-20020ac85d8d000000b003bf9f6ea383mr3773354qtx.20.1680687154483;
        Wed, 05 Apr 2023 02:32:34 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id h19-20020a05620a401300b0074589d41342sm1900175qko.17.2023.04.05.02.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 02:32:33 -0700 (PDT)
Message-ID: <4489a951-710f-a5b1-dcaf-f69d8b21f9fb@redhat.com>
Date:   Wed, 5 Apr 2023 11:32:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 08/12] vfio/pci: Renaming for accepting device fd in
 hot reset path
Content-Language: en-US
To:     Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     joro@8bytes.org, robin.murphy@arm.com, cohuck@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-9-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/1/23 16:44, Yi Liu wrote:
> No functional change is intended.
>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
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

