Return-Path: <kvm+bounces-68049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B90E3D1F438
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 15:01:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 88FED30941BE
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 13:57:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 918AE283FE5;
	Wed, 14 Jan 2026 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vPdgeNMO"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010013.outbound.protection.outlook.com [52.101.85.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E4E274B43
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 13:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768399072; cv=fail; b=SiaEMXURz+vG3cNTTqtu3Pf7Qdq+wcRStNLhfc7LpJWrTnFpEltxabM7rB8j9U3yJZTaBh3afnE0Mau6mcj7AcuT8FFwtMeSqnJNcXLIkG5uW1spuJ2G3SyHoG2Xtgm421kKCopD6ti0GlUePyjdE5aqXdxB67ugqqmj6v40qNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768399072; c=relaxed/simple;
	bh=P6GrBPduWv5GJlQr+L/ew6E13r27gI8llVbX8IZLwUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=S5IGBHNLYtKVVplmGPT8KqgqaEQ2HIUq1FC/ZTzkZYNO6fdlCdcGYqBfJ27sFsSkU044Mztn9vr1Cxe+HSLvgXQayzuFfRSxlC9PLlBLbdf/nRoTC0121XGzAM08QzG9zJv3qUCIV+Dn4x64ik0zix8OvhCI6IAWiXtdvjmUrPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vPdgeNMO; arc=fail smtp.client-ip=52.101.85.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FT3S4fzOp85hgyA6uaGGQJi7LwC61g+b7wjdqWMMm7//WmN/S3Ytr0cGiuQ4cwtUOpPWqQhNecuVhYvYPGWNcwOS2dhGZEkgHmePNFaZO82vFLu/QaGLQx7yjAd1c8zxdUTKVvC64LcjDtSzoB371C7q3B8tqi23th/876EcepfCQVFHjloPJscWrMKHBoOQXPJf38Dd5i4Fnk5ifjPujwDLbVAKVL3IiqSCzLBgugNs/EOa6/2wz3tLE/Qxb2FUF6BKh8DdclWB3rqYgF5/MJkZxEMd3F3dVt8VvqjIcbxcUY5/Iem5ThDINgio49YsGB1yfHSrW/jZbtTZhRKcLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OMNnokTKzYbrfSRdX57TJCs36gIe4nga5yvMoLNhBMc=;
 b=rmDIo6a7Oj5ppBIqJgooh3UhppYY3z8q6ZLUWFFhg/w6sM5NvG5vh7IzsHCUvCtCCSnJI89k4xpi8FVKdBftzRBGcc/JnVMGltwagv/jhab8PuXwbQQ++zgx3kKUjeRHEUM/X0HlU+3B226fua/PP9wUD8no8fJeFNyQ+gLy2laodhKIDy15xhM8tDqQWm5FYneM8QWsqdJDQ0av3lN9PkSYGF3DcxczRbSXQNn9pE09OxMaZXTxi48jxAHK5nuahfm8VBDAH4lIWp89/6tSEwkb29mriwy/iNY6IefcGAAwdrVoltOjZJVvtSnarYFqqrwoa5+J98RE4Mot9wbdkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OMNnokTKzYbrfSRdX57TJCs36gIe4nga5yvMoLNhBMc=;
 b=vPdgeNMOt65gNH7/jpvIxVxhNHkMjYMgZBZDZFEGBFTYvI1ndePIkxy23NIPfH20R+je1iuT8oQeSZm2tboLbbuEQ4MqnvHQQmJTkuBgiZsmLFg6ejIUo2UEZTSC06uVNdvHV0bfGjiLV2GrWMAEoQtvmkHwCD/FXTlNsSe9DHY=
