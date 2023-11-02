Return-Path: <kvm+bounces-356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DD57DEB6D
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:34:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 63498281BF1
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 03:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091DB1865;
	Thu,  2 Nov 2023 03:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TJaj8VXN"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE91851
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 03:33:55 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FE99F;
	Wed,  1 Nov 2023 20:33:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kwvI6cyB/VXBLQgJe15JszZ7DcR8bYyBsodE6Cs1JBDd5bINidtw6Kkzk/Go+3+C6GMcS6bT2A5RCKk3aYD38Nkz/h2Xlsz2W/GPzHySreWnRa8CcEgb8rR01pMZZJGykUTVJXk9sIVxpm3eIe4ti71ob7QSGufUjhJEyxNv7OnLb0MBIJsVqRn6yFWq8JE8hi4v4JyQavBm59UMtws0Jmb+X8iAuitkJxw4BItqD4y3XITRvItT56gv2oX25DAEMWvSvHX/fFSEJ9bOFiPULzwakIYJe1go7n8sRxUnuR1rKnZ5ARF/R2Gk/z1IpsqguWoYqOHP6efG6SOpWC/G5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4a61wOUre/3b+R2eThs77h8VDMUTQpCgOCqZwEPMgbY=;
 b=DdgWU/UfYQfFuI+XPEiiBsDY1VVpso2UA5jBHXX32w60/FnVPpB1ec0Gir5d8W9lQe3eJb+z03mp1UNLIHaahchG+qPwhLWZcbiME81S3HE7vYaKvZtnBVMtsTlC9cKu4ZyOxUaZL4TPEPIhHFJ4dUDSbbauuqxsvi8ckjoMkbLo31hGmtj3RCFHjUYHa14GYEb4Na026jnWO1hfXhg+XCdvcXI4p/8B/Yia+p5aucrFawo7320qeTYSATfk7P+j6cX81LKfRjlh6ri58Sf+sDJI0euMaH8iGT1J8SCJlZoCA4MtzkaS1XH2LBLmKVC2mWVHDag56fnfbE+69TFvxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4a61wOUre/3b+R2eThs77h8VDMUTQpCgOCqZwEPMgbY=;
 b=TJaj8VXNs6j28A7/mqEIMlLp4j+nCFtkA/tYVdC/FmKGnehywYcl70f151wPGZ70HEDwz0einLOEuR9kHlNplz0yreV4SPwkgBwTlneHh8/kZCPATUhDtirZakUbfdcjhqcJ52mPzzqeGrR7AX5Y582TDyxh7sIwiGPq496UzI4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6954.21; Thu, 2 Nov 2023 03:33:48 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::93cc:c27:4af6:b78c%2]) with mapi id 15.20.6954.019; Thu, 2 Nov 2023
 03:33:48 +0000
Message-ID: <1cdb3a7f-a30a-4874-ab3a-8fd0f8b5351a@amd.com>
Date: Thu, 2 Nov 2023 09:03:38 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v5 01/14] virt: sev-guest: Use AES GCM crypto library
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 x86@kernel.org, kvm@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com,
 seanjc@google.com, pbonzini@redhat.com
