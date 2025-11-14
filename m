Return-Path: <kvm+bounces-63191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7426FC5C280
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:06:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108603AD34C
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:06:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 029A63016F2;
	Fri, 14 Nov 2025 09:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yPNUig6m"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013062.outbound.protection.outlook.com [40.93.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA7C2F8BD9
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 09:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763111211; cv=fail; b=QHJnkkqiHFxfTVEnuFmSHUE+49Aebn1siktKKsJcHA1XQsXkyWJmu1ueEyaY+AdOdsKT0vf8qt2/R1ZUlxxTB/Y6aBTAv1ID7h7aQpRojNfHI4fRJUFsqpFB8RiGfDZ1jlEYbF5SbjYoK9EFOhiTBc419Q8DU0YzynY9opBDVmw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763111211; c=relaxed/simple;
	bh=CjCO3uOxBz45oaDCPpXWCRiiCdFHLzlrxZJTglKGVc8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:CC:References:
	 In-Reply-To:Content-Type; b=uCHpYIGBpgto/TYtx1tvn1CRb7FfVgvzfKQ/jt91WySB9BYx4ehD8HTWMDV7DEQ+8YaoZfJliccn1zkAm4tGwGourklLiKkeIugUUY2Sy8ulyKQ9IGI4kJSfUqiq1IOwZ7JkABy68LRATm/BttgGdYh5yho8xuPoaLxEB7tZuaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yPNUig6m; arc=fail smtp.client-ip=40.93.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qVuG49hnmXC8aL9/bAe3WsYyiYD1N/xwkFlvBzkSB62sG5/Seyp2daQL4wwnSAKDSUYqhH9tF9lMrURzwB/WRBQuFZtX/JY/znKbFxIJ1/cBsXVPEqH+T5VBPKvegDF269m+/JOdM0A8FC8RAhyBsmjzXz6fIuBIDSIV/MDfvRA0fN/xsmbtGc134u3HeABQr+Jjjeyn5yBhyRvP4ECWfnfCX9JQuBna60tGcDocQwmG6Q5DPtiCz61FxXoZE58bAkaNzpfYZK4M7Njf+pr5loHtRcHmksUcn3JgYcatAGUc6i4EEFz2chUmK4JwZjjIdVw68bhrlSDT9KSP+ELZYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XkkNQaNaATR42LcGtR6/9eJwi7lqbn2bsgMDGaOmg9Q=;
 b=hoFp664Ww5nnd6GMkoOn+sWPUQqRePu5cc8OUXIS8xinYVCY4RY2CwZzj9BTQTyMmzKmoowI+PGkwzc0fmqPkIASY7uWFF+HLfQlsjLCPRB6dgpvqsPrjF+t37JSwRfh+mBKdYIUQCcSYN3knYA5EXkJextdu6PwazwzmzSeZokJtX2L1Scxu6HgBHvHM4FQLdSEFGCYISnqnk266GnexN+3rBlLMm+75Ur5/tBywHbyw5qsOqKy1gA6Ot7jCQYRJ737v+EuIiedwd3JvQwLg2EJLqWPs1Hjthv4GtWLxJ9y7IjoXeeG0T7ECsvM+Zx9F3cRtDb08fP1ukN+83cQqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XkkNQaNaATR42LcGtR6/9eJwi7lqbn2bsgMDGaOmg9Q=;
 b=yPNUig6m8s4qZZmF25g4jqGe2LiEbdEHxz90ul/q7ALVF3zECMJh/Cl8bCcKReTkoqbe7narcOpSAacXDp0/8YJXp5MnlqU4ISL1xSfHnaIijcIKsre6RD0g9GGrehdeFOAqtV5F0dJqEZ4MUSbJ5G0SbwBX/Zv8aHiMKfwer1Q=
