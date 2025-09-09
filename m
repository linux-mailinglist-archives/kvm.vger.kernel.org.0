Return-Path: <kvm+bounces-57040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 200AEB4A08E
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 06:17:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37EF81BC21FB
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 04:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B2882E0B48;
	Tue,  9 Sep 2025 04:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gazw1fRq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3BCB1DA4E
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 04:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757391427; cv=none; b=HfnyPlhWBnwc9q6HZVdnHo1uOX19zhdJqndb9Maagx0t3qUEsmGf7Tq7nJ+EGX1/nQ6CKw9yYtrJLGavy3PE+89lt4GCSxgpZMTquW4OMFug/Zo9hvhqjmiDwej1NjmFBSapKq3RKOv9O/q2i1GRNZlS3W/NhL2qSgPR7dPIrvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757391427; c=relaxed/simple;
	bh=Vrtl+xs7K4zXcPnLFH1TuZOu/V+27YNQSOap/9QG3ug=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BZ0HzW/qjVSaf3ElE34MjoZlc8uA14ucCIMbojYutIMx8/2EURI2UTMMvIxCSh8WukGqPrKoZoKPYAd03FO3V7YwoD1d7n7CdRj+OqZkJrAz/XcP/j49H3J1z/5A1pHep2OqE/LsZcMuZ0LlDE+pYR4svhjkTentx3DZjhrRiT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gazw1fRq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757391424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PXc4wYDZmZ/L8uZekYzqBJVvEmMbocn1KotryOo59zE=;
	b=gazw1fRq3FlUpr9AAM3srtv70EnitSiZV8xi/tSoQH23d/eFrUHSaO3Fbbk8HdeB763MKJ
	aVXVF9u9e5+XNwWIu7n1FiE5wmL5kOFLLQKqAvhTnBrKp3HOOKkGC9DeaW5RTIf+blb9Xn
	+ajVRMs4H6imOqNeQvjWmRI110LiOmA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-607-z3yvRi2BNKaD8oSrC7JSCA-1; Tue, 09 Sep 2025 00:17:02 -0400
X-MC-Unique: z3yvRi2BNKaD8oSrC7JSCA-1
X-Mimecast-MFC-AGG-ID: z3yvRi2BNKaD8oSrC7JSCA_1757391422
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4b5f91cdf14so131994841cf.0
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 21:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757391422; x=1757996222;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXc4wYDZmZ/L8uZekYzqBJVvEmMbocn1KotryOo59zE=;
        b=cfUNrpmV9IHDi6j4KDqnzDd5KKD9nwwg8sgjYFcm+YAnjPgKY5g8a1JfxfDKEsg8Cf
         2X2c8ssM+ZlYfqmUx8IMvw3I2NEHnlILIPL6v1hyzNn1yUHZbhMv5LwxRfJ1MRZYbZYB
         k6J/96OY4lti9zXrY/cMPjW0fi/6bXS/AsT1vkw1beZOmZOeweAe6Ziafcqw7/LFd99y
         GVp6yudppZJh4mzes5smWpbBFIMQD+lS53jYQgVOyWxaZcdnjiaYQEqigPw2IvmQVu9u
         YGpOVinfiPjhuv78j8TGA8OZGfrD3SUpGBtshRP+GqRT0/V/KP/6Y1AAXTwC5xL7vX3r
         uyEg==
X-Forwarded-Encrypted: i=1; AJvYcCXARVFG17Q/i309wNezjh7dUwBTFAWzy8qBVePXgO7wNTMxk2yAUxrWG+bdXkFJ0/Ln7n0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwoNFS7NFqMBDn/TTJa60M5gdxFuodv0SdD+eabg0QNb9axrceE
	wV49XVlMB45doQcnhh76WghZ/Llv2IVAXwpc0tBz2MGcueRy2XFTu5ME6QHtOsyJwNX181T1rk1
	sCd+Kd0ho1Afme/yTHDOxbITmJjJovwQU0pOTbx9+ns/EhhxfiHWAVA==
X-Gm-Gg: ASbGncvr/KVpnUxaVzy30eRKpBTBq+gteyJ4lUQnvcKKMfJfGQSPYBH4Y3d+zuzwpEL
	YWuLm2iT/MLhPJsrSIZwcaQ0pWVLmJDBm+zXB3+XvzZDbkqKmmISE6m/gSBO1X+Rdn95zOux4wF
	jhM3f/h4NcLIX5h0MLb/5jvO530hZmo1vLt7saHb8bBQcXeMKsOwhR+PVIHcRAxJCO60LgQiSua
	cshsA4/SrJt0PiR2gEnlu0EjOPNnKDg3kQ4HQXxHfc0szSoAre8p9vuANul+OYCKZXvQ73/6SxF
	WDtXd830p4ROSs42pK5F12BLf6ZwHTuAQ+yzfXfG
X-Received: by 2002:ac8:7f56:0:b0:4b2:fcf4:44c9 with SMTP id d75a77b69052e-4b5f846701amr118252541cf.60.1757391422227;
        Mon, 08 Sep 2025 21:17:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlZTe8MK04WhNv9/TediecLNUlQjS4uZJ6D+gPH8b1KU0M6GQFQ+qYugLVX8lKpMw4F3h/7g==
X-Received: by 2002:ac8:7f56:0:b0:4b2:fcf4:44c9 with SMTP id d75a77b69052e-4b5f846701amr118252291cf.60.1757391421878;
        Mon, 08 Sep 2025 21:17:01 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-728a860bdebsm100439826d6.69.2025.09.08.21.16.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 21:17:01 -0700 (PDT)
Message-ID: <d89d3606-a464-443a-891c-637f304127d5@redhat.com>
Date: Tue, 9 Sep 2025 00:16:59 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/11] iommu: Organize iommu_group by member size
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <4-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <4-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/5/25 2:06 PM, Jason Gunthorpe wrote:
> To avoid some internal padding.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 1874bbdc73b75e..543d6347c0e5e3 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -58,13 +58,13 @@ struct iommu_group {
>   	void *iommu_data;
>   	void (*iommu_data_release)(void *iommu_data);
>   	char *name;
> -	int id;
>   	struct iommu_domain *default_domain;
>   	struct iommu_domain *blocking_domain;
>   	struct iommu_domain *domain;
>   	struct list_head entry;
> -	unsigned int owner_cnt;
>   	void *owner;
> +	unsigned int owner_cnt;
> +	int id;
>   
>   	/* Used by the device_group() callbacks */
>   	u32 bus_data;

ok, but still leaves a 32-bit hole at the end, which would occur in the struct if bus_data was put after id or owner_cnt.

Reviewed-by: Donald Dutile <ddutile@redhat.com>


