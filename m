Return-Path: <kvm+bounces-31113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E3009C06BE
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 14:06:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DE409B23067
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 13:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 922E32161E6;
	Thu,  7 Nov 2024 12:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I0QP9jJ7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2056.outbound.protection.outlook.com [40.107.94.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16E3216E02
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 12:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730984285; cv=fail; b=gyYceXMw9EILSWN1U29ykMqkSrJZFit/1+sgOnFRIQSIOMF7nEfnAsqB3MUZyhqV1WIidCHpSapEFl2BlmoPnSuJWhA1UdB0Kp6DJpLGQrMCVoVyDg0DlUuh1PZ95kPkwlUAq6Hqcj5NwPXkF1I9bdjumVelq1d/FWP0JI/jgoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730984285; c=relaxed/simple;
	bh=4d09x73HjXSjU0/HwhPlAqEJIZ2VOUg82aAgG1aIfmM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cOS/KTCdqhan64jJBGxXt/F35rhizKZwyiz/TLig1ia2pQfzenv1ujgiKSaNQyCxDoprR8UySdVjxqy6Cwy2Yrga5aKCGr0e6Xu6H0iR9nBnu32Y/NqsCzymoI/Zj++kgUCVxRYlJJQPC5KD5w8Eod5UCP7jHK+PyHxpZiXNIHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I0QP9jJ7; arc=fail smtp.client-ip=40.107.94.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pVVqmZKJOocTAjZNEkYIxVTA2UEIeibO+miRU+t0vm2SpW19HoXDstiA9WuaThPtJgYkLSBvxbKQ34pp3dmmLNkVFA9GvzDUFrMc2eujc/yEwPPtyblZQGFDa9OTUSJW22EjPrddWuPwSLM6eDPuzi7rGiPcEsrGFAKJu+qbaismmN6XJRVo9tbX/66/alIem9skxWhjX0CHaLHM1fWsHiTjwXUlzmC6tQS7K0DnaBSK1d/r3NMJ9TpkSKhVV0+bAS1vZpa05DL+J43CgvDBePPJU3EL4SosrIGsdH8z9HyrLhV+eXtIPNu665V0lG90RMaOUMk+Nho9V4CvpmgOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9w61m9sSISWTnNtK8D2sqDjDgyAXPWX8zewwQuEZpU8=;
 b=GsrY1ce9zdIwiMF5WAx0CRncQgzU+iC7NNJAR6TWRoijVm2ryTwYMzxk3neJxR34pX/RGLtYfB1depbvcYCLuw8J+5tkEEqC0a9qObvSOa2Wn9lGDXMixHzJKMa1E8A/AU3AOIitfSm/RrxELd9oZd4WKPt0N1ayvwtOpyH3U1xks26DxcpkyhGQ/2fPHYh3IBKyAChatyMwl4LHRUKl4wzrbcROneW9XJesktrwXImkC5vZsOmxtntYdCVba0RKuDnz+paUWEr3rFpI8G3nWViUqt5WyaTml+gU3iK5zkDwo1zu1qkyY4A9SoZHe0eT3GEQaxYqrRfFFXEqYi90RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9w61m9sSISWTnNtK8D2sqDjDgyAXPWX8zewwQuEZpU8=;
 b=I0QP9jJ7O1qiK5dl8p8iMIQw90DNpb5whq5Gg0nKOzjtGeNhOuj+seX0yocvNX6Ay8QKmLdMFOKkLJZOmEz3+mY85QOXn9tGVhwvqAwSpeI3g+Q0Ud0EbHwe/C3RFicoDi3B6SMWdP/0wKuPLxPqqYuzGgtk/MlveK76Zd26Dr2I0QZnj0EmNgrtbnogFBYwaKBCMNploSYH5Hv0eWbpbZKlp+WIrqmzRVhBOeBmylRSMVeJ4UFTeH+UuSfx+hGUMyHp2fQvUcxEUmtvxl+dCyjQxXGiakNWNDp1HdvxLpFV8qTSSRh2r+zAwr1DVAfp6fDZwmd6PZPo7KlZI0W17Q==
Received: from DS7PR05CA0099.namprd05.prod.outlook.com (2603:10b6:8:56::20) by
 MN2PR12MB4405.namprd12.prod.outlook.com (2603:10b6:208:26d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.21; Thu, 7 Nov
 2024 12:57:59 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:8:56:cafe::77) by DS7PR05CA0099.outlook.office365.com
 (2603:10b6:8:56::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.10 via Frontend
 Transport; Thu, 7 Nov 2024 12:57:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Thu, 7 Nov 2024 12:57:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 04:57:47 -0800
Received: from [172.27.34.156] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 7 Nov 2024
 04:57:43 -0800
Message-ID: <af8886fd-ec75-45fa-b627-2cd3c2ce905c@nvidia.com>
Date: Thu, 7 Nov 2024 14:57:39 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
To: Alex Williamson <alex.williamson@redhat.com>, Jason Gunthorpe
	<jgg@nvidia.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
 <20241104102131.184193-8-yishaih@nvidia.com>
 <20241105162904.34b2114d.alex.williamson@redhat.com>
 <20241106135909.GO458827@nvidia.com>
 <20241106152732.16ac48d3.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241106152732.16ac48d3.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|MN2PR12MB4405:EE_
X-MS-Office365-Filtering-Correlation-Id: 11e5b591-5561-4a67-4716-08dcff2bce94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dlhiOXRiWlhmV3VyRllOUjZsZ2lIeGY3UXc0M2xxdFlsMXFiYmhWdyt5amNL?=
 =?utf-8?B?dVUyc2FCN29kdjdmZTlsc1JjZWM3VHNjdFp0SXUyMTBSd1hLTnA5U2c3Tm1P?=
 =?utf-8?B?MnZXZFZ5Ykd0eWwrdXJuQ1YwZ0kxSXkvTlRlY05Nd0w5dEdHQ3JkV1ZPU2tR?=
 =?utf-8?B?dDUzc0FxeXVnZE9DNTMvYUpQem9OZ3ZYY2NEVCtHWnpGZHUwUXpScVhtTTd3?=
 =?utf-8?B?a1grd1NXQXJ0UXRuTmYxOEtCYzlMenFsOEg2YlBjYk40ZUhMYjFFTDRadlN0?=
 =?utf-8?B?dVZLZDRoTk9ieWhNSkc2b1FSb2pydW5TcWNvdHo5UDc0WG1TbnIrMnRwemtv?=
 =?utf-8?B?bmgzcHBpUGNMNDZuZ01FdlBqWUJRQWVCcEUxUFRMbHJHY0UxWEtkMGFVaUEx?=
 =?utf-8?B?R3AzMit0NWg1Mm1YbCtZNHE0VVJBVkhyck9IS0lCTVhnRk9aYXN6aUIwRUtT?=
 =?utf-8?B?RVA4d0hEam9tL3lxbnRMeDlKMFp0aWd1S0lqc0xnQ3FES1JHRkFSakt0RVpM?=
 =?utf-8?B?R1JZaFFRTnpUaFIxektHVE42YVB0b21GTVNlT2NGNFU1c01LUGI2QWJQTTR6?=
 =?utf-8?B?amRjWis1ZFBPUXdjaVdRSVF2Y2ttTHZ3cUthREZkd3E1ejJmTzI2Z29oOWRF?=
 =?utf-8?B?MDdhZUtaMUV4bnNmclFrMVpjZ0pGMS9NdXQrcDVmdVRUbjNqdVBRZFQ0S1h4?=
 =?utf-8?B?OURVRHB1TjlqUnBxVTdiVndhS0dzeSt1ZFY5TVg5MFZRNEp6OVJoL29lYXFi?=
 =?utf-8?B?RFNNenZlRGFmaDhQVDlFVUxzRFh3RjhzNzZ5UEhYOFIzUlNGQ3hmdGtlZ0x6?=
 =?utf-8?B?VWdkOWxpaGx4TklFY0w5QXJ4Y29kNGF1UGpmUE5pRk81RFNsTjcxVnZaVkRk?=
 =?utf-8?B?TEJyeEtCY2xKM0g2dTVONzk4V0dWVWk0dk94N2d2OEJ0TDdlQkZvR1pta3FI?=
 =?utf-8?B?TVp1UzQxcnh1OEIwczBmSEMyODBoQVNJZzNzWjJhV1VHWTNTSkgxMnY1SXYw?=
 =?utf-8?B?MHk2TnUrLzQ1L1FSZ3hwdERjY1E1U2JKcmdqZE5TVDRqVW5MYjBUZGFVUHg5?=
 =?utf-8?B?Y0dUU3RsKzJnTU85M0xFUE1wYk9SVGRHMHB4cXV4RVlOQ1o4b2xuOUFPM3Rw?=
 =?utf-8?B?bUN6blNuSXJENkRyS3FlTmR4WWFoaWJHdXRoTFFJOHlGOFBkS2VPcEhlc212?=
 =?utf-8?B?ZUJUVk5YVlg4TkFyOXpZdGxKMG9oaERmQ1dRVmNtYkZJSHk1dGxCTUoyYmpm?=
 =?utf-8?B?L1kwUkNmZTlKNEU4Qlk2Q3Q0KzIwblZIWmp5ZG1POW5wVWd2WVdGQkt6Q2pI?=
 =?utf-8?B?QXF6a296ckJsNFBMYjhBNlZpY0VrbHpGUGVrNXBuTndvU0tEbEVJa2RYYlZo?=
 =?utf-8?B?ODJwSzFmVjBGamU0amRGa3RzaUMzQWtRTjZpMFRUR2JTK2ZkZStUZTNyYnoy?=
 =?utf-8?B?TFgrZG5TL0N6azNQYkFyQjNBVHhMMzYyd2xZUFZTdnM0c2owdnBtSzlYaXlP?=
 =?utf-8?B?V3lLczNmVHFyU05vTXNIWGtVaExlT043cGZyQkNsdHZLRnFUdFNNejZhdVVK?=
 =?utf-8?B?WVl2MWxJbHU4ZVp0dkpkK0VoQ3JRdG1BSzYzd0dyNVhmUFBiMSs0bXpBWENv?=
 =?utf-8?B?U1Y0YWJ4aTJJYU9LZ2Jwcnc1RUw2OWNTYnd4Q3ZXaGlKR041YW4vZkdGcUZi?=
 =?utf-8?B?Vm5JMnM0S3NWQXh0ejFjQk9ocVMwUFRUUUUxbVQ3UHlpaDVpZ1ZaU2lqU3o3?=
 =?utf-8?B?MnJlTFVOVFA5cDN1K1pqWG5QdkNRemdnaVowMTNoK2IvaXdOMjRXdU9xR3c2?=
 =?utf-8?B?a1V0RkxsRDVEeitBRDdmR1A5eDJ2Ulh1NWtnNW9xR0dUZ1MwNyt0T2dGWTZX?=
 =?utf-8?B?M2hvazNiY2JKSUhyL2xlVHd5eTBQdE1uZjl3d2R4alRlOWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 12:57:59.2705
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11e5b591-5561-4a67-4716-08dcff2bce94
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4405

On 07/11/2024 0:27, Alex Williamson wrote:
> On Wed, 6 Nov 2024 09:59:09 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
>> On Tue, Nov 05, 2024 at 04:29:04PM -0700, Alex Williamson wrote:
>>>> @@ -1,7 +1,7 @@
>>>>   # SPDX-License-Identifier: GPL-2.0-only
>>>>   config VIRTIO_VFIO_PCI
>>>>           tristate "VFIO support for VIRTIO NET PCI devices"
>>>> -        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
>>>> +        depends on VIRTIO_PCI
>>>>           select VFIO_PCI_CORE
>>>>           help
>>>>             This provides support for exposing VIRTIO NET VF devices which support
>>>> @@ -11,5 +11,7 @@ config VIRTIO_VFIO_PCI
>>>>             As of that this driver emulates I/O BAR in software to let a VF be
>>>>             seen as a transitional device by its users and let it work with
>>>>             a legacy driver.
>>>> +          In addition, it provides migration support for VIRTIO NET VF devices
>>>> +          using the VFIO framework.
>>>
>>> The first half of this now describes something that may or may not be
>>> enabled by this config option and the additional help text for
>>> migration is vague enough relative to PF requirements to get user
>>> reports that the driver doesn't work as intended.
>>
>> Yes, I think the help should be clearer
>>
>>> For the former, maybe we still want a separate config item that's
>>> optionally enabled if VIRTIO_VFIO_PCI && VFIO_PCI_ADMIN_LEGACY.
>>
>> If we are going to add a bunch of  #ifdefs/etc for ADMIN_LEGACY we
>> may as well just use VIRTIO_PCI_ADMIN_LEGACY directly and not
>> introduce another kconfig for it?
> 
> I think that's what Yishai is proposing, but as we're adding a whole
> new feature to the driver I'm concerned how the person configuring the
> kernel knows which features from the description might be available in
> the resulting driver.
> 
> We could maybe solve that with a completely re-written help text that
> describes the legacy feature as X86-only and migration as a separate
> architecture independent feature, but people aren't great at reading
> and part of the audience is going to see "X86" in their peripheral
> vision and disable it, and maybe even complain that the text was
> presented to them.
> 
> OR, we can just add an optional sub-config bool that makes it easier to
> describe the (new) main feature of the driver as supporting live
> migration (on supported hardware) and the sub-config option as
> providing legacy support (on supported hardware), and that sub-config
> is only presented on X86, ie. ADMIN_LEGACY.
> 
> Ultimately the code already needs to support #ifdefs for the latter and
> I think it's more user friendly and versatile to have the separate
> config option.
> 
> NB. The sub-config should be default on for upgrade compatibility.
> 
>> Is there any reason to compile out the migration support for virtio?
>> No other drivers were doing this?
> 
> No other vfio-pci variant driver provides multiple, independent
> features, so for instance to compile out migration support from the
> vfio-pci-mlx5 driver is to simply disable the driver altogether.
> 
>> kconfig combinations are painful, it woudl be nice to not make too
>> many..
> 
> I'm not arguing for a legacy-only, non-migration version (please speak
> up if someone wants that).  The code already needs to support the
> #ifdefs and I think reflecting that in a sub-config option helps
> clarify what the driver is providing and conveniently makes it possible
> to have a driver with exactly the same feature set across archs, if
> desired.  Thanks,
> 

Since the live migration functionality is not architecture-dependent 
(unlike legacy access, which requires X86) and is likely to be the 
primary use of the driver, I would suggest keeping it outside of any 
#ifdef directives, as initially introduced in V1.

To address the description issue and provide control for customers who 
may need the legacy access functionality, we could introduce a bool 
configuration option as a submenu under the driver’s main live migration 
feature.

This approach will keep things simple and align with the typical use 
case of the driver.

Something like the below [1] can do the job for that.

Alex,
Can that work for you ?

By the way, you have suggested calling the config entry 
VFIO_PCI_ADMIN_LEGACY, don't we need to add here also the VIRTIO as a 
prefix ? (i.e. VIRTIO_VFIO_PCI_ADMIN_LEGACY)

[1]
# SPDX-License-Identifier: GPL-2.0-only

config VIRTIO_VFIO_PCI
         tristate "VFIO support for live migration over VIRTIO NET PCI
                   devices"
         depends on VIRTIO_PCI
         select VFIO_PCI_CORE
         select IOMMUFD_DRIVER
         help
           This provides migration support for VIRTIO NET PCI VF devices
           using the VFIO framework.

           If you don't know what to do here, say N.

config VFIO_PCI_ADMIN_LEGACY
         bool "VFIO support for legacy I/O access for VIRTIO NET PCI
               devices"
         depends on VIRTIO_VFIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
         default y
         help
           This provides support for exposing VIRTIO NET VF devices which
           support legacy IO access, using the VFIO framework that can
           work with a legacy virtio driver in the guest.
           Based on PCIe spec, VFs do not support I/O Space.
           As of that this driver emulates I/O BAR in software to let a
           VF be seen as a transitional device by its users and let it
           work with a legacy driver.

           If you don't know what to do here, say N.

Yishai

