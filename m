Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723E8628166
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 14:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiKNNer (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 08:34:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbiKNNej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 08:34:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8DB6362
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 05:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668432833;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9QiRkAJtis8qNtWpCrUk39hYQOMQJJ4HZJSB08SnAc8=;
        b=E2OsdzdouCYXIZTUsLOLsvL/TjP24n3zdciXuc5dfZuM35XKO0YlgNqvlrCNdDwTyifdB+
        LIoJh/164Y9tEm7uYs0hKhF9fyKL1vSAcwPyhPkQNukC1lZyF7hD335fdje6HzAUjUgh75
        i0yCqW++2CRg7pFPcG8kt6Ag2sWzum4=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-548-v4UElolhMMy3Kpav2RZNlw-1; Mon, 14 Nov 2022 08:33:49 -0500
X-MC-Unique: v4UElolhMMy3Kpav2RZNlw-1
Received: by mail-qv1-f69.google.com with SMTP id ng1-20020a0562143bc100b004bb706b3a27so8518502qvb.20
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 05:33:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9QiRkAJtis8qNtWpCrUk39hYQOMQJJ4HZJSB08SnAc8=;
        b=6P9bf6ojhLSAs58BEFf2GiINV2FkIS2Zwx0fPt43cCq6gYO64mtM2m+RjGJRaKIaiI
         Vgx5jEW47j8ws9KuEOu7ZTcLNE300ISlp62EFPz/a3rRYLXhaQ3n1cetg3gRG42NPfM+
         kDkd5WcHdguuIfwYptRBB4FDYOZbncaimOBNMxz9zcbIosbZRaW+m63FSjzGSx+hMQfJ
         YzdCVWVksXVxaQAXwcCp/zcHhDdNA3Ossvn5nLj4uy2ccpynU+u6cddFTf0ikjHuxYOM
         Nefm+tlYbt7PNXT7CaH4M4MnwnNyBCHkt87TlsHaXtChwKvHU4m6R8ITMlv2fZ8LUlT+
         a6bA==
X-Gm-Message-State: ANoB5pmWocpYFbZkbguZyOTdHvck8LpipD8kRqAtuORVtX3RPEZUCYMY
        g82qPa5TTszKtT1T9T+naHAr7QtxaGl352xbEv1AH3cb3vD6YvbKBzabRKv2VM/ErT7u+L6WlzQ
        nn+DiEnyM/Bqn
X-Received: by 2002:a05:622a:2443:b0:3a5:2de8:37d3 with SMTP id bl3-20020a05622a244300b003a52de837d3mr12190340qtb.217.1668432829247;
        Mon, 14 Nov 2022 05:33:49 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5MtlcI6o1/58VPaBjE0NvLA0zMfucHakDiba3NqKYYzSgAMOW+iPLhGMgIOTkcfylqwMLaJw==
X-Received: by 2002:a05:622a:2443:b0:3a5:2de8:37d3 with SMTP id bl3-20020a05622a244300b003a52de837d3mr12190293qtb.217.1668432828927;
        Mon, 14 Nov 2022 05:33:48 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id v12-20020ac8748c000000b0039c37a7914csm5641393qtq.23.2022.11.14.05.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 05:33:48 -0800 (PST)
Message-ID: <e1f7fe9c-5201-3fea-a354-bb79c06ddb4c@redhat.com>
Date:   Mon, 14 Nov 2022 14:33:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v4 02/17] iommu: Add device-centric DMA ownership
 interfaces
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>, bpf@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Shuah Khan <shuah@kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Rix <trix@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Farman <farman@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
References: <2-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <2-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
On 11/8/22 01:48, Jason Gunthorpe wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
>
> These complement the group interfaces used by VFIO and are for use by
> iommufd. The main difference is that multiple devices in the same group
> can all share the ownership by passing the same ownership pointer.
>
> Move the common code into shared functions.
>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommu.c | 124 +++++++++++++++++++++++++++++++++---------
>  include/linux/iommu.h |  12 ++++
>  2 files changed, 110 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 6ca377f4fbf9e9..4cb14e44e40f83 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3108,41 +3108,52 @@ static int __iommu_group_alloc_blocking_domain(struct iommu_group *group)
>  	return 0;
>  }
>  
> +static int __iommu_take_dma_ownership(struct iommu_group *group, void *owner)
> +{
> +	int ret;
> +
> +	if (WARN_ON(!owner))
> +		return -EINVAL;
> +
> +	if ((group->domain && group->domain != group->default_domain) ||
> +	    !xa_empty(&group->pasid_array))
> +		return -EBUSY;
> +
> +	ret = __iommu_group_alloc_blocking_domain(group);
> +	if (ret)
> +		return ret;
> +	ret = __iommu_group_set_domain(group, group->blocking_domain);
> +	if (ret)
> +		return ret;
> +
> +	group->owner = owner;
> +	group->owner_cnt++;
> +	return 0;
> +}
> +
>  /**
>   * iommu_group_claim_dma_owner() - Set DMA ownership of a group
>   * @group: The group.
>   * @owner: Caller specified pointer. Used for exclusive ownership.
>   *
> - * This is to support backward compatibility for vfio which manages
> - * the dma ownership in iommu_group level. New invocations on this
> - * interface should be prohibited.
> + * This is to support backward compatibility for vfio which manages the dma
> + * ownership in iommu_group level. New invocations on this interface should be
> + * prohibited. Only a single owner may exist for a group.
>   */
>  int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
>  {
>  	int ret = 0;
>  
> +	if (WARN_ON(!owner))
> +		return -EINVAL;
> +
>  	mutex_lock(&group->mutex);
>  	if (group->owner_cnt) {
>  		ret = -EPERM;
>  		goto unlock_out;
> -	} else {
> -		if ((group->domain && group->domain != group->default_domain) ||
> -		    !xa_empty(&group->pasid_array)) {
> -			ret = -EBUSY;
> -			goto unlock_out;
> -		}
> -
> -		ret = __iommu_group_alloc_blocking_domain(group);
> -		if (ret)
> -			goto unlock_out;
> -
> -		ret = __iommu_group_set_domain(group, group->blocking_domain);
> -		if (ret)
> -			goto unlock_out;
> -		group->owner = owner;
>  	}
>  
> -	group->owner_cnt++;
> +	ret = __iommu_take_dma_ownership(group, owner);
>  unlock_out:
>  	mutex_unlock(&group->mutex);
>  
> @@ -3151,30 +3162,91 @@ int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner)
>  EXPORT_SYMBOL_GPL(iommu_group_claim_dma_owner);
>  
>  /**
> - * iommu_group_release_dma_owner() - Release DMA ownership of a group
> - * @group: The group.
> + * iommu_device_claim_dma_owner() - Set DMA ownership of a device
> + * @dev: The device.
> + * @owner: Caller specified pointer. Used for exclusive ownership.
>   *
> - * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
> + * Claim the DMA ownership of a device. Multiple devices in the same group may
> + * concurrently claim ownership if they present the same owner value. Returns 0
> + * on success and error code on failure
>   */
> -void iommu_group_release_dma_owner(struct iommu_group *group)
> +int iommu_device_claim_dma_owner(struct device *dev, void *owner)
>  {
> -	int ret;
> +	struct iommu_group *group = iommu_group_get(dev);
> +	int ret = 0;
> +
> +	if (!group)
> +		return -ENODEV;
>  
>  	mutex_lock(&group->mutex);
> +	if (group->owner_cnt) {
> +		if (group->owner != owner) {
> +			ret = -EPERM;
> +			goto unlock_out;
> +		}
> +		group->owner_cnt++;
> +		goto unlock_out;
> +	}
> +
> +	ret = __iommu_take_dma_ownership(group, owner);
> +unlock_out:
> +	mutex_unlock(&group->mutex);
> +	iommu_group_put(group);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(iommu_device_claim_dma_owner);
> +
> +static void __iommu_release_dma_ownership(struct iommu_group *group)
> +{
> +	int ret;
> +
>  	if (WARN_ON(!group->owner_cnt || !group->owner ||
>  		    !xa_empty(&group->pasid_array)))
> -		goto unlock_out;
> +		return;
>  
>  	group->owner_cnt = 0;
>  	group->owner = NULL;
>  	ret = __iommu_group_set_domain(group, group->default_domain);
>  	WARN(ret, "iommu driver failed to attach the default domain");
> +}
>  
> -unlock_out:
> +/**
> + * iommu_group_release_dma_owner() - Release DMA ownership of a group
> + * @group: The group.
> + *
> + * Release the DMA ownership claimed by iommu_group_claim_dma_owner().
> + */
> +void iommu_group_release_dma_owner(struct iommu_group *group)
> +{
> +	mutex_lock(&group->mutex);
> +	__iommu_release_dma_ownership(group);
>  	mutex_unlock(&group->mutex);
>  }
>  EXPORT_SYMBOL_GPL(iommu_group_release_dma_owner);
>  
> +/**
> + * iommu_device_release_dma_owner() - Release DMA ownership of a device
> + * @group: The device.
@dev: the device
> + *
> + * Release the DMA ownership claimed by iommu_device_claim_dma_owner().
> + */
> +void iommu_device_release_dma_owner(struct device *dev)
> +{
> +	struct iommu_group *group = iommu_group_get(dev);
> +
> +	mutex_lock(&group->mutex);
> +	if (group->owner_cnt > 1) {
> +		group->owner_cnt--;
> +		goto unlock_out;
> +	}
> +	__iommu_release_dma_ownership(group);
> +unlock_out:
> +	mutex_unlock(&group->mutex);

if (group->owner_cnt > 1)

	group->owner_cnt--;
else
	__iommu_release_dma_ownership(group);

mutex_unlock(&group->mutex);

iommu_group_put(group);

> +	iommu_group_put(group);
> +}
> +EXPORT_SYMBOL_GPL(iommu_device_release_dma_owner);
> +
>  /**
>   * iommu_group_dma_owner_claimed() - Query group dma ownership status
>   * @group: The group.
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index a09fd32d8cc273..1690c334e51631 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -707,6 +707,9 @@ int iommu_group_claim_dma_owner(struct iommu_group *group, void *owner);
>  void iommu_group_release_dma_owner(struct iommu_group *group);
>  bool iommu_group_dma_owner_claimed(struct iommu_group *group);
>  
> +int iommu_device_claim_dma_owner(struct device *dev, void *owner);
> +void iommu_device_release_dma_owner(struct device *dev);
> +
>  struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
>  					    struct mm_struct *mm);
>  int iommu_attach_device_pasid(struct iommu_domain *domain,
> @@ -1064,6 +1067,15 @@ static inline bool iommu_group_dma_owner_claimed(struct iommu_group *group)
>  	return false;
>  }
>  
> +static inline void iommu_device_release_dma_owner(struct device *dev)
> +{
> +}
> +
> +static inline int iommu_device_claim_dma_owner(struct device *dev, void *owner)
> +{
> +	return -ENODEV;
> +}
> +
>  static inline struct iommu_domain *
>  iommu_sva_domain_alloc(struct device *dev, struct mm_struct *mm)
>  {
Besides
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric

