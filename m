Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE083683454
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 18:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231418AbjAaRwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 12:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjAaRwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 12:52:53 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778DE30D8;
        Tue, 31 Jan 2023 09:52:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxK9Hxur27nC+CXzjYNHqqLk0XLjqMT6CVkir8dZT92yk3su8G40sKLRq3CQAhZohN0B/FIrerbqB3zwcHmXB0HJaWKsLytj4WYz62NKvNEt4Xfo5LlM1ZodLP2ns5GEw+HnpGJsXuhdhCVKhh20tkSASTqvq7aDU8sFQpJhdcJI2gtpxYpwENl170/cXQi5XRHfHJ+k0fyur9k3E0IPeC7etKDx1s/TrOAJeWwWjc3oyWShlgiJ+IPTvRAQDXK/cmg56I9/veY5n06rAsuiwEr3KcPw8O6FST6RWUZ4nXr63OmDmHiN3VNqXSZMwFmMIMuezVyoPWdO82j3mGtufA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ccydaN/Un3a9OOa07cPrIJdbZooIBzb/8BFp+j2G50I=;
 b=KwV32lUD6xZ3QetD80Dg+0PPJ+SADLMMjyA46GVdzj/KKv8f6wvHMMzo3M2XCP7YP60bwoDX1yKW4cW2c/3jMVOmxsOMND1cWphZLg5xk+ShUARzn+bpCQT4RNxBL51VafeSOwk+JzU7Shmc6bW1chrDx0aqQH6N1+l3G73v65sM2y3/oviDJJJNyxSl2S9UOuc5XNRoI4nsTNwLEB2R8GN3nX/wUw/PDZqNtPzOT5/Fi4+3iGyzAQQbb4hDKpo0tHPaDM8g99X6ug/ZsBciqxMD8mcpS2YXzMtQl7M9z0iexS1UCHpC2Qo5hrGUY4rrp41M2bbKo00tts7QIqMozQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccydaN/Un3a9OOa07cPrIJdbZooIBzb/8BFp+j2G50I=;
 b=GF4HuSyTZoVCp1F08wVcNBx5PjwiYk1l88VQjQvtlPA8jH0PiexbIqo/3jLHVg07MqemaDrqD2HPMP10kG4TVlgzmu8+L8FJ/ZnPN9Aob5HHfylGGu9aXKb7n9UdTL1wPa663En7KRyWJwUKnXyyHgFQty/a/ZZYGBAOkOetpuM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by BL3PR12MB6596.namprd12.prod.outlook.com (2603:10b6:208:38f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Tue, 31 Jan
 2023 17:52:43 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::dc5d:6248:1c13:4a3%7]) with mapi id 15.20.6043.038; Tue, 31 Jan 2023
 17:52:38 +0000
Message-ID: <75765583-1807-e5eb-80c4-255ff772ad8c@amd.com>
Date:   Tue, 31 Jan 2023 11:52:30 -0600
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
 <81037a58-6b5c-cde4-79fe-3686d9b8a551@amd.com>
 <b0baa6ee-ea6d-3a30-d5fb-3ec395896750@amd.com>
