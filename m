Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0D954A321
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 02:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbiFNAVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jun 2022 20:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiFNAVd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jun 2022 20:21:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2047.outbound.protection.outlook.com [40.107.223.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1AD2314F;
        Mon, 13 Jun 2022 17:21:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fY3zDCvzO1upNxJIxpFPZH5YEc5uWt/ldxWJj0MqZ8UiMxtlmUqJ/pVRJXILoqaWDRZ83xi4jJMQhDh2zwYrdwwlAs9Do9rWLai5SjCED92BvQx7I/+9jOkWHIEGRzo/kVnbGVH2OhhB0E1rVGeXfJsAeRY4L6TmxuyfUKWSPLmKdlaXLDkbpz1zTlty4Hgu07/UQa90+f4ctct3/+usJ/ZH4X1zLVv0FDfExUqXY0w+G/5k/YISm2Gxb5Z+SWPYX4MsK/TXZWo0/7pj0YT9AS1Eaof2/6qpOP7dzQ41IgcWvN80ez0oIuG+VvM3DLEkANWhr6AIw0Eiebf7dqsMog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KnZmZsinsso3errp/WXeQwVC/7Z6BG3l/m32W7RWYmc=;
 b=LjRXqHJ1TgPUUT7vDShD8TCVUBoovj23nllsknt2rymBH7yJBzqU3Y1LJii1tTeM7IP+ppyZtHYurnQ4mzCHBgro7HZQr6LmmMYvdFj7YGKFztP4WJ+phk8OzmMurQJbkWPGzuefINOXcJcxQh1ukb5dj3Vl2F5TmP6cWZ+kHeJezIrjtyVP7Lx/+D60D9+vnmDAH9ukFcIbIi7SHhQk79Cir9dMAeya9i6qIKsZ+gOvgF+Wdp7IK+jgWkm/YaOlJz8DrOkaQ7KvBEy5QxGqR97rfFOxDIpjpXTZcWWuGLRqbNEMrg7IUg+yDG9GSh6ED+Iy3TqOxPVi8vDhwxmn+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnZmZsinsso3errp/WXeQwVC/7Z6BG3l/m32W7RWYmc=;
 b=OBtcgy/w9i5x8TVJPPw4k20JOOLCZj0wGRdh2HMncv0etmucNCohc2Mfq2R8WBtj+vdVbSxJVtP32sytO+0byVqBFccFGCFY2k+uKOrGzm7BDjDtF4t3X3qU0bINzC1OcGHxFkxLaRouQnOWGidVaKGL1b2s85sQyKvMZpTQ0rc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by MWHPR12MB1552.namprd12.prod.outlook.com (2603:10b6:301:a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.20; Tue, 14 Jun
 2022 00:21:23 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::810a:e508:3491:1b93%2]) with mapi id 15.20.5332.020; Tue, 14 Jun 2022
 00:21:22 +0000
Message-ID: <ee1a829f-9a89-e447-d182-877d4033c96a@amd.com>
Date:   Tue, 14 Jun 2022 00:21:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH Part2 v5 23/45] KVM: SVM: Add KVM_SNP_INIT command
Content-Language: en-US
To:     Alper Gun <alpergun@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>, Ashish.Kalra@amd.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        Marc Orr <marcorr@google.com>,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        Pavan Kumar Paluri <papaluri@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-24-brijesh.singh@amd.com>
 <CABpDEukdrEbXjOF_QuZqUMQndYx=zVM4s2o-oN_wb2L_HCrONg@mail.gmail.com>
 <1cadca0d-c3dc-68ed-075f-f88ccb0ccc0a@amd.com>
 <CABpDEun0rjrNVCGZDXd8SO3tfZi-2ku3mit2XMGLwCsijbF9tg@mail.gmail.com>
From:   Ashish Kalra <ashkalra@amd.com>
In-Reply-To: <CABpDEun0rjrNVCGZDXd8SO3tfZi-2ku3mit2XMGLwCsijbF9tg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR19CA0019.namprd19.prod.outlook.com
 (2603:10b6:208:178::32) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d83a4eb-78d6-4bd6-7266-08da4d9bcfb1
