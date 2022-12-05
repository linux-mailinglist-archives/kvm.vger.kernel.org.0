Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C41642AF3
	for <lists+kvm@lfdr.de>; Mon,  5 Dec 2022 16:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232206AbiLEPDN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 10:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiLEPDM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 10:03:12 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249BE1D662;
        Mon,  5 Dec 2022 07:03:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Spi8h9DjWCCGoAOsUWvd1TfnZUvPzHV5E1d8MaLmpbinl7JKoQMYfej/rGzRBQd1cmJKsj5szJ6M3Dupg0MLuHchjtWl0CULcLE6ofUUUq2cLyHVFYUEwDPmACwcwPbIzxD2BQWjd7N0FicLl6YptiJt4rGLb2UTY7Bb9TMiN8YBn9KPKAGJ25BFiZBf73kRwrICf7rtAe65bYJoPwKm4M3QkxMrOJGe3q4HSJIA0wdefBM06fVMWfRP3FFAZb0yWyWJHU7y1L43O9f1rJkk/9oWSI/OCGWzTH7NBvJL5qfz7xqtDHjTIeHTnknhfkzzDe/bzBUOwGbs+wxYo1JgQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJrsADaVYUy9fFnr80jh8OseEHekLo8jTdZGxhVuLlw=;
 b=e8zcVkDhhnD5CAOUb17cc63JX6XVeQ6Od9dJiWWwurruymUv96Q4FSoQ8ierXGC3RT3qiMTEx1hbMqX/oW9PfBd7qPSY8hyGs/PF1582KzAlphGQGR/1ELEOUvoJoKUp1i2T1ix0EuXrvUeDiwGXDHLqmisg9RkhLR5PCt3g2EHMxirYGK4jPEJVkAJstK/frUmvWx8dImXoS0ZoMq+oyXt1sbRAMV32ZNojxrQ4i9QU7B0+B7rzIEl7/EqRY2FFhc9D+51ICffKNJPDwIAGF6HC5+3raXNmiJSI4aCJN6TJdtEPViYhD9Dznth+nRV+Qnoza6PaNyx3zaZfAVqn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJrsADaVYUy9fFnr80jh8OseEHekLo8jTdZGxhVuLlw=;
 b=RAZMRfeAcKlF8sigJStz3UbqJYpWwk+mQLxf64JEZdg/z2sSvjfKMfczuVFTiPAIRsK6Ryr1N52gazh4hyofpdL9pZBvCXjS98mqkf1E/K9Vya5TTq8pxonfOlqPitny5MxXoT9MDSClMnDU1SZzSXusWI58PxnLvqtIP36z13w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 CH2PR12MB4326.namprd12.prod.outlook.com (2603:10b6:610:af::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Mon, 5 Dec 2022 15:03:07 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::6481:82ef:ffb1:4d0a%9]) with mapi id 15.20.5880.013; Mon, 5 Dec 2022
 15:03:07 +0000
