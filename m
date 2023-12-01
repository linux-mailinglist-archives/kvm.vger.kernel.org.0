Return-Path: <kvm+bounces-3174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD66A801623
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:18:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 86A88281ED7
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 22:18:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF703619D6;
	Fri,  1 Dec 2023 22:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nLWiyTIp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2070.outbound.protection.outlook.com [40.107.93.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66493C1
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 14:13:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jiD5WJD6Gn2MHjeSINtNfRN6hExIQESEJBzsoiummQZnPXQ8hqC1z3eq7kpECKCLFSFJW0hx+kgKva5JW1QxLnByM+zV76VXd35HG6dzGjn5EdzhjH1aSiZ7jZWjDXkM0JGDD5dqgTnsMeGwRx5LYsDizkZQzABqM0oIdKAXLz17gNvKiclixOWd5GZl41jLpDKfFOpCVTU5rRXR+e+1S4qmBLDEzCiHiZxz330nCQbpk774ZWXTzZVfVrsBwcalwDh4qjpJRe9g4+RRsmPmBTRQP8JUOcqDr6f6apKVHPPRfHuKH63CzHwl3ia07W7+GKYQRTSdhRY65TX2sUrozg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/+5+2uxOiT9xAAzoKHr7zgkI+gbJR8tftzy2phM+FA=;
 b=BMQP3buId9AxA0+4xSqYIhnEin+KpoRftvS7QaOXOXTpW5TDqh/IBiqhwMfg3eHidKYVK3zr49CDr3ubZzCxdwq+3jfOVh8c0XF8VTGzVt63/SBWb7TWjKMRVYd5AxhhLDeKBFzPUeA1cfjM0iugUk2OB4DyJvizNfN883oT1JOdEWCS0T58MOj8faUw/mO6bHcN1wzfwjw7o/y3nHnKM/ZyhPtYgoxtJvLYGI/qvOcfK4jlTE1GvC3lvIL4jF0DYMVjEE5Je3zVbDSF+b9K6PhoimaJeiP+KZRVuYrJwxLN7AWAKfLtyM5WMlXjwoWxeplE44doMPRPUp13yY7lwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/+5+2uxOiT9xAAzoKHr7zgkI+gbJR8tftzy2phM+FA=;
 b=nLWiyTIpJf7ad9b/gMO7PAFMbXtnc1C7oQFd26rBJMGi1WfyIdZ15lQ/F1f5nw55zLQCjfCzBUTL/XLu1ccHjpPoV3y8k+XYmUVFero4UhT9PdjoXZwxThFcbE4KadVRnMpPRmSj09BgfXreHbLifDTnSQKq9oxAuOCkRP5bpYA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by DM3PR12MB9288.namprd12.prod.outlook.com (2603:10b6:0:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.27; Fri, 1 Dec
 2023 22:13:23 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::3341:faaf:5974:f152%7]) with mapi id 15.20.7046.024; Fri, 1 Dec 2023
 22:13:23 +0000
Message-ID: <f5b8ac1d-f8f9-f7ec-60c8-39428f784261@amd.com>
Date: Fri, 1 Dec 2023 16:13:21 -0600
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH 0/4] KVM: SEV: Limit cache flush operations in sev
 guest memory reclaim events
Content-Language: en-US
To: Mingwei Zhang <mizhang@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Jacky Li <jackyli@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Ovidiu Panait <ovidiu.panait@windriver.com>,
 Liam Merwick <liam.merwick@oracle.com>, David Rientjes
 <rientjes@google.com>, David Kaplan <david.kaplan@amd.com>,
 Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
 Michael Roth <michael.roth@amd.com>
References: <20231110003734.1014084-1-jackyli@google.com>
 <ZWogUHqoIwiHGehZ@google.com>
 <CAL715WKVHJqpA=VsO3BZhs9bS9AXiy77+k-aMEh+FGOKZREp+g@mail.gmail.com>
 <f3299f0b-e5c8-9a60-a6e5-87bb5076d56f@amd.com>
 <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
From: "Kalra, Ashish" <ashish.kalra@amd.com>
In-Reply-To: <CAL715WK7zF3=HJf9qkA-pbs1VMMxSw_=2Z-e6e_621HnK-nC8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0158.namprd04.prod.outlook.com
 (2603:10b6:806:125::13) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:EE_|DM3PR12MB9288:EE_
