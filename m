Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1EF5B3F26
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 20:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiIIS6Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 14:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiIIS6X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 14:58:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B56EB855;
        Fri,  9 Sep 2022 11:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2YkVKNtaGBeK9hi4rJSIOrvbxf4bYMNdyWhrmhKMleiwHMre2tlw9ef2xXXbNQqimuWr7Cq/EneB4INHmIEHIvZ+TumsiNIB891QYtRJIDhaiCZEnDLTxmKungMXSAAFoUPAdSZu9IoFIB2vEURtr/yGkUCz1P8IDQuv6A3ePQBE/G+dSoCSVQiYzVhW7UqGkewSEISWsvbqofTEyhhbeo1Nv1Pa2w0URyx22LPLjQ6lNPWH6bxwNV4HkonJEdYVAS8ULt0knr6Vo9ZwlBiGGDw5xpaB4AYFU/1fDDpO//l5alx3PtQLTjSLw0N1Imo/JB3mEY44539l5kOw40eMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MUkB5xOURTQNyExe4ya7Lrg8IafNF5bVKfOG6h+j4EI=;
 b=WnqJ29ZRS86vsmVgqTfZVEp6m+YdfGvHnSmzd5t7cCQQ2zoXseofcIMbyxWI2vonLj7bLJsdBFWv8tv5RvRBdm/y3ApPcZZE+m3JTNoc62OhIpFsPdHM7A6su3guizgCHK0ud18JCSrd9gKN6iVvMXTFp1DAhJoWWH6E19MTNFXC+LqEyL1HUwl203BGw1eFa3keDLTwnQjd0zoLBNglG5Qud5+Nnb0PVYIL/MC/b5jN7DhwUYwJUOFvr7cfsM3eU5AAH4TS8MCHlyl6vYiAgkb/8xjkScn9GaPg9NlUgOfefpSYXea/mN55G+wTJ4QmnXAn7ezSeOZfORzwp1F8JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUkB5xOURTQNyExe4ya7Lrg8IafNF5bVKfOG6h+j4EI=;
 b=Vpbwp0QULz1zP4hAmcMky+fIdtqizcB6X9Ed13RoxYmfRMGTIvzO9uDA7TEOtO+j8v9F3cAWiSZEONNohNBbAxyYIiLOiIMj575xT9D9fFMe2PTbKv9Iz4kNr+eLyhW59w5U8n57wXyBtePqCyDOLrHXk8Gu+SljouHjbxLOB3UnNzc39/qDz44OCF1VILvEDPdfMrrLaYGWJBj04pxgM7vSZWhuNOmu0L0CxTmbdiIUEN7U1QlFLHHvlqhmo+Nts8Dtj4rEPL9a31ziHJnWNf9MEbBpzf98vegKN3yvB6AtYU5/9m8d3QSh1bwx916gzjEpKzX2zOTqpuH6rYaVaw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19; Fri, 9 Sep
 2022 18:58:21 +0000
Received: from BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a4df:917d:22d6:6ea1]) by BY5PR12MB4130.namprd12.prod.outlook.com
 ([fe80::a4df:917d:22d6:6ea1%6]) with mapi id 15.20.5612.020; Fri, 9 Sep 2022
 18:58:20 +0000
