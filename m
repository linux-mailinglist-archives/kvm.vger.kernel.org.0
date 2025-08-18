Return-Path: <kvm+bounces-54906-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC1CB2B1CC
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 21:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52CD7520D48
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 19:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C74272E46;
	Mon, 18 Aug 2025 19:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CAz3331B"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2FF3451A1;
	Mon, 18 Aug 2025 19:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755545930; cv=fail; b=h++9HIsChcbBE5x87jFniCU6CR9zPQKsjlaMg4yfvFcbYZH+j3B/IOVrTXwLLp/hBceimVO4mhaYbxI5pzm2rHbAfisfetGsoUxYVV5M85Db1aJyH4L60wNIPjH46n5eHRJMV3au+pk1fOV+04JNe9+tLyqMfjxF72fYN0af23s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755545930; c=relaxed/simple;
	bh=m1n10U2m1VeL9t68fCs2CRwE5pgxeQ2DS15NgdCH0GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nRAi/cBX+0qo1oVrLm3+rR463tnd5LAROq/fCyKUa5v/RkB/bFMZgSpLx7kygqrsExzfMnr9ZBavSWUnBuEZMP5qTRZGp8qp4u2fGNKRuGoUfDiSEkcGZtFswdSv/4WATwKLmnAMeS9z0iCnhNT6O/duFTsOfMY265cdT9xOPUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CAz3331B; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fyD6BEgLjdtiFR3b4oICT7ZyUEdy9fQWlyzWC7aIW7Jm3V0ekU7kQDtALJogwP9hXDG5WFP2EJY+Uv3s04CY6rf6Uw3jbVT5dWuALq2Zggkz5PpOWrLSjPxOEnfMZUPW6s1QnRG8jsSyctF0ThjY7Y6PQGVntl1z/AaSrPRqcVVoBxMAA0h9eEWQJYdPghCkFB9OXHPaAlzmBs1q4iCaRrk++HyLD81/d3uU/1dZLwsTH7QRFwfIj0BHfX/63u7/Il6dn8vt73Cq6L4qoeZOP1bdSwbsAPjn/XaxyRjlVrxjzG2xgmNf8bVKjPZAVSiRxZ19XTLb1jbKwFT+DXRPig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkV43cxAH8PyELX4ZmEe9AhpWP743/o1yYNJmTroYHI=;
 b=OJWrpICXAaPRLCq9WhJcPLclgbgcFGCKTneGxxKevWLIcvLl5Z/LGZVtAQUdZEB4BMMLMT/2eiJ7obmsZdQA3YGUprOMu8LP981iJfCLygwKWI4lC9bA7/ONK/WmN3Pd5k6C02FjNqO29XwB9VttZ7cRYXr7fYSrG18qdcxKPHlZMlc8ulC0x9oyG8Kh+X70kYrfQ9krxsxdxzOhP1Sqnlq8CJhRD83uLGaDCgJoanhxdnJcwoEEoT62iHf3vU7GOsV4igTX8wIvhXs8JOxIgMS1m3FrInz6MT4viK2+ceV6vLWTQ5D/li+JbMFXF5nVeTn/JeyMyVufjY1MOAv87g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkV43cxAH8PyELX4ZmEe9AhpWP743/o1yYNJmTroYHI=;
 b=CAz3331BvRZRJSaYhfX2s931dgpyYIBc3+4K+sP1hxsOHXLIE3sdPgguGpn6jYDBVKMKVg9IMFFiHbRSQsc4fDVdT+SCdqnE9SeSvq+JybjX/BN9jOrc5U9HK4+Hzc1wQxmA1XmuNeapbucoH6tAOOWrGAU9I1JRanSXjM2pR0U=
