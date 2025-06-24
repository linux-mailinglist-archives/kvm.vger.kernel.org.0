Return-Path: <kvm+bounces-50559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4494AE7053
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F8C717CC44
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:06:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 724192E7F03;
	Tue, 24 Jun 2025 20:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wt2iQWmJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBE72550D3
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 20:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750795575; cv=none; b=tZGfBl/5VT/WzaQUAAqBcb/4Cltz9YGuKEDE1txLUylHSqlNQ4+fTxNcpN7v2qdSo/B53hhcQDYFCAEBmcKdY60bFeMSNcFH9EjKAoxkPxSwiES0wHprMTW7hg7kywadTiADV/IcyVQASEI7IDxJcqKie5eo9eelZYtaHWmzUkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750795575; c=relaxed/simple;
	bh=KDrvqOW3L4yftEFBZKbv6/w4xpRthChiqDVc7McsUTk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=easWN55Hc/b5blbAn4jCaI4mjPSC+9qiGM8bEn6mY2sQeOISvrkPfh2brkVoPD29pxSSvDUQhGc0tSdyODc5lIiWl1V/69JsfqoUYMNf0Wz1o5tRthyy6MKiox1E6l48ZrsE9GzYQc9gdMd1akjCrGy6M4VGHOV9zpM2QK9Ypj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wt2iQWmJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750795572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwshu8J2HemBLlh99Bx8YqtEUNbGJCb7Izdla+gfURA=;
	b=Wt2iQWmJgiMxFb+aeNVCrkPXiuibWklLJx/IH02gfJbQkXIg6vKBdkfn5Y9pYt36CXxvjL
	WAROoSXkgJ734EttJy7u1+ULynEQQZXVP4rd5Ts7sCVU6aPA3nlmUh0BPVu4SSqGr+fTRQ
	UMJ0zVt3NWa1yDiWDiLZcBnCeTu7TMg=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-t0J7neWLMUmDd8RFrf6dGA-1; Tue, 24 Jun 2025 16:06:10 -0400
X-MC-Unique: t0J7neWLMUmDd8RFrf6dGA-1
X-Mimecast-MFC-AGG-ID: t0J7neWLMUmDd8RFrf6dGA_1750795570
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3de252de603so8973745ab.3
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:06:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750795570; x=1751400370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwshu8J2HemBLlh99Bx8YqtEUNbGJCb7Izdla+gfURA=;
        b=HCiE6kroI5r0d4VC4ctJWW8zB7FA5YS4GyZp0O7M8GOPaynBNdlmcJ1ojK0iNNTfzz
         7Z2wq1YBVPuPGBVM8/q7vmRiIICE9iz0v0I2K1PczM5DzKkqSUOku1z7JHqNTeYrT7S1
         3z4iutkKEzQjBIc/aC3ugrUzR7wrAaf9+vkqGtmnAU8BqKky0pa5UMWxTMTavJwGUsac
         JZhWYbFIlZTgByof3w6F1L6Ga8m6vzJG9WSj4i+hc6n1/iNaU3qTNoef2hgjCKm/sak6
         Imwn7r7cFVPzl4FK/3ZRNNM9cqm5mdIsJDMaTHummOnbyWQh4wjicWP9rlEJAMPwGkKF
         nHLg==
X-Forwarded-Encrypted: i=1; AJvYcCW6mxhkJ2DSEOWHb78vRjJ83EqyFs693mEnNg9IsggGBh4BVZ6q6VIJU+mlk99qDiXz8cw=@vger.kernel.org
X-Gm-Message-State: AOJu0YylyrDqpfnGZrKrRSCOJojaf+AxAE/EZkneOmRlX5BpDEIayiyp
	qPQcUlOTSVtETI5Djr2aqpwCdng8Vd5ZXx5BOSFBdbTbnDKU9k5ER++0kpSeYONl5K3uAoNVJ9A
	S4egtp+yJIIpniDlzt2S/bCRwgPkoI0+ogY5Yjp8PL5UmAAicbjvkLQ==
