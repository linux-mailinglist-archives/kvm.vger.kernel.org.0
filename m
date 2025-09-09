Return-Path: <kvm+bounces-57130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C762FB50670
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 21:33:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6F731C27104
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 19:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCD8E2D77EF;
	Tue,  9 Sep 2025 19:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G0clw1fX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7172E2DD4
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 19:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757446420; cv=none; b=GGBHmZ3TJEEcdg0lhtMSMRophYO6WUUWzKMYBszCJLc0COyXVwVC5TyUA2HzgrrAOmHKDcSPCeg/ZpdI/sphyDHJgWHTdAV3XYMTjr/Igi1BbugUc1lmilxRZ+Wubuc9mQaTsvir6SuZiCW7wuevZi7/RdCl9t04te4xRE2bsRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757446420; c=relaxed/simple;
	bh=mUgqnSrCeNtyPRzp40kafmu2emrwvDGauUeKsNnrkLk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SKtOVVwwgdIDX7ZyoNA7Pgnn2uxrIr2ya0ui3p9QOnRRPVm/p/a+ck2RKYUfgSFHveH0iEQl1Qm7qWvpVCHwSG4c7D1kWEQG0NyZPXM4GcLOMQBPzYjXLhS6pfCw3xvooCPAmHT1ysoOnklpYLgssVs1JWFcTStSJu74sXRHpPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G0clw1fX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757446417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xv0UmvOM6iq9BarO5ln98fc4nB6oP2f7t4wXJ04yBgo=;
	b=G0clw1fX6AvGkMrAm6568HS4gLuy0l0CLv8+1ItuSYXfoarZAVMB8f3Hj7ojKN4e1i/34R
	4+vD1lsrye4OmmmvyVBVpPySVeHm6NJISTRtTueKZQOH484WnQio9kfa5A4d4vVDK4xVxc
	lz3xd8OBPoSyLLL/di+QmY35o3nINdo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-l1GIR1EUMZGwdyT8oBfHDA-1; Tue, 09 Sep 2025 15:33:35 -0400
X-MC-Unique: l1GIR1EUMZGwdyT8oBfHDA-1
X-Mimecast-MFC-AGG-ID: l1GIR1EUMZGwdyT8oBfHDA_1757446415
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-4b5eb7b2c05so131334131cf.0
        for <kvm@vger.kernel.org>; Tue, 09 Sep 2025 12:33:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757446415; x=1758051215;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xv0UmvOM6iq9BarO5ln98fc4nB6oP2f7t4wXJ04yBgo=;
        b=ZNxAyKOOFWhNBhfV33FhYkwlVgeijU0yH7ryYxoW65zUOCbbegy8BREKSQPN5TTv3X
         7PvlB7Y7IpXzAKamXcQIL1r55ch7GEAF5hVhyWzZ9dR8lcbDgoSnhD96tbYYb+igOaXK
         7e5RV6YQiKSX5oR8Z4lFgCkSodGlpm19I50DeDZmYLMM3GQbGlvxTWygNx5/1vB/NLAY
         x6ifuALNAPCAlEJUlmOE/zqkiF1I0FclReArESmdhNeVmrnDKeif9PDzrcAtVF03KT2D
         EiNXlQhnTysi0b+bMvR0aOswrTn8CeZvvihBhkVduIy63Ztmklx74PyZfUGiqkXmpz+y
         RjNw==
X-Forwarded-Encrypted: i=1; AJvYcCVxwUmKaLXrHjEKJcYG15suWqiH3N/AcbJJIYne70UHPESEqbnjDP1b1HUix83bgqrUlYI=@vger.kernel.org
X-Gm-Message-State: AOJu0YykI30qDUXRwclEN5q9qdneX2Y/9YuaN5U3NwQKiEvVAMRmdemX
	OCKhmXSK5Y9P4oDHFU/dB63Ohr3Ak2H7cdam+bl5kOe5NmveFT+rEyLrh11LhZjnOEx9m//uJpq
	8tbhf9euFbZo0VP04Y0ebKoTKK2mpqP1x1XA6F40/FHMaUJhtglmUsw==
X-Gm-Gg: ASbGncu2psgJWa2GqYD9oTbWZn6hPtszCer5FDO1cZP299+5HLbehiYiVdGOwj1UW+K
	4ipDzBtOi3cLjfSkgUPtCZRpBMWRxmcSQuFlQ/5Twez8SAu63zEtOoPbmlM6c9MWiu9yoMKDeKs
	JJnRvk9phIi3nDn6AA7ngbJv/Upc7Wrw4gF5WppNdJ2usvxv5a+Vgh7hsDaxiFN7HMKtp6y0pZE
	jiJ0JVziHs553L41Hnk0fi+6lHn4WZY22M5xer+IxFXhkSONUN3xLQOGCrHBQ6Wt7cUOinqE8PZ
	xacvaTEq61k8smSvY8woTCPlEmbyf31H+vANjZ5r
X-Received: by 2002:a05:622a:1343:b0:4b5:ee26:5373 with SMTP id d75a77b69052e-4b5f83c8b18mr157023801cf.21.1757446415055;
        Tue, 09 Sep 2025 12:33:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHt6ZFsxR50RVtcwNCWmeGZgkt2Iz2ZbSC15FzqztkMn3bYZzGFWhNgqOHOvkUWFbY7XPZ5nA==
X-Received: by 2002:a05:622a:1343:b0:4b5:ee26:5373 with SMTP id d75a77b69052e-4b5f83c8b18mr157023411cf.21.1757446414556;
        Tue, 09 Sep 2025 12:33:34 -0700 (PDT)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b61bbbc3a3sm12895041cf.24.2025.09.09.12.33.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 12:33:33 -0700 (PDT)
Message-ID: <3d775106-2610-4766-afdb-0820cf92e6c1@redhat.com>
Date: Tue, 9 Sep 2025 15:33:32 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
 Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
 Alex Williamson <alex.williamson@redhat.com>,
 Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
 tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
References: <3-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <3634c854-f63f-4dc0-aa53-0b18c5a7ea1c@redhat.com>
 <20250909121845.GI789684@nvidia.com>
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20250909121845.GI789684@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/9/25 8:18 AM, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 12:14:00AM -0400, Donald Dutile wrote:
> 
>>> -/*
>>> - * Use standard PCI bus topology, isolation features, and DMA alias quirks
>>> - * to find or create an IOMMU group for a device.
>>> - */
>>> -struct iommu_group *pci_device_group(struct device *dev)
>>> +static struct iommu_group *pci_group_alloc_non_isolated(void)
> 
>> Maybe iommu_group_alloc_non_isolated() would be a better name, since that's all it does.
> 
> The way I've organized it makes the bus data a per-bus thing, so
> having pci in the name when setting BUS_DATA_PCI_NON_ISOLATED is
> correct.
> 
> What I did was turn iommu_group_alloc() into
> 
> static struct iommu_group *iommu_group_alloc_data(u32 bus_data)
> 
> Then
> 
> struct iommu_group *iommu_group_alloc(void)
> {
> 	return iommu_group_alloc_data(0);
> }
> 
> And instead of pci_group_alloc_non_isolated() it is just:
> 
> 	return iommu_group_alloc_data(BUS_DATA_PCI_NON_ISOLATED);
> 
> So everything is setup generically if someday another bus would like
> to have its own data.
> 
/my bad, I scanned pci_group_alloc_non_isolated() as calling iommu_group_alloc() & not iommu_group_alloc_data() as you pointed out.
Looks good.

Reviewed-by: Donald Dutile <ddutile@redhat.com>

> Jason
> 


