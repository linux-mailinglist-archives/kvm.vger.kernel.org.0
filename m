Return-Path: <kvm+bounces-55757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 81DFAB36D4C
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33639585B77
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 14:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71DCE1EBA14;
	Tue, 26 Aug 2025 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="GiG5nT9f"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E324A22538F
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756220293; cv=fail; b=bgTPBHoHcYrERl7yWH2vduVgHAwLKL+v/sHffk+lCkdDbulWxdObPRVKZGVoX2sItCq8Wu0C9I+FzxWH1khFV9oR0p8QMig02W/wwEvxcZhMrKc4h0U8a8XKsVxLYAZ65/iwLYBw1s5gwblzIlMeLCfk4lMNXVM4wi8Gtik0gRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756220293; c=relaxed/simple;
	bh=6EEnqMPr5PbVZ5411zuMUp5B7sErkaT35KHJqsoJA40=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=o2dpiuqwlCZM3zxNtOBEuYs7HcpvYZnkDrLYx6O0t8QUWkc0O92yhlzcsTPP4bLUHnQgOrNqRnQebQV4NKPSc92A6PK3/oFOSG7hkiPTFRjjfWoAg+OOYhBzb8BzJxS1rYc498V58Fd66hbgPR5N+YvP07dgCLaq3ud1gZd0gSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=GiG5nT9f; arc=fail smtp.client-ip=40.107.243.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z0va9lQ2eg8rnq2chs4JqmZguZiJDgs1lZNL2AA3RqwqtcFifGZuiHuMFo19sX7E8LYYufXwx3xKPmJqcImllJQcwXw7GmqQpRCTYXjGUSpoeWe1KzTwWYQ5pGBAvyQdU/CSiXWbORE9PDD8Bw3GUD2BkPRa52cIcSVLm1i/wdR1I/K3UGQneOC7cCrLahq2p9TuplFI9fWGc6rHL4JGe7h0r1TYnNAn5iddCf2662ZvKN05e5OoZB78Vk6K1SPrW+rfjcT6diRjS4VAMadZSu8Hm7J7Rf/XLCZa1Lhjgj5REL1/LTN2NACP8j0PPkQ5gjqDjZ6YWmhTmbaXG+ZAyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=syaqhJXtxaZJDhh5gLyklUEI0a8njeHkFAHJpvPk20Y=;
 b=dDRaIJWLqXJQml2SLoVK2pEaiFkgesEy8wnZFKx2hPIfCjdaifiUPgGlQgSsjdWwjkTw5CU794rKMv4u6e91hiGvAT/QCtCuffb9kJboTewr+tJK84cBkqt9sEiWfuDmRe99eywtYF7T4THDGnuU1qU5a5ag8fQcVXGuNTKRUn1QYb4hNPMjARUG142cHAIDx15lGeD5+M1xUNdaMhjSPMGBXJB2lPcLRm2UWzWhqhiiprp1mLGkECI7zOd0j/p/5/vO2yuFWe132na65pzgTzCaIM6sLNeaTWGMWo2AXlNRo51Afsglvr35UUKyz/YiuuMrH5A2IbfuOAurXpPBMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=syaqhJXtxaZJDhh5gLyklUEI0a8njeHkFAHJpvPk20Y=;
 b=GiG5nT9fWehGuAOmmy739r0L+749hms+O4w6MHESHSW5was2oRUWNTKnQz1AC7+HQCwCCJ3bOELXsUw5JP/mMW7suPIG41H13yq1/fB1bLecwL1sx/T6pRugoYjcVaFB3s4oFfNHq/d0oqy8JDJbc6ONZo4ea7GXQXLNIiOh9FI=
Received: from CH0PR04CA0065.namprd04.prod.outlook.com (2603:10b6:610:74::10)
 by BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Tue, 26 Aug
 2025 14:58:09 +0000
