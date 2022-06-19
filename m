Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D27F55097E
	for <lists+kvm@lfdr.de>; Sun, 19 Jun 2022 11:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbiFSJ0D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jun 2022 05:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiFSJ0C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jun 2022 05:26:02 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF899DE87
        for <kvm@vger.kernel.org>; Sun, 19 Jun 2022 02:26:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOuo+EmteV6qJvviOtgcfKXuOy1e3S9ENliVkOmpgASbb0gY+xsq58ghmNHsGQyF2szW3XsL1Z5mGK0sOhYnWxoii4+NFIGOt9EDcOF0VEayUQGw92JW4u0iu8LfhgjIOHVPUiU3GaIe5zZJFKmkljaJu/+g/fI3tRGUXp+FLLlp8S9mbHQS2vFWiE5UcwNsYxg0KJJgVU7SufRzYYC0eQrTq7qML2B0uu8cXqgT2TYHwETIk2grjSnkFdyZVWlbdPI0N5of6ASjY5ttYETblt6KEK9K1MVfmZNGD3QrF5F/snzv5GnOs1i3W9P+XMPiB1U0dn8qTcq4SU7yyBem1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bbQDba3wnYtXMoz/Shvr1oLj8ERxa4O3A0kqw5JNqD4=;
 b=ACkE6BE9lf8aHKkGyJGRUvEEktIt9YFLQ42j3NDQD37QRhv7ScaWId4J9NN3nzbItrHVp/9g1T3GkIOQ9y3pmIT19FPlMLgU3Ok5FUpt41RWwvTUxEF5T2W0CkMSiG+2Fr7jC313NEqz9V6d8YzbmI7v46JTP8n6feFdOj3yNrw9V5kzVP0DhvmP0p1cqg1kGbCfMsMeXgMCek/7LDKbel6IoGLZEmTm789V1Eo17yWFG/iky6yegVplj0cUaEX1koyCivkVwaTm9iyiWSx+8maSRSAXGIU473Gmaa8QeJCUITo1K8gtvlHD8B1Tky8SOoSd5CSDy9GlwoSL/S8n/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=huawei.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbQDba3wnYtXMoz/Shvr1oLj8ERxa4O3A0kqw5JNqD4=;
 b=gzv12c4McShQAfQSJcx8YKnFrUxgCPjH4dkVudto0NXu0M00Uw3lyumomsdDmVBALCdYu063QlhAY9928kOfBCaVUOHjlC6rYriCeeR9f9wiXtsLMVTj9L/j5xUI2WrG2Cweu94AnrPEMTXGJGO40qCDanqlFONUCn17AZtVE+9IxOwIasp54kyN44a1qLTZRTpf2wTiduychhr69Dh8w1ksoI93Al3qMfdZwWZms9bTS9uJK+SuBRLF7SUTEbctLzrfFktFJ6YArNRaQIjIhgr0TE0MVu1Lv831MQEdijNLOdhNV+vIkNjhu1iMwzOSM3Usbekb1ja0XmR02nZZxw==
