Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D3B6C5F79
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 07:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCWGHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 02:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjCWGHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 02:07:47 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4282943F;
        Wed, 22 Mar 2023 23:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsJcZuyDRudl5a65Qm6qb+jGPQAhs4XAQxs+KbrT4vOeh5iY1Qq0IvCIiu3S6s/vlybuI8uT3MzrxD3658h2srGAalvCGlPhJT3AJb2QhQ3iZrBDhridmpjtSOOvrIPcSz0YAXpLUYeEb/YeKTvHHBWGGDwCmk49PCxu+vKcjzG7+w2QKOAWi6tVghk3r49dufcs4HZqnp6uiQ/7jIa4a51SirefjA1CNdRqjsw7hT5jcnhjz7Ef9OlwPlWxfGXt1wQvjtl7B0mCNyeO/CBkY+CiTb7/3GK7R5oR6DfYPCZbTeV1uxdlBxDPKTLiDoJpeyNP45Crd1UOD9gce2SbSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGld+I35hPJRNFcN8vH6fVVUs83bzladWC0hU5OulaI=;
 b=nqe441P3NYT5HFAdYikfsAXiNQtlkM9+Cck1dHZdWQvTW2bVl6OHNSIc6adU/+hWGMF8cLJtupYtwsos4una4sc4jg5Jvvq6kMBiwyVI5JGesFkJ0SVJU2GxiWDkCiUAU7HJtdwCqFe7ucEo+LN3s3hFpK4j5B42GSpEIc6yzZ7U3tEEbGINvPGRyhHXAeLPKFZD3bKDof+n9GuvueVPA/DEmFOCgfg4P/vsGih4zRZ/ZM1w2lZavns4E3lFuAcrljVZm6ldkdLyGa7/7Ppnhm0REKNG+GsRRI3+CWgoIYF5V9k+jZeZU5aZPT0JfhO5G7cnh5T6yZ+gcLVomi7+Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGld+I35hPJRNFcN8vH6fVVUs83bzladWC0hU5OulaI=;
 b=Bxt8B1jE29THMHDQbHzz0hsU4y4QqTEbBuKki1VZZFwx3owjOIV7DU19H7Dq33V3Umajty/cQU2CvDeUpz7vxPf1ZuU6vqG6nMWLqxbIBKmI9MzuWAe/Xy/j7omdLxsUP1YKfDtJs8AGTBZ6kPjsa+xIch/2UmyM4qZ2Sg8U21c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6214.namprd12.prod.outlook.com (2603:10b6:8:96::13) by
 CH3PR12MB7571.namprd12.prod.outlook.com (2603:10b6:610:147::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.38; Thu, 23 Mar 2023 06:07:07 +0000
Received: from DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::93a1:b268:8b07:9253]) by DS7PR12MB6214.namprd12.prod.outlook.com
 ([fe80::93a1:b268:8b07:9253%5]) with mapi id 15.20.6178.037; Thu, 23 Mar 2023
 06:07:06 +0000
Message-ID: <acfe667f-f598-ba6f-7723-ad5c55bc746d@amd.com>
Date:   Thu, 23 Mar 2023 11:36:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH kernel 0/2] PreventHostIBS feature for SEV-ES and SNP
 guests
From:   Manali Shukla <manali.shukla@amd.com>
To:     linux-kernel@vger.kernel.org
Cc:     peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        jolsa@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, dave.hansen@linux.intel.com, seanjc@google.com,
        pbonzini@redhat.com, jpoimboe@kernel.org,
        pawan.kumar.gupta@linux.intel.com, babu.moger@amd.com,
        sandipan.das@amd.com, jmattson@google.com, thomas.lendacky@amd.com,
        nikunj@amd.com, ravi.bangoria@amd.com, eranian@google.com,
        irogers@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-perf-users@vger.kernel.org,
        Manali Shukla <manali.shukla@amd.com>
References: <20230206060545.628502-1-manali.shukla@amd.com>
 <786f4d69-85c6-a581-1187-2fe8a49cf7e6@amd.com>
