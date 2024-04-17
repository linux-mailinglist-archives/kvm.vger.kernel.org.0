Return-Path: <kvm+bounces-14929-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACFA08A7BD7
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 07:28:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 640DE283A7E
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 05:28:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA5D752F80;
	Wed, 17 Apr 2024 05:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iwLUlLp+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3780B524DE;
	Wed, 17 Apr 2024 05:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713331681; cv=fail; b=Q/eLTnIwRDJmOCC/wGav2wsz7B+RQs16y/ShjWG+LBEZgz4FOxfAqQkfppQr3S63wAWZOSNABF/F7TTLNeICWq76sbsii9J9siumqLz0hjvF6lEitLPUYfXlKLBj7WSUmCuz6fTFCqeRrDl5WfxyFXpfAlP29BFA25v0yJ21jAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713331681; c=relaxed/simple;
	bh=j6mr467ypkqW5PQ8TpoxhryoayitQlQ85WrKecsN+EU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VdaKW440fDft0myHYX3pz/v0mG4n805Ies8p3r6V/hyQyxlhSeKDslAJgfjs/K3UPxrWgkJDv0+tXBsThv9Zbs4zn/8irZsdTcsCwm0BmOlLuXuroSDAOyzKqXwvsGdb44WL6rg/PlFJGkVaNyN+yDbNlLJtJ+pKupM/LcL1JEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iwLUlLp+; arc=fail smtp.client-ip=40.107.244.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTIWzkMIys0cOtpHediRp0eP0QQhkEYpg0gyReRnm85NGtv9vpq42VwHAF7keRXa9QQxHKeidxB5yOLiQ8xG7vDCOoDtxAEoHzLW5TuLyIpFQ47UJ7plsTLkK/IDz2XyjzLe1K4b+1ahOUBgpzOcrBXW7mALnOCE2xib0uqPBk38oh4891FLtuiwrwZ7x8dRGhn9zMQheVKYQuqA7GPOFTcoutSKeDonJY7GqLwLAMUUSIThA1W+kF7FYLcJqSZKGJpFa1VbErcw2GMgBlxiTtoYRrO0QxaD++2zWnvz6BAyR0l+ORt9frjQkLgkzGyiMNHNCQ2S8rw2iLPuecePLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XP6+NBt3hwf8fHGg4cHE38wpfmNRqHHl4SrZaYJDaFk=;
 b=hyGjPGZn7lU9wfNirEkxYS4wkLLEKIctCqQukuWom9f41w0Gdd2kN3L6+rUY/RqsJ+AW+5hjz1t5kkYqny3siLusRgsyH8NQ8ytmvmDBjStVbiC8dwXHTIohgXQMPoTlX1hYxHqiGNQFhsAlRD2nac5E9rWNtuPk5MfTqNlA+cidimsSNh3srP1shdxTIlyYckDJWvupo1MccihAGIMmBrFSqw7/Q3wOVxpbCIOSoSD9S3UJwxGVXt99QG7nLZ6RDUWIDbU8lvzPKZb3ZiGVVCBNYBSx88xWMfYhl2L0RTtojGtvEqEEs72PJLif6URyp50qc4sF0trBJ/wSd85Tnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XP6+NBt3hwf8fHGg4cHE38wpfmNRqHHl4SrZaYJDaFk=;
 b=iwLUlLp+CIVN5xbHqcgsTM37PtHo7dagS8uciRTqk5LhmBPF4bu8VwvdGYetf76CxW6RkFYumxHDO4qIb/I5uE9KlM9cdN+gv16g1gA+e3ffbwm3xeSQBoadesfbMSTec1/9c0VeUQB7DWmtp/GOyYFpDGc+JAheXfIjFIhkWeQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 LV3PR12MB9401.namprd12.prod.outlook.com (2603:10b6:408:21c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Wed, 17 Apr
 2024 05:27:58 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 05:27:58 +0000
Message-ID: <c08e7493-2fde-4624-9395-d1b8b5ab47c7@amd.com>
Date: Wed, 17 Apr 2024 10:57:46 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 05/16] x86/sev: Cache the secrets page address
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-6-nikunj@amd.com>
 <20240416144542.GFZh6PFjPNT9Zt3iUl@fat_crate.local>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240416144542.GFZh6PFjPNT9Zt3iUl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0131.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:6::16) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|LV3PR12MB9401:EE_
