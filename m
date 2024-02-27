Return-Path: <kvm+bounces-10113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D10869FF4
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FBAC293267
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:15:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6E151C39;
	Tue, 27 Feb 2024 19:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="zoInTme6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6341D698;
	Tue, 27 Feb 2024 19:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061315; cv=fail; b=G7u/ogKjWQavV0oS6pcXyRGt3//kK/dgDDqYhABZnDsXeZCsiHLJ2npxgPYC8pQubfIaYRjgDBU9zy6PSQd4Rutt3o+PQw2OYbObkniSPWnxi3H5wMCVhgRi/mM78cps9k4YgoTtt9ytamiWIO3/vOaL0AdjRM2Pav8ZfUKC+/Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061315; c=relaxed/simple;
	bh=jofiPinI37+C9zkpL+oyVrkW0pCNIYDrLS/ScZOZt4s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O/eIy5b6BuiDB3tKD1uR23d5Mvjb8+jGtGZtzUDa8JE6o0+SWwA/rYMTdKD6e1tx1NibWaTzE7GVhCL6puHNo826XKw44ds4NQm2Wy80XK7FGG/itWNS9TKlLXn9SAewtjrvDQyDhTB3QS1eo9t8mZ5ybw4Ih+5AoAKyiK9OsSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=zoInTme6; arc=fail smtp.client-ip=40.107.223.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CxKH6ZQcihSg4o3iCPWgstIYnuiLaKgWNl5c0x6cKbWDoxdzUY8dRmvffCD8Ww9RuAOpQiQRl9C7zePNvxCxlK6FwPtM1ixitKK4iSam/LTf2Y51utjcsNMqLb1vYDYm9Uk6Yk0o9pDq5IvoROrQEcu+NzC5nz5Ugl2zX/C2EIfFKLSHQQbYwzQSYel7+iAnaMIYcJDdyfavmt20q5BG5e5dj+/K1vIk5WVETG/+vSrwP2GSRvGDJxGCTDHGgfAnN7qlPkeQo6UjE8z6Gnt5tI9oNuwFBW2tB0aeqIoMSpAuQWL8yfGVLEF3iIM08YMyG2dVSVIFt8PTE4pAIzcq6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MKeR52VSceB4QLYNVBMJ4lZ7x1TkpIC9WP7UQD7HLN0=;
 b=ntiQpfJ8Rj9wLxuArudBtM2nZYX3Eqgss6g6euC5x5D4UTsG4yMAUoB9mRVP/HOqfDX1lm5scGXYgUX89eVbmPncMC+CjHXpzoWQ7IPsLDrpjWE0eZ5H4XDBWyA/mwe5IM+kEw5lTKc5d/Zkw3uMWB8pyQ0RXPfyLvzNPRwFTLEKKevNMVEZSeRO8OM5hIyyXQZqxHpJyM4ji5ZTEVUWbrbpSjtPlvE/toAv0aA1m8cvvDgRsLjo6LyJLH4rWpfBujcBjEvN9HqpmZe3/ad1s3DkcygIicT3C6JMkouMnV9CjSLpBf1xTljCXWbjZNtYmMwuyuJKecadjoIwStBWpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MKeR52VSceB4QLYNVBMJ4lZ7x1TkpIC9WP7UQD7HLN0=;
 b=zoInTme6qPq7e0cMdGiS5GD2GVSe+L8yPNd0+EfMN4AUs71xSQKfLlWqdjoGC+f4m1GWPv4oDQGBeUMSIcz8YMciUqja2AML/rMVeOaTd2cPJle1yDgWiMXSpJt5nXeMKe4kg31jcRw2TqNu1jbaRwm9PlsqW6DDUuxUuq/vavU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SA3PR12MB7973.namprd12.prod.outlook.com (2603:10b6:806:305::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Tue, 27 Feb
 2024 19:15:11 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::4c26:40af:e1fd:849e%7]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 19:15:11 +0000
Message-ID: <1f95281e-f8a9-4ff2-8959-162a192e48bd@amd.com>
Date: Tue, 27 Feb 2024 13:15:09 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/9] KVM: SVM: Rename vmplX_ssp -> plX_ssp
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>, John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org, weijiang.yang@intel.com, rick.p.edgecombe@intel.com,
 bp@alien8.de, pbonzini@redhat.com, mlevitsk@redhat.com,
 linux-kernel@vger.kernel.org, x86@kernel.org
References: <20240226213244.18441-1-john.allen@amd.com>
 <20240226213244.18441-6-john.allen@amd.com> <Zd4mf5Z1N4dFjFU7@google.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 vFkWitqCJg==