X-Gm-Gg: ASbGncs7i7YHvf/cBgDhmibSho58IedndjvbVpjEAFswTEWvolnyBwQXRWhoFFhHlV0
	8mVc29dLeX/dze3FgrtWLKybc48WAmbyphxYDsxPGTZ4x62vnRHj2D0+hLZsRzAdX3qClEov5Ur
	Z/VFGBpimKKXLJx4woR+XxbMbw9Js5chyqTKZ1GrhDZH6RITdR7iRmoQ0e1CpyEGB2wFTZeo68R
	7KAed0U/zSCWU4WMa+rDXyKpvt9Ur6PIj5JtPaOGzPkZgYUcLIo0EmbrxFvRzR63pa6WcMtuVni
	Kpj9hY7Yy5IYlpBb5i4dvi9vSQ==
X-Received: by 2002:a05:6602:1643:b0:875:9e30:c7db with SMTP id ca18e2360f4ac-8766b9e6577mr30042639f.4.1750795569632;
        Tue, 24 Jun 2025 13:06:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZcYJwFe9VTa0ekuu92qj5ASFTMJEjfhl8uRTFJZhRD9S4l7IuFfWRjhBHiQlwKvh2nYiM8A==
X-Received: by 2002:a05:6602:1643:b0:875:9e30:c7db with SMTP id ca18e2360f4ac-8766b9e6577mr30040039f.4.1750795568885;
        Tue, 24 Jun 2025 13:06:08 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-501ae5b16b8sm1925485173.3.2025.06.24.13.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jun 2025 13:06:07 -0700 (PDT)
Date: Tue, 24 Jun 2025 14:06:04 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Brett Creeley
 <brett.creeley@amd.com>, Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org, Longfang Liu
 <liulongfang@huawei.com>, qat-linux@intel.com,
 virtualization@lists.linux.dev, Xin Zeng <xin.zeng@intel.com>, Yishai Hadas
 <yishaih@nvidia.com>, Matthew Rosato <mjrosato@linux.ibm.com>, Nicolin Chen
 <nicolinc@nvidia.com>, patches@lists.linux.dev, Shameer Kolothum
 <shameerali.kolothum.thodi@huawei.com>, Terrence Xu
 <terrence.xu@intel.com>, Yanting Jiang <yanting.jiang@intel.com>, Yi Liu
 <yi.l.liu@intel.com>, Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: Re: [PATCH] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250624140604.6330c656.alex.williamson@redhat.com>
In-Reply-To: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
References: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Jun 2025 15:34:40 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> This was missed during the initial implementation. The VFIO PCI encodes
> the vf_token inside the device name when opening the device from the group
> FD, something like:
> 
>   "0000:04:10.0 vf_token=bd8d9d2b-5a5f-4f5a-a211-f591514ba1f3"
> 
> This is used to control access to a VF unless there is co-ordination with
> the owner of the PF.
> 
> Since we no longer have a device name pass the token directly though

s/name pass/name, pass/ s/though/through/