X-MS-Office365-Filtering-Correlation-Id: 35bdbc16-a421-418a-719a-08dc5e9f241c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	DsVTEFKHLl3pOjhW4bLXM3X9LKdCR2lO1ZBGM7K4Cy+S8LnBuS6wTXnxWN9+0XplYQN+SLYTm9NS0o86T1pjW1gFDNHTWovKcYL/E/z0/QhMOj3qgdZrW6JBh/V7a7ZOxujdYdgwO7OPtwakRhTup5xUOi4B8scdNcolqX2ZKD0ndnRuNS3tlKVLxv9Yy+h/CXLjbi7lc07GKdxhV7Qa0uMUM5UYqoL96HgKVR6AJBWdQL/sUFvXS7KNXUd3ErpYpHdolVPPi5FUscEiF8v+4WQ7P4cIPeW7lm8mKw4oZvAvDcAWqVVbV/G9u64E0/x9uSybJw7hP2mKksFsGrzaRZZqZjr0MLGmEmRWCxdHvGjOgEC148nDE8ygLi06xenHi1yjiDyLXkEMswHTtAg0umrPXjiC7MYCOgbC3q7Q/mES5IJNOaXXB98bpyEXXyAl1bvEoRGl6ttCrcYwow0B4/4u9ASculDwVLrFMhX6SW+wORND/DJW+7+UwOvta3G3FaOztO6cwk36b34NodlhM5cqGErHm/BpXaazvRpqPB83F9aHbNBTo3s45A9h3Uri64f193n+PWI1dyd4kK/PBbErGrQxroIPMHALDWsy+FlSQmYLNgF1i6HPHU2/ZUydnL5lTv4QMjCjdvOsdT2q9EyUVikeNWjNzjsKcrIRZjE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M3VyRGxSdkN5SjlBL25Zak9hdGNvcWJPY25MRWZqMzRTbXdIWWU2VEtDWk5v?=
 =?utf-8?B?cUx5M1FyaUlvSzFYSENGMFViRmU1MUVhbWtuZ0tNY2lkQmRCWFhkVTdvcER3?=
 =?utf-8?B?QXVCOUM0NHppb1Y2Z05CZmtUWlpZVG4yZExLcHRReTVkRkRzU2RDV0o0Tk1Y?=
 =?utf-8?B?NnNVQlNjeEl1RGVMUDNtL3Y5SjM4dCsxemtuUEo0SDh0VDRsM1dWc0k5UUhZ?=
 =?utf-8?B?cXhPR3ppRVdwNWUzZnFyd0JqVTB1ckdSV1huSmtRWDl3ckIrbEk5U1dYWHpD?=
 =?utf-8?B?bHhYS01YWmw3d0lwZ3RmaDVRelhZeGxYZVVhTEFKZk1CTmdmZ1R1RWJIK2pQ?=
 =?utf-8?B?NFdsVTV0bWdQQXVSTDcwaWtuQ0F5bFV5cVdaWXZ5SElTZmNaZGZ4dkVkU3Nj?=
 =?utf-8?B?Uk1qK3NMWXI4bTUrNDFBQWJqcndiL2FKbDd6Sk4xbC9UbU9rZFViSHQxWmJV?=
 =?utf-8?B?eFQ0SU1mZU9vSTFyYmZkdlYwRGdvVzhnY1A0RUxxRVl5eFh2NU5Sc1o2SUlJ?=
 =?utf-8?B?MXlid3pDS1FaWC90NFNMUUgyVmpnb1ZHSUNQZ0ZVUk9YMm42MWE4TXFTRHBE?=
 =?utf-8?B?NmY0bk41djBaUS82YUo0Y29qQnpRaURKQnU1NXdVSDlhbUJoYkhyMW5CWTdN?=
 =?utf-8?B?eGlvM3QwdzRuYmtSeS9jTUtTa2FnME14OVZnT0ZFdTZiR3NYSEMrYU82MEVz?=
 =?utf-8?B?RmRCamROcnpjazZhb01xODR0QW1YMUtLL2tnUmpwSWphZGd6REJTa243N1VW?=
 =?utf-8?B?Qll0WEExLzZPK3BibHh5ODlDTjAzSzBTK0t3N0d2SmRtTThSZEdVTWlTZmpj?=
 =?utf-8?B?ZXV5T3h3amhBYjZNZk9xMG03Sm42YytnOGxTVllnMDVMVStLZnF1YmVROG9Z?=
 =?utf-8?B?V1FIbkZXQU92SVpINFdLWG9VVFVRWDRUYkxFMkZ5UmJRWVlXelFpYSt0K0dv?=
 =?utf-8?B?dlF6OVByWExwNmRkVzhCdi9jTlZ0MDRkSWpaK1lxSFJFL0lQSXByN3BxaFhL?=
 =?utf-8?B?bW0ycXBFVllEOVV6U1pvQzRYUHY3RTJGbXo2WDk2NkQvU1R5NDFwM2w2TzJ5?=
 =?utf-8?B?dlBNS0NTRjc4clhXNHVNZy9WSXZZUlFQdGlTeldVeWFHZTdjUjRsSEdsS1U5?=
 =?utf-8?B?QjBHbmp2QVVhcUF2MmhBcjh5OUpYTEtTdkNOZFZWNE5SdnRlWTZxMzhVcVlD?=
 =?utf-8?B?NFE4Z3NSZjBLU0VvUXRIT1hoUm81SGRMY2RGTzY0VUxSK1poaHFjaHBmRW14?=
 =?utf-8?B?Y0pzNnZMbFBKSUVudFhSY3BsYmU2eTZFbVBTTTVDUjk4VFp1YWVnUDBkNEo4?=
 =?utf-8?B?L0ZoZWJyVk5mSWwveXRNRm9RbE5pRkEyOHZUY0hXT2g3MHdsT1JlT1RjRnU0?=
 =?utf-8?B?c0hKNERodjVjRHBLVTk2Wi90SkJhUC9ZalhFT21DWkwzbU52VzgrMWFpcVZJ?=
 =?utf-8?B?Q3N0ZHpBb3c3ZHFpeWdPRjVVY2xDaVJTbWRzeXBVRklxZzVRc3hVOHhlQTFt?=
 =?utf-8?B?UU9qNUwwVWJXZ3JHOVJ6bVB5SGtzWVllVGZTV1dheWgyaTNCNzJKYkpTZGVN?=
 =?utf-8?B?U3ByZmdHTncyZkQ1UUVlbHozUVNZcDA2alQrbitHNVFSdUFVOGJ1cHBaL1Mr?=
 =?utf-8?B?dGN6dWt1L241NWZ6MEJmeGZzRjlML3Jhd1RNM1ZjOUJVSDZhOVZJVVQ2b3Qz?=
 =?utf-8?B?eUh3REVpeStFTldEL0g4dmN1U3F1NnN1ZnJKc2Jaa3dlZENmQ3IxeEo3Qm40?=
 =?utf-8?B?aUNOZTR6eEtxL1dvY1N6WFBQN2xnMk9qUkR0TzhodmxyeVJMMDBmTjVmSjZG?=
 =?utf-8?B?M083L3VwWDlaM1ZCMXU1endlQTBJWkNVSTN3V05lMXh4c1BveDZQbVppb2tt?=
 =?utf-8?B?TEFvZXVEUmx5RjBtcWRCQ1J2dzlUMXc4YlA4RmpPVGxpUGdFckQ3NTR3UWx1?=
 =?utf-8?B?MWp5S0tyWnpPcllucXU3V2xPNVBFYTViZEw5MndjVE1vK01BMFMwa3hDenp3?=
 =?utf-8?B?bTNCcEowS0hzbFdhNEttK2JZRFBMUk1YNS9SV2xLTy9KMFljQVBVNG92QWtD?=
 =?utf-8?B?WCtOSERDSHEydUE1eEtHUzJ0RDlXaUU0SjdCeWhIUU0rRy83OHF2N3pteldC?=
 =?utf-8?Q?nt/JdzGLTVKo+Be+qE/Kzf7ew?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35bdbc16-a421-418a-719a-08dc5e9f241c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 05:27:57.9860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/iz8JtbIR3RMjpwKxTngeJJ9O5H03iBbqVMoWK+tmPxEb2x4FoNCTKFpE6dOb++afDK03YjJQXzIj6H9cmMsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9401

