Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5210E4AFF58
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 22:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiBIVlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 16:41:45 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiBIVll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 16:41:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD1A5DF28AD4
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 13:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644442903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnKaJ3fYeFxAypTgfkLzFAKETIOGKeliSE47QqKxh2M=;
        b=Iw5Z6eHCFm4Gz6L/AJzflTQEQ56xX0KQurAS1sUT8Su2D5YkNkyUZc6X2mNqSAeesadcXt
        NEQPad0ZBkx8Xmfvh+mWDy0E2dX9qqAfgtrGXv/XMJaQQuKrIdd0v5YJQspGAw7ZitrO0I
        RPaLqepiV4fodE1QaYg9JMKdvuiOWNk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-64-yMKwfENKOLWDguWZALC83Q-1; Wed, 09 Feb 2022 16:41:42 -0500
X-MC-Unique: yMKwfENKOLWDguWZALC83Q-1
Received: by mail-io1-f71.google.com with SMTP id y124-20020a6bc882000000b0060fbfe14d03so2727825iof.2
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 13:41:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=vnKaJ3fYeFxAypTgfkLzFAKETIOGKeliSE47QqKxh2M=;
        b=A/CVSYwJZDbpzmPMaQJ1n1wRMRdzVh2yAzxQsx/xjPL7fMHwxGYqCc0cvwcVVlKc9E
         0LXsnoVFLUwjPWNMlKHnKg2GgYY35OD3SnghEg/oyqaEIVzbB8nSrYCuGNbz3sRphHCp
         OTK9q+qAmdixpVMSF+fEOMZ/Fouj6Hh2bcLOgrB7Jqfp+Xgu4Ugaxj/GBWQFLy7FHocA
         W40AYr02MWbyTCXDTfqnVTIKe85BumMvc/awK6YHZgjxkQhlU02lfW1+GD2TZA3nCe3k
         6EiGldKMlWQC7jbW7r44XA9qM6YyuLPbtySUZXYGdLeZq25OYvjyWTTuUe83p2IZBCQm
         S1cA==
X-Gm-Message-State: AOAM533vOzZXijiCNllSy9axOumyOJyuJopNtMibgPQV406Smn+L5ilF
        fSV+0SuYJZlsAs3hzixhD/slb67pl3XYDf8dzOM1J65S3G45vd5UcIRCsOyynu0dI4y1/vvfzX1
        /ffHpIw5jJ2eF
X-Received: by 2002:a5d:9151:: with SMTP id y17mr2084025ioq.38.1644442901149;
        Wed, 09 Feb 2022 13:41:41 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzvob5cspw1EkMKIhhQ6npdyq3pXbPN3p0dVlPXKwvxH2DJtktWfnTq/mijkoSW585QW8ijsQ==
X-Received: by 2002:a5d:9151:: with SMTP id y17mr2084013ioq.38.1644442900953;
        Wed, 09 Feb 2022 13:41:40 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a6sm10552396iow.22.2022.02.09.13.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 13:41:40 -0800 (PST)
Date:   Wed, 9 Feb 2022 14:41:37 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <jgg@nvidia.com>,
        <cohuck@redhat.com>, <mgurtovoy@nvidia.com>, <yishaih@nvidia.com>,
        <linuxarm@huawei.com>, <liulongfang@huawei.com>,
        <prime.zeng@hisilicon.com>, <jonathan.cameron@huawei.com>,
        <wangzhou1@hisilicon.com>
Subject: Re: [RFC v4 5/8] hisi_acc_vfio_pci: Restrict access to VF dev BAR2
 migration region
Message-ID: <20220209144137.3770d914.alex.williamson@redhat.com>
In-Reply-To: <20220208133425.1096-6-shameerali.kolothum.thodi@huawei.com>
References: <20220208133425.1096-1-shameerali.kolothum.thodi@huawei.com>
        <20220208133425.1096-6-shameerali.kolothum.thodi@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Feb 2022 13:34:22 +0000
Shameer Kolothum <shameerali.kolothum.thodi@huawei.com> wrote:

