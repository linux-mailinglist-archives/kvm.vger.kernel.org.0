Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231ED588764
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 08:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiHCGcZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 02:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbiHCGcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 02:32:23 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2087.outbound.protection.outlook.com [40.107.212.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB212251E;
        Tue,  2 Aug 2022 23:32:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lE4l/scsHnaxvNJ8B88lve/JW7J3ShFt285e1FQkCkKrQA/LmEBhlu/ognBU2ON6GtPELLTE64/HwDoEMMjgz7Baapr1ueGx1wviB6KFVT9245HcPZx4NSc28pj5EP3zozqdt1fu4nQ1cQ670zgBPa3wpE1d53UWen/NYkI3v9D6S6rL27snZEqEayFgaIuPzkh6smwCVDWv0TGdbWGf9U2rACs5g8mL/ClJ9W86XHEUI4RvkayEBe/8yDr1jYyKj+zspM2rXGXc5sH+K4znSOV6V+3UvMvU4j+2AwCDk+Lq+hrDkeDbGTsR81kmBh20FB+Ia6ZOCmdYcW8OKHEGYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rXYparhPkAs4FwS9pd/qTpSCaRDoDnbxiitdQJae8P8=;
 b=nY0GaWXjR5/ciWNQZEr172s/xjEFWLrivbyunaEkza8JyehSjLFrm1rDcbFvZXEfOOxJXW9a3bQDQrJ/oVxzwmsBXdmlczvJqzE34y08gZWldHTyp9AWBRI7sEcew/0KOfJt/uL8v/oUM/O/MG3/u0qPFprQAJtucSxY3dGLA3qB4PGYebfBMM2/Hyl3CHByvxu85j7Xheb/gDFCWRISalSbsW/QAlinsWuN+klHXUTRFC9A68ws0Zg+NB/0brkY+7EYFdFKzjXfd93CIsWfeQCs0Jz2S9GB1hr7u+SqitDNpGlUFZakse+d7DaXAcCLXgKDGopEgw053NsZVT96WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rXYparhPkAs4FwS9pd/qTpSCaRDoDnbxiitdQJae8P8=;
 b=kilZ53oJ48f34LyafqjmGD+fW2ApxydUVe6WBwNAiGJuKmoxCRtwFSuB1eyx1yzKnRTGxftq63GcnXv++g7+2iofaEEQXV0n3bOQaYKu6lfQ4vyBBbR6PDpqzSc6WUms64n+0he+f7osp0JyR+Wf4upn0toTFJxK6gFuPCiK3iMxqnxJxN+wztC0YMDNEB5zgD9ItgZJImbgmSdzOTQ5ozLQWTWjXX/1VOtVm+tHOHF9xkpZCfBzxl7Sgy6fnlkP/n8GsMb0LB3p3O8ZNppZjGm8MMgEJHFRwbaPP0+ZrnjXvtpU3kMBHuJvauWrKsbU6YVzofxyqoifWakqnFysYA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13)
 by IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.15; Wed, 3 Aug
 2022 06:32:20 +0000
Received: from BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed]) by BL1PR12MB5304.namprd12.prod.outlook.com
 ([fe80::784c:3561:5f6a:10ed%8]) with mapi id 15.20.5504.014; Wed, 3 Aug 2022
 06:32:19 +0000
Message-ID: <d90a6a11-f6c4-9e29-61a1-c96f1ceb100b@nvidia.com>
Date:   Wed, 3 Aug 2022 12:02:06 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
References: <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
 <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
 <20220726172356.GH4438@nvidia.com>
 <f903e2b9-f85b-a4c8-4706-f463919723a3@nvidia.com>
 <20220801124253.11c24d91.alex.williamson@redhat.com>
 <YukvBBClrbCbIitm@nvidia.com>
 <20220802094128.38fba103.alex.williamson@redhat.com>
 <YulSOK+YKjV2634b@nvidia.com>
 <20220802105755.2ee80696.alex.williamson@redhat.com>
 <YulYVOWh8km2knhx@nvidia.com>
