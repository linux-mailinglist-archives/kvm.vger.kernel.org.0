Return-Path: <kvm+bounces-2836-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD13C7FE689
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 03:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A143EB20EB1
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 02:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B084B101EF;
	Thu, 30 Nov 2023 02:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="oRhG5NBa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA3010E0;
	Wed, 29 Nov 2023 18:14:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HWtPmiTboipsEdnWtrCYFWDJPddv7p+iRUws4+XZw/q2RRMNhmOHUe++Q8pvoraAb+Rf0f05HDEzgxrXpCWyUbvpOF+YMsnEvUcjUjk0qWurDJptGnYGPiHIGm4pvTfVoRVAjdiTonVVV5LBHIYYCg4epRKz+2LqJlwC2o/xp3VpHQLclWoZ5DbESKLpYQIIf1S75fSdSB/KW4GlFkTFt5ecHZeRfL673Ld410vt0+a7limhSAb/4aJO5qaZrfXlJ7RSoLvTLDqNpTAG24MsRJ/rt/Ljk4gri3vDsav3qZc7wpqYSVCvwzUEiYMU5jRMRsSyjFiGUNcjDm3lxQp7hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0DV/4L08UWjEPI07Tb7Sn0O3ZKCS0036HPRhWCNzbQ=;
 b=Y+kO46MOUzJJ4Op7e3fkMaXJdj3sH4vclpwL0xDJLr1HdEpSNs+dipBweWcbIOPpoiPupHUPKocS+k/2URdfZtTDdL13280/kkB4+ytBn7oo51Xldk8ASYMoCnJU+lm9zOxZaKHlOfW0WyxRdKDLNU1gfrl3XBOvWogalnOB2YhGczU76fDlRokKDCn6DIfg/OEAI11hW2t569OOcObPT9AmtV6zvPTALegWXz7R6SF+QZKA0BCmWRcK0pKnUcaiJ0QKjIop4DZIqTcmFW3DsKwUoMiZkYIUu8Z6aRmV+6g68ryMHaKmfdQBdk16a+PhfdVYFmQK3gXPcjHXgSkcjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0DV/4L08UWjEPI07Tb7Sn0O3ZKCS0036HPRhWCNzbQ=;
 b=oRhG5NBaOhMhLPMoPH/paETtrSjg7j4kslU28XyZ3uRO/TefP0pzIaRGNPdEnbyBZWJhwLtc6RlVzNRmr4ORQEg1S9MVQQGAO85imVmMipePWNsdpHLIC7uiAwrBP12oqXkPRdu/SSW5TG1+PH3Z1Y9TpqEjsBH1tQrBV+JHpjU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL1PR12MB5317.namprd12.prod.outlook.com (2603:10b6:208:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.22; Thu, 30 Nov
 2023 02:13:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7046.024; Thu, 30 Nov 2023
 02:13:56 +0000
Message-ID: <d5242390-8904-7ec5-d8a1-9e3fb8f6423c@amd.com>
Date: Wed, 29 Nov 2023 20:13:52 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v10 14/50] crypto: ccp: Add support to initialize the
 AMD-SP for SEV-SNP
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
 thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
 pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
 jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
 slp@redhat.com, pgonda@google.com, peterz@infradead.org,
 srinivas.pandruvada@linux.intel.com, rientjes@google.com,
 dovmurik@linux.ibm.com, tobin@ibm.com, vbabka@suse.cz, kirill@shutemov.name,
 ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
 sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
 jarkko@kernel.org, nikunj.dadhania@amd.com, pankaj.gupta@amd.com,
 liam.merwick@oracle.com, zhi.a.wang@intel.com,
 Brijesh Singh <brijesh.singh@amd.com>, Jarkko Sakkinen <jarkko@profian.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-15-michael.roth@amd.com>
 <20231127095937.GLZWRoiaqGlJMX54Xb@fat_crate.local>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <20231127095937.GLZWRoiaqGlJMX54Xb@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0199.namprd04.prod.outlook.com
 (2603:10b6:806:126::24) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BL1PR12MB5317:EE_
