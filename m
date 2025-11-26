Return-Path: <kvm+bounces-64658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A960EC89E11
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 13:56:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E2153AA4D5
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 12:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 482E3329C58;
	Wed, 26 Nov 2025 12:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BMYuePZR"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010031.outbound.protection.outlook.com [52.101.193.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841C3328B54;
	Wed, 26 Nov 2025 12:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764161749; cv=fail; b=kYJfL1E8Dtb1SJi4jyMavRth/VUbCJaY8VBZfGCH+1ixZlmMH2xIv2d/WrT918kg2y0yKQiqqvFGVO7QX8d2UcNgJo9L4B8gosr9raWOGeS5GIAqm0QQIpBv9plSaRwKW7eTdJiafdcfUBY80bNkmgsYSMp55Mx0nfZNBs2wV/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764161749; c=relaxed/simple;
	bh=VCtlqcnHQLbKsZTS/w3g0Azg1oIMjc8zUiG6lqqQyIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=BXo9DbOI0LJQ+y52xc+aOkQ+IBRVuA52uMzTrEnruX+pMpenfjPHnsIaWrchCE1cqob6Lj23YT6dJL8VT8C8icdYJNnWf1dQBvIsitUyMgn6GbYBTdcgb3ghWpuugUZtCkiD3YkrowZkhVKxOjk7eu9JsCJ0XrEfGUCxB/+PAU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BMYuePZR; arc=fail smtp.client-ip=52.101.193.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yEogWjZXqSXsNWuVqgRu29Y0+TKJmRdTrimnZuyKRO8x2F02gWXZB2hgugjAyd48KfjXE002dFgtrCp5NrSE3qUjUhN+KyLoO82Ag5OFs8kv9yWyYRK53TjpEgjxEAqi2JqktKtI0fepPYR6GhJDVMTowjpgdIbto26Y02SGyaIHwuI7jSdZAdwDgAQA0k15LqSvqGCXBT7vBs26Y6awGNO3nmUUt20lFik1P2ro07Ar9ZFT58Jhb7McFMTVTGy+9ULXgh/Qf2ZfhAvkNmnvETBo/hmtHU11YdGUa0PrNhNE6sDvx8cZ9DPpAuZ/LqaDXy9vQIhDHkvk2z4urg2/6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OOLbz5T6j9f0/FMeiqQGZRnFda1JEt/ver6zFmLEIHI=;
 b=ngk6Ilz4zFP/55Xp6b0MT2iJQAzHFhkYixsTAwB0qQGxRW+ZZF9NItlzqX6TIxGPvT/+WgIrdgV+FyFobtKBZbHS/Q+O/BUFvGFn9hjer3oEAUeEk7+kDkc2bW9UjMWbQeUil6aWx9HBpbP9LIbz954VUZwNup0Qk4CxBz6jfowliX26CgQWK4s9hpG8RzMg9/2SorOoVIRi/QXoXMuRDime9atzgIJYLS0iOOvZuRt9p6NdBrVDwp5C1zla9RhvuL57WWqcrPpqH/S/4SYsksYjvDWUCMhuLnojoowcumzhE3TQJcsDLjq7WTPwOxNSNyn99HvIAerVpaizx1BRjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OOLbz5T6j9f0/FMeiqQGZRnFda1JEt/ver6zFmLEIHI=;
 b=BMYuePZR4M6LFsU+hgQN1T0bUORVbyt19mMLgDnw/nDFr3by+LEfTW5CwffB5J8TvHSEaBn6RqSp+lr5Csf+a1KNJqooowVkQYRM+iIRQ4PurwEx/8bRHqWZajOdGEaI73YzaZJjZ18ejdIp7dyDTmcVmiqVvaPiQWKfjkyoByw=
