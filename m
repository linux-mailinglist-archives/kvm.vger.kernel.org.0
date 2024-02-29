Return-Path: <kvm+bounces-10464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BEA286C4A3
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C852A1F2402C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 103C658124;
	Thu, 29 Feb 2024 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yFokakQW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC31A57894;
	Thu, 29 Feb 2024 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709197993; cv=fail; b=uVLBQgpdXXjGSHjEVmUVJ9Eqv+CSvmWCWgzvp8T6wZUX9/oEdBGmql3ViyhFTt9DhiusocWA5AXQ04A6A3LmbXcG9bS93ivaMJ/Sx7h00awJQKbCQlXzyLwF+mFw7kCJmk/cfwhRyZMdvWHcLstQMqmYbBAPFzhh8TE/0sJWAKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709197993; c=relaxed/simple;
	bh=T1ZMqIp/z89YWjuu1RsiPEMlD/ETZrXfn5NecfukNQ4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XubJaBBo89Gm6aqt3jRY58cF8Z9UmAO1I0wZyrEIErycwrClPmbPSFhdvyYyJG/r1p9vNFndQe5skIA5+UP+nygKQ7wMHvshxwspt/uGvX6afn2DJNfK6isgFTlE+Q+0FSjYgc3ztn0e2YHpPf3626EK3dBaqmNJDC6zvgyFWhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yFokakQW; arc=fail smtp.client-ip=40.107.223.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVr1e0/tGv/sJgeZbyzU5WNdPgoqhMGZJhp0OCYTYhLnLqjkbBWSWJNcTXNr9J8XOsUY9ZXBCcvhzhO4cjBo2hetnhCeuFsLk/U6HUdgngRzxpFag6X7lBPCVbf72eMbLDgncmaK04M6c/FJqCl00UwkgzJ4sGe0vhHscO09rxevbTGoDH2XrISgFvWFnmBDpVV3xw3Er0+jPTzte/rhc0YhNemImCcVtBSYg0qstIqJnT+lPnSEF6ryXGLIP5JM1rq7tLhSijy/gaaYrUTF6JwO9KVQfzCPEahmkNMknyWoJGZPXP6GGtceySJJSY/ChDxR4HdLvF6TKxnFx61ZUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wlLN0sk2/FVoktKz2de+rUsFEuqS4eoCFEqdQJDpB6M=;
 b=bMsFmt10tIZKYbikLeKvESYmQFSAnoNqCDcqr5pvDqzntLKtRjs2XN5NFcO4/PJkcxjvl5ZMsAw6Ev06EtxwoHT2FnsIVIxfL/RSdFsNfZeB6Xfy83eGfPuZB7QFazkvfIWL5+pcyzm70gMxeP4+zQ8ZX0KWEh1BxcGprn2WWZoQFcnTuxYENYWD/qkLZfrfhrEaHmEr9RnR4i9B6r1YNttWEr4nlhcrAH9IEKZ3tfG3aNe5GTNVUi2k76bazlBhcYjT81YP7yFYn6vuEsi5JFcPqFyRkOCHWUvr4RWDKPqMEGJy1AcfOmmqum3syUhddAZN6qgyC/J+AFvkCexNlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wlLN0sk2/FVoktKz2de+rUsFEuqS4eoCFEqdQJDpB6M=;
 b=yFokakQWVOvPPh0Ji6fsrFqwugCCB0qy5+32KLe8dgrN8Z9y/pvL9rSkplUflz7cM5GvxUuMPYR0DR0lOpV4E9AgsXbWZ2pzvruAgreLqWq81jWnq9TGgRM0hzN1uHVCngXHpWLKM9XFIpHyPlcXo2SLzkg/F2tYWrNWOvfOiQw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MN6PR12MB8490.namprd12.prod.outlook.com (2603:10b6:208:470::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 09:13:08 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::71ca:c3d6:bd74:5aa4]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::71ca:c3d6:bd74:5aa4%4]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 09:13:08 +0000
