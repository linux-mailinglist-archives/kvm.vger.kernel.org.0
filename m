Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2087866508D
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 01:49:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbjAKAtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 19:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbjAKAtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 19:49:21 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C02C20B;
        Tue, 10 Jan 2023 16:49:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHCPBor+mfwrPIkqA0xoTyU/aPulx5uID55za23lGttY1VG4al0I0IzPxQJNmv5wKAE5+CbXX5VtQ83Y8flJ/CNMHr37n6RgqHP27JOcH9ByOPVEpUWDiy0kTj68X6KDDfaJgzdtAIjN4CgMEgyxzVSrlAoLS2x6jwbizDbrGiFMdUh8ERaly5jTbfQfk17MmtDlyGkZeFTJMi6oKR/+imKnZBOGBKYo53sohlYfgP1Tg8L8+Z+HXllG6j6L7TH6K8cS13KDOSZiJEYtPasrHC5Zqvufdp03VU/Asl2m0PI+HGJT7pAPQYUAO/mYcvAKd8wFFKvq9wcQzRkqDihO0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wfSHFr6X0BH97Bm0Q7jo3csGA9Dd0wuPzMVaGNg1g2g=;
 b=G1H2z9AnHW+oIrPUr1FXL0IJm3jzKRtTIWmkqlE/EhU8irU2u/RoE1Z3iYFKXEQ3A67bO+ZNxiPe7CBw72ZWAffRwGSz/8qAvvXanjhZ6Y2+2LLefDNJbutNCry5h8H0aUnRL9TsHUVBh/8i3r9WcMBA4VHgilKz/MPTUToLSSbYxxy8FwFMMbSv/kChQhPr7Wf0TYpjZTKVJdje3KJHrKNfS/i2+7gGNu338F3BX424ZfK4QHnNxfsk2Gtjxwxv+SzHj/H3LPG0N+/PmteHo4CKExXihwZYY2NuRn17eafSZZvJ8/6ZHDDYF39OkvOLT/xT05rubZ1m/d2KyADsaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wfSHFr6X0BH97Bm0Q7jo3csGA9Dd0wuPzMVaGNg1g2g=;
 b=yclVx4rVBjKg7jBwvfs9uDNygPaZFKgyXL97izrKwypBnIlTfWmmcNd14Z+8qG7s1hBNBgjp4zxLV28WlVgcVmE8sDaX1/a+iL3jR78SCDoDWEj5DqR2tAZx1BTksH8P9lZty6YyOeugv58CvWPtfKULsc/lvij03vwnCS3VWHk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 CH2PR12MB4954.namprd12.prod.outlook.com (2603:10b6:610:63::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 00:49:17 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 00:49:17 +0000
Message-ID: <55e5f02f-4c1f-e6b0-59ba-07abc4d3408f@amd.com>
Date:   Wed, 11 Jan 2023 11:48:56 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
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
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <385016f9-e948-4f7f-8db3-24a0c0543b3d@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY6PR01CA0102.ausprd01.prod.outlook.com
 (2603:10c6:10:111::17) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|CH2PR12MB4954:EE_
X-MS-Office365-Filtering-Correlation-Id: 9df92270-e9fc-460c-659f-08daf36daa97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cVKXA9/0MuJeHFCLYQU/3X1LqPN9U2aAG0zNYaOOyxX6nyOrfCKupcx+dTS47MHMU7v0MhQmKzOqBNeGiQ7eo1lubMF83VgSh/V0gErnAf5sfDS9jBWA0rCThoqelBE45GuA1c221GZxVyRb7q47yBxRbod6QGOBy5v4UM5vvWYnvp/2XzHRZ4SO9viRqn87gKSrpH7SHHVkk+vcPUGYn7ZiF07g7xauZKK/Sl3im8rsI4HK52i52SUIG3gfEQd9m7zFXb7s+gClw5jxNvqgYyivH07qSLiTG1B4Uo368nA5iGxyWEMT5boSJWxNNROkBTyDgC8e8tNabmNfAsuLRdXSivAYcNsVlgBthlK5gmC6XdanC77M4njT7rBZwzgxjLiHBObukJVSBVSTIY1uoDFLWzQRwaZiNg3EWHv7oEUNBOD7gz5IHiJjirRaRTpg8oS36JFn025CZcw54aP1c8fw9s66aimk4dNvPAVY/DvLaZH6SxkRVEH4qFzUpSBCLe5G9FIc0O7JeN93qzjv+HK/18zwInC3sN9JjWjhSRagGB3TYPRlUdwartAVR1jlfBmhokRadu/aiXRGdp6Vz4+4NfCHYBzWV9b59Tl7/TfrggtgPbE5v/9HNf3UtB/r9ZeG7Dl4qURGuvvBNK4FVVl5RC5miw9vYl5AUciga227z05pkGTncGjNtEldxXRGnXTF3dWXtLxrl9Cs5M/qbD9u4CAb8PS2Ccfs8F/sCMgZ1JvdNwckMiIPReqtz/I5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199015)(6506007)(38100700002)(31686004)(6666004)(53546011)(2906002)(478600001)(6486002)(966005)(2616005)(7416002)(30864003)(26005)(186003)(6512007)(7406005)(5660300002)(316002)(83380400001)(8936002)(36756003)(31696002)(41300700001)(8676002)(110136005)(4326008)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHVaTDBwcHhoZ3V0cUlpc2hyaWRHUzdmSnNXbFZLYjZoTmYreVB4YkZST0x5?=
 =?utf-8?B?VlRLMGhIL1MvaFRtN3BnbjRCd1NsQjNTNnk5ZzQ0YVdpRDVTK044azZRcjRX?=
 =?utf-8?B?QmdNTGN4aHFUS05mYWNMMTJaU3FMcWJ3K0NaTDl4TlJTbWg5Y3dZQ0cwWHl3?=
 =?utf-8?B?NGVnRnE1WWJITVFqK1IrUGtPcWk5b1VhTUxxNC9WbWtoWG9WR1BGQnBjdUVo?=
 =?utf-8?B?YnNqL09qMGJKS2tUWDlxQzN1Mk5pOFoySytwN2ZGY3E5YTljcUQ3anhyWkkr?=
 =?utf-8?B?eXF3WmZmbzNmd29yNzRKcWtCL3ZQTHJJRlBHR0dDaFNDOTlEdi9iOVpMMGdX?=
 =?utf-8?B?UU1jbDBsK2QwSXV1QzEzcE5SQkVxYUtFTGhBU1F3U1dqeUZOeWwxcXlpS2da?=
 =?utf-8?B?bHlJblRQSXNERkhHVVpRRjQxRElWM29RS3BTek5DTU95V0M3cFkvb3FFcVkz?=
 =?utf-8?B?RlFZUmhxbjBHcVphcEl0MjYySm0wMEhWRWNHTGFoc3dRRTVOT0pKZ2tDMHNs?=
 =?utf-8?B?bjRqbTFmcy9UWVB3UGZobEZ0Z0pWdUJKWHA1M2pNOFovQnduU0hrUjVWZnVK?=
 =?utf-8?B?RCs5bzZwcWk4Qkk3R3BjQm9zN3hHQU1KNVJCNmxvS1NzQUoxdW90K1h2L1Az?=
 =?utf-8?B?bjVrSWNFMzBPTTV6VVZkb3dUZ3l5TTVNNzUrNUFTNFY2SCtwOFk0Yk1ZUVNL?=
 =?utf-8?B?QUdOWjRRS2owa05NbGl3UkF5SHZ6a3VxZUM4b21zM1JJODBwRVByT3paSTdF?=
 =?utf-8?B?d3N2KzJuaSttdHhuejB4eFZTZnAyMmRuYk1kQ2lrMDNaWnNGNXFmdjkwL0pr?=
 =?utf-8?B?TWh1YkpWVEU2TGZEbXRjY0ZLSmtpR0ZoY1JRK05zU3UxYk9wRVc0R29ySDEz?=
 =?utf-8?B?UFBTK3dPcVBuV24wbWlFVE5tMWQ1RGk2N3VSWVFxSjJGRzl6dlI4SWhqY1hX?=
 =?utf-8?B?SmRTRmw0M1VpaENuQWFEcjFmQU9VbXROM0MzTFhmV1dQNERNYzlId1Z1ZmlK?=
 =?utf-8?B?czVqVXNIcVBla3BTdmpCcm44WWZ3M2ZnaVFOS1FKTHFJUzQ0L1FXd1lTNVpY?=
 =?utf-8?B?VURaTUhyTElDUUxNVDY3WTNwZ3czeHFJZGVUOGI0cmxsakNjN0ROUCtqK3lj?=
 =?utf-8?B?SVhlNkNFQWVlcVcyM0p6UG9TZHpHV1ZiR1FzSkV2WWVwejk5QmxLcnRrNnZx?=
 =?utf-8?B?NGwwYTFta3ZRa3RMVVh5OWl0b2dGZ2RIYVMwMW9DMXMxVEVERTMyRDdDK0xM?=
 =?utf-8?B?VWdWVUdFZDQrdkk5bHRvMVBoSlYzTFBuS2pBRXI0VGluVFBjdEVGNUFPQnNL?=
 =?utf-8?B?ZkV2S25VTG1pZDByaGtEMjNpMXNITjhVWlRZcSt4TXhjWEppdkpFQTQydnRM?=
 =?utf-8?B?MlM1ZGxWSnk5RkxwZjdYWll6S2psa3VmZnNwL24vaEI2WnRWUkV4WUE0RE9m?=
 =?utf-8?B?ZDBOVVUzeUEySEt4ei95eUxWVFdKazh0dXBUOFdJQ0hibXRBaWU3REFTTXpL?=
 =?utf-8?B?MU55OFBvNERhdDUyQ2tGblloZnlCRlJsdjZheVh3b1lrU3lHVW1UUC9GZzlW?=
 =?utf-8?B?dkdEWVZYbXQ1ekJqYS81Q3JXb2pWTUwrajR4SkR2OTNwSjJwancvZEVlOEJt?=
 =?utf-8?B?Nkg5ZUxEVEYvSHFvVk1zYlFydUJGZWZmdW5GbnZCeThGR0svRTVTblNBM1hh?=
 =?utf-8?B?S09tYkltek45dVRQTFMzU1k1YlRDVEY3MzQ1RXhuYlQzeDc1WGg1NmhESndl?=
 =?utf-8?B?WjJnaDVCaitUZmw1WkJwUm5qMEFPNTJZT3d4VmdEeUprTW1wUWR6WTN4ejdk?=
 =?utf-8?B?eFpSUU9FYk1EYUVnUXcrQ2hQQ3lUTE5WRmdnTy9TazJwQnZNTWEzZW1LVWJ0?=
 =?utf-8?B?RTBESk5LZUZzYU9EZ21LRGZIeGxUMTFPWWZUVXZMbFFxTTFlcHZCWDBycXBB?=
 =?utf-8?B?c204bW5WN3E2WjRqOUU5VFYwb2FrNVRXVDVSbDAwRXJHQXZFL0ZjNDhVdDRh?=
 =?utf-8?B?ak9pS0VtR25RRFZydWo2SG05N01Nb2FJVzRheDI3OVdPdWgwSWN1bU95YmlT?=
 =?utf-8?B?SmpJc1N0V2FpL0hTYjFoV3IxQ05QQWozQ1JRNHZjdGt2VFhGQVNZcG9mL1Nv?=
 =?utf-8?Q?HnzGsbwZy5XT7k8D9xuKYJecr?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9df92270-e9fc-460c-659f-08daf36daa97
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 00:49:17.2254
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: etsV1D4f2+KUeotq6ok/QxnaxgU2AJGO20QVexKFp/d4EbdAWtk+7qiaFYTPZg7SjEfNipfditM7UmPAXLF1IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4954
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/1/23 19:33, Kalra, Ashish wrote:
> 
> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>
>>
>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>
>>>>> Version 2 of GHCB specification added the support for two SNP Guest
>>>>> Request Message NAE events. The events allows for an SEV-SNP guest to
>>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware specification.
>>>>>
>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>>> difference of an additional certificate blob that can be passed 
>>>>> through
>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>>> provides snp_guest_ext_guest_request() that is used by the KVM to get
>>>>> both the report and certificate data at once.
>>>>>
>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>> ---
>>>>>   arch/x86/kvm/svm/sev.c | 185 
>>>>> +++++++++++++++++++++++++++++++++++++++--
>>>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>> index 5f2b2092cdae..18efa70553c2 100644
>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, 
>>>>> struct kvm_sev_cmd *argp)
>>>>>           if (ret)
>>>>>               goto e_free;
>>>>> +        mutex_init(&sev->guest_req_lock);
>>>>>           ret = sev_snp_init(&argp->error, false);
>>>>>       } else {
>>>>>           ret = sev_platform_init(&argp->error);
>>>>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct kvm 
>>>>> *kvm, unsigned int source_fd)
>>>>>    */
>>>>>   static void *snp_context_create(struct kvm *kvm, struct 
>>>>> kvm_sev_cmd *argp)
>>>>>   {
>>>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>       struct sev_data_snp_addr data = {};
>>>>> -    void *context;
>>>>> +    void *context, *certs_data;
>>>>>       int rc;
>>>>> +    /* Allocate memory used for the certs data in SNP guest 
>>>>> request */
>>>>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, GFP_KERNEL_ACCOUNT);
>>>>> +    if (!certs_data)
>>>>> +        return NULL;
>>>>> +
>>>>>       /* Allocate memory for context page */
>>>>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>>>>       if (!context)
>>>>> -        return NULL;
>>>>> +        goto e_free;
>>>>>       data.gctx_paddr = __psp_pa(context);
>>>>>       rc = __sev_issue_cmd(argp->sev_fd, SEV_CMD_SNP_GCTX_CREATE, 
>>>>> &data, &argp->error);
>>>>> -    if (rc) {
>>>>> -        snp_free_firmware_page(context);
>>>>> -        return NULL;
>>>>> -    }
>>>>> +    if (rc)
>>>>> +        goto e_free;
>>>>> +
>>>>> +    sev->snp_certs_data = certs_data;
>>>>>       return context;
>>>>> +
>>>>> +e_free:
>>>>> +    snp_free_firmware_page(context);
>>>>> +    kfree(certs_data);
>>>>> +    return NULL;
>>>>>   }
>>>>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>>>>> @@ -2653,6 +2665,8 @@ static int snp_decommission_context(struct 
>>>>> kvm *kvm)
>>>>>       snp_free_firmware_page(sev->snp_context);
>>>>>       sev->snp_context = NULL;
>>>>> +    kfree(sev->snp_certs_data);
>>>>> +
>>>>>       return 0;
>>>>>   }
>>>>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>>>>> vcpu_svm *svm, u64 *exit_code)
>>>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>>>       case SVM_VMGEXIT_HV_FEATURES:
>>>>>       case SVM_VMGEXIT_PSC:
>>>>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>>>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>>>>           break;
>>>>>       default:
>>>>>           reason = GHCB_ERR_INVALID_EVENT;
>>>>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct kvm_vcpu 
>>>>> *vcpu)
>>>>>       return 1;
>>>>>   }
>>>>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>>>>> +                     struct sev_data_snp_guest_request *data,
>>>>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>>>>> +{
>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>> +    kvm_pfn_t req_pfn, resp_pfn;
>>>>> +    struct kvm_sev_info *sev;
>>>>> +
>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>> +
>>>>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || !IS_ALIGNED(resp_gpa, 
>>>>> PAGE_SIZE))
>>>>> +        return SEV_RET_INVALID_PARAM;
>>>>> +
>>>>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>>>>> +    if (is_error_noslot_pfn(req_pfn))
>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>> +
>>>>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>>>> +    if (is_error_noslot_pfn(resp_pfn))
>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>> +
>>>>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>> +
>>>>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>>>>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>>>>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>>>>> +
>>>>> +    return 0;
>>>>> +}
>>>>> +
>>>>> +static void snp_cleanup_guest_buf(struct 
>>>>> sev_data_snp_guest_request *data, unsigned long *rc)
>>>>> +{
>>>>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>>>>> +    int ret;
>>>>> +
>>>>> +    ret = snp_page_reclaim(pfn);
>>>>> +    if (ret)
>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>> +
>>>>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>>>> +    if (ret)
>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>> +}
>>>>> +
>>>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, gpa_t 
>>>>> req_gpa, gpa_t resp_gpa)
>>>>> +{
>>>>> +    struct sev_data_snp_guest_request data = {0};
>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>> +    struct kvm_sev_info *sev;
>>>>> +    unsigned long rc;
>>>>> +    int err;
>>>>> +
>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>> +        goto e_fail;
>>>>> +    }
>>>>> +
>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>> +
>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>> +
>>>>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>>>> +    if (rc)
>>>>> +        goto unlock;
>>>>> +
>>>>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &err);
>>>>
>>>>
>>>> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
>>>>
>>>>> +    if (rc)
>>>>> +        /* use the firmware error code */
>>>>> +        rc = err;
>>>>> +
>>>>> +    snp_cleanup_guest_buf(&data, &rc);
>>>>> +
>>>>> +unlock:
>>>>> +    mutex_unlock(&sev->guest_req_lock);
>>>>> +
>>>>> +e_fail:
>>>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>>>> +}
>>>>> +
>>>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, 
>>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>>> +{
>>>>> +    struct sev_data_snp_guest_request req = {0};
>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>> +    unsigned long data_npages;
>>>>> +    struct kvm_sev_info *sev;
>>>>> +    unsigned long rc, err;
>>>>> +    u64 data_gpa;
>>>>> +
>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>> +        goto e_fail;
>>>>> +    }
>>>>> +
>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>> +
>>>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>>>> +
>>>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>>> +        goto e_fail;
>>>>> +    }
>>>>> +
>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>> +
>>>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>>>> +    if (rc)
>>>>> +        goto unlock;
>>>>> +
>>>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>>>> long)sev->snp_certs_data,
>>>>> +                     &data_npages, &err);
>>>>
>>>> but this one does not and jump straight to 
>>>> drivers/crypto/ccp/sev-dev.c ignoring sev->fd. Why different? Can 
>>>> these two be unified? sev_issue_cmd_external_user() only checks if 
>>>> fd is /dev/sev which is hardly useful.
>>>>
>>>> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query extended 
>>>> attestation report" added this one.
>>>
>>> SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and 
>>> that's why it goes through the CCP driver interface 
>>> snp_guest_ext_guest_request() that is used to get both the report and 
>>> certificate data/blob at the same time.
>>
>> True. I thought though that this calls for extending sev_issue_cmd() 
>> to take care of these extra parameters rather than just skipping the 
>> sev->fd.
>>
>>
>>> All the FW API calls on the KVM side go through sev_issue_cmd() and 
>>> sev_issue_cmd_external_user() interfaces and that i believe uses 
>>> sev->fd more of as a sanity check.
>>
>> Does not look like it:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/crypto/ccp/sev-dev.c?h=v6.2-rc3#n1290
>>
>> ===
>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>                  void *data, int *error)
>> {
>>      if (!filep || filep->f_op != &sev_fops)
>>          return -EBADF;
>>
>>      return sev_do_cmd(cmd, data, error);
>> }
>> EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>> ===
>>
>> The only "more" is that it requires sev->fd to be a valid open fd, 
>> what is the value in that? I may easily miss the bigger picture here. 
>> Thanks,
>>
>>
> 
> Have a look at following functions in drivers/crypto/ccp/sev-dev.c:
> sev_dev_init() and sev_misc_init().
> 
> static int sev_misc_init(struct sev_device *sev)
> {
>          struct device *dev = sev->dev;
>          int ret;
> 
>          /*
>           * SEV feature support can be detected on multiple devices but
>           * the SEV FW commands must be issued on the master. During
>           * probe, we do not know the master hence we create /dev/sev on
>           * the first device probe.
>           * sev_do_cmd() finds the right master device to which to issue
>           * the command to the firmware.
>       */


It is still a single /dev/sev node and the userspace cannot get it 
wrong, it does not have to choose between (for instance) /dev/sev0 and 
/dev/sev1 on a 2 SOC system.

> ...
> ...
> 
> Hence, sev_issue_cmd_external_user() needs to ensure that the correct 
> device (master device) is being operated upon and that's why there is 
> the check for file operations matching sev_fops as below :
> 
> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>                                  void *data, int *error)
> {
>          if (!filep || filep->f_op != &sev_fops)
>                  return -EBADF;
> ..
> ..
> 
> Essentially, sev->fd is the misc. device created for the master PSP 
> device on which the SEV/SNP firmware commands are issued, hence,
> sev_issue_cmd() uses sev->fd.

There is always just one fd which always uses psp_master, nothing from 
that fd is used.

More to the point, if sev->fd is still important, why is it ok to skip 
it for snp_handle_ext_guest_request()? Thanks,


-- 
Alexey

