Return-Path: <kvm+bounces-9360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 68A6185F49E
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 10:39:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDC041F25B05
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 09:39:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0730B381C6;
	Thu, 22 Feb 2024 09:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FRXrUPnc"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B4637167;
	Thu, 22 Feb 2024 09:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708594785; cv=fail; b=BjiqqqMlkoQ33OFXIafm2ekPAc6sXBWHBt5HhmuLH7eAp4sO5oax0NjsRoqcWXOvQ7dckqIUUzPwhsrYAnAAfE3f2S9XT6kSmeEGAnbEFQ71vv+EVxmwlWRMCMFnLkGnxxoLj5Qhu5Nii5nSr+pUpwvkF6abmhvUmd7YPfJkZqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708594785; c=relaxed/simple;
	bh=+Yu44aMCOHjWpRfQDwDxhmGx/JopDEso1m08LKL4Nb0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=W22IJkDUI7b1ZWwGUW4UIB2dBZp9yaM6WmcuCvBW8TG1LHfXUZU5d2Uh4ofZ7+7RYiPr0w2Rwh+giyfuUg0Z9tskuQOWxdWWFPUyN/8leIqNVFaFwWB+3SBc3PLrAOzwsPm+kiYM7avKonzcG81c0spOj9XIW5SiZCF2FyFc5H8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FRXrUPnc; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DIXqRXmdaV083xi7JXWRrkOQx4/I+RSDuznRwvZy2CplVRaoz4BMFhmUd6SkMpzD3cAn1iUHI4C/qjodI9d+o2j8Nmg5mwQ3RcbPFbdpGm2ROL2jmdfl8fZY9+OksjLNx/k+O20wRTITYkyn+JShBYLf/kB0gcXzGEJ36jQjxbZnMX/4FTO3+pKA7nAnMqJDjUSg60zn8YbGHfIJmgN7LB2XmfVJJ+6qGKA7PyPASvTVfLvDaytzLuusavYwL/me8tUXdFd2K72cKKdzU879sg3ULvGnzo3qwyuYt/qZYGrIG0zDeaNjmqnybHQCeMQNzYwcMDO2Xjc89iNPBziiXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pmp9ViAJ+//wKDoYDyPjaXGvKuTdWEZZGmqh4uqsizg=;
 b=Kh5e1BFsipf4adz4Ixhe9tDH4MEqgkYd3b0uwYN5uh4OZmCvt+7I4kvpwTH7REP37GVVvXfYwCRCWE1ykMhbTfj1a5/9q8Bj0utYO7q+SUHtXJn8FQI4dEz6s9OGumdqoNTZcHJ06rCAHaqjnYJydDLyhYAVaQxIMc7DXSSjh6rVPnR8LN5w5AkyHb1XjuBrvPBFhDnPExdw0SI6KGKSwHVEfPubAEwWbAquGBwVzjJHLpqrWygTcB+2I0y6SaZPaZmwMAYTJW2GRAuYgydbu2zFzXvRFa3dZ2IbUVbybqt3hvIP86Mi7wBzSnXTreJ5gmWj6qoDw+L8ApdVtPzK+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pmp9ViAJ+//wKDoYDyPjaXGvKuTdWEZZGmqh4uqsizg=;
 b=FRXrUPncOrRqMvINVNmoi7ojY4a2nPGC69bLcGAo4sTGq5Lv+RUzad6iK8gNhicgtmsioENNiHJaWBxpcs5B5dGVNHU2VcVkj99CHDLx7TZ1vaU+OLwdkAuGjA1qQnIcbyq/R/ioHPBcFXVoe8cvlo7JZNoaxfhSV8wrTQs95qcSLogbxATeYwEDqNuAcijbHd/9DKRLR1EBsf1B2IyK6QUiQ6N5pZcplXzDqOCu83hxs+cKeg+oQj78iKNsUIahGnnn+hdge/9hP7U0ld41jKcWvvxYOvXojPKk9mNjWz02U2hys9w5hYndX6hY1M4QuMDW3WzH/y6dl5A+a/55Sg==
