Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDCD55D840
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240389AbiF0TNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 15:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237808AbiF0TMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 15:12:52 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2077.outbound.protection.outlook.com [40.107.96.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9575FF3;
        Mon, 27 Jun 2022 12:12:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d0FlNzv9b9SlTb94BVp5eks2CDZSDVZoUBOh5sP2ug/SCXymo8nLx6N1aekZxbAXb1bVLcBUQkW7b90PdhFgyKHhSjCr23vrNjVIEJIejljpD7ppE7xx5YcqhuPjNGZBIRc1ANszSr5V6yDmNsz2JEBfVoQj/tiJVHBEBbQki/8efB9DzllGVv1kWDr5rYUBRsDCwgisWgqrIwQmECkDmZeJJvxnj4TWDdMyC369IJgQTK5SMyhkvsnh5yRBMQmmkzx4ECNUbyU1SjqpHJw2yjXIpgTsNWQA6mIhVQDe0EymNvaZXG0NE1oKDgDj/f6UK692yhacHnp1Ra/ci4ylCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DE0IG2h7mSneuMIsBQ9/bnUOrzeQ4UuKHzUslMnmxPY=;
 b=Kg+v0BDImaTEfnMP4eyi8MAJscCFqQVQcUoxSAOr6bn6ewq0sAu5RQJW4LWwmmosnxzc43iHviurtA7rqQPheCD1Y9PD++7az1DlgNlxZTYz/8Gpexdj2GZkQiVFMqZqgmoZ1N6egolEMMwFSjDtyzuDbNhPNF3ljlWNm6W+7SBODTdNvco6RLToOihqE+r3Vh8UupXHzSCHVVj/I/H48kBMmMaSzR2PiJ8JyKF0FMWxIMMX6BnaqRL4Oe+vq1w+C077zPS9lHW4ao1/zmkni7q+kLG9z8wARDQ5tH7coMEb+DtEbq/F32DuZ9GWNUzPEH+38CHnjT/YulsEt5Ln1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DE0IG2h7mSneuMIsBQ9/bnUOrzeQ4UuKHzUslMnmxPY=;
 b=BoVSogP1CIINulkDI5owZi9lttXGtc0/XW/IlDUeT2Gu4XnqYep58AojL6gAJLfywfGp/cRktrG/9WLMzCDjC07yesi90dFZ6iX2fpR6NF7MEds/Cep+M0OvPRanl/8WvmpfoCrMgKxq6EcUsfC2X42Kk4Ahlk4Z8oXp+ivqy9pzkvdVu43uH4I6QyK6SPpuQnSTLZghfD0ZzRXxZrgsSJXTRR3QNLTcp7WQz7fOayfrdu3TqkEaXDF4aM8skMlylL7B/Asv2j07GaznANI7UZlYtXXqoSn6vcVVIL5H/WhdJ3EChfz4NtG3aZOrK04E/qVWYB/rJ+lcLt4+U5EmkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BN6PR12MB1650.namprd12.prod.outlook.com (2603:10b6:405:3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 19:12:43 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::28d4:3575:5db:6910%4]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 19:12:43 +0000
Message-ID: <f389e72c-c63e-5f47-87a4-8eb987858fee@nvidia.com>
Date:   Mon, 27 Jun 2022 12:12:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/4] kvm: Merge "atomic" and "write" in
 __gfn_to_pfn_memslot()
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux MM Mailing List <linux-mm@kvack.org>
References: <20220622213656.81546-1-peterx@redhat.com>
 <20220622213656.81546-3-peterx@redhat.com> <YrR9i3yHzh5ftOxB@google.com>
 <YrTDBwoddwoY1uSV@xz-m1.local> <YrTNGVpT8Cw2yrnr@google.com>
 <YrTbKaRe497n8M0o@xz-m1.local> <YrTgpjLrnRpqFnIa@google.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <YrTgpjLrnRpqFnIa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:a03:254::15) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 576a62c5-44aa-472d-364b-08da58710313
