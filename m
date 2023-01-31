Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974976821A3
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 02:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjAaBzD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 20:55:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjAaBzC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 20:55:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B209CC02;
        Mon, 30 Jan 2023 17:54:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZGrG0KinNVOemWBpDWfe4oECrwfozQiu2Q+UCUMp2vWG4ZsIEftZw9mcPTEZA47YNmezf3bMItv9gyH9GXpLJpDLCuZx9k0RU3z3ccN6jXSFs5dtMLKpqNhix7t5l7VkIP6LK1mCBmhN/otl2k0oXBOf5LUpf/71WZpol6wj50WUzb0wO4dWFd9AOokUGfDiQwTK4ppTIpon15oqeh++cVSkFLIV/hJwSRp6+wZ19/Zu/6A4XeRMImdnfwa7KeyVBnjaWHzRnakWdPHQ2l0aXSh9aZE2b4yMWQu7PHuOd24u0CHpYiZ7ZmxDjiq5KC4o6/ZsDH6be4kvWhK/M0RCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uiBc5VsAaOcLFAbUtI89i/KuI4cetRUVzd9kHXtIrUg=;
 b=V9Iv/TncYviM+mKZmtz6rp6mLVwt4tvkV1PgjH1BzgUgcd9xaqUE7DsZWqfF69ZFw5QD7FepTDi7/MI+8VCXa6tVFMjm+u81Jj4ibeWhu8gKtHAZp2cgDwza2ebvCPvTdWVic49R79Z3wypiFz1hplGXGRwitfauCumA4w74jyojHOjTqhWuv1l38sxJIgRn3dVT4QIEWK1dPGwNSTjTVi4J0ML3Ptwrt7JGmg7mwHT1X1TtIgZL0LFQf6HzgEUjoU4418zfOC81YhGS+d1H5MzbcZA85HUA4G7RwVVSDYHpIr/glCROkuRM52tSnTeaM+X4nfU1T1zjdJgrlZdVNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uiBc5VsAaOcLFAbUtI89i/KuI4cetRUVzd9kHXtIrUg=;
 b=mUPFCoIcqxq3oBYWyMPbQoiauLCjJ2TwHspKiKUT+U9VS6Ge+TStZO4FndRtdU5N5OqmvsPAMxXBwPRsc5Jej6Px7aTp8aO4G6PZPjxHbhoaZ4YFcablYh2aLfz8+09n8IEecNirz+kXXyR2O6Ts7VLpXRrg6vff91TWW2U8Lr4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 MW4PR12MB6997.namprd12.prod.outlook.com (2603:10b6:303:20a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 01:54:55 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 01:54:55 +0000
Message-ID: <b0baa6ee-ea6d-3a30-d5fb-3ec395896750@amd.com>
Date:   Tue, 31 Jan 2023 12:54:37 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
Content-Language: en-US
To:     "Kalra, Ashish" <ashish.kalra@amd.com>,
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
 <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SYBPR01CA0068.ausprd01.prod.outlook.com
 (2603:10c6:10:2::32) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|MW4PR12MB6997:EE_
X-MS-Office365-Filtering-Correlation-Id: 41accd1f-3e17-4f1e-6fc9-08db032e260c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gWUz3JtTVLlZMm2peNMMCwaj3hFpmX4j39J9S6BPcy61FqY5Tcob/9UGCIc5O7UfY9cAubuOYXYJu6oywP6PJ8XFsHd5imihRS67uvcUe94RJrbYbB06ucQTWmHp6RSOyWuycCQUxfMclEnspBVWzKVposKji6Q/ox352rdvHTlIaZuba4BWtED+wJCaARP/hnf8n9BqsiEF9mxEaIGJ/GhJeZqsqikqkiK+WoDFCAKOZFsg0x0OAo5Yn9CTOWVBGRiDaTfFxv9kfCVQBEXPgjsADfEJeO81kY4UU92c3dt4L+xQtBQVP05nCKX9blfDfK35ASDnG+dtT5oayfKI2H3vmt9SrtrKkqrYmrDJYvr6k3pER3Q8dd9P3CF8zWXA+kmId3lg0xw3G1M5OIhjOei00C+IjSYGuPTNrcA+2hiQeFnczzAquowoTNqz1C37NOJKViHjefZX+06VkBctTEgr6YD6dXwCF6oEH1r2QM3RT2xCJzGGnYeaXxUkSgbhL0t6ytgXv1zlcKQtLK0PmPI+dgRbhYmG0O9mQ4cq52HUfxd7KGQySffN/x4i9mncaKo/1t+HjDIc9n7qJG0mUNP6uleuWpmlqTszrPJZLIae6TTk6FxLGu/CtFCtUAYDfm8+UhD2ZQ8NariiF5PzteVQaN/tkOQXfaAxhG5Q/yCpQW8vEJfdEC23iabNFiKnFNh1wfgmqYiMI86oENuuI8RudYAf2hkn5uNY3qaq97FoyU9EBP6tUe3TNV0ZqwMIysiCpTUEaCLo0eF79ZZSJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(39860400002)(396003)(136003)(451199018)(31696002)(31686004)(66556008)(8676002)(66476007)(4326008)(41300700001)(66946007)(8936002)(83380400001)(478600001)(316002)(2906002)(38100700002)(6666004)(6486002)(53546011)(6506007)(5660300002)(6512007)(30864003)(186003)(966005)(26005)(2616005)(36756003)(7406005)(110136005)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnBkRlJMMHhBcVlPS1p2M200bUIyMWZVS09pYzRNK1F5RTVpR3ZQN201NENQ?=
 =?utf-8?B?QTdQYmdvbU9JVEpQeTR3VTl3dmNqNjcxUWhkN0g4V1h2bktVeEpoMFRNcm9L?=
 =?utf-8?B?TkVGaDgvUTBrZ0NVMC9LOUtTWlh5aXppQ091b0dvNmhyQUNHMmxXeUtrMUd3?=
 =?utf-8?B?ZGROa21ZSFFVNmFrdnRFUGNhaVFLd2tud3NzSy96eTQ4SXNYRHZsV3plVE9B?=
 =?utf-8?B?bjYya3JDeGxnNDh1dGtmekxwc1YvOGxialZINmpxN0V2SzZQZm53TSs1eHVT?=
 =?utf-8?B?djNEbjYreHJYNkVIOWV0cGlrWStyUFdKUFdzMjl4QTRHR0hCMGpjMDBsU3Rh?=
 =?utf-8?B?bDVFWEMwRHk0S3BEMmliYzFPb2gxY1pwVnVRQWMwMjMzTUNHTTV3dlE1dDhk?=
 =?utf-8?B?MEJ2NkE3UE1yajBPcG94NGRSTE12dGd5REpaWjg0Ymh6YW5hTWZLY1lLRkxa?=
 =?utf-8?B?cGR3c0VHMy9hK3pscWxqdXpOUDBPcHNMYnVpUlExblpaM3loY1Btd3dQZm56?=
 =?utf-8?B?RjhwZkNDb2dCL3F1VUs5OXdJZm1Ob2ljalZMbDNiZWcwQ0poaWhhdzBLOFUz?=
 =?utf-8?B?RFdmL2M3QytqcE02UkEzR3plYnM1L1RtSWYxZDRCQkY4QXV1VkZPVUNLek1N?=
 =?utf-8?B?UnJJOVVxYWpDUk9lVnZDeDFQODZZM3Q3YjlQYjNIS1dWSEw2cjZWVFNwck5i?=
 =?utf-8?B?UVNpUDEybXpIU0JmWGdxay9HRm5VdVhaL1pId2NSNWpqT3NvRlg3L0R3cXhL?=
 =?utf-8?B?WnhsUVVJZXRGWC81S0E1UXBVN0RTd1JMY0Zja2gwN0RzampGWkVROVpqaUFV?=
 =?utf-8?B?OVdUUmJtbk5zM2wyYTBZcVBCS0NSYWJ3REUvNUQ4WkFzekpNTEZjUjROT1M4?=
 =?utf-8?B?bzdhbG1sYWNhME1TQW11OGlObTNYR2RNMnUxTW1nODB5cVYzQzZSM3BpZ1lC?=
 =?utf-8?B?eThZSG9FY1FYdEVlSDM0RkYxR01PU1dXZ0VqcE1JbUloamFydmdGL01ncFd4?=
 =?utf-8?B?TUpqY1BLblpKZzUwb2I5NG9zNXk4NU9PVURkSUZHMmxVbXdMUEpFSEtjZGdr?=
 =?utf-8?B?U1F0RXBSUEU0TThGNU54ZEhzUW1OZEVZVkhPcGVHbjA0cGE2S2hQc1dvTTNq?=
 =?utf-8?B?VjNyajJhdFNwMlhJaUVUdUxYRmRzUHNjRGZtNEFJYW1pblcxQ1RSbU9RNFg1?=
 =?utf-8?B?VUdONHEydFhqVzJpdVpDVHQvUTMrTERUZDdaQmpCcGxRZXhUSWNLZWdzVWdh?=
 =?utf-8?B?THl3NTZralRoWElWcDhObjVJSjdkYitMekw1ZzRMUUwxZW1vOEkwWnI4WSti?=
 =?utf-8?B?dmxjMUoweVJueUNiS0U0MzNiZUtqempsalJYTU5wbVVNZHNhS2l2NjZXRENl?=
 =?utf-8?B?V1JjWmNuMmxER0ZCOWpTanNQYjlnZHByeEhLM0xDYnpWTHc5RGxsVndhaHdD?=
 =?utf-8?B?L0lNL09JQUptUTk2eHBSb002bTBKRGdKNmRjUkh2RkF3b0ZKaUlQeHM2U0pF?=
 =?utf-8?B?ZHJHVTZ5SUZweGtrYTRTZk1DQkZDLzJIMmtkajhhWkcra0FUbFU5bCtJQUpx?=
 =?utf-8?B?YklpNzFtbWJodXhUQTRHdWFURXVzY2NldUM1QWQwK2tna3Y3eXpzUVJNd2kv?=
 =?utf-8?B?VU83TVpPbm1oQTNUUWZVR0ZMMUNzZk5HZ1FpWG9kTElTdkNwTWZ4R2IxNjVJ?=
 =?utf-8?B?Z3B2RWg1WFBRczA4bC9MNDdvVjFhdWhwVGNlL0JseTVYRmVqUGNIOUU3VzN4?=
 =?utf-8?B?ejZNaFV6STE1U1REYVZaemZvYXJDMktGTnlCTy9PN0Vodm9aVHFRL3JtQnFJ?=
 =?utf-8?B?TUlpUW5HSkR6Mlo5bnhNMndIeEJjWURPWGt2NEJubE9RdVRxMWF2WG9RS3Fw?=
 =?utf-8?B?SGIzc3FuL3B4Vm5vUDB4SWp3NmR5c0xUZVdlSGNuQThBcyt0dUkvcGRsUzIw?=
 =?utf-8?B?bFY1SDY2SUtkV2kvSnBGaFpSeVFBYmphbXhDVGJzbVNMMmJ3b0hyaTBhaHFG?=
 =?utf-8?B?cVNQRHdlKzBWNXZuc0JZRzhleFN4bkEzMVJrTnRvSE1abWE4MnBtTDdZdXIx?=
 =?utf-8?B?Tml5bFJzQWl6U0VWclJWMDA5Q3NpMHQzL2x3d0p6RE9DVlJMYkNLZFFIZXIv?=
 =?utf-8?Q?fkSGE4fk9SzEEQe55frbInLlZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41accd1f-3e17-4f1e-6fc9-08db032e260c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 01:54:54.8222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4CifZs7PEgpM1Nr2ZMtiV1sUiHlbVKR6fV+kmDqGYbtiCG3H/N/W9TjaydS7yWoinQegflozFiREJpO2ubiUoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6997
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/1/23 13:01, Kalra, Ashish wrote:
> On 1/10/2023 6:48 PM, Alexey Kardashevskiy wrote:
>> On 10/1/23 19:33, Kalra, Ashish wrote:
>>>
>>> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>>>
>>>>
>>>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>
>>>>>>> Version 2 of GHCB specification added the support for two SNP Guest
>>>>>>> Request Message NAE events. The events allows for an SEV-SNP 
>>>>>>> guest to
>>>>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>>>>>
>>>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>>>>> difference of an additional certificate blob that can be passed 
>>>>>>> through
>>>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>>>>> provides snp_guest_ext_guest_request() that is used by the KVM to 
>>>>>>> get
>>>>>>> both the report and certificate data at once.
>>>>>>>
>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>>>> ---
>>>>>>>   arch/x86/kvm/svm/sev.c | 185 
>>>>>>> +++++++++++++++++++++++++++++++++++++++--
>>>>>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>>>>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>>>>>>
>>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>>> index 5f2b2092cdae..18efa70553c2 100644
>>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, 
>>>>>>> struct kvm_sev_cmd *argp)
>>>>>>>           if (ret)
>>>>>>>               goto e_free;
>>>>>>> +        mutex_init(&sev->guest_req_lock);
>>>>>>>           ret = sev_snp_init(&argp->error, false);
>>>>>>>       } else {
>>>>>>>           ret = sev_platform_init(&argp->error);
>>>>>>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct 
>>>>>>> kvm *kvm, unsigned int source_fd)
>>>>>>>    */
>>>>>>>   static void *snp_context_create(struct kvm *kvm, struct 
>>>>>>> kvm_sev_cmd *argp)
>>>>>>>   {
>>>>>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>       struct sev_data_snp_addr data = {};
>>>>>>> -    void *context;
>>>>>>> +    void *context, *certs_data;
>>>>>>>       int rc;
>>>>>>> +    /* Allocate memory used for the certs data in SNP guest 
>>>>>>> request */
>>>>>>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
>>>>>>> +    if (!certs_data)
>>>>>>> +        return NULL;
>>>>>>> +
>>>>>>>       /* Allocate memory for context page */
>>>>>>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>>>>>>       if (!context)
>>>>>>> -        return NULL;
>>>>>>> +        goto e_free;
>>>>>>>       data.gctx_paddr = __psp_pa(context);
>>>>>>>       rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, 
>>>>>>> &data, &argp->error);
>>>>>>> -    if (rc) {
>>>>>>> -        snp_free_firmware_page(context);
>>>>>>> -        return NULL;
>>>>>>> -    }
>>>>>>> +    if (rc)
>>>>>>> +        goto e_free;
>>>>>>> +
>>>>>>> +    sev->snp_certs_data = certs_data;
>>>>>>>       return context;
>>>>>>> +
>>>>>>> +e_free:
>>>>>>> +    snp_free_firmware_page(context);
>>>>>>> +    kfree(certs_data);
>>>>>>> +    return NULL;
>>>>>>>   }
>>>>>>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>>>>>>> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct 
>>>>>>> kvm *kvm)
>>>>>>>       snp_free_firmware_page(sev->snp_context);
>>>>>>>       sev->snp_context = NULL;
>>>>>>> +    kfree(sev->snp_certs_data);
>>>>>>> +
>>>>>>>       return 0;
>>>>>>>   }
>>>>>>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>>>>>>> vcpu_svm *svm, u64 *exit_code)
>>>>>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>>>>>       case SVM_VMGEXIT_HV_FEATURES:
>>>>>>>       case SVM_VMGEXIT_PSC:
>>>>>>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>>>>>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>>>>>>           break;
>>>>>>>       default:
>>>>>>>           reason = GHCB_ERR_INVALID_EVENT;
>>>>>>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct 
>>>>>>> kvm_vcpu *vcpu)
>>>>>>>       return 1;
>>>>>>>   }
>>>>>>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>>>>>>> +                     struct sev_data_snp_guest_request *data,
>>>>>>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>> +{
>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>> +    kvm_pfn_t req_pfn, resp_pfn;
>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>> +
>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>> +
>>>>>>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, 
>>>>>>> PAGE_SIZE))
>>>>>>> +        return SEV_RET_INVALID_PARAM;
>>>>>>> +
>>>>>>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>>>>>>> +    if (is_error_noslot_pfn(req_pfn))
>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>> +
>>>>>>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>>>>>> +    if (is_error_noslot_pfn(resp_pfn))
>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>> +
>>>>>>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>> +
>>>>>>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>>>>>>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>>>>>>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>>>>>>> +
>>>>>>> +    return 0;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void snp_cleanup_guest_buf(struct 
>>>>>>> sev_data_snp_guest_request *data, unsigned long *rc)
>>>>>>> +{
>>>>>>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>>>>>>> +    int ret;
>>>>>>> +
>>>>>>> +    ret = snp_page_reclaim(pfn);
>>>>>>> +    if (ret)
>>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>>> +
>>>>>>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>>>>>> +    if (ret)
>>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t 
>>>>>>> req_gpa, gpa_t resp_gpa)
>>>>>>> +{
>>>>>>> +    struct sev_data_snp_guest_request data = {0};
>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>> +    unsigned long rc;
>>>>>>> +    int err;
>>>>>>> +
>>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>>> +        goto e_fail;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>> +
>>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>>> +
>>>>>>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>>>>>> +    if (rc)
>>>>>>> +        goto unlock;
>>>>>>> +
>>>>>>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, 
>>>>>>> &err);
>>>>>>
>>>>>>
>>>>>> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
>>>>>>
>>>>>>> +    if (rc)
>>>>>>> +        /* use the firmware error code */
>>>>>>> +        rc = err;
>>>>>>> +
>>>>>>> +    snp_cleanup_guest_buf(&data, &rc);
>>>>>>> +
>>>>>>> +unlock:
>>>>>>> +    mutex_unlock(&sev->guest_req_lock);
>>>>>>> +
>>>>>>> +e_fail:
>>>>>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>>>>>> +}
>>>>>>> +
>>>>>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, 
>>>>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>> +{
>>>>>>> +    struct sev_data_snp_guest_request req = {0};
>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>> +    unsigned long data_npages;
>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>> +    unsigned long rc, err;
>>>>>>> +    u64 data_gpa;
>>>>>>> +
>>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>>> +        goto e_fail;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>> +
>>>>>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>>>>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>>>>>> +
>>>>>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>>>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>>>>> +        goto e_fail;
>>>>>>> +    }
>>>>>>> +
>>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>>> +
>>>>>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>>>>>> +    if (rc)
>>>>>>> +        goto unlock;
>>>>>>> +
>>>>>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>>>>>> long)sev->snp_certs_data,
>>>>>>> +                     &data_npages, &err);
>>>>>>
>>>>>> but this one does not and jump straight to 
>>>>>> drivers/crypto/ccp/sev-dev.c ignoring sev->fd. Why different? Can 
>>>>>> these two be unified? sev_issue_cmd_external_user() only checks if 
>>>>>> fd is /dev/sev which is hardly useful.
>>>>>>
>>>>>> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
>>>>>> attestation report" added this one.
>>>>>
>>>>> SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and 
>>>>> that's why it goes through the CCP driver interface 
>>>>> snp_guest_ext_guest_request() that is used to get both the report 
>>>>> and certificate data/blob at the same time.
>>>>
>>>> True. I thought though that this calls for extending sev_issue_cmd() 
>>>> to take care of these extra parameters rather than just skipping the 
>>>> sev->fd.
>>>>
>>>>
>>>>> All the FW API calls on the KVM side go through sev_issue_cmd() and 
>>>>> sev_issue_cmd_external_user() interfaces and that i believe uses 
>>>>> sev->fd more of as a sanity check.
>>>>
>>>> Does not look like it:
>>>>
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/crypto/ccp/sev-dev.c?h=v6.2-rc3#n1290
>>>>
>>>> ===
>>>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>>>                  void *data, int *error)
>>>> {
>>>>      if (!filep || filep->f_op != &sev_fops)
>>>>          return -EBADF;
>>>>
>>>>      return sev_do_cmd(cmd, data, error);
>>>> }
>>>> EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>>> ===
>>>>
>>>> The only "more" is that it requires sev->fd to be a valid open fd, 
>>>> what is the value in that? I may easily miss the bigger picture 
>>>> here. Thanks,
>>>>
>>>>
>>>
>>> Have a look at following functions in drivers/crypto/ccp/sev-dev.c:
>>> sev_dev_init() and sev_misc_init().
>>>
>>> static int sev_misc_init(struct sev_device *sev)
>>> {
>>>          struct device *dev = sev->dev;
>>>          int ret;
>>>
>>>          /*
>>>           * SEV feature support can be detected on multiple devices but
>>>           * the SEV FW commands must be issued on the master. During
>>>           * probe, we do not know the master hence we create /dev/sev on
>>>           * the first device probe.
>>>           * sev_do_cmd() finds the right master device to which to issue
>>>           * the command to the firmware.
>>>       */
>>
>>
>> It is still a single /dev/sev node and the userspace cannot get it 
>> wrong, it does not have to choose between (for instance) /dev/sev0 and 
>> /dev/sev1 on a 2 SOC system.
>>
>>> ...
>>> ...
>>>
>>> Hence, sev_issue_cmd_external_user() needs to ensure that the correct 
>>> device (master device) is being operated upon and that's why there is 
>>> the check for file operations matching sev_fops as below :
>>>
>>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>>                                  void *data, int *error)
>>> {
>>>          if (!filep || filep->f_op != &sev_fops)
>>>                  return -EBADF;
>>> ..
>>> ..
>>>
>>> Essentially, sev->fd is the misc. device created for the master PSP 
>>> device on which the SEV/SNP firmware commands are issued, hence,
>>> sev_issue_cmd() uses sev->fd.
>>
>> There is always just one fd which always uses psp_master, nothing from 
>> that fd is used.
> 
> It also ensures that we can only issue commands (sev_issue_cmd) after 
> SEV/SNP guest has launched.

I can open /dev/sev and start sending commands to the firmware with no 
KVM running at all. Oh well, we discussed this offline :)

