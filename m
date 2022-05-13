Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3156B526BC6
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 22:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384464AbiEMUsC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 16:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380512AbiEMUsA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 16:48:00 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66477286C7;
        Fri, 13 May 2022 13:47:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dH2GfGlHMacwqRPYrr+QD0R1H+FT09A3hOKHMjOSGoea6b+C2ipPUFreS8E5oKnwoE5IEDgODKsOSCy1knC2IM94e1NZuFPu0GCl8vrm+/g4jQp6fqpb9HwHEXB1xqEQ+qo4zuAzA01K/VQjQWw5f53s5/xx7jql1acg/XSjiUdWTzsVD2zWIZV+voArm1kwOVTvfhDapQn1e3HN4ID5O92VcdtY/TOPo94GgjAgAkbzrMf6OMyL3EDTXVbee/E6bnP3XZrZ5l5uTFZje4T2zq6RvPxXkLV0YYOt87Os5i8WG1KX/TNY8elahlTFSsVCvKaZ81/YEYai0pb7Mgp7lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OYZjvEpAUVA6Ym3xzjeYQEpRDFRO39iVThaF2tyLIbY=;
 b=Tw1sVGxzeg83KyF+M2rSq+7X2Uy3QEMMG8P/gWfNC6Dj9jSx/hZO7HqpQETxnKhtse4lnKa6TSEDIWpNoHJVC8PJpB+0OVagd68H2Wu0nTk6u3ycGBHjBX8LBXvbtSna1P00ZezbBOt3l22UBKlCld1subc7saplFK9mftm3HcJHtA+8D4Ia+WMehAeCzxOB/Y6KDXEXXyPq0JKNc/PjON9WenG57wyL80Mtb5hj7tJAhMQF9Dx70z8gbT1ebbXMAAIohKuDBQfvYyjBIiwBvJ92uPp6VFCV1UT1qiNrqrTBQMm7dB15ZZJ0zKZTwhBtPO3hdaouLyDgFnTQAKcvkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OYZjvEpAUVA6Ym3xzjeYQEpRDFRO39iVThaF2tyLIbY=;
 b=oHzje50oS3hjDaB1aEPUO/slvQtBFIS2yVWXZwa6avLCt2mYc8V2Cz5x5c5UrjxNb8iINXSU9FAR25SppOiRSJxxVXhaW4gHeiNS/rVcE5P6jh+fxqiP5D38wnUJyR+hNQwmG1t2ZDLT57iNGjtETn0ddDQvUsiyS/jgp/Z7a3k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by CH0PR12MB5124.namprd12.prod.outlook.com (2603:10b6:610:bf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.16; Fri, 13 May
 2022 20:47:53 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::25d7:1ecc:64f2:f9c0%6]) with mapi id 15.20.5250.015; Fri, 13 May 2022
 20:47:53 +0000
Message-ID: <43a355d1-4867-af2b-9729-fd7570da0d2e@amd.com>
Date:   Fri, 13 May 2022 20:47:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] KVM: SVM: Use kzalloc for sev ioctl interfaces to prevent
 kernel memory leak.
Content-Language: en-US
To:     Peter Gonda <pgonda@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Nguyen <theflow@google.com>,
        David Rientjes <rientjes@google.com>,
        John Allen <john.allen@amd.com>
References: <20220512202328.2453895-1-Ashish.Kalra@amd.com>
 <CAMkAt6ogEpWf7J-OhXrPNw8KojwuLxUwfP6B+A7zrRHpNeX3uA@mail.gmail.com>
 <Yn5wDPPbVUysR4SF@google.com> <51219031-935d-8da4-7d8f-80073a79f794@amd.com>
 <CAMkAt6rSXdFzVg6-tk8Yv9uQJEJaHtcvBHTBmWyjMVCs4uq1uw@mail.gmail.com>
From:   Ashish Kalra <ashkalra@amd.com>
In-Reply-To: <CAMkAt6rSXdFzVg6-tk8Yv9uQJEJaHtcvBHTBmWyjMVCs4uq1uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR14CA0021.namprd14.prod.outlook.com
 (2603:10b6:610:60::31) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e12edeb6-e6c9-4c98-685a-08da3521da0a