Message-ID: <84a74c55-e314-4824-a088-297b3f1c89eb@amd.com>
Date: Thu, 29 Feb 2024 14:42:58 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Tom Lendacky <thomas.lendacky@amd.com>, linux-kernel@vger.kernel.org,
 bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
 pgonda@google.com, seanjc@google.com, pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-4-nikunj@amd.com>
 <c03f15aa-6606-4aff-bcec-2e29e0b36d9f@amd.com>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <c03f15aa-6606-4aff-bcec-2e29e0b36d9f@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0220.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::18) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MN6PR12MB8490:EE_
X-MS-Office365-Filtering-Correlation-Id: 086137fe-94b5-47dc-8421-08dc3906a510
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ht5XKbXYo7MwvoGd38cOEsjNHb5y1ZkO9ShGFMCPnjb2n6WNjK3mD+fEF2KJfLfe+IVP47e+d7uKNkDLRtIRzXKfee1JwcJlqb3dBvdbg0YgDYf2RBfojtgxJd1jAgnjBnQSj6RAAU5f3ELxY6d37MzLCcxBBSsFrjAG5uEN8fmTxgBYxDKT87p0RGnTZXxfJ6524MUdDjSYIc3KpFKaaCqaw0ZjxIgDNtHBkSMs0BLB3gupZWxA1MHMO6QZ3QC1rWcipLGCeIt5Z31LUhIYEBbNI+Olo2RIiSj0WW3uLcaMyRQI4+5AAqH9jHbAY6w5jw47s//dyDXEEoyfYerVi0yg2BwEU4jreltioekGVtl9kf01Vco5/mxHSFYa3hrJ5ne6gMh9PVp/gvqqoKGJUsGulPxXp8ZQf9swFJTID0WPpCI+V45Ny402FIhl1sEklm4Ghzzj44mt2DW2Sr3Ih9zKJ5ZR6FKxWOS+2FpCJGbivnR+rVfGuw9QxlSKwODkqo9ZTKVPfdcwEREC0/O8zzu6HdyMV1kt6leq0EGk6cao5L8t/aiDQqvrEgLJQhGFhnUj01eQby1oPWPYcBpf2+4OW0WOTAW5AX1nFgsdznakIR5HOr9UBN1g5iWx/KjL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGxnaHpOakorNG5CSEw4aU1GNkdiWU5GaytOcHB4T3pxNStxVERObUtSR3Zq?=
 =?utf-8?B?VEFCT0pMSmVxZXN5R2MyTjcxRWxJbytQMzFFcmxhNWJZM2tud2RYWCtDRWFB?=
 =?utf-8?B?eDRDS0JaTVE2dUhyTnY3SFJML3BqT0RHanlJQTRnZklObjZPRXhBUnAvSGRi?=
 =?utf-8?B?Nk5QNStTcElXQ0J3dGpQMS9iK1BIcXVUV3N2ZmNnS2ZBM0E0Y0pnVE5OVzdX?=
 =?utf-8?B?dmgxK3E3M3g4V0ZjM1BPSUI5SjNwaHVhZk95eW5ncU5nZk5BVFFqS3BhaDA5?=
 =?utf-8?B?b0toZjJXWnMvN0lNV1F3K3RKS0lDWDVLSmlncEZLYWdjRDIrb2o3cmNNVWNo?=
 =?utf-8?B?VXdyaUFSZGxTeFRHY1dONEFkOCtab0tYTXozcnZxWUxoR2hWU2lGV0p4V0Qr?=
 =?utf-8?B?STNOTkU4Q2JVSDBOUCtPQWRNTzNuTzlZaUF2MGFieVNwYVM2VWdsaTk0ejdG?=
 =?utf-8?B?aStlbjM4VzJkNitiQXVRZHRoVnhDTTdUaGdjM216bmJLa0VCenlSaGlsdmFV?=
 =?utf-8?B?eThQQlBidCswOXFyeXhKTU14bktMbXF0ZHBMRStXYlBRS3EySC8wcTJIQ1pX?=
 =?utf-8?B?T2VjeXNvNXJrRjVMOHZNbDBVdWtrajQrdldCMXBJNzBNd1lCeDh6aHRJa0sw?=
 =?utf-8?B?dXZ3SU1uZUQxQjVrbHU5bXM4TGJtRUpZNjdzNHZucm1uOW9BNEY1S2tOQTJs?=
 =?utf-8?B?ZnAvMW50bGFsSFJrbjZscjVyd252SkdFNXNoN0hzV2FqYnNPWGcxK0htblow?=
 =?utf-8?B?ajlDQk1rbVU0U3cxTloyZDdEYmszWFpIRUE1UzYzN29OVmxPb3VJa0NsVDRG?=
 =?utf-8?B?ZXhTRGdBUmtvanJNSXZRbmora3lPRkZ0eE1WMnZIVkJ2aTJmWnYxbUZoeHJR?=
 =?utf-8?B?VHdWM0VnOFBvZVluZUJpcm1FN0Y3eC9yZXlxZTdsZy9HTldBK25waUxDSTZH?=
 =?utf-8?B?ZWZjRWJvaGoxR2orVndaa2t3OGVFSWlrWDZ0cVdvaDhBazBpdUczS3diUWIx?=
 =?utf-8?B?VWlGK2RvUC9JMEtkdFVZN2FZMm85SkZjZk16Z29KMUxLZUY2dmZlQk5EekFJ?=
 =?utf-8?B?dC84ekFxbjcycnd2THV1aEQ1cGpwcmswRDhBSTVnWmx0WHo1TllJUExnS3ZE?=
 =?utf-8?B?YjZaQWlmTTA2N0dxbC9EdWtuL1d4ZzBVYTlGU1FYS0syMTl0QkhINkZjdUNE?=
 =?utf-8?B?NzhSR3F1SC9ocXV4WWo2d3FxRnRVdGFwS2ZhaG9oTDdUQ2pIT0YrMDN1UGlM?=
 =?utf-8?B?U0d4WUg3Q1huWUFlL3FwVWVZNWEyOTl0U1pCMHl4Q01ONWpuekVjYWRjU29D?=
 =?utf-8?B?ZzZMc1R3NkRBenR6WjB0V1NHWXVBUi9HQUMxaDZDRFVLaTNhOXk5OUMyanh1?=
 =?utf-8?B?MUNXVUhQUlZmazA3aEdTRHlSTVNWU1p6VWtJTGQzemhSVnlKenNXRGZjVU5o?=
 =?utf-8?B?Um9Ib0tBM0d3RURZaU5wY1FTdzd2clVXaUVVMWo1cm5pV1BreGNFaVNXOTdh?=
 =?utf-8?B?dDFyV3N5em1PdXZCSjlib05zaHBCU0Y0RzN2ZWhPWXhnd0tGRVc2N3IxcjNW?=
 =?utf-8?B?S3E5WjRKczZlWjhDamJNd05wT3pXY1k4aVhQcFFySktWT1JETE9pK1JQRlZY?=
 =?utf-8?B?NWdRcGp0ZExwWDhPNUM1UG5vQXFraEdMdFVxV013TGJJYlhVTWZmZDNhU0t0?=
 =?utf-8?B?NTRHODFtdXpGVHY0QjJ2eU9OUS8rU0czbUNSaWxhYVVBd3FKUlZkU2dEdFZa?=
 =?utf-8?B?dUxUWTlDYUZDcFRBRjdNRnljWW9vSUIwYXNNSnFLZHF4TjBPM0g0Mmdka1RN?=
 =?utf-8?B?R2hmY0NzZ1lwTGs2cE1PS0RPYnFNTVFqUGFaWkY5V3BnMGhhcHRXc0RrcENE?=
 =?utf-8?B?OTNCTXc0S0MzdWFMdk1mY2hwSlA4aE9rUWF6V2N4cGQwUHNKN2R4VWxOckNx?=
 =?utf-8?B?OHV0bllPMXRobmtYN2ZXUk00bUVuN0lzYmNKS0FmZktjNnpiRkIzVGR2V2w3?=
 =?utf-8?B?UnpJVXBRbzBQNG13MkorNW84endOOVd3Z2Z1MnliZENwVlY0Z2tqaUJqSk5S?=
 =?utf-8?B?SzRsZEZUUytuV3pZMFVadWhCUlA1aVp3OWtlcFo2NE01OVduZlR3MlFKQkg5?=
 =?utf-8?Q?jR5xXIiZG6iweBp5cE/qvfkNK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 086137fe-94b5-47dc-8421-08dc3906a510
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 09:13:08.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KNSz+lADcWUvR0WwgjHyfqka0sWcmgQ8oWpc9XN+Q0MMgpHp//t4XBrE+BMwkjTHequfpAmwK7DsyEjTgYGLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8490