In-Reply-To: <Zd4mf5Z1N4dFjFU7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::19) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SA3PR12MB7973:EE_
X-MS-Office365-Filtering-Correlation-Id: ceeead23-f961-4eef-8055-08dc37c86b68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jL29od7iU/jErzXaBr2GnOA9yHCjICbdJrOvR1HIejFHYa+XKaqJlyhRSZErWKrEQU3PtOcNr+eYjgdignVNW85ucU4Bmnou8uht13X7ZKqFE/lKFv2EZidFcZweeVt2YStwGc4ft92lJo9fst5vN/XtDhCK4YsnEHxj7L80RQiXyeA/f4w2BhRLudx0j+eU7sts5MZ2EaRHTDXhOqiYUSJe9420Qc6Tusk9VvM+mXOpYoCI3KRubl3D6zNWcqSF2UcpQLGFp+JU2LS+0g8KyliDiBa4qFV2yOgt/crRc5VH1Qr+ekQFIxbI3W/FkmMpC9t9QdTV7x+mfJKBGRX9L7HI++AVgMZdKDEJtRNyxupqb7O0ZP2OlVYhmWe1Z1UZbTHFKWsYvkRM7kJulHXgovjjSwaVxFcxmf2FdXPIGWQR2wdXfZP/G9qBXC2GqqQLR6WMUJa6t19csrcinLiVY/NG3ImvmStdiDueY8Mt+Woen0fM5CC3fWzthSJWepVVT9woPzFWeseEh7JRnthFScZaTl7X7jYosvoUKX5VhZpVca6qw6z1w8bR65T9y8jnssKlO1HSJif2kzkuchV4uEFwpWc3B7JQjri2odlYGbdZX5vZt3lAFsNzpQ13U3/Ai682KVmeyWWdIroYwLnp1A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R2V0ZThSYkNXMGVZZnhwNFMxMGRxTUgwYUpJQllTNnJka2ZZeUoxVHloZDYy?=
 =?utf-8?B?L2k5RnFxL3pSU2ptRFg1ZmZBdU9rSUdNU0tKQjB5a0F2eDFoUkFWNk16RVp2?=
 =?utf-8?B?Zk5FS2xibXhzaEtFdDFFWVpjc2pYK0ozQWt4Z0NTdEZtV2JMVUVXQm90blZz?=
 =?utf-8?B?Y1JUUWl6VEJiQUdkRS9uU2JoNklpamw3cHN3SzBxWEI1ZTFlKzZMZFZmb1J5?=
 =?utf-8?B?Y0hVTUh1NHFXdGdHbFlQMzhUQUxyN3dVRlEzSXgxbWZwa2QrdkU2MnFBaEQ4?=
 =?utf-8?B?bkkyL0Y2UVVHMHZPUWZZdnhnMFAwWU9nRlpTS1FjaU1BejJBRVJkRXExVG1l?=
 =?utf-8?B?L0JQNytTVVpRVCt1WEVqNTE2bE9iSlNRUVBiYmFzdmZRbFpoeVdKVWlWa2dn?=
 =?utf-8?B?RlBHZUF0RjM1ejlpYkFYRVIyNjZNTS9Ydm5ZS2kxeEVrQjNOTWNkNjh4enQv?=
 =?utf-8?B?bXVyN0VITng5Z05XcWVndGNqVTVEd09SY2t4TjZ4Q0t1S05JV2tZcHdGSW9K?=
 =?utf-8?B?OFpoM2NJeks5NkZJTGw0eXByOGhkZTBNNW5NTnBxcG41MmRZdDJRVWJyUG44?=
 =?utf-8?B?UTRlS1U2K3B2Q3F0aXgvWSt1N3RBWWIvRTJSb0NGeEsyakRoS0dLNEdLUWZG?=
 =?utf-8?B?Qm9KYWxWVElmKzk5ZHp6SjFaMCtCVE9uckN6ZStJTjJ2L2hKVm5ndTJKNWph?=
 =?utf-8?B?QWJVcVA0MW12NVJtUDBSNVAxS3NCK01BNkNsTmp2WXh4cThWK0w1MjlIb2g4?=
 =?utf-8?B?OEMrblpONXFTL3l2cTRRRmhIOXBJNW9KZTR4TlRpYjBrOWxzemhiL25lVGNq?=
 =?utf-8?B?TDRTTEp3bndVam1MTEE3bHd1UE0xTkU2SDRxaWU2VUhLR0VnVUVpRFRZK1lm?=
 =?utf-8?B?dG1yRXhuWmFNazNZU0NSNFA2amkrcTFRWEprTEV6by91UG9FekRrMGpuS3dp?=
 =?utf-8?B?ZkFTcDhrQTJoNTJJT0x2L3NYazhaaUdkU0UvYmRpL29YKzZvY1c2SW9rZ3RT?=
 =?utf-8?B?cCtvRDRpVHE0Tk1MNU5XbHdxZkcvbVIrc1BPWlE2c0JpVEJyVWl1dXFZbnp1?=
 =?utf-8?B?a29BNzJlaHkxeXhZRkVjenBpc1Y0aVBmcCtrdnI1UVduOS9JM1hmbThFTEtG?=
 =?utf-8?B?TTQvN0xRQXdoZEZwVzZPQlFZcWlVYUdzNFhzK2ZOd2tSK0YraXRzY2xFY2J2?=
 =?utf-8?B?a09BaTZ6SzNJMEZGZmExSmh4UXpCbjMvaTlWbkYxclN2ckVaSUpZalBnejZL?=
 =?utf-8?B?Y3h2c0xRNWxuUDFBbTFlTWhtSDRRVnVQM0haYmxiNVZIMFpUejNJaFdYY2Yr?=
 =?utf-8?B?eXJ6ZWFZbXY2clhWSW5HanBsRjFjaDBLTTJOcUpaSjE4VDY2YWpUWVY1WFpO?=
 =?utf-8?B?b2tONXBJQUtXTHRrc2NnU2FYU0doa2RlaXNmaXlDeWN0Mmp4TTVTaEI1UXZh?=
 =?utf-8?B?bndHSG9KN2MzdDlrN1lFOUpKWnpVNjZoc3YvV3pQdFFoNDVRSzV0YklscndZ?=
 =?utf-8?B?NWkwK25kUktHRGMvUlY5WFZVODZwMXg4eVN4bDdONUQ3cUxWUTY1SW9GSFBK?=
 =?utf-8?B?aVVGR21ybU5kZjRoZHlqTG05S0ZOU1VScmpCdlhiVHdGbk9kZmtHZ1FhT0FX?=
 =?utf-8?B?UjdINGJabW9QMmlNdVpYanBFbjV6anhRWnZ1SnAvaHl0OGdQWVFnV1kwYnFB?=
 =?utf-8?B?SUdPNGZxSlg2ZnhjbnJvWXErZG1vY0ZOQzBVZS9tOVVjMjZuci9CMGYzMHZy?=
 =?utf-8?B?SHd4TzFTajBhT2kwWnVDRmcvenUxV3dxNkVpemx0SnNDYS96UHduVHNRMnEw?=
 =?utf-8?B?TTBqWWtSU3BCK1hCQm5WeWpwYlk2Y1ljbjhvK1dOMlZnaXQ3WHJsN29LN2ND?=
 =?utf-8?B?aXhEQnlpYzRkSEVMckVVZCtUR3ZnMENMcmZKd01mclVUZy9hbHNrc1RmbCtO?=
 =?utf-8?B?eUYvZnBQVGpYQ1htU1JRaFpBVFNGUm13ZEYvRy9BU1JjWXVuQW54cHh6bFBK?=
 =?utf-8?B?eGZ0bFZvSHAzeEdhYVlESmFldHg5OExKM0p3YnhzQ2YrNXlvenVDTEtGdjJu?=
 =?utf-8?B?dnBQNm1Ed0V1Qkk1WWFYcEwzb2xMMm5WWnhzSlhqTEJUVmY4UmFJaUtrL1JZ?=
 =?utf-8?Q?QeVDlcC3bzoH6apwShX6mHoaH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceeead23-f961-4eef-8055-08dc37c86b68
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 19:15:11.6138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v0H2jEWliESEAApKH20iwzOgRIVxabOHrN+93HN/Irs7hgx5rdZCzSScFYbKs2cM/lZK0OhSYJxMVYP1+A5Arg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7973