X-MS-Office365-Filtering-Correlation-Id: 937178d1-9eda-4057-9a08-08dbf14a01ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	k1D4+Rtm+XEXjVVBCzCrlKRPvadfWW17VHKHoQWOR6CvVPFYBQ6fqRewyEA90/VJsL/sSaci8d4iUllf6PoRbZuLeoPBEp8ow9ObmBqSVoCNb/nl1LW4aXwa2P9350Xh6p+aOId+ugvXumUNPnOufQcda3zf6YtUxrO8TAFs+VaDxGcuxhyA42c18xLp7LkWpTo5WpVJRdQwkm+lDuhqvMSqKUTm0Uzku0FxrAUMp+KsSt2OhjcMY+FQxbr0JJRktk8wfF1MfVDWYEjPolG+f+UAw1BROl19640iFKWxJQ6j/OUyCE6Z7lUTG22H4FTjSpWCtdkgnVXE3r0AfIa/8UytJ1CTZsqKpA+rJKxFf6pMe2gpJY6BHnaNn3p/DAz/vJvW4zl11ViEVH6UDJAACajEBq/XQngWKZ9Z7mvz2p9SI34KDgM9bkb6zMZuFm66lKP3W5dOhkMtI65GQ/t+raf2bgTccRuD8u395Y0M6zjpDlKPLAUn6E0t9ZY/3qmj7I4dNnbhFPyp3nypSyFjpgRHKoP0GmTo5mifSS/WSjT6NtluCxDlqrAmHWPtePCdQ+p5ZUVJnEqEG/NkyIAk31FBPDl7CAwTNzKbIGzKBEQ4X6Udi+uy55eUr1FBOr5aVXMwQoJoZfhm06zO3Nfa1Ohvtk7ogizuRjUJl0cynE8CVmjkmsxOj0/L+IPplEq4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(39860400002)(136003)(376002)(230922051799003)(186009)(1800799012)(64100799003)(451199024)(41300700001)(31696002)(2616005)(4326008)(86362001)(38100700002)(8676002)(6666004)(8936002)(5660300002)(7406005)(7416002)(2906002)(30864003)(26005)(110136005)(31686004)(202311291699003)(6506007)(478600001)(316002)(6636002)(66556008)(66946007)(66476007)(6486002)(54906003)(83380400001)(36756003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NjE4VVcrdnhPTXlta3d5ZTBvanYwMm9qdGVJd0FZRncyc2FNOFpoWUZzN3Ry?=
 =?utf-8?B?Qm5MTDMvSmt5bzhjeThjYmFCVkpTSjZoOTVLZjYzb1U2b0V3MElpVm9lK0dW?=
 =?utf-8?B?eGY3ajFOSkhOM3kxMGV6ZmlZM2VWVGFIK3VwUjUrL0FOc0tlL3R3VWg1UkNi?=
 =?utf-8?B?aHFuS0N4bzNNdmxxa0ZUSWtEWkg1NlQxRnJtK1RQY1dFdFZqQjRIdmpLWUhQ?=
 =?utf-8?B?bXRuT2tUejJrQ1NsMU81UG1NVEpuSVJFRW9SeFIwUlRQUiszUHhPSEVtRktM?=
 =?utf-8?B?eXBYL2p0M1g5bHFLbTd4OE5GcEFwbktwc3R6V2p2Q29KTk5xdDlsLzNmUEM1?=
 =?utf-8?B?SkxRNWxWbjIxTkdjUVRIczJSMFFvV1pQdzJLVllXREZpQzYzR1M0d2JVNzVj?=
 =?utf-8?B?Z244WjVlQ0szTy8wQlh6TXZmeHJrbklPcUpMQlBWc2s0elpHZEFpc055SVpI?=
 =?utf-8?B?aGxrRXUybk9CdzhOeFV5K0xrdWd0aEY0K0R4ZFFvYS83OTUwVjF0NVNxSnJo?=
 =?utf-8?B?VXpnMytwZmVaU05jMnFRZGtOanFwc0o2bE8wNHFaZGM4bnNUbzU2cEFMcm81?=
 =?utf-8?B?aTBTZVkveXlQNGlEK29JNTZHSVFkdk9IalJQQ2hCNXBUajMzN2htUmJOeHM3?=
 =?utf-8?B?TTluZDlxcXN3aHZSQXcvVEZMUkZrSXhnUFYzeXZ0QThGdHhpYUVFZEpCNjN2?=
 =?utf-8?B?cU84QjVOdlplR2U2VDZNM2Z4eW1PaGZZZGh6dWcyd0RSWUxES0RtTTFvU1dU?=
 =?utf-8?B?QXhQSk1NS0hmY1VBY0RSM2FGQ1REcURsR1MwNXNRNGZCM0NRd1VWeVRSWW1I?=
 =?utf-8?B?TXUxeUdZTGdUUzNzNndQRlc5MmNYaEhLQUZVbVl5bmVwcWkwZ0p4L2p5dnFy?=
 =?utf-8?B?Z3hJSzNXVGp0TE5rUWZCVWtOaVJHU2REaGRXQ1U4bXpHQ2xTeXJsRDF1UFM3?=
 =?utf-8?B?Um9hSFhBSUZJQ3MwOG53NW1WRnl1QmVkTkVGaXNldis5YVNCeExic2RMWVN0?=
 =?utf-8?B?Wm02OEY2OGo1OEd0Wm41SmNNenMwMXBvVUk5cERURE4xcUpLbU9YQWtZa1NJ?=
 =?utf-8?B?UFo2WXVDQ2RlMC91U2sxS1IrY3NXTkFnbkRPc1RpbUFXYllXbS9yNTdFdG84?=
 =?utf-8?B?dmN6Z1A5Ui9JZ2VlMUhjdU54QW04VzYxYXU1U2ZKYkVmc2ZIelJhT01EOXBa?=
 =?utf-8?B?NVczNXczVnVwQ0h2SjZVeWVmSlNjajdhdVk4TFJvajkvSWhrWFlLbXI5NEhi?=
 =?utf-8?B?SXJlbjJMbHZsSW9zeEc2R3BGSE55eEFvS253RnBtWHhsT0JRMFRkMEZZZ2Yz?=
 =?utf-8?B?SzZLMnZvblpza1dZTTRVWEw1WjRiWEZTd293eXNCZGJVRzNXMngrMzFpOE1n?=
 =?utf-8?B?a0NrYm12aUZqaXpMT2N0SGhUSTljeDBZSlZiNnIvYWtEL09ISllhZlFwK3gw?=
 =?utf-8?B?elZUMGpIN3ZsS2hSdE95aGdPcWNobWhIcVA1K1VoYTkxWFJBbkY5dW1ZTXlY?=
 =?utf-8?B?THhOc21jcXRBZ1JwV3ZpN1o1dlRMelAwVDg1endRemhMWGJvT24xL1gwREhp?=
 =?utf-8?B?TU43dVlaTWtaNUUzTnRGY0tyQSs4eVFCQmFWSEllaFVFQ2huNEsyeU9CYTh5?=
 =?utf-8?B?YTZzRHQ1OXduaElhdWR3V3loYzRMc1dYVHk3REpKcy8rcnRpOERQalNsS01O?=
 =?utf-8?B?M09CQkN5VXYwenBXQUNDQ3dhcFpkUXBwTll1TmhHeHk3ckVmNkZHWm92WjFB?=
 =?utf-8?B?ejNvNVpkcEVnbTBySnVodGZoQStVcnFRQjRSR1FwUkRWUlVhNlNJaVdtNU9j?=
 =?utf-8?B?c2pXeURndjFOWHR6SGFuZmkxSkxodUZPc0xKblVBQkNmbUpRTnFKalRmQ2VI?=
 =?utf-8?B?Nit0K3pWaTFlZWQ2K09oMzA1WUtPV2lrUDJvVnI5eTNMR1N4ejQza2NzUnlM?=
 =?utf-8?B?dW92VDVMcm50cnhxV1EwV0RkZ3BTS0tKejdhZ0QwTGJHTEZqVDl2ckg2MWxD?=
 =?utf-8?B?ZVoxbkRiOVZpa1FOdFJ6U1FleGtxSUdpWjJmd01tcnpEOHlKMHNvbkV0Z2l5?=
 =?utf-8?B?ZE5CYVRMNUtjOHlSSlZZZjREc1NrOWdzMWswc1VtSEphZ0ZpUXE4b2swaCs4?=
 =?utf-8?Q?fOU4fE/BaHeer2VItmc40oL/a?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 937178d1-9eda-4057-9a08-08dbf14a01ac
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2023 02:13:56.2497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xxIcrnii1nMIYNdF+d7e3ADuKJyilVm6zbwOYGw58GuNEZqi9v2Sqo77AXwF6q85lfuUIH9HgfkiIj5ypcxMng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5317

Hello Boris,

>> +static int ___sev_platform_init_locked(int *error, bool probe)
>>   {
>> -	int rc = 0, psp_ret = SEV_RET_NO_FW_CALL;
>> +	int rc, psp_ret = SEV_RET_NO_FW_CALL;
>>   	struct psp_device *psp = psp_master;
>>   	struct sev_device *sev;
>>   
>> @@ -480,6 +493,34 @@ static int __sev_platform_init_locked(int *error)
>>   	if (sev->state == SEV_STATE_INIT)
>>   		return 0;
>>   
>> +	/*
>> +	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
>> +	 * so perform SEV-SNP initialization at probe time.
>> +	 */
>> +	rc = __sev_snp_init_locked(error);
>> +	if (rc && rc != -ENODEV) {
>> +		/*
>> +		 * Don't abort the probe if SNP INIT failed,
>> +		 * continue to initialize the legacy SEV firmware.
>> +		 */
>> +		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n", rc, *error);
>> +	}
>> +
>> +	/* Delay SEV/SEV-ES support initialization */
>> +	if (probe && !psp_init_on_probe)
>> +		return 0;
>> +
>> +	if (!sev_es_tmr) {
>> +		/* Obtain the TMR memory area for SEV-ES use */
>> +		sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
>> +		if (sev_es_tmr)
>> +			/* Must flush the cache before giving it to the firmware */
>> +			clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
>> +		else
>> +			dev_warn(sev->dev,
>> +				 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
>> +		}
>> +
>>   	if (sev_init_ex_buffer) {
>>   		rc = sev_read_init_ex_file();
>>   		if (rc)
>> @@ -522,6 +563,11 @@ static int __sev_platform_init_locked(int *error)
>>   	return 0;
>>   }
>>   
>> +static int __sev_platform_init_locked(int *error)
>> +{
>> +	return ___sev_platform_init_locked(error, false);
>> +}
> 
> Uff, this is silly. And it makes the code hard to follow and that meat
> of the platform init functionality in the ___-prefixed function a mess.
> 
> And the problem is that that "probe" functionality is replicated from
> the one place where it is actually needed - sev_pci_init() which calls
> that new sev_platform_init_on_probe() function - to everything that
> calls __sev_platform_init_locked() for which you've added a wrapper.
> 
> What you should do, instead, is split the code around
> __sev_snp_init_locked() in a separate function which does only that and
> is called something like __sev_platform_init_snp_locked() or so which
> does that unconditional work. And then you define:
> 
> _sev_platform_init_locked(int *error, bool probe)
> 
> note the *one* '_' - i.e., first layer:
> 
> _sev_platform_init_locked(int *error, bool probe):
> {
> 	__sev_platform_init_snp_locked(error);
> 
> 	if (!probe)
> 		return 0;
> 
> 	if (psp_init_on_probe)
> 		__sev_platform_init_locked(error);
> 
> 	...
> }
> 
> and you do the probing in that function only so that it doesn't get lost
> in the bunch of things __sev_platform_init_locked() does.
> 
> And then you call _sev_platform_init_locked() everywhere and no need for
> a second sev_platform_init_on_probe().
>

It surely seems hard to follow up, so i am anyway going to clean it up by:

Adding the "probe" parameter to sev_platform_init() where the parameter 
being true indicates that we only want to do SNP initialization on 
probe, the same parameter will get passed on to
__sev_platform_init_locked().

So eventually there won't be a second sev_platform_init_on_probe() and 
also there is no need for a ___sev_platform_init_locked().

We will only have sev_platform_init() and _sev_platform_init_locked().

>> +
>> +static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>> +{
>> +	struct sev_data_range_list *range_list = arg;
>> +	struct sev_data_range *range = &range_list->ranges[range_list->num_elements];
>> +	size_t size;
>> +
>> +	if ((range_list->num_elements * sizeof(struct sev_data_range) +
>> +	     sizeof(struct sev_data_range_list)) > PAGE_SIZE)
>> +		return -E2BIG;
> 
> Why? A comment would be helpful like with the rest this patch adds.
>
Ok.

>> +	switch (rs->desc) {
>> +	case E820_TYPE_RESERVED:
>> +	case E820_TYPE_PMEM:
>> +	case E820_TYPE_ACPI:
>> +		range->base = rs->start & PAGE_MASK;
>> +		size = (rs->end + 1) - rs->start;
>> +		range->page_count = size >> PAGE_SHIFT;
>> +		range_list->num_elements++;
>> +		break;
>> +	default:
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int __sev_snp_init_locked(int *error)
>> +{
>> +	struct psp_device *psp = psp_master;
>> +	struct sev_data_snp_init_ex data;
>> +	struct sev_device *sev;
>> +	int rc = 0;
>> +
>> +	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
>> +		return -ENODEV;
>> +
>> +	if (!psp || !psp->sev_data)
>> +		return -ENODEV;
> 
> Only caller checks this already.
> 
Ok.

>> +	sev = psp->sev_data;
>> +
>> +	if (sev->snp_initialized)
> 
> Do we really need this silly boolean or is there a way to query the
> platform whether SNP has been initialized?
> 

Yes it makes sense to have it as any platform specific way to query 
whether the SNP has been initialized will be much more expensive then 
simply checking this boolean.

>> +		return 0;
>> +
>> +	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>> +		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>> +			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>> +		return 0;
>> +	}
>> +
>> +	/*
>> +	 * The SNP_INIT requires the MSR_VM_HSAVE_PA must be set to 0h
>> +	 * across all cores.
>> +	 */
>> +	on_each_cpu(snp_set_hsave_pa, NULL, 1);
>> +
>> +	/*
>> +	 * Starting in SNP firmware v1.52, the SNP_INIT_EX command takes a list of
>> +	 * system physical address ranges to convert into the HV-fixed page states
>> +	 * during the RMP initialization.  For instance, the memory that UEFI
>> +	 * reserves should be included in the range list. This allows system
>> +	 * components that occasionally write to memory (e.g. logging to UEFI
>> +	 * reserved regions) to not fail due to RMP initialization and SNP enablement.
>> +	 */
>> +	if (sev_version_greater_or_equal(SNP_MIN_API_MAJOR, 52)) {
> 
> Is there a generic way to probe SNP_INIT_EX presence in the firmware or
> are FW version numbers the only way?

It is not only the presence of SNP_INIT_EX but this check is more 
specific to passing the HV_Fixed pages list to SNP_INIT_EX and that is 
only supported with SNP FW versions 1.52 and beyond, so the FW version 
check is the only way.

> 
>> +		/*
>> +		 * Firmware checks that the pages containing the ranges enumerated
>> +		 * in the RANGES structure are either in the Default page state or in the
> 
> "default"
> 
>> +		 * firmware page state.
>> +		 */
>> +		snp_range_list = kzalloc(PAGE_SIZE, GFP_KERNEL);
>> +		if (!snp_range_list) {
>> +			dev_err(sev->dev,
>> +				"SEV: SNP_INIT_EX range list memory allocation failed\n");
>> +			return -ENOMEM;
>> +		}
>> +
>> +		/*
>> +		 * Retrieve all reserved memory regions setup by UEFI from the e820 memory map
>> +		 * to be setup as HV-fixed pages.
>> +		 */
>> +
> 
> 
> ^ Superfluous newline.
> 
>> +		rc = walk_iomem_res_desc(IORES_DESC_NONE, IORESOURCE_MEM, 0, ~0,
>> +					 snp_range_list, snp_filter_reserved_mem_regions);
>> +		if (rc) {
>> +			dev_err(sev->dev,
>> +				"SEV: SNP_INIT_EX walk_iomem_res_desc failed rc = %d\n", rc);
>> +			return rc;
>> +		}
>> +
>> +		memset(&data, 0, sizeof(data));
>> +		data.init_rmp = 1;
>> +		data.list_paddr_en = 1;
>> +		data.list_paddr = __psp_pa(snp_range_list);
>> +
>> +		/*
>> +		 * Before invoking SNP_INIT_EX with INIT_RMP=1, make sure that
>> +		 * all dirty cache lines containing the RMP are flushed.
>> +		 *
>> +		 * NOTE: that includes writes via RMPUPDATE instructions, which
>> +		 * are also cacheable writes.
>> +		 */
>> +		wbinvd_on_all_cpus();
>> +
>> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT_EX, &data, error);
>> +		if (rc)
>> +			return rc;
>> +	} else {
>> +		/*
>> +		 * SNP_INIT is equivalent to SNP_INIT_EX with INIT_RMP=1, so
>> +		 * just as with that case, make sure all dirty cache lines
>> +		 * containing the RMP are flushed.
>> +		 */
>> +		wbinvd_on_all_cpus();
>> +
>> +		rc = __sev_do_cmd_locked(SEV_CMD_SNP_INIT, NULL, error);
>> +		if (rc)
>> +			return rc;
>> +	}
> 
> So instead of duplicating the code here at the end of the if-else
> branching, you can do:
> 
> 	void *arg = &data;
> 
> 	if () {
> 		...
> 		cmd = SEV_CMD_SNP_INIT_EX;
> 	} else {
> 		cmd = SEV_CMD_SNP_INIT;
> 		arg = NULL;
> 	}
> 
> 	wbinvd_on_all_cpus();
> 	rc = __sev_do_cmd_locked(cmd, arg, error);
> 	if (rc)
> 		return rc;

Yes, makes sense, will fix it.

> 
>> +	/* Prepare for first SNP guest launch after INIT */
>> +	wbinvd_on_all_cpus();
> 
> Why is that WBINVD needed?

As the comment above mentions, WBINVD + DF_FLUSH is needed before the 
first guest launch.

> 
>> +	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
>> +	if (rc)
>> +		return rc;
>> +
>> +	sev->snp_initialized = true;
>> +	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
>> +
>> +	return rc;
>> +}
>> +
>> +static int __sev_snp_shutdown_locked(int *error)
>> +{
>> +	struct sev_device *sev = psp_master->sev_data;
>> +	struct sev_data_snp_shutdown_ex data;
>> +	int ret;
>> +
>> +	if (!sev->snp_initialized)
>> +		return 0;
>> +
>> +	memset(&data, 0, sizeof(data));
>> +	data.length = sizeof(data);
>> +	data.iommu_snp_shutdown = 1;
>> +
>> +	wbinvd_on_all_cpus();
>> +
>> +retry:
>> +	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
>> +	/* SHUTDOWN may require DF_FLUSH */
>> +	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
>> +		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
>> +		if (ret) {
>> +			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
>> +			return ret;
> 
> When you return here,  sev->snp_initialized is still true but, in
> reality, it probably is in some half-broken state after issuing those
> commands you it is not really initialized anymore.

Yes, this needs to be fixed.

> 
>> +		}
>> +		goto retry;
> 
> This needs an upper limit from which to break out and not potentially
> endless-loop.
>

Ok.

>> +	}
>> +	if (ret) {
>> +		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
>> +		return ret;
>> +	}
>> +
>> +	sev->snp_initialized = false;
>> +	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
>> +
>> +	return ret;
>> +}
>> +
>> +static int sev_snp_shutdown(int *error)
>> +{
>> +	int rc;
>> +
>> +	mutex_lock(&sev_cmd_mutex);
>> +	rc = __sev_snp_shutdown_locked(error);
> 
> Why is this "locked" version even there if it is called only here?
> 
> IOW, put all the logic in here - no need for
> __sev_snp_shutdown_locked().

In the latest code base, _sev_snp_shutdown_locked() is called from
__sev_firmware_shutdown().

Thanks,
Ashish

> 
>> +	mutex_unlock(&sev_cmd_mutex);
>> +
>> +	return rc;
>> +}
> 
> ...
> 

