Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88524665E1F
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 15:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbjAKOgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 09:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbjAKOgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 09:36:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1041632180;
        Wed, 11 Jan 2023 06:32:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jH2Pv5+dn/WkPDFchI0T4NsnAjNypOnRQFx4rUz+kc+FZBcsSwMm38fJmRu71T2ok0aKsHNCICCQH5j7j70MWuRbGnbWkoEzcLIg6xL4o0A2vWHyV9lYUQPhuRiuB6X2sicGT7E0Pkfm/m6PjbSFFbINcGdslusHUCMR9dUba8goCFdhlP2Vl0MfU90lg/BpiO+DljdgRQ9sC6DieHryTFXL2F0BQtDVXjHi+aiyGZ3eddMDJ0/zYPk5Izv32io/UkF3T6Man4n4S629wZUmz8Cbs5snlot2wMmGjpTmGG40TejPEmhQ5f4RipnLzPrVaoT0PzR71lSMuAwbmjYFaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bfdMHRWYMnxhSuc30Yxqe6k74+cHW1tPOmzIkD68Mqg=;
 b=ZHP0dqEozsWtZ0ZiLU8YKnjxCAQrR25p1pQm1rO3ddEMZA4OkNde4BMnsD6rWiiJ3UCkmg66A+m5McdCSC9PFirN8V0FrENfh+K6pKcxmGp8wk18hf6e0xXP0FWJ+2c1ch9b/Sh374dT8qs/Gp5n125+MUchW3QyjEt05I5HWRT+Z4x6LeczH/itz5f6sU7MTmdYidURqtVq5AkVdnSQrJsLBFBlOVW7hfSw0DXHjBf/3DlzIBKz/7TXnfC0XF133M+6BM8Ikp8FOC/s+RCg4nY4+S0Q25jEQQByv3iisHqSpcQnlKKnVctnQkQKnXlt6iQISg1uvoWisSv0abI4Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bfdMHRWYMnxhSuc30Yxqe6k74+cHW1tPOmzIkD68Mqg=;
 b=NXxPzjRKbK6yO92+KJ9/g3EK8muSa8kVhszQAeAA5LwcwIkV+m8zK2ivqt6HSgZ2w48R57TTCbWHNn0fUR65MBigTpkEH7L4e9EMTHZfOxxwLzEQbrJxRmqU/JTyu3G+1BucV7ktFdfsMvQDY2A+8LV1LXvNxJk+3gq+Jacd7YQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 14:32:36 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%3]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 14:32:36 +0000
Message-ID: <d6b835e0-43e7-e5ae-e291-6ff0611cc817@amd.com>
Date:   Wed, 11 Jan 2023 08:32:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Dov Murik <dovmurik@linux.ibm.com>,
        Dionna Amalie Glaze <dionnaglaze@google.com>
Cc:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, tobin@ibm.com, bp@alien8.de, vbabka@suse.cz,
        kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        alpergun@google.com, dgilbert@redhat.com, jarkko@kernel.org,
        ashish.kalra@amd.com, harald@profian.com