X-MS-TrafficTypeDiagnostic: CH0PR12MB5124:EE_
X-Microsoft-Antispam-PRVS: <CH0PR12MB5124B4CA123C8F218A3222C78ECA9@CH0PR12MB5124.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+wDtZg71qOPpwXFthYj8XfMMrRObPEIghaSl5m8IyXYwNmSE/QZ0FiWoZRrVfJL+89f6wp+Ee2Jf0qUH2ELItmDV1M2DFcwoVlFX+oLveRWOUHP2gCj2D0F8iYpDWdsVw9c3W3XWns+JGuTSc70UUDR10aTlw67CiNTM/aMzQ4Puc3wdJH4JxkIm/rz4Umkfkr0e92Qsfd2BxbTw0HoWb99F1HJZ+2+Z6RQ6j+M9gWBAtPR/5io6QyKFuWxSA1fPfjns88q46c4MH+Ik6LxDRByTAE4yTmBqVyrxZ7g6M7fxGgjgLmjDJFyXrybwqZeX6XZHLUrpEe1XqEPLbRzJq454B0EIB3AwSYXt7u0yMIEZP8CcjTj03BCoKkL5maq1LSO4yiSnPhK0j4zMuwy3/7HW/dYDod40eoFFOpTlBa2EEfXhEXwoJGK3820XzlAjcwp0KWqhR697DSFxXSLHi+12NWeARSFTsSTxzhrWPKHN345L9ZWczVEn6t7rYnADW8QQV4KlhEcb/sfJSTzwS8eEJOggvoOCtxD0vXWxcVxmfTb8/1xR4wJ04cR7QsMDfZqYoulcTHoFso0QXZQIgfY4MONLPQ5diiooYhN5GbTbcjentvYfnH98QEdaYUj7lL6wAO2XDI2oL4hZ/bNHtD54dB/1OxLeM5WLQLltaoEYo9RxqR+kRFFWlV/gGl+raVqjT2MM/2PyOsxdxWhmFo6e4h3y4W/zxBI001Afk8rY3dP0yBPg3mJhIhRSiFP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(316002)(6486002)(31696002)(54906003)(6916009)(66556008)(6512007)(83380400001)(66946007)(6506007)(8676002)(4326008)(38100700002)(508600001)(26005)(7416002)(31686004)(8936002)(2906002)(36756003)(186003)(2616005)(5660300002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGtpRjJob3hTdklaV21iZlcxVDNzZlVBS2pvWWRiRjkzWnVxbTBmOXdSd0Vu?=
 =?utf-8?B?S0w5NDBHdjdUdk5uL0M0RkF0ckx1RzNQREV5enBvS2E3cXBrU3FyVUY0bW1B?=
 =?utf-8?B?ZTJCcVI3dzFoRDJ2MFNoRGthWC9rVUVXMWk4dFdzRGx5ZGJobmdXT0loblZI?=
 =?utf-8?B?bGdMNTFDNS9ReGplUlhnM0hWN2hkRE90MkZLaVJpQmtCemxUS0wzNVdEdHB6?=
 =?utf-8?B?NkdMWjNBN3hqbHdyckFoWkJTRFcrbElyUVBvdEYwRXNFSGxKRW5BdlVOQ2ZI?=
 =?utf-8?B?R1RKZlJvVnE1UGZFMndUNERVK0RrOVRVcEx2d3dFa21NWnZJQmNRMGJhWCtx?=
 =?utf-8?B?QzhkMW92ZGE3M2FIcGc4T01NMENYd21vL1d2S3M0VTc3OG5mOE80L3psUm5i?=
 =?utf-8?B?Qnp0VG5ZVmFwcEJqcUF1SU5UVHlUb1BwLy9OWjhFWmtOc3MvWW54dlNubk9J?=
 =?utf-8?B?Sk85Ym54UDZiemtpWW1DUUcvK3B5Vm9KM1lPdTRUMm9iQWZPaHZ4NkllVnJW?=
 =?utf-8?B?SVE5OER2Z0xiYXJORkEvOU9tNkNIQTlNQ0FjWUloZktCUHFPNHBNTDZFQzdx?=
 =?utf-8?B?N2hHU1pYU1dQeWdMOVcxVzZnb3BTY3FZTzlBVnlqL1lqOUxHSEZRZzVYc0pa?=
 =?utf-8?B?T29hMlFVUnBtc1hVbTNDM1hickhOSEVlSDFvd1N0NjZhRU53L0pKSGhaOENT?=
 =?utf-8?B?OGJzaUpGVklJVmllbkhzQmpiMUpwalJyUXhkekJjTEdDWmVqT05kWVBnQTR4?=
 =?utf-8?B?cTQ0SERzOEorUmM1SERHY2IxMFdTZnRCRGpSYmVGczlWdFhMUmI0UDJuL1pR?=
 =?utf-8?B?QlBCTUdsQzVqQkk2N1luVVpURm5BNUJqN0tqWGV1T2FjcFBYUWNZMno5aDBk?=
 =?utf-8?B?dzVTRWVucFVQcVRBSE9UeHVnRGhucGtxb05NSjZ1aUpBb09SWVpSVTBtbDN1?=
 =?utf-8?B?SXRmaTRkck45QTYwdVFqRUpLT0F2YjQrRGZBMjRjTlhhdE5pckk2M3hsQWxO?=
 =?utf-8?B?M0cwMG1LTmQ0OU5kanpObE5vWUl2YmZHK1ZLd1JLd3FkWDF4VWJ3WjNlN2VD?=
 =?utf-8?B?YVF3cVBtU0hVYkljSVE0bUpmMXBhUzRpZTA2SnNidCswRnkrZytnQXhUcWJz?=
 =?utf-8?B?bGdKVjNoODZ4Yjd1U04vb0NqTjN3d3IxRjM5RjBxN1hxMER4RllRV1hvL2Fh?=
 =?utf-8?B?MlZ3ZFpzeExjK0FGNmVNdE5HNHg5WGVlZkNZZmpNRW5vZkRVekNMZ3pPaU91?=
 =?utf-8?B?U1pDV01nZHgwck5rSG5BdFFYZlE3bEo4eFRILy9xVmhHVmxJMGtZSmVkenBW?=
 =?utf-8?B?UnF5WVRtbHN4SFJDYlM3TklMRUZXcUVlOXkzZ0p2aEF4dzI5Yzl4VlFSeUNs?=
 =?utf-8?B?VFJWZTlZMnhWdlRMN3gxS2NBUDdqTXQrNnNxdEx2ZGtLMnUrdHpobXp6Z3Rj?=
 =?utf-8?B?cldYbjVqMllHVUMyTlIybzRUc1JFdUJVT1VwNUkzeDA1TXR2dlBsQW1IWkcw?=
 =?utf-8?B?eHl5aE9XQ2QwU1YreksrN1B6V21weHhORFFhTVlPT0wyRFlHdUlDTTk5RDhN?=
 =?utf-8?B?eXoremFqUlcydTFodEoxdWNLbkhydkhOa1hYZnN3Zkp5ZENma2dNR3JTQkl3?=
 =?utf-8?B?SW1SVXUvK3Qybm80SWFKRjl0cHowSk5ZVExxeVo4aU1abVJzbVpVc2R5Y3Fq?=
 =?utf-8?B?RXFodlBBSSsxa2Qwd3BjWEllSVZRbHhTeUl2dVphb0V1SXpDYWhwN2wwb2Vk?=
 =?utf-8?B?T2ZhdU5HeEFOUUVIbHFlbXBUZy9JcTBOUTY3QWt0T2lTRHhwQWswczZnVHhi?=
 =?utf-8?B?QytpMXZJT3oyeFBieTFNV3VYOTk5dG4wUW8wanVKNUxRT1EvNCtFdlNOL2lZ?=
 =?utf-8?B?Y3F3ckkzNE1vMlYrYWNnNm9lRzY0VFFEYWFqTmRLUDc5MG9TWGRvZTc1eFBF?=
 =?utf-8?B?K2lmdXl3WCs3a3IyciszWU44U3ZFZm85N1I3YlJHRmtRRUxOZGF5Sy85TVNH?=
 =?utf-8?B?cHN5VGVaNFBEOHY3djlya1lvcXNlWElpK3Ntcm5icThuMVB5eXUvOU1FZkdN?=
 =?utf-8?B?Nk1RWUZTTDZBSGczNmpkQ3VvKysvYjBMMmE2RHVjeUoxdVhoWWZNd0wzQUlX?=
 =?utf-8?B?ZXpwckg2ODNKRFByTFRHNnQwTk9QQk1Jc3lpSXBjWUc3NVl4SjA1VDU0ZWJI?=
 =?utf-8?B?dzZPaEpYVDY0d3FMRGJha0VBVU5NYlcyOGo1ZGhyS3B3U2hEVS9PUjRWcTJ3?=
 =?utf-8?B?ajJGZnNFN1pub1lXSVZzZUFobXhXRnJaQ1UwdFdPK1BTQ3Vyc25SYWpSbHFQ?=
 =?utf-8?B?cTJlMHFOTEk5Q1BXbm9sdlp1bXJDWE5rYVRoYnB0SkJrcXJXdTdXdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e12edeb6-e6c9-4c98-685a-08da3521da0a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 20:47:53.6529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bjAr9nmIfcLGgqVYUiIhZbwk+XBD/Ff1y1yLzKb+7hY5sOVi8SJiMh9dYkbpsKvWoG4qkXjCTCgJSovUpBFlxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5124
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Peter,

On 5/13/22 20:09, Peter Gonda wrote:
> On Fri, May 13, 2022 at 2:11 PM Ashish Kalra <ashkalra@amd.com> wrote:
>> Hello Sean & Peter,
>>
>> On 5/13/22 14:49, Sean Christopherson wrote:
>>> On Fri, May 13, 2022, Peter Gonda wrote:
>>>> On Thu, May 12, 2022 at 4:23 PM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>>
>>>>> For some sev ioctl interfaces, the length parameter that is passed maybe
>>>>> less than or equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data
>>>>> that PSP firmware returns. In this case, kmalloc will allocate memory
>>>>> that is the size of the input rather than the size of the data.
>>>>> Since PSP firmware doesn't fully overwrite the allocated buffer, these
>>>>> sev ioctl interface may return uninitialized kernel slab memory.
>>>>>
>>>>> Reported-by: Andy Nguyen <theflow@google.com>
>>>>> Suggested-by: David Rientjes <rientjes@google.com>
>>>>> Suggested-by: Peter Gonda <pgonda@google.com>
>>>>> Cc: kvm@vger.kernel.org
>>>>> Cc: linux-kernel@vger.kernel.org
>>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>>> ---
>>>>>    arch/x86/kvm/svm/sev.c | 6 +++---
>>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>
>>>> Can we just update all the kmalloc()s that buffers get given to the
>>>> PSP? For instance doesn't sev_send_update_data() have an issue?
>>>> Reading the PSP spec it seems like a user can call this ioctl with a
>>>> large hdr_len and the PSP will only fill out what's actually required
>>>> like in these fixed up cases? This is assuming the PSP is written to
>>>> spec (and just the current version). I'd rather have all of these
>>>> instances updated.
>> Yes, this function is also vulnerable as it allocates the return buffer
>> using kmalloc() and copies back to user the buffer sized as per the user
>> provided length (and not the FW returned length), so it surely needs fixup.
>>
>> I will update all these instances to use kzalloc() instead of kmalloc().
> Do we need the alloc_page() in __sev_dbg_encrypt_user() to have __GFP_ZERO too?

Actually this is used to allocate intermediate buffers to do 
copy_from_user, so it should be safe as size here is used for actual 
guest memory size to be encrypted.

Thanks, Ashish
>
>
>>> Agreed, the kernel should explicitly initialize any copy_to_user() to source and
>>> never rely on the PSP to fill the entire blob unless there's an ironclad guarantee
>>> the entire struct/blob will be written.  E.g. it's probably ok to skip zeroing
>>> "data" in sev_ioctl_do_platform_status(), but even then it might be wortwhile as
>>> defense-in-depth.
>>>
>>> Looking through other copy_to_user() calls:
>>>
>>>     - "blob" in sev_ioctl_do_pek_csr()
>>>     - "id_blob" in sev_ioctl_do_get_id2()
>>>     - "pdh_blob" and "cert_blob" in sev_ioctl_do_pdh_export()
>> These functions are part of the ccp driver and a fix for them has
>> already been sent upstream to linux-crypto@vger.kernel.org and
>> linux-kernel@vger.kernel.org:
>>
>> [PATCH] crypto: ccp - Use kzalloc for sev ioctl interfaces to prevent
>> kernel memory leak
>>
>> Thanks,
>>
>> Ashish
>>
>>> The last one is probably fine since the copy length comes from the PSP, but it's
>>> not like these ioctls are performance critical...
>>>
>>>        /* If we query the length, FW responded with expected data. */
>>>        input.cert_chain_len = data.cert_chain_len;
>>>        input.pdh_cert_len = data.pdh_cert_len;