> We don't have a valid fd to use before the 
> guest launch. The file descriptor is passed as part of the guest launch 
> flow, for example, in snp_launch_start().
>>
>> More to the point, if sev->fd is still important, why is it ok to skip 
>> it for snp_handle_ext_guest_request()? Thanks,
>>
>>
> Then, we should do the same for snp_handle_ext_guest_request().

Okay.

This snp_handle_ext_guest_request() helper is for returning "Table 21. 
ATTESTATION_REPORT Structure" along with the certificate(s) used to sign 
the report: "This usage allows the attestation report and the 
certificates required to verify the report to be returned at the same time".

I can see:
1) KVM_SEV_SNP_{G,S}ET_CERTS ioctls on KVM VM and
2) SNP_{SET,GET}_EXT_CONFIG ioctls on /dev/sev
Both store the passed blob and neither communicate it to the firmware. 
This makes me wonder - how does the attestation report (cooked by the 
firmware) get signed with those certificates passed on by the HV userspace?

Also, the cached blob in /dev/sev seems redundand - the attestation 
report is retuned for a specific guest so having a blob in the KVM VM 
makes sense and KVM unconditionally reserves memory for it anyway. And 
for the HV itself the blob is useless (?) so why bother with caching it 
in /dev/sev.

And GET ioctls() return what SET passed on (not something the firware 
returned, for example), what is ever going to call SET? The userspace 
can as well cache what it passed and save a bit of the code/memory in 
the kernel.

btw SNP_{SET,GET}_EXT_CONFIG are documented in 
Documentation/virt/coco/sev-guest.rst but implemented in 
drivers/crypto/ccp/sev-dev.c (not sev-guest.c).

What do I miss in the big picture here? :) Thanks,


-- 
Alexey
