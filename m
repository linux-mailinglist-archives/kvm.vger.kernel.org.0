Return-Path: <kvm+bounces-43174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF82DA8640F
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 19:08:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 502959C4F8F
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 17:03:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C04CC224884;
	Fri, 11 Apr 2025 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="twlpzZrD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9042206B1;
	Fri, 11 Apr 2025 17:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744390952; cv=fail; b=kwIc7biBbk9nHLJ2uLOvtsM7EbrRm/vSV15rIz6nsjfmP3pB27fF5yE/cFoPbAvyfimQvkO4jZead5LAbQnIN/+qUYGcr+AnovhT3eemm9oluCHXKLAnn19KzMAmj6tU/dmE8PDNetOofCNtsspi+ay/dffVY1QM2XOlfd7QixM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744390952; c=relaxed/simple;
	bh=+Yz40TQa5XWzUhplvCyh7ZyMr2dMSkBfIGLT36eopCY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=IXHGab9Ilak3u+E5weQIzq4FIYKkQHswtMnOkkL7Q1oBmHSc0EswkXVSOxdWR89v5ZbqxEtIyNiiVKKLyhzcYdbyt24QiVZ90bLm5+sN/HNUS+8NORcx77Qv+aMT16+K8SLkC/J93dI9HQgGEsdeLA5dMCfob+kNglY90AKKNhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=twlpzZrD; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hnLVTIdOWpx9ME7vqfCT2MpyTvuY8xUgi+A0XJeIY/ggFZRbPMFfJt/LplbintcTPTfQyCewaAoARvTxEzNTGkB5Kf9f0EUBM/bJretVT3UXb+hXI7IDN49akI+Zr1BBSYabMPRFNNdsAxGV/Ri77ZHkgWoP7y5EH4BhZ/Z52un+IQyubblzlZBmPqAkdAsqC3Q83lk1EULEOiTPTvNPpx+Je3d659I/wcabqySKu9xh6UNngpTMtsA8s7yrhSWg6psoSws90RSP3f9UbWTwiEWJl1MTdmZuvbpRJs/fQJm5iM/T9hpghbp0U7dozySlxPJl43MF5N11x/uT+M1FYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sD43QcVxcPbkFfORw48Zt1b/vMEkkan96vL2cdzhU44=;
 b=g+1AWS8mYW+Yelt0TUy6PXGr2wTwprEZhM+tIYUqq6ef/Xr2JhdNazsVe1p7vhqRJU2UNx7CRFcpvnfUbVgMDRYBzYJgC8HYsXSpRy4pQxTRRnWBSnN4HwDZTsl42g2Rjl9RS0UbxE016VkYMBXhGNDSdfkhTLIL5fFZJFzJLXMuLU1bN+34PFg8kLIasrJBhzXPtjEiuX6fi0akg5FtneJu6Rq6EYsM34klscTI90D0uCZjWSL4K6PU/Wu/CD3f9R3EUh26VZgIOlvjl6RCjSIIEJZGlhpiBwYtMsyUtnrKSVC1+946kMhk3hkVpVNm8LpZg/LKrE4RZ6AYpoa10A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sD43QcVxcPbkFfORw48Zt1b/vMEkkan96vL2cdzhU44=;
 b=twlpzZrD2sTaAdb5YSPMQ6P4IbNByVpvy08Zsm3t234FxBPMZy5FxOBfbWyGr6Di5m/bIDtKnO0HgbzTHd4NtcuzHjnUxH9A9SlSEZsLQTqVxcsg4yBjjIL7pKl/FP4ULUqYvVsSJa/Rp/JziB5dDm+SykajGN1Z41Y9i3Z+Ds8=
