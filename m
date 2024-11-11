Return-Path: <kvm+bounces-31482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 353289C40B5
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 15:18:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 588D61C2106E
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79AE21A00D2;
	Mon, 11 Nov 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gVteSETP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2071.outbound.protection.outlook.com [40.107.220.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC3419F128
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 14:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731334661; cv=fail; b=qSFCaVAeuhoxakEGPS9BAAlKgELAy6pXCs7zfWUtwb/C4yvyaZaUwCMs6PgtIcJksbe5bYtvcFMWDIkPcgAfBRVQgytWVkZ1J1IPklL+PDeiMhJ2yhFVrrwI16DfRsAMvsqLlRBh7+Qmje94bY2cYdV3y97I2dXlufaLTNNCPIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731334661; c=relaxed/simple;
	bh=ou7tuCGBaXVD7PIZFXIAIuuaLQHI4PYnBbuL/Sw3np0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jQNnIrq6LzEK/ZR0yJnr2BBPUzEIxv5W7nuBLio4LzhLFJDBbnE2qL0pFqqsEZtInabRlpAaCRdh7eVVoZ/uIofxc5P/PNV0uKwpy/s8uJRTS6Xs/PPbJdeDeJUXiGulaCRzQq+TCJekayu5vl1l1wM23+weQvo8v415An27fB4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gVteSETP; arc=fail smtp.client-ip=40.107.220.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MySbYsB0GWDY3BWKsP7DWZhvvwUWV1skK+sfTa+nY8l/6XdZTMuiDxcALsFin7PNBpcublacK8lrbiJIP1BjExSwmg0a5jNADFB5/Sm15RgbGu0FpN8uvHP2K8olx+Fttl6QB8wJgFBpi0EF90ty71eIxW7zutBylJDoZ1APQhjen9tx+jTkrQULQg4ZU1udyT9h01th356sTVX4erO7/RFt+0cvQR2Q63HXd++MXHMqEQXwJL1AEnv6qZAPfkRkeX4Rws0lkwgkW/lfZ5Gn7WTFxkVSuJt6546U6cClAh+7d3HioUOAPiTrmBJJyVrBU9n8I2/UU+o4dwL4Ksi39w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sZ107uoQgiadREaLGIXD9w1SK9Yw5pOe+1DX8LMS8kc=;
 b=YoB2/xE6jY6gG+ljaiwC+wL06/DZopoOl1uGjJeMI8LvWboy7ULPVAeuAIJGeDeFifYEw6AcqBOPTRUv2PVlZXvLqtrVaHb7Ev0DO8V4MHWivd/hKVai5WLCvMac/jqBrbwrnsQKtZh0S4Te0MpDN40Z0gbtUeu6z8RtVX4lJvs8PhbIHn51/twFMVy7rBPN1CmSk0zSvJ6SMh7aDrTeKwvNmT2fkJQu4vykINNv74vTsDkF2jFvRZvm82ZVH6ENmaK0/6wlk0bHvtsJaj/neoiauzJNwmvPf7sGfYqteX1mDCLvpAZmmeZlIkfS9BmTtnCjCSBUX8GPlemsZgACuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZ107uoQgiadREaLGIXD9w1SK9Yw5pOe+1DX8LMS8kc=;
 b=gVteSETP46VwmnI+raqWX/tMZRI6cD3slO992csPmH8va+KmmQ7ijof+450CWSjiaQw1gYog8DwylJmO80Y7s+tXMZC4tl5f2AQ9OMhIKNCVNRFEYPabZGfjdFG/Afjkh722mxchoRXhkQ4Uit+wy2/+CjQ2HoazLuNNIcET3vEdfZrQfn7mKYkUZyJJM6Etj8AM4PUaNqJ4i4OFXhqTd9+M1KiSY/5NhgDxovFTmGAJwjb9rTMaKWXrWFNanS3acmUE0KOZYotaxguRgLVu6TUq2WqkazlSx6vNB7zwYnZ8EZp7ILLNpf2jm27zEVASkBEXhuZ8zCoyaH246zwi6w==
Received: from CY8PR11CA0014.namprd11.prod.outlook.com (2603:10b6:930:48::8)
 by IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Mon, 11 Nov
 2024 14:17:34 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:930:48:cafe::8f) by CY8PR11CA0014.outlook.office365.com
 (2603:10b6:930:48::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29 via Frontend
 Transport; Mon, 11 Nov 2024 14:17:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Mon, 11 Nov 2024 14:17:33 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 06:17:21 -0800
Received: from [172.27.52.206] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 11 Nov
 2024 06:17:18 -0800
Message-ID: <ba487f4f-b8d9-4e42-9aef-300a8ed3648a@nvidia.com>
Date: Mon, 11 Nov 2024 16:17:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 vfio 7/7] vfio/virtio: Enable live migration once
 VIRTIO_PCI was configured