References: <20231030063652.68675-1-nikunj@amd.com>
 <20231030063652.68675-2-nikunj@amd.com>
 <2a4bbe7b-31e5-7527-8e63-10fb318e0f46@amd.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <2a4bbe7b-31e5-7527-8e63-10fb318e0f46@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN0PR01CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:4e::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|DM6PR12MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ba855b2-c2a7-46cb-9e48-08dbdb5485dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	u31J9F2plugk694uOUqJbC5mEMGI/XzndRU9XUqnn5Gh8eqrgSN89HJ/L2X18UjVLoN+XC2NjCjFfIL2GKdB9bQ8fSLzBlpjqq8WKWftZqfBUBkosq+XSZx9wbCgLqwoFSREjY70lZCQauCReToyl8qRAtuZryzhh1KpwR7DOHJV1HKSFasDxJnUVUXZ0Gzc56wGORcR4lzGTGvcQo45fHwIQ39NR1jNJbz/BNDX6fYWbr4+XKOmxHd/Zd8XFuxGgSxEsyBfpKr3Kix29RA62arCrGh/ZGYmoIB7fIvMcB4OVjC6rWl0+jd1+Ds/ryzqLw/9hJw844SHAMZ9Rp8AJCCnWRaAdN8JBYZC0bcUY2QKKk67ppAja72ogL630G6ozxgD41XAAa5bUwa//uX1b+OShmKoK44oVXtoo4Db2DvgBF1MF/pPfG1qkkmjYJdf7uy/SyObYwpG8s3FnchnLvoy2vh49W0WIt5+JMj3PIGbsR2ABWLbPZxJ08NXIvmrWP5Opz+kOw4UF9x9FlsvOm11qmE2Y+LD9BPLz3I0u9xVJyN9MmW13icfAydmuBiqi/RdcJ8EGSV8qnVYCCD8SbPFtPLwS8b+JLhlff85K3PvTi1H8Cgl8bI/D5mRNIS0XIhYad0CyXg1AR87rhHNIQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(366004)(136003)(39860400002)(376002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(66556008)(66476007)(66946007)(316002)(6506007)(2616005)(6512007)(26005)(36756003)(6666004)(38100700002)(31696002)(53546011)(83380400001)(6486002)(478600001)(5660300002)(3450700001)(2906002)(7416002)(41300700001)(31686004)(4326008)(8936002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVRQWEZ1by9oK3JsSU5iRFQ1VlhoKzA0T1h5VExGeWNtVUpCUFk4Z0hsZmNR?=
 =?utf-8?B?c3Q3VUYzRE9aYTgyTGloN29MRGpWM1hlQ1VZQWd5QmlXZ1NGSmlCdHdpZGZu?=
 =?utf-8?B?U3p0bXc2M1Z6S09SLysrNEhWZWtYK2gxUXU3RHhkSlFKTlZXZVhNTGdnUHFV?=
 =?utf-8?B?R2MzcjhlRnZoYVlzUG8zelBXS1VrTm9LejEyZHlkVEF5OFo2emlPaUd5eFor?=
 =?utf-8?B?T2lTTWRvQ3N1cERzSGQxQzVleDFnQVhuQTlVTGxTdHZaWlJROGN6R0pGMXg2?=
 =?utf-8?B?TDE3L3NReGNMdUJjSmJva2JDRitoWGZ2TFdRVVpsTDloeUF5YkRzcHUwMDJw?=
 =?utf-8?B?SElOTmdVcGpEZGlHdmdnc3Fsejg1UllFd1ltenEvSXZja25rU09kTTd6QUQx?=
 =?utf-8?B?VXI4V1U5bjhEam4wQUN3NTU3QlhQZ0FhUUhhU0Q2TVFOVlZId3N2cWNCMzgv?=
 =?utf-8?B?aEwzckJweTg0UDkwbUpxRklWeEtZQjJyZmIzbUZYajlReGhkVGRTRk5NWGlx?=
 =?utf-8?B?KzhkbkZWdit6WFFWS2hnVVdMdzl6bHJFbUZ4OUpvTVBUb0crcFQ3Ujc2S2lU?=
 =?utf-8?B?Rnl3QytlUWt6cmx5YVJwS0U0d1dtY0dvd3p4RlB2bXF0bU1va3Fwd1RUM3Uv?=
 =?utf-8?B?b1JZditCMjVHV1hrTXkxQnBERHIvUzgwWjlwdkVDT24rTGZyd0kwMmJaWjhI?=
 =?utf-8?B?cmhkL0FOZms5NFpwUVRqcHBYVmVHbnRUL2JJTTVkRGlra2Y1NXBCODZZTWY4?=
 =?utf-8?B?UEpmWkRudjZVWE10TDR5azlTV2ZpeHgzOUNtcnNhL0VwRUtPSmJlZmZscFpC?=
 =?utf-8?B?bkMycHNkeS9vQndhRm5QcEhza0VDbTZJT1IrRURWNnR3dG9PZW9BSHpXa2FB?=
 =?utf-8?B?MGR1OHYzUkcrMkRQaW96c2gwOGdEYWFPam14LzFuNXJYRFRZTlo1emRwejBi?=
 =?utf-8?B?SVlaS2xYbmVDS1FYWmJ0SU5mVDA3ZlJIc2hSL09CaFE2Z2tsNVowdXJDcjdp?=
 =?utf-8?B?OTVKeFV2L3lEd2hYT2IrN0xPL1hmYlpkQXhxZkYzSUhqZ0RNYjZrTmZVYVFK?=
 =?utf-8?B?ZVVpMlphUjRKM1M1ZXAwcEhUUlZvVW14NWhDTkxsL1JzMU84VmJNMmNzOC84?=
 =?utf-8?B?eVJRNjBUNjlwQ2xrbTgyM3NnZFNad3FjNTBPT1dLaFhSRFpFOXU5NW1IRE1w?=
 =?utf-8?B?QXl1VXl3b0Q3TFVHUzlTdG1VZzA4empkZUgvamNaU0RwUGNoSytOdm9LajVI?=
 =?utf-8?B?am54L3c5VGRzOWZNc01wRU9Fem1nVENQTk5oZ0FuVDYyeXI5a1B2bkt5OGh2?=
 =?utf-8?B?UFhDa29BNWpEZGR4WngwNk9BUmlHcVd3bzMrdFVGeHZ4UG1tbmVpaWxTOWFI?=
 =?utf-8?B?VVdtMDZHbjdRWHEyS3R1ejdPVHlkcTRycm9mUDJpZjE3VElySGdzRThSQU02?=
 =?utf-8?B?T1RydEJwQ3RpWjJoYWdWZXMyK3lJbGk1L2xBK2hsdWtlaXlpb2NjbWZGRkxL?=
 =?utf-8?B?a2tvVldUMHJSZGtqSG5PRWc2dVcyVFRRWTBkNXNqM1BwUVkwd0lIalNLcDlV?=
 =?utf-8?B?MFE1SEdlOFNOSW13VGZGUkh4RTNESkU4RVd3R0NLVC9McjMvY3BjaDVQVlpI?=
 =?utf-8?B?R2I5VEtlVUxhSnBpbzZ0eFhBZjdaTEZ6WmNUTmJva3NBVjlMZkszcE5nb1Vs?=
 =?utf-8?B?d3I4RFhMWTk1aVFpZVhCVVFsaFhZeVl1Z2tvaHBSODJjd1dya0ZNRjNJa1BW?=
 =?utf-8?B?dmo3aGM3NHRvdlhSRy9XYVNqaENtMy9BL1ExMGtUQkZGTWFkNzI0VU5TR3VC?=
 =?utf-8?B?TVNFN3FPRFF4OXlhMXRqeGovSktRalVISXZEM2NFa0FzRDB5WWNseDlYai9v?=
 =?utf-8?B?aDlOUCttUFo4WlVjRkI2UlpLU0Z5by93bVFpSWZmVHhXM3dISldvVVJaOTZV?=
 =?utf-8?B?ckpxaThOaDd0TXlNekU2cFFXdVljUkNCbUdoNjFiRUJyVy9aL2wvcFhEK0pG?=
 =?utf-8?B?ZlZTSjRkaG5IbVZza0RtU3pFcloyMndYM3RGNzZKM3ZtTXN1ZFEzNW1ISWRk?=
 =?utf-8?B?a3hST0wxcWpZcUhrMVRmZCthQWZjY2w3a2FLS1ExcE1mekZFTVpMT1h2bC83?=
 =?utf-8?Q?fPtLE0jB/mL2jbCFm/oZbVLrD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba855b2-c2a7-46cb-9e48-08dbdb5485dc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2023 03:33:47.6432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KVCUAaSDlwk1N1C8ykJA1zGulTt95xeaA62OLVv9fPtbK2eB1Shr4+W7DIs3sklP8EPDDaDrhUBfnQcQ5HJFBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388