Message-ID: <2b8f7201-24fe-0eba-2629-e35900f4d5d7@amd.com>
Date:   Mon, 5 Dec 2022 20:32:52 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Borislav Petkov <bp@alien8.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, stable@kernel.org
References: <20221201100423.7117-1-nikunj@amd.com> <Y44Amf9MJIIi4Ric@zn.tnic>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <Y44Amf9MJIIi4Ric@zn.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0113.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:27::28) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|CH2PR12MB4326:EE_
X-MS-Office365-Filtering-Correlation-Id: fd1da80c-8dca-4468-f65e-08dad6d1d103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9vx4IJmOp96MEb1PXj0M8L8XF3guZFRqTETcljjJL62uEvM1+Ya1URfv0H7HVGUruBUHhiddz20Tn4nn4wVpVXQ9ybgHE06RcLMtMT7zQ3xpnxOxiy5P3GlkDpfDxrbpWT+Yhk/AvPWomXtqDVkXpjfa9G4Aygf/tMQPso8NFnpE2tZff76LepwA9DKXr1FJ2HaF06GIGr/Qq80XpmdN0+TEjK9+vvPWoxoL3y5+5Xpz+87qb81IvgRTrBYfX7fhBhvFOzNRYMa0MZIdja5pu7rHWCr3S/5c9uFfr2dACWHT45HRlSo6UyWCAO2tF2eW153Q04eFZjxMdhK5JO09hAJVaVyRE19H6iivfCWvdlUT3XbW7LOeV3QYSvcwAB7mI6nOkvavf8+bLLBIf+hthBXbxdNSXvzD4XpBPKorVaqIE8OtlHRSW/xGv0SMaTZx0yh2cGa54B0LhSOyiCYE1yVQJGnsbvAp3Diy0pP41vsMcAASbB67NCKMfyrk15t2KVAYt9rltFPzxuoZL572dBScrSQu060NIlSBpL19bsEbmoovC/GJ0kw+60C25vTLmxJ5FAMfAmspiAUHjTiq6MkGDU281VaP+VWfkR2r9YlNYR/WlrNZlJ/bW8U2mmNEnSkSN736+3VzCvpfTb3LRlRn8tUGZ6ZN7Cr9fh8BD1SSXxkYqHbW0aqPkvINqY18eoOIc8EOtGRVY+Kj+tabQRvxX0eB6+h7uCO49YKfZ5o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(366004)(39860400002)(346002)(451199015)(41300700001)(186003)(38100700002)(2616005)(2906002)(83380400001)(5660300002)(36756003)(478600001)(8936002)(7416002)(6666004)(6486002)(53546011)(6506007)(31686004)(6512007)(31696002)(66946007)(66556008)(66476007)(8676002)(4326008)(26005)(6916009)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THROWStXcmhVVTN6SzVhOFJpNEQ0dkg4dmZTb0JOSlJabkJOTmhwUlFTQUd1?=
 =?utf-8?B?WXZqSThsNXFwa0ZvNUwyL0pPRVY2SWlhT3V5MmYrc1FVM0RRa3dsZmY3MzUr?=
 =?utf-8?B?ckZTQWJhQzZNZ3Y3NTBrRE5KTk9wTDVnTldNUHdsMnhrK2pKY1hwODdQMFdv?=
 =?utf-8?B?T214cG1tbW5ReExreHNESUZSanV5dkFvZjcxTVNsZkJ3aTlaSFpxQ0EzZm9V?=
 =?utf-8?B?MlBqbzZabFM0WElkclBlZjZtemNxSVhsTm9Oc2tacmY2OUJoZkZDS1FVVUdh?=
 =?utf-8?B?YTVtTm9UOE1PazlVZmVBRDFIaytTMWIwalV5TlVzd1FxZ2RKVGZvL1dseU5w?=
 =?utf-8?B?SE9USmZNNFZtU25lY3hmZzZiZTBxVlY0aEVrSGxCb0tFQ0MrK3JMaFFReVNl?=
 =?utf-8?B?eStFYURoOEZkMCtSRkkySUNYZGxIMGRXVlJla3ZiVjNKLzdyUENjSW5TT08y?=
 =?utf-8?B?cEVPOEZBQ05IZ0xNelJpSWFnRkNhWXdva3FRSGhCd3ppRklHZ0hKajV2bjM3?=
 =?utf-8?B?MzVhTDAyQ3hoNk5wRkZZRUNuZmRhbVlNc1ZYOW02bVVsWDdES2EyNWFXRmdh?=
 =?utf-8?B?dXRmeS81QW16RUFNeHo3R3F1SmZwZXJJZjgxQ3FCelVrV3l1OWNqejFMN2kz?=
 =?utf-8?B?ZGxBd0NVWDlBano1MnYvdjNTVzgxV25YWVZTMzNDeGt2eEUyaENIT2pxc3Yw?=
 =?utf-8?B?OHo3dnNpbExUQ00vbC91NUx5dEhFWkhsZXJLV21uSVp0RlZKM0VBS0ttL21h?=
 =?utf-8?B?WmNSTHFOSnFCcG5TSzJiRFlwMEVDeXprbWlQVkVCTnRxZTcxWXArcU5EdDhH?=
 =?utf-8?B?TnJ3dUF4Q3kyYXJLVy9UamxtZlF5Szk3b0U2RUxsUmd6aXE4RHhBdGszdnMy?=
 =?utf-8?B?bk10eDd3VkFDelVqUTRSdmoxemRDaHF6WnFuOVpCajhaN2FLemUrb2IxNjZH?=
 =?utf-8?B?aGliQ2xPWE04eUhMb1VSVXlTRFg0Y2RLN2VGcGt4UWlLS3NYQWQ3SGpsVDVZ?=
 =?utf-8?B?SGhFbE83bk90LzhubExJMGJGa2xVbzA4cytsSWVmRUJUYjc0RFF0RkMzdHNm?=
 =?utf-8?B?aEVJTDNsTlBvRVB4RDMxVXRjeDV0TVg0U1VRTWVYclI2NW1jT1REdkZySjhD?=
 =?utf-8?B?V2dGUHpvUUNnZGFsODdlenZGaDBubDRFbG1xOHFUMmNMcDA3eHpCM1BhNklJ?=
 =?utf-8?B?NE45bWtIdFdJdkJrZzhGTGFwSkYxeGJDb25GUWFiQjdTQ1d0Y3ZvSkFXY3Zz?=
 =?utf-8?B?WDloNEM5MGF1b2FwMmErOWxDdkVETndxRVV1NGFnckgxTDdyZG03dC9KQUJX?=
 =?utf-8?B?TUM4YVFKcERIMjNPdzBYSG91a0dvZ0J0NUx5eDVremF4K08xQnN4dktLbkNV?=
 =?utf-8?B?Sm5BZkZ4T1pXMm5ZWitHcHpXcFNOem5ENGZXRlhoUllSUGJMZ1gzTEtiZ3lX?=
 =?utf-8?B?WWhYLzB5YkxidXdlY0diN1REdnorSFl2aEtMS0phSUsxVS8zK2ZFN1loRDZW?=
 =?utf-8?B?NDdZMUVoTS9MYWREUHdxNFZBdG9Fc3kwNXBjdGtSMWdRK0I0VGNzYldvQnRX?=
 =?utf-8?B?MWg2aWJNakd3cmRwY00wWEU2anFUTEJEbEFqZnFZSWNQSE05UTZEd0gwamV1?=
 =?utf-8?B?dTdCVVhFK1B1V1YxTkRzYU1melJxbXBwb0I2T21JM3c2a003cUhtNE82bDN5?=
 =?utf-8?B?TjV0NU4wd2JkYWJPMlhEZWpRdkFXdGhhRFJVUlJmazJYbG1mc3NhVFRpUmY5?=
 =?utf-8?B?bzFpNmI0UldHbnFiS1RmSmZBSUY2d1NFRWl4WXhSLzNzUDVrSjc2TUVYOExq?=
 =?utf-8?B?RnVDVGRySmhtYXRqQkQ4b0FyampTN1pNL0F5a1FjK1VFbVA3L0NIN2g4bjk1?=
 =?utf-8?B?RHFPZHIzbjUybzl1ZFJnTkJxcUZkU1F4WFVxU3dUVW9iVUNlYmZCR1BDcFRX?=
 =?utf-8?B?eWhRODBsemE5UGtZd3VKMXpENnRuTXBZNkxRQ1loWEFCNmhHamc4eFo4YjNP?=
 =?utf-8?B?dWFhOW9qa3hjNk0zTXNsT1M5VC9CRS9LN096T2FlR0IxWEFOWmFobnE3TlU5?=
 =?utf-8?B?OGZpTExQcmZvUlEvem15UWttclNaYVh3TERaVkxGVHVPVWtRb3VWcXZaSHFx?=
 =?utf-8?Q?2nXzCEUkpacf3M9Vf0diLETJt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd1da80c-8dca-4468-f65e-08dad6d1d103
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 15:03:07.0814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u47U9wfcSjIrUJFatcKzyRozLNyKdbM1yfQpfP0D3K3mDxg1b+OMOVyXWgSsWGGJw5lFIJQ8v79EDqcsg1uPuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4326
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 05/12/22 20:00, Borislav Petkov wrote:
> On Thu, Dec 01, 2022 at 03:34:23PM +0530, Nikunj A Dadhania wrote:
>> The hypervisor can enable various new features (SEV_FEATURES[1:63])
>> and start the SNP guest. Some of these features need guest side
>> implementation. If any of these features are enabled without guest
>> side implementation, the behavior of the SNP guest will be undefined.
>> The SNP guest boot may fail in a non-obvious way making it difficult
>> to debug.
>>
>> Instead of allowing the guest to continue and have it fail randomly
>> later, detect this early and fail gracefully.
>>
>> SEV_STATUS MSR indicates features which hypervisor has enabled. While
>> booting, SNP guests should ascertain that all the enabled features
>> have guest side implementation. In case any feature is not implemented
>> in the guest, the guest terminates booting with SNP feature
>> unsupported exit code.
>>
>> The below table lists the expected guest behavior with various
>> possible scenarios of guest/hypervisor SNP feature support.
>>
>> +---------------+---------------+---------------+---------------+
>> |Feature Enabled|  Guest needs  |   Guest has   |  Guest boot   |
>> |     by HV     |implementation |implementation |   behavior    |
>> +---------------+---------------+---------------+---------------+
>> |      No       |      No       |      No       |     Boot      |
>> |               |               |               |               |
>> +---------------+---------------+---------------+---------------+
>> |      No       |      Yes      |      No       |     Boot      |
>> |               |               |               |               |
>> +---------------+---------------+---------------+---------------+
>> |      No       |      Yes      |      Yes      |     Boot      |
>> |               |               |               |               |
>> +---------------+---------------+---------------+---------------+
>> |      Yes      |      No       |      No       |   Boot with   |
>> |               |               |               |feature enabled|
>> +---------------+---------------+---------------+---------------+
>> |      Yes      |      Yes      |      No       | Graceful Boot |
>> |               |               |               |    Failure    |
>> +---------------+---------------+---------------+---------------+
>> |      Yes      |      Yes      |      Yes      |   Boot with   |
>> |               |               |               |feature enabled|
>> +---------------+---------------+---------------+---------------+
> 
> I like this table and I wouldn't want for it to go under in some commit
> message which is not that easy to retrieve so I'm thinking you should
> add it along with some blurb to
> 
>   Documentation/x86/amd-memory-encryption.rst
> 
> instead where it belongs.

