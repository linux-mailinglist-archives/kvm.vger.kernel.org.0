Return-Path: <kvm+bounces-55758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 40146B36D75
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 17:16:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E368F8E6621
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 15:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 985ED266B64;
	Tue, 26 Aug 2025 15:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KZaKk2L5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D5E25B1DC
	for <kvm@vger.kernel.org>; Tue, 26 Aug 2025 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756220844; cv=fail; b=RpUE4rfvpxfDWHcyo2QRrWN1Ybld9UCZ0DVKZ7a6M4/Ix2tq5p7DjQ9/wj18HuNVF/g37isXecAKRQ1r5RBvQnMBCktg9XUHY4RTUXbaCYn80sgy95s5ArNTQPtaoA1nvWjShowQPYCv6TM/ppamibyKezMa+I7R1gKJStvK8JI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756220844; c=relaxed/simple;
	bh=5hs7xUuSipxq7oMqmJu7bJoiInoV2Tq7994fZFidVhU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=n0cbFitHrRIDUhp6Po/EJiEKFuhFN2vgH2LEA4GGKtvM5LvP8cjusq0ZiG329EclY9UqYfafmHRuS23N8udHXGk4qNJWD3oL4jI1tbhuftFIL3sChbRkg4E1fnXUbbClttVucJhxV3ZhGw2QpMDt7a/YHSV35dKY+gwog48LpLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KZaKk2L5; arc=fail smtp.client-ip=40.107.92.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=asbvjX7JFXkjHRQD4oeomALC1WstICm/MyNMbAFJvB+oNssUydUCjXglnwD31jrDBMaJ/OkStLpeIEig2gaaOSTl/U74H3LAmhRIWWm5EDjqIyr/4nnBmd1c0Osb6KnbkF307aRGcJZmN0e6NdVwizbFg5t4UPY4QaXug+2mAGPcmVu6raUqaR2RtBGmhyfviutIIkIJzC0RqekantIg2iZILJ2Nt/nUXOxvQln8creGlXtCq0y9xvvQ87hshOQkIWTZKyOdk0YXiglE/dvmlKqDyJea5fn/lGXuqqMSiJUJpS1h5vklcofvmGsSIeXiSI2o7UTQVikT/jAxfTdaxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yRB+jEdkSETErBlgJ1/Vd5WU/Z8f4vfOk8dCa75anuE=;
 b=lXYnH0nHX12k3ZYjBpvHNLrjqbVIiJ66yyMQWK424YWXr858xmQ9KrmLQOFM29ymZ+4DshNdHwchxLMdotakXkRrZyDcpIg2pVa6DH1wSR4XMRX7gbH6j3/U8eJckbx6Sv1Tz59MnLyMhu9ffdc9JMGENsreH6R4AgB/FoSF3JPKwlCaTlgApC0c3ncaL0ZlLmLTNA9dqR75VvwWo/f6VnUuh7hXcVmQOpEBTJJGq+zlX3pftHLGeCg/B+pZnfL24vp8r7B8/6edCnR0W/RG2LMlOgKzbVYOuqDpp6WwTC7Azr4kVH3JWtOztZnQ273qqjbXcqh9HiEEdgmE5Iu7VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yRB+jEdkSETErBlgJ1/Vd5WU/Z8f4vfOk8dCa75anuE=;
 b=KZaKk2L5J9yD+oENows6MCKOFW6d/hWB9Dk9nBPIPyV35TeES/o5mdVpep3dvTFXXjUGKl0QVhSoPWddVLcR+KHNvfFB0qWBKWWNquNkX1LOpk3bR5pIMEP2bkHJCEi/7+enAqQDY04qCjJh8NLt5YSdX1wcyPmVpznS/9IoMeI=
