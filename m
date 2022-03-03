Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB7B4CB4BE
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 03:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiCCCND (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 21:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiCCCNB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 21:13:01 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2074.outbound.protection.outlook.com [40.107.96.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66033FD10;
        Wed,  2 Mar 2022 18:12:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Beeaw3n5nZo9yfFJFin+6A6WMGHuG/LU1Nut1j00gJdOnRz/23CRACg7CZy0tniJ7/X8zyTL2U2WOtyOsdALAN44Hb/Gr8gmUg2t7LN3GnRkuYqVPS10fXnZsBFppxIrdN3FJvwj1mtI9lOib8Anm+WewUDptpmnAv14SrX7eupH7AQqFNQns5uJT8x1o8bDSSwcY7kf/svX5UW5ZyLOQ0raJEARw1Hw4p7MWK3kvsD1Pqo1hhgRg07pYBHBR+ATUAqfzLoi2ii0PUj9UiFfElPuo4l4fSx8aiNVBtyuQV5Bzh7S1407KkeCOUMEb9DQ9i/ay18UgGbyAXqLnLuOUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E+hF+k0qXX7SceswlDEuJraPyQrgz9l7cAoJCGkPDOI=;
 b=h8bUqgcpbTSrxBhMG6P/ZV0jbiMkKjpDly5eRv6FfEchy6f+47k0lWNoVfA4femCVEyFxptTXV1eQxVSMVAcASkn+Z4sSaWUileBnBpXPfTo3De5/jhS6LJb+LB8OTjqLEzMQGRIaQEzKi6kJ6FN4L52hyFIwJMrSyfCV1WLp4cqykDpTtX9wpg16hFbj987x9UEf56faoReJIeFu5/Q2MlQaO0/FgiyZn6nLhFJGC9SL8K0snvsahWH+Nh7NbBxbP5Ni+y4XQppWfZYONouuAs6moH17ste4PNiTBuwb2PQgaKZ2najLnpMNTt6NTzC3u7ZL8DbdmoZ3Wuu2Huwhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E+hF+k0qXX7SceswlDEuJraPyQrgz9l7cAoJCGkPDOI=;
 b=B+e99IBFXVxkC9+Onp0SOfqaqJs7L2eW2X8fOAUqsTWoCs0hZFpoRMRwt6LuFQYaYNjwsxhxwZbzqSYeQO5jVjCrDSIRK4BO6BzuO1w4JYqbBln2AlZ7hjCsupoKNxdrmFtA5mqsn7KyVOkMTlD95PHoPoVD2PTw7ZjcJ5kvzww=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 02:12:12 +0000
Received: from PH0PR12MB5452.namprd12.prod.outlook.com
 ([fe80::758b:8db2:a518:ad56]) by PH0PR12MB5452.namprd12.prod.outlook.com
 ([fe80::758b:8db2:a518:ad56%9]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 02:12:12 +0000
Message-ID: <071b523e-9b61-f96d-5c98-7e7572643d8a@amd.com>
Date:   Thu, 3 Mar 2022 09:12:01 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [RFC PATCH 06/13] KVM: SVM: Add logic to determine x2APIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220221021922.733373-1-suravee.suthikulpanit@amd.com>
 <20220221021922.733373-7-suravee.suthikulpanit@amd.com>
 <334aadda53c7837d71e7c9d11b772a4a66b58df3.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <334aadda53c7837d71e7c9d11b772a4a66b58df3.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2PR02CA0128.apcprd02.prod.outlook.com
 (2603:1096:202:16::12) To PH0PR12MB5452.namprd12.prod.outlook.com
 (2603:10b6:510:d7::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea114ffc-dee9-446d-b5cd-08d9fcbb3a21
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR12MB54390D5B7D1B3250785A90C2F3049@SJ0PR12MB5439.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l6cduFz+7nECjQiowpUoeKAKj77SydCVPZcm80F8r0zgcNNGlIYVnm8ce2N2dyt/U4Yk16M9uKQ9m0njUyWbL4EzJr2NiO86LMc033pgAXXPG0u2rYuY1Bq/qiIJAmm6G56ROZHoYLMUPCGXZvK35Ip0xU7z1Qydqck/C/B6ANgc+4O0e9jsRjez9UP2ggw9aqm1CQIQn1nElavC0yNY/rQhSkcYqjT/0g/P6kRb2aRw5WgYHuqzc3E04j6gnrCH7oLCnKfiCq1bwloKzenB+buLYY24z5pY0f5Bhaxu1S4vrQvXzj0XOV5dk1tGAokGzGNUmxTVW4dJixJx7cJN4ItoJaZklKttHCviXxhnyHdMAu6RaIfSN70EU94qbHF5WnL8l92v+qwyMlsC1gSuj/wnSSOy2kkcE1OXRXGO585sq1noigr1RDMPymhpHnmm0MIqWr1yzMSzQlZIllAGdHWutLITwJoXxTrz+B3/ZQ51jZp2U4F7W2cyYGD9xB5yW5CSoKRhdtqqr7L40iWUxUf1hvgqqaraoPUgK2nQTCHIQLbGOjsy9Vq6RG7wm7QBQqOfd34dTy46AihdXZTp1M8pEzjJ68KkbtFmYV7W8PipxwdR0RXAQPkTHqtkFsk138zAjInpuEhOUeiv3QL0Ebw5fTh+AJoNqVFxh7VzDJTDLP7MMJymT7pZgys4IUXToGLMZNb3HvrIFn3o4WyttTWAaqoo/i/UdqCLnubKT14=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5452.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(8936002)(31686004)(8676002)(66476007)(6486002)(4326008)(26005)(86362001)(5660300002)(508600001)(36756003)(6666004)(66946007)(66556008)(31696002)(83380400001)(6512007)(2906002)(53546011)(6506007)(38100700002)(186003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1FhQzFnODkzSXd6Mm5FalpBZkpVVHgrdTBzTTdJek5hVm45ZkgzcEQ4NjBn?=
 =?utf-8?B?M0N4d3BTSVRCQkVQaUg4V0ZOQ1pPVXM2dWhlcWlrTjA3QkZ5K1B5VDd5QWJC?=
 =?utf-8?B?cnRvK0tiS3VZbTJ1SHNXa0dwWi9ZZzFmMVpuTkZQc2tJb09JNkIzV0s0YTJV?=
 =?utf-8?B?MXJNLzBwOS8vTWx6Mm9yem5abVk5SkxpSVh3RXh2bS9pa3c2aVZTaStSaDlP?=
 =?utf-8?B?K2RsQm8yNEJZelNFcEMzZURPS3U0bVBuMDZIeG8wU01FWnFTYkExVW01R2xU?=
 =?utf-8?B?Q2tPTE45SFdoZ2d5NTdDT0pEWEFNT3hhdXU4a3pXMmF1ZHJ0R0c4QnZCVzFS?=
 =?utf-8?B?aVhhTjdldW8zUkMybUhsUVdLRXdGS2hlN3pnWC9TT0VXV1VLYUFudWNPZ0lB?=
 =?utf-8?B?SkgvQ051NXB6eWlaNjBqTStUVEJWY2hrMU5OWFJETk1XdU03UlFTaUFjUC9t?=
 =?utf-8?B?ZVpaNjJ0V1VuVVE0KzNsZ3AwbjhLOHFOQmVnazNkMVRNcUtwTXhIbkN5VkpM?=
 =?utf-8?B?VGxQdGwxMWR4eTlLMDZ2WE9KOW5TcE80QWxhNHZCc2tkY3VwKy9oNzFMdFNU?=
 =?utf-8?B?aVp6VXdKUHNyNExlYVBqbG5IclpMUUllZXl0SXNZVVhwRHZ2eWl6a0VZTkhL?=
 =?utf-8?B?RjNZZzFjVnQ4aEl4REpYOVRmSW5MUVlvNm9welovT21MVGpyUVp2WWdjSWFZ?=
 =?utf-8?B?U0pGTEtGVTVPK2xFUzVaanJ4UHVMbVJYUWtzTkhIRi9uR2xRQkhmLzZ5RUd0?=
 =?utf-8?B?ZG14b3BYU0x5TWhUSGdsSkhhSlduWGxsRTd4RWtnb2QwaU9vdVRmOGdkeU9x?=
 =?utf-8?B?SnByajc2WG9Lb2UwV3NZcm5RZWhDMmkvMVE2VkJGekZ2M1QzUDBCaTFFRFhX?=
 =?utf-8?B?QjVnRG5FaXBUcTJ6KzdBMzY1cDZ6VytnK04rY3AxSmExdkNFc1oxS1d6TjlK?=
 =?utf-8?B?bldhOWphWDh1cmJjZkxWaFFDRlhRWlBEUUVTVDNjV2NLSmtOV25YZGg0UWc3?=
 =?utf-8?B?bmxNMnRxaEpOYW4wL3VaTTFPQzZaSkhCbHBLMWhhemJxV3lJVVAxTkhDdWZj?=
 =?utf-8?B?N0xIYlFwbFFScllKRldSQ1RxbE54Z3FHSTk5STZMMG9pSG9NTHI4WTZvc2Qv?=
 =?utf-8?B?YzE1V2UwbXNVbnU0aTU3NHRsQS80QjkxelE0YmdBRDdCeHdjR0ZoOGtvZG5s?=
 =?utf-8?B?M0pUb1N1dFRZZ0thY081cnR2Y0hwTkltMk9EQWR2WlMrL1dpcmJ1L3NCOUZL?=
 =?utf-8?B?TDZkY25qVThvS3NFOVdMOGJORzNqL2psU0JRaE1McWtJMHViSVI1QVA2cWpS?=
 =?utf-8?B?dlJZWHpGa3UrVm5nUktNWUJNekFlQjJqUkdldDQ5N1hIaS92eGV6VFFNZUQ3?=
 =?utf-8?B?bjZMNXZlWFk2elRIeU5jY21aSnBWTStGeCtSWnNZbzdFV3hpQkR2QjJJcWFY?=
 =?utf-8?B?aUt5cVdsOUtycVVPbDB0VzNCd0toelE4Rmd2bDI1T2VtVFBLZkZ6Y3ZKUVpQ?=
 =?utf-8?B?RjRyTEVPQzQxaDBIbnRRdkQrb0VQWVRXNkdGdGZlakVFN2d6RkQxckdJWnN5?=
 =?utf-8?B?bkYzS2JEY21yU3MvL3RVLzdwZHhuOTQ0YkZZbWRKNGpmU080WC92YXgwWUdo?=
 =?utf-8?B?QmNsaWlxSjhkVTF3MHV2ZnBYeGVxSUlMNXpVMlF5cUJZQjZqQW5ybThkekJx?=
 =?utf-8?B?MjQ0eGU1NHBuNFBvQjRLS3ZDRTg1STB0ZzFoZFA5NEs5WTBGeWpIMURmRlVH?=
 =?utf-8?B?cnR2OERET1MwblpyQVNqVy93SEVWdVovRXlMYXBFYjViZWg5cUxMNXMweXgz?=
 =?utf-8?B?blJ4VjdiUHU4aFVWcVRGb3V5RkljengwZ09hTHFEQktEa2wrMkxVaWZzVStQ?=
 =?utf-8?B?V0thL3RvbW5TZEloVnZwTGlJS3dpa1VCamR5TWZzQXQ0VjE1L3BkaW1KWmNz?=
 =?utf-8?B?bTc1b0pUOGZJaDJkbVRORG5XL3BEeEhSdjEzcFEwSlQyNlcyL3V3bTBMdEJi?=
 =?utf-8?B?dTBGOE0rMDcrMmw1bFk4dWtsNmxPRkxiMFVjcmtaa0xvbEk0TmpGbm5RSVpz?=
 =?utf-8?B?cHZ4Y2VpQVVDTWpMN2xqTHAwcjdQbUtleTFXSUh4SUZVZ3ZZdU1OM1dwVnBV?=
 =?utf-8?B?Nkt5TG9JQTVHTTY5WE9MMUpnU0tRY2RDdjFHR1pBVm1Fdk1iU0h2cUdYaTlX?=
 =?utf-8?Q?W+kpunMKLWwSPYidJ5GzDIM=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea114ffc-dee9-446d-b5cd-08d9fcbb3a21
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5452.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 02:12:12.3862
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aV8P55TsyPAqmYUvAJpRgyc8t87stkWEBjPFdqvyh68izzJGE3FFHrwswdTym+tJ2CSCTPJt/nwXoUu540zRSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Maxim,

On 2/25/2022 12:29 AM, Maxim Levitsky wrote:
>> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
>> index 1a0bf6b853df..bfbebb933da2 100644
>> --- a/arch/x86/kvm/svm/svm.h
>> +++ b/arch/x86/kvm/svm/svm.h
>> @@ -225,6 +225,7 @@ struct vcpu_svm {
>>   	u32 dfr_reg;
>>   	struct page *avic_backing_page;
>>   	u64 *avic_physical_id_cache;
>> +	bool x2apic_enabled;
>>   
>>   	/*
>>   	 * Per-vcpu list of struct amd_svm_iommu_ir:
>> @@ -566,6 +567,7 @@ void avic_init_vmcb(struct vcpu_svm *svm);
>>   int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu);
>>   int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu);
>>   int avic_init_vcpu(struct vcpu_svm *svm);
>> +void avic_update_vapic_bar(struct vcpu_svm *svm, u64 data);
>>   void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
>>   void avic_vcpu_put(struct kvm_vcpu *vcpu);
>>   void avic_post_state_restore(struct kvm_vcpu *vcpu);
> 
> Have you looked at how this is done on Intel's APICv side?
> You need to implement .set_virtual_apic_mode instead.
> (look at vmx_set_virtual_apic_mode)

Actually, that would be better. I'll update this part to use svm_set_virtual_apic_mode,
which is doing nothing at the moment.

Regards,
Suravee
