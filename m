Return-Path: <kvm+bounces-52691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9620FB08457
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 07:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D5993A4679
	for <lists+kvm@lfdr.de>; Thu, 17 Jul 2025 05:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E0F2036F3;
	Thu, 17 Jul 2025 05:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ArIEIf45"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DE62904;
	Thu, 17 Jul 2025 05:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752730757; cv=fail; b=qb51BorxyZpuRGJVwQgg8nw01Y+uPm7Z1Gu8hVnHsIO4BY26vYiQh2cA5U39a6SUrSn4v3NSpuGb2DE89aKTUlLCVONvGZtdjfAXl2mYA3VzD2YS/xKtrb3AVwtM02uzyTrlrudx3R1HI0hFqq2h0X/JLRIvi7i/t03YlSgvooQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752730757; c=relaxed/simple;
	bh=nMWTbNm9Ys+9cSkQTTbPGFXIe3IMj/tBq1nCLidwGGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XlmggW1IsXcORSQDfOwo0P7ZaipjcF/2hKoNNp/gE1nzciq8cOYDyWhRtG+OIuBWEnxGlCv6devmD8SnPHtlCW75E+pfBeE3Y4Tw7bWTB+qp6FVXlnWxk6Ug3QPjqqP4fXZqvLAv9vxTauHaDXrhgv8rConF5WjM7RYekEZcZFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ArIEIf45; arc=fail smtp.client-ip=40.107.243.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g81px8pDd/q+o0baVM7KPxA1J2TAfB2Eg5ZnU1sPaCjcKZlH81uDjDGJ1qyku5pCEtbkHkwNrR+E93TIyGIY0uwL2NE2ajyWaQS0iKLSpjj5OPLmEAXzNSdgWWYOQ24WiXOgifECEktLBN0xwu9CP6z9YxroscS9Cz4/dq9UAK98eZdI0Srd1J05gcFq9RmqkhZahiZnAzjPuKTSNvAw0KztT5hbYo2fMgSta0wVTwwLOMuvfZLjigm+C0uxCG+xSbU9tde1KaolbOQWsbybFyMh/DLGvPFQHohnWmksjFNUyKgcyR1zMR83AlGuvhUB0QFRfF+NDE5LjbaM7zJJjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hfCkc2H61i4PKLWoP0JFC0GTOi1tr8c6nWWmKdCm5aA=;
 b=FNmdHsC7lxmrf4ZKR6RjO3XbgpGn/SMCn+TMpsORD00BBJ2WbRs1b8TUZTSmUc4Ul4G6s9ZB6j6e+I2wzqj61oKIUJhTmo0ivQqJhk/kHrx5E/344duhuKXdP21C+W4mTWxf6WxnQrL9lELtJM3YDu5Yl66MPNz11J1EtnYnx91QeM6/RHHsrDu9KRjBGmPXq+MM2JOyKgaCne6sbdoNxg4TwpGLzMcS1/jMedUlLjFUTydzGwRNbdimiayc+XDrFKdTCdpMoFrAMNw1CRb8f+ZooMFt7Rx22q8pb0OPIF3Df2BtUGqHgMWCc4akSvhFBL8d+cLaVovKSmYwTG/UqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfCkc2H61i4PKLWoP0JFC0GTOi1tr8c6nWWmKdCm5aA=;
 b=ArIEIf45JI50RP/DmqvQhCrHbpzlQCit8fnAskrEwvjUft9tLJyp6PhGZLdtcUNAg9wVN105GlWdZ2+lbxMnO6vQSrIGKGYEueO4xQagZ5nm9253tyLTdrM0zSnY1dqPvcqEHHyCb5IZH8gf9z1cYnem8CinvN3HeA1pZOxOtTY=
Received: from CH5P222CA0023.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::11)
 by IA1PR12MB6652.namprd12.prod.outlook.com (2603:10b6:208:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 17 Jul
 2025 05:39:08 +0000
Received: from CH3PEPF0000000F.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::4c) by CH5P222CA0023.outlook.office365.com
 (2603:10b6:610:1ee::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.20 via Frontend Transport; Thu,
 17 Jul 2025 05:39:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000F.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8943.21 via Frontend Transport; Thu, 17 Jul 2025 05:39:08 +0000
Received: from [10.252.206.76] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 17 Jul
 2025 00:39:01 -0500
Message-ID: <8869fcdb-5a4a-45c7-a1ff-1ade5b85097d@amd.com>
Date: Thu, 17 Jul 2025 11:08:58 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] iommu/amd: Reuse device table for kdump
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Vasant Hegde
	<vasant.hegde@amd.com>, <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<bp@alien8.de>, <michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