From:   "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <b0baa6ee-ea6d-3a30-d5fb-3ec395896750@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0360.namprd03.prod.outlook.com
 (2603:10b6:610:11a::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|BL3PR12MB6596:EE_
X-MS-Office365-Filtering-Correlation-Id: 3218ddbf-16f0-44eb-469d-08db03b3f0b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +R/KOeLKBNU/JgizaG/21rlqo/TabxdPQXrTK/2w1Db2mAadsWP/kdCNzSi5rE4FJJFo/IjzymmuGksdbdWe6iPKUAfu77g6m+qeIJ8IkuNiJ/IF/VFU0AYeMxmgRbffabBQ2/6eBdW+8ED5F8tWNx1F8+EyU4AmudjxzwlQlI33Yaz43ZyqTlLaB7tWHygHY2+1h88lwJlH9GggewHVYbA7ZCIFj99MKn76F19HhZAlE1DAn3xkaUaaMuZmO389lV5a0o8dTYxj3l0p2judzG6N/4x23ZBcatP3mG3YFW7Byo1IBICZoQdRVa3nEa/akrUracnV6Xh4nxGXnQrOf67RU7Vgl93nAa3ghGBy4IahKFoP6KLl21XykkueJn5ghu/Ok+ajce3GeWyKOX6Q5qu2qiclXBQrtqCzWoJU+f/yprXMYkONXbV5fLlFVI6t4m6roC34cGXQbws/mbdoYI9MfLhJLiL8d6sAzo98ZBFqfQtzZiw8dbT3RTcPV8X5uDVUMm8fJbatEg4dhfTuOB3Pj0TsySyi3d6PRtigWTqOps+PVZV0Z1i9TLUO/fEwkh/ldGAJWUSrOIyrfG0CuBXE4BMnQLn/stfgcZ1AEdDZzZOdFBuqK+VDePKmrB1uXQqbPA1vKPGteTDfeTbdUvZwrOSTI1sfb1fEuJCSwqMDQ7cJgNiMV7uWjj+riK7Xaax42FVbYF6mNV1nOydxxBbzPqyoZIOmnyiJcH9c6vXiCmmCmgk8EmE7bieOceZ3gFXBwJ2PYqTRkcd85azePA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199018)(53546011)(7406005)(5660300002)(316002)(8936002)(6486002)(478600001)(6666004)(86362001)(6506007)(2616005)(38100700002)(31696002)(186003)(26005)(966005)(36756003)(6512007)(30864003)(7416002)(110136005)(2906002)(8676002)(66946007)(66556008)(66476007)(4326008)(41300700001)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVMwS0FOczhVVUEyM0h4bmNycmJLWTFteTBXaDdnMVRhcE9SUW12UkU4anMx?=
 =?utf-8?B?dVF4ekU0aFA5enZsQkprOUU0QTNUN1o4REtHcW9FbUdIRnFCZWg3bWZDVHJV?=
 =?utf-8?B?c3JxTDNzajhWanhqa3NhU0RBQStRaVJkaFFXMTNqcjZhY2JvdlE3WXlVWVh2?=
 =?utf-8?B?MnV1RDRVbGQyTFZTQ3RkdCs2K09Ga0JwaHBNUDZ1d1Nnck82RkdlN0hDMTgv?=
 =?utf-8?B?TFVWc0lmMFFIRXRaQk1OaUNyYVI5ZlZ4VktKOGJSMUtLTTJZTDBNOXM5UDg0?=
 =?utf-8?B?ejZZSC92VkxnOWpyQjUzZlJ2bVFqUHNEWlhkVjcrNE1RenhXZkF6Ni9YaVZ4?=
 =?utf-8?B?WmYxclkyU2xKYTZiQW5qVEo4S0Z1QjNCdy90Z0EyUU9Xdm5XcnBqVkxGZ1dQ?=
 =?utf-8?B?RGdJVDF1TXB2bUpoblVnOTl3c2tYd2RxTzdvci9oTFBnKzl3Q3dRZGRGU1kv?=
 =?utf-8?B?cG5vT0FvTks2blpYQXRXbUNJODduTkM5bVRsNUhlTS9VQjFpeHplUGJpcE5l?=
 =?utf-8?B?b0lMR1h2MGY3cUw1K0sxaE5qSXhLR1dBMTQ1cHJ6eUxTTTE2dmI5N1dBTUJ2?=
 =?utf-8?B?c3U5eWwvN2dhWmM5LzV6THU0dlNQa2tjcXFuWjAwSDBDbzRRNTNBYVpwL0Ix?=
 =?utf-8?B?TThsVjBLcDBxRTBvK0V0T2E2ci83elQxbWZzV21KUlY0THZ3L0N0c0NScWdC?=
 =?utf-8?B?bW1LT1FNK3NnUFQ5TGxFaXFOQzFMcEpSS2w5OWtBNzRmUHYxNDFlTmgrSlV6?=
 =?utf-8?B?dElsUkxrbTNNZkxhRHlFQ2FPZ1psODZUSWxONUNqUGNOckluM1I5UUdRUVpB?=
 =?utf-8?B?TzdxMVN1eDN1emU4ZDg1aEZYN1ZYVFZsQ3NQKzJoZFJ6VnFIQmk4cEVpanA5?=
 =?utf-8?B?TGFCaFhESXFKRWZwaU12LzRVUDBFY3RQNktxcVROVFNlMU8wM0tSQkd4Sktz?=
 =?utf-8?B?VzVzcGE5UXo5UGJ3R0U3N2Z1WnRoUGdiMEZOY0R6Ly9ydk1QdzQxeUczeFVU?=
 =?utf-8?B?MW8rbGltVEltRVZFcGhURllaTkRtZTZPSEpndlVCV0c3V2JIaDVsbFZXSW1M?=
 =?utf-8?B?SnRaaVljeFFLNzRScWRmRnRxd0dMeWVkWkRFdGhtTlVSU2NCaEtQTHBwbEtx?=
 =?utf-8?B?NDdKYW1zMjJnKy9SRUNXQmhqWW52dThwUmFIWG95RWo4WEphaVJEdSsyTFZh?=
 =?utf-8?B?QUlPVDI0MUNnM3dWbE1mWFAyTnduRmlmVXlneXVpWlBTNU1yc0NKd2pXb0h6?=
 =?utf-8?B?cUVpN0h0L2E4ME5uU3JEdXAwZmFCMEVVUytTM3lKWFdyNTNxeVdOU09VcnRu?=
 =?utf-8?B?TVBuVndZZTlKYzh5QzZmYWtVNFliYXpEQy9YYThESkplQjl5WGVnYm5SZlZM?=
 =?utf-8?B?ekJWcTMwMkZjTEt0L2h3UEkxNlpCSWlBTElBbWpzeVZBSS84VHdBNEtCK2Ru?=
 =?utf-8?B?S201SThCMm15Y3RvUWdGYVJ4YU1tT0pIdTg4SWF5c2dHdktJMjFpOWFPc0J6?=
 =?utf-8?B?SDlicktTTHhkWkRpZmwvZ3hobGltV04wdTFUMVB5LzFzNmlZUkVtZ3RRRjR0?=
 =?utf-8?B?OEUvVVRtTHp2ZnVQTk1FL2d1TDlzZ3ZScTJYajdmTlhUbzNDZHovMnJIZ3lP?=
 =?utf-8?B?OTd0dXI0UE1YU2xVbFBzczN3VURNQ1B6dVcwRGF0RU1DL0dxY0drZy9ic3NK?=
 =?utf-8?B?NzhzbUhRVVVPNlZlS1B0M3AyRUQxQUF1SHFWdndMRGhTa0lyNVNmVW81a1Nt?=
 =?utf-8?B?dTNGaE9kMEV0RnRZZXZJL1ozTFBzbVNBWnNyRU81ZkViOUxMdnBhS1YxQktH?=
 =?utf-8?B?Y0w1VlZWWGt4TWRkUThIRFNGa05reEYvdlZTSUdBQkYwcC90UWxIb3Y5dWZ6?=
 =?utf-8?B?VGxKOFlpUVdCcjRHS20wM0ZCNTNTT1ZnL0NPMzY0T0VReUNxTGZEcUVBZ2F6?=
 =?utf-8?B?K1JzUE5IWTZ0WTI4Wi9ac3VLWTVjeXdRcnRTaTRKWVdCU2YyNTZmVXpXZzNx?=
 =?utf-8?B?Wmx6ZnZHRzNER0c2NHpFdkJmZjJ3UTZDTGJZK2dUcndNb01YZnMrUHBQQnVv?=
 =?utf-8?B?bGNtUU5rdmcvYUtEb1BXckllM2tIVW4xaWZ4MzM0WnJ1Y3pXZFpPM2l4cm1E?=
 =?utf-8?Q?dq4c0At+4jk4eBcWeFNHx74FM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3218ddbf-16f0-44eb-469d-08db03b3f0b7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 17:52:37.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IO54m2jMOBHGHkF0MgrS9lG/rXv1e9lurBfa7w7Kjj8qBOaxQe0k06yF8xRbECo8E75sAHuFkcu7h7SHrLMEqw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6596
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/30/2023 7:54 PM, Alexey Kardashevskiy wrote:
> 
> 
> On 11/1/23 13:01, Kalra, Ashish wrote:
>> On 1/10/2023 6:48 PM, Alexey Kardashevskiy wrote:
>>> On 10/1/23 19:33, Kalra, Ashish wrote:
>>>>
>>>> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>>>>
>>>>>
>>>>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>>>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>
>>>>>>>> Version 2 of GHCB specification added the support for two SNP Guest
>>>>>>>> Request Message NAE events. The events allows for an SEV-SNP 
>>>>>>>> guest to
>>>>>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>>>>>>
>>>>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>>>>>> difference of an additional certificate blob that can be passed 
>>>>>>>> through
>>>>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>>>>>> provides snp_guest_ext_guest_request() that is used by the KVM 
>>>>>>>> to get
>>>>>>>> both the report and certificate data at once.
>>>>>>>>
>>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>>>>> ---
>>>>>>>>   arch/x86/kvm/svm/sev.c | 185 
>>>>>>>> +++++++++++++++++++++++++++++++++++++++--
>>>>>>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>>>>>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>>>> index 5f2b2092cdae..18efa70553c2 100644
>>>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>>>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, 
>>>>>>>> struct kvm_sev_cmd *argp)
>>>>>>>>           if (ret)
>>>>>>>>               goto e_free;
>>>>>>>> +        mutex_init(&sev->guest_req_lock);
>>>>>>>>           ret = sev_snp_init(&argp->error, false);
>>>>>>>>       } else {
>>>>>>>>           ret = sev_platform_init(&argp->error);
>>>>>>>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct 
>>>>>>>> kvm *kvm, unsigned int source_fd)
>>>>>>>>    */
>>>>>>>>   static void *snp_context_create(struct kvm *kvm, struct 
>>>>>>>> kvm_sev_cmd *argp)
>>>>>>>>   {
>>>>>>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>>       struct sev_data_snp_addr data = {};
>>>>>>>> -    void *context;
>>>>>>>> +    void *context, *certs_data;
>>>>>>>>       int rc;
>>>>>>>> +    /* Allocate memory used for the certs data in SNP guest 
>>>>>>>> request */
>>>>>>>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, 
>>>>>>>> GFP_KERNEL_ACCOUNT);
>>>>>>>> +    if (!certs_data)
>>>>>>>> +        return NULL;
>>>>>>>> +
>>>>>>>>       /* Allocate memory for context page */
>>>>>>>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>>>>>>>       if (!context)
>>>>>>>> -        return NULL;
>>>>>>>> +        goto e_free;
>>>>>>>>       data.gctx_paddr = __psp_pa(context);
>>>>>>>>       rc = __sev_issue_cmd(argp->sev_fd, 
>>>>>>>> SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
>>>>>>>> -    if (rc) {
>>>>>>>> -        snp_free_firmware_page(context);
>>>>>>>> -        return NULL;
>>>>>>>> -    }
>>>>>>>> +    if (rc)
>>>>>>>> +        goto e_free;
>>>>>>>> +
>>>>>>>> +    sev->snp_certs_data = certs_data;
>>>>>>>>       return context;
>>>>>>>> +
>>>>>>>> +e_free:
>>>>>>>> +    snp_free_firmware_page(context);
>>>>>>>> +    kfree(certs_data);
>>>>>>>> +    return NULL;
>>>>>>>>   }
>>>>>>>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>>>>>>>> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct 
>>>>>>>> kvm *kvm)
>>>>>>>>       snp_free_firmware_page(sev->snp_context);
>>>>>>>>       sev->snp_context = NULL;
>>>>>>>> +    kfree(sev->snp_certs_data);
>>>>>>>> +
>>>>>>>>       return 0;
>>>>>>>>   }
>>>>>>>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>>>>>>>> vcpu_svm *svm, u64 *exit_code)
>>>>>>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>>>>>>       case SVM_VMGEXIT_HV_FEATURES:
>>>>>>>>       case SVM_VMGEXIT_PSC:
>>>>>>>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>>>>>>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>>>>>>>           break;
>>>>>>>>       default:
>>>>>>>>           reason = GHCB_ERR_INVALID_EVENT;
>>>>>>>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct 
>>>>>>>> kvm_vcpu *vcpu)
>>>>>>>>       return 1;
>>>>>>>>   }
>>>>>>>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>>>>>>>> +                     struct sev_data_snp_guest_request *data,
>>>>>>>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>>> +{
>>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>>> +    kvm_pfn_t req_pfn, resp_pfn;
>>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>>> +
>>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>> +
>>>>>>>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || 
>>>>>>>> !IS_ALIGNED(resp_gpa, PAGE_SIZE))
>>>>>>>> +        return SEV_RET_INVALID_PARAM;
>>>>>>>> +
>>>>>>>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>>>>>>>> +    if (is_error_noslot_pfn(req_pfn))
>>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>>> +
>>>>>>>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>>>>>>> +    if (is_error_noslot_pfn(resp_pfn))
>>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>>> +
>>>>>>>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>>> +
>>>>>>>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>>>>>>>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>>>>>>>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>>>>>>>> +
>>>>>>>> +    return 0;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static void snp_cleanup_guest_buf(struct 
>>>>>>>> sev_data_snp_guest_request *data, unsigned long *rc)
>>>>>>>> +{
>>>>>>>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>>>>>>>> +    int ret;
>>>>>>>> +
>>>>>>>> +    ret = snp_page_reclaim(pfn);
>>>>>>>> +    if (ret)
>>>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>>>> +
>>>>>>>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>>>>>>> +    if (ret)
>>>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, 
>>>>>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>>> +{
>>>>>>>> +    struct sev_data_snp_guest_request data = {0};
>>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>>> +    unsigned long rc;
>>>>>>>> +    int err;
>>>>>>>> +
>>>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>>>> +        goto e_fail;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>> +
>>>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>>>> +
>>>>>>>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>>>>>>> +    if (rc)
>>>>>>>> +        goto unlock;
>>>>>>>> +
>>>>>>>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, 
>>>>>>>> &err);
>>>>>>>
>>>>>>>
>>>>>>> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
>>>>>>>
>>>>>>>> +    if (rc)
>>>>>>>> +        /* use the firmware error code */
>>>>>>>> +        rc = err;
>>>>>>>> +
>>>>>>>> +    snp_cleanup_guest_buf(&data, &rc);
>>>>>>>> +
>>>>>>>> +unlock:
>>>>>>>> +    mutex_unlock(&sev->guest_req_lock);
>>>>>>>> +
>>>>>>>> +e_fail:
>>>>>>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>>>>>>> +}
>>>>>>>> +
>>>>>>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, 
>>>>>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>>> +{
>>>>>>>> +    struct sev_data_snp_guest_request req = {0};
>>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>>> +    unsigned long data_npages;
>>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>>> +    unsigned long rc, err;
>>>>>>>> +    u64 data_gpa;
>>>>>>>> +
>>>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>>>> +        goto e_fail;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>> +
>>>>>>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>>>>>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>>>>>>> +
>>>>>>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>>>>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>>>>>> +        goto e_fail;
>>>>>>>> +    }
>>>>>>>> +
>>>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>>>> +
>>>>>>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>>>>>>> +    if (rc)
>>>>>>>> +        goto unlock;
>>>>>>>> +
>>>>>>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>>>>>>> long)sev->snp_certs_data,
>>>>>>>> +                     &data_npages, &err);
>>>>>>>
>>>>>>> but this one does not and jump straight to 
>>>>>>> drivers/crypto/ccp/sev-dev.c ignoring sev->fd. Why different? Can 
>>>>>>> these two be unified? sev_issue_cmd_external_user() only checks 
>>>>>>> if fd is /dev/sev which is hardly useful.
>>>>>>>
>>>>>>> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
>>>>>>> attestation report" added this one.
>>>>>>
>>>>>> SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and 
>>>>>> that's why it goes through the CCP driver interface 
>>>>>> snp_guest_ext_guest_request() that is used to get both the report 
>>>>>> and certificate data/blob at the same time.
>>>>>
>>>>> True. I thought though that this calls for extending 
>>>>> sev_issue_cmd() to take care of these extra parameters rather than 
>>>>> just skipping the sev->fd.
>>>>>
>>>>>
>>>>>> All the FW API calls on the KVM side go through sev_issue_cmd() 
>>>>>> and sev_issue_cmd_external_user() interfaces and that i believe 
>>>>>> uses sev->fd more of as a sanity check.
>>>>>
>>>>> Does not look like it:
>>>>>
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/crypto/ccp/sev-dev.c?h=v6.2-rc3#n1290 
>>>>>
>>>>>
>>>>> ===
>>>>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>>>>                  void *data, int *error)
>>>>> {
>>>>>      if (!filep || filep->f_op != &sev_fops)
>>>>>          return -EBADF;
>>>>>
>>>>>      return sev_do_cmd(cmd, data, error);
>>>>> }
>>>>> EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>>>> ===
>>>>>
>>>>> The only "more" is that it requires sev->fd to be a valid open fd, 
>>>>> what is the value in that? I may easily miss the bigger picture 
>>>>> here. Thanks,
>>>>>
>>>>>
>>>>
>>>> Have a look at following functions in drivers/crypto/ccp/sev-dev.c:
>>>> sev_dev_init() and sev_misc_init().
>>>>
>>>> static int sev_misc_init(struct sev_device *sev)
>>>> {
>>>>          struct device *dev = sev->dev;
>>>>          int ret;
>>>>
>>>>          /*
>>>>           * SEV feature support can be detected on multiple devices but
>>>>           * the SEV FW commands must be issued on the master. During
>>>>           * probe, we do not know the master hence we create 
>>>> /dev/sev on
>>>>           * the first device probe.
>>>>           * sev_do_cmd() finds the right master device to which to 
>>>> issue
>>>>           * the command to the firmware.
>>>>       */
>>>
>>>
>>> It is still a single /dev/sev node and the userspace cannot get it 
>>> wrong, it does not have to choose between (for instance) /dev/sev0 
>>> and /dev/sev1 on a 2 SOC system.
>>>
>>>> ...
>>>> ...
>>>>
>>>> Hence, sev_issue_cmd_external_user() needs to ensure that the 
>>>> correct device (master device) is being operated upon and that's why 
>>>> there is the check for file operations matching sev_fops as below :
>>>>
>>>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>>>                                  void *data, int *error)
>>>> {
>>>>          if (!filep || filep->f_op != &sev_fops)
>>>>                  return -EBADF;
>>>> ..
>>>> ..
>>>>
>>>> Essentially, sev->fd is the misc. device created for the master PSP 
>>>> device on which the SEV/SNP firmware commands are issued, hence,
>>>> sev_issue_cmd() uses sev->fd.
>>>
>>> There is always just one fd which always uses psp_master, nothing 
>>> from that fd is used.
>>
>> It also ensures that we can only issue commands (sev_issue_cmd) after 
>> SEV/SNP guest has launched.
> 
> I can open /dev/sev and start sending commands to the firmware with no 
> KVM running at all. Oh well, we discussed this offline :)
> 

Yes, and as we already discussed we need to support that to get SEV/SNP 
platform status (SNP_PLATFORM_STATUS) and also for legacy SEV commands 
like certificate generation and import/export which can be issued before 
a VM is launched.

Thanks,
Ashish
