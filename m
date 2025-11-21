Return-Path: <kvm+bounces-64254-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E52ACC7BB29
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 21:58:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E4563A6FC9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:58:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC2B52FFDC4;
	Fri, 21 Nov 2025 20:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PODgdyLq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tr/8dx4Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD7F2E8B8B
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 20:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763758709; cv=none; b=Iq+pbBYC4seCyxgqSBWuwXoNgQai30CLoHNKbu2B8IjSug0ptu5bNkt4eYgoxCCQ0QXK37w7ENl+R+WKvBFwFggiS7bsHKtgqp/P0fliROZeWLamkKpsqa4C0ZaPS82JyHlW4AoscC7pRn8s12XAZEJdVBk9EdKsyQEDp+BCOTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763758709; c=relaxed/simple;
	bh=06oXEfhjprUqiQB5deP8QG66ZL/M1lhD7+55HTheX04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Il0VPJAyvGvq/p6I4ilNBUUSXVicV8l/XBQO9A+IFYcPoJvN4UPJq1KnPnfLe1vMrrFDR5pwc5+n9JKoA5mpx2ayX95smSQpZvUSmVitHlQO58EAqDPLhVawOUTha2cGqceSvOlajppChijlp6eHMFTClySnAI7jS1KrKPNQ4eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PODgdyLq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tr/8dx4Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763758706;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e88HhueZj89DvDALxZLu6Aq2WQkVf8WGiqxl2400ceE=;
	b=PODgdyLqj/sWDV59KB7KUs7id/+4Tryh/4wMjMR8xrymBqmi5vTMSKK7IeiUcTr8ZVDZB8
	Sk8vRhqIa72vS8m8voBUeyDjpAoEt/3C3DC5ytYu/UpmYZCsTe2rp+my6t47a90ntDOQHT
	9xXTz5EIzcso6uMTBWbVFsowUCRyVwU=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-bf-WI-VGO9WCMPrCFsU6Tg-1; Fri, 21 Nov 2025 15:58:25 -0500
X-MC-Unique: bf-WI-VGO9WCMPrCFsU6Tg-1
X-Mimecast-MFC-AGG-ID: bf-WI-VGO9WCMPrCFsU6Tg_1763758705
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-89ee646359cso724671085a.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 12:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763758705; x=1764363505; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e88HhueZj89DvDALxZLu6Aq2WQkVf8WGiqxl2400ceE=;
        b=Tr/8dx4ZEx4i7rTR7eOLeBbWhE4h3do7z0Fy4zAkg2xuO4tyNPBSo7GB1gjiOzDsPD
         u64oahVPBwvbLDh3qtjVKKK5LUr/+P99nXuaodGhfdIJe/8PrQJ32+HVOPJgX6tTCWSs
         sBYMZ7pbvFMUcRwe7PwoHlkrd8dCQUDfvUK5gOZdFEgXGvko0WyHaHsc0gTdLobjf5rc
         AOUGYFeIFq2ogvdC+nw+g5QkMf3JTzeJmYN4ArwBplX1c1jauOYVeURy9ekiBZvl5SBp
         n+CY/vZSTWX5WqCCmsbCQxBadSUGBGNq3+4/+w7HPDSQzaQ2QZZ9PTRoH5BDkgKXDUDA
         rZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763758705; x=1764363505;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e88HhueZj89DvDALxZLu6Aq2WQkVf8WGiqxl2400ceE=;
        b=ozpsZ/OZDNPklpmDazBEV5JWVFzVp9teSHTHo2lpcjOXqSJfGPCMMUr97KpnwLZiWQ
         gE1rKY8wt8XeYhLY6ZfRMDMyJ0ogL3k/tZYFgubzjdOr2pVyMg4NoXkW/Aa3zz+0jOAY
         AXbvgLDRCtZvvfZnNRwLudwcH43KVdooXVm9EzIQVgDvirt8a1jWhPvMzWdI+aIVXT0f
         pzkwbuNkcrtCc8hVkbovJ57il3HQDJQ/p6/wOP8HzvTpzCNAvbZpWRgi4+UWhVBxKPWK
         L/bn+iYAdaWYrFgJC8FAwYbWxhmcKgXKlXFsNzUqgHA5IpE64sxiXhoQ2rYF6HfaaoK/
         3J3A==
X-Forwarded-Encrypted: i=1; AJvYcCVXWX6BqKv9B+/P94JJ35+ejrsFkqYfa/B+9A5Bx3ts51K/yr4sXm6Iz7+2zoFU11Y1HE4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8+W8FBb+KR5vuMF4Sy7mPau3hCDxaGR/YSLYNHV8pJM6/rbCI
	2av7mLnfv+eICyR6OOzBx5rhSjdjgviawYX4CVXK96oLUdXHmM50MnIr1ngQlnJYJH8oT6bkHB6
	LxCbYt7txgT2SbyUNaESx9JBUHplEil0r9JN5uIF8kWsmn00TEl61YQ==
X-Gm-Gg: ASbGncsfugtW59loCqMPT8gM1b6OmlLZGigKaYP4Ur9HNtIQ6LtHXTYsEUAK/7Yn9rY
	jV/Kksnh/AeWFMsjYDs0DKgw1YIGRbIj7fLYq82jFHT1jfi/evXcS7FTEFvetdb5cOp66y9kiyn
	FaEGtaz9P5GQFVoZl9FlFQP7ucLcrx6RI91mmiegRHvnseEVP5K01y2cqMl7q2mdnJp9lLJxXws
	v5ZGvNdtm/i63kLg7ZSyVgY2i9hHOe5AtbKJOO2nE0XwO8suL3WONCXuBZnfTipl7h6h+A28lw9
	l6n8e6ScRsfsFgHQME5ZvQyHTgCJizOUme782+jHijchMd08INTuGjkpgqHD1ZG4TgR40HjE4+o
	wBAb1uwFSyQ==