Message-ID: <7d54bd95-e5f1-2142-6877-d73c76dc2af9@nvidia.com>
Date:   Fri, 9 Sep 2022 11:58:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [GIT PULL] VFIO fix for v6.0-rc5
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220909045225.3a572a57.alex.williamson@redhat.com>
 <CAHk-=wj3rrkPvPJB_u4qoHK4=PVUuBHKB67f_oZO62EE22pNPQ@mail.gmail.com>
 <30566203-bbf6-786e-d4b7-f0003ee35e37@redhat.com>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <30566203-bbf6-786e-d4b7-f0003ee35e37@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0172.namprd03.prod.outlook.com
 (2603:10b6:a03:338::27) To BY5PR12MB4130.namprd12.prod.outlook.com
 (2603:10b6:a03:20b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR12MB4130:EE_|BL1PR12MB5175:EE_
X-MS-Office365-Filtering-Correlation-Id: 161cfd18-666e-4b2a-215d-08da92954386
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F0mjgZKdYWGch5+DWO+3HHnr+hOVa+qssbrYLAgQ2LrZIK/yYICbGIoRa+PLn4L4W63z39uYAEnkO5OyIZ95zhUNYnwfCeGc4O2TyFCqqQY6B/qNzOLJ2rtjXPuyq7ZyBC+g598XKqAqu6nEFmEEXmXmX+lLJea0o8WSqjxgcE7VK2VmfcPpA0lZ04pkJCqCGUIvnOnE4CbiD0nm6uabWpv7avqmz4FVlw5gJ18P4wVvCkMQ830BJAOe/vmDUT7LyY77KNXEhDpp4zViHmc/sh/LjW/7JVvscLNxQy6FeCTR9g6738mcHUFTCfHeHg1Dt5UBZB5JAkv54jO9onoXcFeZxL0nBljeb290OqE1FdMYRqjvK1WNYgmwxOvVGgXH7Bx8eioD+owgSNAUJO4/Yuje6VM8weWrLLuDvMe85a05/DlxbsuGomC2LZhhF7Tq+WLUPN4rDGzrBJkI1DJCJA96G3qzIgsfKWeL/JYqe4HdBdC8v0SILYcQUJET62hent/Fq9BkoAUY4le3dGpvNg1n+uoeZlnUh0aFPbM9xfVTdkjZ/fUXdMUQ7Vl1jlcIP73fY7paIwMGg+v0R0nVVHhScG7L8aK2dFFgbMdnjj6jeXJNnybIX8brUNiPC/CEfKnvz/hVgKxQbraX8QiiEuZA2xYw7Dg1XivpPA0jazqd1WuTMWwg4mr67lYiTUjjro61SETxqFNPo3rVH9/S4l94FubySRYltofIZMr9Yt8sWynpY6QT5Ny3rR8Fn9omrUUs3dsDJUY+fzeS0pWRSuedFMFLPBQRFU+nvP+hzL7d0zusCqWei/UNIBecLtGLDjK5+xRjfUllyrOeYPz0dQe4+dHlcTnL3rCbHLNDIva9Th9mRsmzqvTnnbihns2b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4130.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(316002)(6486002)(110136005)(31696002)(86362001)(83380400001)(2616005)(186003)(966005)(478600001)(6506007)(38100700002)(53546011)(26005)(6512007)(2906002)(66556008)(5660300002)(31686004)(8936002)(41300700001)(8676002)(4326008)(66476007)(66946007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZGh0UTNLazRtVExyTVlPRlF4dzlYMnl5TDBuV3k3ZDJVU3hKMktXVGhpaW5l?=
 =?utf-8?B?VlZyUTE0UVV4K2gvUUF3MG9oemxDdWpoVXRvcjNiWG5EYTNjSlVqYThwTFVM?=
 =?utf-8?B?dXJuanNhSzgzWUxPdy9VT21idzlBZUpnY3JOWENHRlEwbVRvTEF1anFGUms2?=
 =?utf-8?B?Y2E2ZVRnSmF2djkwYVN6aVFSbVg2UWNzcmtkaTJnTGZKdkFLVVk4VXNTUFZQ?=
 =?utf-8?B?REdkSm5McWNMc2xtc2NMMUJhd1N0QVdpdkl1Smh3SGtrOUVUSEVsNEZPMHJ1?=
 =?utf-8?B?ckJacGhBY25iaGtkOW5HejlPTVBGQWpkM0M5WWNDQVREZHEvTWNRVGhJSStz?=
 =?utf-8?B?cmtuRXlKSm4wcEp6Sm5hVzV5K1NiYmw3c3J1eHVOakhGdnZMTkRDaEM0N2kr?=
 =?utf-8?B?RkxhcmR3Ymc4Qy83aDVKSTRYVTM3K0ZvdFFybVJwWi9INUo3MSt4VHR2MFFI?=
 =?utf-8?B?b0gwanhMaDYxTXkvOHNsTVhwdFlrS1REdkJQMHpIdGtwSUFNMWFrUTNVdGth?=
 =?utf-8?B?d3VMTndUemthUkVZcjg5UytXVG1KUkhFM25jYk1wKzdqYlRpL2RveUdHcDc1?=
 =?utf-8?B?QlRvcHE2ck9FYXBQQVp0Z0dhZHVld2J2YUtMNjBHSndjZEFHVTVGRkdCanl2?=
 =?utf-8?B?RG5JR3BaYno0OGxaOVgxL3lSa0VoNXk5dCtrc05WRi9jTEpRN1lBL3RFOFZW?=
 =?utf-8?B?cU5WQWllVDh2Wk5OQ3p6OFd1ZzZHdlUvOVZpN0ZUUlJ2Nlk4VUpMRVpvc1Rp?=
 =?utf-8?B?SEJ6emd0WHRKR3hpYnhWUGVURmc3eldVbllSeldmb2ZNZHlDZGx2MnhTcTU4?=
 =?utf-8?B?aEdnM2xLL1d1MDMvTjgrQWtYZno2a0M0Skw3MXdZNGVLMndBa3NzdktHZmc3?=
 =?utf-8?B?SVJHYmNNUHFEKy83ZStleXViS1g4dnRFeUZjSnFpVzRnZDJ0Znk3M1dPblls?=
 =?utf-8?B?STljNEJHVjNFNGxOV2Z5V3BjeDl4QitvOVB2NmVBRW5Cd0lrNzdsRGhHTnYv?=
 =?utf-8?B?YzZoTndadUhZN3VTQ1JWMzlpL0ppTm1hRFhoQ1pkditsM2dNdTVjY2RaakRQ?=
 =?utf-8?B?MFNGdHFaU3dLWE51NnVwbWE5VFNVL1czUEtCTHZHMm9iUkZ2djVMN1h5N1Bz?=
 =?utf-8?B?UDQ4TEVvYkdVNUFaWmFzelRlUHNZUEpDOUdJVjMxN0VrbFEwbnVTbnM5OUg3?=
 =?utf-8?B?TVZkanIyR2tkTVppcU50ZnNJYUVOSVc5T2VabkNXeUJUMDVLMkRkQ3lQT3RV?=
 =?utf-8?B?VlJKbUE2TjZQZEtnUEhIcktRU3pVSUE3NTlUdXMxVUZyeGNpWDNxUG8rOUhL?=
 =?utf-8?B?WnlLaDZ4dDVtVVhBOFpLa21adUZTaFNVd2lEd0p4THdwRnpid3VKcS9ZeG5O?=
 =?utf-8?B?dFZNMFV4Qk1mbFBqRUthaHFZaEkrOGI4Q2kzV0haYTdRMGNsZ2U2NDZJNjA4?=
 =?utf-8?B?Zk9UZ0FqVGZmbURIQ1pQbjU2Zit5cU5EekExTlk1U1hiY21xTzEydGl0Vnd3?=
 =?utf-8?B?c2VsZTNBOWZTWXNEVmcwa3dpQXhaNVI3OEd5eHlnN0t3N1hMd1NzVmFiWXVq?=
 =?utf-8?B?M0MwNlNZWUZDb0hxVzFKeGpJZzVVV20xeEorWnkwaTFBL1FjMmRpWEVkMHpV?=
 =?utf-8?B?dFFRMzZVdk9aay8yZ1kzSVVkU2doQVA2cXZtVzFiOWdQRG5aekVndDh4THBI?=
 =?utf-8?B?d1FBSW5YaGY1WEN1MVhkYzI4WHZoeGRWd2d1TFhyWTI4YmszaFpqa0pCSVIy?=
 =?utf-8?B?czZ4SWx1QUM1SXhGTlFrQWdKSnQwbFl2WXRnR05sRVVZMmpWTk5wUzUwUDlt?=
 =?utf-8?B?NUZUd2ltZE9mUHNQSXJ6UW1GR25leWJmejJnYm4xSVUwa0J3WnlXUE5laVJi?=
 =?utf-8?B?SWFmZ3h3SDNPSkkrdWRsSnM1QnJHbU85REJrNWhSSG1YeExRSXplSy9vY0dL?=
 =?utf-8?B?R29nMERycVAxTC80b3ZBWjZHR1FxeUIvU21RbXdWWXJzUmRsTnhtb09CTkNP?=
 =?utf-8?B?d0ZJSGFic1FKSy80YmtCSkthU0R3TGZwTkNORGdibE9TbFV1TVZlenJoR0Jo?=
 =?utf-8?B?N3oxaGlrWk5EUytrTEtXTlFYOUx2N3luV2JDc1NqNDJ3WTlyODQ2NHJUQWdj?=
 =?utf-8?Q?unn2e6O3zz4H6dwdE7djl7TGA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 161cfd18-666e-4b2a-215d-08da92954386
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4130.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 18:58:20.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ud1Gd3dNxSlUK7lCkrto7h+nHhP0NoLcNclC556p2yuCKvV34L323IwvFs6xrs20j/UMgDsbzidL6u+uYecbkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/9/22 05:02, David Hildenbrand wrote:
> On 09.09.22 13:53, Linus Torvalds wrote:
>> On Fri, Sep 9, 2022 at 6:52 AM Alex Williamson
>> <alex.williamson@redhat.com> wrote:
>>>
>>> VFIO fix for v6.0-rc5
>>>
>>>   - Fix zero page refcount leak (Alex Williamson)
>>
>> Ugh. This is disgusting.
>>
>> Don't get me wrong - I've pulled this, but I think there's some deeper
>> problem that made this patch required.
>>
>> Why is pin_user_pages_remote() taking a reference to a reserved page?
>> Maybe it just shouldn't (and then obviously we should fix the unpin
>> case to match too).
>>
>> Adding a few GUP people to the participants for comments.
>>
>> Anybody?
> 
> I mentioned in an offline discussion to Alex that we should teach the 
> pin/unpin interface to not mess with the zeropage at all (i.e., not 
> adjust the refcount and eventually overflow it).

I don't think this is part of the problem. And I sure hope that it's
not. If you can make such a change, and contain it within the gup.c
layer so that callers can still think they are pinning the zero page,
then OK, that works.

But generally, callers expect to be able to pin the zero page, or to at
least believe that they've done so. :)  Sorting it out and treating it
separately requires larger changes to probably quite a lot of subsystems.

As a case in point, very close to my heart, I'm about to add a
pin_user_page*() caller to block/bio, that pins the zero page, after
discussing it with block/fs people [1]. 

> 
> We decided that the unbalanced pin/unpin should be fixed independently, 
> such that the refcount handling change on pin/unpin stays GUP internal.
> 
> 

OK, good.

[1] https://lore.kernel.org/all/20220124221709.kzsaqkdp3gmjie3z@quack3.lan/

thanks,

-- 
John Hubbard
NVIDIA

