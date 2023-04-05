Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9750E6D819E
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 17:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238695AbjDEPUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238716AbjDEPUr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 11:20:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2060.outbound.protection.outlook.com [40.107.223.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905A110EB;
        Wed,  5 Apr 2023 08:20:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZM0AUvS0MzIhnnLwhQs9yanrJvtIgad7hqzlJGgcouLJl04WhxnNiAKYWzdSwesC6rxICZ8Cc1wiAVIF8VL3DBNEvPTUrLgqwB0H5oYpW0f5qRaWBshzFjQLNJj5al9f21F0U8gCDWDo6pFbaeY+50joOdLLEy75CM7UfOgFKPtfo1dE5vmXPuw7K3TPbEkZoB78eITuOk8+bdqs+C5clEGSAhiRP2oYE0epxoYNJPrjqMUZty9i7ScVhnLlCjrJOzYmOIfpXxKs9T9DPJH/k0m4CZqQl7jGjdlFY9NC31PaVt+m5bQG8zn0liDWUnCsKIhUohrGUWS2qtol/iXrUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JGFWcL+1fK9UxQH1UnlPY85PUI1B29JyNjF9xPLqQs=;
 b=jsIzN112LTR2UWDTsEK9QEoqmTkc5cfnWW2hjplKea4tCiqjE8xKnfyDK1+q7xb8h2wiqK1dtWYBdUem6SUjDUPxjh4bauMpxVUWzv7oYgMy0fn36bZBs8UIYfeS3eviFemG6XOfgLEW8Loh+h3I3Dg9u1reDaCyKS0i0EBbd7yu/jUw6Azi9AHdIZ8HVIM3YEeGMrp0lz1HgRiOH7pDouZkfVqHAUgnjoxoCMHWrUk+IcR2Dnt6/9Z8rPUC5hwdwqdG16051cvNBy/JcFIYee7d1QNAylj6oZqWnkxplQWmZLUQVbgmdT112izQZpUQmWEaxeCa/omjVyx2yc93AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2JGFWcL+1fK9UxQH1UnlPY85PUI1B29JyNjF9xPLqQs=;
 b=MArtsiau6HlOgLe0EOxbOKqpsI9QUyyqTieP1+laFK3dWtrXueDdH4HxsoLxqEmZnMtPaj47caYXEtU49xYFD+s8CZ89NE1j6jzgLOq7KnmlqjXuifyN5MLWopLo8n2huLTsFeZFT84KsFaK6w3xIvMS5PBU+QVSpt0MX64MbDM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by PH7PR12MB5734.namprd12.prod.outlook.com (2603:10b6:510:1e1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Wed, 5 Apr
 2023 15:20:39 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::5b56:bf13:70be:ea60%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 15:20:38 +0000
Message-ID: <b8b7c8c3-c721-9dbd-2377-f4af42baf52f@amd.com>
Date:   Wed, 5 Apr 2023 10:20:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH RFC v8 47/56] KVM: SVM: Support SEV-SNP AP Creation NAE
 event
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>,
        Alexander Graf <graf@amazon.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-48-michael.roth@amd.com>
 <09696af0-b72d-29e7-862b-22ae4a630299@amazon.com>
 <20230404224802.23fbe7kxa3h7tjps@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20230404224802.23fbe7kxa3h7tjps@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:610:cd::22) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|PH7PR12MB5734:EE_