X-Received: by 2002:a05:620a:414b:b0:8a3:9bb4:9e4f with SMTP id af79cd13be357-8b33d1fe5e1mr463784885a.30.1763758704709;
        Fri, 21 Nov 2025 12:58:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGhfkyzY52YJ2bXpl0xvrpFvW8lduyG4EKof39hTidPOL/dpJFOpP6aOif1GUzrwgXScGO24A==
X-Received: by 2002:a05:620a:414b:b0:8a3:9bb4:9e4f with SMTP id af79cd13be357-8b33d1fe5e1mr463780785a.30.1763758704275;
        Fri, 21 Nov 2025 12:58:24 -0800 (PST)
Received: from [192.168.40.164] ([70.105.235.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295e4b96sm437647485a.45.2025.11.21.12.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 12:58:23 -0800 (PST)
Message-ID: <9b25494c-0271-4469-a7f4-71876eadd4e3@redhat.com>
Date: Fri, 21 Nov 2025 15:58:19 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/7] vfio: move barmap to a separate function and
 export
To: Alex Williamson <alex@shazbot.org>, ankita@nvidia.com
Cc: jgg@ziepe.ca, yishaih@nvidia.com, skolothumtho@nvidia.com,
 kevin.tian@intel.com, aniketa@nvidia.com, vsethi@nvidia.com,
 mochs@nvidia.com, Yunxiang.Li@amd.com, yi.l.liu@intel.com,
 zhangdongdong@eswincomputing.com, avihaih@nvidia.com, bhelgaas@google.com,
 peterx@redhat.com, pstanner@redhat.com, apopple@nvidia.com,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, cjia@nvidia.com,
 kwankhede@nvidia.com, targupta@nvidia.com, zhiw@nvidia.com, danw@nvidia.com,
 dnigam@nvidia.com, kjaju@nvidia.com
References: <20251121141141.3175-1-ankita@nvidia.com>
 <20251121141141.3175-6-ankita@nvidia.com>
 <20251121093949.54f647a6.alex@shazbot.org>
Content-Language: en-US
From: Donald Dutile <ddutile@redhat.com>
In-Reply-To: <20251121093949.54f647a6.alex@shazbot.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/25 11:39 AM, Alex Williamson wrote:
> On Fri, 21 Nov 2025 14:11:39 +0000
> <ankita@nvidia.com> wrote:
> 
>> From: Ankit Agrawal <ankita@nvidia.com>
>>
>> Move the code to map the BAR to a separate function.
>>
>> This would be reused by the nvgrace-gpu module.
>>
>> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_core.c | 38 ++++++++++++++++++++++----------
>>   include/linux/vfio_pci_core.h    |  1 +
>>   2 files changed, 27 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
>> index 29dcf78905a6..d1ff1c0aa727 100644
>> --- a/drivers/vfio/pci/vfio_pci_core.c
>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>> @@ -1717,6 +1717,29 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
>>   #endif
>>   };
>>   
>> +int vfio_pci_core_barmap(struct vfio_pci_core_device *vdev, unsigned int index)
>> +{
>> +	struct pci_dev *pdev = vdev->pdev;
>> +	int ret;
>> +
>> +	if (vdev->barmap[index])
>> +		return 0;
>> +
>> +	ret = pci_request_selected_regions(pdev,
>> +					   1 << index, "vfio-pci");
>> +	if (ret)
>> +		return ret;
>> +
>> +	vdev->barmap[index] = pci_iomap(pdev, index, 0);
>> +	if (!vdev->barmap[index]) {
>> +		pci_release_selected_regions(pdev, 1 << index);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_pci_core_barmap);
> 
> Looks a lot like vfio_pci_core_setup_barmap() ;)
> 
> Thanks,
> Alex
> 
+1 ... and below ...
> 
>> +
>>   int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
>>   {
>>   	struct vfio_pci_core_device *vdev =
>> @@ -1761,18 +1784,9 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>>   	 * Even though we don't make use of the barmap for the mmap,
>>   	 * we need to request the region and the barmap tracks that.
>>   	 */
>> -	if (!vdev->barmap[index]) {
>> -		ret = pci_request_selected_regions(pdev,
>> -						   1 << index, "vfio-pci");
>> -		if (ret)
>> -			return ret;
>> -
>> -		vdev->barmap[index] = pci_iomap(pdev, index, 0);
>> -		if (!vdev->barmap[index]) {
>> -			pci_release_selected_regions(pdev, 1 << index);
>> -			return -ENOMEM;
>> -		}
>> -	}
>> +	ret = vfio_pci_core_barmap(vdev, index);
>> +	if (ret)
>> +		return ret;
>>   
so, vfio_pci_core_mmap() should be calling vfio_pci_core_setup_barmap() vs. what it does above currently?

--Don

>>   	vma->vm_private_data = vdev;
>>   	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index a097a66485b4..75f04d613e0c 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -121,6 +121,7 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
>>   		size_t count, loff_t *ppos);
>>   vm_fault_t vfio_pci_map_pfn(struct vm_fault *vmf, unsigned long pfn,
>>   			    unsigned int order);
>> +int vfio_pci_core_barmap(struct vfio_pci_core_device *vdev, unsigned int index);
>>   int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
>>   void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
>>   int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
> 
> 


