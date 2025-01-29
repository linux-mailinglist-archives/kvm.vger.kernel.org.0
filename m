Return-Path: <kvm+bounces-36842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 93BF3A21CFA
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 13:11:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CB220188737B
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 12:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7222A1DACB8;
	Wed, 29 Jan 2025 12:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d2aKz62o"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB031D63CF
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738152674; cv=none; b=pyeAIwgzVoPoZLUhtybFU+IxFSk5ninBMu4DnuVCLZMYeMVsjLi7KGj995Rf/WZiAqXxdG1F9r2MvRewQ8d/gyiBLvZ4S1z01JQZgGTFSf4kcZgpIJBNCgXCSuJP5k1pBhtAIiW8H7QcTWq1S30uzDX74Bx2mbfTwSg+zJi3SrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738152674; c=relaxed/simple;
	bh=6IdA7SqmTNXeAUkejuPdnOPZIQXSzN75bEY9k/EhdgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bzh+4uD0Ml06RfTMyfs8RpDUrhQUwS/DIeEtcXKOEv0O9VEfx4zKPSP1F0Sje0e1Tx95t7LyAz4z0uSEDWVQKypGcnlKh8Oiz6aGouTaQwoYEl1kWEfFUPhW9BhhB0NimFdzFC9aNdKsiotoqvk6nwQhEIFjYsTR7XQVaq1v3+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d2aKz62o; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738152672;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FfYT43qInjD7+NE+73mPjG28PGMRFzMEZ6xoue/ST5Q=;
	b=d2aKz62oKVOASe8PrigYXLJQ0lMGRQINldyIvr4bgpmBUcZWX3iGclsFHK/3K/40rszAKd
	7YjAZ9G/AiL1eRhzUKOd5BRGYGNwNkbXbndESg5T4LdCurij0Ohij6elHdkFkf1ldx1DS/
	EftO+YmiNpqPs8ZYpUHYzG0guZ0jEdk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-25-Oo615a28N3OzPrlAAZSaOw-1; Wed, 29 Jan 2025 07:11:10 -0500
X-MC-Unique: Oo615a28N3OzPrlAAZSaOw-1
X-Mimecast-MFC-AGG-ID: Oo615a28N3OzPrlAAZSaOw
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5d9e4d33f04so6101081a12.0
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 04:11:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738152669; x=1738757469;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfYT43qInjD7+NE+73mPjG28PGMRFzMEZ6xoue/ST5Q=;
        b=ECBfZ223P2tgXVEgGTBq75t5XeX3wy0WSDDkwiJsmLu3Jm42ZaNU1JM6810MTQpRiw
         Lw+y94O6O/Bjx0TQvgHoVn7x9srr/A5YdOJ/KusUSHpyZ5UOq06zDpGGQeEDWtEW1j7i
         89jttfvJXVUtbKPFUDeL6S4WBmQWsY9jHGdQBA+d1oykhH9R12a1Gjtfxg52+Vn2lAUX
         RNvHb6HyYQmYRCE0zdl33EMOwFqBlyTsQIuVUf+BdcV0sCv8q+zqPlV6A3JvA9Kdk5yZ
         ltnnFk9El/+ZEl4iwWwHx/+aozIRTiMrAk4iTS/KEG5Ax9qmueFRFAZVwbMME9RHkG+5
         lU7w==
X-Forwarded-Encrypted: i=1; AJvYcCW4CKWCOSGieL2CzLuUoTkGE5VBG78+UhfAjlC2FIJ6XDAWLxr9sJhVSWC89/3mNs1MuhU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxncBHRw8Y0+TEO6b7owByWHDfO6Rf12rrwGlpoXjW+XzH/9QWE
	iBbExOf0diEQx79qEf4yIn7uEBFb9CCL2d51aVD02zfD1vV2PzxwFGgmVCwa0ISyZxPy65UqHc8
	vTrq4UcHAXncdqyErZn14Os+GtIwlQ4HRjQMjElORFRhzM2PjEw==
X-Gm-Gg: ASbGncu33Hy6KISNDfmJEozY5gUqpASeZSjqYaLz+VLj86gpNOvpPXk/NZmHqBMQeqg
	37KnDfrrx8W99kV6kEtxMkVsic1aytB1u7r7FFFA7qDuWj6O5dclQ9eXFuZgHIbJUF6F0StqFlv
	GoUOOFqVqKrOQ2Pm8XJi3ORezOqRVzfpTbYQ12aiiRdSXkgjy46YhZsbp0Udw1mOGsPdBJLGEbB
	QjmwBTbF7j6fvj8e1UqXx+qy/36CPhvQH/xd+6m5t636GJz0p0QtyeYl9zS5PtTmfRWCoqxMeVP
	GFEgiRN+GZOptSOeOiqdoHlXUdmQsDOu9c9swROEKg2XAn5a4pHC
