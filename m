Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7146633F0
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 23:27:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbjAIW1X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 17:27:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjAIW1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 17:27:22 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2074.outbound.protection.outlook.com [40.107.93.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDF99FC2;
        Mon,  9 Jan 2023 14:27:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GeIE7Y0m1sNau3zTmxiluHS0Z28L1xxJWk2HAcmP8o1tqWS8NU7rVldkGavMjYLPXkTjfSDjtWbJWR71FEhyFob2xgtOfaAbXZS9uTTGA0hhBcs2UdYkW59BTylcLhbbVtDdss7V+l5QXoiBKt+ebXNFosKYuZ3EIuSZr93v4YyYv2io5HYV8BUYDfQUCY0i+bE6P8HLClZcTakOv9o6hK3t4qPU7JE809BB3o6NjU5B4bexL2f0DkSa7fhctI1dNnhZ2MrBw7n/XK8hcw2Na2lx2RaOfNvrjiManDfuMwd/57n2urvYSSNXIqmkkdfsWyuJN4a76q2NaXj02CaaFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GsF9EIfTai5Ogul357Q9HtfHXvGjdUFbGX1hlRuGx/c=;
 b=ggMMnqPLjxntNJ51beBD8/2SxocSkBOy0vQMcJja+418cghn4jQ8kKCMHT1xEaA+YRo9j/saZq3DrW4T9mK+pRnMsyl381cSvdv4p6EasYGgjsZywQ3zNL5psnVwz1zEMgEw4k2qZ9gHoq9a9I8SwhfRZa3747SkqDiqwdXRg7My/X5UVvc62qSc1JvXtY83xKswYCGL4xq5drSL6VhxVC+6hH72SKC5Er9o3RaWRhq+aC6SwGN7DOCICtYoirbizyLHgMqQexq5Qg58G9gvmNtv/5txUgAHyNdIbsOosKxJhMQNhYIIR8AtIIprM7gmotX20StToEkXS8MvfHvDpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GsF9EIfTai5Ogul357Q9HtfHXvGjdUFbGX1hlRuGx/c=;
 b=3K5h3i0TbCcmkMcwnwZTAnswgOyLXrsIF8mNe0aI1BhRVi1m+yGdnDrbILUzU4JfTLAH38vqxhl9CYtm/ZXe0OwY4O7rs1t+Q/jkL3dOCvwDJqqkpJNElRmvJNxUwwuXT1TIodGnKDdZFElFEJJxpY2EtQw+KTEtKE7SHGMray0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by IA1PR12MB8077.namprd12.prod.outlook.com (2603:10b6:208:3f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 22:27:17 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::8200:4042:8db4:63d7%4]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 22:27:17 +0000
Message-ID: <54ff7326-e3a4-945f-1f60-e73dd8865527@amd.com>
Date:   Mon, 9 Jan 2023 16:27:12 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH RFC v7 62/64] x86/sev: Add KVM commands for instance certs
Content-Language: en-US
To:     Dionna Amalie Glaze <dionnaglaze@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>
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
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <CAAH4kHbhFezeY3D_qoMQBLuFzWNDQF2YLQ-FW_dp5itHShKUWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR15CA0004.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::17) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|IA1PR12MB8077:EE_
X-MS-Office365-Filtering-Correlation-Id: cfb0569a-af58-49af-32e5-08daf290aa40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EXzQiX7R0+OKLE3mHf6cPB3YErNNb7WwmpvOXFITLqPDX1AHsa9woe4vfLH16xjC7M3bXW6VSeeHWgyv5yZAQM7req0CwdxzFRw6Er1tfXD3ghDFg75AwV22v6/3ESuiGr67CcqJqVDML6E1kKbq6mRlSIdgcqaYoNFTCQloEZ/NyjEP6pivibltGgEZaTX/hIwJtj28HUmIqQI+jtCTJ6QCy+4IcCbsnudeK4Alklkj6kfX4gINvnkvaTKEfvMgffv9CZeE7knkDWc8aoWtfEPnqf/mkBiOHNH5eqgpk55PPcNDJHkr0+vlni1rAFLwK+7+xJiJoSg7l0ddN+9Q/1laKYE3EWqAc5fLLu2VqR1wWwqkYt5X4ogiVIfONKp2IjURIKJBHwNWkrshJ0icpuYSHvN989NGozCjlTltQMj5djo/de6P46ErJauS4ItsTDfAJmn/7pcAOQC+hxsuXHMoetMwGGSHliwNjCQYVYbm8UExqivHcs1Y+TMwW/o6p8Zvh8aZ2ObehwNNYW4oXCOSgG71PFMpRgoe2/hkDp+wZK5geC4Qgg22udsWq0xCbCagajGLfCrubuKW/dIblwlgtqzMDoXaHJAOmD+7aYyUkfQJRLNSGZTUBqKQ4cunW3cKLztExJZTnaLRawzNMD0lIbFOnhWeMj9T+8A7MwyP9jIGYiEjb6BpfGTcRuQkXWbza+XMo09eqtQ+TDLPxLqmIMhQnct+3UZdYrmo+B8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(136003)(39860400002)(396003)(376002)(451199015)(6506007)(6512007)(186003)(2616005)(6666004)(110136005)(8676002)(86362001)(66556008)(66946007)(38100700002)(66476007)(7406005)(31696002)(4326008)(5660300002)(7416002)(478600001)(36756003)(53546011)(2906002)(31686004)(26005)(316002)(8936002)(41300700001)(83380400001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGhDcXgxWU5oRHNpSzdEZ1JzOHorWGI0UktNQzJYWE84b1g5YzFWNTg2S25E?=
 =?utf-8?B?TDR6ZnBRY2VHaERPOWQ0SVBhZFFSQ1pqQ3BaSm9CT0hwaDdicXhCU1VoT2Jx?=
 =?utf-8?B?U0o5QVFnbWU2bExsVWN3Rmt2S2dlV1RFb0tSdm9ueGZmQmtIaU4vQVphc0U4?=
 =?utf-8?B?eVdNM1R0cVBYNDRDYlpBUWgyNERLempxaEJSNndPUHVDalUwanZBSWc4TGw0?=
 =?utf-8?B?cE9nY1l5cGQwZDBYN2prNlhZOWlLTTZPVnh6d3k1MlF5bGRUQWlwZCtadWk4?=
 =?utf-8?B?N3hOaEszem5nejNiSnBFbEZ3MDk4U2VBQ01ZVXNxZS9ldkxNbFhDY1lRcnQy?=
 =?utf-8?B?SUNITDN1RHYzNGx5YWJjeTlkOXc4YmtPQVh6a0Y5cTFEcGtyMTJ4bStiTXVZ?=
 =?utf-8?B?YTUxZzRlQW1aWlErY0VvbVVRRHNybVRJT1JsM1FGTGpveTROMzl2b2paYThv?=
 =?utf-8?B?M3g2RmRtbGRqdU10ZFhManMreCt6eFc3bGlmcmt4YnhLellOTDN0Ni9QOWlo?=
 =?utf-8?B?bzZScVhaYWR2QTQvYnNOOE5Zb1NWQkhQSVJIVXZhUWJoL1JxaFlTZU50Z2dh?=
 =?utf-8?B?enFXWE1tTHJpRlBsUmVJdG1DV3RONGZpZDVIK0dTd0kwNW1XMmhDNGkwQlpJ?=
 =?utf-8?B?WlQvSHRjVXZDb0owOE5iMmZHb1ZRVGxHSy9SUm82ZUQ5NkFMSVVQbXRmeCs4?=
 =?utf-8?B?SEo3OUxucWVyWEwxMmxWclExcHE3NUdHWERpTUplcmR6NmxZb1VvMjY3UGdQ?=
 =?utf-8?B?djZwd0RWMEluUzMvbW1pZStZUmoxS0Rkazh6VHE2djBkM2h1M3FMMUxMbnVu?=
 =?utf-8?B?VzIvM1U2Z01VTjJPRkh6VlFjWFFLU2UrNjNSSlVYMCt6cFBIanJDME9yZzJu?=
 =?utf-8?B?R256WTRVUGxXUTRGTVhWUU9YYTFBdGUxMVljUzJTNm1iblozSGd5b3p5WjNK?=
 =?utf-8?B?N3UvRTByb1drUXo4Nkl0eDZua3BkQkwzSlRQSGlKZjVGWG9hU3QxWFVITDFB?=
 =?utf-8?B?TElKcndET0FiYXFmV1FyNHpvZEh4VEFabnd5Ylkxa0JuN1lsUWNWNTd4dkk3?=
 =?utf-8?B?SVFzcnZOZVYxUFhoRnd2OVBLcmlIRmFXUFJnaFYyM1diazEvR0gxbSt1K3pK?=
 =?utf-8?B?OXZMRTZsYi9CV2xhdjNRdXRwU3hOL1Y4WTVudzV6Vys5QkNRR3RIN2NrV1lR?=
 =?utf-8?B?STJudUphN05Ib2kxbWplN1NhL05OaHhhK0Ztc2I3Wm96TnduNG5jMFlZTG1h?=
 =?utf-8?B?Z3VJb002RHI3RFFMelJlT1BUdGRxTGJac3d2SzV6THppb2F3Tlh3Q0pqVWNG?=
 =?utf-8?B?Y3oxTk9xTmZjcHhaOFd2ai92WjlXVEk3TFhLdVJ5bnhieHF5NGtKak1uRFdS?=
 =?utf-8?B?NW9lVnkva3BSVTByaDVaaDh6bmtoUkI2L3FLNGFrZVR1eXhsT2hza28wNXZW?=
 =?utf-8?B?M25wa1hRcXo3VTR3bnNLb3E1cE9ydVpkK2NBc1oyMk1ITUFhNCtVTE1GdW1Y?=
 =?utf-8?B?OHJwemJvZmVMMlBiendRY1hQZFVjMVZWUkozczk4YXNPUk0zdTcwTXJHU0ZI?=
 =?utf-8?B?NGhKZFlWRkJialFiUVg5aWZOeEh5OTJWQlpEU2tvdGFWQTV5QklmL0NGdGRY?=
 =?utf-8?B?ZC9OMWtHQzE4YnhhVlMvV2I0WHUvN1haSFFHQWJWSjhEVUF0Wk5sQnhyWkxR?=
 =?utf-8?B?eFRrYUN1SEJKRElxWXcxS1BjNnJzeVpSdmw0YVpIdWRzcE5wbFhqTEZsRG54?=
 =?utf-8?B?bExxQTU0NVllTTZIU2Rvdk01SGR5dStudk5WSktDOXNrK0h6REp6UFZXcUtT?=
 =?utf-8?B?WWpOYlBEYjZZZUJLZGhQeUFnYUw1dXkzWWxUMytIcDVxK1RadzMxdDVmRzZs?=
 =?utf-8?B?SlRZa1BlRGRtV3hIYWQ1NHBlNU0wQTJvNGplQ0JUckRLK0ZLS0JiT3l0WHpF?=
 =?utf-8?B?U0luTnhTUzNOYmhhNkZoSm8wYU9XdHF5bmd5V0E5TXNQK1ZaV1VQY0t3cjBY?=
 =?utf-8?B?MjhnbkVJUUJFTGFyNXdnMFM2OE5WNWtwRnFnS3czcVhOYTNmcjNzczZPOEJQ?=
 =?utf-8?B?WS93cjdVTG1DSklGSWFTNWtEdVozb3JMM3lLQ3dzcEtjQng2QWN2MXVtd3h6?=
 =?utf-8?Q?VWJfKiTj94/839KWlbcL0Oz2n?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb0569a-af58-49af-32e5-08daf290aa40
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 22:27:17.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hs7jN8hZr6IOlmILuFFaM0Zkv146Kywfo9HwWG8vwbcTTBHCGCNK6cO2PbJibjT/B8Jl52qkPJoPuVBVqzTdog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8077
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/23 10:55, Dionna Amalie Glaze wrote:
>>> +
>>> +static int snp_set_instance_certs(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>> +{
>> [...]
>>
>> Here we set the length to the page-aligned value, but we copy only
>> params.cert_len bytes.  If there are two subsequent
>> snp_set_instance_certs() calls where the second one has a shorter
>> length, we might "keep" some leftover bytes from the first call.
>>
>> Consider:
>> 1. snp_set_instance_certs(certs_addr point to "AAA...", certs_len=8192)
>> 2. snp_set_instance_certs(certs_addr point to "BBB...", certs_len=4097)
>>
>> If I understand correctly, on the second call we'll copy 4097 "BBB..."
>> bytes into the to_certs buffer, but length will be (4096 + PAGE_SIZE -
>> 1) & PAGE_MASK which will be 8192.
>>
>> Later when fetching the certs (for the extended report or in
>> snp_get_instance_certs()) the user will get a buffer of 8192 bytes
>> filled with 4097 BBBs and 4095 leftover AAAs.
>>
>> Maybe zero sev->snp_certs_data entirely before writing to it?
>>
> 
> Yes, I agree it should be zeroed, at least if the previous length is
> greater than the new length. Good catch.
> 
> 
>> Related question (not only for this patch) regarding snp_certs_data
>> (host or per-instance): why is its size page-aligned at all? why is it
>> limited by 16KB or 20KB? If I understand correctly, for SNP, this buffer
>> is never sent to the PSP.
>>
> 
> The buffer is meant to be copied into the guest driver following the
> GHCB extended guest request protocol. The data to copy back are
> expected to be in 4K page granularity.

I don't think the data has to be in 4K page granularity. Why do you think 
it does?

Thanks,
Tom

> 
>> [...]
>>>
>>> -#define SEV_FW_BLOB_MAX_SIZE 0x4000  /* 16KB */
>>> +#define SEV_FW_BLOB_MAX_SIZE 0x5000  /* 20KB */
>>>
>>
>> This has effects in drivers/crypto/ccp/sev-dev.c
>>                                                                 (for
>> example in alloc_snp_host_map).  Is that OK?
>>
> 
> No, this was a mistake of mine because I was using a bloated data
> encoding that needed 5 pages for the GUID table plus 4 small
> certificates. I've since fixed that in our user space code.
> We shouldn't change this size and instead wait for a better size
> negotiation protocol between the guest and host to avoid this awkward
> hard-coding.
> 
> 
