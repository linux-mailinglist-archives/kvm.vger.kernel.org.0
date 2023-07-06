Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE972749241
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 02:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjGFAHW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 20:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjGFAHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 20:07:21 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35821993;
        Wed,  5 Jul 2023 17:07:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCjOg/+q8Gh8IiE2MV+NRLes92/1MH5aPAB0ktSAWMKiqgaZPrcKfzHN148fsQU38Wif3ppKq9nFTl8VCG5VFcQ0Pr2zc0kd0W7zs7jFeUS0q+yPyD0Q6yXxETgWgUi+kHXhEitG04/c4s792Sx94eImAMYxS7aneoSbDy2EybpccYOYjXqHPIA93Xt8KJYbf64zKX40WNLORS/lPFgMV6W/IZJnZV8xir5fUnykyQHUHZS8CHglGztBbFsgqolrIthSWsIYbsqIXGx2Lgfl7tXKwFdOOG+1Tn0PzYsTvs0Q7QoQDYozEC8FJqtIMUCCDZM5FwdftvyGvbZOOBm38A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RpP5a6cw4EeTRIq2b6GOheaVyQW5GRCg7EDcMu2xlFs=;
 b=Jio4vMh1BCi+8UpBDL631C8PpqarFirubVfD/yffEQ7WtFh2m6RN6RX9JNftBofd2OxHelJm+umLHzWWKtxaDwSQR0LV1rAvUbWtUcf1MpI7yQYanMbYL0NXCCtIqkXuvm65mPjCXwIkYejGji7GnSG1d4Fg2vE3BQCJkULYHnCBSG+xI34RWY9DIZVim4xKoOrPZMI4qATNeQant9Cdqg5AtZ/YO5M5QWzAmu42v2h4aEPUGKjQBgb4X8Z2Y3yYrbGQhOEz5ST71wqU0wjPUbkd9dHWnzgElokYYvL3oUD+KCMZpBsvLjzskSU4LmiEtYR7TktRXSrtPzrtRLtd1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpP5a6cw4EeTRIq2b6GOheaVyQW5GRCg7EDcMu2xlFs=;
 b=UAIAAneKuyQ/LqikPfIC+YPcYQO1OH3kb0ePZWILEcf1eV7tU6pQjfPIrFF0KMDBNYNrDD2/jiN2l/F7a4QFAwTuQahZRiDIm/l1lzKMFTsnLFLStg0oFx6G4At/4qFqwbbBTGrLTliGJVpmrHrdIIecg+cZdCpnte+6/yF0hsk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 IA1PR12MB7589.namprd12.prod.outlook.com (2603:10b6:208:42b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Thu, 6 Jul
 2023 00:07:15 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::818a:c10c:ce4b:b3d6]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::818a:c10c:ce4b:b3d6%4]) with mapi id 15.20.6565.016; Thu, 6 Jul 2023
 00:07:15 +0000
Message-ID: <eff34828-545b-956b-f400-89b585706fe4@amd.com>
Date:   Wed, 5 Jul 2023 17:07:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: [PATCH] vdpa: reject F_ENABLE_AFTER_DRIVER_OK if backend does not
 support it
Content-Language: en-US
To:     Eugenio Perez Martin <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
References: <20230703142218.362549-1-eperezma@redhat.com>
 <20230703105022-mutt-send-email-mst@kernel.org>
 <CAJaqyWf2F_yBLBjj1RiPeJ92_zfq8BSMz8Pak2Vg6QinN8jS1Q@mail.gmail.com>
 <20230704063646-mutt-send-email-mst@kernel.org>
 <CAJaqyWfdPpkD5pY4tfzQdOscLBcrDBhBqzWjMbY_ZKsoyiqGdA@mail.gmail.com>
 <20230704114159-mutt-send-email-mst@kernel.org>
 <CACGkMEtWjOMtsbgQ2sx=e1BkuRSyDmVfXDccCm-QSiSbacQyCA@mail.gmail.com>
 <CAJaqyWd0QC6x9WHBT0x9beZyC8ZrF2y=d9HvmT0+05RtGc8_og@mail.gmail.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <CAJaqyWd0QC6x9WHBT0x9beZyC8ZrF2y=d9HvmT0+05RtGc8_og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::26) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|IA1PR12MB7589:EE_
