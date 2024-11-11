Return-Path: <kvm+bounces-31411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EFA729C399B
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 09:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AFA5F28256C
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FE315D5C3;
	Mon, 11 Nov 2024 08:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MOUzJuNK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2088.outbound.protection.outlook.com [40.107.95.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE4213E02E
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 08:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731313359; cv=fail; b=ZgOoQ09Fak5wfvjlqlCXCgmYf6J/bsaqrHyYZ9C82ouiSf6SIabj2F5hAkj8WRCyED5vFuckc44AYjJyGX42mLMgcElgAqjfQIlGFPfjeAlVQkb6nIUNqGepjCK2atZ53k3zip3mAjlWe74ZM7W+wjyQPTrQ4vXQO9P35K6+te0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731313359; c=relaxed/simple;
	bh=ueor/dStl/VAfFRis4ZveePU9yUvgQDfoOQ9ARoLN0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=JOUlRmWFlvGANK0f2ZlZ3jo6EqWIQIiV8w866vpJ4Ox2gQDPCucc9+AaZo63Ko2S1gHSIeHLiZ89Jguhe/OXPBXB/GFCZLx4FGT+HgcU1UXciTAMo+BhvRB4am4rNBkE5p19e0aDRQM/gs8a9j/hXXRbWjVPlmvce+RtR1MTND8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MOUzJuNK; arc=fail smtp.client-ip=40.107.95.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQbULRw/AvMGN1lBCN3vHuqmNz9491TKRedqRmp5/GFkxQ6yhsnz8pFa7h2Y98chBEu3UWwcSmBxrjU5qREdfPlnEqe6S5SBPSPVko0MLRPLF4FdsPOs3xMuUc0Evq15bFaasNmxVf6+rBckPs/WmDJRhHf8J0n7c3lIHHM9xwTI9TvF1dTfVVxV8YhOMi0zRT7cJ3xQAYZJ5vDYaEarpG/xMP5CMe9ANxdx/+qr4PSRjM2Sg6/TbbIrge9p+DhEfk7NQq8neTB2H994JL4VGCCGWaRLAwYaBiDDN+2XvLHESbDtAMl9RIEJon2cLRigZezlx42U7TyQ9Hg2YZdZLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=usZH6Lk4uwvy/iWpkoqYvx1m53ahPhaY/3rgUuXYsW4=;
 b=l/0sceTcR0rAKSY0O5Unr9PV5Va4C6uu37JGhfxuglmQDL+wOseiK/0MmzF++nFSbbDy5VAioXwxtfUicDcxv1g/RQDWJl/6Eo1jXP7iy3E9AiNcgdAFRmFvrRg8AblOkIEdVaO2C4Eh2VtOXUWBr2qbLxJi3BcuV6Jh++Ba9ePf5r1V8LrYcYeOykpRpd1OKamTqpnuypH/Uizx6gweO9y869bqO4ifsW2KRtdGo/Iy5tSQB19X09I2hih5/y61QWOMZz7kXdpb6eN1Dc0sEK8DnXoCbEbmmZsYbHTdIGnKwDSEgNofgyudV7CO78U95ScvSYyzPrBcOvQFB+ih+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=usZH6Lk4uwvy/iWpkoqYvx1m53ahPhaY/3rgUuXYsW4=;
 b=MOUzJuNKo9Bvo6F5S95rtp8wvMZQ8XemOTwkfz3U8a++Tati7H40US4AKVaLm0KN1+on1SQ+lSY++oV3FIF0oXoaXkkN8yUay04jAsaxOh6qjmAZZijXBZ9NfHGyy/LOQSp8EUx0KsFZQSpN8djTz0/2u0V4wlRH1ulsOaU/pO4l6nmJbY9Tju44lma9JjK5bSg5L9MKiFFUO769VXJcEQSs7czmTRSowWy3m/+WlkWjPtG1L6wCFV8Ajfn6AznBXZrCv6lYJhmIKgMe9bNulvi7u5O3mWkyHDTvySjFlX2UNPDMt9238pMXe6XbhNq5Dqc2CpursfqEVOQJ18GV7Q==
Received: from SA1PR05CA0023.namprd05.prod.outlook.com (2603:10b6:806:2d2::17)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 08:22:32 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:806:2d2:cafe::af) by SA1PR05CA0023.outlook.office365.com
 (2603:10b6:806:2d2::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.12 via Frontend
 Transport; Mon, 11 Nov 2024 08:22:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 08:22:31 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:22:16 -0800
Received: from [172.27.52.206] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 00:22:12 -0800
Message-ID: <4ea48b12-03d0-40df-8c9c-96a78343f8c6@nvidia.com>
Date: Mon, 11 Nov 2024 10:22:09 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
 <20241104102131.184193-8-yishaih@nvidia.com>
 <20241105162904.34b2114d.alex.williamson@redhat.com>
 <20241106135909.GO458827@nvidia.com>
 <20241106152732.16ac48d3.alex.williamson@redhat.com>
 <af8886fd-ec75-45fa-b627-2cd3c2ce905c@nvidia.com>
 <20241107142554.1c38f347.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241107142554.1c38f347.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|DM6PR12MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: 29ae1894-780b-4bb4-add7-08dd0229fd14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUZaTG9mVFlNTWd1TlFTRG05SHkzM0NucS9ONnMwUU56WXM3TDRXbUhMeHFp?=
 =?utf-8?B?OE1hamtiYWVWUGtSTkN0bG40a2JFRFVRd3haS2pYMmI5SlJiNVc0QlloNmlH?=
 =?utf-8?B?VXRqWC9XK0RvTzltUXBpYktQbXNFTkVtekRmMld6eHBCeHB5VWY4dlZCbVJk?=
 =?utf-8?B?eFBLY054U2xoRkt1MUNYUzRjaUVlSVZrN09raHY1RTRhWGMrZjNzVjJONXVW?=
 =?utf-8?B?UDJOTjhHTnp6SXdZKzBBN1JaRjJOb0hVY3l4MlNPSlgwRW5CZEtoVUdCU1pn?=
 =?utf-8?B?NU0rQkpRM3pSTGZ2WmVDYWpXbkxXR3ZlZm5wYngrOVdTUTFJdUVLazBiRmdu?=
 =?utf-8?B?c2dmeXVDTEVXa3VFRkI3NWp6T2QxRWFJeWZNSzBtbFY4aVIvRk5ZYjZ5R1B3?=
 =?utf-8?B?QTF6L1krZURTZ3dOQStvdFVoRVo1QWozMFcxRjZDNi9xM3l4YTZYMEpUUGpB?=
 =?utf-8?B?U2JTMGFlSlFxc2NMVnlYTHgrOVhhb2lBQWxiUmpncTUxdkRzL1NQOGNsWlNQ?=
 =?utf-8?B?M3AxWUVDbXVUOUZiUzA1cC9hNm0yZklhbFh5d1QzWDVkajJ6VVVKSWQvSDlL?=
 =?utf-8?B?enpCTFR1REFHRXl1blYvSTk1L0FORzdyQTgxd3hESXppeStsbkd5cTYydEdR?=
 =?utf-8?B?RnU2L2tPblpLR3gxUlVmTi9BcitLdStPblV2QThKd0VGVU52WmdPa1AvdWtl?=
 =?utf-8?B?RzZpeEw1UWtwenpqdHZwbncxVnVKR3B5aHpiMXBVRC9LWnNSSDc4QThCSXZr?=
 =?utf-8?B?WGJIVWgvUUY4SHFKWHNxOVgzbUt0Q3hSUlFJMmhZNTBzSkIxdTdMdWo4Y0tu?=
 =?utf-8?B?NzNRcHlzMW5wNFFyeHlhUmRDeUdZRFFsV1lkdjI2WkhvbGRkMTJ4VG56U1Vy?=
 =?utf-8?B?dHZjMThNNnhtSGsxN3R6VGx3Uy9MczBtZm80VGwwcFNBVUN0NmZIT1ZydURW?=
 =?utf-8?B?VnlLRzkyaHFmU2ZDUk5kZzdHN214QzlzU1c0L2thT0MwZTJUREhsakFTZUNs?=
 =?utf-8?B?b1NucnJlTUYvaFJkYmpBb0hGdUp3UW5kNzhRUlE2cmZaeVpWek5ua1RFMHEw?=
 =?utf-8?B?aklYWTVIR0JDREYzTlp5czY3ZjgxR1BqL3dLYS9DWkRqM1c5YVhoUnZIRWky?=
 =?utf-8?B?NUpHNTJ2ZXIzajM4QUFpVlIzd2pOUFg4bHBvNzBxZ3kzcTlrZ2pGaHFDbzVh?=
 =?utf-8?B?d0pocEhPQ0VaeFg1Q3hXTFg2VmdXOEZvbU45aTJNYXMyUjFwYjQrM2xWalpN?=
 =?utf-8?B?SDVSbWVhUGRjWjAydmJJNE5VVkZtYkg3bnJ0OUY2RUNnVldFMUpNOHE5a0px?=
 =?utf-8?B?MC9oUGJBNjFyT21hZ2xMNlZhUWJoelo2RVl1a1czSkVnN1pyYmVlZTlacWVG?=
 =?utf-8?B?Ky9PbDBpbnkrSWMzY0tEU2lpU3R0M1lPQkhWQWd4UkxwYjErSTJHdDFQSG00?=
 =?utf-8?B?TnpxUVh4Z0J1VVRPaE13ZWlFaGtncFNVZDBneHE2YU1BZ1A0dG9OKzhYZTRY?=
 =?utf-8?B?dU11Z0ZQWE52dk5sSjBlTXZ5ZXMwcFZIM01PbWd2dGtkNmtkQzBXTGlyeloz?=
 =?utf-8?B?aXhvQWdvZEtqcExKSEsxaUVoaVcvemFHeVBrV1Y2S3VZamJPQ3hxRWN6Sklx?=
 =?utf-8?B?MGVqRHorcnpyR1ZTbUpmNnVDREVjNmlFay9lWGxhMEU0bEVVRHNMSjE5RFZ4?=
 =?utf-8?B?d2xoNWRUVjFCYkJHWG92cTNJd2w5UWNQYW9WeHA3bUxZNlZTeW5taW50ZDRi?=
 =?utf-8?B?RGdtbHdWRXVYNlphblVtaE5rSlF1eW1kamVZVDVtRWZaNC83eWd6UU91QUd6?=
 =?utf-8?B?d2pPWFZmZnBJbWRFZlFtcDRxMFVPY2R5empiUkM3NE5yVHpmU1A4eTNvWklL?=
 =?utf-8?B?MVlFVDFaaDkrcXh1NG15RFd3YVhpQW9FOGZqSnFiQURBSUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 08:22:31.7821
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ae1894-780b-4bb4-add7-08dd0229fd14
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267

On 07/11/2024 23:25, Alex Williamson wrote:
> On Thu, 7 Nov 2024 14:57:39 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> On 07/11/2024 0:27, Alex Williamson wrote:
>>> On Wed, 6 Nov 2024 09:59:09 -0400
>>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>>    
>>>> On Tue, Nov 05, 2024 at 04:29:04PM -0700, Alex Williamson wrote:
>>>>>> @@ -1,7 +1,7 @@
>>>>>>    # SPDX-License-Identifier: GPL-2.0-only
>>>>>>    config VIRTIO_VFIO_PCI
>>>>>>            tristate "VFIO support for VIRTIO NET PCI devices"
>>>>>> -        depends on VIRTIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
>>>>>> +        depends on VIRTIO_PCI
>>>>>>            select VFIO_PCI_CORE
>>>>>>            help
>>>>>>              This provides support for exposing VIRTIO NET VF devices which support
>>>>>> @@ -11,5 +11,7 @@ config VIRTIO_VFIO_PCI
>>>>>>              As of that this driver emulates I/O BAR in software to let a VF be
>>>>>>              seen as a transitional device by its users and let it work with
>>>>>>              a legacy driver.
>>>>>> +          In addition, it provides migration support for VIRTIO NET VF devices
>>>>>> +          using the VFIO framework.
>>>>>
>>>>> The first half of this now describes something that may or may not be
>>>>> enabled by this config option and the additional help text for
>>>>> migration is vague enough relative to PF requirements to get user
>>>>> reports that the driver doesn't work as intended.
>>>>
>>>> Yes, I think the help should be clearer
>>>>   
>>>>> For the former, maybe we still want a separate config item that's
>>>>> optionally enabled if VIRTIO_VFIO_PCI && VFIO_PCI_ADMIN_LEGACY.
>>>>
>>>> If we are going to add a bunch of  #ifdefs/etc for ADMIN_LEGACY we
>>>> may as well just use VIRTIO_PCI_ADMIN_LEGACY directly and not
>>>> introduce another kconfig for it?
>>>
>>> I think that's what Yishai is proposing, but as we're adding a whole
>>> new feature to the driver I'm concerned how the person configuring the
>>> kernel knows which features from the description might be available in
>>> the resulting driver.
>>>
>>> We could maybe solve that with a completely re-written help text that
>>> describes the legacy feature as X86-only and migration as a separate
>>> architecture independent feature, but people aren't great at reading
>>> and part of the audience is going to see "X86" in their peripheral
>>> vision and disable it, and maybe even complain that the text was
>>> presented to them.
>>>
>>> OR, we can just add an optional sub-config bool that makes it easier to
>>> describe the (new) main feature of the driver as supporting live
>>> migration (on supported hardware) and the sub-config option as
>>> providing legacy support (on supported hardware), and that sub-config
>>> is only presented on X86, ie. ADMIN_LEGACY.
>>>
>>> Ultimately the code already needs to support #ifdefs for the latter and
>>> I think it's more user friendly and versatile to have the separate
>>> config option.
>>>
>>> NB. The sub-config should be default on for upgrade compatibility.
>>>    
>>>> Is there any reason to compile out the migration support for virtio?
>>>> No other drivers were doing this?
>>>
>>> No other vfio-pci variant driver provides multiple, independent
>>> features, so for instance to compile out migration support from the
>>> vfio-pci-mlx5 driver is to simply disable the driver altogether.
>>>    
>>>> kconfig combinations are painful, it woudl be nice to not make too
>>>> many..
>>>
>>> I'm not arguing for a legacy-only, non-migration version (please speak
>>> up if someone wants that).  The code already needs to support the
>>> #ifdefs and I think reflecting that in a sub-config option helps
>>> clarify what the driver is providing and conveniently makes it possible
>>> to have a driver with exactly the same feature set across archs, if
>>> desired.  Thanks,
>>>    
>>
>> Since the live migration functionality is not architecture-dependent
>> (unlike legacy access, which requires X86) and is likely to be the
>> primary use of the driver, I would suggest keeping it outside of any
>> #ifdef directives, as initially introduced in V1.
>>
>> To address the description issue and provide control for customers who
>> may need the legacy access functionality, we could introduce a bool
>> configuration option as a submenu under the driver’s main live migration
>> feature.
>>
>> This approach will keep things simple and align with the typical use
>> case of the driver.
>>
>> Something like the below [1] can do the job for that.
>>
>> Alex,
>> Can that work for you ?
>>
>> By the way, you have suggested calling the config entry
>> VFIO_PCI_ADMIN_LEGACY, don't we need to add here also the VIRTIO as a
>> prefix ? (i.e. VIRTIO_VFIO_PCI_ADMIN_LEGACY)
> 
> I think that was just a typo referring to VIRTIO_PCI_ADMIN_LEGACY.
> Yes, appending _ADMIN_LEGACY to the main config option is fine.
> 
>> [1]
>> # SPDX-License-Identifier: GPL-2.0-only
>>
>> config VIRTIO_VFIO_PCI
>>           tristate "VFIO support for live migration over VIRTIO NET PCI
>>                     devices"
> 
> Looking at other variant drivers, I think this should just be:
> 
> 	"VFIO support for VIRTIO NET PCI VF devices"
> 
>>           depends on VIRTIO_PCI
>>           select VFIO_PCI_CORE
>>           select IOMMUFD_DRIVER
> 
> IIUC, this is not a dependency, the device will just lack dirty page
> tracking with either the type1 backend or when using iommufd when the
> IOMMU hardware doesn't have dirty page tracking, therefore all VM
> memory is perpetually dirty.  Do I have that right?

