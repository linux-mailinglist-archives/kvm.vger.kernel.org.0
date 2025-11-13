Return-Path: <kvm+bounces-63008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FAC9C574C8
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 13:00:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA56C3B7F37
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 11:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B34B34D4D4;
	Thu, 13 Nov 2025 11:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UcDjy4r1"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011026.outbound.protection.outlook.com [40.93.194.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B2333D6F9;
	Thu, 13 Nov 2025 11:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035108; cv=fail; b=QRIt7G681XiP8dsyJ5kiQubYLGDvRShOFkbvE3SxfSG9aEYsKl31Of50Ksp71GnF79LyGD2KOr2V8JS+nUXIFW+vwtqhElqNXjwZunfotxewJVfo9f6XL+LP6D4FAARheE+uLjQIi7ZDexl2icPa0unOXp4mVyj32Dak+YTMe3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035108; c=relaxed/simple;
	bh=1Cx50zctEONqefLPHiZnsthKGwF//2RYUKV+y8S5Tkw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Kx9dziDNP1riPl+n39pWou8OCYiDFBbGlRwj3f6s3cK3kCGeT+z9Nx6k41R6P6XaEQ5+05Px/qN6iSiSovTewmn4X8hd2H2Ctp5wbOdk67lSMeo9QQBh4rC/FafciiL0HqqvT9LX/yaxKvkqApIFX2XRkL8AOsgXpn/btGMbMPI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UcDjy4r1; arc=fail smtp.client-ip=40.93.194.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=piXKQxvJL5AogsA6CW4msQDjU0P7xWUm2wwqBWdPUkk7uE8/UF8fR43fg6Fh3Wv79gEwIEG/QFYb8M0tXeHc/XS6795q4gB+vkCPtfflkt1toUCgrtXp8S9DWjP3ag+bQZo9HD6V/mLak+2y99Q+Ux7KQ0KRNhc+CDvl1gaTkKnEzhaEtEkmd9AnHtBWbkJONu0kU7xvWOmtOEdp6NGGXHtX8eRBxQXiKYp2o78aAyvxq8sNwuNm6hha6LdlV6iuZ/zmUAOxIl1LzVWtm3qxMYBjnftLR4xXLOU+hqFOKKVVNWn1WBhlLAnNjUd1VN2kTc18f6hVw/rBQMhozPXTXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CNzkxJpEtbEfot+Bix7y83KXkacAkmVq2QVi+bvk6zM=;
 b=J9Fcqzf2fB1mv+FXiX/d8tkGngFoIJ/EV4eKXtC2kZqY3lWCiWKZG/G3FOl0LzpeaoKY1zq8aCC8ez5EoMyZuQJbKBp68XPpoRc8PZYxL7snwFDR75PcmJ2PhQpE0hlBZxzkh3MmX78qBvd/NP/rrbxlr7QPz4zm1ONvRvGa0qeBuVMg+vN9PAmpgXbtqNDC5KPWRRksuTSwXgE960s/92NKLMzsBzdXXnOUr75yIXmLf3SpfVrODykYcSCj4+HQZHpbLpOnAXenTnpPqc7pd+yr040W77bAMq82fWf3N2Hp+Tox83ipI6fTtmN9XBlBaiZCbIrChcmm70D+LB1kAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CNzkxJpEtbEfot+Bix7y83KXkacAkmVq2QVi+bvk6zM=;
 b=UcDjy4r1I1SPqxuEEtwm9DbBX4AkDJDOqRvKr937qlIEWm1ZvtzPaCDIClYEBYE8yK/XudkVGYm86UX18yK08sIiqOX0LIb9l0U4FgHccdWjYf25YztgoUokhNEmCeADBsD17jkhqXtvxuE7x6VpqeSfxY9+JNdL5fup9NBkdeM=
