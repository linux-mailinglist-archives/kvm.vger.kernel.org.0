Return-Path: <kvm+bounces-52241-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2881B02F48
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 09:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB772189ADAE
	for <lists+kvm@lfdr.de>; Sun, 13 Jul 2025 07:57:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273411E102D;
	Sun, 13 Jul 2025 07:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pLeSyE8q"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF852F5E;
	Sun, 13 Jul 2025 07:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752393437; cv=fail; b=VYLsMOrMX8z+yxp4PCByyL3dLsrBOLAkVdAjXxMTgNy/lv39c7ARm6ZdqcqSo+mlWzsZKgFjv7BUJoUjW9P/Mr430Qi84ORlM5sFl/yO3IiK6Y7PnH6BnDuJStDtoLLtkZbJzu4GG4kaB1YXb6Cb/Z99/8KhIUnsePciySrSIx0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752393437; c=relaxed/simple;
	bh=xEmJjSklYySeZQxCgbO9F3HJi6vyw703lJsQ53S+DFQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qlW9T9Xvq0wZqvMcBQYqxpHdClQ9O0awn+IENnwd94bjqC0E6jsdnrQuV9YOJOoEThUBKtgHs034/728gt8kNrtB23oyEFBJCB9KnJ24FM2eDtK0r7OCxVT++vBCaDlSmNnocHtZmEvxgLC4Vf+4ZEKWu/pVK5USerzsY4HATu0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pLeSyE8q; arc=fail smtp.client-ip=40.107.243.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JnzSnB5qQIyuzX0KiuZ+vD/bi5l7CBEuAFYeZlM5GPKFONI4YyiRXPHFwEkO5LxDQ0v5GktU//M+mp2OgYUs32efO7me6X70Nj8SOEL60fpauEqjJiIUmbkSNSxqfGKaIaVuzb9VsPEgyRiYLR+BzjqFb+ooPXaLyZP5nLnVQyvpJcgzNOjud+u7CtapasUlNCZmP9yT4b4FFvgMGdy7mKzvENu/sIMGeh9a3dKDYXSajFI68ienENwJ7goPt0Wir/gEer0nelndouhAHhpflXXaS2Ni6im8JjErSiuwPun2Rby4AFkBuTZUi78GZqB5uxLlYxi0jsmlpY6jDuwqwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/j02l7zrCjbGQE+t6YnbKr7wK1aAuq95ejnlaP9orjA=;
 b=AAQmHslGaWJy5Ee7kE//4M6QVcLN2aFTkjy1lkwk58h6cZyMUZRxABVWZKt+9hEeTDbSKxOSnKxTJ0ZPi2w8UZvP1H3QAtbbOPC7jhhXYyjcGKdAu9sibz3zpjkkmEobnDGYAlqF4CiwpeZdCFniAHFyZCUbzvfMcW7bh+gzHakHv/hW+vC0rJI+4rQeeb8m37prsRiYx3m1v4Be6+RkWGLmGJNfY23Qvy7b3u6FdCuJ9uZFfWgztxepr7WYevjMvdsEJ/QkNmtZHWpMl4hWaLclPkJjdYjuMKH8ZvlWcAN5CC+z9MSnLNWdJzNYPabkOb8mYZvwrKhVDOawov8COg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/j02l7zrCjbGQE+t6YnbKr7wK1aAuq95ejnlaP9orjA=;
 b=pLeSyE8qT7bn5u+lhoIseetu4M8TBBZmxw08+mW/j569nBtkOmQC8/kP9rnoxRT9dTbFiozRDSqnXgJ/etSXaWWMZLfspmd3SIRmyPDb1srLyWwqoB5lXcPPzUNIwAj9XBueyx36zmKH6zHByamezvH4fch+dpbDj1Sai9n4enkqsq7aXiGorBVMkVK7Ko2rLiOUofAw84IJPTGNobQKs70HAXm2VzISbaX3Je9nX7vTzD38mzzEsR21rn/0HDA09N35ybJGBGFhSzl2GVEuXn1fqWuoHDDJf0OoaAEknup8UqBve2Fg1/t4/HSR0GvFfpyEtQrRvhKcmufmvA0v1A==
