Return-Path: <kvm+bounces-64687-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 92FA3C8AEA2
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 17:19:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E7DCC346524
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 16:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1012B331A57;
	Wed, 26 Nov 2025 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SB4v7UFw"
X-Original-To: kvm@vger.kernel.org
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013043.outbound.protection.outlook.com [40.107.201.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C478F48;
	Wed, 26 Nov 2025 16:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764173957; cv=fail; b=S2qAxoMcB6LHkm+AKkZ4kfOpRS/1+t3DzOOTHD1sMnLw+4ZHA50wvW+TcAZKbCbla6S0IwlkLeERpxgO5nIGkHT1JzoZjSZR8WnSbu34WADHKgOOa1hiCv+vIhbEOTE3CwRe9Gnv7oxh7wQCjAfg6+aoydGvHCN2gkgEowwNMlc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764173957; c=relaxed/simple;
	bh=iqUqiZpaf6+uu2aNLUcvN7crg4ZeeyScnRDI7Ooj5M4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RfzNAc6/enT9H8y5pnzO52p9jK+9N2zzEJB/B5YNCddFj8JO8RICpqdAJyIo/bbwyHgxf6arXv0QNAY/Nh759gBbVDP70TFPgLln3AnA9tAV76y0rERcP7aqxY55r+9f8En/p3mxuJHOmthQqRC8b24ikxP5CcZKsPDXG79uO4M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SB4v7UFw; arc=fail smtp.client-ip=40.107.201.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uRv4HsvUO7XnPs2Dz420b4UhMElRmFBQwrdqbEFmPwXyUfOZdFRKKCOMz+ROinvJE45l+qvOvc676C+pEBjvInqtSreET6lI4bfb1Du3gjt57DEblRTaLLVgT6rtJgaSKHQwIK6PDNi/csuhQHGBVQy6IPELAiKCb8Q5jRRfv+EFCA97k3hoY/djgkBCBexrgoLgOXt+iTKPdKIRoujTKRYjvNiQeGdnnqGtBEkvf/rY1gmba/+ObJDQHRfvkEOeCH3XGLtlEAEF3GB9VBoLC9efQZuLc6J9IrRPcZVz5gCNQqfOGX+ywr32xMyA+aTtsfo/bmB8RbF+BlnUs/S0TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsodfgddKhOSDG2GBtD27ZGo+y0PDAT9cAr9o2A8mRk=;
 b=A6BE55ZRZgBj9z2JubIQKPcVqhYdp41os9P1yQj3vqjf70HDFyZ/760+8fQtgeUtaM9VoaGIw8VWYM03lkL+xydxbOOlQu4EKRSVKW91h8DU8jJfpG/7ACu46aDZV3ac0ItIm/IUIWhqCw0oGncs0fs5p0tIGqEymK+w9RggaiDf3p4YbG5XwWd2uiPk+LWA69WCg+jxxdxsNq0aQ6HLyl9Ys26yl4UUVJb1yK1p70E0Ov+fwZPVi7JBJfZNsmVWcqxlGA40cOmtfVt85J8mtthf0UJFpqifkd1x7A1bYAQp/GE0BKzdVnyaanSrM9UqcS0bMXjrmPrOGJ//wn6gIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsodfgddKhOSDG2GBtD27ZGo+y0PDAT9cAr9o2A8mRk=;
 b=SB4v7UFwtxGDl6oousoZBIBIWqkpwlubDkXlblTO7eAfs2N/CPbgJRxhEI4ey7aXtP69MzMV7EgTqDDtROyIfqo364c7+LiRzLw0W6didT7kQK5TdshMcjUmaRGgLHaPry4a2CDYbH94Vun5OmEe79jdMmdU2aI9ISSp1W85d2Y=
Received: from BL0PR02CA0011.namprd02.prod.outlook.com (2603:10b6:207:3c::24)
 by MW4PR12MB7118.namprd12.prod.outlook.com (2603:10b6:303:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 16:19:11 +0000
Received: from BL6PEPF0001AB76.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::3b) by BL0PR02CA0011.outlook.office365.com
 (2603:10b6:207:3c::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9366.13 via Frontend Transport; Wed,
 26 Nov 2025 16:19:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB76.mail.protection.outlook.com (10.167.242.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9366.7 via Frontend Transport; Wed, 26 Nov 2025 16:19:10 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 26 Nov
 2025 10:19:10 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 26 Nov
 2025 08:19:10 -0800
Received: from [10.252.200.251] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 26 Nov 2025 08:19:05 -0800
Message-ID: <451ce2f9-732a-4424-bd45-d20a4d819d46@amd.com>
Date: Wed, 26 Nov 2025 21:49:04 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/5] iommu: Lock group->mutex in
 iommu_deferred_attach()
To: Nicolin Chen <nicolinc@nvidia.com>, "Srivastava, Dheeraj Kumar"
	<dhsrivas@amd.com>
CC: <joro@8bytes.org>, <afael@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <lenb@kernel.org>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <helgaas@kernel.org>, <etzhao1900@gmail.com>
References: <cover.1763775108.git.nicolinc@nvidia.com>
 <a7ebae88c78e81e7ff0d14788ddff2e6a9fcecd3.1763775108.git.nicolinc@nvidia.com>
 <1f65de37-db9f-4807-a3ff-6cd377c855a5@amd.com>
 <aScn9t5ctN7FgRKD@Asurada-Nvidia>
Content-Language: en-US
From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
In-Reply-To: <aScn9t5ctN7FgRKD@Asurada-Nvidia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB76:EE_|MW4PR12MB7118:EE_
X-MS-Office365-Filtering-Correlation-Id: 6207d0a6-74bf-40e0-7773-08de2d078860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YXcraEFZcXowMmNqSjlERjQwUlNZQXdMRXMvNTdmMnRVZGRqL1lqWG1Yc1F5?=
 =?utf-8?B?K3Z4VlFGRG5WNDNxaE5FU0U2R25tVnZHQkhsa0YrN1NZV2dkVE4vd3lBU0ph?=
 =?utf-8?B?bmtDZjUzZXlKbkVqa21nMzBhL0s4ZFB6RzB6Y0NCR1dZbm9BemxNempMY1NV?=
 =?utf-8?B?bGk3Z1M4NWJYK2VyZnNnMGZNM2JDaFJQUE5GR2N4dkZyYjRUZUFDS1hxcjBY?=
 =?utf-8?B?eFpkWXkyTEJ4WWcrQTJjR0RuVHRPejdmcS9CL2FGcjRNM01ZTnpMeWs2ZVVk?=
 =?utf-8?B?V1ArMFR4Wk1UeHdURkVMaFFvOUUwZFRSMVZIQkRzMC9QdkFQNlVHTHJNME1K?=
 =?utf-8?B?ZEhnYVZ3bi9XS3VtWHhLd004ellhUDlJaDhFQm52SzdtbFpGWW9UUUNNVWNm?=
 =?utf-8?B?MmZKZHBpdWx2RjAyVDJOTldra2VZdlpoRDNsbWlST1BBZHhYaklTYmp2RHcx?=
 =?utf-8?B?LytqczEzNXh3VjR0RWhrY1diNDBqN3ZPYUZCWlFyTEFKOWF1Z0RwRnE1VXVl?=
 =?utf-8?B?V29ManpYL1dmbm9GSWdDQVczaEQ0ZnBUWHJ2dGEyRWRoV1luK0ZGZlBXdHlK?=
 =?utf-8?B?ZFZIV252Lzc4MUVBQjJTMTVCNS95SGhlUnVWR1psY1NlYmpUTzFoUkNodkhs?=
 =?utf-8?B?RmpHclFCZUkwdXNpd2JKQXNtOGc1elRJSS9CcVdCbTVpL2U1amcwSW1ZQ3pU?=
 =?utf-8?B?VklQNnJMQjJFcGVXVE1NbXV4RGlqRko1WWxrVVVFNHlyNTNpVHVmL3NteFVX?=
 =?utf-8?B?Nll6Mk1MeHNSUXMrdmtNQ2UvcEhUbXU4TEhMNVBXZnd0dXpCQXZNWitxQ0Rh?=
 =?utf-8?B?TXo5Q3YvSG4weERxSkpZbXZWV1c1ZGhQR0RlMDhBVXBpVlliL2FYa08rYy9L?=
 =?utf-8?B?ai9vZjhGUktCSm5uMWUwc0p6b2dlMDNqS3U5SzBoazhyS1VQZktjbWVUMVQz?=
 =?utf-8?B?QWgxdVJOTTRXejRobVVGNEdJYk1VU2RiOFd1L0pTTDFJNGdSK3hDNE9WYjQy?=
 =?utf-8?B?T0UzMVJVKzNMVHIrVEU2UitvYXp3YmNBMkNNYzZ4NmE3Y3pKdXJxQldBcTlK?=
 =?utf-8?B?R0U2WGplME9HajVTZ0NFaEFwa3BxTTh0cUlOWXpYelVIS0o5M3BxaXU0TnBO?=
 =?utf-8?B?Y09RN3RiYTV6elVOZmNpajFtTkJtRFJLVE50enFpNlQ4RmpEMHF3ejdnZXdx?=
 =?utf-8?B?S1FRSmxkcjJxN2tGeGdDaGhlUk4zWDFIZnlsUTg2MjNxV1NHaFpLYzdRZVJK?=
 =?utf-8?B?d09IOXFoV0U4MWJDZU1vSlpFTEo1ZjJxNG56Vkdua1JQT3RCYllxU1RSV2Q4?=
 =?utf-8?B?V3FjSWoyNk1GakpZR1NjMnFJL0RzTlRSVXBobld6WjRaN25YVWFMSFJ3dXFO?=
 =?utf-8?B?N05KRE5WOHNxSzhzV052SHJhMStaUXZmZUJJbGlnZlFzbWcyak5PcWtEa2pu?=
 =?utf-8?B?RzFWbFV2UElLNk9Vdm05VFZJV2hKS01pWDlMbk4rQ09tcWlDWTlPaXZzSlgw?=
 =?utf-8?B?RWlPUVZwLzJ4ekhKY3UyckNFVTRMdWd1RE9jZzgyT2F2R296UkV2THZyS0pj?=
 =?utf-8?B?MStTeVNDK1J3RGlmVVk2b0hQNEdueHd3SC9DREJycEZJdmsyVXk1MUszbmZH?=
 =?utf-8?B?S2RxaldNWDVTSkpFcjF3V1ZvbS9lemNVZHdoUWk5dTVscTNJSzBYc1h6akF3?=
 =?utf-8?B?RjVsL0ZvT3JBMHRQQVQrb2x2OFA4ayt2MDlmanh5TXBSNGZQS2laZE1KSUda?=
 =?utf-8?B?cVpjU0RhNW9WcE9ZOHd1UlYvSnJzRjNFY1JMU25uKzBSRVpLNE1wdC9ua25v?=
 =?utf-8?B?WGZ2RU1CdDR2MStrSVdoMG1wRm9WdXZpTURDMjR0TmRnVmJ1V0FOcU1JUHF6?=
 =?utf-8?B?NDR4NUNMbGtTMkpQNGpHNE45SjBaUGFLN2M1dU9scmVJaWxQbldONWw0R2g0?=
 =?utf-8?B?R0dxQ3VGY2laa09ZZHF4eXlmMWNvdlhIUEZMK05ockNlTmhCbmpiY1U4WVpR?=
 =?utf-8?B?RWNoem14cjJpa2VTK2lFNEh6OEhYOWdLMjRqNHErQnM0ZU9CUGdhSmpZQ1dC?=
 =?utf-8?B?UVJubVVLZVZ0MlR5d1hRdEtPZEpUUWI5T0RRRm14cnZsRUoydURXaFNVS1B0?=
 =?utf-8?Q?b3E0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 16:19:10.8788
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6207d0a6-74bf-40e0-7773-08de2d078860
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB76.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7118

Hi

On 11/26/2025 9:46 PM, Nicolin Chen wrote:
> On Wed, Nov 26, 2025 at 06:25:34PM +0530, Srivastava, Dheeraj Kumar wrote:
>> On 11/22/2025 7:27 AM, Nicolin Chen wrote:
>>> The iommu_deferred_attach() function invokes __iommu_attach_device(), but
>>> doesn't hold the group->mutex like other __iommu_attach_device() callers.
>>>
>>> Though there is no pratical bug being triggered so far, it would be better
>>> to apply the same locking to this __iommu_attach_device(), since the IOMMU
>>> drivers nowaday are more aware of the group->mutex -- some of them use the
>>> iommu_group_mutex_assert() function that could be potentially in the path
>>> of an attach_dev callback function invoked by the __iommu_attach_device().
>>>
>>> Worth mentioning that the iommu_deferred_attach() will soon need to check
>>> group->resetting_domain that must be locked also.
>>>
>>> Thus, grab the mutex to guard __iommu_attach_device() like other callers.
>>>
>>
>> Tested the series with PCI reset on PFs and VFs, including device
>> pass-through to a Linux guest. All scenarios worked as expected.
>>
>> Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
> 
> Thanks for testing!
> 
> Yet, this is replying to PATCH-1. So, you might want to reply with
> your "Tested-by" tag to PATCH-0 :)
> 

Sure.

Thanks
Dheeraj

> Otherwise, default B4 command might miss your tag in other patches:
> 
>    ✗ [PATCH v7 1/5] iommu: Lock group->mutex in iommu_deferred_attach()
>      + Tested-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com> (✓ DKIM/amd.com)
>    ✗ [PATCH v7 2/5] iommu: Tidy domain for iommu_setup_dma_ops()
>      + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)
>    ✗ [PATCH v7 3/5] iommu: Add iommu_driver_get_domain_for_dev() helper
>      + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)
>    ✗ [PATCH v7 4/5] iommu: Introduce pci_dev_reset_iommu_prepare/done()
>      + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)
>    ✗ [PATCH v7 5/5] PCI: Suspend iommu function prior to resetting a device
>      + Reviewed-by: Jason Gunthorpe <jgg@nvidia.com> (✗ DKIM/Nvidia.com)
> 
> Thank you
> Nicolin