X-MS-Office365-Filtering-Correlation-Id: acc1374c-d8c2-400e-8d97-08db7db4f447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aFucxTUXfxArMCgQrwF26LxSbb3GI0A7/O7nfJ3wYYsmsOUER491HsEHeAinZjv+J4+JvsPXdsVkOSynH4MwG75Gl6bRrGxuGc+aJ7qYjRPoSdSYz78Sv6KKcOWJzq7COHbJxfSvrVTYgVheL7vtVFxvwZgyjcr+SAetP4geZnvGFpE/ljqa3rqsIxaFu5dg2JOp8vneyQnktpMeMON6spgd8dQ5RaW8nRrupqssbL9aFauL6DcjIdoAnA7ah/dx/QeEqY4Y6GFntLRWzc6uhlo6HbHMc++1H4nNhYR68RrcuObcWXt7xMha3HFKiKCYyOKgC29jFHvyaywXdnYIae3DF5CcskCESKN0OnEz+6NqFD65Z36lFisYwDwpp1wGjWPELJR6EPzbmXnTQ58frhXY6WbralnN4ipLenWoZ8PRjgmp9xmCJWoeVo42dlJW0SFyGMLTJyxN8lHqC2Pvb9b6RXoPjLnbcNEQ5N1TAlHMbNfR08IHsUTTaIoTvvW71gUYMdsSW5l8o2/OmjqMMUsUa0k1t6zYj2yBOuLhr4AdZwwEJ12eu10fI9ah3Sdw8pz2oI2G5DvUTu2hsflSGsEmnto6Z9mYDs1AEGxF5ovcI1IoB6921UI7PEY8l6oZJarc+lyzig1WcpNIc06hXDdhSmg0H/v7mm1q1nG4RJD9GOBySgEf/hc9/QY11mUB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199021)(2906002)(8676002)(66899021)(41300700001)(5660300002)(44832011)(8936002)(36756003)(6666004)(86362001)(31696002)(31686004)(478600001)(2616005)(26005)(6506007)(53546011)(966005)(6512007)(186003)(110136005)(84970400001)(66946007)(316002)(4326008)(66476007)(38100700002)(66556008)(6486002)(83380400001)(66574015)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MHpSSGdSdDJIb0tsVTVtQXJ2TGx6Q0VkT0p5NkprbUR6eHI4UmQxRXlZOFpF?=
 =?utf-8?B?ZVdibnlYaEZUaGlMV1llNVhtSDZrRkUwTHRVRG5yUnBFM2RVTS9qVzF3N2tu?=
 =?utf-8?B?WldvdjR5Zk5qY3FBNTVaN000WjFoYmNYdWlNS1cxZWZrY05YRHJwMjlkYStz?=
 =?utf-8?B?aDJvZkVvUEV4cjFXNlhOaW41dUdPWGs3L2NtU2w4VzQ0M3JYVDA1SDdscEtw?=
 =?utf-8?B?SHVWVzJyR3ZVanZZWUlUU2dhTkRJSlVNQTAxR1VsQld5bTdoMTNhSE53WkNa?=
 =?utf-8?B?blkzaUtMV3RIK3JyaVZjSGVtQXdWNm9VNTM1R0pWM0pDNXZFQ0tTRjYzendp?=
 =?utf-8?B?SjE4d0RPOWl5RFFqcHc5cTZVdXd1c0JPVy8ydWR2bUowTytVYThxaDE4dE8y?=
 =?utf-8?B?MS9nM0pnMFFxc29ZdGtET1Z1dFBYYVNTQ1NDNWt0ME1aMGZqdVBxbE1LQ3o2?=
 =?utf-8?B?QWlTTXBaR0NpekVsUmMydHhFcnFmdDRETUgwYVIzdTA1QzVQQ3dKdUtjYUxR?=
 =?utf-8?B?bjlTUGxoRExSWCtXVkNicDlhc0ZkRHVtN2tBSzBnQUhjMXMvVTdSWDdpZEtk?=
 =?utf-8?B?MW1IOVJoeXMxN1dBeUxaZ3plcDhtSmN6bXB4VlNLakN4NS9IUHUrN25VZjk0?=
 =?utf-8?B?K0VxLzJneVNmUlg3Qjh2NmxwcVpKV2JSLzRIbWZrQ3gwem9vMnN2SHk1ODBx?=
 =?utf-8?B?amRmdkp4cGtORWt4YkFhOW9DRWpCblBGVWloT3lzemlJWFhuRWNSN1R0bklh?=
 =?utf-8?B?SXJabURUODN0MmhXZG1zTnlvaTZaTWI5VGZZR2M2cThoVDhPenlJQ2podmJI?=
 =?utf-8?B?SVFHR0Q5UmRkSUI4NlJsYmdIUEVjRmJGOU9mTytOUmw5VlhRU2R6TkJXSjVQ?=
 =?utf-8?B?di9pK0ZPTy9hVnN2SksrV29vanRNM21YZ1hxaXJZeEUzSG03S05JbXBQcEJo?=
 =?utf-8?B?MXNSd0JkWTM1MFhaOFZheStFcEpJd3dET0MzQWdYSWtRamN6bWp6VU04bWJR?=
 =?utf-8?B?djJ4Y1gxSlhpZXB0Y1RwdjMvYW10U3U2elhldEFiZHFBQTlSOUlVMlQvMmU3?=
 =?utf-8?B?RHpXNXpraElGb2ZqanVPWWpjSXB4S3N1S1h2SXFwV2JmdDI2ZFNDRzRIa3hr?=
 =?utf-8?B?VjZVKzVyc2JLd29sRi9ZdmZXYk5hWmRpVStYbFliYlFnZ3ZaUVY0SlBWYnpP?=
 =?utf-8?B?OEFLRkMzeDYwM3BTRlhVYlkvdFlyZ3c2amJFNlYxcGgyeHJFQ0tpZmNkdytr?=
 =?utf-8?B?NGZZRldwZC9VK1Ftemh6cWdYWmcwbTNzbklUSUcyVG1YVlFqQzloYmVSb2tM?=
 =?utf-8?B?eDJvSC9OL1ZSWUNDM3B3b29CMkswQkZJUGJLM3JTcEdhTHVsc2NHamp1aEFV?=
 =?utf-8?B?M1l6QjVNOXAzYVhUZld2d3BpUEhkUFQ5WUFYTWFWUVljTzk1S0FYQm5JSEhp?=
 =?utf-8?B?REFabzdoTGNCODVVclJDT2pFRHRoNkxvTHBjanFLWEVFQm16aDZSUk8yYmtP?=
 =?utf-8?B?NG1DMXE3TEFlU00vQjNHSXIrd2E1NHo3dlBNbytFYkhUWVRiYjdHd3JwOTdo?=
 =?utf-8?B?bXlkVlNBWmpCbUZzT1Q1cTl4MWdGUDJGRFd1b0w3S3RrcU9pVG1IRXBaaWN0?=
 =?utf-8?B?bjZnRGRmOEFQSXRGME53WU8zM000V1hnSUE2dnBHbm4vWkRJV3RzSTF0Qjlp?=
 =?utf-8?B?TVJwWitpejJVbVpuVjhYNk5XYWtPNHdTTERUbXpEZDdMMldod2ZEZnlGWUFY?=
 =?utf-8?B?Mmwzc1VzakJkRFljOXhkeCtIa2xzamZPRlNvWktZQmE1SWE5MS9rcy9YN3Vw?=
 =?utf-8?B?UzU5ZkFBa2xnVE9vMWdSRjRKUmZPYXVSU20vUUNMS1B6ZXp6WXZyYlM1QWhM?=
 =?utf-8?B?czR2TE9VS2wwMWd4V2Irc2IvMFVMSndkaWlDNzd1SzBtM2dWVGZ6WWg0UUtT?=
 =?utf-8?B?c0I5bWJMbElEMldvNGFlbzdmeTJrK0lJMElyNlRmWFBWVnhSMHJUcXNYdHlv?=
 =?utf-8?B?UGJkd3RzT05ZRFFVK3NtZEluNXNuVEhuOUFmL3lrV3BwajRrZzFoR3A0MVhk?=
 =?utf-8?B?OC9LSzJGVVhXcXBMQWZNRlh5MEJxa2NwV0Y1ZFZXU2FYalZiM1RtSFBnKzJz?=
 =?utf-8?Q?TGVjBslVLsd0vaKCpGVqUWwuH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc1374c-d8c2-400e-8d97-08db7db4f447
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2023 00:07:15.0687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nXuvAtj2zfKb/Xf8o2cGF9QYI8KZBdp344Z9TfnPMybTPtstVVdQog2PLGqx3InwIl6cqAwpOKysyZyySGooOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7589
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/23 11:27 AM, Eugenio Perez Martin wrote:
 >