X-MS-Office365-Filtering-Correlation-Id: b0e26458-dbe7-438a-b31c-08dbf2babbad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PT8zn7wQxEqKkm7CpJiMAEE0We2sIGAod5/FkBAIJp9TuQTeD7DKfk+MCJ95AMzezkvoKJCDY/aF0FSbS/TCt/5H2V8f6WIXioGIsLlFfdsVWsAyklX0arUbzu2s0Sheo3SN23xLawiQXkU9KLZjhaZoq/L3P4P0mGJSpJBeEjirJ3Iv+ryqPvef84rBBw0W6eigyoKSV6BdeGIIU8tmVokLvppsmKt/W3x1vLGt3Q1RUg10umdPpE5DbiFPl8vrCf89ihjhkb5RnLji3RH2KExwD6CJDAN6wjwsz1g/RZHZ1/Tmcq4hnqOR2gAFtpo7K69KRXF4/2uwnn1l7GMviZL/EGvp9BDNTd7AWs/LaxtAaD8nF7tAdTV8+MI9R5eeEpga47FzWW/nLnsKhmLjlkCxAWVRGcngGzGaLVvqx4bZeQBYqPAjbC3uRGJZLXmZ/NS85o+hNF+xxmo7+u+w3CaBY4w0nsfQnmKlLSAl0lOxG5Fb7kboBbZ+dVGIyMnidvSkR4i8qygl9kimcEtYUB0Sna74M3gwZOjSPMGQt+P0FrvcUzNgav6opixjlH/o4OlmhBCdUyEDtAa13F2RnxHvQI6Q8is+UG5kMsF9GsmGkpzbPBfW/zC8jP6iv7yodTGV6G7JEFZxIdsaWOCtSw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(136003)(376002)(396003)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(5660300002)(2906002)(54906003)(6916009)(66476007)(316002)(66556008)(66946007)(8676002)(8936002)(4326008)(26005)(41300700001)(6506007)(6486002)(478600001)(6512007)(53546011)(31686004)(2616005)(83380400001)(66899024)(38100700002)(36756003)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WUZ5QlZoWUpub1VxWmVSUVBGR0taSkxReVlpZEtGaFMvRmRxUUxsYnNJOVFD?=
 =?utf-8?B?b0FXZ0NhUVhCMUJHUm81Rkp1K2RxK2hPcFN3aEx0ZkUzcUpLRStzTFkrYzJX?=
 =?utf-8?B?TWdFM2tONE5xV3p1eFVHMlRnTm9ublFlZy9jdGp0dmZJN09yWjFkcXpISlM3?=
 =?utf-8?B?aFFTRHRyNlh2VjlMWHBOUlM1dHVRN3Z1dFd5Vm1zeDhNSFU2VjBURlBoRWtX?=
 =?utf-8?B?K0ZmeGRkcUNPaWJXNnBCK2NaUkJXMW45NFM3SE45b09vT2pjNGNPb1BlRi80?=
 =?utf-8?B?K2c4NGozTjFrT2kwZkY2MnJSS3JEVlZKUlZBVVVMb05SNzQzQ0ZETVNIc1U5?=
 =?utf-8?B?ZitvaTB0cnNXK1BTQXRTZzFjN0EvYnJPQXVwV3AxTFc0UytlWHl5d1R5TWpr?=
 =?utf-8?B?ZDNPZjRFNy85cERqQ1J4RzdxL0ltaDVaMkgzV2pEZkhXVnUzYzFtUHBpRmw3?=
 =?utf-8?B?Y1IraDA0T0hoeE9tM2VhRlhDV2o3ait1MU81WVQrdmp2NmNyNTVEQXE0QVFI?=
 =?utf-8?B?RnZYWnEra0M1eTVoQWxWSmIwRkNJWmdLL1BkNE9VTUxta05LcUlhVVUrMjUy?=
 =?utf-8?B?elBJUFdvc2xnNjNlTmVkZ3hlQ0NpMmJjbnlqb2dYVEl2b2Z0V3ZQd2w2V2or?=
 =?utf-8?B?d01ReWc5Sit1UitBY0gzWmNRUWEydXVIUFl1TFdLZERndUZtUVdra3MwcW82?=
 =?utf-8?B?Vk1ld1ExOElENU1mTWRBeWNFVnY3a3ZKWFJnOTJRV0pSL0tqQlNrV3FxSHBv?=
 =?utf-8?B?b3NGT05DMFB5NWZQRHVJYkdYNkpqZ3VrUU53S3BzK2VvaU44dmdNNy8zMzJj?=
 =?utf-8?B?WlpVa3Yza2Z3b0VFdU5kYkJXdk9UcjNuaWpkYUxFSHVadXMyYW5pWjk4aTJ1?=
 =?utf-8?B?TncrVEtyMnJUZTFMSnE1WENZdGt6QnZZV0VPdGxzYVI2RnBaRUFPL240QVpQ?=
 =?utf-8?B?N1lKQlVHSGJSSFBEOUowa1F4cmdDRlkwU1dRZGlXSC9mYWdGbWVJMGNraWYr?=
 =?utf-8?B?cDcwT0VxUlppT3VQUHVGNGF5WnNSbFhhVlpRYWZITllxclJwNVpiN0lqbVB4?=
 =?utf-8?B?SEFCNndHTmVDZURiRkRTTitNcXI2M0o5N1MyN2x5Uk1MRmhjRmkxN1EzRHJa?=
 =?utf-8?B?Tmw5dWRxTnJsem5KYkN2ZDlpRnMxRHdDdkozdVYzM0V6TWVXZTk3OVl4dUdu?=
 =?utf-8?B?d0tBRk8xSzdoWHA4VjF4SlQ0TGo2a3NmSlYvdWlIblFQMWFPd1VQZEQ0dEU1?=
 =?utf-8?B?em9nai80RTZLakx3dFZtREtiRWphbkx5WERUcDZqeVJPTWtTb3JCWDFJZXZJ?=
 =?utf-8?B?TkEraFBNM3VxNm9aNnRqZkRUdjlEdnZKd0JwTERaTHBkNjkyTHhiMWt4ZmJC?=
 =?utf-8?B?TGZ1MCtsZHg5M1BsRVNKZERRc2gwdHdSNXBxSXk0TUVteWlnTU1lcTlIaFc4?=
 =?utf-8?B?d0F5eWtiTVpPakt3RXh5TUJGVmViWWtsUlYvSEpVV0lxUDB3Nnh6Q3l0YXN6?=
 =?utf-8?B?eGZWcFhESWdrcU16ZDR1c2lFK290TUkxVFBUK3E2U2hqS2xTY2hUbUcrUWVP?=
 =?utf-8?B?Y3I4OFZySXNEM1BBam51bnhpUmQrcXk2YTdKb2JZK2ZlZW9rRENLcWwrU1p1?=
 =?utf-8?B?VStRVVljSXNvTWNyb0dwRDdiRG5jQlIvZGhwZGpRc0tYRis5dnF3TTdlUVp6?=
 =?utf-8?B?c0ZzejlvWGwyeUtpZEVYR1hNeWI5NXZVb3pySGNZcXJsYytaa1Zrdy9aRFk3?=
 =?utf-8?B?SlFMU0I5WmhlYlhnMHBzODlXUG5DZkh3d1NvVlF5TjFOd0FaWWZabXVic1NM?=
 =?utf-8?B?b3RqYytoamxJNk9DcC9sTFRFcGxlaGlHek1IbGNwVjFuZDI1ajBVREcwbEdW?=
 =?utf-8?B?elRzRGk0dnN1SEVJM1ZVd1dXcmVCb04rWk8yVlR2R1AwYlFDbEJ5MGI2Mm0z?=
 =?utf-8?B?eUdCaXJKbkxkbHR6b2dDQXBHUXBMNmhtVzh4SnlsTC94WXFMVlZKREM3Q25V?=
 =?utf-8?B?RldKcDRGT1BlcXFlajBQMWJYQ1RERFVNbjVTU2tCOVJkM0hTL1EzWmd0WXdZ?=
 =?utf-8?B?Wlg3M0R5ZkY1RWpqV05YdWVrUUM4UXdEUTFtclZ2WnJBN3NRY1VNL2EzeHlo?=
 =?utf-8?Q?ZFwI6tJsv6vNieE+1m58pj8b/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0e26458-dbe7-438a-b31c-08dbf2babbad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2023 22:13:23.1263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KvPgDOIgVkBxGoTWTzwiKXWKdNaW1q6yPn/xNYAGWYB1MowshAw6FB6Co8kxylS6gOrl10ERzYoi4pxutcHzFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9288