Received: from SJ0PR05CA0058.namprd05.prod.outlook.com (2603:10b6:a03:33f::33)
 by DM4PR12MB8523.namprd12.prod.outlook.com (2603:10b6:8:18e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 15:07:20 +0000
Received: from CY4PEPF0000EE3A.namprd03.prod.outlook.com
 (2603:10b6:a03:33f:cafe::66) by SJ0PR05CA0058.outlook.office365.com
 (2603:10b6:a03:33f::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9073.13 via Frontend Transport; Tue,
 26 Aug 2025 15:07:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CY4PEPF0000EE3A.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9073.11 via Frontend Transport; Tue, 26 Aug 2025 15:07:19 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 26 Aug
 2025 10:07:19 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 26 Aug
 2025 10:07:18 -0500
Received: from [10.252.207.152] (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server id 15.1.2507.39 via Frontend
 Transport; Tue, 26 Aug 2025 10:07:15 -0500
Message-ID: <eef0e010-181b-491d-9b5e-91bc35bf566c@amd.com>
Date: Tue, 26 Aug 2025 20:37:14 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] KVM: SEV: Skip SNP-safe allocation when
 HvInUseWrAllowed is supported
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
References: <20250825152009.3512-1-nikunj@amd.com>
 <20250825152009.3512-3-nikunj@amd.com>
 <668a279d908bfdac33a0e64838d4276ec43fcce0.camel@intel.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <668a279d908bfdac33a0e64838d4276ec43fcce0.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB05.amd.com: nikunj@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3A:EE_|DM4PR12MB8523:EE_
X-MS-Office365-Filtering-Correlation-Id: c9e5e81d-effa-460c-cb76-08dde4b240b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eVpObVVDQVNYQ0s1Umc2YkNpd0dwYVlJOFMrdUpvcnl4RE5PckkxV3hCSWpi?=
 =?utf-8?B?WFpldHJqeFIrWmRQandCSDhLY2J5a2hmcFRxWEprTWM1Mm0zekxrTnAzT2x3?=
 =?utf-8?B?am9wdkQ2a3h2Z2E4NUZiM1dxUnVhRnF4QU5LNjIvQUt5MFVjbVVReFFocXA3?=
 =?utf-8?B?alNMOUVMenYwMG5FL0JlOFJuRnBVZ3lqcXZPNlo1cmQzQ2VLT1FHT2ZCaEJw?=
 =?utf-8?B?S3lqSW54bVRTZHUzTXZtQWpDSm16ampCdDlCVENUL0dZTG9lQlZTWE55bnRz?=
 =?utf-8?B?NWVNZUUwUEYzd3dZNDNhZlJQRmVkY3ZUR3EvWk9uYUVVckRPdXRWS3FWSXFB?=
 =?utf-8?B?WnZvc3NoMUdUU0pSQkVxdE1vdDkzMjVLazJ2VWpqQXBPSUcvbE1mUitUZ1FO?=
 =?utf-8?B?c3FVOUs4Sy9qcnBkTjlJL2NHQzN5c050b0pqemRKdDZVY29JOUIxZXlpR1o3?=
 =?utf-8?B?dXZFZVFvVjRkWjNvZ25TaHpnUVg1M1kzeXY1dWhVME00MU96VHBpbzJBTDlE?=
 =?utf-8?B?b2hiUWIwWVNRbEZNdW1senFjeEJpVEtRNGZ4cVpYL1I2Nk5rbjJPcTZOanFt?=
 =?utf-8?B?ZmhuR3d5VVB6TVh5Z0RtS3dZSXNvd1BkUm80d2JXMDhaS2w1c3V2TXgzektR?=
 =?utf-8?B?OHQ2K1JDdW4zOEo3VWdiTXhKdEhZMHZDYTBLTU4zUll1NU9UT25tSGZiUTJO?=
 =?utf-8?B?dXhlUTR1OXM2MmppQUpIQzJqTzJvUGV6Z0NyMHNNdG9FSDltM3FoaWxxSTdi?=
 =?utf-8?B?REs5VWRMdUJDeXVyTHV6VDRlQkRRYUttSC8yTTltUmxxUy8vM05rSHFST3di?=
 =?utf-8?B?REFFMjhIQU5EMlZnQ3YyRWE3MXBvc201VGM2VlJkelBIMFlSWW1adkFGQVlH?=
 =?utf-8?B?cmdCalI3MFBMcTE1eTFhMGRDbm14K2g0SUoyVlJVc0QxTUxjN094L2VxTy9D?=
 =?utf-8?B?d1RXd3dsak0wVzNRMm02QTI4MklRMU5KRUZWMjBsVmVWKzBhd3pPM0xqMEFZ?=
 =?utf-8?B?NUxueUM1ZXYxTk11b04xcEhxT0FtNWxuWWFrTElqSmhVRktZa3hrTjZCdFZt?=
 =?utf-8?B?S05iaU13L2x4TEVvV1VvbVJNRUNqd08wNmh2WXNBdEozbmwrdmZWbUtpZDN0?=
 =?utf-8?B?S1J6MzhwYS9iVEhreTVkMXJmMmg5SkpGdXRiV2gwSk83L1JicXlML01Sb0pD?=
 =?utf-8?B?L2xOSjBRWEdJVm1xYVpSNHhzWlg4VG5XYm1xckVFdjg1QVJQS1pWVFVYRWxE?=
 =?utf-8?B?bzVLTHlRREpZeEh4V3FqMUhCYS9mRnVzNnJuaWRXY2V0dExvZk1EbVNzRTFO?=
 =?utf-8?B?b1hTZmxWZW5sSVVhVzlWVm5HWjhGSTlmSmd3MXlnMW5iS1UwYkc5VldPU2ty?=
 =?utf-8?B?SERWc0dVTWE4YmcrRGw5K21laXNvd09ENFRkRHh4VDNaeTBWQ3FBa1pFYUNj?=
 =?utf-8?B?UjdmU25kbGxKUTh3dUEvZWlrSFRmMkN0Mml5L0JqUUFvVEg0Wi9WYTE4Z0g0?=
 =?utf-8?B?M2xMbnBGdjFzWkE4RkJOeE8zWCt5MTlIdTFkSHdBRVN0TmNSd1NaWXFTclZU?=
 =?utf-8?B?bFo0QXRKdWNwKzc1NXoxcUc1NnpOWDI2cEdyditPU3JobnRpYzNMdFRlYVpw?=
 =?utf-8?B?a083SDVqQzF2V2tIWjlEYm9JS3VSU2Z4YkNvdEg2WituMFh2N3VoM2ppYm9V?=
 =?utf-8?B?NHp6dU54Y1pHcG5mYUhoYVdLaEplSWMxUGh2cndNWTYzMlNpcURUSEdqVUlk?=
 =?utf-8?B?Q2xtNnNVd25qSGNQQ1B6eXd1Mm1vZjVEdHZoYjFyd1ErbTVEb2lOVGNUa0Y2?=
 =?utf-8?B?SHowak5UMGtUSGdjRjVBVktiZlRJcnVBUHprY25TbW9aTVYrQlY5bDdYQ1dh?=
 =?utf-8?B?S2dmQnA1ZHpXZ3ZLTUhFcktRMlFJV1NVZkl0NUlVSVk2VFpwZVVvVjlIRXha?=
 =?utf-8?B?TG93L1ZlOHZiaDVvZUw1eFp4OUNFSGd6TzBGWHlwbGdCVTRLQXdqZ043ZFY0?=
 =?utf-8?B?cFhuMDgwdkpKZnRHTWltdXV1MzZkVTNtR281aGE3UEJ6b2V4S00zam1jL3o1?=
 =?utf-8?Q?bC/o7T?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 15:07:19.6689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e5e81d-effa-460c-cb76-08dde4b240b7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3A.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8523



On 8/26/2025 3:37 PM, Huang, Kai wrote:
> On Mon, 2025-08-25 at 15:20 +0000, Nikunj A Dadhania wrote:
>> When HvInUseWrAllowed (CPUID 8000001F EAX[30]) is supported, the CPU allows
>> hypervisor writes to in-use pages without RMP violations, making the 2MB
>> alignment workaround unnecessary. Check for this capability to avoid the
>> allocation overhead when it's not needed.
> 
> Could you add some text to explain why this is related to PML?

PML works fine without this and the change is not linked to PML. This can go
as a separate fix.

While working on PML which was using the snp_safe_alloc_page(), Tom had suggested
to apply the alignment workaround only on the CPUs without HvInUseWrAllowed.

> 
>>
>> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>  arch/x86/kvm/svm/sev.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>> index 2fbdebf79fbb..c5477efc90b9 100644
>> --- a/arch/x86/kvm/svm/sev.c
>> +++ b/arch/x86/kvm/svm/sev.c
>> @@ -4666,7 +4666,8 @@ struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
>>  	unsigned long pfn;
>>  	struct page *p;
>>  
>> -	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
>> +	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP) ||
>> +	    cpu_feature_enabled(X86_FEATURE_HV_INUSE_WR_ALLOWED))
>>  		return alloc_pages_node(node, gfp | __GFP_ZERO, 0);
>>  
>>  	/*
Regards,
Nikunj


