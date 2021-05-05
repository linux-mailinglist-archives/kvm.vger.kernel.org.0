Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ACF3749DD
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 23:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233142AbhEEVGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 17:06:13 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:23520
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231488AbhEEVGM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 17:06:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uo7n+qbukvARpCG34XiiIyRA8y9C/z5LQOoN7MIw47+WvBmTrCMJnkJRZbhskAr+3aWXDl5vzNB0fWWpjo3j22XIBR1WlrTPBoaZZt2/axL4AA+LjeJTh2PwLoH/LhCveLAKtFgeDC7a5U9dUW3FiEjUQ7Im/F+/0YS9Zo70CgPIOUH1RSeg1saFY5unW5rtP4/bW5ZBQb66o58RoRX2+QalhDghHJ7x6DnX9QK8BwG4U3wFXd8hzaHc1QAOc3Vg64F5Jybp08blVCVZXTepsbTLYiGolC2IXfWBTFKCda/Drl4wHALe2dC4VAvm+IWpvqF2GvHkE3Ku6DhK5+Bo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sMKLNwVqq748sEwV/1nLUT+F/nEO4RFs9r2p4No4WdM=;
 b=UNAThl7nREF7JuQKdxVkJp4uec3iOT9g6GbceVT9NBrRGu8bSmOVm1+MOUGapUxRuSwCSq9qS0Z5N0HZgvUUtuKPD5WwUNGH7i6HsE7Fw/Gxl6A3uTGOks4QwzVmlOoIplJRujzAFUAMPc/z0YPaabQA4F3pldSlllmZnfO8x5a7Os/47uac0f+Rbnkean4wop4mN1P739QRSUjZwC8Zh1ZjFT7qbeWSiS2/rF6GOZ4+BDS4yWBOmk9wIOVeYrr5T6hoV2ZIITD4MeTOgi0MIjj0/82tF6Jm41+1cyLb3pqSm1giBgabCupKInQ/d+McorD0jmaEO8kFPP3l2UapAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sMKLNwVqq748sEwV/1nLUT+F/nEO4RFs9r2p4No4WdM=;
 b=rkLeET9IdWoIX7LI4u1UFb0v592dvA1bdb+cIhTRCLK1QmJPcE36NaRz3HRWnX0GbhwdLuQEJarrCW1vUXBz9rET4lwAFFcbtQEST418gsllly0UoWXUC0pXaaW3CLAHmiYTaPlpyT1Umu6bBX4uirvN5hFKJ1rayJsqb2C9AHk=