Received: from SJ0PR03CA0204.namprd03.prod.outlook.com (2603:10b6:a03:2ef::29)
 by DM6PR12MB4300.namprd12.prod.outlook.com (2603:10b6:5:21a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Wed, 26 Nov
 2025 12:55:41 +0000
Received: from SJ1PEPF00001CE1.namprd05.prod.outlook.com
 (2603:10b6:a03:2ef:cafe::5d) by SJ0PR03CA0204.outlook.office365.com
 (2603:10b6:a03:2ef::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.11 via Frontend Transport; Wed,
 26 Nov 2025 12:55:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE1.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 12:55:40 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 26 Nov
 2025 06:55:40 -0600
Received: from [10.252.200.251] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 26 Nov 2025 04:55:34 -0800
Message-ID: <1f65de37-db9f-4807-a3ff-6cd377c855a5@amd.com>
Date: Wed, 26 Nov 2025 18:25:34 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/5] iommu: Lock group->mutex in
 iommu_deferred_attach()
To: Nicolin Chen <nicolinc@nvidia.com>, <joro@8bytes.org>, <afael@kernel.org>,
	<bhelgaas@google.com>, <alex@shazbot.org>, <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <lenb@kernel.org>,
	<kevin.tian@intel.com>, <baolu.lu@linux.intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
	<patches@lists.linux.dev>, <pjaroszynski@nvidia.com>, <vsethi@nvidia.com>,
	<helgaas@kernel.org>, <etzhao1900@gmail.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <a7ebae88c78e81e7ff0d14788ddff2e6a9fcecd3.1763775108.git.nicolinc@nvidia.com>
Content-Language: en-US
From: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>
In-Reply-To: <a7ebae88c78e81e7ff0d14788ddff2e6a9fcecd3.1763775108.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE1:EE_|DM6PR12MB4300:EE_
X-MS-Office365-Filtering-Correlation-Id: 25291961-492c-4892-72e5-08de2ceb1ab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zm1hSWY2S0w2ejhWT1NHOFZMdXJWdC94S041c1VBS3lLWGJ3a2lodXhuc2tu?=
 =?utf-8?B?anNNSndzN0N0T3ZIZVV5NWY0eU1oVURrSUZkR0JkVWtxOGpsdHlsTjZxcy9V?=
 =?utf-8?B?dWp2YlJtN1Y3bVZwcWVSRlUwcEYvek1BM0d3Y09JY0RPREwzQWQwbHhudWVm?=
 =?utf-8?B?RExUckFjL0tjREhTTjY5ZUNlYUl0WGFMcVdUdXpRMDN6TURoaGtMN2p5cmNi?=
 =?utf-8?B?THVQRTJJNEV4Y3VPbTdkdDVDZFZWdkN3dkJWWEszWUlyM3N5bG1yTURhdnFh?=
 =?utf-8?B?endRNjAyU3NWUXlzcFV5b1Rhb0JrRDdadUxlN1dzMkJZUDNKUkpzVjZsa3JK?=
 =?utf-8?B?ZFZ5d3poZmRDN0pIa0lBaTVMdm91VFFsNXFydFZBcXRuVlc5b2dvU3NNQ3gz?=
 =?utf-8?B?RUNIdUFwR29MaGlQc3U2T2llWGtFVEZDd1NLUHVKYW5sWHRIS2VsTTJORjdy?=
 =?utf-8?B?NVN5UWloZFlKVkRqNnl1MGhMU3gyc1BNM3JxZjlKY3VUZ0VOblUvelNtTkJL?=
 =?utf-8?B?Ukw4ejgvVmNYQ3dhaXphL3ZEai9vbmdhaDg1eGFPSklHbzBibEJaeWhZd01I?=
 =?utf-8?B?anlML0dMMnVocTAvckNvZzQzY1VjQmxPaVNEd1V2OERvWmxja3JHZWo0dDVv?=
 =?utf-8?B?bVRTRFg4Qkx3VnhQclBsQk9adEt1R1ZYdmt5Y2ZHVUpSTnhQT2dyZ3QvRVht?=
 =?utf-8?B?Z1FKSkJPTXRUWElzTlZ0MzhoVjYvblNHVkdaczZIcGNBQUJIS1puamJRdVRP?=
 =?utf-8?B?VERYamVlTkdNRzI2MjVuckhMczI3UWFQVFlxOElFRzlsMVJQcHcvcitmTnp5?=
 =?utf-8?B?MzVqbS9uNHBRUzFMZ0M1SVF0cndxUERvdTltenpxNWdZNDV5NU8wTURPSHJk?=
 =?utf-8?B?SFBEVHorMFA2MWlpSmQ2dkJyMVg5Y1dyV0lXbXhVcUYvOEF5ODlTc0NlRHVH?=
 =?utf-8?B?QjFYdk5zdWV2U1EvOW5vVTRCMkIzS0drN2huZkVBbkw0QW02WTE4YjNSUU5O?=
 =?utf-8?B?QXZXSVhoVSsvR0xZTDgvV1RoZDY1NDVTZGk3b1NXaVRoZDI0UEM2RzZMZ1E5?=
 =?utf-8?B?Q0lIWVVsS3BtSFdKalFia2tVR0xyVHRXY1NFT01aaldsQUNxbWhCZEZvcElV?=
 =?utf-8?B?MlpQazdlazhkRlhScWlKekt6QTZ0RXZSWTFEbEJZRFprclMwdThhUmJ6dTkr?=
 =?utf-8?B?VllHMlhGRmxCK01sT205am5tM01ab2VpYzhDbFhuS0ppdTY2R01oYlJWSUxR?=
 =?utf-8?B?eFJGZ2lLWmg0NG95dzRNalRHY2xCWFd3QjIwd0R1dUhpckZvUEFJRk1MQ0hH?=
 =?utf-8?B?c09GTnNHcmpuWWV0TWVlVlFOcVl6VllGM013NGcwcHB2UU5ZUk5MQXA0UnNu?=
 =?utf-8?B?YlFVRUQ3QXhDT2JXSm93RnlXd0tLeC9KMWE4cmpmWU1waWVJV1BrN0xkcldq?=
 =?utf-8?B?VUpFTWh0MG45eEkyQ1NIVkNvRkI1alRnQXB0NDNkaWo3OWZod3hOT2xwTjdD?=
 =?utf-8?B?V3BMZU81T2ZLZGhockVRbmJEOHU3QVp1MDVvREhwZ1J2VXdxM21JNGhuNXdn?=
 =?utf-8?B?Q2JZWWNSSm5XQ2owZEJwM3ZlWjJneVp2cDdPZjJXa2Rpak1qSUUwK3htZU5Y?=
 =?utf-8?B?TCt1NkFMN3h3U01nRDQvRU5FOXJNZkFSemNKSlpZcTdaVWk3WWVIc2lRTWpH?=
 =?utf-8?B?TUFnWXRNUk1LZGRnMGdESjJEdCt1VUdXeTZ3ZktDMnoxTFNpMDM5cHU5c3Bq?=
 =?utf-8?B?TU1ka2R1LzZZNVhna244R1c2V01iY2M5M1ExMGFkTU9pZHpBOXI4SHlLS3JC?=
 =?utf-8?B?azdtMHBsdUlaVXVTeUF0enFrQldHS2tlUVVza3gvVDE1K09uNHRDVkM1TE84?=
 =?utf-8?B?cDdKd2I5MGFOdEFkeS9PeEZzQ0RJeThUUDg3UW5ScXlDOVRrVFBDSHE1Tktv?=
 =?utf-8?B?LzlaVjVrQTdOYmo4NFJjb1h5OHlpUjNsSXhnZG15b05acWtwWEJqQ1BIK1hI?=
 =?utf-8?B?YnJvMDdIczJ3bk42T0Y3STRaNWxnbzBjSHRRU1AzNXYvdVdLYU9id29kUkNj?=
 =?utf-8?B?OVdWMjBpZWdJZjI4VERkeGMvTG1GUStuK3dyZWRicmlEdmZBOHMrQklMWUQ4?=
 =?utf-8?Q?7QbY=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 12:55:40.8724
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 25291961-492c-4892-72e5-08de2ceb1ab3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4300

Hi,

On 11/22/2025 7:27 AM, Nicolin Chen wrote:
> The iommu_deferred_attach() function invokes __iommu_attach_device(), but
> doesn't hold the group->mutex like other __iommu_attach_device() callers.
> 
> Though there is no pratical bug being triggered so far, it would be better
> to apply the same locking to this __iommu_attach_device(), since the IOMMU
> drivers nowaday are more aware of the group->mutex -- some of them use the
> iommu_group_mutex_assert() function that could be potentially in the path
> of an attach_dev callback function invoked by the __iommu_attach_device().
> 
> Worth mentioning that the iommu_deferred_attach() will soon need to check
> group->resetting_domain that must be locked also.
> 
> Thus, grab the mutex to guard __iommu_attach_device() like other callers.
> 

Tested the series with PCI reset on PFs and VFs, including device 
pass-through to a Linux guest. All scenarios worked as expected.

Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>

Thanks
Dheeraj

> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 2ca990dfbb884..170e522b5bda4 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -2185,10 +2185,17 @@ EXPORT_SYMBOL_GPL(iommu_attach_device);
>   
>   int iommu_deferred_attach(struct device *dev, struct iommu_domain *domain)
>   {
> -	if (dev->iommu && dev->iommu->attach_deferred)
> -		return __iommu_attach_device(domain, dev, NULL);
> +	/*
> +	 * This is called on the dma mapping fast path so avoid locking. This is
> +	 * racy, but we have an expectation that the driver will setup its DMAs
> +	 * inside probe while being single threaded to avoid racing.
> +	 */
> +	if (!dev->iommu || !dev->iommu->attach_deferred)
> +		return 0;
>   
> -	return 0;
> +	guard(mutex)(&dev->iommu_group->mutex);
> +
> +	return __iommu_attach_device(domain, dev, NULL);
>   }
>   
>   void iommu_detach_device(struct iommu_domain *domain, struct device *dev)


