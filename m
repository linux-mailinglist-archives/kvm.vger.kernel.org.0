Return-Path: <kvm+bounces-43414-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 70074A8B5FC
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 11:47:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EF3C189714C
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 569AA236445;
	Wed, 16 Apr 2025 09:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5PsE39rd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957FE22B8A7;
	Wed, 16 Apr 2025 09:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744796845; cv=fail; b=urSLT6E3DRbNgcAKPfEsVoCs6eC8dMcoCG7nVl7wpJd00ofVz9DyFsszx1V/5ySwVoExX0J+6LoqWwj3EzVvtoTrwzEegyCq9gKzEPiKezLsAK7490hSZ+8OHjRm1PZUFz+YgM/yAUHaeDOPkgHSwNXBEs0dTLnPpNFf3TI15pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744796845; c=relaxed/simple;
	bh=m9E9TB0DICFh91Bw4b4zEeEU/S30ZlQv6gRoP1lR2qY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jGrSLPiJTARoaSrh4LAMYt6XnHVzY+Ra5QzbB1QDZgsReAMMeM8048wtMGVOBJTVt3Xr3mR8Lr6n28+HdfpVApYrtsj60unNxTN3kF8fDlmeYoRRFXDGlMghm3EE5eU+DPbPB9wGx1zT0l6JzqRbwveXV5MJDPEHtszekqfg5Ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5PsE39rd; arc=fail smtp.client-ip=40.107.244.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gxad5yjuMfOrjYNa55/ULCaUtXEpNhAJcShd2Sw++vKaZedMgJd1W2yv6xNvwC5hHPY89Fs8rrFgg8nWy2H+an6cICLsDx39EdzmG2IIkROeGzqCrGKuTcHHDVjuh53t9n9HwCeolV+N51+EaMh21r6lhL8TYY7OgIgWnJwxc/RqXy/IX5aMK3oszY+oXoi6eLkalOVtDX4VflsrvHEoOs+Sb9jSCBpUzFr6xiBpgffGRy+DSbr3UKqFICxDq8jtoSFebc+EPB7nD7UaHTQLCkeF6fSdNe+6uQS0rg6EsC/CcS9ckkJy594MNSj0aUYLR+UBoN8yldtTbE7cyzNCrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JvhZ4co6DZfYZBg7ZBqxyYHoFCkMqnoWr5f57hY10g=;
 b=MA3aCReU6PhwyY5GOs6o970CTDIqU1k/ZTllVn2nPrX8c3SNjqaKowyK15JdqdBgF6bBh6Nhc8j1v/l4LybM3Y3kbwFPBlL6LnkA+VTT8n66emWiLOosbX6s8i6o8+8XbmwnhKKX0c+iTSeNBlZIm6p4D9NsP1iMIVrUz7YntV6HUJ4BTHox3rUJxxxzZmIi+SjAUzRxzStrNzsb8EnT5V6CeMCWbmq6S9geg1T9K9nu6F0OF6UCR2IbC9QWNzeGqzZGtJi8PpGso40NGV1M7crAINT3GN7nEHNryw+7utwmrljsqcuAWBNSldoN9NtYYiuEhQbFpY41jiYbk7NjNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JvhZ4co6DZfYZBg7ZBqxyYHoFCkMqnoWr5f57hY10g=;
 b=5PsE39rdgUlKGXolriTE9G7ddFmRs2MPe0J913hpINBhTOkyzDg1Vi+zs8goWx9lKheSrIO7CGSK0OsZ6+pFyAgBBwv6ngkKHUaRPHzvQDP0gM2TjXiHoE0KDK/YsB66fQjMYXhHAicKIobtjb0O6Hz2nw9Fv4ynKcMZJ5Ol/L0=