On 4/16/2024 8:15 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:17PM +0530, Nikunj A Dadhania wrote:
>> +/* Secrets page physical address from the CC blob */
>> +static u64 secrets_pa __ro_after_init;
> 
> Since you're going to use this during runtime (are you?), 

Yes, this is used during runtime, during initial boot will be used by Secure TSC and later by sev-guest driver.

> why don't you put in here the result of:
> 
> 	ioremap_encrypted(secrets_pa, PAGE_SIZE);
> 
> so that you can have it ready and not even have to ioremap each time?

Yes, that is a good idea. If I map in sev.c, what is the right place to iounmap ? Is it safe to keep it mapped until reboot/shutdown ?

> And then you iounmap on driver teardown.
> 
>> +static void __init set_secrets_pa(const struct cc_blob_sev_info *cc_info)
>> +{
>> +	if (cc_info && cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE)
>> +		secrets_pa = cc_info->secrets_phys;
>> +}
> 
> Why is this a separate function if it is called only once and it is
> a trivial function at that?

Sure, I will change it.

> 
> Also, can the driver continue without secrets page?

No.

> If not, then you need to unwind.
>
By unwind, do you mean unmapping in the driver?
 
>>  bool __init snp_init(struct boot_params *bp)
>>  {
>>  	struct cc_blob_sev_info *cc_info;
>> @@ -2099,6 +2079,8 @@ bool __init snp_init(struct boot_params *bp)
>>  	if (!cc_info)
>>  		return false;
>>  
>> +	set_secrets_pa(cc_info);
>> +
>>  	setup_cpuid_table(cc_info);
>>  
>>  	/*
>> @@ -2246,16 +2228,16 @@ static struct platform_device sev_guest_device = {
>>  static int __init snp_init_platform_device(void)
>>  {
>>  	struct sev_guest_platform_data data;
>> -	u64 gpa;
>>  
>>  	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
>>  		return -ENODEV;
>>  
>> -	gpa = get_secrets_page();
>> -	if (!gpa)
>> +	if (!secrets_pa) {
>> +		pr_err("SNP secrets page not found\n");
>>  		return -ENODEV;
>> +	}
> 
> Yeah, no, you need to error out in snp_init() and not drag it around to
> snp_init_platform_device().

snp_init() is called from sme_enable(), and does not handle failure from snp_init()

How about the below diff?

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index e9925df21010..5e052f972138 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -114,7 +114,7 @@ struct snp_req_data {
 };
 
 struct sev_guest_platform_data {
-	u64 secrets_gpa;
+	void *secrets_page;
 };
 
 /*
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 95003b809438..14c88e4f98ba 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -90,6 +90,9 @@ static struct ghcb *boot_ghcb __section(".data");
 /* Bitmap of SEV features supported by the hypervisor */
 static u64 sev_hv_features __ro_after_init;
 
+/* Secrets page address mapped from the CC blob physical address */
+static void *secrets_page __ro_after_init;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -616,54 +619,16 @@ void noinstr __sev_es_nmi_complete(void)
 	__sev_put_ghcb(&state);
 }
 
