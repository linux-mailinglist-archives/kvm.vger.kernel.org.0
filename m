Return-Path: <kvm+bounces-56051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 53D64B397E3
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9FA1BA7F20
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 09:15:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76EF8223710;
	Thu, 28 Aug 2025 09:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="n1PwFiIk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2042.outbound.protection.outlook.com [40.107.95.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAF5634
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 09:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756372528; cv=fail; b=V8VapelgUEbE9UfI2+oBDfrJTYl2r8vst/4SwAS+db3A+WLn9Uz3LPGof3xajGv/ZgWUg4DtT8fkb/sXj0un7d78XlcuyZ9o5kas/hSRtGgO6N0eEf/zgCajg7YhuARKydTjV0ZfyDmD5nyFnIYoBuz8hiYCrQN/q4bueEJSock=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756372528; c=relaxed/simple;
	bh=98l0Z1DN9P82Z/p2cNliV3p9o6KHgsPANQk/kWWW5V0=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=SkC1OFBTxLKIKeccM4GcwC2RT1NDf6vMciWu4M1+xapeeGGpvIo9nXfc9DD9KU4dMS74cgueN7ZvTs7YEnroJxwiF/T3Q5fnqsO9XSIvcLUHvEt+zzvJeQG+yxFo7a1WZ6/ycnuC9AcGzX5nZUscVC46uZrYIXBlK9N76HLm/i0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=n1PwFiIk; arc=fail smtp.client-ip=40.107.95.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sIIGEEwc1fGr7dlbsO/EDiJUXaDAwIzyjKnNzcf1aNv0xqyRyKJQ9KdJONflpHKhGN8tMLdtNjWPvxJSZVFcm0aly3aNpo6lULCMZCFk23q1F4jM7qTzTXFkRLSirLQX+Cbm75G3wZrKcSyHpL4/OH25AD5p33gZM6wFxK4GNvH4FXbHOx9eYamu7fZrz/Hij1fXm6a8hB9rKl5WMNXvGmbEpqPNPjv9Sx1eJBBxkfsTOlspc8i0LQvLQU30IK4DX9+UhuOzBFHqubpb+xSdF/A96TGTehcDER4qV+awssTABve39DwaZFQT0R0+LfkE8P0w1Teoyoq1kkupKs9LOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3MGZDbeLrkRijZl2XfmkAKoFobhMgTMehqaMbGjdFmk=;
 b=KJk286PnsVdykDbfYG/hCL7i5ODCpjWNCATypsqRXHeygpRRAxFQ7x6ev87d5dkRec2f7tqfEuADxE08wlCfZOjBoyzrZOg7/uMzlnRWmsLqVtDDf71jY27yEXAieyBUKKvok3rt5zI1LXmn7AIZKPSsO1tCm2RWDpLR4viVL2juXq5/Or46TeWoh0uNrsXTphtSESw+NgC5vClml3aUsYaKYoLMsPWVyRMOhMDH680QLVubQVTDH/pwet94k5gkJ1H7hXGP9jiOq0w4jI2pokOYzQjIYm6+wn37NGkD+6fgYJG3WIl+rQr7Lezi2EqrpDx9869gb+ZFCH9yiuy5Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3MGZDbeLrkRijZl2XfmkAKoFobhMgTMehqaMbGjdFmk=;
 b=n1PwFiIkKcHxOQG0Q4NQcIR2jYt61gyQM/9tmER157BCzJo6GTlYYYnHR4sjnmsRT341yZ0JU2vln8NOjCG7Oyje2qE79cdWJL2q5Ou0EWDh4F58IBUDA+xrr8GiX4/af0bgDKT9769YfGtpwUu+pyYIFwe1ktmJsL6cfar8jv4=
