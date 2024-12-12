Return-Path: <kvm+bounces-33540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B0C89EDD49
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 03:04:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0DEA8283840
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 02:04:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 291CE13B59B;
	Thu, 12 Dec 2024 02:04:17 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D874013632B;
	Thu, 12 Dec 2024 02:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733969056; cv=none; b=YXYuviz9OpSXolJl8a1faOAjfv/sXUsfKWP2oA8Fet/oCwCq4wVQuHR73pBrB9yTbPs8H2W4jQPI6Q/MxgFbvJW254WgZSaUde8/lOSEj9pD28N6i4rgkmIQ8gkALTIDPGSXOgsIxqI6ZjTvFZJF2MnMp0fgt5pb0gpSsJNm9SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733969056; c=relaxed/simple;
	bh=1sjkvJsY2w7QUnIlrDRiVOJt0A/CLP+VGSt76sZx2j0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=a2F9VsahfuQCBwtwV12qqj23qy/NBT/z0YuoEdCrG19qo2fpRw7ahnVJ9Cqcky7gDmJlW7Okj4mGnFivk3hgLnmrzXnANI7uEKjWIUYomRSnvZBYce4Q7VdQGx+tdUZY/UjnZRCyrc9BDJ/m4oh4gL0RtO/01hx8GFD8aoeAhhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y7wgr5Z1fz1kvs7;
	Thu, 12 Dec 2024 10:01:44 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 38A4A1A016C;
	Thu, 12 Dec 2024 10:04:11 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 12 Dec 2024 10:04:10 +0800
Received: from [10.67.121.110] (10.67.121.110) by
 kwepemn100017.china.huawei.com (7.202.194.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 12 Dec 2024 10:04:10 +0800
Subject: Re: [PATCH 5/5] hisi_acc_vfio_pci: bugfix live migration function
 without VF device driver
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: <alex.williamson@redhat.com>, <shameerali.kolothum.thodi@huawei.com>,
	<jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20241206093312.57588-1-liulongfang@huawei.com>
 <20241206093312.57588-6-liulongfang@huawei.com>
 <20241209135119.GB1888283@ziepe.ca>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <f35c7425-3990-97b7-09c7-065b11ef5eec@huawei.com>
Date: Thu, 12 Dec 2024 10:04:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241209135119.GB1888283@ziepe.ca>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemn100017.china.huawei.com (7.202.194.122)

On 2024/12/9 21:51, Jason Gunthorpe wrote:
> On Fri, Dec 06, 2024 at 05:33:12PM +0800, Longfang Liu wrote:
>> If the driver of the VF device is not loaded in the Guest OS,
>> then perform device data migration. The migrated data address will
>> be NULL.
>> The live migration recovery operation on the destination side will
>> access a null address value, which will cause access errors.
>>
>> Therefore, live migration of VMs without added VF device drivers
>> does not require device data migration.
>> In addition, when the queue address data obtained by the destination
>> is empty, device queue recovery processing will not be performed.
> 
> This seems very strange, why can't you migrate over the null DMA addr?
> Shouldn't this be fixed on the receiving side?
>

There are two parts to the process here:
First: If the source does not add the device driver in the Guest VM.
Then except the dma address is empty, other device parameters are also
empty data. Therefore, there is no need to migrate this data of the device.

Second: If the source adds the driver in the VM, but the received DMA
address is empty due to data reading or migration process. This kind of
empty address needs to be processed at the destination and cannot be
written to the device.

Thanks,
Longfang.

> Jason
> .
> 