On 10/30/2023 11:21 PM, Tom Lendacky wrote:
> On 10/30/23 01:36, Nikunj A Dadhania wrote:
>> The sev-guest driver encryption code uses Crypto API for SNP guest
>> messaging to interact with AMD Security processor. For enabling SecureTSC,
>> SEV-SNP guests need to send a TSC_INFO request guest message before the
>> smpboot phase starts. Details from the TSC_INFO response will be used to
>> program the VMSA before the secondary CPUs are brought up. The Crypto API
>> is not available this early in the boot phase.
>>
>> In preparation of moving the encryption code out of sev-guest driver to
>> support SecureTSC and make reviewing the diff easier, start using AES GCM
>> library implementation instead of Crypto API.
>>
>> CC: Ard Biesheuvel <ardb@kernel.org>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> 
> I just a few nit comments that might be nice to cover if you have to do a v6...

Sure, I will address them in v6.

>>   -static int __enc_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
>> +static int __enc_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>>                void *plaintext, size_t len)
>>   {
>> -    struct snp_guest_crypto *crypto = snp_dev->crypto;
>>       struct snp_guest_msg_hdr *hdr = &msg->hdr;
>> +    u8 iv[GCM_AES_IV_SIZE] = {};
>>   -    memset(crypto->iv, 0, crypto->iv_len);
>> -    memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
>> +    if (WARN_ON((hdr->msg_sz + ctx->authsize) > sizeof(msg->payload)))
>> +        return -EBADMSG;
>>   -    return enc_dec_message(crypto, msg, plaintext, msg->payload, len, true);
>> +    memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
>> +    aesgcm_encrypt(ctx, msg->payload, plaintext, len, &hdr->algo, AAD_LEN,
>> +               iv, hdr->authtag);
>> +    return 0;
>>   }
> 
> __enc_payload() is pretty small now and can probably just be part of the only function that calls it, enc_payload().
> 
>>   -static int dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
>> +static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
>>                  void *plaintext, size_t len)
>>   {
>> -    struct snp_guest_crypto *crypto = snp_dev->crypto;
>>       struct snp_guest_msg_hdr *hdr = &msg->hdr;
>> +    u8 iv[GCM_AES_IV_SIZE] = {};
>>   -    /* Build IV with response buffer sequence number */
>> -    memset(crypto->iv, 0, crypto->iv_len);
>> -    memcpy(crypto->iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
>> -
>> -    return enc_dec_message(crypto, msg, msg->payload, plaintext, len, false);
>> +    memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
>> +    if (aesgcm_decrypt(ctx, plaintext, msg->payload, len, &hdr->algo,
>> +               AAD_LEN, iv, hdr->authtag))
>> +        return 0;
>> +    else
>> +        return -EBADMSG;
> 
> This would look cleaner / read easier to me to have as:
> 
>     if (!aesgcm_decrypt(...))
>         return -EBADMSG;
> 
>     return 0;
> 
> But just my opinion.
> 
> And ditto here on the size now, can probably just be part of verify_and_dec_payload() now.
> 
> Thanks,
> Tom

Regards
Nikunj


