Return-Path: <kvm+bounces-43175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 601E2A86404
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 19:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E23991B86FD1
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 17:05:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED418221DB2;
	Fri, 11 Apr 2025 17:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IDos/jps"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8B9221FAC;
	Fri, 11 Apr 2025 17:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744391042; cv=fail; b=TCNHbsG4L45a4Eq8q/eNzyzBchOv2nyHu7ecRDM6UKEDMBa9YIpx18tKsEMM65MbHxsFb1mwRis9x/vf/GvgsHKva0nducd3SAQI6/278XYuUU9OePyzpoxvZ24YTA/bVqibLC9TVI1K4yUQ4YDPI3iUnDiL1RwBj6kkvSGca98=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744391042; c=relaxed/simple;
	bh=+/5nbMo84YFUzHIDL5MK5g/7AdD4jg4sEaigF2TADGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sCS/YyPkGCZhtU86bA1hwG+Hu8sgYI8yEQ3K9DuSNRjGblPyK0yh7Rp8lIs9nggLc48YZhPBO5sqFut9NquMJhSmOddG7vKMGWLUyGjXSETeAgfmenqIKWk87J+Trm51JbDAXr17i2qHFNKsBBNzkODaOklDMMbx+53CK6X4ZFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IDos/jps; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydw6XgwtSFSW+08enil4XjJpJmCyRT4ar5Z6ndAezZB8YdlvLOZZPlHl6z6DSmGqY+kDTgh2ErNtjsuaPufM6ziGnBr/nYnYl/bqWkrUpkg6ovr0+D4sMnZHdvXbNrcNKv00GPdHVNF9tfiKLl4aMaRrMRFz2Lb5Ro2LB0nmMMwWKHJjG5a6OZyViaJGTcUUWB20SSz5KHAmNCQY0HzzeSQGwvBeXJjZg/BifxMYAemRaIjPuY4A6IT80j8Uh+NfI5Yl9vJPc/c2gyLICmqGbtahK7iqFE0CIFeHH5fdc096fprAT05zOI0MFISlKLzqZ5XkPQUYGjYnMiY+jDyTBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x4YmLYesgLEO3iHqb4o7Xe6xtPqoLcuXBhCeNywPIWs=;
 b=oOUXiYh/ZnxoHngtrMr6MGRN5LHIc75Qj0pjkFXC15E3zv0gRuwGW0KGAns4UVCHtsFIgj26JKqGG1nxGOmr6MdXP+AMdrIFJgsvGGN7N3Z0XXsXtIaXqSTmW+wEQ559A1KpCvoxPTWe+4eMBaNcOV/5jDiB6rz2fgyfrwotlkwnEFuBJtBEKdVlP6N4pGamzB6Ba5Nqq1dwUGtn/9s6FAUj4/YZRqbO8D92bS7SfgOCJUbfIaODL4Pdmb+zjmxG2sunvvw8+FsF/K+Wk8+CaDufffJfyeWpkaMusIFWg5Y9Eu+dbJAjKQYyeS50qCu6l3MRyMJJx9gc0nWutK0BkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x4YmLYesgLEO3iHqb4o7Xe6xtPqoLcuXBhCeNywPIWs=;
 b=IDos/jps9GwwSJSz5TEAonnzRh2PfWWRQKv9SyBgPVb0gax6dHuvClVt/hqXa67gY+auXUMCzG4X2xjziAiyepncl/W1lufPXvZ5GBVtHySXGwVRBr/6tWrEkb2nwBgAnlhfqA38sO8HnAqf451RtLCABsd+4Az5WzipDuwPIyQ=
