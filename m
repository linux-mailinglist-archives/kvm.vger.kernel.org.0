Return-Path: <kvm+bounces-47136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEFD3ABDD3D
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 16:35:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8BF2A4C81FD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 14:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC7419ABB6;
	Tue, 20 May 2025 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TW12Ynjf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C041824728B
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 14:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750421; cv=fail; b=AErAGsVJQjbj07CVmDEOJpnrOvG6PjAMPi7uiIe2bIAIEo4XgW1iNw+9nokyTDhFkxZPEMKJJpC5q9ISRCcQG91ghmkSUzhsSMp2oHTKC/8+qHpL6j45EU/Ku4WXMXRdUmaU1SHS186OkDopVRXSrVWGu+DbTqniM7xR+U3UyZE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750421; c=relaxed/simple;
	bh=+mfazPi0VMhpc4CQTN1e4N3skczLQFKj1QO/gAc9HN0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sdwLsm1fdODvi+GLtLc/GDw5YSUWlKiraz03pyTZFzKYrf0IKwOf8LrXqpeD8GX9mHR9u7DIQxu0bodH892TgI4lYUcLJ1JrOzZRV2SOT0yMt3mZvPdYHBIoNWCDEoRgrU0iGvWuqkfEP2EN8ubqCxn3zGiq0pnhKEXECSXzuWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TW12Ynjf; arc=fail smtp.client-ip=40.107.244.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofjDHqvzYn8K/olz45OSPtGGQcukcsQbhoKPpQLnvlg9HDRWqtDdGVVQNGnxFqCEMwwi1Xd1jM4Iah1Budq3wnUXW2L2QRl78TLFQONkIGFUb2PoID7zRwgb9fMn0nOl9oUQh3tUtnWL5vsFr5xNzVHqbjomgeXmyQEBXI44sk/uPU+QokgtY9kTLD3YKicWvfhGvr7OgwpHAzABNfH2jv/kMrjQ+G6YKXdN6hf4eqT5C7idaTTCtrdqyKL2f54BW8CJzSy8axszJMLZQb8toQoQrCRD7KIqjNJO94pWTnq17bxNs6pBZjypFo7WvKH1BoIJ2z2AD4JWCzMeJg92Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tQBRjZEoMrS0yTjv8uXOF3Axg9JcjYl/+H9sJDcecaw=;
 b=ASlu+xBWr1bZhmx6dpZ422smqYakpiWlY7+hQz2PnjdexYO2eSuwXGfu99W0W3mscyqgwfVc+Ngm0P2sx/tdeMGzaa8eKR7MMc/+wmuRYb8gkIjz/n6Qah5K/CLLH3gZF/6BrnJ68Rmk7QnWil8uVJM4uykYL64n1KsUItVfyFfJRUVaMyvXZaEx1XuXgAluMoe/FTVzofdyKEki+R9KWDo0Ye5xHn662ucfZ5VK8GFF6Cc21ea1u8evPVxpCiXcrZiqH7wgcmZJp7mDDuos1xxqMKVXKwervbOfXWF812ELfc1o1/w/PV3DFi6h+cY/BVFdVK1le9ahUUucqmF1rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tQBRjZEoMrS0yTjv8uXOF3Axg9JcjYl/+H9sJDcecaw=;
 b=TW12YnjfSyxwvTsU/ntSunXzr0sDbEpgohvI28O0Ht/BgoBvbi3D5Wepg6s0MJaQxPUScljE7wSFAp+azTPESCxSsYZF8cISDOlW4K3CadMmOPsdahgpFEWHH3Ai6yaH+/xmFlw6Kg4+2U71XfcCc4vO6SuTLZU5EBvYE/krmA8wVvYMuQP60k3emx4RgrOQpOtFAygimoejnNYwCOswufewYDmiwl4WZZKdSEUwD7ERVPtnHrw9G6LjDYjTxyN6Rsn8vzfiga887asQon+joke7BavoFRUcIneexTt2dwGKgGOmvBR0/fzO2/ESUFOODcT8KCxEh9BVB5S9sxXXGw==
