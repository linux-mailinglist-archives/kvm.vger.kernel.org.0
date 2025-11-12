Return-Path: <kvm+bounces-62877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89B43C5297D
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 15:02:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 227E03B9B9E
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 13:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A91B6230BDB;
	Wed, 12 Nov 2025 13:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KUOTsDJE"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010031.outbound.protection.outlook.com [52.101.201.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058F32206A7;
	Wed, 12 Nov 2025 13:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762955321; cv=fail; b=Hg3jwh5aeZLuVNlsu2MMdvuc/Yg/BRhYDbsIlAjFW7wXq8+t5Wkux4MRsftHnUVBi/Tb8eYS+b3tR5FFcyZQ1wE2nc0XMUxBFRtUPl4BiKpuudGXBHWLjRNA+/w/Mnl9e3U6hFbOrUtZBDUuM1l9USOM5YGyoKUf06vLH3Crn3w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762955321; c=relaxed/simple;
	bh=yDcjdrE5aAXhJK98sbV32wSUrOLlU3D1VXZs6SnBqFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=nv0nEXDN46+4Eb7SE0rcQ8mbTNbv4s41VW1MqoTBSyobOUOajK3LADZ3yeNx26WfR9Br74wJX5t8CAmNbpCsPXgwoI2MZDHCRt38gveBPzUulvu+bAquDszmOactMvamacqIdSbOt88Tdz89lEESNuEW8d8F2bzxFU7W2oEnYNM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KUOTsDJE; arc=fail smtp.client-ip=52.101.201.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nm4NVpS5hBCUnlLxFJ6vmOg/mQcnPR/YKCqdJ1NcB97ul4Idq4XTStEPlsH5YXKsUTAbZdjA0SfhZnc4AUIjTZe9HtLs+4UdxiIELirZ0lr8BEcMzyGZ/fe2tp7P2v40xsCG+GJ7cLMTnrSJlia644d1Xuja49RcX7Pd0E0xfhy22gWDCT80s/knVl38dzCBoaFBWn7ncIR/Z5j7Tbf+QME1IbyVORJ235guuWddQvomq5n8pAugvK0HHiMfeCbsObfkKkyu3O9DyRxVNQDD0IdXM5Q2s+Ttrkc/KnMJnYwplrLx0g7EsR4yWsroLpBVMFvPHI713PHJLUQ6cpPhLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Gi8wXJIcK949+luYbPeqaabQkqRPEa3kPjn6CqP5IE=;
 b=VtNfe65qEq98j96JQz5Ghb6Tmt7ukGgEDxOAScUINt4stjpEB84Eo5BvBbkx4xBI2oQDovnsLA5webHhEM3ldzU/esYMevc/T63vKNHjr8oIH2NxFZYfey9k6EfRRFE+gF4bEpFw+vLarSnG1VMI1zajP1B5DysaPI6DPGNDy3Hnoz1v70kb3rj8vLVHs7lZIkkClH0kE334OuMcLCe/gEvN3767JZPcPaA894dv7MdiWAULqig/tfzgZqQlmoFM27m1GyDCj6B6INaUpfvqKPra6S98ITXV13nS9P9ME3Q2IbOjH0M1ge3WCoWbkT4XojH057HzbsVSdmTZdnBpfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/Gi8wXJIcK949+luYbPeqaabQkqRPEa3kPjn6CqP5IE=;
 b=KUOTsDJEczrS8Dz5c/HmPe3vkF8vyqyra071MlkbRpqsRDrzAzw7lCpC78MCiu3ORl02J8ljyMcmtSXxHUtjnDjgmPf2DLvYKBgzkRKBLG+w4k6XKbJ9eE5cQOqLdCU7lgojEHs8O2a1fbTCzrPZvbstrSPWcxxWQqmeLeBzl1g=