To: Joao Martins <joao.m.martins@oracle.com>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Jason Gunthorpe <jgg@nvidia.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
 <20241104102131.184193-8-yishaih@nvidia.com>
 <20241105162904.34b2114d.alex.williamson@redhat.com>
 <20241106135909.GO458827@nvidia.com>
 <20241106152732.16ac48d3.alex.williamson@redhat.com>
 <af8886fd-ec75-45fa-b627-2cd3c2ce905c@nvidia.com>
 <20241107142554.1c38f347.alex.williamson@redhat.com>
 <4ea48b12-03d0-40df-8c9c-96a78343f8c6@nvidia.com>
 <d2b83eef-4f39-4583-86d8-fc5bf83dd47a@oracle.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <d2b83eef-4f39-4583-86d8-fc5bf83dd47a@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: d1c2d2e0-e6f2-4fcf-218e-08dd025b961e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L21qWDFmWThFREc0Vi9UM1lQUkVJcitmSzNJUHA4ZFRVaGcveGllVm9NZ1hT?=
 =?utf-8?B?ZFgvY1JaNS9TTzF6eTJmeW5mKy9zUVZxTVF5UlBRVTQzUWt4cmNpNk83MnRH?=
 =?utf-8?B?N2M3cFYrRjJnZHZ2V0pDTUVYaFRlUlh2VENZRzRwU3YyUWlkSVVLNWVoUEJN?=
 =?utf-8?B?NlZXRi9GNkZ4OG5sRXRJZ3RrRzVOb2dpWk5lbW9CSm5lY3grNkxpRlN0NlZw?=
 =?utf-8?B?YndNL1ZPQjVPUHFwemx3Y09FSm81RGRVZmNaNVBISW1kZE1zUXNjSDlWalJu?=
 =?utf-8?B?aWR0cXRNNWtKbmRUV3FsV21BS3pBbTFjeUhOSk9BWTVuUGRGcDFDY2VNbWZn?=
 =?utf-8?B?Vm1ZcHlIc3pyamU1UGZ2Y3l3M09rNTZ6S1o3L29YVGVpTy84Wk9ad2pOc2pT?=
 =?utf-8?B?WUtVY0pZeHN3ZUxnUG11SFppZmFLS2M3WDI4U2JDZXVDUmYvM0hXNlRoOGhF?=
 =?utf-8?B?U1h4S1B3Q1F2a3RIMVIraE1wNGRwWitFSTFCQzAzeVg2VTRRSk5UOGw2N2gz?=
 =?utf-8?B?SHN3VndtVGR4cTdXSCtLZm9Cem5sMjdaK0d0T2N6Mm9jaTVuNzJHU2k4YlNT?=
 =?utf-8?B?a2RnR0MybEdOS2djdEN1QWE5QldxME92UW9ESzRQSkdiOTlyemJsZWxmOHNS?=
 =?utf-8?B?YzBtUFFTVWozVWdIT0szelVZWUFTKzUyaHlMUnA4Sy9maGVCTFpQSTFrK1ZL?=
 =?utf-8?B?ZCszM1dFY3BGZUNBTWVlb2xzYWJxNGZJYzJsK3VDamdyanlxa2pGTis1Qk0w?=
 =?utf-8?B?SllxelZMQ3BEUFh3WHFzSjBUQUppNGlScm9ZbFFYVzQvR1Z5SlN5OGNrKzBw?=
 =?utf-8?B?S2FmTFBjcnpLMXZxVW1VejFhQ0o1c3pMSVNkMFRJYjRGWS9ydURqRTNIWjlT?=
 =?utf-8?B?c25tQ3gxSUpnUTRqSFJwSW9mQWM3UjVIaDZFYlMvVGRLb2UxS0krSjl2QlJC?=
 =?utf-8?B?KzIyeDc4L3dHRmxpb0FhTElkVVFVTXRzVmEzWUxQZG12SVdVS0ZsdkswUXo0?=
 =?utf-8?B?VXVPR1Evc1pES0tuck8wNno1S0srQVpPN1R0Z0RNUFF4aEQwNWIzYmhLcC91?=
 =?utf-8?B?WFN5Q1p6YUN0YjhSeUx5OHF3cnV2cllDQXdDTUpVTzR0bElXV0QyZDVKQ3dj?=
 =?utf-8?B?NnV1OERqQTlEMDBMT0s2dzZORXg4ZFQ2OU5DOHdMaHkzRDloRzJGK1oyWmRv?=
 =?utf-8?B?dEYyUEdsWFQ4Qnl1UUQyREdnUUNsTGRTcFFSMjB3M1UramR4QUFaV3VGM295?=
 =?utf-8?B?cGdWWHJ0OU1EODBEN0liWnYrUDU2Uk5VbjhJSDd1a1VTdXdBTG5QcW9LMUZj?=
 =?utf-8?B?UWFnZmwzRG51bm9JTkUwYW04dWRzUmd6WmMxOEpIaFlWY3ZqNHdEUFpvWUdt?=
 =?utf-8?B?eGY3QzNyb2RqVUpmYUdXakhBcEZUd1RJYmZyY25QQkc2aWZCS2kwSEJiRXd4?=
 =?utf-8?B?alRTdzFTZ0FEbnF1SU5LRFV4VFBUMmh2T1o0UHZKb0FuOHVCMHRNT1BnaTR0?=
 =?utf-8?B?ZDAvYlJGVjlHNnl1ci9ibTEvZ1NGR3E0Tk9KYTFCYWZUb2kwamZmdlB5bnJW?=
 =?utf-8?B?QTdXWHh3aWI5OW1rTEZYTUR5L0Yyb2dGMThUMHo3OWlzNTNhTWwrWm4rQ0FK?=
 =?utf-8?B?bnB3cktoSENIYlZMclVGMUJmVmxkWFBtdGhIUHA5eXgvMU1ldTdaRUJKUGN5?=
 =?utf-8?B?c21UQk1hS2hpcDIwRjVIak05Q3J5NTNpb1JWMlNITGYza2FiazNUaWxNd1Bi?=
 =?utf-8?B?ZU9IY1crU3RJUVFUTUZERGI5WGFPcWhYQitXMXl3WDY2Umt3M2FndENuNlZZ?=
 =?utf-8?B?SndPb09mWlYzNGZZWVZkSWtvdDNxekdySzhEWmxHTVdhanNMYXBjZEhlVFpM?=
 =?utf-8?B?cTlJQUwrVXFxRWg1bFFsNUdEQWh6REtXRjkrRTk3RlJCZVE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2024 14:17:33.9221
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1c2d2e0-e6f2-4fcf-218e-08dd025b961e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312