> On Wed, Jul 5, 2023 at 9:50 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On Tue, Jul 4, 2023 at 11:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>
>>> On Tue, Jul 04, 2023 at 01:36:11PM +0200, Eugenio Perez Martin wrote:
>>>> On Tue, Jul 4, 2023 at 12:38 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>
>>>>> On Tue, Jul 04, 2023 at 12:25:32PM +0200, Eugenio Perez Martin wrote:
>>>>>> On Mon, Jul 3, 2023 at 4:52 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>>>>>>>
>>>>>>> On Mon, Jul 03, 2023 at 04:22:18PM +0200, Eugenio Pérez wrote:
>>>>>>>> With the current code it is accepted as long as userland send it.
>>>>>>>>
>>>>>>>> Although userland should not set a feature flag that has not been
>>>>>>>> offered to it with VHOST_GET_BACKEND_FEATURES, the current code will not
>>>>>>>> complain for it.
>>>>>>>>
>>>>>>>> Since there is no specific reason for any parent to reject that backend
>>>>>>>> feature bit when it has been proposed, let's control it at vdpa frontend
>>>>>>>> level. Future patches may move this control to the parent driver.
>>>>>>>>
>>>>>>>> Fixes: 967800d2d52e ("vdpa: accept VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK backend feature")
>>>>>>>> Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
>>>>>>>
>>>>>>> Please do send v3. And again, I don't want to send "after driver ok" hack
>>>>>>> upstream at all, I merged it in next just to give it some testing.
>>>>>>> We want RING_ACCESS_AFTER_KICK or some such.
>>>>>>>
>>>>>>
>>>>>> Current devices do not support that semantic.
>>>>>
>>>>> Which devices specifically access the ring after DRIVER_OK but before
>>>>> a kick?