Sure will do.

> 
>> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
>> index c93930d5ccbd..571eb2576475 100644
>> --- a/arch/x86/boot/compressed/sev.c
>> +++ b/arch/x86/boot/compressed/sev.c
>> @@ -270,6 +270,50 @@ static void enforce_vmpl0(void)
>>  		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>>  }
>>  
>> +/*
>> + * SNP_FEATURES_NEED_GUEST_IMPLEMENTATION is the mask of SNP features that
>> + * will need guest side implementation for proper functioning of the guest.
>> + * If any of these features are enabled without guest side implementation,
> 
> "... are enabled in the hypervisor ... "
> 

Sure

>> + * the behavior of the guest will be undefined. The guest may fail in
>> + * non-obvious way making it difficult to debug.
>> + *
>> + * SNP reserved feature bits may or may not need guest side implementation.
> 
> Yah, get rid of that PPR formulation. If you see the verb "may" always
> run away. :-)
>

True, had to add "may" as the I don't know what the bit will be used for.
 
>> + * As the behavior of reserved feature bits are unknown, to be on the safer
>> + * side add them to the NEED_GUEST_IMPLEMENTATION mask.
> 
> Yah, that makes sense - you want to protect those for future use. Ack.
> 
>> + */
>> +#define SNP_FEATURES_NEED_GUEST_IMPLEMENTATION (MSR_AMD64_SNP_VTOM |			\
> 
> SNP_FEATURES_REQUIRED
> 
> Simpler and shorter.

