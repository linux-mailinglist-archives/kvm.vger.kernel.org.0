Return-Path: <kvm+bounces-36845-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AEF4A21DAD
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 14:15:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A081167BBB
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 13:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA000133987;
	Wed, 29 Jan 2025 13:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hyCBSyc2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8DB1F5FD
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 13:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738156501; cv=none; b=kmQBd7cJBmiBcOnCdnWblqHDoUkbGRwLF89rnwfbDV4hIXV//ogjmdDP/C4g+HSt+kHveZRjjMeIbSu31ApDHAuOp/BjXmcYGJhWA7Mn0Nw5YbiowFWl5lP3/zgA8VP4+skFEodi9xMALreJQRhwOPO8f6uvmxZUAvghGFL8dmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738156501; c=relaxed/simple;
	bh=61jiTg2T5PjjrrV1rtwoMTqbJe73DTEBYoavQki9pEQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f4fg0mxby7pTjw8Oyym0p0jFHpYdi8h7dXmULu4ApcGsMxsYO7CpBskmp0RuK2db3/tSoULzUC5eTgs5D8qAYIJWUzgtDqhbTMpX8/gTu6e5CDkqvQLgJXaB4yOpK52LuMMdZB+Ljk4YoT4vORSvnwfVC3K/4zbhlwWgLlUDhDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hyCBSyc2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738156497;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ehaLD59VOlGQNJVYY9S7cn8vnhal1Jf6t1sz+p8LqBk=;
	b=hyCBSyc2dbfVYlLdCBleC8pvK6boNQ8oZ5S3bZY/I5XhSac88FXzNfJM42Et0QJWIftSa+
	2DjLmAKXrPCEuTmSPR0luW1wGHsMZ34wN9igzGwvsVe1JVlwcLf92RAoN/C9BdKT92tCuj
	bWjbQ1HDHwIcdct6fp3/DAW4pyHhXS4=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15-Jw7BW2b-NSKuPyV9XJunFg-1; Wed, 29 Jan 2025 08:14:56 -0500
X-MC-Unique: Jw7BW2b-NSKuPyV9XJunFg-1
X-Mimecast-MFC-AGG-ID: Jw7BW2b-NSKuPyV9XJunFg
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4679db55860so130471631cf.3
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 05:14:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738156496; x=1738761296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ehaLD59VOlGQNJVYY9S7cn8vnhal1Jf6t1sz+p8LqBk=;
        b=Lu9PNIM1/AVgBz+xO01rh+wlX3dKXh4l4Au2QGDkXLuLxcUFTz1gfIf1DXq9rNQirL
         PV1340UIvaetGUh24vhCoi+nVtECj1qf0iemYdwZXQZEVD2tc48YOGRaDzKUFUpVJgLP
         0LP2vXWAV0MHU0xnUD+JVCK61GOu+NNfyt55JgD7VXw1NZiQMdyp7LBtm6BRZK7MnuFD
         HIAepd8LPVp0EYSxqppl30IdXSTcublh8JSwDsMW+oIfFFbUbXSIFGiWu2xoPgpyKfGB
         7IGfxm8XQtKOTcEBEs8z1qFNJOxJwVSpvfCyWr6x5bmYF86pOV5vkrkPx8fMK6Or7Ciy
         LCuA==
X-Forwarded-Encrypted: i=1; AJvYcCWMPzxj6A+nOP7+iqggOLMinxlz6ba9bTEuOl8agsJvoq2VYJ8BAnyPMfp95UW7VCemQzc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyw9dw4aPCzcIqT9ByBcC89vyXSqBqMSm8RBMbp7Lfy8hExn9dU
	jrl5nX39uRxgbMzFiAGCJPPXJx7ZB7rPvpRRkVSGI7c8FDsEAbxZwoYoDAuoxtPVC0wv/sYvyx3
	CGXXbhrz/cjh+XYJHf4FbZcrM9VTlo0rFat+EfjAa1b1g8zyU3g==
X-Gm-Gg: ASbGncvc3XEhVxs2TjiNurRyRTyhAxR+MlpBgpzoBl+PcrLot7s6EDqn34qw6F1GGvN
	l40wMZRgExjU2ypB4KVwJvp6UBJei/5bhBQV9XwhOGILO3GEm7H7AiJHDxorYrk6/GwIRIjSZXc
	/blylqcJV8sqQSwDl/Sz9zACCtSOgIvS4iXzsTeFmRShEicYhq9F/J6DcRx9wzTcMRa+WQCNiuT
	AZw/BCJ90tvi4FWG3g+WhWcHcrtwd/iC0slU1XNIR99yDwcOM4vr+H4i2WpAck4WHn/Tsty8hRK
	tL8paC8hLF5P88xoUr07CTAGQTmfaDfEaX0ecEP9QJgdxUvBaZAe