Received: from BYAPR21CA0030.namprd21.prod.outlook.com (2603:10b6:a03:114::40)
 by BL3PR12MB6546.namprd12.prod.outlook.com (2603:10b6:208:38d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 13:48:34 +0000
Received: from SJ1PEPF00002326.namprd03.prod.outlook.com
 (2603:10b6:a03:114:cafe::a7) by BYAPR21CA0030.outlook.office365.com
 (2603:10b6:a03:114::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.5 via Frontend Transport; Wed,
 12 Nov 2025 13:48:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00002326.mail.protection.outlook.com (10.167.242.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 13:48:31 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 05:48:31 -0800
Received: from [10.252.219.240] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 12 Nov 2025 05:48:29 -0800
Message-ID: <3cbc2be4-11f4-4ff2-989c-8bf7083c0f0e@amd.com>
Date: Wed, 12 Nov 2025 19:18:28 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/14] x86/svm: Cleanup selective cr0 write intercept
 test
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
	<seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <20251110232642.633672-4-yosry.ahmed@linux.dev>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20251110232642.633672-4-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002326:EE_|BL3PR12MB6546:EE_
X-MS-Office365-Filtering-Correlation-Id: 38868fc6-396c-43ad-a9e0-08de21f22aec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N0wwZjRmT3pTeGpsOVpvUU9FTDNTZkYrNi9WRFBDd0p4YVk3NXhyWjM4cW9s?=
 =?utf-8?B?NTl1RFNhSlZaOVhCKzJPb1N3NmE3M1VQZndJUGdUMG1UMzB3VnV5Q3Jlb3R4?=
 =?utf-8?B?TGVlL1YwdTZ6c200bllxNmpoclNFczVkTkdTcTBOUzJqRHRvTzc5SXVLTC9O?=
 =?utf-8?B?RkRzdk9jUmpwUzhtTWx6WXZDc3lJeVRxQ2JHQ0kwUElQcmoxTmxVNURzVmNo?=
 =?utf-8?B?bzJvOGxER0ZJdFJ0VFltRnZ3cnlLYlJ6N0h6RzYwL3JzeGMycU1JdmVzditr?=
 =?utf-8?B?dktzeGhDL0I5Z0JmNzBpQ1oyR2pHakY1NktjSEt0NGQzTDNOcEVhdmdTd0Z1?=
 =?utf-8?B?QXZDUUFqYzVQUG54ZFpIZ2JVeWJmcFY3TWdXZFprMXgwNDlYZk5IK3R2RUg1?=
 =?utf-8?B?a05FNXVrRjQ1SXhtSGlnWUowUkJLNVVVTUNuVlpaM21mZElqYXQyTEZKeEdk?=
 =?utf-8?B?NHRLdWlwWitESEVjZm5JSGg3dXlLR28wRXdzcGFIdEdYMTQyMWwwSWVVMUhs?=
 =?utf-8?B?TWduTU5XcncwbEIrTktjUzdpTVFaMGlBWVJoUGtpOWhCcXpDWHBjZTI4eWg5?=
 =?utf-8?B?RW9BZ1dzQnF0NjVvL1NYNisyZzg5NGwvUHptREt5M1dvanRiVzFqSHBkd1cy?=
 =?utf-8?B?TlJLQ25EN3E1eFp3TWREOWFSU3FrM043MzJuOGdIMzNJZEdTeHdidi9TYlZo?=
 =?utf-8?B?VGxVNG9naHdDTjhhSEM3WUNNRi8xdnFTdHFmRW5TNUxZYXp4RUlGTzB4M2Z2?=
 =?utf-8?B?UmFBNWozdE9XZTgrQUwrT1MyR2Y2b0NvVG51R0hEaVg3ZzRHakhSamtQM0lO?=
 =?utf-8?B?MHh1UkxKeGhtVktCR09hMnpTUU1Vd2xaQXJoYjZnbWhNMng2b0FNTFFrZGxa?=
 =?utf-8?B?c25tblBKc3BaRkVZS3E0WHNuVlZ6THlyMTRQdjZMMDJacTlUNGltdW1yTXdM?=
 =?utf-8?B?c3ZQa0FmUU1DRm5zRFJyYy9QVDdJOEM4YW5pR2hFUHBwQ3hIVDdSYVZRNVZu?=
 =?utf-8?B?K2k5cFBHU1IycThLdGNkSyt6RVJSNm9TR1AzTG5McXVuSTJ4WnpKakEvUm5z?=
 =?utf-8?B?VFM0aG9DUWJpcDdsdDQ2TWJ2Y3NweVRwUUZnOVZsK0FXRTRucHorTk9tS3lI?=
 =?utf-8?B?c1dRbHFVVkVUa1FJZnorcCtzcm9KN0hJRzhUVlYzWEM1YlZHaU1KOUhnUnhE?=
 =?utf-8?B?bVcrN3A3TVpULzRWQUREWHozVzZyNkpWaWdac0FLeGZxaCtuQ3I1VWdpck43?=
 =?utf-8?B?and3S2JHQy9FZmxIcENQTUMyRG1jd2xlKzNTMjlGS1RhZ0puU00rWnFqTzdF?=
 =?utf-8?B?WnU1SXl2WlBjQ3piRzBzVGhtZGZTU0ltdGFuV2xiWUZXMzJValQ4dUoxTDVk?=
 =?utf-8?B?ejdXNFZWdENhN2R4ZGJXQlVzMktPUDZRL1hBQlliQWd4eGl1bkFGVGJIcXVj?=
 =?utf-8?B?SUNrbkk5dHJ0YzZCRzlrNU02eUxiR1BYYUpUNk1icmZINlJZT280ZU9aRFVl?=
 =?utf-8?B?eWV0NzJ2MzQwcE9rM2U2dWtMUVFTeno3Qks5NFo0QWdQVnVXUzRwN3o1YWww?=
 =?utf-8?B?Qnd6NFJJa1I1TnZCVGNacmdGMlJMeVVWeEVJazVJRTJteWtweVZyS0EwYkoz?=
 =?utf-8?B?aldjK2FnWFBOL2RtV0hmTjBMRFZTWnUwNGNpdEh6SWJhdzQyOXJFcFdaczdM?=
 =?utf-8?B?ZldscTRZeDFzaFh5WXBzbFFBa3ZVcUJHd3NaUWxUcllGM3k0enBBdUtaNTlH?=
 =?utf-8?B?N1l6N2pNZXdwQTl4eWhETkZsdEtkbWZHV2Z5aG5aTnRlUldyMXpWM2FUTHBu?=
 =?utf-8?B?T2ovdGNGaG4rRUFUOTB0KzM3QkVjMUFiR1BleVZnK3M2SGxxZTlLNlVrRFJt?=
 =?utf-8?B?TVhWSjNyTHh6b21qcHRreGlENHE4U2xuSXltNWl5cXZheTQ5dzQ2bjczSkV4?=
 =?utf-8?B?dXN4dk9KRXJLd1hYenhwSzkreURiZUVPaXQ0Rzd2RDFpVlRxblh5R1JOT3RN?=
 =?utf-8?B?aWtKV1hWRmRmcVh0S2lpa1NTVnVnMVZzWEFHSzBOZHJNUkp6SDdRSE41N0F3?=
 =?utf-8?B?aDg5U05jamQxaTlWVkQ2UE1aN01KMXhtVW1CZG1PYWtobG1HZDVLekk5NlM3?=
 =?utf-8?Q?8QVc=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 13:48:31.7766
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38868fc6-396c-43ad-a9e0-08de21f22aec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002326.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6546

On 11/11/2025 4:56 AM, Yosry Ahmed wrote:
> Rename the test and functions to more general names describing the test
> more accurately. Use X86_CR0_CD instead of hardcoding the bitmask, and
> explicitly clear the bit in the prepare() function to make it clearer
> that it would only be set by the test.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  x86/svm_tests.c | 22 +++++++++-------------
>  1 file changed, 9 insertions(+), 13 deletions(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index 80d5aeb108650..e911659194b3d 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -793,23 +793,19 @@ static bool check_asid_zero(struct svm_test *test)
>  	return vmcb->control.exit_code == SVM_EXIT_ERR;
>  }
>  
> -static void sel_cr0_bug_prepare(struct svm_test *test)
> +static void prepare_sel_cr0_intercept(struct svm_test *test)
>  {
> +	vmcb->save.cr0 &= ~X86_CR0_CD;
>  	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
>  }
>  
> -static bool sel_cr0_bug_finished(struct svm_test *test)
> -{
> -	return true;
> -}
> -
> -static void sel_cr0_bug_test(struct svm_test *test)
> +static void test_sel_cr0_write_intercept(struct svm_test *test)
>  {
>  	unsigned long cr0;
>  
> -	/* read cr0, clear CD, and write back */
> +	/* read cr0, set CD, and write back */
>  	cr0  = read_cr0();
> -	cr0 |= (1UL << 30);
> +	cr0 |= X86_CR0_CD;
>  	write_cr0(cr0);
>  
>  	/*
> @@ -821,7 +817,7 @@ static void sel_cr0_bug_test(struct svm_test *test)
>  	exit(report_summary());
>  }
>  
> -static bool sel_cr0_bug_check(struct svm_test *test)
> +static bool check_sel_cr0_intercept(struct svm_test *test)
>  {
>  	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
>  }
> @@ -3486,9 +3482,9 @@ struct svm_test svm_tests[] = {
>  	{ "asid_zero", default_supported, prepare_asid_zero,
>  	  default_prepare_gif_clear, test_asid_zero,
>  	  default_finished, check_asid_zero },
> -	{ "sel_cr0_bug", default_supported, sel_cr0_bug_prepare,
> -	  default_prepare_gif_clear, sel_cr0_bug_test,
> -	  sel_cr0_bug_finished, sel_cr0_bug_check },
> +	{ "sel cr0 write intercept", default_supported,
> +	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
> +	  test_sel_cr0_write_intercept, default_finished, check_sel_cr0_intercept},
>  	{ "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
>  	  default_prepare_gif_clear, tsc_adjust_test,
>  	  default_finished, tsc_adjust_check },


LGTM

Reviewed-by: Manali Shukla <manali.shukla@amd.com>

Tested on AMD Genoa machine. This test case works as expected.

Tested-by: Manali Shukla <manali.shukla@amd.com>

