Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F73666063
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 17:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbjAKQ0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 11:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbjAKQZo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 11:25:44 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2061.outbound.protection.outlook.com [40.107.96.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD7038ADD;
        Wed, 11 Jan 2023 08:22:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d27E+0/+2XckM3w1e8SwzxuZ6U5NIf6VqJgdnubg74f3WjcrCsXOftuZ94t0W5iJMYM03L5qvE9rVMcz5VQQpLA4RffAwyuUzg3dfvTxdVBBqGbSBRPV+MVdNtBlUe852ur5rH9xQB0BgugJTX4AdBfcc0z2WTyVf7GZ0iO/whQ3pDbNRnOrcVYESLcfFXljJuSllbS+xQ5J0OewcwCC+jfyohoC9p4vVR7Fqoj23Q/XFQvlbD5jDkCyMX6bXgfHC3HATIQgODqcBvL1WfVri5fJh9hAdZesNy8nT2jYvVn/htqn3Q4/c19BjlV/7m5H89eu+JKLjpoA0cJ6WyKmUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tOrzCL+nC1yGZY87yjgLfG6Hcd4rG0sSouPnMfeXZnM=;
 b=VD1wbfwQPq03DaT3XmSS8VD1iB079uGGAUM2GF27Q54AhfofXMPYQouCR/OKb9X9Pw17PVM6SiSuB5OFnU2dNRIetBSW4DgzerZJ/SLWKtktXnCGtMBvO+Hz2XGJnUijQPh/+qH9bvSHBnd9fOhweAZc7l5xi0rKxlrCWNI3pgIUnnlOCy3q6tXx3J+MDd34ZXLa8zxt2HbZJoImhy7e5YfOmygiHkMsj4IERReROUg/3k/c5tWI0aIdJVnRSUBAnL6jNmAI5ivN0qxJBBpAn2MLI9/ytukztPXo+r0cH7TXONq4k3d30TpOncEiWbNRvj5M3pDDz2r4N9GHfUL+fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tOrzCL+nC1yGZY87yjgLfG6Hcd4rG0sSouPnMfeXZnM=;
 b=w9AQh9UVXHe4KQiYCgIvYLeeFPp0ELhjl0zLqtFj0SkdSH2avYGtD7DOUxMJZfa3zKy59jL/7fpd+fjC2+Y/QeUOSM2ZQeYZZmZmjIj1ZMX06CL5CaoB447XD2nmhlS1enXFcvZyaJE8CSidXlI04DnL/LrMblU3VWmsPoaQOGI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 PH7PR12MB8179.namprd12.prod.outlook.com (2603:10b6:510:2b8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Wed, 11 Jan
 2023 16:22:04 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::8079:86db:f2e5:7700%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:22:04 +0000
Message-ID: <4401f09b-e883-d3ae-99e2-6920c0c6ec2a@amd.com>
Date:   Wed, 11 Jan 2023 21:51:49 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4] x86/sev: Add SEV-SNP guest feature negotiation support
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        bp@alien8.de
Cc:     mingo@redhat.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
        seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
        David Rientjes <rientjes@google.com>, stable@kernel.org
References: <20230111064522.957859-1-nikunj@amd.com>
 <df8d8451-60d5-e126-6528-8318b689fcc0@amd.com>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <df8d8451-60d5-e126-6528-8318b689fcc0@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0PR01CA0063.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::17) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|PH7PR12MB8179:EE_