X-Received: by 2002:a05:622a:1f95:b0:466:8f68:a606 with SMTP id d75a77b69052e-46fd0b8933fmr51420011cf.40.1738156495635;
        Wed, 29 Jan 2025 05:14:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0hlzQVzABYE1rVWDmtCfFtRMGLzg436MgJYB4YxGHvMQN+tBbfqahN31khaEjfZ7znX/xmg==
X-Received: by 2002:a05:622a:1f95:b0:466:8f68:a606 with SMTP id d75a77b69052e-46fd0b8933fmr51419521cf.40.1738156495253;
        Wed, 29 Jan 2025 05:14:55 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e66b870b1sm61901531cf.75.2025.01.29.05.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 05:14:54 -0800 (PST)
Message-ID: <2b7f6c5e-434b-4f36-beb1-94af12362c8d@redhat.com>
Date: Wed, 29 Jan 2025 14:14:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 06/13] iommufd: Make attach_handle generic
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
 <c708aedc678c63e2466b43ab9d4f8ac876e49aa1.1736550979.git.nicolinc@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <c708aedc678c63e2466b43ab9d4f8ac876e49aa1.1736550979.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,


On 1/11/25 4:32 AM, Nicolin Chen wrote:
> "attach_handle" was added exclusively for the iommufd_fault_iopf_handler()
> used by IOPF/PRI use cases, along with the "fault_data". Now, the iommufd
> version of sw_msi function will resue the attach_handle and fault_data for
reuse
> a non-fault case.
>
> Move the attach_handle part out of the fault.c file to make it generic for
> all cases. Simplify the remaining fault specific routine to attach/detach.
>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/iommufd_private.h |  40 +-------
>  drivers/iommu/iommufd/device.c          | 105 +++++++++++++++++++++
>  drivers/iommu/iommufd/fault.c           | 120 +++---------------------
>  3 files changed, 122 insertions(+), 143 deletions(-)
>
> diff --git a/drivers/iommu/iommufd/iommufd_private.h b/drivers/iommu/iommufd/iommufd_private.h
> index b6d706cf2c66..063c0a42f54f 100644
> --- a/drivers/iommu/iommufd/iommufd_private.h
> +++ b/drivers/iommu/iommufd/iommufd_private.h
> @@ -472,42 +472,12 @@ void iommufd_fault_destroy(struct iommufd_object *obj);
>  int iommufd_fault_iopf_handler(struct iopf_group *group);
>  
>  int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
> -				    struct iommufd_device *idev);
> +				    struct iommufd_device *idev,
> +				    bool enable_iopf);
>  void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
> -				     struct iommufd_device *idev);
> -int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
> -				     struct iommufd_hw_pagetable *hwpt,
> -				     struct iommufd_hw_pagetable *old);
> -
> -static inline int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
> -					     struct iommufd_device *idev)
> -{
> -	if (hwpt->fault)
> -		return iommufd_fault_domain_attach_dev(hwpt, idev);
> -
> -	return iommu_attach_group(hwpt->domain, idev->igroup->group);
> -}
> -
> -static inline void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
> -					      struct iommufd_device *idev)
> -{
> -	if (hwpt->fault) {
> -		iommufd_fault_domain_detach_dev(hwpt, idev);
> -		return;
> -	}
> -
> -	iommu_detach_group(hwpt->domain, idev->igroup->group);
> -}
> -
> -static inline int iommufd_hwpt_replace_device(struct iommufd_device *idev,
> -					      struct iommufd_hw_pagetable *hwpt,
> -					      struct iommufd_hw_pagetable *old)
> -{
> -	if (old->fault || hwpt->fault)
> -		return iommufd_fault_domain_replace_dev(idev, hwpt, old);
> -
> -	return iommu_group_replace_domain(idev->igroup->group, hwpt->domain);
> -}
> +				     struct iommufd_device *idev,
> +				     struct iommufd_attach_handle *handle,
> +				     bool disable_iopf);
>  
>  static inline struct iommufd_viommu *
>  iommufd_get_viommu(struct iommufd_ucmd *ucmd, u32 id)
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index dfd0898fb6c1..38b31b652147 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -352,6 +352,111 @@ iommufd_device_attach_reserved_iova(struct iommufd_device *idev,
>  	return 0;
>  }
>  
> +/* The device attach/detach/replace helpers for attach_handle */
> +
> +static int iommufd_hwpt_attach_device(struct iommufd_hw_pagetable *hwpt,
> +				      struct iommufd_device *idev)
> +{
> +	struct iommufd_attach_handle *handle;
> +	int rc;
> +
> +	if (hwpt->fault) {
> +		rc = iommufd_fault_domain_attach_dev(hwpt, idev, true);
why don't we simply call iommufd_fault_iopf_enable(idev)
also it looks there is a redundant check of hwpt_fault here and in

iommufd_fault_domain_attach_dev

Besides the addition of enable_iopf param is not documented anywhere

> +		if (rc)
> +			return rc;
> +	}
> +
> +	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> +	if (!handle) {
> +		rc = -ENOMEM;
> +		goto out_fault_detach;
> +	}
> +
> +	handle->idev = idev;
> +	rc = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
> +				       &handle->handle);
> +	if (rc)
> +		goto out_free_handle;
> +
> +	return 0;
> +
> +out_free_handle:
> +	kfree(handle);
> +	handle = NULL;
> +out_fault_detach:
> +	if (hwpt->fault)
> +		iommufd_fault_domain_detach_dev(hwpt, idev, handle, true);
> +	return rc;
> +}
> +
> +static struct iommufd_attach_handle *
> +iommufd_device_get_attach_handle(struct iommufd_device *idev)
> +{
> +	struct iommu_attach_handle *handle;
> +
> +	handle =
> +		iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
> +	if (IS_ERR(handle))
> +		return NULL;
> +	return to_iommufd_handle(handle);
> +}
> +
> +static void iommufd_hwpt_detach_device(struct iommufd_hw_pagetable *hwpt,
> +				       struct iommufd_device *idev)
> +{
> +	struct iommufd_attach_handle *handle;
> +
> +	handle = iommufd_device_get_attach_handle(idev);
> +	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
> +	if (hwpt->fault)
> +		iommufd_fault_domain_detach_dev(hwpt, idev, handle, true);
same here, pretty difficult to understand what this

iommufd_fault_domain_detach_dev does
To me calling iommufd_auto_response_faults and iommufd_fault_iopf_disable would be more readable or rename iommufd_fault_domain_detach_dev().
Also compared to the original code, there is a new check on handle. Why is it necessary.

Globally I feel that patch pretty hard to read. Would be nice to split if possible to ease the review process.

Thanks

Eric

> +	kfree(handle);
> +}
> +
> +static int iommufd_hwpt_replace_device(struct iommufd_device *idev,
> +				       struct iommufd_hw_pagetable *hwpt,
> +				       struct iommufd_hw_pagetable *old)
> +{
> +	struct iommufd_attach_handle *old_handle =
> +		iommufd_device_get_attach_handle(idev);
> +	struct iommufd_attach_handle *handle;
> +	int rc;
> +
> +	if (hwpt->fault) {
> +		rc = iommufd_fault_domain_attach_dev(hwpt, idev, !old->fault);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> +	if (!handle) {
> +		rc = -ENOMEM;
> +		goto out_fault_detach;
> +	}
> +
> +	handle->idev = idev;
> +	rc = iommu_replace_group_handle(idev->igroup->group, hwpt->domain,
> +					&handle->handle);
> +	if (rc)
> +		goto out_free_handle;
> +
> +	if (old->fault)
> +		iommufd_fault_domain_detach_dev(old, idev, old_handle,
> +						!hwpt->fault);
> +	kfree(old_handle);
> +
> +	return 0;
> +
> +out_free_handle:
> +	kfree(handle);
> +	handle = NULL;
> +out_fault_detach:
> +	if (hwpt->fault)
> +		iommufd_fault_domain_detach_dev(hwpt, idev, handle,
> +						!old->fault);
> +	return rc;
> +}
> +
>  int iommufd_hw_pagetable_attach(struct iommufd_hw_pagetable *hwpt,
>  				struct iommufd_device *idev)
>  {
> diff --git a/drivers/iommu/iommufd/fault.c b/drivers/iommu/iommufd/fault.c
> index 06aa83a75e94..1d9bd3024b57 100644
> --- a/drivers/iommu/iommufd/fault.c
> +++ b/drivers/iommu/iommufd/fault.c
> @@ -60,42 +60,17 @@ static void iommufd_fault_iopf_disable(struct iommufd_device *idev)
>  	mutex_unlock(&idev->iopf_lock);
>  }
>  
> -static int __fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
> -				     struct iommufd_device *idev)
> -{
> -	struct iommufd_attach_handle *handle;
> -	int ret;
> -
> -	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> -	if (!handle)
> -		return -ENOMEM;
> -
> -	handle->idev = idev;
> -	ret = iommu_attach_group_handle(hwpt->domain, idev->igroup->group,
> -					&handle->handle);
> -	if (ret)
> -		kfree(handle);
> -
> -	return ret;
> -}
> -
>  int iommufd_fault_domain_attach_dev(struct iommufd_hw_pagetable *hwpt,
> -				    struct iommufd_device *idev)
> +				    struct iommufd_device *idev,
> +				    bool enable_iopf)
>  {
> -	int ret;
> +	int rc = 0;
>  
>  	if (!hwpt->fault)
>  		return -EINVAL;
> -
> -	ret = iommufd_fault_iopf_enable(idev);
> -	if (ret)
> -		return ret;
> -
> -	ret = __fault_domain_attach_dev(hwpt, idev);
> -	if (ret)
> -		iommufd_fault_iopf_disable(idev);
> -
> -	return ret;
> +	if (enable_iopf)
> +		rc = iommufd_fault_iopf_enable(idev);
> +	return rc;
>  }
>  
>  static void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
> @@ -127,86 +102,15 @@ static void iommufd_auto_response_faults(struct iommufd_hw_pagetable *hwpt,
>  	mutex_unlock(&fault->mutex);
>  }
>  
> -static struct iommufd_attach_handle *
> -iommufd_device_get_attach_handle(struct iommufd_device *idev)
> -{
> -	struct iommu_attach_handle *handle;
> -
> -	handle = iommu_attach_handle_get(idev->igroup->group, IOMMU_NO_PASID, 0);
> -	if (IS_ERR(handle))
> -		return NULL;
> -
> -	return to_iommufd_handle(handle);
> -}
> -
>  void iommufd_fault_domain_detach_dev(struct iommufd_hw_pagetable *hwpt,
> -				     struct iommufd_device *idev)
> +				     struct iommufd_device *idev,
> +				     struct iommufd_attach_handle *handle,
> +				     bool disable_iopf)
>  {
> -	struct iommufd_attach_handle *handle;
> -
> -	handle = iommufd_device_get_attach_handle(idev);
> -	iommu_detach_group_handle(hwpt->domain, idev->igroup->group);
> -	iommufd_auto_response_faults(hwpt, handle);
> -	iommufd_fault_iopf_disable(idev);
> -	kfree(handle);
> -}
> -
> -static int __fault_domain_replace_dev(struct iommufd_device *idev,
> -				      struct iommufd_hw_pagetable *hwpt,
> -				      struct iommufd_hw_pagetable *old)
> -{
> -	struct iommufd_attach_handle *handle, *curr = NULL;
> -	int ret;
> -
> -	if (old->fault)
> -		curr = iommufd_device_get_attach_handle(idev);
> -
> -	if (hwpt->fault) {
> -		handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> -		if (!handle)
> -			return -ENOMEM;
> -
> -		handle->idev = idev;
> -		ret = iommu_replace_group_handle(idev->igroup->group,
> -						 hwpt->domain, &handle->handle);
> -	} else {
> -		ret = iommu_replace_group_handle(idev->igroup->group,
> -						 hwpt->domain, NULL);
> -	}
> -
> -	if (!ret && curr) {
> -		iommufd_auto_response_faults(old, curr);
> -		kfree(curr);
> -	}
> -
> -	return ret;
> -}
> -
> -int iommufd_fault_domain_replace_dev(struct iommufd_device *idev,
> -				     struct iommufd_hw_pagetable *hwpt,
> -				     struct iommufd_hw_pagetable *old)
> -{
> -	bool iopf_off = !hwpt->fault && old->fault;
> -	bool iopf_on = hwpt->fault && !old->fault;
> -	int ret;
> -
> -	if (iopf_on) {
> -		ret = iommufd_fault_iopf_enable(idev);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	ret = __fault_domain_replace_dev(idev, hwpt, old);
> -	if (ret) {
> -		if (iopf_on)
> -			iommufd_fault_iopf_disable(idev);
> -		return ret;
> -	}
> -
> -	if (iopf_off)
> +	if (handle)
> +		iommufd_auto_response_faults(hwpt, handle);
> +	if (disable_iopf)
>  		iommufd_fault_iopf_disable(idev);
> -
> -	return 0;
>  }
>  
>  void iommufd_fault_destroy(struct iommufd_object *obj)


