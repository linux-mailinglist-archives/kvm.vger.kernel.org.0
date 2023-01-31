Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833F0683761
	for <lists+kvm@lfdr.de>; Tue, 31 Jan 2023 21:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjAaUVb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Jan 2023 15:21:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbjAaUV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Jan 2023 15:21:29 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2063.outbound.protection.outlook.com [40.107.243.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18661ABDA;
        Tue, 31 Jan 2023 12:21:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bxs7fas6v/TEsE9TR5KBdWpguuSnAjJ53ku1RoaQDConC6/1Uh/WyBs+s/EMu8ZyqqnHb7SVvWJtjgFJqHU3tj1QdLIIeIo4KKIPf8X7fg7A0lYoknCqu/WdsGiSMIbEFqIabKKJdMw9vaija+UeJdEl8x20uwU30sKwrrE4OVUK0135qymBG2b2RnUMJ5Q0f8PddIkFXeBWNYLo/w7S/GhH0HMDPjXlmSpTimfHyb6cQZD04zumm/gaWErMD/c3AoYr6omCgCypSI6GiC0yYH6/QLSQevwBqYNyWheY6lDbR9L2kTaSVh2WhqmfRyMlsoetY1OWpxkm7NfQo+aGPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcw4x0waD76PYVcCJhdAmEtZqiSLjynUqMSAzJrP+mg=;
 b=KbxDP4yL4Krer50Sid4VmyMmVUNYHeD2rgoyEkOPw0o+6+lJmQ4XXwOlzuSSZ3jEZ8bAQiXs98ujP0lB3UwnhwOG3aRwy7YL9IS8DAjvTvCl3HgM2okeAjfwzTo6mgjHt6pDMc+Mb0l8wGg98cnl6CzRVpsuCuKKKigEhd047TMXnE5nlK8+vLpfc3c7n1nO3TfqSV7stm2AtLkUlcl6N1hTevi6Nk1gPMRgXRVdu2HfVxa9LdWRLlWxCB96Cufp7B+/rB1FA1rp9K01U7g1n8uMNDrFtwr3MqQ2wSjUBD4kOpsXfSY2N2GIe35s3veJuyImhJMSjuG5GsmWt7qUug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcw4x0waD76PYVcCJhdAmEtZqiSLjynUqMSAzJrP+mg=;
 b=S3pT87xzWsAutEOd8knjlm3qoTdUtxEHycFbJbiX7Q2bDSLaoEeSZ37kSvpXrmTO0rv/OlbBsoFACGks80GQVia+C3TepQMQ3KuzgDAYBfJhQantnI6ZEtFWqsPGXI9ietm52bIvVOuF5puF3u9LE62+PsoMe7Paxmdj0ng8GPA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB2843.namprd12.prod.outlook.com (2603:10b6:5:48::24) by
 SN7PR12MB6959.namprd12.prod.outlook.com (2603:10b6:806:261::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 20:21:25 +0000
Received: from DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf]) by DM6PR12MB2843.namprd12.prod.outlook.com
 ([fe80::2867:7b21:95a4:aaf%2]) with mapi id 15.20.6043.036; Tue, 31 Jan 2023
 20:21:25 +0000
Message-ID: <7fb25176-3752-1be3-66d4-a7f5a0e1617a@amd.com>
Date:   Wed, 1 Feb 2023 07:21:08 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH RFC v7 52/64] KVM: SVM: Provide support for
 SNP_GUEST_REQUEST NAE event
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        "Kalra, Ashish" <ashish.kalra@amd.com>,
        Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
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
 <dbcb6666-270a-4867-6de7-73812d32fd8c@amd.com>