Authentication-Results: alien8.de; dkim=none (message not signed)
 header.d=none;alien8.de; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM6PR12MB4957.namprd12.prod.outlook.com (2603:10b6:5:20d::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4087.26; Wed, 5 May 2021 21:05:13 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4087.044; Wed, 5 May 2021
 21:05:13 +0000
Subject: Re: SRCU dereference check warning with SEV-ES
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
References: <601f1278-17dd-7124-f328-b865447ca160@amd.com>
 <c65e06ed-2bd8-cac9-a933-0117c99fc856@redhat.com>
 <9bbc82fa-9560-185c-7780-052a3ee963b9@amd.com>
 <a6bf7668-f217-4217-501a-f9a12a41beb3@redhat.com>
 <1d0ddadc-6a98-2564-aa78-cf8fa2113a28@amd.com>
Message-ID: <911bf5d1-1141-7970-6776-83eaac4882c2@amd.com>
Date:   Wed, 5 May 2021 16:05:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <1d0ddadc-6a98-2564-aa78-cf8fa2113a28@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR10CA0019.namprd10.prod.outlook.com
 (2603:10b6:806:a7::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SA9PR10CA0019.namprd10.prod.outlook.com (2603:10b6:806:a7::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Wed, 5 May 2021 21:05:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19e0eb3a-ec5b-4ad3-dee7-08d9100979d3
X-MS-TrafficTypeDiagnostic: DM6PR12MB4957:
X-Microsoft-Antispam-PRVS: <DM6PR12MB49579919990563DA60D3A061EC599@DM6PR12MB4957.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dug0ijy6kyJQ1tbVVWnX9vHNKzCRMrAgx5z9gqun9SApgiOnAUmiq0cbkPuDBiO3CHGTXLjELtvrAKMl+HF/NW4yH/svnVB1NW9G+cx7eBtPjT0TcvNCJVeMM5V9fjIHOeyPp92jgSDH3IwdrDEKD9BCi9FuLYNVyegrPugFmqDXdbs/kqit63xy237lO4oilO5h5gRJ+K157+yt5tAIqCsQkreaM59K2Ka+uwScyK36uUfSk40oTEBWGxjoBP54uX+qq41YKWI/B5Apvc/5EwNqYMDQ/VZ1kkfUYKOEAdzzF2xhZOfjHh44ndIKk/zU3NLeO10pRQgGH3aH/njQ0sY3wxmv1BsOaVeoJspFHuqbe7eoOLjaY7uWj9v/Px0WodHzfAcjJOjHMfxKHPOrSS06sgX36ayhnqUNtmLY0J+H/ytVlctiisEVdTpuXAW+JwmQ79j8yAfz9pfUdJPaOq1RkhY3fQSc3mNYLoHm1SebCw+Dek+cZIdqRoaIb1ccYAIzgBOZ69kuyas2JuJtMgj88GPUqqgTj52WDbYjoL/6gGZIaAw8BWGY3g9tiOAigN0uL0iqrSRoehExJi6xmdUnIK1AvUokp4RV+Ib9q48ldoNn6JwOi9MEzGiNuKz+ECz6GmSI0uku4v2aYOi5DwMQw6bPIsLKWMKe42GZbEjauhez7qRV/W2t3GN6FS8z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(346002)(366004)(136003)(376002)(478600001)(16526019)(86362001)(31696002)(8676002)(36756003)(186003)(38100700002)(26005)(31686004)(4326008)(2616005)(956004)(110136005)(66556008)(66946007)(316002)(83380400001)(6486002)(5660300002)(2906002)(53546011)(66476007)(16576012)(8936002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OEY2S1hFWkl1QUp0Tlk1R3NadVNza042THM4OS9pZXJKY0oyMmdGekZ1WGtt?=
 =?utf-8?B?VDFvczlaS1JHQmFpMmovM2xFRDZSOWxYUjIrMGo3T3hNOXRycFdBMjdNcFBF?=
 =?utf-8?B?NDhvb3I1Q3lYSXpSaGs5TEZlZE12cW9HT1VLN0JEN1ZQdTA3ZzQ4dVlYY0pT?=
 =?utf-8?B?bmx4RHVxSkttL0xzdGIyS3p0cWxNRTFhYVI5MDNSOEJyWExONnZrdVMwbUhI?=
 =?utf-8?B?SGZ5bElUNXRKT3QrM2ZPYmhhWkJ2NS9oTEcvSFZDV1N2WXI1NnFYUFlxQ2Zl?=
 =?utf-8?B?RDZVK0pxZXhGeTQvbG1ZaktnaFA0V1EvclZMV21nUGIxdWhHUGNtQ3Q3UGJS?=
 =?utf-8?B?bGRaRzZQaG9NUlE4dGhOSmRQbWpXeURiTVdhcDZGWjhLMlJQcTJPenZ3YVFQ?=
 =?utf-8?B?STd2ejdIYXNkbjJyajJTY1NERm5rcExIYnRId2FEVTQxNEFOZGFZRmhMdk04?=
 =?utf-8?B?dFlxdVFCcGxpR3ppOEE5VXpndysrR2xzWG1iNy9IUHc1Q0FmbStWQ0FGOWow?=
 =?utf-8?B?amdZSGp2RjV2RTZYVlM2ZGFReldNUU8reEFIdWczYlIvZGdOamlCNS9NZ3Vs?=
 =?utf-8?B?UUFocVprMFZueXptTEZEMkNIL0ora0ZjSWFBeHJ1bUNFeG1mNG9OSm8vc25a?=
 =?utf-8?B?akF4UHVOWkVEOTk3MVBudjJDWGtYcXdzc2p0WVlCaGY5eHBKaXRndE9wMSs0?=
 =?utf-8?B?ZlJNTjRpZHkrOWhMbHp5THRnKzU2WFJtWjYxUWd5bEJRQW1ZQU9ndDNWTnU4?=
 =?utf-8?B?dHlyRXZOa1RJQWEyUFRtMXRKMFNvSkpxOE9HQ0NEdzNiVDBxWEdyaUZxKzF4?=
 =?utf-8?B?TXFPRXlwN0JseGFiS3J2YXhNRFVwekw0V0NKV1p0blNwemRNeU9iRWxUeVVN?=
 =?utf-8?B?WjlFZGI0L3FMa0FiR05ldmxUbUN5N3MzU3R2Ym9HSG9Nck9JNGlCQjNyaU1O?=
 =?utf-8?B?d0wrMGtVVjY5b2RNemhJUitpYUdmRndtNit4R0xnRXJYWmJjVFNRM2RlTTI3?=
 =?utf-8?B?emZoWGUvK1FPK3oweFYvZTVEV2Z2bmVzdkZhM280RHdpWDhOZGpQYitKdjE1?=
 =?utf-8?B?NEM2cEJVengxVGpQVVlQR2RVcktHK2ZMZ2MwSVdKbEQ0YnpPQ1FQV292Nlhh?=
 =?utf-8?B?V0JnZkJESTNqanduNjhzRnhWeVZ3aS9aTVR2NzFWVzQ3OWF6aEJtNklIZWE5?=
 =?utf-8?B?NVk0VjBtUXMxVzNwTjNHN1ZGTHlGSVRwL09oSlpwMlo0UlQ3VDZlVGpUQ0ky?=
 =?utf-8?B?N0tUemZzWUV5STRuM3Y0RWRmVmEvczU3Wlp2ZHZWRHlZalcyYkxVVG5Ob2Ev?=
 =?utf-8?B?SUdMbmR5NnJPRHpjUUc3TCtwS0VzSUhvbUt1RDFnb05odG1xWHBjMmhiZmhE?=
 =?utf-8?B?ZjZ1QTRmVTFoTEEreHlJVmJjS1BwZk40b2RyTFJMYnJqYjFZL2J2TG9JNGc4?=
 =?utf-8?B?Szh3WFYwcGZNNWpGNFE4bm43MjFDM1VxWHhQeDVSclNzU2xkZjFDTmVTT2xz?=
 =?utf-8?B?MzlOY2xjZ2JCQzZobjBRZjlPTHlEZzdtam5SMGhhNEU4SkpCdUdsb205RXlv?=
 =?utf-8?B?Q2tjQ3RwSUlJMm9pditBbWYwSWdndkIrcEpBbjNiSHJqUVNyOVBMNzJ2bVlj?=
 =?utf-8?B?bEpCNGl1eldiblAwSGQwazdQdWl3V0FNU0d2QWdra29NVUZMTCttaXFTTnFo?=
 =?utf-8?B?cC93YlF1S3RNaEVKUWxUUFkvTXJCdGs2TzJpWkZJNEhYWUxCVzd1NE8yWC9K?=
 =?utf-8?Q?ymyyFOiHPzEYOH/q7+lcjXBhDqnczQSyIDkMEuQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19e0eb3a-ec5b-4ad3-dee7-08d9100979d3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 21:05:13.6133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TgfPWO3X4UnVanap34ugCSOmSSS3fRmS+H+jRDUGoIYK0MD6sAr0RdIG/VgxhLQskAyipXaxzOHaJ6jIosoqZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4957
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/5/21 2:55 PM, Tom Lendacky wrote:
> On 5/5/21 1:50 PM, Paolo Bonzini wrote:
>> On 05/05/21 20:39, Tom Lendacky wrote:
>>> On 5/5/21 11:16 AM, Paolo Bonzini wrote:
>>>> On 05/05/21 16:01, Tom Lendacky wrote:
>>>>> Boris noticed the below warning when running an SEV-ES guest with
>>>>> CONFIG_PROVE_LOCKING=y.
>>>>>
>>>>> The SRCU lock is released before invoking the vCPU run op where the
>>>>> SEV-ES
>>>>> support will unmap the GHCB. Is the proper thing to do here to take the
>>>>> SRCU lock around the call to kvm_vcpu_unmap() in this case? It does fix
>>>>> the issue, but I just want to be sure that I shouldn't, instead, be
>>>>> taking
>>>>> the memslot lock:
>>>>
>>>> I would rather avoid having long-lived maps, as I am working on removing
>>>> them from the Intel code.  However, it seems to me that the GHCB is almost
>>>> not used after sev_handle_vmgexit returns?
>>>
>>> Except for as you pointed out below, things like MMIO and IO. Anything
>>> that has to exit to userspace to complete will still need the GHCB mapped
>>> when coming back into the kernel if the shared buffer area of the GHCB is
>>> being used.
>>>
>>> Btw, what do you consider long lived maps?  Is having a map while context
>>> switching back to userspace considered long lived? The GHCB will
>>> (possibly) only be mapped on VMEXIT (VMGEXIT) and unmapped on the next
>>> VMRUN for the vCPU. An AP reset hold could be a while, though.
>>
>> Anything that cannot be unmapped in the same function that maps it,
>> essentially.
>>
>>>> 2) upon an AP reset hold exit, the above patch sets the EXITINFO2 field
>>>> before the SIPI was received.  My understanding is that the processor will
>>>> not see the value anyway until it resumes execution, and why would other
>>>> vCPUs muck with the AP's GHCB.  But I'm not sure if it's okay.
>>>
>>> As long as the vCPU might not be woken up for any reason other than a
>>> SIPI, you can get a way with this. But if it was to be woken up for some
>>> other reason (an IPI for some reason?), then you wouldn't want the
>>> non-zero value set in the GHCB in advance, because that might cause the
>>> vCPU to exit the HLT loop it is in waiting for the actual SIPI.
>>
>> Ok.  Then the best thing to do is to pull sev_es_pre_run to the
>> prepare_guest_switch callback.
> 
> A quick test of this failed (VMRUN failure), let me see what is going on
> and post back.

I couldn't just move sev_es_pre_run() into sev_es_prepare_guest_switch()
because of the guest_state_loaded check in svm_prepare_guest_switch().

Renaming sev_es_pre_run() to sev_es_unmap_ghcb() and calling it before the
guest_state_loaded check worked nicely. I'll send a patch soon.

Thanks,
Tom

> 
> Thanks,
> Tom
> 
>>
>> Paolo
>>