Received: from BN6PR17CA0005.namprd17.prod.outlook.com (2603:10b6:404:65::15)
 by DM6PR12MB3468.namprd12.prod.outlook.com (2603:10b6:5:38::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Sun, 19 Jun
 2022 09:25:57 +0000
Received: from BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::6b) by BN6PR17CA0005.outlook.office365.com
 (2603:10b6:404:65::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20 via Frontend
 Transport; Sun, 19 Jun 2022 09:25:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT044.mail.protection.outlook.com (10.13.177.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5353.14 via Frontend Transport; Sun, 19 Jun 2022 09:25:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 19 Jun
 2022 09:25:55 +0000
Received: from [172.27.14.105] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Sun, 19 Jun
 2022 02:25:52 -0700
Message-ID: <4f14e015-e4f7-7632-3cd7-0e644ed05c99@nvidia.com>
Date:   Sun, 19 Jun 2022 12:25:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
Content-Language: en-US
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        liulongfang <liulongfang@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>
References: <20220606085619.7757-1-yishaih@nvidia.com>
 <20220606085619.7757-3-yishaih@nvidia.com>
 <BN9PR11MB5276F5548A4448B506A8F66A8CA69@BN9PR11MB5276.namprd11.prod.outlook.com>
 <2c917ec1-6d4f-50a4-a391-8029c3a3228b@nvidia.com>
 <5d54c7dc-0c80-5125-9336-c672e0f29cd1@nvidia.com>
 <20220616170118.497620ba.alex.williamson@redhat.com>
 <6f6b36765fe9408f902d1d644b149df3@huawei.com>
 <20220617084723.00298d67.alex.williamson@redhat.com>
From:   Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20220617084723.00298d67.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc637f54-fa27-45d8-565f-08da51d5b738
X-MS-TrafficTypeDiagnostic: DM6PR12MB3468:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB34688993310C2F37627BA86CC3B19@DM6PR12MB3468.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2prvvVU3Go/xk2FF9achomfeU6ThCkJDCAqVw5G7+ExHOX7Gh1uQhnUacftkFdyOSM6Epn2RQpAMvm+sxonv0skiDdVR+5yfUeeKAoU1FrLjc1t7R+PLlMl2MbyuTIyPTQBthokSRdyOUmjhZkblUQlVCWkOCwnVB/5waGhuhFhoN3rTiRIgtRCJbQXdW+Nf99EXPHsLG4nJ5KFQvgy/g0c3ZOmKH9Gc1PdUTf56h7fVYTGK4ZYekd6REmm4OHCfxdC24BPiEZ4M0UWPieQQ3qrl7YqGsonckMlmhsRsD1b0OCkRsPwR9zD4H2R5BwkxSN4E088y1n6pa95eGGmWWp6OVFtemfWmJxt+gTBNa2OX6icA9/JUYz7edueLAKsBzq7pdzxDEyXsiZn59bRMTTLdskX2mmbPWdcVmCFYTlE2CmQDZ5r8XTppgHYkLb4I2v535rdzFZInh/A1MpRbJ1GorIsiD/KMEItQlLE2gaDGGpPGB8zZBI/Lea5yZp/SJYpNJ7tMv+UQbc/eJn/kAgtf3kV+XCpWP4kkuyDyT27vbvI5n+vC2IP26wItj1DQtacbpRm2m8GOL3Jo2isNCS9wKAa+8CdvJHvdxR3O3p6oRitAuHUR9oG73ROv6KqWNag2A11J5Ba8a8MPyDctrCLnR1vEfAk2L1t/M91wewWXkoCo2HnZf8ZShRR2cwUSYdE7eIp+6ZTWsTZ8kDm5TQvgqccamL1sJKAgPV03qF4uyxky/vBmzgQMNqUnv/64
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(36840700001)(40470700004)(46966006)(6916009)(4326008)(186003)(16526019)(70586007)(40460700003)(47076005)(336012)(316002)(36756003)(498600001)(8936002)(54906003)(82310400005)(16576012)(426003)(8676002)(70206006)(31686004)(2616005)(5660300002)(83380400001)(53546011)(26005)(36860700001)(31696002)(2906002)(356005)(81166007)(86362001)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2022 09:25:56.8434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc637f54-fa27-45d8-565f-08da51d5b738
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3468
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/2022 17:47, Alex Williamson wrote:
> On Fri, 17 Jun 2022 08:50:00 +0000
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
>
>>> -----Original Message-----
>>> From: Alex Williamson [mailto:alex.williamson@redhat.com]
>>> Sent: 17 June 2022 00:01
>>> To: Yishai Hadas <yishaih@nvidia.com>
>>> Cc: Tian, Kevin <kevin.tian@intel.com>; maorg@nvidia.com;
>>> cohuck@redhat.com; Shameerali Kolothum Thodi
>>> <shameerali.kolothum.thodi@huawei.com>; liulongfang
>>> <liulongfang@huawei.com>; kvm@vger.kernel.org; jgg@nvidia.com
>>> Subject: Re: [PATCH vfio 2/2] vfio: Split migration ops from main device ops
>>>
>>> On Thu, 16 Jun 2022 17:18:16 +0300
>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>    
>>>> On 13/06/2022 10:13, Yishai Hadas wrote:
>>>>> On 10/06/2022 6:32, Tian, Kevin wrote:
>>>>>>> From: Yishai Hadas <yishaih@nvidia.com>
>>>>>>> Sent: Monday, June 6, 2022 4:56 PM
>>>>>>>
>>>>>>> vfio core checks whether the driver sets some migration op (e.g.
>>>>>>> set_state/get_state) and accordingly calls its op.
>>>>>>>
>>>>>>> However, currently mlx5 driver sets the above ops without regards to
>>>>>>> its
>>>>>>> migration caps.
>>>>>>>
>>>>>>> This might lead to unexpected usage/Oops if user space may call to the
>>>>>>> above ops even if the driver doesn't support migration. As for example,
>>>>>>> the migration state_mutex is not initialized in that case.
>>>>>>>
>>>>>>> The cleanest way to manage that seems to split the migration ops from
>>>>>>> the main device ops, this will let the driver setting them separately
>>>>>>> from the main ops when it's applicable.
>>>>>>>
>>>>>>> As part of that, changed HISI driver to match this scheme.
>>>>>>>
>>>>>>> This scheme may enable down the road to come with some extra
>>> group of
>>>>>>> ops (e.g. DMA log) that can be set without regards to the other options
>>>>>>> based on driver caps.
>>>>>>>
>>>>>>> Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5
>>>>>>> devices")
>>>>>>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>>>>>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>, with one nit:
>>>>> Thanks Kevin, please see below.
>>>>>   
>>>>>>   
>>>>>>> @@ -1534,8 +1534,8 @@
>>> vfio_ioctl_device_feature_mig_device_state(struct
>>>>>>> vfio_device *device,
>>>>>>>        struct file *filp = NULL;
>>>>>>>        int ret;
>>>>>>>
>>>>>>> -    if (!device->ops->migration_set_state ||
>>>>>>> -        !device->ops->migration_get_state)
>>>>>>> +    if (!device->mig_ops->migration_set_state ||
>>>>>>> +        !device->mig_ops->migration_get_state)
>>>>>>>            return -ENOTTY;
>>>>>> ...
>>>>>>   
>>>>>>> @@ -1582,8 +1583,8 @@ static int
>>>>>>> vfio_ioctl_device_feature_migration(struct vfio_device *device,
>>>>>>>        };
>>>>>>>        int ret;
>>>>>>>
>>>>>>> -    if (!device->ops->migration_set_state ||
>>>>>>> -        !device->ops->migration_get_state)
>>>>>>> +    if (!device->mig_ops->migration_set_state ||
>>>>>>> +        !device->mig_ops->migration_get_state)
>>>>>>>            return -ENOTTY;
>>>>>>>   
>>>>>> Above checks can be done once when the device is registered then
>>>>>> here replaced with a single check on device->mig_ops.
>>>>>>   
>>>>> I agree, it may look as of below.
>>>>>
>>>>> Theoretically, this could be done even before this patch upon device
>>>>> registration.
>>>>>
>>>>> We could check that both 'ops' were set and *not* only one of and
>>>>> later check for the specific 'op' upon the feature request.
>>>>>
>>>>> Alex,
>>>>>
>>>>> Do you prefer to switch to the below as part of V2 or stay as of
>>>>> current submission and I'll just add Kevin as Reviewed-by ?
>>>>>
>>>>> diff --git a/drivers/vfio/pci/vfio_pci_core.c
>>>>> b/drivers/vfio/pci/vfio_pci_core.c
>>>>> index a0d69ddaf90d..f42102a03851 100644
>>>>> --- a/drivers/vfio/pci/vfio_pci_core.c
>>>>> +++ b/drivers/vfio/pci/vfio_pci_core.c
>>>>> @@ -1855,6 +1855,11 @@ int vfio_pci_core_register_device(struct
>>>>> vfio_pci_core_device *vdev)
>>>>>          if (pdev->hdr_type != PCI_HEADER_TYPE_NORMAL)
>>>>>                  return -EINVAL;
>>>>>
>>>>> +       if (vdev->vdev.mig_ops &&
>>>>> +          !(vdev->vdev.mig_ops->migration_get_state &&
>>>>> +            vdev->vdev.mig_ops->migration_get_state))
>>>>> +               return -EINVAL;
>>>>> +
>>>>>
>>>>> Yishai
>>>>>   
>>>> Hi Alex,
>>>>
>>>> Did you have the chance to review the above note ?
>>>>
>>>> I would like to send V2 with Kevin's Reviewed-by tag for both patches,
>>>> just wonder about the nit.
>>> The whole mig_ops handling seems rather ad-hoc to me.  What tells a
>>> developer when mig_ops can be set?  Can they be unset?  Does this
>>> enable a device feature callout to dynamically enable migration?  Why do
>>> we init the device with vfio_device_ops, but then open code per driver
>>> setting vfio_migration_ops?
>>>
>>> For the hisi_acc changes, they're specifically defining two device_ops,
>>> one for migration and one without migration.  This patch oddly makes
>>> them identical other than the name and doesn't simplify the setup path,
>>> which should now only require a single call point for init-device with
>>> the proposed API rather than the existing three.
>> I think one of the reasons we ended up using two diff ops were to restrict
>> exposing the migration BAR regions to Guest(and for that we only expose
>> half of the BAR region now). And for nested assignments this may result
>> in invalid BAR sizes if we do it for no migration cases. Hence we have
>> overrides for read/write/mmap/ioctl functions in hisi_acc_vfio_pci_migrn_ops .
> Darn, I always forget about that and skimmed too quickly, the close,
> read, write, and mmap callbacks are all different.  Sorry about that.
>
>> If we have to simplify the setup path, I guess we retain only the _migrn_ops and
>> add explicit checks for migration support in the above override functions.
> Yes, that's an option and none of those callbacks should be terribly
> performance sensitive to an inline test, it's just a matter of where we
> want to simplify the code.  Given the additional differences in
> callbacks I'm not necessarily suggesting this is something we need to
> change.


Alex,

So, do you suggest to go via this approach for mlx5 as well ?

Means, staying with a single device_ops but just inline a check whether 
migration is really supported inside the migration get/set state 
callbacks and let the core call it unconditionally.

Following this approach may introduce extra 'if's for the coming dirty 
tracking 'ops' that may face the same issue with the need to maintain an 
extra cap bit inside the driver for 'dirty tracking' support.

Assuming that an extra 'if' is not performance issue even not on the 
'read and clear' flow (is it ?) this can work.

However, the alternative that was suggested by this patch could be 
cleaner I assume at least for mlx5 and may drop all those extra 'if's, etc.

Let's converge and I'll send V2 accordingly.

Yishai