Received: from BY3PR05CA0036.namprd05.prod.outlook.com (2603:10b6:a03:39b::11)
 by DS2PR12MB9565.namprd12.prod.outlook.com (2603:10b6:8:279::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 19:38:46 +0000
Received: from SJ5PEPF000001EE.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::9a) by BY3PR05CA0036.outlook.office365.com
 (2603:10b6:a03:39b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.12 via Frontend Transport; Mon,
 18 Aug 2025 19:38:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001EE.mail.protection.outlook.com (10.167.242.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 19:38:45 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 14:38:43 -0500
Message-ID: <51f0c677-1f9f-4059-9166-82fb2ed0ecbb@amd.com>
Date: Mon, 18 Aug 2025 14:38:38 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/7] Add SEV-SNP CipherTextHiding feature support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: <Neeraj.Upadhyay@amd.com>, <aik@amd.com>, <akpm@linux-foundation.org>,
	<ardb@kernel.org>, <arnd@arndb.de>, <bp@alien8.de>, <corbet@lwn.net>,
	<dave.hansen@linux.intel.com>, <davem@davemloft.net>, <hpa@zytor.com>,
	<john.allen@amd.com>, <kvm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<michael.roth@amd.com>, <mingo@redhat.com>, <nikunj@amd.com>,
	<paulmck@kernel.org>, <pbonzini@redhat.com>, <rostedt@goodmis.org>,
	<seanjc@google.com>, <tglx@linutronix.de>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <20250811203025.25121-1-Ashish.Kalra@amd.com>
 <aKBDyHxaaUYnzwBz@gondor.apana.org.au>
 <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <f2fc55bb-3fc4-4c45-8f0a-4995e8bf5890@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001EE:EE_|DS2PR12MB9565:EE_
X-MS-Office365-Filtering-Correlation-Id: 83cb7ba4-5b5c-4743-1b27-08ddde8ed89f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TzJraE9CWm5ENTlmVithTHJFVjg3dlh0YVVyQkVBYjlRNzJLR1hESTVzV2Zo?=
 =?utf-8?B?UlFrNk5vT0NvUkxTb3JPNFJlWlcxcUNVK2lGRFFJNVgzVjBYTXdUeU9UYVdL?=
 =?utf-8?B?Zk92d3lpOUNLZ2hFb0FRMW1UMVRYb0h6bit1ek9NQUszYjZrem1pNmtLSWdJ?=
 =?utf-8?B?R2dQOXhSL3ROSDdEL2FGMFZnb1JxY3JGd3BSUzU4N1FqaEpCS3BQYkxzRE1K?=
 =?utf-8?B?VWVJYU9BUzBpYW1STGhmUGxrWG1jQlBxYm1vL041MWZweWxMcDlrUm1OdVV0?=
 =?utf-8?B?azhyUU02cjF0ajNWM3E5ZzMwb212djFYQ0wvUjkyZ3QzR3BBSzMreC90cnJw?=
 =?utf-8?B?TWF4cHJWa0hMUVlGaFgwbTZLcG9IRklUbWh6SzhCd0hhejR6MnFwMzRPb1pp?=
 =?utf-8?B?TmJ6R2o5VkhSeGtKb0tzN2prWCtjRFRLZkVIV0h1VUxseTdzT0NYMVZLU3BQ?=
 =?utf-8?B?VG54U1AvNXdZcHJsei9qRVFldERuV1JJVkNId1dOUEdhaWlwVE1lZkcxb2U5?=
 =?utf-8?B?Z2NTVUFJUWpDeUR1OVQvdFIyMXNFam1nb0RCei9MSnZmTHVtM0dncGE2R1FJ?=
 =?utf-8?B?enpncmNkTkIvSi9EcjBMOGhsc29KVWx2dGlMWEFDdVluN2FZWkZweGFiZmw1?=
 =?utf-8?B?bnZzeGhBT1VmU3JsOCtzNWd6eFo4ZEg5V0RxYUZtUVF1MGdma0Z2UmZVQ1V6?=
 =?utf-8?B?VnVrekVMVTdBMGJIeDlEaGFtZUoxZU9CUmMySjM0RFZNcnY4RENvTW9LT3Yy?=
 =?utf-8?B?NXlBb0hMZUIzdytTSnN6eDJ4NVVZWTMxVHYyZVVzWGNSbWV1a1pkN2RMRHhK?=
 =?utf-8?B?M3MraW9UN0tONisxZndhby9hNUVUN3g0dGNnUjRkdm5pUlc4cEVDSHFnTDZC?=
 =?utf-8?B?eHdpdmVqRnZ4cGFCQ3hYTmFMVUxiVW9HUTB3bUR1ZEdibXlRRWh3T0ZiQ09T?=
 =?utf-8?B?WkZmNFlzelVSSENQbWRyT2pONC9MOEdmdHJtbUV1MzNEUmhVWUQzNXZYVDB1?=
 =?utf-8?B?MTllQXNlc201SmNHRDFKTXZmYkFrUHFoQmdUdHBBZHZ1dFRVRlpDMzA1QWMx?=
 =?utf-8?B?UGIwMmp1OStzWC9wUkJtdUk5ZllrbVM3R2lNRlpObzQ0NHVyV2xIUnZPeEZR?=
 =?utf-8?B?bVFqLzlKbHl6NEtDWDFDVndCZTVsVE15YXcyYTRzbytTKzJaczI3bEs0a2p4?=
 =?utf-8?B?Qk80ZEhEV0R5ckZqMHA5SjFyRVVXL2ZyMTdnbGhFSzZmMWJiVnU0RkJHcUt2?=
 =?utf-8?B?Z3V2VStTS1ZJLytGMGN1MGFxZkNyTFg4Uzh0ekY4aStrZmpBQndjV1ZHem0r?=
 =?utf-8?B?RUpaS0FQVjJ0ZGRYNGUxeEtOV1BSWXRpekh3TUhzek1SelAyVlVQWGQwZ0xq?=
 =?utf-8?B?Tmp0ZEJVUXlhUzlhclpxTUd0QVhiRmV4Q3hXYUhBTThSSStyRUJ2R2owYW9I?=
 =?utf-8?B?MlRyMW8vQk03c3I1MFR1bW1DYVlHRDlseWUzYTZtMlZhc0RIVDk1bU5Nejd1?=
 =?utf-8?B?akw2elNUVjByU3kvRWZic1hhc2Q3N0ZvWVNCQ2pRd1lveWxqQTY2UGF4czB3?=
 =?utf-8?B?RTE3UGVZVGdjQ3NXV0VnWTFWbC96dHpRb3FoZTkzbzVnSlNlRTRCUmdaQm1F?=
 =?utf-8?B?ZlFoTGkvRmhGdWh3REJNM0FLVEJxUjAwdE1obzN0c2k4S21rSVhHSm96Qmlv?=
 =?utf-8?B?SmF0cURvVnBBclNJNTRyUStLK243cU5zYmJBNUhpWDA5SHI4NzI4UmtNK1hv?=
 =?utf-8?B?MDF6Um1mSFZ2SmkwcW5TWVpiWkYrWlpBWE1vZlA2dlBLZXNIR2M5N0NMNGl2?=
 =?utf-8?B?b3VvN1ZKSCs5bDJZdTRXNldCMDhOSy8yMzlxYjJiNWhEKzI3RDljaHovUzFn?=
 =?utf-8?B?ODBpTElLaGFqa2VQVkp4ZVB1NUhCWDZqdnhXZTdVekxaVHJyTDNhQWtxcmhX?=
 =?utf-8?B?OUo4a1lZS3BSNDlKTFR3Z1ppOW5RaU5SMGc2bXMvSlZWT3c1b25ac0xSS2Fy?=
 =?utf-8?B?RjJ3ODVpR2ZRPT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 19:38:45.6165
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 83cb7ba4-5b5c-4743-1b27-08ddde8ed89f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9565

On 8/18/25 2:16 PM, Kalra, Ashish wrote:
> On 8/16/2025 3:39 AM, Herbert Xu wrote:
>> On Mon, Aug 11, 2025 at 08:30:25PM +0000, Ashish Kalra wrote:
>>> Hi Herbert, can you please merge patches 1-5.
>>>
>>> Paolo/Sean/Herbert, i don't know how do you want handle cross-tree merging
>>> for patches 6 & 7.
>> These patches will be at the base of the cryptodev tree for 6.17
>> so it could be pulled into another tree without any risks.
>>
>> Cheers,
> Thanks Herbert for pulling in patches 1-5.
>
> Paolo, can you please merge patches 6 and 7 into the KVM tree.
Hi Ashish,

I have pending comments on patch 7:

https://lore.kernel.org/kvm/e32a48dc-a8f7-4770-9e2f-1f3721872a63@amd.com/

If still not welcome, can you say why you think:

1. The ciphertext_hiding_asid_nr variable is necessary

2. The isdigit(ciphertext_hiding_asids[0])) check is needed when it's 
immediately followed by kstrtoint which effectively makes the open-coded 
isdigit check  redundant?

3. Why the 'invalid_parameter:' label referenced by only one goto 
statement can't be folded and removed.

Thanks,

Kim

