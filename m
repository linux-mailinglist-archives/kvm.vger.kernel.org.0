Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73856BB659
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 15:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbjCOOnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Mar 2023 10:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbjCOOnR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Mar 2023 10:43:17 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5905487D81
        for <kvm@vger.kernel.org>; Wed, 15 Mar 2023 07:43:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irpuwgrHpbmQ7G2290p1vCaev6WnaO2969cSy9U2qqo9S6fnMbz5OB6bmA8SD1yJ0AVjPXqw37Jts0O3h4j09XRNZBKoZLoUSkN6NNiNZE/GtdtDNwZFwwAuPIy8MiSusknZzy2IT4tetIN5u6iIdVGQ9hn6hzzkcEG5vt9YrS/O5RpG4oyZkbIvJLTkj2hW9jaJRvLvFaflaBBTwzUtd0oB9GF/gRoVkj9M4VqYVWvZjMfD5MvFO8sRnDZ8B5RHmLx3dxwVeHSjbRUnasN8pcA5wZps+/iKi2+jfX/TuqcXmDJ7KA8l9kWl7UcS0xl6lVHttkaIWFrIZUP4wM9tww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WM51ZlsU//Ujj6y+kB7GsxYAQPQa2C0MTiBeQBhuc7k=;
 b=jMi9bpldVqpWqf9PVvIZHuOZTM62eT3CF3DIbetpnU+6y7ZR06vxv47JZ7neZGe4pFGWlkQzoSnu07w8PMK7eOZbXPcms7pVQUYkljFvOUubCv0dUhnzz1RdKhiNWuStLTr/0XX82wOTB9TqTv81vg7wkELjWEe4L9cIfcPbaGI6ZhlVWmf09xvb1btc7mT8MEo/Mlv06KjxX7WbblH24swg1Om2VK6Y8xumMQjZzT5YZbVZcjn1Wi77FzUjsCDvcgLfsVse+vB66ybrR5pZYG4IKAzrZ3JsE+GkWnbK6hx0FNn205qKiuLg+m4aVbEa3h8VkWQ6cBWd4MH1b5m+WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WM51ZlsU//Ujj6y+kB7GsxYAQPQa2C0MTiBeQBhuc7k=;
 b=3B2lnDPio67YQQlT5lNs7hbZP92XagJ2+qppTHRmK0q/cZvKFkNXJnSOduvEnxVapuEQlwF3ulOM1wWh1OIMR9sKqyalx6j+c+q+rLZtfnHyF+61zSRlUf7zrNnQ3yux/VOp2N6g0v4LyCvVIpCxSFTuUT4E1+M6Qz/wFSnkP7M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by SJ0PR12MB6968.namprd12.prod.outlook.com (2603:10b6:a03:47b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 14:43:13 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3490:de56:de08:46f6]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::3490:de56:de08:46f6%9]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 14:43:13 +0000
Message-ID: <ffa6ed49-d6e0-04ec-5e0d-93f2e28cbd99@amd.com>
Date:   Wed, 15 Mar 2023 09:43:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Reply-To: babu.moger@amd.com
Subject: Re: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
Content-Language: en-US
From:   "Moger, Babu" <babu.moger@amd.com>
To:     "Moger, Babu" <bmoger@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>
Cc:     "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "marcel.apfelbaum@gmail.com" <marcel.apfelbaum@gmail.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "richard.henderson@linaro.org" <richard.henderson@linaro.org>,
        "yang.zhong@intel.com" <yang.zhong@intel.com>,
        "jing2.liu@intel.com" <jing2.liu@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "Roth, Michael" <Michael.Roth@amd.com>,
        "Huang2, Wei" <Wei.Huang2@amd.com>
References: <20230106185700.28744-1-babu.moger@amd.com>
 <20230127075149-mutt-send-email-mst@kernel.org>
 <8df55f5e-afd1-ab04-c7da-8ac70a8f9453@amd.com>
 <26a70833-b9fb-d975-4c90-3adaaa497bd2@amd.com>
In-Reply-To: <26a70833-b9fb-d975-4c90-3adaaa497bd2@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR08CA0019.namprd08.prod.outlook.com
 (2603:10b6:610:33::24) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW3PR12MB4553:EE_|SJ0PR12MB6968:EE_