References: <20221214194056.161492-1-michael.roth@amd.com>
 <20221214194056.161492-63-michael.roth@amd.com>
 <1c02cc0d-9f0c-cf4a-b012-9932f551dd83@linux.ibm.com>
 <CAAH4kHbhFezeY3D_qoMQBLuFzWNDQF2YLQ-FW_dp5itHShKUWw@mail.gmail.com>
 <54ff7326-e3a4-945f-1f60-e73dd8865527@amd.com>
 <a3ecd9fc-11f8-49b6-09a2-349df815d2cf@linux.ibm.com>
 <1047996c-309b-6839-fdd7-265fc51eb07a@amd.com>
 <9f221719-7ab3-3e87-7d66-a4ca6ce0e794@linux.ibm.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <9f221719-7ab3-3e87-7d66-a4ca6ce0e794@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:610:5a::30) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: 76812c0f-ca7f-459c-3fce-08daf3e0aecc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UOV7WxsKmL6PtHJNZjURnjRphvyN5CYU4VNvIdXK5548hApTBNXHSUb52jG3i0m8TRJYfeK7Yyqa06AG+v4tcBbZ8jwwAFQnf8gy20bqtbjAaJgLFapAXivncaAlqR3TmMuq9viz2fRAZteFC6tE35QWal5Xo8A8U/texAHXuqzrsIai+/Iqxb9zWpTfpYRcnOBPl2qJY0jqgN0NwDWgq62w1Pyoxptet0n9s1XhKs1xlPwJO16TSrpy9lMyP6uGOSloleVTFKG6Szu+p/nBZEv6xah7auNcRkI8ZC2hE9lmDb/+UczuDqs0XoAwD5RwNAiszGEW06G4K5ecR5AvOalkRbsLydw+Ut16++pESkt7V57H9/7HdO63W9tkmE3iMiX/svOpk9optBjSY4wicrE94nBnTTU55Pb/uzzHdxZYFjrmHbQxDI9S0D5PIJLQdauhthnKCaH6fPLkK+/j23awoV1gRHi8L1xkkjp7vknYKCNpabqNJXM2qZvh4wqc6hYiBe53kbm37893TfHQMu3p3flL+vXAlQAOSVaC2IsnyWT0SM1Yvx0rk4dLq7wenPgVbaQd773UkiQJR7Im/4JlQTAeSyh7Jx3oQpv/Vhk7I1GQiWgq2T78XNNqg4naXClLWQP5chtx11wRMl+vdqNnkxXJkd8RVwRQUgKH7dRlaYa8m1FcFtxptTQq4xqNY8r4ms2CdUc2gAKcX/HOzusHJvCKctiaTSyGl57jBk0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199015)(66946007)(110136005)(2616005)(4326008)(41300700001)(8676002)(316002)(66476007)(66556008)(36756003)(86362001)(31696002)(83380400001)(8936002)(38100700002)(5660300002)(7416002)(7406005)(6486002)(2906002)(6506007)(6512007)(53546011)(31686004)(478600001)(186003)(26005)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1lHN1NLTjdUK3p4cytjOENwVXNtZWNnQnkzMjd5dzVyZ1JkMVoyRVFsNzR5?=
 =?utf-8?B?bHA3SG1QZG9naXBCRzBLcEI1ZkllRXNqREtpMEtSMzJ5SjFtcGswUXUvTkZW?=
 =?utf-8?B?RDdvU3lBSXZWVnlvNGJoK3U4Z2VZNnpkQjh0WDR2YTVjYlVBaGxpUGtueU5S?=
 =?utf-8?B?MndpMlQ4dXpaSHdqV2ZWZ2ZlWVhYMEsyQ1dGUjJOYisrN1lFSHZrZ1ZGVGEz?=
 =?utf-8?B?MnBSdDI2c0tFOHJNYnpCYUdhV3JrdlVGdnUybWV1SDEzWG1YSEYwRHNoRXBS?=
 =?utf-8?B?MWg5NE13RDJ1Rmw4OHMzSDFnWmczU3Z0NFlNa2t6aGljNjk3NkhYaUJRRVdu?=
 =?utf-8?B?eEFmZGVRMU14Vmd2aTVvTXNsYTRQWC9pOWRlOGV0M0thY2lkOG5pSkxvQ09U?=
 =?utf-8?B?M0piVzhlT0ZSczF1T2pGTlBrTC9Lcy9OQmUrU2pMdjg0V0RLRjRTSVl2TUQr?=
 =?utf-8?B?bEtvT0lMQllvYnJuWTF4SGF1T3dxYzhaY3ZwMTZGTDYyY2RNRXNOcld5U0Uz?=
 =?utf-8?B?bVhkUDY0cU9ncmdRSER5Z2dZT1dxQ3dDY2VubS8xRFk3ZE1BMzkyRTJDcXdk?=
 =?utf-8?B?SVJuazVDM3U5bnF2U1lCV1NCWHdRQUNaVjQ5SVZZRU1hYStveHZPVE1QWkdM?=
 =?utf-8?B?QTkrU0YrbDRtNzJyM2VXNFJhckhHdlJGcFpWRWRCR1hJQWpGcjJpbi9CbS9D?=
 =?utf-8?B?VEdOWEo5U2lxVThXYVZTalBUTVc2RHJCZG83K2czZmQzSEhRcUxLTHJjdUlB?=
 =?utf-8?B?SFBOLy9UNHY2NFlwcnJtRjFOWE1PaENKTXpsK0dTcytvbmNsSHV2VGlBWU41?=
 =?utf-8?B?eGZrWFRsVUgvZys5ZDJ2UEN4dXRQOTRPY2JIeDhGZkNVSHRPblNmZkN3SlJu?=
 =?utf-8?B?MW5ZeGh6c2o4aXpYSEZVNVorVUVxTjVDMFFncGJlRmRqVGxlbkdaRkttMlRz?=
 =?utf-8?B?VTFkd3VvY3NITDlNdSszbXdaQWFhaEZpamRYZ2pFTUZpd3hNRjV4UGM1aDAr?=
 =?utf-8?B?UWl3a29UeEwwaGFXQjFmNDJjS1RjbzRLeFRBZVVWR3cwbzJSTG9qdURpaytN?=
 =?utf-8?B?eGFTUDJUY2NCaFF4RXhzY2Z5Ym5ZZllmUjdwbmZnK3pncUNNNzJpRGJ3cEky?=
 =?utf-8?B?akxya0ZzOVFxdUdBbVNHZVoybVZTK0FldG5JcC95OUNGN1U2c1JFdTdMVWxS?=
 =?utf-8?B?alc5TkF6MERBemJIV2t6WHNkTmlQTVVVRXpuSmU2enl5MHRiSG4xUlUyMUY5?=
 =?utf-8?B?TmtsSEF5S3FxQUF1ZytZTmJRM0pWQjJ1eE1kOFZpM1k3NGpGNXFHZ2tYQmpH?=
 =?utf-8?B?Slh4cndVTFh6dXB0cDUxSGJ6ak5xd1pyZ3lWam9YSmEzcnY2cEdpeDBKRE9o?=
 =?utf-8?B?dkJVZ2pHNkMxNURlWHc5Qk1YTS9QT2ZIdlhsZDRwZnY2RVM1V2ZHWEJ0Uld2?=
 =?utf-8?B?WEJ4MDVnWllTSFJwbWJLWXR0WTM2V2hWaWNqbVhHTkFIQThSaUcvSStycWxN?=
 =?utf-8?B?VVhTeUVuVzhzMUR4OTNReWxMZHhHZkUzZkJSM0VKMmZNc1ZtdVU2ZkZORmQ1?=
 =?utf-8?B?cUg5bEhCUzRpK2pGc1ZWZjY4QjNTQUQyTjNWWlNUUTJGWVNlZEYra2puNFJR?=
 =?utf-8?B?SXExYUZXVWt5Znd2QTdqeXM5c0lHaWp1Z0xPeGkwSDJ0dnVtN2pBanZFUTRY?=
 =?utf-8?B?anV0MTFpUktOOGdZQ2VYT2NJSGs2dVJMMVRZYW5ZdnpWUUo4V2xFbnhqMjRE?=
 =?utf-8?B?bkl0c2x2MFIzWDlnb0l3SXFVeVpTVXNEeEtlbEsrd3lnTjlHSHZ5M294eERQ?=
 =?utf-8?B?aUhYQTh6QVlvWXF0R1ByeUtkNnRzdDFQZXdnZHBxMk0zN2lENCtWaE1OdlhM?=
 =?utf-8?B?UnV5ZHZ2QjRxZjNjYVFIWWQwVC80K2VKcG8vMzhxK2RzWU1semtRUXI1Vm5v?=
 =?utf-8?B?aFVnM1dLbHhBV3BVM2lDdlJyUnU5TTF3bm5kQ3FnNnpvdmFaSjhCUU1sMXhF?=
 =?utf-8?B?M1pTbmF0UTMvd3VSOWlyRm51eHhFZThWZVZwZmhSM3VqbDBzRWhHN3R4U2JH?=
 =?utf-8?B?MWxxZEFjTHc5OXBtNGFzbm1PaDJvRFJ0UHpzbVo4bUxLWUlCdnprUUdDeEhS?=
 =?utf-8?Q?WSnBOeYvIEJXwt6GeAk3F8w7D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76812c0f-ca7f-459c-3fce-08daf3e0aecc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 14:32:35.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLLFQrYnxw5ZcQvmmmPIwOps3F5eD13vxy7iiKOtgrzdTAN4/1N6A5Jx4m7w+QOyAC+f8b6d99olVVT2AKm2sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/11/23 00:00, Dov Murik wrote:
