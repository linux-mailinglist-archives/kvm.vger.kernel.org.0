Return-Path: <kvm+bounces-36412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FE8EA1A8A7
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 18:15:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB8BC189079E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 17:11:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8CF156F2B;
	Thu, 23 Jan 2025 17:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dA6eSxdc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8858F14C59C
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 17:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737652263; cv=none; b=QNiBhgEsNvBApEWQXJ3qg9KILmIUAsXGJUbn9nj4opQBtU7BvYhRObGKdPTpO24HCP3BNAYIDWLu2tFJg9vOwi55L1rB3ih+V1UPDQ1QY93BJdXLBsSSlokfibF/zLD2me5PhP9N0VmU0h8mrO8jyO90eNSer1EX7cvBQJMDpCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737652263; c=relaxed/simple;
	bh=So1bT6v/8IBUYr9O0B8Tc8G+IQCBnuKe6Hrn1SqQMRs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVADvFwDqjxVFSA8LwL8hfNPdHWW4OtPlMBEFs3+Zc34CBsY2Ba34ioZDyjBT82KJ0tD3hW8Hb8ajZH6Es51AYmj8USWnQi2cWnfbIMPX1sihOhmCiPGbErcpk9Y1LcPU4yMn+M5knTonrBijB4yL1eIoC0Z2sDOtypJTETy2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dA6eSxdc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737652260;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f2lz1JhxCiAQPWfDUtfyCfkikpyW82hyEvi1Or2PPgU=;
	b=dA6eSxdcTM9zs5iEBA8ytwPYBUY0aMBbkJuoZ6/e1CsDCnBT7oM/Dkr1UfhlXV8A/PvZSv
	7++adDN/dvfBM1lCmu/CQoGfFt47D6+qij/EbLmCu7wQPzCwpbtD6Vxvw1EJeT81Kj50vh
	gMvPmq/1ZRwqbH5su4a2IpMtgbekt44=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-wkrIUIKcNty35-H4j2CpkA-1; Thu, 23 Jan 2025 12:10:56 -0500
X-MC-Unique: wkrIUIKcNty35-H4j2CpkA-1
X-Mimecast-MFC-AGG-ID: wkrIUIKcNty35-H4j2CpkA
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-38634103b0dso663171f8f.2
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 09:10:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737652255; x=1738257055;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f2lz1JhxCiAQPWfDUtfyCfkikpyW82hyEvi1Or2PPgU=;
        b=MKpo0f8CrdjfkesTEZREP0z+1jAQ9BgG+wEoDpwd9+TqdBCR8VsnUW19bSaubeNLL8
         Fd3VWRv8BdGGSRbPnqPLkODVMrS6qGAakPzQ/L6wYp94velTzGLTq6Ml20Dh9sie6ZSn
         NUYbmFh4qUUYUuAiWRkXfLDBXL34zc2pvw5utMMMVELsJinT9DVOLzXtExGUIrjhc2JH
         r+9qS6YTEPBdjunW9v4twxMXIxcoCngfN53H4P+0JXLtoJ9xKPnV3pP/TzE9j/y11IQH
         Quie7/CGEBkLW6Kvw6c4UIcOqEUmYkNa725jfnYqkH8rhFCCAXevVcyOpQKuvHdOShca
         yfug==
X-Forwarded-Encrypted: i=1; AJvYcCWrE9fF7UpPLHZ6qcItY01MsXbpmrUcvijKkOhPNTXi7YGyVE31L3HHCHsQtZ5JjLiaDMs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZhB2FW6jqmRIxidfGTRuCwnuPsQinVMeEL2YgaKGQNGkJ6CM+
	4dbEgpn+kQ5mSVX5aO9B3Tnwc3NpRRiqmDC88TjS73PzAqp1nX/HMob9J6IxH+cJ3Nwn24tr+/Y
	rfvXB3LQAcC/EXVGqLzsHaesO2Nxds3/f2/o5fTiVZ2DbJ0flkg==
X-Gm-Gg: ASbGnctv2bWVIcJSVLVMMrRcHcY8LNOyA1EU3ErL44XmY/PDQIAZl8TZ51VZzq7O4wx
	vFLJPdVYre7Uq97LmDc2mZKVAalrnpeCJRKwH5YnihSWOuaRIvoPMkO3kpoeYfqlYFu/8w1FyMj
	21WOLG8l7wTAbgI6Airma4gCnsTB3OLSRXGKNsKSSQcFQQIqmVXHMyWRslrClKj0VrHlEO8xBST
	8eajbKVD4ds7zer+ENvlAWHisu7Svari4NlxqWA7I0Y16wdTkw0DyJdzJrSvnl46jYrW6MoaK1p
	nwH4XCaHJSuVVcZDjt+T21VJdz2jiO5TFBCtkAU+tA==