On 11/11/2024 12:32, Joao Martins wrote:
>>>>            depends on VIRTIO_PCI
>>>>            select VFIO_PCI_CORE
>>>>            select IOMMUFD_DRIVER
>>>
>>> IIUC, this is not a dependency, the device will just lack dirty page
>>> tracking with either the type1 backend or when using iommufd when the
>>> IOMMU hardware doesn't have dirty page tracking, therefore all VM
>>> memory is perpetually dirty.  Do I have that right?
>>
>> IOMMUFD_DRIVER is selected to utilize the dirty tracking functionality of IOMMU.
>> Therefore, this is a select option rather than a dependency, similar to how the
>> pds and mlx5 VFIO drivers handle it in their Kconfig files.
>>
> 
> Yishai, I think Alex is right here.
> 
> 'select IOMMUFD_DRIVER' is more for VF dirty trackers where it uses the same
> helpers as IOMMUFD does for dirty tracking. But it's definitely not signaling
> intent for 'IOMMU dirty tracking' but rather 'VF dirty tracking'

I see, please see below.

> 
> If you want to tie in to IOMMU dirty tracking you probably want to do:
> 
> 	'select IOMMUFD'
> 

Looking at the below Kconfig(s) for AMD/INTEL_IOMMU [1], we can see that 
if IOMMUFD is set IOMMFD_DRIVER is selected.

 From that we can assume that to have 'IOMMU dirty tracking' the 
IOMMFD_DRIVER is finally needed/selected, right ?

So you are saying that it's redundant in the vfio/virtio driver as it 
will be selected down the road once needed ?

[1]
https://elixir.bootlin.com/linux/v6.12-rc6/source/drivers/iommu/intel/Kconfig#L17
https://elixir.bootlin.com/linux/v6.12-rc6/source/drivers/iommu/amd/Kconfig#L16

> But that is a big hammer, as you also need the VFIO_DEVICE_CDEV kconfig selected
> as well and probably more.

I agree, we didn't plan to add those dependencies.

> 
> Perhaps best to do like qat/hisilicon drivers and letting the user optionally
> pick it. Migration is anyways disabled when using type1 (unless you force it,
> and it then it does the perpectual dirty trick).

I can drop it in V3 if we all agree that it's not really needed here.

Thanks,
Yishai