Received: from CH2PR08CA0017.namprd08.prod.outlook.com (2603:10b6:610:5a::27)
 by DS2PR12MB9566.namprd12.prod.outlook.com (2603:10b6:8:279::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.27; Fri, 11 Apr
 2025 17:03:57 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::54) by CH2PR08CA0017.outlook.office365.com
 (2603:10b6:610:5a::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.26 via Frontend Transport; Fri,
 11 Apr 2025 17:03:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Fri, 11 Apr 2025 17:03:56 +0000
Received: from [172.31.190.189] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Apr
 2025 12:03:49 -0500
Message-ID: <97a694f4-322c-41ef-a3e7-c61fb867f6d6@amd.com>
Date: Fri, 11 Apr 2025 22:33:41 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/67] iommu/amd: WARN if KVM attempts to set vCPU
 affinity without posted intrrupts
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
	"David Woodhouse" <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	<kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>,
	Naveen N Rao <naveen.rao@amd.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-7-seanjc@google.com>
 <0895007e-95d9-410e-8b24-d17172b0b908@amd.com> <Z_ki0uZ9Rp3Fkrh1@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <Z_ki0uZ9Rp3Fkrh1@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|DS2PR12MB9566:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d302341-4241-4f25-1e1a-08dd791ad8c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dGVLMmFnSWFtOU9vRTgrNlM3VGVteGR0Wnd3SEpST3hCVmRXdjJudldTRklu?=
 =?utf-8?B?Z0NHbkYxd3RjUG1rVUN2VXY1YWRqT2x0dy9VR1hSUjdOOU85M3JFcjJ1Q3J4?=
 =?utf-8?B?YXNTeEFlVkFicE5WM1VhQlMra0d3Qi9oZXpkRExHNWZ3b3cxOUNMQWtnSENv?=
 =?utf-8?B?cHlOeUMyR2NDbDNZNlZERnY5c0MxbVdISWJuNDYvdTBHYXZKRmxWUlZFTHI0?=
 =?utf-8?B?cmxjR1QrTzVHWGd6cW4wY2g1cU0xRWJqeWY3cit5cjdhSjhUakZud2pkMHha?=
 =?utf-8?B?am5VcFJ4NmU4WEhidDJzcjBwbEZIcE92MDZTZU83TUVDbGhEOWcvQ1YvZlp6?=
 =?utf-8?B?R1dGb1BuM1BsV0xUWEJXYzJDcTdVb0d2RnJvT3ppeEtyazBVdnpSVFFMMVV4?=
 =?utf-8?B?V1A4RG0yNFF4YWpFeDRyU2tnYnNPbExOK0poWldvL3BYczVnRnNRNFFkWnh5?=
 =?utf-8?B?R1Fsb1E1TUY5V3p6Y2tXWWdKeWVnZ1lEaXdzcEEzQWx1N2t1dy9Celh0RkVB?=
 =?utf-8?B?OXd0V285Q1RINjlsWWR0bEUwSGpBM1FmK1RHd0d5VkY2ZW1uK2V6WjJDWTZO?=
 =?utf-8?B?YmFwbDgzOG5QQnJoSkVWVlFrZkdkK0RiZVZvNXBDN3kyL2xtV1A1OVI5Y1o4?=
 =?utf-8?B?YUJRUlNTeEIyNzNYSmZ4TVBlZ1V2bVczblVHazIvVW1kYStJYVFETTFjNXBT?=
 =?utf-8?B?SmVLWUV4SjRCM2pzdEdNd0xneFdiWkhuRG16MStLUjBUZkErQ3BKdm9BTTFi?=
 =?utf-8?B?ZGU0MWZVcDNHZEc3eDFEWWs1bldqYmp6QXR3Z1NqN1Z5MDJZcERHZUZKMlkz?=
 =?utf-8?B?ZDNJNlNPRFhzQytRNjJpVzVSc2pyRllJSGFwK2poNDhuQm9EWkVKNWllSWRE?=
 =?utf-8?B?THpXenRTS1dnYlBmUkMxdVVlTy9WNGRCV2IrZkVlTVk2R3lONjhUY21UQmdB?=
 =?utf-8?B?YUNVRjQ3QWpBbUg5UHVESUxhaHhaOGJjZ2JCVTRxNXlxQU9KL05jaURya2RG?=
 =?utf-8?B?eDVVM1B0M0grOEc3d1RCa0VIQk4yVENUcXM5UmJEVjdoUlB6L3FqQ3RJZEpT?=
 =?utf-8?B?dXZjVS9peCs2ZE1iWUZqWEdwTXIxdUV6VVc0MUZxdGtndlBLT2JGWXJjUG5H?=
 =?utf-8?B?MXl5ZXlYZ1RBS2VjSWhzeDVnQlA0YlIyK2JUb2VNMHI5N3lBMWFFTi9ENnBP?=
 =?utf-8?B?aXA5aUtxdnIyRDRyWFVDZGhrd3llMVJLTnBLN2QrV1lNaGQ3endubmtKc3Ji?=
 =?utf-8?B?OUhSbnZXUSs0VkY2M0RnY0lzcUo0UWhEOE5ORjZJdUxWQ01yc0M2M21QSWhL?=
 =?utf-8?B?c1hZeUErVWV3VnNHUGNSNmJ4MitJRlJISTR3YUZHNTBlaklTREQrQ0dSbnZE?=
 =?utf-8?B?Wmw4RkVNMHliSmR6NEEwYjZFaEc1NFU2eUdjOEdKdUowMFFBc3MzUTdmdUIr?=
 =?utf-8?B?Mi9adWx1b3AwZ0VZSTZNQU1pYUIzN1I1dXI5SDh1VTBiMDVGcE1ZWUpsalE5?=
 =?utf-8?B?YXRvYy9PVm5IN0JMeGpjOVJQUVE1SzcxNlcrWjh4eGVTeGtVRWswZGtSWEVR?=
 =?utf-8?B?clVYMzdZU0FQbmVQVVgxcjlVUHdSOWlVZXA3cUZ6ZUdnMXhSemNJWnJCR25W?=
 =?utf-8?B?dUQ0c0Y2dU9QbmhHOGlqR2xOQWNmWWhKQnlQd0hnWSsvclR3UEJLSFR5emx3?=
 =?utf-8?B?TE1qeklKNkRBa05vVlRPT05TNDdNeWVVZVBvdXlzcnNDeUl0ZmVFaDNNYjVz?=
 =?utf-8?B?ampqS2xrV056ZXYvQnc2RlNDSmsvUGhtZ2tUeHBBZVBON0pvUFluUU1PMzAy?=
 =?utf-8?B?ZENGOFZ0ZGxYcVcvTW1ubVFsYWJvRmY5ckF3OUdHblNZb092bXdaeWR2OGpz?=
 =?utf-8?B?bzUzK3VFRUJ5Q0NXOVpTZHpyU2VxVWJWY0NiUlVmMmRtM2J6NTUrbEMvaGdE?=
 =?utf-8?B?TEZDRlg2SjNtaVdWTmw2N0pXWnlVakhkVkdKZkdYZ3hjMGdsaTBlZjFibExO?=
 =?utf-8?B?ekVRaWNQK01tcXhvK1FMMzhmTFZZeFptUEQrRU50S2s0YUdPM3R5TWg5dzVR?=
 =?utf-8?Q?kNUJuM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 17:03:56.8761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d302341-4241-4f25-1e1a-08dd791ad8c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9566