The PDS vdpa device can deal with a call to .set_vq_ready after 
DRIVER_OK is set.  And I'm told that our VQ activity should start 
without a kick.

Our vdpa device FW doesn't currently have support for 
VIRTIO_F_RING_RESET, but I believe it could be added without too much 
trouble.

sln


>>>>>
>>>>
>>>> Previous versions of the QEMU LM series did a spurious kick to start
>>>> traffic at the LM destination [1]. When it was proposed, that spurious
>>>> kick was removed from the series because to check for descriptors
>>>> after driver_ok, even without a kick, was considered work of the
>>>> parent driver.
>>>>
>>>> I'm ok to go back to this spurious kick, but I'm not sure if the hw
>>>> will read the ring before the kick actually. I can ask.
>>>>
>>>> Thanks!
>>>>
>>>> [1] https://lists.nongnu.org/archive/html/qemu-devel/2023-01/msg02775.html
>>>
>>> Let's find out. We need to check for ENABLE_AFTER_DRIVER_OK too, no?
>>
>> My understanding is [1] assuming ACCESS_AFTER_KICK. This seems
>> sub-optimal than assuming ENABLE_AFTER_DRIVER_OK.
>>
>> But this reminds me one thing, as the thread is going too long, I
>> wonder if we simply assume ENABLE_AFTER_DRIVER_OK if RING_RESET is
>> supported?
>>
> 
> The problem with that is that the device needs to support all
> RING_RESET, like to be able to change vq address etc after DRIVER_OK.
> Not all HW support it.
> 
> We just need the subset of having the dataplane freezed until all CVQ
> commands have been consumed. I'm sure current vDPA code already
> supports it in some devices, like MLX and PSD.
> 
> Thanks!
> 
>> Thanks
>>
>>>
>>>
>>>
>>>>>> My plan was to convert
>>>>>> it in vp_vdpa if needed, and reuse the current vdpa ops. Sorry if I
>>>>>> was not explicit enough.
>>>>>>
>>>>>> The only solution I can see to that is to trap & emulate in the vdpa
>>>>>> (parent?) driver, as talked in virtio-comment. But that complicates
>>>>>> the architecture:
>>>>>> * Offer VHOST_BACKEND_F_RING_ACCESS_AFTER_KICK
>>>>>> * Store vq enable state separately, at
>>>>>> vdpa->config->set_vq_ready(true), but not transmit that enable to hw
>>>>>> * Store the doorbell state separately, but do not configure it to the
>>>>>> device directly.
>>>>>>
>>>>>> But how to recover if the device cannot configure them at kick time,
>>>>>> for example?
>>>>>>
>>>>>> Maybe we can just fail if the parent driver does not support enabling
>>>>>> the vq after DRIVER_OK? That way no new feature flag is needed.
>>>>>>
>>>>>> Thanks!
>>>>>>
>>>>>>>
>>>>>>>> ---
>>>>>>>> Sent with Fixes: tag pointing to git.kernel.org/pub/scm/linux/kernel/git/mst
>>>>>>>> commit. Please let me know if I should send a v3 of [1] instead.
>>>>>>>>
>>>>>>>> [1] https://lore.kernel.org/lkml/20230609121244-mutt-send-email-mst@kernel.org/T/
>>>>>>>> ---
>>>>>>>>   drivers/vhost/vdpa.c | 7 +++++--
>>>>>>>>   1 file changed, 5 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>>>>>>>> index e1abf29fed5b..a7e554352351 100644
>>>>>>>> --- a/drivers/vhost/vdpa.c
>>>>>>>> +++ b/drivers/vhost/vdpa.c
>>>>>>>> @@ -681,18 +681,21 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
>>>>>>>>   {
>>>>>>>>        struct vhost_vdpa *v = filep->private_data;
>>>>>>>>        struct vhost_dev *d = &v->vdev;
>>>>>>>> +     const struct vdpa_config_ops *ops = v->vdpa->config;
>>>>>>>>        void __user *argp = (void __user *)arg;
>>>>>>>>        u64 __user *featurep = argp;
>>>>>>>> -     u64 features;
>>>>>>>> +     u64 features, parent_features = 0;
>>>>>>>>        long r = 0;
>>>>>>>>
>>>>>>>>        if (cmd == VHOST_SET_BACKEND_FEATURES) {
>>>>>>>>                if (copy_from_user(&features, featurep, sizeof(features)))
>>>>>>>>                        return -EFAULT;
>>>>>>>> +             if (ops->get_backend_features)
>>>>>>>> +                     parent_features = ops->get_backend_features(v->vdpa);
>>>>>>>>                if (features & ~(VHOST_VDPA_BACKEND_FEATURES |
>>>>>>>>                                 BIT_ULL(VHOST_BACKEND_F_SUSPEND) |
>>>>>>>>                                 BIT_ULL(VHOST_BACKEND_F_RESUME) |
>>>>>>>> -                              BIT_ULL(VHOST_BACKEND_F_ENABLE_AFTER_DRIVER_OK)))
>>>>>>>> +                              parent_features))
>>>>>>>>                        return -EOPNOTSUPP;
>>>>>>>>                if ((features & BIT_ULL(VHOST_BACKEND_F_SUSPEND)) &&
>>>>>>>>                     !vhost_vdpa_can_suspend(v))
>>>>>>>> --
>>>>>>>> 2.39.3
>>>>>>>
>>>>>
>>>
>>
> 
