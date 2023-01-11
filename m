Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B114665170
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 03:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbjAKCCR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 21:02:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbjAKCCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 21:02:06 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37904E00A;
        Tue, 10 Jan 2023 18:01:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkBQ+/5QPtFiioGS7bb9YexdaleAwE9aQGckcglfd8TxWIowQuNYXzXOg4fkv1pqygGdZ55uQTBu44SmVcX+quv1zn5HEUD9pawfGt/+B0IcqkAiZ4rQnTW4F0h6IHoH1+RY8xZnSQghrGcyEMusJDoDTn7U+n9WFSVGM2Iwc9Jc+/0T+gSJbmNAgU9HQA0FVf1C7aFtn2iIQqmFHrSW3UaUXRk2lHkuA3hMefE14MnNY+7QGJSDG1km0Vus5Le9MsKp2bFgB20rteIAtQAVlAKVj13muSd0eQtLFXM/iytD3KxI8WoE997XYN8VvM3qFr1wtdaGVuSHn5sEYSR8XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gy9ybSu7NmJRXlVeB8KFJvtT1/jhO+ruwoXitXYAqWQ=;
 b=N9MHs+dpHlqgzlRRKIURpdcAKwuRHnsko+XMf+ki3k9r6bb65LjCht49fOAyVxcqtwLNqcvB720bhRZUQW984xXWtvOaDmcmuI24nn0yJlCPouT69ETVL3fP/HPi1N1g5OeCjHEN0BSv10XTEa6bAXdOA7sLseYvH+Uu6fj6TAFiDxOwsNiPZ8eRW4ylG92E2iAA/Yqn9ffDozCGXAYUDPTQZ3WKF6TmcMbhyMj/J/U5Y5Qd97T9rOq7/Dgi18ZduxIveryvUS6h/dwB8sbnRD7FwUXsFkLEn+DBgDJ7nvUvO06S54J3mus9ItBDGat5iKgA8vJbvdGjfEzo5V+3RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gy9ybSu7NmJRXlVeB8KFJvtT1/jhO+ruwoXitXYAqWQ=;
 b=5pvM6XWjRY4rOa5XjgLPfPZOf2OIw2PjAmDEDY6brQJmVtg7GWALEYsNBCwpuikEaiUuju/K3CBAhal+DOLMKLuzPTgJCDbE9M1mTi/nq/eBkEIjCyOt8/gKLS6IslSVsdaJebmoY2cRbqrjGUXXUb3YEAzUpVBTaSXhxBcIR4E=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by PH8PR12MB7325.namprd12.prod.outlook.com (2603:10b6:510:217::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 02:01:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::5317:fa3f:5cbe:45e9%3]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 02:01:34 +0000