Received: from SA0PR11CA0116.namprd11.prod.outlook.com (2603:10b6:806:d1::31)
 by LV2PR12MB5750.namprd12.prod.outlook.com (2603:10b6:408:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.32; Tue, 20 May
 2025 14:13:33 +0000
Received: from SA2PEPF00003F65.namprd04.prod.outlook.com
 (2603:10b6:806:d1:cafe::a3) by SA0PR11CA0116.outlook.office365.com
 (2603:10b6:806:d1::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.32 via Frontend Transport; Tue,
 20 May 2025 14:13:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF00003F65.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.18 via Frontend Transport; Tue, 20 May 2025 14:13:32 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 20 May
 2025 07:13:18 -0700
Received: from [172.27.58.102] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Tue, 20 May
 2025 07:13:15 -0700
Message-ID: <ae6d8d55-2af4-4f78-8b33-6a30b075c30b@nvidia.com>
Date: Tue, 20 May 2025 17:13:11 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH vfio-next 0/3] mlx5 VFIO PCI DMA conversion
To: Leon Romanovsky <leon@kernel.org>, Alex Williamson
	<alex.williamson@redhat.com>
CC: Marek Szyprowski <m.szyprowski@samsung.com>, <kvm@vger.kernel.org>, "Jason
 Gunthorpe" <jgg@nvidia.com>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	Christoph Hellwig <hch@lst.de>
References: <cover.1747747694.git.leon@kernel.org>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <cover.1747747694.git.leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F65:EE_|LV2PR12MB5750:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cc1588b-5e6a-4d47-31de-08dd97a880cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QWVzS045cWoyNnIzYTJkV0pNdXdIVFBpWVFvWkZBK000aUg2aVZ5MzNpSUJ4?=
 =?utf-8?B?MHdZR3JseDJuVVpqc1YyWWFKa3oxMnNIZENpa0Z6S00rdDZyY0hFSjdVTU51?=
 =?utf-8?B?YVptck5VWWphcUhPbjV6ZWJTRGlzcU8vK3k1eU5xTkpuT2lMQTFGVHNvUmRx?=
 =?utf-8?B?YkZBdWNUaUx6dytoQ3VEQ3djL3JUamVYNHFzQ3Jvc1lYUUdkeHZsV2F3bkxM?=
 =?utf-8?B?eHhTSW9oa1BJSDdJODdTTXRKWHlReVNnZ2FRRXZzUkE5N3FNWm5GUEFQQUNv?=
 =?utf-8?B?NVp1L3ZHTmd2RGZUS0hTZlYvVXBpK3N1QWJ3TWJZSURMWU9UTkxHSVVXUlF3?=
 =?utf-8?B?OENLMEc4VDcxVzRsQWFUWXA0QWxLc3FDc2tDY20vTm0yUElGbFVEMnJSOWNr?=
 =?utf-8?B?cEhhc2gyRHdXc3UvR2grSmRSVkcyQ3NSVk5ucVlLdUNPOCt6eHhobXdMczdO?=
 =?utf-8?B?M0xQS3oyYjdMeXJzc0NWM1p1bjU1WlNCUDFIOGF0T1lLeTFqNDYrcXdQRlVz?=
 =?utf-8?B?N0RaME9xdVV1bys1UWoxL0hYUTlvREtudGs4Y2toKzFpc1piazRpalE1R2VB?=
 =?utf-8?B?SGNNYUc4aERwVmNRdVQyK2hscDNIcWh1VGtzbmZVN1pkTmNad21ybFlpMnJy?=
 =?utf-8?B?U28zb1Y3bTZGU2xaZkVEdWhOL3VzTHJWWnZZNk5TREo2VEtRSkk0eXZ6UEU5?=
 =?utf-8?B?TWhRL0V6bGF4NnN3MGpacFhiU29vOVBJN2hDczNtTmIrb3pIQkhESnJiemNu?=
 =?utf-8?B?eVJJek9VSUlyUUY2aVg5aE13TEp4am4vYm05bC9tSmd3L3Z0RmN6bktNcVN0?=
 =?utf-8?B?Y0wvRVZJTXlXTjJ1WWhjMHBjKzJxVjJHK2JISlNrb1oyalZmWjNDa214MExH?=
 =?utf-8?B?QlFNVmo0aFl0TDBBMEx2RmxTS3FMZmJ2UTRHYlZzUnlnL0dPbC9OeUpadzFD?=
 =?utf-8?B?RGsxWTFCN1V1Zno1bnQ5TkQvV0UvNURJYUdWMU5DbzBlSzJRck4ydkM4b3Jx?=
 =?utf-8?B?UUs4cWUxUUJMcVowRktRb0M1SjVFMTlsbGlxWXFuNGM0c2lnNERyWFVuTFM3?=
 =?utf-8?B?M1F4djRCZU9NYVA0RjNXeGVJMWJjN09QdTVSWTJmNlhBaDhzUUIwWUtyNVl0?=
 =?utf-8?B?bXFnVkNQZ1lyN29yLzJnQ1l1VWN2bmthMUR1SVpaYzdibnQxYXZZYWpJWm1t?=
 =?utf-8?B?bUR2d0ZVT2hmY1UvbWd3VDJhR051VjhjNlpBd3JFdXBCOW9hYXhsdjNLOUN5?=
 =?utf-8?B?QkhwcmRXMTJwc25PZ1JFS0ExTmt4QzhuTllRUlJ1WUo0SmlRT0hkeTUxYjcv?=
 =?utf-8?B?L2ZmT0dSeUFTQzRPTTExNERxVzVsMHhtR2YyL1FQbit6MVBEcTNRVEJyamJw?=
 =?utf-8?B?VS9WVWlJMlJMVzVKc1MraTBscnljemRsU2VCTUFiWW5WYmlyeENra290Rys4?=
 =?utf-8?B?VjRUY1RwcWp6Y0xjMW1HRGc4UjI1UTNNeEtSRVBoeDZJT1ovZktzMEVLRVdr?=
 =?utf-8?B?YW00TGdPMW04MGNxYndpR01xQVg1WmF6endwemFhc1oralRoT21IeHlBS004?=
 =?utf-8?B?Q0l5enZDRFJqR0s4Z3V3SmRTREU0bWlndzdlZHlKaUYvNU5EVHRjdFJmNytC?=
 =?utf-8?B?cllHNW93U0xMZXBFL2ZwY1R0WmdXNm94eUVlalk5SS9iSjJqaHFRc0NTTDRt?=
 =?utf-8?B?U3dnOXR2Vnp1KzkvVUVzK2d0S1haYXk1VXN1QzRBQTF0cWlEVGEzc1hwM1BK?=
 =?utf-8?B?MlFXeXJ0N044eU90bWhvY0pUT1J0VDc4ekhXS0I4ZjBWR2lxRG8yd3p1MVY1?=
 =?utf-8?B?WUhPcTVVcWNaQ29jOW1GOEs3REZyRTcwcVQxWFY3Y09XOHZRc2YwekwwUGNW?=
 =?utf-8?B?eDdCUU11eEdDTnJJMUJIT2VZZDgydFFRTWlxNEtzNjFjUFdpYk1Ta1ZTZHp4?=
 =?utf-8?B?UW5WRm1UT1Fhc29qd1FLcmhkSWpCSjVwL01sVGF0dEhZS3ArcVJ0bWg1Qm5Q?=
 =?utf-8?B?Y29ld3F0VUhTTVdZdmZXUXA2ZEVxRW1rOGF4OFNlLzZyZlNPTEQxd1dFcFEy?=
 =?utf-8?Q?teKIY7?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2025 14:13:32.6836
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cc1588b-5e6a-4d47-31de-08dd97a880cf
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5750

On 20/05/2025 16:46, Leon Romanovsky wrote:
> Hi Alex,
> 
> This series presents subset of new DMA-API patchset [1] specific
> for VFIO subsystem, with some small changes:
> 1. Change commit message in first patch.
> 2. Removed WARN_ON_ONCE DMA_NONE checks from third patch.
> 
> ------------------------------------------------------------------
> It is based on Marek's dma-mapping-for-6.16-two-step-api branch, so merging
> now will allow us to reduce possible rebase errors in mlx5 vfio code and give
> enough time to start to work on second driver conversion. Such conversion will
> allow us to generalize the API for VFIO kernel drivers, in similar way that
> was done for RDMA, HMM and block layers.
> 
> Thanks
> 
> [1] [PATCH v10 00/24] Provide a new two step DMA mapping API
> https://lore.kernel.org/all/cover.1745831017.git.leon@kernel.org/
> 
> Leon Romanovsky (3):
>    vfio/mlx5: Explicitly use number of pages instead of allocated length
>    vfio/mlx5: Rewrite create mkey flow to allow better code reuse
>    vfio/mlx5: Enable the DMA link API
> 
>   drivers/vfio/pci/mlx5/cmd.c  | 371 +++++++++++++++++------------------
>   drivers/vfio/pci/mlx5/cmd.h  |  35 ++--
>   drivers/vfio/pci/mlx5/main.c |  87 ++++----
>   3 files changed, 235 insertions(+), 258 deletions(-)
> 

The series looks good to me.

Acked-by: Yishai Hadas <yishaih@nvidia.com>