Yes, much better.

> 
>> +						MSR_AMD64_SNP_REFLECT_VC |		\
>> +						MSR_AMD64_SNP_RESTRICTED_INJ |		\
>> +						MSR_AMD64_SNP_ALT_INJ |			\
>> +						MSR_AMD64_SNP_DEBUG_SWAP |		\
>> +						MSR_AMD64_SNP_VMPL_SSS |		\
>> +						MSR_AMD64_SNP_SECURE_TSC |		\
>> +						MSR_AMD64_SNP_VMGEXIT_PARAM |		\
>> +						MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
>> +						MSR_AMD64_SNP_RESERVED_BIT13 |		\
>> +						MSR_AMD64_SNP_RESERVED_BIT15 |		\
>> +						MSR_AMD64_SNP_RESERVED_MASK)
>> +
>> +/*
>> + * SNP_FEATURES_HAS_GUEST_IMPLEMENTATION is the mask of SNP features that are
>> + * implemented by the guest kernel. As and when a new feature is implemented
>> + * in the guest kernel, a corresponding bit should be added to the mask.
> 
> And there's no way we won't notice that we've forgotten to do so because
> it'll terminate with the proper error code.
> 
>> + */
>> +#define SNP_FEATURES_HAS_GUEST_IMPLEMENTATION (0)
> 
> SNP_FEATURES_PRESENT
> 
> And so I've done a couple of changes ontop, here's a diff as it explains
> a lot better what I mean.
> 
> Have a look and let me know if something's wrong.

Looks good. Do you want me to send v3 with these changes ?

Regards
Nikunj