Message-ID: <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
Date:   Tue, 10 Jan 2023 20:01:27 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     Alexey Kardashevskiy <aik@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
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
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, harald@profian.com,
        Brijesh Singh <brijesh.singh@amd.com>
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-53-michael.roth@amd.com>
 <aab7ed11-870e-579d-9328-4c32d9936392@amd.com>
 <66039193-14ca-5edb-d8d4-ca732d8c13a6@amd.com>
 <119075dd-5f3e-a393-f543-6cdfd34cd337@amd.com>
 <385016f9-e948-4f7f-8db3-24a0c0543b3d@amd.com>
 <55e5f02f-4c1f-e6b0-59ba-07abc4d3408f@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <55e5f02f-4c1f-e6b0-59ba-07abc4d3408f@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::28) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|PH8PR12MB7325:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ed3ea1b-5454-4bc9-4182-08daf377c3da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpG92ZuboGUaEWDJUqcMhuBVmNxGTvyK5ObaBB3yOzVCo1oY0RUNH/Q2a1N41tvzACnzfWy5ePm207+sezhEHJGYNz8x/dGleH+AQQIRO10xfTWFPku2fHGFE3jlSuPCqR0fO6za07JxrC4Qj7/9o66H/dJ12hcaph7WeqnhSzXEwA4BpTtJs3AeRk8IiHiLF0wqi6A4q8mNrFxhGyIErhwyD+bSzdP4SvQqpTR75yQBtY5TFWit1ZzmTrBJBG+mpS4DC7Ed5VIoNu7y4SUz+tVk3P8G7N0Ib283MnNZds5OnNN1a3cnylperM6dYavrXQImCdN+WuIIjyFM3npyzN2EWINrVWG6Kth3z4wZyRPoFyHW50a4U5UiSkZI9jxZJaiLleIFCVIq7wIyHOgNvfmMdNFd6n+0MrBazStskdbZ/juofCeiijUR2+uMyn1OH+GLe9iYSDABgP/8DyVHv8iBJe3jbLqZ9I4hkZHgqvXFdS2Z1BcuhdpFiQ4NB4SfepWgY1XKseTcv79C5jg0wZAspSObttv1QqmpO+5H7PFh22VGbOc7SBA53O4/k0KFZ7fIURu6A01QqzOw9+2Aqb4np/g3iItIS4Ohip9DgRib4UgWVKGGVYMy0kLSN7Q1eCfqyoyjWnTFij5LWIUA2cJ8fMjma2fvZtbkYC2ieQz1+jXILW8hOBnCWC1NOIMxCCGcn2Vg39tsKMFKtEsaG1DAlrMkI+BjoXVnVS4S2aIoVp8Nkz3pH3dX4Jk4NCM/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(6506007)(38100700002)(31686004)(6666004)(53546011)(2906002)(478600001)(6486002)(966005)(86362001)(7416002)(2616005)(30864003)(8676002)(186003)(26005)(6512007)(7406005)(316002)(5660300002)(8936002)(83380400001)(36756003)(31696002)(41300700001)(4326008)(66946007)(66556008)(110136005)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tyt0NGsvRXBEK2NqK3E4YUpVbFcwRittWC9UZGRtWHRUcXAwaTlnYnRxajh3?=
 =?utf-8?B?eGNhMzlmcFRSMG5HNVFwNDBWZ3hnM1AxYXplK1R2ZVVmR1dMb3dOTk4rdVpE?=
 =?utf-8?B?R0l6a2dhN21sYVJUTjdYWWJYRnFZSEsvaTJwTzgyTXZqTWROVlhDT0swMWFB?=
 =?utf-8?B?TW50bEpZbVJBcEtEZzk2WmdVR0N1KzZCNnJEaXBVNSt4WSs0OVZhaSs5aTZN?=
 =?utf-8?B?MHNjeXZaeXFNRVVQaGJzeTVITFdCOVB3aHJZZXRvMkdQbTErQ2s0aURSSVZm?=
 =?utf-8?B?eGdXZFdyekdvVVlIOEh0b2VuTzNrZk1Rdjl5d1kybDBkT015akFtbG1uVUJx?=
 =?utf-8?B?Qk1sZ1NGZGkxRXBOcmJGU1ZlMHYvT3JKQ29WVFFlTVpwSEY1Y3FXc0tQS2Ri?=
 =?utf-8?B?MEdIa29LWGxyZlNuZnNpcTM0a3MwUnJGUFNnZGtjaUcrZHV6VFZiVHZUOU1Q?=
 =?utf-8?B?U1BUbjRqV1A4RWdOdlZNMFV5RngrRkRqQ1R2TG13blNZei9zTGpxSlFhazBq?=
 =?utf-8?B?Yk1YWHhyUXdDZFhRQXRia3hoQWoxSENDZ3Z0aTFTTW1XSmpuU3NGMDgxc3Zq?=
 =?utf-8?B?UDFGQUdFajJhTnJMakNRMVZyVEo0czBCNUxIYm0zL1o2bW9Ya0J6V3ZObTVP?=
 =?utf-8?B?SE1USXV4a1A2THJldEd3L05PY1ZSelQyYkVMMzlDZUdnNlVzcVFiSU1xTlVw?=
 =?utf-8?B?NHRiSVFMR0Rpb0tuUGlWakI1Tmh6OEMzV0w2Ri9FRm5nN2RJK3dxNUphZXBF?=
 =?utf-8?B?Y0UyWlNsOHpaTDgrUkpjUDd0NjJaWjRGK0RvL2doZ0RQQkRBaktDZkNzRnR2?=
 =?utf-8?B?ZnZpOFhDOW1zc3hmYU03UUptSDAzNkJnaEpQdG1wMmxLUUdId0xjV1cxS0d1?=
 =?utf-8?B?RDV2dVhJQk1STE9mN0hRVlFJMmhyWm9sNC9IYUs5UGNpWkRNdklhb3RkTjJu?=
 =?utf-8?B?Kyt4NklTV1VSZ0hZaHQzRUtCS0xkMTBVdWFKZmloWU5zeWp4dmVhT1hDZTE5?=
 =?utf-8?B?RFQwNnhKSnAzVElIMy9aUXo2ZDlVT1dZSEhwdk5xVm1YMmgxbWxqNEFiSEpW?=
 =?utf-8?B?MitJZGlaM08wdmZoR3UxVEcwNW80OGtkUVhDOVNJMDd1eWN6RkgrNWlYb1d6?=
 =?utf-8?B?aDU1a0NuM0VHT1JnbE4xbEU2T0ZwUFlndFIrc25oOHFPOHRnbFUrVXdsc0dv?=
 =?utf-8?B?OER3c1ZQZVBRck1rNXJObTBLYlFtbE1HZ0FpYnhhbDRBd3dPOWxpbWJ4d2FM?=
 =?utf-8?B?WkxXNjZlaVBvWDMwaUNYN3Y2MEorYnZUdFcyd0tTNnJaUVI4RTQweWx6anNP?=
 =?utf-8?B?RkREMnhUWDlTYnVZclZ0OC9XbEhiL1ZpYTlvUVF0a2ZUS0MwZ0hyZGhGUEh2?=
 =?utf-8?B?QUVtTUZ3Rlg5NXNpMTRnNGhvWmFVTk5BbU0yNUl1TU5QbVhBeDRXTTJqMEcw?=
 =?utf-8?B?dTR6ZFN5anlobWt6aHhwZkI1L05scnJMaGRZaUtzdUJHV2piUEFmVm1XbDE0?=
 =?utf-8?B?elRQelFmRVhnOFVWSXY5UmwzTUlRV0JCRVorMU5weGF6VzFoZnRBQTMraXFk?=
 =?utf-8?B?eVVuRGplQmJVUmtCampORUZFUWs2MDRsSlJaWUJSQlA1VXl1ZEp5L0JnTU5s?=
 =?utf-8?B?NEtKSWdjNzNpWEluZW4wVmgwbnBCUmhoVEVPYzRoZFQxR1VndmJqWWsvQlR3?=
 =?utf-8?B?Q3FTcHhEdytyVTdNZHJ1QUpmZkRwYkNReElndUZEZGQxZ3UvbWFxTHQ1RlpJ?=
 =?utf-8?B?ZnMzMTBYNm9sZjJ3SFdxMEZ6NkM3WVdvZ255Mnp5VlU5TzdMa1B5ZkZndzBE?=
 =?utf-8?B?WnJKV1RMeWE3cGs5a1AvTEV1QXE1blJtdWp3S3Blbm9vcEF2OUI5bnRkRDFB?=
 =?utf-8?B?MjFZUEs2M0srZFNmT1VPUVhGWmVnbU5QeWJRUHBmNEk1NUhHMVhHWUZGWnlv?=
 =?utf-8?B?cTlXRGsweGVBRWhGZDd6TEtIT1BWbmVELzhZOFFHYzM0RC96QWZCYlgvVENN?=
 =?utf-8?B?L28rRnJ3RHlvNDdQQUlmdTRxUGxWNVgvY2t3ek92UXY0alFyRHo0WVhTSXRE?=
 =?utf-8?B?RHZGcnZtU3FPRTB6Rm1tUDNVbUhCMU5qbWRWTHpDUjZlR1piQ1ZRZkl6Rjdx?=
 =?utf-8?Q?CLdgLtM7Yc8W/YB1oJvtRxyPM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ed3ea1b-5454-4bc9-4182-08daf377c3da
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 02:01:34.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +/nTzr45M9ghzTo9Baarq9sLKtov4X7G6gL9QfX+Mq2nkFOd2fj4KNWAJqWel4n7CPYRxbwUSFH5Mz7cgAoLTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7325
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/2023 6:48 PM, Alexey Kardashevskiy wrote:
> On 10/1/23 19:33, Kalra, Ashish wrote:
>>
>> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>>
>>>
>>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>
>>>>>> Version 2 of GHCB specification added the support for two SNP Guest
>>>>>> Request Message NAE events. The events allows for an SEV-SNP guest to
>>>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>>>>
>>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>>>> difference of an additional certificate blob that can be passed 
>>>>>> through
>>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>>>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>>>>>> both the report and certificate data at once.
>>>>>>
>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>>> ---
>>>>>>   arch/x86/kvm/svm/sev.c | 185 
>>>>>> +++++++++++++++++++++++++++++++++++++++--
>>>>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>>>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>>>>>
>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>> index 5f2b2092cdae..18efa70553c2 100644
>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, 
>>>>>> struct kvm_sev_cmd *argp)
>>>>>>           if (ret)
>>>>>>               goto e_free;
>>>>>> +        mutex_init(&sev->guest_req_lock);
>>>>>>           ret = sev_snp_init(&argp->error, false);
>>>>>>       } else {
>>>>>>           ret = sev_platform_init(&argp->error);
>>>>>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct 
>>>>>> kvm *kvm, unsigned int source_fd)
>>>>>>    */
>>>>>>   static void *snp_context_create(struct kvm *kvm, struct 
>>>>>> kvm_sev_cmd *argp)
>>>>>>   {
>>>>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>       struct sev_data_snp_addr data = {};
>>>>>> -    void *context;
>>>>>> +    void *context, *certs_data;
>>>>>>       int rc;
>>>>>> +    /* Allocate memory used for the certs data in SNP guest 
>>>>>> request */
>>>>>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
>>>>>> +    if (!certs_data)
>>>>>> +        return NULL;
>>>>>> +
>>>>>>       /* Allocate memory for context page */
>>>>>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>>>>>       if (!context)
>>>>>> -        return NULL;
>>>>>> +        goto e_free;
>>>>>>       data.gctx_paddr = __psp_pa(context);
>>>>>>       rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, 
>>>>>> &data, &argp->error);
>>>>>> -    if (rc) {
>>>>>> -        snp_free_firmware_page(context);
>>>>>> -        return NULL;
>>>>>> -    }
>>>>>> +    if (rc)
>>>>>> +        goto e_free;
>>>>>> +
>>>>>> +    sev->snp_certs_data = certs_data;
>>>>>>       return context;
>>>>>> +
>>>>>> +e_free:
>>>>>> +    snp_free_firmware_page(context);
>>>>>> +    kfree(certs_data);
>>>>>> +    return NULL;
>>>>>>   }
>>>>>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>>>>>> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct 
>>>>>> kvm *kvm)
>>>>>>       snp_free_firmware_page(sev->snp_context);
>>>>>>       sev->snp_context = NULL;
>>>>>> +    kfree(sev->snp_certs_data);
>>>>>> +
>>>>>>       return 0;
>>>>>>   }
>>>>>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>>>>>> vcpu_svm *svm, u64 *exit_code)
>>>>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>>>>       case SVM_VMGEXIT_HV_FEATURES:
>>>>>>       case SVM_VMGEXIT_PSC:
>>>>>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>>>>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>>>>>           break;
>>>>>>       default:
>>>>>>           reason = GHCB_ERR_INVALID_EVENT;
>>>>>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct 
>>>>>> kvm_vcpu *vcpu)
>>>>>>       return 1;
>>>>>>   }
>>>>>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>>>>>> +                     struct sev_data_snp_guest_request *data,
>>>>>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>>>>>> +{
>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>> +    kvm_pfn_t req_pfn, resp_pfn;
>>>>>> +    struct kvm_sev_info *sev;
>>>>>> +
>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>> +
>>>>>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, 
>>>>>> PAGE_SIZE))
>>>>>> +        return SEV_RET_INVALID_PARAM;
>>>>>> +
>>>>>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>>>>>> +    if (is_error_noslot_pfn(req_pfn))
>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>> +
>>>>>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>>>>> +    if (is_error_noslot_pfn(resp_pfn))
>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>> +
>>>>>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>> +
>>>>>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>>>>>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>>>>>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>>>>>> +
>>>>>> +    return 0;
>>>>>> +}
>>>>>> +
>>>>>> +static void snp_cleanup_guest_buf(struct 
>>>>>> sev_data_snp_guest_request *data, unsigned long *rc)
>>>>>> +{
>>>>>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>>>>>> +    int ret;
>>>>>> +
>>>>>> +    ret = snp_page_reclaim(pfn);
>>>>>> +    if (ret)
>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>> +
>>>>>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>>>>> +    if (ret)
>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>> +}
>>>>>> +
>>>>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t 
>>>>>> req_gpa, gpa_t resp_gpa)
>>>>>> +{
>>>>>> +    struct sev_data_snp_guest_request data = {0};
>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>> +    struct kvm_sev_info *sev;
>>>>>> +    unsigned long rc;
>>>>>> +    int err;
>>>>>> +
>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>> +        goto e_fail;
>>>>>> +    }
>>>>>> +
>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>> +
>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>> +
>>>>>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>>>>> +    if (rc)
>>>>>> +        goto unlock;
>>>>>> +
>>>>>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
>>>>>
>>>>>
>>>>> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
>>>>>
>>>>>> +    if (rc)
>>>>>> +        /* use the firmware error code */
>>>>>> +        rc = err;
>>>>>> +
>>>>>> +    snp_cleanup_guest_buf(&data, &rc);
>>>>>> +
>>>>>> +unlock:
>>>>>> +    mutex_unlock(&sev->guest_req_lock);
>>>>>> +
>>>>>> +e_fail:
>>>>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>>>>> +}
>>>>>> +
>>>>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, 
>>>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>>>> +{
>>>>>> +    struct sev_data_snp_guest_request req = {0};
>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>> +    unsigned long data_npages;
>>>>>> +    struct kvm_sev_info *sev;
>>>>>> +    unsigned long rc, err;
>>>>>> +    u64 data_gpa;
>>>>>> +
>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>> +        goto e_fail;
>>>>>> +    }
>>>>>> +
>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>> +
>>>>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>>>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>>>>> +
>>>>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>>>> +        goto e_fail;
>>>>>> +    }
>>>>>> +
>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>> +
>>>>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>>>>> +    if (rc)
>>>>>> +        goto unlock;
>>>>>> +
>>>>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>>>>> long)sev->snp_certs_data,
>>>>>> +                     &data_npages, &err);
>>>>>
>>>>> but this one does not and jump straight to 
>>>>> drivers/crypto/ccp/sev-dev.c ignoring sev->fd. Why different? Can 
>>>>> these two be unified? sev_issue_cmd_external_user() only checks if 
>>>>> fd is /dev/sev which is hardly useful.
>>>>>
>>>>> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
>>>>> attestation report" added this one.
>>>>
>>>> SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and 
>>>> that's why it goes through the CCP driver interface 
>>>> snp_guest_ext_guest_request() that is used to get both the report 
>>>> and certificate data/blob at the same time.
>>>
>>> True. I thought though that this calls for extending sev_issue_cmd() 
>>> to take care of these extra parameters rather than just skipping the 
>>> sev->fd.
>>>
>>>
>>>> All the FW API calls on the KVM side go through sev_issue_cmd() and 
>>>> sev_issue_cmd_external_user() interfaces and that i believe uses 
>>>> sev->fd more of as a sanity check.
>>>
>>> Does not look like it:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/crypto/ccp/sev-dev.c?h=v6.2-rc3#n1290 
>>>
>>>
>>> ===
>>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>>                  void *data, int *error)
>>> {
>>>      if (!filep || filep->f_op != &sev_fops)
>>>          return -EBADF;
>>>
>>>      return sev_do_cmd(cmd, data, error);
>>> }
>>> EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>> ===
>>>
>>> The only "more" is that it requires sev->fd to be a valid open fd, 
>>> what is the value in that? I may easily miss the bigger picture here. 
>>> Thanks,
>>>
>>>
>>
>> Have a look at following functions in drivers/crypto/ccp/sev-dev.c:
>> sev_dev_init() and sev_misc_init().
>>
>> static int sev_misc_init(struct sev_device *sev)
>> {
>>          struct device *dev = sev->dev;
>>          int ret;
>>
>>          /*
>>           * SEV feature support can be detected on multiple devices but
>>           * the SEV FW commands must be issued on the master. During
>>           * probe, we do not know the master hence we create /dev/sev on
>>           * the first device probe.
>>           * sev_do_cmd() finds the right master device to which to issue
>>           * the command to the firmware.
>>       */
> 
> 
> It is still a single /dev/sev node and the userspace cannot get it 
> wrong, it does not have to choose between (for instance) /dev/sev0 and 
> /dev/sev1 on a 2 SOC system.
> 
>> ...
>> ...
>>
>> Hence, sev_issue_cmd_external_user() needs to ensure that the correct 
>> device (master device) is being operated upon and that's why there is 
>> the check for file operations matching sev_fops as below :
>>
>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>                                  void *data, int *error)
>> {
>>          if (!filep || filep->f_op != &sev_fops)
>>                  return -EBADF;
>> ..
>> ..
>>
>> Essentially, sev->fd is the misc. device created for the master PSP 
>> device on which the SEV/SNP firmware commands are issued, hence,
>> sev_issue_cmd() uses sev->fd.
> 
> There is always just one fd which always uses psp_master, nothing from 
> that fd is used.

It also ensures that we can only issue commands (sev_issue_cmd) after 
SEV/SNP guest has launched. We don't have a valid fd to use before the 
guest launch. The file descriptor is passed as part of the guest launch 
flow, for example, in snp_launch_start().

> 
> More to the point, if sev->fd is still important, why is it ok to skip 
> it for snp_handle_ext_guest_request()? Thanks,
> 
> 
Then, we should do the same for snp_handle_ext_guest_request().

Thanks,
Ashish