> 
> 
> On 10/01/2023 17:10, Tom Lendacky wrote:
>> On 1/10/23 01:10, Dov Murik wrote:
>>> Hi Tom,
>>>
>>> On 10/01/2023 0:27, Tom Lendacky wrote:
>>>> On 1/9/23 10:55, Dionna Amalie Glaze wrote:
>>>>>>> +
>>>>>>> +static int snp_set_instance_certs(struct kvm *kvm, struct
>>>>>>> kvm_sev_cmd *argp)
>>>>>>> +{
>>>>>> [...]
>>>>>>
>>>>>> Here we set the length to the page-aligned value, but we copy only
>>>>>> params.cert_len bytes.  If there are two subsequent
>>>>>> snp_set_instance_certs() calls where the second one has a shorter
>>>>>> length, we might "keep" some leftover bytes from the first call.
>>>>>>
>>>>>> Consider:
>>>>>> 1. snp_set_instance_certs(certs_addr point to "AAA...",
>>>>>> certs_len=8192)
>>>>>> 2. snp_set_instance_certs(certs_addr point to "BBB...",
>>>>>> certs_len=4097)
>>>>>>
>>>>>> If I understand correctly, on the second call we'll copy 4097 "BBB..."
>>>>>> bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
>>>>>> 1) & PAGE_MASK which will be 8192.
>>>>>>
>>>>>> Later when fetching the certs (for the extended report or in
>>>>>> snp_get_instance_certs()) the user will get a buffer of 8192 bytes
>>>>>> filled with 4097 BBBs and 4095 leftover AAAs.
>>>>>>
>>>>>> Maybe zero sev->snp_certs_data entirely before writing to it?
>>>>>>
>>>>>
>>>>> Yes, I agree it should be zeroed, at least if the previous length is
>>>>> greater than the new length. Good catch.
>>>>>
>>>>>
>>>>>> Related question (not only for this patch) regarding snp_certs_data
>>>>>> (host or per-instance): why is its size page-aligned at all? why is it
>>>>>> limited by 16KB or 20KB? If I understand correctly, for SNP, this
>>>>>> buffer
>>>>>> is never sent to the PSP.
>>>>>>
>>>>>
>>>>> The buffer is meant to be copied into the guest driver following the
>>>>> GHCB extended guest request protocol. The data to copy back are
>>>>> expected to be in 4K page granularity.
>>>>
>>>> I don't think the data has to be in 4K page granularity. Why do you
>>>> think it does?
>>>>
>>>
>>> I looked at AMD publication 56421 SEV-ES Guest-Hypervisor Communication
>>> Block Standardization (July 2022), page 37.  The table says:
>>>
>>> --------------
>>>
>>> NAE Event: SNP Extended Guest Request
>>>
>>> Notes:
>>>
>>> RAX will have the guest physical address of the page(s) to hold returned
>>> data
>>>
>>> RBX
>>> State to Hypervisor: will contain the number of guest contiguous
>>> pages supplied to hold returned data
>>> State from Hypervisor: on error will contain the number of guest
>>> contiguous pages required to hold the data to be returned
>>>
>>> ...
>>>
>>> The request page, response page and data page(s) must be assigned to the
>>> hypervisor (shared).
>>>
>>> --------------
>>>
>>>
>>> According to this spec, it looks like the sizes are communicated as
>>> number of pages in RBX.  So the data should start at a 4KB alignment
>>> (this is verified in snp_handle_ext_guest_request()) and its length
>>> should be 4KB-aligned, as Dionna noted.
>>
>> That only indicates how many pages are required to hold the data, but
>> the hypervisor only has to copy however much data is present. If the
>> data is 20 bytes, then you only have to copy 20 bytes. If the user
>> supplied 0 for the number of pages, then the code returns 1 in RBX to
>> indicate that one page is required to hold the 20 bytes.
>>
> 
> 
> Maybe it should only copy 20 bytes, but current implementation copies
> whole 4KB pages:
> 
> 
>          if (sev->snp_certs_len)
>                  data_npages = sev->snp_certs_len >> PAGE_SHIFT;
>          ...
>          ...
>          /* Copy the certificate blob in the guest memory */
>          if (data_npages &&
>              kvm_write_guest(kvm, data_gpa, sev->snp_certs_data, data_npages << PAGE_SHIFT))
>                  rc = SEV_RET_INVALID_ADDRESS;
> 
> 
> (elsewhere we ensure that sev->snp_certs_len is page-aligned, so the assignment
> to data_npages is in fact correct even though looks off-by-one; aside, maybe it's
> better to use some DIV_ROUND_UP macro anywhere we calculate the number of
> needed pages.)