Received: from SN7PR04CA0177.namprd04.prod.outlook.com (2603:10b6:806:125::32)
 by CY5PR12MB6479.namprd12.prod.outlook.com (2603:10b6:930:34::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 13:57:47 +0000
Received: from SN1PEPF00026367.namprd02.prod.outlook.com
 (2603:10b6:806:125:cafe::da) by SN7PR04CA0177.outlook.office365.com
 (2603:10b6:806:125::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.6 via Frontend Transport; Wed,
 14 Jan 2026 13:57:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SN1PEPF00026367.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Wed, 14 Jan 2026 13:57:47 +0000
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 14 Jan
 2026 07:57:46 -0600
Received: from [172.31.177.37] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 14 Jan 2026 07:57:43 -0600
Message-ID: <daadd596-4a40-4754-8773-ebbdac89f6df@amd.com>
Date: Wed, 14 Jan 2026 19:27:42 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/8] KVM: x86: Carve out PML flush routine
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20260105063622.894410-1-nikunj@amd.com>
 <20260105063622.894410-2-nikunj@amd.com>
 <b62a329fafa824c7a1475dcdd81852ddcb269be8.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <b62a329fafa824c7a1475dcdd81852ddcb269be8.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026367:EE_|CY5PR12MB6479:EE_
X-MS-Office365-Filtering-Correlation-Id: def1e1eb-6f3c-4db0-39d5-08de5374e616
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|82310400026|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1lIQzJsNDNmV2ZFT2xyOW8zRVFLYVd4cVV1bURyY2k1OGlXdmlHMFVTKzY2?=
 =?utf-8?B?TENnZ1E1SXZFMlBRRXI0eHJJQ0RxNXlIbXA2YnBCakQyR2R1SStJOFY2aGw4?=
 =?utf-8?B?RmxPZTE3UWxKNUJkUkJ2MUl5V3R1eTQwaUgxRkZnZSttc2hJejlxZFAvbmln?=
 =?utf-8?B?WFZrQW1rb2tJZ3dJWnVGS0hPQkI3UWhQUTJhSStFTzRyYXBuMlFtOXl1d1FD?=
 =?utf-8?B?WlhNanhoSnIxNDRPb2dRZWdrb3Zubm1UT0RVZW1Rc3h5Wk9oZnp4T2d3NzdJ?=
 =?utf-8?B?U3hRYnV6V0gzbk1yditFcnkxUmg1WlBudXdEK2xRc2RWODlCbS9XQ3NpYnlK?=
 =?utf-8?B?ZStaYkNmSjQ3bWdEVzRJWWNpQTErR0tqQ0duajB1WFdXWEVxYjJud041eGRF?=
 =?utf-8?B?Y1BFUFh2QXVmcEhNZVBVQmZtVlNBcDl5L1YrN0NMblg3TVJObmlRaWoyMzZM?=
 =?utf-8?B?cVVMN0ZRaUdBNXJWbGc2R01QejZIZXdidUordWxsRFZicUlWYTBxcTJIR3Fk?=
 =?utf-8?B?cGZrakZXZTBtSnMzUGE3UHZZd1JUaHcxdGJoNjNKVFlmeElvbER1MGZSTDhE?=
 =?utf-8?B?MlQrRXpRRXVQVUpXZXpXQkN5aTM0b1QyZUMrMzFIaGhYcnJsK2JUNUg1bHNK?=
 =?utf-8?B?a052b2laY0pqeWovc3QrOGgzNkZVYzhYd2VlcGhESHNRUWQ4RzlpS1pSY0tt?=
 =?utf-8?B?eWt4RDFibjRieTBzcFdHbUpqRDZrdFN3UCtsV3ppN1g0SHlLU2dGaEpMYVE5?=
 =?utf-8?B?MjM2L0NQUFRVdWZ4alpERDg3eElNVW5UeXFkK05ReVFBTUZSY3lTRVdYZ2ZV?=
 =?utf-8?B?Z1hIVjBleUhzZzExSklLTDB1c0JMWlFHZ3QxUDhEMWtRUFd1MU1Jd1lwY0dW?=
 =?utf-8?B?ek9mUnA5U2Qrd0d0bnA4V0VvWjhnekpxdjlEKzdOZ0hWUWRWVHM0c3JDVWN6?=
 =?utf-8?B?SUFyMVJYZ0hEZ1BSWWJGZlJNaGpiazcyeEM5aHpQRXRzWVVDWkZOeGlsSmRB?=
 =?utf-8?B?T3g4cFdXUlRxUW54RXFnSFdsRjBTT1YvcFBnUFRscjU0eU8xYmRDQUF4VlV0?=
 =?utf-8?B?TnJGN25FV1RWeWhHVmFpT3cyamEyNFhYSjNjZkwxemhFVC91L2xPbWMwMkcr?=
 =?utf-8?B?dUZRZTR0amkxbzZSYmZUdHpGakxwcHBnVDlVRWRwZHdDRk15VmZOeDVGd01G?=
 =?utf-8?B?TXJwbkdETUlXWURnTWNac2pCZTVTeEdXaHdSeE1ucHgwNklTczFDRktlS2pK?=
 =?utf-8?B?eXdqZXRIdFljWTI1YlV4SFNqKzBBc1NLWW14MlJma3ZadUdFUEQxTjRmNDg4?=
 =?utf-8?B?cGhreTVXWFdKU3prdGEyY001S1o0NHpDREtJdWlOVFlHZ0RycVl2N3hmV2tI?=
 =?utf-8?B?YTZqcFdpbmNHazRsZDZsUnh0Zm85eloyV1JhNzJsdXllVWk3aDlOSFVtbVBo?=
 =?utf-8?B?YmZtc21ycW8vU295MW9WR1BFMnhSeTRiSzVTN3FKdGpMMmdYUGJmSTZaUDVT?=
 =?utf-8?B?QlI1R1FjWVBtZ3pyb2d2RUc3b3lPenF0T1hVZ3c4Qk9jSStpZDVnZVl3UXU0?=
 =?utf-8?B?SzZVdWxBTzhJRlBBSlQzZnBDOWdsMUFkemFtNGpjNUJLRnVVd1VHNjRoQXZ6?=
 =?utf-8?B?Q3EwRFRvaWUrTHY5Z3czcjUrekNHbkdsc2NZRFZ1MWwzUHd6ci9yM0RHZGR1?=
 =?utf-8?B?Yk8vSzlEZ2VuMk9LbmtyS04zak5wY2ZiTEljaThoYXFldzBhK1JudnBCUG5k?=
 =?utf-8?B?dlVJV1Vld21ickQyZ0MzWFlNdEVUUXZ4VVZmS2ZORUhzcTBsMGl0SDBuZy9n?=
 =?utf-8?B?bTJkdHJmUEltdFR0b1BJMHRCS1pmVVFWWjFQOFFNV2UvVTh5eWowcW81aklO?=
 =?utf-8?B?dFoxVTI2d2tOYzRXVm5IQ0RqVjBmRXVHZkM2eXF2U3ZLMHVDTjFIbkZkdVBF?=
 =?utf-8?B?R1EyVXdZY2d3cHdKMVFTUHVzN2FIelgzbEk5ZHM4Vm0vQXp6L1pRc3IvS3ZH?=
 =?utf-8?B?VEdmSlBaRVpVckxhbzFycEU0SER4OUdXUWphYkdCOE5QSlcxeWJyT01mS1E4?=
 =?utf-8?B?MHFqVUI4OXYwY3J1K3VBT2t0SEhnN0pDeHp6ZXJvNlUreFF6aGMrekkyTm5M?=
 =?utf-8?B?WXZQZCs4c0RVRktNaWtqeXBmeTIzTW1UYUo2T2tNc2dNbitpVDJHWG85WlZ2?=
 =?utf-8?B?ekpkT3dHeWg5eXZkeHhnT0ZMbFpVbzM3RmxwRCtNcnFLK2llcUtYNmNkUTlH?=
 =?utf-8?B?R2JReFNJSitnY0dWN3VRU3UzcG9RPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(82310400026)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 13:57:47.4100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: def1e1eb-6f3c-4db0-39d5-08de5374e616
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00026367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6479



On 1/12/2026 3:32 PM, Huang, Kai wrote:
> On Mon, 2026-01-05 at 06:36 +0000, Nikunj A Dadhania wrote:
>> Move the PML (Page Modification Logging) buffer flushing logic from
>> VMX-specific code to common x86 KVM code to enable reuse by SVM and avoid
>> code duplication.
>>
>> The AMD SVM PML implementations share the same behavior as VMX PML:
>>  1) The PML buffer is a 4K page with 512 entries
>>  2) Hardware records dirty GPAs in reverse order (from index 511 to 0)
>>  3) Hardware clears bits 11:0 when recording GPAs
>>
>> The PML constants (PML_LOG_NR_ENTRIES and PML_HEAD_INDEX) are moved from
>> vmx.h to x86.h to make them available to both VMX and SVM.
> 
> Nit:
> 
> If a new version is needed, you can use imperative mode for the above
> paragraph:
> 
>   Move PML constants (...) from vmx.h to x86.h to ...
> 
> Or IMHO you can just remove this paragraph, because the new
> kvm_flush_pml_buffer() in x86.c uses both PML constants so the move is
> implied actually.

Sure, will remove the paragraph as it is implied.

> 
>>
>> No functional change intended for VMX, except tone down the WARN_ON() to
>> WARN_ON_ONCE() for the page alignment check. If hardware exhibits this
>> behavior once, it's likely to occur repeatedly, so use WARN_ON_ONCE() to
>> avoid log flooding while still capturing the unexpected condition.
>>
>> The refactoring prepares for SVM to leverage the same PML flushing
>> implementation.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
> 
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Thanks
Nikunj

