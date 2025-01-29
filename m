Return-Path: <kvm+bounces-36846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B2E6A21E14
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFB9C1884B99
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 13:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46E7814A635;
	Wed, 29 Jan 2025 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5hhpXna"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 288F786250
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 13:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738158264; cv=none; b=JTQzRwOQfz9Qv0Ue3jtke/AaeW8u5ohrHRlBX5UEJVf2uhs+a7tSAiLFxeGLR0xKVbwGQq+VSJ31VVPdsekSGR0N/h9YHf6J/wNkwTfFBTjiiNy77y7+7RgnsHiBharMTfJ2IwllTb7qb3apP6wNdSrjIcL7hREaRv/BSoiOJkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738158264; c=relaxed/simple;
	bh=b9UgbSGBeNmmJCIGLoCXB4vAkJ110kVpSuKj6rgRcYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VyXo2xD6cNddEXbBaQSP9l+RX4cynO/PA9ZGUbDZMf0Riun7zuoml4NovuR04zUYh7y0qB46rP0X5PONdL6dbL4UnZxZLNGWsttncay0lFcyft1RDdOO59tTglFqBkhNRJkS82nLLaK+jl5R8YB4nsjJNKa6q2dTyxf22GULOtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F5hhpXna; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738158261;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sf+DtGmrqdTwE2hubtPrHYXjgFDMJbqgNNnIu1aYodU=;
	b=F5hhpXnawqB7JDJTKlAkraF4zN1rBoiucBAajLOYYZ6e2eBw8+veMPz8Xq0WHLAz7CidT6
	AboQJ/MwGLuGELSCiBYlBKzwqqjKxZhyvLa4YVd40ye0dhlsVoK0E2LSnFLFwJWZeWBuVV
	9thfV9+iW7aTCr+4qsjybbgfLoKM5Zg=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-6w-oUbDVN-OK9PSHLyCofg-1; Wed, 29 Jan 2025 08:44:20 -0500
X-MC-Unique: 6w-oUbDVN-OK9PSHLyCofg-1
X-Mimecast-MFC-AGG-ID: 6w-oUbDVN-OK9PSHLyCofg
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7b6e1b036e9so667602785a.1
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 05:44:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738158260; x=1738763060;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sf+DtGmrqdTwE2hubtPrHYXjgFDMJbqgNNnIu1aYodU=;
        b=D3QOzm9V7b7mx/IUvkFAdCmMCFWqJ0nCSRZgPAA0tWta6i3K2hQV0CaYId2iglEKXn
         LGj+mAlo0+aec48UXfGx+J00f/p88+m3epcsEnr6LEb9cuCHCYT+yXWHFw4oSr+ZCknQ
         UE6N2usBvWo2ulLRxpc38BwPYOl3B2IymZ+J7KHH5NCAh7kTAbeg1cp3sHZ/yY2qQIej
         GSTTv25QpIktu9E3qdFeaaoryXjQQB34GQQ+sWMVbyqWpIniyQKY29Ong0xw8QU0u3xi
         0QD5/jDAtPrFmfWTNoFPkBAHVLsYZWmaYSPA8P8E8NSvQU4LAI7DPXHnwD8L/XIEkeGM
         /lng==
X-Forwarded-Encrypted: i=1; AJvYcCX380iDpfVLhSdU5QL05FucT0kBkhZtL5+EdbttpTVQXDkOCQEumb7SrHmzFTbgu3oySn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPjeoWj3zw32rKYcXud6h5xHm7TJEJnCKvVSlFDTN2vXWrY0eK
	+2p6CxZF93UJzC0cL0idDN34mq6D5R0yMZWLfqRAJaiTxx1jyGp58OU+bxrCIr+QSt7HUIhxcg/
	cu12O/n3WShtF+yi7UHFBw3VvqIg9T47Wuygzn1Zluw+fPju1ow==