X-Received: by 2002:a5d:6da4:0:b0:38b:e32a:10a6 with SMTP id ffacd0b85a97d-38bf57a9932mr29480871f8f.41.1737652255076;
        Thu, 23 Jan 2025 09:10:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGK/5MgTOgXIu9+Lg1LjrltVZkaY8JHUprLufh35bjJjxTwBW+dXwhnf8hS5iSt70eBgqDsvw==
X-Received: by 2002:a5d:6da4:0:b0:38b:e32a:10a6 with SMTP id ffacd0b85a97d-38bf57a9932mr29480826f8f.41.1737652254632;
        Thu, 23 Jan 2025 09:10:54 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b31d9a39sm67975795e9.31.2025.01.23.09.10.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 09:10:53 -0800 (PST)
Message-ID: <1b48e138-3134-442a-9796-e3a33b106221@redhat.com>
Date: Thu, 23 Jan 2025 18:10:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH RFCv2 01/13] genirq/msi: Store the IOMMU IOVA directly in
 msi_desc instead of iommu_cookie
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
 <671b2128c193fc9ac9af0f4add96f85a785f513a.1736550979.git.nicolinc@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <671b2128c193fc9ac9af0f4add96f85a785f513a.1736550979.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


Hi Nicolin,

On 1/11/25 4:32 AM, Nicolin Chen wrote:
> From: Jason Gunthorpe <jgg@nvidia.com>
>
> All the iommu cases simply want to override the MSI page's address with
those which translate MSIs
> the IOVA that was mapped through the iommu. This doesn't need a cookie
> pointer, we just need to store the IOVA and its page size in the msi_desc.
>
> Instead provide msi_desc_set_iommu_msi_iova() which allows the IOMMU side
> to specify the IOVA that the MSI page is placed during
> iommu_dma_prepare(). This is stored in the msi_desc and then
iommu_dma_prepare_msi()
> iommu_dma_compose_msi_msg() is a simple inline that sets address_hi/lo.
>
> The next patch will correct the naming.
>
> This is done because we cannot correctly lock access to group->domain in
> the atomic context that iommu_dma_compose_msi_msg() is called under. Today
> the locking miss is tolerable because dma_iommu.c operates under an
> assumption that the domain does not change while a driver is probed.
>
> However iommufd now permits the domain to change while the driver is
> probed and VFIO userspace can create races with IRQ changes calling
> iommu_dma_prepare/compose_msi_msg() and changing/freeing the iommu_domain.
and is it safe in iommu_dma_prepare_msi()?
>
> Removing the pointer, and critically, the call to
> iommu_get_domain_for_dev() during compose resolves this race.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h     |  6 ------
>  include/linux/msi.h       | 45 +++++++++++++++++++++++----------------
>  drivers/iommu/dma-iommu.c | 30 +++++---------------------
>  3 files changed, 32 insertions(+), 49 deletions(-)
>
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 318d27841130..3a4215966c1b 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -1513,7 +1513,6 @@ static inline void iommu_debugfs_setup(void) {}
>  int iommu_get_msi_cookie(struct iommu_domain *domain, dma_addr_t base);
>  
>  int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr);
> -void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg);
>  
>  #else /* CONFIG_IOMMU_DMA */
>  
> @@ -1529,11 +1528,6 @@ static inline int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_a
>  {
>  	return 0;
>  }
> -
> -static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
> -{
> -}
> -
>  #endif	/* CONFIG_IOMMU_DMA */
>  
>  /*
> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index b10093c4d00e..d442b4a69d56 100644
> --- a/include/linux/msi.h
> +++ b/include/linux/msi.h
> @@ -184,7 +184,8 @@ struct msi_desc {
>  	struct msi_msg			msg;
>  	struct irq_affinity_desc	*affinity;
>  #ifdef CONFIG_IRQ_MSI_IOMMU
> -	const void			*iommu_cookie;
you may add kernel doc comments above
> +	u64				iommu_msi_iova : 58;
> +	u64				iommu_msi_page_shift : 6;
>  #endif
>  #ifdef CONFIG_SYSFS
>  	struct device_attribute		*sysfs_attrs;
> @@ -285,28 +286,36 @@ struct msi_desc *msi_next_desc(struct device *dev, unsigned int domid,
>  
>  #define msi_desc_to_dev(desc)		((desc)->dev)
>  
> -#ifdef CONFIG_IRQ_MSI_IOMMU
> -static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
> -{
> -	return desc->iommu_cookie;
> -}
> -
> -static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
> -					     const void *iommu_cookie)
> +static inline void msi_desc_set_iommu_msi_iova(struct msi_desc *desc,
> +					       u64 msi_iova,
> +					       unsigned int page_shift)
>  {
> -	desc->iommu_cookie = iommu_cookie;
> -}
> -#else
> -static inline const void *msi_desc_get_iommu_cookie(struct msi_desc *desc)
> -{
> -	return NULL;
> +#ifdef CONFIG_IRQ_MSI_IOMMU
> +	desc->iommu_msi_iova = msi_iova >> page_shift;
> +	desc->iommu_msi_page_shift = page_shift;
> +#endif
>  }
>  
> -static inline void msi_desc_set_iommu_cookie(struct msi_desc *desc,
> -					     const void *iommu_cookie)
> +/**
> + * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
> + * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
> + * @msg: MSI message containing target physical address
> + */
> +static inline void iommu_dma_compose_msi_msg(struct msi_desc *desc,
> +					     struct msi_msg *msg)
>  {
> -}
> +#ifdef CONFIG_IRQ_MSI_IOMMU
> +	if (desc->iommu_msi_page_shift) {
> +		u64 msi_iova = desc->iommu_msi_iova
> +			       << desc->iommu_msi_page_shift;
> +
> +		msg->address_hi = upper_32_bits(msi_iova);
> +		msg->address_lo = lower_32_bits(msi_iova) |
> +				  (msg->address_lo &
> +				   ((1 << desc->iommu_msi_page_shift) - 1));
> +	}
>  #endif
> +}
>  
>  int msi_domain_insert_msi_desc(struct device *dev, unsigned int domid,
>  			       struct msi_desc *init_desc);
> diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
> index 2a9fa0c8cc00..bf91e014d179 100644
> --- a/drivers/iommu/dma-iommu.c
> +++ b/drivers/iommu/dma-iommu.c
> @@ -1815,7 +1815,7 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
>  	static DEFINE_MUTEX(msi_prepare_lock); /* see below */
>  
>  	if (!domain || !domain->iova_cookie) {
> -		desc->iommu_cookie = NULL;
> +		msi_desc_set_iommu_msi_iova(desc, 0, 0);
>  		return 0;
>  	}
>  
> @@ -1827,33 +1827,13 @@ int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
>  	mutex_lock(&msi_prepare_lock);
>  	msi_page = iommu_dma_get_msi_page(dev, msi_addr, domain);
>  	mutex_unlock(&msi_prepare_lock);
> -
> -	msi_desc_set_iommu_cookie(desc, msi_page);
> -
>  	if (!msi_page)
>  		return -ENOMEM;
> -	return 0;
> -}
>  
> -/**
> - * iommu_dma_compose_msi_msg() - Apply translation to an MSI message
> - * @desc: MSI descriptor prepared by iommu_dma_prepare_msi()
> - * @msg: MSI message containing target physical address
> - */
> -void iommu_dma_compose_msi_msg(struct msi_desc *desc, struct msi_msg *msg)
> -{
> -	struct device *dev = msi_desc_to_dev(desc);
> -	const struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
> -	const struct iommu_dma_msi_page *msi_page;
> -
> -	msi_page = msi_desc_get_iommu_cookie(desc);
> -
> -	if (!domain || !domain->iova_cookie || WARN_ON(!msi_page))
> -		return;
> -
> -	msg->address_hi = upper_32_bits(msi_page->iova);
> -	msg->address_lo &= cookie_msi_granule(domain->iova_cookie) - 1;
> -	msg->address_lo += lower_32_bits(msi_page->iova);
> +	msi_desc_set_iommu_msi_iova(
> +		desc, msi_page->iova,
> +		ilog2(cookie_msi_granule(domain->iova_cookie)));
> +	return 0;
>  }
>  
>  static int iommu_dma_init(void)