-static u64 __init get_secrets_page(void)
-{
-	u64 pa_data = boot_params.cc_blob_address;
-	struct cc_blob_sev_info info;
-	void *map;
-
-	/*
-	 * The CC blob contains the address of the secrets page, check if the
-	 * blob is present.
-	 */
-	if (!pa_data)
-		return 0;
-
-	map = early_memremap(pa_data, sizeof(info));
-	if (!map) {
-		pr_err("Unable to locate SNP secrets page: failed to map the Confidential Computing blob.\n");
-		return 0;
-	}
-	memcpy(&info, map, sizeof(info));
-	early_memunmap(map, sizeof(info));
-
-	/* smoke-test the secrets page passed */
-	if (!info.secrets_phys || info.secrets_len != PAGE_SIZE)
-		return 0;
-
-	return info.secrets_phys;
-}
-
 static u64 __init get_snp_jump_table_addr(void)
 {
 	struct snp_secrets_page_layout *layout;
-	void __iomem *mem;
-	u64 pa, addr;
-
-	pa = get_secrets_page();
-	if (!pa)
-		return 0;
+	u64 addr;
 
-	mem = ioremap_encrypted(pa, PAGE_SIZE);
-	if (!mem) {
-		pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");
+	if (!secrets_page)
 		return 0;
-	}
-
-	layout = (__force struct snp_secrets_page_layout *)mem;
 
+	layout = (__force struct snp_secrets_page_layout *)secrets_page;
 	addr = layout->os_area.ap_jump_table_pa;
-	iounmap(mem);
 
 	return addr;
 }