> VFIO_DEVICE_BIND_IOMMUFD with an optional field indicated by
> VFIO_DEVICE_BIND_TOKEN. Only users using a PCI SRIOV VF will need to
> provide this. This is done in the usual backwards compatible way.
> 
> Fixes: 5fcc26969a16 ("vfio: Add VFIO_DEVICE_BIND_IOMMUFD")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/device_cdev.c                    | 38 +++++++++++++++++--
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  1 +
>  drivers/vfio/pci/mlx5/main.c                  |  1 +
>  drivers/vfio/pci/nvgrace-gpu/main.c           |  2 +
>  drivers/vfio/pci/pds/vfio_dev.c               |  1 +
>  drivers/vfio/pci/qat/main.c                   |  1 +
>  drivers/vfio/pci/vfio_pci.c                   |  1 +
>  drivers/vfio/pci/vfio_pci_core.c              | 22 +++++++----
>  drivers/vfio/pci/virtio/main.c                |  3 ++
>  include/linux/vfio.h                          |  1 +
>  include/linux/vfio_pci_core.h                 |  2 +
>  include/uapi/linux/vfio.h                     | 13 ++++++-
>  12 files changed, 74 insertions(+), 12 deletions(-)
> 
> I wrote this quickly and don't have an environment available to check it out
> on.. Since it feels like a significant miss I felt we should start looking at
> it.
> 
> diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> index 281a8dc3ed4974..c5d74c7e71f585 100644
> --- a/drivers/vfio/device_cdev.c
> +++ b/drivers/vfio/device_cdev.c
> @@ -60,22 +60,50 @@ static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
>  	spin_unlock(&df->kvm_ref_lock);
>  }
>  
> +static int vfio_df_check_token(struct vfio_device *device,
> +			       const struct vfio_device_bind_iommufd *bind)
> +{
> +	uuid_t uuid;
> +
> +	if (!device->ops->match_token_uuid) {
> +		if (bind->flags & VFIO_DEVICE_BIND_TOKEN)
> +			return -EINVAL;
> +		return 0;
> +	}
> +
> +	if (!(bind->flags & VFIO_DEVICE_BIND_TOKEN))
> +		return device->ops->match_token_uuid(device, NULL);
> +
> +	if (copy_from_user(&uuid, u64_to_user_ptr(bind->token_uuid_ptr),
> +			   sizeof(uuid)))
> +		return -EFAULT;
> +	return device->ops->match_token_uuid(device, &uuid);
> +}
> +
>  long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>  				struct vfio_device_bind_iommufd __user *arg)
>  {
> +	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_TOKEN;
>  	struct vfio_device *device = df->device;
>  	struct vfio_device_bind_iommufd bind;
>  	unsigned long minsz;
> +	u32 user_size;
>  	int ret;
>  
>  	static_assert(__same_type(arg->out_devid, df->devid));
>  
>  	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
>  
> -	if (copy_from_user(&bind, arg, minsz))
> -		return -EFAULT;
> +	ret = get_user(user_size, &arg->argsz);
> +	if (ret)
> +		return ret;
> +	if (bind.argsz < minsz)
> +		return -EINVAL;
> +	ret = copy_struct_from_user(&bind, minsz, arg, user_size);
> +	if (ret)
> +		return ret;
>  
> -	if (bind.argsz < minsz || bind.flags || bind.iommufd < 0)
> +	if (bind.iommufd < 0 || bind.flags & ~VALID_FLAGS)
>  		return -EINVAL;
>  
>  	/* BIND_IOMMUFD only allowed for cdev fds */
> @@ -93,6 +121,10 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
>  		goto out_unlock;
>  	}
>  
> +	ret = vfio_df_check_token(device, &bind);
> +	if (ret)
> +		return ret;
> +
>  	df->iommufd = iommufd_ctx_from_fd(bind.iommufd);
>  	if (IS_ERR(df->iommufd)) {
>  		ret = PTR_ERR(df->iommufd);
> diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> index 2149f49aeec7f8..397f5e44513639 100644
> --- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> +++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
> @@ -1583,6 +1583,7 @@ static const struct vfio_device_ops hisi_acc_vfio_pci_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 93f894fe60d221..7ec47e736a8e5a 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -1372,6 +1372,7 @@ static const struct vfio_device_ops mlx5vf_pci_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/nvgrace-gpu/main.c b/drivers/vfio/pci/nvgrace-gpu/main.c
> index e5ac39c4cc6b6f..d95761dcdd58c4 100644
> --- a/drivers/vfio/pci/nvgrace-gpu/main.c
> +++ b/drivers/vfio/pci/nvgrace-gpu/main.c
> @@ -696,6 +696,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_ops = {
>  	.mmap		= nvgrace_gpu_mmap,
>  	.request	= vfio_pci_core_request,
>  	.match		= vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> @@ -715,6 +716,7 @@ static const struct vfio_device_ops nvgrace_gpu_pci_core_ops = {
>  	.mmap		= vfio_pci_core_mmap,
>  	.request	= vfio_pci_core_request,
>  	.match		= vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
> index 76a80ae7087b51..5731e6856deaf1 100644
> --- a/drivers/vfio/pci/pds/vfio_dev.c
> +++ b/drivers/vfio/pci/pds/vfio_dev.c
> @@ -201,6 +201,7 @@ static const struct vfio_device_ops pds_vfio_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/qat/main.c b/drivers/vfio/pci/qat/main.c
> index 845ed15b67718c..5cce6b0b8d2f3e 100644
> --- a/drivers/vfio/pci/qat/main.c
> +++ b/drivers/vfio/pci/qat/main.c
> @@ -614,6 +614,7 @@ static const struct vfio_device_ops qat_vf_pci_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 5ba39f7623bb76..ac10f14417f2f3 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -138,6 +138,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  	.mmap		= vfio_pci_core_mmap,
>  	.request	= vfio_pci_core_request,
>  	.match		= vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd	= vfio_iommufd_physical_bind,
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 6328c3a05bcdd4..086aa37a60a2b5 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1821,9 +1821,13 @@ void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count)
>  }
>  EXPORT_SYMBOL_GPL(vfio_pci_core_request);
>  
> -static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
> -				      bool vf_token, uuid_t *uuid)
> +int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
> +				   const uuid_t *uuid)
> +
>  {
> +	struct vfio_pci_core_device *vdev =
> +		container_of(core_vdev, struct vfio_pci_core_device, vdev);
> +
>  	/*
>  	 * There's always some degree of trust or collaboration between SR-IOV
>  	 * PF and VFs, even if just that the PF hosts the SR-IOV capability and
> @@ -1854,7 +1858,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>  		bool match;
>  
>  		if (!pf_vdev) {
> -			if (!vf_token)
> +			if (!uuid)
>  				return 0; /* PF is not vfio-pci, no VF token */
>  
>  			pci_info_ratelimited(vdev->pdev,
> @@ -1862,7 +1866,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>  			return -EINVAL;
>  		}
>  
> -		if (!vf_token) {
> +		if (!uuid) {
>  			pci_info_ratelimited(vdev->pdev,
>  				"VF token required to access device\n");
>  			return -EACCES;
> @@ -1880,7 +1884,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>  	} else if (vdev->vf_token) {
>  		mutex_lock(&vdev->vf_token->lock);
>  		if (vdev->vf_token->users) {
> -			if (!vf_token) {
> +			if (!uuid) {
>  				mutex_unlock(&vdev->vf_token->lock);
>  				pci_info_ratelimited(vdev->pdev,
>  					"VF token required to access device\n");
> @@ -1893,12 +1897,12 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>  					"Incorrect VF token provided for device\n");
>  				return -EACCES;
>  			}
> -		} else if (vf_token) {
> +		} else if (uuid) {
>  			uuid_copy(&vdev->vf_token->uuid, uuid);
>  		}
>  
>  		mutex_unlock(&vdev->vf_token->lock);
> -	} else if (vf_token) {
> +	} else if (uuid) {
>  		pci_info_ratelimited(vdev->pdev,
>  			"VF token incorrectly provided, not a PF or VF\n");
>  		return -EINVAL;
> @@ -1906,6 +1910,7 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_core_device *vdev,
>  
>  	return 0;
>  }
> +EXPORT_SYMBOL_GPL(vfio_pci_core_match_token_uuid);
>  
>  #define VF_TOKEN_ARG "vf_token="
>  
> @@ -1952,7 +1957,8 @@ int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf)
>  		}
>  	}
>  
> -	ret = vfio_pci_validate_vf_token(vdev, vf_token, &uuid);
> +	ret = vfio_pci_core_match_token_uuid(core_vdev,
> +					     vf_token ? &uuid : NULL);

