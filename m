Return-Path: <kvm+bounces-14941-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0A2B8A7D97
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 10:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0EFA91C21950
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 08:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0637478B63;
	Wed, 17 Apr 2024 08:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YV7xpkwg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0926FE14;
	Wed, 17 Apr 2024 08:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713340812; cv=fail; b=FGXG1asCAxaaGXbVm1KNNYjDcFAhISvYpupdx9MXtbbGAbMdmKEZlHecRzk35VhwE78HdL9pDq/oYs+SdHPSt3l3REYvG7d0JH9i35kwBHnQ5CU2K4Z8LeYciwdBQCMnzbPMDMSfcUC40HiLk86qA4tsehIjVMVFAMV0sADiVu4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713340812; c=relaxed/simple;
	bh=KaRUi82nUYrfqu09fAvCd4obk8KRPZFwNDuy1NueIyo=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UFJKJw8SaEHfpq0ffwYm2ctCv+esO+oYQiCnzXDQRTlYQn+ScnuOmwVysCW8sD+nIAfu8JxgxUxltPhfzlVDklC31BmelFW4kCm9q77ISI9IsWsFOoxtHe67gXqpemjD/nKsE1oNmNe4ga/60BNGDNlKUQnTtVL9y1NU/zwCkwk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YV7xpkwg; arc=fail smtp.client-ip=40.107.94.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ktsWnT98kEy2JaeQgCxd6W10gQIDWZeknmuXYILdxK83BCCuLaQWUpKURUHf3OoOsA3C/nDep2600PMcWaeam0eUJRfQJKo/ysBB4FvDDjNMJ+CmEDzRl9cGlMh8cgllaAXX/bVuNQTMbAy+hRt6gFBntYPKxdcLJFN0LfwJEucKBz7L1ynfz8YWAZ1JRNIGCQVklMxd08Ko4o3xrwpf1TOLUU4PQEE1pV0A1jso+i6+BnEvfDtrUAI92fTqlCz+mEv1HUnnyMTZWP0V1w0RStNyfKYAz3uNVYxWlb8stMPWiossSonUu0InC3sh4WA/ihJ2cR05dXskuMDUQul4Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HTnFDF2V/FmSU1e44rfQbXw9t75Br4nQgrq20a9GiEs=;
 b=FhV9FKJys5gnpMkbFXvigvt7A90ZnvV/DUh/o9NvrMzhQPFKizHivIkJhWq0GMp0QgWECYDW4J31SlRJeLabgWuzWfUhJ6gxKfnxfobJ6yIsWc9gRoEHuzCnwcdhhjv0Vf1XzWtFdeeLykD4M3Dx3VV4SvxQr9vVI+dpNLizvwNzNyl4fRuIjmQna5NedIkVgGacXrUgi4Zb2MxlZvpgZIV0WiofA3s5AVDeYayRWZdr8aQA387IYtsxS/PtM6l4QuMxicH6Sk8HM3icsVjH4HUV1ASYKz6qv9TVCvQ1KEWf6xzVPxOROdcjLCkCHP7o7TJK+8OtXdnSwy4MUaLCjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HTnFDF2V/FmSU1e44rfQbXw9t75Br4nQgrq20a9GiEs=;
 b=YV7xpkwgwtlMsY0dSPPU+mo8r6iWX658lyIbYGZWq3kQ7bF2z2JzwuLF5BnTqL4jhMYX3ECP77z1WOvsdj5DXD5cV/w+uwUEWfH1flmpTxU3n16fjp+978LxigLtNdLwd9cLCcnHu8YKvULqzC3ZMhBkEVh/lrq0tWpJI5cQZcA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM4PR12MB7575.namprd12.prod.outlook.com (2603:10b6:8:10d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Wed, 17 Apr 2024 08:00:06 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::b890:920f:cf3b:5fec%4]) with mapi id 15.20.7452.049; Wed, 17 Apr 2024
 08:00:06 +0000
Message-ID: <d97c6518-b434-42da-bd12-88cf432d1163@amd.com>
Date: Wed, 17 Apr 2024 13:29:53 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 05/16] x86/sev: Cache the secrets page address
From: "Nikunj A. Dadhania" <nikunj@amd.com>
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-6-nikunj@amd.com>
 <20240416144542.GFZh6PFjPNT9Zt3iUl@fat_crate.local>
 <c08e7493-2fde-4624-9395-d1b8b5ab47c7@amd.com>