X-MS-TrafficTypeDiagnostic: BN6PR12MB1650:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tKqJxrSUH/PF/XTSzQjFQKZj/AgiBC/qmBU/622L8Q8T3AC7f0BB0f4fOn+ieoAUwA1zdBE0kBcnZi8pwKXWLTe4l2VE3nhhXFjFfLPjjl4hc8XkWFkvRHh26l9EGNxG1yY+sD0Ebof7p0Qsk5TtQddyJ5Dzs7fgRyTzN97UfDjj+N6e0mcvTK6M/UlP7+ngvpRZLCetseInQXS8MfhGDGb7NoPXfpcyu12Tt9w2fGHQZEjnA3wlT/xGvaRfJsVE+CfuJao8ValHS9Gb6kzK6Kr/GUfRNs1O/SI5kJpei2GfSroKSHRsNL4FW5DwcYiRxPUAjLrQFkIgMZJEK5BWe0S64vyNerpccu3Ea2n8Zt+Xms1YWQTNNUyU+mosMno8D3ejpcMflL6kgjClR+vf7Uy6lJH2hlTR5nHX2rXf8q9OHjt1MYA+pMUGIeaJ4KC6ybmJf1kJD7DitWKikNiXlpYgZu6j+Tw6RWBan8v7r7BXz0J05gKM1+FHMd7vGGe+vsuUw7Uya5dvF0fBUPrBrPZOvwjDYJCHI7NgYUvpe8tv9DZMv2+ZBxrFdlClTBX1eaQnrXy9m8WIup2XtL1m26qyKL18+58wrbofHYuxbf5N7dkMT3nzwSjS6y9ZelLWV+TER7n84AXBhV92gaFcFKaa4+pcgOwFuimbRu025mk7xethh1EbcCiqF2kqUkW1HpD4/AqeCNH63SMg07DRZ6h4XH5dGDbfQwAQulFkPxGeLDcvOobDHdG7J+cg3s/1h5de5OPRON+TKGwXFKqHNaA2HrCKP2z5Cc4y7ME9Fht1MBlufEcGfZjkUi33MUX8j4vmCZHhynszGmIVAN5MXQHlNFi+9+hrOsrRbpiXTCs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(31696002)(7416002)(66476007)(4326008)(8676002)(83380400001)(6486002)(2906002)(66946007)(316002)(54906003)(38100700002)(5660300002)(66556008)(110136005)(36756003)(8936002)(6506007)(53546011)(2616005)(26005)(478600001)(6512007)(186003)(86362001)(31686004)(41300700001)(21314003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d2N5Y3h5cnd5VVZQLzhkQndlRFdHREtJQnhVejNxUkxUWTRPMHJ6S0twekJF?=
 =?utf-8?B?c0xVVjRGZFprQXNmbyt2WitMYkpMejVFRHFsdlhhMVhVbGpEVmNtT0FJNmtI?=
 =?utf-8?B?a1JqWjk3cThOTWxDUFlWMitjUFBHVTZJczQ5R2FmVkVXcnhXUWVZeEZEN3NV?=
 =?utf-8?B?K2tweXVmMUp0Ymd2L3hZbVh5VmFBUjYwM2lmTzdpOC9PdUNXQTZJRW5QaXZQ?=
 =?utf-8?B?aG80NlMvbFpPWFZVMUQrU3lCbW84cHp1Rm5Zai9GTWFlaTFpNXg1SkUrZnBL?=
 =?utf-8?B?MXJWQWluTnE5b29XaGxWL1M2QSs3VFo5MUxKNUFFYm5FcjM1QzBDdFBEcTdr?=
 =?utf-8?B?RjVjWlhRQzZzd29UUHZwcExZODNBQ3pqc2FXWVpvdFQzZGpJUFM0VE55TWNp?=
 =?utf-8?B?cUpYOFBnbXYvaGNSVmtSblV0WndGQU9YcklUeUdFTjBKZE9jWUtXa3B0Vkxw?=
 =?utf-8?B?eDdmY3JmRStUTzNsUlNuVVdFdDhRdldiTThZVElhMDNMMDFCa25ycURvZ2lG?=
 =?utf-8?B?bmxzS3RZSnFqZHZSNEFIdE9sMWcya2p0Sy9VR2hPcndhbFEzOHh2R3plRUUz?=
 =?utf-8?B?em1RemhERzJEd085clJieTZaaU40UGxpbldtVFhWVWFSMlpIODJnUHlTUWd6?=
 =?utf-8?B?bzVVdC9Bbi9PanhLSVFOVUlDY1JTeVl3WWpDS2ZLcEQzMGZ2aDdIQ29IaTFD?=
 =?utf-8?B?bFJWQ21rVnpnNnNnMmpGby9KQkdWMDZ3a1p2aDNGL25JcnNnZkljcjJESG1R?=
 =?utf-8?B?S3JJUW9RaHdlMUNBQW1XTHg0QVdZbkdYQW5HTTgwVkM5STVBTFdWbkxQZWFE?=
 =?utf-8?B?WjY1OXhEaEhoMlVKUnJVMFFBem1lV2RaUWcwVVlIZFVHTUx6ODQvbHc1MEpy?=
 =?utf-8?B?N2ExZkhwZkNoM3FJa3pYUWNlbUJOYzUvZTcxVi9CUThaWlEzTStDR0JOSnEw?=
 =?utf-8?B?Q0dNZnJKN1VQbVdJelY0bVhUSUREdUxvZkpNazljZExmQ014QlM3WDFLNzNi?=
 =?utf-8?B?K2lxWFZ0azBDZFdia0xzZDZmNnc4S2Rid2hBY3FkUUtqM1RXNDUzN1JvNTNo?=
 =?utf-8?B?cWY2WDFxRG5rR1JkSlJiQU1tckhHRGpUVTkySktkM0xxcHA4WWlybkk2bU1E?=
 =?utf-8?B?UWhHNW1zeW1XT2dHUk50S0IwN29CSSt2UnBpTWIvSzNVeGJMazN5YmJtRk0z?=
 =?utf-8?B?TnNFNEJXckVjNFFoVUltdjZrYW1wcUlTMitNM2poSkVVSWFZRkFtVmplYVNs?=
 =?utf-8?B?TjJQNWN3dDNjSW1haVovcFREL0p2bWh1MUllWWoyeWVOc1ovU2Nremh4ajIr?=
 =?utf-8?B?ZVRiSk5tMHFVQnNjVWF0VmMzSHNDK1dIellXeTA2dk5tRXduWHU4bDVIMHRp?=
 =?utf-8?B?RzdqSm1DRExSZFRHNzNJZDIxSmMveFNiOVdGbFl0a3p3NWdGeGtzTmRnbVNL?=
 =?utf-8?B?SDVPellMSWhQa0RuVk4xNTA1eCtPQkxveklHKzFpSldmOVZ1T0VOZXpjamc4?=
 =?utf-8?B?dWFFV0ZTMGxrNUxWTW5qTHFuQU84TVI3MU9Fb1p3N3RBWFFGRjlYRVlNU0sw?=
 =?utf-8?B?ZkJXOWIwbk13dDR2WllEVCtIQ25ZaDlkSzhKdG1uaUZwTmZVcnZqakkvcHhq?=
 =?utf-8?B?RW1CVkNKL0xzTVE0QVhwUTFGMnJBcExBQVVCR2J5U1QvZVltZm4wbUp2Lytt?=
 =?utf-8?B?aThxL2pmMTR2UERRSzF5SWZKYXBtS2tHU3BRbStOT045TmtqYmpkRXA0NHNa?=
 =?utf-8?B?NGZVM1Q4UFphd0QzdkxWL1cwaHpQRlRZZXpNeHBHaXRiYXhKcDRMNDBVRUZl?=
 =?utf-8?B?YzRPTVVqaU9aWlBWSnBrTEM5L2lhczdPdzFMa0lkWnhmWGlMYllvVnJIY2M4?=
 =?utf-8?B?YVRxUzdHVEtpaXQ3dkxOTWdXUlYvUVRIcjF4ai9nRjNaRmRUK3VGSkFKU1dV?=
 =?utf-8?B?bWliSHRhVHgyL0pzREhuWTllUW8yTjNyTXVoU3g2ZTJyMWFQMzBrUnhRbTcy?=
 =?utf-8?B?dnVUYVUxRGgyMHFGRllTVzZ5c21DSHA5RVhuOElDTXdUUm81YStVdDVCMEdW?=
 =?utf-8?B?eG5hdVJwbWxSbTJrOWhjWjdsNnNtTmZvNzhhY3NWYkl3aEJZbEZTeHhBbk9v?=
 =?utf-8?Q?wCWwD+5aszHKw/GEkrpgX4wFR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 576a62c5-44aa-472d-364b-08da58710313
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 19:12:43.5141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UHU5cGgm5qQUKRF2PBCpk6lk2EeKSytpUd36Mr80j5m6uPbVVWHWG6PLGrJJcIzWKNw27CYqWHsPbc7TZwo4zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1650
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/22 14:52, Sean Christopherson wrote:
> On Thu, Jun 23, 2022, Peter Xu wrote:
>> On Thu, Jun 23, 2022 at 08:29:13PM +0000, Sean Christopherson wrote:
>>> This is what I came up with for splitting @async into a pure input (no_wait) and
>>> a return value (KVM_PFN_ERR_NEEDS_IO).
>>
>> The attached patch looks good to me.  It's just that..
>>
>> [...]
>>
>>>   kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>>> -			       bool atomic, bool *async, bool write_fault,
>>> +			       bool atomic, bool no_wait, bool write_fault,
>>>   			       bool *writable, hva_t *hva)
>>
>> .. with this patch on top we'll have 3 booleans already.  With the new one
>> to add separated as suggested then it'll hit 4.
>>
>> Let's say one day we'll have that struct, but.. are you sure you think
>> keeping four booleans around is nicer than having a flag, no matter whether
>> we'd like to have a struct or not?
> 
> No.
> 
>>    kvm_pfn_t __gfn_to_pfn_memslot(const struct kvm_memory_slot *slot, gfn_t gfn,
>> 			       bool atomic, bool no_wait, bool write_fault,
>>                                 bool interruptible, bool *writable, hva_t *hva);
>>
>> What if the booleans goes to 5, 6, or more?
>>
>> /me starts to wonder what'll be the magic number that we'll start to think
>> a bitmask flag will be more lovely here. :)
> 
> For the number to really matter, it'd have to be comically large, e.g. 100+.  This
> is all on-stack memory, so it's as close to free as can we can get.  Overhead in
> terms of (un)marshalling is likely a wash for flags versus bools.  Bools pack in
> nicely, so until there are a _lot_ of bools, memory is a non-issue.

It's pretty unusual to see that claim, in kernel mm code. :) Flags are often
used, because they take less space than booleans, and C bitfields have other
problems.

> 
> That leaves readability, which isn't dependent on the number so much as it is on
> the usage, and will be highly subjective based on the final code.
> 
> In other words, I'm not dead set against flags, but I would like to see a complete
> cleanup before making a decision.  My gut reaction is to use bools, as it makes
> consumption cleaner in most cases, e.g.
> 
> 	if (!(xxx->write_fault || writable))
> 		return false;
> 
> versus
> 
> 	if (!((xxx->flags & KVM_GTP_WRITE) || writable))
> 		return false;
> 
> but again I'm not going to say never until I actually see the end result.
> 

Just to add a light counter-argument: the readability is similar enough that
I think the compactness in memory makes flags a little better. imho anyway.


thanks,
-- 
John Hubbard
NVIDIA
