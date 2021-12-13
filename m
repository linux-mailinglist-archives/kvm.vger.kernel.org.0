Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B20F472A92
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237585AbhLMKrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:47:17 -0500
Received: from mail-bn8nam12on2055.outbound.protection.outlook.com ([40.107.237.55]:63152
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237440AbhLMKrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 05:47:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2x9nkV721y8r9fPCW46LfaA8a4eHYXUg0ySNPGhT1VeiJtmYy343Fw4LhBO2/i7uVnROjgeGH0dYfYjCEHWNmuUiGax398ffQ3bPCJX2YoQQOTxa+7oB9G59y8JKcn9C9sIh68FwXjtt4/pcD85TLrNOwt1mnDpPqFn7on5uYK5fBu9Fpu1BR65mRsIx3r3AbW2KHgl/N+gwkZ7joxmPaGQQ3AejvX5YmOoeMrAkUKJfOHK4mD3EL3Fv7kZ/682cepOMw7jbC/ywTz7JjXM/e9A8atqnC2aXa/1rgCamJ5Z4IN+ul86EYO6ZtGzkk8w4YJjl01TY+pZbWdtamNYFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=51VrP3sswOCJ0zZy58eckSctOYyKfLf3RQdvyRDJPfM=;
 b=P43o7EG/+y/NkUHITrTfn7ZuDpujlUq0LpKefuf0OLrFbNDj6gY3/Xcn/hqnEzSCl4+IskXqfN1fRc+mOO6AyLLdPMr8Oxjst9eEY8Byy9Am55fLW9iMT/X6QHcoAfV2WgJiWjju5Qd+kJ2UY6v7A8M9vlL4JgZJxX3lZs8Rork3E4x5BiY0MlkeUPaJOwx3rQPq8LnPQqoWEWJMfHHjNfSQmcXXq20ZKvCnrcCnoaWhZms+IhIGfRFnTSjy6fAmLHpowXFDCZcE8EfppbfriWC/acjTEG6IAPQi3glmFp5d1Pye5PQjQ5f9cgarJGj/F1rxzUrg1gXBNNYpB7hvGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=51VrP3sswOCJ0zZy58eckSctOYyKfLf3RQdvyRDJPfM=;
 b=MTjCrI9aQWA6a1pD9oVySsLpAF6C+II2/ioeWfy7JYE/zoUTvSeIr/8t0md65gBj30payyaD1/VMk8IjCk5+z2hD3E9EQR9qGHgNAwB3Jaq1XsDRv96oUsmyJwMYDm8Nq0wU/rj7bfPhZENUPQ61RBguwBH8JFvTKDodcHwuOP8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB5549.namprd12.prod.outlook.com (2603:10b6:5:209::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4778.16; Mon, 13 Dec 2021 10:47:09 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::548c:85f1:ef86:559e]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::548c:85f1:ef86:559e%5]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 10:47:09 +0000
Message-ID: <6282bfaa-b325-d083-cc8b-5c279f984120@amd.com>
Date:   Mon, 13 Dec 2021 17:46:54 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Content-Language: en-US
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     pbonzini@redhat.com, joro@8bytes.org, seanjc@google.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, jon.grimm@amd.com
References: <20211202235825.12562-1-suravee.suthikulpanit@amd.com>
 <20211202235825.12562-4-suravee.suthikulpanit@amd.com>
 <7dd1e7d1510f17f1140b7174dd42fed752eefc38.camel@redhat.com>
 <6cc9848a-9f04-b923-453a-6dbe03b73e58@amd.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <6cc9848a-9f04-b923-453a-6dbe03b73e58@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR0P264CA0173.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::17) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6acbcb46-a6be-47e1-4cab-08d9be25e99c