Received: from CH2PEPF00000146.namprd02.prod.outlook.com
 (2603:10b6:610:74:cafe::d4) by CH0PR04CA0065.outlook.office365.com
 (2603:10b6:610:74::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.21 via Frontend Transport; Tue,
 26 Aug 2025 14:58:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000146.mail.protection.outlook.com (10.167.244.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Tue, 26 Aug 2025 14:58:08 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 26 Aug
 2025 09:58:07 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Tue, 26 Aug
 2025 07:58:06 -0700
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Tue, 26 Aug 2025 09:58:04 -0500
Message-ID: <0e709b57-0a7e-4aba-8974-e20934ac6415@amd.com>
Date: Tue, 26 Aug 2025 20:28:03 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] KVM: x86: Carve out PML flush routine
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250825152009.3512-1-nikunj@amd.com>
 <20250825152009.3512-2-nikunj@amd.com>
 <84a1809495eb262c26987559a90bc80f285f1c0d.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <84a1809495eb262c26987559a90bc80f285f1c0d.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000146:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 91c14120-1fee-40bf-bed4-08dde4b0f877
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TmdlS2tNWThKaHJUZ2t1Rm9nMmc3NllMTFY0eG8rVjBpZWphR0xPRm9NWlhL?=
 =?utf-8?B?Q2ZMMnVzS0RRSlgxbTNMUEFFd05UQi9QOGlCNkZ4UGFWZERmQXMwVjBrUFJS?=
 =?utf-8?B?TnFPaWFocVFiZllIVWppdlJ6NjcreWNHMi9wYWs3OTJUNWFMK0JOK0ZjQTgx?=
 =?utf-8?B?c3MxOTl1QTBjZE1NV3Z4a1h0VjZUcllKaU1hTVcxQXFpR0Q3a2lRR1JhNWt3?=
 =?utf-8?B?Yk9vZ3gwNG9qZUZWNEJNWk1kcm9UcncvU0dML1d0Z3B0eXMwVGlSN2xJQTNU?=
 =?utf-8?B?dFFXTExxUW42OFdkVlJXR1U4SzhYMGVzRHJSQVFSTjg1QWtZR1hZaFMyOXVr?=
 =?utf-8?B?eWV4KzJuRmhPOE5lY2N0U1ZkV1VyRTIyZmpzUGNSRGdaRFBYTHZaTThEZTBq?=
 =?utf-8?B?QXVOOWI3c0RuY2hqOVhZYzB2ZXFBMkhic1VJcXRvYWw3NXlESjhSOFk0bVkw?=
 =?utf-8?B?MzZSVk1IQW95REJBbU43UmMzZUY5SytYS2tDaXc4eVRzZThITDByNk9Db1VH?=
 =?utf-8?B?djNQdnNYeit0b1lRK0FCOTl1T214cWtoM3g1R00yNjh4WVRwVmkyYWc0QThz?=
 =?utf-8?B?SDBXUjljSHkyT044WlpNbEJGY2xhcUQ2aXFmRC9LZkpYMWpEelp6L2dqaGli?=
 =?utf-8?B?TERGUTdzV0dzREdodUZJTzllYWIwdzFaUi9LVFRUc0doMGgrbG9RVHoyRVd0?=
 =?utf-8?B?dW5Bd0cwaEY5MTdOdXNiSktSWE9tdE1uY05pWW9LTG1LZDJydlBmazc5QlNs?=
 =?utf-8?B?T2xWN3dSSlFiSk5mSjhiQ0ZaMjdiYVYrNXpLYjBWQit1eURhTnQyd0F2MzUv?=
 =?utf-8?B?QjltS2VWWEZlSFRaWit1L3JUbXJTdW1mK3FFMzdObXJxMll6Vk8zWFdSclZQ?=
 =?utf-8?B?OU5EUW0xTjh1aDBDQUJmeEtnNkdJeDFKYVB5ZmZPSmwzcm8vQmoxeVBWVXNG?=
 =?utf-8?B?VTVqSWc5NkhMQlJ0Tjc3VGhza0wvZ2ozbDZnbVViR1c0QUFYUDAwT05Kb1l6?=
 =?utf-8?B?R0lSZTlJdUZBdUZTMVM5RVptU1pCeVZaL0xmMXhqd0QzSnI2bWZTSk5VL0dE?=
 =?utf-8?B?Z0ZUUXpybis2THVvNDdySTBuT2JscGZKaTM5V0JyRnRWblNhWnlLdFV4RVFp?=
 =?utf-8?B?cml1eklESjRxU2pOVU1wdzQwWWxDc1U1Q2FsUU4xWE9NWGhaOGplVjRaMTRT?=
 =?utf-8?B?TjN6aFhYaDJDZzV0M0tkWGVSMmlCVW5UZEM1YlF3bWN2bmpKdFM4WTNKanYv?=
 =?utf-8?B?K0pmY2EyS3BOZk16dENvSjc0RXprN21BZjRKTGR3dkRxS0dJU1NrdlBUL2U1?=
 =?utf-8?B?QmlxY085ck1KanBab0JoVXEwYVRwcUxjSTl6aVFrNE1IVE1YelpSLzFYRDBW?=
 =?utf-8?B?bmdaVFMyM0luaUZOaUExRHlEUm9ZandPZmZIR1I3RmE1ZWVwSm9XUmZoSGI4?=
 =?utf-8?B?RXV6Z2l1QlU3SStRVGtmKzRFZ2FIRlAvaE9qdi9uaGJHWlBOY1B2STFETHZX?=
 =?utf-8?B?TTZCd0dzNXVESTI0d0VnQUEwajEreUJrWUxjdTB3VDI0RERVbFYyWVg0Ri84?=
 =?utf-8?B?bCtXK1JocTBGMjUyQXFDek1FTENpV2tXMDFBSEZ1Qi9DMGFSQ2VGamRXS0Yr?=
 =?utf-8?B?NGcxbGIrMzlmdjVEUDVzQnQwYWZkcmpTRVBEd2FleWNHQVYvYnZ3bjh3azZG?=
 =?utf-8?B?YnJNZlQrb3BFV29rdUNPeUZvM3Nob3kzQmFCNUpmQmgrQy8zZXc1L2J2TkdE?=
 =?utf-8?B?WUU1NzFUV0s1dUZSY0kxMUREcmRxS1VqL3pFdGcrMzlCcmwwS2M0ZnZZQTBP?=
 =?utf-8?B?U2dvZHdMdmo5VlZPL3paWkVZVXVLSlkzckhXOWN2WVEvelBMYVE3Q0NCM0lV?=
 =?utf-8?B?aHcrNlpoRjRPRWNTSnRnTVkzbmowTG1xbWg3MWY3eWdZNms3bytUUnMwc3k5?=
 =?utf-8?B?STNwK2J4dTQwMHoyRjc4ZW84THo5VTQzY2czZVJ4T2pqbzV4YmQwTGhBTktB?=
 =?utf-8?B?NFBYK3RvNFBRYlJPNGVadVh4aExTWXVpcVBUL2Y1UGgvSXFNRnduQ0VtQ0RZ?=
 =?utf-8?Q?o4EwOM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 14:58:08.9885
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91c14120-1fee-40bf-bed4-08dde4b0f877
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000146.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051



On 8/26/2025 3:36 PM, Huang, Kai wrote:
> On Mon, 2025-08-25 at 15:20 +0000, Nikunj A Dadhania wrote:
>> Move the PML (Page Modification Logging) buffer flushing logic from
>> VMX-specific code to common x86 KVM code to enable reuse by SVM and avoid
>> code duplication.
> 
> Looking at the code change, IIUC the PML code that is moved to x86 common
> assumes AMD's PML also follows VMX's behaviour:
> 
>  1) The PML buffer is a 4K page;
>  2) The hardware records the dirty GPA in backwards to the PML buffer
> 
> Could we point this out in the changelog?

Ack, will add in the next revision

> 
> [...]
> 
>> --- a/arch/x86/kvm/vmx/vmx.h
>> +++ b/arch/x86/kvm/vmx/vmx.h
>> @@ -269,11 +269,6 @@ struct vcpu_vmx {
>>  	unsigned int ple_window;
>>  	bool ple_window_dirty;
>>  
>> -	/* Support for PML */
>> -#define PML_LOG_NR_ENTRIES	512
>> -	/* PML is written backwards: this is the first entry written by the CPU */
>> -#define PML_HEAD_INDEX		(PML_LOG_NR_ENTRIES-1)
>> -
>>  	struct page *pml_pg;
> 
> Can we share the 'pml_pg' as well?

Sure, Is struct kvm_vcpu_arch the right place?

Regards,
Nikunj