From:   Abhishek Sahu <abhsahu@nvidia.com>
X-Nvconfidentiality: public
In-Reply-To: <YulYVOWh8km2knhx@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0075.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ad::16) To BL1PR12MB5304.namprd12.prod.outlook.com
 (2603:10b6:208:314::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3d26cd3-2e5d-4090-384e-08da7519e9ad
X-MS-TrafficTypeDiagnostic: IA1PR12MB6434:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: woeTsJftR1wX5tbbLiunu0nVkADbAv3nOckCg4tnRvct/0a5nP3gXIEwQsErIoK9utgWDHP7yL3M4WQPiLfQDoqcw2YG/Nvnrf0qTGvITvfVhcXcCmVKWJMci4SkU1/X2nfdTO79SekfRqCifzp0PDciWOoh0cP1xkgoPTovhPmUVlNwnvANTtBWbnE+10YYRJp1wueZP1bcxnPOcZbj2CmgOC0yAoeP/4lPMNeLABR7ZUy972wJ9gkRD2BVHWNW4wmTE0z/6nYKUkgsR0xBuVhEFr7KSvZvJczb3nfTOG0JoU29qwXqF9XFDty4W88zskbb16dtLn3Hx+mzqdHYB9ih2ByereQzw1E2wjf80Ymwp1mcK+OuX0JsQuhkRSeVD1BoFPwXmIMViezOS/MLIqxRF3qw/Pm0gya6HgWYnUxwyqW94qzxYFkOjYth5RBhxt1OQxXOMKh7Xz2syJmzqpc8xyZHmfdYI3z+5w85YKWvAn5F8r4Wo+uq/Q+NGtMI4H6ntpq+wBvuupv6FJ/5XiUfxWMKb9CRU9+SkMAlRRpiEQm2kLaIoeo1ieJwB3Exb4B7YrQCgcOwS8NozRmbYYlJNB0moJy4LVnKPzgr8jUVo+JbA1u8HdKr5ZV0qZpPj0h7thTLVuAzzotZ4QH+WMK3hfOvGQRICe+VG3ZDnLtU4/8QR5TxjZ2QTamXeNGo3p5duGg5QbupgxdUV39wEvlvy6k9e9oib5Ha21hG+B3LJAvsdP8T5Sn4d9lowPOF7zipTyLM8Gh+Wiyc7mkvUcUyL3YZADd5WMVzBHMk9pQY6oPR2icNJdlCsRlfxRGgrkU3mlpEfJyMT1SnDmCdOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5304.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(66946007)(66476007)(66556008)(8936002)(4326008)(8676002)(478600001)(38100700002)(186003)(6486002)(5660300002)(7416002)(316002)(31696002)(6666004)(110136005)(86362001)(53546011)(6506007)(54906003)(31686004)(41300700001)(55236004)(2616005)(2906002)(83380400001)(36756003)(26005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R0xFaUtvVkJ2OXZ5Z1ZvUzlPQVgzeU91d2YyUG1WTU4rOVEvVk5NUFZiWWww?=
 =?utf-8?B?dzZHbTAyT0ZEa3psQVQvWXY4MWNHOE91cFJsdE54UFZNLzhGNW11a3I0N21P?=
 =?utf-8?B?RWRlU1g1emRPaUtJeWNPT0hPOUJYRVEzcS9vSWlrU3VRZm5JNEYyUmxMY1ZP?=
 =?utf-8?B?YUxYMWRsN1lRM1JTZ1FDUWdaL2NQNk10N0xMR3daZnNNYlB3UUY4dGNUMzZ4?=
 =?utf-8?B?cUtBdmVUbGNlc3Z1ZCs5UGZNSm5NWmFPcUhiZ1NoMzh0cExNd21vSEVocndZ?=
 =?utf-8?B?c3R1ZkNZRCtaYURTQ29jWmw2L3VXcWFOZ1JMdUhWNTYvSzViQ3ZLbTRaSVA2?=
 =?utf-8?B?a1owQUJWVDE4eVcwQXQyRE1INWdiMTZDbHRyTGt4QndyTmJxaU5RQTN3eXZn?=
 =?utf-8?B?Z3B0a0RjcDMwa24zaEgxS0FTYXRHMDZYNmpwUFhtZmhIWjJBdks4OUNoU0x3?=
 =?utf-8?B?dGRGclhzblZpUjA0SjJsRHpQUjJsMVd3Z0JhV0g3dVduaE9rK3FUd3RWdlFn?=
 =?utf-8?B?VjloOUVJUTUxd2dSUGJKUlFNVStqUjYvUG4yRlBmdW8rcVdiUWJXbEdPL0xa?=
 =?utf-8?B?SlhwU3NCbnNiYVZFS1FJMlV0d1NnUEYrTEV5RElrdHByNVJxVHBmNVU5OXZU?=
 =?utf-8?B?OU85VDFTV2Vmc29oUjN6cENCZ2dTdXdVRElUYWJIVVRMeWloQm5qcnI1RDA5?=
 =?utf-8?B?Vis2OHBXN3ZGSTVDSkFZL1IvT0dWeGdHUnV4N2NvQ1ZvK1VMd3ZkYWtLRDNs?=
 =?utf-8?B?VFQyRHE3L0ZGOFgxRFBJWVRaNk12Z1A4ZlR4dG4rbGxFK3Iva3lhdTYxa2No?=
 =?utf-8?B?U216ejF2NXUxM3I1dHZjeVVFdW5CUkZ0OFRqb1VOMkkrU1NjVHlLdXFBTWVT?=
 =?utf-8?B?N2F4THI1cjZpT0VNZnphQUczaU9ray95RWZneEFvUmZ4Z05YM3RCaUJreFNH?=
 =?utf-8?B?MFllQjlLdk9QbkJuODQ3bnNySFAwWXNvZVhPOEk4eHpXOXlOaVZaTjFXcWp2?=
 =?utf-8?B?MDcvc2x1cnpaM2gwU3p1dm1UQmtGTk1MY3VXNm1KVHhYMVZFaG9SU3hFOHRO?=
 =?utf-8?B?RkZINktqYytFNXNYSk9Gc3BCbW9jclhMTG5taDNBMHZ2WW5ZdzQ5eWlMb3RV?=
 =?utf-8?B?MzJCc1NhZCt5cHBEcDdRQngwQ3EvQmw0L2dqZkxORkw3ME9pV1REWGhQTysr?=
 =?utf-8?B?U1RNdW1jdm9OUStqQWN5dmxub2FST1RHRXFUcURpcmw4WlhVSEVCNUwzbzgz?=
 =?utf-8?B?aTNWVGkrUzZ3S3pMZzFuVFFJYTdYdy9VV1E4TmxoWTlJaVlNQWEwVllMQnpT?=
 =?utf-8?B?cUprVHJoR1pCM1ZUdjQ1Y25kVXYzekhpNk1Rbk9wVW42UlZpWWFqdll5dXpI?=
 =?utf-8?B?MFJIdmtyZUU3UkI0cUdaa3QwVUtIbi9HUnVOb1AzMFBWcGE1eWdlRVc2cENo?=
 =?utf-8?B?UlM0bUhHUmlsZlVSekkvNzZQdG5LUnFpcHRXTk15eXdrL0RSZTREdjlkVkh6?=
 =?utf-8?B?SjdzdlBabFYwRjJWQWF4V1Rab2pqNWI0bHVhdkNFeTJoNkJJeDZ4NlpWQXVI?=
 =?utf-8?B?UFA1QWtDUDZSWFFBaitIUmg3dXRyK2k3N3NySVREd3ZmWE5zTzUrbmovbkNU?=
 =?utf-8?B?NVk2OGVBQjA1RTVCTVZnYmhnNElBZUNLTGtQcjk1cVBseWt6ZllwdS90S3ZD?=
 =?utf-8?B?VzlqZEpkeDFSN3p4ODFTVm1qUVk4UnpuVlpwbzJtN2pSSnJJbUJmVHRwWWJk?=
 =?utf-8?B?cjJHaCtabjM4c3BaaUxqRTRFVHF1bEwwK0hHYWsraHpzVy9PZUM5NkVsTlN0?=
 =?utf-8?B?Y05pczRtSHJzNkZ1YVBHT0pmQ0RPVFRCU290dkp0c25tU005NUFCNGdOT0pz?=
 =?utf-8?B?b0MzQnREV3h3UVZJRnV6b2N3dzhuazdnYk00aEtqVkxWQWVIeGRzUlYvZWlh?=
 =?utf-8?B?Q0xCMXVsT1hSL3ZKa1V4MDcyU3JSMWYrcVRGTWlKc21EQ21MNHF6SU1kUHcz?=
 =?utf-8?B?RkRucVpmRXBlQ24zSm9Qb2ZsTy91NU9ZaUVjaDNxeC9sZWN2WnNHaDdkblVM?=
 =?utf-8?B?TG1oTDB4N1IxVFplVUFmOW1qQVNObll3aHRCTzBZckorUE5GK1lTWnBpRjFt?=
 =?utf-8?Q?1DjA4tRxVVcB5N6Gb1s/Z75Te?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d26cd3-2e5d-4090-384e-08da7519e9ad
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5304.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 06:32:19.7412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fTt+3+poOdIvBzQFIgiY3QkvPyaokYsHjtLA9yBSVxWgk0Q6w6Yjf9uyhAzpdnoRKZdSDNs51VhfOtZFUPAxug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/2022 10:31 PM, Jason Gunthorpe wrote:
> On Tue, Aug 02, 2022 at 10:57:55AM -0600, Alex Williamson wrote:
>> On Tue, 2 Aug 2022 13:35:04 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>>
>>> On Tue, Aug 02, 2022 at 09:41:28AM -0600, Alex Williamson wrote:
>>>
>>>> The subtlety is that there's a flag and a field and the flag can only
>>>> be set if the field is set, the flag can only be clear if the field is
>>>> clear, so we return -EINVAL for the other cases?  Why do we have both a
>>>> flag and a field?  This isn't like we're adding a feature later and the
>>>> flag needs to indicate that the field is present and valid.  It's just
>>>> not a very clean interface, imo.  Thanks,  
>>>
>>> That isn't how I read Abhishek's proposal.. The eventfd should always
>>> work and should always behave as described "The notification through
>>> the provided eventfd will be generated only when the device has
>>> entered and is resumed from a low power state"
>>>
>>> If userspace provides it without LOW_POWER_REENTERY_DISABLE then it
>>> still generates the events.
>>>
>>> The linkage to LOW_POWER_REENTERY_DISABLE is only that userspace
>>> probably needs to use both elements together to generate the
>>> auto-reentry behavior. Kernel should not enforce it.
>>>
>>> Two fields, orthogonal behaviors.
>>
>> What's the point of notifying userspace that the device was resumed if
>> it might already be suspended again by the time userspace responds to
>> the eventfd? 
> 
> I don't know - the eventfds is counting so it does let userspace
> monitor frequency of auto-sleeping.
> 
> In any case the point is to make simple kernel APIs, not cover every
> combination with a use case. Decoupling is simpler than coupling.
> 
> Jason


 Thanks Alex and Jason for your inputs.

 It seems, I can use the original uAPI where we will have 2 variants
 of ENTRY.

 Since already kernel merge window is started, so I will wait for
 v5.20-rc1 (or v6.0-rc1) and then I will rebase and test my patches on
 the updated kernel.

 Regards,
 Abhishek