X-MS-TrafficTypeDiagnostic: MWHPR12MB1552:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB15521D0FE2EB3F39276238E78EAA9@MWHPR12MB1552.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MWeuJuuyRYJ6sI5hLdcvSSHLfuiio+KXQhzdphvTJNGaU+5AaEtSS8leKj2p1Fzebh6URq23GLRhG6Hx5cJFy2USLW49tmvIWTpXl7wVcw1PoZ/STWrtWRzhgjsyPstZdDIrqODaSMUwIn7tVpTnO++2o0feuua5e6xvK7W6hy01QO8Sy8/Oj+n2J33ZNtorAABc3G4uZS1sjIvu8+3SnD4J57/mf1VF3vtq5Yfu+Xae4AXyxnEdyZ3BkRdAsyt1cfV+5hrGkgJLXPbgKU1qrri7lMyg5IdYBQv8QdN4q0EuL37ENMs9zkG5imghbo03Av7QSHUSN2cNVfSVODElMd2aSbZnaT8LA2V/EPWaOltQMqnJMHXqlNS1UHTswFcG6jcFk0pzl6FoKldn/2jt09RP4uJB5Bmx8K1Fv/t5jvY8t7bPqCOEELePlmNaKrlUowJUojEHAdLG4HfQnS5PMBwzftk9Eu0CRAOpAkAhZARvZbVV90tZSl9j0ucE5DYp2JPcd05edUaQ3UHyk4k1K7BSwOTl4JjUg5EbiBUkdzULPW/PlmO6o9nJbFjIPXSnL4eAtSlnenW45YhotHsefGCe2h/AWo/CRkBS45yYE8LvBoYxICavS2l5bA/oHWQf88f11a4Mp6vGs0HCb313q47AFT7hbyWrfZg7AjhEo/PPf/YxNwhEXbvnydNBMDrla5GSMQ4bWAVe8WBbEpiWvmjAR/cUOUY4M95z97YkfTA5YYHVEgXtg7k9a1DjmGrz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(36756003)(4326008)(8676002)(31686004)(7416002)(7406005)(5660300002)(66556008)(66476007)(66946007)(6486002)(316002)(2906002)(8936002)(31696002)(6916009)(186003)(508600001)(54906003)(2616005)(6666004)(53546011)(6506007)(6512007)(83380400001)(38100700002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG9jOVl4VFFzcEN3UXpqdDliZStGMWsyd2ZlWlY4WUZ4TnVTVUh0TEQ0Yjlp?=
 =?utf-8?B?cjFSOEE2NHo1Zy9IQURGUmNFdkJhVG9mY29EZU9Mak0zREt3L2tVQXYzU1NL?=
 =?utf-8?B?eXdmS2tETWh2UTk3UElKSlVTNzN4SE0xR3dVYnhNOHZoMFRjQUNrcy92N1E1?=
 =?utf-8?B?VXZLY054dGtneW43OUY2MkFsbTNyQW05aERCNGo4QUxudWdyZ29JK2dnaHJS?=
 =?utf-8?B?N0dWemoxY1hEeGphaXdBSFhQVzFKSmFIVG05STVROEF1b0tsRkpwRnBnZVdo?=
 =?utf-8?B?azEzLzdCNHhOZ09ZUmJ4UnBlLzY0RmVVeGRqeVFSNllteTZwQktGSzJJT3RU?=
 =?utf-8?B?YnMyMTFSb1NSbmVyT3I2V21MSW8rbEwxYzY1ZTQ1cTRFcWRseDV3eStxVlpW?=
 =?utf-8?B?SHljeVZOQ01ndVRjUkxicjNLV2xRWTdlVWJZejQvbEE5VGVKbVl3YkdVVHE2?=
 =?utf-8?B?T3lMMm9ncDRIMEtCdTNmc1lOVzNFaDZobktLdEQ0WG5kTlJwUFN2N3UwWnFT?=
 =?utf-8?B?U0pUcnFhaVpuVFpDcmswRXh5N3JrSTl4MmVDSTd6QTFKYjY1RWxVdDQ5RzZH?=
 =?utf-8?B?SDM1REM5NTVqUEFzTEQydnZ3MW5wUmlxRkpuaEd6UlVsMXdTd0haWVdhRzMx?=
 =?utf-8?B?SDdNd3FGc2prTzUzK2ZqZnZoWkpwcFVWd0V5MmJWZGdCaHJ2MzNLam5UalFu?=
 =?utf-8?B?dUxwbExIZ1ZoVXVNeHF3alVRcHVRdndPQytuZFNtdDkzUDY3cTVPb0Z6TG1U?=
 =?utf-8?B?cHYyT2FVL1d3SE1aM2hTeWlBR0NZbEdVQmRSaldROUhQa1VCOWVZUEpZbkZz?=
 =?utf-8?B?bmw2WW1raC9sY1lnQWZmQTBxQi90ODJMWGJ1K2RlVVhGZlFLOW5NOE5PckM3?=
 =?utf-8?B?Y0VmZ3BBREIzL2c1VXM3ZjRyUEdDL3QzVFBtQVhYOUtpV3FuV2NVSXZYM1RE?=
 =?utf-8?B?NGd5c2s3bXc3YUNjUHhDTTdZM2Qxc2Q3RS9vWVNublRjbVFxenJqOWIxcFRa?=
 =?utf-8?B?R2tidGNIQVZ0aVFmb1R2ZlBkbzdqVGJOckxUQmJYZTYzcFpyZmk5K3BHNlNR?=
 =?utf-8?B?WjJWaUN1bzNTMGJIQmpaVGV4UEF3b1VRZjhHbXhhMXc3ODJJS0pJejFvY1ps?=
 =?utf-8?B?bm5INkw1dEVpZ01JaHBFcHRtait1VGxLWFk5YTdTZy9IcEVBWnBoVCtHQ3Z4?=
 =?utf-8?B?UTgvSEF5Ym9EaGVUNUI1SFc1c0dEem9rZXIyRjYzRUhCdXVXYlVLMHZEQ1l6?=
 =?utf-8?B?VXh4RTAzdGJYN3orY1l1QzVzb0tROUxvR0hjbmpvdTlta05TejYvZEovbXdG?=
 =?utf-8?B?R05UMGhuNnREZVl3dUw5UXJ2UnR0NStnR1B0R0VLRXkwbkxNRUZwZXl4YWk4?=
 =?utf-8?B?RElGWWY5aEQ2VFNKekk4cTVNQ1NGS1VCa28wbVNIUGxsZzd6K015Umd6cUl1?=
 =?utf-8?B?M2YzMGI5V0lrQjhuQnJicXA3TytZWkJPb2YxWHRSN29kY0Q2alNqTnd1dTBS?=
 =?utf-8?B?Sy9QenFIbUQxbzRSTHAwZFRGZmlHbEdxZGo3VnBiazMyUlZ3VmFzRnNOYUtV?=
 =?utf-8?B?aklTbS9scG5kcVBJczh4VnZzYTY0Tm5FRHVvNW1GY0hvNjZSNzhQTU8zWXox?=
 =?utf-8?B?NndGL0ZzZnN3UWgvVE1ycTR6WkMvTDZmSmY4UEV4MzJMMnMxa3g4TEdkNGtK?=
 =?utf-8?B?LzBmUHhuaWVtOVNaWXBhVnFzVXdicXRRM1p4aVZieGJzeGd0L09VK3IxY1BJ?=
 =?utf-8?B?Q2ZxMjZPa0t6UURyZUVyUmpoQjNjOUNZQmsvYnlmZGk2WURYSHord2dVNHIr?=
 =?utf-8?B?bWtES0Q3K3BNellzYUxtV1hmSStrZTVFVGhhekhHMWc2K0w4MFZQaDY1Z29Z?=
 =?utf-8?B?MEhwZTg2VFZ2OXl0ZVFBMVMwZnB3R2Z4QkZZdGVSbk9xcEx6L0p3S2lEUjl2?=
 =?utf-8?B?N29EK1g0Nm54NmlHSUhldVJRd01wUUQyZGZuSGtkczk3NEJWRCtlVkhEMjMw?=
 =?utf-8?B?S3hVeGdlTlRKcWZrWUdmaTVDbXBlWHJwVGN4eFZTSm8xS05LUEovR1EvdWR2?=
 =?utf-8?B?S3hpUmJyTklLMXFXbUYrK21vYTRLMXM4TXdmK2xXSmdERkhtM3J4UmFQN2Nz?=
 =?utf-8?B?OTVjOFpvUExWbVRQZ3ZSbzJWS0MzUTJYMEhGYzlOczlXZ042cTE4SHFxUW4z?=
 =?utf-8?B?aXBodm5DSGpMZ0pVd0dPRElCSGp0M0V4NFppTXo4R2Nic1hBSWMrWXhQd3Rz?=
 =?utf-8?B?LzBsZ1RUbnAwMVlNejR1amtvaUcwYjU3QjVOZUFUSVN6V2IrQzE5c2FvVHNW?=
 =?utf-8?B?THVCTkFEYitQTW16WFk4MFRhMElWQk53cGZuanE2QVFhNE8xR1d3QT09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d83a4eb-78d6-4bd6-7266-08da4d9bcfb1
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2022 00:21:22.8316
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obNi8Bh1gyecFZQ2S7Q9T845A1uehELk+zRFmpHtFqnKUFtoM+1bWcc/cOIblOkhsWUeAZGzvddm6Gzc/sGV3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1552
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/13/22 23:33, Alper Gun wrote:
> On Mon, Jun 13, 2022 at 4:15 PM Ashish Kalra <ashkalra@amd.com> wrote:
>> Hello Alper,
>>
>> On 6/13/22 20:58, Alper Gun wrote:
>>> static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>    {
>>>> +       bool es_active = (argp->id == KVM_SEV_ES_INIT || argp->id == KVM_SEV_SNP_INIT);
>>>>           struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> -       bool es_active = argp->id == KVM_SEV_ES_INIT;
>>>> +       bool snp_active = argp->id == KVM_SEV_SNP_INIT;
>>>>           int asid, ret;
>>>>
>>>>           if (kvm->created_vcpus)
>>>> @@ -249,12 +269,22 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>                   return ret;
>>>>
>>>>           sev->es_active = es_active;
>>>> +       sev->snp_active = snp_active;
>>>>           asid = sev_asid_new(sev);
>>>>           if (asid < 0)
>>>>                   goto e_no_asid;
>>>>           sev->asid = asid;
>>>>
>>>> -       ret = sev_platform_init(&argp->error);
>>>> +       if (snp_active) {
>>>> +               ret = verify_snp_init_flags(kvm, argp);
>>>> +               if (ret)
>>>> +                       goto e_free;
>>>> +
>>>> +               ret = sev_snp_init(&argp->error);
>>>> +       } else {
>>>> +               ret = sev_platform_init(&argp->error);
>>> After SEV INIT_EX support patches, SEV may be initialized in the platform late.
>>> In my tests, if SEV has not been initialized in the platform yet, SNP
>>> VMs fail with SEV_DF_FLUSH required error. I tried calling
>>> SEV_DF_FLUSH right after the SNP platform init but this time it failed
>>> later on the SNP launch update command with SEV_RET_INVALID_PARAM
>>> error. Looks like there is another dependency on SEV platform
>>> initialization.
>>>
>>> Calling sev_platform_init for SNP VMs fixes the problem in our tests.
>> Trying to get some more context for this issue.
>>
>> When you say after SEV_INIT_EX support patches, SEV may be initialized
>> in the platform late, do you mean sev_pci_init()->sev_snp_init() ...
>> sev_platform_init() code path has still not executed on the host BSP ?
>>
> Correct, INIT_EX requires the file system to be ready and there is a
> ccp module param to call it only when needed.
>
> MODULE_PARM_DESC(psp_init_on_probe, " if true, the PSP will be
> initialized on module init. Else the PSP will be initialized on the
> first command requiring it");
>
> If this module param is false, it won't initialize SEV on the platform
> until the first SEV VM.
>
Ok, that makes sense.

So the fix will be to call sev_platform_init() unconditionally here in 
sev_guest_init(), and both sev_snp_init() and sev_platform_init() are 
protected from being called again, so there won't be any issues if these 
functions are invoked again at SNP/SEV VM launch if they have been 
invoked earlier during module init.

Thanks, Ashish