> 
> Thx.
> 
> ---
> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
> index 10272835dfe9..f023d37e2c41 100644
> --- a/arch/x86/boot/compressed/sev.c
> +++ b/arch/x86/boot/compressed/sev.c
> @@ -271,48 +271,35 @@ static void enforce_vmpl0(void)
>  }
>  
>  /*
> - * SNP_FEATURES_NEED_GUEST_IMPLEMENTATION is the mask of SNP features that
> - * will need guest side implementation for proper functioning of the guest.
> - * If any of these features are enabled without guest side implementation,
> - * the behavior of the guest will be undefined. The guest may fail in
> - * non-obvious way making it difficult to debug.
> - *
> - * SNP reserved feature bits may or may not need guest side implementation.
> - * As the behavior of reserved feature bits are unknown, to be on the safer
> - * side add them to the NEED_GUEST_IMPLEMENTATION mask.
> - */
> -#define SNP_FEATURES_NEED_GUEST_IMPLEMENTATION (MSR_AMD64_SNP_VTOM |			\
> -						MSR_AMD64_SNP_REFLECT_VC |		\
> -						MSR_AMD64_SNP_RESTRICTED_INJ |		\
> -						MSR_AMD64_SNP_ALT_INJ |			\
> -						MSR_AMD64_SNP_DEBUG_SWAP |		\
> -						MSR_AMD64_SNP_VMPL_SSS |		\
> -						MSR_AMD64_SNP_SECURE_TSC |		\
> -						MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> -						MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> -						MSR_AMD64_SNP_RESERVED_BIT13 |		\
> -						MSR_AMD64_SNP_RESERVED_BIT15 |		\
> -						MSR_AMD64_SNP_RESERVED_MASK)
>  
> -/*
> - * SNP_FEATURES_HAS_GUEST_IMPLEMENTATION is the mask of SNP features that are
> - * implemented by the guest kernel. As and when a new feature is implemented
> - * in the guest kernel, a corresponding bit should be added to the mask.
> + * SNP_FEATURES_REQUIRED is the mask of SNP features that will need
> + * guest side implementation for proper functioning of the guest. If any
> + * of these features are enabled in the hypervisor but are lacking guest
> + * side implementation, the behavior of the guest will be undefined. The
> + * guest could fail in non-obvious way making it difficult to debug.
> + *
> + * As the behavior of reserved feature bits is unknown to be on the
> + * safe side add them to the required features mask.
>   */
> -#define SNP_FEATURES_HAS_GUEST_IMPLEMENTATION (0)
> +#define SNP_FEATURES_REQUIRED		(MSR_AMD64_SNP_VTOM |			\
> +					MSR_AMD64_SNP_REFLECT_VC |		\
> +					MSR_AMD64_SNP_RESTRICTED_INJ |		\
> +					MSR_AMD64_SNP_ALT_INJ |			\
> +					MSR_AMD64_SNP_DEBUG_SWAP |		\
> +					MSR_AMD64_SNP_VMPL_SSS |		\
> +					MSR_AMD64_SNP_SECURE_TSC |		\
> +					MSR_AMD64_SNP_VMGEXIT_PARAM |		\
> +					MSR_AMD64_SNP_VMSA_REG_PROTECTION |	\
> +					MSR_AMD64_SNP_RESERVED_BIT13 |		\
> +					MSR_AMD64_SNP_RESERVED_BIT15 |		\
> +					MSR_AMD64_SNP_RESERVED_MASK)
>  
>  /*
> - * The hypervisor can enable various features flags (in SEV_FEATURES[1:63]) and
> - * start the SNP guest. Certain SNP features need guest side implementation.
> - * Check if the SNP guest has implementation for those features.
> + * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
> + * by the guest kernel. As and when a new feature is implemented in the
> + * guest kernel, a corresponding bit should be added to the mask.
>   */
> -static bool snp_guest_has_features_implemented(void)
> -{
> -	u64 guest_features_not_implemented = SNP_FEATURES_NEED_GUEST_IMPLEMENTATION &
> -		~SNP_FEATURES_HAS_GUEST_IMPLEMENTATION;
> -
> -	return !(sev_status & guest_features_not_implemented);
> -}
> +#define SNP_FEATURES_PRESENT (0)
>  
>  void sev_enable(struct boot_params *bp)
>  {
> @@ -383,7 +370,7 @@ void sev_enable(struct boot_params *bp)
>  		 * Terminate the boot if hypervisor has enabled any feature
>  		 * missing guest side implementation.
>  		 */
> -		if (!snp_guest_has_features_implemented())
> +		if (sev_status & SNP_FEATURES_REQUIRED & ~SNP_FEATURES_PRESENT)
>  			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
>  
>  		enforce_vmpl0();
> 