On 12/1/2023 3:58 PM, Mingwei Zhang wrote:
> On Fri, Dec 1, 2023 at 1:30 PM Kalra, Ashish <ashish.kalra@amd.com> wrote:
>>
>> On 12/1/2023 1:02 PM, Mingwei Zhang wrote:
>>> On Fri, Dec 1, 2023 at 10:05 AM Sean Christopherson <seanjc@google.com> wrote:
>>>>
>>>> On Fri, Nov 10, 2023, Jacky Li wrote:
>>>>> The cache flush operation in sev guest memory reclaim events was
>>>>> originally introduced to prevent security issues due to cache
>>>>> incoherence and untrusted VMM. However when this operation gets
>>>>> triggered, it causes performance degradation to the whole machine.
>>>>>
>>>>> This cache flush operation is performed in mmu_notifiers, in particular,
>>>>> in the mmu_notifier_invalidate_range_start() function, unconditionally
>>>>> on all guest memory regions. Although the intention was to flush
>>>>> cache lines only when guest memory was deallocated, the excessive
>>>>> invocations include many other cases where this flush is unnecessary.
>>>>>
>>>>> This RFC proposes using the mmu notifier event to determine whether a
>>>>> cache flush is needed. Specifically, only do the cache flush when the
>>>>> address range is unmapped, cleared, released or migrated. A bitmap
>>>>> module param is also introduced to provide flexibility when flush is
>>>>> needed in more events or no flush is needed depending on the hardware
>>>>> platform.
>>>>
>>>> I'm still not at all convinced that this is worth doing.  We have clear line of
>>>> sight to cleanly and optimally handling SNP and beyond.  If there is an actual
>>>> use case that wants to run SEV and/or SEV-ES VMs, which can't support page
>>>> migration, on the same host as traditional VMs, _and_ for some reason their
>>>> userspace is incapable of providing reasonable NUMA locality, then the owners of
>>>> that use case can speak up and provide justification for taking on this extra
>>>> complexity in KVM.
>>>
>>> Hi Sean,
>>>
>>> Jacky and I were looking at some cases like mmu_notifier calls
>>> triggered by the overloaded reason "MMU_NOTIFY_CLEAR". Even if we turn
>>> off page migration etc, splitting PMD may still happen at some point
>>> under this reason, and we will never be able to turn it off by
>>> tweaking kernel CONFIG options. So, I think this is the line of sight
>>> for this series.
>>>
>>> Handling SNP could be separate, since in SNP we have per-page
>>> properties, which allow KVM to know which page to flush individually.
>>>
>>
>> For SNP + gmem, where the HVA ranges covered by the MMU notifiers are
>> not acting on encrypted pages, we are ignoring MMU invalidation
>> notifiers for SNP guests as part of the SNP host patches being posted
>> upstream and instead relying on gmem own invalidation stuff to clean
>> them up on a per-folio basis.
>>
> oh, I have no question about that. This series only applies to
> SEV/SEV-ES type of VMs.
> 
> For SNP + guest_memfd, I don't see the implementation details, but I
> doubt you can ignore mmu_notifiers if the request does cover some
> encrypted memory in error cases or corner cases.

I believe that all page state transitions from private->shared will 
invoke gmem's own invalidation stuff which should cover such corner cases.

Mike Roth can provide more specific details about that.

>Does the SNP enforce the usage of guest_memfd? 

Again i believe that SNP implementation is only based on and uses guest 
memfd support.

Thanks,
Ashish

> How do we prevent exceptional cases? I am
> sure you guys already figured out the answers, so I don't plan to dig
> deeper until SNP host pages are accepted.
> 
> Clearly, for SEV/SEV-ES, there is no such guarantee like guest_memfd.
> Applying guest_memfd on SEV/SEV-ES might require changes on SEV API I
> suspect, so I think that's equally non-trivial and thus may not be
> worth pursuing.
> 
> Thanks.
> -Mingwei
> 