Received: from SJ0PR13CA0198.namprd13.prod.outlook.com (2603:10b6:a03:2c3::23)
 by DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.17; Thu, 22 Feb 2024 09:39:40 +0000
Received: from SJ1PEPF00001CE9.namprd03.prod.outlook.com
 (2603:10b6:a03:2c3:cafe::fb) by SJ0PR13CA0198.outlook.office365.com
 (2603:10b6:a03:2c3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14 via Frontend
 Transport; Thu, 22 Feb 2024 09:39:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF00001CE9.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.25 via Frontend Transport; Thu, 22 Feb 2024 09:39:39 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 22 Feb
 2024 01:39:24 -0800
Received: from [172.27.62.150] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.12; Thu, 22 Feb
 2024 01:39:19 -0800
Message-ID: <3296eb65-1ee5-417b-93e0-c5ce595a2dc6@nvidia.com>
Date: Thu, 22 Feb 2024 11:39:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Zeng, Xin" <xin.zeng@intel.com>
CC: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, qat-linux <qat-linux@intel.com>,
	"Cao, Yahui" <yahui.cao@intel.com>
References: <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
 <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
 <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220132459.GM13330@nvidia.com>
 <DM4PR11MB5502BE3CC8BD098584F31E8D88502@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220170315.GO13330@nvidia.com>
 <DM4PR11MB550223E2A68FA6A95970873888572@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240221131856.GS13330@nvidia.com>
 <461b50e9-c539-46c0-96ad-d379da581d8c@nvidia.com>
In-Reply-To: <461b50e9-c539-46c0-96ad-d379da581d8c@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE9:EE_|DM4PR12MB9072:EE_
X-MS-Office365-Filtering-Correlation-Id: 632e8816-f4bf-421a-cefc-08dc338a3104
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9iUapuSiTNOMJmcOi/qxNHECKngbIvGy5gkSchygO4tK2WeuhplXj++ZKBIHyPD5KeOOD3JwFCt6YO+GxClZ0fCdLya4LACEpoJU3OTLSAsNx6RtT06p/eSriXTNRgT75BS2Eghi4pVLuNu1QkvsFY1Ib9M9tmJD2CfnmnPZQfHlTnFY7up/dj/U7o9ai/pBWBSnB9SPZSkIF2yWWG0ZINVyub5a5eF6miYLvsGRR3ppnb2a+w2RaQTh8MY6yR91PnK5Ok0Kt8VwYctD3mkmAvNGFWnuueeDuCGvMfSbnLMqcRZ5/yiDvVhtWz4VvJh7f9EFp9Jn4y6OW8f98wD29lEsY3rVsyAgTzlew075NhmiyKHwdXHK8z0Bioh7AsnJ/xcRTZHgSYpp1N/sxH7SoyvVtGKt5W0FkAzkdfTzzAU+jeX3ugFbYod+wRnDctSv9uIp5EvEyBZWIEnfHestw5qh9T1C/shpp1s9xYeNwJYVuBTQxPCGn+t8pWL44C5gr40IntDe1XaiAo6wxPeyIvfxYtUJZhxiQsBBT0DM16fHbOLstJS9bY/Bqpg5Dg/VFkDM9cBZ0HDB3d2qpdm6FzA4cGWAO6lhUYu0GrVrMfu5JfHItu4+OqaUdDS448XHGMQAnfNgaV+GmWcaHAGJiuvPWULnnumTaIRpvyzH8JWXuNmLIOsYQADOiGcdFykCr42IuSjCtjSPjTT1Kt5VQg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(40470700004)(46966006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2024 09:39:39.8638
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 632e8816-f4bf-421a-cefc-08dc338a3104
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9072

On 21/02/2024 17:11, Yishai Hadas wrote:
> On 21/02/2024 15:18, Jason Gunthorpe wrote:
>> On Wed, Feb 21, 2024 at 08:44:31AM +0000, Zeng, Xin wrote:
>>> On Wednesday, February 21, 2024 1:03 AM, Jason Gunthorpe wrote:
>>>> On Tue, Feb 20, 2024 at 03:53:08PM +0000, Zeng, Xin wrote:
>>>>> On Tuesday, February 20, 2024 9:25 PM, Jason Gunthorpe wrote:
>>>>>> To: Zeng, Xin <xin.zeng@intel.com>
>>>>>> Cc: Yishai Hadas <yishaih@nvidia.com>; herbert@gondor.apana.org.au;
>>>>>> alex.williamson@redhat.com; shameerali.kolothum.thodi@huawei.com;
>>>> Tian,
>>>>>> Kevin <kevin.tian@intel.com>; linux-crypto@vger.kernel.org;
>>>>>> kvm@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cao, Yahui
>>>>>> <yahui.cao@intel.com>
>>>>>> Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel 
>>>>>> QAT VF
>>>> devices
>>>>>>
>>>>>> On Sat, Feb 17, 2024 at 04:20:20PM +0000, Zeng, Xin wrote:
>>>>>>
>>>>>>> Thanks for this information, but this flow is not clear to me why it
>>>>>>> cause deadlock. From this flow, CPU0 is not waiting for any resource
>>>>>>> held by CPU1, so after CPU0 releases mmap_lock, CPU1 can continue
>>>>>>> to run. Am I missing something?
>>>>>>
>>>>>> At some point it was calling copy_to_user() under the state
>>>>>> mutex. These days it doesn't.
>>>>>>
>>>>>> copy_to_user() would nest the mm_lock under the state mutex which is
>>>> a
>>>>>> locking inversion.
>>>>>>
>>>>>> So I wonder if we still have this problem now that the copy_to_user()
>>>>>> is not under the mutex?
>>>>>
>>>>> In protocol v2, we still have the scenario in precopy_ioctl where
>>>> copy_to_user is
>>>>> called under state_mutex.
>>>>
>>>> Why? Does mlx5 do that? It looked Ok to me:
>>>>
>>>>          mlx5vf_state_mutex_unlock(mvdev);
>>>>          if (copy_to_user((void __user *)arg, &info, minsz))
>>>>                  return -EFAULT;
>>>
>>> Indeed, thanks, Jason. BTW, is there any reason why was 
>>> "deferred_reset" mode
>>> still implemented in mlx5 driver given this deadlock condition has 
>>> been avoided
>>> with migration protocol v2 implementation.
>>
>> I do not remember. Yishai?
>>
> 
> Long time passed.., I also don't fully remember whether this was the 
> only potential problem here, maybe Yes.
> 
> My plan is to prepare a cleanup patch for mlx5 and put it into our 
> regression for a while, if all will be good, I may send it for the next 
> kernel cycle.
> 
> By the way, there are other drivers around (i.e. hisi and mtty) that 
> still run copy_to_user() under the state mutex and might hit the problem 
> without the 'deferred_rest', see here[1].
> 
> If we'll reach to the conclusion that the only reason for that mechanism 
> was the copy_to_user() under the state_mutex, those drivers can change 
> their code easily and also send a patch to cleanup the 'deferred_reset'.
> 
> [1] 
> https://elixir.bootlin.com/linux/v6.8-rc5/source/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c#L808
> [2] 
> https://elixir.bootlin.com/linux/v6.8-rc5/source/samples/vfio-mdev/mtty.c#L878
> 
> Yishai
> 

 From an extra code review around, it looks as we still need the 
'deferred_reset' flow in mlx5.

For example, we call copy_from_user() as part of 
mlx5vf_resume_read_header() which is called by mlx5vf_resume_write() 
under the state mutex.

So, no change is expected in mlx5.

Yishai