X-MS-TrafficTypeDiagnostic: DM6PR12MB5549:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB55491A59E3DD2C3FC084E682F3749@DM6PR12MB5549.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GjylYnv69Okg0Pne+nr7wMR78A+7YI3dUcDOiip++MRSjcNbCmV0Ag9F0vfqGj63fczOSlIL3CDbmbIePp0kFAX155jpC/bLU27ATvnEREh3hRxJFcILRcQdr1eUgycIxBEIMPmG9ti0sFtKnXpSpcqtglHOAfV0PlqcGVBPIxeiUz6Ltt1t+0FkQ5D4BhIKeBJAd/IviYwcYiDrgifrKLA71NGca71RxeNozVcszeF1wKonv/tSd/VQtjR49bfXye5IR5Hc+mr6LGyUJzX3MQ3BQHJf8r0q0lmkv9ck5yaCBTTpz9Zy9PQkgUmTKNkHiJSOGkhx9KouShVlgWfF8W4AoMo9SqVT31ExUGiuASsexwjGHFd3+51/XkrKnCK0XxUTEegb/tCoMoK+fsEJBX3tqC2XqXL15S/q4uiIuVLCVh70nJ5rpLsSf5PFgMf3rxlMlzUMQ9m9CuDGLRrTVoe7aUmNsEQbIJZd/2wB2AidiBiJeu5nbD4O7kx6K8aL75HJFvB+L9K7I3jSCovfmcf1grhp6BWR5xh0Y5F1+a3Zw4RWzRjKRfUR0Q666lm1MQHZDxUwZmdhbKO35tJwoa/LhqLc1kBldmDIagP5fuvjf85+pOTEY18g5AdYXr67a/F6trEKJFEDl2bj5EFYRCl+afna1Hh9nT0IB0Bytw7QQHv7AqX+YfEHyHzivKEPzzlgz7irNgtA4MFybBQWEuZZhN15nHeW7HTP4ulGGiNLyIUzpPeSFFmHmSWW8lz+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66476007)(2616005)(66556008)(6486002)(6666004)(8936002)(38100700002)(4326008)(6512007)(5660300002)(31696002)(7416002)(2906002)(31686004)(6506007)(83380400001)(86362001)(36756003)(316002)(110136005)(186003)(66946007)(26005)(53546011)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHdCMDlNSThPWXgya0NGa3daL1BMRFJUY29tK05sYlVQaTQxN3BMWDJsckpI?=
 =?utf-8?B?VDB0Z2doTGFrelJob3d6RzZFRzcwKytHVXgvbkpyWDJRY2YvOFRBZ0dKTGFN?=
 =?utf-8?B?SjQ3dWxRRDZ3cWlUWGM3Y2N0eG55aDZXWlRyN3BQY3UveFl5YU0xOC9BRGw5?=
 =?utf-8?B?ZjFsRWIwZm1PUTgvcVZHZ0pzZXhxc3F2TFlXdUdPUTk5WG9PdU8vcHRQSmto?=
 =?utf-8?B?bXVjQUREeWFwU0h2YytyTE9XMllwdXBjbDNJTnkrNmc5SWdjTjZSdWlkR2da?=
 =?utf-8?B?d2F3YUZ6TkhFcFZPWWVyNmlpMFRJSXA3QWpwL0lXOEoza2JWa2ZYV2xpVmlB?=
 =?utf-8?B?aXNuSGVVV0pRZk9vUGZ3ZW9XVWM5V2Q3b2F2SFQ2SGZCVTJjSVpDQW5QOFNa?=
 =?utf-8?B?c3FkbUFRVjBFaUhJR2VyS3pVTVJpdEoxdFJmTThmU0RPUWV2eUp4ZUJRMDdD?=
 =?utf-8?B?Um8zbzFQU3JlWHM1MVRFajVZdldhZ0JpM0Qxd2JkREM5a2lJcndKOFMzL1Nq?=
 =?utf-8?B?dENZU0JjU2YrVVVKaW0yd3I5WFhQNERrSHIyeHZNRmZuLzJObnJLTmJqRHhM?=
 =?utf-8?B?ejRKWXQzWHYzWkZuejhkVHgyUUFjQ0lQaWxreEwxUEJtUXU1QXBpN2E1a3ln?=
 =?utf-8?B?aUFPRDQzelM4dWJ6ZUVlVUpVQ2o1ckVSWElza3JVeEZVNGpWMEZIWjhXZWtH?=
 =?utf-8?B?eG1pZTdGZEE5eVdESWhVYXFIQzdOM1M3RmU5amt2UW41UHhhcUo2ejg5TnlW?=
 =?utf-8?B?QzlWMVcvaVpibVlWNGt1QVEzZVVtWGsvNzU4eDQ1VUJPMEFYRFkrcExZQ1U2?=
 =?utf-8?B?c1dBbndJM1pMclFTQ3o4ak13eXkzcTVtbHd4UVQ0ZmhKa0luZ3BpaGpoYmxS?=
 =?utf-8?B?RUUyR1pnRGpZRFVFb2dWa3VNYUV3L1ZqbTNWNFR5NGNldWU4NUpDM2w3ZjdR?=
 =?utf-8?B?NVdkeXkvaVZ5cTBSSW9CcXoxbTBKeCsvU2YxVHB1VVU1RS9nOERUNEQ3UldP?=
 =?utf-8?B?SmFJT2tCVXhoSzkycWlwL1JVbTRKQUhCeDgrK2JzRXl0a2tUNHVsVGQ5Y3dH?=
 =?utf-8?B?alNBZnhpM01hQzFQWjdLWVlCaUUrVXplbWt4YTZueDRnK3dzb2l2ZVZhK3J2?=
 =?utf-8?B?dUk4ZWsySDk1TUFxcWVQZkRhdHBPcGZYWEZpSEFwTG05S1FiRU5WRTZCaWRi?=
 =?utf-8?B?Uy9kZGh4ZmRFZmErd0FoN0k1dHMvd1BwZVJrME4wYXcrSHo3NUdTRWlielR0?=
 =?utf-8?B?S2UxL2dlUFQ1SlBCQVBJcnVpUXc5b2N3ZEw2Y09yUUZiV20rMUpYOENTN053?=
 =?utf-8?B?c0xQQjU2WnNGUzMyd1lqeFZ6S0J1cGRsemQzeUtzNktVU29jRlhZdU9hMmlr?=
 =?utf-8?B?N3hqS2FwZVlXYzNFK1NIaXBTeVIxOGJQT0lzN3ZOd2phVHgxaXVpWGFWdURY?=
 =?utf-8?B?b2tGdU1ncW96Qld3Si9oaXlDVC9BQjljRHFhTG5CdjRNcWtrbGhnb0V2Tjhz?=
 =?utf-8?B?UVpqaEkzeWlxTmZtMWVxR21zU2oraTJDeGhuRjNPUU5uVmFzM0RCd0l4Tmh4?=
 =?utf-8?B?VUdEdmtkTHROOGtCVEtDbTZIemc5ZUZxbGprTnpidXNPZThOZGxBSTRkZlk1?=
 =?utf-8?B?dUMwUHEreXZCMDh1ZXdYMEsveU4xWFJ5OURwUnpvampOTW5zcjc4SnZiLzZn?=
 =?utf-8?B?RUN6REZlU09Mai9wMyszOXlPWk9oSUI2NlFaYURaeEk2K3hWYzJFY3pMaTRi?=
 =?utf-8?B?U2k3VENQbnpjK20xMTJJZUVMcG9kdi84aUVkOXlEUGQ4ZWxGd2VrRDdIc0NS?=
 =?utf-8?B?aFpvVUNJMmhyL3dJSS9qTEN2NlNKbkNMMW5lSnBSbnRjT29hOUpjRElxbCti?=
 =?utf-8?B?ZDdZeXBGbDljRHBnc25mQUFkN21QQVZzbE5DTWxWWVJwbGtrTk1XRGl5Y1hR?=
 =?utf-8?B?bjB5Q2pnWFNNMzQ1OXU0V2FhMzNNWHFLUkJHNFFLZlhxN1R5dHYvWEJPTHJJ?=
 =?utf-8?B?U0V5Z01yNE1vRDJpN0ErenpIV1pVajJnSEJKMGo5TEdTRnZoTzhoTWQydmlM?=
 =?utf-8?B?OGVSRHhYRHJNNURKcmg1QVFlcERHL2pxcEdqMDR4NVFUUmdWYVl6VXl0T1Nl?=
 =?utf-8?B?ZXlCdUgxQVdGNzVUTTdRc3FHazhXRVZEVHhwdFJmRi8zeWJDN0g4Ym01dVhW?=
 =?utf-8?Q?Ft7qDB/kg8IXSwbGf3dlWpk=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6acbcb46-a6be-47e1-4cab-08d9be25e99c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2021 10:47:09.7020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DbUc7kU2aG8BUdWGq4zY5atwmdmgOpgiqmWFNDqVwtwEd1Z4lEt+FXy1aAupkQuJ6loSgrAQTt/BTEU7dcbR8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5549
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/3/2021 11:34 PM, Tom Lendacky wrote:
> On 12/3/21 1:46 AM, Maxim Levitsky wrote:
>> On Thu, 2021-12-02 at 17:58 -0600, Suravee Suthikulpanit wrote:
> 
>>> @@ -63,6 +64,7 @@
>>>   static DEFINE_HASHTABLE(svm_vm_data_hash, SVM_VM_DATA_HASH_BITS);
>>>   static u32 next_vm_id = 0;
>>>   static bool next_vm_id_wrapped = 0;
>>> +static u64 avic_host_physical_id_mask;
>>>   static DEFINE_SPINLOCK(svm_vm_data_hash_lock);
>>>   /*
>>> @@ -133,6 +135,20 @@ void avic_vm_destroy(struct kvm *kvm)
>>>       spin_unlock_irqrestore(&svm_vm_data_hash_lock, flags);
>>>   }
>>> +static void avic_init_host_physical_apicid_mask(void)
>>> +{
>>> +    if (!x2apic_mode) {
>> Wonder why this is a exported  global variable and not function.
>> Not the patch fault though.
>>> +        /* If host is in xAPIC mode, default to only 8-bit mask. */
>>> +        avic_host_physical_id_mask = 0xffULL;
>>> +    } else {
>>> +        u32 count = get_count_order(apic_get_max_phys_apicid());
>>> +
>>> +        avic_host_physical_id_mask = BIT(count) - 1;
>> I think that there were some complains about using this macro and instead encouraged
>> to use 1 << x directly, but I see it used already in other places in avic.c so I don't know.
> 
> And I think it should be BIT_ULL() since avic_host_physical_id_mask is a u64.
> 
> Thanks,
> Tom

I am not sure about complains on the use of the BIT macros. However, we can just use BIT_ULL() for now
and clean up the whole file at once later if needed.

Regards,
Suravee
