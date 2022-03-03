Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB8E4CC29D
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 17:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiCCQ01 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 11:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234493AbiCCQ0X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 11:26:23 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2045.outbound.protection.outlook.com [40.107.92.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE239199E24;
        Thu,  3 Mar 2022 08:25:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCh05X0DhY4LzgWFEqBmZ1UdKOtCBQy1cuFFjinnupm5aOk7wofFlubxr6RobQszpDB2NOgZF9t0pe2q3+lsEGKhqBnriMaK859ttrF9m66fWJCPUcypuT6HUV95DU8RGS7wxUlObNtmJmhxSxGl06rCUxmfddg/nWl1EgY1FEHpTac3hH/tmH0t+JvLKnvvEPIULa0Ah8j3CGRZhRQsp1cMjq3qArQeOZhzvTdTETq3HmRgO73AvbSKiTxwY6bS4z2ft/M2aqUleOsRcNjJuH/OXoQGdwFViR6ZR5MHMq3KLu79+PnBRzoURvkJcCS4ZbhBVx7AZnFZQZDkGGx1ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TL/bDJQs4N9md9jTl/2a6qWDX5TPggEtdqnH8Mb24/s=;
 b=l9wsFz/OgXLRtwaYb8LZ3KtBncrObU0roRJzExd+2IH+sxC37q5dFbc0zG0/mbwPlmNzRpjCWgarbum/V8Gb3shdkU/RbY431a7dfQtRFJCQg8c/f77D5E9VyX3dSCACh90hexdQ8MC0OLjOqJpNhtCCRhd673f+HmrM0OGLYZDK/rw26Nq3K5S5cAQAlWONMP27XnuppeS3dRvUyegQ04pS+045VdQOaW+IbFiCPQv/NkLOJbUPKL/rsc6kvOjG+9JZtkG2+ZyofqWn9NUZbMv9GOu/eW9fptvk6EjQBeNWHwTG967v+NWflnTZzR1WZmMCmSonuuPZJqW/uLrWXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TL/bDJQs4N9md9jTl/2a6qWDX5TPggEtdqnH8Mb24/s=;
 b=x81gEkz91vHdecGatUaEkGZLpaX6axDwzIlMHkV4w4nEgEf6+mF04aQZQ3zONmQG28IvYAPlWqQSBuU2vBla+nhXU9tLRgQUzXUjCww3tWb8lrTFRdgOOl0TIYxR3SUqE+UPRfGDVPyeAo4TlY7aMSnweB144Qi2UEMKr5JsrB4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN2PR12MB3053.namprd12.prod.outlook.com (2603:10b6:208:c7::24)
 by MN2PR12MB3757.namprd12.prod.outlook.com (2603:10b6:208:15a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 16:25:34 +0000
Received: from MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b]) by MN2PR12MB3053.namprd12.prod.outlook.com
 ([fe80::9117:ca88:805a:6d5b%4]) with mapi id 15.20.5038.015; Thu, 3 Mar 2022
 16:25:34 +0000
Message-ID: <54d94539-a14f-49d7-e4f3-092f76045b33@amd.com>
Date:   Thu, 3 Mar 2022 21:55:16 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 3/3] KVM: x86/pmu: Segregate Intel and AMD specific logic
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>
Cc:     Like Xu <like.xu.linux@gmail.com>, seanjc@google.com,
        dave.hansen@linux.intel.com, peterz@infradead.org,
        alexander.shishkin@linux.intel.com, eranian@google.com,
        daviddunn@google.com, ak@linux.intel.com,
        kan.liang@linux.intel.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kim.phillips@amd.com,
        santosh.shukla@amd.com,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>, Ravi Bangoria <ravi.bangoria@amd.com>