On 2/28/2024 3:50 AM, Tom Lendacky wrote:
> On 2/15/24 05:31, Nikunj A Dadhania wrote:
>> Add a snp_guest_req structure to simplify the function arguments. The
>> structure will be used to call the SNP Guest message request API
>> instead of passing a long list of parameters.
>>
>> Update snp_issue_guest_request() prototype to include the new guest request
>> structure and move the prototype to sev.h.
>>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>> ---
>>   arch/x86/include/asm/sev.h              |  75 ++++++++-
>>   arch/x86/kernel/sev.c                   |  15 +-
>>   drivers/virt/coco/sev-guest/sev-guest.c | 195 +++++++++++++-----------
>>   drivers/virt/coco/sev-guest/sev-guest.h |  66 --------
>>   4 files changed, 187 insertions(+), 164 deletions(-)
>>   delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index bed95e1f4d52..0c0b11af9f89 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -111,8 +111,6 @@ struct rmp_state {
>>   struct snp_req_data {
>>       unsigned long req_gpa;
>>       unsigned long resp_gpa;
>> -    unsigned long data_gpa;
>> -    unsigned int data_npages;
>>   };
>>     struct sev_guest_platform_data {
>> @@ -154,6 +152,73 @@ struct snp_secrets_page_layout {
>>       u8 rsvd3[3840];
>>   } __packed;
>>   +#define MAX_AUTHTAG_LEN        32
>> +#define AUTHTAG_LEN        16
>> +#define AAD_LEN            48
>> +#define MSG_HDR_VER        1
>> +
>> +/* See SNP spec SNP_GUEST_REQUEST section for the structure */
>> +enum msg_type {
>> +    SNP_MSG_TYPE_INVALID = 0,
>> +    SNP_MSG_CPUID_REQ,
>> +    SNP_MSG_CPUID_RSP,
>> +    SNP_MSG_KEY_REQ,
>> +    SNP_MSG_KEY_RSP,
>> +    SNP_MSG_REPORT_REQ,
>> +    SNP_MSG_REPORT_RSP,
>> +    SNP_MSG_EXPORT_REQ,
>> +    SNP_MSG_EXPORT_RSP,
>> +    SNP_MSG_IMPORT_REQ,
>> +    SNP_MSG_IMPORT_RSP,
>> +    SNP_MSG_ABSORB_REQ,
>> +    SNP_MSG_ABSORB_RSP,
>> +    SNP_MSG_VMRK_REQ,
>> +    SNP_MSG_VMRK_RSP,
>> +
>> +    SNP_MSG_TYPE_MAX
>> +};
>> +
>> +enum aead_algo {
>> +    SNP_AEAD_INVALID,
>> +    SNP_AEAD_AES_256_GCM,
>> +};
>> +
>> +struct snp_guest_msg_hdr {
>> +    u8 authtag[MAX_AUTHTAG_LEN];
>> +    u64 msg_seqno;
>> +    u8 rsvd1[8];
>> +    u8 algo;
>> +    u8 hdr_version;
>> +    u16 hdr_sz;
>> +    u8 msg_type;
>> +    u8 msg_version;
>> +    u16 msg_sz;
>> +    u32 rsvd2;
>> +    u8 msg_vmpck;
>> +    u8 rsvd3[35];
>> +} __packed;
>> +
>> +struct snp_guest_msg {
>> +    struct snp_guest_msg_hdr hdr;
>> +    u8 payload[4000];
> 
> If the idea is to ensure that payload never goes beyond a page boundary (assuming page allocation/backing), it would be better to have:
> 
>     u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
> 
> instead of hard-coding 4000 (I realize this is existing code). Although, since you probably want to ensure that you don't exceed the page allocation by testing against the size or page offset, you can just make this a variable length array:
> 
>     u8 payload[];
> 
> and ensure that you don't overrun.

Sure, below is the delta to make payload a variable length array. I will squash it with current patch.

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 0c0b11af9f89..85cf160f6203 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -200,9 +200,12 @@ struct snp_guest_msg_hdr {
 
 struct snp_guest_msg {
 	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
+	u8 payload[];
 } __packed;
 
+#define SNP_GUEST_MSG_SIZE 4096
+#define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
+
 struct snp_guest_req {
 	void *req_buf;
 	size_t req_sz;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 596cec03f9eb..da9a616c76cf 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -46,7 +46,7 @@ struct snp_guest_dev {
 	 * Avoid information leakage by double-buffering shared messages
 	 * in fields that are in regular encrypted memory.
 	 */
-	struct snp_guest_msg secret_request, secret_response;
+	struct snp_guest_msg *secret_request, *secret_response;
 
 	struct snp_secrets_page_layout *layout;
 	struct snp_req_data input;
@@ -169,8 +169,8 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 
 static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
-	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
+	struct snp_guest_msg *resp_msg = snp_dev->secret_response;
+	struct snp_guest_msg *req_msg = snp_dev->secret_request;
 	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
 	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
@@ -181,7 +181,7 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
 		 resp_msg_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));
+	memcpy(resp_msg, snp_dev->response, SNP_GUEST_MSG_SIZE);
 
 	/* Verify that the sequence counter is incremented by 1 */
 	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
@@ -210,7 +210,7 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_gues
 
 static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg *msg = snp_dev->secret_request;
 	struct snp_guest_msg_hdr *hdr = &msg->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
@@ -233,7 +233,7 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_gues
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
+	if (WARN_ON((req->req_sz + ctx->authsize) > SNP_GUEST_MSG_PAYLOAD_SIZE))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
@@ -341,7 +341,7 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 		return -EIO;
 
 	/* Clear shared memory's response for the host to populate. */
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
+	memset(snp_dev->response, 0, SNP_GUEST_MSG_SIZE);
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
 	rc = enc_payload(snp_dev, seqno, req);
@@ -352,8 +352,7 @@ static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_gues
 	 * Write the fully encrypted request to the shared unencrypted
 	 * request page.
 	 */
-	memcpy(snp_dev->request, &snp_dev->secret_request,
-	       sizeof(snp_dev->secret_request));
+	memcpy(snp_dev->request, snp_dev->secret_request, SNP_GUEST_MSG_SIZE);
 
 	rc = __handle_guest_request(snp_dev, req, rio);
 	if (rc) {
@@ -864,12 +863,21 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	snp_dev->dev = dev;
 	snp_dev->layout = layout;
 
+	/* Allocate secret request and response message for double buffering */
+	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_request)
+		goto e_unmap;
+
+	snp_dev->secret_response = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_response)
+		goto e_free_secret_req;
+
 	/* Allocate the shared page used for the request and response message. */
-	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	snp_dev->request = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
 	if (!snp_dev->request)
-		goto e_unmap;
+		goto e_free_secret_resp;
 
-	snp_dev->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	snp_dev->response = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
 	if (!snp_dev->response)
 		goto e_free_request;
 
@@ -911,9 +919,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 e_free_cert_data:
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
 e_free_response:
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->response, SNP_GUEST_MSG_SIZE);
 e_free_request:
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->request, SNP_GUEST_MSG_SIZE);
+e_free_secret_resp:
+	kfree(snp_dev->secret_response);
+e_free_secret_req:
+	kfree(snp_dev->secret_request);
 e_unmap:
 	iounmap(mapping);
 	return ret;
@@ -924,9 +936,11 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->response, SNP_GUEST_MSG_SIZE);
+	free_shared_pages(snp_dev->request, SNP_GUEST_MSG_SIZE);
 	kfree(snp_dev->ctx);
+	kfree(snp_dev->secret_response);
+	kfree(snp_dev->secret_request);
 	misc_deregister(&snp_dev->misc);
 }
 


