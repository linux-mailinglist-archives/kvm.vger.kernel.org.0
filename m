Return-Path: <kvm+bounces-72558-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLMsLCMqp2nSfAAAu9opvQ
	(envelope-from <kvm+bounces-72558-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:36:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1071F5608
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 19:36:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5FDFF30247EE
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 18:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8E89421A12;
	Tue,  3 Mar 2026 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BFn1FTwV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE613C278D
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 18:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772562961; cv=none; b=m7F0hetlmpOXwkANi7i+Vb80Qn5e0Zje1Ok9VJwy6bYWFEPUmsAMeIIOI/DvJlvxD9Lm69xc3v4iv0OwdxrlqDlJRlixDbQ4s2eriE7XKAbrRcZtO6jyp7NBAmnynx57r4+7r5RYfJpe1CYlyMU3qWgTZw71kxnHX40mgXOOVds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772562961; c=relaxed/simple;
	bh=wcbTJ+dxtc43pshEWpYW4YZDVIGTHhabXjI58Bwu58I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i2Zs5qydyhPUJK981g7aobGHkKozMzEPOEPy3bQa56FK6WSj27z4D+5Sl/xHAwTU2LV5NKvSs7mlczsCMpTc9IEA1qtkAmJSidms1DG0Wr4C4mZwmpJTVPQHdWhfMGGDKGLkBxQxKkmnEv0+kimc24CJmZzT1DLReDORiNdK8cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BFn1FTwV; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ae49120e97so91475ad.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 10:35:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772562959; x=1773167759; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=trHHJ83pdpjgNSAR80l6JTOyQ+mJmW3s5tLBspjTXe4=;
        b=BFn1FTwVZnxFxqdNhle/XW7GVpahNuTG+cI6vMEMP4nB1Su8Xg5HIhqdLjjGPgnU9g
         ywgSAZa6U/Vk5aHkaVmXR8qt7wJRLzYH4zDKsJ5Rn60R7BUEknEEW1IoVGwy8BpXuaVl
         RUG8PngNexu1N84sIrX6IVwFNlwGZAddlnfKfKqKJ00a6Fr068jPiQVN83h1q8On0KnH
         WAB5QAGOaeMSkEYPTjYnRMiIERZJR461M8AblFWSSnObsebNu6rHC9UuAGvi6f5bdcd1
         +3PVYN8fulhVWO+akbQ2gHtlE9A/CeG0Y5By+SIbTu/Qzg2GkKjm6LQ0DtZxSUHzYeEi
         SZqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772562959; x=1773167759;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=trHHJ83pdpjgNSAR80l6JTOyQ+mJmW3s5tLBspjTXe4=;
        b=FQGfAMCH7x0xJ9xw38BRn6/MCIJzsSvZ0tUUAM2XsK17N9Z8RatynpXXwFDeDqTqmJ
         Jo8XSnCqh5i89SxoiGbu+/Iubdt1uTc4zpj9/ZidOYAKgp5Q1AG4/A1/+UQnFaFOLbYS
         cqheZN56Dplo8vgrZF7tKFOf39J+zW4CCGhfJPNg5zH+nzlTwHr85cOzAfDwsuyzLw1i
         bq2zxWHeg09aO/sooxGwwbS5BXTGyqUrH9VgLNNwqNfUAwyryMcNbeN4ccPEOWdXynsb
         8wL4wVnGVfmrnsMgWeokhr3pvACXHZYKt0gI3/Vu827uBEwSQHv5xPzGSfc6c0s45EkK
         Q0QA==
X-Forwarded-Encrypted: i=1; AJvYcCUumomMdoPX4Cyv0/3qCOsvdoqn4M2cBvuUUnlIED7Atga51Zn/AeSAqw+0zNU51CxG27o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxf9YzimpyGnubLXTUk8L3AxyogzzHIbGXL0dJjazN4JxO5he/5
	ejOhmF+IWpdJghgbgJ37aTDTid/UaR8GGDVfOWHf0ICcjZ+3CD/fsgMcURtTAnPoAA==
X-Gm-Gg: ATEYQzwplV50x6Gn+Si3BQZKRVZacfoKafBZ5FvOLZ1SQWEAgO5gDhLWwhD3M9us74i
	VhrMcDT70GNf6xvtH8WnYdggXbNqTg/36vAxb77SHU4HZQm2lwIxTht1vQRUfwsOz6PFeU8755X
	f9Luxl0HGEGBxXmwTCafjr+BfmgywC+GD9rNoTJ0HeX+jLf4k1350acWB1IO0NrrORZ0D1zqJiy
	uvSh14wA0rzknDx/D5LNjjhCr3Q8KUO7YdXWKuC+JR9O3hn3QTlZbsPaU+lNdGcBMKMOSphrDoU
	N4cds/lF8WVtQM4JmNzPFQNRbnZeSCgUh5HVu/YIiFEBH9zixF7SXjJdWVtsYbqE5NjI31C662D
	3U7vGzOduCfoFjmXDTcoH1BZ+VKMuA3ep2wQgJd916Sqbrh1IF3uj+ERL9v+1qvdIWodOyyLpie
	XzowCUuveVEs5dsKRebbG4Fua9G9u7ZCEtdlyV7fg8LlG1t/M19t90QuuLTSJHow==
X-Received: by 2002:a17:902:f712:b0:2ae:4f95:df55 with SMTP id d9443c01a7336-2ae4f95e48dmr4767015ad.25.1772562958685;
        Tue, 03 Mar 2026 10:35:58 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae5229cd5esm80423705ad.21.2026.03.03.10.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 10:35:58 -0800 (PST)
Date: Tue, 3 Mar 2026 18:35:54 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Ankit Soni <Ankit.Soni@amd.com>
Cc: David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>, 
	Shuah Khan <shuah@kernel.org>, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Parav Pandit <parav@nvidia.com>, 
	Leon Romanovsky <leonro@nvidia.com>, William Tu <witu@nvidia.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Pranjal Shrivastava <praan@google.com>, 
	Vipin Sharma <vipinsh@google.com>, YiFei Zhu <zhuyifei@google.com>
Subject: Re: [PATCH 13/14] vfio/pci: Preserve the iommufd state of the vfio
 cdev
Message-ID: <mxemy34aaxtwly3ugve5kfy5is3dsgnnrmjzvrmnxq2nvhcmgw@ghnjvhgdodth>
References: <20260203220948.2176157-1-skhawaja@google.com>
 <20260203220948.2176157-14-skhawaja@google.com>
 <idfs4bm5tib5nfe7i6rrm7hxsvhybbidfxtxl4jx3pamkisdon@zaljkqd66cwq>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <idfs4bm5tib5nfe7i6rrm7hxsvhybbidfxtxl4jx3pamkisdon@zaljkqd66cwq>
X-Rspamd-Queue-Id: 3B1071F5608
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72558-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[skhawaja@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 04:18:08AM +0000, Ankit Soni wrote:
>On Tue, Feb 03, 2026 at 10:09:47PM +0000, Samiullah Khawaja wrote:
>> If the vfio cdev is attached to an iommufd, preserve the state of the
>> attached iommufd also. Basically preserve the iommu state of the device
>> and also the attached domain. The token returned by the preservation API
>> will be used to restore/rebind to the iommufd state after liveupdate.
>>
>> Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
>> ---
>>  drivers/vfio/pci/vfio_pci_liveupdate.c | 28 +++++++++++++++++++++++++-
>>  include/linux/kho/abi/vfio_pci.h       | 10 +++++++++
>>  2 files changed, 37 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
>> index c52d6bdb455f..af6fbfb7a65c 100644
>> --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
>> +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
>> @@ -15,6 +15,7 @@
>>  #include <linux/liveupdate.h>
>>  #include <linux/errno.h>
>>  #include <linux/vfio.h>
>> +#include <linux/iommufd.h>
>>
>>  #include "vfio_pci_priv.h"
>>
>> @@ -39,6 +40,7 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>>  	struct vfio_pci_core_device_ser *ser;
>>  	struct vfio_pci_core_device *vdev;
>>  	struct pci_dev *pdev;
>> +	u64 token = 0;
>>
>>  	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>>  	pdev = vdev->pdev;
>> @@ -49,15 +51,32 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>>  	if (vfio_pci_is_intel_display(pdev))
>>  		return -EINVAL;
>>
>> +#if CONFIG_IOMMU_LIVEUPDATE
>> +	/* If iommufd is attached, preserve the underlying domain */
>> +	if (device->iommufd_attached) {
>> +		int err = iommufd_device_preserve(args->session,
>> +						  device->iommufd_device,
>> +						  &token);
>> +		if (err < 0)
>> +			return err;
>> +	}
>> +#endif
>> +
>>  	ser = kho_alloc_preserve(sizeof(*ser));
>> -	if (IS_ERR(ser))
>> +	if (IS_ERR(ser)) {
>> +		if (device->iommufd_attached)
>> +			iommufd_device_unpreserve(args->session,
>> +						  device->iommufd_device, token);
>> +
>
>To use iommufd_device_preserve()/iommufd_device_unpreserve(),
>looks like the IOMMUFD namespace import is missing here —  MODULE_IMPORT_NS("IOMMUFD");
>
>-Ankit

Agreed, I will add it to this file in v2.
>
>>  		return PTR_ERR(ser);
>> +	}
>>
>>  	pci_liveupdate_outgoing_preserve(pdev);
>>
>>  	ser->bdf = pci_dev_id(pdev);
>>  	ser->domain = pci_domain_nr(pdev->bus);
>>  	ser->reset_works = vdev->reset_works;
>> +	ser->iommufd_ser.token = token;
>>
>>  	args->serialized_data = virt_to_phys(ser);
>>  	return 0;
>> @@ -66,6 +85,13 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
>>  static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
>>  {
>>  	struct vfio_device *device = vfio_device_from_file(args->file);
>> +	struct vfio_pci_core_device_ser *ser;
>> +
>> +	ser = phys_to_virt(args->serialized_data);
>> +	if (device->iommufd_attached)
>> +		iommufd_device_unpreserve(args->session,
>> +					  device->iommufd_device,
>> +					  ser->iommufd_ser.token);
>>
>>  	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
>>  	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>> diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
>> index 6c3d3c6dfc09..d01bd58711c2 100644
>> --- a/include/linux/kho/abi/vfio_pci.h
>> +++ b/include/linux/kho/abi/vfio_pci.h
>> @@ -28,6 +28,15 @@
>>
>>  #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
>>
>> +/**
>> + * struct vfio_iommufd_ser - Serialized state of the attached iommufd.
>> + *
>> + * @token: The token of the bound iommufd state.
>> + */
>> +struct vfio_iommufd_ser {
>> +	u32 token;
>> +} __packed;
>> +
>>  /**
>>   * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
>>   * device.
>> @@ -40,6 +49,7 @@ struct vfio_pci_core_device_ser {
>>  	u16 bdf;
>>  	u16 domain;
>>  	u8 reset_works;
>> +	struct vfio_iommufd_ser iommufd_ser;
>>  } __packed;
>>
>>  #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
>> --
>> 2.53.0.rc2.204.g2597b5adb4-goog
>>

Thanks for looking at this.

Sami

