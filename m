Return-Path: <kvm+bounces-68004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1BFD1C91C
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 06:20:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D5EC4302CE49
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 05:20:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF9EC35CBB0;
	Wed, 14 Jan 2026 05:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ETovJu5r"
X-Original-To: kvm@vger.kernel.org
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012009.outbound.protection.outlook.com [40.107.209.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3DE33509B;
	Wed, 14 Jan 2026 05:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768368015; cv=fail; b=TjHqP+iQ/jLvVvoPbAA7mvcX6HS7TWvFEuUpWGzXHXzMYZZPS5p5B+S/G2OyfvNMWzlZTTMawiBt3rb9WLZZw0SNh2fl2hfYD9jVi/Q8UVfn+hWhWdlpy5rhlJ/3ZlQBUDBjeeHPzGnug3PSb1C/xqoH6ocjAht2tq1jjZQoDIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768368015; c=relaxed/simple;
	bh=BI7lsiqOwJEyW+jvLreeKosIUbOucYDauPo4xj+EuSY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EnMkoouBI4GECAqYOP5Fo8GBs6274F88baetZj0cE2Uli8xpEm/uAiOO+MSBgLfgM+aN1/syrbKkrqsGlo0vhonrMOAxFcKiGUflrmw5kCaySwfjoXtS5hWZ0A58CsqtkIf17WVJ2I2yN2ZnCL65ZCr7CiqC8AYeUBaaYbu+irA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ETovJu5r; arc=fail smtp.client-ip=40.107.209.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iNyOlnAHut+7fT4+eLjvy3meUlb4L2HA7m31iYV1O9u+wjLmhQXWDSS25FcXTuusPtbSLV7bZ9zDzZIIaYff367vQdZPl1SYJjiB7z3kT0qzfURKXOh/eV8d4zU/uQhcr2MkBLmUGW5XCbQ8MHc+2EOJ+rdpG3YLke8X/a5jFt6KhCfGPS5Ps0cZkgPDCkQR8Y41MM1wf64wLCXUouRmraPGad/ROAnlgnTsApqBmlKASOH3usYFdhy2/JhMS/WkllpyyxpItGE5sYF2t1xsswRzesoUnmhOu/oHZxCpD8EQj6ozIz9ks6VdUyPU5cbbX7LQECIX6fzzRUR/T4Sq3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyzR/6J+EyyJfPYiG5SN1Ls0NXor/Twd2PKH9A4AP8I=;
 b=tZynnLIiWNMXY9OG5CmrZG9fl7W6vMRcs7GWSPGwjy6NLouCvyChz8eERsxWZyevUu1we5IXlx1RTzxh7GJyFPKXBGsjD7syFICQcLfa7DofSIbjovZ2VjTr5MB8+bdK5I9+GUTgCb7AXTRWnKGV9lJNqHJHWjEbZmTi5ZvP3Er8WVEEx47t8lyEFAvGgyfHktw7x7zHb5ZfKxezX9X/JGIpMp50GwqyaPJ18Qf1ztwkV2NrkmjxeUzPKqcAoOx3yqV60u03GEi459KcO/YlYfkzN9pa9O2Fd3LWhWGbqL2YhVOtpstR223HwF1ebu7tQpGh8Li9yjhCykPfksPrdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyzR/6J+EyyJfPYiG5SN1Ls0NXor/Twd2PKH9A4AP8I=;
 b=ETovJu5rBS831zbuFJ6hFU1wQgRE/7BggQ1HvjBgNeOACN9Nwdb64VVM1L0GjmAuTVmtVHoZ4X1yCDByED1TMYB4jGfMk9NXLilvgum3KsrP92LQwiBDIl7eHEniJdxyxFDv8gtLJMFwknFP521aAI2KAdYIhQq/1imE1SVgdzw=
Received: from CH0PR03CA0084.namprd03.prod.outlook.com (2603:10b6:610:cc::29)
 by IA0PR12MB7724.namprd12.prod.outlook.com (2603:10b6:208:430::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 05:20:04 +0000
Received: from CH2PEPF0000009D.namprd02.prod.outlook.com
 (2603:10b6:610:cc:cafe::86) by CH0PR03CA0084.outlook.office365.com
 (2603:10b6:610:cc::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.5 via Frontend Transport; Wed,
 14 Jan 2026 05:20:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 CH2PEPF0000009D.mail.protection.outlook.com (10.167.244.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.1 via Frontend Transport; Wed, 14 Jan 2026 05:20:04 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Tue, 13 Jan
 2026 23:20:03 -0600
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 13 Jan
 2026 23:20:03 -0600
Received: from [10.252.219.255] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 13 Jan 2026 21:20:01 -0800
Message-ID: <ae55f762-8778-4a74-aaec-3c3763eaf6bd@amd.com>
Date: Wed, 14 Jan 2026 10:50:00 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 5/5] KVM: SVM: Raise #UD if VMMCALL instruction is not
 intercepted
To: Kevin Cheng <chengkev@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yosry.ahmed@linux.dev>
References: <20260112174535.3132800-1-chengkev@google.com>
 <20260112174535.3132800-6-chengkev@google.com>
Content-Language: en-US
From: Manali Shukla <manali.shukla@amd.com>
In-Reply-To: <20260112174535.3132800-6-chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: manali.shukla@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009D:EE_|IA0PR12MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: ad07515e-2035-4004-e203-08de532c92f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzdoRkp4SVdPOXJaQ3pINjQxcUtQUllISVcxQjNsK2EwTExaUXFKcVRJS0cw?=
 =?utf-8?B?dDJ3QXAxMmFMdERnWlNmTlRqdDdPZ2o2UTlTWUJzN3JvTFhVK0FSK0cxSW04?=
 =?utf-8?B?MzRqMldEZ3F4Z0Ywc2UwU0o4S3VEMDRNeFZWeDVxaWZzbTU5YUZlb3NsZFNL?=
 =?utf-8?B?U0QrT0V2c0FrOWRUbHFpaUR6V0twRXI5QWNadzY4Y1VRTzlYazE4UXJ4NHdv?=
 =?utf-8?B?aHYvRWhSbDFZVWNCSEV4Yy94blN3R2d2SWVJZ0RKQUVKMmV1M21pVG1kZEs4?=
 =?utf-8?B?bE4yYVFSZUlJMlBkNXB1YTBoeERNeUI2S2V1NlFZVWpSck9ZUmVDVG5lTTBZ?=
 =?utf-8?B?RlFWMFJueStrbndmOEp3V0FZVC9hU1JJT2NmSlczQ3U5QTVVMVc4dkFvZ1hn?=
 =?utf-8?B?RDNGZTFHQytGNjVKV0FqL2Q2RDlxb2ZYTDJvT0Z6UVhFY1JuZVRVamFsd011?=
 =?utf-8?B?bzMyenh6RC9qZFAxRHJMeVgvMHMrbjhuZHVDRmdKVmpMMXdSMXhrMGIzZnNW?=
 =?utf-8?B?STBIOEtCdmVNM0FwZWN0WUFYQ0I3NzhUOTV5cWE5QVBnbVByTkhxTnQ4NEpo?=
 =?utf-8?B?M0JPVHlUTjVkd0JvekQybnZ2dnlWelNRWXNwZU5Wb2tGSGhsdURpcTdwNGty?=
 =?utf-8?B?dkQzbTVSVHpaSm9XeVQxYTVHaHNUaWltVUlNQURJVCsvd2FFNU42YXNwQ2pk?=
 =?utf-8?B?a0dFNWY4RFcwL2MrWmNweDFRNysrbWZYeldmdi9QTW1RVktwUFpvczhCeFVk?=
 =?utf-8?B?cXlPVWx6cnFsTFRXZ1FXUVJwbGVZTTlhTDNqTFZIMlpMRWdLRkIxczNjZmRB?=
 =?utf-8?B?dWc2dkRHRzhFdmY4YksvbkFRdjVJbDY0U1BIaUNtU3A4UmhvWnFNYWtjdWhr?=
 =?utf-8?B?UHJ1cFAvMHBibVZuRzAzR2xkMll4ZmJkb2w4S1ovYmJGQVNCK21jVHN6Nlho?=
 =?utf-8?B?V3VUT0orU0xNYUQxWUdORW83dWgzcytzRy91MEdtclFhdmM2OHN1S0szSkF0?=
 =?utf-8?B?WktGcmk2TVM0UG1UeEFEa3c1VmZMT3RCNmlram1qLzVrY2JIVjJabFEzMTBH?=
 =?utf-8?B?SDdaVmhoSkdrNXhwbXdRcUxZcjJ5bTQ3dERrWnBFdzNYU2VnRDAwUFpuWm01?=
 =?utf-8?B?Vk90MGRRY3FOZlljQjRmd3ZXaTZ2RklWTEdtb1JjV25NSE5MbWJJSnZJVVRO?=
 =?utf-8?B?WVEzUHQveWd3UUtGOExyNXZrVjNRMkNyVkJHVFQ1enlpZWZJamM4MzVZa0dT?=
 =?utf-8?B?YTR3K21CY0krSnB2ZXZTTkt6MnR0QkFqU1FvMXdDTmo1SW51RXlrK2VtNyt4?=
 =?utf-8?B?OWJoUE96R3JPcHk3UkJ4QmtwM3pCQk5CcjIyRGRjTFEwMWFJUWNKbFlxZWlX?=
 =?utf-8?B?WTBiaWRyTWpyZjdmVkVtNk83b0Z0OEtNQU1MckphUzJyTldHREFrOWpkdHZV?=
 =?utf-8?B?SVUzMmEvNEdxWjF1RzBjTVo0UTBOZmpyWnJiNm5ucFR6Y29vYUdrVXJPOGNB?=
 =?utf-8?B?ek1OL2FtSUk4dTlFbW1vQ0l4VGgrRWtZTGtuNkx4SnN3alNNMnVuR2xsU2tF?=
 =?utf-8?B?NVRPU2pzRXE5VTBrWVBZeTVWUkFXRWQvU0lIaWlrcVcwZ2QvcUZoREE3WkRC?=
 =?utf-8?B?MllYSDdzeHg1elhBQmFVWFpNVkZGbkI5YzU2N3loSmpxTU5hKzB2K2E0Wnd4?=
 =?utf-8?B?SzhoNGwxNXJlbnRYMTVKWkJreUc3OUVPbmJUdzh2WUJYN3JsMFp6SlZvbkw1?=
 =?utf-8?B?VFdtN2RxdmF4VWZ3VkwxYUY1VzQvUUQyMkJmVHYyWno3dE1za0NpTTZ3eHRy?=
 =?utf-8?B?Q1FhWHB5ODBOUU4wbGxaK2diMHZJRHFJRThYSlpaZStVdi9tRHJvWHhLcVd4?=
 =?utf-8?B?cXBoNTRMbU0vL1gyaUdGOWdOK0ZjYnJDbytKNUlXcExZZjRJR2lBdStiMStT?=
 =?utf-8?B?ditJcWNTRW9RYmMxcTJjVVEvWWUycGRhUkJZOEhiSjE5Nmx4d0tlcWxsWHJt?=
 =?utf-8?B?d2lCNmlXUTEvanArZ2pIeEFtNVJzNGt3eC9ESGlxK25uWVljeG1kT25uUjd5?=
 =?utf-8?B?eThwZDZWajQwTVc3SWZVWHM1c1V5UXdYSjZMYUFOSEdpZ0ZyeDZER0Nkd0dT?=
 =?utf-8?Q?YX58=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 05:20:04.1819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad07515e-2035-4004-e203-08de532c92f0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7724

On 1/12/2026 11:15 PM, Kevin Cheng wrote:
> The AMD APM states that if VMMCALL instruction is not intercepted, the
> instruction raises a #UD exception.
> 
> Create a vmmcall exit handler that generates a #UD if a VMMCALL exit
> from L2 is being handled by L0, which means that L1 did not intercept
> the VMMCALL instruction.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Kevin Cheng <chengkev@google.com>
> ---
>  arch/x86/kvm/svm/svm.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 92a66b62cfabd..805267a5106ac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3180,6 +3180,20 @@ static int bus_lock_exit(struct kvm_vcpu *vcpu)
>  	return 0;
>  }
>  
> +static int vmmcall_interception(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * VMMCALL #UDs if it's not intercepted, and KVM reaches this point if
> +	 * and only if the VMMCALL intercept is not set in vmcb12.
> +	 */
> +	if (is_guest_mode(vcpu)) {
> +		kvm_queue_exception(vcpu, UD_VECTOR);
> +		return 1;
> +	}
> +
> +	return kvm_emulate_hypercall(vcpu);
> +}
> +
>  static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_READ_CR0]			= cr_interception,
>  	[SVM_EXIT_READ_CR3]			= cr_interception,
> @@ -3230,7 +3244,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
>  	[SVM_EXIT_TASK_SWITCH]			= task_switch_interception,
>  	[SVM_EXIT_SHUTDOWN]			= shutdown_interception,
>  	[SVM_EXIT_VMRUN]			= vmrun_interception,
> -	[SVM_EXIT_VMMCALL]			= kvm_emulate_hypercall,
> +	[SVM_EXIT_VMMCALL]			= vmmcall_interception,
>  	[SVM_EXIT_VMLOAD]			= vmload_interception,
>  	[SVM_EXIT_VMSAVE]			= vmsave_interception,
>  	[SVM_EXIT_STGI]				= stgi_interception,

Reviewed-by: Manali Shukla <manali.shukla@amd.com>
Tested-by: Manali Shukla <manali.shukla@amd.com>