X-MS-Office365-Filtering-Correlation-Id: 379b1f0e-dc78-4791-4169-08daf3eff98c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3Bga2bhPV3zonbBypaKHZeUTbY6/ELslUchY3XB9rmBJSz7QvHqpQmo7VuWJdtNOa7tH3AGbbGw8SOTlylhkBStvv/wyQoVDSwXUnWUUVqrHvLb6cesF/Vj6ZXcUqlgKQ0+sHCIJ0GrB54KaX7m6kQoYlduh3w02CiqJd8QeqHLkmAzOARFc02OMHzB8LBoIbzK6zCwKP9TsViwqAyIYlZgWqWeVFYnwWueEupD7LVtCq2/3U/UhGl9aCx+3iGmdiq2JMnm8/NnCTP/Cdrc/Y5RlDnr1ujGEpkBOgFiUTucs+jjPoFMbUq5yrPcmMNGojy92HUqmXROlb6cPHS0VE/KRD9AsVznnTOluWy5OxnHQkkMh57JxaN3jO6PIINsgyUh2hrN6DXthfZYUismMzi75fJmtiDqP+X2bcTMTjAUDvjjSCddT3kRwl9zdKF0YS+vb1sRbs5NkhGtrERMnF6AGBNQ1cRSfMlQeepFCFKvVNoXRvNTgdpOTWZIchN/BD0G60yxlL/qoDuZWRYiJLS9ugDdKDKRqctC74m9m9cmJzlogAlneBzyIb9XvZOumYfxhN89xdP+7Dsr9hEFJVdzbtIKWa1XL9zYV6X9NwATuUXnOI53uzX02skdp4k4qcuK+ClTyqTUiXieb550R2EMnScahnZYyRfEILZXh2Jv8FVCXTjpY2QcxG9f7smVfKBDyB405Bk/LJSv+fM/2E8zdwa3K4+MobfqtdQ/iDqTj5s0LTwCNUITPv7kPPXUYD43G1nPSXYdVKBiZNGlQ9vK5sNEvbyrxGCLqoimXLY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199015)(6486002)(478600001)(41300700001)(966005)(38100700002)(6512007)(316002)(31696002)(2616005)(26005)(66476007)(66946007)(66556008)(186003)(4326008)(8676002)(36756003)(55236004)(5660300002)(53546011)(6666004)(6506007)(7416002)(2906002)(31686004)(30864003)(8936002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEdzR3VzbXNGYUtGZW9FRUVwN0pnbG5ham5wdEdWTnR3c0V3eExhK3k4YWpl?=
 =?utf-8?B?NjdMWUd2ejBDQXlYYTdhM1lXL0lqMFVJYzdqNWVJU0k5aVF1ZHNqVWVCVGxO?=
 =?utf-8?B?b0ZaS0tLQ1J3UXBLWFdkNytPWGxTaklLbTNXVHl5V1I5Q24vVUE2cHBWUDkv?=
 =?utf-8?B?YjhwVXdHT3gxVmplZ0hlL2RxemhFZXZpeGVhSldCbkxVVytESHRTNElVL3VP?=
 =?utf-8?B?bGtQL0hnRlhQeUZQMVFKdzVpa1FkbjY5VmRzZkQ4QkREdVBnQ0NxQ2FuY2lh?=
 =?utf-8?B?Nk1oYzBLbmVHMUR2OStOS1hkTXFVc0V0YTRVWjErSkNXbThKaDZ3UG8vY2ZJ?=
 =?utf-8?B?UTYvK2lzYlliWDVHZ01oMHZSVEZhVndSZm5KMEhBZ0pLOGliSE5qMUQ1OUtl?=
 =?utf-8?B?WEtWLytHalhNb2UxTEQyNVVNSHdicVhTREYzNXgrdWE2cEpLaC8xdFR1SW1r?=
 =?utf-8?B?dzZMWnhqdVpyOE5TK05EU2hBcEVFR1RWMjNWbXFaZ0JzUmlYMS9QdGlPMDJJ?=
 =?utf-8?B?RGxrYlA0UHB6bzk5SXAvOHdXTjQwZ0k2VjdlbEJmT2U2bjdkQS80aW9zdUNv?=
 =?utf-8?B?UGNlYUVZVHZtdi9Jemo5Z3BtTFU5MW5kQ0x2ZTliMTZNNFlJQU1uQUxFTjc0?=
 =?utf-8?B?NFNXZmZGOXc0Uk1VZVFtWStGRkF6ejlpR1NaNUR0VXJqelF5ZWxNa1ozVzUy?=
 =?utf-8?B?d1R1NUJUWndsRXpxcy9tSXI5UlplUlR0UmFwOGdOMHgvTEY0VVQ4cndsNWw2?=
 =?utf-8?B?MzNpZ2ttUkpoMitJNkRqWWExWDh2WGxFRWpQaTNqRitweGp2UStDNHFlYmFR?=
 =?utf-8?B?V3ZadHF6QXFjSlJXemJMTFptQVp1Q0EwTEdBRGozNWs3S0h5V0pjN0ZQWmd2?=
 =?utf-8?B?MWI3OENyOGRWdjF5L1U2a3lJU3NTbWZudy8vL3BDd2h5NTBNdC8xaWRRK0FD?=
 =?utf-8?B?R1R4SnBJeTBmSTVmc3ZyTTQxRVRhcXhjQ0NVTnFXUHBNZnBFQVlOZzg3VmU0?=
 =?utf-8?B?THZRUmpJWHZLUmlDRnhDOXUzUjdmbVM0YmdpTlU2SG9IVExFcWMwU3ZvTWRW?=
 =?utf-8?B?VUVCeU0zMDIzdXNZbVVJWHAyS2pmTEF5bzZackRlOFAzbEN1dmZXSWUyeDNr?=
 =?utf-8?B?QTJDNk43R0VjaFplZDIyVjhTRkgyY1BYNUxFSSsyODhrUU0yTkN5V1Yxb25m?=
 =?utf-8?B?d3dvSzBrb1BPN0VtTkRtNnFMM1BBajdwWCtOOVBEWGNDaW1jSTRtczJOUFBm?=
 =?utf-8?B?cU9Rak5YNGVmL0V3dU1jbXlxcFlFY1JPWDVVSURoRlN4L1lROTN1QXZlZXpz?=
 =?utf-8?B?WHFKVzZONERhTllQSDRBSTJDMVlINDhQd2E0cGN4OGVlNnBheEZYR0JaSllZ?=
 =?utf-8?B?L2xVaHFXNWRwYi9FVVVVRkE0QTZCdlU1cnlWQXY1N01ONTJHOFRNYWZKVWlo?=
 =?utf-8?B?aVowWGw4eW1rMmd4ZXVraGVWa0lIRkkzVk9VbFQ4d3Zia2lhdFlCQ1RFeUNm?=
 =?utf-8?B?SkYwMWpQc3pieXZWdHRzcEZsQ2paOVZSRmgxUUJSMW15SEFWdXdQU3NjOFM3?=
 =?utf-8?B?T0YyV004eEdXRGs1VmVneVFmakNLTFcxbkM2cG5qTEVnc3BaZkR3TVFnSE5J?=
 =?utf-8?B?YTBpcitVcytyM1AwUWN2TGJNa012NFNEeDJ0c1laekhudEIvRE10RFVsSVAv?=
 =?utf-8?B?bDdITXhSSnYvVWVhZ2NaUkRBNDRFUHRwRXoyUE1xSzdQSVF5blJRNkUycm45?=
 =?utf-8?B?STBLZlhWWGhjVWFYcGdTM2htNzVhaytOYlFsNWEvakJ3S2JpV01tdHNCTEZJ?=
 =?utf-8?B?SnhPNFo1RHR1MEQ3VHY3c2w0ZE5yckxaUElxVm9vNWQ5SS9PTmE1VHF3Y1hJ?=
 =?utf-8?B?Nkd6bU9QUFBlL3lUQ3dkSlR5QnI5YXRqN0RUSTZWd1NPa2gwSGxndG1vMFhw?=
 =?utf-8?B?a2hHSDk2alR4ZVU3WTBRZEVXVXNIWS9IMlhWeUNNTmVsanR5NWU5eFhVUUZx?=
 =?utf-8?B?ZW04cGhXaDZWM3VreGxVWWgwUFA0alZsSU9QNEdmNXRFaGlLbzZVOER2YmRC?=
 =?utf-8?B?eUJEM2thSG9ieFEzQktjdTFmSlQ5WndkdFNVVEdBdmozdXlUMmp0S1pac3Rn?=
 =?utf-8?Q?6Sp0KYoLBSewIKUukmH2GdN0v?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 379b1f0e-dc78-4791-4169-08daf3eff98c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:22:03.9235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yn2QpKdnWsP7t0J7OYbGvFM1aJ3p5nE4HJrr05L8vYjbsXuliOd6CfXPuZ4mW+cCA3Cr5m1zgl8IMzWSKfPl3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8179
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/01/23 21:11, Tom Lendacky wrote:
> On 1/11/23 00:45, Nikunj A Dadhania wrote:
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
>> SEV_STATUS MSR indicates features which the hypervisor has enabled.
>> While booting, SNP guests should ascertain that all the enabled
>> features have guest side implementation. In case any feature is not
>> implemented in the guest, the guest terminates booting with GHCB
>> protocol Non-Automatic Exit(NAE) termination request event[1]. Populate
>> SW_EXITINFO2 with mask of unsupported features that the hypervisor
>> can easily report to the user.
>>
>> More details in AMD64 APM[2] Vol 2: 15.34.10 SEV_STATUS MSR
>>
>> [1] https://developer.amd.com/wp-content/resources/56421.pdf
>>      4.1.13 Termination Request
>>
>> [2] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
>>
>> Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
>> CC: Borislav Petkov <bp@alien8.de>
>> CC: David Rientjes <rientjes@google.com>
>> CC: Michael Roth <michael.roth@amd.com>
>> CC: Tom Lendacky <thomas.lendacky@amd.com>
>> CC: <stable@kernel.org>
>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>
>> ---
>>
>> Changes:
>> v3:
>> * Use GHCB protocol NAE termination event SEV-SNP feature(s)
>>    not supported along with SW_EXITINFO2 containing mask of the
>>    unsupported features. Need handling of this event on the HV.
>> * Add the SNP features check initialize_identity_maps() when the
>>    boot GHCB page can be initialized and used.
>> * Fixed sphinx warnings in documentation
>>
>> v2:
>> * Updated Documentation/x86/amd-memory-encryption.rst
>> * Address review feedback from Boris/Tom
>>
>> v1:
>> * Dropped _ENABLED from the feature bits
>> * Use approprate macro/function names and move closer to the function where
>>    it is used.
>> * More details added to the commit message and comments
>> * Fixed compilation issue
>> ---
>>   Documentation/x86/amd-memory-encryption.rst | 36 +++++++++++++
>>   arch/x86/boot/compressed/head_64.S          | 10 ++++
>>   arch/x86/boot/compressed/misc.h             |  2 +
>>   arch/x86/boot/compressed/sev.c              | 59 +++++++++++++++++++++
>>   arch/x86/include/asm/msr-index.h            | 20 +++++++
>>   arch/x86/include/asm/sev-common.h           |  1 +
>>   arch/x86/include/uapi/asm/svm.h             | 10 ++++
>>   7 files changed, 138 insertions(+)
>>
>> diff --git a/Documentation/x86/amd-memory-encryption.rst b/Documentation/x86/amd-memory-encryption.rst
>> index a1940ebe7be5..b3adc39d7735 100644
>> --- a/Documentation/x86/amd-memory-encryption.rst
>> +++ b/Documentation/x86/amd-memory-encryption.rst
>> @@ -95,3 +95,39 @@ by supplying mem_encrypt=on on the kernel command line.  However, if BIOS does
>>   not enable SME, then Linux will not be able to activate memory encryption, even
>>   if configured to do so by default or the mem_encrypt=on command line parameter
>>   is specified.
>> +
>> +Secure Nested Paging (SNP)
>> +==========================
>> +
>> +SEV-SNP introduces new features (SEV_FEATURES[1:63]) which can be enabled
>> +by the hypervisor for security enhancements. Some of these features need
>> +guest side implementation to function correctly. The below table lists the
>> +expected guest behavior with various possible scenarios of guest/hypervisor
>> +SNP feature support.
>> +
>> ++-----------------+---------------+---------------+------------------+
>> +| Feature Enabled | Guest needs   | Guest has     | Guest boot       |
>> +| by the HV       | implementation| implementation| behaviour        |
>> ++=================+===============+===============+==================+
>> +|      No         |      No       |      No       |     Boot         |
>> +|                 |               |               |                  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      No         |      Yes      |      No       |     Boot         |
>> +|                 |               |               |                  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      No         |      Yes      |      Yes      |     Boot         |
>> +|                 |               |               |                  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      Yes        |      No       |      No       | Boot with        |
>> +|                 |               |               | feature enabled  |
>> ++-----------------+---------------+---------------+------------------+
>> +|      Yes        |      Yes      |      No       | Graceful boot    |
>> +|                 |               |               | failure          |
>> ++-----------------+---------------+---------------+------------------+
>> +|      Yes        |      Yes      |      Yes      | Boot with        |
>> +|                 |               |               | feature enabled  |
>> ++-----------------+---------------+---------------+------------------+
>> +
>> +More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR
>> +
>> +[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
>> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
>> index a75712991df3..22037443e958 100644
>> --- a/arch/x86/boot/compressed/head_64.S
>> +++ b/arch/x86/boot/compressed/head_64.S
>> @@ -557,6 +557,16 @@ SYM_FUNC_START_LOCAL_NOALIGN(.Lrelocated)
>>       /* Pass boot_params to initialize_identity_maps() */
>>       movq    (%rsp), %rdi
>>       call    initialize_identity_maps
>> +
>> +#ifdef CONFIG_AMD_MEM_ENCRYPT
>> +    /*
>> +     * Now that the required page table and mappings are done, early boot ghcb
>> +     * page can be setup and used. Check for SNP guest/HV feature compatibility
>> +     * and terminate the guest providing exit information in boot ghcb.
>> +     */
> 
> How about a more concise comment...> 
>     /*
>      * Now that the required page table mappings are established and a
>      * GHCB can be used, check for SNP guest/HV feature compatibility.
>      */

Yes, better.

>> +    call    snp_check_features
>> +#endif
>> +
>>       popq    %rsi
>>     /*
>> diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
>> index 62208ec04ca4..0bc3639be1f8 100644
>> --- a/arch/x86/boot/compressed/misc.h
>> +++ b/arch/x86/boot/compressed/misc.h
>> @@ -126,6 +126,7 @@ static inline void console_init(void)
>>     #ifdef CONFIG_AMD_MEM_ENCRYPT
>>   void sev_enable(struct boot_params *bp);
>> +void snp_check_features(void);
>>   void sev_es_shutdown_ghcb(void);
>>   extern bool sev_es_check_ghcb_fault(unsigned long address);
>>   void snp_set_page_private(unsigned long paddr);
>> @@ -143,6 +144,7 @@ static inline void sev_enable(struct boot_params *bp)
>>       if (bp)
>>           bp->cc_blob_address = 0;
>>   }
>> +static void snp_check_features(void) { }
> 
> Unneeded since you're wrapping the call in a #ifdef check.

Will drop it.

> 
>>   static inline void sev_es_shutdown_ghcb(void) { }
>>   static inline bool sev_es_check_ghcb_fault(unsigned long address)
>>   {
>> diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
>> index c93930d5ccbd..a26a5d6949c3 100644
>> --- a/arch/x86/boot/compressed/sev.c
>> +++ b/arch/x86/boot/compressed/sev.c
>> @@ -270,6 +270,65 @@ static void enforce_vmpl0(void)
>>           sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
>>   }
>>   +/*
>> + * SNP_FEATURES_IMPL_REQ is the mask of SNP features that will need
>> + * guest side implementation for proper functioning of the guest. If any
>> + * of these features are enabled in the hypervisor but are lacking guest
>> + * side implementation, the behavior of the guest will be undefined. The
>> + * guest could fail in non-obvious way making it difficult to debug.
>> + *
>> + * As the behavior of reserved feature bits is unknown to be on the
>> + * safe side add them to the required features mask.
>> + */
>> +#define SNP_FEATURES_IMPL_REQ    (MSR_AMD64_SNP_VTOM |            \
>> +                MSR_AMD64_SNP_REFLECT_VC |        \
>> +                MSR_AMD64_SNP_RESTRICTED_INJ |        \
>> +                MSR_AMD64_SNP_ALT_INJ |            \
>> +                MSR_AMD64_SNP_DEBUG_SWAP |        \
>> +                MSR_AMD64_SNP_VMPL_SSS |        \
>> +                MSR_AMD64_SNP_SECURE_TSC |        \
>> +                MSR_AMD64_SNP_VMGEXIT_PARAM |        \
>> +                MSR_AMD64_SNP_VMSA_REG_PROTECTION |    \
>> +                MSR_AMD64_SNP_RESERVED_BIT13 |        \
>> +                MSR_AMD64_SNP_RESERVED_BIT15 |        \
>> +                MSR_AMD64_SNP_RESERVED_MASK)
> 
> Should these be indented one extra space to line up with MSR_AMD64_SNP_VTOM?

Boris in his comment on v2 had it indented till tab, I had used same intendation.

>> +
>> +/*
>> + * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
>> + * by the guest kernel. As and when a new feature is implemented in the
>> + * guest kernel, a corresponding bit should be added to the mask.
>> + */
>> +#define SNP_FEATURES_PRESENT (0)
>> +
>> +void snp_check_features(void)
>> +{
>> +    u64 unsupported_features;
>> +
>> +    if (!(sev_status & MSR_AMD64_SEV_SNP_ENABLED))
>> +        return;
>> +
>> +    /*
>> +     * Terminate the boot if hypervisor has enabled any feature
>> +     * lacking guest side implementation.
>> +     */
>> +    unsupported_features = sev_status & SNP_FEATURES_IMPL_REQ & ~SNP_FEATURES_PRESENT;
>> +    if (unsupported_features) {
>> +        u64 exit_info_1 = SVM_VMGEXIT_TERM_REASON(SVM_VMGEXIT_TERM_REASON_SET,
> 
> This should be SEV_TERM_SET_GEN (or see below).

Yes, will use reason set as SEV_TERM_SET_GEN and reason code as GHCB_SNP_UNSUPPORTED.

> 
>> +                              SVM_VMGEXIT_TERM_SNP_FEAT_UNSUPPORTED);
>> +
>> +        if (!boot_ghcb && !early_setup_ghcb())
>> +            sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_FEAT_NOT_IMPLEMENTED);
>> +
> 
> You need to call vc_ghcb_invalidate() before doing any ghcb_set*() calls.

Ack.

> 
>> +        ghcb_set_sw_exit_code(boot_ghcb, SVM_VMGEXIT_TERM_REQUEST);
>> +        ghcb_set_sw_exit_info_1(boot_ghcb, exit_info_1);
>> +        ghcb_set_sw_exit_info_2(boot_ghcb, unsupported_features);
> 
> Add a blank line here.

Ok
> 
>> +        sev_es_wr_ghcb_msr(__pa(boot_ghcb));
>> +        VMGEXIT();
> 
> Add a blank line here.
> 

Ok

>> +        while (true)
>> +            asm volatile("hlt\n" : : : "memory");
>> +    }
>> +}
>> +
>>   void sev_enable(struct boot_params *bp)
>>   {
>>       unsigned int eax, ebx, ecx, edx;
>> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
>> index 37ff47552bcb..d3fe82c5d6b6 100644
>> --- a/arch/x86/include/asm/msr-index.h
>> +++ b/arch/x86/include/asm/msr-index.h
>> @@ -566,6 +566,26 @@
>>   #define MSR_AMD64_SEV_ES_ENABLED    BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
>>   #define MSR_AMD64_SEV_SNP_ENABLED    BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
>>   +/* SNP feature bits enabled by the hypervisor */
>> +#define MSR_AMD64_SNP_VTOM            BIT_ULL(3)
>> +#define MSR_AMD64_SNP_REFLECT_VC        BIT_ULL(4)
>> +#define MSR_AMD64_SNP_RESTRICTED_INJ        BIT_ULL(5)
>> +#define MSR_AMD64_SNP_ALT_INJ            BIT_ULL(6)
>> +#define MSR_AMD64_SNP_DEBUG_SWAP        BIT_ULL(7)
>> +#define MSR_AMD64_SNP_PREVENT_HOST_IBS        BIT_ULL(8)
>> +#define MSR_AMD64_SNP_BTB_ISOLATION        BIT_ULL(9)
>> +#define MSR_AMD64_SNP_VMPL_SSS            BIT_ULL(10)
>> +#define MSR_AMD64_SNP_SECURE_TSC        BIT_ULL(11)
>> +#define MSR_AMD64_SNP_VMGEXIT_PARAM        BIT_ULL(12)
>> +#define MSR_AMD64_SNP_IBS_VIRT            BIT_ULL(14)
>> +#define MSR_AMD64_SNP_VMSA_REG_PROTECTION    BIT_ULL(16)
>> +#define MSR_AMD64_SNP_SMT_PROTECTION        BIT_ULL(17)
>> +
>> +/* SNP feature bits reserved for future use. */
>> +#define MSR_AMD64_SNP_RESERVED_BIT13        BIT_ULL(13)
>> +#define MSR_AMD64_SNP_RESERVED_BIT15        BIT_ULL(15)
>> +#define MSR_AMD64_SNP_RESERVED_MASK        GENMASK_ULL(63, 18)
>> +
>>   #define MSR_AMD64_VIRT_SPEC_CTRL    0xc001011f
>>     /* AMD Collaborative Processor Performance Control MSRs */
>> diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
>> index b8357d6ecd47..db60cbb01b31 100644
>> --- a/arch/x86/include/asm/sev-common.h
>> +++ b/arch/x86/include/asm/sev-common.h
>> @@ -148,6 +148,7 @@ struct snp_psc_desc {
>>   #define GHCB_SEV_ES_GEN_REQ        0
>>   #define GHCB_SEV_ES_PROT_UNSUPPORTED    1
>>   #define GHCB_SNP_UNSUPPORTED        2
>> +#define GHCB_SNP_FEAT_NOT_IMPLEMENTED    3
> 
> No, you can't create a new value to the SEV_TERM_SET_GEN without modifying the GHCB spec. So please use GHCB_SNP_UNSUPPORTED if using the SEV_TERM_SET_GEN set or else add a new value to be used with the SEV_TERM_SET_LINUX set.

Agree, this anyways is not used now.

> 
>>     /* Linux-specific reason codes (used with reason set 1) */
>>   #define SEV_TERM_SET_LINUX        1
>> diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
>> index f69c168391aa..5bd81adfb114 100644
>> --- a/arch/x86/include/uapi/asm/svm.h
>> +++ b/arch/x86/include/uapi/asm/svm.h
>> @@ -116,6 +116,16 @@
>>   #define SVM_VMGEXIT_AP_CREATE            1
>>   #define SVM_VMGEXIT_AP_DESTROY            2
>>   #define SVM_VMGEXIT_HV_FEATURES            0x8000fffd
>> +#define SVM_VMGEXIT_TERM_REQUEST        0x8000fffe
>> +#define SVM_VMGEXIT_TERM_REASON_SET        0
>> +#define SVM_VMGEXIT_TERM_GENERAL        0
>> +#define SVM_VMGEXIT_TERM_SEVES            1
>> +#define SVM_VMGEXIT_TERM_SNP_FEAT_UNSUPPORTED    2
> 
> This NAE event uses the same reason code set information as the MSR protocol, so the above 4 definitions are not needed or the definitions in sev-common.h should be redefined to use these defines, e.g.:
> 
> #define SEV_TERM_SET_GEN    SVM_VMGEXIT_TERM_REASON_SET
> #define GHCB_SEV_ES_GEN_REQ    SVM_VMGEXIT_TERM_GENERAL
> ...

Will use the defines from sev-common.h

Regards
Nikunj