Content-Language: en-US
From:   Alexey Kardashevskiy <aik@amd.com>
In-Reply-To: <dbcb6666-270a-4867-6de7-73812d32fd8c@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SY5PR01CA0051.ausprd01.prod.outlook.com
 (2603:10c6:10:1fc::11) To DM6PR12MB2843.namprd12.prod.outlook.com
 (2603:10b6:5:48::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB2843:EE_|SN7PR12MB6959:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bff5853-cedd-49d4-6260-08db03c8b97a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: //+mLgRSzFuTQRmu+L+YzhDKI63D2G86i0tyg7bSXfN1SeqaFVGxnVEM1F0aX05MEBtrkjkaks2NpHgbYOGZsHyMs327150tLktCSxNjlCkClAObHlvcuR3m1R41/Yl5VDZpbWy+1+1k2prqjfeqoE3AHWJSATGjJrj1tKMFaT+Mo4dRCWntMoVgzCmSU8wCbaLTCpktiuRtdhM/Ko1M3Qc6lhxPU2vRUY1aKgQgwUkO4VCHcSS05WoBE1yvB5Ya6Q8ELd/TB7C2I/bPW7ZzmU4VGMavKuHqgBllSFjhuqdPU1JB9kBLtJqCiZXf88FwWT+JpV+xy1/lg9/AlrCBov4Iw0NTG42CsYwURd4cyo4AS9uoZFD3MLkK/BDErT3VeHe7YfcjIfB+7aaxYQb2rAvL5JmT+vnuwzQ4iEZj14J+1ZkZAL9PdH47QZD2ZoCSKoPhxgwghrctQbZlAmF0arRY9irw2dHkKRMHN37m4mDK8Q+S/ZSvmt9cbc2fPHwWF0fJy4t3yBF86CMP9zZop10gsBbGJ2hLXDNO1KgXthrOGTwjHnTpBwzqlUMKpsBnano9ukwAcDr4jizjZDHiGZ3gcnTkm+kYKZCyKilOFLQFrpUrc1uHUB6w8UWempHrJNX9NIDP6sB+f5tGNdc4tU5RVLETdE5607OMRsMNRK7dTyoEPCGINCNB+QQcj3j19newADvStTr3IZw1hzyxvNXfdnb3rOnEaxxO/wgxXuKKnSOhwJ2puwPNEF5+BLxM25+BdEwSNG1EN+rdKDgBNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB2843.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199018)(41300700001)(4326008)(31686004)(83380400001)(66946007)(66556008)(66476007)(8676002)(316002)(8936002)(36756003)(186003)(6512007)(7416002)(30864003)(7406005)(26005)(2906002)(5660300002)(110136005)(6666004)(478600001)(6506007)(53546011)(966005)(31696002)(38100700002)(6486002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEVHZmJjWG9JQitKOHZlS1RpVWVxK3lNSzFPRHNZem1MWG9XWHN1YmxhK1Zp?=
 =?utf-8?B?dXNIc3FYUTRVWkpxT2JxV0V6SEwyaHFUZEl1NXBsc0txS0xGOGM4NHNHL1Ru?=
 =?utf-8?B?OU0xZGdWTi9MUTJKWk8wTXJLYjYyb0hRNXBXU3NXNkVkR0RiTSt4TWdzQTFJ?=
 =?utf-8?B?T0lhMnhRZlZxaGtudGN0YXVUenlVN09vSDZCVDVWUndWV2tqMzNwaDJ2WkI0?=
 =?utf-8?B?SnZUUHZDbGU1bnpyeWEwdlRwQ3FiMWp4T1g5a0hVRmk0ZXo0dXgwY3FGUXUx?=
 =?utf-8?B?cWJ0OEEyQ1Q3UGJoZ1dKTzZ6RVlyaklFT2NKRXYrRUMwUmRmYmpnYnhqbUxr?=
 =?utf-8?B?K0RWR2hyMWZuSnhUdzFVR0VKWXVzTXNNRFVSeEdKV0Y2Snc2MlBTSk9obU9l?=
 =?utf-8?B?dUdEVHlBVitDdmRpZ2l6d3dTMnQyVnRDYkh3UlZlT29YUHFibUZveEx0Q3lC?=
 =?utf-8?B?ZEJrQk1sL2dsTXlEUm9TdWRlbXhqemlRNWJtOWpEaGVqTnZIbWJqcmlod0FE?=
 =?utf-8?B?RlhCa3FRNHl1NmtwalFKVVhhOXBEc21LU21uWStCcjM0cnd5eTh1Z240ZmZh?=
 =?utf-8?B?ZzZINVI4RUh5YkxLNWtSeXdnVFJLakdLUU1yVXAyQ3QwNXd0MHlmY3ZvM2ph?=
 =?utf-8?B?Zlh1dmNJYXV3ajNUMFJVbE9RUDI5dmtDNkVJR3EzbDFrV2ZXL1VEVktBTHYx?=
 =?utf-8?B?a0UvVVBIZDlLOXV3bFNXbXN4NjhFeldqdjlELzE2N0hTS1BFNExhUjNYZTIz?=
 =?utf-8?B?VjN3Y3VpZEo3R0UrV2ZMbUsxVWJDTFAxck5NTysyRjRDVHI3WnVMeTNDTTZ0?=
 =?utf-8?B?ZzQ0eWZSYWZLQmxYbW1UbUU1c0JzZzRpZGdQUlFnTldhQUlVZGZRcW44TDlx?=
 =?utf-8?B?SjhoTXcwUis3RG1Rc3dWL053VWNJNnFDWjczUzFFek1mRlNPOGVHTTdsTWIx?=
 =?utf-8?B?dDJuMkVlTWFsNnNPaFViSjV3VUc1blREaUZCcXVDWnFmRlFzR2pBY3Vid3ZR?=
 =?utf-8?B?MGFVS21Xd2V4MVhpVU1maVZWVWFNTXd3bnBMVTQyMnY0RU1hWHkvNGlXUHJD?=
 =?utf-8?B?LzBYbFpwRmZydGNNMzQyMTB2N1NPT3hBM2tZL2RXalMwblIxZ0ZnYXZHN0RL?=
 =?utf-8?B?U1lObkhsNmRiajhpeWU0RUdBSFdYbHFSMWFWSHg1elI3bXBTMGJqWkZuV1JK?=
 =?utf-8?B?T2lLTDhsaEQvVWNRSjc2WGZTUDdFd1kyMFpIdkJ0Y2RaUmdXdnpOYnZwaGxL?=
 =?utf-8?B?eHlrVEJQNmJmMkZRTjV5NFNtbFEralJONDlwSWdMT0tXbE9NSDBMNkRQUS9B?=
 =?utf-8?B?Rno2b2xhS1gwdkZkdWt1eGs3alhHdTZOSXdoS3cxb09RaS9wMzlaMUlhWVpF?=
 =?utf-8?B?SkRkVVRDNXNhQlNnTHZRVmkwTytqUWdRaU04TVJFMEZmRlYrUk8vVUpOOUVK?=
 =?utf-8?B?cU5oYk1uWVNMdmN1cGNyNEQ5MUdzRGlKRzBIakcvSTJKZkJoZ1NIT0tWY3dQ?=
 =?utf-8?B?Tkg2R0lPTitDQi9rWHpQa1NOZTA2aG03VjJkRDU0VGVkTmkrdUNRdzdFR1ds?=
 =?utf-8?B?REpJa2lBcUZmcVR3WmN1T2IvZC9GYkdCRVRzR0JXVjBVcEd2dmQ0RjdYYk5y?=
 =?utf-8?B?YWhpMkhtODFPRk51NEN3akpMUTdJcDdhVW1VcXRnRXBacUZHWkNsTkMxYXh0?=
 =?utf-8?B?Sm9FL2lDamVtbU5rSlRTSWhZb0hqcXJEOEVONWhWL2NsQWZ5RDNUZGNhbXlZ?=
 =?utf-8?B?ZStYY0F0Z2hqUCsxeHRqczBuM09PcUt0ZGpxSjFEeVVrdytmeHR5U0Z5Q1pm?=
 =?utf-8?B?MGhPWnVEa3FEZURVNTdabnZENlhqZnpsS0NQM0RxY0Z3dC9XNVhYTDArQUZ0?=
 =?utf-8?B?MFgvRzJOZlozdFdGWDRyTkNUTFBKbEwycmZzRjcrYzBRNnJHMDF5bW1TQkdV?=
 =?utf-8?B?RUtGdWJaa05mS3dpSVVFNTgwZUxMVjJUODM5RS9GLzNITksreVVXcEVhcFF2?=
 =?utf-8?B?dGdVZHQxUDN6cjF1MkZZRzM0Vmh5blpObkZRRXczcUxKZkcwV3hNeWdVNzdU?=
 =?utf-8?B?dUlTWGhoR3VTSXhWcHcyUkUxZHlRemdmcVk4alNRTERpTEJjUWtmWEIwM2Fs?=
 =?utf-8?Q?w/u52GrWM8bJLsKadu6V5atOa?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bff5853-cedd-49d4-6260-08db03c8b97a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB2843.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 20:21:25.1173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TBn+r62wZqBa7dMuxXdaTUkKowHzO1he3LOfFpGDT/T36QtSzlVlreMayFoFkpNUrZ1P69katwDKq0Bm/KHOeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6959
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 01/02/2023 03:23, Tom Lendacky wrote:
> On 1/30/23 19:54, Alexey Kardashevskiy wrote:
>>
>>
>> On 11/1/23 13:01, Kalra, Ashish wrote:
>>> On 1/10/2023 6:48 PM, Alexey Kardashevskiy wrote:
>>>> On 10/1/23 19:33, Kalra, Ashish wrote:
>>>>>
>>>>> On 1/9/2023 8:28 PM, Alexey Kardashevskiy wrote:
>>>>>>
>>>>>>
>>>>>> On 10/1/23 10:41, Kalra, Ashish wrote:
>>>>>>> On 1/8/2023 9:33 PM, Alexey Kardashevskiy wrote:
>>>>>>>> On 15/12/22 06:40, Michael Roth wrote:
>>>>>>>>> From: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>>
>>>>>>>>> Version 2 of GHCB specification added the support for two SNP 
>>>>>>>>> Guest
>>>>>>>>> Request Message NAE events. The events allows for an SEV-SNP 
>>>>>>>>> guest to
>>>>>>>>> make request to the SEV-SNP firmware through hypervisor using the
>>>>>>>>> SNP_GUEST_REQUEST API define in the SEV-SNP firmware 
>>>>>>>>> specification.
>>>>>>>>>
>>>>>>>>> The SNP_EXT_GUEST_REQUEST is similar to SNP_GUEST_REQUEST with the
>>>>>>>>> difference of an additional certificate blob that can be passed 
>>>>>>>>> through
>>>>>>>>> the SNP_SET_CONFIG ioctl defined in the CCP driver. The CCP driver
>>>>>>>>> provides snp_guest_ext_guest_request() that is used by the KVM 
>>>>>>>>> to get
>>>>>>>>> both the report and certificate data at once.
>>>>>>>>>
>>>>>>>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>>>>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>>>>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>>>>>>>> ---
>>>>>>>>>   arch/x86/kvm/svm/sev.c | 185 
>>>>>>>>> +++++++++++++++++++++++++++++++++++++++--
>>>>>>>>>   arch/x86/kvm/svm/svm.h |   2 +
>>>>>>>>>   2 files changed, 181 insertions(+), 6 deletions(-)
>>>>>>>>>
>>>>>>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>>>>>>> index 5f2b2092cdae..18efa70553c2 100644
>>>>>>>>> --- a/arch/x86/kvm/svm/sev.c
>>>>>>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>>>>>>> @@ -331,6 +331,7 @@ static int sev_guest_init(struct kvm *kvm, 
>>>>>>>>> struct kvm_sev_cmd *argp)
>>>>>>>>>           if (ret)
>>>>>>>>>               goto e_free;
>>>>>>>>> +        mutex_init(&sev->guest_req_lock);
>>>>>>>>>           ret = sev_snp_init(&argp->error, false);
>>>>>>>>>       } else {
>>>>>>>>>           ret = sev_platform_init(&argp->error);
>>>>>>>>> @@ -2051,23 +2052,34 @@ int sev_vm_move_enc_context_from(struct 
>>>>>>>>> kvm *kvm, unsigned int source_fd)
>>>>>>>>>    */
>>>>>>>>>   static void *snp_context_create(struct kvm *kvm, struct 
>>>>>>>>> kvm_sev_cmd *argp)
>>>>>>>>>   {
>>>>>>>>> +    struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>>>       struct sev_data_snp_addr data = {};
>>>>>>>>> -    void *context;
>>>>>>>>> +    void *context, *certs_data;
>>>>>>>>>       int rc;
>>>>>>>>> +    /* Allocate memory used for the certs data in SNP guest 
>>>>>>>>> request */
>>>>>>>>> +    certs_data = kzalloc(SEV_FW_BLOB_MAX_SIZE, 
>>>>>>>>> GFP_KERNEL_ACCOUNT);
>>>>>>>>> +    if (!certs_data)
>>>>>>>>> +        return NULL;
>>>>>>>>> +
>>>>>>>>>       /* Allocate memory for context page */
>>>>>>>>>       context = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT);
>>>>>>>>>       if (!context)
>>>>>>>>> -        return NULL;
>>>>>>>>> +        goto e_free;
>>>>>>>>>       data.gctx_paddr = __psp_pa(context);
>>>>>>>>>       rc = __sev_issue_cmd(argp->sev_fd, 
>>>>>>>>> SEV_CMD_SNP_GCTX_CREATE, &data, &argp->error);
>>>>>>>>> -    if (rc) {
>>>>>>>>> -        snp_free_firmware_page(context);
>>>>>>>>> -        return NULL;
>>>>>>>>> -    }
>>>>>>>>> +    if (rc)
>>>>>>>>> +        goto e_free;
>>>>>>>>> +
>>>>>>>>> +    sev->snp_certs_data = certs_data;
>>>>>>>>>       return context;
>>>>>>>>> +
>>>>>>>>> +e_free:
>>>>>>>>> +    snp_free_firmware_page(context);
>>>>>>>>> +    kfree(certs_data);
>>>>>>>>> +    return NULL;
>>>>>>>>>   }
>>>>>>>>>   static int snp_bind_asid(struct kvm *kvm, int *error)
>>>>>>>>> @@ -2653,6 +2665,8 @@ static int 
>>>>>>>>> snp_decommission_context(struct kvm *kvm)
>>>>>>>>>       snp_free_firmware_page(sev->snp_context);
>>>>>>>>>       sev->snp_context = NULL;
>>>>>>>>> +    kfree(sev->snp_certs_data);
>>>>>>>>> +
>>>>>>>>>       return 0;
>>>>>>>>>   }
>>>>>>>>> @@ -3174,6 +3188,8 @@ static int sev_es_validate_vmgexit(struct 
>>>>>>>>> vcpu_svm *svm, u64 *exit_code)
>>>>>>>>>       case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>>>>>>>>>       case SVM_VMGEXIT_HV_FEATURES:
>>>>>>>>>       case SVM_VMGEXIT_PSC:
>>>>>>>>> +    case SVM_VMGEXIT_GUEST_REQUEST:
>>>>>>>>> +    case SVM_VMGEXIT_EXT_GUEST_REQUEST:
>>>>>>>>>           break;
>>>>>>>>>       default:
>>>>>>>>>           reason = GHCB_ERR_INVALID_EVENT;
>>>>>>>>> @@ -3396,6 +3412,149 @@ static int snp_complete_psc(struct 
>>>>>>>>> kvm_vcpu *vcpu)
>>>>>>>>>       return 1;
>>>>>>>>>   }
>>>>>>>>> +static unsigned long snp_setup_guest_buf(struct vcpu_svm *svm,
>>>>>>>>> +                     struct sev_data_snp_guest_request *data,
>>>>>>>>> +                     gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>>>> +{
>>>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>>>> +    kvm_pfn_t req_pfn, resp_pfn;
>>>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>>>> +
>>>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>>> +
>>>>>>>>> +    if (!IS_ALIGNED(req_gpa, PAGE_SIZE) || 
>>>>>>>>> !IS_ALIGNED(resp_gpa, PAGE_SIZE))
>>>>>>>>> +        return SEV_RET_INVALID_PARAM;
>>>>>>>>> +
>>>>>>>>> +    req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
>>>>>>>>> +    if (is_error_noslot_pfn(req_pfn))
>>>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>>>> +
>>>>>>>>> +    resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
>>>>>>>>> +    if (is_error_noslot_pfn(resp_pfn))
>>>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>>>> +
>>>>>>>>> +    if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true))
>>>>>>>>> +        return SEV_RET_INVALID_ADDRESS;
>>>>>>>>> +
>>>>>>>>> +    data->gctx_paddr = __psp_pa(sev->snp_context);
>>>>>>>>> +    data->req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
>>>>>>>>> +    data->res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
>>>>>>>>> +
>>>>>>>>> +    return 0;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static void snp_cleanup_guest_buf(struct 
>>>>>>>>> sev_data_snp_guest_request *data, unsigned long *rc)
>>>>>>>>> +{
>>>>>>>>> +    u64 pfn = __sme_clr(data->res_paddr) >> PAGE_SHIFT;
>>>>>>>>> +    int ret;
>>>>>>>>> +
>>>>>>>>> +    ret = snp_page_reclaim(pfn);
>>>>>>>>> +    if (ret)
>>>>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>>>>> +
>>>>>>>>> +    ret = rmp_make_shared(pfn, PG_LEVEL_4K);
>>>>>>>>> +    if (ret)
>>>>>>>>> +        *rc = SEV_RET_INVALID_ADDRESS;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static void snp_handle_guest_request(struct vcpu_svm *svm, 
>>>>>>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>>>> +{
>>>>>>>>> +    struct sev_data_snp_guest_request data = {0};
>>>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>>>> +    unsigned long rc;
>>>>>>>>> +    int err;
>>>>>>>>> +
>>>>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>>>>> +        goto e_fail;
>>>>>>>>> +    }
>>>>>>>>> +
>>>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>>> +
>>>>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>>>>> +
>>>>>>>>> +    rc = snp_setup_guest_buf(svm, &data, req_gpa, resp_gpa);
>>>>>>>>> +    if (rc)
>>>>>>>>> +        goto unlock;
>>>>>>>>> +
>>>>>>>>> +    rc = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, 
>>>>>>>>> &err);
>>>>>>>>
>>>>>>>>
>>>>>>>> This one goes via sev_issue_cmd_external_user() and uses sev-fd...
>>>>>>>>
>>>>>>>>> +    if (rc)
>>>>>>>>> +        /* use the firmware error code */
>>>>>>>>> +        rc = err;
>>>>>>>>> +
>>>>>>>>> +    snp_cleanup_guest_buf(&data, &rc);
>>>>>>>>> +
>>>>>>>>> +unlock:
>>>>>>>>> +    mutex_unlock(&sev->guest_req_lock);
>>>>>>>>> +
>>>>>>>>> +e_fail:
>>>>>>>>> +    svm_set_ghcb_sw_exit_info_2(vcpu, rc);
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>>> +static void snp_handle_ext_guest_request(struct vcpu_svm *svm, 
>>>>>>>>> gpa_t req_gpa, gpa_t resp_gpa)
>>>>>>>>> +{
>>>>>>>>> +    struct sev_data_snp_guest_request req = {0};
>>>>>>>>> +    struct kvm_vcpu *vcpu = &svm->vcpu;
>>>>>>>>> +    struct kvm *kvm = vcpu->kvm;
>>>>>>>>> +    unsigned long data_npages;
>>>>>>>>> +    struct kvm_sev_info *sev;
>>>>>>>>> +    unsigned long rc, err;
>>>>>>>>> +    u64 data_gpa;
>>>>>>>>> +
>>>>>>>>> +    if (!sev_snp_guest(vcpu->kvm)) {
>>>>>>>>> +        rc = SEV_RET_INVALID_GUEST;
>>>>>>>>> +        goto e_fail;
>>>>>>>>> +    }
>>>>>>>>> +
>>>>>>>>> +    sev = &to_kvm_svm(kvm)->sev_info;
>>>>>>>>> +
>>>>>>>>> +    data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
>>>>>>>>> +    data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
>>>>>>>>> +
>>>>>>>>> +    if (!IS_ALIGNED(data_gpa, PAGE_SIZE)) {
>>>>>>>>> +        rc = SEV_RET_INVALID_ADDRESS;
>>>>>>>>> +        goto e_fail;
>>>>>>>>> +    }
>>>>>>>>> +
>>>>>>>>> +    mutex_lock(&sev->guest_req_lock);
>>>>>>>>> +
>>>>>>>>> +    rc = snp_setup_guest_buf(svm, &req, req_gpa, resp_gpa);
>>>>>>>>> +    if (rc)
>>>>>>>>> +        goto unlock;
>>>>>>>>> +
>>>>>>>>> +    rc = snp_guest_ext_guest_request(&req, (unsigned 
>>>>>>>>> long)sev->snp_certs_data,
>>>>>>>>> +                     &data_npages, &err);
>>>>>>>>
>>>>>>>> but this one does not and jump straight to 
>>>>>>>> drivers/crypto/ccp/sev-dev.c ignoring sev->fd. Why different? 
>>>>>>>> Can these two be unified? sev_issue_cmd_external_user() only 
>>>>>>>> checks if fd is /dev/sev which is hardly useful.
>>>>>>>>
>>>>>>>> "[PATCH RFC v7 32/64] crypto: ccp: Provide APIs to query 
>>>>>>>> extended attestation report" added this one.
>>>>>>>
>>>>>>> SNP_EXT_GUEST_REQUEST additionally returns a certificate blob and 
>>>>>>> that's why it goes through the CCP driver interface 
>>>>>>> snp_guest_ext_guest_request() that is used to get both the report 
>>>>>>> and certificate data/blob at the same time.
>>>>>>
>>>>>> True. I thought though that this calls for extending 
>>>>>> sev_issue_cmd() to take care of these extra parameters rather than 
>>>>>> just skipping the sev->fd.
>>>>>>
>>>>>>
>>>>>>> All the FW API calls on the KVM side go through sev_issue_cmd() 
>>>>>>> and sev_issue_cmd_external_user() interfaces and that i believe 
>>>>>>> uses sev->fd more of as a sanity check.
>>>>>>
>>>>>> Does not look like it:
>>>>>>
>>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/crypto/ccp/sev-dev.c?h=v6.2-rc3#n1290
>>>>>>
>>>>>> ===
>>>>>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>>>>>                  void *data, int *error)
>>>>>> {
>>>>>>      if (!filep || filep->f_op != &sev_fops)
>>>>>>          return -EBADF;
>>>>>>
>>>>>>      return sev_do_cmd(cmd, data, error);
>>>>>> }
>>>>>> EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>>>>>> ===
>>>>>>
>>>>>> The only "more" is that it requires sev->fd to be a valid open fd, 
>>>>>> what is the value in that? I may easily miss the bigger picture 
>>>>>> here. Thanks,
>>>>>>
>>>>>>
>>>>>
>>>>> Have a look at following functions in drivers/crypto/ccp/sev-dev.c:
>>>>> sev_dev_init() and sev_misc_init().
>>>>>
>>>>> static int sev_misc_init(struct sev_device *sev)
>>>>> {
>>>>>          struct device *dev = sev->dev;
>>>>>          int ret;
>>>>>
>>>>>          /*
>>>>>           * SEV feature support can be detected on multiple devices 
>>>>> but
>>>>>           * the SEV FW commands must be issued on the master. During
>>>>>           * probe, we do not know the master hence we create 
>>>>> /dev/sev on
>>>>>           * the first device probe.
>>>>>           * sev_do_cmd() finds the right master device to which to 
>>>>> issue
>>>>>           * the command to the firmware.
>>>>>       */
>>>>
>>>>
>>>> It is still a single /dev/sev node and the userspace cannot get it 
>>>> wrong, it does not have to choose between (for instance) /dev/sev0 
>>>> and /dev/sev1 on a 2 SOC system.
>>>>
>>>>> ...
>>>>> ...
>>>>>
>>>>> Hence, sev_issue_cmd_external_user() needs to ensure that the 
>>>>> correct device (master device) is being operated upon and that's 
>>>>> why there is the check for file operations matching sev_fops as 
>>>>> below :
>>>>>
>>>>> int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>>>>>                                  void *data, int *error)
>>>>> {
>>>>>          if (!filep || filep->f_op != &sev_fops)
>>>>>                  return -EBADF;
>>>>> ..
>>>>> ..
>>>>>
>>>>> Essentially, sev->fd is the misc. device created for the master PSP 
>>>>> device on which the SEV/SNP firmware commands are issued, hence,
>>>>> sev_issue_cmd() uses sev->fd.
>>>>
>>>> There is always just one fd which always uses psp_master, nothing 
>>>> from that fd is used.
>>>
>>> It also ensures that we can only issue commands (sev_issue_cmd) after 
>>> SEV/SNP guest has launched.
>>
>> I can open /dev/sev and start sending commands to the firmware with no 
>> KVM running at all. Oh well, we discussed this offline :)
>>
>>> We don't have a valid fd to use before the guest launch. The file 
>>> descriptor is passed as part of the guest launch flow, for example, 
>>> in snp_launch_start().
>>>>
>>>> More to the point, if sev->fd is still important, why is it ok to 
>>>> skip it for snp_handle_ext_guest_request()? Thanks,
>>>>
>>>>
>>> Then, we should do the same for snp_handle_ext_guest_request().
>>
>> Okay.
>>
>> This snp_handle_ext_guest_request() helper is for returning "Table 21. 
>> ATTESTATION_REPORT Structure" along with the certificate(s) used to 
>> sign the report: "This usage allows the attestation report and the 
>> certificates required to verify the report to be returned at the same 
>> time".
>>
>> I can see:
>> 1) KVM_SEV_SNP_{G,S}ET_CERTS ioctls on KVM VM and
> 
> This allows the VMM to (optionally) supply per-VM certificates that the 
> guest can use to validate the attestation report, instead of the guest 
> requesting separately.
> 
>> 2) SNP_{SET,GET}_EXT_CONFIG ioctls on /dev/sev
> 
> This allows the VMM to (optionally) supply certificates used for all 
> VMs, i.e., there is no need for per-VM certificates.
> 
>> Both store the passed blob and neither communicate it to the firmware. 
>> This makes me wonder - how does the attestation report (cooked by the 
>> firmware) get signed with those certificates passed on by the HV 
>> userspace?
> 
> These are for use by the guest to validate the attestation report. It 
> allows the guest to obtain the certificate information without having to 
> use another method to request the certificates.
> 
> By having this certificate store, the hypervisor can request the 
> certificates from the KDS once, rather than every time a guest requests 
> an attestation report.
> 
>>
>> Also, the cached blob in /dev/sev seems redundand - the attestation 
>> report is retuned for a specific guest so having a blob in the KVM VM 
>> makes sense and KVM unconditionally reserves memory for it anyway. And 
>> for the HV itself the blob is useless (?) so why bother with caching 
>> it in /dev/sev.
> 
> In general, the certificates are for the machine (VCEK, ASK, ARK), so 
> they can be for all VMs on the machine. The per-VM blob allows a VMM to 
> supply additional per-VM certficates, if it desires, but is not required.
> 
>>
>> And GET ioctls() return what SET passed on (not something the firware 
>> returned, for example), what is ever going to call SET? The userspace can 
> 
> As stated above, the firmware already has the information needed to sign 
> the attestation report. The SET IOCTL is used to supply the certficates 
> to the guest for validation of the attestation report.


Does the firmware have to have all certificates beforehand? How does the 
firmware choose which certificate to use for a specific VM, or just 
signs all reports with all certificates it knows?


> This reduces the 
> traffic and complexity of the guest requesting the certficates from the 
> KDS.

Guest <-> HV interaction is clear, I am only wondering about HV <-> FW.


>> as well cache what it passed and save a bit of the code/memory in the 
>> kernel.
>>
>> btw SNP_{SET,GET}_EXT_CONFIG are documented in 
>> Documentation/virt/coco/sev-guest.rst but implemented in 
>> drivers/crypto/ccp/sev-dev.c (not sev-guest.c).
>>
>> What do I miss in the big picture here? :) Thanks,
> 
> The reason for the extended request is to make the attestation request 
> appear atomic to the guest. If you had to make two calls to request the 
> information, in the future, when live migration is possible, there is no 
> guarantee that the guest couldn't have been migrated in between the 
> calls to obtain the certificates and the call to obtain the attestation 
> report and thus validation of the attestation report could fail.




-- 
Alexey