> HiSilicon ACC VF device BAR2 region consists of both functional
> register space and migration control register space. From a
> security point of view, it's not advisable to export the migration
> control region to Guest.
> 
> Hence, override the ioctl/read/write/mmap methods to hide the
> migration region and limit the access only to the functional register
> space.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  drivers/vfio/pci/hisi_acc_vfio_pci.c | 122 ++++++++++++++++++++++++++-
>  1 file changed, 118 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/pci/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> index 8b59e628110e..563ed2cc861f 100644
> --- a/drivers/vfio/pci/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisi_acc_vfio_pci.c
> @@ -13,6 +13,120 @@
>  #include <linux/vfio.h>
>  #include <linux/vfio_pci_core.h>
>  
> +static int hisi_acc_pci_rw_access_check(struct vfio_device *core_vdev,
> +					size_t count, loff_t *ppos,
> +					size_t *new_count)
> +{
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;

Be careful here, there are nested assignment use cases.  This can only
survive one level of assignment before we've restricted more than we
intended.  If migration support is dependent on PF access, can we use
that to determine when to when to expose only half the BAR and when to
expose the full BAR?

We should also follow the mlx5 lead to use a vendor sub-directory below
drivers/vfio/pci/  Thanks,

Alex

> +
> +		/* Check if access is for migration control region */
> +		if (pos >= end)
> +			return -EINVAL;
> +
> +		*new_count = min(count, (size_t)(end - pos));
> +	}
> +
> +	return 0;
> +}
> +
> +static int hisi_acc_vfio_pci_mmap(struct vfio_device *core_vdev,
> +				  struct vm_area_struct *vma)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +	unsigned int index;
> +
> +	index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
> +	if (index == VFIO_PCI_BAR2_REGION_INDEX) {
> +		u64 req_len, pgoff, req_start;
> +		resource_size_t end = pci_resource_len(vdev->pdev, index) / 2;
> +
> +		req_len = vma->vm_end - vma->vm_start;
> +		pgoff = vma->vm_pgoff &
> +			((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);
> +		req_start = pgoff << PAGE_SHIFT;
> +
> +		if (req_start + req_len > end)
> +			return -EINVAL;
> +	}
> +
> +	return vfio_pci_core_mmap(core_vdev, vma);
> +}
> +
> +static ssize_t hisi_acc_vfio_pci_write(struct vfio_device *core_vdev,
> +				       const char __user *buf, size_t count,
> +				       loff_t *ppos)
> +{
> +	size_t new_count = count;
> +	int ret;
> +
> +	ret = hisi_acc_pci_rw_access_check(core_vdev, count, ppos, &new_count);
> +	if (ret)
> +		return ret;
> +
> +	return vfio_pci_core_write(core_vdev, buf, new_count, ppos);
> +}
> +
> +static ssize_t hisi_acc_vfio_pci_read(struct vfio_device *core_vdev,
> +				      char __user *buf, size_t count,
> +				      loff_t *ppos)
> +{
> +	size_t new_count = count;
> +	int ret;
> +
> +	ret = hisi_acc_pci_rw_access_check(core_vdev, count, ppos, &new_count);
> +	if (ret)
> +		return ret;
> +
> +	return vfio_pci_core_read(core_vdev, buf, new_count, ppos);
> +}
> +
> +static long hisi_acc_vfio_pci_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
> +				    unsigned long arg)
> +{
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
> +	if (cmd == VFIO_DEVICE_GET_REGION_INFO) {
> +		struct pci_dev *pdev = vdev->pdev;
> +		struct vfio_region_info info;
> +		unsigned long minsz;
> +
> +		minsz = offsetofend(struct vfio_region_info, offset);
> +
> +		if (copy_from_user(&info, (void __user *)arg, minsz))
> +			return -EFAULT;
> +
> +		if (info.argsz < minsz)
> +			return -EINVAL;
> +
> +		if (info.index == VFIO_PCI_BAR2_REGION_INDEX) {
> +			info.offset = VFIO_PCI_INDEX_TO_OFFSET(info.index);
> +
> +			/*
> +			 * ACC VF dev BAR2 region consists of both functional
> +			 * register space and migration control register space.
> +			 * Report only the functional region to Guest.
> +			 */
> +			info.size = pci_resource_len(pdev, info.index) / 2;
> +
> +			info.flags = VFIO_REGION_INFO_FLAG_READ |
> +					VFIO_REGION_INFO_FLAG_WRITE |
> +					VFIO_REGION_INFO_FLAG_MMAP;
> +
> +			return copy_to_user((void __user *)arg, &info, minsz) ?
> +					    -EFAULT : 0;
> +		}
> +	}
> +	return vfio_pci_core_ioctl(core_vdev, cmd, arg);
> +}
> +
>  static int hisi_acc_vfio_pci_open_device(struct vfio_device *core_vdev)
>  {
>  	struct vfio_pci_core_device *vdev =
> @@ -32,10 +146,10 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.name = "hisi-acc-vfio-pci",
>  	.open_device = hisi_acc_vfio_pci_open_device,
>  	.close_device = vfio_pci_core_close_device,
> -	.ioctl = vfio_pci_core_ioctl,
> -	.read = vfio_pci_core_read,
> -	.write = vfio_pci_core_write,
> -	.mmap = vfio_pci_core_mmap,
> +	.ioctl = hisi_acc_vfio_pci_ioctl,
> +	.read = hisi_acc_vfio_pci_read,
> +	.write = hisi_acc_vfio_pci_write,
> +	.mmap = hisi_acc_vfio_pci_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
>  };

