Return-Path: <kvm+bounces-62878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CB02C5297A
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 15:02:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2E3FB4FAB99
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 13:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6315023E320;
	Wed, 12 Nov 2025 13:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MuUccef3"
X-Original-To: kvm@vger.kernel.org
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010049.outbound.protection.outlook.com [52.101.201.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC800229B12;
	Wed, 12 Nov 2025 13:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762955579; cv=fail; b=q3IuEyST/b7hiHOgCdOXtFvtGxZaGVBy3Qcv8Mr65xjPXRPc3JSguF4kpUwrv3uMg7CVpmwVfzh8+PUMhyVa1z8H4qRIWHaZtrN8PnwdJEUj5c9giccBxPcr+mV/dTY97FpTX6NUrH2BgcgCvEZpuPOzPjsn06LvpXNaJjkyqU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762955579; c=relaxed/simple;
	bh=pnyd25uGzFjEfyAJTyKed9scWvHqCkrp+v5hOy86gFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=XVdsWtd6PQ69Ad9Y5ARu+r47KIiK3S94doqsJL7fJX9xg6KvsjEdvbbyqHWC1vvRKh0ySu9BhnksUkXaVSO13v2mrv4hZ6wLTFEja89FwPzA5MD+MNRKP8ZrtiYI64p7uXfNlKs1qIHAjx1KwXHJf+lR9YaAT4hV34iRJO0ghkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MuUccef3; arc=fail smtp.client-ip=52.101.201.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EaaST1IAezGiybIb4GidbF3oiKtKEadFwChXKBNA9mpToCzqH+Uvo+FQ4VlxYWS6qP+FCIe2won/diTV4ma6JBzoTfBlN3bpRcVoiRoid8H02JvQtEys+02Q/olc+kOevdqNlJ0BpHPnej9A4DN0GdFly6JgBJSdJiZO0BYtOmXnItlRecW3oyS5bo9I0dIMiGE1n2oe2uR0yw7F2oL25sbNeMIVg8garF0Iwkcyt3D2jZiIC8dU2GGXeNB8a06bT/dL9WaGv4zUmPbr213n7LGrwiyvjQ3THpChihV/tBW0Jc6SvZVDjX3G58jDyc4Upn+bDFGaiXo056dmVOWmcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILVKLe2Jvle93QGmwsacPY8/YejLJlqxz2i2pA+fy48=;
 b=DDv/GqKFlKnCsyKVUwvTNizGWa705IZgccQVxy7TC3MjGaOb/o3unsOBpo0PDfYwu1NiCHWQ1ecQOrIi+cYuY+TBSQVl6cEtgKN0k/5wF/BFA2Eh4komrAQghTdk9ByCXU6lnCWadR5g0yBS0VCDvrGka/IxJF7hIDk35Ic8z3mQKUaZVrVemABF9BYqhTpTirNQcvJGMIcTz0hgdF99aBDXeVjsD6PchdcjS+EmiqLh431ZcvJLlXv01FyWPR6KtoFP4/hf4r1k+wTRZmN1TEjqHMXEUR2WGvb5T753MBRpHGznIfvU5STS/P6YT4amxk6BlIiJBaUX4G6QsBsXFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.dev smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILVKLe2Jvle93QGmwsacPY8/YejLJlqxz2i2pA+fy48=;
 b=MuUccef3dTX+dwLaTqe6zMMp5JgzD5SkpHVhbPPJKMRb8sPEP+4aBW6kK1n/Jj6rGzan0dAooqR0m3YWMk3jw372842ToNzcVyUR4tGxVZkJjwgGD/Dd4A1bcgRKxYy8N/4o/3CXXMJW7+thYJJmQfAIpwJH4qA+cPM4Z7XtTzA=
Received: from BYAPR06CA0009.namprd06.prod.outlook.com (2603:10b6:a03:d4::22)
 by DS2PR12MB9797.namprd12.prod.outlook.com (2603:10b6:8:2ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Wed, 12 Nov
 2025 13:52:52 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:d4:cafe::7a) by BYAPR06CA0009.outlook.office365.com
 (2603:10b6:a03:d4::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.15 via Frontend Transport; Wed,
 12 Nov 2025 13:52:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Wed, 12 Nov 2025 13:52:51 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 05:52:46 -0800
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 12 Nov
 2025 05:52:46 -0800
Received: from [10.252.219.240] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 12 Nov 2025 05:52:44 -0800
Message-ID: <a3163ebf-86bd-42b7-a413-7a936a6a92d1@amd.com>
Date: Wed, 12 Nov 2025 19:22:43 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/14] x86/svm: Move CR0 selective write intercept test
 near CR3 intercept
To: Yosry Ahmed <yosry.ahmed@linux.dev>, Sean Christopherson
	<seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20251110232642.633672-1-yosry.ahmed@linux.dev>
 <20251110232642.633672-5-yosry.ahmed@linux.dev>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20251110232642.633672-5-yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|DS2PR12MB9797:EE_
X-MS-Office365-Filtering-Correlation-Id: 4423c206-9976-43f5-3cb2-08de21f2c5cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHZTVThraDdEeUl0dGNDYTMyaE5SR2ZlRnA2NVVQaHZGQ0VhRDZkeU0vSzRQ?=
 =?utf-8?B?V0Y2RXZseHBPR1ZsNTZ4NDRGOEFmWGhaTFUxUGxtK0VXVXNrNGpLY21NQmc1?=
 =?utf-8?B?NmN0R0JMNExHUzBZTnhVVnBoRnZrSDZWYkRpSG1pMDJLdzR0U21uNkozbDR3?=
 =?utf-8?B?bHNrQktlb2d3RCtqRllIRGFXclpPSmF0djZBekVpdkVVbUZJelpxMUVYdHRF?=
 =?utf-8?B?QkY1VWUwcTlQUGIyVjk0QUdyZDZuaEJiT2J3KzVmRlIyYVBOcE9yQituN1Rt?=
 =?utf-8?B?RjdWeGNDTVVTVUFPTDltWEpwUUR2cW1rUVR1em1PR2VkbVNOYU9uWTJmR3lU?=
 =?utf-8?B?OCs1T0FzTURSZ3JCalVuY3ZMK25XRmFVeURDSWNkbzF1c3E3emtZOFpuMWFy?=
 =?utf-8?B?Y01CRWtHVjcvMzREQVhtQTA2cjJxcys5cDBvelR2am4rV2JGbjNTK1ZVYnFY?=
 =?utf-8?B?c294K3F6UDNUQ002aElWdHFXUGt5Mnlhd296OStjVDlkbmxpUjdSb1JZVm9o?=
 =?utf-8?B?UVQ1cFdPTDJrUC81ajMzWnE4bkxNaUxGaEpER2Q5cGFiUE85S1FRTUFjUFNn?=
 =?utf-8?B?dDl3QWVjVXMrQXNxbW82T3R0QUoveC9qVG9Fa0duNXludnh4bDJCbTZPSVhS?=
 =?utf-8?B?em5lLytDK2tqVk5mdkFNZWtlZDBiSTZWS1Y3ajVsd2RvQ2RrVzZNKzVuUlZo?=
 =?utf-8?B?WmxnRXZlZk9MRGRYTW5kd29LWFZnL1RXYXVzUEhKRkp2OEoxcnVLR3VaUTgr?=
 =?utf-8?B?UzI2cFd6RDlHeHNlZk5WQ2c0LzE4akxSUEM4ZzFOcjZuUkdEaWFzU0tnbjI5?=
 =?utf-8?B?VE1EbVAvM2IwSEdsTi9Ua2JIUG9qRmNsd21lY2tEWlRINVRzY0t5VHltZmgx?=
 =?utf-8?B?c0tjN3RCc2E4K09mMS9HeFNZdUlHU0g3VnRKdStCUWdvRVNYbktMNll5bmJZ?=
 =?utf-8?B?TUpmY1k2N1lyWTZoSnJvZjdGTTZoZzhxZ250aGg0VUo4RC9MeDV6K2pRVjRa?=
 =?utf-8?B?bVk2Qk02eUk1d3hzZ29VaU52WUc1V0JJVWRqeHVHZ082eitIR1F1dGdCbkNQ?=
 =?utf-8?B?dlFRbUZsNkJLd0RHZ0RGVXpVY3lpYzduR29NNmdtTEgwVUVxS3NXTWZIeVEx?=
 =?utf-8?B?Y3ZmU0l5Uk9NSjJqOXMwSG00UytnRFVHRDc4ZjVEbDdUT3lSZGptZTJ2azA1?=
 =?utf-8?B?TVBiSkVHbXdyYmNpZWhpKzdnNnhobW1sRk53S0NxNCtqNmJQS1RiaWhZZC9q?=
 =?utf-8?B?aEpJWXY2YUVHaUxJZ1BRVTk1anpOaklROVVBUmVkYWRCZUZxZUl6STRqWURH?=
 =?utf-8?B?dUtjeTNmUzZzTFJNbHA4dzVPU2hSS1cwT0JqUDRGakhURXFwZFlKM2F6QUVS?=
 =?utf-8?B?dVNoZmZCZXg2NGtBL1RmVUxKVzRwb0hqVFJsenl1T29TcW1hd0Jpc25jMjZU?=
 =?utf-8?B?OUNVa2x3Wk9FYzN4VkZuMmFNeklCS1IxMklyYjROSHVRSjBpbnRDV015NXMy?=
 =?utf-8?B?NEFncVRBWUtVSG40MkxsUjFlSGk5WngxcEVzbGg3dEpTOCtPcG9UU0pwZFFu?=
 =?utf-8?B?WDRMYW5wS3FiczJPMXdSYnRSMXdMZWFYem1YeFpvZWJOcEVhL2p1ZmZ2SlBO?=
 =?utf-8?B?NHZicjU4Qk02dGJ0bDF4RGhhakYrOE5Kc2E1Rlg3N0MranhWc2lZbVF0WUVs?=
 =?utf-8?B?M1ordDk1N1gxUEtZY01vQlZCcnJnUkIyQjY5azV2c2hYUHovdCtBdEpwL0lD?=
 =?utf-8?B?VW9YS2Zld3pZT2dOdi9qTlhleUlaSFQ2UWxmenJKVzI4UDEvUExWb0xvMzNl?=
 =?utf-8?B?NGUrMUtQTDlsaGsydisyRXVueDFwQ0IyUnFEaXhKTVJyM0lDcGZLOUxCMURP?=
 =?utf-8?B?QURncjIvbUJpOUd3bWxBNVlCLy9kWDVYRkJLemdkbzhpSFpFbVJkQ2w2SlI5?=
 =?utf-8?B?dlJBZ0gwNU14L21YRk9VY1JvRVg3dzFQc1VzYk1RVFROZ1NjSXB6dWlZK3NK?=
 =?utf-8?B?cy9JaW9lQ0c4UU5mamdzSG4zclM5K3pPUnpqV0JCejRoZnpiS0YwYTRodGFy?=
 =?utf-8?B?Y2FWQWJuWUhpcFdHalZkQTE5eHZSTGpaa1RsNnEyaW91WmZMZVRjSFNwdFJG?=
 =?utf-8?Q?yFmg=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 13:52:51.6179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4423c206-9976-43f5-3cb2-08de21f2c5cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9797

On 11/11/2025 4:56 AM, Yosry Ahmed wrote:
> It makes more semantic sense for these tests to be in close proximity.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  x86/svm_tests.c | 64 ++++++++++++++++++++++++-------------------------
>  1 file changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index e911659194b3d..feeb27d61435b 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -112,6 +112,35 @@ static bool finished_rsm_intercept(struct svm_test *test)
>  	return get_test_stage(test) == 2;
>  }
>  
> +static void prepare_sel_cr0_intercept(struct svm_test *test)
> +{
> +	vmcb->save.cr0 &= ~X86_CR0_CD;
> +	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
> +}
> +
> +static void test_sel_cr0_write_intercept(struct svm_test *test)
> +{
> +	unsigned long cr0;
> +
> +	/* read cr0, set CD, and write back */
> +	cr0  = read_cr0();
> +	cr0 |= X86_CR0_CD;
> +	write_cr0(cr0);
> +
> +	/*
> +	 * If we are here the test failed, not sure what to do now because we
> +	 * are not in guest-mode anymore so we can't trigger an intercept.
> +	 * Trigger a tripple-fault for now.
> +	 */
> +	report_fail("sel_cr0 test. Can not recover from this - exiting");
> +	exit(report_summary());
> +}
> +
> +static bool check_sel_cr0_intercept(struct svm_test *test)
> +{
> +	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
> +}
> +
>  static void prepare_cr3_intercept(struct svm_test *test)
>  {
>  	default_prepare(test);
> @@ -793,35 +822,6 @@ static bool check_asid_zero(struct svm_test *test)
>  	return vmcb->control.exit_code == SVM_EXIT_ERR;
>  }
>  
> -static void prepare_sel_cr0_intercept(struct svm_test *test)
> -{
> -	vmcb->save.cr0 &= ~X86_CR0_CD;
> -	vmcb->control.intercept |= (1ULL << INTERCEPT_SELECTIVE_CR0);
> -}
> -
> -static void test_sel_cr0_write_intercept(struct svm_test *test)
> -{
> -	unsigned long cr0;
> -
> -	/* read cr0, set CD, and write back */
> -	cr0  = read_cr0();
> -	cr0 |= X86_CR0_CD;
> -	write_cr0(cr0);
> -
> -	/*
> -	 * If we are here the test failed, not sure what to do now because we
> -	 * are not in guest-mode anymore so we can't trigger an intercept.
> -	 * Trigger a tripple-fault for now.
> -	 */
> -	report_fail("sel_cr0 test. Can not recover from this - exiting");
> -	exit(report_summary());
> -}
> -
> -static bool check_sel_cr0_intercept(struct svm_test *test)
> -{
> -	return vmcb->control.exit_code == SVM_EXIT_CR0_SEL_WRITE;
> -}
> -
>  #define TSC_ADJUST_VALUE    (1ll << 32)
>  #define TSC_OFFSET_VALUE    (~0ull << 48)
>  static bool ok;
> @@ -3458,6 +3458,9 @@ struct svm_test svm_tests[] = {
>  	{ "rsm", default_supported,
>  	  prepare_rsm_intercept, default_prepare_gif_clear,
>  	  test_rsm_intercept, finished_rsm_intercept, check_rsm_intercept },
> +	{ "sel cr0 write intercept", default_supported,
> +	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
> +	  test_sel_cr0_write_intercept, default_finished, check_sel_cr0_intercept},
>  	{ "cr3 read intercept", default_supported,
>  	  prepare_cr3_intercept, default_prepare_gif_clear,
>  	  test_cr3_intercept, default_finished, check_cr3_intercept },
> @@ -3482,9 +3485,6 @@ struct svm_test svm_tests[] = {
>  	{ "asid_zero", default_supported, prepare_asid_zero,
>  	  default_prepare_gif_clear, test_asid_zero,
>  	  default_finished, check_asid_zero },
> -	{ "sel cr0 write intercept", default_supported,
> -	  prepare_sel_cr0_intercept, default_prepare_gif_clear,
> -	  test_sel_cr0_write_intercept, default_finished, check_sel_cr0_intercept},
>  	{ "tsc_adjust", tsc_adjust_supported, tsc_adjust_prepare,
>  	  default_prepare_gif_clear, tsc_adjust_test,
>  	  default_finished, tsc_adjust_check },

You might probably want to add "No functional change intended" in the
commit message, since this is just the movement of a test case.

Reviewed-by: Manali Shukla <manali.shukla@amd.com>