References: <cover.1752605725.git.ashish.kalra@amd.com>
 <42842f0455c1439327aaa593ef22576ef97c16ee.1752605725.git.ashish.kalra@amd.com>
 <7db3a4b2-dff6-4391-a642-b4c374646ca7@amd.com>
 <7f08c03f-a618-4ea4-ab57-f7078afe49c9@amd.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <7f08c03f-a618-4ea4-ab57-f7078afe49c9@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000F:EE_|IA1PR12MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: ac5bb09c-c490-4f91-f499-08ddc4f44055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UmlXdnpRQTJWbnB1VUR6VkVDMmM3d2E3cmlraFhRb2NzTTZkR1Mya2ROREdM?=
 =?utf-8?B?UVFVSmFMcHJORHBuNmVvZ0htREhtcmpReWhIRktqa3hsVzloZGtoUks0THVC?=
 =?utf-8?B?cUJqL1dobmZQazhMcHlXN3N1cG5PTHdGVStVZFlNZ3BVWG9wU0RMei93aDRP?=
 =?utf-8?B?bmlkai9mNE9jbDk3RC82M0NEYUJJK2dmWTFtMCtyOFpJRzBlZmNrMDJDQXZ4?=
 =?utf-8?B?YjByRktnVUhpS3FDMHhMZEFsaGlONHhpeVRoK3MrS2ZLUzluOG5pcGFnc01I?=
 =?utf-8?B?WVNudUk1UHZXYWU5cWlCQ0F2bVZ3blR2T0FpblczTThPVkZDWUg0TVk1VnF0?=
 =?utf-8?B?aTV6U0Rva1EwNVRwTytaeWk2NTYzV3hwaWR0UElBQ0RCTHlqbjhCdnU3SUNm?=
 =?utf-8?B?STZUZElQWWlEOUNsV1JXdHFlYUZMZmY0cGpYTDRUWGYxQXROZitVdEpqeWhP?=
 =?utf-8?B?MEJQSUNxbC9mMmFjRjRXbFNhNGVhbENpYUh5b3RsQVlXTk5nSjJCSURobUx0?=
 =?utf-8?B?QlFtTHR0OWNsYlZYLzNPYmIxZU96SE9FKzZNUUthbFpiYVlQRDl3dVpLcFZt?=
 =?utf-8?B?QjI2bnVpS002RERRc2NmSHdtaVQvNXN1RHlGOUg0Y1o2eFZCMWc0dDhiM1c1?=
 =?utf-8?B?SUhNK3ZQSm1wb0JkTC9MNW84QXNjSllVTXVRU0VNK1l4WndBSEt2WXo3eHFs?=
 =?utf-8?B?aEZESEdqNFU5VTNGUURUVWhFam9DZXdQa1dodVlMRnFhelJXQ1h5bGV2aVFq?=
 =?utf-8?B?Q3pGcll2RHpjeGRVS2YzOFNrWndNbittVGd3Vnk5T1liWGhIWkRRRHlwUzlC?=
 =?utf-8?B?a0tuakdLbXFKck1lUkRkc1p5ZEx5NFFkME9qRW9RdHFUQlJLWTZMNzE2Yncv?=
 =?utf-8?B?dmMwVk9lYkJXNGVibmtvOVlmaUNSM1ZBQk1VYmhBcE5Qa3hPQUw0M0ZYOGU4?=
 =?utf-8?B?bnYxTHZpR25iWkVXUnFzU0k4aHdRaDN4SUFXelFXNjlHT0cwdDc5aGM4MEcv?=
 =?utf-8?B?QnA5Tm0vS2N0VzFOa2k0NjJUTGR6bms0cWtneEdmSVN5YU8zclA3clN2QmRi?=
 =?utf-8?B?dy9RM1Zka1cwRVNLcGJWOHJTZ2pMTGJIV1ZZZ2RVRW9oRFBCVW4vVEJWelo5?=
 =?utf-8?B?ZHllZ3MrWGdBL3ZPdDNoaytjRi84NU9TbjZHZjVBa0djRXI5Zmc5VWpZVHRQ?=
 =?utf-8?B?NVdZNDc0dUZycmtuLzREUjVORUp2M2ZFSUR0VnJjam4rOEU2MnhSZmF6RkJI?=
 =?utf-8?B?bUVZbmlSRExhcm9rSmkwVXFkUUlMQ0FmQmsxRXFMYVFSazV3L2Y5VUIvMVRn?=
 =?utf-8?B?d3lqTnNiYlFlUWRPRVNWenJrUUJqWkZlY3VrREdRd0FlbHZRbHpoOXkyZk53?=
 =?utf-8?B?K1RKZWRCVGhlVmUySzB6RGhYTTNGUGliS0xsSVRGTjJMSWVIOFVuaUFhSGNr?=
 =?utf-8?B?UVJ4WUU3QVFKS29JeU9HTXV5SFdyWjhEQUhyVXRYT3hDZ2tXOU84bjhZTnNN?=
 =?utf-8?B?WFRHa3NxZWFpUzZ5TjNuQnRYdDF6dGp0Z1hJOUsyWFpRY2ZNeEU2ZXRzaEtn?=
 =?utf-8?B?TCtTRUZvZ2pKUzd5R2ZRdDJRTTBDcUJhOEoraVlER3ZQdE9zbWhFOCtOdnFt?=
 =?utf-8?B?TDNTVVpaTGU2TnRjL0VlQkZzbFFsOGdwakZrTTNjSGExRWovcFI0U3pJRE9h?=
 =?utf-8?B?UG02K283elZwa2hUVzRUS1RuejZuMyt5QS8ybXZDZ1NRRmVWR2RwQmk5QnNz?=
 =?utf-8?B?ZnBjWEd1RXRMakVYSHltL3c5MmFNZHh3OG51bDBKZ29XQnNqSlJleHgzNlVz?=
 =?utf-8?B?Mjlkd1gvUE5OcGFydjNCWWt5OGpvNFdseVZHQXp4dGF2UWwzN2hHTHNENTll?=
 =?utf-8?B?MDE4bjVadzBuWk1MT2JBNXloMkJrcFpwRUM4TE5MWEcwcDZ3d09IVkFDTElu?=
 =?utf-8?B?MFBaZk1sVVd5dG56bm0zeDQ5cDBvVDNSNHFwSWJNRTZCNE9NeHY4NmF5UGhz?=
 =?utf-8?B?aHdpL0ZiVUtrUkxoRTQ4ekVqMjZvRlVHM3hsS0FEVWtNL1ZrYmtKTVZwSnZw?=
 =?utf-8?Q?lzy2zc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2025 05:39:08.6391
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac5bb09c-c490-4f91-f499-08ddc4f44055
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6652



