Return-Path: <kvm+bounces-10465-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6AC386C50B
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 10:26:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 747A1284668
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:26:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4AC5CDF0;
	Thu, 29 Feb 2024 09:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pt/NvoSC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2063.outbound.protection.outlook.com [40.107.212.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374FA5B690;
	Thu, 29 Feb 2024 09:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709198799; cv=fail; b=RbA/uIu9P8RqElRkngQjkjlI7zVuIWMxpqzZcUOwxuV/CMUJHL+qIN23fIZoI/JyULemq0j1h8fvttXboi01K/Xo3lP6uEKR71I7GTXr9eIJME71VPzbpIvDAtihu0rRJVwOy1Fod5xeKkKZBmWhEuhQ+SAKx/QhRkjbi8JKCJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709198799; c=relaxed/simple;
	bh=g7RiSR8iNEHKnIciQa2KQDESnRSy4MLZYdioiSyZWKo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bxSqoI1Zm0ukJibXmSbBMeUe54/dHJ+85afTkmCdI7x1CsWFiyXFTkEHgaQpyTh+F843/qJrSkO6cKAGWfRxGGhxj/lmN5hjM0vL1Llv8hHcQYhjVcO/HIF5GatUM4heUz+JJYxm/PJ/JHDRfQVrKAgNP2ysIdFGUhEROq0RD3k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pt/NvoSC; arc=fail smtp.client-ip=40.107.212.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf4t2sl3ofAFtllD2Ou6GLPAXfyIKn+kpm0LZv73S3PnqXDjKDqXXNvvlzoD0doRyWZtvpJ+vrkOZaEoH4WUbidn9Svpccwo6sIinT9R9k8pJ7DYg/CNjQQYdaGCY+IgI9x/J5ZQfPTRBN6X+Fn4am837LnpwsmJEGHi+xmp9JynELBtk0h79wVhyJuDbzy2nxF76coV75nu2kOaKNLfs34jMgZHqwYX+wdgVc/i8bFT1I2v/ig6g35NeVLlSoyoHj0nwmxXdFxqDWBnaNZa+Su86L+f89q5PxY5yWfRGllffIyjsa4FtVP/pqhGpFOUDBhqbS01zFK5hLIZxGnB5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nS5RnF2HoMVUO9ttsXpI8Bc9hq61vZr+XKQXBdNtFLA=;
 b=MIlO8g3OhY6qH/X01g+lBja5m/5C0u/dUqIpNWOsXLlDrld+KlcbtnUStPAe+rIzRhxwo1ra9bZfLzvLG6HnB9C+t5CXmGJM6L3b2npAyZ2EMoxDUgzR6T4qgHdnWP26Weh6qMu/EHrpmoXPsb1Nad/lpnUapVXrO3UQZiDpNPMjqJ2RlYxySrGQx50Py2uq9w69bLx66Uux78swtAJ7Dn0TZAEZJIS6QpaZO+Q0RKmZ1jyUaotm3KGhFsgzJFbmW1gIZ3OFG0QAUZv02htCn7FYY7hSBJK3rVfoMKqb4kolld7K9Up2aKU7V20ajo4Z5RVZMAS6vym+886snjV0Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nS5RnF2HoMVUO9ttsXpI8Bc9hq61vZr+XKQXBdNtFLA=;
 b=Pt/NvoSC4UlNngs8AvwaIQmnwEFTzvNdMmGUr7H0DhyFL8sPnhwdBzP+fNuI0NrIiKkEUw9RZNU7J9+6scIry3MVEnc613zlJy81YHLCTOzKGXH84H2EXia+RuESoClbYYqxd/luO0MfILeBMvIqo1852lFbw6/ieXRQTMtxCHs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.41; Thu, 29 Feb 2024 09:26:34 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::71ca:c3d6:bd74:5aa4]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::71ca:c3d6:bd74:5aa4%4]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 09:26:34 +0000