Received: from BYAPR05CA0017.namprd05.prod.outlook.com (2603:10b6:a03:c0::30)
 by DS7PR12MB6046.namprd12.prod.outlook.com (2603:10b6:8:85::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 11:58:21 +0000
Received: from MWH0EPF000971E3.namprd02.prod.outlook.com
 (2603:10b6:a03:c0:cafe::cf) by BYAPR05CA0017.outlook.office365.com
 (2603:10b6:a03:c0::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.6 via Frontend Transport; Thu,
 13 Nov 2025 11:58:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000971E3.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Thu, 13 Nov 2025 11:58:20 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Thu, 13 Nov
 2025 03:58:19 -0800
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 13 Nov
 2025 05:58:19 -0600
Received: from [10.252.220.243] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Thu, 13 Nov 2025 03:58:17 -0800
Message-ID: <1f39d5a3-e728-4b2b-a9c6-50cbc4fffd17@amd.com>
Date: Thu, 13 Nov 2025 17:28:11 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/14] x86/svm: Cleanup LBRV tests
To: Yosry Ahmed <yosry.ahmed@linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Kevin Cheng <chengkev@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <20251110232642.633672-13-yosry.ahmed@linux.dev>
Content-Language: en-US
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
In-Reply-To: <20251110232642.633672-13-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E3:EE_|DS7PR12MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: 49fa27e9-9957-4862-c72b-08de22abf0b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MjNoVGFzak0vQXdYMm5qWnhJWW1ZeGdsL0FMYnlueU1NVjNHelN5eldObWlH?=
 =?utf-8?B?Rkx4OHdUN010QkFDeW5vNTh6UUp6UEIxanlFeWxocHlZcWYxeFdQdmZhdlha?=
 =?utf-8?B?OGowMXBzYjMvTC9uTzB4OFpoR3Jzc1VYMnk5d0lrU2QrMWl1ZGRlT0NtbU9q?=
 =?utf-8?B?bHFTRFVGcENEVmJOOTRYcWJMakNuQm5TcEF5SERKVW5nV2xpTGMzN2JvUEl1?=
 =?utf-8?B?NFl2WDZFTEdGeTRzNmc4N3BCNDJIVTdCOE5ibFRPbUhJZG5lMGo2L1hiTWht?=
 =?utf-8?B?bWNSOFZVcUNzODc0MlZEeDVvS1pEUlJEN0l1Q05MTWtWcGIyWUk5bnVOc0Uz?=
 =?utf-8?B?YmFUbTZmUTA2bkRadkxTSlhvRi9wdzJCYjBKa2JMSE9MUDIyeVNLRVQ2eXFY?=
 =?utf-8?B?U25oUHprR0VyY1d6RTAzdWxzS2xMT1R4VWNRMXI2WWllU25qbHQ5Yzg3TEdr?=
 =?utf-8?B?aGt6cTVVNVBpU1FTSDYyb2tkWCsrZjkxcURJYnVPcVhHdnRPNGk5aklUM3hu?=
 =?utf-8?B?MnowUDRRZjRBQVFqTHJGZHRFN2ZHQVlETVhkYXRxYkYydGhraFY0UmUyYlF6?=
 =?utf-8?B?cW9leTRFL0VFQ21ock9zZVlDVjZMNWJWZUNSR1pBWnN0SFNnb29FeEFHbmNz?=
 =?utf-8?B?WHpCQ0orWkYxeDlJNG1NanpRekZYSW9zc2NGSk8vYWxpdC9LOERheU9lUGFU?=
 =?utf-8?B?RUttbjFYcGNGY3VvaWdGUjFMQ3d2UFYvUk02S3JYU3QycmR1NGV1dXBsbHdP?=
 =?utf-8?B?SHlwUlZNTGk2RXZ5dFlKbTNTV25PZ0ZsTkdKZk0vNjVkZXdJZGxsK05aT3Fo?=
 =?utf-8?B?RGdtNE93QkV1dFZLM0tIczA2dHNIelVySFpBYktIVERZRFVtYnYrcXFkSkQy?=
 =?utf-8?B?QVcreWFUMWVPNHFZdUs1cWV4clRwSHNDaVRTdVdEdmJHOGE5Q1Z4TzBpMlVW?=
 =?utf-8?B?ZlM2L3VCUWZDdkUrRXB1TlRXeWttN05rVnliaW9NWWRPdkd1WG1ISHhscUtP?=
 =?utf-8?B?ODRRRDVtZE5pRnJYdDJQSFRsdFR6NUw0czl2QnpNYUxwdTNtVi9CQWswMzZD?=
 =?utf-8?B?Z0Ryazh3K2Q4WlUzNWI4U0tua2lpcVlUNGF6Mk1Hbkt1akh3dVFZWWl0TTZP?=
 =?utf-8?B?aUVlZmpzTW9wMHVNa3NZNVpmRG5UTVpnUm0wRUo5L0ZjRHVWaGJKVTgzMlZF?=
 =?utf-8?B?ZHlrVlI4a0VtMlU2cjVWamZ0NFErYS84ckNUcC8rZFoxN2ZjMnRPZlY2YnBZ?=
 =?utf-8?B?YkRzOGowdGsxam52RHJkUmdvOUVyaW55YjhrTjdJSm1TVzR0a1ZlMFJwVGlG?=
 =?utf-8?B?c0JQd05XZUFJNUhQbTNRSjFxbDh6Y2Y2Ym84T1lzeW9YaStrWmQwKzFzamlS?=
 =?utf-8?B?YXpqSDlIL0twMEkvelVQVjlVQVVFaDBvZnAzYWF3RklBQW1jWW0rU3JpbEs1?=
 =?utf-8?B?U08zSDNab2JuS29HNjd4dWF2RW9pMG9tM01OOU93NnozYy9MYlB3RVNZWEVF?=
 =?utf-8?B?MFFaRVFLK3pTdUdmV3ZLZkE5cG5aZDdPOUduQlQ3RHZoUU5RNWdGcElCWExZ?=
 =?utf-8?B?VVFHVmJMcHBhRGJibUtpRitmQkErUlRnQjJ1RU9zUzR4MnhPMnE0VEtSZ3pp?=
 =?utf-8?B?SkVINkljZjFnTTNXVzhOcjR0bDNPUU9NOUY0T2daelo1R0xLb0NNNWYwTG92?=
 =?utf-8?B?UUdReHNoK0tyY3ROalpWM2RYZXZVTmhmNkg2WThsaG5EUXRyczhxRndLd3Bs?=
 =?utf-8?B?RkJ4aml6aXFrR0UxZGdaanZZSzZ0ZnFqekFJY2tDcHVPWDVoTHhmUHZQc05U?=
 =?utf-8?B?ejlMNGZkLzdUQXp0WllrSk9XdlVhZXZzZzdMZXdiaEN5dHR4OSs0MURxSUwx?=
 =?utf-8?B?VGl4UG96MmhJejFqQ1U5TTZMOFRSMktxWUpUZkhXWFlVWkJwK1BYT1ZYLzl3?=
 =?utf-8?B?SXZuVVh1VFB0RVdkT3UzcDlXQTcvSm5KdnVNUFIyOFdlVlpXMm55R0xpS0V2?=
 =?utf-8?B?UVpIcUVhSE16TjVOU1VTL0s3dDlDZXRZOFpuY2Z2b0k4MURsTmZocGd4VS9v?=
 =?utf-8?B?Y0tGNDdMc1dzekN6Y2dTaWtKSmJxajFJSFZ4SmdaT2xzaENoNEJvL1dLblNO?=
 =?utf-8?Q?rUSQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 11:58:20.4720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49fa27e9-9957-4862-c72b-08de22abf0b0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E3.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6046

Hi Yosry,

I tested this on EPYC-Turin and found that some tests seem to be a bit flaky.
See below.

On 11-11-2025 04:56, Yosry Ahmed wrote:
> @@ -3058,55 +3041,64 @@ u64 dbgctl;
>  
>  static void svm_lbrv_test_guest1(void)
>  {
> +	u64 from_ip, to_ip;
> +
>  	/*
>  	 * This guest expects the LBR to be already enabled when it starts,
>  	 * it does a branch, and then disables the LBR and then checks.
>  	 */
> +	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);

This TEST_EXPECT_EQ is run when LBR is enabled, causing it to change last
branch. I tried to move it below wrmsr(MSR_IA32_DEBUGCTLMSR, 0) and it works
fine that way.

>  
>  	DO_BRANCH(guest_branch0);
>  
> -	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	/* Disable LBR before the checks to avoid changing the last branch */
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);> +	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	TEST_EXPECT_EQ(dbgctl, 0);
>  
> -	if (dbgctl != DEBUGCTLMSR_LBR)
> -		asm volatile("ud2\n");
> -	if (rdmsr(MSR_IA32_DEBUGCTLMSR) != 0)
> -		asm volatile("ud2\n");
> +	get_lbr_ips(&from_ip, &to_ip);
> +	TEST_EXPECT_EQ((u64)&guest_branch0_from, from_ip);
> +	TEST_EXPECT_EQ((u64)&guest_branch0_to, to_ip);
>  
> -	GUEST_CHECK_LBR(&guest_branch0_from, &guest_branch0_to);
>  	asm volatile ("vmmcall\n");
>  }
>  
>  static void svm_lbrv_test_guest2(void)
>  {
> +	u64 from_ip, to_ip;
> +
>  	/*
>  	 * This guest expects the LBR to be disabled when it starts,
>  	 * enables it, does a branch, disables it and then checks.
>  	 */
> -
> -	DO_BRANCH(guest_branch1);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	TEST_EXPECT_EQ(dbgctl, 0);
>  
> -	if (dbgctl != 0)
> -		asm volatile("ud2\n");
> +	DO_BRANCH(guest_branch1);
>  
> -	GUEST_CHECK_LBR(&host_branch2_from, &host_branch2_to);
> +	get_lbr_ips(&from_ip, &to_ip);
> +	TEST_EXPECT_EQ((u64)&host_branch2_from, from_ip);
> +	TEST_EXPECT_EQ((u64)&host_branch2_to, to_ip);
>  
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, DEBUGCTLMSR_LBR);
>  	dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
> +	TEST_EXPECT_EQ(dbgctl, DEBUGCTLMSR_LBR);

Same thing here as well.

> +
>  	DO_BRANCH(guest_branch2);
>  	wrmsr(MSR_IA32_DEBUGCTLMSR, 0);
>  
> -	if (dbgctl != DEBUGCTLMSR_LBR)
> -		asm volatile("ud2\n");
> -	GUEST_CHECK_LBR(&guest_branch2_from, &guest_branch2_to);
> +	get_lbr_ips(&from_ip, &to_ip);
> +	TEST_EXPECT_EQ((u64)&guest_branch2_from, from_ip);
> +	TEST_EXPECT_EQ((u64)&guest_branch2_to, to_ip);
>  
>  	asm volatile ("vmmcall\n");
>  }
Reviewed-by: Shivansh Dhiman <shivansh.dhiman@amd.com>

Other tests look good to me, and work fine.

Tested-by: Shivansh Dhiman <shivansh.dhiman@amd.com>