Hmmm... yeah, not sure why it was implemented that way, I guess it can 
always be changed later if desired.

> 
> Also -- how does the guest know they got only 20 bytes and not 4096? Do they have
> to read all the 'struct cert_table' entries at the beginning of the received data?

Yes, they should walk the cert table entries.

Thanks,
Tom

> 
> -Dov
> 
> 
>>>
>>> I see no reason (in the spec and in the kernel code) for the data length
>>> to be limited to 16KB (SEV_FW_BLOB_MAX_SIZE) but I might be missing some
>>> flow because Dionna ran into this limit.
>>
>> Correct, there is no limit. I believe that SEV_FW_BLOB_MAX_SIZE is a way
>> to keep the memory usage controlled because data is coming from
>> userspace and it isn't expected that the data would be larger than that.
>>
>> I'm not sure if that was in from the start or as a result of a review
>> comment. Not sure what is the best approach is.
>>
>> Thanks,
>> Tom
>>
>>>
>>>
>>> -Dov
>>>
>>>
>>>
>>>> Thanks,
>>>> Tom
>>>>
>>>>>
>>>>>> [...]
>>>>>>>
>>>>>>> -#define SEV_FW_BLOB_MAX_SIZE 0x4000  /* 16KB */
>>>>>>> +#define SEV_FW_BLOB_MAX_SIZE 0x5000  /* 20KB */
>>>>>>>
>>>>>>
>>>>>> This has effects in drivers/crypto/ccp/sev-dev.c
>>>>>>                                                                   (for
>>>>>> example in alloc_snp_host_map).  Is that OK?
>>>>>>
>>>>>
>>>>> No, this was a mistake of mine because I was using a bloated data
>>>>> encoding that needed 5 pages for the GUID table plus 4 small
>>>>> certificates. I've since fixed that in our user space code.
>>>>> We shouldn't change this size and instead wait for a better size
>>>>> negotiation protocol between the guest and host to avoid this awkward
>>>>> hard-coding.
>>>>>
>>>>>
