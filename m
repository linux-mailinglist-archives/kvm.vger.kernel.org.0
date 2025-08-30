Return-Path: <kvm+bounces-56387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA32CB3C9AC
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 11:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D1EAA605AE
	for <lists+kvm@lfdr.de>; Sat, 30 Aug 2025 09:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F23C9258ED8;
	Sat, 30 Aug 2025 09:13:15 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C392FEEDE;
	Sat, 30 Aug 2025 09:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756545195; cv=none; b=pOJFtVzoFJHSxyH2DAVzK9fFhNrUeJ2zFivx+nYIIgKbfgAKw6wRl6u5XuDHhtViqzYlWSVNJvBiFCBqgBtDwsME1JSMd2kE4NA7n4Fsi2dWgEA4l6S8jdzh6J5torC0nnP+oML2k14m5ghP27oGX04j21+UVejJwdw1Fz896go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756545195; c=relaxed/simple;
	bh=0f+HBDJOsdpBtZ0u2LFEqmnMIrAsbkYqSQU7CblwEd8=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=njXyvFWiolYBJH0vRFtgod0tOi/n7cYPjybYOk6XuRyHbQMGJtJSgvl9C8zFir4F+tju1VYIywBfciuTVbYqB3YxCDnfTxfweuqsJgoEQ2xipFXoFRoa7WTBMvvx/RE/a7fK+Qxg1wQ19M5XwUdUkWUadvRnhVXNyoQ/zBAtCyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cDTpp6xMYz13N9H;
	Sat, 30 Aug 2025 17:09:22 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 2292B1400E3;
	Sat, 30 Aug 2025 17:13:09 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 30 Aug 2025 17:13:08 +0800
Subject: Re: [PATCH v8 3/3] hisi_acc_vfio_pci: adapt to new migration
 configuration
To: Alex Williamson <alex.williamson@redhat.com>, Shameer Kolothum
	<shameerkolothum@gmail.com>
CC: <jgg@nvidia.com>, <jonathan.cameron@huawei.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>
References: <20250820072435.2854502-1-liulongfang@huawei.com>
 <20250820072435.2854502-4-liulongfang@huawei.com>
 <20250821120112.3e9599a4.alex.williamson@redhat.com>
 <f3617d78-e75e-378b-ad0f-4aa6c8ed61b9@huawei.com>
 <723cd569-b194-4876-9aea-d0bdd6861810@gmail.com>
 <20250822081258.27bc71da.alex.williamson@redhat.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <6f383882-b358-b578-faa9-8312289e61ee@huawei.com>
Date: Sat, 30 Aug 2025 17:13:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250822081258.27bc71da.alex.williamson@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2025/8/22 22:12, Alex Williamson wrote:
> On Fri, 22 Aug 2025 08:03:39 +0100
> Shameer Kolothum <shameerkolothum@gmail.com> wrote:
> 
>> On 22/08/2025 03:44, liulongfang wrote:
>>> On 2025/8/22 2:01, Alex Williamson wrote:  
>>>> On Wed, 20 Aug 2025 15:24:35 +0800
>>>> Longfang Liu <liulongfang@huawei.com> wrote:
>>>>> +enum hw_drv_mode {
>>>>> +	HW_V3_COMPAT = 0,
>>>>> +	HW_V4_NEW,
>>>>> +};  
>>>>
>>>> You might consider whether these names are going to make sense in the
>>>> future if there a V5 and beyond, and why V3 hardware is going to use a
>>>> "compat" name when that's it's native operating mode.
>>>>  
>>>
>>> If future versions such as V5 or higher emerge, we can still handle them by
>>> simply updating the version number.
>>> The use of "compat" naming is intended to ensure that newer hardware versions
>>> remain compatible with older drivers.
>>> For simplicity, we could alternatively rename them directly to HW_ACC_V3, HW_ACC_V4,
>>> HW_ACC_V5, etc.
>>>   
>>>> But also, patch 1/ is deciding whether to expose the full BAR based on
>>>> the hardware version and here we choose whether to use the VF or PF
>>>> control registers based on the hardware version and whether the new
>>>> hardware feature is enabled.  Doesn't that leave V4 hardware exposing
>>>> the full BAR regardless of whether the PF driver has disabled the
>>>> migration registers within the BAR?  Thanks,
>>>>  
>>>
>>> Regarding V4 hardware: the migration registers within the PF's BAR are
>>> accessible only by the host driver, just like other registers in the BAR.
>>> When the VF's live migration configuration registers are enabled, the driver
>>> can see the full BAR configuration space of the PF.However, at this point,
>>> the PF's live migration configuration registers become read/write ineffective.
>>> In other words, on V4 hardware, the VF's configuration domain and the PF's
>>> configuration domain are mutually exclusive—only one of them is ever read/write
>>> valid at any given time.  
>>
>> Sorry it is still not clear to me. My understanding was on V4 hardware,
>> the VF's live migration config register will be inactive only when you
>> set the PF's QM_MIG_REGION_SEL to QM_MIG_REGION_EN.
>>
>> So, I think the question is whether you need to check the PF's
>> QM_MIG_REGION_SEL has set to  QM_MIG_REGION_EN, in patch 1 before
>> exposing the full VF BAR region or not. If yes, you need to reorganise
>> the patch 1. Currently patch 1 only checks the hardware version to
>> decide that.
> 
> This, and also is there any migration compatibility between V3 hardware
> and V4 hardware in compat mode?  Changing the BAR size is a fundamental
> hardware difference that would preclude that unless something like QEMU
> masks the true BAR size to the guest.  Thanks,
>

This difference will not affect migration compatibility. For our device migration,
we only need to ensure that the device can be restored correctly after migration.
Although the BAR size may differ depending on the device configuration, the data
required to restore the device and ensure its normal operation remains consistent.

Thanks.
Longfang.


> Alex
> 
> 
> .
> 