Message-ID: <5cc893ef-5e0b-4188-af76-7a9034e1a780@amd.com>
Date: Thu, 29 Feb 2024 14:56:24 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v8 03/16] virt: sev-guest: Add SNP guest request structure
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20240215113128.275608-1-nikunj@amd.com>
 <20240215113128.275608-4-nikunj@amd.com>
 <20240228115045.GGZd8eFe9WZYmZmIeU@fat_crate.local>
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <20240228115045.GGZd8eFe9WZYmZmIeU@fat_crate.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0229.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::11) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: 11a35fd8-e8e3-4181-b468-08dc3908857c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	NtoZmSxdeu/AVUnOzXBohHd/NRGvGSFoSX3zfPkeJ2Mew5sMWl1hsWOEUtIIjrSClxpRyv4D8qJtpTcERWHwl9JBet/jwPPIIgX5GSeV2ltGe2P+MfAAbRUJiglfiOLnuoKusdmJ6Q49QneZpJdgY6gfn6NMN+xqwx8k29z8e3zMwouEJpUJWomLFb+Z/dMUiru8cWpPf4BwR3HvzHyyu3Znc/ICsLM6CJvvGq2kM0hoYbiv1340nLxV2abC32H7YHZWRbs7FEQSDHiF7noLGvVI/xhsT/Mtsb4AYeVNshyLxLvVtuvurfmC0wHGqycJntRSovRefEBiJfX921Y7aTrFKEaprPFOWHfD3DsQig2z5GXbAYEythfZjHOUl4NHLUPGX3b6/5zyKYQ1Ozpm5WOg2A1TUeZ06pJejy+qQcvLYDsTSFHuaffwqvkxTu+9BQtn8129YtetTA3hBhK20dpvrgw1B47zv5aqf//gvS7ahdKio0qLqCA2vLALBGhBTfmv4HY2uYIPguEjROCSR7KiOKRHsI3tBBXZR0MoY0s0Wdv7u15hKHNVXZr1Pcr9SjOpqPLXdzpGLLHAUZKaFYFQ1z5/r3lO0Nf03gAcODfNfnHkTxqlw+JOe1b87OFRRIq2bg32Al2Z6LG+muqPFg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L1ZJSnZmOW5YaHhrdERqaWhDcytVRkU4TjRZMnJueGc5YTNNOGNlcCtWUmZw?=
 =?utf-8?B?M0Jia21vczMzNDBVb2dMNC8vM1I0UzZDVmdmamNNeW9rL3plRC9RYjkvQ3BZ?=
 =?utf-8?B?cUFuVXFIYUZaV0pYb3FRWW4xcExiTXg5bG1DdzBRbmZFTFUxQzdXRmhEVjJU?=
 =?utf-8?B?RmIyV0pTUTRkTnQ4WHNjUmdCdzRtYWd1UDhmckJMZUx5YkZtMnVBc250ZDdj?=
 =?utf-8?B?cmN2dlJOTzhmUkJLbndqY2RncVh3YVRlRjJxYnFZVHBxQk9LeFFzbUFBTUt5?=
 =?utf-8?B?R0p4RUxXR0VYZ2pldC9rVEd1WitmSnJPWVlFQ0RqUStFMTFzR0lTcHR0Q2gx?=
 =?utf-8?B?QjdnRlB6c0RvcTdqUWVYT2hzVUhFSnZtUEdFVzB5SGVkU0RLbFJFU1REK2lJ?=
 =?utf-8?B?elRSSFNwNEVmY1FGRE1OempiZ1dIV2tQRXRqMCs0d1p5aHFlcHdVaXV2a1kv?=
 =?utf-8?B?WVBkdVNFbVN4ZUtCTkRtYUhwb21YNHh1Ly9UUkZxL2FMNmdob0J0dzdXWUQ4?=
 =?utf-8?B?WDVpdjd2TjA5WHdMcTZ4dHZqbGJKOEl0S3UvUW9wRGVPOXltbXhKRUNFc1Fy?=
 =?utf-8?B?ZnJUWHlSa0tMOUVkSDFTanJTd29DcHo0OGxuaXdNZ0pNQVNUUFFnblhJeGhw?=
 =?utf-8?B?Z1ZqVXZqZEV6SnFsanN6NzFLMDN4eTFhT1ZiWlBOS0pINGdtRExqeTRENHk5?=
 =?utf-8?B?ZGpqSkFKYUdNSlRDay82bzhsTDY3M0R5WkdsRlRkK0ZueUtXVVFhVzMybzFy?=
 =?utf-8?B?U21pei8wVDZhc0V6UGx4djh3THZ5T2FjT2QzVkZpVWlqNTVhVTF4WXVWQ0w5?=
 =?utf-8?B?WGgrUmp5Vzl0NlhhSXJaZndsREtSdklHRjRIV3RqRi9OY0hhZjduRHRnZy9p?=
 =?utf-8?B?S25SamRzN3dWZS9GTDg2cXljaDIrUVlEUGpnU1EwaUpzUmE4UWtKQ2hDRU5k?=
 =?utf-8?B?alFqNmovYi9UalZKbXl1a2p2eXdYbWIvMUJJdmxlN0ZtMlhiUFoySC9jamlN?=
 =?utf-8?B?bS9neVFYQzA3NzZKcFBEODFsRnVIRDlZaW9nNlFETWRMWlFtazF3MVRKTVYw?=
 =?utf-8?B?TEIvY2JmTVhwZFk0bjZ0UVFHTWQ0S1VjMm85c0d0dE1aKzNYL1hoSTF4TmdH?=
 =?utf-8?B?MWJteHVRNEdPYStLb09ndElvb25XVG4wWEIyQ2UrODhqckQwMG5KZVdOYVYy?=
 =?utf-8?B?aGx0T2FWQkFCMStLcUpUL1BrWEhYeThoSlIyQlJzcWdwVlNPUmxjTW95WGx5?=
 =?utf-8?B?d1VHQXc5aW5WMFM3WHgrWWdaZWk4S1NIZ21GQTFPSzNZd2NJblBuV2JRNUFL?=
 =?utf-8?B?TnE2OU11Mkd0cFhPazZhUU16YWZFdEYxa0lkZ3k0eDNJbmk3Y1lBMDBNSzN1?=
 =?utf-8?B?amVGVHcwRm9vWjk5SjdBMWNNTGt0R2MzVVNpcXc2YVV3TUhYc0hYV2U3eW90?=
 =?utf-8?B?UysxU0dXYmlSN0JvaEx3V05ibmEwQnQwZDltR05HYTRNT2p0RFQ2VThHT3F6?=
 =?utf-8?B?bi90ZTAySFlFTHY0ZmJZak02VE1SUHdXSW8ySGVXUW9udTU1ZzZyMTI1SW1i?=
 =?utf-8?B?amNXVVErL0Ryenpkc2lzQWNFT3BjcEpNR1hvbUY0MitjU01pMllFaTZNVEhD?=
 =?utf-8?B?d2tINmYra1lpY2V6RDkzTFRFWk1Bb2FXblM5eklsRndxM0Q5ZHh0N3RVVnZL?=
 =?utf-8?B?dU5Fcys5b29OV0M0WXNhZEZsdmpNanloQ0VibVorTDc0bldpVlUrMVgxb0Nw?=
 =?utf-8?B?UnhVYktDSEIwc0FPb3VVT0w1Q3pKZUNYTUFyM05naWNjeTBIOUJLNnRjTXZm?=
 =?utf-8?B?Q1BuRjFXS3dpaE5RQ0hzdkVNLzg4VzJxQUJ1d2l0RHNZUDZ1TmhHVFRweGlI?=
 =?utf-8?B?YkpMWTQrSmVCUnNKSW4vdC9zWkxkMjBsWVIyZDBGYjREVUh3aWFEZEFQSzAr?=
 =?utf-8?B?bWpKUEFmZjNIWmttY2IvZ2haSVF1QllLVjRvZDFobm5NTU5VbTB1emNwSWR3?=
 =?utf-8?B?TW0zeW1DV3EzbzF5NHFBNlB6aklxakcyN29qSjh0aUx0M2R4Ui9BNWNoeGk3?=
 =?utf-8?B?Um8xWjJWS0ZLQ2JudFVlNEpUTHZUZlkvQXljdUE4ejFadXRHZWFXQ1h5SXQv?=
 =?utf-8?Q?T5yYeajSptoTaRUFC7ETmhDUe?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11a35fd8-e8e3-4181-b468-08dc3908857c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 09:26:34.5261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMAbESJiz09/qI4BaVa8Aiz1/XHOM8KAAkY6DwN28WIhXB+KpQjx5KSnUjzwpB9XI9Q/ju5dbZlP6SUNTqXlhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395