References: <20220221073140.10618-1-ravi.bangoria@amd.com>
 <20220221073140.10618-4-ravi.bangoria@amd.com>
 <1e0fc70a-1135-1845-b534-79f409e0c29d@gmail.com>
 <80fce7df-d387-773d-ad7d-3540c2d411d1@amd.com>
 <CALMp9eQtW6SWG83rJa0jKt7ciHPiRbvEyCi2CDNkQ-FJC+ZLjA@mail.gmail.com>
From:   Ravi Bangoria <ravi.bangoria@amd.com>
In-Reply-To: <CALMp9eQtW6SWG83rJa0jKt7ciHPiRbvEyCi2CDNkQ-FJC+ZLjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BM1PR01CA0093.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1::33) To MN2PR12MB3053.namprd12.prod.outlook.com
 (2603:10b6:208:c7::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d749c04d-d21e-4d4c-8b51-08d9fd3270b8
X-MS-TrafficTypeDiagnostic: MN2PR12MB3757:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB375793CC87A8D8C5F59F5905E0049@MN2PR12MB3757.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dcI2ZUk0pS6D5FTasFman8xdmfOFhkn9VKJ0xsYPzDerwbpp8ouYlIVhYYH5/lEGXkuiD+WRzNVrI53xK7PEntpTmfeuFWtxAsDpP1SnrCDE5aw/xnKdmFYtJdnOnYOH+WqFAhupm5tCT+DH/SsjsJTJK3IA2W49gQDh9lmfIWg2y/Ut0osI9zpOUdNrfaty23Cx+u+Oc+HngkqDXcWYuaKXcFUgP0GeFK+sMo759Pttwdupfr4wBSquNBdKDDd8c2uBNw/LA8c23JdI1VwkkRXOQx6u8wFpieNN4u1sBnoPJT8PZurRZ9Mg1nqQI4cRAoQXO9qItQvW65eDBIiGUNEx2kPHA/dYdEVX6Ho6EsqnHCaIdjUxvZd21/ZQ4sANOYpDurIzkR5g+fLCj60BfDFy8Hs6kGBJvkTF5QSn7yJawgSx45BDLhCgK+2TECcRaf7q10e55jcSzd59X93sYKE99gYxpBbIvwXpeSRDwg94uZx8FZLhWJ7HHmFsroYVZ3KxE2bc3Pz+tUJKDD/VxaAoTcfzOMSgG5Y5qLWGGB2UAXPYfZrTXOloAp8qT0apj6tZz1b32nZlQchDC6lbd48NDCrPVnn9nX7DXLh242S/DZx6Qe36q1vOAFBan2d+9ee6jaBh8iDSNewIc1Gq5htuCNa8J+zBJ8jeb6XWsUS0yTzlZF7SAXhjGeSQLOb2TS0SjKVzCLyhvjbtuB4ZbI8ID/0VomeqvWfx0d3ELY+l2h9Xx8ckHshAjg+CQ/+R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3053.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(6916009)(38100700002)(508600001)(8936002)(8676002)(6486002)(7416002)(316002)(36756003)(66476007)(66556008)(66946007)(6666004)(44832011)(31686004)(5660300002)(4326008)(6512007)(2616005)(6506007)(186003)(26005)(2906002)(53546011)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2Fkb1Q3MkRkRmo1ei9uNmFMTThWL2VzTTZtWTFnRTM1ZlhUd2ZoNlRFbXdl?=
 =?utf-8?B?NUhETmpHL2xXZDNoenk4eHB2WUlQQU5hbmhRWDlVTlJITGdHSTY3RW8wNGFa?=
 =?utf-8?B?UjRFU05mdFBLQWhjUmFXWCtrdEtVYUlJZ1VCbGZ2aVZZWUF6dUw4RHB6dzl4?=
 =?utf-8?B?dWY5ZkxES0h6NWRKVHJHT3QxUFRqdEtxcHBCSmlmREJ5NCtBZTJLYytNTERX?=
 =?utf-8?B?WFZ5YmdLcTltazhEOUlVU3lUVGlEdmIxcmtoOTQvbzhMeHhLS1BneS8xVFJ1?=
 =?utf-8?B?TmZMTUROTDhRb0xDWUo5Z1NINUI2eDVaZ3FjbVBSU2NnZTlIMVZYT2lPQnhW?=
 =?utf-8?B?Tm1lRGltSUJqc0p1M2ZvWWxuZXU2L01kb1FidFRCVFRwRDJqZlhxUXpjM3FV?=
 =?utf-8?B?anJ3Ukt2UFdnWVZDOUdMUzEyQWo2NDRyelhPdFZXbXZHaERjVUVKMUZmYnQv?=
 =?utf-8?B?S2p4MVhEOG9rQVNzMjdCQUMxejVmejRaZGJaeFRTZzJwSkluSEtWaVhMaGdW?=
 =?utf-8?B?UERDQkYzODA1TVYxaXlJWHM2bCtramQ3N0JMb0lDMzRhdVpsVVp5d3grZW1E?=
 =?utf-8?B?ZEVrK1RGd2dqb2xsOHlSWlRZbmdrZG9NblczT0ZnRVRTYmZMdlpDaWtpN0Q4?=
 =?utf-8?B?em9MWWxnY3VrbUNyekdabXFuNW1TdDhVRGpDWWY5NkU5Wis5ZWRTcHlFcUtn?=
 =?utf-8?B?Y0lKVlFFemhCc1dkZWUyT0xrVno5Zk9IOHIxZGNvelNpdk9yT2xJRC9wSHZ0?=
 =?utf-8?B?ZThDWDJadE81cHFCY3BoU1FCdzI5a1FSd3VFdFdGYU52QTFJM2NOcFY3ZFN6?=
 =?utf-8?B?VmtOMDlzTkg1WmFJNW1uWXFUQjFjaWd3N0dYOXBwckxJUnh3Z3ZYempJYVVC?=
 =?utf-8?B?T0F4YkptSThMTE9NaFQ2WTZzVUFHWkJ6Z0p2dno1ZHEwSHRnNFFSVHdKYUtZ?=
 =?utf-8?B?cFZ3ZFVpSjhTWG4yL0ZCczNxbHdpdk9sQmlSTFE0KzUxTldnREhCcGJ4cWRp?=
 =?utf-8?B?c2JKZ3V0ajNUQVAzbzI1ZE84NVY3VHpTc2gzN0xhQTJRelIyQlJyVmhITUpJ?=
 =?utf-8?B?QkJha2N5dlcrM2FrL0NrbDZYM2t0UlpibTdnK0tsVmYvVG9qQ0xsTjU0R2Jn?=
 =?utf-8?B?REs2WTRjTml6cHF6Ty9NRTA5aU1mbkladDNrOEkzb2g0akVRMVVzYmNtdXlz?=
 =?utf-8?B?dU16b0xJRWVFTmpjWFlpNXBjaVpkaytrZitTSEd2d3l2ckpYVUI0cS8zZUtv?=
 =?utf-8?B?anhVSm5jdjJXUWlDKzUzTy9tN3oxc0FVaTJoWUd6L0R6YU56UUd0MllkOFJV?=
 =?utf-8?B?MTlJRU9hdnlRMlhvSElJaWlsR082clJPT1ZrcUUzSFRNdXVpVm9vL3Zhb0Rl?=
 =?utf-8?B?WU94ME5ac3YzWXFFTUNvK0VsODdOTnlQZzgrMWZaTzdnSVZCVjc4SllmR050?=
 =?utf-8?B?UUI2ZWF3VnljdUhyWEI4NHk0MFY1M3VUV1MxWlNRamYvR3JkeGRVR1hQcjFy?=
 =?utf-8?B?Y2FEMWMxc0JyRlBnZ1pteEZ5cnplMTh4YWZSQXdvM1ppR3FZUkpuZHUyL29B?=
 =?utf-8?B?c1RTc2xKTVpOMTF3VCtJYUZsR3laT29JMksyK2ltRGY3ZUppcWRjc0RiaHRy?=
 =?utf-8?B?VWFxcVRtSjZxQmpFZ2s4QlRoLzMxdWd5T2dVTFNQelVNaWRYUlZYVDR0UWZ1?=
 =?utf-8?B?d1FIbHlReE81dm5LQ0hIWUdyajRFZmhzMU5HMWN0YkJJVWtqcmlqUm9WcTJx?=
 =?utf-8?B?ZEpMRVVwR1BwYzJzYjFSUmNkUU1GSjI3dXNNRG5sb1A3dHBEZ1ZBQXB5T2ts?=
 =?utf-8?B?NnhXb2RmY05rRS8vL0d4Zkl1bGNKdU5oUkZnUzBCN1pVcGhFL0g3UGlrQ2Yr?=
 =?utf-8?B?aXNQSGhYT1RwQ2FDQWJPRzUzZ29Lb0lVNmxMRHVwSzRYdEhFekcyRzdLK0xU?=
 =?utf-8?B?MU03eldwZG1rRVpyT0puVW51dEZMNTFWR2xIRWJoTWJoSHZwelh3SUd6M3BR?=
 =?utf-8?B?amUyTnJLVmthdEtEZVdFK3BscnJ6TmNMSlJXQ0xKTmNNcEpreTJxZSt2M2JL?=
 =?utf-8?B?OVBDOW1ZRy9rcm5JeTlMQ1ZoT1JqaXEwQVZNT2NNVmtmOHBoZVJ4anNXTmtY?=
 =?utf-8?B?c3RDWWxiTitsajNtL3FlZzZROXFsa2JmeHZHNk02MDBMcVVjUUNWOXpHS21O?=
 =?utf-8?Q?USEG8RuVAk2GdCWhST1jZr8=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d749c04d-d21e-4d4c-8b51-08d9fd3270b8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3053.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 16:25:33.4876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e128FVB5TW8wY0db+fP4/mBa+KiD02VHbH6xNMeWJ23bUC2+lvFUIusI0Zlbmk5ekgAsXjFjoVoQtpTgUL07EQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3757
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 03-Mar-22 10:08 AM, Jim Mattson wrote:
> On Mon, Feb 21, 2022 at 2:02 AM Ravi Bangoria <ravi.bangoria@amd.com> wrote:
>>
>>
>>
>> On 21-Feb-22 1:27 PM, Like Xu wrote:
>>> On 21/2/2022 3:31 pm, Ravi Bangoria wrote:
>>>>   void reprogram_counter(struct kvm_pmu *pmu, int pmc_idx)
>>>>   {
>>>>       struct kvm_pmc *pmc = kvm_x86_ops.pmu_ops->pmc_idx_to_pmc(pmu, pmc_idx);
>>>> +    bool is_intel = !strncmp(kvm_x86_ops.name, "kvm_intel", 9);
>>>
>>> How about using guest_cpuid_is_intel(vcpu)
>>
>> Yeah, that's better then strncmp().
>>
>>> directly in the reprogram_gp_counter() ?
>>
>> We need this flag in reprogram_fixed_counter() as well.
> 
> Explicit "is_intel" checks in any form seem clumsy,

Indeed. However introducing arch specific callback for such tiny
logic seemed overkill to me. So thought to just do it this way.

> since we have
> already put some effort into abstracting away the implementation
> differences in struct kvm_pmu. It seems like these differences could
> be handled by adding three masks to that structure: the "raw event
> mask" (i.e. event selector and unit mask), the hsw_in_tx mask, and the
> hsw_in_tx_checkpointed mask.

struct kvm_pmu is arch independent. You mean struct kvm_pmu_ops?

> 
> These changes should also be coordinated with Like's series that
> eliminates all of the PERF_TYPE_HARDWARE nonsense.

I'll rebase this on Like's patch series.

Thanks,
Ravi
