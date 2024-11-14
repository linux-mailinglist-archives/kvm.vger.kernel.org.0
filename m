Return-Path: <kvm+bounces-31840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DFC949C8455
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 08:53:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5901E1F23863
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 07:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7A911F7080;
	Thu, 14 Nov 2024 07:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hGOxjxrb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DD51F668A
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 07:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731570775; cv=fail; b=MaWVRXyW+GO2aM6v/K3o+btKF+KPC33lOw43VsFUkcMfNqPS9jdXnkQmBHcj48CbF1hxrABgFq5qyN9nbVcbf0PdWPJ0PIlVNNNTCaslAHvzi7rZZEj5+O+dUCz5ppXvDJblGFPcNRu5G34AOJxjLkgdfyjvya4eelxmh8ZB/PQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731570775; c=relaxed/simple;
	bh=SurKVrl4b084dCLuH7ZoGWdRjoiibh5ugE4yLLkvGaI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ImncYFhyOFNZY/2hvOH4JrUR3hcpDL9psisq304/iHRhwpdD0LdNMUINGE5nggpT0P2iRcdWEvb6+AakTSnHx2fIDNS6i1JguVU1DJ2BTMUTBJHAMkBi42ufoqsY3TGKdb5q7fszItQV1wRCB5upos5ysxV4ah3kndvxu3sUggU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hGOxjxrb; arc=fail smtp.client-ip=40.107.95.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y1J3/qCxyamqhZYsWJWZyQ4ZzssHudddpEJfcmd/QyHFMJAtpLx3NqO0tucGUpTAyessm6WYrrmicwxIFjlIJRZl9lGj7Q6R4L9gv73ysSFKy303RT2l0KQ6lVUKab9ipHIEJY+qbadby6KpuAyLfO6iZ+eXyCKkeREnYIqbW8y9Gkdnsr7dT2TIw0pj5Awnn4EM+ENgE4pVQlWKiutcEUml5hM9K8saA7MwD4xdij2WHtY3O+r6NqxNIG+A17ycXa9mDPhaPZchpQ2spjjsHaoBNWOLpDWIyF4hFPdIpoe6Nh82LAvnm8ql2vDV6j45ElXwHs9MUkmz+uGLYM0p9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TjBzHxFcVACsSG9oKEwZAtG0yNB5BGavruslpJNjFcA=;
 b=j2um7olMhs5wf38cs6sAGC0eJuSrsnleMaDI0fneBOuLM8IoECuSj5ARVVKp0sD5vLN87i2soVEYEOklM9aBed2PCT4f492OwFICTmsGzM+v5laK0YNbMn6VGCE98pfLr2e1KuhWYXfZ85M4A5BGhPNz1uY+r2XRPVv331urbKGeDGHsDtvUvel2KDOha6DC0Ay4prm5dmQzXP7MmV/bGkpLFksL7CcmHqw3BDPkNJbvMzeWKiRSATFMwqf8exM9bXQlARVmxbt7hXiUhGnHoZkdImt4Hn2lB73dlvHB/6Q6aC/SOh/3Pc4+NPGFzZKRhxtilW561nKGtwJjjmZLSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TjBzHxFcVACsSG9oKEwZAtG0yNB5BGavruslpJNjFcA=;
 b=hGOxjxrbyN8O8krg9YPNAKF+S+cHDX/9CrkCxk117yq25yt/VJ8WhaK7qfB3bgLK6Smx8vvyPkaxUPQyh03UNQcGDcxM+a18R1IQVrE9FRWgPBb7d68lGpKBsNM40O+b6Ok4LMlfTrNanODrBNZ2jhDhTGMNCcF8s91qF0EDkuhjZkwzGYzj11WScxPGpj31R8LskPvERX7WZwB9u7bBGVkJvpImxOMKrb82FtPUMoZ5RoGqO1WtSjfpRW7rVgFcB/Tp9CeyFRzXYGbc3euliUfKMAeWBb7mh5BvK/dAL2KgmLn2g8CEBxJEoXuFflMl60BxHEGG8DDFj5rp2j6jBw==
