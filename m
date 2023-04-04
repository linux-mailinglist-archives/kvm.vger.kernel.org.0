Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F8F6D64A4
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbjDDOFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbjDDOFh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:05:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370353C06
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 07:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680616984;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wxXQaGpyUM5ChSgPSymgIrV3xjP+dbX+YB7Kwp3u8FE=;
        b=MdX4iDREjiqaIQzSWDrZ+zYqIEDfrcB/sYnRV8f/gPQgtncwDPbE6OctHZpUZeOscuj+O/
        9geKy6G0HkPV4TAsxczNL66+Ct6Dw9FER+eUofHay2GlMPTblt6dmq8B3QM8MRIOmuyatl
        ZdfE1vaw5m9CqL7QyOKT3xpfhOBWTzo=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-ItWXl_EyPuGwBQPs-6Fx_g-1; Tue, 04 Apr 2023 09:59:41 -0400
X-MC-Unique: ItWXl_EyPuGwBQPs-6Fx_g-1
Received: by mail-qt1-f198.google.com with SMTP id w13-20020ac857cd000000b003e37d3e6de2so22218291qta.16
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 06:59:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680616780;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wxXQaGpyUM5ChSgPSymgIrV3xjP+dbX+YB7Kwp3u8FE=;
        b=zf+EXPvScJ2XTihZwufua7eZuImOqpknIQYD7a+VJHnFHNjU3Fzk/2wdxVdYdu+ZiD
         FegwK82AxTXuzmg4vSTbWN5xPA3UDcvBdktGd5k/bOJKKi4G8fdaYePM+qAyacX3JnKm
         tI6gTMu789EQokXtsCFEDTV1qjPdbEZBtW7IRm89xbiMTpxV9zLOsDenPzJ8RN8moSDo
         FIs9RwDYzof1umMU0MEpbMyPKQwMFFlTkPApslBWeCFT3XHxOEzW4iU9B85CR7KGQ3Pr
         woAvtGF8sTztjkb787GMyWZP/gLhY9Wu0SKXMNPMCxGYRuoG7ZrVvlNOOkRiAPZ3fwvW
         mXOQ==
X-Gm-Message-State: AAQBX9cDz87vFqnOCJWm4w6iXy9Os+EFS8uMeDdK7gPMH0dCZM9m4lvW
        ZE2nP9MKRvv+fhKbHfbmp0KrFIVCBr2giF55WgFhJkbOBL8m0aQxsz6dm3xincXMlIkzr58C+9N
        ZYM15Sz6kdwd3
X-Received: by 2002:ac8:5990:0:b0:3bf:e364:1d19 with SMTP id e16-20020ac85990000000b003bfe3641d19mr3487122qte.54.1680616779656;
        Tue, 04 Apr 2023 06:59:39 -0700 (PDT)
X-Google-Smtp-Source: AKy350bCWWuuTxHWY9DOMfflmCQARBlvG/akS0xtd4IuYfgAD/YTofqLq6p8mh4g/QJi69uADkX8yQ==
X-Received: by 2002:ac8:5990:0:b0:3bf:e364:1d19 with SMTP id e16-20020ac85990000000b003bfe3641d19mr3487031qte.54.1680616778531;
        Tue, 04 Apr 2023 06:59:38 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id l26-20020a37f91a000000b007422eee8058sm3597749qkj.125.2023.04.04.06.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 06:59:37 -0700 (PDT)
Message-ID: <4bc269aa-f2b9-d8ac-82bf-2205d05e4b11@redhat.com>
Date:   Tue, 4 Apr 2023 15:59:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v3 03/12] vfio/pci: Move the existing hot reset logic to
 be a helper
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
 <20230401144429.88673-4-yi.l.liu@intel.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230401144429.88673-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