X-MS-Office365-Filtering-Correlation-Id: ed85c242-2130-43bf-d2d7-08db25639a7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L7c1wFibJortsnzHU1Z5MLK/TqdWj2b9Oo/8D5cCGMHP+OxbNjtfkBgZDl8tlfi9UEzXNMowBp01LX7ZbOsYtaypT3WHyet42zfQg2aQn9SCxybI1r+Cm56fzoavaQSv3FnHw6R58hkzigmSb/9jVCe1uaTy0hzGsQbCTAPOpJYrH2h+7V2yvZei0kiAs4A3VRzv97A6OjiK6Dz8JWtPaR0wQQOcUzS/7+alO7PqCj6GE0VSvsVBz+iXJXzNnS+5lwDgFmi6UKvZ+sYw+S4eYb0oHlwtFi00PqsQQngn9QoYVZr8T42TEmSZYW+K8jBXacDk65RllKmweCDp7T5MvDSqF4HgmN7Y66pRMPqGd1rQqi66h4GIaLVbqV+vFdz61vUB2eS9stvt2iZVTgGCaOjfBuaf/qMPj+aFzL8MZTIVZEzDMT8EyY/ueXTueuQVRj1dLwYwkLvoRhDnaf0TAAZBxmWylN3QdrWULho2ZmeH5BUWen2mLGNuyLemk/dayhhCygw5JazaZML9q5KMIlZtxbZH58TQr0FyAYEKqTEJ3pv5thC1+jG//MHdzVpAJmhdIRg0SFhZPP92HgFGgSK4Vc7sLe8i25pWHe4bC+z1j7rsorNwG+/8aGKQIwwRs1B/SHKdZmju+vOCDVRRGXVW8H78yNCK1/ovLqGWKc5E87Z+e7eSuJrNulLa1mSfHk0rI+blVXGhgDOhvPQQt2WDiFuI9dQJSznfOns1fB/U0Rp89eVZZMIdhYlKe37BqCUQZNzXrk5b/RB7oAxFVzYV0xwI/Ntbo0gUtOCcTQU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(451199018)(31686004)(7416002)(41300700001)(8936002)(5660300002)(3450700001)(15650500001)(2906002)(38100700002)(31696002)(86362001)(36756003)(478600001)(66946007)(66476007)(8676002)(66556008)(966005)(6486002)(6666004)(4326008)(2616005)(54906003)(83380400001)(110136005)(316002)(186003)(6512007)(53546011)(26005)(6506007)(170073001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1hjRXV6dlg4MXk4SlYweC9ORGo1a2J1K3V1dCt0emVWcTFsVGNpZ3dmeVg1?=
 =?utf-8?B?SmJuUHQ0ZHhFekpkdTJTbW9LNDlQQnVEc0kxUmlIZlVkSW96MGI3VFZnOHcy?=
 =?utf-8?B?clRiemxCUGZ0S1ZrWXpueTZzUmViZ2E4b3ZVby9qUW5XWHlVaFlOclpaU2tX?=
 =?utf-8?B?VThtekNzQktac0xqT2dQaDJva3N1bVdDRFZVdWNQV1JaZThPS093eFpEdWpV?=
 =?utf-8?B?T2FHN3BJRUhrSVVEYmlQSkRQMkgyREtzL2o4bUJ4d1lkeXhoaSs1dy90K0Zh?=
 =?utf-8?B?RW92dTRmKzk1emRuT3J3L2FFUlJZM3ViQ0l5Rm5Zc1pXVjBNMU9aWlpjTk5K?=
 =?utf-8?B?MU00ci9oTTJqdW02aDJnRVhOc3NBd1JTT1BOVVp1SG9DeDRrVUJxVHVybnZl?=
 =?utf-8?B?SEgxMURPRGVJR2tFYlRNeTV4WEF1bkR6SDFMMUdOQWdXRDFCNG4rNitnbWdJ?=
 =?utf-8?B?c0dFWVBzNnhWSmpDQ2grbzc4SlovMGFFeTB0dXc4Yi9YWWlqV29RY21QQXlJ?=
 =?utf-8?B?dEZXcGhBYUZtWVNQNUdlbkNwOVo5akhhSCt2QUY4SkZCMVVqZTd0Y1dlQWhX?=
 =?utf-8?B?RnVSTGQ5NlZ6Q0lrRzlrZ1h1NmxQUnVPQVBJWkZIYlRvVk51K3R5VlJJa2JS?=
 =?utf-8?B?Smh2ZDZ6OVlYTm0yN0UrNnVrUStpMVVWK0lWaXN1WjBENWVYb240TXFNOXBJ?=
 =?utf-8?B?Rm45VDUwUTAzcFNzTGJvL05mVThwdjBZRjFXUThQbUNrQ0p2WGJ3YTFHN0xv?=
 =?utf-8?B?eStLS2pxZC82SjU2SDdOSU1CN2Y4NSs4MUtXSHE5RmtzMnlJZG1qd2lWRzVv?=
 =?utf-8?B?THUrcXdoUlpFSHFxbnFxN1l2ZXhkcXZVNkF5K0JWd2dUb1VPQSs3U1pNd2NS?=
 =?utf-8?B?MG01dG9wclBHZHlFVmhZMjdnR1haQ2NIZGZRWkJXRGxnNS9veXQ1cTFkSmZh?=
 =?utf-8?B?bzVvNEt2WmhaWHhzWHY1bFFvVm5GV1NnK1U0a1l1NjFpcE12WTJVSU9MZlB0?=
 =?utf-8?B?WTk0NHB6c0NEMEFXNUdMSURXbnl0YVBmVDVvN0FnWVdlamV4Um8yN0szck1r?=
 =?utf-8?B?enRuSVd2a2NxQ1FOcFBxVE5HYmVOWithdi9CQTNzOG5KNlBBZklHVkNBV3pB?=
 =?utf-8?B?ZTdjL29qNG9XTW9FTVVZemRiSWFhK0NtSmtwSmcxZkNFRmhGYzRiRTh0RFRT?=
 =?utf-8?B?NVd2TFZqWTVnN09LejZtKzhtNmZEMVJLTEtvN1V0bUdBdDNROW1kZldsd1g0?=
 =?utf-8?B?ZDExaHh6aFNiNWh6SmVlSGl6TXlidGtQd2lZN3RZTS8rWTZ5MHY1N3dOOTZm?=
 =?utf-8?B?RUZZUFNrc1k2NEV4UDJGZGdhRHdtT2piWkdHa09FajJ1Mk9UYWRFWFZSbktT?=
 =?utf-8?B?dERCdGNUcWNHRllpeEdKbVdBRG1NVHpTOGY4amU5ME41Q0UrWnVGL3p4NFEz?=
 =?utf-8?B?UkV0d1VOOWFma01SQ2dGM203WEV1UnV1RmF6NEd4VzQwUWRiaTNyelYycG16?=
 =?utf-8?B?eHNySkxYREUyVTlHeGVDYXJaaC9rQWJrODY4Z0lWYS9abUJPSkNONmV2cnln?=
 =?utf-8?B?MkFoWW1MYkgxOFkrYjA3OGRVcjk1Z0NGYnBUNjFWaTlkWkhpdWcybE1jZGdv?=
 =?utf-8?B?OWdhQTFHSWtkQjJjM2NXcUdQWXdiMU1kNHFCcnJ6NTQzK3R0MUkwdTdyR1pJ?=
 =?utf-8?B?Nit6M2lZaVBrVXFYOHVyL0d1cXk4ZTNUSDh4dFlBa093cGxDVTI3TVBhN0U5?=
 =?utf-8?B?L1ZCWURwaHVDbXppMENHQVVhZlRhTW5SSVFlZE1jOHhSdjVMNlBOa21qTHpF?=
 =?utf-8?B?RGR4bHF5MzIwLy9OZ3cyYjVEbVFLK3VhMmJYM0dEeVpqVnBWbGpqbWVMRFBT?=
 =?utf-8?B?QlR1WittamNCZFZKdEVmaTZxcCs0ZGh5VmVJTEFmZEdzbkp6bWhucUNiSmlP?=
 =?utf-8?B?aE1uLzhWYVRKbVBCUTFlUlpOV0R4WTFpN0lQV1F6bzFndWNqWEsvRXJoQ1BX?=
 =?utf-8?B?UlVZNGxqcXZ3bDlzUzBRR1FyZTc2YmRqTjc2MFRkVmFudTBFR09sUmIyRFNL?=
 =?utf-8?B?NDFtSkRzdEp4OWdpRnNqeVdDOS9scE5wZys2TG8vMmF1dEFuTFFXSWRrSDFq?=
 =?utf-8?Q?6GwL7w/OksXxRCMRPzs+kAeiM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed85c242-2130-43bf-d2d7-08db25639a7d
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 14:43:12.9483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsCGiRsH9a++nFXFDuUxJDhFACnOomXkPk6NHfvTwP4K7Bn+VCMTtHHF2gI+Ki5v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6968
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,
Any plans to merge these patches to v8.0 release.
Thanks
Babu