On 2/27/24 12:14, Sean Christopherson wrote:
> On Mon, Feb 26, 2024, John Allen wrote:
>> Rename SEV-ES save area SSP fields to be consistent with the APM.
>>
>> Signed-off-by: John Allen <john.allen@amd.com>
>> ---
>>   arch/x86/include/asm/svm.h | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
>> index 87a7b917d30e..728c98175b9c 100644
>> --- a/arch/x86/include/asm/svm.h
>> +++ b/arch/x86/include/asm/svm.h
>> @@ -358,10 +358,10 @@ struct sev_es_save_area {
>>   	struct vmcb_seg ldtr;
>>   	struct vmcb_seg idtr;
>>   	struct vmcb_seg tr;
>> -	u64 vmpl0_ssp;
>> -	u64 vmpl1_ssp;
>> -	u64 vmpl2_ssp;
>> -	u64 vmpl3_ssp;
>> +	u64 pl0_ssp;
>> +	u64 pl1_ssp;
>> +	u64 pl2_ssp;
>> +	u64 pl3_ssp;
> 
> Are these CPL fields, or VMPL fields?  Presumably it's the former since this is
> a single save area.  If so, the changelog should call that out, i.e. make it clear
> that the current names are outright bugs.  If these somehow really are VMPL fields,
> I would prefer to diverge from the APM, because pl[0..3] is way to ambiguous in
> that case.

Definitely not VMPL fields...  I guess I had VMPL levels on my mind when I 
was typing those names.

Thanks,
Tom

> 
> It's borderline if they're CPL fields, but Intel calls them PL[0..3]_SSP, so I'm
> much less inclined to diverge from two other things in that case.