Received: from MW4PR04CA0040.namprd04.prod.outlook.com (2603:10b6:303:6a::15)
 by BL4PR12MB9483.namprd12.prod.outlook.com (2603:10b6:208:590::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Thu, 14 Nov
 2024 07:52:50 +0000
Received: from SJ1PEPF00001CE7.namprd03.prod.outlook.com
 (2603:10b6:303:6a:cafe::e) by MW4PR04CA0040.outlook.office365.com
 (2603:10b6:303:6a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Thu, 14 Nov 2024 07:52:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00001CE7.mail.protection.outlook.com (10.167.242.23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Thu, 14 Nov 2024 07:52:49 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 23:52:36 -0800
Received: from [172.27.34.142] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 23:52:32 -0800
Message-ID: <101107fe-d998-4545-a060-501429dae8c0@nvidia.com>
Date: Thu, 14 Nov 2024 09:52:28 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 vfio 5/7] vfio/virtio: Add support for the basic live
 migration functionality
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
 <20241113115200.209269-6-yishaih@nvidia.com>
 <20241113162819.698fd35a.alex.williamson@redhat.com>
Content-Language: en-US
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20241113162819.698fd35a.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE7:EE_|BL4PR12MB9483:EE_
X-MS-Office365-Filtering-Correlation-Id: c384d590-1825-4c6f-5def-08dd048155f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UE9mM3o0bmdSeVk1WWkySjZoWityU2h1dFk0MWZTR1JQSmlNbVFTVjZ4OUhC?=
 =?utf-8?B?WVBva2x6ZE5LdVdKSGhQbWdtKy8zQkkvS0tYQWtPUU1jaWtRaERaR0tVbXFU?=
 =?utf-8?B?MG1zZThITm1YbFJ3Z0JuVnRpME1maHV5NytFTEpyOWJDY1Z6TWJKYklOQzBk?=
 =?utf-8?B?RVNZUXZzajljMkVXemIxQVE2VTNkQXU1OURhY3hKOVJMTzdUTGpTbHh2eVox?=
 =?utf-8?B?a2kyZVl5YXA3cUpLSVR1dlR4SUlsOVJrSlpLWURuMlp1UysxRm4rWHdtQnlP?=
 =?utf-8?B?bXp4UWJuUHBTNnpLMGRlQ0hFb2JOY0xWdEl4UlBhVk1jU1hmZEpMSVlCcVAr?=
 =?utf-8?B?M0NXdURCUmxFdkdWV3RiZExuSmZJT3hQcm1SR3hSc2RZMmQyOGZ5REFCa3RW?=
 =?utf-8?B?c0dZS1dwS1RKMlhmajUrQVlVUi9hdURWYXp6blVpUldJbkhseDFSMFk1RlpY?=
 =?utf-8?B?SkRhaWx4VHRxRm1zMXJ2a1VHK1llM1l6aW5yWXNkeGMxTm9hTThHcGQ0MmJN?=
 =?utf-8?B?cFB5NmVPVE9PTHRVck5ueHZoRnNxekUrUDlvNW5KKzM0ZjNiTGpYa0R0ZUU1?=
 =?utf-8?B?WDFzNlY1MkhwQ3o5Q1RmT3JxUU9xR3FqYjNmdjZIeGhkM2ZxZzlCQkxZd1hC?=
 =?utf-8?B?emd3UkhrMTFRT0hJZ1VCQmVKcnFMRURFRVp0UUdicUE4d0hjdU95KytBQnJs?=
 =?utf-8?B?K0pVLzB4UmdoeVlUS21KYnRLWUw5ZWplczNDSHFFdU5obFhGRzdic211ODJE?=
 =?utf-8?B?TUMvMzRuRVN6dkdtZ0I4TXZaTitJbmJzMnJQWUJYeHZuZGI5ak56QkdGcTRE?=
 =?utf-8?B?NlpFYk51NGw0SnVKSHphQ1FsVDdnKzA2aS9QL3RIQW00T1FybG4zSjZ6eHR3?=
 =?utf-8?B?UzNsUXd0UEJlVkZUbTVydnZrUWM4VU92U0dFTVVWQWxDeWJRc1NWK1pZUjlr?=
 =?utf-8?B?Y0dmbTh4TWhZaG1NMExyYjcwbFJhWXJ2MXJVNFJVcWNYbzdQdyswaDRSb1Jr?=
 =?utf-8?B?NkZ5UjBGZ242QkQwMXMwSis1Z3dhUmwwKytDQzRhS3c4V2FxUW1YRHhST3Fi?=
 =?utf-8?B?RlZ1VmFzM2phWk1XTm1XQk5iVVJCZUNzN3FFOGd5MjZOTHNudlFGdlNINUpO?=
 =?utf-8?B?cmFURk56eXRXVTZFUGxWcmw3eCtmdGEvcXpxSlVZd1lLdENyVUNSajBFeTM2?=
 =?utf-8?B?UkFGU0hsUFBCaGpxZm13Z1dlN3M3NFFML05hYTk3bytKTDVydzZyR2ZNbktF?=
 =?utf-8?B?M2hZRjlsWTgwcWdyWS9YZ1h4ejN1RDcya1ZoYWJDN0crQVkrZDRxRlNmS2tG?=
 =?utf-8?B?dGdkc2lDZnNnRkFZSThuTWEwWGpUL20xUm9RTmhNM29HMHFwZ3hzd09BRGtD?=
 =?utf-8?B?a2lXQlNDOEprckN1eDJBWXRmYm40bHgyZzd1bE9kTG9RUjM5VHF3TEZNNGtx?=
 =?utf-8?B?MWxBb1JkdUZ1QmR5VlpxK05VQ25uQk8yNFNtSkVhVDRuTDg3MTliWWdWODZI?=
 =?utf-8?B?ZEJkZVVrT1dEbzl2VWR6MUk3Y2J2bkhRZnBHQk9BL0lwM1V5b2lsZW9vOWlS?=
 =?utf-8?B?UDVXOTJkOGdWOVZHNXJuRE92V0oxcExCTU54L2pnTmtHdDdxUjNRcEJ5V25o?=
 =?utf-8?B?Q0FxS3l3LzFWRE5qdU53TWdpYy9qMDN4QWdhbk9QYTVuR2hCbFo4ZUNzOEl3?=
 =?utf-8?B?VzlzNTIzb3ZPQUJ3aFNkTVgzV2dDTFlENHpGUXlVTjlKNXFMV3NqU2lRQnM4?=
 =?utf-8?B?OXl2a2EyeTNDV00xWlBNT1hlSDlidlp4ODdiWkU5OEJBZVl4SWpDVFROYmw5?=
 =?utf-8?B?ak9UNzJzYXFZUVYzMnFlRjlWZ2xBU3JWcFVtd0taT0FpNWRuLzh2R0Y2Y1RX?=
 =?utf-8?B?V1RWVVNTa3Zxd0FUb2tWRHdMTSs2STF3WjVBN21wYjIwNFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 07:52:49.5733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c384d590-1825-4c6f-5def-08dd048155f7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR12MB9483

On 14/11/2024 1:28, Alex Williamson wrote:
> On Wed, 13 Nov 2024 13:51:58 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
>> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
>> new file mode 100644
>> index 000000000000..a0ce3ec2c734
>> --- /dev/null
>> +++ b/drivers/vfio/pci/virtio/migrate.c
> ...
>> +static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
>> +					unsigned int npages)
>> +{
>> +	unsigned int to_alloc = npages;
>> +	struct page **page_list;
>> +	unsigned long filled;
>> +	unsigned int to_fill;
>> +	int ret;
>> +	int i;
>> +
>> +	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
>> +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> 
> checkpatch spots the following:
> 
> WARNING: Prefer kvcalloc over kvzalloc with multiply
> #416: FILE: drivers/vfio/pci/virtio/migrate.c:71:
> +	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> 
> 
> With your approval I'll update with the following on commit:

Sure, thanks.

Yishai

> 
> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index a0ce3ec2c734..4fdf6ca17a3a 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -68,7 +68,7 @@ static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
>   	int i;
>   
>   	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
> -	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
> +	page_list = kvcalloc(to_fill, sizeof(*page_list), GFP_KERNEL_ACCOUNT);
>   	if (!page_list)
>   		return -ENOMEM;
>