@@ -2118,6 +2083,14 @@ bool __init snp_init(struct boot_params *bp)
 	if (!cc_info)
 		return false;
 
+	if (cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE) {
+		secrets_page = ioremap_encrypted(cc_info->secrets_phys, PAGE_SIZE);
+		if (!secrets_page) {
+			pr_err("Unable to map secrets page\n");
+			return false;
+		}
+	}
+
 	setup_cpuid_table(cc_info);
 
 	/*
@@ -2265,16 +2238,11 @@ static struct platform_device sev_guest_device = {
 static int __init snp_init_platform_device(void)
 {
 	struct sev_guest_platform_data data;
-	u64 gpa;
-
-	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		return -ENODEV;
 
-	gpa = get_secrets_page();
-	if (!gpa)
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP) || !secrets_page)
 		return -ENODEV;
 
-	data.secrets_gpa = gpa;
+	data.secrets_page = secrets_page;
 	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
 		return -ENODEV;
 
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index dbc04229f7ac..4cef4e108130 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -820,12 +820,10 @@ static void unregister_sev_tsm(void *data)
 
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
-	struct snp_secrets_page_layout *layout;
 	struct sev_guest_platform_data *data;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
 	struct miscdevice *misc;
-	void __iomem *mapping;
 	int ret;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
@@ -835,28 +833,24 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	data = (struct sev_guest_platform_data *)dev->platform_data;
-	mapping = ioremap_encrypted(data->secrets_gpa, PAGE_SIZE);
-	if (!mapping)
+	if (!data->secrets_page)
 		return -ENODEV;
 
-	layout = (__force void *)mapping;
-
-	ret = -ENOMEM;
 	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
 	if (!snp_dev)
-		goto e_unmap;
+		return -ENOMEM;
 
 	ret = -EINVAL;
-	snp_dev->layout = layout;
+	snp_dev->layout = (__force struct snp_secrets_page_layout *)data->secrets_page;
 	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
 		dev_err(dev, "invalid vmpck id %u\n", vmpck_id);
-		goto e_unmap;
+		return ret;
 	}
 
 	/* Verify that VMPCK is not zero. */
 	if (snp_is_vmpck_empty(snp_dev)) {
 		dev_err(dev, "vmpck id %u is null\n", vmpck_id);
-		goto e_unmap;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, snp_dev);
@@ -865,7 +859,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	/* Allocate secret request and response message for double buffering */
 	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
 	if (!snp_dev->secret_request)
-		goto e_unmap;
+		return ret;
 
 	snp_dev->secret_response = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
 	if (!snp_dev->secret_response)
@@ -925,8 +919,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	kfree(snp_dev->secret_response);
 e_free_secret_req:
 	kfree(snp_dev->secret_request);
-e_unmap:
-	iounmap(mapping);
 	return ret;
 }


Regards
Nikunj