On 4/1/23 16:44, Yi Liu wrote:
> This prepares to add another method for hot reset. The major hot reset logic
> are moved to vfio_pci_ioctl_pci_hot_reset_groups().
>
> No functional change is intended.
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 56 +++++++++++++++++++-------------
>  1 file changed, 33 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 5d745c9abf05..3696b8e58445 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1255,29 +1255,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
>  	return ret;
>  }
>  
> -static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
> -					struct vfio_pci_hot_reset __user *arg)
> +static int
> +vfio_pci_ioctl_pci_hot_reset_groups(struct vfio_pci_core_device *vdev,
> +				    struct vfio_pci_hot_reset *hdr,
nit why don't you simply pass the user group count as decoded earlier.
hdr sounds like a dup of arg.
> +				    bool slot,
> +				    struct vfio_pci_hot_reset __user *arg)
>  {
> -	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
> -	struct vfio_pci_hot_reset hdr;
>  	int32_t *group_fds;
>  	struct file **files;
>  	struct vfio_pci_group_info info;
> -	bool slot = false;
>  	int file_idx, count = 0, ret = 0;
>  
> -	if (copy_from_user(&hdr, arg, minsz))
> -		return -EFAULT;
> -
> -	if (hdr.argsz < minsz || hdr.flags)
> -		return -EINVAL;
> -
> -	/* Can we do a slot or bus reset or neither? */
> -	if (!pci_probe_reset_slot(vdev->pdev->slot))
> -		slot = true;
> -	else if (pci_probe_reset_bus(vdev->pdev->bus))
> -		return -ENODEV;
> -
>  	/*
>  	 * We can't let userspace give us an arbitrarily large buffer to copy,
>  	 * so verify how many we think there could be.  Note groups can have
> @@ -1289,11 +1277,11 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  		return ret;
>  
>  	/* Somewhere between 1 and count is OK */
> -	if (!hdr.count || hdr.count > count)
> +	if (!hdr->count || hdr->count > count)
>  		return -EINVAL;
>  
> -	group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
> -	files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
> +	group_fds = kcalloc(hdr->count, sizeof(*group_fds), GFP_KERNEL);
> +	files = kcalloc(hdr->count, sizeof(*files), GFP_KERNEL);
>  	if (!group_fds || !files) {
>  		kfree(group_fds);
>  		kfree(files);
> @@ -1301,7 +1289,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	}
>  
>  	if (copy_from_user(group_fds, arg->group_fds,
> -			   hdr.count * sizeof(*group_fds))) {
> +			   hdr->count * sizeof(*group_fds))) {
>  		kfree(group_fds);
>  		kfree(files);
>  		return -EFAULT;
> @@ -1311,7 +1299,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	 * Get the group file for each fd to ensure the group held across
>  	 * the reset
>  	 */
> -	for (file_idx = 0; file_idx < hdr.count; file_idx++) {
> +	for (file_idx = 0; file_idx < hdr->count; file_idx++) {
>  		struct file *file = fget(group_fds[file_idx]);
>  
>  		if (!file) {
> @@ -1335,7 +1323,7 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	if (ret)
>  		goto hot_reset_release;
>  
> -	info.count = hdr.count;
> +	info.count = hdr->count;
>  	info.files = files;
>  
>  	ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
> @@ -1348,6 +1336,28 @@ static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
>  	return ret;
>  }
>  
> +static int vfio_pci_ioctl_pci_hot_reset(struct vfio_pci_core_device *vdev,
> +					struct vfio_pci_hot_reset __user *arg)
> +{
> +	unsigned long minsz = offsetofend(struct vfio_pci_hot_reset, count);
> +	struct vfio_pci_hot_reset hdr;
> +	bool slot = false;
> +
> +	if (copy_from_user(&hdr, arg, minsz))
> +		return -EFAULT;
> +
> +	if (hdr.argsz < minsz || hdr.flags)
> +		return -EINVAL;
> +
> +	/* Can we do a slot or bus reset or neither? */
> +	if (!pci_probe_reset_slot(vdev->pdev->slot))
> +		slot = true;
> +	else if (pci_probe_reset_bus(vdev->pdev->bus))
> +		return -ENODEV;
> +
> +	return vfio_pci_ioctl_pci_hot_reset_groups(vdev, &hdr, slot, arg);
> +}
> +
>  static int vfio_pci_ioctl_ioeventfd(struct vfio_pci_core_device *vdev,
>  				    struct vfio_device_ioeventfd __user *arg)
>  {
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