Received: from SJ0PR03CA0149.namprd03.prod.outlook.com (2603:10b6:a03:33c::34)
 by DS0PR12MB8200.namprd12.prod.outlook.com (2603:10b6:8:f5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Wed, 16 Apr
 2025 09:47:18 +0000
Received: from CO1PEPF000044F2.namprd05.prod.outlook.com
 (2603:10b6:a03:33c:cafe::67) by SJ0PR03CA0149.outlook.office365.com
 (2603:10b6:a03:33c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Wed,
 16 Apr 2025 09:47:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F2.mail.protection.outlook.com (10.167.241.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Wed, 16 Apr 2025 09:47:18 +0000
Received: from [10.85.32.54] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Apr
 2025 04:47:14 -0500
Message-ID: <de563c32-b124-433e-9d16-2544c41e2be6@amd.com>
Date: Wed, 16 Apr 2025 15:17:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/67] iommu/amd: WARN if KVM attempts to set vCPU
 affinity without posted intrrupts
To: Sean Christopherson <seanjc@google.com>, Vasant Hegde
	<vasant.hegde@amd.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>,
	"David Woodhouse" <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
	<kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, "Joao
 Martins" <joao.m.martins@oracle.com>, David Matlack <dmatlack@google.com>,
	Naveen N Rao <naveen.rao@amd.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-7-seanjc@google.com>
 <0895007e-95d9-410e-8b24-d17172b0b908@amd.com> <Z_ki0uZ9Rp3Fkrh1@google.com>
 <fcc15956-aad0-49ea-b947-eac1c88d0542@amd.com> <Z_7X3hoRdbHsTnc8@google.com>
Content-Language: en-US
From: Sairaj Kodilkar <sarunkod@amd.com>
In-Reply-To: <Z_7X3hoRdbHsTnc8@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F2:EE_|DS0PR12MB8200:EE_
X-MS-Office365-Filtering-Correlation-Id: 1feaf856-fdb7-4f65-1400-08dd7ccbad41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QmtoWGhhRUVvZ3B3Tnhqb0RzTU9VRVhzNlFnWjVVai9GR1lUSWQ1NkJtT3Bp?=
 =?utf-8?B?SlZiRS9TeUZpSkkrRjVUaVByUXFuQSsxNHc2UFpLckZ1Ri9mb1VpN2c0Tkp3?=
 =?utf-8?B?ODQrTXdBYlA0K1A0eU5uM1FyNzB2S3JNSStVaGp5Vzc5d0VJVnRpZXdPQlBr?=
 =?utf-8?B?Y1kwWWF2S29CUCt3ckx1K2E0R2VxYlFWWHJUR2w5bU5hVzRZSUZuQ1BpWWdB?=
 =?utf-8?B?S3FqSjlwQ0o3bHd6MFhYME5tTk5tUzRObkxMWUJuY2RZUHRNaGIzS1RwOXBT?=
 =?utf-8?B?Z1RHNmhNa1RIa013ZFludlA2U0NwaDI5dTZTb09FM1d6MWJVM1lON0hCdTM1?=
 =?utf-8?B?cnlqZ2tOL1V4ZFJSSklCR29XVUZveTRqMWFtM2EwT0ducCtpV0FmV0lBU256?=
 =?utf-8?B?Vk9LbUgyVFJXMnVlYzR0bGRGUmkzWVhrYkl6YjBTU3I3cVhYU2ZvTUVzTmoz?=
 =?utf-8?B?aVltU1h2Yms2L2N4TDNtN21zU2JRQkFzdjdOdmtkRlVPM09OYmdRdlBpWlpQ?=
 =?utf-8?B?R2o4aTZvSHdFcTFmZ3ZFakZxdjBHTlA3cUFhd0N4RkM4SzNnM292WEJLSFpt?=
 =?utf-8?B?SjU1REMxYzV0S3NTdEluNyttbEdDRjBQMVp6Qmk3elc0alJHempCZVdlQzBq?=
 =?utf-8?B?cE1XUDZPSW90Umh0aTVQeDNRMXpiN1JnUmhKRWMxN0R5eVVPaW10WG05ZllK?=
 =?utf-8?B?cEpiMkVxd3E2WFZtUTFLSkVUZHBLRHZYYmU3cEVKbnBXVy9GUUlucVRkSlYv?=
 =?utf-8?B?WVRiZTN4MG94THpuUFdvQm1EbEJ3ekVTTk1xeENoQ3kwWEcwUjlPSy9uMHRU?=
 =?utf-8?B?MmtoM0Z0M3lOcnQ2Q2tKcHZKMFgzM2dyaGNhOUJpZ3NsSW45V3hzTjhZaW54?=
 =?utf-8?B?a0taVjlhdjVBUkRkRFpvc2lKaVM3Ny83TTJzejVmUlVLQVpjUGxJT2UwQjY5?=
 =?utf-8?B?YjNGL0JTMjNqcnEwbllOM3dpa0tHN2lMZFNZSUlsKysyNXNqcVI4bUpLUDVX?=
 =?utf-8?B?aWdjajlYeXE1R0RueFNQaFR6NmRESUdRdjQ2Tm82L3l2V2h2VnY3eUQ5cFVu?=
 =?utf-8?B?d0p2ci9ENlJubEVGWFN1cEYvZjVCSElrU2YrYTZJd25GUG9DQllGcDh4cnUr?=
 =?utf-8?B?VUhvSko1aDFQR0xzV3pBK0EzYzJrRzhaU25zT1lNSmlTYlVjMVB4VVJIWnl3?=
 =?utf-8?B?Ui95QmRpRVpRR1hLaGI4UC9XZGJINDlkaHlCcHdPNVd2ZDJEbERCRW1uclNI?=
 =?utf-8?B?ZjZoNXd2YWxvd0pWK3p6cWVZT2I1dktZN0tJbHNpcHU3R0pZVUVZUzVxMStk?=
 =?utf-8?B?K0Nlb0hwNjlwR1FUMk5hZjFwcEErSFdpUDl3KzVkbUpSK25VSUgzU09zaTgv?=
 =?utf-8?B?QmI3cWZ5OUxQRlJhNE1IWm5Bb0R4aEwreVRJWDFnOFpkU1RNT3EzS2NxOGJZ?=
 =?utf-8?B?eTVIY0o2dy9EbG45TmxhUzJLOEZldUwvWHNHT3BQZ3dXZzZpY2s1SElZa1Q0?=
 =?utf-8?B?N2ZwekFVbWw1eEh3TnNnYk1vSDQ0NXRKdklvQ0p5SmVaY0NUSlcwb2VPb3ZF?=
 =?utf-8?B?SHhiL2swRmVQRldjNzlweStmM2ZTWnlxQ2NEWHdwb1BHeEc2Um9INXVxbmwy?=
 =?utf-8?B?T2VlY1JnOTFhaEtwbUlhWE5oSlZ5MWVQZDRTOW1jU25XTFlXK2IydFdyM1Jt?=
 =?utf-8?B?RXQxRTVaWHp2Qzdtb3NhQTMrY1VuQU85S2tzUUlKdm9laFp3WDVDRmhIVzhw?=
 =?utf-8?B?dTQyR3dGcGhlK0NBZGg3NkVHcWZLZ0l6TzU1Y2g5VUxJYVU5a2ZqVXB4RkVR?=
 =?utf-8?B?Sk52Wk5PUWs1WTkycERwTy90YjU0MUJlMEJWR0lYNGVwdzZMakV5MWkwczZB?=
 =?utf-8?B?Mlc3OE5sM05mWnNVSi9hMGpRbVlBV1FlZVN3cjhJSStRZTN3aXNwZUFVZzdM?=
 =?utf-8?B?QmdCa0Y3UFZXd0dHTHl2b1hOR2NSVjN1RmZPRWNmQ3c2czFIaHcvZWxZL0Q1?=
 =?utf-8?B?TS9DbXBsRVlLQ3hseHdKMDZyMjdEOENWTU4xelpYc3FvekhQU1ZpdzNlamx1?=
 =?utf-8?Q?s+CljI?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 09:47:18.2000
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1feaf856-fdb7-4f65-1400-08dd7ccbad41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8200

On 4/16/2025 3:34 AM, Sean Christopherson wrote:
> On Tue, Apr 15, 2025, Vasant Hegde wrote:
>> On 4/11/2025 7:40 PM, Sean Christopherson wrote:
>>> On Fri, Apr 11, 2025, Sairaj Kodilkar wrote:
>>>> On 4/5/2025 1:08 AM, Sean Christopherson wrote:
>>>>> WARN if KVM attempts to set vCPU affinity when posted interrupts aren't
>>>>> enabled, as KVM shouldn't try to enable posting when they're unsupported,
>>>>> and the IOMMU driver darn well should only advertise posting support when
>>>>> AMD_IOMMU_GUEST_IR_VAPIC() is true.
>>>>>
>>>>> Note, KVM consumes is_guest_mode only on success.
>>>>>
>>>>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>>>>> ---
>>>>>    drivers/iommu/amd/iommu.c | 13 +++----------
>>>>>    1 file changed, 3 insertions(+), 10 deletions(-)
>>>>>
>>>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>>>> index b3a01b7757ee..4f69a37cf143 100644
>>>>> --- a/drivers/iommu/amd/iommu.c
>>>>> +++ b/drivers/iommu/amd/iommu.c
>>>>> @@ -3852,19 +3852,12 @@ static int amd_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
>>>>>    	if (!dev_data || !dev_data->use_vapic)
>>>>>    		return -EINVAL;
>>>>> +	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
>>>>> +		return -EINVAL;
>>>>> +
>>>>
>>>> Hi Sean,
>>>> 'dev_data->use_vapic' is always zero when AMD IOMMU uses legacy
>>>> interrupts i.e. when AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) is 0.
>>>> Hence you can remove this additional check.
>>>
>>> Hmm, or move it above?  KVM should never call amd_ir_set_vcpu_affinity() if
>>> IRQ posting is unsupported, and that would make this consistent with the end
>>> behavior of amd_iommu_update_ga() and amd_iommu_{de,}activate_guest_mode().
>>>
>>> 	if (WARN_ON_ONCE(!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir)))
>>
>> Note that this is global IOMMU level check while dev_data->use_vapic is per
>> device. We set per device thing while attaching device to domain based on IOMMU
>> domain type and IOMMU vapic support.
>>
>> How about add WARN_ON based on dev_data->use_vapic .. so that we can catch if
>> something went wrong in IOMMU side as well?
> 
> It's not clear to me that a WARN_ON(dev_data->use_vapic) would be free of false
> positives.  AFAICT, the producers (e.g. VFIO) don't check whether or not a device
> supports posting interrupts, and KVM definitely doesn't check.  And KVM is also
> tolerant of irq_set_vcpu_affinity() failures, specifically for this type of
> situation, so unfortunately I don't know that the IOMMU side of the world can
> safely WARN.

Hi sean,
I think it is safe to have this WARN_ON(!dev_data->use_vapic) without
any false positives. IOMMU driver sets the dev_data->use_vapic only when
the device is in UNMANAGE_DOMAIN and it is 0 if the device is in any
other domain (DMA, DMA_FQ, IDENTITY).

We have a bigger problem from the VFIO side if we hit this WARN_ON()
as device is not in a UNMANGED_DOMAIN.

Regards
Sairaj Kodilkar