On 7/17/2025 3:37 AM, Kalra, Ashish wrote:
> Hello Vasant,
> 
> On 7/16/2025 4:42 AM, Vasant Hegde wrote:
>>
>>
>> On 7/16/2025 12:57 AM, Ashish Kalra wrote:
>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>
>>> After a panic if SNP is enabled in the previous kernel then the kdump
>>> kernel boots with IOMMU SNP enforcement still enabled.
>>>
>>> IOMMU device table register is locked and exclusive to the previous
>>> kernel. Attempts to copy old device table from the previous kernel
>>> fails in kdump kernel as hardware ignores writes to the locked device
>>> table base address register as per AMD IOMMU spec Section 2.12.2.1.
>>>
>>> This results in repeated "Completion-Wait loop timed out" errors and a
>>> second kernel panic: "Kernel panic - not syncing: timer doesn't work
>>> through Interrupt-remapped IO-APIC".
>>>
>>> Reuse device table instead of copying device table in case of kdump
>>> boot and remove all copying device table code.
>>>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> ---
>>>   drivers/iommu/amd/init.c | 97 ++++++++++++----------------------------
>>>   1 file changed, 28 insertions(+), 69 deletions(-)
>>>
>>> diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
>>> index 32295f26be1b..18bd869a82d9 100644
>>> --- a/drivers/iommu/amd/init.c
>>> +++ b/drivers/iommu/amd/init.c
>>> @@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
>>>   
>>>   	BUG_ON(iommu->mmio_base == NULL);
>>>   
>>> +	if (is_kdump_kernel())
>>
>> This is fine.. but its becoming too many places with kdump check! I don't know
>> what is the better way here.
>> Is it worth to keep it like this -OR- add say iommu ops that way during init we
>> check is_kdump_kernel() and adjust the ops ?
>>
>> @Joerg, any preference?
>>
>>
>>> +		return;
>>> +
>>>   	entry = iommu_virt_to_phys(dev_table);
>>>   	entry |= (dev_table_size >> 12) - 1;
>>>   	memcpy_toio(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET,
>>> @@ -646,7 +649,10 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
>>>   
>>>   static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
>>>   {
>>> -	iommu_free_pages(pci_seg->dev_table);
>>> +	if (is_kdump_kernel())
>>> +		memunmap((void *)pci_seg->dev_table);
>>> +	else
>>> +		iommu_free_pages(pci_seg->dev_table);
>>>   	pci_seg->dev_table = NULL;
>>>   }
>>>   
>>> @@ -1128,15 +1134,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
>>>   	dte->data[i] |= (1UL << _bit);
>>>   }
>>>   
>>> -static bool __copy_device_table(struct amd_iommu *iommu)
>>> +static bool __reuse_device_table(struct amd_iommu *iommu)
>>>   {
>>> -	u64 int_ctl, int_tab_len, entry = 0;
>>>   	struct amd_iommu_pci_seg *pci_seg = iommu->pci_seg;
>>> -	struct dev_table_entry *old_devtb = NULL;
>>> -	u32 lo, hi, devid, old_devtb_size;
>>> +	u32 lo, hi, old_devtb_size;
>>>   	phys_addr_t old_devtb_phys;
>>> -	u16 dom_id, dte_v, irq_v;
>>> -	u64 tmp;
>>> +	u64 entry;
>>>   
>>>   	/* Each IOMMU use separate device table with the same size */
>>>   	lo = readl(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET);
>>> @@ -1161,66 +1164,22 @@ static bool __copy_device_table(struct amd_iommu *iommu)
>>>   		pr_err("The address of old device table is above 4G, not trustworthy!\n");
>>>   		return false;
>>>   	}
>>> -	old_devtb = (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT) && is_kdump_kernel())
>>> -		    ? (__force void *)ioremap_encrypted(old_devtb_phys,
>>> -							pci_seg->dev_table_size)
>>> -		    : memremap(old_devtb_phys, pci_seg->dev_table_size, MEMREMAP_WB);
>>> -
>>> -	if (!old_devtb)
>>> -		return false;
>>>   
>>> -	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
>>> -		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
>>> +	/*
>>> +	 * IOMMU Device Table Base Address MMIO register is locked
>>> +	 * if SNP is enabled during kdump, reuse the previous kernel's
>>> +	 * device table.
>>> +	 */
>>> +	pci_seg->old_dev_tbl_cpy = iommu_memremap(old_devtb_phys, pci_seg->dev_table_size);
>>>   	if (pci_seg->old_dev_tbl_cpy == NULL) {
>>> -		pr_err("Failed to allocate memory for copying old device table!\n");
>>> -		memunmap(old_devtb);
>>> +		pr_err("Failed to remap memory for reusing old device table!\n");
>>>   		return false;
>>>   	}
>>>   
>>> -	for (devid = 0; devid <= pci_seg->last_bdf; ++devid) {
>>> -		pci_seg->old_dev_tbl_cpy[devid] = old_devtb[devid];
>>> -		dom_id = old_devtb[devid].data[1] & DEV_DOMID_MASK;
>>> -		dte_v = old_devtb[devid].data[0] & DTE_FLAG_V;
>>> -
>>> -		if (dte_v && dom_id) {
>>> -			pci_seg->old_dev_tbl_cpy[devid].data[0] = old_devtb[devid].data[0];
>>> -			pci_seg->old_dev_tbl_cpy[devid].data[1] = old_devtb[devid].data[1];
>>> -			/* Reserve the Domain IDs used by previous kernel */
>>> -			if (ida_alloc_range(&pdom_ids, dom_id, dom_id, GFP_ATOMIC) != dom_id) {
>>> -				pr_err("Failed to reserve domain ID 0x%x\n", dom_id);
>>> -				memunmap(old_devtb);
>>> -				return false;
>>> -			}
>>> -			/* If gcr3 table existed, mask it out */
>>> -			if (old_devtb[devid].data[0] & DTE_FLAG_GV) {
>>> -				tmp = (DTE_GCR3_30_15 | DTE_GCR3_51_31);
>>> -				pci_seg->old_dev_tbl_cpy[devid].data[1] &= ~tmp;
>>> -				tmp = (DTE_GCR3_14_12 | DTE_FLAG_GV);
>>> -				pci_seg->old_dev_tbl_cpy[devid].data[0] &= ~tmp;
>>> -			}
>>> -		}
>>> -
>>> -		irq_v = old_devtb[devid].data[2] & DTE_IRQ_REMAP_ENABLE;
>>> -		int_ctl = old_devtb[devid].data[2] & DTE_IRQ_REMAP_INTCTL_MASK;
>>> -		int_tab_len = old_devtb[devid].data[2] & DTE_INTTABLEN_MASK;
>>> -		if (irq_v && (int_ctl || int_tab_len)) {
>>> -			if ((int_ctl != DTE_IRQ_REMAP_INTCTL) ||
>>> -			    (int_tab_len != DTE_INTTABLEN_512 &&
>>> -			     int_tab_len != DTE_INTTABLEN_2K)) {
>>> -				pr_err("Wrong old irq remapping flag: %#x\n", devid);
>>> -				memunmap(old_devtb);
>>> -				return false;
>>> -			}
>>> -
>>> -			pci_seg->old_dev_tbl_cpy[devid].data[2] = old_devtb[devid].data[2];
>>> -		}
>>> -	}
>>> -	memunmap(old_devtb);
>>> -
>>>   	return true;
>>>   }
>>>   
>>> -static bool copy_device_table(void)
>>> +static bool reuse_device_table(void)
>>>   {
>>>   	struct amd_iommu *iommu;
>>>   	struct amd_iommu_pci_seg *pci_seg;
>>> @@ -1228,17 +1187,17 @@ static bool copy_device_table(void)
>>>   	if (!amd_iommu_pre_enabled)
>>>   		return false;
>>>   
>>> -	pr_warn("Translation is already enabled - trying to copy translation structures\n");
>>> +	pr_warn("Translation is already enabled - trying to reuse translation structures\n");
>>>   
>>>   	/*
>>>   	 * All IOMMUs within PCI segment shares common device table.
>>> -	 * Hence copy device table only once per PCI segment.
>>> +	 * Hence reuse device table only once per PCI segment.
>>>   	 */
>>>   	for_each_pci_segment(pci_seg) {
>>>   		for_each_iommu(iommu) {
>>>   			if (pci_seg->id != iommu->pci_seg->id)
>>>   				continue;
>>> -			if (!__copy_device_table(iommu))
>>> +			if (!__reuse_device_table(iommu))
>>>   				return false;
>>>   			break;
>>>   		}
>>> @@ -2917,8 +2876,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
>>>    * This function finally enables all IOMMUs found in the system after
>>>    * they have been initialized.
>>>    *
>>> - * Or if in kdump kernel and IOMMUs are all pre-enabled, try to copy
>>> - * the old content of device table entries. Not this case or copy failed,
>>> + * Or if in kdump kernel and IOMMUs are all pre-enabled, try to reuse
>>> + * the old content of device table entries. Not this case or reuse failed,
>>>    * just continue as normal kernel does.
>>>    */
>>>   static void early_enable_iommus(void)
>>> @@ -2926,18 +2885,18 @@ static void early_enable_iommus(void)
>>>   	struct amd_iommu *iommu;
>>>   	struct amd_iommu_pci_seg *pci_seg;
>>>   
>>> -	if (!copy_device_table()) {
>>> +	if (!reuse_device_table()) {
>>
>> Hmmm. What happens if SNP enabled and reuse_device_table() couldn't setup
>> previous DTE?
>> In non-SNP case it works fine as we can rebuild new DTE. But in SNP case we
>> should fail the kdump right?
>>
> 
> Which will happen automatically, if we can't setup previous DTE for SNP case
> then IOMMU commands will time-out and subsequenly cause a panic as IRQ remapping
> won't be setup.
> 
> So this is as good as failing the kdump, which will have the same result.
> 

Maybe we can have a BUG_ON() when it fails to remap the DTE in kdump
kernel and SNP is turned on ?

Its hard to understand why kdump has failed just by looking at
completion wait timeout. Will be easier to debug with BUG_ON().

> Thanks,
> Ashish
> 