On 3/1/23 14:01, Moger, Babu wrote:
> Gentle ping again. Hope this patch doesn't get lost.
> Thanks
> Babu
> 
> On 1/31/23 14:21, Moger, Babu wrote:
>>
>>> -----Original Message-----
>>> From: Michael S. Tsirkin <mst@redhat.com>
>>> Sent: Friday, January 27, 2023 6:53 AM
>>> To: Moger, Babu <Babu.Moger@amd.com>
>>> Cc: pbonzini@redhat.com; mtosatti@redhat.com; kvm@vger.kernel.org;
>>> marcel.apfelbaum@gmail.com; imammedo@redhat.com;
>>> richard.henderson@linaro.org; yang.zhong@intel.com; jing2.liu@intel.com;
>>> vkuznets@redhat.com; Roth, Michael <Michael.Roth@amd.com>; Huang2, Wei
>>> <Wei.Huang2@amd.com>
>>> Subject: Re: [PATCH v2 0/5] target/i386: Update AMD EPYC CPU Models
>>>
>>> On Fri, Jan 06, 2023 at 12:56:55PM -0600, Babu Moger wrote:
>>>> This series adds following changes.
>>>> a. Allow versioned CPUs to specify new cache_info pointers.
>>>> b. Add EPYC-v4, EPYC-Rome-v3 and EPYC-Milan-v2 fixing the
>>>>     cache_info.complex_indexing.
>>>> c. Introduce EPYC-Milan-v2 by adding few missing feature bits.
>>>
>>> Acked-by: Michael S. Tsirkin <mst@redhat.com>
>>
>> Michael, Thank you
>>
>>>
>>> who's merging this btw?
>>> target/i386/cpu.c doesn't have an official maintainer in MAINTAINERS ...
>>
>> I thought Paolo might pick this up.
>>
>> Thanks
>> Babu
>>
>>>
>>>> ---
>>>> v2:
>>>>    Refreshed the patches on top of latest master.
>>>>    Changed the feature NULL_SELECT_CLEARS_BASE to NULL_SEL_CLR_BASE
>>> to
>>>>    match the kernel name.
>>>>    https://lore.kernel.org/kvm/20221205233235.622491-3-
>>> kim.phillips@amd.com/
>>>>
>>>> v1:
>>> https://lore.kernel.org/kvm/167001034454.62456.7111414518087569436.stgit
>>> @bmoger-ubuntu/
>>>>
>>>>
>>>> Babu Moger (3):
>>>>    target/i386: Add a couple of feature bits in 8000_0008_EBX
>>>>    target/i386: Add feature bits for CPUID_Fn80000021_EAX
>>>>    target/i386: Add missing feature bits in EPYC-Milan model
>>>>
>>>> Michael Roth (2):
>>>>    target/i386: allow versioned CPUs to specify new cache_info
>>>>    target/i386: Add new EPYC CPU versions with updated cache_info
>>>>
>>>>   target/i386/cpu.c | 252
>>> +++++++++++++++++++++++++++++++++++++++++++++-
>>>>   target/i386/cpu.h |  12 +++
>>>>   2 files changed, 259 insertions(+), 5 deletions(-)
>>>>
>>>> --
>>>> 2.34.1
>>
> 

-- 
Thanks
Babu Moger