In-Reply-To: <786f4d69-85c6-a581-1187-2fe8a49cf7e6@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0198.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:e9::7) To DS7PR12MB6214.namprd12.prod.outlook.com
 (2603:10b6:8:96::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6214:EE_|CH3PR12MB7571:EE_
X-MS-Office365-Filtering-Correlation-Id: 657e5f24-84c2-4b3d-54f4-08db2b64d459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nRmDrN5h9iod5WqkefQSuvIIljTUhgWRAXc8TUSycsRjIQxd0moP8C8mzcoWTbc9RgP0T7kbMhlMAdX/sjuIEJazRq9rnigfSaVbmJ6UjkT1wBrq/AGlqASRssEFshMi7rDaYsM4Wc6HFJQRWZlAXYYdQXanHujs6MrxkCkPwH7p3EZMjlutbMHUlt7MT83S2N+gcOvkX3dAcHT/4nMGzNHFbbLe7d1N+d3GcCx9U1HX/4UC9Q6kzR6g899yD29MyJ44qDptgNCucKWf5W9CKtDopgaxnU5PFAj/VrgYmeAFXrO902/Av4BFrQe8lGbG9vJV1Vq4DG6gHvuCPddLb7qscTy/V+adscgRjImLehY7+eb3hGLMJ6hNh1KEodYYwsdWyGKtaSOcrmAHAVehOUdRX/Iq5FRjjUVNq3EwrsLyDwjjIDrDGMw2PIl/DzIXt9h5Mu2hREDSu4k1mPSZDT8458UiIdHCZ9fdTv6etizTIehRv1DYaD053ki0eOYLj5wFWcfxb/uyqrbO07p+fAm9JJWeVg/SHAcriqCK/miX2NHDxmDCaqQy9ZY/KTQpLACni/Y/WAigOI251TrmAAO8XMQ6fN34sPNRf0H1BzvvvRYLrGIkKobpja8P+N5+SYupjzSxbe724ZoSw/zX6PVaptTvDoLkbcJ7GokvP1ekJ7c+gnQTC6b4CSBmwb28IeF66+V7bpOG7nVNr0ZHIIfRxoXtxmQJIJz3RNRtN+U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6214.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(451199018)(2906002)(44832011)(7416002)(5660300002)(41300700001)(8936002)(86362001)(36756003)(31696002)(38100700002)(83380400001)(6512007)(26005)(478600001)(6506007)(53546011)(6666004)(6486002)(31686004)(66946007)(66556008)(66476007)(186003)(2616005)(8676002)(4326008)(6916009)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEZKQmtOUDJtbEVHKzBTQ2M3dmp1VjN3bUg5OFJZNHVzZjRCYXJTSk1YYjJC?=
 =?utf-8?B?RmJmV1czcll6MFV4MUxOQXd4cVdNR2hORFZGWCt0TE10UzVQeW9lTFJZN3M5?=
 =?utf-8?B?MlM4MDNuSE05Tmx0d043eUFvYlB6Vml5RlV1Y0VOUEJyTUhkd2VNaWFwY1lT?=
 =?utf-8?B?NlJJaCt4WmE0OXdESnJkaVNBMTlyMmg5WEFuYXBaNURkN2gzOHVWT05oQUo1?=
 =?utf-8?B?Mm4zYnRkdTFrVzUrYkVkakFBb0dVdEZqdHpYVjdOWkgydVpuTHdYaTNTYU04?=
 =?utf-8?B?WENpTGcrVlByek5IUjUrL2JZc3dtd081RDVDQUduK0xoKzRKc3ZpUWVVYXJu?=
 =?utf-8?B?MkpoVGhEN0hKVW05dDM0NWh2K3Mvei9wOEZyN05lbFpMa1o1dnFTcWZ4WlJL?=
 =?utf-8?B?bzFJMjZwR3I2c09JbjhVVnBSVXpGaU4ybzlNcVdrVE9RMjdoOUFQMW1BVUdC?=
 =?utf-8?B?eUF0UVUxOUZZYWpuVDhsTjRyMlU0QU1RSk9XRGN0M3FjSVNPYVpDMWpyWjdq?=
 =?utf-8?B?Z0JQSnZ1S2ZPYkV1VHRsZWUvU1B1TUxrRTMweDE5czBBRE1DdlFReHJoaksv?=
 =?utf-8?B?ek5VWGVQRTR0dWpkNVdVUVVvazczSE4rcVo5TXpHbExYUVJvNU02cUJKYUYy?=
 =?utf-8?B?VXpCNG1IZ09iV2x2UVBaejYwVHhCNjNZWFpKcTQyd05nNEtndXFmZ1FuMFRI?=
 =?utf-8?B?WTM0NHRORkFWMXpvY3BUZk1FRVhQcHowUk5MUW92SzcrK1YwN1c0N2hENDJi?=
 =?utf-8?B?Y2ZQQlhtMGNuK1djem5DQmFEd01UVThKZTkvdjJ2QStCci9rdzYyK0FBRjg5?=
 =?utf-8?B?TnJxekxRbU0wMlUvRTlDNVRkL29DUU5wbGNjN2NlbjRkYkQrd1lRM0djejRO?=
 =?utf-8?B?MHRzQTBPOS9xS1FwZ1RBd0lLdmVReDBjWHJjTUMxWHB6eGVwbHFDc2h3YjFW?=
 =?utf-8?B?YlBjaWFKN0VpUVRsWUFzM3ZiNEhWWmcrbDdjaFBvUmdyQmJnb3B2Ny9jR0Zt?=
 =?utf-8?B?djhMaXdaQXV0SmFNTnJCSGNhRVZ1L2hNc3RSelVpeUgzelpqd2Y1OEJSSXNq?=
 =?utf-8?B?d1UreDBMRmh5MUpWSlIrem9BZm1TRnV4ck5LTXMyQmFUaTFWMXkxbWJhakJN?=
 =?utf-8?B?VFg2UE0zNTJTWGE0VXViaDZUZHlJUkc3b2ZNS1I2ckFIV1BKNGsyd2d6U0l6?=
 =?utf-8?B?QmRoYU9UcWlPQmhsYjU4TWJtMG5MUHdvNklyN3poNUV2UWtyUTZKc2lCdFI5?=
 =?utf-8?B?eTMrV2FVUXNraTk1Vlo5ZWVVdVhCYlk2MHVRcTlGNkJqaGNjSVdBNnBUbU16?=
 =?utf-8?B?Z1M4U2YwdVJCZEt4UEhmTFZRQmp2RDIxTFllcmxEQU1JOFc2RDZzd1hXSUxI?=
 =?utf-8?B?UzhSdXRTeTVRcjBCTVFGWldJd3dRTmlIQkFiY1JyaEh2ZzlNc0VwQnhSZlZi?=
 =?utf-8?B?aS9kaS90cW1nSDgwaDB1dk42SEVoRnlMQUtVMWdRbkZzSGRTY3FnTS9oV1J2?=
 =?utf-8?B?R2JZUnRZVXVrQ21uTmdVTnBMRDBoUGkyZnUvbHVSTlBycTN3d0lVU1NVNGxi?=
 =?utf-8?B?U2szSDVNZDhjL0RyRUVHN2tZTE1KQkIxOXpsVnJkVWdXSXNYQVJ2K1hvZExz?=
 =?utf-8?B?MWNLeUp5VkhvRWpXbkFmOW1uVSthTG5RNXdMYWN4MUZQZVJzU3BJZGg4c2VP?=
 =?utf-8?B?TnJrVGhTbm1vZ1ZFVTRyWjEvMVRGTStQQm5pd05iNnRoQTg0ZVhxV1FkdkNy?=
 =?utf-8?B?bG1EVkpyVE15b2xyVFp0OGpOU0d4QkowS2RMd0NzYmlRVEhTWlFHRUxFaVN4?=
 =?utf-8?B?NHpGMlZZUWN0N1F6Y3JCR0VjcXhSbFF6TEJobm9ESktRbWhiSFkwenBzT3hq?=
 =?utf-8?B?c0NpMTFIWmM0TkdSaHBNeCtqbFFzaS9BaythSWtyTExzU2tLNkdiZTlNakJB?=
 =?utf-8?B?emtBZ1hVeGloZlZvaEhCRDBWanU2ZDBGcHFydGFDVEFPZWNic0dJTXcvNG1M?=
 =?utf-8?B?VE9nYzdOQ3ljcFpzWVhUZmdoNW1mL0lRS1lPNFJsbzRtbCt2QjJuMHBVVmlG?=
 =?utf-8?B?UHVtZU9EY3BSK3VjZTFjazZnYjEvMERIY1hZNmxPeVk2R2xnamtVNy81dDhN?=
 =?utf-8?Q?YQJawZkt1ewk9G+wOuCtCAuY/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 657e5f24-84c2-4b3d-54f4-08db2b64d459
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6214.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 06:07:06.7573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a450DiOEe6zhBuooRAprvxbtepjte65/U3ng+xWdh6Y3GivCv8prLenD44MSBnd+qKzggiJG3iBiiNSF2201AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7571
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/15/2023 10:33 AM, Manali Shukla wrote:
> On 2/6/2023 11:35 AM, Manali Shukla wrote:
>> Adds support for PreventHostIBS feature for SEV-ES and SNP guests.
>> Currently, the hypervisor is able to inspect instruction based samples
>> from the guest and gather execution information.  With enablement of
>> PreventHostIBS feature, SEV-ES and SNP guests may choose to disallow
>> use of instruction based sampling by the hypervisor in order to limit
>> the information gathered about their execution.  (More information in
>> Section 15.36.17 APM Volume 2)
>>
>> While implementing this feature, unknown NMIs were being seen. On
>> further investigation, a race was found effecting the IBS FETCH/OP
>> MSR.
>>
>> ENABLE bit and VALID bit for IBS_FETCH_CTL are contained in the same
>> MSR and same is the case with IBS_OP_CTL.
>>
>> Consider the following scenario:
>> - The IBS MSR which has ENABLE bit set and VALID bit clear is read.
>> - During the process of clearing the ENABLE bit and writing the IBS
>>   MSR to disable IBS, an IBS event can occur that sets the VALID bit.
>> - The write operation on IBS MSR can clear the newly set VALID bit.
>> - Since this situation is occurring in the CLGI/STGI window
>>   (PreventHostIBS window), the actual NMI is not taken.
>> - Once VMRUN is issued, it will exit with VMEXIT_NMI and as soon as
>>   STGI is executed, the pending NMI will trigger.
>> - The IBS NMI handler checks for the VALID bit to determine if the NMI
>>   is generated because of IBS.
>> - Since VALID bit is now clear, it doesn't recognize that an IBS event
>>   is occurred which in turn generates the dazed and confused unknown
>>   NMI messages.
>>
>> Per-cpu ibs_flags which indicates whether PreventHostIBS window is
>> active/inactive are added to avoid the above mentioned race.
>>
>> An active PreventHostIBS window is set before calling VMRUN and
>> cleared after STGI. PreventHostIBS window check is added to
>> perf_ibs_handle_irq(), to avoid unknown NMIs and treat them as handled
>> when window is active.
>>
>> There are 2 patches in this series.
>> 1) Add amd_prevent_hostibs_window() function to set per-cpu ibs_flags
>> based on an active/inactive PreventHostIBS window.
>> 2) Enable PreventHostIBS for SEV-ES and SNP guests.
>>
>> Testing done:
>> - Executed program symbols in guest are not captured in host when
>>   PreventHostIBS feature is enabled.
>> - Generated 1000+ NMIs using cpuid command, no unknown NMIs are seen
>>   after enablement of PreventHostIBS feature.
>>
>> Qemu commandline to enable PreventHostIBS on guest.
>>
>> qemu-system-x86_64 -enable-kvm -cpu EPYC-v4,+nohostibs \ ..
>>
>> Manali Shukla (2):
>>   perf/x86/amd: Add amd_prevent_hostibs_window() to set per-cpu
>>     ibs_flags
>>   KVM: SEV: PreventHostIBS enablement for SEV-ES and SNP guest
>>
>>  arch/x86/events/amd/ibs.c          | 64 ++++++++++++++++++++++++++++++
>>  arch/x86/include/asm/cpufeatures.h |  1 +
>>  arch/x86/include/asm/perf_event.h  | 20 ++++++++++
>>  arch/x86/kvm/svm/sev.c             | 10 +++++
>>  arch/x86/kvm/svm/svm.c             | 39 +++++++++++++++++-
>>  arch/x86/kvm/svm/svm.h             |  1 +
>>  6 files changed, 133 insertions(+), 2 deletions(-)
>>
> 
> A gentle reminder for the review.
> 
> -Manali

A gentle reminder for the review.

-Manali