X-Received: by 2002:a05:6402:42d4:b0:5d9:a54:f8b4 with SMTP id 4fb4d7f45d1cf-5dc5efbf5bamr2757070a12.11.1738152669141;
        Wed, 29 Jan 2025 04:11:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHWwGofFlveJZZ8Y8RCQ261keTvS+w2IGgafzQLJiEPoI+LUqDstLACEsFV9aVwDeaatRYmZg==
X-Received: by 2002:a05:6402:42d4:b0:5d9:a54:f8b4 with SMTP id 4fb4d7f45d1cf-5dc5efbf5bamr2757022a12.11.1738152668668;
        Wed, 29 Jan 2025 04:11:08 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc1863978asm8680072a12.33.2025.01.29.04.11.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2025 04:11:06 -0800 (PST)
Message-ID: <38896dfc-b5d9-4efd-8aff-bbe8cdb47c6e@redhat.com>
Date: Wed, 29 Jan 2025 13:11:03 +0100
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
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Nicolin Chen <nicolinc@nvidia.com>, will@kernel.org,
 robin.murphy@arm.com, kevin.tian@intel.com, tglx@linutronix.de,
 maz@kernel.org, alex.williamson@redhat.com, joro@8bytes.org,
 shuah@kernel.org, reinette.chatre@intel.com, yebin10@huawei.com,
 apatel@ventanamicro.com, shivamurthy.shastri@linutronix.de,
 bhelgaas@google.com, anna-maria@linutronix.de, yury.norov@gmail.com,
 nipun.gupta@amd.com, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
 jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
 shameerali.kolothum.thodi@huawei.com, smostafa@google.com, ddutile@redhat.com
References: <cover.1736550979.git.nicolinc@nvidia.com>
 <671b2128c193fc9ac9af0f4add96f85a785f513a.1736550979.git.nicolinc@nvidia.com>
 <1b48e138-3134-442a-9796-e3a33b106221@redhat.com>
 <20250123184855.GU5556@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20250123184855.GU5556@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,


On 1/23/25 7:48 PM, Jason Gunthorpe wrote:
> On Thu, Jan 23, 2025 at 06:10:48PM +0100, Eric Auger wrote:
>
>>> However iommufd now permits the domain to change while the driver is
>>> probed and VFIO userspace can create races with IRQ changes calling
>>> iommu_dma_prepare/compose_msi_msg() and changing/freeing the iommu_domain.
>> and is it safe in iommu_dma_prepare_msi()?
> iommu_dma_prepare_msi() takes the group mutex:
>
> int iommu_dma_prepare_msi(struct msi_desc *desc, phys_addr_t msi_addr)
> {
> 	struct device *dev = msi_desc_to_dev(desc);
> 	struct iommu_group *group = dev->iommu_group;
>
> 	mutex_lock(&group->mutex);
> 	if (group->domain && group->domain->sw_msi)
> 		ret = group->domain->sw_msi(group->domain, desc, msi_addr);
>
> Which prevents changing domain attachments during execution.
>
> For iommufd, if the domain attachment changes immediately after
> iommu_dma_prepare_msi() unlocks, then the information given to
> msi_desc_set_iommu_msi_iova() is still valid on the new domain.
>
> This is because the iommufd implementation of sw_msi keeps the same
> IOVA for the same ITS page globally across all domains. Any racing
> change of domain will attach a new domain with the right ITS IOVA
> already mapped and populated.
> It is why this series stops using the domain pointer as a cookie
> inside the msi_desc, immediately after the group->mutex is unlocked
> a new domain can be attached and the old domain can be freed, which
> would UAF the domain pointer in the cookie.
OK thank you for the clarification
>
>>> diff --git a/include/linux/msi.h b/include/linux/msi.h
>>> index b10093c4d00e..d442b4a69d56 100644
>>> --- a/include/linux/msi.h
>>> +++ b/include/linux/msi.h
>>> @@ -184,7 +184,8 @@ struct msi_desc {
>>>  	struct msi_msg			msg;
>>>  	struct irq_affinity_desc	*affinity;
>>>  #ifdef CONFIG_IRQ_MSI_IOMMU
>>> -	const void			*iommu_cookie;
>> you may add kernel doc comments above
> I wondered if internal stuff was not being documented as the old
> iommu_cookie didn't have a comment..
>
> But sure:
>
>  * @iommu_msi_iova: Optional IOVA from the IOMMU to overide the msi_addr.
>  *                  Only used if iommu_msi_page_shift != 0
>  * @iommu_msi_page_shift: Indicates how many bits of the original address
>  *                        should be preserved when using iommu_msi_iova.
Sounds good

Eric
>
> Jason
>


