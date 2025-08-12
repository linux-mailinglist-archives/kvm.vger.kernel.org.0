Return-Path: <kvm+bounces-54517-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D1A6B22650
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 14:06:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFCE33B16F2
	for <lists+kvm@lfdr.de>; Tue, 12 Aug 2025 12:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D97ED2EF656;
	Tue, 12 Aug 2025 12:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NOQLps2F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2052.outbound.protection.outlook.com [40.107.243.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DD12E06EF;
	Tue, 12 Aug 2025 12:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755000406; cv=fail; b=UIRmcna6PHkkivSzFz5bV8Grb+SvGqe8Ii5FLQB8hjTcnlp+PMNB0AMclkyjijsms5zXphWf6ul6xKCTc1w/n6TEad5pgGDWLspj/SojGwkJaBrNZcK7RnCx2KsqBoqdTk6EUwDbSvq0Eb/XZI9TK5GK+tdV6DgkI3Bt2xU8K10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755000406; c=relaxed/simple;
	bh=yRlbwj/dB/eyocG3BvPNCVuhcPAD7e6b3on2B6Jw7Ls=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PPGwq0lYMtXafo96i8/Co+HMHnyIPCJAjZJsy4utal10ZDDHA21EzpbHCXPlg1vMW4SYtPMirwKVA4MW3Ic9l68p2UYxdBVCL7e9Jcaa5vo/3ou7SLOjKVDe7sZ+kNc8aG04Q5H8g3jcWLC5jthvbReYKM1EaxorB1cxr1gQbOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NOQLps2F; arc=fail smtp.client-ip=40.107.243.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HkT80cnHFYcR+V3rGgBn/029yhZeYW/lg1hFjp0VO207JdIjjcC24qvbGIg6lPZ3sw/Rl1P0PuuaR2Wks7z3LhNCnRtEKOQOTH60SCJmG3B0dDhuH0WOGGwt+55vrF3tEw0v4tuOc/raoFHF2b6TJ5ydgSlgcG5/p5vt8OBS6OXfwQLJ1vXfLc4NW7OlLIOu5AE2Awf6t47NyyysRVdGCfIBiCQIDwOR848h367ONTBRVbAdOS86074jcNPKE7cdJg0SmzbhzrIOR5HW3csg50sYOwskryguzSg/AP2gWNuaYzBJc/whrEFs5Mk/P/mijzElT23RtU/bzh4IOcf60A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYuxo9hzPAP8P/RAwfAqFO3bLoYV2qO6AgfPHZsuiO0=;
 b=VLtDTmY7smVLHjLEgH+Sj7GN/t37VwlUNweU0TWJd5VxsZssDnphEEnqkaADXElpgLFLeLi51dUNWfsJxoYVxmCcxQ/Ou1GgoYr9hojiNh4kNHme2vnC5VUkycNsc1yCQCTBAlf8nCr9NoejtqAadZmjCmMNua4yL6osaeeyeBx1IDoajlseZrhq7wPeCxvKkv3ou9WnCSlT43wnGwnsfocWwhjmG817ti2ZOaBUIANIVNhQFjsKmep55wplmmYsvVAn3nanQoNkM1QeTqSgYEhilivQGtqQuJBtx1oWzudUUfpuQ/NeF+Q+j0GoxM9ZFj5D4tFDKvzqiFENyUqxPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYuxo9hzPAP8P/RAwfAqFO3bLoYV2qO6AgfPHZsuiO0=;
 b=NOQLps2FJUox3hFTnumxAMWmh91iEdTWAcC/a3SxphaVs178xpSBkSilueix8r1V0qSi5LuNYf2Y1KpBiGs1DoV/0N77XAGW/EdySh+Yc3f39Glsq1IS8o/DWnPXFDMeOqj5CF1g52kpeV7vrOkmpf+MsGpx55PWnwK70yYP4TE=
Received: from SA9PR13CA0082.namprd13.prod.outlook.com (2603:10b6:806:23::27)
 by SA3PR12MB7879.namprd12.prod.outlook.com (2603:10b6:806:306::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.14; Tue, 12 Aug
 2025 12:06:41 +0000
Received: from SN1PEPF0002BA4F.namprd03.prod.outlook.com
 (2603:10b6:806:23:cafe::d7) by SA9PR13CA0082.outlook.office365.com
 (2603:10b6:806:23::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.8 via Frontend Transport; Tue,
 12 Aug 2025 12:06:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4F.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Tue, 12 Aug 2025 12:06:40 +0000
Received: from [10.236.30.53] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 12 Aug
 2025 07:06:39 -0500
Message-ID: <29bff13f-5926-49bb-af54-d4966ff3be96@amd.com>
Date: Tue, 12 Aug 2025 07:06:38 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] KVM: SEV: Add SEV-SNP CipherTextHiding support
To: "Kalra, Ashish" <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, <corbet@lwn.net>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <john.allen@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <akpm@linux-foundation.org>, <rostedt@goodmis.org>,
	<paulmck@kernel.org>
CC: <nikunj@amd.com>, <Neeraj.Upadhyay@amd.com>, <aik@amd.com>,
	<ardb@kernel.org>, <michael.roth@amd.com>, <arnd@arndb.de>,
	<linux-doc@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
References: <cover.1752869333.git.ashish.kalra@amd.com>
 <44866a07107f2b43d99ab640680eec8a08e66ee1.1752869333.git.ashish.kalra@amd.com>
 <9132edc0-1bc2-440a-ac90-64ed13d3c30c@amd.com>
 <03068367-fb6e-4f97-9910-4cf7271eae15@amd.com>
 <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
From: Kim Phillips <kim.phillips@amd.com>
Content-Language: en-US
In-Reply-To: <b063801d-af60-461d-8112-2614ebb3ac26@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4F:EE_|SA3PR12MB7879:EE_
X-MS-Office365-Filtering-Correlation-Id: 1228a2ac-1994-46c1-5721-08ddd998b283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZWtRUzgvaWZzRkpCYTJkUFpBUkZ2RHhCZUZCV3g4OThJTUcwb3hJYkNqL1lm?=
 =?utf-8?B?eitIdFFIcU42bHFzWDRmQjEwRHVnNmUwdk01NlJKdkNTZHI1N1oxQ3FNWG1H?=
 =?utf-8?B?NHc5UXBOd202dTFUSmZQbGtyc2VsOHZMbWhzVE4yWmtDUkJlZDhpSFRzaDZJ?=
 =?utf-8?B?VFNwRk5zRjBGandNTHljSjZmV09CREp6NzExVkdsYzYybmEvYVhYa3pyYWRh?=
 =?utf-8?B?ODZUa2dmdUd6SXZrWnRXY2lUb09wSjZxNysxTzZPSlNjNHRwbkNZRUVUOXdJ?=
 =?utf-8?B?bUxlVFVpbzFoeGVHVHZMZkU0alZ3dzQ1VzRKYlRWc0h0Rng5VXozSDBMZ2lY?=
 =?utf-8?B?R1l6bWVzNlBYM0NvQXc2d0owSmpBYU9JVHRVclMvL1ozNVBwK01Na3RMYlVG?=
 =?utf-8?B?Ly81c3VwY2puMFRVL05NQW9UaXM3My9lK21BWE0rckFJZ3dlQUEveVJsSnNy?=
 =?utf-8?B?RVBmZmJMcTZTMDhTaWhIOEt6bTYrN3Zmcjl0c2xlaC84Q2FYQWkzbDdPWk93?=
 =?utf-8?B?Y3h0UFRKMTJIVDJ5SE5ZRENwYTY2aXc1WDhGOVlnZVhTUVVpM0JGTDk0R3Nm?=
 =?utf-8?B?d29ZcnNVS3FkOGNFV0czNlA0SnJGYkhFaDFaMlZieVY5dHZnZDc1ckxWdVQy?=
 =?utf-8?B?L3lTdTlBc2x6Vy9uK3hDbXZzY3JSR2dOeWsrNWl3cGl3Y214eitoL2RLdmNI?=
 =?utf-8?B?Q2puNzFnRitob0laN0JUVDJyRjUvdHRrQ2tWdkZwT2UrV0dwUEJaN3NhOWpN?=
 =?utf-8?B?OW5KakJHQVYxOU9HS3A1N2NqUUVSNFZDOGVFeEU3allHNGdrWTRMYTBDRUpT?=
 =?utf-8?B?bFRYUXpqd0RVNVhBTTRqMWF6bXQ5Tm80bkZ0Z0k2UzBUY25oLzRNREVPUjJM?=
 =?utf-8?B?Y2NyNE9rSGRvR0ZpdW0yK1dsS1RmVWhEU1BBVkg2S0NsYWFtRU1pUjlnRGho?=
 =?utf-8?B?b2FCZ0kzbTRYZTNFSVROQk0yenp4Qk91UmE5bTZDcEFyMUd4czlwbHU2WnZl?=
 =?utf-8?B?bVpWQWxWU0pzcXJHQWtZYnRzUVdiaUdjTW96d0tVeDRIeDVSMHQ2QkttTVQz?=
 =?utf-8?B?Smk5eG14UEpkZ3cwK1grNm9BcGdRNGtFdHVFYzZkQjdkSmY5SHVwRnR2UCtY?=
 =?utf-8?B?S1lURVgxQVZQL0pzREdFMnFIYlplRmhzdHJpeks0RVNMS3hzT0Y3eDhMeDMw?=
 =?utf-8?B?amRIL0NPYkpXeTNCZ1ZtM2VIVW1MRlNpKzVkcSt4SUlqWE8yYm5vSkNDelMw?=
 =?utf-8?B?WmRxZ0tQc2diSTd6TnNaUmNzeXU3YlpNblV5NHpxKzh2cnVPQThsNk9kQ1JN?=
 =?utf-8?B?QS9ReDRPWjVycWZlT0lvQk5hbUV5TzI2dXNGMENiVjZGL3pyR1hoVmFwb0ZM?=
 =?utf-8?B?emRtQXRhSTJHVUV6WjgrSitXWkYxczhORC9tU1lCdHpRYjdsaHpDWEFtQnJa?=
 =?utf-8?B?S1kwNTkrSm9NYmF4aktjcS9pN1pDY1dsRWJmR3N3eGpXeEdLQmw0ek54UmV3?=
 =?utf-8?B?aVF4dzdoU3hDVjEvcmVQL00rWDhXbWZDSElsSUgrK3N3M21ERkwySW1HODBZ?=
 =?utf-8?B?TU9CdWYvY2hlS1ZLcDhwNW92K0pJK3VTb3BzNEw3MFBxQjZ1Q2F2cFA1S0lM?=
 =?utf-8?B?MEFCVi9uRENxSyttZXl2M0JMdjVBM20rWVFJeC9HWndrUWJ0SUFXOURLeGJu?=
 =?utf-8?B?OWMrTERsMU1BVHRVeWZFS0c4VmVsMFVLeStjaDFTL1BPd3pUcXRFTEFIMUlN?=
 =?utf-8?B?ckEzbS9rRHQvRWdjalBTOTZoWHVSakhlZTJWc0hPTUxCZmdxNmNCQ0ZFNzBG?=
 =?utf-8?B?cm16NjNhZFRONks4NkZLQVBjRXJXQXQxczFvZ1ZydVhEYysvN0Iva0hUV3U5?=
 =?utf-8?B?TXliOSs2RnVDdUFTQnU0SU94VHNKNXNXZ3NLVldIbkhLeWl4dFJDbDR0UEMy?=
 =?utf-8?B?WGFXZXozdWxGL3NyL1gwUXg0Q3g2UnpJTjFrTzErc1VJZ25yaEpsNzE3NFlE?=
 =?utf-8?B?ZTBzdnNacUlOMVVJK3MwZzFxM3J1NWZhZC9Da25mQzF3bENiWVhLYjFJYys4?=
 =?utf-8?B?UEdUdExXTml5cCtmTjhtckFxSHlkOE5abkZvZz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 12:06:40.9020
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1228a2ac-1994-46c1-5721-08ddd998b283
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7879

On 7/25/25 1:46 PM, Kalra, Ashish wrote:
> On 7/25/2025 1:28 PM, Tom Lendacky wrote:
>> On 7/25/25 12:58, Kim Phillips wrote:
>>> Hi Ashish,
>>>
>>> For patches 1 through 6 in this series:
>>>
>>> Reviewed-by: Kim Phillips <kim.phillips@amd.com>
>>>
>>> For this 7/7 patch, consider making the simplification changes I've supplied
>>> in the diff at the bottom of this email: it cuts the number of lines for
>>> check_and_enable_sev_snp_ciphertext_hiding() in half.
>> Not sure that change works completely... see below.
>>
>>> Thanks,
>>>
>>> Kim
>>>
>>> On 7/21/25 9:14 AM, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 7ac0f0f25e68..bd0947360e18 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -59,7 +59,7 @@ static bool sev_es_debug_swap_enabled = true;
>>>   module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>>>   static u64 sev_supported_vmsa_features;
>>>
>>> -static char ciphertext_hiding_asids[16];
>>> +static char ciphertext_hiding_asids[10];
>>>   module_param_string(ciphertext_hiding_asids, ciphertext_hiding_asids,
>>>               sizeof(ciphertext_hiding_asids), 0444);
>>>   MODULE_PARM_DESC(ciphertext_hiding_asids, "  Enable ciphertext hiding for
>>> SEV-SNP guests and specify the number of ASIDs to use ('max' to utilize
>>> all available SEV-SNP ASIDs");
>>> @@ -2970,42 +2970,22 @@ static bool is_sev_snp_initialized(void)
>>>
>>>   static bool check_and_enable_sev_snp_ciphertext_hiding(void)
>>>   {
>>> -    unsigned int ciphertext_hiding_asid_nr = 0;
>>> -
>>> -    if (!ciphertext_hiding_asids[0])
>>> -        return false;
>> If the parameter was never specified
>>> -
>>> -    if (!sev_is_snp_ciphertext_hiding_supported()) {
>>> -        pr_warn("Module parameter ciphertext_hiding_asids specified but
>>> ciphertext hiding not supported\n");
>>> -        return false;
>>> -    }
>> Removing this block will create an issue below.
>>
>>> -
>>> -    if (isdigit(ciphertext_hiding_asids[0])) {
>>> -        if (kstrtoint(ciphertext_hiding_asids, 10,
>>> &ciphertext_hiding_asid_nr))
>>> -            goto invalid_parameter;
>>> -
>>> -        /* Do sanity check on user-defined ciphertext_hiding_asids */
>>> -        if (ciphertext_hiding_asid_nr >= min_sev_asid) {
>>> -            pr_warn("Module parameter ciphertext_hiding_asids (%u)
>>> exceeds or equals minimum SEV ASID (%u)\n",
>>> -                ciphertext_hiding_asid_nr, min_sev_asid);
>>> -            return false;
>>> -        }
>>> -    } else if (!strcmp(ciphertext_hiding_asids, "max")) {
>>> -        ciphertext_hiding_asid_nr = min_sev_asid - 1;
>>> +    if (!strcmp(ciphertext_hiding_asids, "max")) {
>>> +        max_snp_asid = min_sev_asid - 1;
>>> +        return true;
>>>       }
> As Tom has already pointed out, we will try enabling ciphertext hiding with SNP_INIT_EX even if ciphertext hiding feature is not supported and enabled.
AFAICT, Tom pointed out two bugs with my changes: the 'base' argument to 
kstrtoint(), and bad min_sev_es_asid assignment if ciphertext hiding 
isn't supported.
> We do need to make these basic checks, i.e., if the parameter has been specified and if ciphertext hiding feature is supported and enabled,
> before doing any further processing.
>
> Why should we even attempt to do any parameter comparison, parameter conversion or sanity checks if the parameter has not been specified and/or
> ciphertext hiding feature itself is not supported and enabled.
Agreed.
> I believe this function should be simple and understandable which it is.
Please take a look at the new diff below: I believe it's even simpler 
and more understandable as it's less code, and now alerts the user if 
they provide an empty "ciphertext_hiding_asids= ".

Thanks,

Kim

  arch/x86/kvm/svm/sev.c | 47 
++++++++++++++++++-----------------------------
  1 file changed, 18 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7ac0f0f25e68..57c6e4717e51 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2970,42 +2970,29 @@ static bool is_sev_snp_initialized(void)

  static bool check_and_enable_sev_snp_ciphertext_hiding(void)
  {
-       unsigned int ciphertext_hiding_asid_nr = 0;
-
-       if (!ciphertext_hiding_asids[0])
-               return false;
-
-       if (!sev_is_snp_ciphertext_hiding_supported()) {
+       if (ciphertext_hiding_asids[0] && 
!sev_is_snp_ciphertext_hiding_supported()) {
                 pr_warn("Module parameter ciphertext_hiding_asids 
specified but ciphertext hiding not supported\n");
                 return false;
         }

-       if (isdigit(ciphertext_hiding_asids[0])) {
-               if (kstrtoint(ciphertext_hiding_asids, 10, 
&ciphertext_hiding_asid_nr))
-                       goto invalid_parameter;
-
-               /* Do sanity check on user-defined 
ciphertext_hiding_asids */
-               if (ciphertext_hiding_asid_nr >= min_sev_asid) {
-                       pr_warn("Module parameter 
ciphertext_hiding_asids (%u) exceeds or equals minimum SEV ASID (%u)\n",
-                               ciphertext_hiding_asid_nr, min_sev_asid);
-                       return false;
-               }
-       } else if (!strcmp(ciphertext_hiding_asids, "max")) {
-               ciphertext_hiding_asid_nr = min_sev_asid - 1;
-       }
-
-       if (ciphertext_hiding_asid_nr) {
-               max_snp_asid = ciphertext_hiding_asid_nr;
+       if (!strcmp(ciphertext_hiding_asids, "max")) {
+               max_snp_asid = min_sev_asid - 1;
                 min_sev_es_asid = max_snp_asid + 1;
-               pr_info("SEV-SNP ciphertext hiding enabled\n");
-
                 return true;
         }

-invalid_parameter:
-       pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
-               ciphertext_hiding_asids);
-       return false;
+       /* Do sanity check on user-defined ciphertext_hiding_asids */
+       if (kstrtoint(ciphertext_hiding_asids, 10, &max_snp_asid) ||
+           max_snp_asid >= min_sev_asid) {
+               pr_warn("invalid ciphertext_hiding_asids \"%s\" or !(0 < 
%u < minimum SEV ASID %u)\n",
+                       ciphertext_hiding_asids, max_snp_asid, 
min_sev_asid);
+               max_snp_asid = min_sev_asid - 1;
+               return false;
+       }
+
+       min_sev_es_asid = max_snp_asid + 1;
+
+       return true;
  }

  void __init sev_hardware_setup(void)
@@ -3122,8 +3109,10 @@ void __init sev_hardware_setup(void)
                  * ASID range into separate SEV-ES and SEV-SNP ASID 
ranges with
                  * the SEV-SNP ASID starting at 1.
                  */
-               if (check_and_enable_sev_snp_ciphertext_hiding())
+               if (check_and_enable_sev_snp_ciphertext_hiding()) {
+                       pr_info("SEV-SNP ciphertext hiding enabled\n");
                         init_args.max_snp_asid = max_snp_asid;
+               }
                 if (sev_platform_init(&init_args))
                         sev_supported = sev_es_supported = 
sev_snp_supported = false;
                 else if (sev_snp_supported)


> Thanks,
> Ashish
>
>>> -    if (ciphertext_hiding_asid_nr) {
>>> -        max_snp_asid = ciphertext_hiding_asid_nr;
>>> -        min_sev_es_asid = max_snp_asid + 1;
>>> -        pr_info("SEV-SNP ciphertext hiding enabled\n");
>>> -
>>> -        return true;
>>> +    /* Do sanity check on user-defined ciphertext_hiding_asids */
>>> +    if (kstrtoint(ciphertext_hiding_asids,
>>> sizeof(ciphertext_hiding_asids), &max_snp_asid) ||
>> The second parameter is supposed to be the base, this gets lucky because
>> you changed the size of the ciphertext_hiding_asids to 10.
>>
>>> +        max_snp_asid >= min_sev_asid ||
>>> +        !sev_is_snp_ciphertext_hiding_supported()) {
>>> +        pr_warn("ciphertext_hiding not supported, or invalid
>>> ciphertext_hiding_asids \"%s\", or !(0 < %u < minimum SEV ASID %u)\n",
>>> +            ciphertext_hiding_asids, max_snp_asid, min_sev_asid);
>>> +        max_snp_asid = min_sev_asid - 1;
>>> +        return false;
>>>       }
>>>
>>> -invalid_parameter:
>>> -    pr_warn("Module parameter ciphertext_hiding_asids (%s) invalid\n",
>>> -        ciphertext_hiding_asids);
>>> -    return false;
>>> +    return true;
>>>   }
>>>
>>>   void __init sev_hardware_setup(void)
>>> @@ -3122,8 +3102,11 @@ void __init sev_hardware_setup(void)
>>>            * ASID range into separate SEV-ES and SEV-SNP ASID ranges with
>>>            * the SEV-SNP ASID starting at 1.
>>>            */
>>> -        if (check_and_enable_sev_snp_ciphertext_hiding())
>>> +        if (check_and_enable_sev_snp_ciphertext_hiding()) {
>>> +            pr_info("SEV-SNP ciphertext hiding enabled\n");
>>>               init_args.max_snp_asid = max_snp_asid;
>>> +            min_sev_es_asid = max_snp_asid + 1;
>> If "max" was specified, but ciphertext hiding isn't enabled, you've now
>> changed min_sev_es_asid to an incorrect value and will be trying to enable
>> ciphertext hiding during initialization.
>>
>> Thanks,
>> Tom
>>
>>> +        }
>>>           if (sev_platform_init(&init_args))
>>>               sev_supported = sev_es_supported = sev_snp_supported = false;
>>>           else if (sev_snp_supported)
>>>