Received: from CH5PR03CA0007.namprd03.prod.outlook.com (2603:10b6:610:1f1::25)
 by PH7PR12MB5973.namprd12.prod.outlook.com (2603:10b6:510:1d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 09:06:44 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:1f1:cafe::c8) by CH5PR03CA0007.outlook.office365.com
 (2603:10b6:610:1f1::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.18 via Frontend Transport; Fri,
 14 Nov 2025 09:06:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Fri, 14 Nov 2025 09:06:44 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Fri, 14 Nov
 2025 01:06:43 -0800
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 14 Nov
 2025 03:06:43 -0600
Received: from [10.252.198.192] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Fri, 14 Nov 2025 01:06:42 -0800
Message-ID: <3f8f8f67-7ce5-4fc5-83bc-80fb828bd155@amd.com>
Date: Fri, 14 Nov 2025 14:36:42 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Manali Shukla <manali.shukla@amd.com>
Subject: Re: [kvm-unit-tests PATCH] x86/vmexit: Add WBINVD and INVD VM-Exit
 latency testcases
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>
References: <20251113235946.1710922-1-seanjc@google.com>
Content-Language: en-US
In-Reply-To: <20251113235946.1710922-1-seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|PH7PR12MB5973:EE_
X-MS-Office365-Filtering-Correlation-Id: cf3552e4-376f-4b01-58be-08de235d21f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dEJWdVlLTU5BUlptbk9Hd2tJNGp6Ky9lVkNLOFF6SWxySnc5dTVVL05nd1Uv?=
 =?utf-8?B?OTJwbmV2T1lueHRrelBaSmZYR2ZDVjBzTDBrMm1kaGxwQ1RrSi94OXUwY1Rr?=
 =?utf-8?B?M1RBRUgvYTluRExQZmloRSswZlFISTZLbFpNdDhRQTJTYis1b3I2cnBOaktH?=
 =?utf-8?B?c1ZRWVdXQ1RPc3VwT3Awek93eWxHWkpZMkN1d1J0Zi9OUk5zN0g3TGRRZFRE?=
 =?utf-8?B?NlA0eXJham1wcWh5RG9qS0M4Zit6WTFNbFpCZzg0OFdOQlpheG5xUEM5eUx1?=
 =?utf-8?B?dWp6eVdBY0hxenV0VlFKT1YwUjRhbUwwcm1oV1pnZXkwSEZidVU3bTlYZXRY?=
 =?utf-8?B?UDJZZElQRTNZVy9nUkVoeEJhMWlQRXh3NVV0NkRsVVkxSVVzMFBYUkhzRjBM?=
 =?utf-8?B?ZjlGRkI0S2F3Q0lsdTQ1YmFIcnhhR1I0d2pnNjlkRmh2SW1xZVpXRWlsREJH?=
 =?utf-8?B?WWk0bjFOeE5xQzlmcTBNR0NzbnlJOXE1RHc0R3VaYVJlT0NFcS9aak5mZ01l?=
 =?utf-8?B?RWJNby8xMXVNeHdGc3dNYStyTHhEOFY4eWtWZ3JRK3FXYnZyS205dHFjNG5C?=
 =?utf-8?B?Wk1oNHNFT2hQdG9Qc3JEOENkREQ2RklLL1Jqd3JkMTh2Nys1VExMRlkzSEt3?=
 =?utf-8?B?U1VybTVPZDZEMU1pQWRTbFB4Q1V1cWY1NCtDL3hlYldML1ZqN1dIb3BMOGVX?=
 =?utf-8?B?UDJMdWc5L005dUhIazV4ZGZ2aWhtelNwTUxPL1lDTWp3QWZURzdPN3J0aG04?=
 =?utf-8?B?WnlIMzRqOHdySzF0ZFlXNWc5c1ZJZ0QyM3lLYVdlZ1I1MTJsMUZUQUUrUGtT?=
 =?utf-8?B?d2U4VkNzbjA0ZFBjUmhUSUtwWGhjYVB6aE40OVVGNzhtdGlSbVJjL1h0bXJI?=
 =?utf-8?B?eEVkMW9RSlNxdGxZWlVnUWxvV3dqUWxUUlFZTTliWnpkMnZwb0trTHBQY3VI?=
 =?utf-8?B?bUlFMjRxZUtzaUZXRW1IZDQ0NWJ4TVg2Nk90eHYxTHhCaU9LNDdxR2lTdHBa?=
 =?utf-8?B?MnNKdzlUWk9aeGIvWXI2UHVpZG9uakVQekxYS080YlpDVnU5RWU2ZytWdFVl?=
 =?utf-8?B?RlJsMzkyaW53SlFubE1oMS8xc3dNN21YQ0VUUWN2eXUvak93YkFkam4vSDJt?=
 =?utf-8?B?SzBLT09zM0dKT1l0UG00U083aEQzZitZcmMvS2hVZm5taGtvSGtQQW1oWVA5?=
 =?utf-8?B?SkxrODV5cFVScEJUaWRDQkJWS2NxNHQ4UEQwZXppdUFDbVFRSm1BZ2EzdWkr?=
 =?utf-8?B?Zk03bnJDakxoTGxhSFg5bmI0ZVRMNUJSMElyVnRSWDdrdDYrVStCY3o0NGtn?=
 =?utf-8?B?dWJwNHYrTEthSkt5Q0RONGhIUWViOTM2TVp1UjcwMTNTRlIrTzA3RkUxc3BC?=
 =?utf-8?B?UG90ZzUxc2I0aUlNUHJMVUJCQVV3b0MyU29ia1dkYUd2UU9sNitWUGt0Mmg5?=
 =?utf-8?B?c21NNmV3d3VXTS9iL1pVdHBBMTJNQ3B2TEdqLzNnOWpIOVBKNzZPT2Z6TjJ1?=
 =?utf-8?B?cTBUd3kyZTluNnNIWVptci8rOVZTVlQyR1EyQ3NUeDFLVFVCMG93c01BcHEw?=
 =?utf-8?B?eGRKaUM4azV2QWdrNFVoWm9UVkJTVjNDdmFyNHVwQWxKNmdhdE0waWlIeVkv?=
 =?utf-8?B?ZE5MZVZHTnBjUTZlZ0FvaGRCdzhwTnM0My9lSXQ3WVRKV25rV3FURksyWkpL?=
 =?utf-8?B?Nkwwd2tNaTFTRlBuSjVSbm5sQnJJTEdEQVI1SC9ZY3A0c0VnWXA2RURyR1JZ?=
 =?utf-8?B?SzJDa056U2thYTRiTDZvUERYcWRLdG5KMXlMS0pZRGUyeUVFSmw3V2FjemZq?=
 =?utf-8?B?K0lkRG03dmFwN05oOXlDVkx2UzRxYXc5ODd5djdJOVpMaUpPaGhkdEZzMVVZ?=
 =?utf-8?B?dERYQ1RUaEhnSno0aG9zbW9UcnRkM2pjOUNEWVVyVGdIekVydStlRWJrblp1?=
 =?utf-8?B?ZXBBMzZXK0RzOEo3TDA1OVVmTmVURGJzUkw0Y0JvZ2hMdHA1MTlsM2kyYVlp?=
 =?utf-8?B?cHdCb25FOVRDRGpMMm5tQXg2bXplYStwUmNpZTZkU2JTMC96SkZVYk10bnNC?=
 =?utf-8?B?RlhYQmZKcmlLY3VWSXZDd0R3Tjh4V2xmN1l1L0orQkdlRHhGU2lnSldlZzNx?=
 =?utf-8?Q?kbQI=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 09:06:44.1408
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cf3552e4-376f-4b01-58be-08de235d21f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5973

On 11/14/2025 5:29 AM, Sean Christopherson wrote:
> Add WBINVD and INVD testcase to the VM-Exit performance/latency test so
> that it's easy to measure latency of VM-Exits that are handled in KVM's
> fastpath on both Intel and AMD (INVD), and so that a direct comparison can
> be made to an exit with no meaningful emulation (WBINVD).
> 
> Don't create entries in x86/unittests.cfg, as running the INVD test on
> bare metal (or a hypervisor that emulates INVD) would likely corrupt
> memory (and similarly, WBINVD can have a massively negative impact on the
> system).
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  x86/vmexit.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/x86/vmexit.c b/x86/vmexit.c
> index 48a38f60..46cc4c92 100644
> --- a/x86/vmexit.c
> +++ b/x86/vmexit.c
> @@ -36,6 +36,16 @@ static void vmcall(void)
>  	asm volatile ("vmcall" : "+a"(a), "=b"(b), "=c"(c), "=d"(d));
>  }
>  
> +static void wbinvd(void)
> +{
> +	asm volatile ("wbinvd");
> +}
> +
> +static void invd(void)
> +{
> +	asm volatile ("invd");
> +}
> +
>  #define MSR_EFER 0xc0000080
>  #define EFER_NX_MASK            (1ull << 11)
>  
> @@ -482,6 +492,8 @@ static void toggle_cr4_pge(void)
>  static struct test tests[] = {
>  	{ cpuid_test, "cpuid", .parallel = 1,  },
>  	{ vmcall, "vmcall", .parallel = 1, },
> +	{ wbinvd, "wbinvd", .parallel = 1, },
> +	{ invd, "invd", .parallel = 1, },
>  #ifdef __x86_64__
>  	{ mov_from_cr8, "mov_from_cr8", .parallel = 1, },
>  	{ mov_to_cr8, "mov_to_cr8" , .parallel = 1, },
> 
> base-commit: af582a4ebaf7828c200dc7150aa0dbccb60b08a7

I have tested this on AMD EPYC-Genoa and EPYC-Turin machine on 6.18-rc5.

Both the tests work as expected.

Results:
---------------------------------------
|                |  wbinvd  |   invd   |
----------------------------------------
| AMD EPYC-Genoa |   2.6k   |   2.1k   |
----------------------------------------
| AMD EPYC-Turin |   2.0k   |   1.8k   |
----------------------------------------

Feel free to add
Tested-by: Manali Shukla <manali.shukla@amd.com>

-Manali