X-Gm-Gg: ASbGncvQG6vtiti1Phadf91ej7gWaOBInbTkJW9Iwy1nC5PMeWSvmM1JQbgnyFR5ZbN
	PDyvNXxSVz07J3Ftj6Nap40paSdtzBj+tpftj9kP/itqeOoHvbOhi9VJjK8xftFi2hjZAAXFbav
	UgWbJdYLcR/nTwAyNOvXXOmXDAf9TRdffSqLwUpxDqIqHR8wgbatBuOHccus+/TlNFUXlEeD/Yd
	WGIwESkC3yPxRwqIgAw2XRxh+FC/1V/1r8vYchIGd44O6fpbdyRpIhMfZuX2a5p1Nzz+AHwQCHk
	wGbUAZYxXt1HQ0ve7eXepQnWee20kOmq3EWlsVEmR2NHK1SwB3uc
X-Received: by 2002:a05:620a:4387:b0:7b6:d910:5b31 with SMTP id af79cd13be357-7bffcd902b1mr487013385a.39.1738158259360;
        Wed, 29 Jan 2025 05:44:19 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHfdRRfWiU/OFcr3Tb9Wnx23c3Oss13g014CVs37t9ZgKQ1ODWd2wjx8kgWWU1PdQbKyQMMZA==
X-Received: by 2002:a05:620a:4387:b0:7b6:d910:5b31 with SMTP id af79cd13be357-7bffcd902b1mr487009785a.39.1738158258956;
        Wed, 29 Jan 2025 05:44:18 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be9af03b3dsm619851385a.90.2025.01.29.05.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 05:44:18 -0800 (PST)
Message-ID: <0521187e-c511-4ab1-9ffa-be2be8eacd04@redhat.com>
Date: Wed, 29 Jan 2025 14:44:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 09/13] iommufd: Add IOMMU_OPTION_SW_MSI_START/SIZE
 ioctls
Content-Language: en-US
To: Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
 robin.murphy@arm.com, jgg@nvidia.com, kevin.tian@intel.com,
 tglx@linutronix.de, maz@kernel.org, alex.williamson@redhat.com
Cc: joro@8bytes.org, shuah@kernel.org, reinette.chatre@intel.com,
 yebin10@huawei.com, apatel@ventanamicro.com,
 shivamurthy.shastri@linutronix.de, bhelgaas@google.com,
 anna-maria@linutronix.de, yury.norov@gmail.com, nipun.gupta@amd.com,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com, ddutile@redhat.com
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <d3cb1694e07be0e214dc44dcb2cb74f014606560.1736550979.git.nicolinc@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <d3cb1694e07be0e214dc44dcb2cb74f014606560.1736550979.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,


On 1/11/25 4:32 AM, Nicolin Chen wrote:
> For systems that require MSI pages to be mapped into the IOMMU translation
> the IOMMU driver provides an IOMMU_RESV_SW_MSI range, which is the default
> recommended IOVA window to place these mappings. However, there is nothing
> special about this address. And to support the RMR trick in VMM for nested
well at least it shall not overlap VMM's RAM. So it was not random either.
> translation, the VMM needs to know what sw_msi window the kernel is using.
> As there is no particular reason to force VMM to adopt the kernel default,
> provide a simple IOMMU_OPTION_SW_MSI_START/SIZE ioctl that the VMM can use
> to directly specify the sw_msi window that it wants to use, which replaces
> and disables the default IOMMU_RESV_SW_MSI from the driver to avoid having
> to build an API to discover the default IOMMU_RESV_SW_MSI.
IIUC the MSI window will then be different when using legacy VFIO
assignment and iommufd backend.
MSI reserved regions are exposed in
/sys/kernel/iommu_groups/<n>/reserved_regions
0x0000000008000000 0x00000000080fffff msi

Is that configurability reflected accordingly?

How do you make sure it does not collide with other resv regions? I
don't see any check here.