X-MS-Office365-Filtering-Correlation-Id: b72f07a9-702c-4cec-7a93-08db35e94f77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1EiLlnVgED4hHhhjAfUwYwn96IzQpXJJT7RbnqUYmckcRZ+JtRtaSUrcpcCl6MFh4D3uJ7vtD1FRojxAA4oCYn3yBaNQ0otUltN9/PJoz/FPJaeNW0Po6HmRc7XMvCYl/9BALhZgVwRC8YrwRUQ6Iq7eZD9fYtgdnMr/cX7VZA/ZwkrJKD1TkXzU3O7voFkEIh0Pals4sqHwj5QY1mkI3FUUSNI33jkUatadgvq5v2vgLqvxb50ouupyEPxlQEGV943v3u5ELEtoMIj2YFaFtaVW9mGN3o+HBtfBxOr9xAc7xQkWmnsnWQYJqI/nxaXorifw8QN5aMHbXcCfLo60TbsnLPdiiTiyjQ5zkrFPpbaUMsN7hdTdLhSATFkpUsEoTM4z9meIkHn/s9DcU0sHpLSzQAnwb5zAdrJe28D0hOyTAuDRBwrZ6nA7up/8qc6oNuNl5ko2DnIglesViOJtB5MrSp+vtz1tydjF9QbZT7M5JwwASCjfuAnCbW9QAiE9mr3hWjcg0FPlNX4QbVnh+89WoKVfExxlwAvc0P4gavxv3tHA+jaeAfKD04pu/0HRm+79ZdbV/k/lhRZul2/Ej7nO2F1MKmMiiYgrg4JaitLYQqQIdGXkjDgZg8eKZuNjn01EBJGlEzzkcmWBRGAFng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199021)(31686004)(86362001)(6486002)(83380400001)(38100700002)(36756003)(6666004)(2906002)(7416002)(31696002)(478600001)(7406005)(53546011)(6512007)(6506007)(26005)(316002)(8936002)(5660300002)(110136005)(41300700001)(186003)(4326008)(66946007)(66556008)(66476007)(8676002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUdWaWtLOTBxZi9nS1pkeXlaOThOT3F0ZXBJV0FXdGtMRXVSSTN4RERMU2Rk?=
 =?utf-8?B?d29hTzZNUGVhemF1aklLUG5aVWdoeGtkQkYxajZhelZZSFhqVHBTbG00c0VR?=
 =?utf-8?B?dEF4Qjd3a0hZWUQyTHliRmZRWkpRVkxCc0N5SGxPZnMvelN5azVodUxxWlZ6?=
 =?utf-8?B?Y2YzMS9RZUhaVmZ2TXp0WG1zMFlCV296ckZVVkdic1pPcTQ0QWVuelFvcmNu?=
 =?utf-8?B?VEpEdmRuc01tRVVaQVRvc2dwei9Ta0pEM3ZQZHV5QWtjUVlKZU9LTnVGa2E3?=
 =?utf-8?B?bEtneERoK1FOQU9pb2VmeEhUQmpncDZ6c0FJcWMyR3JxbnNQNWVQcEJlR2d0?=
 =?utf-8?B?bHlnSGEzeXd4RWxWVjd0enh5dWd4UzFwVlBhTlJkM1JPWDRhYWZQU2xlZVN5?=
 =?utf-8?B?RTRSMHFSRzRSR21Qd0FDN0NJbU5zaGloSzcwaFBBcGFnclMvWTJRUDNiNFFy?=
 =?utf-8?B?VEFBdHpSeFljMmxqT3F0VzhPcGwrSi95emJjUmlud2NMUXdXTUlmWVRELzA2?=
 =?utf-8?B?VGlRLy9xcVJCSFU4dnc3WmU4bDhYcmxyNFpZTlhQZEtWYk9XK2NKdUN0cDRJ?=
 =?utf-8?B?WE01SnpxYnFxaWpvM3pQaGsxVENlZXVMaVBUNEZGMi9nQzZBNFRCUk1UUzFw?=
 =?utf-8?B?MzA0aFZpRGIvRi9hYXRRRlhodkJST3dCMkdUUmRVVzBsaHJ3UGIxNlVBVmE4?=
 =?utf-8?B?UVVKQTRUVG16Ni80M2RROFdBb2pTWk5BTnNEeFp1Qm52elJLVHlSVHIxaVZu?=
 =?utf-8?B?SldycUhTeGNqbktROHczVDdSZ1VhOUxRTGpOWlVxb05Bb2xJTVl0dlI3d3dX?=
 =?utf-8?B?ODVJM2oreS9qTWpNQ2FiMUw0YkJUeEVncThmVnBKWVVNWUdBZCszU0t5MHov?=
 =?utf-8?B?aUJXYXlITVpXazZPWitSdFFlODd6ZkFaR2lWb1pldGE5SGY2U0FJMS9rY3dE?=
 =?utf-8?B?UG5kdlhOVDg0SzJ4UjJzZWQ0YkJpc05Xemx4d0UzdFJUTVJYa3pEQlhqSjhw?=
 =?utf-8?B?V2xROVRuVTVYN0RRSEFaWXUycXRKcjV5ZENiQWdFdk1SRWRVQ2lGVG1hQnlR?=
 =?utf-8?B?ZFZ4blR3OEtHSCs5cmtzUzVuNnRtWk03Q0JNRHVjdWJwTGJQbGh3dDhZR1pZ?=
 =?utf-8?B?M3ZBTVRtU2RnSjZqUTBkVTNMUjdRdGdUdHo3UjY1SUEzQjA3aGV5SW9CVWFF?=
 =?utf-8?B?K0RremtEQ2RGVXludytDQkZHUjJKWnBNNWg2Q1JOci9keGY1UXphS0NjZVph?=
 =?utf-8?B?clVYR0xtU251MDF2N3VVbkdidHBJemt4N0hKTHNVMzJiTEtqZVhVVUxxNnRE?=
 =?utf-8?B?MWhhdWdLOGtiRVd1NEoxNFZRSGhTalVGdUxBN3Nvb0hWd2RXN3hrZGlWQzUv?=
 =?utf-8?B?bHEranlYQjAwQ1pZRWdkMDRvM05xandxVUtOUVNSeXR3U0R1M0cvZ3pPdzBq?=
 =?utf-8?B?ZFpCTTl1VWlEWG1Ea1NMQU1DN3UvM1FuMTl2WjhZTHhHZElTazF0T2ZCRnJp?=
 =?utf-8?B?S3NRRFRmTE0wREVrZ1ZWQUJadEZQN1d5QkRwaTBkVmUvRkxRZm1RM3pORU1m?=
 =?utf-8?B?MmpHNGRrSzV0U01IOURBR0pzMUNaOEN0MUxhNytDeXlxVXZoUFd5djNNeHNB?=
 =?utf-8?B?aE9GVW0xU0lrcWZxTldFajEva2VMRjJXNVZxK0xBNEkzei9nUXpUdlBUNU9v?=
 =?utf-8?B?azVGYmhtL3FjemxlTGR6aDZ2bWpKMXpoUy9qaTI3RmVzOGRXb2FIVHNmdVR0?=
 =?utf-8?B?K2FRZUtHVVNpZ2RTYWkwNHJWd0FUVk50NUU5MGszWlQvdkdoRWY0YkJTemwx?=
 =?utf-8?B?TkVhNlFGeVhyVjUxT2FvUXZ2TE5Yc0ZOTWxRVDgzdFc5S0E5a3JhLy9tUjFI?=
 =?utf-8?B?ZEh4MTBiSzBBMWIvNnlzdkFyaVY4WTBPQUQzV2Ird3luZFFyTS9jaFZEeHRk?=
 =?utf-8?B?QlB2ZGJWY201enZmbC84bCt5aHllRWRHSVZQTkxoZU9yUGo3Ri9LdnlyOEhH?=
 =?utf-8?B?MnpLZUdVSERVczFoVkErajJRNExpalJGcTk0SUlDTEdTYVJqVjk4MDZJWS9p?=
 =?utf-8?B?ODdNNGFrSGdyNWMxc25tUEg4dDhwL0dJMEQvNG1mc01vN0xEUzhsNmpXby9s?=
 =?utf-8?Q?s4sRzzAV4hl3FcyavJgX1WB/l?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b72f07a9-702c-4cec-7a93-08db35e94f77
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 15:20:38.2620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OQHH++iJxNAuNkZuJfw/AgYw8duwpb+3OkluMcMOPy2dx4QePM3agWTzI/Ww8uiPwGahzFO4hx4+9FhOWcDzjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5734
X-Spam-Status: No, score=-0.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/4/23 17:48, Michael Roth wrote:
> On Fri, Feb 24, 2023 at 01:37:48PM +0100, Alexander Graf wrote:
>>
>> On 20.02.23 19:38, Michael Roth wrote:
>>> From: Tom Lendacky <thomas.lendacky@amd.com>
>>>
>>> Add support for the SEV-SNP AP Creation NAE event. This allows SEV-SNP
>>> guests to alter the register state of the APs on their own. This allows
>>> the guest a way of simulating INIT-SIPI.
>>>
>>> A new event, KVM_REQ_UPDATE_PROTECTED_GUEST_STATE, is created and used
>>> so as to avoid updating the VMSA pointer while the vCPU is running.
>>>
>>> For CREATE
>>>     The guest supplies the GPA of the VMSA to be used for the vCPU with
>>>     the specified APIC ID. The GPA is saved in the svm struct of the
>>>     target vCPU, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is added
>>>     to the vCPU and then the vCPU is kicked.
>>>
>>> For CREATE_ON_INIT:
>>>     The guest supplies the GPA of the VMSA to be used for the vCPU with
>>>     the specified APIC ID the next time an INIT is performed. The GPA is
>>>     saved in the svm struct of the target vCPU.
>>>
>>> For DESTROY:
>>>     The guest indicates it wishes to stop the vCPU. The GPA is cleared
>>>     from the svm struct, the KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event is
>>>     added to vCPU and then the vCPU is kicked.
>>>
>>> The KVM_REQ_UPDATE_PROTECTED_GUEST_STATE event handler will be invoked
>>> as a result of the event or as a result of an INIT. The handler sets the
>>> vCPU to the KVM_MP_STATE_UNINITIALIZED state, so that any errors will
>>> leave the vCPU as not runnable. Any previous VMSA pages that were
>>> installed as part of an SEV-SNP AP Creation NAE event are un-pinned. If
>>> a new VMSA is to be installed, the VMSA guest page is pinned and set as
>>> the VMSA in the vCPU VMCB and the vCPU state is set to
>>> KVM_MP_STATE_RUNNABLE. If a new VMSA is not to be installed, the VMSA is
>>> cleared in the vCPU VMCB and the vCPU state is left as
>>> KVM_MP_STATE_UNINITIALIZED to prevent it from being run.
>>>
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>> [mdr: add handling for restrictedmem]
>>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>>
>>
>> What is the intended boot sequence for SEV-SNP guests? FWIW with this
>> interface in place, guests will typically use in-guest VMSA pages to hold
>> secondary vcpu state. But that means we're now allocating 4kb of memory for
>> every vcpu that we create that will be for most of the guest's lifetime
>> superfluous.
>>
>> Wouldn't it make more sense to have a model where we only allocate the VMSA
>> for the boot CPU and leave secondary allocation to the guest? We already
>> need firmware changes for SEV-SNP - may as well make this one more.
> 
> I don't think we'd necessarily need a firmware change. We could just
> free original VMSA back to the hypervisor as soon as those APs come
> online. The down-side to that versus deferring cleaning till guest
> shutdown is there is some flushing activity (see:
> sev_flush_encrypted_page()) that would now likely be occuring during
> guest boot up where the overhead might be more noticeable. But for SNP
> the host likely supports X86_FEATURE_SME_COHERENT so the overhead
> probably isn't that bad.

Currently, OVMF code will perform a broadcast IPI to start all the APs 
because it doesn't know the APIC IDs until they start for the first time. 
Until the APIC IDs are known, the guest BSP can't create the VMSAs.

However, a new GHCB event is in plan to retrieve the APIC IDs for the 
guest. Once that is in place, then you could create just a single VMSA for 
the BSP and then allow the guest to create the remainder (the current OVMF 
PoC patches to support an SVSM do this). The VMM would have to know that 
the hypervisor and the firmware both support that, though. That could be 
advertised as part of the GUID table of the firmware (in the case of OVMF) 
and as a capability from KVM.

Thanks,
Tom

> 
>>
>> [...]
>>
>>> +
>>> +static int sev_snp_ap_creation(struct vcpu_svm *svm)
>>> +{
>>> +       struct kvm_sev_info *sev = &to_kvm_svm(svm->vcpu.kvm)->sev_info;
>>> +       struct kvm_vcpu *vcpu = &svm->vcpu;
>>> +       struct kvm_vcpu *target_vcpu;
>>> +       struct vcpu_svm *target_svm;
>>> +       unsigned int request;
>>> +       unsigned int apic_id;
>>> +       bool kick;
>>> +       int ret;
>>> +
>>> +       request = lower_32_bits(svm->vmcb->control.exit_info_1);
>>> +       apic_id = upper_32_bits(svm->vmcb->control.exit_info_1);
>>> +
>>> +       /* Validate the APIC ID */
>>> +       target_vcpu = kvm_get_vcpu_by_id(vcpu->kvm, apic_id);
>>
>>
>> Out of curiosity: The target CPU can be my own vCPU, right?
> 
> I don't think that would be the normal behavior, but maybe with some
> care it's possible for a guest to do things that way. I haven't seen
> anything strictly prohibiting this in the relevant specs.
> 
>>
>>
>>> +       if (!target_vcpu) {
>>> +               vcpu_unimpl(vcpu, "vmgexit: invalid AP APIC ID [%#x] from guest\n",
>>> +                           apic_id);
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       ret = 0;
>>> +
>>> +       target_svm = to_svm(target_vcpu);
>>> +
>>> +       /*
>>> +        * The target vCPU is valid, so the vCPU will be kicked unless the
>>> +        * request is for CREATE_ON_INIT. For any errors at this stage, the
>>> +        * kick will place the vCPU in an non-runnable state.
>>> +        */
>>> +       kick = true;
>>> +
>>> +       mutex_lock(&target_svm->sev_es.snp_vmsa_mutex);
>>> +
>>> +       target_svm->sev_es.snp_vmsa_gpa = INVALID_PAGE;
>>> +       target_svm->sev_es.snp_ap_create = true;
>>> +
>>> +       /* Interrupt injection mode shouldn't change for AP creation */
>>> +       if (request < SVM_VMGEXIT_AP_DESTROY) {
>>> +               u64 sev_features;
>>> +
>>> +               sev_features = vcpu->arch.regs[VCPU_REGS_RAX];
>>> +               sev_features ^= sev->sev_features;
>>> +               if (sev_features & SVM_SEV_FEAT_INT_INJ_MODES) {
>>> +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP injection mode [%#lx] from guest\n",
>>> +                                   vcpu->arch.regs[VCPU_REGS_RAX]);
>>> +                       ret = -EINVAL;
>>> +                       goto out;
>>> +               }
>>> +       }
>>> +
>>> +       switch (request) {
>>> +       case SVM_VMGEXIT_AP_CREATE_ON_INIT:
>>> +               kick = false;
>>> +               fallthrough;
>>> +       case SVM_VMGEXIT_AP_CREATE:
>>> +               if (!page_address_valid(vcpu, svm->vmcb->control.exit_info_2)) {
>>> +                       vcpu_unimpl(vcpu, "vmgexit: invalid AP VMSA address [%#llx] from guest\n",
>>> +                                   svm->vmcb->control.exit_info_2);
>>> +                       ret = -EINVAL;
>>> +                       goto out;
>>> +               }
>>> +
>>> +               /*
>>> +                * Malicious guest can RMPADJUST a large page into VMSA which
>>> +                * will hit the SNP erratum where the CPU will incorrectly signal
>>> +                * an RMP violation #PF if a hugepage collides with the RMP entry
>>> +                * of VMSA page, reject the AP CREATE request if VMSA address from
>>> +                * guest is 2M aligned.
>>
>>
>> This will break genuine current Linux kernels that just happen to allocate a
>> guest page, no? In fact, given enough vCPUs you're almost guaranteed to hit
>> an aligned structure somewhere. What is the guest supposed to do in that
>> situation?
> 
> The initial SNP support for guest kernels already made use of
> snp_alloc_vmsa_page() to do the appropriate workaround to avoid allocating
> 2MB-aligned VMSA pages.
> 
> -Mike
> 
>>
>>
>>
>> Amazon Development Center Germany GmbH
>> Krausenstr. 38
>> 10117 Berlin
>> Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
>> Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
>> Sitz: Berlin
>> Ust-ID: DE 289 237 879
>>
>>