Received: from CH0P221CA0024.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:11c::20)
 by DS0PR12MB8017.namprd12.prod.outlook.com (2603:10b6:8:146::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Thu, 28 Aug
 2025 09:15:19 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:11c:cafe::f6) by CH0P221CA0024.outlook.office365.com
 (2603:10b6:610:11c::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.18 via Frontend Transport; Thu,
 28 Aug 2025 09:15:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Thu, 28 Aug 2025 09:15:19 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 01:37:41 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 28 Aug
 2025 01:37:41 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Thu, 28 Aug 2025 01:37:38 -0500
Message-ID: <86c883c4-c9a6-4ec8-b5f3-eb90b0b7918d@amd.com>
Date: Thu, 28 Aug 2025 12:07:37 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/4] KVM: SVM: Add Page modification logging support
To: "Huang, Kai" <kai.huang@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>, "seanjc@google.com"
	<seanjc@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
References: <20250825152009.3512-1-nikunj@amd.com>
 <20250825152009.3512-5-nikunj@amd.com>
 <fb9f2dcb176b9a930557cabc24186b70522d945d.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <fb9f2dcb176b9a930557cabc24186b70522d945d.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|DS0PR12MB8017:EE_
X-MS-Office365-Filtering-Correlation-Id: bf4a4b78-6e46-4cb8-4c95-08dde61368a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZHVTWC9Sczg4cGRoVW9seURna3plb25LN3ZHSDl2dSsvRjMxVEkvcUllV1F2?=
 =?utf-8?B?cTdmNFl5S3Zmbis4N202MkhUUTJTQ0E1d1drWXMxVEc2QnJybUJ1YlR1L2pT?=
 =?utf-8?B?SzRSdmZldFlwWVlUc3NOL2IzRHNDN1dXcGdtZTAzWUwwcURwM3dULzJ4QXRx?=
 =?utf-8?B?OTJMNlhFZ0FwZXVKbks5L28wQ2J1dlhzb29DdFJVbUhhNWFCSG1pSG8yWnpm?=
 =?utf-8?B?Q3kySlAreWY0T2VOdE5VaDIycjFqS29Lc2JaMjFicmY0V01zQUVZdjluV1NF?=
 =?utf-8?B?MDY0Y0RGQzFYcmNxbFJHVDZvOFRrbjBtNFcvUFZ6bmZHOTNaOFhZdWlQdG5V?=
 =?utf-8?B?VGxJaXpyR01TMmRCOEdKQnJnbUovS3kvc2NIZXo3QjR4NWtWS25wNXgrNUJq?=
 =?utf-8?B?c0dJbFBVc2o0c0xFL2tlMFZJT3Z0b3JtTjRSL3h3Vmx0d0szVDhVakdNTDFa?=
 =?utf-8?B?a0UyR3BLSGh1VWFxRWo5eWdXYm9mTlN1cGc5RmN4NVh1RUZsRlg3c1N3ZjJv?=
 =?utf-8?B?d1I2WnJpNWYwUytlVGJlYzFsMDRVdnZaTUljZW5oc1lPYStyM1hxb21NM1Bi?=
 =?utf-8?B?dG1mUS9zejRtaEk1QkFvYUxyYXRnYkp6amRSQXp1a0t1TzloTitwTWZOSGRO?=
 =?utf-8?B?ZXc0RFhjMlpadHFkUW9pQTRiTWxQTEtRb0hKT1FUeUQ4MGJIS0E5Tkdja3dZ?=
 =?utf-8?B?eGhKaVJENjc4enBqLzhPS0Q1WGJGZ0lSMGhaMWI1bGExRDcrZHN1YXk1bFoy?=
 =?utf-8?B?ZWlteWU2UTNDYlJJcVJSL3dwZi85cjBzbm1vK1JQanVTRGRTWEtUdU1XOHFQ?=
 =?utf-8?B?cWRSSmdaTXoxdEtqWURPQnA3REp0UHRpa1J2WFN5SHFGdmxQbDIzdHVsMldm?=
 =?utf-8?B?RTJtbUh1L1Uvekl2ZFpMMTJma0V6cWJYWjJyWGVtRlZnYjdSRGxLME01a1Ro?=
 =?utf-8?B?R0s0WVFzOVZpY3IwbWxPSWx2K3QvRG9mbnhybzNleS9mK2JkUVFoOFhRUlBX?=
 =?utf-8?B?WE1ZMjdPSDJMa1NtMnppc1ZHZkM2V0NhMG5uUXMwZGpFOFlyVmJkWVdGSTYy?=
 =?utf-8?B?Q29YY3E4LzR1ZCt2MUI0Z25UNWRXT29rWjZZcjc1VUEyNm5iR0FFQVlSY2hq?=
 =?utf-8?B?eXZlS29ZV2xybDlUV1dTM2hGVHRKdWJqbVhYLzJxZlNhNUtpK044b1cxN3Vz?=
 =?utf-8?B?dHd0dC9aTlh5QjBvOXYvQWpmSDhYMFBYemwveFh2S3lvMEpRVUJqM1ZjeFFp?=
 =?utf-8?B?WXBaQnBqU0RvaWwvdjVKeWxuTi9uNVdPdENmQzJSS0VUelhFZjYzUklVUmZY?=
 =?utf-8?B?a0UxdUNoWlpyZ0p5bGxmMS9OZ3BSbkdCUmQ1dmh0R2d6bWdjejUzNi9KdmdD?=
 =?utf-8?B?V25JMnR2M3VUcDZBcmlSS1ZadTFrNExxKzFZdkg1U2FmNXBtRHBNWkJqRUxN?=
 =?utf-8?B?b3BQOWJlNVQvN0tzSnZ1dnlURXdERTFzY3dMMy9hVnlvSkp0VlBRcUtiZ1ND?=
 =?utf-8?B?U25sdGtZWmpRMTE5WDk0S0IycFVpRTBuMm1TNExEZFRURnNQOGJ1VVRkejZQ?=
 =?utf-8?B?MFdmd2JoSHhLN29tUWJINU1HaisxeC9nZ1p2VUZGL0FWc3FkSm4xcGhmM3dw?=
 =?utf-8?B?SXNZY0l1eTBYUm5wa0hvVFI5eXhBd05RUldoMGZ0ZDdadGtpSkVIMDhmSlJ5?=
 =?utf-8?B?dHFjZzRoNkIyTkpNRjdiUDk1K0kxbUxJZ3hZUGMzM29rUkMwM1hDTmpqNktq?=
 =?utf-8?B?Y0tLR1JsN25tclZsUzByOHdTZCtrSGtoRVkrZmtpakdWZWVXVzhmQmtvcUE2?=
 =?utf-8?B?SzR4T3RybTRSbkREeVd2a1RaNkN5UlZIV0dwK0FaZDc1YzJLMitGRHhKUllC?=
 =?utf-8?B?cm9NM0tvTm16cG0zdFgxSm05NnhXbWV2ZW1kU2dRa2tkRHRkSzl3ejJIL0h0?=
 =?utf-8?B?WkVhYzJ4SVJJcjVJOHR6QkM1K3U1OXZrYTFjQ3VxbjBmZlJFcHhLRlREd0Jk?=
 =?utf-8?B?V1lUM3VKZnNaODNlYnlyTjIwcENWRmVOK3NXbEp3VlhHcXowSkRNcVBJaE41?=
 =?utf-8?Q?GXaIEz?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 09:15:19.0574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf4a4b78-6e46-4cb8-4c95-08dde61368a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8017



On 8/28/2025 5:14 AM, Huang, Kai wrote:
> On Mon, 2025-08-25 at 15:20 +0000, Nikunj A Dadhania wrote:
>> +	if (pml) {
>> +		svm->pml_page = snp_safe_alloc_page();
>> +		if (!svm->pml_page)
>> +			goto error_free_vmsa_page;
>> +	}
> 
> I didn't see this yesterday.  Is it mandatory for AMD PML to use
> snp_safe_alloc_page() to allocate the PML buffer, or we can also use
> normal page allocation API?

As it is dependent on HvInUseWrAllowed, I need to use snp_safe_alloc_page().

Tom?

> VMX PML just uses alloc_pages().  I was thinking the page allocation/free
> code could be moved to x86 common as shared code too.
Got that, because of the above requirement, I was going to share the variable
(pml_page) but do the allocation in the vmx/svm code.

Regards,
Nikunj