On 2/28/2024 5:20 PM, Borislav Petkov wrote:
> On Thu, Feb 15, 2024 at 05:01:15PM +0530, Nikunj A Dadhania wrote:
>> +enum aead_algo {
> 
> Looks unused.

This is being moved from drivers/virt/coco/sev-guest/sev-guest.h and is 
used in drivers/virt/coco/sev-guest/sev-guest.c::enc_payload()

 	hdr->algo = SNP_AEAD_AES_256_GCM;

> Add new struct definitions, etc, together with their first user - not
> preemptively.
> 
> Please audit all your patches.

Sure.

> 
>> +	SNP_AEAD_INVALID,
>> +	SNP_AEAD_AES_256_GCM,
>> +};
>> +
>> +struct snp_guest_msg_hdr {
>> +	u8 authtag[MAX_AUTHTAG_LEN];
>> +	u64 msg_seqno;
>> +	u8 rsvd1[8];
>> +	u8 algo;
>> +	u8 hdr_version;
>> +	u16 hdr_sz;
>> +	u8 msg_type;
>> +	u8 msg_version;
>> +	u16 msg_sz;
>> +	u32 rsvd2;
>> +	u8 msg_vmpck;
>> +	u8 rsvd3[35];
>> +} __packed;
>> +
>> +struct snp_guest_msg {
>> +	struct snp_guest_msg_hdr hdr;
>> +	u8 payload[4000];
> 
> What Tom said.

Responded on that thread.

> 
>> +} __packed;
>> +
>> +struct snp_guest_req {
>> +	void *req_buf;
>> +	size_t req_sz;
>> +
>> +	void *resp_buf;
>> +	size_t resp_sz;
>> +
>> +	void *data;
>> +	size_t data_npages;
>> +
>> +	u64 exit_code;
>> +	unsigned int vmpck_id;
>> +	u8 msg_version;
>> +	u8 msg_type;
>> +};
>> +
>>  #ifdef CONFIG_AMD_MEM_ENCRYPT
>>  extern void __sev_es_ist_enter(struct pt_regs *regs);
>>  extern void __sev_es_ist_exit(void);
>> @@ -223,7 +288,8 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
>>  void snp_set_wakeup_secondary_cpu(void);
>>  bool snp_init(struct boot_params *bp);
>>  void __init __noreturn snp_abort(void);
>> -int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
>> +int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
>> +			    struct snp_guest_request_ioctl *rio);
> 
> Much nicer!

Thank you.

> 
> ...
> 
>> @@ -868,7 +890,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
>>  	/* initial the input address for guest request */
> 
> That comment reads wrong - might fix it while here.

Will update.

>>  	snp_dev->input.req_gpa = __pa(snp_dev->request);
>>  	snp_dev->input.resp_gpa = __pa(snp_dev->response);
>> -	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
> 
>>  
>>  	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
>>  	if (ret)
> 
> Rest looks ok. I'd chose shorter local vars if I were you but yours are
> ok too.
> 

Regards
Nikunj


