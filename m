Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B824166A73A
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 00:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbjAMXtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 18:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbjAMXtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 18:49:24 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2086.outbound.protection.outlook.com [40.107.100.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCF46C06F;
        Fri, 13 Jan 2023 15:49:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AR873LolVMH8hWm9KlR/EgFUCIz0HScKVcrMawaDAiCU/uJvgejFR+LBW2gnBjMnRuTdJ6YQsuScj5ZWeDLubz8iM4P/s1v3Msc0CaAAWl5nML5FYSVWeCPpPHm+bL+TVX1ueYtdQPq02cW6hGVXE2/1zwRXkyPtWGMEKBSIkS7/kcYWc6ftVc65Y3MSsDO20E6ifAczNW6QwVMfsdTAOKtm67AylySxZy5723og6RrTSvFquGsZsyE1oxl/8KpXJDK/uhm3eNRr55Ok82q5Knk9b6AFvHLnVs+4cUInU3+nQ1lvUXETD+RtafCALuxcXvrRBexrNjx5GALQyDIbYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lOeUeJmyRFPEQH70CZbi3G9bFkJ6QW+TG+1Zth5MpbI=;
 b=bFaCrwyP8fXTjugd8CG2/IQMTbJGGdBiS58UVZgI1FQR+sDXLbsPHA6Nvq/yLYdMCQ1t4vneYJA65IO6yugP/Te8mfSG0ynDSxrS1QV/P7adXPfVljNqmA+MGLVjvb1mpCLM46fnOo76qVLqKiRBx7exMT4xNC3rYA++bCcy5BatylNadiKqsv/QGLMm/9DeUxcDiXwzC+zZhVj/Ahw9rnioBGffirzWRv1Al375rpg8C29IjyDuhl81/vxnhTSgepCOt6Hu9/j90BhwjEeXIINXEntSRTdSn5DGGXThWmPKUV+ImEMEbA3G0ak3I0TM3yzJv+W10kiU7c06UX7bKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOeUeJmyRFPEQH70CZbi3G9bFkJ6QW+TG+1Zth5MpbI=;
 b=hs1UA1z6BEup80Ivpk1c2EpokBkm3P8Li3ayJuyYcPlDkX+f27YACEU1d6dpiJKATQZaz1bZCFXav0x6NzD/D9mt49DqdpNj9EyIxDBewfwgqhwhWLZzqUgz1Bcp7m5otaDh5W27U6iKCIllLYWS97yVc1ySFce900sA8xB+qJU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH3PR12MB7572.namprd12.prod.outlook.com (2603:10b6:610:144::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Fri, 13 Jan
 2023 23:49:20 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.018; Fri, 13 Jan 2023
 23:49:19 +0000
Message-ID: <0bc2dc15-4c51-3003-0e7c-cab541a8a4cb@amd.com>
Date:   Fri, 13 Jan 2023 17:49:13 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 23/64] x86/fault: Add support to dump RMP entry on
 fault
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>,
        Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        luto@kernel.org, dave.hansen@linux.intel.com, slp@redhat.com,
        pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, dgilbert@redhat.com,
        jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-24-michael.roth@amd.com>
 <CABpDEu=eNi_R5c_hmw1J3kFUsWiNUFQ2Sdxwf0QXX5osH4u6cQ@mail.gmail.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CABpDEu=eNi_R5c_hmw1J3kFUsWiNUFQ2Sdxwf0QXX5osH4u6cQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0019.namprd18.prod.outlook.com
 (2603:10b6:610:4f::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|CH3PR12MB7572:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b267bf5-16a2-49a7-f670-08daf5c0c9db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yo2KLwLVI1dVHGw3v4lYS698mavmGsPm7JzYWxd+hMloizIkDWt1xnvMcwPvBwidI59ofVGKV1GxFrPX9TYSNZ9ahomIvz9ja/OtythGNEoQ4iaB/ifZXrMO0ptNr8J3D++BA3cXP6Ox+QWbV5IKJcAKnerLuXkXk/QDHNhAcP6KyvJcM5rxCq6vbt8iGctHkva5FPW6C/MrR6/6VSBIgV2sx1XzhDXL0RenofYfEvQyhsbAHYRSrPOYKr4+zQETeA9OdiKaCpIYCTuT+gnnEMEl5S9V2W9KvzHHzPBDBxH5Zw5MhxzjiCLi4LWb2270nM4wVHsuZ57ovS6oTXr2RIdV46kuwqh347FMhTFAux5/ztf/NuyWa4bH8uYLTGM3qhM4mA6+NA68xZd/Wt7/oq6bzfSHCoUuQcf/SCqbJ/i4JGwmnCoC2o2vo/9Dgfhgd0Nsm/xbp6iCEebMXMpq7mfeEqxivNZj4JNKxhc5zKWe1n4BkyK1Y/iL7gcr9ZKueBf2QC7KZ4Tdg/6xmOjPa00mUoZbJCRKFKtY7w5NcUOrRInXQ0n/24gVMYk8JtrItA0uiP+vINDt3bbcwqilcY0p9swiZr3gIdpcQJXG3UUbb2DdE1cfqLET5dN0B5m3nvtPlX5VNbfGaffer1wND7/i7kcrsn4i1sbiXRvGZBuPv3Rvbz9OtrtJEW3BjoyUcLsxmDqKyU4ltfjrHtshpsLGU7oEttVGV/NsF8aGbA8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(86362001)(26005)(7406005)(316002)(6512007)(186003)(478600001)(5660300002)(6486002)(7416002)(2616005)(41300700001)(31696002)(6636002)(4326008)(66476007)(66556008)(66946007)(110136005)(8936002)(36756003)(8676002)(83380400001)(31686004)(6666004)(53546011)(6506007)(38100700002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QWV5cWQzTEU2Zmc5eUdzTHMzTW5uTUt2S1ZmT2J2VmVyYkg1djFJaVU4ZlJa?=
 =?utf-8?B?VjEzeWtxb0hEWmtIRHFXMHpUdldaYmZYMzNiL1RhcnJKZzNxN1Q2MFV6NlBl?=
 =?utf-8?B?ZFFKWGNPUlN5SmhBYlBzaXZkN1NYcXAxT1lTRUVhdzZWMmRqNVdNMWxxMUM5?=
 =?utf-8?B?eDhoK2s5d1h4d1pBWDY2bVIya2RHSENPQ1NsNDlSamM1bHlhTkNhR2hoWDBQ?=
 =?utf-8?B?aVRrb3B4a3AyUFNmaHA1Ui9TODYvV1BUOG1mWnFJalIvR0RIZlRQdUNiWjlH?=
 =?utf-8?B?RzdDN1dVaStuZCtYbHZQbXFCSzFaalNjUjA4ZWFrTE05eXV0WjlWWmdHWlNN?=
 =?utf-8?B?dHFIaStrdnFwMHdHRHpwR0VKRzVFYVhIV0ZYR0VRSCtVRXR6TndMczVheDlR?=
 =?utf-8?B?blBmT1BFY1E3R0xSNEFvTzNMejFDZXYzQ2xJbmRHRTNMU0Q0T25GRzc5VHY4?=
 =?utf-8?B?VU4xd2hncE4zRldXdmdVbzBUSWZ4VjA5UG4wMy9Ha3FjNVJPSy8xamlMektv?=
 =?utf-8?B?N0lyVnZPUVQ5cVhETG9lZ3dOWmlza3Rld2xXaW5KVEZFeWVxSVlialp6SFdo?=
 =?utf-8?B?dzQ2SWpSNDM3NFMxME1CMEVGOUloejVyTHI3MERhNENQaDVzaCtGQVhPRmZW?=
 =?utf-8?B?V3B2VkwzYVh5UHBFVFVrQVFabjBUR21IaE9JbmFEQjBtRWg3c0tnZEgxclZq?=
 =?utf-8?B?VnFzUDlQSXc5MXJSV2FNUWtmYkx0bzdWc3FpK1E0M0s2Q2E2cU9qWTA4UFJk?=
 =?utf-8?B?MW9yZmFOb0FwVExnREtpOU9HVkNuQjVnRzZhOUJvL2hGQVlYZEZRdS94K1pV?=
 =?utf-8?B?czNPT2NKZ1VQU2ZVN29rb2Ewc1Jtc3BRSEFTNXhEU3pRc2ZXdzR1eTc3RUNr?=
 =?utf-8?B?cFRsbGNzc3VvSlMrQUZ1czZKZU1NN0p5dGZhd3NNbkRQeCtGeEZjVVhvdXRN?=
 =?utf-8?B?UFdxaFlFREpKNUdSVnkzc0dLYzZBSHdVTForc0I0cyttWVhJcC9ZZXFNVzF4?=
 =?utf-8?B?bWhEZDVsYklVYzZ0TXNZUWl2bjNubjlvNVYrWGlZdTdlZUZ0YjlHbGZQV3FX?=
 =?utf-8?B?cjdaN2piZm9kOWtoRE5NOGxSNEJ6OWprZ3V3dkpaMFVDN28vaStGZmpxQUwx?=
 =?utf-8?B?Y2M3SVJEK2lOK1FxdG5WZkFWbVNST1hMWHprTjFMNGFiK0pRVVo3bThpZ2dz?=
 =?utf-8?B?M1F1NkN3SUxaWVo4RUtYMGFpaCtLWDl6V2dBcTBpUngzUEJEb1pqSFlKTjg3?=
 =?utf-8?B?ZEpvektvZ1pIdGdPUlExS3AxeXVkTWtDNjY1b1BqWVFSOGpKREJlRDR1bzFY?=
 =?utf-8?B?QWxWQ0FVUDhCbDNPcFpBbzJOejBCREZNL3NCSWtlKzYrRmZFVkpQYjdDWFdW?=
 =?utf-8?B?YVF1VDg4aFRKdGJDVEZuY2UzN1dZYmlnNC9tV2h3UG1xM2dzUUdyM0hJVEdw?=
 =?utf-8?B?c3RqK2ZRTTh1QjdDdWpoYUlJYjVMOHJBT0dETHVaTFVmYkxqOTJVNGtMVlkw?=
 =?utf-8?B?M2dhai9sVGdnL1B5ODBWblVvbUZoUlhRRzRpS2M2TlRId2J5U3BQK2tHNDRi?=
 =?utf-8?B?blEvL1c3VzJzbDh4V3RMR0pXR3pjQ1MvMHNkcmwwc2ZQRTRDVVY5bVFKRmJj?=
 =?utf-8?B?ZndqaDZMWXFadkN3YXRCVElWb0RoVm1uWVFnS0pORmxyYmo1bkVVVFU2NWZ0?=
 =?utf-8?B?QXVqQ05kUUpOcERVd3dwNUtUU1hhVloyeDluZy9VeUdnUFU4YzliWmlLNWNa?=
 =?utf-8?B?bjJ1S2lmNm1BcWhxTUx5bGkzdVhGbmhxaG0yaldYM3ZqNkVQeW1tSCtvNXRT?=
 =?utf-8?B?dHk4NHZYaDhsbmxSTlpIdUtaVGM1MmpmSzhZSzhQbUUvamtxaVBraEIyMzVu?=
 =?utf-8?B?R2hscUw2dVU0ZmZnZmRqN3R6Wk5ZVmZPSVpQSDdVOWprMlNzeU5CNzVQNU1u?=
 =?utf-8?B?ZUw5Wm1JRHprUUo3MllHb2ZUbGcycmRCemQ5TWJsY2RtWXdtUm9MQUlUR3cy?=
 =?utf-8?B?UUZOTzhHczlmMHZGM3VudjlFU1F4cCs0azNzazlLUUZJTkN1dGFtK09BMmRs?=
 =?utf-8?B?a1FhK1FqSkxzT0c2R21qY2czN0NwZWdLRHBaMXlFVWtTMnhPY2lnQ0RrL2VW?=
 =?utf-8?Q?cYKW7E6iiIa+82xXborkaS1yj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b267bf5-16a2-49a7-f670-08daf5c0c9db
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 23:49:19.7226
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4gCrC/7mxCOPo5UtgHkB2uUbqverJRAoP77QCl8zIHJfdsVnO+J50jdXR5dsuL2lqrgpc3bP/LSfHDHpfHb2Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7572
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/13/2023 4:56 PM, Alper Gun wrote:
> On Wed, Dec 14, 2022 at 11:52 AM Michael Roth <michael.roth@amd.com> wrote:
>>
>> From: Brijesh Singh <brijesh.singh@amd.com>
>>
>> When SEV-SNP is enabled globally, a write from the host goes through the
>> RMP check. If the hardware encounters the check failure, then it raises
>> the #PF (with RMP set). Dump the RMP entry at the faulting pfn to help
>> the debug.
>>
>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>   arch/x86/include/asm/sev.h |  2 ++
>>   arch/x86/kernel/sev.c      | 43 ++++++++++++++++++++++++++++++++++++++
>>   arch/x86/mm/fault.c        |  7 ++++++-
>>   3 files changed, 51 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
>> index 4eeedcaca593..2916f4150ac7 100644
>> --- a/arch/x86/include/asm/sev.h
>> +++ b/arch/x86/include/asm/sev.h
>> @@ -215,6 +215,7 @@ int snp_lookup_rmpentry(u64 pfn, int *level);
>>   int psmash(u64 pfn);
>>   int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int asid, bool immutable);
>>   int rmp_make_shared(u64 pfn, enum pg_level level);
>> +void sev_dump_rmpentry(u64 pfn);
>>   #else
>>   static inline void sev_es_ist_enter(struct pt_regs *regs) { }
>>   static inline void sev_es_ist_exit(void) { }
>> @@ -247,6 +248,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, int as
>>          return -ENODEV;
>>   }
>>   static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
>> +static inline void sev_dump_rmpentry(u64 pfn) {}
>>   #endif
>>
>>   #endif
>> diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
>> index e2b38c3551be..1dd1b36bdfea 100644
>> --- a/arch/x86/kernel/sev.c
>> +++ b/arch/x86/kernel/sev.c
>> @@ -2508,6 +2508,49 @@ static struct rmpentry *__snp_lookup_rmpentry(u64 pfn, int *level)
>>          return entry;
>>   }
>>
>> +void sev_dump_rmpentry(u64 pfn)
>> +{
>> +       unsigned long pfn_end;
>> +       struct rmpentry *e;
>> +       int level;
>> +
>> +       e = __snp_lookup_rmpentry(pfn, &level);
>> +       if (!e) {
> if (IS_ERR(e)) {
> 

Yes, this needs to be fixed to IS_ERR(e)

>> +               pr_info("failed to read RMP entry pfn 0x%llx\n", pfn);
>> +               return;
>> +       }
>> +
>> +       if (rmpentry_assigned(e)) {
>> +               pr_info("RMPEntry paddr 0x%llx [assigned=%d immutable=%d pagesize=%d gpa=0x%lx"
>> +                       " asid=%d vmsa=%d validated=%d]\n", pfn << PAGE_SHIFT,
>> +                       rmpentry_assigned(e), e->info.immutable, rmpentry_pagesize(e),
>> +                       (unsigned long)e->info.gpa, e->info.asid, e->info.vmsa,
>> +                       e->info.validated);
>> +               return;
>> +       }
>> +
>> +       /*
>> +        * If the RMP entry at the faulting pfn was not assigned, then not sure
>> +        * what caused the RMP violation. To get some useful debug information,
>> +        * iterate through the entire 2MB region, and dump the RMP entries if
>> +        * one of the bit in the RMP entry is set.
>> +        */
>> +       pfn = pfn & ~(PTRS_PER_PMD - 1);
>> +       pfn_end = pfn + PTRS_PER_PMD;
>> +
>> +       while (pfn < pfn_end) {
>> +               e = __snp_lookup_rmpentry(pfn, &level);
>> +               if (!e)
>> +                       return;
> if (IS_ERR(e))
>        continue;

Again, this is correct, but then it should be :

if (IS_ERR(e)) {
	pfn++;
	continue;
}

Thanks,
Ashish

>> +
>> +               if (e->low || e->high)
>> +                       pr_info("RMPEntry paddr 0x%llx: [high=0x%016llx low=0x%016llx]\n",
>> +                               pfn << PAGE_SHIFT, e->high, e->low);
>> +               pfn++;
>> +       }
>> +}
>> +EXPORT_SYMBOL_GPL(sev_dump_rmpentry);
>> +
>>   /*
>>    * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
>>    * and -errno if there is no corresponding RMP entry.
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index ded53879f98d..f2b16dcfbd9a 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -536,6 +536,8 @@ static void show_ldttss(const struct desc_ptr *gdt, const char *name, u16 index)
>>   static void
>>   show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long address)
>>   {
>> +       unsigned long pfn;
>> +
>>          if (!oops_may_print())
>>                  return;
>>
>> @@ -608,7 +610,10 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
>>                  show_ldttss(&gdt, "TR", tr);
>>          }
>>
>> -       dump_pagetable(address);
>> +       pfn = dump_pagetable(address);
>> +
>> +       if (error_code & X86_PF_RMP)
>> +               sev_dump_rmpentry(pfn);
>>   }
>>
>>   static noinline void
>> --
>> 2.25.1
>>
