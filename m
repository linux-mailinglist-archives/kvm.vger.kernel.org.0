Return-Path: <kvm+bounces-52583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C823B06F2E
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:41:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C322A163FDA
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5E9228D8E7;
	Wed, 16 Jul 2025 07:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YuC7ReL5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646DD28C2DB;
	Wed, 16 Jul 2025 07:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651656; cv=fail; b=C+N+eTNzG+xfnipjYOI+bhvGPJCv1AIdTLYdBv44zAFe5WuSb3/m+m066v5h75S6SZ+lgKfilMAbCNIG5sCFHYGW0U/+Q7SbDwYXf6nOdo5yT6xL/uv5ohiYO5c5Jyz5sOHvepHc6BtFAEd7WZnr4QHv+B20SgGbhZY3q01V3xU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651656; c=relaxed/simple;
	bh=ZobGd1KygIkSZCY8CgU08x6w/QfC8nnBPIj0UXro1w4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=giBXkzAI8BjENg+ANT2a2vLC5jWbf+emgFEG1Aa9kaDr2jEq3d6NwsPHq3PUsehE0Z+nQZSUViczzGJdwJzplPHR7HA4y9IKACllOjXBwRkNXLsHyZfu9/aWAvb5yT8q4smrqQxuIMFBbh/jrMFl28bcL1pKLouQ/niOpG43fcs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YuC7ReL5; arc=fail smtp.client-ip=40.107.243.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LsqiiUnedfXkgnHl1CU/aVoevsohJ0ulN9/F5OaBsb649oajm+r1LHZBsB3h3zyVFV0XC56PK7kXMkr/6KSWtel1WvwJGd/tS41ffqNMLErmjBipuC+319T1Lwi7w4phdchzRjhK5AoHYHWysSjqRL8kLTJoUBG0D5jmaSM05rKJ9q/p7QTSHm76ZIOBgN5rVdyn/qGID/P6XBKN5vax/AO7/5ABl33+rL60f7z26zla3iaT43MWIxd0uDwhxPijcus4wEq75Y3g09uTKnonoQnxPeHEb+5FAfq/rILj6saIKcOnrkgftMQLruu5JvHoJrdU2CjfdWZnHVy1dWEmgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JWGI23wLIE0v2E+4M/GF44b5MZ5eGF4+/7sZCy6CgLQ=;
 b=X8ta0Xd26XBCBjOsWM4tzDLI71YNoOmzMSiHmKsWGrgf9G0PsApe+llJuZaqh5OETC9mq3kkFDF8NkeAFVV7Wd/EU3BjWpWT9CJI7UkvriPjSx8YXKkYGfTlRttcGy+hM4WoA8SzrLs2LlSZWsy8KwiARglv+0YBL0MzIrAUePhZSafuItbRPncI3TvrVYFUFUg1XufVJdKhfli0tQAo9exGZd2EE85+1VMEd02YsQ7BY54+lDg8CpDY5m2EV7vbUFWpjfaeV0xMeCvUdVjObW8VI77fTbvQgwV7xeL3SAjHZkOF2KF5qsSy9rNVXporahveNn222E7HPgfN4GaqzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JWGI23wLIE0v2E+4M/GF44b5MZ5eGF4+/7sZCy6CgLQ=;
 b=YuC7ReL5zLgZV9Wexb/B14pBNChwpOBYX1NG26163j/pxsMgjt35ZTO7ANaapaudKtIfFetVaxeP2Exry1tE3atKEkBZ/zzW0qFhEIRdiGVqiECHWLek5tPightbuP4JRmNZYW00K9WU+J3AdxNh+jYvTrppsB5wI+j+0wJJVpI=
Received: from DS2PEPF00004564.namprd21.prod.outlook.com
 (2603:10b6:f:fc00::51c) by DM4PR12MB6134.namprd12.prod.outlook.com
 (2603:10b6:8:ad::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Wed, 16 Jul
 2025 07:40:49 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:2c:400:0:1005:0:8) by DS2PEPF00004564.outlook.office365.com
 (2603:10b6:f:fc00::51c) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.7 via Frontend Transport; Wed,
 16 Jul 2025 07:40:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Wed, 16 Jul 2025 07:40:49 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 16 Jul
 2025 02:40:48 -0500
