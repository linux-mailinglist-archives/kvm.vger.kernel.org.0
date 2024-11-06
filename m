Return-Path: <kvm+bounces-31029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 506F59BF646
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 20:21:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 730811C21FDC
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 19:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1353209F4E;
	Wed,  6 Nov 2024 19:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4T/gfwpL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B69D207A16;
	Wed,  6 Nov 2024 19:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730920862; cv=fail; b=q+r1BFULjLPAIaIVqx1FCOKBdvgLlDX/ztI8DM+bJV6dr7AQk6KxzlIt5uIGEEM1ibqgjcH4E03IMh4ZYK1aRkjZONbU9rgnmD2jqhRhaj5LmzNcoNS4Grhtc6TjKNRHOS/GgV8aYBMomqENbplHL+e24A+ifNKxYVck+uSA2kU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730920862; c=relaxed/simple;
	bh=6CqtNOwDvVuH86bYX7dI8YPerBslGN448v4uVWHFZdM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=j1o78w5mwk1Js2/4you+OUDWWVO4TdBHnGjwVnlCisr1J8kmYufRUpYq2k8eD6edtvijw1XIaW1d/vBPBI2cGLmZAppO2w6lOoMrjUv23CreZFj0B6yOgSYtVy597AmFxvfQl66tZLmi9oC6RgnG7FFTAFrzkf2cFjbdmNI+L04=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4T/gfwpL; arc=fail smtp.client-ip=40.107.93.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ea/ZAY4q2z+hZHdouu8/CVdjXMq+vhrfglTg+0rJz2dsrpqkOgeyUySxgwxSTvxzFDISB+Bs3+tssPllbf96jySxqJNPp0Vb9mi8fdUWBzPrHBVGLR8MONpdOVLFUxIS8OVbKiSOoEBdgpyft5ByNyL6c04/Y1H1y1oM+9gful0Vu1ORtLQZ6+Uc8iv56zl8/v/Yxai9p5n3m1Jvhtm+OS0KQYoCWVFjkdjI/q6RTLiqPfNVUOe0+6EI2LwTxcsO0+8BKW2EKdAdaqtqtPh+l0q43n5FQtdebtAYzAwC3hs8sZ3d8SIP0Avsa4P0iHKJV5OquyoD6i4QJ69w1KkVvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iH1FVB40fgckqmepYLcAU2o/Q4Jcd9KQ5V5tF7ADY9k=;
 b=Vy9skTLJ10HP9rjOR9LjXy9RN02dvVtMvFMp2c/uk8FYIHuyVEKqO5ljSij08uQh3h0uC/QtUbqdQCXrRBp4+V092BRN8iehrayDvVXqLNfDh+1OAW3SkLx5cnL4JBOhJmaeFXINzqwRFNsrK9D+gFqsYTQ3ogt2zkc69pHBANghnMsDkCmJISDWtk1pwtD9T92Lep2vria3oZu9YSqQRtXTKeDiBMVWYGFjAvTmeAr8eD29pSzGLcZeAqRVJl6hiV4tKDipni6wdhOiKo7TQhlXaoxmbPzjctSUwvK89huCxCkamsKOEpMoFh0E6ZKoLdU8EYamtCx2XOnxfrOHKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iH1FVB40fgckqmepYLcAU2o/Q4Jcd9KQ5V5tF7ADY9k=;
 b=4T/gfwpL+CSXzr2dbh3M9LYRupSEgXn9iPAMgOMYSexQW4klpYDBOxueXsiqr7OHCj/NwaIJHT9Iu3ghTngg2joo80Sxd8kWEg6tTDm1ZQpuChzCor5F9qXBWdhXdeI7Ac0qrQ1/oGUZJBtmFJWkU6k6PPsUkiCw42ndkmmxIeM=