On 4/11/2025 7:40 PM, Sean Christopherson wrote:
> On Fri, Apr 11, 2025, Sairaj Kodilkar wrote:
>> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
>>> WARN if KVM attempts to set vCPU affinity when posted interrupts aren't
>>> enabled, as KVM shouldn't try to enable posting when they're unsupported,
>>> and the IOMMU driver darn well should only advertise posting support when
>>> AMD_IOMMU_GUEST_IR_VAPIC() is true.
>>>
>>> Note, KVM consumes is_guest_mode only on success.
>>>
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    drivers/iommu/amd/iommu.c | 13 +++----------
>>>    1 file changed, 3 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>> index b3a01b7757ee..4f69a37cf143 100644
>>> --- a/drivers/iommu/amd/iommu.c
>>> +++ b/drivers/iommu/amd/iommu.c
>>> @@ -3852,19 +3852,12 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>>>    	if (!dev_data || !dev_data->use_vapic)
>>>    		return -EINVAL;
>>> +	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
>>> +		return -EINVAL;
>>> +
>>
>> Hi Sean,
>> 'dev_data->use_vapic' is always zero when AMD IOMMU uses legacy
>> interrupts i.e. when AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) is 0.
>> Hence you can remove this additional check.
> 
> Hmm, or move it above?  KVM should never call amd_ir_set_vcpu_affinity() if
> IRQ posting is unsupported, and that would make this consistent with the end
> behavior of amd_iommu_update_ga() and amd_iommu_{de,}activate_guest_mode().
> 
> 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
> 		return -EINVAL;
> 
> 	if (ir_data->iommu == NULL)
> 		return -EINVAL;
> 
> 	dev_data = search_dev_data(ir_data->iommu, irte_info->devid);
> 
> 	/* Note:
> 	 * This device has never been set up for guest mode.
> 	 * we should not modify the IRTE
> 	 */
> 	if (!dev_data || !dev_data->use_vapic)
> 		return -EINVAL;
> 
> I'd like to keep the WARN so that someone will notice if KVM screws up.

Yeah makes sense. Lets move it above

Thanks
Sairaj