Received: from [10.252.203.104] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Wed, 16 Jul 2025 02:40:45 -0500
Message-ID: <216b4a00-3fff-46b6-ae09-b24690ace088@amd.com>
Date: Wed, 16 Jul 2025 13:10:39 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 08/11] KVM: SVM: Extend VMCB area for virtualized IBS
 registers
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, <kvm@vger.kernel.org>,
	<linux-perf-users@vger.kernel.org>, <linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<bp@alien8.de>, <peterz@infradead.org>, <mingo@redhat.com>,
	<mizhang@google.com>, <thomas.lendacky@amd.com>, <ravi.bangoria@amd.com>,
	<Sandipan.Das@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
 <20250627162550.14197-9-manali.shukla@amd.com>
 <03480d7a-7808-454c-8e3d-872901c31b1d@linux.intel.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <03480d7a-7808-454c-8e3d-872901c31b1d@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB03.amd.com: manali.shukla@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|DM4PR12MB6134:EE_
X-MS-Office365-Filtering-Correlation-Id: f21a8fae-a3e9-486c-9fe2-08ddc43c156c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NXNlV2Znem14bjJrWnRvQ2hDWGJERXk1d3N2dVBiemowRkFSVW1Ka2NtWWhh?=
 =?utf-8?B?bXczZzlTV0liTzJtL2gwRS9XS09VTlhaa2VSWVBWVEQySGRVMWRBdjd1bUtQ?=
 =?utf-8?B?dUkvQlR2WHJtalRKREpBdUFacnl0Q3lOTVh2SldWeCt0VWl0MXVyM1FoNGtl?=
 =?utf-8?B?ZVBkSWFXSkhteUU1ajg1UXh0ekxEZG12bEFGYXRsdjlCWWw0MlBXcjNiM3M0?=
 =?utf-8?B?TjVibjRZbjVUcHhBa1V5cWZEblZyQ2gwaURaS0VwYU9YcjhnUTQrU205MFc0?=
 =?utf-8?B?THZCeFpNWXRZMnpoenVlaHh6TnQ5YVF3K0wwdjgrWUdBbloxVEtYRkkrRDUy?=
 =?utf-8?B?SEl0MEovMmFBSHZHUzdTckYyVWM2ZEJkOFpsWnF4cENQWk5Lb21XZXdjalFk?=
 =?utf-8?B?ZzRJbjRyNTNId0dYWnVIemhaRTNaZmlGcWVERnh1dUtXSDQ5aE5HS0NlRHdH?=
 =?utf-8?B?bUpXb0ErSE9yNkpPcmNJMlZsVkhXaG5VaEtLSDhrdlgzUTlRM3UzVGJWZ0JE?=
 =?utf-8?B?RUZJVHhteXgvLy9VcjA2VVVtYnlLeWdGMXE3MTdBMlNSWFEzRzJMdW1PSjI5?=
 =?utf-8?B?WTd4OU1zdHdTWHhMVUduZWJYaVJDcW9Zb05nZGNFM3QrbVhNeHREL1dMZmVF?=
 =?utf-8?B?UlJyNm8wa0ZaRFdkNFdEODNBUjdUYUQwaFhLRTdUOWlDalE0dHh3emhnbE5k?=
 =?utf-8?B?dm9nNTRQMVFwcTBIQlVzeTU2cDZOOERLeGRzQ2lQem5hbDAxTFhtTXFOVnpk?=
 =?utf-8?B?SHYzdnRGbnZHOUpiRmM2b2UyWnJ6d2o0SWRKbm1VNmdYVE9vM3h4Rkx2ZlJk?=
 =?utf-8?B?RHlHcEt6TUJVQ0xaNkRReE5ZZEY3RFZVUERoWTVIczR1L05ZSjJBWG9KWC9V?=
 =?utf-8?B?Vk1rWDRGN2drS2gyTEYrbDVrNWlybDdWZW9BRFpyYWdRMElsMnVMeGQ3QTZk?=
 =?utf-8?B?T0pOK01uNGlJaTJ4MDNGUFlYNDd2d2hMSlB3SkNVaGU1UGNBazlWTnNaM3B4?=
 =?utf-8?B?ZzREcVQxTGU4SE83NWoxTzFYcGtzR1k5MlVsdG1VNlF0cXZwemkxWjNKTkxG?=
 =?utf-8?B?clNPRUtXVVg2a0puQS9ZcnRRZjRlM01kZkZiYk9OWlhOMmhsV1ZvM3JaZENt?=
 =?utf-8?B?VVcvYmNWMGpsTFoycTAvODRZRHN2b2lHTk9nU0h3Q2pjdVhhcHQ5NDAyc1RM?=
 =?utf-8?B?UzM3M2hXU2JYM3hORWY2eldmcXdzT3VmNDV0eWpqUTl6WWFuTWl5SnduQ1Ns?=
 =?utf-8?B?UThZMU8vOWkyclNQeEVUVzE1T0FBZnMxTWVGeDUyY1EraytXQlZKakRQVUla?=
 =?utf-8?B?WW5pTGFSZTRrZUM5Vkh2UzVmcEd4bW95L1E5Y0hJSlJWVVdtb1JqT0UxNGdN?=
 =?utf-8?B?aTllY0JSeUJRZFRYcHBmeDh3SytXYUFVMlBLLzlNM2pEUDhjdTNtUWc3cnBi?=
 =?utf-8?B?TkQ1UllhanU2OXVvaXVvVXJEb3FyU2tQaFQxV2xoSnpCMTFnNEVhZUhlaWE5?=
 =?utf-8?B?K1I2ZVhRYlVHOGdnNmJGUGZRdXBiRlBNYnBSaldxd2JHUWFJc09YZ0kwZHEw?=
 =?utf-8?B?VHNtTEs4T0Nta3ladUVNYmJNZHVYK096MUx5U3RPZms5VWYydFVKazhIUzF3?=
 =?utf-8?B?UE1hb0dqRGVLYkJyMWFvUnZWYzltbm5Ba1VSWk1tVCs3N3RyRjJNbXliR3Qx?=
 =?utf-8?B?V2IycWFkc1JMUmdoR0JiU3ZpSmhJWGhtWFMyYVN5UGRoeUM1eUZHUVlxQXAv?=
 =?utf-8?B?T3lHciszVXMxdDVMM0RBV2poak44d1k3WlZrQ21LaXBCMXh5MklLLzVNOXBR?=
 =?utf-8?B?SDEva2owdVJjQkpOVGlQd2N1Z0czZFhFL3VsRHlrY0pIY1llaGtWaGNCQmhQ?=
 =?utf-8?B?UTdNU0JWU0l1RGI4enZxbGZadFpkMmxqTEF5TTB6azA0dXJCRzcvWnc3b21C?=
 =?utf-8?B?ZVVrQnI5Q3RSaDZ4QmZlMnV0Zm1DTi9oZy8zdUlXY0hwOWN5dDB1OTBIVG5p?=
 =?utf-8?B?bmxRK2RUWU13aUY4YjFJTDVNMEV6OHA2dTJCN1VTdjBwZjJxWlRKN2hBY1dS?=
 =?utf-8?Q?g8e21l?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 07:40:49.2202
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f21a8fae-a3e9-486c-9fe2-08ddc43c156c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6134

Hi Dapeng Mi,

Thank you for reviewing my changes.

On 7/15/2025 8:43 AM, Mi, Dapeng wrote:
> 
> On 6/28/2025 12:25 AM, Manali Shukla wrote:
>> From: Santosh Shukla <santosh.shukla@amd.com>
>>
>> Define the new VMCB fields that will beused to save and restore the
> 
> s/beused/be used/

Ack. I will correct it in V2.

-Manali