IOMMUFD_DRIVER is selected to utilize the dirty tracking functionality 
of IOMMU. Therefore, this is a select option rather than a dependency, 
similar to how the pds and mlx5 VFIO drivers handle it in their Kconfig 
files.

> 
>>           help
>>             This provides migration support for VIRTIO NET PCI VF devices
>>             using the VFIO framework.
> 
> This is still too open ended for me, there is specific PF support
> required in the device to make this work.  Maybe...
> 
> 	This provides migration support for VIRTIO NET PCI VF devices
> 	using the VFIO framework.  Migration support requires the
> 	SR-IOV PF device to support specific VIRTIO extensions,
> 	otherwise this driver provides no additional functionality
> 	beyond vfio-pci.
> 
> 	Migration support in this driver relies on dirty page tracking
> 	provided by the IOMMU hardware and exposed through IOMMUFD, any
> 	other use cases are dis-recommended.
> 
>>             If you don't know what to do here, say N.

Looks good.

>>
>> config VFIO_PCI_ADMIN_LEGACY
> 
> VIRTIO_VFIO_PCI_ADMIN_LEGACY
> 
>>           bool "VFIO support for legacy I/O access for VIRTIO NET PCI
>>                 devices"
> 
> Maybe:
> 
> 	"Legacy I/O support for VIRTIO NET PCI VF devices"
> 
>>           depends on VIRTIO_VFIO_PCI && VIRTIO_PCI_ADMIN_LEGACY
>>           default y
>>           help
>>             This provides support for exposing VIRTIO NET VF devices which
>>             support legacy IO access, using the VFIO framework that can
>>             work with a legacy virtio driver in the guest.
>>             Based on PCIe spec, VFs do not support I/O Space.
>>             As of that this driver emulates I/O BAR in software to let a
>>             VF be seen as a transitional device by its users and let it
>>             work with a legacy driver.
> 
> Maybe:
> 
> 	This extends the virtio-vfio-pci driver to support legacy I/O
> 	access, allowing use of legacy virtio drivers with VIRTIO NET
> 	PCI VF devices.  Legacy I/O support requires the SR-IOV PF
> 	device to support and enable specific VIRTIO extensions,
> 	otherwise this driver provides no additional functionality
> 	beyond vfio-pci.
> 

Looks good.

> IMO, noting the PF requirement in each is important (feel free to
> elaborate on specific VIRTIO extension requirements).  It doesn't seem
> necessary to explain how the legacy compatibility works, only that this
> driver makes the VF compatible with the legacy driver.
> 
> Are both of these options configurable at the PF in either firmware or
> software? 

These options are configured in the firmware.

  I used "support and enable" in the legacy section assuming
> that there is such a knob, but for migration it seems less necessary
> that there's an enable step.  Please correct based on the actual
> device behavior.  Thanks,
> 

Migration is such a basic functionality that we may expect it to be 
enabled by default, so your suggestion seems reasonable. Let’s proceed 
with it.


Thanks,
Yishai