For consistency shouldn't this call core_vdev->ops->match_token_uuid?

>  	if (ret)
>  		return ret;
>  
> diff --git a/drivers/vfio/pci/virtio/main.c b/drivers/vfio/pci/virtio/main.c
> index 515fe1b9f94d80..8084f3e36a9f70 100644
> --- a/drivers/vfio/pci/virtio/main.c
> +++ b/drivers/vfio/pci/virtio/main.c
> @@ -94,6 +94,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_lm_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> @@ -114,6 +115,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_tran_lm_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> @@ -134,6 +136,7 @@ static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
>  	.mmap = vfio_pci_core_mmap,
>  	.request = vfio_pci_core_request,
>  	.match = vfio_pci_core_match,
> +	.match_token_uuid = vfio_pci_core_match_token_uuid,
>  	.bind_iommufd = vfio_iommufd_physical_bind,
>  	.unbind_iommufd = vfio_iommufd_physical_unbind,
>  	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 707b00772ce1ff..b2cca540a6b4bf 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -132,6 +132,7 @@ struct vfio_device_ops {
>  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
>  	void	(*request)(struct vfio_device *vdev, unsigned int count);
>  	int	(*match)(struct vfio_device *vdev, char *buf);
> +	int	(*match_token_uuid)(struct vfio_device *vdev, const uuid_t *uuid);
>  	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
>  	int	(*device_feature)(struct vfio_device *device, u32 flags,
>  				  void __user *arg, size_t argsz);

Update the structure comments.

> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> index fbb472dd99b361..f541044e42a2ad 100644
> --- a/include/linux/vfio_pci_core.h
> +++ b/include/linux/vfio_pci_core.h
> @@ -122,6 +122,8 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
>  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
>  void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
>  int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
> +int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
> +				   const uuid_t *uuid);
>  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
>  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 5764f315137f99..48233ec4daf7b4 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -901,14 +901,18 @@ struct vfio_device_feature {
>  
>  #define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
>  
> +#define VFIO_DEVICE_BIND_TOKEN (1 << 0)

We tend to define ioctl flags within the ioctl data structure and
include "_FLAG_" in the name.

> +
>  /*
>   * VFIO_DEVICE_BIND_IOMMUFD - _IOR(VFIO_TYPE, VFIO_BASE + 18,
>   *				   struct vfio_device_bind_iommufd)
>   * @argsz:	 User filled size of this data.
> - * @flags:	 Must be 0.
> + * @flags:	 Must be 0 or a bit flags of VFIO_DEVICE_BIND_*
>   * @iommufd:	 iommufd to bind.
>   * @out_devid:	 The device id generated by this bind. devid is a handle for
>   *		 this device/iommufd bond and can be used in IOMMUFD commands.
> + * @token_uuid_ptr: Valid if VFIO_DEVICE_BIND_TOKEN. Points to a 16 byte UUID
> + *                  in the same format as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN.
>   *
>   * Bind a vfio_device to the specified iommufd.
>   *
> @@ -917,6 +921,12 @@ struct vfio_device_feature {
>   *
>   * Unbind is automatically conducted when device fd is closed.
>   *
> + * A token is sometimes required to open the device, unless this is known to be
> + * needed VFIO_DEVICE_BIND_TOKEN should not be set and token_uuid_ptr is
> + * ignored. The only case today is a PF/VF relationship where the VF bind must
> + * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provided to
> + * the PF.
> + *
>   * Return: 0 on success, -errno on failure.
>   */
>  struct vfio_device_bind_iommufd {
> @@ -924,6 +934,7 @@ struct vfio_device_bind_iommufd {
>  	__u32		flags;
>  	__s32		iommufd;
>  	__u32		out_devid;
> +	__aligned_u64	token_uuid_ptr;
>  };

So we're expecting in the general case, old code doesn't set the flag,
doesn't need a token, continues to work.  There's potentially a narrow
case of old code that should have required a token, which now
intentionally breaks.  We're not offering an introspection mechanism
here, but doing so also doesn't add a lot of value.  Userspace needs to
know the token to pass anyway.  Is that how you see it?

Do note that QEMU already has support for this in the legacy interface
and should just need to reparse the token from the name provided
through the attach_device callback and pass it through to the
iommufd_cdev_connect_and_bind() function.

Thanks for jumping on this,
Alex

>  
>  #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 18)
> 
> base-commit: 3e2a9811f6a9cefd310cc33cab73d5435b4a4caa