Received: from MN0PR03CA0015.namprd03.prod.outlook.com (2603:10b6:208:52f::17)
 by SA3PR12MB7924.namprd12.prod.outlook.com (2603:10b6:806:313::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Sun, 13 Jul
 2025 07:57:10 +0000
Received: from BN2PEPF000044A3.namprd02.prod.outlook.com
 (2603:10b6:208:52f:cafe::47) by MN0PR03CA0015.outlook.office365.com
 (2603:10b6:208:52f::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.28 via Frontend Transport; Sun,
 13 Jul 2025 07:57:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A3.mail.protection.outlook.com (10.167.243.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8922.22 via Frontend Transport; Sun, 13 Jul 2025 07:57:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 13 Jul
 2025 00:56:59 -0700
Received: from [172.27.51.237] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Sun, 13 Jul
 2025 00:56:55 -0700
Message-ID: <b7cfa490-bc6c-4375-898a-7e4d12579f5d@nvidia.com>
Date: Sun, 13 Jul 2025 10:56:52 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] vfio/mlx5: fix possible overflow in tracking max
 message size
To: Alex Williamson <alex.williamson@redhat.com>, Artem Sadovnikov
	<a.sadovnikov@ispras.ru>
CC: <kvm@vger.kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Shameer Kolothum
	<shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>,
	<linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
References: <20250701144017.2410-2-a.sadovnikov@ispras.ru>
 <20250711150026.19818a98.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20250711150026.19818a98.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A3:EE_|SA3PR12MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: 74e05d71-9373-4548-41b1-08ddc1e2df10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnlnOWZTaXkwdmhqVS9oOW1sMjhZMEpWejB5RVJHWXlVSjFqcDNEd1NESHR6?=
 =?utf-8?B?Y1BveU9FZU92c2wxRW1sY3pDWHk4bU5HUHpRVjZiWlZnS1MvM3ZpREZCSmky?=
 =?utf-8?B?OXlWUjFnZGg5bk1rY3plaTlVTGUwbUxCeUI4eFdyRS9hZ1NMN1RCNFpTRThJ?=
 =?utf-8?B?NW5Ycit0Qkw0bC9lTnEyM3cveDJqVlNFb3owRWQ4VkpSaDlYWXlldUhjYXh6?=
 =?utf-8?B?dElXY3o0TWFkeE5SSDFPTnlDb3c0dXRWTnFteFo4cEVWZlFOd3JNL0xLUktZ?=
 =?utf-8?B?WnE5N1cySEdKWFNhZTVzb2xJbHRQd3JMV2JDWUdaem5KOXZIODRwZ051T3Jk?=
 =?utf-8?B?MFNOcVZBOG5reEgwbG1zUEMxMGplNldyTm13UTRPRnpXZVZhbkQyRFU4Z1Zm?=
 =?utf-8?B?cXNwaVJoTFFqL3FlSnhLeXIrRnowR3VCSlhxaXM5bGFkcVE1bHhzMGkwTFZx?=
 =?utf-8?B?MXRNOVBPYmpraXN0L2YxUEFzYjVNdnBVb0dJWmhMYU1GMjc0OFdPQUxianpD?=
 =?utf-8?B?Uk01QzVkVGZjSDBHQXN0MHpNVVM4TEJSN3ZnSWdQaStvL2FnUVpualFGWjNz?=
 =?utf-8?B?aG85YWxFM1NNMFVFMDNWM1NlL1V0eFBtSW5uL0xITWhjNFlCZVp3TUFodlZm?=
 =?utf-8?B?YXVCNEE0MVd0dVFSenRwYUw1ekluaStTUGx1dThYNEN3cm9xUDQ5bjRJZkRr?=
 =?utf-8?B?L2JjZGVXOVliMHJQa0UwQVZubkZTdFM3QWMveWtqd2ExcTdlUGpFVnpRYWFt?=
 =?utf-8?B?R0RtRFcyelFRRmFZTENWREtaUUl0aXVROGU2RVJVOE9KamhnZk85Mnk0QnhT?=
 =?utf-8?B?b2ovdWJRcGs5b0dXcU5qbDVZNlBzblVRelVEV0JHN0IyRHRON3VGQzh0TG1K?=
 =?utf-8?B?eTFNNitZbWhrbmdyL1krWmtWMGhiZzVZT2FNSmtBM0NMc2lyc3p4dFFmQm9q?=
 =?utf-8?B?cVJhVTZyOXBFK3UxQTVGUHF5WVBwMnpkeE5pTVVXTlBvUWdOS2hTd3JkZEhk?=
 =?utf-8?B?UkwxblA3WW5FRWxnV2dqeThYQXpKeW41ME5sSHh3UEx0NmpaTzI1RHByMktF?=
 =?utf-8?B?RDBkdGpLdlhpSzJnckltRGV3SnZlajNEbDN0UEJ3RWxwM0krQ0JIYTFRUTlB?=
 =?utf-8?B?Z1JvaitlU0k4SVlYU0xQTkQ1VmVuWkQrTUtibGRnb1dWSnlYaGVRL2VUMGtC?=
 =?utf-8?B?K29xbEpqc3FFZTVXdDlxOGw5aFRZcWhwck54eVJvdFRIVHJvTkpLSWwzSzdm?=
 =?utf-8?B?VmpSbFdPWTJkMEozODlGbDBxbm1uMXhvR2NnTWlNS0JLK0lwVVZnUG5Qejdw?=
 =?utf-8?B?ZnU0NVhyMnJmYVJBVFlvaEthN25kRFNBQTBGWS8xcUpWekk0YUhpbGpkOGYy?=
 =?utf-8?B?R3E5NDZtWS9QR0FoL2JiSXN0Y1c3MWhpWVRtVTE2SUtlS1Q3clM1cTBtT04r?=
 =?utf-8?B?cjhmZVo2Ujd5ek1RMWdTU3R1a1VLZnVGV3hISHdoWUhuamJqOTllY3pCdHFm?=
 =?utf-8?B?Nzl5cy80Q2E2NEZVd2dMUGJKNVJobUNhQnRXWVNvUmdTdmpabzFSdEJRdDlB?=
 =?utf-8?B?UFp1NmhkWTVCTVpHNFJiQ0tlT2djcmJra0V3RzlNTG9ZaXdDWnkra2dQRXl4?=
 =?utf-8?B?WG8vK2VjeGVuUFhWZ2J2b2s2M29ySVczWmtPaEs0L1FEREtaV3BNUkY5ZFZC?=
 =?utf-8?B?bEFzaHZlb1NFdWJPL3QwaW1xZmtTakJqTFR6VEFHMDc5WHppbUh5UTBwcGk0?=
 =?utf-8?B?Y1JPUVZ5SFUyRkVrRFVsSUNkZHhxZFkyVUU0MVNvKzBUL01TZVpVVktJQWl2?=
 =?utf-8?B?dmxVZ0VTbGFCSE9TMmFnalpnSGRKWHpSR3hZU2lEME91K1JwQWFFY2NMeGQ1?=
 =?utf-8?B?YitCei95MmtPSDk5OHZxZlBVeXI1SVNSc3hSdWFXSzB0R1d3MCtOcVBDWjMy?=
 =?utf-8?B?SHQ5bXIxdGU0UERudE5LWHdXcmREUlJMRWkvQ015SjVyV0hGeTRKQUpoYjhm?=
 =?utf-8?B?WUVnL2Z0THZ2Q1lSb3oyTk1yZnZBeFhVUjgwMkFTV3RoMWN3VENib29NUlBa?=
 =?utf-8?B?b25HdUorS0hqWW93cmVKS1ZkK3I3b09qbVVYdz09?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2025 07:57:10.3772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74e05d71-9373-4548-41b1-08ddc1e2df10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7924

On 12/07/2025 0:00, Alex Williamson wrote:
> On Tue,  1 Jul 2025 14:40:17 +0000
> Artem Sadovnikov <a.sadovnikov@ispras.ru> wrote:
> 
>> MLX cap pg_track_log_max_msg_size consists of 5 bits, value of which is
>> used as power of 2 for max_msg_size. This can lead to multiplication
>> overflow between max_msg_size (u32) and integer constant, and afterwards
>> incorrect value is being written to rq_size.
>>
>> Fix this issue by extending integer constant to u64 type.
>>
>> Found by Linux Verification Center (linuxtesting.org) with SVACE.
>>
>> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
>> Signed-off-by: Artem Sadovnikov <a.sadovnikov@ispras.ru>
>> ---
>> Changes from v1:
>> - The constant type was changed instead of variable type.
>> - The patch name was accidentally cut and is now fixed.
>> - LKML: https://lore.kernel.org/all/20250629095843.13349-1-a.sadovnikov@ispras.ru/
>> ---
>>   drivers/vfio/pci/mlx5/cmd.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>> index 5b919a0b2524..a92b095b90f6 100644
>> --- a/drivers/vfio/pci/mlx5/cmd.c
>> +++ b/drivers/vfio/pci/mlx5/cmd.c
>> @@ -1523,8 +1523,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
>>   	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
>>   	max_msg_size = (1ULL << log_max_msg_size);
>>   	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
>> -	if (rq_size < 4 * max_msg_size)
>> -		rq_size = 4 * max_msg_size;
>> +	if (rq_size < 4ULL * max_msg_size)
>> +		rq_size = 4ULL * max_msg_size;
>>   
>>   	memset(tracker, 0, sizeof(*tracker));
>>   	tracker->uar = mlx5_get_uars_page(mdev);
> 
> LGTM, Yishai?  Thanks,
> 
> Alex
> 

Reviewed-by: Yishai Hadas <yishaih@nvidia.com>