Content-Language: en-US
In-Reply-To: <c08e7493-2fde-4624-9395-d1b8b5ab47c7@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN3PR01CA0080.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:9a::22) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM4PR12MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: eefeafca-5d38-4d5a-6a0d-08dc5eb464c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uXIFVDTkcWnAmNer4FhIs9iD01CltxVWGIacvqecNl3i55dgcvmfqm+Ls2rj4P41CEx/N5s+Vcpxs4kdcxGVkmnZsEMuNITimlDK1bP+vL5Ttt5yJI+SYGqqU3n9t9XXmIfPBiDkOOquRIwxFd+IGOxo3rjry0g/Gc+C78yNfKQQaT89IR/W/wd4FHc1+ZZxANKU2NzXN8NePPGULM+sQjZJccb6G2JP+EvQBNUaXVAcOmlhF3OFeel/AhwdMPhQFiUEcu/F/QICumBmx5y83QJF+ZKhxhH8bYiYzbiT7aQ7FqY3K3BnDlgL5edQ4vRvaFJ9xQUWCH7m7QL2Ucd5UuPNuJoAPQ11RXa//4Ww4ezxYMhtPyBPy9zExg6/dANnDGL9UoW6EvLLQFMe4xU1o8QLKrEbiS9Qrg8lh67K7he1jTDuLCXzAf/vO7eRwulw8eub586FWKhvFrDAGmWMxw+Ejc7ojENhOtl4dAgyP9MI+M38a/nfLgvSRiSPM1biLQar4eW7AQntnHOXWADgVdFnwBJhtMTZqGQKN3BP+QPpVRvkExai+eD/WMlfdeTq6cQjFhS3nGX2e/A/QMfWEw1s4PCxcNm4aQBwBruqoTPUH5AtEVaE7SDckZWEf0+U2vmg4i9u+KLkZADi8uejQtJ4tEs6P2c42ipLVq7uAF8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R05OcDVwTkx0SkM3dHhvdGhNZnowK2g0aXJJSHpYMHpRSjJreE1mVE11RVRv?=
 =?utf-8?B?cCtnbmVaQnVGWlluWnFmTHZmVEYzcERnV2YreDU2aUwzTGFjeFNzaDJmM2Vt?=
 =?utf-8?B?SU0yaTAzdWsyMUwwL2EwbkFZckdWQkdoa05odjFtTTlzYmQrVXY1bGxXT3Ju?=
 =?utf-8?B?b1pEQjhRMXl2NXpNdStPYnpTeFBGeUMxN3FaMjAwK2I3KzdjK056blZXYlcw?=
 =?utf-8?B?V3FCbk0wWXJKWVhucEVHUldWWURES09vL2NzZjRqVURsdnV1cURBWGhpWktp?=
 =?utf-8?B?OW5LRDZWK2IrakgydFVPYUJmT2orbGJKMEh5dndMNHg3OTRjYlNkN2d6cExL?=
 =?utf-8?B?NEZ3MGdZaUpSNlBGaTFERTUzSWVFYmRpYnFhdkdCcFZBL1BRLzhleGRLNnJv?=
 =?utf-8?B?L1NiZEpOMVZkL0N5VkRCZ0NpNE1CNU4ySUpVa2h0UGtYWUVLUkY5emh0azUr?=
 =?utf-8?B?L3loOXJMVk85blUrYVA4N3MxSzY3Wnc0Nkl0TGdTNXhFLzFNYkFBUkU4WkFm?=
 =?utf-8?B?LzIreTBjSVJWTEtWQ29rcFlhcFdOZGZvYTdGREozdGRRa21jRTlmVnp6a1pC?=
 =?utf-8?B?L0c2N1RSS0wyUFRPbjBpaDkyR25OYUREdVYwK1I5T3JORlBndWpRaDM1cWFr?=
 =?utf-8?B?b3Nrc0pjS090N054cWt2QldDM2hxb21rajhkTDJJdnkvdXNqa05wQStGWjNH?=
 =?utf-8?B?TW5WNVh0ZXhNVktSRXVKSFFJNmlMakNUbmdDcHBwSklvaVhhWUlKODRnUkg3?=
 =?utf-8?B?ZmR0K3BSY3RBU0V1VkhRay9ualp1SFZneG9oeVl0UVlPa2Y5V1BGSUVwVS9E?=
 =?utf-8?B?WUtINEZxQzRMWVc2eitjdnFVZVNDbUdkbGQrZk85UGlPMEVRUVBKVXkyL3Z0?=
 =?utf-8?B?WFphY25QSVk0c2k2T1hIM0FiMFdYQUtxZm1EYVpvSCtSQWE4WlNCQWcwUk81?=
 =?utf-8?B?Mk9hN2xjNlhyRkhQb2ZtN1JSQm50WkZ0aTVJQmVndHduK0s1OXNYZk5qN09u?=
 =?utf-8?B?VGMyRkJmanNtVXdIanUwUS9TeExJV1NPTnFydXZuRHZ5SXNTYTBJbzV3dFFM?=
 =?utf-8?B?VEo4a1BtZGcwVXMwdC9zZXNsdkpUN3ZyL0RxVGthc2RIWDhPTkdIeEpiVytz?=
 =?utf-8?B?NnRrUVgwWUl1dzJhZ213REhZOW5BeDc3SStKNXJLbU5hQmVsb2JtRVNzMHlv?=
 =?utf-8?B?RnVTMXpXZlhhc2VvbStYL2d0TE01ek9CT2M5ZkQ0MTZXUitUVEVGVmxJZVdR?=
 =?utf-8?B?RXZqM0R3WWFQR3hDME1WVGhMWnZodStiSDUwa3puZWNkd0MrSWo5alc2Zlpn?=
 =?utf-8?B?elVENDJVNVdHUkJkWTNGRTN4TTB3aTBYUTVWL0ptQjhIajN0VGJXbUVlYnhO?=
 =?utf-8?B?cWZYNXkzQWhIdXE0N3dCYnN0b3ZXcXFGS1ptSktRSGV6czBZV0o5bW9Sb0tq?=
 =?utf-8?B?TnFjOURNaHAxb04vSW9DSGtlYzUvdURYaWNrdzFKYkp5aGlLNTI3Zjlaaks2?=
 =?utf-8?B?QUhCRDJhbGlOUzhsSUFVa0ZVcjBOVTJTL251RFJLbk9GaXVSZ2QycjcxdGcz?=
 =?utf-8?B?Rldsa1l5VDdTdzZzakdMVEVHc0xndVYrZFBxckh2aG9mR0ZETTBQVlV4QS92?=
 =?utf-8?B?eGFCUGY3QmVESmFZY2VLOXpValZnVjJTVFBIWlV3YS9rZnlPTXJTVmdKQnlj?=
 =?utf-8?B?eHhCc1BmN0t2Nkp3UEI1RTFreURyV0dwUzlMeXY2QzRqUXU1NjNST2JpTHBM?=
 =?utf-8?B?aThRQUgreXdISjNpckxFbS9qREE0ZEhYby94TGFLYXl5RGQ0bCt1WXRqR05D?=
 =?utf-8?B?M1RjcngyMnRVdmR4TWZkMjMrdUFJTjVsTm5YVVVxZVFMektEblU5bkFuQVVP?=
 =?utf-8?B?dXRLa2UrWkZEMHp6NW4xY0RXelJRSm9FbU9yY3NyNDVyMVhTYXNrbk5BRUti?=
 =?utf-8?B?UUJmN2x5QVo4anhZN0s1VkJuMy9oK1JxMTdDNzY1cFRmVW4wRWlYb0JxclFt?=
 =?utf-8?B?UHQvQ0tEbVRvVUN3N0E0c1J5NVVBWXl6UTkrWk9rWnNBUEJoNXhkQkRkcm91?=
 =?utf-8?B?c2pkS2x3aHd1UGtEMkJoUytpU3NDcmswZ0RoalJQN29tWlM2Qy9vcENjU25i?=
 =?utf-8?Q?RkgjIsO0ccQkgPUTf9fC8uQDk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eefeafca-5d38-4d5a-6a0d-08dc5eb464c7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 08:00:06.1834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uzUGprrUsfVt+zx/ECR2WICFbpcVEgdLrppkdXwiqTi5a/Kghf9fxj49qThpHqH/vc36AGPBXPM0UYN+b4VxwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7575

On 4/17/2024 10:57 AM, Nikunj A. Dadhania wrote:
> On 4/16/2024 8:15 PM, Borislav Petkov wrote:
>> On Thu, Feb 15, 2024 at 05:01:17PM +0530, Nikunj A Dadhania wrote:
>>> +/* Secrets page physical address from the CC blob */
>>> +static u64 secrets_pa __ro_after_init;
>>
>> Since you're going to use this during runtime (are you?), 
> 
> Yes, this is used during runtime, during initial boot will be used by Secure TSC and later by sev-guest driver.
> 
>> why don't you put in here the result of:
>>
>> 	ioremap_encrypted(secrets_pa, PAGE_SIZE);
>>
>> so that you can have it ready and not even have to ioremap each time?
> 

> @@ -2118,6 +2083,14 @@ bool __init snp_init(struct boot_params *bp)
>  	if (!cc_info)
>  		return false;
>  
> +	if (cc_info->secrets_phys && cc_info->secrets_len == PAGE_SIZE) {
> +		secrets_page = ioremap_encrypted(cc_info->secrets_phys, PAGE_SIZE);

ioremap_encrypted() does not work this early, snp guest boot fails, will debug further.

Regards,
Nikunj