Received: from MW2PR16CA0033.namprd16.prod.outlook.com (2603:10b6:907::46) by
 PH7PR12MB7795.namprd12.prod.outlook.com (2603:10b6:510:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.29; Wed, 6 Nov
 2024 19:20:55 +0000
Received: from SJ1PEPF000023D0.namprd02.prod.outlook.com
 (2603:10b6:907:0:cafe::da) by MW2PR16CA0033.outlook.office365.com
 (2603:10b6:907::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.20 via Frontend
 Transport; Wed, 6 Nov 2024 19:20:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D0.mail.protection.outlook.com (10.167.244.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8137.17 via Frontend Transport; Wed, 6 Nov 2024 19:20:54 +0000
Received: from [10.23.197.56] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Nov
 2024 13:20:51 -0600
Message-ID: <de5905fe-214d-4740-8b6d-45386efa50ca@amd.com>
Date: Wed, 6 Nov 2024 11:20:41 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 03/14] x86/apic: Populate .read()/.write() callbacks of
 Secure AVIC driver
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, <linux-kernel@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<Thomas.Lendacky@amd.com>, <nikunj@amd.com>, <Santosh.Shukla@amd.com>,
	<Vasant.Hegde@amd.com>, <Suravee.Suthikulpanit@amd.com>, <bp@alien8.de>,
	<David.Kaplan@amd.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<peterz@infradead.org>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>
References: <20240913113705.419146-1-Neeraj.Upadhyay@amd.com>
 <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
Content-Language: en-US
From: "Melody (Huibo) Wang" <huibo.wang@amd.com>
In-Reply-To: <20240913113705.419146-4-Neeraj.Upadhyay@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D0:EE_|PH7PR12MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: ee9acaaa-a8eb-43c4-4ff0-08dcfe98226d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WmpiWmUraytwZ29yaXRLaUN5TEFrSlFuNHZrOVJpNEdjZUVic2RxM3Mzd0tU?=
 =?utf-8?B?S3NGMXJxVGNqdlNwTUkwM1BzWkYvZTJLNVlJaEZnb2lpNEk2TStaSkphcnB0?=
 =?utf-8?B?NVkvWEhYNkpVZmxGYmpGVWFyRkNnZHhBSHVteEErSGdMeDEyT0xKRzFpaXlQ?=
 =?utf-8?B?eGZwZC94VGRIa3RWTDNxOGlJZ3FlMjdLMHc5MmI3VDc3YzRrSWcycnJBK25p?=
 =?utf-8?B?Y0NwNG9zSzNRQkVtYWZVNk1YRWVicXE2a1VIMjlzWjNpWTc0YndMbDFTbTU2?=
 =?utf-8?B?TDhNRHRzamIwRDgrYXdBTStOM01vd3FlL3gzZjdIbi96dmViMFE5T2FpUkM4?=
 =?utf-8?B?RUJObjRJUmpabUFOSzI1WmE4cEo1R0VYVUNUTXlSb251eXJFdVBEM1VoZEY4?=
 =?utf-8?B?STVXNDlsTzdPb1JrUFJiTUtad0dDODBhWmZPdVB6QnQ2MnRrbHE2V0NxMFAr?=
 =?utf-8?B?TnJkREZvYUlqdk9vTk1jWFp4VW40dVNnVzhsZUxnRWxCV2hpYTJJd3BwaitT?=
 =?utf-8?B?OFBGQ1pRSnlMVkFyWTlEclZtZ2xZMG9SZWw3SFNaL0x0VW51amluL25KSCtQ?=
 =?utf-8?B?My9Cd1RGSHZzWUtWdVlwRG10c21lcnhubFMxNmFOYXRvVC9MQVI3N1grTmZT?=
 =?utf-8?B?ZTJYaG5LMitiQ2RsZUcvRGphTTh1L1ViY1JnU3R4UFVmbEFEWm5mM0VVSlVX?=
 =?utf-8?B?ZUJod1laaCs1Y2xDYnVsVDRYRXBOb1JSaWg0TGF1K1ZqZnIvYXkyYWl3N1Uw?=
 =?utf-8?B?WFYyUGU1T1N6TWwwSVN1UFhhelRyM3VSM1BjcXJ1NnA1MEUxQm5zTzcyMWw0?=
 =?utf-8?B?cUVDL3lGUmlXU1luSUxxQ1dmRWlNemxlUC8vcGJ0WjNDTkhQS2QrV3hsK0xJ?=
 =?utf-8?B?Z2lTVEhnVm9vMEdRdzRMWWl0a01xa1VNWHNNTmNYQmFhaWE5MUZuclVvUzFw?=
 =?utf-8?B?YWxGbklub3R6UmkzMTBIR0c2RFpvOTUxaUpzUVB6anhBckF0NS9KMjZNdllJ?=
 =?utf-8?B?U20vbWJwWjFlMXVLTHIxaGErYStYa3R2NGlXMjVVMnlQNG9TYWVNbm1YMGx4?=
 =?utf-8?B?VzZIWTRRVGFOdW93bGU3eW5lWWQ2YTl6UTh0RTlwQmRQVHpNbHkwLzhXUWU5?=
 =?utf-8?B?ZEdpUnUvdDRDb1JhYVJXUDdrZmtnSXluWWlQdHMvaG1GYTk3RDhGT01qc2V6?=
 =?utf-8?B?azZLRS9OSldyNVNJMDQ2Y0QxUkZzaEVNMXBWUVhKMWY5bjVJaVk2c1o1OG93?=
 =?utf-8?B?NmxCMnpyT2xudXY2VHpxSnEzL3NDMkFDdk5reWxvZDZWTSsyYnJwMHRnQ2Iz?=
 =?utf-8?B?YUptMWxzTU55T2ZxZFJsdEZ5V2hQWWdhOE9pdEhISTA1MUJ6SlZQc2ZDOFJm?=
 =?utf-8?B?UlRvMWFCV2xTOTcyQjBuRndoVC9XWjdlMkxSWGQzOW8yUkEzMThqblhaOVRQ?=
 =?utf-8?B?MnVoVFpCS1F5Qld1S3N1cm9rTC96L2ljUGFDMU4ycGMxaU1OUitKYlJCT0VC?=
 =?utf-8?B?QThraFUza2NHS0JsaklScXc0UzAwbzZPdldlSkY0WEd2ZXhTemtpQ2M4YUdG?=
 =?utf-8?B?QlNONVIzc2EvWnpUa3paU3pRakZGUzVHMmFORDdDRnhkcW1PRWl1NEx5V1R5?=
 =?utf-8?B?bTc1bFZkYVJwaC9YdEROQkYzY2pieVo5UjdBMDZMem1GTlRZWkJqdDllU2I2?=
 =?utf-8?B?T1dIdnJZQWdTU0FqT2ZzaFVVVzJheHBFd054SzJzaW1YbXBZSFg3eDkwVlZv?=
 =?utf-8?B?YkY0MzlHa1d3Z3pORjJwNUgxQTFMYlZlZStLRzBKYTRKQlg5cTY3TXZSNGpT?=
 =?utf-8?B?ZkhkWEd1ZmhxY1JaMEFIaVlJM3pmUVV1MGJxSm9kRkJIcjVKM21IL2JkYWYx?=
 =?utf-8?B?eTR4YlFyMVRTR2NVejZTQ1AzWE1pWS9teUZBV2lYTVUzcXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2024 19:20:54.3809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9acaaa-a8eb-43c4-4ff0-08dcfe98226d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7795

Hi Neeraj,

On 9/13/2024 4:36 AM, Neeraj Upadhyay wrote:
> The x2APIC registers are mapped at an offset within the guest APIC
> backing page which is same as their x2APIC MMIO offset. Secure AVIC
> adds new registers such as ALLOWED_IRRs (which are at 4-byte offset
> within the IRR register offset range) and NMI_REQ to the APIC register
> space. In addition, the APIC_ID register is writable and configured by
> guest.
> 
> Add read() and write() APIC callback functions to read and write x2APIC
> registers directly from the guest APIC backing page.
> 
> The default .read()/.write() callbacks of x2APIC drivers perform
> a rdmsr/wrmsr of the x2APIC registers. When Secure AVIC is enabled,
> these would result in #VC exception (for non-accelerated register
> accesses). The #VC exception handler reads/write the x2APIC register
> in the guest APIC backing page. Since this would increase the latency
> of accessing x2APIC registers, the read() and write() callbacks of
> Secure AVIC driver directly reads/writes to the guest APIC backing page.
> 
I think this is important non-obvious information which should be in a comment in the code
itself, not just in the commit message. 

Thanks,
Melody