Received: from CH2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:610:5a::33)
 by SJ2PR12MB7943.namprd12.prod.outlook.com (2603:10b6:a03:4c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.40; Fri, 11 Apr
 2025 17:02:23 +0000
Received: from CH3PEPF0000000C.namprd04.prod.outlook.com
 (2603:10b6:610:5a:cafe::9a) by CH2PR08CA0023.outlook.office365.com
 (2603:10b6:610:5a::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8632.26 via Frontend Transport; Fri,
 11 Apr 2025 17:02:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF0000000C.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Fri, 11 Apr 2025 17:02:22 +0000
Received: from [172.31.190.189] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Apr
 2025 12:02:18 -0500
Message-ID: <304df156-0374-4e43-b261-754b438e937b@amd.com>
Date: Fri, 11 Apr 2025 22:32:15 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/67] iommu/amd: Return an error if vCPU affinity is set
 for non-vCPU IRTE
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
	"David Woodhouse" <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	<kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>, Naveen N Rao <naveen.rao@amd.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-6-seanjc@google.com>
 <686dced1-17e6-4ba4-99c3-a7b8672b0e0d@amd.com> <Z_khsNAbh4kIhKVC@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <Z_khsNAbh4kIhKVC@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF0000000C:EE_|SJ2PR12MB7943:EE_
X-MS-Office365-Filtering-Correlation-Id: f9aad40c-2a00-4357-4682-08dd791aa0e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T28xZjQ0Ykx5UUxReUlpU3lhSUFZZERlWTc0U3ZlbUtyaGxZYllRazlmTEpT?=
 =?utf-8?B?WC9ydnI4cDNkZnQ3anNzRlZOcnRSWjcyKzdaQnFpNU45YVh0UnVNeFhXb2du?=
 =?utf-8?B?N0Uyeldnd21lb05qaGxIUG1QdXVLZGgwUVJjQmFQeVFMdmVsVmoxQytNTGJQ?=
 =?utf-8?B?OEdGbVRzQ1FhUVhiWGtzY3VIQlU3UHNUUTlkTWMrYXMvamlrYjNBNVdQTmZa?=
 =?utf-8?B?dUxiWkw4OEZiMzE1STVZaVNUNjJLVm1IMzI5OGZ1YXlxbmNnRlllTnBaWW1T?=
 =?utf-8?B?RHdTVCtKa1BMaklXek9iUHJvbXZFbjUxYTlSNW5FYU1ldmlMUnJtMVFNTjFu?=
 =?utf-8?B?alZBcCsvdFdoWDZUOHFhMStlc09Mb0pMalF6d3FjN3p3dWNKOU5JRm1WcWpv?=
 =?utf-8?B?R0tFdDVWTWszelZzVE9FRlVoSzBvejBVMVFSa1lqc0lGYTJPT2tpYjN6a2JX?=
 =?utf-8?B?NmdwbHhESUUwa3hpeHVidjBGbkNsaDdURmFvWXBqWmNlRXpIb3puTHF4aTgz?=
 =?utf-8?B?c1ZNYkdONm5mWkVVTngyT2pTVGJjbDF3TWRlRmZwUWdyN1hnOWtCblIwbzND?=
 =?utf-8?B?dkFtVVNjNWtjVVg2ZFRIYjNaZ2tFQ0crcFJoZ2svcG01dGRNaDFNeTBBZXpY?=
 =?utf-8?B?K1BmMlE0eEUzUHRjMFZTV1hYOXprcE0wd25QLzU4bVQrNWU2Yk5EY3ZnanpO?=
 =?utf-8?B?Q2JLclZHYk12MmtuT2JwbStEbXZHakloTFEyWDdTTXZubWgrUkh5bkxEdDU3?=
 =?utf-8?B?QjlRM0ZVWThRSzBOQStOU2FsQ2dIazZ5Ny9HZ3IxM2F2K2ZubTJSUmRiakxN?=
 =?utf-8?B?VG9FNmV6WnpYU0JPb0pneC9nMVptblF1YmZMaXZVZmVZSlF1RVFPRld1bFJL?=
 =?utf-8?B?bThEdEdwTlhWWlpGS2pNTTk4emFkUHNQeEU1UFJONjRCQXdxbHdMTVZIeTlk?=
 =?utf-8?B?aENsdTArVDlJTFd0MHBQV1ZyR0hLWUphU2I1akxyRG9TOTZIdTNoQ2Y1a1Jp?=
 =?utf-8?B?VW5UN29wbEhqTDk5bWd6WkRwQkZsak4vcDArUW9IcnFQaWExbG1UY1RwSFU4?=
 =?utf-8?B?RkluVTB6RDc1OWVzeFRPemlFeEZOdTdlaWlxOWVIRk9ENnMwajRHLzBwQ3I5?=
 =?utf-8?B?NkJvM2xtTm9zS1lsWXowUEFPaXZYeGVRUmVPSkkzc0NnK1REWHBHdjkzN1Jm?=
 =?utf-8?B?OWhSRlIrNG00V0EyK3VNbWtGVGFzRHFuZEFROFlMY1J2VFdIR1NMM0xkRGF4?=
 =?utf-8?B?Nm80dGt1RHBCckV2aStzMHdxZ0FNcmR5T3o1dGNicUZ3c2cyMDdtR1IrS0ls?=
 =?utf-8?B?cFZDdTMwSk5EbWJ4YjN4NWlxSjBadTBjb2J2NU8rV29aSXRpUSt2S3BCQk5o?=
 =?utf-8?B?TnFZWldnZVZ5OXNzNjVWZEtpYTBtNUc1L21DR25zWTlGY0ZSa05EbENNZVh0?=
 =?utf-8?B?UXNUL3NMZFg2MzZsc05IN3VHdWdyRVBoZmoyM0FPcStoL2xueFQ1anYyODU1?=
 =?utf-8?B?WDhDVXFWUTVKamZlenZ2VXBsVjdPODc1Sm1VL21qU0sxaG5LM2hsUkZ3L1hV?=
 =?utf-8?B?bEpMWEp6Q0h5UWYzNWgwdXgvSTV4N2NHS2lsbGZYUmtnd0F1WUVnZWRBNXVl?=
 =?utf-8?B?OWNnTVlLZ21Qam53QUViK1VHcEpobWdwTWp0VG5YaVllQytab0NSQS95MzVn?=
 =?utf-8?B?blJ0K1gzM0EySUxtMUJnK3k3bXBrTWZWWHp2czhQRng3aSsxaW9Ucys1RERG?=
 =?utf-8?B?TFl2dXRReHpmSmx2VTFvODlPaXlHNmV1MnlsN0tmSzZkUDZuS0FrTW9GM00w?=
 =?utf-8?B?RlczV0UvYS8zNk1FSENiY2Jaa2o2Mk9HTWo5SjNSaTUxbWdVNDh3WDdyVEtS?=
 =?utf-8?B?UExLME1CMlNYRUk2ZU9UM0NsdFMzTWE5dDlmbENyZm0xSWJ1UFB2WVMzS1FO?=
 =?utf-8?B?MUZVRXhGcnlDMGZUaFBZa01GelphY2hTNFltUmw0WG1CdTFiVVZGV0RrajFL?=
 =?utf-8?B?bTkzb25nVkZTVEZrWk9WNE9SUmJ2eGlzcmpwOUJ6WmdnVkFvQWYzU1dMM1BC?=
 =?utf-8?Q?GZg1Qm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 17:02:22.9847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9aad40c-2a00-4357-4682-08dd791aa0e6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF0000000C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7943



On 4/11/2025 7:35 PM, Sean Christopherson wrote:
> On Fri, Apr 11, 2025, Sairaj Kodilkar wrote:
>> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
>>> Return -EINVAL instead of success if amd_ir_set_vcpu_affinity() is
>>> invoked without use_vapic; lying to KVM about whether or not the IRTE was
>>> configured to post IRQs is all kinds of bad.
>>>
>>> Fixes: d98de49a53e4 ("iommu/amd: Enable vAPIC interrupt remapping mode by default")
>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>> ---
>>>    drivers/iommu/amd/iommu.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>> index cd5116d8c3b2..b3a01b7757ee 100644
>>> --- a/drivers/iommu/amd/iommu.c
>>> +++ b/drivers/iommu/amd/iommu.c
>>> @@ -3850,7 +3850,7 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>>>    	 * we should not modify the IRTE
>>>    	 */
>>>    	if (!dev_data || !dev_data->use_vapic)
>>> -		return 0;
>>> +		return -EINVAL;
>>
>> Hi Sean,
>> you can update following functions as well to return error when
>> IOMMU is using legacy interrupt mode.
>> 1. amd_iommu_update_ga
>> 2. amd_iommu_activate_guest_mode
>> 3. amd_iommu_deactivate_guest_mode
> 
> Heh, I'm well aware, and this series gets there eventually (the end product WARNs
> and returns an error in all three functions).  I fixed amd_ir_set_vcpu_affinity()
> early in the series because it's the initial API that KVM will use to configure
> an IRTE for posting to a vCPU.  I.e. to reach the other helpers, KVM would need
> to ignore the error returned by amd_ir_set_vcpu_affinity().
> 

Ohh sorry about that. Since I was reviewing patches sequentially, I did
come across those changes.

Regards
Sairaj Kodilkar

>> Currently these functions return 0 to the kvm layer when they fail to
>> set the IRTE.
>>
>> Regards
>> Sairaj Kodilkar