>
> Since iommufd now has its own sw_msi function, this is easy to implement.
>
> To keep things simple, the parameters are global to the entire iommufd FD,
> and will directly replace the IOMMU_RESV_SW_MSI values. The VMM must set
> the values before creating any hwpt's to have any effect.
>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h |  4 +++
>  include/uapi/linux/iommufd.h            | 18 ++++++++++++-
>  drivers/iommu/iommufd/device.c          |  4 +++
>  drivers/iommu/iommufd/io_pagetable.c    |  4 ++-
>  drivers/iommu/iommufd/ioas.c            | 34 +++++++++++++++++++++++++
>  drivers/iommu/iommufd/main.c            |  6 +++++
>  6 files changed, 68 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index 3e83bbb5912c..9f071609f00b 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -45,6 +45,9 @@ struct iommufd_ctx {
>  	struct mutex sw_msi_lock;
>  	struct list_head sw_msi_list;
>  	unsigned int sw_msi_id;
> +	/* User-programmed SW_MSI region, to override igroup->sw_msi_start */
> +	phys_addr_t sw_msi_start;
> +	size_t sw_msi_size;
>  
>  	u8 account_mode;
>  	/* Compatibility with VFIO no iommu */
> @@ -281,6 +284,7 @@ int iommufd_ioas_unmap(struct iommufd_ucmd *ucmd);
>  int iommufd_ioas_option(struct iommufd_ucmd *ucmd);
>  int iommufd_option_rlimit_mode(struct iommu_option *cmd,
>  			       struct iommufd_ctx *ictx);
> +int iommufd_option_sw_msi(struct iommu_option *cmd, struct iommufd_ctx *ictx);
>  
>  int iommufd_vfio_ioas(struct iommufd_ucmd *ucmd);
>  int iommufd_check_iova_range(struct io_pagetable *iopt,
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 34810f6ae2b5..c864a201e502 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -294,7 +294,9 @@ struct iommu_ioas_unmap {
>  
>  /**
>   * enum iommufd_option - ioctl(IOMMU_OPTION_RLIMIT_MODE) and
> - *                       ioctl(IOMMU_OPTION_HUGE_PAGES)
> + *                       ioctl(IOMMU_OPTION_HUGE_PAGES) and
> + *                       ioctl(IOMMU_OPTION_SW_MSI_START) and
> + *                       ioctl(IOMMU_OPTION_SW_MSI_SIZE)
>   * @IOMMU_OPTION_RLIMIT_MODE:
>   *    Change how RLIMIT_MEMLOCK accounting works. The caller must have privilege
>   *    to invoke this. Value 0 (default) is user based accounting, 1 uses process
> @@ -304,10 +306,24 @@ struct iommu_ioas_unmap {
>   *    iommu mappings. Value 0 disables combining, everything is mapped to
>   *    PAGE_SIZE. This can be useful for benchmarking.  This is a per-IOAS
>   *    option, the object_id must be the IOAS ID.
> + * @IOMMU_OPTION_SW_MSI_START:
> + *    Change the base address of the IOMMU mapping region for MSI doorbell(s).
> + *    It must be set this before attaching a device to an IOAS/HWPT, otherwise
> + *    this option will be not effective on that IOAS/HWPT. User can choose to
> + *    let kernel pick a base address, by simply ignoring this option or setting
> + *    a value 0 to IOMMU_OPTION_SW_MSI_SIZE. Global option, object_id must be 0
I think we should document it cannot be put at a random place either.
> + * @IOMMU_OPTION_SW_MSI_SIZE:
> + *    Change the size of the IOMMU mapping region for MSI doorbell(s). It must
> + *    be set this before attaching a device to an IOAS/HWPT, otherwise it won't
> + *    be effective on that IOAS/HWPT. The value is in MB, and the minimum value
> + *    is 1 MB. A value 0 (default) will invalidate the MSI doorbell base address
> + *    value set to IOMMU_OPTION_SW_MSI_START. Global option, object_id must be 0
>   */
>  enum iommufd_option {
>  	IOMMU_OPTION_RLIMIT_MODE = 0,
>  	IOMMU_OPTION_HUGE_PAGES = 1,
> +	IOMMU_OPTION_SW_MSI_START = 2,
> +	IOMMU_OPTION_SW_MSI_SIZE = 3,
>  };
>  
>  /**
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index f75b3c23cd41..093a3bd798db 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -445,10 +445,14 @@ static int
>  iommufd_device_attach_reserved_iova(struct iommufd_device *idev,
>  				    struct iommufd_hwpt_paging *hwpt_paging)
>  {
> +	struct iommufd_ctx *ictx = idev->ictx;
>  	int rc;
>  
>  	lockdep_assert_held(&idev->igroup->lock);
>  
> +	/* Override it with a user-programmed SW_MSI region */
> +	if (ictx->sw_msi_size && ictx->sw_msi_start != PHYS_ADDR_MAX)
> +		idev->igroup->sw_msi_start = ictx->sw_msi_start;
>  	rc = iopt_table_enforce_dev_resv_regions(&hwpt_paging->ioas->iopt,
>  						 idev->dev,
>  						 &idev->igroup->sw_msi_start);
> diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
> index 8a790e597e12..5d7f5ca1eecf 100644
> --- a/drivers/iommu/iommufd/io_pagetable.c
> +++ b/drivers/iommu/iommufd/io_pagetable.c
> @@ -1446,7 +1446,9 @@ int iopt_table_enforce_dev_resv_regions(struct io_pagetable *iopt,
>  		if (sw_msi_start && resv->type == IOMMU_RESV_MSI)
>  			num_hw_msi++;
>  		if (sw_msi_start && resv->type == IOMMU_RESV_SW_MSI) {
> -			*sw_msi_start = resv->start;
> +			/* Bypass the driver-defined SW_MSI region, if preset */
> +			if (*sw_msi_start == PHYS_ADDR_MAX)
> +				*sw_msi_start = resv->start;
>  			num_sw_msi++;
>  		}
>  
> diff --git a/drivers/iommu/iommufd/ioas.c b/drivers/iommu/iommufd/ioas.c
> index 1542c5fd10a8..3f4e25b660f9 100644
> --- a/drivers/iommu/iommufd/ioas.c
> +++ b/drivers/iommu/iommufd/ioas.c
> @@ -620,6 +620,40 @@ int iommufd_option_rlimit_mode(struct iommu_option *cmd,
>  	return -EOPNOTSUPP;
>  }
>  
> +int iommufd_option_sw_msi(struct iommu_option *cmd, struct iommufd_ctx *ictx)
> +{
> +	if (cmd->object_id)
> +		return -EOPNOTSUPP;
> +
> +	if (cmd->op == IOMMU_OPTION_OP_GET) {
> +		switch (cmd->option_id) {
> +		case IOMMU_OPTION_SW_MSI_START:
> +			cmd->val64 = (u64)ictx->sw_msi_start;
> +			break;
> +		case IOMMU_OPTION_SW_MSI_SIZE:
> +			cmd->val64 = (u64)ictx->sw_msi_size;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +		return 0;
> +	}
> +	if (cmd->op == IOMMU_OPTION_OP_SET) {
> +		switch (cmd->option_id) {
> +		case IOMMU_OPTION_SW_MSI_START:
> +			ictx->sw_msi_start = (phys_addr_t)cmd->val64;
> +			break;
> +		case IOMMU_OPTION_SW_MSI_SIZE:
> +			ictx->sw_msi_size = (size_t)cmd->val64;
> +			break;
> +		default:
> +			return -EOPNOTSUPP;
> +		}
> +		return 0;
> +	}
> +	return -EOPNOTSUPP;
> +}
> +
>  static int iommufd_ioas_option_huge_pages(struct iommu_option *cmd,
>  					  struct iommufd_ioas *ioas)
>  {
> diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
> index 7cc9497b7193..026297265c71 100644
> --- a/drivers/iommu/iommufd/main.c
> +++ b/drivers/iommu/iommufd/main.c
> @@ -229,6 +229,8 @@ static int iommufd_fops_open(struct inode *inode, struct file *filp)
>  	init_waitqueue_head(&ictx->destroy_wait);
>  	mutex_init(&ictx->sw_msi_lock);
>  	INIT_LIST_HEAD(&ictx->sw_msi_list);
> +	ictx->sw_msi_start = PHYS_ADDR_MAX;
> +	ictx->sw_msi_size = 0;
>  	filp->private_data = ictx;
>  	return 0;
>  }
> @@ -287,6 +289,10 @@ static int iommufd_option(struct iommufd_ucmd *ucmd)
>  	case IOMMU_OPTION_RLIMIT_MODE:
>  		rc = iommufd_option_rlimit_mode(cmd, ucmd->ictx);
>  		break;
> +	case IOMMU_OPTION_SW_MSI_START:
> +	case IOMMU_OPTION_SW_MSI_SIZE:
> +		rc = iommufd_option_sw_msi(cmd, ucmd->ictx);
> +		break;
>  	case IOMMU_OPTION_HUGE_PAGES:
>  		rc = iommufd_ioas_option(ucmd);
>  		break;
Eric


