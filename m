Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780E7664434
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238926AbjAJPLS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238937AbjAJPKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:10:40 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6903B2A0;
        Tue, 10 Jan 2023 07:10:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mcdcnrqx1RNg/OnBzGsQaqC1iAJgLVnClx7HCrIMAmXlQp48uK3ydEAQwBIwmPALWpHl4aqVzOp3VnsMC5m52oPZEzx3jMrF272kb2BQ9r8VbI/lK9h9bc2APlAYbCEJPyhTuYE2sl4rG+Y1Zas+abO49+jEOrPSGnBxBWA7RGIkK9xQyf4pyAD0Qp8EI4Bgdg+8EnII5AVt+fkA2LbcBVeVxV2dNW8GCS5LwSIXT3hISMIdsXeDQrPeJ+CbCOgyuSik+CZCRCthT4oy5SbLCK7w15qrIxKZFEaENutyuQRTJdgBj8q6esDwxMWuSMSMSNcR8/ycrNWQ10pEve2Z6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oCEB7wpA4+XDUe3doPVc28dg2RtlJWFecMdUR+2CTDA=;
 b=DbEwxxZxo6DCPJklaeO4amhgJcSkj/bgZAvyWRyRnmFwXavipzu95oxr/HdHRQMD5hjZglocCQvOYbJj2V6REfLApSpQtLs9FpvIsIDt78ZD8kS+2J3znYXaSDC9H2xIU59m/OuoYGZbKDzPi1sxMtwaSoWi4kVQwytxG409H2KiI3veyl5O3/+stDb24G7xAu0oUd0Yq0jj5AkIj+uWLjtj2Zynx7zdWK3L2r+nqmNIE1FrAzLKNEkweKvsUbRgNKiRtuQv82eq2sCuJhhUO0KJiGa6z47i325GXE6HWyXOWtunYRI07A40zDPAzEtqno1f23A9MoxJWC/RIr2aOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oCEB7wpA4+XDUe3doPVc28dg2RtlJWFecMdUR+2CTDA=;
 b=sqMC32UwQP2neBmbIP5oNsWOZexXkD4/eq0KqZYLKVHj2cYucGdTESzPdcd2r1BhjD4nhxjOSD0Va55Ko8cX2OTANg+YByymVljLQ+bMw4u0peSG9VLdJrZFCYeduDXix2EJJD1/l7bfMDtQkKR2SkJ2S/n2l9sm0pxx4gi58tI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DS7PR12MB5959.namprd12.prod.outlook.com (2603:10b6:8:7e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 15:10:31 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 15:10:31 +0000
Message-ID: <1047996c-309b-6839-fdd7-265fc51eb07a@amd.com>
Date:   Tue, 10 Jan 2023 09:10:26 -0600
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <a3ecd9fc-11f8-49b6-09a2-349df815d2cf@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0044.prod.exchangelabs.com
 (2603:10b6:208:25::21) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DS7PR12MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: 55cefc9b-21e0-48c1-e895-08daf31cd09c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3e+8tzYnsCRv/oYF37YaG80haPKHnxG4WkvMeWgMdIl+Tw5fvZDxi92DLmUfl33VoY0LyVMWghM4QRbSsZDS2FDNSE+QkXv28yBQ0nBJ9Z+j+DAzbV9X34HN2mfU5CkT/L69ADuqH5lh4ZX0Ig5nr96RH4ZLdqY2Gd0GEHvOtKEKJ+zB5vCLkLUO1eU7XtPKkaT/9G/Z8wWja2zmF9tR1GIRGsFRsSiMPcOD0h3Qew2ZU7CMW17UImKhroOkd6XczfHrC+nZLYQiy6XDsOwSCTVqGxxyIVsbSCB63+T7j5LC9CUv7zKlTjuk+i5t1GGhLKzUeY4I7XuJWt4VN91afHKRKf13hs028QMmt1qhmiOv+h5TCfFE2pABOnpphSoVy6bRtTtEubg2v2JUmlA2tRsO0kB+spYvTDJxVY9oh6KCn8OVLeI/+JJQnGBCB1YMQ0zju+e6OLClHfPOFCSKK/oNNEcwyjQSxN9OsF1iAncr5rOMi8nDG9W9P3k3Wg5rbZdjsGtpVD+i+FVUvQTIWrN6ndc27DJMv+mTcGzvgqAjBOakQClP5ipmW8kLeQDQmGxTwb3FdRFmdvZBH0hGVvq3tNuP8gmZwi2v2S4rENCMAlunRiQVWqO3FBaKvq0fx7EbP9Dlr5MrVrPNUq6yRlqT6Qvl978CPA3h7cN7gDDKBJqWXfXCQ6pwvY1a0NPQ5N7f5sHI3JmV8+mV3/PT685ggnwePUDJXwlG0z7CeXg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(451199015)(6506007)(38100700002)(53546011)(31686004)(6666004)(2906002)(478600001)(6486002)(2616005)(7416002)(26005)(6512007)(186003)(7406005)(5660300002)(316002)(83380400001)(8936002)(36756003)(86362001)(41300700001)(31696002)(8676002)(110136005)(4326008)(66946007)(66556008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHRPOFBLcS9rZFFLS05BRFg5RUJwbXJOTElNWUhzd0htNnhiUVBPVkhhZG03?=
 =?utf-8?B?TmFJOXltZjF5Y2VVcWZsWXZzMnBuVGVzQmZGcFQwMGZyd2FkRnlGN3VyS0Z2?=
 =?utf-8?B?Rk9GczRDSXFpS29yTHNid0dWb2tQaXBJUHpqSVVwOTVZbzVHeXYzdzMvMy9T?=
 =?utf-8?B?Uk8zUzlCUGJvMW5PNGdEb0NJRFp6bVpGNUV5eGhUVGF1RWpCQmJ5TGlYckMy?=
 =?utf-8?B?aDY4ZHJMZ1ZmVGw4Y21MamF1bkdqTTBEdk9VQmVJRTlhSTN1dmNjV0RCQkU4?=
 =?utf-8?B?ZkxRSlJSZEJjU0dUN2xXNFJlK1lrR1B6eFNlRHZQSjRmMTlUQkNNYmpSMHUy?=
 =?utf-8?B?eHpJZ21nT2RaZDIzdTlhVW1Xc3NaeUZjOGE0MlMra2t6Q0pWWjZ4QXI1dWJ0?=
 =?utf-8?B?YVNBRHhzZm9nMG5NVlZxNUxtRXdDSGVoTExudVpybnR0S1hQNGw1V1QydXR6?=
 =?utf-8?B?YjlEWlkxaldDdUlHU3NyTTVTUXd3RlNrdjFMZTZsWlo1ekFGN0dtNG5OQTRE?=
 =?utf-8?B?akNPNjQwOUQvcjVKZytMczF1YlV6cGMwaDI1RUg2VFVKdXRoK3FuOFhqVk5F?=
 =?utf-8?B?UHJlYTZGS0VxOXVXSE8zVy9ZRG9CNXFuSXVic1hBUEVmcW9TMUtvZCsvaXRt?=
 =?utf-8?B?NzB4OUhxNS94Y3puTjFXbDMvRjlhaWF1azBMNk4yOU5zYnJmbkJ5QnRXY0Y2?=
 =?utf-8?B?WVR5OHZla2luTVhqWXFKY1ptS2NySFAwc2twelpkR0FicnE1QmxoZWF1WWZm?=
 =?utf-8?B?UTFGbCtwdDBSMnpmM251YmZnSUFaMDJaR29DaUpDaHErYTFHclNIR3VmTjQr?=
 =?utf-8?B?UmRnMHFuYkdLZWxtQXJFNUpHOFovTENIV1dYVm5hYjgwandaT09NcUhtd1A4?=
 =?utf-8?B?UmdQbnliRnlNTDB5Z3VGTDg4N1Y3UXd5eVcrc3RTZFRCQkVIdlpQTFRoRHhG?=
 =?utf-8?B?NUpVYU0rSkRrWFI1TnZVUmUrS0dSaTg0a1k1VVpvZkxJNWc2V0doM1NWOUls?=
 =?utf-8?B?eDJyZ1U5RVJXTmFzRGVDMjk5QktYOUZDVDZ4eSs1Yko4VzB2VmJUV3pIckpr?=
 =?utf-8?B?dll0SXk2c1IvMHpRcVZubkg1S0pMWWxjUWpUeGRiQmJwalpMQ1pLYmJWVWhU?=
 =?utf-8?B?NWorblZDK1FSMVVOdkxEenpKRjhtN1hHYThWRXdFY28xTk9VaHhXdWdxV0xJ?=
 =?utf-8?B?Z0U2K1JodVRtTTdORXQ4a05ZR2x2eFp6NEZCaWFFQ1ArU09UQ2JFeTRzcHZZ?=
 =?utf-8?B?cnJjVTdDT0FwZUNzNmgvYTlDRkFadjBGNkhlTUxURFdhMlg5ejVHZGttZDlB?=
 =?utf-8?B?aE5IL3QrRGFXL1ZPbFFSbS9pVXJsblI4OTRMV3VZV2lvSm41bEc0NU0yQTlG?=
 =?utf-8?B?bGZHTk51cEFIR3MydStBdTh4aUxyRy9tVDloTUFpNHNIK0RQdzJBWkRVbWho?=
 =?utf-8?B?Nk1XNGEvcnhjcFNqRlRuVFNOanMrdmxtZnZEcTNiUmppMkVYSGFRTllNL2cr?=
 =?utf-8?B?RFNUWUNuYzhVZENnU2lFNzA5V0sxYzNaNlJQREpyK0Z6eityc1pQRE5jcjlS?=
 =?utf-8?B?Y1ozVHZrVHVaOFZOMFR0R245ZzRucHlMVWlsOTdRMWcvRWF6MzFrTnUvS01O?=
 =?utf-8?B?Nkx5QUJ6dXZqMFNjT2ZncFFqOThRL2pTRDNBbDJ0OHJrNFVNSm14SFVndDRS?=
 =?utf-8?B?bG9kVDRDUjBCTnYzN3o3a2U1dnBKRDVUcGROQWFaWVhRZzVKdGpUVjFXNks5?=
 =?utf-8?B?R1FNbU52STdiSzlPL1lNbHJaUklqSERwZ2ZlemorcjM4ZjFLUU5OQjBiQnZI?=
 =?utf-8?B?cXo3S3JMRUpQWFFRbXp4VmdkbFNkUjd2ZlBJWnUyZkJFMU5uYW9RWFg5VmtR?=
 =?utf-8?B?NStScWFpSTh6Sy9pQ0xtYmY3WW1ka1FNOUJFeXJkcHVMZFRNTjVlVkFtU2c3?=
 =?utf-8?B?RVozdVdkNVQxeU9ldC9EcHgraE4wY0JBelJ1YzJ2SHFRN2lxWmFsMWxQOVMw?=
 =?utf-8?B?UTZPTE1uUjFpL1BUSDhRd3pDbnY1bDRBZVdzRjh2SHIwTmpKYTBLNWY5UFJn?=
 =?utf-8?B?WnhlNDZlOFMzN2VZTFpxbTM4KzJhSzF1U0tLMmE5SUlTVlNxVTZWY2E4blIr?=
 =?utf-8?Q?8LCRVKYpawoiXuTmojPENjeYF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55cefc9b-21e0-48c1-e895-08daf31cd09c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 15:10:31.3111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xCXHfD9UQTyTV9wp+/n/9Uc82M00MS+Nbogwt7QeYFsrEm00OYU9+H6sHG9IwYgN2xoKqxdlSxp5o9ExHxGoAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5959
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/10/23 01:10, Dov Murik wrote:
> Hi Tom,
> 
> On 10/01/2023 0:27, Tom Lendacky wrote:
>> On 1/9/23 10:55, Dionna Amalie Glaze wrote:
>>>>> +
>>>>> +static int snp_set_instance_certs(struct kvm *kvm, struct
>>>>> kvm_sev_cmd *argp)
>>>>> +{
>>>> [...]
>>>>
>>>> Here we set the length to the page-aligned value, but we copy only
>>>> params.cert_len bytes.  If there are two subsequent
>>>> snp_set_instance_certs() calls where the second one has a shorter
>>>> length, we might "keep" some leftover bytes from the first call.
>>>>
>>>> Consider:
>>>> 1. snp_set_instance_certs(certs_addr point to "AAA...", certs_len=8192)
>>>> 2. snp_set_instance_certs(certs_addr point to "BBB...", certs_len=4097)
>>>>
>>>> If I understand correctly, on the second call we'll copy 4097 "BBB..."
>>>> bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
>>>> 1) & PAGE_MASK which will be 8192.
>>>>
>>>> Later when fetching the certs (for the extended report or in
>>>> snp_get_instance_certs()) the user will get a buffer of 8192 bytes
>>>> filled with 4097 BBBs and 4095 leftover AAAs.
>>>>
>>>> Maybe zero sev->snp_certs_data entirely before writing to it?
>>>>
>>>
>>> Yes, I agree it should be zeroed, at least if the previous length is
>>> greater than the new length. Good catch.
>>>
>>>
>>>> Related question (not only for this patch) regarding snp_certs_data
>>>> (host or per-instance): why is its size page-aligned at all? why is it
>>>> limited by 16KB or 20KB? If I understand correctly, for SNP, this buffer
>>>> is never sent to the PSP.
>>>>
>>>
>>> The buffer is meant to be copied into the guest driver following the
>>> GHCB extended guest request protocol. The data to copy back are
>>> expected to be in 4K page granularity.
>>
>> I don't think the data has to be in 4K page granularity. Why do you
>> think it does?
>>
> 
> I looked at AMD publication 56421 SEV-ES Guest-Hypervisor Communication
> Block Standardization (July 2022), page 37.  The table says:
> 
> --------------
> 
> NAE Event: SNP Extended Guest Request
> 
> Notes:
> 
> RAX will have the guest physical address of the page(s) to hold returned
> data
> 
> RBX
> State to Hypervisor: will contain the number of guest contiguous
> pages supplied to hold returned data
> State from Hypervisor: on error will contain the number of guest
> contiguous pages required to hold the data to be returned
> 
> ...
> 
> The request page, response page and data page(s) must be assigned to the
> hypervisor (shared).
> 
> --------------
> 
> 
> According to this spec, it looks like the sizes are communicated as
> number of pages in RBX.  So the data should start at a 4KB alignment
> (this is verified in snp_handle_ext_guest_request()) and its length
> should be 4KB-aligned, as Dionna noted.

That only indicates how many pages are required to hold the data, but the 
hypervisor only has to copy however much data is present. If the data is 
20 bytes, then you only have to copy 20 bytes. If the user supplied 0 for 
the number of pages, then the code returns 1 in RBX to indicate that one 
page is required to hold the 20 bytes.

> 
> I see no reason (in the spec and in the kernel code) for the data length
> to be limited to 16KB (SEV_FW_BLOB_MAX_SIZE) but I might be missing some
> flow because Dionna ran into this limit.

Correct, there is no limit. I believe that SEV_FW_BLOB_MAX_SIZE is a way 
to keep the memory usage controlled because data is coming from userspace 
and it isn't expected that the data would be larger than that.

I'm not sure if that was in from the start or as a result of a review 
comment. Not sure what is the best approach is.

Thanks,
Tom

> 
> 
> -Dov
> 
> 
> 
>> Thanks,
>> Tom
>>
>>>
>>>> [...]
>>>>>
>>>>> -#define SEV_FW_BLOB_MAX_SIZE 0x4000  /* 16KB */
>>>>> +#define SEV_FW_BLOB_MAX_SIZE 0x5000  /* 20KB */
>>>>>
>>>>
>>>> This has effects in drivers/crypto/ccp/sev-dev.c
>>>>                                                                  (for
>>>> example in alloc_snp_host_map).  Is that OK?
>>>>
>>>
>>> No, this was a mistake of mine because I was using a bloated data
>>> encoding that needed 5 pages for the GUID table plus 4 small
>>> certificates. I've since fixed that in our user space code.
>>> We shouldn't change this size and instead wait for a better size
>>> negotiation protocol between the guest and host to avoid this awkward
>>> hard-coding.
>>>
>>>
